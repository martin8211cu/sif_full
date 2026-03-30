<cfif isdefined("o")>
	<cfset tabChoice = Val(o)>
<cfelse>
	<cfset tabChoice = 1>
</cfif> 

<cfset tabNames = ArrayNew(1)>

<cfset tabNames[1] = "Par&aacute;metros">
<cfset tabNames[2] = "Varios">
<cfset tabNames[3] = "Formas de Pago">
<cfset tabNames[4] = "Otros">

<cfset tabLinks = ArrayNew(1)>

<script language="JavaScript" type="text/javascript">
	function gotoTab(tab) {
		window.location.href = "Parametros.cfm?o=" + tab;
	}
</script>
<!--- 
<cfset tabLinks[1] = "javascript: gotoTab(1, #Form.Aid#);">
<cfset tabLinks[2] = "javascript: gotoTab(2, #Form.Aid#);">
<cfset tabLinks[3] = "javascript: gotoTab(3, #Form.Aid#);">
<cfset tabLinks[4] = "javascript: gotoTab(4, #Form.Aid#);">
 --->
<cfset tabLinks[1] = "javascript: gotoTab(1);">
<cfset tabLinks[2] = "javascript: gotoTab(2);">
<cfset tabLinks[3] = "javascript: gotoTab(3);">
<cfset tabLinks[4] = "javascript: gotoTab(4);">

<cfset tabStatusText = ArrayNew(1)>

<cfset tabStatusText[1] = "Par&aacute;metros Generales">
<cfset tabStatusText[2] = "Par&aacute;metros Varios">
<cfset tabStatusText[3] = "Par&aacute;metros referentes a Formas de Pago">
<cfset tabStatusText[4] = "Otros Par&aacute;metros">