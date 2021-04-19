/********************************************************************
Purpose: Donwloading NHANES data for Wan et al pesticide-ckd paper.
*********************************************************************/

*clear the space;
clear all

/*Change working directory*/
cd "C:\Users\Grace\Desktop\project publication\try\2001-02"

*2001-2002

*bmiwc
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BMX_B.XPT", clear
keep seqn bmxwaist
sort seqn
save bmiwc, replace

*bloodpressure
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BPX_B.XPT", clear
keep seqn bpxsy1 bpxdi1
sort seqn
save bloodpressure, replace

*fastingglucose
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/L10AM_B.XPT", clear
keep seqn lbxglu
sort seqn
save fastingglucose, replace

*serumcreatinine
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/L40_B.XPT", clear
keep seqn lbdscr 
sort seqn 
save serumcreatinine, replace

*metal
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/L06_B.XPT", clear
keep seqn lbxbcd
sort seqn 
save metal, replace

*herbicide
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/L26PP_B.XPT", clear
keep seqn urxcpm urxopm urx24d wtspp2yr
sort seqn 
save herbicide, replace

*smoke
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/SMQ_B.XPT", clear
keep seqn smq020 smq040
sort seqn 
save smoke, replace

*alcohol
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/ALQ_B.XPT", clear
keep seqn alq110
sort seqn 
save alcohol, replace

*hypertension
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/BPQ_B.XPT", clear
keep seqn bpq040a
sort seqn 
save hypertension, replace

*diabetes
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/DIQ_B.XPT", clear
keep seqn diq010 diq070
sort seqn 
save diabetes, replace

*demographic
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2001-2002/DEMO_B.XPT", clear
keep seqn riagendr ridageyr ridreth1 dmdeduc2 indfmpir wtint2yr wtmec2yr sdmvpsu sdmvstra
sort seqn
save demographic, replace

*merge for 2001-2002 /*Change working directory*/
merge seqn using demographic bmiwc bloodpressure fastingglucose ///
serumcreatinine metal herbicide smoke alcohol hypertension diabetes
tab _merge
drop _merge*
gen wave = 1
cd "C:\Users\Grace\Desktop\project publication\try\merged"
sort seqn
save wave1, replace

*2003-2004

/*Change working directory*/
cd "C:\Users\Grace\Desktop\project publication\try\2003-04"

*bmiwc
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/BMX_C.XPT", clear
keep seqn bmxwaist
sort seqn
save bmiwc, replace

*bloodpressure
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/BPX_C.XPT", clear
keep seqn bpxsy1 bpxdi1
sort seqn
save bloodpressure, replace

*fastingglucose
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/L10AM_C.XPT", clear
keep seqn lbxglu
sort seqn
save fastingglucose, replace

*serumcreatinine
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/L40_C.XPT", clear
keep seqn lbxscr 
sort seqn 
save serumcreatinine, replace

*metal
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/L06BMT_C.XPT", clear
keep seqn lbxbcd
sort seqn 
save metal, replace

*herbicide
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/L26UPP_C.XPT", clear
keep seqn wtsc2yr urx24d urxape urxbsm urxchs
sort seqn 
save herbicide, replace

*smoke
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/SMQ_C.XPT", clear
keep seqn smq020 smq040
sort seqn 
save smoke, replace

*alcohol
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/ALQ_C.XPT", clear
keep seqn alq110
sort seqn 
save alcohol, replace

*hypertension
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/BPQ_C.XPT", clear
keep seqn bpq040a
sort seqn 
save hypertension, replace

*diabetes
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/DIQ_C.XPT", clear
keep seqn diq010 diq070
sort seqn 
save diabetes, replace

*demographic
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/DEMO_C.XPT", clear
keep seqn riagendr ridageyr ridreth1 dmdeduc2 indfmpir wtint2yr wtmec2yr sdmvpsu sdmvstra
sort seqn
save demographic, replace

*merge for 2003-2004 /*Change working directory*/
merge seqn using demographic bmiwc bloodpressure fastingglucose ///
serumcreatinine metal herbicide smoke alcohol hypertension diabetes
tab _merge
drop _merge*
gen wave = 2
cd "C:\Users\Grace\Desktop\project publication\try\merged"
sort seqn
save wave2, replace


*2007-2008

/*Change working directory*/
cd "C:\Users\Grace\Desktop\project publication\try\2007-08"

*bmiwc
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BMX_E.XPT", clear
keep seqn bmxwaist
sort seqn
save bmiwc, replace

*bloodpressure
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BPX_E.XPT", clear
keep seqn bpxsy1 bpxdi1
sort seqn
save bloodpressure, replace

*fastingglucose
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/GLU_E.XPT", clear
keep seqn lbxglu
sort seqn
save fastingglucose, replace

*serumcreatinine
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BIOPRO_E.XPT", clear
keep seqn lbxscr 
sort seqn 
save serumcreatinine, replace

*metal
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/PBCD_E.XPT", clear
keep seqn lbxbcd
sort seqn 
save metal, replace

*herbicide
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/UPHOPM_E.XPT", clear
keep seqn wtsc2yr urx24d urxcpm urxmal urxopm
sort seqn 
save herbicide, replace

*smoke
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/SMQ_E.XPT", clear
keep seqn smq020 smq040
sort seqn 
save smoke, replace

*alcohol
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/ALQ_E.XPT", clear
keep seqn alq110
sort seqn 
save alcohol, replace

*hypertension
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/BPQ_E.XPT", clear
keep seqn bpq040a
sort seqn 
save hypertension, replace

*diabetes
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/DIQ_E.XPT", clear
keep seqn diq010 did070
sort seqn 
save diabetes, replace

*demographic
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/DEMO_E.XPT", clear
keep seqn riagendr ridageyr ridreth1 dmdeduc2 indfmpir wtint2yr wtmec2yr sdmvpsu sdmvstra
sort seqn
save demographic, replace

*merge for 2007-2008 /*Change working directory*/
merge seqn using demographic bmiwc bloodpressure fastingglucose ///
serumcreatinine metal herbicide smoke alcohol hypertension diabetes
tab _merge
drop _merge*
gen wave = 3
cd "C:\Users\Grace\Desktop\project publication\try\merged"
sort seqn
save wave3, replace


*2009-2010

/*Change working directory*/
cd "C:\Users\Grace\Desktop\project publication\try\2009-10"

*bmiwc
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BMX_F.XPT", clear
keep seqn bmxwaist
sort seqn
save bmiwc, replace

*bloodpressure
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BPX_F.XPT", clear
keep seqn bpxsy1 bpxdi1
sort seqn
save bloodpressure, replace

*fastingglucose
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/GLU_F.XPT", clear
keep seqn lbxglu
sort seqn
save fastingglucose, replace

*serumcreatinine
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BIOPRO_F.XPT", clear
keep seqn lbxscr 
sort seqn 
save serumcreatinine, replace

*metal
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/PBCD_F.XPT", clear
keep seqn lbxbcd
sort seqn 
save metal, replace

*herbicide
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/UPHOPM_F.XPT", clear
keep seqn wtsc2yr urx24d urxcpm urxmal urxopm
sort seqn 
save herbicide, replace

*smoke
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/SMQ_F.XPT", clear
keep seqn smq020 smq040
sort seqn 
save smoke, replace

*alcohol
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/ALQ_F.XPT", clear
keep seqn alq110
sort seqn 
save alcohol, replace

*hypertension
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/BPQ_F.XPT", clear
keep seqn bpq040a
sort seqn 
save hypertension, replace

*diabetes
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/DIQ_F.XPT", clear
keep seqn diq010 diq070
sort seqn 
save diabetes, replace

*demographic
import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/DEMO_F.XPT", clear
keep seqn riagendr ridageyr ridreth1 dmdeduc2 indfmpir wtint2yr wtmec2yr sdmvpsu sdmvstra
sort seqn
save demographic, replace

*merge for 2009-2010 /*Change working directory*/
merge seqn using demographic bmiwc bloodpressure fastingglucose ///
serumcreatinine metal herbicide smoke alcohol hypertension diabetes
tab _merge
drop _merge*
gen wave = 4
cd "C:\Users\Grace\Desktop\project publication\try\merged"
sort seqn
save wave4, replace

*Full data
merge seqn using wave1 wave2 wave3 wave4
tab _merge
save alldat, replace
