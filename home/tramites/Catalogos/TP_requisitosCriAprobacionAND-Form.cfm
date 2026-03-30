<cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfparam name="form.id_requisito" default="#url.id_requisito#">
	
</cfif>

<cfquery name="combo" datasource="#session.tramites.dsn#">
		select es_criterio_and
		from TPRequisito  
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_requisito#">
</cfquery>

<cfoutput>	
<form method="post" name="form2" action='TP_requisitosCriAprobacionAND-sql.cfm?id_requisito=#JSStringFormat(form.id_requisito)#' >
	
	<input type="hidden" name="id_requisito" value="#form.id_requisito#">
	<table width="100%" border="0" align="left" cellpadding="0">
  		
		<tr>
			<td  align="right"> 
				<input  onChange="javascript:enviar();" <cfif #combo.es_criterio_and# EQ 1>checked</cfif> name="radio" id="r1" value="1" type="radio"></td>
			<td   align="left"> <label for="r1">Debe cumplir los criterios (AND)</label> </td>
		<!--- </tr>
		<tr> --->
			<td  align="right"> 
				<input onChange="javascript:enviar();" <cfif #combo.es_criterio_and# EQ 0>checked</cfif> name="radio" id="r2" value="0" type="radio"></td>
			<td   align="left"><label for="r2">Debe cumplir al menos uno (OR) </label> </td>
		</tr>
		
	</table>
</form>

</cfoutput>

<script language="JavaScript">
function enviar() {
	document.form2.submit();
}
</SCRIPT> 


