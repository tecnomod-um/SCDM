// From Barthel Index data of those patient records that included only 2 sessions
// where the 1st is a BI admission assessment completed within 45 days after stroke,
// and the 2nd is a BI discharge assessment completed between 70 and 120 days after stroke,
// get the information of the first evaluation (167 patients expected).

MATCH (patient:Person)-[:isParticipantIn]->(barthelSession:BarthelSession)
WITH patient, count (barthelSession) as barthelSessionCount
WHERE barthelSessionCount = 2
WITH patient
MATCH (dischargeDate:PointInTime)<-[:projectsOnto]-(barthelDischargeSession:BarthelSession)<-[:isParticipantIn]-(patient)-[:isParticipantIn]->(barthelAdmissionSession:BarthelSession)-[:projectsOnto]->(admissionDate:PointInTime)
WHERE dischargeDate.hasValue[0] > admissionDate.hasValue[0]
WITH patient, barthelAdmissionSession, barthelDischargeSession
MATCH (dischargeDaysSinceInjury:ObservableResultValue)<-[:hasPart]-(dischargeCS:ClinicalStatement)<-[:hasOutcome]-(barthelDischargeSession)<-[:isParticipantIn]-(patient)-[:isParticipantIn]->(barthelAdmissionSession)-[:hasOutcome]->(admissionCS:ClinicalStatement)-[:hasPart]->(admissionDaysSinceInjury:ObservableResultValue)
WHERE (dischargeCS)-[:hasPart]->(:DaysSinceInjury)
      AND (admissionCS)-[:hasPart]->(:DaysSinceInjury)
      AND 0 <= admissionDaysSinceInjury.hasValue[0] <= 45
      AND 70 <= dischargeDaysSinceInjury.hasValue[0] <= 120
WITH patient, barthelAdmissionSession, admissionDaysSinceInjury
MATCH (barthelAdmissionSession)-[:hasPart]->(itemProcedure:ClinicalProcess)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart|:interprets_observable]->(observable:`363787002`)
WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, itemProcedure, cs, observable
CALL {
      WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, itemProcedure, cs, observable
      MATCH(cs)-[:hasPart]->(resultValue:ObservableResultValue)
      RETURN resultValue.hasValue[0] as result
      UNION
      WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, itemProcedure, cs, observable
      MATCH (cs)-[:represents]->(finding:`404684003`)
      RETURN finding.label[0] as result
}
RETURN patient.label[0] as patient, 
       barthelAdmissionSession.displayLabel[0] as session, 
       admissionDaysSinceInjury.hasValue[0] as daysSinceInjury, 
       itemProcedure.displayLabel[0] as procedure,
       observable.label[0] as observable,
       result
