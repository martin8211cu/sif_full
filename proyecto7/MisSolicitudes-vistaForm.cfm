
<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">

<cfquery name="qryLista" datasource="#session.dsn#">
	select a.ESidsolicitud, a.ESnumero, a.ESfecha, a.ESobservacion, a.EStipocambio, 
		a.NAP,  a.NRP, a.NAPcancel, a.TRcodigo, a.ESjustificacion, 
		b.CMTSdescripcion, 
		c.CMCcodigo, c.CMCnombre, 
		d.SNnumero, d.SNnombre, 
		e.Mnombre, 
		f.CFcodigo, f.CFdescripcion,
		1
	from ESolicitudCompraCM a
		inner join CMTiposSolicitud b on b.Ecodigo = a.Ecodigo and b.CMTScodigo = a.CMTScodigo
		left outer join CMCompradores c on c.CMCid = a.CMCid
		left outer join SNegocios d on d.Ecodigo = a.Ecodigo and d.SNcodigo = a.SNcodigo
		inner join Monedas e on e.Mcodigo = a.Mcodigo
		inner join CFuncional f on f.CFid = a.CFid
	where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ESidsolicitud#">
</cfquery>

<cfquery name="qryLista2" datasource="#session.dsn#">
	select 
		a.DSconsecutivo, a.DSdescripcion, a.DSobservacion, a.DSdescalterna, a.DScant, 
		a.DScantsurt, a.DScantcancel, a.Ucodigo, DStotallinest, Icodigo, 
		case a.DStipo 
		when 'A' then (select ltrim(rtrim(Acodigo)) from Articulos x where x.Aid = a.Aid)
		when 'S' then (select ltrim(rtrim(Ccodigo)) from Conceptos x where x.Cid = a.Cid) 
		else ' ' end as Codigo,
		case (
			select Coalesce(min(ds.Estado),-1)
			from DSProvLineasContrato ds
			where ds.DSlinea = a.DSlinea
			)
				when -1 
					then (
						case when exists(
							select 1
							from DOrdenCM dor
							where a.DSlinea = dor.DSlinea)
						then (
							select min(comp.CMCnombre)
							from CMCompradores comp
							where a.CMCid = comp.CMCid)
						else
							(
								select min(f.CMCnombre)
								from ESolicitudCompraCM e
									inner join CMCompradores f
										on f.CMCid = e.CMCid
								where e.ESidsolicitud = a.ESidsolicitud
							)
						end
					)
	
				else (
					select min(comp.CMCnombre)
					from CMCompradores comp
					where a.CMCid = comp.CMCid
					)
			end
		as Comprador,
		(select min(CFcodigo) from CFuncional cf where cf.CFid = a.CFid) as CFcodigo,
		(select min(Almcodigo) from Almacen al where al.Aid = a.Alm_Aid) as Almcodigo,
		(select min(ERdocumento) 
			from DRequisicion dr 
				inner join ERequisicion er
				on er.ERid = dr.ERid
			where dr.DSlinea = a.DSlinea
		) as ERdocumento,
		coalesce((select min(Iporcentaje) from Impuestos im where im.Ecodigo = a.Ecodigo and im.Icodigo = a.Icodigo),0.00) as Iporcentaje
	from DSolicitudCompraCM a
	where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ESidsolicitud#">
    order by a.DSconsecutivo
</cfquery>

<cfoutput query="qryLista" group="ESidsolicitud"> 
<table width="99%" style="width:inherit;" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="5" class="tituloListas"><strong><cf_translate key="LB_DatosDeLaSolicutudDeCompra">Datos de la Solicitud de Compra</cf_translate></strong></td>
	</tr>
	<tr>
		<td colspan="4"><strong>#CMTSdescripcion#</strong></td>
	</tr>
  <tr>
		<td valign="top"><strong><cf_translate key="LB_NumeroDeSolicitud">N&uacute;mero de Solicitud</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#ESnumero#</td>
		<td valign="top"><strong><cf_translate key="LB_Comprador">Comprador</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CMCcodigo# - #CMCnombre#</td>
  </tr>
  <tr>
		<td valign="top"><strong><cf_translate key="LB_FechaDeLaSolicitud">Fecha de la Solicitud</cf_translate>:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(ESfecha,'dd/mm/yyy')#</td>
		<td valign="top"><strong><cf_translate key="LB_Proveedor">Proveedor</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#SNnumero# - #SNnombre#</td>
  </tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#ESobservacion#</td>
		<td valign="top"><strong><cf_translate key="LB_Moneda">Moneda</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#Mnombre#</td>
  </tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CFcodigo# - #CFdescripcion#</td>
		<td valign="top"><strong><cf_translate key="LB_TipoDeCambio">Tipo de Cambio</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#LSCurrencyFormat(EStipocambio,'none')#</td>
  </tr>
	<tr>
		<cfif isdefined('url.ESestado') and len(trim(url.ESestado)) and url.ESestado EQ 20 or url.ESestado EQ 25 or url.ESestado EQ 40 or url.ESestado EQ 50>
			<cfif NAP EQ 0 or NAP EQ ''>
				<td valign="top"><strong><cf_translate key="LB_NAP">NAP</cf_translate>&nbsp;:&nbsp;</strong></td>	
				<td valign="top"><cf_translate key="LB_NA">N/A</cf_translate></td>
			<cfelse>
				<td valign="top"><strong><cf_translate key="LB_NAP">NAP</cf_translate>&nbsp;:&nbsp;</strong></td>
				<td valign="top">#NAP#</td>	
			</cfif>
		</cfif>
			
		<cfif isdefined('url.ESestado') and len(trim(url.ESestado)) and url.ESestado EQ -10>
			<cfif NRP EQ 0 or NRP EQ ''>
				<td valign="top"><strong>NRP&nbsp;:&nbsp;</strong></td>	
				<td valign="top"><cf_translate key="LB_NA">N/A</cf_translate></td>
			<cfelse>
				<td valign="top"><strong><cf_translate key="LB_NRP">NRP</cf_translate>&nbsp;:&nbsp;</strong></td>	
				<td valign="top">#NRP#</td>
			</cfif>
		</cfif>
			
		<cfif isdefined('url.ESestado') and len(trim(url.ESestado))>

			<td width="18%" valign="top"><strong><cf_translate key="LB_Estado">Estado</cf_translate>&nbsp;:&nbsp;</strong></td>	
			<td width="39%" valign="top">
				<cfif url.ESestado eq 0 >
					<cf_translate key="LB_Pendiente">Pendiente</cf_translate>
				<cfelseif url.ESestado eq -10 >
					<cf_translate key="LB_RechazadaPorPresupuesto">Rechazada por Presupuesto</cf_translate>
				<cfelseif url.ESestado eq 10 >
					<cf_translate key="LB_EnTramiteDeAprobacion">En Tr&aacute;mite de aprobaci&oacute;n</cf_translate>
				<cfelseif url.ESestado eq 20 >
					<cf_translate key="LB_Aplicada">Aplicada</cf_translate>
				<cfelseif url.ESestado eq 25 >
					<cf_translate key="LB_OrdenCompraDirectaAplicada">Orden Compra Directa(Aplicada)</cf_translate>
				<cfelseif url.ESestado eq 40 >
					<cf_translate key="LB_ParcialmenteSurtida">Parcialmente Surtida</cf_translate>
				<cfelseif url.ESestado eq 50 >
					<cf_translate key="LB_Surtida">Surtida</cf_translate>
				<cfelseif url.ESestado eq 60 >
					<cf_translate key="LB_Cancelada">Cancelada</cf_translate>
				</cfif>
			</td>
		</cfif>
	</tr>
<!-----/*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/----->
	<tr>
		<td nowrap><strong><cf_translate key="LB_TipoDeRequisicion">Tipo de requisición</cf_translate>:</strong></td>
		<td>#TRcodigo#</td>
	</tr>
<!-----/*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/----->
	<cfif isdefined('url.ESestado') and len(trim(url.ESestado))>
		<cfif url.ESestado EQ 60>
			<tr>
				<td valign="top"><strong><cf_translate key="LB_Justificacion">Justificación</cf_translate>&nbsp;:&nbsp;</strong></td>
				<td>#ESjustificacion#</td>		
			</tr>
		</cfif> <!---- Si el estado es cancelada (60)  ---->
	</cfif> <!---- Si existe la variable url.ESestado ---->
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
            <td nowrap width="5%" style="padding-right: 5px;  border-bottom: 1px solid black;"><cf_translate key="LB_">L&iacute;nea</cf_translate></td>
            <td nowrap width="17%" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
            <td nowrap width="40%" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Item">&Iacute;tem</cf_translate></td>            
            <td nowrap width="40%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Onservacion">Descrici&oacute;n Alterna</cf_translate></td>
            <td nowrap width="40%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Onservacion">Observaci&oacute;n</cf_translate></td>		
            <td nowrap width="2%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Cant">Cant</cf_translate>.</td>
            <td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "><cf_translate key="LB_Unidad">Unidad</cf_translate></td>
            <td nowrap width="10%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "><cf_translate key="LB_CtrFuncional">Ctro.Funcional</cf_translate></td>
            <td nowrap width="10%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "><cf_translate key="LB_Almacen">Almac&eacute;n</cf_translate></td>
            <td nowrap width="7%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; "><cf_translate key="LB_Requisicion">Requisici&oacute;n</cf_translate></td>
            <td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_Impuesto">Impuesto</cf_translate></td> 
            <td nowrap width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><cf_translate key="LB_TotalEstimadoLinea">Total Estimado L&iacute;nea</cf_translate></td>		
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
				<td width="5%" style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#DSconsecutivo#&nbsp;</td>
				<td width="17%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#codigo#&nbsp;</td>
				<td width="20%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DSdescripcion#&nbsp;</td>
                <td width="60%" style="min-width:190px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DSdescalterna#&nbsp;</td>
                <td width="40%" style="min-width:120px border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DSobservacion#&nbsp;</td>	
                <td nowrap width="2%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DScant#&nbsp;</td>		
				<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#trim(Ucodigo)#&nbsp;</td>
				<td nowrap width="10%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#CFcodigo#&nbsp;</td>
				<td nowrap width="10%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Almcodigo#&nbsp;</td>
				<td nowrap width="7%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#ERdocumento#&nbsp;</td>
				<td nowrap width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Icodigo#(#Iporcentaje#%)&nbsp;</td> 
				<td width="25%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(DStotallinest,'none')#&nbsp;</td>				
			</tr>
		</cfoutput>
	</cfif>
</table>

<cfoutput>
<table width="99%" align="center"  border="0" cellspacing="2" cellpadding="2" style="border-top:1px solid black; ">
	<cfquery name="rsTotales" datasource="#session.DSN#">
		select coalesce(sum((Iporcentaje*DStotallinest)/100),0) as impuesto, coalesce(sum(DScant*DSmontoest),0) as subtotal
		from ESolicitudCompraCM a
		inner join DSolicitudCompraCM b
			on a.Ecodigo=b.Ecodigo
			and a.ESidsolicitud=b.ESidsolicitud
		inner join Impuestos c
			on a.Ecodigo=c.Ecodigo
			and b.Icodigo=c.Icodigo
		where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ESidsolicitud#">
		and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#consultar_Ecodigo#">
	</cfquery>
	<tr>
		<td rowspan="2" width="100%">&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Subtotal">Subtotal</cf_translate>&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(rsTotales.subtotal,'none')#</td>
	</tr>
	<tr>
		<td nowrap align="right"><cf_translate key="LB_Impuestos">Impuestos</cf_translate>&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(rsTotales.impuesto,'none')#</td>
	</tr>
	<tr>
		<td width="100%">&nbsp;</td>
		<td align="right" nowrap><strong><cf_translate key="LB_Total">Total</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td align="right"><strong>#LSCurrencyFormat(rsTotales.subtotal+rsTotales.impuesto,'none')#</strong></td>
	</tr>
</table> 

</cfoutput>

<cfif not isdefined("url.imprimir")>
<script type="text/javascript" language="javascript1.2" >
	function info(index){
		open('../consultas/Solicitudes-info.cfm?index='+index, 'Solicitudes','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=410,left=250, top=200,screenX=250,screenY=200');	
		//open('Solicitudes-info.cfm?observaciones=DOobservaciones&descalterna=DOalterna&titulo=Ordenes de Compra&index='+index, 'ordenes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
</script>
</cfif>