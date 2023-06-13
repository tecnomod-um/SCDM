// Get all patients that have done at least 2 Barthel Index evaluations (1086 patients expected).
MATCH (patient:Person)-[:isParticipantIn]->(barthelSession:BarthelSession)
WITH patient, count (barthelSession) as barthelSessionCount
WHERE barthelSessionCount >= 2
RETURN patient.label[0] as patient, barthelSessionCount order by barthelSessionCount