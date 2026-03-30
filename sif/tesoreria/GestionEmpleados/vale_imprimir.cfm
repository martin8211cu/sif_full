<cfparam name="Attributes.id">
<cfparam name="Attributes.tipo">
<cfparam name="Attributes.location">

<cfset form.id = Attributes.id>

<cfinclude template="vale_imprimir_#Attributes.tipo#.cfm">

<cfoutput>
<script language="javascript">
	fnImgPrint();
	window.setTimeout("window.location.replace('#Attributes.location#');",1000);
</script>
</cfoutput>
<cfabort>
