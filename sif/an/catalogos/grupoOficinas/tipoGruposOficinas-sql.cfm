<!--- <cfdump var="#form#">
<cfabort> --->
<cfset path = "tipoGruposOficinas.cfm">
<cfif IsDefined("form.Cambio")>
 	<cfquery  name="idquery" datasource="#session.DSN#">
			update AnexoGOTipo	set
				GOTcodigo 		= <cfqueryparam value="#form.GOTcodigo#" cfsqltype="cf_sql_char">,
				GOTnombre		= <cfqueryparam value="#Form.GOTnombre#" cfsqltype="cf_sql_char">,
				BMfecha 		= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				BMUsucodigo		= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where GOTid 			= <cfqueryparam value="#Form.GOTid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfset path = "tipoGruposOficinas.cfm">
	
<cfelseif IsDefined("form.Baja")>
	
	<!--- Elimina de la tabla AnexoGOTipos --->
	<cfquery datasource="#session.dsn#" name="idquery">
	   	 delete from AnexoGOTipo
	  	 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 and GOTid = <cfqueryparam value="#Form.GOTid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<!--- redirecciona a la pagina principal --->
	<cfset path = "tipoGruposOficinas.cfm">

<cfelseif IsDefined("form.Alta")>
	<cftransaction>
	<cfquery datasource="#session.dsn#" name="idquery">
		insert into AnexoGOTipo( Ecodigo, GOTcodigo, GOTnombre, BMfecha,BMUsucodigo)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.GOTcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.GOTnombre#">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		
		 <cf_dbidentity1 datasource="#session.dsn#" name="idquery">
	</cfquery>
	<cf_dbidentity2 datasource="#session.dsn#" name="idquery">
	
	</cftransaction>
	
	<cfset path = "tipoGruposOficinas.cfm">
	
<cfelseif IsDefined("form.Nuevo")>
	<cfset path = "tipoGruposOficinas-form.cfm">
</cfif>

<form action="<cfoutput>#path#</cfoutput>" method="post" name="sql">
	<cfoutput>
		
		<cfif isdefined('form.Alta') and isdefined("idquery.identity") and not isdefined('form.Cambio') and not isdefined('form.Baja')>
			<input name="GOTid" type="hidden" value="#idquery.identity#"> 
		</cfif>
		
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="GOTid" type="hidden" value="#form.GOTid#"> 
		</cfif>
				
		<cfif isdefined('form.Codigo_F') and len(trim(form.Codigo_F))>
			<input type="hidden" name="Codigo_F" value="#form.Codigo_F#">	
		</cfif>
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
			<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">	
		</cfif>
		
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
