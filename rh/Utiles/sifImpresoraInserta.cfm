<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.valor") and len(trim(url.valor)) and isdefined("url.descripcion") and len(trim(url.descripcion))>
	<cfquery name="rs" datasource="#session.DSN#">
		select 1
		from FAM012
		where FAM12CODD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.valor#">
	</cfquery>
	<cfif rs.recordCount EQ 0>
		<cfquery name="rs" datasource="#session.DSN#">
			insert into FAM012 (FAM12CODD, Ecodigo, FAM12DES, BMUsucodigo, fechaalta)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#url.valor#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.descripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#Now()#">
			)
		</cfquery>
	<cfelse>
		<cfquery name="rs" datasource="#Session.DSN#">
			update FAM012 set
				FAM12DES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.descripcion#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where FAM12CODD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.valor#">
		</cfquery>
	</cfif>
	
	<script language="JavaScript">
		var params ="";		
		params = "<cfoutput>&id=#url.id#&desc=#url.desc#&codigo=#url.codigo#</cfoutput>";	
		location.href="/rh/Utiles/sifImpresoraquery.cfm?valor=<cfoutput>#url.valor#&descripcion=#url.descripcion#&formulario=#url.formulario#</cfoutput>&campo=1" + params;
	</script>	
</cfif>




