// From Barthel Index data of those patient records that included only 2 sessions
// where the 1st is a Barthel Index admission assessment completed within 45 days after stroke,
// and the 2nd is a Barthel Index discharge assessment completed between 70 and 120 days after stroke.
// The patients must have at least 2 CIQ evaluations, and the first one needs to be done after the
// first session of the Barthel Index evaluation. Get the number of patients that meet these restrictions (1 patient).

MATCH (patient:Person)-[:isParticipantIn]->(barthelSession:BarthelSession)
WITH patient, count (barthelSession) as barthelSessionCount
WHERE barthelSessionCount = 2
WITH patient
MATCH (dischargeDate:PointInTime)<-[:projectsOnto]-(barthelDischargeSession:BarthelSession)<-[:isParticipantIn]-(patient)-[:isParticipantIn]->(barthelAdmissionSession:BarthelSession)-[:projectsOnto]->(admissionDate:PointInTime)
WHERE dischargeDate.hasValue[0] > admissionDate.hasValue[0]
WITH patient, barthelAdmissionSession, barthelDischargeSession, dischargeDate, admissionDate
MATCH (dischargeDaysSinceInjury:ObservableResultValue)<-[:hasPart]-(dischargeCS:ClinicalStatement)<-[:hasOutcome]-(barthelDischargeSession)<-[:isParticipantIn]-(patient)-[:isParticipantIn]->(barthelAdmissionSession)-[:hasOutcome]->(admissionCS:ClinicalStatement)-[:hasPart]->(admissionDaysSinceInjury:ObservableResultValue)
WHERE (dischargeCS)-[:hasPart]->(:DaysSinceInjury)
      AND (admissionCS)-[:hasPart]->(:DaysSinceInjury)
      AND 0 <= admissionDaysSinceInjury.hasValue[0] <= 45
      AND 70 <= dischargeDaysSinceInjury.hasValue[0] <= 120
WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, barthelDischargeSession, dischargeDaysSinceInjury,  dischargeDate, admissionDate
MATCH (patient)-[:isParticipantIn]->(ciqSession1:CIQSession)-[:projectsOnto]->(ciq1Date:PointInTime)
WHERE ciq1Date.hasValue[0] > admissionDate.hasValue[0] and ciqSession1.displayLabel[0] = "CIQ session 1"
WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, barthelDischargeSession, dischargeDaysSinceInjury,  dischargeDate, admissionDate, ciq1Date
MATCH (patient)-[:isParticipantIn]->(ciqSession:CIQSession)-[:projectsOnto]->(ciqDate:PointInTime)
WHERE ciqDate.hasValue[0] >= ciq1Date.hasValue[0]
WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, barthelDischargeSession, dischargeDaysSinceInjury,  dischargeDate, admissionDate, collect(ciqSession) as ciqSessions
WHERE size(ciqSessions)>=2
UNWIND ciqSessions as ciqSession
WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, barthelDischargeSession, dischargeDaysSinceInjury,  dischargeDate, admissionDate, ciqSession
MATCH (ciqSession)-[:projectsOnto]->(ciqDate:PointInTime)
RETURN patient.label[0] as patient,
      barthelAdmissionSession.displayLabel[0] as admissionBarthel, 
      admissionDate.hasValue[0] as admissionBarthelDate, 
      barthelDischargeSession.displayLabel[0] as dischargeBarthel,
      dischargeDate.hasValue[0] as dischargeBarthelDate,
      ciqSession.displayLabel[0] as ciqSession,
      ciqDate.hasValue[0] as ciqDate
