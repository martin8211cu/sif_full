<cfprocessingdirective pageEncoding="utf-8">
<cfif isdefined("url.Ecodigo") and #url.Ecodigo# neq "">
	<cfset consultar_Ecodigo = trim(#url.Ecodigo#)>
</cfif>
<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">

<style type="text/css">
.tituloDetalle{
	white-space: nowrap;
	padding-right: 5px;
	border-bottom: 1px solid black;
}
.borderLeft{
	border-left: 1px solid black;
}
</style>
<cfquery name="qryLista" datasource="#session.dsn#">
	select 	ECid,
			Pnombre +' '+ Papellido1 +' '+ Papellido2 as Comprador,
			SNnombre,
			Rcodigo,
			CMTOcodigo,
			CMFPid,
			CMIid,
			ECdesc,
			ECfechaini,
			ECfechafin,
			ECestado,
			ECfalta,
			ECplazocredito,
			ECporcanticipo,
			ECtiempoentrega,
			ECaviso,
			ECavisaremail,
			Consecutivo,
			Tramite,
			MotivoCancelacion
	from EcontratosCM a
		inner join Usuario u
			inner join DatosPersonales dp on dp.datos_personales = u.datos_personales
		on u.Usucodigo = a.Usucodigo
		left outer join SNegocios d on d.Ecodigo = a.Ecodigo and d.SNcodigo = a.SNcodigo
	where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECId#">
</cfquery>

<cfquery name="qryLista2" datasource="#session.dsn#">
	select ROW_NUMBER()OVER(order by DClinea) as linea,
		case DCtipoitem
			when 'A' then 'Artículo'
			when 'F' then 'Activo Fijo'
			when 'S' then 'Servicio'
		end as Tipo,
		case a.DCtipoitem
			when 'A' then (select ltrim(rtrim(Acodigo)) from Articulos x where x.Aid = a.Aid)
			when 'S' then (select ltrim(rtrim(Ccodigo)) from Conceptos x where x.Cid = a.Cid)
			else ' '
		end as Codigo,
		case a.DCtipoitem
			when 'A' then (select ltrim(rtrim(Adescripcion)) from Articulos x where x.Aid = a.Aid)
			when 'S' then (select ltrim(rtrim(Ccodigo)) from Conceptos x where x.Cid = a.Cid)
			else ' '
		end as item,
		Miso4217,
		a.Icodigo,
		i.Iporcentaje,
		a.Ucodigo,
		DCpreciou,
		DCtc,
		DCgarantia,
		DCdescripcion,
		DCdescalterna,
		DCcantcontrato,
		DCcantsurtida,
		DCdiasEntrega,
		DCpreciou * DCcantcontrato as totalLin
	from DContratosCM a
		inner join Impuestos i on a.Ecodigo = i.Ecodigo and a.Icodigo = i.Icodigo
		inner join Monedas m on a.Ecodigo = m.Ecodigo and a.Mcodigo = m.Mcodigo
		Left join Articulos ar on a.Aid = ar.Aid and a.Ecodigo = ar.Ecodigo

	where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECid#">
    order by a.DClinea
</cfquery>

<cfoutput query="qryLista" group="ECid">
<cfinclude template="AREA_HEADER.cfm"><br>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="5" class="tituloListas"><strong><cf_translate key="LB_DatosDeLaSolicutudDeCompra">Datos del Contrato de Compra</cf_translate></strong></td>
	</tr>
	<tr>
		<td colspan="4"></td>
	</tr>
  	<tr>
		<td valign="top"><strong><cf_translate key="LB_NumeroDeContrato">Número de Contrato</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#Consecutivo#</td>
		<td valign="top"><strong><cf_translate key="LB_Comprador">Comprador</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#Comprador#</td>
  	</tr>
  	<tr>
		<td valign="top"><strong><cf_translate key="LB_FechaInicio">Fecha de Inicio</cf_translate>:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(ECfechaini,'dd/mm/yyy')#</td>
		<td valign="top"><strong><cf_translate key="LB_Proveedor">Proveedor</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#SNnombre#</td>
  	</tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_FechaVencimiento">Fecha de Vencimiento</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(ECfechafin,'dd/mm/yyy')#</td>
		<td valign="top"><strong><cf_translate key="LB_Moneda">Tiempo de Entrega</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top"><cfif LEN(ECtiempoentrega)>#ECtiempoentrega#<cfelse>N/A</cfif>#ECtiempoentrega#</td>
  	</tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#ECdesc#</td>
		<td valign="top"><strong><cf_translate key="LB_PlazoCredito">Plazo Crédito</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top"><cfif ECplazocredito GT 0>#ECplazocredito#<cfelse>0</cfif></td>
  	</tr>
	<tr>
		<td nowrap><strong><cf_translate key="LB_PorcentajeAnticipo">Porcentaje de Anticipo</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#ECporcanticipo#</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4" class="tituloListas" style="border-bottom: 1px solid black;" >
			<strong><cf_translate key="LB_DetallesDeLineasDeLaSolicitudDeCompra">Detalles de L&iacute;nea(s) de la Solicitud de Compra</cf_translate></strong>
		</td>
	</tr>
</table>
</cfoutput>

<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr class="tituloListas">
		<td width="5%"  class="tituloDetalle"><cf_translate key="LB_Linea">Línea</cf_translate></td>
		<td width="17%" class="tituloDetalle borderLeft"><cf_translate key="LB_Tipo">Tipo</cf_translate></td>
		<td width="15%" class="tituloDetalle borderLeft"><cf_translate key="LB_Codigo">Código</cf_translate></td>
		<td width="40%" class="tituloDetalle borderLeft"><cf_translate key="LB_Item">Ítem</cf_translate></td>
		<cfif not isdefined("url.imprimir")>
			<td class="tituloDetalle borderLeft">&nbsp;</td>
		</cfif>
		<td width="2%"  class="tituloDetalle borderLeft"><cf_translate key="LB_Cant">Cant</cf_translate>.</td>
		<td width="3%"  class="tituloDetalle borderLeft"><cf_translate key="LB_CantSurt">Cant.Surt</cf_translate>.</td>
		<td width="5%"  class="tituloDetalle borderLeft"><cf_translate key="LB_Unidad">Unidad</cf_translate></td>
		<td width="10%" class="tituloDetalle borderLeft"><cf_translate key="LB_DiasEntrega">Dias Entrega</cf_translate></td>
		<td width="10%" class="tituloDetalle borderLeft"><cf_translate key="LB_TipoCambio">Tipo Cambio</cf_translate></td>
		<td width="7%"  class="tituloDetalle borderLeft"><cf_translate key="LB_Moneda">Moneda</cf_translate></td>
		<td width="5%"  class="tituloDetalle borderLeft"><cf_translate key="LB_Impuesto">Impuesto</cf_translate></td>
		<td width="25%" class="tituloDetalle borderLeft"><cf_translate key="LB_PrecioU">Precio Unidad</cf_translate></td>
		<td width="25%" class="tituloDetalle borderLeft"><cf_translate key="LB_TotalEstimadoLinea">Total Línea</cf_translate></td>
	</tr>
	<cfif qryLista2.RecordCount eq 0>
		<tr class="listaNon">
			<td colspan="<cfif not isdefined("url.imprimir")>11<cfelse>10</cfif>" style="padding-right: 5px; border-bottom: 1px solid black; text-align:center">
				&nbsp;--------- <cf_translate key="LB_NoHayDetallesEnLaSolicitudDeCompra">No hay detalles en la Solicitud de Compra</cf_translate> ---------&nbsp;
			</td>
		</tr>
	<cfelse>
		<cfoutput query="qryLista2">
			<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				<td width="5%" style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#linea#&nbsp;</td>
				<td width="17%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Tipo#&nbsp;</td>
				<td width="15%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Codigo#&nbsp;</td>
				<td width="40%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; min-width:400px;">&nbsp;#item#&nbsp;</td>
				<cfif not isdefined("url.imprimir")>
					<td style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">
						<cfset varDSdescalterna = trim(Replace(DCdescripcion,chr(34),'&quot;','ALL' ))>
						<cfset varDSobservacion = trim(Replace(DCdescalterna,chr(34),'&quot;','ALL' ))>
						<input type="hidden" name="DSobservacion#CurrentRow#" value="#varDSdescalterna#">
						<input type="hidden" name="DSdescalterna#CurrentRow#" value="#varDSobservacion#">
						<a href="javascript: info(#currentRow#);"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a>
					</td>
				</cfif>
				<td nowrap width="2%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DCcantcontrato#&nbsp;</td>
				<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DCcantsurtida#&nbsp;</td>
				<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#trim(Ucodigo)#&nbsp;</td>
				<td nowrap width="10%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DCdiasEntrega#&nbsp;</td>
				<td nowrap width="10%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DCtc#&nbsp;</td>
				<td nowrap width="7%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Miso4217#&nbsp;</td>
				<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Icodigo#(#Iporcentaje#%)&nbsp;</td>
				<td width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(DCpreciou,'none')#&nbsp;</td>
				<td width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(totalLin,'none')#&nbsp;</td>
			</tr>
		</cfoutput>
	</cfif>
</table>

<cfoutput>
<table width="99%" align="center"  border="0" cellspacing="2" cellpadding="2" style="border-top:1px solid black; ">
	<cfquery name="rsPreTotales" datasource="#session.DSN#">
		select 	coalesce((DCcantcontrato*DCpreciou),0) as subtotal,
				DCpreciou * (Iporcentaje/100) * DCcantcontrato as IVA,
				((DCpreciou * (Iporcentaje/100)) + DCpreciou) * DCcantcontrato as MontoT
		  		<!---coalesce(round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0) as MotoIEPS,
			 	Case when (b.DStipo = 'S' or b.DStipo = 'A') and (COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1)
			 			THEN coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2),0)
					   else
				  	coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2),0)
				end as IVA,
				case when (b.DStipo = 'S' or b.DStipo = 'A') and (COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1)
						THEN coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2) + round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
					 else coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) + round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
				end as MontoT --->
		 from 	EcontratosCM a
			inner join DContratosCM b
				on a.ECid=b.ECid and a.Ecodigo = b.Ecodigo
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
		where a.ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#consultar_Ecodigo#">
	</cfquery>

	<cfif rsPreTotales.recordcount gt 0>
		<cfquery name="rsTotales" dbtype="query">
			select
				sum(subtotal) as subtotal,
				sum(IVA) as impuesto,
				sum(MontoT) as STMontoT
			from rsPreTotales
		</cfquery>
	</cfif>

	<tr>
		<td rowspan="3" width="100%">&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Subtotal">Subtotal</cf_translate>&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(rsTotales.subtotal,'none')#</td>
	</tr>
	<!--- <tr>
		<td nowrap align="right"><cf_translate key="LB_Impuestos">IEPS</cf_translate>&nbsp;:&nbsp;</td>
		<td align="right"><!--- #LSCurrencyFormat(rsTotales.TotalIEPS,'none')# ---></td>
	</tr> --->
	<tr>
		<td nowrap align="right"><cf_translate key="LB_Impuestos">Impuestos</cf_translate>&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(rsTotales.impuesto,'none')#</td>
	</tr>
	<tr>
		<!--- <td width="100%">&nbsp;</td> --->
		<td align="right" nowrap><strong><cf_translate key="LB_Total">Total</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td align="right"><strong>#LSCurrencyFormat(rsTotales.STMontoT,'none')#</strong></td>
	</tr>
</table>

</cfoutput>

<cfif not isdefined("url.imprimir")>
<script type="text/javascript" language="javascript1.2" >
	function info(index){
		open('../consultas/Solicitudes-info.cfm?index='+index, 'Solicitudes','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=410,left=250, top=200,screenX=250,screenY=200');
	}
</script>
</cfif>