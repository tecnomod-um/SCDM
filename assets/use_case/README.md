# Use case
The proposed semantic model was used to harmonized the data from the [Precise4Q project](https://precise4q.eu/), which is centered in stroke, and whose objective is to improve the quality of life of patients by preventing the disease, by making the best treatment in the acute phase, and by selecting the best promising rehabilitation therapies in order to achieve the highest level of independency during the reintegration of the patient in the society after the disease. In this context, we have harmonized heterogeneous data from several European institutions, creating the Precise4Q harmonized graph database, which is compliant with our SCDM. Additionally, we developed a query interface for retrieving data from the Precise4Q harmonized database. Due to the private nature of the clinical data, these results cannot be shared. Nonetheless, we show some extra information next.

## Data size
The source data was provided by different institutions heterogeneously. The next table shows the provided datasets together with a description and the number of patients and entries contained in each dataset, as well as the institution that provided the data.

|Institution         |Dataset          |Patients|Entries|Description                                                                                                                                              |
|--------------------|-----------------|--------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
|Guttmann            |Barthel          |1172    |3474   |Assessments using Barthel Index in patients from the Guttmann clinic                                                                                     |
|Guttmann            |Bateria          |1200    |2909   |Rehabilitation assessments of Guttmann patients by using the Bateria test                                                                                |
|Guttmann            |CIQ              |356     |1057   |Community Integration Questionnaire (CIQ) data recorded in Guttmann clinic                                                                               |
|Guttmann            |EVSF             |1039    |1608   |Evaluations of Guttmann patients according to the Escala de Valoración Socio-Familiar (EVSF) (social and family assessment scale)                        |
|Guttmann            |FIM              |1170    |3920   |Assessments of patients from Guttmann according to the Functional Independence Measure (FIM)                                                             |
|Guttmann            |Clinical Notes   |1459    |13243  |Clinical notes in free text                                                                                                                              |
|Guttmann            |Fugl-Meyer       |129     |264    |Physical assessments using the Fugl-Meyer evaluation in Guttmann patients                                                                                |
|Guttmann            |GNPT             |413     |82556  |Rehabilitation tasks performed by Guttmann patients through the Guttmann NeuroPersonalTrainer (GNPT)                                                     |
|Guttmann            |NIHSS            |1882    |1882   |Evaluation of Guttmann patients according to the National Institutes of Healt Stroke Scale (NIHSS)                                                       |
|ICARE               |Fugl-Meyer       |361     |1444   |Evaluation performed in the ICARE consortium by using Fugl-Meyer (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3547701/)                                 |
|IST3                |IST3             |3035    |3035   |Data from the third international stroke trial (IST-3) of thrombolysis for acute ischaemic stroke (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2442584/)|
|RiksStroke          |RiksStroke       |210777  |344526 |Data from the Swedish Stroke Register (https://www.riksstroke.org/)                                                                                      |
|University of Tartu |Estonian Hospital|11142   |211292 |                                                                                                                                                         |


After the harmonization process of these datasets, the harmonized graph database consisted of:
  - 226,112 patients
  - 4,913,197 clinical statements
  - 18,531,396 nodes
  - 82,219,554 relationships

## Mappings
An example of mappings is shown [here](./mapping_example), where each column of a CSV source dataset is mapped to a procedure, observable entity, and clinical finding.

## SNOMED CT coverage
We decided to use SNOMED CT as a terminology for describing the datasets, thus the graph database contains SNOMED codes to describe the procedures, the clinical findings and the observable entities concerning the data variables. In this context, we evaluated the degree in which the source datasets are covered by the SNOMED CT terminology. In other words, we evaluated if SNOMED CT contains the concepts that we need to describe the source data with enough level of detail to prevent ambiguity. Here, we distinguish:

  - Concept totally covered: if there is a concept in SNOMED CT that exactly matches with the required one.
  - Concept partially covered: if there is not a concept in SNOMED CT that exactly matches with the required one, but the required one can be created in the SNOMED CT semantic context by using the existing ones through specialization or post-coordination.
  - Concept not covered: the required concept is not available in SNOMED CT, and it cannot be created by using the existing ones.

Based on this classification, we did not find any concept not covered. Most of the procedure entities were partially covered, as the datasets contains very concrete procedures that could not exists in SNOMED CT; however, we could create the corresponding class in the context of SNOMED CT, thus being partially covered. Only a couple of them were totally covered by SNOMED, I.e., 716205007 (Assessment using Wisconsin Card Sorting Test). The observable entities and the clinical finding were totally covered in a higher degree. The next table shows, per each dataset, the number of totally and partially covered observable entities and clinical findings:

|Dataset                |Total observables|Covered observables|Totally covered observables|Partially covered observables|Observable coverage|Total findings|Covered findings|Totally covered findings|Partially covered findings|Finding coverage|
|-----------------------|-----------------|-------------------|---------------------------|-----------------------------|-------------------|--------------|----------------|------------------------|--------------------------|----------------|
|Guttmann-bateria       |16               |16                 |10                         |6                            |1                  |8             |8               |8                       |0                         |1               |
|Guttmann-EVSF          |16               |16                 |11                         |5                            |1                  |33            |33              |16                      |17                        |1               |
|Guttmann-GNPT          |9                |9                  |9                          |0                            |1                  |0             |0               |0                       |0                         |NA              |
|Guttmann-FuglMeyer     |10               |10                 |8                          |2                            |1                  |3             |3               |3                       |0                         |1               |
|Guttmann-CIQ           |20               |20                 |8                          |12                           |1                  |41            |41              |20                      |21                        |1               |
|Guttmann-Barthel       |17               |17                 |14                         |3                            |1                  |37            |37              |35                      |2                         |1               |
|Guttmann-FIM           |24               |24                 |19                         |5                            |1                  |50            |50              |48                      |2                         |1               |
|Guttmann-clinicalNotes |10               |10                 |10                         |0                            |1                  |16            |16              |16                      |0                         |1               |
|Linkoping-RiksStroke12m|8                |8                  |6                          |2                            |1                  |18            |18              |10                      |8                         |1               |
|Linkoping-RiksStroke3m |14               |14                 |11                         |3                            |1                  |32            |32              |22                      |10                        |1               |
|Tartu-conditions       |1                |1                  |1                          |0                            |1                  |24            |24              |24                      |0                         |1               |
|ICARE-FuglMeyer        |10               |10                 |8                          |2                            |1                  |2             |2               |2                       |0                         |1               |
|Guttmann-NIHSS         |1                |1                  |1                          |0                            |1                  |0             |0               |0                       |0                         |NA              |
|TOTALS                 |156              |156                |116                        |40                           |1                  |264           |264             |204                     |60                        |1               |



## Query interface

Several videos of the developed query interface are available, in which we used the application to perform the following queries:


- [Use case 1](./demonstration/use_case_1.mp4): Take patients with suffered the stroke when they were between 12 and 40 years old. From these patients, select those who improved the memory digit test from Bateria evaluation (they get a score lower than 5 first, and greater than 5 later), and show the GNPT rehabilitation tasks regarding memory training they perform in between the bateria evaluations.
- [Use case 2](./demonstration/use_case_2.mp4): Get the wrist stability assessment at admission using Fugl-Meyer evaluation of female patients. In this case, the query retrieve results from two heterogeneous datasets that were harmonized by using the SCDM, namely patients from the [Guttmann Institute](https://www.guttmann.com), and patients from the [Interdisciplinary Comprehensive Arm Rehabilitation Evaluation (ICARE)](https://pubmed.ncbi.nlm.nih.gov/23311856/).
