using ODTKMS.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace ODTKMS.Controllers
{
    using Newtonsoft.Json.Linq;
    using System.Data.Common;
    using System.Web.Http.Description;

    public class SurveyViewModel
    {
        public Dictionary<string, int> Provinces { get; set; }
        public Dictionary<string, int> Genders { get; set; }
        public Dictionary<string, int> Sectors { get; set; }

        public object Questions { get; set; }

        public SurveyViewModel()
        {
            Provinces = new Dictionary<string, int>();
            Genders = new Dictionary<string, int>();
            Sectors = new Dictionary<string, int>();
        }
    }

    public class ReportController : ApiController
    {
        ProjectDbContext _context = new ProjectDbContext();

        [AllowAnonymous]
        [HttpPost]
        [ResponseType(typeof(JObject))]
        public object Login4W([FromBody] LoginViewModel data)
        {
            var org = _context.Organizations.FirstOrDefault(o => string.Compare(o.Username, data.Email, true) == 0 && o.PasswordHash == data.Password);

            if (org == null)
                return NotFound();

            return org.OrganizationId;
        }

        //[AllowAnonymous]
        [HttpGet]
        [ResponseType(typeof(JObject))]
        public object Respondents(int id)
        {
            var respondents = _context.Respondents.Where(o => o.SurveyQuestionResponses.Any(r => r.SurveyId == id))
                                .Select(s => new { respondentId = s.RespondentId, name = s.Name }).ToList();

            return respondents;
        }

        [HttpGet]
        [ResponseType(typeof(JObject))]
        public object Survey(int id, GenderType? genderType = null, int? provinceId = null, int? organizationTypeId = null)
        {
            var vm = new SurveyViewModel();
            var where = string.Format(" WHERE Q.Type BETWEEN 0 AND 3 AND S.SurveyId = {0}", id);
            var query = _context.Respondents.AsQueryable();

            if (genderType != null)
            {
                query = query.Where(o => o.Gender == genderType.Value);
                where += string.Format(" AND R.Gender = {0}", Convert.ToInt32(genderType.Value));
            }

            if (provinceId != null)
            { 
                query = query.Where(o => o.District.ProvinceId == provinceId.Value);
                where += string.Format(" AND D.ProvinceId = {0}", Convert.ToInt32(provinceId.Value));
            }

            if (organizationTypeId != null)
            {
                query = query.Where(o => o.OrganizationTypeId == organizationTypeId.Value);
                where += string.Format(" AND R.OrganizationTypeId = {0}", Convert.ToInt32(organizationTypeId.Value));
            }

            vm.Provinces = query.GroupBy(p => p.District.Province.Name)
                            .Select(o =>
                                new
                                {
                                    Key = o.Key,
                                    Value = o.Count(p => p.SurveyQuestionResponses.Any(r => r.SurveyId == id && r.RespondentId == p.RespondentId))
                                }).ToDictionary(o => o.Key, o => o.Value);

            vm.Genders = query.GroupBy(p => p.Gender)
                .Select(o =>
                    new
                    {
                        Key = o.Key.ToString(),
                        Value = o.Count(p => p.SurveyQuestionResponses.Any(r => r.SurveyId == id && r.RespondentId == p.RespondentId))
                    }).ToDictionary(o => o.Key, o => o.Value);


            vm.Sectors = query.GroupBy(p => p.OrganizationType.Name)
                        .Select(o =>
                            new
                            {
                                Key = o.Key,
                                Value = o.Count(p => p.SurveyQuestionResponses.Any(r => r.SurveyId == id && r.RespondentId == p.RespondentId))
                            }).ToDictionary(o => o.Key, o => o.Value);

            var sqlQuery = " SELECT Q.Statement AS 'Question', " +
                        " CASE WHEN Q.Type = 0 THEN 'YesNo' " +
                        " WHEN Q.Type = 1 THEN 'AgreementScale' " +
                        " WHEN Q.Type = 2 THEN 'SatisfactionScale' " +
                        " WHEN Q.Type = 3 THEN 'InterestScale' " +
                        " ELSE '' END AS Type, " +
                        " SUM(CASE WHEN SQR.Response = 0 THEN 1 ELSE 0 END) AS 'Choice1', " +
                        " SUM(CASE WHEN SQR.Response = 1 THEN 1 ELSE 0 END) AS 'Choice2', " +
                        " SUM(CASE WHEN SQR.Response = 2 THEN 1 ELSE 0 END) AS 'Choice3', " +
                        " SUM(CASE WHEN SQR.Response = 3 THEN 1 ELSE 0 END) AS 'Choice4', " +
                        " SUM(CASE WHEN SQR.Response = 4 THEN 1 ELSE 0 END) AS 'Choice5' " +
                        " FROM dbo.Survey S " +
                        " INNER JOIN SurveyQuestion SQ ON SQ.SurveyId = S.SurveyId " +
                        " INNER JOIN Question Q ON Q.QuestionId = SQ.QuestionId " +
                        " INNER JOIN SurveyQuestionResponse SQR ON SQR.SurveyId = S.SurveyId AND SQR.QuestionId = SQ.QuestionId " +
                        " INNER JOIN Respondent R ON R.RespondentId = SQR.RespondentId " +
                        " INNER JOIN District D ON D.DistrictId = R.DistrictId " +
                        " " +
                        where +
                        " GROUP BY Q.Statement, Type ";

            vm.Questions = ConvertSqlToList(sqlQuery);

            return vm;
        }

        [HttpGet]
        public int ParticipantsAttended(int id)
        {
            return _context.Participants.Count(o => o.TrainingId == id &&
                   _context.TrainingSessionParticipants.Select(t => t.ParticipantId).Contains(o.ParticipantId));
        }

        [HttpGet]
        public int ParticipantsRegistered(int id)
        {
            return _context.Participants.Count(o => o.TrainingId == id && o.ApprovalStatus == ApprovalType.Accepted);
        }

        [HttpGet]
        public object Report(int? id, string where = null)
        {
            if (!string.IsNullOrWhiteSpace(where))
                where = string.Format(" WHERE {0} ", where);

            string sqlQuery = "";

            switch (id)
            {
                case 3:
                    sqlQuery = " SELECT T.Name 'Training', " +
                                " IsNull((SELECT SUM(AmountPaid) FROM Participant P " +
                                " WHERE ParticipantId IN (SELECT TSP.ParticipantId FROM TrainingSession TS INNER JOIN TrainingSessionParticipant TSP ON TSP.TrainingSessionId = TS.TrainingSessionId WHERE TS.TrainingId = T.TrainingId) " +
                                " ), 0) AS Revenue, " +
                                " IsNull((SELECT SUM(TC.Cost) FROM TrainingCost TC WHERE TC.TrainingId = T.TrainingId), 0) AS 'Cost' " +
                                " FROM  Training T ";

                    break;
                case 4:
                    sqlQuery = " SELECT Training.Name AS Training, Province.Name As Province, COUNT(*) AS Participants," +
                                " SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male'," +
                                " SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female'," +
                                //" --SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'No Special Ability'," +
                                " SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Special Ability'" +
                                " FROM Participant" +
                                " INNER JOIN Training ON Training.TrainingId = Participant.TrainingId" +
                                " INNER JOIN District ON District.DistrictId = Participant.DistrictId" +
                                " INNER JOIN Province ON Province.ProvinceId = District.ProvinceId" +
                                " GROUP BY Training.Name, Province.Name" +
                                " ORDER BY Training.Name, Province.Name";
                    break;
                case 5:
                    sqlQuery = " SELECT Training.Name AS Training, Province.Name As Province, COUNT(*) AS Participants," +
                                " SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male'," +
                                " SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female'," +
                                //" SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'No Special Ability'," +
                                " SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Special Ability'" +
                                " FROM Participant" +
                                " INNER JOIN Training ON Training.TrainingId = Participant.TrainingId" +
                                " INNER JOIN District ON District.DistrictId = Participant.DistrictId" +
                                " INNER JOIN Province ON Province.ProvinceId = District.ProvinceId" +
                                " GROUP BY Training.Name, Province.Name" +
                                " ORDER BY Training.Name, Province.Name";
                    break;
                case 7:
                    sqlQuery = " SELECT Training.Name AS Training, OrganizationType.Name AS Sector, COUNT(*) AS Participants, " +
                                " SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male'," +
                                " SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female'," +
                                //" --SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'No Special Ability'," +
                                " SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Special Ability'" +
                                " FROM Participant" +
                                " INNER JOIN Training ON Training.TrainingId = Participant.TrainingId" +
                                " INNER JOIN District ON District.DistrictId = Participant.DistrictId" +
                                " INNER JOIN Province ON Province.ProvinceId = District.ProvinceId" +
                                " INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId" +
                                " INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId" +
                                " GROUP BY Training.Name, OrganizationType.Name" +
                                " ORDER BY Training.Name, OrganizationType.Name";
                    break;
                case 9:
                    sqlQuery = " SELECT Training.Name AS Training, Province.Name AS Province, OrganizationType.Name AS Sector, COUNT(*) AS Participants " +
                                " FROM Participant" +
                                " INNER JOIN Training ON Training.TrainingId = Participant.TrainingId" +
                                " INNER JOIN District ON District.DistrictId = Participant.DistrictId" +
                                " INNER JOIN Province ON Province.ProvinceId = District.ProvinceId" +
                                " INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId" +
                                " INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId" +
                                " GROUP BY Training.Name, Province.Name, OrganizationType.Name" +
                                " ORDER BY Training.Name, Province.Name";
                    break;
                case 10:
                    sqlQuery = " SELECT Training.Name AS Training, OrganizationType.Name AS Sector, Organization.Name AS Department, COUNT(*) AS Participants," +
                                " SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male'," +
                                " SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female'," +
                                //" --SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'No Special Ability'," +
                                " SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Special Ability'" +
                                " FROM Participant" +
                                " INNER JOIN Training ON Training.TrainingId = Participant.TrainingId" +
                                " INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId" +
                                " INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId" +
                                " GROUP BY Training.Name, OrganizationType.Name, Organization.Name" +
                                " ORDER BY Training.Name, OrganizationType.Name, Organization.Name";
                    break;
                case 11:
                    sqlQuery = " SELECT Training.Name AS Training, Province.Name AS Province, OrganizationType.Name AS Sector, COUNT(*) AS Participants, " +
                                " SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male'," +
                                " SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female'," +
                                //" --SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'No Special Ability'," +
                                " SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Special Ability'" +
                                " FROM Participant" +
                                " INNER JOIN Training ON Training.TrainingId = Participant.TrainingId" +
                                " INNER JOIN District ON District.DistrictId = Participant.DistrictId" +
                                " INNER JOIN Province ON Province.ProvinceId = District.ProvinceId" +
                                " INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId" +
                                " INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId" +
                                " GROUP BY Training.Name, Province.Name, OrganizationType.Name" +
                                " ORDER BY Training.Name, Province.Name, OrganizationType.Name";
                    break;
                case 13:
                    // 13.	Training Cost with date range 
                    sqlQuery = " SELECT T.Name 'Training', FORMAT(T.StartDate, 'dd MMM yyyy') AS StartDate, FORMAT(T.EndDate, 'dd MMM yyyy') AS EndDate, " +
                               " IsNull((SELECT SUM(TC.Cost) FROM TrainingCost TC WHERE TC.TrainingId = T.TrainingId), 0) AS 'Cost' " +
                               " FROM  Training T ";
                    //"WHERE T.StartDate BETWEEN @StartDate AND @EndDate";

                    break;
                case 14:
                    // Training Revenue Report – Payments made by participants with date range

                    sqlQuery = " SELECT T.Name 'Training', " +
                               " IsNull((SELECT SUM(AmountPaid) FROM Participant P " +
                               " WHERE P.IsFeePaid = 1 AND P.ParticipantId IN (" +
                               " SELECT TSP.ParticipantId FROM TrainingSession TS " +
                               " INNER JOIN TrainingSessionParticipant TSP ON TSP.TrainingSessionId = TS.TrainingSessionId WHERE TS.TrainingId = T.TrainingId) " +
                               " ), 0) AS Revenue, " +
                               " IsNull((SELECT SUM(TC.Cost) FROM TrainingCost TC WHERE TC.TrainingId = T.TrainingId), 0) AS 'Cost' " +
                               " FROM  Training T ";
                    //"WHERE T.StartDate BETWEEN @StartDate AND @EndDate";
                    break;
                case 15:
                    // Attendance Report with date range
                    sqlQuery = " SELECT T.Name AS Training, FORMAT(T.StartDate, 'dd MMM yyyy') AS StartDate, FORMAT(T.EndDate, 'dd MMM yyyy') AS EndDate, " +
                                "( " +
                                "	SELECT Count(*) FROM TrainingSession TS  " +
                                "	INNER JOIN TrainingSessionParticipant TSP ON TSP.TrainingSessionId = TS.TrainingSessionId  " +
                                "	WHERE TS.TrainingId = T.TrainingId " +
                                ") AS Participants " +
                                " FROM Training T ";
                    //"WHERE T.StartDate BETWEEN @StartDate AND @EndDate";
                    break;

                case 16:
                    // Evaluation Report with date range
                    break;
                case 17:
                    // Training status report  (Completed/in progress/Rescheduled/Postponed/ cancelled)
                    sqlQuery = " SELECT T.Name AS Training, FORMAT(T.StartDate, 'dd MMM yyyy') AS StartDate, FORMAT(T.EndDate, 'dd MMM yyyy') AS EndDate,  " +
                                " CASE WHEN T.Status = 0 Then 'Draft'  " +
                                " When T.Status = 1 Then 'Planned' " +
                                " When T.Status = 2 Then 'Scheduled' " +
                                " When T.Status = 3 Then 'InProgress' " +
                                " When T.Status = 4 Then 'Completed' " +
                                " When T.Status = 5 Then 'Rescheduled' " +
                                " When T.Status = 6 Then 'Postponed' " +
                                " When T.Status = 7 Then 'Cancelled'  " +
                                " END AS 'Status' " +
                                " FROM Training T " +
                                " ORDER BY T.Name";
                    break;
                case 18:
                    // List of Trainings conducted with Collaborating Agencies
                    // (Join Training with TrainingOrganization)
                    sqlQuery = " SELECT	 " +
                                " T.Name Training, T.Description,  " +
                                " CASE WHEN T.Status = 0 Then 'Draft'  " +
                                " When T.Status = 1 Then 'Planned' " +
                                " When T.Status = 2 Then 'Scheduled' " +
                                " When T.Status = 3 Then 'InProgress' " +
                                " When T.Status = 4 Then 'Completed' " +
                                " When T.Status = 5 Then 'Rescheduled' " +
                                " When T.Status = 6 Then 'Postponed' " +
                                " When T.Status = 7 Then 'Cancelled'  " +
                                " END AS 'Status', " +

                                " CASE  " +
                                " WHEN TrainingType = 0 THEN 'Practitioner' " +
                                " WHEN TrainingType = 1 THEN 'Training of Trainers' " +
                                " WHEN TrainingType > 1 THEN 'Other' " +
                                " END AS 'TrainingType' , " +

                                " CASE  " +
                                " WHEN TrainingLevel = 0 THEN 'International' " +
                                " WHEN TrainingLevel = 1 THEN 'National' " +
                                " WHEN TrainingLevel = 2 THEN 'Province' " +
                                " WHEN TrainingLevel = 3 THEN 'Division' " +
                                " WHEN TrainingLevel = 4 THEN 'District' " +
                                " WHEN TrainingLevel > 4 THEN 'Other' " +
                                " END AS 'TrainingLevel',  " +

                                " B.Name AS BroaderTrainingArea, O.Name AS 'Organization', OT.Name 'Sector' " +
                                " FROM	Organization AS O  " +
                                " INNER JOIN TrainingOrganization AS TOG ON O.OrganizationId = TOG.OrganizationId  " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = O.OrganizationTypeId " +
                                " RIGHT OUTER JOIN Training AS T ON TOG.TrainingId = T.TrainingId " +
                                " INNER JOIN BroaderTrainingArea B ON B.BroaderTrainingAreaId = T.BroaderTrainingAreaId ";
                    break;
                case 19:
                    sqlQuery = " SELECT YEAR(StartDate) 'Year', Count(P.ParticipantId) Participants, Count(T.TrainingId) Trainings, " +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 1 THEN 1 ELSE 0 END) AS 'Assessment'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 2 THEN 1 ELSE 0 END) AS 'CBDRM'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 3 THEN 1 ELSE 0 END) AS 'CCCM'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 4 THEN 1 ELSE 0 END) AS 'Climate Change'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 5 THEN 1 ELSE 0 END) AS 'Disaster Reporting/Media Management'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 6 THEN 1 ELSE 0 END) AS 'DRM/DRR'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 7 THEN 1 ELSE 0 END) AS 'Gender/Age & Disability'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 8 THEN 1 ELSE 0 END) AS 'Hazard Mitigation'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 9 THEN 1 ELSE 0 END) AS 'Health'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 10 THEN 1 ELSE 0 END) AS 'Information Management'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 11 THEN 1 ELSE 0 END) AS 'Planning'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 12 THEN 1 ELSE 0 END) AS 'Reconstruction/Rehab'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 13 THEN 1 ELSE 0 END) AS 'Recovery'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 14 THEN 1 ELSE 0 END) AS 'Response'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 15 THEN 1 ELSE 0 END) AS 'School Safety'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId = 16 THEN 1 ELSE 0 END) AS 'Supply Chain & Warehouse Management'," +
                                " SUM(CASE WHEN T.BroaderTrainingAreaId > 16 THEN 1 ELSE 0 END) AS 'Other'" +

                                " FROM Training T" +
                                " LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId" +
                                " GROUP BY YEAR(StartDate)" +
                                " ORDER BY YEAR(StartDate)";
                    break;
                case 192:
                    sqlQuery = " SELECT YEAR(StartDate) 'Year', Count(P.ParticipantId) Participants, Count(T.TrainingId) Trainings," +
                                " SUM(CASE WHEN TrainingLevel = 0 THEN 1 ELSE 0 END) AS 'International', " +
                                " SUM(CASE WHEN TrainingLevel = 1 THEN 1 ELSE 0 END) AS 'National', " +
                                " SUM(CASE WHEN TrainingLevel = 2 THEN 1 ELSE 0 END) AS 'Province', " +
                                " SUM(CASE WHEN TrainingLevel = 3 THEN 1 ELSE 0 END) AS 'Division', " +
                                " SUM(CASE WHEN TrainingLevel = 4 THEN 1 ELSE 0 END) AS 'District', " +
                                " SUM(CASE WHEN TrainingLevel > 4 THEN 1 ELSE 0 END) AS 'Other' " +
                                " FROM Training T" +
                                " LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId" +
                                " GROUP BY YEAR(StartDate)" +
                                " ORDER BY YEAR(StartDate)";
                    break;
                case 193:
                    sqlQuery = " SELECT YEAR(StartDate) 'Year', Count(T.TrainingId) Trainings, Count(P.ParticipantId) Participants," +
                                " SUM(CASE WHEN TrainingType = 0 THEN 1 ELSE 0 END) AS 'Practitioner', " +
                                " SUM(CASE WHEN TrainingType = 1 THEN 1 ELSE 0 END) AS 'Training of Trainers', " +
                                " SUM(CASE WHEN TrainingType > 1 THEN 1 ELSE 0 END) AS 'Other' " +
                                " FROM Training T" +
                                " LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId" +
                                " GROUP BY YEAR(StartDate)" +
                                " ORDER BY YEAR(StartDate)";
                    break;
                case 194:
                    sqlQuery = " SELECT YEAR(StartDate) 'Year', Province.Name 'Province', Count(T.TrainingId) Trainings, Count(P.ParticipantId) Participants " +
                                " FROM Training T " +
                                " LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId " +
                                " INNER JOIN Province ON Province.ProvinceId = T.ProvinceId " +
                                " GROUP BY YEAR(StartDate), Province.Name " +
                                " ORDER BY YEAR(StartDate), Province.Name";
                    break;
                case 20:
                    sqlQuery = " SELECT YEAR(StartDate) AS 'Year', " +
                                " (SELECT COUNT(T1.TrainingId) FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AS 'Trainings', " +
                                //" --(SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN(SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND HasSpecialAbility = 0) AS 'No Special Ability', " +
                                " (SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN(SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND HasSpecialAbility = 1) AS 'Special Ability', " +
                                " (SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN(SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND Gender = 1) AS 'Male', " +
                                " (SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN(SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND Gender = 0) AS 'Female'" +
                                " " +
                                " FROM Training T" +
                                " GROUP BY YEAR(StartDate)" +
                                " ORDER BY YEAR(StartDate)";
                    break;
                case 203:
                    sqlQuery = " SELECT YEAR(Training.StartDate) AS 'Year', ISNULL(OrganizationType.Name, 'Others') AS 'Sector', COUNT(*) AS 'Participants' " +
                                " FROM OrganizationType " +
                                " INNER JOIN Participant ON OrganizationType.OrganizationTypeId = Participant.OrganizationTypeId  " +
                                //" INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId  " +
                                " RIGHT OUTER JOIN Training ON Participant.TrainingId = Training.TrainingId " +
                                " GROUP BY YEAR(Training.StartDate), OrganizationType.Name";
                    break;
                case 21:
                    sqlQuery = " SELECT YEAR(Training.StartDate) AS Year, Province.Name AS Province, COUNT(*) AS Participants" +
                                " FROM    Training INNER JOIN" +
                                " District ON District.DistrictId = Training.DistrictId INNER JOIN" +
                                " Province ON Province.ProvinceId = District.ProvinceId LEFT OUTER JOIN" +
                                " Participant ON Participant.TrainingId = Training.TrainingId" +
                                " GROUP BY YEAR(Training.StartDate), Province.Name" +
                                " ORDER BY YEAR(Training.StartDate), Province.Name";
                    break;
                case 210:
                    sqlQuery = " SELECT Temp.Year AS Year, Temp.[Age Group] 'Age Group', SUM(Temp.Participants) 'Participants', " +
                                " SUM(Temp.Healthy) 'Healthy', SUM(Temp.Disabled) 'Disabled',  " +
                                " SUM(Temp.Male) 'Male', SUM(Temp.Female) 'Female' " +
                                " FROM " +
                                " (" +
                                " SELECT YEAR(Training.StartDate) As Year, COUNT(*) AS Participants, " +
                                " SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'Healthy', " +
                                " SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Disabled', " +
                                " SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male', " +
                                " SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female', " +
                                " ISNULL((SELECT Name FROM AgeGroup WHERE(SELECT DATEDIFF(YEAR, DateOfBirth, GETDATE())) BETWEEN StartAge AND    EndAge), 'NONE') AS 'Age Group' " +
                                " FROM Participant " +
                                " INNER JOIN Training ON Training.TrainingId = Participant.TrainingId " +
                                " GROUP BY YEAR(Training.StartDate), DateOfBirth " +
                                " ) Temp " +
                                " GROUP BY Temp.[Year], Temp.[Age Group] " +
                                " ORDER BY Temp.[Year], Temp.[Age Group] ";
                    break;
                case 22:
                    // Participants and no. of trainings province–wise graph
                    sqlQuery = " SELECT DISTINCT PR.Name as Province, " +
                               " (SELECT COUNT(*) FROM Participant P WHERE P.DistrictId = D.DistrictId) AS Participants, " +
                               " (SELECT COUNT(*) FROM Training T WHERE T.ProvinceId = PR.ProvinceId) AS Trainings " +
                               " FROM Province PR " +
                               " INNER JOIN District D ON D.ProvinceId = PR.ProvinceId ";
                    break;
                case 23:
                    // Government department–wise male & female 
                    sqlQuery = " SELECT OT.Name AS 'Department', " +
                               " (SELECT COUNT(ParticipantId) FROM Participant P WHERE P.OrganizationTypeId = OT.OrganizationTypeId AND P.Gender = 0) Male, " +
                               " (SELECT COUNT(ParticipantId) FROM Participant P WHERE P.OrganizationTypeId = OT.OrganizationTypeId AND P.Gender = 1) Female " +
                               " FROM OrganizationType OT ";
                    break;
                case 24:
                    // List of participants (with date range) by using following filters: 
                    // Ability to generate list by combining two or more than two attributes of the following as well.  
                    // Both table and graph (where applicable). (List of participants includes only those participants 
                    // who have attendance marked “YES” for any time period).  

                    //--a.	Broader Training Area 
                    //--b.	Training level
                    //--c.	Geographical location (Province/Districts/City/on campus/off campus)
                    //--d.	 Gender
                    //--e.	Age (calculate age from DOB entered by participants)  
                    //--f.	Special Ability
                    //--g.	Sector
                    //--h.	Government department 
                    //--i.	Organization wise

                    sqlQuery = " SELECT " +
                                "  " +
                                " P.Title + ' ' + P.Name As Name , P.Cell, P.Email, " +
                                " DATEDIFF(YEAR, P.DateOfBirth, GETDATE()) As Age, " +
                                " CASE WHEN Gender = 0 THEN 'Male' ELSE 'Female' END AS 'Gender',  " +
                                " FORMAT(DateOfBirth, 'dd MMM yyyy') AS DateOfBirth,  " +
                                " CASE WHEN HasSpecialAbility = 0 THEN 'Healthy' ELSE 'Disabled' END AS 'Special Ability',  " +
                                " OT.Name 'Sector', " +
                                " T.Name as Training, " +
                                " City.Name +' '+ D.Name +' ' + Province.Name   AS 'Geographical Location', " +
                                " B.Name AS 'Broader Training Area', " +
                                "  " +
                                " CASE  " +
                                " WHEN TrainingType = 0 THEN 'Practitioner' " +
                                " WHEN TrainingType = 1 THEN 'Training of Trainers' " +
                                " WHEN TrainingType > 1 THEN 'Other' " +
                                " Else 'No Training' END AS 'Training Type', " +
                                "  " +
                                " CASE  " +
                                " WHEN TrainingLevel = 0 THEN  'International' " +
                                " WHEN TrainingLevel = 1 THEN  'National' " +
                                " WHEN TrainingLevel = 2 THEN  'Province' " +
                                " WHEN TrainingLevel = 3 THEN  'Division' " +
                                " WHEN TrainingLevel = 4 THEN  'District' " +
                                " ELSE 'Other Level' End AS 'Training Level' " +
                                "  " +
                                " FROM Training T " +
                                " INNER JOIN BroaderTrainingArea B ON B.BroaderTrainingAreaId = T.BroaderTrainingAreaId " +
                                " INNER JOIN Participant P ON P.TrainingId = T.TrainingId " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = P.OrganizationTypeId " +
                                "  " +
                                " INNER JOIN District D ON D.DistrictId = T.DistrictId " +
                                " INNER JOIN Province ON Province.ProvinceId = T.ProvinceId " +
                                " INNER JOIN City ON City.CityId = T.CityId ";
                    //" WHERE T.BroaderTrainingArea = @BroaderTrainingArea " +
                    //" AND T.TrainingLevel = @TrainingLevel " +
                    //" AND P.Gender = @Gender " +
                    //" AND DATEDIFF(YEAR, P.DateOfBirth, GETDATE()) = @Age -- In Years " +
                    //" AND P.HasSpecialAbility = @SpecialAbilit " +
                    //" AND P.OrganizationTypeId = @Sector " +
                    //" AND P.OrganizationId = @Organization ";
                    break;

                case 25:
                    //List of participants who registered but did not attend the training 
                    // Participants NOT in (TrainingSessionParticipants)
                    sqlQuery = " SELECT " +
                                "  " +
                                " P.Title + ' ' + P.Name As Name, P.Cell, P.Email, " +
                                " DATEDIFF(YEAR, P.DateOfBirth, GETDATE()) As Age, " +
                                " CNIC, CASE WHEN Gender = 0 THEN 'Male' ELSE 'Female' END AS 'Gender',  " +
                                " FORMAT(DateOfBirth, 'dd MMM yyyy') AS DateOfBirth,  " +
                                " CASE WHEN HasSpecialAbility = 0 THEN 'Healthy' ELSE 'Disabled' END AS 'Special Ability', " +
                                " OT.Name 'Sector', " +
                                " T.Name as Training, " +
                                " City.Name +' '+ D.Name +' ' + Province.Name   AS 'Geographical Location', " +
                                " " +
                                " B.Name AS 'Broader Training Area', " +
                                " " +
                                " CASE  " +
                                " WHEN TrainingType = 0 THEN 'Practitioner' " +
                                " WHEN TrainingType = 1 THEN 'Training of Trainers' " +
                                " WHEN TrainingType > 1 THEN 'Other' " +
                                " Else 'No Training' END AS 'Training Type', " +
                                "  " +
                                " CASE  " +
                                " WHEN TrainingLevel = 0 THEN  'International' " +
                                " WHEN TrainingLevel = 1 THEN  'National' " +
                                " WHEN TrainingLevel = 2 THEN  'Province' " +
                                " WHEN TrainingLevel = 3 THEN  'Division' " +
                                " WHEN TrainingLevel = 4 THEN  'District' " +
                                " ELSE 'Other Level' End AS 'Training Level' " +
                                "  " +
                                " FROM Training T " +
                                " INNER JOIN BroaderTrainingArea B ON B.BroaderTrainingAreaId = T.BroaderTrainingAreaId " +
                                " INNER JOIN Participant P ON P.TrainingId = T.TrainingId " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = P.OrganizationTypeId " +
                                "  " +
                                " INNER JOIN District D ON D.DistrictId = T.DistrictId " +
                                " INNER JOIN Province ON Province.ProvinceId = T.ProvinceId " +
                                " INNER JOIN City ON City.CityId = T.CityId " +
                                " WHERE P.ParticipantId NOT IN (SELECT TSP.ParticipantId FROM TrainingSessionParticipant TSP) ";
                    break;
                case 26: // Participant Trend analysis: Cross Broader Training Area 
                    sqlQuery = "SELECT B.Name  AS 'Broader Training Area', " +
                                " COUNT(*) AS 'Participants' FROM dbo.Participant P " +
                                " INNER JOIN dbo.Training T ON T.TrainingId = P.TrainingId " +
                                " INNER JOIN BroaderTrainingArea B ON B.BroaderTrainingAreaId = T.BroaderTrainingAreaId " +
                                " GROUP BY B.Name ";
                    break;

                case 27: // Participant Trend analysis: Cross Geographical location (Province/Districts/City/on campus/off campus)

                    sqlQuery = " SELECT Province.Name AS 'Province', D.Name AS 'District', City.Name AS City, " +
                                " City.Name+'/'+D.Name+'/'+ Province.Name AS 'Geographical Location', " +
                                " COUNT(*) Participants FROM dbo.Participant P " +

                                " INNER JOIN dbo.Training T ON T.TrainingId = P.TrainingId " +
                                " INNER JOIN District D ON D.DistrictId = T.DistrictId " +
                                " INNER JOIN Province ON Province.ProvinceId = T.ProvinceId " +
                                " INNER JOIN City ON City.CityId = T.CityId " +

                                " GROUP BY  Province.Name, D.Name, City.Name ";
                    break;
                case 28: // Participant Trend analysis: Cross Sector
                    sqlQuery = " SELECT OT.Name AS 'Sector', COUNT(*) Participants " +
                                " FROM Participant P " +
                                " INNER JOIN Training T ON T.TrainingId = P.TrainingId " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = P.OrganizationTypeId " +
                                " GROUP BY  OT.Name ";
                    break;
                case 29: // Participant Trend analysis: Cross Government department

                    sqlQuery = " SELECT OT.Name As Sector, O.Name AS 'Department', COUNT(*) Participants  " +
                                " FROM dbo.Participant P " +
                                " INNER JOIN Training T ON T.TrainingId = P.TrainingId " +
                                " INNER JOIN Organization O ON O.OrganizationId = P.OrganizationId " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = O.OrganizationTypeId " +
                                //" --WHERE OT.OrganizationTypeId = 1 " +
                                " GROUP BY  O.Name";
                    // " --WHERE T.StartDate BETWEEN @StartDate AND @EndDate";
                    break;

                case 30:
                    sqlQuery = " SELECT  " +
                                " O.Name 'Donor', " +
                                " OT.Name 'Sector', " +
                                " P.Name AS 'Project',  " +
                                " P.ProjectNumber,  " +
                                " FORMAT(P.StartDate, 'dd MMM yyyy') StartDate,  " +
                                " FORMAT(P.EndDate, 'dd MMM yyyy') EndDate, " +
                                " CONVERT(VARCHAR, DATEDIFF(Month, P.StartDate, P.EndDate)) + ' Months' AS Duration, " +
                                " P.Description " +

                                " FROM	ActivityCost AS AC INNER JOIN " +
                                " Activity AS A ON A.ActivityId = AC.ActivityId RIGHT OUTER JOIN " +
                                " Funding AS F ON AC.FundingId = F.FundingId LEFT OUTER JOIN " +
                                " Training AS T INNER JOIN " +
                                " TrainingCost AS TC ON T.TrainingId = TC.TrainingId ON TC.FundingId = F.FundingId LEFT OUTER JOIN " +
                                " Project AS P ON P.ProjectId = F.ProjectId " +

                                " INNER JOIN Organization O ON O.OrganizationId = P.OrganizationId " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = O.OrganizationTypeId ";

                    //" GROUP BY O.Name, OT.Name, P.Name, P.ProjectNumber, P.StartDate, P.EndDate";
                    break;
                case 31:
                    // Reconciliation of donor projects funding and activity 
                    //-- (including training) cost /expenses and cost/expense analysis  (date range) 

                    //-- One Funding Contains Multiple TrainingCost -- So get Sum(Cost) As TrainingCost
                    //-- One Funding Contains Multiple ActivityCost -- So get Sum(Cost) As ActivityCost
                    //-- Total Cost = TrainingCost + ActivityCost
                    //-- Date Fiter on Trainng.StartDate and Activity.DateOfActivity

                    sqlQuery = " SELECT  " +
                                " OT.Name 'Sector', " +
                                " O.Name 'Donor',  " +

                                " P.Name AS 'Project',  " +
                                " P.ProjectNumber,  " +
                                " FORMAT(P.StartDate, 'dd MMM yyyy') StartDate,  " +
                                " FORMAT(P.EndDate, 'dd MMM yyyy') EndDate, " +
                                " CONVERT(VARCHAR, DATEDIFF(Month, P.StartDate, P.EndDate)) + ' Months' AS Duration, " +

                                //" CASE FundingType WHEN 0 THEN 'Cash' WHEN 1 THEN 'InKind' WHEN 2 THEN 'Expertise' ELSE 'None' END AS 'Funding Type',  " +
                                " ISNULL(SUM(F.CashAmount), 0) AS 'Total Funding',  " +
                                " ISNULL(SUM(TC.Cost), 0) AS 'Training Cost',  " +
                                " ISNULL(SUM(AC.Cost), 0) AS 'Activity Cost', " +
                                " ISNULL(SUM(TC.Cost), 0)  + ISNULL(SUM(AC.Cost), 0) AS 'Total Cost', " +
                                " ISNULL(SUM(F.CashAmount), 0) - (ISNULL(SUM(TC.Cost), 0)  + ISNULL(SUM(AC.Cost), 0)) As Balance " +

                                " FROM	ActivityCost AS AC INNER JOIN " +
                                " Activity AS A ON A.ActivityId = AC.ActivityId RIGHT OUTER JOIN " +
                                " Funding AS F ON AC.FundingId = F.FundingId LEFT OUTER JOIN " +
                                " Training AS T INNER JOIN " +
                                " TrainingCost AS TC ON T.TrainingId = TC.TrainingId ON TC.FundingId = F.FundingId LEFT OUTER JOIN " +
                                " Project AS P ON P.ProjectId = F.ProjectId " +

                                " INNER JOIN Organization O ON O.OrganizationId = P.OrganizationId " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = O.OrganizationTypeId " +
                                where +
                                " GROUP BY O.Name, OT.Name, P.Name, P.ProjectNumber, P.StartDate, P.EndDate";

                    //" WHERE F.StartDate BETWEEN @StartDate AND @EndDate";
                    break;

                case 32:
                    // List of Resource persons with following filters (with graphical representation wherever applicable)
                    //--a.	All
                    //--b.	Area of expertise
                    //--c.	Geographical location (province/district/city)
                    //--d.	Training sessions ( as added in training agenda) and amount paid (if any)
                    //--e.	Trainings count

                    /*
                    sqlQuery = " SELECT " +
                                " RP.Name AS 'ResourcePerson',  " +
                                " D.Name AS 'District',  " +
                                " T.Name AS 'Training',  " +
                                " TS.Name 'Session', FORMAT(TS.StartTime, 'hh:mm tt') AS StartTime, FORMAT(TS.EndTime, 'hh:mm tt') AS EndTime, CASE RPT.IsPaid WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END As Paid, RPT.AmountPaid, " +
                                " (STUFF((SELECT DISTINCT ',' + A.Name FROM Area A INNER JOIN ResourcePersonArea RPA ON RPA.AreaId = A.AreaId " +
                                 " WHERE RPA.ResourcePersonId = RP.ResourcePersonId " +
                                    " FOR XML PATH(''), TYPE " +
                                    " ).value('.', 'NVARCHAR(MAX)') " +
                                " ,1,1,'') ) AS 'Expertise' " +
                                " FROM " +
                                " ResourcePerson RP " +
                                " INNER JOIN District D ON D.DistrictId = RP.DistrictId " +
                                " INNER JOIN ResourcePersonTraining RPT ON RPT.ResourcePersonId = RP.ResourcePersonId " +
                                " INNER JOIN TrainingSession TS ON TS.TrainingSessionId = RPT.TrainingSessionId " +
                                
                                " INNER JOIN Training T ON T.TrainingId = TS.TrainingId ";
                    */

                    sqlQuery = " SELECT RP.Name AS 'Resource Person', CASE WHEN RP.Gender = 0 THEN 'Male' ELSE 'Female' END AS 'Gender', " +
                                " Province.Name AS 'Province',  D.Name AS 'District',  " +
                                " ISNULL(( " +
                                " 	SELECT COUNT(DISTINCT T.TrainingId) FROM TrainingSession TS " +
                                " 	INNER JOIN Training T ON T.TrainingId = TS.TrainingId " +
                                " 	INNER JOIN ResourcePersonTraining RPT ON RPT.TrainingSessionId = TS.TrainingSessionId " +
                                " 	WHERE RPT.ResourcePersonId = RP.ResourcePersonId " +
                                " ), 0) AS 'Trainings',   " +

                                " ISNULL(( " +
                                " 	SELECT COUNT(RPT.TrainingSessionId) FROM ResourcePersonTraining RPT Where RPT.ResourcePersonId = RP.ResourcePersonId  " +
                                " 	GROUP BY ResourcePersonId " +
                                " ), 0) 'Sessions',  " +

                                " ISNULL((STUFF((SELECT DISTINCT ',' + A.Name FROM Area A INNER JOIN ResourcePersonArea RPA ON RPA.AreaId = A.AreaId  " +
                                "      WHERE RPA.ResourcePersonId = RP.ResourcePersonId  " +
                                "      FOR XML PATH(''), TYPE  " +
                                "      ).value('.', 'NVARCHAR(MAX)')  " +
                                " ,1,1,'') ), 'N/A') AS 'Expertise'  " +
                                " FROM  " +
                                " ResourcePerson RP  " +
                                " INNER JOIN District D ON D.DistrictId = RP.DistrictId " +
                                " INNER JOIN Province ON Province.ProvinceId = D.ProvinceId";
                    break;

                case 33:
                    // List of organizations registered with NIDM, with following filters 
                    //--a.	All
                    //--b.	Organization type
                    //--c.	Geographical area of operation
                    //--d.	District (HO)   
                    //--e.	Areas of Specialty/Intervention

                    sqlQuery = " SELECT " +
                                " OT.Name 'Sector', O.Name AS 'Organization', " +
                                " CASE WHEN O.GeographicalArea = 0 THEN 'Nationwide' WHEN O.GeographicalArea = 1 THEN 'Punjab' WHEN O.GeographicalArea = 2 THEN 'Sindh' WHEN O.GeographicalArea = 3 THEN 'KPK' WHEN O.GeographicalArea = 4 THEN 'Balochistan' WHEN O.GeographicalArea = 5 THEN 'GB' WHEN O.GeographicalArea = 6 THEN 'AJK' WHEN O.GeographicalArea = 7 THEN 'FATA' ELSE 'N/A' END AS 'Geographical Area',  " +
                                " FORMAT(DateEstablished, 'dd MMM yyyy') AS DateEstablished, RegisteringAuthority,  " +
                                " CASE WHEN O.ApprovalStatus= 0 THEN 'Pending' WHEN O.ApprovalStatus = 1 THEN 'Accepted' WHEN O.ApprovalStatus = 3 THEN 'Rejected' ELSE 'None' END AS 'Status', " +
                                " D.Name AS 'District', " +
                                " (STUFF((SELECT DISTINCT ',' + A.Name FROM Area A INNER JOIN OrganizationArea OA ON OA.AreaId = A.AreaId " +
                                         " WHERE OA.OrganizationId = O.OrganizationId " +
                                            " FOR XML PATH(''), TYPE " +
                                            " ).value('.', 'NVARCHAR(MAX)') " +
                                        " ,1,1,'') ) AS 'Areas' " +
                                " FROM Organization O  " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = O.OrganizationTypeId " +
                                " INNER JOIN District D ON D.DistrictId = O.DistrictId " +
                                " WHERE O.Category = 1";

                    break;
                case 34:
                    // List of trainings with date range ; filters as below (Where Category = 1)
                    //--a.	All
                    //--b.	Training type 
                    //--c.	Training level
                    //--d.	Organization–wise
                    //--e.	Broader training area
                    //--f.	Organization type 
                    //--g.	Geographical location (province/district/city) 

                    sqlQuery = " SELECT " +
                                " TA.TitleOfTraining,  " +
                                " CASE  " +
                                " WHEN TrainingType = 0 THEN 'Practioner' " +
                                " WHEN TrainingType = 1 THEN 'Training of Trainers' " +
                                " WHEN TrainingType > 1 THEN 'Other' " +
                                " END AS 'TrainingType' , " +
                                "  " +
                                " CASE  " +
                                " WHEN TrainingLevel = 0 THEN 'International' " +
                                " WHEN TrainingLevel = 1 THEN 'National' " +
                                " WHEN TrainingLevel = 2 THEN 'Province' " +
                                " WHEN TrainingLevel = 3 THEN 'Division' " +
                                " WHEN TrainingLevel = 4 THEN 'District' " +
                                " WHEN TrainingLevel > 4 THEN 'Other' " +
                                " END AS 'TrainingLevel',  " +
                                "  " +
                                " B.Name AS'BroaderTrainingArea', OT.Name 'Sector', D.Name District, FORMAT(TA.StartDate, 'dd MMM yyyy') AS StartDate, FORMAT(TA.EndDate, 'dd MMM yyyy') AS EndDate " +
                                " FROM	Organization AS O  " +
                                " INNER JOIN TrainingActivity AS TA ON O.OrganizationId = TA.OrganizationId " +
                                " INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = O.OrganizationTypeId " +
                                " INNER JOIN District AS D ON D.DistrictId = TA.DistrictId " +
                                " INNER JOIN BroaderTrainingArea B ON B.BroaderTrainingAreaId = TA.BroaderTrainingAreaId " +
                                " WHERE O.Category = 1 ";
                    break;
                case 101:
                    var filter = " Q.Type BETWEEN 0 AND 3 ";

                    if (!string.IsNullOrWhiteSpace(where))
                        where += " AND " + filter;
                    else
                        where = " WHERE " + filter;

                    sqlQuery = " SELECT Q.Statement AS 'Question', " +
                                " CASE WHEN Q.Type = 0 THEN 'YesNo' " +
                                " WHEN Q.Type = 1 THEN 'AgreementScale' " +
                                " WHEN Q.Type = 2 THEN 'SatisfactionScale' " +
                                " WHEN Q.Type = 3 THEN 'InterestScale' " +
                                " ELSE '' END AS Type, " +
                                " SUM(CASE WHEN SQR.Response = 0 THEN 1 ELSE 0 END) AS 'Choice1', " +
                                " SUM(CASE WHEN SQR.Response = 1 THEN 1 ELSE 0 END) AS 'Choice2', " +
                                " SUM(CASE WHEN SQR.Response = 2 THEN 1 ELSE 0 END) AS 'Choice3', " +
                                " SUM(CASE WHEN SQR.Response = 3 THEN 1 ELSE 0 END) AS 'Choice4', " +
                                " SUM(CASE WHEN SQR.Response = 4 THEN 1 ELSE 0 END) AS 'Choice5' " +
                                " FROM dbo.Survey S " +
                                " INNER JOIN SurveyQuestion SQ ON SQ.SurveyId = S.SurveyId " +
                                " INNER JOIN Question Q ON Q.QuestionId = SQ.QuestionId " +
                                " INNER JOIN SurveyQuestionResponse SQR ON SQR.SurveyId = S.SurveyId AND SQR.QuestionId = SQ.QuestionId " +
                                " INNER JOIN Respondent R ON R.RespondentId = SQR.RespondentId " +
                                " " +
                                where +
                                " GROUP BY Q.Statement, Type ";
                    break;
            }

            return ConvertSqlToList(sqlQuery);
        }

        private List<Dictionary<string, object>> ConvertSqlToList(string sqlQuery)
        {
            using (var cmd = _context.Database.Connection.CreateCommand())
            {
                _context.Database.Connection.Open();
                cmd.CommandText = sqlQuery;
                using (var reader = cmd.ExecuteReader())
                {
                    return ConvertReaderToList(reader);
                }
            }
        }

        private List<Dictionary<string, object>> ConvertReaderToList(DbDataReader reader)
        {
            List<Dictionary<string, object>> expandolist = new List<Dictionary<string, object>>();

            while (reader.Read())
            {
                IDictionary<string, object> expando = new System.Dynamic.ExpandoObject();

                for (int i = 0; i < reader.FieldCount; i++)
                {
                    expando.Add(Convert.ToString(reader.GetName(i)), reader.GetValue(i));
                }

                expandolist.Add(new Dictionary<string, object>(expando));
            }

            return expandolist;
        }
    }
}