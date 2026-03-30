<cfinvoke key="LB_Titulo" default="Impresi&oacute;n de Órdenes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="imprOrdenPago.xml"/>
<cfinvoke key="LB_Archivo" default="OrdenesDePago.xls"	returnvariable="LB_Archivo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="imprOrdenPago.xml"/>

<cf_navegacion name="TESOPid" default="">

<cfif form.TESOPid NEQ "" and not isdefined("url.regresar")>
	<cfset LvarComponente = "imprOrdenPago_form.cfm">
	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select  TESOPRevisado 
				,TESOPAprobado 
				,TESOPRefrendado
				,TESOPidioma
				,TESOPcomponente
		from TESOPprocEmi
		where TESid 	= #session.tesoreria.TESid#
	</cfquery>
	
    <cfif isdefined("rsVerifica") and rsVerifica.recordcount gt 0 and len(trim(rsVerifica.TESOPcomponente)) GT 5>
		<cfset LvarComponente = rsVerifica.TESOPcomponente>
	</cfif>


	<cf_templatecss>

	<cfparam name="url.RegresarA" default="imprOrdenPago.cfm?regresar=1">
	<cf_htmlReportsHeaders 
		title="#LB_Titulo#" 
		filename="#LB_Archivo#"
		irA="#url.RegresarA#"
		download="no"
		preview="no"
	>

	<cfset paramsuri="&imprime=1">
	<cfif isdefined("Form.TESOPid")>
		<cfset paramsuri = paramsuri & '&TESOPid=#form.TESOPid#'>
	</cfif>

	<cfset form.MSG="">
	
	<cfinclude template="#LvarComponente#">
<cfelse>

	<cf_templateheader title="#LB_Titulo#">
		<cfinclude template="imprOrdenPago_lista.cfm">
	<cf_templatefooter>
</cfif>
