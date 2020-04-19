using System;
using System.Collections;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Security.Principal;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using System.Web.Routing;

namespace BootstrapSupport
{
    public static class DefaultScaffoldingExtensions
    {
        public static string GetControllerName(this Type controllerType)
        {
            return controllerType.Name.Replace("Controller", String.Empty);
        }

        public static string GetActionName(this LambdaExpression actionExpression)
        {
            return ((MethodCallExpression)actionExpression.Body).Method.Name;
        }

        public static PropertyInfo[] VisibleProperties(this IEnumerable Model)
        {
            var elementType = Model.GetType().GetElementType();
            if (elementType == null)
            {
                elementType = Model.GetType().GetGenericArguments()[0];
            }
            return elementType.GetProperties().Where(info => !info.GetGetMethod().IsVirtual
                                                    && info.Name != elementType.IdentifierPropertyName()).ToArray();
        }

        public static PropertyInfo[] VisibleProperties(this Object model)
        {
            return model.GetType().GetProperties().Where(info => !info.GetGetMethod().IsVirtual
                                                            && info.Name != model.IdentifierPropertyName()).ToArray();
        }

        public static PropertyInfo[] Properties(this Object model)
        {
            return model.GetType().GetProperties();
        }

        public static bool IsVirtual(this PropertyInfo property)
        {
            return property.GetGetMethod().IsVirtual;
        }

        public static bool IsVisible(this PropertyInfo property)
        {
            var scaffold = true;
            var scaffoldAttr = property.GetAttribute<ScaffoldColumnAttribute>();

            if (scaffoldAttr != null)
                scaffold = scaffoldAttr.Scaffold;

            return scaffold;
        }

        public static bool IsPrimaryKey(this PropertyInfo property)
        {
            return property.AttributeExists<KeyAttribute>();
        }

        public static bool IsForeignKey(this PropertyInfo property)
        {
            return property.AttributeExists<ForeignKeyAttribute>();
        }

        public static RouteValueDictionary GetIdValue(this object model)
        {
            var v = new RouteValueDictionary();
            v.Add(model.IdentifierPropertyName(), model.GetId());
            return v;
        }

        public static object GetId(this object model)
        {
            return model.GetType().GetProperty(model.IdentifierPropertyName()).GetValue(model,new object[0]);
        }


        public static string IdentifierPropertyName(this Object model)
        {
            return IdentifierPropertyName(model.GetType());
        }

        public static string IdentifierPropertyName(this Type type)
        {
            var keyProperty = type.GetProperties().FirstOrDefault(info => info.AttributeExists<KeyAttribute>());

            if (keyProperty != null)
                return  keyProperty.Name;
            else if (type.GetProperties().Any(p => p.Name.Equals("id", StringComparison.CurrentCultureIgnoreCase)))
            {
                return
                    type.GetProperties().First(
                        p => p.Name.Equals("id", StringComparison.CurrentCultureIgnoreCase)).Name;
            }
            return "";
        }

        public static string GetLabel(this PropertyInfo propertyInfo)
        {
            var meta = ModelMetadataProviders.Current.GetMetadataForProperty(null, propertyInfo.DeclaringType, propertyInfo.Name);
            return meta.GetDisplayName();
        }

        public static string ToSeparatedWords(this string value)
        {
            return Regex.Replace(value, "([A-Z][a-z])", " $1").Trim();
        }

    }

    public static class PropertyInfoExtensions
    {
        public static bool AttributeExists<T>(this PropertyInfo propertyInfo) where T : class
        {
            var attribute = propertyInfo.GetCustomAttributes(typeof(T), false)
                                .FirstOrDefault() as T;
            if (attribute == null)
            {
                return false;
            }
            return true;
        }

        public static bool AttributeExists<T>(this Type type) where T : class
        {
            var attribute = type.GetCustomAttributes(typeof(T), false).FirstOrDefault() as T;
            if (attribute == null)
            {
                return false;
            }
            return true;
        }

        public static T GetAttribute<T>(this Type type) where T : class
        {
            return type.GetCustomAttributes(typeof(T), false).FirstOrDefault() as T;
        }

        public static T GetAttribute<T>(this PropertyInfo propertyInfo) where T : class
        {
            return propertyInfo.GetCustomAttributes(typeof(T), false).FirstOrDefault() as T;
        }
		
        public static string LabelFromType(Type type)
        {
            string label = null;
            var attr = GetAttribute<DisplayAttribute>(type);

            if (attr != null)
                label = attr.Name;
            else
            {
                var nameAttr = GetAttribute<DisplayNameAttribute>(type);

                if (nameAttr != null)
                    label = nameAttr.DisplayName;
            }

            if (label == null)
                label = (type.BaseType != typeof(Object) ? type.BaseType.Name : @type.Name);

            return label.ToSeparatedWords();
        }
		
        public static string GetLabel(this Object Model)
        {
            return LabelFromType(Model.GetType());
        }

        public static string GetLabel(this IEnumerable Model)
        {
            var elementType = Model.GetType().GetElementType();
            if (elementType == null)
            {
                elementType = Model.GetType().GetGenericArguments()[0];
            }
            return LabelFromType(elementType);
        }
    }

    public static class ExtentionMethods
    {
        public static bool IsAdmin(this IPrincipal user)
        {
            string name = user.Identity.Name.ToLower();
            return (name == "admin" || name == "superadmin");
        }
    }

    public static class HtmlHelperExtensions
    {
        public static MvcHtmlString MenuLink(this HtmlHelper htmlHelper, string linkText, string actionName, string controllerName, object routeValues = null, object htmlAttributes = null, string redirectAction = null)
        {
            actionName = actionName.ToLower();
            controllerName = controllerName.ToLower();

            if (!string.IsNullOrEmpty(redirectAction))
                redirectAction = redirectAction.ToLower();

            var builder = new TagBuilder("li");

            var currentAction = htmlHelper.ViewContext.RouteData.GetRequiredString("action").ToLower();
            var currentController = htmlHelper.ViewContext.RouteData.GetRequiredString("controller").ToLower();

            if (controllerName == currentController && (actionName == currentAction || redirectAction == currentAction))
                builder.AddCssClass("active");

            builder.InnerHtml = htmlHelper.ActionLink(linkText, actionName, controllerName, routeValues, htmlAttributes).ToHtmlString();

            return new MvcHtmlString(builder.ToString());
        }

        public static MvcHtmlString TryPartial(this HtmlHelper helper, string viewName, object model)
        {
            try
            {
                return helper.Partial(viewName, model);
            }
            catch (Exception)
            {
            }
            return MvcHtmlString.Empty;
        }
    }
}