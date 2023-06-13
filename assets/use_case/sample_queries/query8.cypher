// Get the patients that were evaluated by using Barthel Index at admission and at discharge,
// where the admission assessment should be performed before 45 days after the stroke
// and the discharge assessment between 70 and 120 days after the stroke (268 patients expected).


MATCH (barthelDischargeSession:BarthelSession)<-[:isParticipantIn]-(patient:Person)-[:isParticipantIn]->(barthelAdmissionSession:BarthelSession)
WHERE barthelAdmissionSession.displayLabel[0] = 'Barthel session 1'
      AND barthelDischargeSession.displayLabel[0] = 'Barthel session 2'
WITH patient, barthelAdmissionSession, barthelDischargeSession
MATCH (dischargeDaysSinceInjury:ObservableResultValue)<-[:hasPart]-(dischargeCS:ClinicalStatement)<-[:hasOutcome]-(barthelDischargeSession)<-[:isParticipantIn]-(patient)-[:isParticipantIn]->(barthelAdmissionSession)-[:hasOutcome]->(admissionCS:ClinicalStatement)-[:hasPart]->(admissionDaysSinceInjury:ObservableResultValue)
WHERE (dischargeCS)-[:hasPart]->(:DaysSinceInjury)
      AND (admissionCS)-[:hasPart]->(:DaysSinceInjury)
      AND 0 <= admissionDaysSinceInjury.hasValue[0] <= 45
      AND 70 <= dischargeDaysSinceInjury.hasValue[0] <= 120
WITH patient, barthelAdmissionSession, admissionDaysSinceInjury, barthelDischargeSession, dischargeDaysSinceInjury
RETURN patient.label[0] as Patient,
      barthelAdmissionSession.displayLabel[0] as Admision,
      admissionDaysSinceInjury.hasValue[0] as `Days since injury at admision`,
      barthelDischargeSession.displayLabel[0] as Discharge,
      dischargeDaysSinceInjury.hasValue[0] as `Days since injury at discharge`
