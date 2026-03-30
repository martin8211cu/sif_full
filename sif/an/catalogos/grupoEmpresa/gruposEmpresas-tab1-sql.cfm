<!--- <cfdump var="#form#">
<cfabort> --->
<cfif IsDefined("form.Cambio")>
 	<cfquery  name="idquery" datasource="#session.DSN#">
			update AnexoGEmpresa	set
				GEcodigo 		= <cfqueryparam value="#form.GEcodigo#" cfsqltype="cf_sql_char">,
				GEnombre		= <cfqueryparam value="#Form.GEnombre#" cfsqltype="cf_sql_char">,
				BMfecha 		= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				BMUsucodigo		= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where GEid 			= <cfqueryparam value="#Form.GEid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset path = "gruposEmpresas-tabs.cfm">
	
<cfelseif IsDefined("form.Baja")>
	
	<!--- Elimina de la tabla AnexoGEmpresasDet --->
	<cfquery datasource="#session.dsn#" name="idquery">
			delete from AnexoGEmpresaDet
			where GEid = <cfqueryparam value="#Form.GEid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<!--- Elimina de la tabla AnexoGEmpresas --->
	<cfquery datasource="#session.dsn#" name="idquery">
	   	 delete from AnexoGEmpresa
	  	 where CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype = "cf_sql_numeric"> 
	   	 and GEid = <cfqueryparam value="#Form.GEid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<!--- redirecciona a la pagina principal --->
	<cfset path = "gruposEmpresas.cfm">

<cfelseif IsDefined("form.Alta")>
	<cftransaction>
	<cfquery datasource="#session.dsn#" name="idquery">
		insert into AnexoGEmpresa( CEcodigo, GEcodigo, GEnombre, BMfecha,BMUsucodigo)
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.GEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.GEnombre#">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		
		 <cf_dbidentity1 datasource="#session.dsn#" name="idquery">
	</cfquery>
	<cf_dbidentity2 datasource="#session.dsn#" name="idquery">
	
	</cftransaction>
	
	<!--- redirecciona al form en el tab 2--->
	<cfset path = "gruposEmpresas-tabs.cfm?tab=2">
	
<cfelseif IsDefined("form.Nuevo")>
	<cfset path = "gruposEmpresas-tabs.cfm">
</cfif>

<form action="<cfoutput>#path#</cfoutput>" method="post" name="sql">
	<cfoutput>
		
		<cfif isdefined('form.Alta') and isdefined("idquery.identity") and not isdefined('form.Cambio') and not isdefined('form.Baja')>
			<input name="GEid" type="hidden" value="#idquery.identity#"> 
		</cfif>
		
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="GEid" type="hidden" value="#form.GEid#"> 
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
