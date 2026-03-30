<cfset form.modo_errores = modo_errores>
<!--- Etiqueta para Indicar al Usuario la empresa que se esta ejecutando --->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>	
<cfquery name="rsNombre" datasource="preicts">
	select min(acct_full_name) as acct_full_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>
<cfset etiquetaT = "#rsNombre.acct_full_name#">

<cfinclude template="lista-query.cfm">
<cf_htmlreportsheaders
title="#titulo#" 
filename="#directorio#-#Session.Usucodigo#.xls" 
ira="index.cfm?botonsel=btnLista">
<cf_templatecss>

<cfflush interval="512">
<cfset MostrarFactor = (modo_errores neq "1") and (directorio is "swaps-nofact")>
<cfset MostrarCobertura =  (directorio is "swaps-nofact" or directorio is "swaps-fact")>

<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
<tr>
	<td colspan="2">&nbsp;</td>
	<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
</tr>					
<tr>
	<td style="font-size:16px" align="center" colspan="3">
	<strong>#etiquetaT#</strong>	
	</td>
</tr>
<tr>
	<td style="font-size:16px" align="center" colspan="3">
	<strong>#HTMLEditFormat(titulo)#</strong>
	</td>
</tr>
<tr>
	<td colspan="3">&nbsp;</td>
</tr>
</table>
<table width="100%" border="0">
<tr>
	<td nowrap><strong>Contrato</strong></td>
	<td nowrap><strong>Documento</strong></td>
	<cfif MostrarCobertura>
		<td nowrap><strong>Cobertura</strong></td>
	</cfif>
	<td nowrap align="left"><strong>Socio</strong></td>
	<td nowrap align="left"><strong>Prod/Cpto</strong></td>
	<td nowrap align="left"><strong>Fecha Documento</strong></td>
	<td nowrap align="left"><strong>No. Trade</strong></td>
	<cfif MostrarFactor>
	<td nowrap align="right"><strong>Factor</strong></td></cfif>
	<td nowrap align="right"><strong>Importe</strong></td>
	<cfif MostrarFactor>
	<td nowrap align="right"><strong>Calculado</strong></td></cfif>
	<td nowrap align="right"><strong>Iva</strong></td>
	<td nowrap align="left"><strong>Moneda</strong></td>
	<td nowrap align="left"><strong>Módulo</strong></td>
	<td nowrap align="left"><strong>Tipo Trans.</strong></td>
	<cfif modo_errores is '1'>
		<td nowrap align="left"><strong>Mensaje</strong></td>
	</cfif>
</tr>
<tr><td colspan="#iif(modo_errores is '1', 12, 11)#">&nbsp;</td></tr>
<cfif rsProductos.RecordCount is 0>
<tr><td colspan="#iif(modo_errores is '1', 12, 11)#" align="center"><strong>
<cfif modo_errores is '1'>
- No hay registros de error -
<cfelse>
- No hay registros por aplicar -
</cfif>
</strong></td></tr>
</cfif>
<cfloop query="rsProductos">
	<tr>
		<td valign="top" nowrap >#rsProductos.ContractNo#</td>
		<td valign="top" nowrap >#rsProductos.Documento#</td>
		<cfif MostrarCobertura>
			<td valign="top" nowrap >#rsProductos.cobertura#</td>
		</cfif>
		<td valign="top" nowrap >#rsProductos.NumeroSocio#</td>
		<td valign="top" nowrap >#rsProductos.CodigoItem#</td>
		<td valign="top" nowrap >#DateFormat(rsProductos.FechaDocumento,"dd/mm/yyyy")#</td>
		<td valign="top" nowrap >#rsProductos.VoucherNo#</td>
		<cfif MostrarFactor>
		<td valign="top" nowrap align="right">#NumberFormat(rsProductos.factor, ",9.00")#</td></cfif>
		<td valign="top" nowrap align="right">#NumberFormat(rsProductos.PrecioTotal, ",9.00")#</td>
		<cfif MostrarFactor>
		<td valign="top" nowrap align="right">#NumberFormat(rsProductos.calculado, ",9.00")#</td></cfif>
		<td valign="top" nowrap align="right">#rsProductos.CodigoImpuesto#</td>
		<td valign="top" nowrap align="center">#rsProductos.CodigoMoneda#</td>
		<td valign="top" nowrap >#rsProductos.Modulo#</td>
		<td valign="top" nowrap >#rsProductos.CodigoTransacion#</td>
		<cfif modo_errores is '1'>
			<!--- se omite el nowrap porque el mensaje sí puede salir en varias líneas --->
			<td valign="top" align="left"># HTMLEditFormat( rsProductos.MensajeError ) #</td>
		</cfif>
	</tr>
</cfloop>
</table>
</cfoutput>

	</body></html>
