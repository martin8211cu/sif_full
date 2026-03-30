<cfparam name="Attributes.location" default="">
<cfif isdefined ('url.TESSPid')>
	<cfinclude template="../sif/tesoreria/Solicitudes/SP_imprimir.cfm">
	<cfreturn>
<cfelse>
	<cf_navegacion name="chkImprimir" default="0">
	<cf_navegacion name="chkImprimir" session>
	<cfif form.chkImprimir EQ "1">
        	<cfinclude template="../sif/tesoreria/Solicitudes/imprSolicitPago.cfm">
            <script language="javascript">
                fnImgPrint();
            </script>
	<cfelse>

		<cfoutput>
		<script language="javascript">
			window.parent.document.form1.action = "tesoreria.cfm";
			window.parent.document.form1.submit();
		</script>
		</cfoutput>
	</cfif>
</cfif>