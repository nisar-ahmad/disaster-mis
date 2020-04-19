

-- 4.	Participants analysis of a Training – Province–wise Age and disability segregation 
-- (Count Group by Training, Provance, Disability) 
/*
SELECT Training.Name, Province.Name, COUNT(*) AS Participants, 
SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'NONE',
SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Disabled'
FROM Participant
INNER JOIN Training ON Training.TrainingId = Participant.TrainingId
INNER JOIN District ON District.DistrictId = Participant.DistrictId
INNER JOIN Province ON Province.ProvinceId = District.ProvinceId
GROUP BY Training.Name, Province.Name
ORDER BY Training.Name, Province.Name

*/


-- (Counts  Group by Training, Provance, Age Range)
/*
SELECT 
Temp.Training, Temp.Province, SUM(Temp.Participants) 'Participants', Temp.[Age Group] 'Age Group',
SUM(Temp.Healthy) 'Healthy', SUM(Temp.Disabled) 'Disabled', 
SUM(Temp.Male) 'Male', SUM(Temp.Female) 'Female'
FROM 
(
SELECT Training.Name 'Training', Province.Name 'Province', COUNT(*) AS Participants, 
SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'Healthy',
SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Disabled',
SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male',
SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female',
ISNULL((SELECT Name FROM AgeGroup WHERE (SELECT DATEDIFF(YEAR, DateOfBirth, GETDATE())) BETWEEN StartAge AND	EndAge), 'NONE') AS 'Age Group'
FROM Participant
INNER JOIN Training ON Training.TrainingId = Participant.TrainingId
INNER JOIN District ON District.DistrictId = Participant.DistrictId
INNER JOIN Province ON Province.ProvinceId = District.ProvinceId
GROUP BY Training.Name, Province.Name, DateOfBirth
--ORDER BY Training.Name, Province.Name
) Temp
GROUP BY Temp.Training, Temp.Province, Temp.[Age Group]
ORDER BY Temp.Training, Temp.Province, Temp.[Age Group]

*/
-----------------------------------------------------------
-- 5.	Participants analysis of a Training – Province–wise male & female segregation 
-- (Count of Male, Femlae group by Training, then Province)
/*
SELECT Training.Name As Training, Province.Name As Province, COUNT(*) AS Participants, 
SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male',
SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female'
FROM Participant
INNER JOIN Training ON Training.TrainingId = Participant.TrainingId
INNER JOIN District ON District.DistrictId = Participant.DistrictId
INNER JOIN Province ON Province.ProvinceId = District.ProvinceId
GROUP BY Training.Name, Province.Name
ORDER BY Training.Name, Province.Name
*/

-----------------------------------------------------------
--7.	Participants analysis of a Training – Sector–wise male & female segregation 
--      (Count of Male, Femlae group by Training, then OrgType)
/*

SELECT Training.Name AS Training, OrganizationType.Name AS Sector, COUNT(*) AS Participants, 
SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male',
SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female'
FROM Participant
INNER JOIN Training ON Training.TrainingId = Participant.TrainingId
INNER JOIN District ON District.DistrictId = Participant.DistrictId
INNER JOIN Province ON Province.ProvinceId = District.ProvinceId

INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId
INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId

GROUP BY Training.Name, OrganizationType.Name
ORDER BY Training.Name, OrganizationType.Name

*/


-----------------------------------------------------------
-- 9.	Participants analysis of a Training – Province–wise sector segregation
/*
SELECT Training.Name AS Training, Province.Name AS Province, OrganizationType.Name AS Sector, COUNT(*) AS Participants
FROM Participant
INNER JOIN Training ON Training.TrainingId = Participant.TrainingId
INNER JOIN District ON District.DistrictId = Participant.DistrictId
INNER JOIN Province ON Province.ProvinceId = District.ProvinceId

INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId
INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId

GROUP BY Training.Name, Province.Name, OrganizationType.Name
ORDER BY Training.Name, Province.Name
*/

/*
-----------------------------------------------------------
-- 10.	Participants analysis of a Training – Segregation by government departments only 
--      (Counts Training, OrgType, Org Group by Training, then OrgType)


SELECT Training.Name AS Training, OrganizationType.Name AS Sector, 
COUNT(*) AS Participants,
SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male',
SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female',
SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'Healthy',
SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Disabled'

FROM Participant
INNER JOIN Training ON Training.TrainingId = Participant.TrainingId
INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId
INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId

GROUP BY Training.Name, OrganizationType.Name
ORDER BY Training.Name, OrganizationType.Name

*/

/*
-----------------------------------------------------------
-- 11.	Participants analysis of a Training – Government departments province–wise 
--      (Counts Training, OrgType, Org Group by Training, then Prov, then OrgType)

SELECT Training.Name AS Training, Province.Name Province, OrganizationType.Name AS Sector, 
COUNT(*) AS Participants,
SUM(CASE WHEN Gender = 0 THEN 1 ELSE 0 END) AS 'Male',
SUM(CASE WHEN Gender = 1 THEN 1 ELSE 0 END) AS 'Female',
SUM(CASE WHEN HasSpecialAbility = 0 THEN 1 ELSE 0 END) AS 'Healthy',
SUM(CASE WHEN HasSpecialAbility = 1 THEN 1 ELSE 0 END) AS 'Disabled'

FROM Participant
INNER JOIN Training ON Training.TrainingId = Participant.TrainingId
INNER JOIN District ON District.DistrictId = Participant.DistrictId
INNER JOIN Province ON Province.ProvinceId = District.ProvinceId
INNER JOIN Organization ON Organization.OrganizationId = Participant.OrganizationId
INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId

GROUP BY Training.Name, Province.Name, OrganizationType.Name
ORDER BY Training.Name, Province.Name, OrganizationType.Name

*/

--===========================================================

-- 19.	Public report of Trainings by Year as shown at http://www.nidm.gov.pk/Training/TrainingCoursesAndParticipation. 
--      This report page should also show list of Trainings for that Year
-- a. Broader Area public report by Year
-- b. Training Level public report by Year
-- c. Training Type public report by Year
-- d. Province–wise public report by Year

/*
SELECT YEAR(StartDate) AS 'Year' ,
COUNT(*) AS 'Training Courses',
(
	SELECT COUNT(*) FROM Participant P
	INNER JOIN	Training TT ON TT.TrainingId = P.TrainingId
	WHERE YEAR(TT.StartDate) = YEAR(T.StartDate)
) AS Participants
FROM Training T
GROUP BY YEAR(StartDate)
*/

-- a. Broader Area public report by Year
/*
SELECT YEAR(StartDate) 'Year', T.Name AS Training, Count(P.ParticipantId) Participants,
SUM(CASE WHEN BroaderTrainingArea = 0 THEN 1 ELSE 0 END) AS 'Mitigation',
SUM(CASE WHEN BroaderTrainingArea = 1 THEN 1 ELSE 0 END) AS 'Preparedness',
SUM(CASE WHEN BroaderTrainingArea = 2 THEN 1 ELSE 0 END) AS 'Response',
SUM(CASE WHEN BroaderTrainingArea = 3 THEN 1 ELSE 0 END) AS 'Recovery',
SUM(CASE WHEN BroaderTrainingArea > 3 THEN 1 ELSE 0 END) AS 'Other'

FROM Training T
LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId
GROUP BY YEAR(StartDate), T.Name
ORDER BY YEAR(StartDate), T.Name

*/

-- b. Training Level public report by Year
-- public enum TrainingLevel { International, National, Province, Division, District, Local }
/*
SELECT YEAR(StartDate) 'Year', T.Name AS Training, Count(P.ParticipantId) Participants,
SUM(CASE WHEN TrainingLevel = 0 THEN 1 ELSE 0 END) AS 'International',
SUM(CASE WHEN TrainingLevel = 1 THEN 1 ELSE 0 END) AS 'National',
SUM(CASE WHEN TrainingLevel = 2 THEN 1 ELSE 0 END) AS 'Province',
SUM(CASE WHEN TrainingLevel = 3 THEN 1 ELSE 0 END) AS 'Division',
SUM(CASE WHEN TrainingLevel = 4 THEN 1 ELSE 0 END) AS 'District',
SUM(CASE WHEN TrainingLevel > 4 THEN 1 ELSE 0 END) AS 'Other'

FROM Training T
LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId
GROUP BY YEAR(StartDate), T.Name
ORDER BY YEAR(StartDate), T.Name
*/

-- c. Training Type public report by Year
 -- public enum TrainingType { NIDM, NDMA, Other, None }

/*
SELECT YEAR(StartDate) 'Year', T.Name AS Training, Count(P.ParticipantId) Participants,
SUM(CASE WHEN TrainingType = 0 THEN 1 ELSE 0 END) AS 'NIDM',
SUM(CASE WHEN TrainingType = 1 THEN 1 ELSE 0 END) AS 'NDMA',
SUM(CASE WHEN TrainingType = 2 THEN 1 ELSE 0 END) AS 'Other',
SUM(CASE WHEN TrainingType > 2 THEN 1 ELSE 0 END) AS 'None'

FROM Training T
LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId
GROUP BY YEAR(StartDate), T.Name
ORDER BY YEAR(StartDate), T.Name

*/
-- d. Province–wise public report by Year
/*
SELECT YEAR(StartDate) 'Year', T.Name AS Training, Province.Name 'Province', Count(P.ParticipantId) Participants

FROM Training T
LEFT OUTER JOIN Participant P ON P.TrainingId = T.TrainingId
INNER JOIN Province ON Province.ProvinceId = T.ProvinceId
GROUP BY YEAR(StartDate), T.Name, Province.Name
ORDER BY YEAR(StartDate), T.Name, Province.Name
*/

--===========================================================
--20.	Public report of Participants by Year as shown at http://www.nidm.gov.pk/Training/TrainingCoursesAndParticipation 
--a.	Special Ability Province–wise Public Report by Year
--b.	Male & Female Province–wise Public Report by Year
/*
SELECT YEAR(StartDate) AS 'Year', 
(SELECT COUNT(T1.TrainingId) FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AS 'Training Cources', 
( SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN  (SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND HasSpecialAbility = 0) AS 'Health Participants', 
( SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN  (SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND HasSpecialAbility = 1) AS 'Disabled Participants', 
( SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN  (SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND Gender = 1) AS 'Male', 
( SELECT COUNT(ParticipantId) FROM Participant WHERE TrainingId IN  (SELECT T1.TrainingId FROM Training T1 WHERE YEAR(T1.StartDate) = YEAR(T.StartDate)) AND Gender = 0) AS 'Female'

FROM Training T
GROUP BY YEAR(StartDate)
ORDER BY YEAR(StartDate)
*/

--c.	Sector–wise Public Report by year
/*
SELECT YEAR(Training.StartDate) AS 'Year', ISNULL(OrganizationType.Name, 'NONE') AS 'Sector', COUNT(*) AS 'Participants'
FROM Organization 
INNER JOIN Participant ON Organization.OrganizationId = Participant.OrganizationId 
INNER JOIN OrganizationType ON OrganizationType.OrganizationTypeId = Organization.OrganizationTypeId 
RIGHT OUTER JOIN Training ON Participant.TrainingId = Training.TrainingId
GROUP BY YEAR(Training.StartDate), OrganizationType.Name
*/

--===========================================================
-- 21.	Province & Age Group Public Report by YEAR

/*
SELECT YEAR(Training.StartDate) AS 'Year', Province.Name AS 'Province', COUNT(*) AS 'Participants'
FROM    Training INNER JOIN
        District ON District.DistrictId = Training.DistrictId INNER JOIN
        Province ON Province.ProvinceId = District.ProvinceId LEFT OUTER JOIN
        Participant ON Participant.TrainingId = Training.TrainingId
GROUP BY YEAR(Training.StartDate), Province.Name
ORDER BY YEAR(Training.StartDate), Province.Name
*/


--===========================================================
--24.	List of participants (with date range) by using following filters: 
--      Ability to generate list by combining two or more than two attributes of the following as well.  
--      Both table and graph (where applicable). (List of participants includes only those participants 
--      who have attendance marked “YES” for any time period).  

--a.	Broader Training Area 
--b.	Training level
--c.	Geographical location (Province/Districts/City/on campus/off campus)
--d.	 Gender
--e.	Age (calculate age from DOB entered by participants)  
--f.	Special Ability
--g.	Sector
--h.	Government department 
--i.	Organization wise

--SELECT 
--ParticipantId, P.TrainingId, Title, P.Name, CNIC, CASE WHEN Gender = 0 THEN 'Male' ELSE 'Female' END AS 'Gender', 
--DateOfBirth, CASE WHEN HasSpecialAbility = 0 THEN 'Healthy' ELSE 'Disabled' END AS 'Special Ability', 
--O.Name 'Organization', Designation, BPSNo, YearsOfExperience, AcademicQualificationId, 
--D.Name 'District', OfficialAddress, ResidentialAddress, PhoneWithExt, P.Fax, Cell, P.Email, P.Skype, 
--AnyPreviousTrainingAttended, PreviousTrainings, IsFeePaid, AmountPaid, PaymentProofDocument, 
--P.ApprovalStatus, P.IsActive, OtherOrganization, OT.Name 'Sector'

--FROM Training T
--INNER JOIN Participant P ON P.TrainingId = T.TrainingId
--INNER JOIN Organization O ON O.OrganizationId = P.OrganizationId
--INNER JOIN OrganizationType OT ON OT.OrganizationTypeId = O.OrganizationTypeId
--INNER JOIN District D ON D.DistrictId = T.DistrictId

--WHERE T.BroaderTrainingArea = @BroaderTrainingArea
--AND T.TrainingLevel = @TrainingLevel
--AND P.Gender = @Gender
--AND DATEDIFF(YEAR, P.DateOfBirth, GETDATE()) = @Age -- In Years
--AND P.HasSpecialAbility = @SpecialAbilit
--AND P.OrganizationTypeId = @Sector
--AND P.OrganizationId = @Organization


