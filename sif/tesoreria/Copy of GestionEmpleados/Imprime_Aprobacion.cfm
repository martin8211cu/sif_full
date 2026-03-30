<cfparam name="Attributes.location" default="">
<cfif isdefined ('url.TESSPid')>
	<cfinclude template="../Solicitudes/SP_imprimir.cfm">
	<cfreturn>
<cfelse>	
		<cfinclude template="ImprimeTransac.cfm">
		<cfoutput>
		<script language="javascript">
			fnImgPrint();
			window.setTimeout("location.href='#Attributes.location#'",1000);
		</script>
		</cfoutput>
		<cfabort>	
</cfif>

