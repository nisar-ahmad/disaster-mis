using System.Web;
using System.Web.Optimization;

namespace ODTKMS
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/bootstrap-datepicker.js",
                      "~/Scripts/bootstrap-timepicker.js",
                      "~/Scripts/viewportchecker.js",
                      "~/Scripts/animate.js",
                      "~/Scripts/ie10-viewport-bug-workaround.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new ScriptBundle("~/bundles/gallery").Include(
                      "~/Scripts/bootstrap-image-gallery.js",
                      "~/Scripts/jquery.blueimp-gallery.min.js"
                      ));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/css/bootstrap.css",
                      "~/Content/css/site.css",
                      "~/Content/css/datepicker3.css",
                      "~/Content/css/bootstrap-timepicker.css",
                      "~/Content/css/blueimp-gallery.css",
                      "~/Content/css/bootstrap-image-gallery.css",
                      "~/Content/animate.css",
                      "~/Content/font.css",
                      "~/Content/font-awesome/css/font-awesome.css",
                      "~/Content/custom.css"));            
        }
    }
}
