<!--- Modifica la pregunta de Usuario --->
<cfif isdefined("form.preg") and form.preg eq 1>
	<cfquery name="upd_pregunta" datasource="asp">
		update Usuario
		set Usupregunta  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pregunta#">,
			Usurespuesta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.respuesta#">
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
</cfif>
<cfset error = 0>
<!--- datos incompletos --->
<cfif len(trim(form.oldpass)) eq 0 or len(trim(form.newpass)) eq 0 or len(trim(form.newpass2)) eq 0 >
	<cfset error = 1 >
</cfif>


<!--- EJB --->
<cfif error is 0>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfif not sec.cambiarPassword(form.oldpass, form.newpass)>
		<cfset error = 2>
	</cfif>
</cfif>

<cfif error is 0>
	<cflocation url="passch2.cfm">
</cfif>

<html><head></head><body>
<cfoutput>
<form action="passch.cfm" method="post" name="sql">
	<input name="error" type="hidden" value="#error#">
</form>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body></html>