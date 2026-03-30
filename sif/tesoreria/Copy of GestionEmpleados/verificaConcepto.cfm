<cfquery name="rsMonto" datasource="#session.dsn#">
	select montoI from GEconceptoGasto where GECid=#url.concepto#
</cfquery>
<cfset montoSolic=replace(url.monto,',','','ALL')>
	<cfif isdefined ('url.tc') and len(trim(url.tc)) gt 0>
		<cfset tc= url.tc>
	<cfelse>
		<cfset tc = 1>
	</cfif>
		
<!---<cfset TCsol=#form.GEAmanual#>
<cfset  FC= TCSol/TCdoc>--->
<cfset monto=montoSolic*tc>		
		
<cfif rsMonto.montoI gt 0>
	<cfif monto GT rsMonto.montoI>
		<script language="javascript">
			alert('El monto solicitado es mayor que el monto permitido, ingrese un monto menor');
			<cfif url.dir eq 1>
			window.parent.document.form1.MontoDetA.value='0.00';
			<cfelse>
			window.parent.document.formAntD.MontoDet.value='0.00';
			</cfif>
		</script>
	</cfif>
</cfif>
