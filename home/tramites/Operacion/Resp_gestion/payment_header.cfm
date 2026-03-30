<cfquery datasource="#session.tramites.dsn#" name="carrito">
	select 45 as importe, 45 as saldo
	
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="total_header">
	select costo_requisito as saldo,costo_requisito as importe,moneda  from  TPRequisito
	where id_requisito   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">                
</cfquery>



<table width="100%" border="0">
<tr>
  <td colspan="2"><cfinclude template="hdr_persona.cfm"></td>
</tr>
<tr>
  <td valign="top"><cfinclude template="hdr_tramite.cfm"></td>
  <td valign="top"><cfinclude template="hdr_requisito.cfm">
</td>
</tr>
</table>

