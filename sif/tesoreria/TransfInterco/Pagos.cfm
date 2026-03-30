<cfset LvarTESTILestado = 10>
<cfif isdefined("url.OPnum")>
	<script language="javascript">
		alert('Se generó la Orden de Pago Num.<cfoutput>#url.OPnum#</cfoutput>');
	</script>
</cfif>
<cfinclude template="Transferencias.cfm">
