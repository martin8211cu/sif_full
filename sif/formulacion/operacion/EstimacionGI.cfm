<style type="text/css">
	.msgError {font-family: Georgia, "Times New Roman", Times, serif;font-style: italic;font-weight: bold;color: #FF0000;}
</style>

<cfparam name="url.resumido" 	default="false">
<cfparam name="form.tab" 		default="1">
<cfparam name="URL.tab" 		default="#form.tab#">
<cfparam name="param"  			default="">
<cfparam name="ModoDet" 		default="ALTA">
<cfparam name="request.RolAdmin"default="false">
<cfparam name="url.FPEEid"  	default="-1">
<cfparam name="form.FPEEid" 	default="#url.FPEEid#">
<cfparam name="url.FPDElinea"  	default="-1">
<cfparam name="form.FPDElinea" default="#url.FPDElinea#">

<cfparam name="url.FPEPID" 		default="-1">
<cfparam name="form.FPEPID" 	default="#url.FPEPID#">
<cfparam name="form.HV" 		default="0">
<cfparam name="prefijoHV" 		default="">
<cfparam name="filtroHV" 		default="">

<cfif form.HV NEQ 0>
	<cfset prefijoHV  = 'V'>
	<cfset filtroHV	  = "and Version = #form.HV#">
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_dbfunction name="OP_concat" 					  returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="a.FPEEid"  	  returnvariable="V_FPEEid">
<cf_dbfunction name="to_char"	args="a.FPEPid"  	  returnvariable="V_FPEPid">
<cf_dbfunction name="to_char"	args="a.FPDElinea"    returnvariable="V_FPDElinea">
<cf_dbfunction name="to_char"	args="a.FPCCid"       returnvariable="V_FPCCid">

<cfset PCG_ConceptoGastoIngreso = createobject("component","sif.Componentes.PCG_ConceptoGastoIngreso")>
<cfset PlantillaFormulacion = createobject("component","sif.Componentes.PlantillaFormulacion")>		
<cfset FPRES_EstimacionGI    = createobject("component","sif.Componentes.FPRES_EstimacionGI")>	

<cfif isdefined('form.FPEEid') and len(trim(form.FPEEid)) and isdefined('form.FPEPID') and len(trim(form.FPEPID)) and form.FPEPID neq -1 and isdefined('form.FPDElinea') and len(trim(form.FPDElinea)) and form.FPDElinea neq -1>
	<cfset ModoDet = 'CAMBIO'>
</cfif>
<cfset detExtra = "">
<cfif isdefined('form.Equilibrio')>
	<cfset detExtra = "(En Equilibrio)">
</cfif>
<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Estimación de Fuentes de Financiamiento y Egresos#detExtra#">
		<cfif isdefined("form.FPEEid") and len(trim(form.FPEEid)) and form.FPEEid neq -1>
			<cfinclude template="EstimacionGI-form.cfm">
		<cfelse>		
			<cfinclude template="EstimacionGI-lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>