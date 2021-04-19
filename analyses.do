/********************************************************************
Purpose: Analysis NHANES data for Wan et al pesticide-ckd paper.
*********************************************************************/

*clear the space;
clear all

*Change working directory
cd "C:\Users\Grace\Desktop\project publication\formal data\merged"

*Read the data
use "alldat.dta"


/*Genearl calculations*/

*Participants at each wave
tabulate wave
label define wave 1 "2001-2002" 2 "2003-2004" 3 "2007-2008" 4 "2009-2010"
label values wave wave
tabulate wave

*Pesticide weight
gen wtpest = wtspp2yr if wave==1
replace wtpest = wtsc2yr if wave>=2

*SERUM creatinine - *SCr should be in mg/dL. LBDSCR on wave 1 and LBXSCR in other waves
gen sercreat = lbdscr if wave == 1
replace sercreat = lbxscr if wave == 2 | wave == 3 | wave == 4
label variable sercreat "Creatinine (mg/dL)"
count if missing(sercreat)

*calcuate egfr using CKD-EPI equation eGFR = 141 x min(SCr/κ, 1)α x max(SCr/κ, 1)-1.209 x 0.993Age x 1.018 [if female] x 1.159 [if Black]
*https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2763564/

*if female
gen egfrepi = 141*(min((sercreat/0.7), 1)^(-0.329))*(max((sercreat/0.7),1)^(-1.209))*(0.993^ridageyr)*1.018 if riagendr == 2
*if male
replace egfrepi = 141*(min((sercreat/0.9), 1)^(-0.411))*(max((sercreat/0.9),1)^(-1.209))*(0.993^ridageyr) if riagendr == 1
*considering race
replace egfrepi = egfrepi*1.159 if ridreth1 == 4
label variable egfrepi "eGFR (CKD-EPI equation)"
univar egfrepi
count if missing(egfrepi)
replace egfrepi = . if sercreat == .

***********ckd stage epi - https://pubmed.ncbi.nlm.nih.gov/15882252/
gen stageepi = 1 if egfrepi >= 90
replace stageepi = 2 if egfrepi < 90 & egfrepi >= 60
replace stageepi = 3 if egfrepi < 60 & egfrepi >= 30
replace stageepi = 4 if egfrepi < 30 & egfrepi >= 15
replace stageepi = 5 if egfrepi < 15
label variable stageepi "CKD-EPI Stage "
label define stageepi 1 "1 'eGFR >= 90'" 2 "2 '60 <= eGFR < 90'" 3 "3 '30 <= eGFR < 60'" 4 "4 '15 <= eGFR < 30'" 5 "5 'eGFR < 15'" 
label values stageepi stageepi
tab stageepi
replace stageepi = . if egfrepi == .
count if missing(stageepi)

***********ckd yes or no - 59 >= egfr >=15 https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5552458/pdf/nihms887041.pdf
gen ckd = 1 if egfrepi <= 59 & egfrepi >= 15
replace ckd = 0 if egfrepi < 15 | egfrepi > 59 
label variable ckd "Chronic Kidney Disease"
label define ckd 1 "Yes '15 <= eGFR <= 59" 0 "No 'eGFR>59, eGFR<15'"
label values ckd ckd
replace ckd = . if egfrepi == .
tab ckd

/*End of genearl calculations*/

/***Table 1 first column  - no sub-population we use all the data with MEC weight for this***/
*MEC weight for the all participants (no sub-population)
gen wtall = (1/4)*wtmec2yr

*Design elements for the all data
*https://wwwn.cdc.gov/nchs/nhanes/tutorials/Module2.aspx
svyset [w=wtall], psu(sdmvpsu) strata(sdmvstra)
svydescribe 
*There are 61 strata with 2 or 3 PSU in each. There are 123 PSU (per sampling unit). 
*Observations at each PSU varies, a max of 137, min of 22 and an average of 91.8 observation in the PSU.

*Sex 
label define riagendr 1 "Male" 2 "Female"
label values riagendr riagendr
svy:tab riagendr, ci
tab riagendr

*Age
svy:mean ridageyr

*Weight circumfrence
svy:mean bmxwaist

*Serum creatinine
svy:mean lbxscr

*Ethnicity
label define ridreth1 1 "Mexican American" 2 "Other Hispanic" 3 "Non-Hispanic White" 4 "Non-Hispanic Black" 5 "Other Race - Including Multi-Racial" 
label values ridreth1 ridreth1
svy:tab ridreth1, ci
tab ridreth1, mi

*Poverty income ratio
gen poverty_group=0
replace poverty_group=1 if indfmpir<1
replace poverty_group=2 if indfmpir>=1
label define poverty_group 1 "<1" 2">=1"
label values poverty_group poverty_group
svy: tab poverty_group, ci
tab poverty_group,mi

*Cigarettes smoking
*variables need Smoked at least 100 cigarettes in life - SMQ020
*Do you now smoke cigarettes? - SMQ040
gen smoker=0
replace smoker=. if smq020>=7 | smq040>=7
replace smoker=1 if smq020==1  & smq040<=2
replace smoker=2 if smq020==1  & smq040==3
replace smoker=3 if smq020==2
label define smoker 1 "current smoker" 2 "former smoker" 3 "non-smoker"
label values smoker smoker
svy: tab smoker if missing(smoker), obs se ci col
tab smoker, mi

*Alcohol consumption
gen alcohol=2
replace alcohol=0 if alq110>=2
replace alcohol=1 if alq110==1
replace alcohol=. if alq110==9
label define alcohol 0 "abstinence" 1 "drinker"
label values alcohol alcohol
svy: tab alcohol, ci
tab alcohol

*Hypertension
gen HTN_case=0
replace HTN_case=1 if bpxsy1>=140 | bpxdi1>=90 | bpq040a==1
replace HTN_case=. if bpxsy1==. & bpxdi1==. & bpq040a==.
label define HTN_case 0 "non-hypertension" 1 "hypertension"
label values HTN_case HTN_case
svy: tab HTN_case, ci
tab HTN_case

*Diabetes
gen DM_case=0
replace DM_case=1 if lbxglu>=126 | diq070==1 | did070==1
replace DM_case=. if lbxglu==. & diq070==. & did070==.
label define DM_case 0 "non-DM" 1 "diabetes"
label values DM_case DM_case
svy: tab DM_case, ci
tab DM_case

*CKD
gen ckd = 1 if egfrepi <= 59 & egfrepi >= 15
replace ckd = 0 if egfrepi < 15 | egfrepi > 59 
label variable ckd "Chronic Kidney Disease"
label define ckd 1 "Yes '15 <= eGFR <= 59" 0 "No 'eGFR>59, eGFR<15'"
label values ckd ckd
svy: tab ckd, ci
tab ckd

/***Table 1 second column  - 2,4-Dichloro acid ***/
*Pesticide weight for 2,4-Dichloro - collected in all waves. 
*8-years pesticide weight; WTSPP2YR - pesticides subsample 2 year MEC weight, WTSC2YR - environmental subsample c weights
*Johnson CL, Paulose-Ram R, Ogden CL, et al. National Health and Nutrition Examination Survey: Analytic guidelines,- 
*-1999–2010. National Center for Health Statistics. Vital Health Stat 2(161). 2013.
/*since we have 2,4-D data from 4 different waves, 
we calculate the 8 years weight by multiplying by 1/4 
(8 years weight = 2 years weight * 1/4)
See the link https://wwwn.cdc.gov/nchs/nhanes/tutorials/module3.aspx
Within the link click on "When and How to Construct Weights When Combining Survey Cycles"*/
gen wt24d = 1/4*(wtpest)
label variable wt24d "Weights for 2,4-D"

*Design elements of the survey
*https://wwwn.cdc.gov/nchs/nhanes/tutorials/Module2.aspx
svyset, clear
svyset [w=wt24d], psu(sdmvpsu) strata(sdmvstra)
svydescribe

*Define sub-population for 2,4-Dichloro 20 <= age <= 80 and nonmissing serum creatinint
gen sp24d = 1  if ridageyr > 19 & ridageyr < 81 & urx24d != . & sercreat != .
replace sp24d = 0 if sp24d == .
tab sp24d

*Sex
svy, subpop(sp24d): tab riagendr,ci
tab riagendr if sp24d

*Age
svy, subpop(sp24d): mean ridageyr

*Weight circumfrence
svy, subpop(sp24d): mean bmxwaist


*Serum creatinine
svy, subpop(sp24d): mean lbxscr

*Ethnicity
svy, subpop(sp24d): tab ridreth1,ci
tab ridreth1 if sp24d

*Poverty income ratio
svy, subpop(sp24d): tab poverty_group,ci
tab poverty_group if sp24d

*Cigarettes smoking
svy, subpop(sp24d): tab smoker if !missing(smoker), ci
tab smoker if sp24d, mi

*Alcohol consumption
svy, subpop(sp24d): tab alcohol,ci
tab alcohol if sp24d

*Hypertension
svy, subpop(sp24d): tab HTN_case,ci
tab HTN_case if sp24d

*Diabetes
svy, subpop(sp24d): tab DM_case,ci
tab DM_case if sp24d

*CKD
svy, subpop(sp24d): tab ckd,ci
tab ckd if sp24d


/***Table 1 third column  - 3,5,6-Trichloro ***/
*Pesticide weight for 3,5,6-Trichloro - collected in waves 1,3,4. 
gen wt356t = 1/3*(wtpest)
label variable wt356t "Weights for 3,5,6-T"

*Design elements of the survey
*https://wwwn.cdc.gov/nchs/nhanes/tutorials/Module2.aspx
svyset, clear
svyset [w=wt356t], psu(sdmvpsu) strata(sdmvstra)
svydescribe

*Define sub-population for 3,5,6-Trichloro 20 <= age <= 80 and nonmissing serum creatinint
gen sp356t = 1  if ridageyr > 19 & ridageyr < 81 & urxcpm != . & sercreat != .
replace sp356t = 0 if sp356t == .
label variable sp356t "SubPopulation 3,5,6-T"

*Sex
svy, subpop(sp356t): tab riagendr,ci
tab riagendr if sp356t

*Age
svy, subpop(sp356t): mean ridageyr

*Waist circumfrence
svy, subpop(sp356t): mean bmxwaist

*Serum creatinine
svy, subpop(sp356t): mean lbxscr

*Ethnicity
svy, subpop(sp356t): tab ridreth1,ci
tab ridreth1 if sp356t

*Poverty income ratio
svy, subpop(sp356t): tab poverty_group,ci
tab poverty_group if sp356t

*Cigarettes smoking
svy, subpop(sp356t): tab smoker,ci
tab smoker if sp356t

*Alcohol consumption
svy, subpop(sp356t): tab alcohol,ci
tab alcohol if sp356t

*Hypertension
svy, subpop(sp356t): tab HTN_case,ci
tab HTN_case if sp356t

*Diabetes
svy, subpop(sp356t): tab DM_case,ci
tab DM_case if sp356t

*CKD
svy, subpop(sp356t): tab ckd,ci
tab ckd if sp356t


/***Table 1 forth column  - 3-Pheno ***/
*Pesticide weight for 3-Pheno - collected in waves 1,3,4. 
gen wt3p = 1/3*(wtpest)
label variable wt3p "Weights for 3-Pheno"

*Design elements of the survey
*https://wwwn.cdc.gov/nchs/nhanes/tutorials/Module2.aspx
svyset, clear
svyset [w=wt3p], psu(sdmvpsu) strata(sdmvstra)
svydescribe

*Define sub-population for 3,5,6-Trichloro 20 <= age <= 80 and nonmissing serum creatinint
gen sp3p = 1  if ridageyr > 19 & ridageyr < 81 & urxopm != . & sercreat != .
replace sp3p = 0 if sp3p == .
label variable sp3p "SubPopulation 3-Pheno"
tab sp3p

*Sex
svy, subpop(sp3p): tab riagendr,ci
tab riagendr if sp3p

*Age
svy, subpop(sp3p): mean ridageyr

*Waist circumfrence
svy, subpop(sp3p): mean bmxwaist

*Serum creatinine
svy, subpop(sp3p): mean lbxscr

*Ethnicity
svy, subpop(sp3p): tab ridreth1,ci
tab ridreth1 if sp3p

*Poverty income ratio
svy, subpop(sp3p): tab poverty_group,ci
tab poverty_group if sp3p

*Cigarettes smoking
svy, subpop(sp3p): tab smoker,ci
tab smoker if sp3p

*Alcohol consumption
svy, subpop(sp3p): tab alcohol,ci
tab alcohol if sp3p

*Hypertension
svy, subpop(sp3p): tab HTN_case,ci
tab HTN_case if sp3p

*Diabetes
svy, subpop(sp3p): tab DM_case,ci
tab DM_case if sp3p

*CKD
svy, subpop(sp3p): tab ckd
tab ckd if sp3p


/***Table 1 fifth column  - Malathion ***/
*Pesticide weight for Malahion - collected in waves 3,4. 
gen wtmal = 1/2*(wtpest)
label variable wtmal "Weights for Malathion"

*Design elements of the survey
*https://wwwn.cdc.gov/nchs/nhanes/tutorials/Module2.aspx
svyset, clear
svyset [w=wtmal], psu(sdmvpsu) strata(sdmvstra)
svydescribe

*Define sub-population for 3,5,6-Trichloro 20 <= age <= 80 and nonmissing serum creatinint
gen spmal = 1  if ridageyr > 19 & ridageyr < 81 & urxmal != . & sercreat != .
replace spmal = 0 if spmal == .
label variable spmal "SubPopulation Malathion"

*Sex
svy, subpop(spmal): tab riagendr,ci
tab riagendr if spmal

*Age
svy, subpop(spmal): mean ridageyr

*Waist circumfrence
svy, subpop(spmal): mean bmxwaist

*Serum creatinine
svy, subpop(spmal): mean lbxscr

*Ethnicity
svy, subpop(spmal): tab ridreth1,ci
tab ridreth1 if spmal

*Poverty income ratio
svy, subpop(spmal): tab poverty_group,ci
tab poverty_group if spmal

*Cigarettes smoking
svy, subpop(spmal): tab smoker,ci
tab smoker if spmal

*Alcohol consumption
svy, subpop(spmal): tab alcohol,ci
tab alcohol if spmal

*Hypertension
svy, subpop(spmal): tab HTN_case,ci
tab HTN_case if spmal

*Diabetes
svy, subpop(spmal): tab DM_case,ci
tab DM_case if spmal

*CKD
svy, subpop(spmal): tab ckd
tab ckd if spmal

/Before analysing table 2/
**********Now convert those below the limit of detection (LOD) to a fill value
gen LOD_cd = lbxbcd
replace LOD_cd = 0.10 if lbxbcd<=0.14
tab LOD_cd

gen LOD_24D = urx24d
replace LOD_24D = 0.20 if urx24d<=0.28
tab LOD_24D

gen LOD_356 = urxcpm
replace LOD_356 = 0.20 if urxcpm<=0.28
tab LOD_356

gen LOD_malathion = urxmal
replace LOD_malathion = 0.25 if urxmal<=0.35
tab LOD_356

gen LOD_3PBA = urxopm
replace LOD_3PBA = 0.05 if urxopm<=0.07
tab LOD_3PBA

***********Now log-transformed heavy metals & pesticides included in the study
*variables need Blood cadmium (ug/L) - LOD_cd

*2,4-D (ug/L) result - LOD_24D
*3,5,6-trichloropyridinol (ug/L) result - LOD_356
*Malathion diacid (ug/L) result - LOD_malathion
*3-phenoxybenzoic (ug/L) acid result - LOD_3PBA

gen log_cadmium=log(LOD_cd)
gen log_24D=log(LOD_24D)
gen log_356=log(LOD_356)
gen log_malathion=log(LOD_malathion)
gen log_3phenoxybenzoic=log(LOD_3PBA)


***********************Table 2 logistic regression
**for log cadmium
*weight for cadmium - MEC weight
gen wtcd = 1/4*(wtmec2yr)
label variable wtcd "Weights for cadmium"
svyset, clear
svyset [w=wtcd], psu(sdmvpsu) strata(sdmvstra)
svydescribe

*Define sub-population for cadmium 20 <= age <= 80 and nonmissing serum creatinint
gen spcd = 1  if ridageyr > 19 & ridageyr < 81 & lbxbcd != . & sercreat != .
replace spcd = 0 if spcd == .
label variable spmal "SubPopulation Cadmium"
*crude OR
svy,subpop(spcd):logistic ckd log_cadmium
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(spcd):logistic ckd log_cadmium ridageyr riagendr indfmpir ridreth1 smoker wave

**for log 2,4-D
svyset, clear
svyset [w=wt24d], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy, subpop(sp24d):logistic ckd log_24D
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy, subpop(sp24d):logistic ckd log_24D ridageyr riagendr indfmpir ridreth1 smoker wave

**for 3,5,6-trichloropyridinol
svyset, clear
svyset [w=wt356t], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(sp356t):logistic ckd log_356
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(sp356t):logistic ckd log_356 ridageyr riagendr indfmpir ridreth1 smoker wave

*for malathion
svyset, clear
svyset [w=wtmal], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(spmal):logistic ckd log_malathion
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(spmal):logistic ckd log_malathion ridageyr riagendr indfmpir ridreth1 smoker wave

**for 3PBA
svyset, clear
svyset [w=wt3p], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(sp3p):logistic ckd log_3phenoxybenzoic
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(sp3p):logistic ckd log_3phenoxybenzoic ridageyr riagendr indfmpir ridreth1 smoker wave


***********************Table 3 sensitivity analysis
***excluding those with hypertension & diabetes prior to the analysis
drop if HTN_case==1 & DM_case==1
save "sensitivity.dta", replace

**for cadmium
svyset, clear
svyset [w=wtcd], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(spcd):logistic ckd log_cadmium
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(spcd):logistic ckd log_cadmium ridageyr riagendr indfmpir ridreth1 smoker wave

**for 2,4-D
svyset, clear
svyset [w=wt24d], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(sp24d):logistic ckd log_24D
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(sp24d):logistic ckd log_24D ridageyr riagendr indfmpir ridreth1 smoker wave

**for 3,5,6-trichloropyridinol
svyset, clear
svyset [w=wt356t], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(sp356t):logistic ckd log_356
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(sp356t):logistic ckd log_356 ridageyr riagendr indfmpir ridreth1 smoker wave

**for malathion
svyset, clear
svyset [w=wtmal], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(spmal):logistic ckd log_malathion
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(spmal):logistic ckd log_malathion ridageyr riagendr indfmpir ridreth1 smoker wave

**for 3PBA
svyset, clear
svyset [w=wt3p], psu(sdmvpsu) strata(sdmvstra)
*crude OR
svy,subpop(sp3p):logistic ckd log_3phenoxybenzoic
*adjusted model (adjusted for age, gender, poverty income ratio, ethnicity, smoker, NHANES wave)
svy,subpop(sp3p):logistic ckd log_3phenoxybenzoic ridageyr riagendr indfmpir ridreth1 smoker wave


