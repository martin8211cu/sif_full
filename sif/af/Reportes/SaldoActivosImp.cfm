<cfsetting requesttimeout="1800">
<cfset vsFiltro = ''>
<cfif isdefined("form.Mes") and Len(Trim(form.Mes)) gt 0>
		<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "Mes=" & form.Mes>
</cfif>
<cfif isdefined("form.AID") and Len(Trim(form.AID)) gt 0>
		<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "AID=" & form.AID>
</cfif>
<cfif isdefined("form.CategoriaIni") and Len(Trim(form.CategoriaIni)) gt 0>
		<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "CategoriaIni=" & form.CategoriaIni>
</cfif>
<cfif isdefined("form.CategoriaFin") and Len(Trim(form.CategoriaFin)) gt 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "CategoriaFin=" & form.CategoriaFin>
</cfif>	
<cfif isdefined("form.CLASEIni") and Len(Trim(form.CLASEIni)) gt 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "CLASEIni=" & form.CLASEIni>
</cfif>
<cfif isdefined("form.CLASEFin") and Len(Trim(form.CLASEFin)) gt 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "CLASEFin=" & form.CLASEFin>
</cfif>	
<cfif isdefined("form.OFICINAIni") and Len(Trim(form.OFICINAIni)) gt 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "OFICINAIni=" & form.OFICINAIni>
</cfif>
<cfif isdefined("form.OFICINAFin") and Len(Trim(form.OFICINAFin)) gt 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "OFICINAFin=" & form.OFICINAFin>
</cfif>
<cfif isdefined("form.resumido") and Len(Trim(form.resumido)) gt 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "resumido=" & form.resumido>
	<cfset LSvar_resumido = "Resumido">
</cfif>

<cfparam name="LSvar_resumido" default="">
<!--- <cf_rhimprime datos="/sif/af/Reportes/SaldoActivosRep#LSvar_resumido#.cfm" paramsuri="&Periodo=#form.Periodo#&#vsFiltro#" regresar="/cfmx/sif/af/Reportes/SaldoActivos.cfm">  --->
<cfinclude template="SaldoActivosRep#LSvar_resumido#.cfm">