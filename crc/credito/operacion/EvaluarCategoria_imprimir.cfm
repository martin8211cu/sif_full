
	<!--- 
	Creado por Jose Gutierrez 
		27/04/2018
	 --->
<html>
	<head>
		<meta http-equiv="content-type" content="text/plain; charset=UTF-8"/>
	</head>
	<body>	
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		
		<cfset LB_Titulo1 				= t.Translate('LB_Titulo1','Tiendas Full')>
		<cfset LB_Titulo2				= t.Translate('LB_Titulo2','Actualizacion de Categoria')>
		<cfset LB_Titulo3				= t.Translate('LB_Titulo3','Generado el')>
		<cfset LB_Titulo4				= t.Translate('LB_Titulo4','Actualizaci&oacute;n de Categor&iacute;a')>
		<cfset LB_Cuenta				= t.Translate('LB_Cuenta','Cuenta')>
		<cfset LB_Nombre				= t.Translate('LB_Nombre','Nombre')>
		<cfset LB_PromVentas			= t.Translate('LB_PromVentas','Promedio de Ventas')>
		<cfset LB_CategoriaActual		= t.Translate('LB_CategoriaActual','Categor&iacute;a Actual')>
		<cfset LB_CategoriaNueva 		= t.Translate('LB_CategoriaNueva', 'Categor&iacute;a Nueva')>
		<cfset LB_CategoriaFinal 		= t.Translate('LB_CategoriaFinal', 'Categor&iacute;a Final')>
		<cfset LB_FechaMod		 		= t.Translate('LB_FechaMod', 'Fecha de Modificaci&oacute;n')>
		<cfset LB_Movimiento 			= t.Translate('LB_Movimiento', 'Movimiento')>
		<cfset LB_Seleccione 			= t.Translate('LB_Seleccione', 'Seleccione')>
		<cfset LB_Aplicar 				= t.Translate('LB_Aplicar', 'Aplicar')>
		<cfset LB_Imprimir 				= t.Translate('LB_Imprimir', 'Imprimir')>
		<cfset LB_SubioCat 				= t.Translate('LB_SubioCat', 'Subi&oacute; de categor&iacute;a')>
		<cfset LB_BajoCat 				= t.Translate('LB_BajoCat', 'Bajo de categor&iacute;a')>
		<cfset LB_SinCambio 			= t.Translate('LB_SinCambio', 'No hay cambios')>
		<cfset BTN_Filtrar	 			= t.Translate('BTN_Filtrar', 'Filtrar')>
		
		<cfif isDefined('form.formPeriodo') and #form.formPeriodo# neq ''>
			<cfset form.periodo = #form.formPeriodo#>
		</cfif>
		<cfif isDefined('form.formCsnn') and #form.formCsnn# neq ''>
			<cfset form.considerarSNNuevos = #form.formCsnn#>
		</cfif>
		
		<cfset prevPag="EvaluarCategoria.cfm">
		<cfset targetAction="EvaluarCategoria_imprimir.cfm">
		<cfinclude template="../catalogos/imprimirReporte.cfm" >
		<cfset This.C_PARAM_LIM_ESTADO_CUENTA_PROM = '30000705'>
		
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
		
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_LIM_ESTADO_CUENTA_PROM#",conexion=#session.DSN#,ecodigo=#session.ecodigo#, descripcion="Recibir promociones de categoría hasta estado" )> 
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_LIM_ESTADO_CUENTA_PROM#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset pLimiteEstadoCuentaPromosion = paramInfo.valor>
		
		<cfset considera_nuevos = 0>
		<cfif isDefined('form.considerarSNNuevos') and #form.considerarSNNuevos# eq '1'>
			<cfset considera_nuevos = 1>
		</cfif>
		
		<cfset miperiodo = 1>
		<cfif isDefined('form.periodo') and #form.periodo# neq ''>
			<cfset miperiodo = form.periodo>
		</cfif>
		
		
		<!--- Query para obtener registros a modificar categoria --->
		<cfquery name="rsEvaluarCat" datasource="#session.DSN#">
			select 
					s.SNid, s.SNnombre,
					a.CRCCuentasid idCta,a.primera_venta, 
					b.Monto, 
					c.CRCCategoriaDistid,
					cd.Orden, cd.Descripcion,
					c.Numero,
					case when datediff(month,a.primera_venta,getdate()) >= #form.periodo#
						then round(b.Monto/#form.periodo#,2)
						else round(b.Monto/datediff(month,a.primera_venta,getdate()),2)
					end promedio_venta,
					nc.id idCat, nc.Orden Orden2, nc.Descripcion Descripcion2,
					ec.Descripcion as EstatusCuenta
				from (
					select t.CRCCuentasid, min(t.Fecha) primera_venta 
					from CRCTransaccion t 
					where t.TipoTransaccion = 'VC' 
					group by CRCCuentasid
				) a
				inner join (
					select sum(t.Monto) Monto, t.CRCCuentasid 
					from 
						CRCTransaccion t 
						where t.TipoTransaccion = 'VC'
							and datediff(month,t.fecha, getdate()) <= #form.periodo#
							and datediff(month,t.fecha, getdate()) > 0
					group by CRCCuentasid
				) b on a.CRCCuentasid = b.CRCCuentasid
				inner join CRCCuentas c on c.id = a.CRCCuentasid
				inner join CRCEstatusCuentas ec on c.CRCEstatusCuentasid = ec.id
				inner join SNegocios s on c.SNegociosSNid = s.SNid
				inner join CRCCategoriaDist cd on c.CRCCategoriaDistid = cd.id
				left join (
					select * from CRCCategoriaDist
				) nc on case when datediff(month,a.primera_venta,getdate()) >= #form.periodo#
							then round(b.Monto/#form.periodo#,2)
							else round(b.Monto/datediff(month,a.primera_venta,getdate()),2)
						end between nc.MontoMin and nc.MontoMax
				where (datediff(month,a.primera_venta,getdate()) >= #form.periodo# or #considera_nuevos# = 1)
					AND ec.Orden <
						(SELECT Pvalor
						FROM CRCParametros
						WHERE Pcodigo IN ('30000710'))
					AND nc.Orden <> cd.Orden
		</cfquery>
		
		<!--- Query para obtener las categorias disponibles--->
		<cfquery name="rsCategoriasDis" datasource="#session.DSN#">
			select id, Descripcion 
			from CRCCategoriaDist
			where Ecodigo = #session.Ecodigo#
		</cfquery>
		
		
		<cfoutput>
		
		<!--- Tabla para mostrar resultados a imprimir --->
		<div id="#printableArea#">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
					
						<table  width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr><td colspan="4">&nbsp;</td></tr>
							
							<tr>
								<td height="22" align="center" width="40%">
									<span class="style1" style="font-family: verdana; font-size: 200%">#LB_Titulo1#</span><br>
									<span style="font-family: verdana; font-size: 100%"><strong>#LB_Titulo4#</strong><br></span>
									<strong>#LB_Titulo3# #LSDateFormat(Now(),'dd/mm/yyyy')#</strong><br>
								</td>
							</tr>
							<tr height="22" align="center"></tr>
							<tr>
								<table width="100%" border="0">
									<tr style="background-color: ##A9A9A9;">
										<td>No. Cuenta</td>
										<td>#LB_Nombre#</td>
										<td>#LB_PromVentas#</td>
										<td>#LB_CategoriaActual#</td>
										<td>#LB_CategoriaFinal#</td>
										<td>#LB_Movimiento#</td>
										<!---
										<td>#LB_FechaMod#</td>
										
										<td>#LB_CategoriaNueva#</td>
										--->
									</tr>
									<cfif rsEvaluarCat.RecordCount gt 0>
										<cfset cont = 1>
										<cfif isDefined('form.catNueva') and #form.catNueva# neq ''>
											<cfset arr = listToArray (#form.catNueva#)>
										</cfif>
										
										<cfloop query="rsEvaluarCat">
											<cfif isDefined('arr')>
												<cfset categoriaNueva = arr[cont]>
											</cfif>
											<tr>
											<td>#Numero#</td>
											<td>#SNnombre#</td>
											<td>#LSNumberFormat(promedio_venta,',9.00')#</td>
											<td>#descripcion#</td>
											<td>
												#descripcion2#
											</td>
											<td>
												<cfif #Orden2# gt #Orden#  >
													#LB_SubioCat#
												<!--- <cfelseif #nuevaCategoria# lt #idCat#>
													#LB_BajoCat# --->
												<cfelse> 
													#LB_BajoCat#
												</cfif>
		
											</td>
										</tr>
											<cfset cont++>
										</cfloop>
									<cfelse>
											<tr><td colspan="6">&nbsp;</td></tr>
											<tr><td colspan="6" align="center"><font color="red"><span style="text-align: center;">--- No se encontraron resultados ---</span></font></td></tr>
									</cfif>
								</table>
							</tr>
						</table>
					</td>	
				</tr>
			</table>
		</div>
		
		</cfoutput>
	</body>
</html>
