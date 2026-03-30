<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Solicitud de Servicios</title>
</head>

<body>

	<cf_web_portlet_start titulo="Formulario para Solicitud de Servicios">

		<cfif isdefined("url.r")>
			<cfinclude template="prospectos-result.cfm">
		<cfelse>
			<cfinclude template="prospectos-form.cfm">
		</cfif>

	<cf_web_portlet_end> 

</body>
</html>
