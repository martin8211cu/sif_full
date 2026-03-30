<cfquery datasource="#session.DSN#">
	update Documentos
	set id_direccionFact = <cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#"><cfelse>id_direccionFact</cfif>
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
	  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>

<cfquery datasource="#session.DSN#">
	update HDocumentos
	set id_direccionFact = <cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#"><cfelse>id_direccionFact</cfif>
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
	  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>

<!--- NAVEGACION --->

<cfset navegacion = ''>
<cfif isdefined("form.fSNcodigo")>
	<cfset navegacion = navegacion & "&fSNcodigo=#form.fSNcodigo#" >
</cfif>
<cfif isdefined("form.fDdocumento")>
	<cfset navegacion = navegacion & "&fDdocumento=#form.fDdocumento#" >
</cfif>
<cfif isdefined("form.fCCTcodigo")>
	<cfset navegacion = navegacion & "&fCCTcodigo=#form.fCCTcodigo#" >
</cfif>
<cfif isdefined("form.fid_direccion")>
	<cfset navegacion = navegacion & "&fid_direccion=#form.fid_direccion#" >	
</cfif>
<cfif isdefined("form.fDfechadesde")>
	<cfset navegacion = navegacion & "&fDfechadesde=#form.fDfechadesde#" >
</cfif>
<cfif isdefined("form.fDfechahasta")>
	<cfset navegacion = navegacion & "&fDfechahasta=#form.fDfechahasta#" >
</cfif>
<cfif isdefined("form.fDusuario")>
	<cfset navegacion = navegacion & "&fDusuario=#form.fDusuario#" >
</cfif>
<cfif isdefined("form.SNcodigo") >
	<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#" >
</cfif>
<cfif isdefined("form.CCTcodigo") >
	<cfset navegacion = navegacion & "&CCTcodigo=#form.CCTcodigo#" >
</cfif>
<cfif isdefined("form.Ddocumento")>
	<cfset navegacion = navegacion & "&Ddocumento=#form.Ddocumento#" >
</cfif>
<cfset navegacion = replace(navegacion ,'##','','all')>
<cflocation url="adminDirecciones-modificar.cfm?dummy=ok#jsstringformat(navegacion)#">