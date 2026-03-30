<cfquery datasource="#session.dsn#">
	update CPNAP
	   set CPNAPcongelado = #url.OP#
	 where Ecodigo = #session.Ecodigo#
	   and CPNAPnum = #url.NAP#
</cfquery>
<script language="javascript">
	<cfoutput>
	<cfif url.OP EQ "1">
		alert("NAP #url.NAP# ha sido Congelado");
	<cfelse>
		alert("NAP #url.NAP# ha sido descongelado, ya se puede volver a utilizar");
	</cfif>
	</cfoutput>
</script>
