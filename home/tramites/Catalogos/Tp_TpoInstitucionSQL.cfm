<cfparam name="modo" default="ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="ABC_TpoIden" datasource="#session.tramites.dsn#">
			insert into TPTipoInst (codigo_tipoinst ,nombre_tipoinst,BMUsucodigo,BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_char"    value="#UCase(Form.codigo_tipoinst)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tipoinst#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_TpoIden" datasource="#session.tramites.dsn#">			
			delete TPTipoInst 
			where  id_tipoinst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipoinst#">				  
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTipoInst"
			redirect="Tp_TpoRequisitos.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_tipoinst" 
			type1="numeric" 
			value1="#form.id_tipoinst#">
		<cfquery name="ABC_TpoIden" datasource="#session.tramites.dsn#">			
			update TPTipoInst set 
			codigo_tipoinst 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_tipoinst)#">, 
			nombre_tipoinst 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tipoinst#">, 
			BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
			BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where  id_tipoinst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipoinst#">
		</cfquery>
		<cfset modo="CAMBIO">				  				  
	</cfif>			
</cfif>

<form action="Tp_TpoInstitucion.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="id_tipoinst" type="hidden" value="<cfif isdefined("Form.id_tipoinst")><cfoutput>#Form.id_tipoinst#</cfoutput></cfif>">
	</cfif>
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
