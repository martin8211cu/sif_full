<cfif Not isdefined('form.Baja') and isdefined('url.Baja')>
	<cfset form.Baja = url.Baja>
</cfif>
<cfif Not isdefined('form.SNcodigo') and isdefined('url.SNcodigo')>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif Not isdefined('form.CDCcodigo') and isdefined('url.CDCcodigo')>
	<cfset form.CDCcodigo = url.CDCcodigo>
</cfif>
<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FACSnegocios"
		redirect="clientes_cred.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="SNcodigo"
		type1="integer"
		value1="#form.SNcodigo#" 
		
		field2="CDCcodigo"
		type2="integer"
		value2="#form.CDCcodigo#"> 
	
	<cfquery name="update" datasource="#session.DSN#">
		update FACSnegocios set
		CDCactivo = <cfif isdefined('form.CDCactivo')> 1, <cfelse> 0, </cfif>
		CDCDefault = <cfif isdefined('form.CDCDefault')> 1, <cfelse> 0, </cfif>
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_numeric">
		and CDCcodigo = <cfqueryparam value="#Form.CDCcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery> 

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FACSnegocios
	  where Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	    and SNcodigo  = <cfqueryparam value="#form.SNcodigo#"   cfsqltype="cf_sql_integer">
	    and CDCcodigo = <cfqueryparam value="#form.CDCcodigo#"  cfsqltype="cf_sql_numeric">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FACSnegocios( Ecodigo, SNcodigo, CDCcodigo, CDCactivo, CDCDefault, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">, 
		        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">,
				<cfif isdefined('form.CDCactivo')> 1,
				<cfelse> 0,
				</cfif>
				<cfif isdefined('form.CDCDefault')> 1,
				<cfelse> 0,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
</cfif> 

<form action="clientes.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio')>
			<input name="SNcodigo" type="hidden" value="#form.SNcodigo#"> 	
		</cfif>
		
		<input name="CDCcodigo" type="hidden" value="#form.CDCcodigo#"> 	
		
		<cfif isdefined('form.CDCidentificacion_F') and len(trim(form.CDCidentificacion_F))>
			<input type="hidden" name="CDCidentificacion_F" value="#form.CDCidentificacion_F#">	
		</cfif>
		<cfif isdefined('form.CDCnombre_F') and len(trim(form.CDCnombre_F))>
			<input type="hidden" name="CDCnombre_F" value="#form.CDCnombre_F#">	
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
