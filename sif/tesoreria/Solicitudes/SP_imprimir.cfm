<cfparam name="Attributes.location">
<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>
<cfif form.chkImprimir EQ "1">
	<cfinclude template="imprSolicitPago.cfm">
	<cfoutput>
	<script language="javascript">
		window.setTimeout("location.href='#Attributes.location#'",1);
		fnImgPrint();
	</script>
	</cfoutput>
	<cfabort>
<cfelse>
	<cflocation url="#Attributes.location#">
</cfif>