using System;
using System.Data.Entity;
using System.Linq;
using System.Web.Mvc;
using System.Threading.Tasks;
using System.Collections.Generic;

using ODTKMS.Models;

namespace ODTKMS.Controllers
{
    [AllowAnonymous]
    public class WebsiteController : BaseController
    {
        // GET: api/Event
        public async Task<ActionResult> GetContent(ContentType contentType = ContentType.Event, int take = 3)
        {
            var contents = await db.Contents.Where(o=> o.ContentType == contentType).OrderByDescending(o => o.Date).Take(take).ToListAsync();

            if (contents == null)
                return HttpNotFound();

            return Json(contents);
        }

        public ActionResult Index(string id)
        {
            var vm = new HomePageViewModel();

            vm.SliderImages = db.Contents.Where(o => o.ContentType == ContentType.MainSlider).Select(o => o.File).ToList();
            vm.News = db.Contents.Where(o => o.ContentType == ContentType.News).OrderByDescending(o => o.Date).Take(10).ToList();
            vm.Events = db.Contents.Where(o => o.ContentType == ContentType.Event).OrderByDescending(o => o.Date).Take(10).ToList();
            vm.StakeholderActivities = db.Contents.Where(o => o.ContentType == ContentType.StakeholderActivity).Take(10).ToList();
            vm.ProminentStakeholder = db.Contents.Where(o => o.ContentType == ContentType.ProminentStakeholder).FirstOrDefault();
            vm.PictureGallery = db.Contents.Where(o => o.ContentType == ContentType.PictureSlider).ToList();
            vm.GuestBook = db.Contents.Where(o => o.ContentType == ContentType.GuestBook).ToList();
            vm.PartnerLogos = db.Contents.Where(o => o.ContentType == ContentType.Partner).Select(o => o.File).ToList();

            var trainings = db.Trainings.Include(o => o.City).Where(o=> o.StartDate >= DateTime.Now).OrderBy(o => o.StartDate).ToList();
            vm.Trainings = GetTrainings(trainings);

            PopulateNIDMStats(vm);
            PopulateStakeholderStats(vm);

            return View(vm);
        }

        private void PopulateNIDMStats(HomePageViewModel vm)
        {
            vm.NIDMStats = new StatsViewModel();
            vm.NIDMStats.Trainings = db.Trainings.Count(o => o.Status == TrainingStatus.Completed);

            var participantsByGender = db.Participants.GroupBy(p => p.Gender)
                                        .Select(o =>
                                            new
                                            {
                                                Gender = o.Key,
                                                Participants = o.Count(p => p.TrainingSessionParticipants.Count > 0)
                                            }).ToList();

            vm.NIDMStats.Male = participantsByGender.Find(p => p.Gender == GenderType.Male).Participants;
            vm.NIDMStats.Female = participantsByGender.Find(p => p.Gender == GenderType.Female).Participants;

            var participantsBySector = db.Participants.GroupBy(p => p.OrganizationTypeId)
                                        .Select(o =>
                                            new
                                            {
                                                OrganizationTypeId = o.Key,
                                                Participants = o.Count(p => p.TrainingSessionParticipants.Count > 0)
                                            }).ToList();

            foreach(var p in participantsBySector)
            {
                switch(p.OrganizationTypeId)
                {
                    case 1: // Govt
                        vm.NIDMStats.Govt += p.Participants;
                        break;
                    case 2: // UN
                    case 6: // INGOS
                        vm.NIDMStats.UN += p.Participants;
                        break;
                    case 3: // Academia
                        vm.NIDMStats.Academia += p.Participants;
                        break;
                    case 5: // Media
                        vm.NIDMStats.Media += p.Participants;
                        break;
                    case 7: // NGO
                        vm.NIDMStats.NGO += p.Participants;
                        break;
                    case 12:// Industry
                        vm.NIDMStats.Industry += p.Participants;
                        break;
                    case 13: // Public Reps
                        vm.NIDMStats.PublicReps += p.Participants;
                        break;
                    default: // Others
                        break;
                }
            }
        }

        private void PopulateStakeholderStats(HomePageViewModel vm)
        {
            vm.StakeholderStats = db.TrainingActivities.Where(o => o.ApprovalStatus == ApprovalType.Accepted)
                                       .GroupBy(o => 1)
                                       .Select(s => new StatsViewModel
                                       {
                                           //Participants = s.Sum(o => o.NoOfParticipants),
                                           Male = s.Sum(o => o.GenderRepresentationMale),
                                           Female = s.Sum(o => o.GenderRepresentationFemale),
                                           Govt = s.Select(o => o.Government).DefaultIfEmpty(0).Sum().Value
                                                + s.Select(o => o.ArmedForces).DefaultIfEmpty(0).Sum().Value
                                                + s.Select(o => o.Police).DefaultIfEmpty(0).Sum().Value,
                                           UN = s.Select(o => o.UNAgencies).DefaultIfEmpty(0).Sum().Value 
                                              + s.Select(o => o.INGOs).DefaultIfEmpty(0).Sum().Value,
                                           NGO = s.Select(o => o.NGOs).DefaultIfEmpty(0).Sum().Value,
                                           Academia = s.Select(o => o.Students).DefaultIfEmpty(0).Sum().Value
                                                    + s.Select(o => o.Teachers).DefaultIfEmpty(0).Sum().Value
                                                    + s.Select(o => o.EducationalManagement).DefaultIfEmpty(0).Sum().Value,
                                           Media = s.Select(o => o.Media).DefaultIfEmpty(0).Sum().Value,
                                           Industry = s.Select(o => o.PrivateCommercialOrg).DefaultIfEmpty(0).Sum().Value,
                                           PublicReps = s.Select(o => o.Community).DefaultIfEmpty(0).Sum().Value
                                       }).FirstOrDefault();

            if (vm.StakeholderStats == null)
            {
                vm.StakeholderStats = new StatsViewModel();
                return;
            }

            vm.StakeholderStats.Trainings = db.TrainingActivities.Count(o => o.ApprovalStatus == ApprovalType.Accepted);
        }

        public ActionResult Page(string id)
        {
            if (string.IsNullOrWhiteSpace(id))
                id = "Index";

            return View(id);
        }

        private List<Content> GetTrainings(IEnumerable<Training> trainings)
        {
            var contents =  new List<Content>();

            foreach (var t in trainings)
            {
                var dates = string.Format("{0:dd MMM}", t.StartDate);

                if (t.EndDate.Month != t.StartDate.Month || t.EndDate.Day != t.StartDate.Day)
                    dates += string.Format(" - {0:dd MMM}", t.EndDate);

                contents.Add(new Content
                {
                    ContentId = t.TrainingId,
                    Title = t.Name,
                    Location = t.City.Name,
                    Description = dates
                });
            }

            return contents;
        }

        public ActionResult Guestbook()
        {
            var contents = db.Contents.Where(o => o.ContentType == ContentType.GuestBook).OrderByDescending(o => o.Date);
            return View(contents);
        }

        public ActionResult Surveys()
        {
            var surveys = db.Surveys.Where(o => o.SurveyId != 1 && o.Active == true);
            return View(surveys);
        }

        public ActionResult News()
        {
            var news = db.Contents.Where(o => o.ContentType == ContentType.News).OrderByDescending(o => o.Date);
            return View(news);
        }

        public ActionResult Events()
        {
            var events = db.Contents.Where(o => o.ContentType == ContentType.Event).OrderByDescending(o => o.Date);
            return View(events);
        }

        public ActionResult Calendar(int year = 0)
        {
            var vm = new CalendarViewModel();

            var upcoming = db.Trainings.Include(o => o.City).Where(o => o.StartDate >= DateTime.Now).OrderBy(o => o.StartDate).ToList();
            vm.Upcoming = GetTrainings(upcoming);

            if (year == 0)
                year = DateTime.Now.Year;

            var archived = db.Trainings.Include(o => o.City).Where(o => o.StartDate < DateTime.Now && o.StartDate.Year == year).OrderBy(o => o.StartDate).ToList();
            vm.Archived = GetTrainings(archived);

            return View(vm);
        }

        public ActionResult ResourceCenter(string id, bool recent = false)
        {
            var documents = db.Documents.Include(d => d.DocumentCategory1).Include(d => d.DocumentCategory2).Include(d => d.DocumentCategory3)
                                        .Include(d => d.ThematicArea).Include(d => d.Training);

            if (!string.IsNullOrWhiteSpace(id))
            {
                var strArray = id.Split(",".ToCharArray());

                var idList = new List<int?>();

                foreach (var s in strArray)
                    idList.Add(Convert.ToInt32(s));

                documents = documents.Where(o => idList.Contains(o.DocumentCategoryId1) || idList.Contains(o.DocumentCategoryId2) || idList.Contains(o.DocumentCategoryId3)).OrderByDescending(o => o.YearOfPublication);
            }

            if (recent)
                documents = documents.OrderByDescending(o => o.YearOfPublication).Take(5);

            return View(documents.ToList());
        }

        public ActionResult Gallery(string id)
        {
            return View(id);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

    }
}