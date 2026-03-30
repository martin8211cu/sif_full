<!--- ////////////////////////////////////////////////////////// --->
<cfset ainicio = listtoarray(form.fechai,'/')>
<cfset afinal = listtoarray(form.fechaf,'/')>
<cfset finicio = createdate(ainicio[3],ainicio[2],ainicio[1]) >
<cfset ffinal = createdate(afinal[3],afinal[2],afinal[1]) >
<cfif datecompare(finicio, ffinal) gt 0>
	<cfset tmp = finicio >
	<cfset finicio = ffinal >
	<cfset ffinal = tmp >
</cfif>
<cfset finicio = LSDateFormat(finicio,'yyyymmdd') >
<cfset ffinal = LSDateFormat(ffinal,'yyyymmdd') >
<!--- ////////////////////////////////////////////////////////// --->
<cfquery name="data" datasource="csulog">
	select a.CODCLIENTE as cliente, 
		   a.DESCRCLIENTE as descripcion, 
		   a.NUMPEDIDO as pedido, 
		   a.FECREGISTRO as fecha, 
		   a.TOTCOSTO as total, 
		   b.CODBODEGA as bodega, 
		   b.FECDESPACHO as despacho,
		   ( select sum(coalesce(cast(det.MONTOTOTDESPACHADO as  numeric(15,2)),0)) 
		   	 from DETDESP det 
			 where det.CODCLIENTE=b.CODCLIENTE 
			   and det.NUMDESPACHO=b.NUMDESPACHO ) as totaldesp
	from ENCPED a
	left outer join ENCDESP b
	on b.CODCLIENTE = a.CODCLIENTE
	and a.NUMPEDIDO = b.NUMDESPACHO
	where a.FECREGISTRO between <cfqueryparam cfsqltype="cf_sql_varchar" value="#finicio#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ffinal#">
	<cfif isdefined("form.CODCLIENTE") and len(trim(form.CODCLIENTE))>
		and a.CODCLIENTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CODCLIENTE#">
	</cfif>
</cfquery>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td align="center"><font size="3" face="Arial, Helvetica, sans-serif"><strong>Consulta de Seguimiento de Pedidos</strong></font></td></tr>
	<cfif isdefined("form.CODCLIENTE") and len(trim(form.CODCLIENTE))>
		<tr><td align="center"><font size="3" face="Arial, Helvetica, sans-serif"><strong>Cliente: #data.cliente# - #data.descripcion#</strong></font></td></tr>
	</cfif>
	<tr><td align="center"><strong>Del #form.fechai# al #form.fechaf#</strong></td></tr>
	<!---<tr><td>&nbsp;</td></tr>--->
</table>
</cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
<tr bgcolor="#e6e6e6">
	<td ><strong><font size="2">Pedido</font></strong></td>
	<td  nowrap><strong><font size="2"><cfif not (isdefined("form.CODCLIENTE") and len(trim(form.CODCLIENTE)))>Punto de Venta</font></strong></cfif></td>
	<td ><strong><font size="2">Fecha</font></strong></td>
	<td  nowrap><strong><font size="2">Fecha Despacho</font></strong></td>
	<td ><strong><font size="2">Bodega</font></strong></td>
	<td align="right" width="15%" nowrap><strong><font size="2">Costo Total</font></strong></td>
	<td align="right" width="15%" nowrap><strong><font size="2">Total Despachado</font></strong></td>
</tr>
<cfoutput query="data">
	<tr style="cursor:hand;" onClick="javascript:location.href='/cfmx/csudemo/consultas/csu_detalledespacho.cfm?codcliente=#data.cliente#&numpedido=#data.pedido#&fechai=#form.fechai#&fechaf=#form.fechaf#'" <cfif data.currentrow mod 2>bgcolor="##FAFAFA"</cfif> >
		<td style="cursor:hand;"><font size="2">#data.pedido#</font></td>
		<td style="cursor:hand;"><font size="2"><cfif not (isdefined("form.CODCLIENTE") and len(trim(form.CODCLIENTE)))>#data.cliente# - #data.descripcion#</cfif></font></td>
		<td style="cursor:hand;"><font size="2"><cfif len(trim(data.fecha))>#mid(replace(data.fecha,'/',''),7,2)#/#mid(replace(data.fecha,'/',''),5,2)#/#mid(replace(data.fecha,'/',''),1,4)#</cfif></font></td>
		<td style="cursor:hand;"><font size="2"><cfif len(trim(data.despacho))>#mid(replace(data.despacho,'/',''),7,2)#/#mid(replace(data.despacho,'/',''),5,2)#/#mid(replace(data.despacho,'/',''),1,4)#</cfif></font></td>
		<td style="cursor:hand;"><font size="2">#data.bodega#</font></td>
		<td style="cursor:hand;" align="right"><font size="2"><cfif len(trim(data.total))>#LSNumberFormat(data.total,',9.00')#<cfelse>0.00</cfif></font></td>
		<td style="cursor:hand;" align="right"><font size="2"><cfif len(trim(data.totaldesp))>#LSNumberFormat(data.totaldesp,',9.00')#<cfelse>0.00</cfif></font></td>
	</tr>
</cfoutput>
<cfif data.recordcount eq 0 >
	<tr><td colspan="7" align="center"><strong>No se encontraron registros</strong></td></tr>
<cfelse>
	<tr><td colspan="7" align="center">-------------- Fin de la consulta --------------</td></tr>
</cfif>
</table>