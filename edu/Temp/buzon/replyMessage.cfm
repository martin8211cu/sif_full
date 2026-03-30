<cfset roles = "edu.admin, edu.docente, edu.estudiante, edu.encargado, edu.asistente, edu.director">
<cfset rolesDesc = "Administrador del Centro de Estudios, Docente, Estudiante, Padre de Familia o Encargado, Asistente, Director">
<cfset rolCod = "4, 5, 6, 7, 11, 12">

<cfinclude template="common.cfm">


<HTML>
<head>
</head>
<body>
<form action="sendMessage-result.cfm" method="post" name="sql">
	<input name="NoEnviados" type="hidden" value="<cfoutput>#NoEnviados#</cfoutput>">
</form>
<script language="JavaScript" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
