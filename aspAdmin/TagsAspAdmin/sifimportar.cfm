<cfsetting enablecfoutputonly="yes">

<cfif ThisTag.ExecutionMode IS 'Start' AND ThisTag.HasEndTag IS 'YES'>
<cfelseif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'NO' >
	<cfparam name="Attributes.EIid"     type="numeric" default="0">
	<cfparam name="Attributes.EIcodigo" type="string"  default="">
	<cfparam name="Attributes.mode"     type="string">
	<cfparam name="Attributes.width"    type="numeric" default="300">
	<cfparam name="Attributes.height"   type="numeric" default="300">
	<cfparam name="Attributes.form"     type="string"  default="formexport">
	<cfparam name="Attributes.exec"     type="boolean" default="no">
	
	<!--- solo para exportación --->
	<cfparam name="Attributes.html"     type="boolean" default="no">
	<cfparam name="Attributes.header"   type="boolean" default="#Attributes.html#">
	<cfparam name="Attributes.name"     type="string"  default="">
	<cfparam Name="ThisTag.parameters"  default="#arrayNew(1)#">
	
	<cfif Attributes.EIid EQ 0 AND Len(Attributes.EIcodigo) EQ 0>
		<cfthrow message="Debe especificarse al menos uno de los siguientes atributos:  EIid, EIcodigo">
	</cfif>
	
	<cfquery datasource="#session.dsn#" name="formatos">
		select * from EImportador
		where (Ecodigo is null
		   or Ecodigo = #Session.Ecodigo#)
		<cfif Attributes.EIid NEQ 0>
		  and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EIid#">
		</cfif>
		<cfif Len(Attributes.EIcodigo) NEQ 0>
		  and EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.EIcodigo#">
		</cfif>
	</cfquery>
	
	<cfif formatos.RecordCount EQ 1>
		<cfif Attributes.mode EQ "out" and formatos.EIexporta EQ 0>
			<cfoutput>Este formato no est&aacute; habilitado para exportaci&oacute;n.</cfoutput>
		<cfelseif Attributes.mode EQ "out" and Attributes.exec EQ "yes">
			<cfinclude template="/sif/importar/export-function.cfm">
			<cfset parms = StructNew()>
			<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
				<cfset parms[ThisTag.parameters[i].name] = ThisTag.parameters[i].value>
			</cfloop>
			<cfset ret_value = exportar(formatos.EIid,Attributes.html,Attributes.header,parms)>
			<cfif Len(Attributes.name) EQ 0>
				<cfif not Attributes.html>
					<cfcontent type="text/plain">
					<cfheader name="Content-Disposition" value="attachment; filename=exportar.txt">
					<cfheader name="Expires" value="-1">
				</cfif>
				<cfoutput>#ret_value#</cfoutput>
			<cfelse>
				<cfset "Caller.#Attributes.name#" = ret_value>
			</cfif>
		<cfelseif Attributes.mode EQ "out">
			<cfinclude template="/sif/importar/export-form.cfm">
		<cfelseif Attributes.mode EQ "in" and formatos.EIimporta EQ 0>
			<cfoutput>Este formato no est&aacute; habilitado para importaci&oacute;n.</cfoutput>
		<cfelseif Attributes.mode EQ "in" AND Attributes.exec EQ "yes">
			<cfthrow message="cfsifimportar: No se debe especificar mode='in' y exec='yes'">
		<cfelseif Attributes.mode EQ "in">
			<cfoutput>
				<iframe
					width ="#Attributes.width#"
					height="#Attributes.height#"
					frameborder="0"
					src="/cfmx/sif/importar/importar-form.cfm?fmt=#formatos.EIid#">
				</iframe>
			</cfoutput>
		<cfelse>
			<cfthrow message="El atributo mode debe ser in o out">
		</cfif>
	</cfif>
</cfif> <!--- ThisTag.ExecutionMode IS 'End' --->
<cfsetting enablecfoutputonly="no">