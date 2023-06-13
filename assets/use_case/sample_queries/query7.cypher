// Get the first and the second Bateria evaluation for each patient.
// The time point for the second evaluation should be less or equal to 180 days
// since the stroke episode (686 patients expected).

MATCH (bateriaSession2:BateriaSession)<-[:isParticipantIn]-(patient:Person)-[:isParticipantIn]->(bateriaSession1:BateriaSession)
WHERE bateriaSession1.displayLabel[0] = 'Bateria session 1' AND bateriaSession2.displayLabel[0] = 'Bateria session 2'
WITH patient, bateriaSession1, bateriaSession2
MATCH (bateriaSession2)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart]->(daysSinceInjuryValue:ObservableResultValue)
WHERE (cs)-[:hasPart]->(:DaysSinceInjury) AND
0 <= daysSinceInjuryValue.hasValue[0] <= 180
WITH patient, [bateriaSession1, bateriaSession2] as bateriaSessions
UNWIND bateriaSessions as bateriaSession
WITH patient, bateriaSession
CALL {
    WITH bateriaSession
    MATCH (bateriaSession)-[:hasPart]->(procedure:ClinicalProcess)-[:hasOutcome]->(cs:ClinicalStatement)-[:represents]->(finding:`404684003`)
    WITH procedure, cs, finding
    MATCH (cs)-[:interprets_observable]->(observable:`363787002`)
    RETURN procedure, cs, observable, finding.prefLabel[0] as value
    UNION
    WITH bateriaSession
    MATCH (bateriaSession)-[:hasPart]->(procedure:ClinicalProcess)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart]->(result:ObservableResultValue)
    WITH procedure, cs, result
    MATCH (cs)-[:hasPart]->(observable:`363787002`)
    RETURN procedure, cs, observable, result.hasValue[0] as value
}
WITH patient, bateriaSession, procedure, cs, observable, value
MATCH (bateriaSession)-[:hasOutcome]->(aux:ClinicalStatement)-[:hasPart]->(daysSinceInjury:ObservableResultValue)
WHERE (aux)-[:hasPart]->(:DaysSinceInjury)
RETURN patient.label[0] as patient,
        bateriaSession.displayLabel[0] as session,
        daysSinceInjury.hasValue[0] as daysSinceInjury,
        procedure.displayLabel[0] as procedure,
        observable.prefLabel[0] as variable,
        value
order by patient, session, daysSinceInjury
