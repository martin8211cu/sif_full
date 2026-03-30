<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Validación</title>
</head>

<body>
<cfif isdefined("url.username") and len(trim(url.username)) gt 0>
	<cfquery name="rsLogin" datasource="asp">
		select Usulogin 
		from Usuario 
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		  and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.username)#">
	</cfquery>
	
	<cfif rsLogin.RecordCount gt 0>
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.frmUsuarios.username.value = '';
			window.parent.alert('Se presentaron los siguientes errores:\n - El login que desea asignar al Usuario ya existe');
		</script>
	</cfif>
</cfif>
<cfif IsDefined('url.username') and Len(Trim(url.username)) and 
	IsDefined('url.password') and Len(Trim(url.password)) >
	
	<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="dataPoliticas" CEcodigo="#session.CEcodigo#"/>
	<cfinvoke component="home.Componentes.ValidarPassword" method="validar" returnvariable="valida"
		data="#dataPoliticas#" user="#url.username#" pass="#url.password#" />

	<cfif ArrayLen(valida.erruser) Or ArrayLen(valida.errpass)>
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.frmUsuarios.password.value = '';
			window.parent.document.frmUsuarios.password2.value = '';
			window.parent.alert('Se detectaron los siguientes errores: '
			<cfoutput>
				<cfloop from="1" to="#ArrayLen(valida.erruser)#" index="i">+'\n - #JSStringFormat(valida.erruser[i] )#'</cfloop>
				<cfloop from="1" to="#ArrayLen(valida.errpass)#" index="i">+'\n - #JSStringFormat(valida.errpass[i] )#'</cfloop>
			</cfoutput>
			);
		</script>
	</cfif>
</cfif>
</body>
</html>
