<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Validar usuario</title>
</head>

<body style="margin:0">

<cfsilent>
	<cfinvoke component="home.Componentes.ValidarPassword" method="validar" 
		data="#data#" user="#form.test_user#" pass="#form.test_pass#" returnvariable="r"/>
	<cfset msg = ''>
	<cfloop from="1" to="#ArrayLen(r.erruser)#" index="i">
		<cfset msg = msg & '\n - ' & r.erruser[i]>
	</cfloop>
	<cfloop from="1" to="#ArrayLen(r.errpass)#" index="i">
		<cfset msg = msg & '\n - ' & r.errpass[i]>
	</cfloop>
</cfsilent>

<cfoutput>

<script type="text/javascript">
<cfif Len(msg)>
	alert('Valide lo siguiente: #msg#');
<cfelse>
	alert('Usuario y contraseña válidos');
</cfif>
</script>

</cfoutput>
</body>
</html>
