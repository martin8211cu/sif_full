<!--- <cfdump var="#form#">
<cfabort> --->
<cfif IsDefined("form.Cambio")>
 	<cfquery  name="idquery" datasource="#session.DSN#">
			update AnexoGOficina	set
				GOcodigo 		= <cfqueryparam value="#form.GOcodigo#" cfsqltype="cf_sql_char">,
				GOnombre		= <cfqueryparam value="#Form.GOnombre#" cfsqltype="cf_sql_char">,
				BMfecha 		= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				BMUsucodigo		= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				GOTid			= <cfqueryparam value="#form.GOTid#" 	cfsqltype="cf_sql_numeric" null="#form.GOTid EQ ""#">
			where GOid 			= <cfqueryparam value="#Form.GOid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfset path = "gruposOficinas-tabs.cfm">
	
<cfelseif IsDefined("form.Baja")>
	
	<!--- Elimina de la tabla AnexoGOficinasDet --->
	<cfquery datasource="#session.dsn#" name="idquery">
			delete from AnexoGOficinaDet
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 	and GOid = <cfqueryparam value="#Form.GOid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<!--- Elimina de la tabla AnexoGOficinas --->
	<cfquery datasource="#session.dsn#" name="idquery">
	   	 delete from AnexoGOficina
	  	 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 and GOid = <cfqueryparam value="#Form.GOid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<!--- redirecciona a la pagina principal --->
	<cfset path = "gruposOficinas.cfm">

<cfelseif IsDefined("form.Alta")>
	<cftransaction>
	<cfquery datasource="#session.dsn#" name="idquery">
		insert into AnexoGOficina( Ecodigo, GOcodigo, GOnombre, BMfecha,BMUsucodigo,GOTid)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.GOcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.GOnombre#">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam value="#form.GOTid#" 	cfsqltype="cf_sql_numeric" null="#form.GOTid EQ ""#">
			)
				
		
		 <cf_dbidentity1 datasource="#session.dsn#" name="idquery">
	</cfquery>
	<cf_dbidentity2 datasource="#session.dsn#" name="idquery">
	
	</cftransaction>
	
	<!--- redirecciona al form en el tab 2--->
	<cfset path = "gruposOficinas-tabs.cfm?tab=2">
	
<cfelseif IsDefined("form.Nuevo")>
	<cfset path = "gruposOficinas-tabs.cfm">
</cfif>

<form action="<cfoutput>#path#</cfoutput>" method="post" name="sql">
	<cfoutput>
		
		<cfif isdefined('form.Alta') and isdefined("idquery.identity") and not isdefined('form.Cambio') and not isdefined('form.Baja')>
			<input name="GOid" type="hidden" value="#idquery.identity#"> 
		</cfif>
		
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="GOid" type="hidden" value="#form.GOid#"> 
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
