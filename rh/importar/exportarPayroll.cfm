
<!--- -- Script de generación de archivo payroll para Puerto Rico
<cfsetting requesttimeout="#3600*24#">--->
<cfparam name="url.CPmes" type="numeric">
<cfparam name="url.CPperiodo" type="numeric">
<cfsetting requesttimeout="#600#">

<cfquery name="ERR" datasource="#session.DSN#">
	select 
	<!---convert(varchar, cp.CPfpago, 112) as Fecha, --->
	<cf_dbfunction name="date_format"  args="cp.CPfpago,YYYYMMDD">, 
	substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8) as Identificacion, 
	substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9) as NoPatronal, 
	substring(e.DEapellido1 || ' ' || e.DEapellido2 || ' ' || e.DEnombre, 1, 35) as Nombre,
	' ' as filler1,
	' ' as filler2,
	' ' as filler3,
	' ' as filler4,
	' ' as filler5,
	' ' as filler6,
	' ' as filler7,
	' ' as filler8,
	' ' as filler9,
	' ' as filler10,
	' ' as filler11,
	' ' as filler12,
	' ' as filler13,
	' ' as filler14,
	' ' as filler15,
	se.SEsalariobruto + se.SEincidencias - se.SEinorenta as Taxable,
	se.SEinorenta as NonTaxable,
	se.SEsalariobruto + se.SEincidencias as TotalIncome,
		coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00) + 
		coalesce((select sum(CCvaloremp) from HCargasCalculo cc where cc.RCNid = se.RCNid and cc.DEid = se.DEid), 0.00)+ se.SErenta as Deducciones, 
	se.SEliquido as NetIncome,
	se.SEsalariobruto as Wages,
	0.00 as Commisions,
	0.00 as Allowances,
	0.00 as Tips,
	coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'K401'), 0.00) as d401K,
	0.00 as OtherRetirment,
	0.00 as Cafeteria,
	0.00 as Reimbursements,
	0.00 as CODA,
	SErenta as Witholding,
	0.00 as FICA,
 	coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SS'), 0.00) as SocialSecurity,
	coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'MD'), 0.00) as Medicare,
	coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SINOT'), 0.00) as Disability,
	0.00 as ChauferInsurance,
	0 as ChaufferWeeks,
	coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo not in ('SS', 'MD', 'SINOT', 'K401')), 0.00) + 
	coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00) as OtherDeductions
	from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
	   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
	   and se.RCNid = cp.CPid
	   and e.DEid = se.DEid
	order by 1, 4
</cfquery>
