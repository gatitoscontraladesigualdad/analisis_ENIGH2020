
*Titulo: 				Análisis de programas sociales, incidencia y desigualdad
*Autor: 				Máximo Ernesto Jaramillo Molina
*Fuentes:				ENIGH 2020 y anteriores
*Fecha de finalización: 28 de Julio de 2021


clear all

***********************************2020
gl ruta20=       	"~/Documents/Encuestas/ENIGH Vieja Construccion/2020/bases/"

use "$ruta20/ingresos.dta", clear 
*Identificar ingresos por programas sociales separados
gen bec_benito_edubas=0
replace bec_benito_edubas=ing_tri if clave=="P101"
gen bec_benito_EMS=0
replace bec_benito_EMS=ing_tri if clave=="P102"
gen JCF=0
replace JCF=ing_tri if clave=="P108"
gen pam=0
replace pam=ing_tri if clave=="P104" | clave=="P045"
gen pdp=0
replace pdp=ing_tri if clave=="P105"
gen madres_trab=0
replace madres_trab=ing_tri if clave=="P106"
gen seg_vida=0
replace seg_vida=ing_tri if clave=="P107"
gen otros=0
replace otros=ing_tri if clave=="P048"
gen procampo=0
replace procampo=ing_tri if clave=="P043"
gen JeF=0
replace JeF=ing_tri if clave=="P103"

*Sumar dichos ingresos a nivel hogar y pegarlos con base de Concentrado
collapse (sum) bec_benito_edubas bec_benito_EMS JCF pam pdp madres_trab seg_vida otros procampo JeF, by(folioviv foliohog)
merge m:1 folioviv foliohog using "$ruta20/Concen2020.dta"
drop _merge

*Análisis de datos de desigualdad
count
*89,006
sgini ing_cor [w=factor]
* 0.4260

*Generar incidencia de programas sociales sobre ingreso corriente total
gen prog_soc_inci=bene_gob/ ing_cor

*Generar deciles y veintiles del hogar
xtile decil = ing_cor   [w=factor], nq(10)
xtile veintil = ing_cor   [w=factor], nq(20)

*Tabular incidencia promedio, ingresos promedio por Prog. Soc (PS) y Ing. Corriente por deciles 
tabstat prog_soc_inci bene_gob ing_cor [w=factor], by(decil)

*Generar variable que de cuenta del número de hogares que reciben PS 
gen prog_soc_count=0
replace prog_soc_count=1 if bene_gob>0
*Tabular hogares que reciben programas sociales
tabstat prog_soc_count [w=factor], by(decil)
tabstat prog_soc_count [w=factor], by(veintil)

*Tabular incidencia de programas sociales sobre el ingreso para los beneficiarios
tabstat prog_soc_inci  [w=factor] if bene_gob>0, by(decil)

*Sustituir valores perdidos con Ceros para tabular cobertura de PS
recode bec_benito_edubas bec_benito_EMS JCF pam pdp madres_trab seg_vida otros JeF procampo (.=0)

*Generar variables que den cuenta del número de hogares que reciben distintos PS 
gen bec_benito_edubas_count=0
replace bec_benito_edubas_count=1 if bec_benito_edubas>0
gen bec_benito_EMS_count=0
replace bec_benito_EMS_count=1 if bec_benito_EMS>0
gen JCF_count=0
replace JCF_count=1 if JCF>0
gen pam_count=0
replace pam_count=1 if pam>0
gen pdp_count=0
replace pdp_count=1 if pdp>0
gen madres_trab_count=0
replace madres_trab_count=1 if madres_trab>0
gen seg_vida_count=0
replace seg_vida_count=1 if seg_vida>0
gen otros_count=0
replace otros_count=1 if otros>0
gen procampo_count=0
replace procampo_count=1 if procampo>0
gen JeF_count=0
replace JeF_count=1 if JeF>0

gen otros2_count=0
replace otros2_count=1 if pdp>0 | madres_trab>0 | seg_vida>0 | otros>0 | JeF>0 | procampo>0 


*Tabular cobertura de programas sociales sobre total de hogares por decil 
tabstat bec_benito_edubas_count pam_count prog_soc_count [w=factor], by(decil)
tabstat bec_benito_edubas_count bec_benito_EMS_count JCF_count pam_count otros2_count prog_soc_count [w=factor], by(decil)
tabstat JeF_count pdp_count madres_trab_count seg_vida_count otros_count procampo_count [w=factor], by(decil)

*Tabular monto transferido por programas sociales a hogares beneficiarios 
tabstat bec_benito_edubas  [w=factor] if bec_benito_edubas>0 , by(decil)
tabstat bec_benito_EMS  [w=factor] if bec_benito_EMS>0 , by(decil)
tabstat JCF  [w=factor] if JCF>0 , by(decil)
tabstat pam  [w=factor] if pam>0 , by(decil)

*Tabular monto transferido por totalidad de programas sociales a hogares beneficiarios 
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil)

*Tabular masa transferida por totalidad de programas sociales a hogares beneficiarios 
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil) s(sum) format(%22.2fc)
*Obtener el coeficiente de concentración de la política social 
recode bene_gob (0=.)
sgini bene_gob [w=factor] , sortvar(ing_cor)

*Obtener el coeficiente de concentración de los distintos programas sociales
sgini bec_benito_edubas bec_benito_EMS JCF pam pdp madres_trab seg_vida otros procampo JeF [w=factor], sortvar(ing_cor)

*Tabular monto transferido por algunos programas sociales a hogares beneficiarios
tabstat bec_benito_edubas  [w=factor] if bec_benito_edubas>0 , by(decil) s(sum) format(%22.2fc)
sgini bec_benito_edubas [w=factor], sortvar(ing_cor)
tabstat procampo  [w=factor] if procampo>0 , by(decil) s(sum) format(%22.2fc)
sgini procampo [w=factor], sortvar(ing_cor)




************************************2018
*Se repite metodología del año 2020.

gl ruta=       	"~/Documents/Encuestas/ENIGH Vieja Construccion/2018/bases"
use "$ruta/ingresos.dta", clear 
*prospera
gen prospera=0
replace prospera=ing_tri if clave=="P042"
gen pam=0
replace pam=ing_tri if clave=="P044" | clave=="P045"
collapse (sum) prospera pam, by(folioviv foliohog)
merge m:1 folioviv foliohog using "$ruta/Concen2018.dta"
drop _merge


count
*74,647
gen prog_soc_inci=bene_gob/ ing_cor

*Del hogar
xtile decil = ing_cor   [w=factor], nq(10)
tabstat prog_soc_inci bene_gob ing_cor [w=factor], by(decil)

gen prog_soc_count=0
replace prog_soc_count=1 if bene_gob>0
tabstat prog_soc_count [w=factor], by(decil)
xtile veintil = ing_cor   [w=factor], nq(20)
tabstat prog_soc_count [w=factor], by(veintil)
tabstat prog_soc_inci  [w=factor] if bene_gob>0, by(decil)
  
recode prospera pam (.=0)
gen pros_count=0
replace pros_count=1 if prospera>0
gen pam_count=0
replace pam_count=1 if pam>0

tabstat pros_count pam_count prog_soc_count [w=factor], by(decil)
tabstat prospera pam bene_gob  [w=factor], by(decil)

tabstat prospera  [w=factor] if prospera>0 , by(decil)
tabstat pam  [w=factor] if pam>0 , by(decil)
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil)
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil) s(sum) format(%22.2fc)
recode bene_gob (0=.)
sgini bene_gob [w=factor] 

sgini prospera pam bene_gob [w=factor], sortvar(ing_cor)
sgini prospera if prospera>0 [w=factor], sortvar(ing_cor)
sgini ing_cor [w=factor], sortvar(ing_cor)


************************************2016
*Se repite metodología del año 2020.
clear
use "~/Documents/Encuestas/ENIGH Vieja Construccion/2016/bases/Concen16.dta", clear
count
*70,311
sgini ing_cor [w=factor]
gen prog_soc_inci=bene_gob/ ing_cor

*Del hogar
xtile decil = ing_cor   [w=factor], nq(10)
tabstat prog_soc_inci bene_gob ing_cor [w=factor], by(decil)

gen prog_soc_count=0
replace prog_soc_count=1 if bene_gob>0

tabstat prog_soc_count [w=factor], by(decil)
xtile veintil = ing_cor   [w=factor], nq(20)
tabstat prog_soc_count [w=factor], by(veintil)
tabstat prog_soc_inci  [w=factor] if bene_gob>0, by(decil)

tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil)
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil) s(sum) format(%22.2fc)
recode bene_gob (0=.)
sgini bene_gob [w=factor] 


************************************2014
*Se repite metodología del año 2020.
clear
use "~/Documents/Encuestas/ENIGH Vieja Construccion/2014/bases/tra_concentrado_2014_concil_2010_stata.dta", clear
count
*19,479
sgini ing_cor [w=factor]
gen prog_soc_inci=bene_gob/ ing_cor

*Del hogar
xtile decil = ing_cor   [w=factor], nq(10)
tabstat prog_soc_inci bene_gob ing_cor [w=factor], by(decil)

gen prog_soc_count=0
replace prog_soc_count=1 if bene_gob>0

tabstat prog_soc_count [w=factor], by(decil)
xtile veintil = ing_cor   [w=factor], nq(20)
tabstat prog_soc_count [w=factor], by(veintil)
tabstat prog_soc_inci  [w=factor] if bene_gob>0, by(decil)

tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil)
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil) s(sum) format(%22.2fc)
recode bene_gob (0=.)
sgini bene_gob [w=factor] 




************************************2012
*Se repite metodología del año 2020.
use "~/Documents/Encuestas/ENIGH Vieja Construccion/2012/bases/Concen2012.dta", clear
count
*9,002
sgini ing_cor [w=factor]
gen prog_soc_inci=bene_gob/ ing_cor

*Del hogar
xtile decil = ing_cor   [w=factor], nq(10)
tabstat prog_soc_inci bene_gob ing_cor [w=factor], by(decil)

gen prog_soc_count=0
replace prog_soc_count=1 if bene_gob>0

tabstat prog_soc_count [w=factor], by(decil)
xtile veintil = ing_cor   [w=factor], nq(20)
tabstat prog_soc_count [w=factor], by(veintil)
tabstat prog_soc_inci  [w=factor] if bene_gob>0, by(decil)

tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil)
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil) s(sum) format(%22.2fc)
recode bene_gob (0=.)
sgini bene_gob [w=factor] 



************************************2010
*Se repite metodología del año 2020.
cd "~/Documents/Encuestas/ENIGH Vieja Construccion"

use "2010/bases/Concen2010.dta", clear

count

rename ingcor ing_cor
sgini ing_cor [w=factor]
gen prog_soc_inci=bene_gob/ ing_cor

*Del hogar
xtile decil = ing_cor   [w=factor], nq(10)
tabstat prog_soc_inci bene_gob ing_cor [w=factor], by(decil)

gen prog_soc_count=0
replace prog_soc_count=1 if bene_gob>0

tabstat prog_soc_count [w=factor], by(decil)
xtile veintil = ing_cor   [w=factor], nq(20)
tabstat prog_soc_count [w=factor], by(veintil)
tabstat prog_soc_inci  [w=factor] if bene_gob>0, by(decil)

tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil)
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil) s(sum) format(%22.2fc)
recode bene_gob (0=.)
sgini bene_gob [w=factor] 



************************************2008
*Se repite metodología del año 2020.
cd "~/Documents/Encuestas/ENIGH Vieja Construccion"

clear
use "2008/bases/Concen2008.dta", clear
count
*20,468
sgini ingcor [w=factor]

count

rename ingcor ing_cor
sgini ing_cor [w=factor]
gen prog_soc_inci=bene_gob/ ing_cor

*Del hogar
xtile decil = ing_cor   [w=factor], nq(10)
tabstat prog_soc_inci bene_gob ing_cor [w=factor], by(decil)

gen prog_soc_count=0
replace prog_soc_count=1 if bene_gob>0

tabstat prog_soc_count [w=factor], by(decil)
xtile veintil = ing_cor   [w=factor], nq(20)
tabstat prog_soc_count [w=factor], by(veintil)
tabstat prog_soc_count [w=factor] if veintil<11, 
tabstat prog_soc_inci  [w=factor] if bene_gob>0, by(decil)

tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil)
tabstat bene_gob  [w=factor] if bene_gob>0 , by(decil) s(sum) format(%22.2fc)
recode bene_gob (0=.)
sgini bene_gob [w=factor] 

















