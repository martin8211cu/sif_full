-- Script de generación de archivo payroll para Puerto Rico

select 
convert(varchar, cp.CPfpago, 112) Fecha, 
substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8) Identificacion, 
substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9) NoPatronal, 
substring(e.DEapellido1 || ' ' || e.DEapellido2 || ' ' || e.DEnombre, 1, 35) Nombre,
' ' filler1,
' ' filler2,
' ' filler3,
' ' filler4,
' ' filler5,
' ' filler6,
' ' filler7,
' ' filler8,
' ' filler9,
' ' filler10,
' ' filler11,
' ' filler12,
' ' filler13,
' ' filler14,
' ' filler15,
se.SEsalariobruto + se.SEincidencias - se.SEinorenta Taxable,
se.SEinorenta NonTaxable,
se.SEsalariobruto + se.SEincidencias TotalIncome,
convert(money, 
	coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00) + 
	coalesce((select sum(CCvaloremp) from HCargasCalculo cc where cc.RCNid = se.RCNid and cc.DEid = se.DEid), 0.00)+ se.SErenta) Deducciones,
se.SEliquido NetIncome,
se.SEsalariobruto Wages,
0.00 Commisions,
0.00 Allowances,
0.00 Tips,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'K401'), 0.00)) d401K,
0.00 OtherRetirment,
0.00 Cafeteria,
0.00 Reimbursements,
0.00 CODA,
SErenta Witholding,
0.00 FICA,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SS'), 0.00)) SocialSecurity,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'MD'), 0.00)) Medicare,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SINOT'), 0.00)) Disability,
0.00 ChauferInsurance,
0 ChaufferWeeks,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo not in ('SS', 'MD', 'SINOT', 'K401')), 0.00) + 
coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00)) OtherDeductions
from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
where cp.Ecodigo = @Ecodigo
   and cp.CPperiodo = @CPperiodo
   and cp.CPmes = @CPmes
   and se.RCNid = cp.CPid
   and e.DEid = se.DEid
order by 1, 4