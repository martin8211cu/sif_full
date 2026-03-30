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
<!--- Consultas para pintar los datos del Reporte --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsCuentas" datasource="#session.DSN#">
	select 	a.EOidorden, a.EOnumero, a.EOfecha, b.Mnombre, a.EOtotal, a.Observaciones, a.EOtotal,
			(a.EOtotal * a.EOtc) as MontoLocal, c.SNcodigo, c.SNnumero, c.SNnombre, c.SNidentificacion,
			d.CMTOdescripcion, d.CMTOcodigo
	from 	EOrdenCM a 
			inner join Monedas b
				on a.Ecodigo = b.Ecodigo
				and a.Mcodigo = b.Mcodigo
			inner join SNegocios c
				on a.Ecodigo = c.Ecodigo
				and a.SNcodigo = c.SNcodigo
			inner join CMTipoOrden d
				on a.CMTOcodigo = d.CMTOcodigo
				and a.Ecodigo = d.Ecodigo
					
	where 	a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
			</cfif>
			<cfif isdefined("form.fdesde") and trim(form.fdesde) NEQ "" and isdefined("form.fhasta") and trim(form.fhasta) NEQ "">
				and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
			<cfelseif isdefined("form.fdesde") and trim(form.fdesde) NEQ "" and isdefined("form.fhasta") and trim(form.fhasta) EQ "">
				and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
			<cfelseif not isdefined("form.fdesde") and trim(form.fdesde) EQ "" and isdefined("form.fhasta") and trim(form.fhasta) NEQ "">	
				and a.EOfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(form.fhasta)))#">
			</cfif>
	order by c.SNnumero, a.EOnumero, d.CMTOdescripcion, a.EOfecha
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
	<td colspan="4" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr> 
	<td colspan="4" class="letra" align="center"><b>Consulta de Compras por Proveedor</b></td>
	</tr>
	<cfoutput> 
	<tr>
	<td colspan="4" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
	</cfoutput> 			
</table>
<br>
<table width="98%" cellpadding="2" cellspacing="0" align="center">
<cfset vsCorteSocio = ''>
<cfset vnTotalSocio = 0>
<cfoutput query="rsCuentas">		
	<cfif rsCuentas.SNcodigo neq vsCorteSocio>
		<cfif rsCuentas.CurrentRow NEQ 1>
			<tr>
				<td colspan="3" align="right"><strong>Total:</strong></td>
				<td align="right"><strong>#LSCurrencyFormat(vnTotalSocio,'none')#</strong></td>
			</tr>
		</cfif>
		<cfset vnTotalSocio = 0>
		<tr><td class="bottomline" nowrap colspan="4"><strong>Proveedor:&nbsp;#rsCuentas.SNnumero# - #rsCuentas.SNnombre#</strong></td></tr>
		<tr class="tituloListas">
			<td width="18%" class="LetraEncab">No.Orden</td>			
			<td width="20%" class="LetraEncab">Fecha</td>
			<td width="20%" class="LetraEncab">Moneda</td>
			<td width="42%" align="right" class="LetraEncab">Monto Total</td>
		</tr>		
	</cfif>
	<tr class="<cfif rsCuentas.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
		<td style="padding-left:5px; " class="LetraDetalle">#rsCuentas.EOnumero#</td>
		<td style="padding-left:5px; " class="LetraDetalle">#LSDateFormat(rsCuentas.EOfecha,'dd/mm/yyyy')#</td>
		<td style="padding-left:5px; " class="LetraDetalle">#rsCuentas.Mnombre#</td>
		<td style="padding-left:5px; " class="LetraDetalle" align="right">#LSCurrencyFormat(rsCuentas.EOtotal,'none')#</td>		
	</tr>	
	<cfset vnTotalSocio = vnTotalSocio + EOtotal>
	<cfset vsCorteSocio = rsCuentas.SNcodigo >
</cfoutput>
<cfif rsCuentas.RecordCount NEQ 0>
	<tr>
		<td colspan="3" align="right"><strong>Total:</strong></td>
		<td align="right"><cfoutput><strong>#LSCurrencyFormat(vnTotalSocio,'none')#</strong></cfoutput></td>
	</tr>
</cfif>
<cfif rsCuentas.RecordCount gt 0 >
	<tr><td colspan="4" align="center">&nbsp;</td></tr>
	<tr><td colspan="4" align="center" class="LetraDetalle">------------------ Fin del Reporte ------------------</td></tr>
<cfelse>
	<tr><td colspan="4" align="center">&nbsp;</td></tr>
	<tr><td colspan="4" align="center" class="LetraDetalle">--- No se encontraron datos ----</td></tr>
</cfif>
</table>
<br>
<!----========================================== ANTERIOR ===============================================
<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr><td colspan="8" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td colspan="8" nowrap align="center" class="letra" ><strong>Proveedor:&nbsp; #rsCuentas.SNnumero# - #rsCuentas.SNnombre#</strong></td></tr>
		<tr><td colspan="8" align="center" class="letra"><strong>Consulta de Compras por Proveedor </strong></td></tr>
		<tr><td colspan="8" align="center" class="letra"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</td></tr>
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="encabezado2">
	<cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td nowrap class="tituloListas"><strong></strong>&nbsp;</td>
			<td nowrap class="tituloListas"><strong>Fecha</strong></td>
			<!---<td nowrap class="tituloListas"><strong>Tipo Orden</strong></td>--->
			<td nowrap class="tituloListas"><strong>Orden</strong></td>		
			<td nowrap class="tituloListas"><strong>Observaciones</strong></td>	
			<td nowrap class="tituloListas"><strong>Moneda</strong></td>
			<td nowrap align="right" class="tituloListas"><strong>Monto Origen</strong></td>
			<td nowrap align="right" class="tituloListas"><strong>Monto Local</strong></td>
		</tr>
	</cfoutput>
</cfsavecontent>

<link href="StyleReporte.css" rel="stylesheet" type="text/css">
<cfoutput>
	<table width="98%" border="0" cellspacing="0" cellpadding="3" align="center">
		<cfset corte=''>	
		<cfif rsCuentas.RecordCount EQ 0>
			#encabezado1#
		</cfif>		
		<cfif rsCuentas.RecordCount GT 0>
			<cfset Total = 0>
			<cfloop query="rsCuentas">				
				<cfif currentRow mod 40 EQ 1>
					<cfif currentRow NEQ 1>
						<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
					</cfif>
					#encabezado1#
					#encabezado2#
				</cfif>				
				<cfif corte neq rsCuentas.CMTOcodigo >
					<tr>
						<td nowrap class="tituloListas" colspan="7">#trim(rsCuentas.CMTOcodigo)# - #rsCuentas.CMTOdescripcion#</td>
					</tr>	
				</cfif>								
				<tr onClick="javascript: doConlis(#rsCuentas.EOidorden#);" style="cursor:hand; " class="<cfif rsCuentas.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
					<td nowrap>&nbsp;</td>
					<td nowrap>#LSDateFormat(rsCuentas.EOfecha,'dd/mm/yyyy')#</td>
					<!---<td nowrap>#trim(rsCuentas.CMTOdescripcionrs)# - #Cuentas.CMTOdescripcion#</td>--->
					<td nowrap>#rsCuentas.EOnumero#</td>
					<td nowrap>#rsCuentas.Observaciones#</td>
					<td nowrap>#rsCuentas.Mnombre#</td>
					<td nowrap align="right">#LSCurrencyFormat(rsCuentas.EOtotal,'none')#</td>
					<td nowrap align="right">#LSCurrencyFormat(rsCuentas.MontoLocal,'none')#</td>
				</tr>
				<cfset Total = Total + #rsCuentas.MontoLocal#>
				<cfset corte=rsCuentas.CMTOcodigo>
			</cfloop>						
			<tr>
				<td nowrap class="topline" colspan="6" align="right" ><strong>Total Moneda Local:</strong></td>
				<td nowrap class="topline" align="right" ><strong>#LSCurrencyFormat(Total,'none')#</td>
			</tr>
			<cfloop query="rsMtsMonedas">
				<tr>	
					<td nowrap colspan="6" align="right" ><strong>Total #rsMtsMonedas.Mnombre#:</strong></td>
					<td nowrap align="right" ><strong>#LSCurrencyFormat(rsMtsMonedas.total,'none')#</td>
				</tr>
			</cfloop>
			<tr><td colspan="8" nowrap  class="listaCorte">&nbsp;</td></tr>
			<tr><td colspan="8" nowrap align="center" class="listaCorte">---------- Fin de la Consulta ----------</td></tr>
		<cfelse>
			<tr><td colspan="8" nowrap>&nbsp;</td></tr>
			<tr><td colspan="8" nowrap align="center" class="listaCorte"><strong>--- La Consulta no Gener&oacute; Resultados ---</strong></td></tr>
		</cfif>
		
		<tr><td colspan="8" nowrap>&nbsp;</td></tr>
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
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOidorden="+valor,10,10,1000,550);
	}
</script>s
---------->