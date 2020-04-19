using ODTKMS.Models;
using System.Web.Http;
using Newtonsoft.Json.Linq;
using System.Net.Mail;
using System.Web.Http.Description;
using System.Net.Http;
using System.Threading.Tasks;
using System.Linq;
using System.Text;
using System.Web.Configuration;
using System.Net.Configuration;
using System.Web;
using System.Collections.Generic;
using System;

namespace ODTKMS.Controllers
{
    public class AlertData
    {
        public string Type { get; set; }
        public int Id { get; set; }

        public string Group { get; set; }
        public string To { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
    }

    public class AlertController : ApiController
    {
        ProjectDbContext db = new ProjectDbContext();

        //const string smsApi = "http://api.clickatell.com/http/sendmsg?user=nrtdcorp&password=ZegcHSagZOVLUe&api_id=3563404&to={0}&text={1}";

        [HttpPost]
        [ResponseType(typeof(JObject))]
        public async Task<IHttpActionResult> Website([FromBody] AlertData data)
        {
            var from = "NIDM Admin <admin@nidm.gov.pk>";
            var smtpSection = WebConfigurationManager.GetSection("system.net/mailSettings/smtp") as SmtpSection;

            if (smtpSection != null && !string.IsNullOrWhiteSpace(smtpSection.From))
                from = smtpSection.From;

            var to = "info@nidm.gov.pk";

            if (data.Type == "feedback")
            {
                var feedbackEmail = WebConfigurationManager.AppSettings["FeedbackEmail"];

                if (!string.IsNullOrWhiteSpace(feedbackEmail))
                    to = feedbackEmail;
            }
            else if (data.Type == "newsletter")
            {
                var newsletterEmail = WebConfigurationManager.AppSettings["NewsletterEmail"];

                if (!string.IsNullOrWhiteSpace(newsletterEmail))
                    to = newsletterEmail;
            }

            var smtpClient = new SmtpClient();

            var msg = new MailMessage(from, to, data.Subject, data.Body);
            msg.IsBodyHtml = true;

            await smtpClient.SendMailAsync(msg);

            return Ok();
        }

        [HttpPost]
        [ResponseType(typeof(JObject))]
        public async Task<IHttpActionResult> Email([FromBody] AlertData data)
        {
            var to = data.To;
            var hostUrl = HttpContext.Current.Request.Url.AbsoluteUri.Replace("/api/Alert/Email", "");

            var smtpClient = new SmtpClient();
            var from = "NIDM Admin <admin@nidm.gov.pk>";

            var smtpSection = WebConfigurationManager.GetSection("system.net/mailSettings/smtp") as SmtpSection;

            if (smtpSection != null && !string.IsNullOrWhiteSpace(smtpSection.From))
                from = smtpSection.From;

            if (data.Id > 0)
            {
                var trainingUrl = string.Format("{0}/public.html#/training/{1}/details/public", hostUrl, data.Id);
                data.Body = data.Body.Replace("[training-link]", trainingUrl);
            }

            if (data.Type == "Participant")
            {
                var participants = db.Participants.Where(o => o.TrainingId == data.Id && !string.IsNullOrEmpty(o.Email));

                switch (data.Group)
                {
                    case "Accepted":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Accepted);
                        break;
                    case "Rejected":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Rejected);
                        break;
                    case "Waiting":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Pending);
                        break;
                    case "Attended":
                    case "Evaluation":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Accepted && o.TrainingSessionParticipants.Count > 0);
                        break;
                    case "Absent":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Accepted && o.TrainingSessionParticipants.Count == 0);
                        break;
                    default:
                        participants = null;
                        break;
                }

                if (participants != null)
                {

                    var list = participants.Select(p => new { ParticipantId = p.ParticipantId, Email = p.Email }).ToArray();

                    if (list.Length == 0)
                        throw new Exception("Participants not found. Please make sure you have marked attendance.");

                    if (data.Group == "Evaluation")
                    {
                        for (var i = 0; i < list.Length; i++)
                        {
                            var evalUrl = string.Format("{0}/public.html#/training/evaluation/{1}/{2}", hostUrl, data.Id, list[i].ParticipantId);
                            var body = data.Body.Replace("[evaluation-link]", evalUrl);

                            var message = new MailMessage(from, list[i].Email, data.Subject, body);
                            message.IsBodyHtml = true;

                            await smtpClient.SendMailAsync(message);
                        }

                        return Ok();
                    }

                    to = string.Join(",", list.Select(o => o.Email));
                }
            }

            var msg = new MailMessage(from, to, data.Subject, data.Body);
            msg.IsBodyHtml = true;

            foreach (var address in msg.To)
                msg.Bcc.Add(address);

            msg.To.Clear();

            await smtpClient.SendMailAsync(msg);

            return Ok();
        }

        [HttpPost]
        [ResponseType(typeof(JObject))]
        public async Task<IHttpActionResult> SMS([FromBody] AlertData data)
        {
            var to = data.To;

            if (data.Type == "Participant")
            {
                var participants = db.Participants.Where(o => o.TrainingId == data.Id && !string.IsNullOrEmpty(o.Cell));

                switch (data.Group)
                {
                    case "Accepted":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Accepted);
                        break;
                    case "Rejected":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Rejected);
                        break;
                    case "Waiting":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Pending);
                        break;
                    case "Attended":
                    case "Evaluation":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Accepted && o.TrainingSessionParticipants.Count > 0);
                        break;
                    case "Absent":
                        participants = participants.Where(o => o.ApprovalStatus == ApprovalType.Accepted && o.TrainingSessionParticipants.Count == 0);
                        break;
                    default:
                        participants = null;
                        break;
                }

                if (participants != null)
                {
                    var sb = new StringBuilder();

                    foreach (var p in participants)
                        sb.AppendFormat("{0},", p.Cell);

                    to = sb.ToString();
                    to = to.Remove(to.Length - 1, 1);
                }
            }

            var smsApi = WebConfigurationManager.AppSettings["SMS"];

            using (HttpClient client = new HttpClient())
            {
                var url = string.Format(smsApi, to, data.Body);
                await client.GetAsync(url);
            }

            return Ok();
        }
    }
}