<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM023"
		redirect="mensajes.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="FAM23COD"
		type1="integer"
		value1="#form.FAM23COD#" >

	<cfquery name="update" datasource="#session.DSN#">
		update FAM023
		set FAM23DES = <cfqueryparam value="#Form.FAM23DES#" cfsqltype="cf_sql_char">,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM23COD = <cfqueryparam value="#Form.FAM23COD#" cfsqltype="cf_sql_integer">
	</cfquery> 



<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from FAM023
	  	 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 and FAM23COD = <cfqueryparam value="#Form.FAM23COD#" cfsqltype="cf_sql_integer">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<!--- DETERMINA CUAL ES EL ULTIMO REGISTRO Y LE SUMA 1 PARA CREAR OTRO REG--->
	<cfquery name="Ult_reg" datasource="#session.dsn#">
		select coalesce(max(FAM23COD),0)+1 as FAM23COD
		from FAM023
	</cfquery>

	<cfquery datasource="#session.dsn#">
		insert into FAM023( Ecodigo, FAM23COD, FAM23DES, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Ult_reg.FAM23COD#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAM23DES#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>			
</cfif>

<form action="mensajes.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FAM23COD" type="hidden" value="#form.FAM23COD#"> 
		</cfif>
				
		<cfif isdefined('form.FAM23DES_F') and len(trim(form.FAM23DES_F))>
			<input type="hidden" name="FAM23DES_F" value="#form.FAM23DES_F#">	
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

