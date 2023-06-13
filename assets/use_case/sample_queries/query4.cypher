// Get the first evaluation of FIM and Barthel Index of all patients
// that have done at least one FIM and one Barthel evaluation (1019 patients expected).

MATCH (patient:Person)
WHERE (patient)-[:isParticipantIn]->(:BarthelSession) AND
      (patient)-[:isParticipantIn]->(:FIMSession)
WITH patient
CALL{
    WITH patient
    MATCH (patient)-[:isParticipantIn]->(session:BarthelSession)-[:hasPart]->(procedure:ClinicalProcess)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart|:interprets_observable]->(observable:`363787002`)
    WHERE session.displayLabel[0] = 'Barthel session 1'
    RETURN session, procedure, cs, observable
    UNION
    WITH patient
    MATCH (patient)-[:isParticipantIn]->(session:FIMSession)-[:hasPart]->(procedure:ClinicalProcess)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart|:interprets_observable]->(observable:`363787002`)
    WHERE session.displayLabel[0] = 'FIM session 1'
    RETURN session, procedure, cs, observable
}
WITH patient, session, procedure, cs, observable
CALL{
    WITH patient, session, procedure, cs, observable
    MATCH (cs)-[:hasPart]->(result:ObservableResultValue)
    RETURN result.hasValue[0] as result
    UNION
    WITH patient, session, procedure, cs, observable
    MATCH (cs)-[:represents]->(result:`404684003`)
    RETURN result.label[0] as result
}
RETURN patient.label[0] as patient, 
       session.displayLabel[0] as session,
       procedure.displayLabel[0] as procedure,
       observable.label[0] as observable,
       result
