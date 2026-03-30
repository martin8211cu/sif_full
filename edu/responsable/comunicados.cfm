
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Comunicados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/edu.css" rel="stylesheet" type="text/css">

</head>
<body>

<!--- <cfset Session.RolActual = 4> --->

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
		<td colspan="6" class="CeldaHdr" style="border-top:1px solid ##E6E6E6;"> 
			<cfif Session.RolActual eq 4>		<!--- Centro Educativo --->
			  COMUNICADO DEL CENTRO EDUCATIVO			
			<cfelseif Session.RolActual eq 5>	<!--- Docente --->			
			  COMUNICADO DE DOCENTE
			<cfelseif Session.RolActual eq 6>	<!--- Alumno --->
			  COMUNICADO DE ALUMNO			
			<cfelseif Session.RolActual eq 7>	<!--- Padre o Encargado --->		
			  COMUNICADO DEL ENCARGADO (A)			
			<cfelseif Session.RolActual eq 11>	<!--- Asistente --->		
			  COMUNICADO DE ASISTENTE
			<cfelseif Session.RolActual eq 12>	<!--- Director --->
			  COMUNICADO DE DIRECTOR (A)
			</cfif>				
		</td>
	  </tr>
	</table>

	<cfinclude template="formComunicado.cfm">
</body>
</html>
