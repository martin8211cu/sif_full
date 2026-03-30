<html>
<head>
<title>Administraci&oacute;n del Centro de Estudio</title>
<script type="text/javascript">
<cfif isdefined("Session.RolActual") and Session.RolActual EQ 4>
   location.href="/cfmx/edu/ced/index.cfm"
<cfelseif isdefined("Session.RolActual") and Session.RolActual EQ 5>
   location.href="/cfmx/edu/docencia/index.cfm"
<cfelseif isdefined("Session.RolActual") and Session.RolActual EQ 11>
   location.href="/cfmx/edu/asistencia/index.cfm"
<cfelse>
   location.href="/jsp/sdc"
</cfif>
</script>
</head>
<body>
</body>
</html>