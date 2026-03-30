<cfset LvarReporte = isdefined("rsReporteTotal")>
<cfif LvarReporte>
	<cfset LvarReporteN = rsReporteTotal.recordCount>
<cfelse>
	<cfset LvarReporteN = 0>
</cfif>

<cfparam name="LvarTESOPid" default="#form.TESOPid#">
<cfinvoke 	component="sif.tesoreria.Componentes.TESafectaciones"
			method="sbImprimeCPCs"
			returnvariable="Imprimio"
			
			TESSPid		= "#LvarTESOPid#"
			esReporte	= "#LvarReporte#"
			ReporteN	= "#LvarReporteN#"
>
<cfif Imprimio>
	<cfset LvarCPCimpresion = true>
</cfif>