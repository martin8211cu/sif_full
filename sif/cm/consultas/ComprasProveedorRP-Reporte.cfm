<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #CCCCCC;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;

		font-size:11px;
	}
	.letra {
		font-size:11px;
	}
	.LetraDetalles{		
		font-size:10px;
	}
	.LetraEncabezados{
		font-size:11px;
		font-weight:bold;		
	}
	.pageEnd{
		page-break-before:always;		
	}
}
</style>


<!--- Si los filtros vienen por URL los carga en el form (Al hacer cambio de pagina) --->
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo") >
	<cfset form.SNcodigo = url.SNcodigo >
</cfif>

<cfif isdefined("url.fdesde") and not isdefined("form.fdesde") >
	<cfset form.fdesde = url.fdesde >
<cfelse>
	<cfset form.fdesde = form.fdesde >
</cfif>

<cfif isdefined("url.fhasta") and not isdefined("form.fhasta") >
	<cfset form.fhasta = url.fhasta >
<cfelse>
	<cfset form.fhasta = form.fhasta >
</cfif>

<cfif not isdefined("form.SNcodigo") or len(form.SNcodigo) EQ 0>
	<cfset form.SNcodigo = -1>
</cfif>

<!--- Consultas para pintar los datos del Reporte --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsCuentas" datasource="#session.DSN#">
	select 	a.EOidorden, a.EOnumero, a.EOfecha, b.Mnombre, a.EOtotal, a.Observaciones,
			(a.EOtotal * a.EOtc) as MontoLocal, c.SNnumero, c.SNnombre,d.CMTOdescripcion,d.CMTOcodigo
			,a.EOdesc
			,a.Impuesto
			,(select sum(DOtotal) 
				from DOrdenCM e
				where a.EOidorden = e.EOidorden
				) as subtotal
			,a.Mcodigo,
			b.Miso4217
	from 	EOrdenCM a 
			inner join Monedas b
				on a.Mcodigo = b.Mcodigo
			inner join SNegocios c
				on a.Ecodigo = c.Ecodigo
				and a.SNcodigo = c.SNcodigo
			inner join CMTipoOrden d
				on a.CMTOcodigo = d.CMTOcodigo
				and a.Ecodigo = d.Ecodigo
					
	where 	a.Ecodigo = #Session.Ecodigo#
	and a.SNcodigo = #form.SNcodigo#
	<cfif isdefined("form.fdesde") and trim(form.fdesde) NEQ "" and isdefined("form.fhasta") and trim(form.fhasta) NEQ "">
		and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
	<cfelseif isdefined("form.fdesde") and trim(form.fdesde) NEQ "" and isdefined("form.fhasta") and trim(form.fhasta) EQ "">
		and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
	<cfelseif not isdefined("form.fdesde") and trim(form.fdesde) EQ "" and isdefined("form.fhasta") and trim(form.fhasta) NEQ "">	
		and a.EOfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
	</cfif>
	order by d.CMTOcodigo,d.CMTOdescripcion,a.Mcodigo,a.EOnumero,a.EOfecha
</cfquery>

<!---- SQL con los montos agrupados por las dif. monedas de la orden de compra --->
<cfquery name="rsMtsMonedas" datasource="#session.DSN#">
	select  sum(EOtotal) as total,a.Mcodigo,b.Mnombre
	from EOrdenCM a
		inner join Monedas b 
			on a.Mcodigo = b.Mcodigo 
	where a.Ecodigo = #Session.Ecodigo#
	and a.SNcodigo = #form.SNcodigo#
	<cfif isdefined("form.fdesde") and trim(form.fdesde) NEQ "" and isdefined("form.fhasta") and trim(form.fhasta) NEQ "">
		and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
	<cfelseif isdefined("form.fdesde") and trim(form.fdesde) NEQ "" and isdefined("form.fhasta") and trim(form.fhasta) EQ "">
		and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
	<cfelseif not isdefined("form.fdesde") and trim(form.fdesde) EQ "" and isdefined("form.fhasta") and trim(form.fhasta) NEQ "">	
		and a.EOfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
	</cfif>	
	group by a.Mcodigo,b.Mnombre
</cfquery>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr><td colspan="10" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td colspan="10" nowrap align="center" class="letra" ><strong>Proveedor:&nbsp; #rsCuentas.SNnumero# - #rsCuentas.SNnombre#</strong></td></tr>
		<tr><td colspan="10" align="center" class="letra"><strong>Consulta de Compras por Proveedor (Montos)</strong></td></tr>
		<tr><td colspan="10" align="center" class="letra"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</td></tr>
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="encabezado2">
	<cfoutput>	
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td  class="LetraEncabezados" width="1%"><strong></strong>&nbsp;</td>
			<td  class="LetraEncabezados" width="5%"><strong>Fecha</strong></td>
			<td  class="LetraEncabezados" width="5%"><strong>Orden</strong></td>		
			<td  class="LetraEncabezados" width="30%"><strong>Observaciones</strong></td>	
			<td  class="LetraEncabezados" width="5%"><strong>Moneda</strong></td>
			<td  align="right" class="LetraEncabezados" width="11%"><strong>Subtotal</strong></td>
			<td  align="right" class="LetraEncabezados" width="11%"><strong>Descuentos</strong></td>
			<td  align="right" class="LetraEncabezados" width="11%"><strong>Impuestos</strong></td>
			<td  align="right" class="LetraEncabezados" width="11%"><strong>Total</strong></td>
			<td  align="right" class="LetraEncabezados" width="11%"><strong>Monto Local</strong></td>
		</tr>
	</cfoutput>
</cfsavecontent>

<link href="StyleReporte.css" rel="stylesheet" type="text/css">
<cfflush interval="128">
<cfoutput>
	<table width="98%" border="0" cellspacing="0" cellpadding="3" align="center">
		<cfset corte=''>			<!---=============== CORTE POR TIPO DE ORDEN ===============---->	
		<cfset corte_moneda= ''>	<!---=============== CORTE POR MONEDA ===============----->
		<cfset vn_mtomoneda = 0>	<!---=============== MONTO TOTAL CORTE POR MONEDA =============== ---->
		<cfset vs_moneda = ''>  	<!---=============== DESCRIPCION DE LA MONEDA PARA EL CORTE POR TOTAL DE MONEDA =============== ---->
		<cfset vn_mtolocaltipo = 0>	<!---=============== MONTO LOCAL TOTAL POR TIPO DE ORDEN ===============--->
		<cfif rsCuentas.RecordCount EQ 0>
			#encabezado1#
		</cfif>		
		<cfif rsCuentas.RecordCount GT 0>
			<cfset Total = 0>
			<cfloop query="rsCuentas">				
				<cfif currentRow mod 26 EQ 1> <!----======= CONTROLA EL CORTE DE PAGINA ======--->
					<cfif currentRow NEQ 1>
						<tr class="pageEnd"><td colspan="10">&nbsp;</td></tr>
					</cfif>
					#encabezado1#
					#encabezado2#
				</cfif>				
				<cfif rsCuentas.CurrentRow NEQ 1 and ((corte_moneda neq rsCuentas.Mcodigo) or (corte neq rsCuentas.CMTOcodigo))>					
					<tr>
						<td nowrap class="tituloListas" colspan="10">&nbsp;&nbsp;Total #vs_moneda#:&nbsp;#LSNumberFormat(vn_mtomoneda,',9.00')#</td>
					</tr>				
				</cfif>
				<cfif corte neq rsCuentas.CMTOcodigo >	<!---============ CORTE POR TIPO DE ORDEN ============---->					
					<cfif rsCuentas.CurrentRow NEQ 1>	<!---============ TOTAL MONEDA LOCAL POR TIPO DE ORDEN ============---->
						<tr>
							<td nowrap class="tituloListas" colspan="10">Total Moneda LocaL:&nbsp;#LSNumberFormat(vn_mtolocaltipo,',9.00')#</td>
						</tr>
					</cfif>
					<tr>
						<td nowrap class="tituloListas" colspan="10">#trim(rsCuentas.CMTOcodigo)# - #rsCuentas.CMTOdescripcion#</td>
					</tr>	
					<cfset vn_mtolocaltipo = 0>
				</cfif>				
				
				<cfif (corte_moneda neq rsCuentas.Mcodigo) or (corte neq rsCuentas.CMTOcodigo)><!---============ CORTE POR MONEDA ============---->
					<cfset vn_mtomoneda = 0>										 
					<tr>						
						<td nowrap class="tituloListas" colspan="10">&nbsp;&nbsp;#rsCuentas.Mnombre#</td>						
					</tr>	
				</cfif>		
				<tr onClick="javascript: doConlis(#rsCuentas.EOnumero#);" style="cursor:hand; " class="<cfif rsCuentas.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
					<td  class="LetraDetalles" width="1%" valign="top">&nbsp;</td>
					<td  class="LetraDetalles" width="5%" valign="top">#LSDateFormat(rsCuentas.EOfecha,'dd/mm/yyyy')#</td>
					<td  class="LetraDetalles" width="5%" valign="top">#rsCuentas.EOnumero#</td>
					<td  class="LetraDetalles" width="30%" valign="top">#rsCuentas.Observaciones#</td>
					<td  class="LetraDetalles" width="5%" valign="top">#rsCuentas.Miso4217#</td>
					<td  align="right" class="LetraDetalles" width="11%" valign="top">#LSCurrencyFormat(rsCuentas.subtotal,'none')#</td>
					<td  align="right" class="LetraDetalles" width="11%" valign="top">#LSCurrencyFormat(rsCuentas.EOdesc,'none')#</td>
					<td  align="right" class="LetraDetalles" width="11%" valign="top">#LSCurrencyFormat(rsCuentas.Impuesto,'none')#</td>
					<td  align="right" class="LetraDetalles" width="11%" valign="top">#LSCurrencyFormat(rsCuentas.EOtotal,'none')#</td>
					<td  align="right" class="LetraDetalles" width="11%" valign="top">#LSCurrencyFormat(rsCuentas.MontoLocal,'none')#</td>
				</tr>				
				<cfset Total = Total + #rsCuentas.MontoLocal#>
				<cfset vn_mtomoneda = vn_mtomoneda + rsCuentas.EOtotal><!---============ GUARDA EL MONTO POR MONEDA =============---->
				<cfset corte = rsCuentas.CMTOcodigo>		<!----======= CARGA EL CORTE POR TIPO DE ORDEN ==========---->
				<cfset corte_moneda = rsCuentas.Mcodigo>	<!-----=========== CARGA EL CORTE POR MONEDA =========----->			
				<cfset vs_moneda = rsCuentas.Mnombre>		<!----===========  CARGA LA DESCRIPCION DE LA MONEDA PARA EL CORTE POR MONEDA =========----->
				<cfset vn_mtolocaltipo = vn_mtolocaltipo + rsCuentas.MontoLocal>
			</cfloop><!---========= FIN DE LOOP DE ORDENES ===========---->						
			<tr><!---============= ULTIMO CORTE DE MTO MONEDAS ================---->
				<td nowrap class="tituloListas" colspan="10">&nbsp;&nbsp;Total #vs_moneda#:&nbsp;#LSNumberFormat(vn_mtomoneda,',9.00')#</td>
			</tr>	
			<tr><!---============= ULTIMO CORTE DE MTO LOCAL ================---->
				<td nowrap class="tituloListas" colspan="10">Total Moneda Local:&nbsp;#LSNumberFormat(vn_mtolocaltipo,',9.00')#</td>
			</tr>
			<tr>
				<td nowrap class="topline" colspan="9" align="right" ><strong>Total Moneda Local:</strong></td>
				<td nowrap class="topline" align="right" ><strong>#LSCurrencyFormat(Total,'none')#</td>
			</tr>
			<cfloop query="rsMtsMonedas"> <!----======== TOTALES POR LAS MONEDAS ========== ---->
				<tr>	
					<td nowrap colspan="9" align="right" class="LetraEncabezados"><strong>Total #rsMtsMonedas.Mnombre#:</strong></td>
					<td nowrap align="right" class="LetraEncabezados"><strong>#LSCurrencyFormat(rsMtsMonedas.total,'none')#</td>
				</tr>
			</cfloop>
			<tr><td colspan="10" nowrap  class="listaCorte">&nbsp;</td></tr>
			<tr><td colspan="10" nowrap align="center" class="listaCorte">---------- Fin de la Consulta ----------</td></tr>
		<cfelse><!----=============== ELSE SI NO  DEVUELVE REGISTROS EL QUERY ================----->
			<tr><td colspan="10" nowrap>&nbsp;</td></tr>
			<tr><td colspan="10" nowrap align="center" class="listaCorte"><strong>--- La Consulta no Gener&oacute; Resultados ---</strong></td></tr>
		</cfif><!---===== FIN DEL IF DEL RECORDCOUNT ======---->
		
		<tr><td colspan="10" nowrap>&nbsp;</td></tr>
	</table>
</cfoutput>

<script language='javascript' type='text/JavaScript' >
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOnumero="+valor,10,10,1000,550);
	}
</script>
