# Mapping examples

Here, we show an example of mappings from the [Functional Independence Measure (FIM)](https://www.physio-pedia.com/Functional_Independence_Measure_(FIM)) data provided by the [Guttmann Institute](https://www.guttmann.com) into our SCDM by using SNOMED CT as a terminology. The source dataset was provided as a tabular file, where each column represents a variable. In order to map these data into our SCDM, we have to stablish, for each pair (variable, value), the SNOMED codes corresponding to:

  1. The observable entity that is being observed
  2. The procedure used to make the observation
  3. The clinical finding resulted from the observation

Thus, the file [FIMMappings.csv](./FIMMappings.csv) contains the name of the columns in the source data, which are written in Catalan, together with their possible values and the associated observables, procedures, and clinical findings.