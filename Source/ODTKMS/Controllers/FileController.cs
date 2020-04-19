using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;

namespace ODTKMS.Controllers
{
    public class FileController : ApiController
    {
        [HttpGet]
        public string Hello()
        {
            return "Hello";
        }

        private void GenerateThumbnail(string filePath, int thumbnailSize)
        {
            var imageExtensions = new string[] { ".jpg", ".jpeg", ".png", ".gif" };
            var ext = Path.GetExtension(filePath).ToLower();                       

            var isImage = imageExtensions.Contains(ext);

            if (isImage)
            {
                // Save thumbnail
                // First, we convert an HttpPostedFileBase to an Image
                using (var image = Image.FromFile(filePath))
                {
                    var aspectRatio = Convert.ToDouble(image.Width) / Convert.ToDouble(image.Height);

                    // Then we create a thumbnail.
                    // The simplest way is using Image.GetThumbnailImage:
                    using (var thumb = image.GetThumbnailImage(
                        thumbnailSize, // width
                        Convert.ToInt32(Convert.ToDouble(thumbnailSize) / aspectRatio), // height
                        () => false,
                        IntPtr.Zero))
                    {
                        // Finally, we encode and save the thumbnail.
                        var jpgInfo = ImageCodecInfo.GetImageEncoders()
                            .Where(codecInfo => codecInfo.MimeType == "image/jpeg").First();

                        using (var encParams = new EncoderParameters(1))
                        {
                            // Your output path
                            string thumbDir = Path.Combine(Path.GetDirectoryName(filePath), "thumbnails");
                            Directory.CreateDirectory(thumbDir);

                            string thumbPath = Path.Combine(thumbDir, Path.GetFileName(filePath));

                            // Image quality (should be in the range [0..100])
                            long quality = 100;
                            encParams.Param[0] = new EncoderParameter(Encoder.Quality, quality);
                            thumb.Save(thumbPath, jpgInfo, encParams);
                        }
                    }
                }
            }
        }

        [HttpPost]
        //[ActionName("SaveFile")]
        [ResponseType(typeof(JObject))]
        public async Task<IHttpActionResult> SaveFile(string savePath, string oldFileName = null, bool? generateThumbnail = null, int thumbnailSize = 256)
        {
            string path = HttpContext.Current.Server.MapPath("~/" + savePath);
            Directory.CreateDirectory(path);

            // Check if the request contains multipart/form-data.
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }
            
            var provider = new MultipartFormDataStreamProvider(path);

            try
            {
                // Read the form data.
                await Request.Content.ReadAsMultipartAsync(provider);

                if (!string.IsNullOrWhiteSpace(oldFileName))
                {
                    var oldFilePath = Path.Combine(path, oldFileName);

                    if (File.Exists(oldFilePath))
                        File.Delete(oldFilePath);
                }

                // This illustrates how to get the file names.
                foreach (MultipartFileData file in provider.FileData)
                {
                    //Console.WriteLine(file.Headers.ContentDisposition.FileName);
                    //Trace.WriteLine("Server file path: " + file.LocalFileName);

                    var fileName = Path.GetFileName(file.Headers.ContentDisposition.FileName.Replace("\"", string.Empty));
                    var fileNameWithoutExt = Path.GetFileNameWithoutExtension(fileName);                                       
                    var fileExt = Path.GetExtension(fileName);
                    var filePath = Path.Combine(path, fileName);

                    var i = 1;

                    while (File.Exists(filePath))
                    {
                        fileName = string.Format("{0} ({1}){2}", fileNameWithoutExt, i, fileExt);
                        filePath = Path.Combine(path, fileName);
                        i++;
                    }

                    File.Move(file.LocalFileName, filePath);

                    if(generateThumbnail == true)
                        GenerateThumbnail(filePath, thumbnailSize);

                    return Json(fileName);
                }
            }
            catch (System.Exception ex)
            {
                return InternalServerError(ex);
            }

            return Ok();
        }
    }
}
