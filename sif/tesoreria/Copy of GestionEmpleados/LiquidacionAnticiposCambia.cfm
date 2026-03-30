<!----- Realiza el calculo  de los valores del viatico monto real contra tipo de cambio ------->
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	<cfif isdefined ('url.montoReal') and isdefined ('url.GELVtipoCambio') and isdefined ('url.Linea')>
		<cfset Monto=#url.montoReal# * #url.GELVtipoCambio#>		
		window.parent.document.formDet.GELVmonto[#url.Linea#].value = "#LSNumberFormat(Monto,'9,9.99')#";	
	</cfif>
</script>
</cfoutput>
