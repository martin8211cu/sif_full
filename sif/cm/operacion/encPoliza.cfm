<!--- Moneda Local --->
<cfquery name="rsPolizaDesal" datasource="#Session.DSN#">
	Select EPDid,EPDnumero,EPDdescripcion
	from EPolizaDesalmacenaje
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
	and EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid_DP#">
</cfquery>
<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>



<cfif isdefined('rsPolizaDesal') and rsPolizaDesal.recordCount GT 0>
	<cfoutput>
		<table width="100%"  border="0" class="areaFiltro">
		  <tr>
			<td class="style1"><strong>P&oacute;liza de Desalmacenaje: &nbsp;&nbsp;&nbsp;&nbsp;</strong>#rsPolizaDesal.EPDdescripcion#&nbsp;&nbsp;--&nbsp;&nbsp;#rsPolizaDesal.EPDnumero#</td>
			<td><a href='##' onClick="javascript:location.href = 'polizaDesalmacenaje.cfm?EPDid=#rsPolizaDesal.EPDid#'">Ir a la Póliza</a></td>
		  </tr>
		</table>
	</cfoutput>		
</cfif>
