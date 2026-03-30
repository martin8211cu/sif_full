
<cfif IsDefined("form.Cambio")>
 <cftransaction>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="FATiposBono" 
			redirect="tiposBonos.cfm"
			timestamp="#form.ts_rversion_Bon#"
			field1="IdTipoBn,numeric,#form.IdTipoBn#">
	
		<cfquery name="update" datasource="#session.DSN#">
			update FATiposBono	set
				BNCodigo = <cfqueryparam value="#form.BNCodigo#" cfsqltype="cf_sql_char">,
				BNDescripcion = <cfqueryparam value="#Form.BNDescripcion#" cfsqltype="cf_sql_char">,
				BNComplementoCF = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BNComplemento#">,
				BNFecha_Vence = <cfqueryparam value="#LSParseDateTime(Form.BNFecha)#" cfsqltype="cf_sql_timestamp">,
				BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
				
			where IdTipoBn = <cfqueryparam value="#Form.IdTipoBn#" cfsqltype="cf_sql_numeric">
		</cfquery> 
</cftransaction>	
	
	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from FATiposBono
	  	 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 and IdTipoBn = <cfqueryparam value="#Form.IdTipoBn#" cfsqltype="cf_sql_numeric">
	</cfquery> 

<cfelseif IsDefined("form.Alta")>
	<cftransaction>
		<cfquery name="rsAlta" datasource="#session.dsn#">
			insert into FATiposBono( Ecodigo, BNCodigo, BNDescripcion, BNComplementoCF, BNFecha_Vence,BMUsucodigo,BNfechaalta)
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.BNCodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value = "#form.BNDescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_char" value = "#form.BNComplemento#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.BNFecha)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
				<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>			
		<cf_dbidentity2 datasource="#session.DSN#" name="rsAlta">
	</cftransaction>	
	
	<cfif isdefined('rsAlta')>
		<cfset form.IdTipoBn = rsAlta.identity>
	</cfif>
</cfif>

<form action="tiposBonos.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') or isdefined('form.Alta') and isdefined('form.IdTipoBn') and not isdefined('form.Baja')>
			<input name="IdTipoBn" type="hidden" value="#form.IdTipoBn#"> 
		</cfif>
				
		<cfif isdefined('form.Codigo_F') and len(trim(form.Codigo_F))>
			<input type="hidden" name="Codigo_F" value="#form.Codigo_F#">	
		</cfif>
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
			<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">	
		</cfif>
		<cfif isdefined('form.Fecha_F') and len(trim(form.Fecha_F))>
			<input type="hidden" name="Fecha_F" value="#form.Fecha_F#">	
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

