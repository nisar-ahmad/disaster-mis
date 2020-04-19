using ODTKMS.Models;
using System.IO;
using System.Web;
using System.Web.Mvc;

namespace ODTKMS.Controllers
{
    public class BaseController : Controller
    {
        protected ProjectDbContext db = new ProjectDbContext();

        public const string AlbumsPath = "~/Files/Albums/";
        public const string DocumentsPath = "~/Files/Documents/Library/";
        public const string ResumesPath = "~/Files/ResourcePersons/Resumes/";
        public const string PhotosPath = "~/Files/ResourcePersons/Photos/";
        public const string Activity4WPath = "~/Files/4W/";
        public const string OrganizationsPath = "~/Files/Organizations/";

        /// <summary>
        /// Saves the file to the path. If a file with same name exists
        /// then it is renamed by appending a number.
        /// </summary>
        /// <param name="file"></param>
        /// <param name="relativePath"></param>
        /// <returns>null if not saved</returns>
        public string SaveFile(HttpPostedFileBase file, string relativePath, string oldFileName = null)
        {
            string savePath = null;

            if (file != null && file.ContentLength > 0)
            {
                string physicalPath = Server.MapPath(relativePath);

                // Delete old file to replace it
                if (!string.IsNullOrWhiteSpace(oldFileName))
                {
                    var oldFilePath = Path.Combine(physicalPath, oldFileName);
                    System.IO.File.Delete(oldFilePath);
                }

                string fileName = Path.GetFileName(file.FileName);
                string fileNameWithoutExt = Path.GetFileNameWithoutExtension(fileName);

                string fileExt = Path.GetExtension(fileName);
                string filePath = Path.Combine(physicalPath, fileName);

                savePath = filePath;
                var i = 1;

                // Rename if already exists
                while (System.IO.File.Exists(savePath))
                {
                    var newFileName = string.Format("{0} ({1}){2}", fileNameWithoutExt, i, fileExt);
                    savePath = Path.Combine(physicalPath, newFileName);

                    i++;
                }

                file.SaveAs(savePath);
            }

            if (savePath != null)
                return Path.GetFileName(savePath);

            return null;
        }
    }
}