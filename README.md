# PestKidneyGrace# Pesticides and kidney function US Population 2001-2010
This is the data repository for public available code and data to reproduce analyses in Grace et al. 

(https://github.com/MountStats/PestKidneyGrace/dataprep.do) includes the code to extract all necessary data and prepocess data for statistical analyses.

The datapre.do file directly download the necessary data from (https://wwwn.cdc.gov/nchs/nhanes/Default.aspx)

Variable name (NHANES)			
				2001-02	2003-04	2007-08	2009-10
Outcome variable				
ckd	LBDSCR	LBXSCR	LBXSCR	LBXSCR
								
Pesticide				
2,4-Dichlorophenoxyacetic acid	URX24D 	URX24D 	URX24D 	URX24D 
3,5,6-trichloropyridinoal	URXCPM	-	URXCPM	URXCPM
Malathion diacid		-	-	URXMAL	URXMAL
3-Phenoxybenzoic acid		URXOPM	-	URXOPM	URXOPM
				
				
Pedictors				
Age				RIDAGEYR 	RIDAGEYR 	RIDAGEYR 	RIDAGEYR 
Gender				RIAGENDR	RIAGENDR	RIAGENDR	RIAGENDR
Poverty income ratio		INDFMPIR	INDFMPIR	INDFMPIR	INDFMPIR
Race				RIDRETH1	RIDRETH1	RIDRETH1	RIDRETH1
Education level			DMDEDUC2	DMDEDUC2	DMDEDUC2	DMDEDUC2
smoking				smoker		smoker		smoker		smoker
NHANES cycle			wave		wave		wave		wave
				
				
Alcohol consumption		ALQ110		ALQ110		ALQ110		ALQ110
Hypertension			HTN_case	HTN_case	HTN_case	HTN_case
Diabetes			DM_case		DM_case		DM_case		DM_case
				
				
Weights				
primary sampling unit		SDMVPSU		SDMVPSU		SDMVPSU		SDMVPSU
strata				SDMVSTRA	SDMVSTRA	SDMVSTRA	SDMVSTRA
weight				WTSPP2YR	WTSC2YR		WTSC2YR		WTSC2YR


(https://github.com/MountStats/PestKidneyGrace/analyses.do) includes the code to implement analyses presented in the paper.

