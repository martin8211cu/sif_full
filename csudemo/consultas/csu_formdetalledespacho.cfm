<cfif isdefined("URL.CodCliente") and Len(Trim(URL.CodCliente))>
	<cfset form.CodCliente = URL.CodCliente>
</cfif>
<cfif isdefined("URL.NumPedido") and Len(Trim(URL.NumPedido))>
	<cfset form.NumPedido = URL.NumPedido>
</cfif> 
<cfif isdefined("URL.fechai") and Len(Trim(URL.fechai))>
	<cfset form.fechai = URL.fechai>
</cfif> 
<cfif isdefined("URL.fechaf") and Len(Trim(URL.fechaf))>
	<cfset form.fechaf = URL.fechaf>
</cfif> 

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<form action="csu_detalledespacho.cfm" method="post" name="sql">
	<tr>
		<td width="64%" bgcolor="gainsboro" align="center">
			<b><font size="3">Detalle del pedido </font></b>
		 </td>
		 <td  nowrap width="26%" bgcolor="gainsboro" align="right">
			Mostrar:
			<select name="Mostrar" onChange="this.form.submit();">
					<option value="D" <cfif isdefined("Form.Mostrar") and  Form.Mostrar EQ 'D'>selected</cfif>>Diferencias</option>
					<option value="T" <cfif isdefined("Form.Mostrar") and  Form.Mostrar EQ 'T'>selected</cfif>>Todo</option>
			</select>
	  </td>
	   <td width="10%" bgcolor="gainsboro" align="right">
		<input type="button" name="Regresar" 
		value="Regresar" 
		onClick="javascript: if (window.FuncBack) return FuncBack();" tabindex="0">
	   </td>
	</tr>	
	<input type="hidden" name="CodCliente" value="<cfoutput>#form.CodCliente#</cfoutput>">
	<input type="hidden" name="NumPedido" value="<cfoutput>#form.NumPedido#</cfoutput>">
	<input type="hidden" name="fechai" value="<cfoutput>#form.fechai#</cfoutput>">
	<input type="hidden" name="fechaf" value="<cfoutput>#form.fechaf#</cfoutput>">

	</form>
</table>

<cfquery name="RsEncabezado" datasource="csulog">       
	select 	a.DescrCliente,a.CodCliente,a.NumPedido
	from EncPed a 
	where a.CodCliente   = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CodCliente#">
	and a.NumPedido      =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.NumPedido#">
</cfquery>

<cfquery name="RsDetalle" datasource="csulog">       
	select 	a.DescrProducto,a.CodIntProducto,a.SubIndice,
			a.Cantidad, coalesce(d.CantidadDespachada, '') as CantidadDespachada,
			coalesce(d.MontoTotDespachado, '') as MontoTotDespachado,
			case when d.CantidadDespachada is null then  'Sin Despachar' else 'Despachado' end as Estado
	from DetPed a 
	left outer join DetDesp d
		on  a.CodCliente  		= d.CodCliente
		and a.NumPedido 		= d.NumDespacho	  
		and a.CodIntProducto 	= d.CodIntProducto
		and a.SubIndice      	= d.SubIndice 
		and a.Digito        	= d.Digito 
	where a.CodCliente   = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CodCliente#">
	and a.NumPedido      =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.NumPedido#">
	<cfif not isdefined("form.Mostrar")  OR  isdefined("form.Mostrar") AND  Form.Mostrar EQ 'D'> 
		and (a.Cantidad != d.CantidadDespachada	or  d.CantidadDespachada is null)
	</cfif> 
</cfquery>
<cfoutput>
	<table width="100%" border=0"" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td  colspan="6" align="left"><font size="2">Pedido :<b>#RsEncabezado.NumPedido#</b></font></td>
		</tr>
		<tr>
			<td  colspan="6" align="left"><font size="2">Tienda :<b>#RsEncabezado.CodCliente#-#RsEncabezado.DescrCliente#</b></font></td>
		</tr>
		<tr>
			<td  colspan="6" align="left">&nbsp;</td>
		</tr>
		<tr>
			<td  bgcolor="gainsboro" align="left"><font size="2"><b>Código</b></font></td>
			<td  bgcolor="gainsboro" align="left"><font size="2"><b>Producto</b></font></td>
			<td  bgcolor="gainsboro" align="right"><font size="2"><b>Cantidad Solicitada</b></font></td>
			<td  bgcolor="gainsboro" align="right"><font size="2"><b>Cantidad Despachada</b></font></td>
			<td  bgcolor="gainsboro" align="right"><font size="2"><b>Monto Despachado</b></font></td>
			<td  bgcolor="gainsboro" align="right"><font size="2"><b>Estado</b></font></td>
		</tr>
		<cfloop query="RsDetalle">
			<tr>
				<td  align="left"><font size="2">#RsDetalle.CodIntProducto#-#RsDetalle.SubIndice#</font></td>
				<td  align="left"><font size="2">#RsDetalle.DescrProducto#</font></td>
				<td  align="right"><font size="2">#LSNumberFormat( RsDetalle.Cantidad,',9.00')#</font></td>
				<td  align="right"><font size="2">#LSNumberFormat( RsDetalle.CantidadDespachada,',9.00')#</font></td>
				<td  align="right"><font size="2">#LSNumberFormat( RsDetalle.MontoTotDespachado,',9.00')#</font></td>
				<td  align="right"><font size="2">#RsDetalle.Estado#</font></td>
			</tr>
		</cfloop>
		<tr>
			<td  colspan="6" align="left"><hr></td>
		</tr>
		
	</table>


<script language="javascript" type="text/javascript">
	function FuncBack(){
		javascript:location.href='/cfmx/csudemo/consultas/csu_pedidos.cfm?codcliente=#form.CodCliente#&numpedido=#form.NumPedido#&fechai=#form.fechai#&fechaf=#form.fechaf#&consultar=1' ;
	}
</script>

</cfoutput>
