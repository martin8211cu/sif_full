<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
<cfelse>
	<cfset tabChoice = 1>
</cfif> 

<cfset tabNames = ArrayNew(1)>

<cfset tabNames[1] = "Informaci&oacute;n General">
<cfset tabNames[2] = "Anotaciones">
<cfset tabNames[3] = "Depreciaci&oacute;n">
<cfset tabNames[4] = "Revaluaci&oacute;n">
<cfset tabNames[5] = "Mejora">	

<cfset tabLinks = ArrayNew(1)>

<script language="JavaScript" type="text/javascript">
	function gotoTab(tab, aid) {
		window.location.href = "Activos.cfm?o=" + tab + "&Aid=" + aid;
	}
</script>

<cfset tabLinks[1] = "javascript: gotoTab(1, #Form.Aid#);">
<cfset tabLinks[2] = "javascript: gotoTab(2, #Form.Aid#);">
<cfset tabLinks[3] = "javascript: gotoTab(3, #Form.Aid#);">
<cfset tabLinks[4] = "javascript: gotoTab(4, #Form.Aid#);">
<cfset tabLinks[5] = "javascript: gotoTab(5, #Form.Aid#);">

<cfset tabStatusText = ArrayNew(1)>

<cfset tabStatusText[1] = "Informaci&oacute;n General sobre el Activo">
<cfset tabStatusText[2] = "Mantenimiento de Anotaciones de el Activo">
<cfset tabStatusText[3] = "Depreciaciones aplicadas al Activo">
<cfset tabStatusText[4] = "Revaluaciones aplicadas al Activo">
<cfset tabStatusText[5] = "Mejoras aplicadas al Activo">	