<cfset Request.Error.Url = "gestion.cfm?cli=#form.cli#&lpaso=#Form.lpaso#&cpaso=#Form.cpaso#&cue=#Form.cue#&pkg=#Form.pkg#&logg=#Form.logg#">
<cfparam name="Form.rol" default="DAS">

<cfquery datasource="#session.DSN#" name="rsLogDatos">
	select 	LGnumero,LGlogin,Contratoid,Snumero,LGrealName,LGmailQuota,LGroaming,LGprincipal,LGapertura,LGcese,LGserids,Habilitado,LGbloqueado,LGmostrarGuia,LGtelefono
	from 	ISBlogin 
	where 	LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
			and Habilitado =1
</cfquery>
<cfquery datasource="#session.DSN#" name="rsCuent">
	select 	case when CUECUE = 0 then 'Por Asignar'
			else <cf_dbfunction name="to_char" args="CUECUE" datasource="#session.DSN#"> end as CUECUE
	from 	ISBcuenta
	where 	CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">			
</cfquery>
<cfquery datasource="#session.DSN#" name="rsPQ">
	select 	distinct b.PQnombre
	from 	ISBproducto a
			inner join ISBpaquete b
			on b.PQcodigo = a.PQcodigo
	where 	Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">			
</cfquery>

<cfset mens ="">
<cfif isdefined("form.lpaso") and form.lpaso EQ 1>		<!---login apply--->
	<cfinclude template="gestion-log-apply.cfm">
	
	
<cfelseif isdefined("form.lpaso") and form.lpaso EQ 2>	<!---telefono apply--->
	<cfinclude template="gestion-login-Telefono-apply.cfm">
	
<cfelseif isdefined("form.lpaso") and form.lpaso EQ 3>	<!---Realname apply--->
	<cfinclude template="gestion-login-RealName-apply.cfm">
	
<cfelseif isdefined("form.lpaso") and form.lpaso EQ 4>	<!---password apply--->
	<cfinclude template="gestion-login-Password-apply.cfm">
	
<cfelseif isdefined("form.lpaso") and form.lpaso EQ 5>	<!---password global apply--->
	<cfinclude template="gestion-login-PasswordGlobal-apply.cfm">
	
<cfelseif isdefined("form.lpaso") and form.lpaso EQ 6>	<!---forwarding apply--->
	<cfinclude template="gestion-login-forwarding-apply.cfm">

<cfelseif isdefined("form.lpaso") and form.lpaso EQ 7>	<!---Sobre apply--->
	<cfinclude template="gestion-login-sobre-apply.cfm">
	
<cfelseif isdefined("form.lpaso") and form.lpaso EQ 8>	<!---bloqueo apply--->
	<cfinclude template="gestion-login-bloqueo-apply.cfm">

<cfelseif isdefined("form.lpaso") and form.lpaso EQ 9>	<!--- retiro--->
	<cfinclude template="gestion-login-retiro-apply.cfm">

</cfif>

<cfinclude template="gestion-redirect.cfm">