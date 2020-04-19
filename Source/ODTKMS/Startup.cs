using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ODTKMS.Startup))]
namespace ODTKMS
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
