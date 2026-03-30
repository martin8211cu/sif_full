<cfparam name="Attributes.location">
<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>
<cfif form.chkImprimir EQ "1">
<cfif isdefined ('form.tipo') and #form.tipo# eq 'ANTICIPO'>
	<cfinclude template="imprValeA_form.cfm">
<cfelse>
	<cfinclude template="imprVale_form.cfm">
</cfif>
	<cfoutput>
	<script language="javascript">
		fnImgPrint();
		window.setTimeout("location.href='#Attributes.location#'",1000);
	</script>
	</cfoutput>
	<cfabort>
<cfelse>
	<cflocation url="#Attributes.location#">
</cfif>


