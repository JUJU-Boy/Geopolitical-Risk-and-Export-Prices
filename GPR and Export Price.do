
cap gen lnP=ln(P+1)

global X "lnP GPR lntfp lnCost CI SGR QC"

*************************描述性统计*************************

outreg2 using "描述性统计.doc", replace sum(log) keep(lnP GPR lntfp lnCost CI SGR QC)

*************************基准回归****************************
reghdfe $X , a(year)
outreg2 using "基准回归结果.rtf", replace tstat bdec(3) tdec(2) addtext(CONTROL,YES,Product FE,YES,Country FE,YES)

reghdfe $X ,a(hs_id year)
outreg2 using "基准回归结果.rtf", append tstat bdec(3) tdec(2) addtext(CONTROL,YES,Year FE,YES,Product FE,YES)

reghdfe $X , a(stkcd hs_id country)
est sto result1
outreg2 using "基准回归结果.rtf", append tstat bdec(3) tdec(2) addtext(CONTROL,YES,Product FE,YES,Company FE,YES,Country FE,YES)

reghdfe $X , a(stkcd hs_id year)
est sto result2
outreg2 using "基准回归结果.rtf", append tstat bdec(3) tdec(2) addtext(CONTROL,YES,Year FE,YES,Company FE,YES,Product FE)

*************************异质性检验****************************
cap gen MI=(industry==3)
cap gen SOE=(NOQ==1)
cap gen GT=(type==1)

reghdfe $X MI c.GPR#i.MI ,a(stkcd hs_id year)
outreg2 using "异质性检验.rtf",replace tstat bdec(3) tdec(2) ctitle(是否制造业) addtext(CONTROL,YES,Company FE,YES,Year FE,YES,Product FE,YES)

reghdfe $X SOE c.GPR#i.SOE ,a(stkcd hs_id year)
outreg2 using "异质性检验.rtf",append tstat bdec(3) tdec(2) ctitle(是否国有企业) addtext(CONTROL,YES,Company FE,YES,Year FE,YES,Product FE,YES)

reghdfe $X GT c.GPR#i.GT ,a(stkcd hs_id year)
outreg2 using "异质性检验.rtf",append tstat bdec(3) tdec(2) ctitle(是否一般贸易) addtext(CONTROL,YES,Company FE,YES,Year FE,YES,Product FE,YES)

*************************进一步分析****************************
sum GPR,detail
cap gen C1=(GPR<=.0295617)
cap gen C2=(GPR>.0295617 & GPR<=.0820348)
cap gen C3=(GPR>.0820348 & GPR <=.2416615)

reghdfe $X c.GPR#i.C1 c.GPR#i.C2 c.GPR#i.C3,a(stkcd hs_id year)
outreg2 using "异质性检验.rtf",append tstat bdec(3) tdec(2) ctitle(是否一般贸易) addtext(CONTROL,YES,Company FE,YES,Year FE,YES,Product FE,YES)

*Wald Test
display (_b[1bn.C1#c.GPR]-_b[1bn.C2#c.GPR])/(sqrt(SE[8,8])^2+sqrt(SE[10,10])^2)^0.5
display (_b[1bn.C2#c.GPR]-_b[1bn.C3#c.GPR])/(sqrt(SE[10,10])^2+sqrt(SE[12,12])^2)^0.5
display (_b[1bn.C3#c.GPR]-_b[GPR])/(sqrt(SE[1,1])^2+sqrt(SE[12,12])^2)^0.5
