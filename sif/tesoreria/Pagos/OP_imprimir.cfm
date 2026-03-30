<cfparam name="Attributes.location">
<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>
<cfif form.chkImprimir EQ "1">
	<cfinclude template="imprOrdenPago.cfm">
	<cfoutput>
	<script language="javascript">
		fnImgPrint();
		window.setTimeout("location.href='#Attributes.location#'",1000);
	</script>
	</cfoutput>
	<cfabort>
<cfelse>
	<cfoutput>
	<script language="javascript">
	location.href = "#Attributes.location#";
	</script>
	</cfoutput>
</cfif>