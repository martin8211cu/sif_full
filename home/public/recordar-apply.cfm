<cfparam name="form.empresa" default="">
<cfparam name="form.login"   default="">
<cfparam name="form.retry"   type="numeric" default="0">
<cfparam name="form.error"   default="">

<!--- Solo permite digitar la respuesta a la pregunta 2 veces, si no logra acertar la respuesta en esas 2 oportunidades
		despliega de nuevo la p[agina de logueo para introducir el login y password para empezar el proceso de nuevo --->
<cfif isdefined('form.retry') and form.retry GT 2>
	<cfset action = 'recordar-imposible.cfm'>
<cfelse>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset loginCEid = sec.buscarAliasLogin(form.empresa)>
	<cfquery name="QRY_usuario" datasource="asp">
		select Usucodigo, Usupregunta as pregunta, Usurespuesta as respuesta
		from Usuario
		where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.login#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#loginCEid#">
		  and Utemporal = 0
	</cfquery>
	
	<cfif form.login EQ "pso" OR QRY_usuario.recordCount EQ 0
		OR Len(Trim(QRY_usuario.pregunta)) EQ 0  OR Len(Trim(QRY_usuario.respuesta)) EQ 0>
		<cfset action = 'recordar-imposible.cfm?d=#loginCEid#'>
	<cfelse>
		<cfset action = 'recordar.cfm'>
		
		<cfif isdefined('form.respuesta') and form.respuesta NEQ ''>
			<cfset error = ''>
			<cfif UCase(Trim(form.respuesta)) NEQ UCase(Trim(QRY_usuario.respuesta))>
				<cfset error = 'La respuesta no coincide con nuestros registros'>
			<cfelse>
				<cfif sec.generarPassword(QRY_usuario.Usucodigo, true)>
					<cfset action = 'recordar-fin.cfm'>
				<cfelse>
					<cfset action = 'recordar-imposible.cfm?c=#loginCEid#'>
				</cfif>
			</cfif>		
		</cfif>
	</cfif>
</cfif>

<html>
<head>
</head>
<body>
<cfoutput>
	<form action="#action#" method="post">
		<input type="hidden" name="login" value="#form.login#">
		<input type="hidden" name="empresa" value="#form.empresa#">
		<cfif isdefined('QRY_usuario') and QRY_usuario.recordCount GT 0>
			<input type="hidden" name="pregunta" value="#QRY_usuario.pregunta#">
			<input type="hidden" name="retry" value="#form.retry + 1#">			
			<cfif isdefined('error') and error NEQ ''>
				<input type="hidden" name="error" value="#error#">
			</cfif>
		</cfif>
	</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>

</body>
</HTML>