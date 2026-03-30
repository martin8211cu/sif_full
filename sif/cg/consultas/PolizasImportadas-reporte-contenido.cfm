<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Inicio. --->

<!--- Tags para la traduccion --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Poliza" Default= "P&oacute;liza" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Poliza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PolizaOrigen" Default= "P&oacute;liza Origen" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_PolizaOrigen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default= "Descripci&oacute;n" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default= "Periodo" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default= "Mes" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_fecha" Default= "Fecha" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estatus" Default= "Estatus" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Estatus"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_LineaDeDetalle" Default= "Linea" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_LineaDeDetalle"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MonedaOrigen" Default= "Moneda Origen" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_MonedaOrigen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoOrigen" Default= "Monto Origen" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_MontoOrigen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoCambio" Default= "TC" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_TipoCambio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoLocal" Default= "Monto Local MXP" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_MontoLocal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoOrigenPolizaOrigen" Default= "Monto Origen" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_MontoOrigenPolizaOrigen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoCambioPolizaOrigen" Default= "TC Origen" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_TipoCambioPolizaOrigen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoLocalPolizaOrigen" Default= "Monto Local EUR" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_MontoLocalPolizaOrigen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default= "Cuenta" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Cuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Movimiento" Default= "Movimiento" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Movimiento"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_UsuarioCreador" Default= "P&oacute;liza creada por:" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_UsuarioCreador"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_UsuarioAplicador" Default= "P&oacute;liza aplicada por:" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_UsuarioAplicador"/>

<!--- Origen de las polizas --->
<cfset EmpresaOrigen  = 15>
<cfset EmpresaDestino = 27>

<cfset ListaImg = "JPG,BMP,GIF,PNG">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<!--- Busqueda de Polizas para el reporte --->
<cfquery name="rsEncabezado" datasource="#session.DSN#">
	<!--- Polizas aplicadas ---> 
	select 	h.IDcontable, h.Eperiodo, h.Emes, h.Edocumento, h.Efecha, h.Edescripcion, 
					h.ECusuario as UsuarioCreador, usu.Usulogin as UsuarioAplicador,
					(select Edocumento from HEContables where IDcontable = pt.IDcontableOri and Ecodigo = #EmpresaOrigen#) as PolizaOrigen, 
					pt.IDcontableOri,
					'Aplicada' as Estatus
	from HEContables h
	inner join PolizasTransferidas pt
		on  pt.IDcontable = h.IDcontable
		and pt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	left join  Usuario usu
		on usu.Usucodigo = h.ECusucodigoaplica
	where h.Ecodigo = #session.Ecodigo#
		<cfif isdefined("form.Poliza") and form.Poliza neq "">
	and h.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.Poliza)#">
		</cfif>
		<cfif isdefined("form.fechaInicio") and form.fechaInicio neq "">
	and h.Efecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.fechaInicio,'yyyy-mm-dd') & ' 00:00:00.000'#">
		</cfif>
		<cfif isdefined("form.fechaFin") and form.fechaFin neq "">
	and h.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(form.fechaFin,'yyyy-mm-dd') & ' 00:00:00.000'#">
		</cfif>

	union

	<!--- Polizas NO aplicadas ---> 
	select 	e.IDcontable, e.Eperiodo, e.Emes, e.Edocumento, e.Efecha, e.Edescripcion, 
					e.ECusuario as UsuarioCreador, 'NA' as UsuarioAplicador,
					(select Edocumento from HEContables where IDcontable = pt.IDcontableOri and Ecodigo = #EmpresaOrigen#) as PolizaOrigen, 
					pt.IDcontableOri,
					'No Aplicada' as Estatus
	from EContables e
	inner join PolizasTransferidas pt
		on  pt.IDcontable = e.IDcontable
		and pt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where e.Ecodigo = #session.Ecodigo#
		<cfif isdefined("form.Poliza") and form.Poliza neq "">
	and e.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.Poliza)#">
		</cfif>
		<cfif isdefined("form.fechaInicio") and form.fechaInicio neq "">
	and e.Efecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.fechaInicio,'yyyy-mm-dd') & ' 00:00:00.000'#">
		</cfif>
		<cfif isdefined("form.fechaFin") and form.fechaFin neq "">
	and e.Efecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.fechaFin,'yyyy-mm-dd') & ' 00:00:00.000'#">
		</cfif>
</cfquery>

<!--- Obtiene el nombre del archivo de la pantalla actual --->
<cfset archivo = GetFileFromPath(GetTemplatePath())>
<cfoutput>

	<!--- Pintado de la Información --->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
    <td valign="top" alang="center">
	<table width="100%" cellpadding="2" cellspacing="0" align="center">
		<tr><td nowrap>&nbsp;</td></tr>
		<tr><td nowrap>&nbsp;</td></tr>
		<tr><td nowrap>&nbsp;</td></tr>
			<cfloop query="rsEncabezado">
				<!--- Buscar los detalles de la poliza --->
				<cfquery name="rsDetalle" datasource="#session.DSN#">
						<!--- Buscar los detalles de la poliza si aun no se ha aplicado --->
						select 	d.Dlinea, d.Ddescripcion, d.Doriginal, d.Dlocal, d.Dtipocambio, d.Dmovimiento, m.Miso4217,
										hd.Doriginal as MontoOrigenPolizaOrigen, hd.Dtipocambio as TipoCambioPolizaOrigen,
										hd.Dlocal as MontoLocalPolizaOrigen, cc.Cformato as Cuenta
						from DContables d
						inner join HDContables hd
							on  hd.Ecodigo = #EmpresaOrigen#
							and hd.IDcontable = #rsEncabezado.IDcontableOri#
							and hd.Dlinea = d.Dlinea
						inner join CContables cc
							on  cc.Ecodigo = #session.Ecodigo#
							and cc.Ccuenta = d.Ccuenta
						inner join Monedas m
							on  m.Ecodigo = d.Ecodigo
							and m.Mcodigo = d.Mcodigo
						where d.Ecodigo = #session.Ecodigo#
						and d.IDcontable = #rsEncabezado.IDcontable#

						union

						<!--- Buscar los detalles de la poliza si ya se aplico --->
						select 	h.Dlinea, h.Ddescripcion, h.Doriginal, h.Dlocal, h.Dtipocambio, h.Dmovimiento, m.Miso4217,
										hd.Doriginal as MontoOrigenPolizaOrigen, hd.Dtipocambio as TipoCambioPolizaOrigen,
										hd.Dlocal as MontoLocalPolizaOrigen, cc.Cformato as Cuenta
						from HDContables h
						inner join HDContables hd
							on  hd.Ecodigo = #EmpresaOrigen#
							and hd.IDcontable = #rsEncabezado.IDcontableOri#
							and hd.Dlinea = h.Dlinea
						inner join CContables cc
							on  cc.Ecodigo = #session.Ecodigo#
							and cc.Ccuenta = h.Ccuenta
						inner join Monedas m
							on  m.Ecodigo = h.Ecodigo
							and m.Mcodigo = h.Mcodigo
						where h.Ecodigo = #session.Ecodigo#
						and h.IDcontable = #rsEncabezado.IDcontable#
					</cfquery>

				<tr>
					<td style="width: 100px;" nowrap align="right">#LB_Poliza#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.Edocumento#</strong></td>
				</tr>
				<tr>
					<td style="width: 100px;" nowrap align="right">#LB_PolizaOrigen#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.PolizaOrigen#</strong></td>
				</tr>
				<tr>
					<td style="width: 100px;" nowrap align="right">#LB_Descripcion#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.Edescripcion#</strong></td>
				</tr>

				<tr>
					<td nowrap align="right">#LB_Periodo#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.Eperiodo#</strong></td>
				</tr>
				<tr>
					<td style="width: 100px;" nowrap div align="right">#LB_Mes#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.Emes#</strong></td>
				</tr>
				<tr>
					<cfset fecha = LSDateFormat(#rsEncabezado.Efecha#,'dd/mm/yyyy')>
					<td style="width: 100px;" nowrap align="right">#LB_fecha#:</td>
					<td style="width: 100px;"><strong>#fecha#</strong></td>
				</tr>
				<tr>
					<td style="width: 100px;" nowrap div align="right">#LB_UsuarioCreador#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.UsuarioCreador#</strong></td>
				</tr>
				<tr>
					<td style="width: 100px;" nowrap div align="right">#LB_Estatus#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.Estatus#</strong></td>
				</tr>
				<tr>
					<td style="width: 100px;" nowrap div align="right">#LB_UsuarioAplicador#:</td>
					<td style="width: 100px;"><strong>#rsEncabezado.UsuarioAplicador#</strong></td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td style="width: 100px;" nowrap div align="left">#LB_LineaDeDetalle#</td>
					<td style="width: 100px;" nowrap div align="left">#LB_Descripcion#</td>
					<td style="width: 100px;" nowrap div align="left">#LB_Movimiento#</td>
					<td style="width: 100px;" nowrap div align="left">#LB_Cuenta#</td>
					<td style="width: 100px;" nowrap div align="left">#LB_MonedaOrigen#</td>
					<td style="width: 100px;" nowrap div align="left">#LB_MontoOrigenPolizaOrigen#</td>
					<td style="width: 100px;" nowrap div align="left">#LB_TipoCambioPolizaOrigen#</td>	
					<td style="width: 100px;" nowrap div align="left">#LB_MontoLocalPolizaOrigen#</td>
					<td style="width: 100px;" nowrap div align="left">#LB_TipoCambio#</td>	
					<td style="width: 100px;" nowrap div align="left">#LB_MontoLocal#</td>	
				</tr>	

				<cfloop query="rsDetalle">
					<tr>
						<td style="width: 100px;" nowrap div align="left">#rsDetalle.Dlinea#</td>
						<td style="width: 100px;" nowrap div align="left">#rsDetalle.Ddescripcion#</td>
						<td style="width: 100px;" nowrap div align="left">#rsDetalle.Dmovimiento#</td>
						<td style="width: 100px;" nowrap div align="left">#rsDetalle.Cuenta#</td>
						<td style="width: 100px;" nowrap div align="left">#rsDetalle.Miso4217#</td>
						<td style="width: 100px;" nowrap div align="left">#NumberFormat("#rsDetalle.MontoOrigenPolizaOrigen#", ",.00" )#</td>
						<td style="width: 100px;" nowrap div align="left">#NumberFormat("#rsDetalle.TipoCambioPolizaOrigen#", ",.0000" )#</td>
						<td style="width: 100px;" nowrap div align="left">#NumberFormat("#rsDetalle.MontoLocalPolizaOrigen#", ",.00" )#</td>	
						<td style="width: 100px;" nowrap div align="left">#NumberFormat("#rsDetalle.Dtipocambio#", ",.0000" )#</td>
						<td style="width: 100px;" nowrap div align="left">#NumberFormat("#rsDetalle.Dlocal#", ",.00" )#</td>
					</tr>	
				</cfloop><!--- rsDetalle --->
				<tr><td nowrap>&nbsp;</td></tr>
				<tr><td nowrap>&nbsp;</td></tr>
			</cfloop><!--- rsEncabezado --->
	</table>
</cfoutput>

<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Fin. --->