



<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfset form.id_tramite = url.id_tramite >
</cfif>
<cfif isdefined("url.id_requisito") and not isdefined("form.id_requisito")>
	<cfset form.id_requisito = url.id_requisito >
</cfif>
<cfif isdefined("url.id_persona") and not isdefined("form.id_persona")>
	<cfset form.id_persona = url.id_persona >
</cfif>


<cfquery datasource="#session.tramites.dsn#" name="carrito">
	select 45 as importe, 45 as saldo
	
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="RSTramite">
	select nombre_tramite  from  TPTramite
	where id_tramite   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">                
</cfquery>


<cfquery datasource="#session.tramites.dsn#" name="total_header">
	select costo_requisito as saldo,costo_requisito as importe,moneda,nombre_requisito  from  TPRequisito
	where id_requisito   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">                
</cfquery>


<table border="0" align="center" width="510" cellpadding="0"  cellspacing="0">
	<cfoutput>
	<cfif not isdefined("form.imprimir")>
	<tr>
		<td colspan="2" bgcolor="##ECE9D8" style="font-size:20px; padding:3px; "><strong>#RSTramite.nombre_tramite#</strong></td>
	</tr>
	<cfelse>
	<tr>
		<td  width="70%" bgcolor="##ECE9D8" style="font-size:20px; padding:3px; "><strong>#RSTramite.nombre_tramite#</strong></td>
  		<td   valign="top" align="right" bgcolor="##ECE9D8"><a href="javascript:imprimir()">Imprimir</a></td>
	</tr>	
	</cfif> 
	<tr>
		<td  colspan="2" bgcolor="##ECE9D8" style="font-size:18px; padding:3px; "><strong>#total_header.nombre_requisito#</strong></td>
	</tr>
	<tr>
	  <td   colspan="2"><cfinclude template="hdr_persona.cfm"></td>
	</tr>
	</cfoutput>
</table>

