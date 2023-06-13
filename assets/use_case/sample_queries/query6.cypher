// Get the days since injury at admission EVSF, the length of stay,
// calculated as the days between the first and the second evaluation of EVSF,
// and the age at stroke of the following patient ids: 4474782, 4638114, 4740138,
// 4764240, 5077800, 5135598, 5148468, 5237622, 5301504, 5327478, 5394870, 5411952,
// 5439798, 5483556, 5490810, 5504382, 5583942, 5586048, 5605002, 5646420, 5758974,
// 5779332, 5799456, 5828238, 5877378 (25 entries expected).

MATCH (evsfDischarge:EVSFSession)<-[:isParticipantIn]-(patient:Person)-[:isParticipantIn]->(evsfAdmission:EVSFSession)
WHERE evsfAdmission.displayLabel[0] = 'EVSF session 1' and evsfDischarge.displayLabel[0] = 'EVSF session 2' 
and patient.label[0] in ['subject_gm_4474782', 'subject_gm_4638114', 'subject_gm_4740138', 'subject_gm_4764240', 'subject_gm_5077800', 'subject_gm_5135598', 'subject_gm_5148468', 'subject_gm_5237622', 'subject_gm_5301504', 'subject_gm_5327478', 'subject_gm_5394870', 'subject_gm_5411952', 'subject_gm_5439798', 'subject_gm_5483556', 'subject_gm_5490810', 'subject_gm_5504382', 'subject_gm_5583942', 'subject_gm_5586048', 'subject_gm_5605002', 'subject_gm_5646420', 'subject_gm_5758974', 'subject_gm_5779332', 'subject_gm_5799456', 'subject_gm_5828238', 'subject_gm_5877378']
WITH patient, evsfAdmission, evsfDischarge
MATCH (evsfAdmission)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart]->(daysSinceInjuryAtAdmissionEVSF:ObservableResultValue)
WHERE EXISTS((cs)-[:hasPart]->(:DaysSinceInjury))
WITH patient, evsfAdmission, evsfDischarge, daysSinceInjuryAtAdmissionEVSF
MATCH (evsfDischarge)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart]->(daysSinceInjuryAtDischargeEVSF:ObservableResultValue)
WHERE EXISTS((cs)-[:hasPart]->(:DaysSinceInjury))
WITH patient, evsfAdmission, evsfDischarge, daysSinceInjuryAtAdmissionEVSF, daysSinceInjuryAtDischargeEVSF
MATCH (evsfAdmission)-[:hasOutcome]->(cs:ClinicalStatement)-[:hasPart]->(ageAtAdmissionEVSF:ObservableResultValue)
WHERE EXISTS((cs)-[:hasPart]->(:AgeAtEVSFObservable))
WITH patient, evsfAdmission, evsfDischarge, daysSinceInjuryAtAdmissionEVSF, daysSinceInjuryAtDischargeEVSF, ageAtAdmissionEVSF,  ageAtAdmissionEVSF.hasValue[0] - (daysSinceInjuryAtAdmissionEVSF.hasValue[0]/365.0) as ageAtStroke

MATCH (evsfDischarge)-[:projectsOnto]->(evsfDischargeDate:PointInTime)
WITH patient, evsfAdmission, evsfDischarge, daysSinceInjuryAtAdmissionEVSF, daysSinceInjuryAtDischargeEVSF, ageAtAdmissionEVSF, ageAtStroke, evsfDischargeDate
MATCH (evsfAdmission)-[:projectsOnto]->(evsfAdmissionDate:PointInTime)
WITH patient, evsfAdmission, evsfDischarge, daysSinceInjuryAtAdmissionEVSF, daysSinceInjuryAtDischargeEVSF, ageAtAdmissionEVSF, ageAtStroke, evsfDischargeDate, evsfAdmissionDate, abs(duration.inDays(evsfAdmissionDate.hasValue[0], evsfDischargeDate.hasValue[0]).days) as LOS
WITH patient, evsfAdmission, evsfDischarge, daysSinceInjuryAtAdmissionEVSF, daysSinceInjuryAtDischargeEVSF, ageAtAdmissionEVSF, ageAtStroke, evsfAdmissionDate, evsfDischargeDate, LOS
return  patient.label[0] as patient,
    daysSinceInjuryAtAdmissionEVSF.hasValue[0] as daysSinceInjuryAtAdmissionEVSF, 
    daysSinceInjuryAtDischargeEVSF.hasValue[0] as daysSinceInjuryAtDischargeEVSF,
    ageAtAdmissionEVSF.hasValue[0] as ageAtAdmissionEVSF,
    ageAtStroke,
    evsfAdmissionDate.hasValue[0] as evsfAdmissionDate,
    evsfDischargeDate.hasValue[0] as evsfDischargeDate,
    LOS
