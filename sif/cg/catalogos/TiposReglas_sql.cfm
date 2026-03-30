<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
	
		<cfquery name="rsVerifica" datasource="#Session.DSN#">
			select count(1) as total
			from PCReglaGrupo 
			where PCRGcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRGcodigo#"> 
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rsVerifica.total GT 0 >
			<cf_errorCode	code = "50233"
							msg  = "El codigo @errorDat_1@ ya está siendo utilizado por otro grupo"
							errorDat_1="#Form.PCRGcodigo#"
			>
		</cfif>
		
		<cftransaction>
		
		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into PCReglaGrupo (Ecodigo, PCRGcodigo, PCRGDescripcion, Cmayor, PCRGorden, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRGcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRGDescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cmayor#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCRGorden#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
			)
		  <cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsAlta">
		
		<cfquery name="rsUsu" datasource="#session.DSN#">				
		insert into PCUsuariosReglaGrp (
								PCRGid,
								Usucodigo,	
								Ecodigo,
								BMUsucodigo
								)
		values	( 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlta.identity#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 	
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
		</cfquery>
		
		</cftransaction>
		<cfset modo="ALTA">
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from PCReglaGrupo
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and PCRGid = <cfqueryparam value="#Form.PCRGid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo="BAJA">
		
	<cfelseif isdefined("Form.Cambio")>
		
		<cfquery name="rsVerifica" datasource="#Session.DSN#">
			select count(1) as total
			from PCReglaGrupo 
			where PCRGcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRGcodigo#"> 
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and PCRGid != <cfqueryparam value="#Form.PCRGid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif rsVerifica.total GT 0 >
			<cf_errorCode	code = "50233"
							msg  = "El codigo @errorDat_1@ ya está siendo utilizado por otro grupo"
							errorDat_1="#Form.PCRGcodigo#"
			>
		</cfif>		
		
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="PCReglaGrupo" 
			redirect="TiposReglas.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#session.Ecodigo#"			
			field2="PCRGid,numeric,#form.PCRGid#">			
			
		<cfquery name="rsCambio" datasource="#Session.DSN#">
			update PCReglaGrupo set
			PCRGcodigo = <cfqueryparam value="#Form.PCRGcodigo#" cfsqltype="cf_sql_varchar">,			
			PCRGDescripcion = <cfqueryparam value="#Form.PCRGDescripcion#" cfsqltype="cf_sql_varchar">,			
			Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cmayor#">,
			PCRGorden = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCRGorden#">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and PCRGid = <cfqueryparam value="#Form.PCRGid#" cfsqltype="cf_sql_numeric">
		</cfquery>	
	
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="TiposReglas.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="PCRGid" type="hidden" value="<cfif isdefined("Form.PCRGid") and modo NEQ 'ALTA'>#Form.PCRGid#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</cfoutput>		
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>


