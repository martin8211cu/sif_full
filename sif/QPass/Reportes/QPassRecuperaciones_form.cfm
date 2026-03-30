<cfcontent type="application/vnd.ms-excel">
	<cfheader name="Content-Disposition" value="attachment; filename=RecuperacionCobro_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>

	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
		"http://www.w3.org/TR/html4/loose.dtd">
	<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
		<head>
			<title>Consulta Recuperacion Cobranza</title>
			<style type="text/css">
				table
				{mso-displayed-decimal-separator:"\.";
				mso-displayed-thousand-separator:"\,";}
				.numWithoutDec {mso-number-format:\#\,\#\#0?;text-align:right;}
				.numWith2Dec {mso-number-format:Standard;text-align:right}
				.date {mso-number-format:dd\/mm\/yyyy\;\@}

			</style>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<meta http-equiv="content-language" content="es" />
		</head>

<cfif isdefined('form.generar')>
	<!--- Query:
	
		Tabla Principal:  
						QPControl				-- Establece los registros que se consideran tomando la fecha de procesamiento
						
		Tablas:
						QPSalida				-- Contiene los registros que no se bloquearon.  Join por qpl_id ( Lote de Bloqueo )
						
							QPcliente			-- Cliente del banco. Join por QPCente ( ente del banco )
								QPtipoCiente	-- Tipo de Cliente del Banco
								
							QPassTag			-- Maestro de TAGS.  Join desde QPSalida por el TAG
							
							QPventaTags			-- Registro de Ventas.  Join desde QPassTag y QPcliente por QPidtag y QPcteid
								QPventaConvenio	-- Tipos de Convenio de Ventas.  Se accede desde QPventaTags
	--->




 		<cfquery name="rsEmpresa" datasource="#session.dsn#">
			  select Enombre
			  from Empresa
			  where CEcodigo = #session.CEcodigo#
		 </cfquery>


	<cfset fecha = LSDateFormat(form.fecha,'yyyy/mm/dd')>
	<cfset LvarFecha = createdate(year(fecha), month(fecha), day(fecha))>
	<cfset LvarFecha2 = dateadd("s",86399,LvarFecha)>
	
	



	<cfquery datasource="#session.DSN#" name="rsRecupera">
		select

			coalesce(s.qpdl_monto - s.qpdl_monto_no_blq,0) as Monto_Recaudado, 
			c.qpl_fecha_proceso3					as FechaRecaudacion,
			s.qpdl_fecha_blq						as Fecha_movimiento_Recaudar,
			coalesce(s.qpdl_cod_bloqueo, 0.00)		as CodigoBloqueo,
			coalesce(s.qpdl_cod_bloqueo2, 0.00)		as CodigoBloqueo2,
			co.QPvtaConvDesc						as Convenio, 
			s.qpdl_monto							as Monto_Solicitado,
			s.qpdl_monto_no_blq						as Monto_NoBloqueado,
			s.qpdl_PAN 								as Quick_Pass,
			cl.QPcteNombre							as NombreCliente,
			tc.QPtipoCteDes							as tipo_identificacion,
			cl.QPcteDocumento 						as Identificacion,
			s.qpdl_cuenta 							as Cuenta,
			s.qpdl_causa							as causa,
			s.qpdl_moneda							as MonedaBloqueo,
			s.qpdl_moneda_no_blq					as MonedaNoBloqueo
						
		from QPControl c
			inner join QPSalida s
			on s.qpl_id = c.qpl_id

				inner join QPassTag mt
				on mt.QPTPAN = s.qpdl_PAN
				
				inner join QPcliente cl
				on cl.QPCente = s.qpdl_ente

					inner join QPtipoCliente tc
					on tc.QPtipoCteid = cl.QPtipoCteid 

				inner join QPventaTags v
				on  v.QPcteid = cl.QPcteid
				and v.QPTidTag = mt.QPTidTag
				and v.QPvtaEstado = 1

							left outer join QPventaConvenio co
							on co.QPvtaConvid = v.QPvtaConvid 

		where c.qpl_fecha_proceso3  >= #LvarFecha#  
		  and c.qpl_fecha_proceso3  <  #LvarFecha2#
		  and coalesce(s.qpdl_monto_no_blq, 0.00) <> 0
	</cfquery>

	
		<table>
			<cfoutput>
			<tr>
				<td colspan="15" align="center"><strong>#rsEmpresa.Enombre#</strong></td>
			</tr>
			<tr>
				<td colspan="15" align="center"><strong>Sistema de Telepeaje QuickPass</strong></td>
			</tr>
			<tr>
				<td colspan="15" align="center">Reporte de Montos No Bloqueados a #dateformat(LvarFecha, "DD/MM/YYYY")#</td>
			</tr>
			<tr>
				<td colspan="15">&nbsp;</td>
			</tr>
			</cfoutput>
			<tr>
				<td align="right"><strong>Fecha Recaudacion</strong></td>
				<td align="right"><strong>Fecha Movimiento</strong></td>
				<td align="left"><strong>Codigo Bloqueo</strong></td>
				<td align="left"><strong>Codigo Bloqueo2</strong></td>
				<td align="left"><strong>Convenio</strong></td> 
				<td align="left"><strong>Causa</strong></td>
				<td align="right"><strong>Monto Total del Movimiento</strong></td>
				<td align="left"><strong>Moneda</strong></td>
				<td align="left"><strong>Monto Recaudado</strong></td>
				<td align="right"><strong>Monto Pendiente de Recaudar</strong></td>
				<td align="left"><strong>Moneda NB</strong></td>
				<td align="left"><strong>Quick Pass</strong></td>
				<td align="left"><strong>Nombre Cliente</strong></td>
				<td align="left"><strong>tipo Identificacion</strong></td>
				<td align="left"><strong>Identificacion</strong></td>
				<td align="left"><strong>Cuenta</strong></td>
			</tr>
			<cfoutput query="rsRecupera">
				<tr>
					<td>#DateFormat(FechaRecaudacion,'dd/mm/yyyy')#</td>
					<td>#DateFormat(Fecha_movimiento_Recaudar,'dd/mm/yyyy')#</td>
					<td x:str>#CodigoBloqueo#</td>
					<td x:str>#CodigoBloqueo2#</td>
					<td x:str>#Convenio#</td> 
					<td x:str>#causa#</td>
					<td class=numWith2Dec x:num>#Monto_Solicitado#</td>
					<td x:str>#MonedaBloqueo#</td>
					<td class=numWith2Dec x:num>#Monto_Recaudado#</td>
					<td class=numWith2Dec x:num>#Monto_NoBloqueado#</td>
					<td x:str>#MonedaNoBloqueo#</td>
					<td x:str>#Quick_Pass#</td>
					<td x:str>#NombreCliente#</td>
					<td x:str>#tipo_identificacion#</td>
					<td x:str>#Identificacion#</td>
					<td x:str>#Cuenta#</td>
				</tr>
			</cfoutput>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="15">Tipos de Cambio de Referencia:</td>
			</tr>
			<tr>
				<td>Moneda</td>
				<td align="right">Compra</td>
				<td align="right">Venta</td>
				<td align="right">Promedio</td>
			</tr>

<cfquery name="rsTiposCambio" datasource="#session.DSN#">
		select m.Miso4217 as Moneda,
			min(m.Mcodigo) as Mcodigo, 
			max(tc.TCcompra) as Compra, 
			max(tc.TCventa) as Venta, 
			max(tc.TCpromedio) as Promedio
		from Monedas m
			inner join Htipocambio tc
			 on tc.Mcodigo = m.Mcodigo
			and tc.Ecodigo = m.Ecodigo
			and tc.Hfecha  <= #LvarFecha#
			and tc.Hfechah >  #LvarFecha2#
		where m.Ecodigo = #session.Ecodigo#
		group by Miso4217
	</cfquery>
			<cfoutput query="rsTiposCambio">
				<tr>
					<td x:str>#Moneda#</td>
					<td x:num>#Compra#</td>
					<td x:num>#Venta#</td>
					<td x:num>#Promedio#</td>
				</tr>
			</cfoutput>
		</table>
	</html>
</cfif>

