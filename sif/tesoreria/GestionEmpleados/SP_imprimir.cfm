<cfparam name="Attributes.location" default="">
<cfif isdefined ('url.TESSPid')>
	<cfinclude template="../Solicitudes/SP_imprimir.cfm">
	<cfreturn>
<cfelse>
	<cf_navegacion name="chkImprimir" default="0">
	<cf_navegacion name="chkImprimir" session>

	
	<cfif form.chkImprimir EQ "1">
		<cfinclude template="LiquidacionImpresion_form.cfm">
		<cfoutput>
		<script language="javascript">
			window.setTimeout("location.href='#Attributes.location#'",1000);
			fnImgPrint();
		</script>
		</cfoutput>
		<cfabort>
	<cfelse>

		<cflocation url="#Attributes.location#">
	</cfif>
</cfif>

