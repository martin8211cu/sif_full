<cfparam name="modo" default="ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="ABC_TpoIden" datasource="#session.tramites.dsn#">
			insert into TPTipoServGlobal (codigo_tiposervg ,nombre_tiposervg,BMUsucodigo,BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_char"    value="#UCase(Form.codigo_tiposervg)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tiposervg#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">	)
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_TpoIden" datasource="#session.tramites.dsn#">			
			delete TPTipoServGlobal 
			where  id_tiposervg = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tiposervg#">				  
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTipoServGlobal"
			redirect="tipo-servicio-global.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_tiposervg" 
			type1="numeric" 
			value1="#form.id_tiposervg#">
		<cfquery datasource="#session.tramites.dsn#">			
			update TPTipoServGlobal set 
			codigo_tiposervg 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_tiposervg)#">, 
			nombre_tiposervg 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tiposervg#">, 
			BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
			BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where  id_tiposervg = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tiposervg#">
		</cfquery>
		<cfset modo="CAMBIO">				  				  
	</cfif>			
</cfif>

<form action="tipo-servicio-global.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="id_tiposervg" type="hidden" value="<cfif isdefined("Form.id_tiposervg")><cfoutput>#Form.id_tiposervg#</cfoutput></cfif>">
	</cfif>
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
