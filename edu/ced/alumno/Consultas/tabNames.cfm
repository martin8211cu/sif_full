<cfset tabChoice = 1>

<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "Datos Alumno">
<cfset tabNames[2] = "Datos Encargado">
<cfset tabLinks = ArrayNew(1)>
<!--- Se utiliza cuando el que consulta es el administrador --->
<!--- <cfif Session.Params.ModoDespliegue EQ 1> --->
	<script language="JavaScript" type="text/javascript">
		function gotoTab(tab, emp) {
			document.regAlum.o.value = tab;
			document.regAlum.persona.value = emp;
			document.regAlum.submit();
		}
	</script>

	<cfset tabLinks[1] = "javascript: gotoTab(1, #Form.persona#);">
	<cfset tabLinks[2] = "javascript: gotoTab(2, #Form.persona#);">
<!--- Se utiliza cuando el que consulta es el empleado --->
<!--- <cfelseif Session.Params.ModoDespliegue EQ 0>
	<cfset tabLinks[1] = "expediente-cons.cfm?o=1">
	<cfset tabLinks[2] = "expediente-cons.cfm?o=2">
</cfif> --->
<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "">
<cfset tabStatusText[2] = "">
<!--- <cfif Session.Params.ModoDespliegue EQ 1>
	<cfset tabStatusText[5] = "">
</cfif> --->

