
<!--- <cfdump var="#form#">
  <cfdump var="#url#"> 
  <cfdump label="dia:" var="#DayofWeekAsString(DayOfWeek(form.RHJMUfecha))#">
<cfdump label="dia:" var="#DayOfWeek(form.RHJMUfecha)#"> 
<cfabort>    --->

<cfif IsDefined("form.Cambio")>
	
	<cfquery name="update" datasource="#session.DSN#">
		update RHJustificacionMarcasUsuario set
			DEid= <cfqueryparam value="#form.DEid1#" cfsqltype="cf_sql_numeric">,
			RHJMUfecha= <cfqueryparam value="#LSDateFormat(LSParseDateTime(form.RHJMUfecha), 'yyyy-mm-dd 00:00:00')#" cfsqltype="cf_sql_timestamp">,
			RHJMUjustificacion=<cfqueryparam value="#form.RHJMUjustificacion#"cfsqltype="cf_sql_varchar">,
			RHJMUsituacion=<cfqueryparam value="#form.RHIid#" cfsqltype="cf_sql_integer">
			
		where RHJMUid = <cfqueryparam value="#form.RHJMUid#" cfsqltype="cf_sql_numeric">
	</cfquery> 
	
	<cflocation url="justificacionAdelantadaMarca-jefe.cfm?RHJMUid=#form.RHJMUid#">
</cfif>

<cfif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from RHJustificacionMarcasUsuario
	  	 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 and RHJMUid = <cfqueryparam value="#form.RHJMUid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cflocation url="justificacionAdelantadaMarca-jefe.cfm">
</cfif>

<cfif IsDefined("form.Alta")>
	
	<cfquery datasource="#session.dsn#">
		insert into RHJustificacionMarcasUsuario( Ecodigo, DEid, RHJMUsituacion, RHJMUfecha,RHJMUjustificacion,BMUsucodigo,RHJMUprocesada,BMfecha)
		values(	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#form.DEid1#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#form.RHIid#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#LSDateFormat(LSParseDateTime(form.RHJMUfecha), 'yyyy-mm-dd 00:00:00')#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value ="#form.RHJMUjustificacion#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				0,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)
	</cfquery>	
	
	<cflocation url="justificacionAdelantadaMarca-jefe.cfm"> 
</cfif>

<cfif IsDefined("form.NUEVO")>
	<cflocation url="justificacionAdelantadaMarca-jefe.cfm"> 
</cfif>

