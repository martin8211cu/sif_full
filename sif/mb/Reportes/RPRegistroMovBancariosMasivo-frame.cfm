<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoHayDatosParaReportar" default="No hay datos para reportar" returnvariable="MSG_NoHayDatosParaReportar" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalCuenta" default="Total Cuenta" returnvariable="LB_TotalCuenta" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Banco" default="BANCO" returnvariable="LB_Banco" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Transaccion" default="Transacci&oacute;n" returnvariable="LB_Transaccion" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoCambio" default="Tipo Cambio" returnvariable="LB_TipoCambio" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoDocumento" default="Monto del Documento" returnvariable="LB_MontoDocumento" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoDocumentoMonedaLocal" default="Monto del Documento Moneda Local" returnvariable="LB_MontoDocumentoMonedaLocal" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentasPorCobrar" default="Cuentas por Cobrar" returnvariable="LB_CuentasPorCobrar" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentasPorPagar" default="Cuentas por Pagar" returnvariable="LB_CuentasPorPagar" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cliente" default="Cliente" returnvariable="LB_Cliente" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Proveedor" default="Proveedor" returnvariable="LB_Proveedor" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CodigoTransaccion" default="C&oacute;digo de Transacci&oacute;n" returnvariable="LB_CodigoTransaccion" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Direccion" default="Direcci&oacute;n" returnvariable="LB_Direccion" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" returnvariable="LB_Monto" xmlfile="Movimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoMonedaLocal" default="Monto Moneda Local" returnvariable="LB_MontoMonedaLocal" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pagina" default="P&aacute;gina" returnvariable="LB_Pagina" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalGeneral" default="Total General" returnvariable="LB_TotalGeneral" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RegistroMovimientosBancarios" default="Registro de Movimientos Bancarios" returnvariable="LB_RegistroMovimientosBancarios" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ImpresionMovimientosBancarios" default="Impresi&oacute;n del Registro de Movimientos Bancarios" returnvariable="LB_ImpresionMovimientosBancarios" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ImpresionMovimientosTarjetaCredito" default="Impresi&oacute;n del Registro de Movimientos de Tarjetas de Cr&eacute;dito" returnvariable="LB_ImpresionMovimientosTarjetaCredito" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RegistroMovimientosTarjetaCredito" default="Registro de Movimientos de Tarjetas de Cr&eacute;dito Empresariales" returnvariable="LB_RegistroMovimientosTarjetaCredito" xmlfile="RPRegistroMovBancariosMasivo-frame.xml"/>


<cfsetting enablecfoutputonly="no">
<cfif isdefined("url.lista") and  not isdefined("form.lista")>
	<cfset form.lista = url.lista>
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfset datos = ''>
<cfset i = 1>
<cfloop index = "index" list = "#form.lista#" delimiters = ",">
	<cfset datos = ListAppend(datos,#index#)>
</cfloop>
<cfif LEN(datos) EQ 0>
	<cfset datos = "-1">
</cfif>
<cfquery name="rsReporte" datasource="#session.DSN#"><!--- Recibe por url la varible varTCE para indicar si es un reporte para TCE--->
	select 
		a.EMid,
		a.EMfecha, 
		a.EMdocumento, 
		a.EMtipocambio, 
		a.EMdescripcion,
		a.EMtotal * case when c.BTtipo ='D' then 1 else -1 end as EMtotal,
		c.BTdescripcion,
		c.BTtipo,
		d.CBcodigo,
		d.CBdescripcion, 
		e.Bdescripcion, 
		f.Mnombre, 
		(( select i.Cformato from CContables i where i.Ccuenta = d.Ccuenta)) as CformatoEnc,
		(( select i.Cdescripcion from CContables i where i.Ccuenta = d.Ccuenta)) as CdescripcionEnc,
		a.SNcodigo,
		a.id_direccion,
		a.TpoSocio,
		a.TpoTransaccion,
		a.Documento,
		a.SNid
	from EMovimientos a 
		inner join CuentasBancos d

			inner join Bancos e
			on e.Bid = d.Bid 

			inner join Monedas f
			on d.Mcodigo = f.Mcodigo 

		on d.CBid = a.CBid 

		inner join BTransacciones c
		  on c.BTid    = a.BTid 
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and d.CBesTCE = #url.varTCE#
	  and a.EMid in (#datos#)
	order by e.Bdescripcion, d.CBcodigo, a.EMdocumento
</cfquery>


<cfif rsReporte.recordcount LT 1>
	<cfoutput>
	<table align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center">-----#MSG_NoHayDatosParaReportar#-----</td></tr>
	</table>
	</cfoutput>
	<cfabort>
</cfif>
<cfset LvarNumeroLinea = 60>
<cfset LvarPagina = 0>
<cfset LvarBdescripcion = "">
<cfset LvarCBcodigo = "">

<cfoutput>
	<style type="text/css">
	<!--
	.style1 {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 14px;
		font-weight: bold;
	}
	.style2 {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 10px;
	}
	.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
	
	.style4 {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 11px;
		font-weight: bold;	
	}
	.style5 {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 11px;

	}
	.style6 {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 7px;
	}
	-->
	</style>
	

	<cfif trim(#url.varTCE#) EQ 1><!--- Cambia títulos y encabezados si es un reporte para TCE--->
		<cfset Pagina="../../tce/operaciones/TCEListaMovimientos.cfm">
		<cfset titulo="#LB_ImpresionMovimientosTarjetaCredito#">
		<cfset subtitulo="#LB_RegistroMovimientosTarjetaCredito#">
		<cfset filesName="MovTCEmpresariales.xls">
	<cfelse>
		<cfset Pagina="../../mb/operacion/listaMovimientos.cfm">
		<cfset titulo="#LB_ImpresionMovimientosBancarios#">
		<cfset subtitulo="#LB_RegistroMovimientosBancarios#">
		<cfset filesName="MovBancarios.xls">
	</cfif>
<cf_htmlReportsHeaders 
	title="#titulo#" 
	filename="#filesName#"
	irA="#Pagina#"
	download="no"
	preview="no">
	
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<cfset LvarSumaDetallesA = 0.00>
<cfset LvarSumaDetallesAML = 0.00><!--- total moneda local--->
<cfset LvarSumaDetallesB = 0.00>
<cfset LvarSumaDetallesBML = 0.00><!--- total general moneda local--->
</cfoutput>

<cfset tmpM=0><!--- temporal para almacenar monto--->
<cfset tmpCamb=0><!---temporal para almacenar tipo cambio--->
<cfset tmpML=0><!---temporal para almacenar monto de moneda local--->

<cfloop query="rsReporte">
	
	<cfif (rsReporte.CBcodigo NEQ LvarCBcodigo) and LvarCBcodigo neq "">
		<cfoutput>
			<tr class="style4">
				<td align="left" colspan="6">:</td>
				<td align="right" colspan="1">#LB_TotalCuenta##numberFormat(LvarSumaDetallesA,',.00')#</td>
				<td align="right" colspan="1">#numberFormat(LvarSumaDetallesAML,',.00')#</td>
			</tr>
			<tr class="style6">
				<td colspan="7">&nbsp;</td>
			</tr>
			<cfset LvarSumaDetallesA = 0.00>
			<cfset LvarSumaDetallesAML = 0.00>
		</cfoutput>
	</cfif>
	<cfset imprimirEncabezado()>
	<cfif rsReporte.Bdescripcion NEQ LvarBdescripcion>
		<cfoutput>
		<tr class="style1">
			<td colspan="8" bgcolor="##E4E4E4"><cfoutput>#LB_Banco#</cfoutput>: #Bdescripcion#</td>
		</tr>
		</cfoutput>
		<cfset LvarNumeroLinea = LvarNumeroLinea + 1>
		<cfset LvarBdescripcion = rsReporte.Bdescripcion>
	</cfif>

	<cfset imprimirEncabezado()>
	<cfif rsReporte.CBcodigo NEQ LvarCBcodigo>
		
		<cfoutput>
		<tr class="style1">
			<td colspan="8" bgcolor="##E4E4E4">#UCase(LB_Cuenta)#: #CBcodigo# - #CBdescripcion#</td>
		</tr>
		</cfoutput>
		<cfset LvarNumeroLinea = LvarNumeroLinea + 1>
		<cfset LvarCBcodigo = rsReporte.CBcodigo>
	</cfif>
	<cfset imprimirEncabezado()>
	<cfoutput>

	<tr class="style5">
		<td colspan="3">#LB_Fecha#: #dateformat(rsReporte.EMfecha, "DD/MM/YYYY")#</td>
		<td colspan="4">#LB_Transaccion#: #rsReporte.BTdescripcion#</td>
		<td>&nbsp;</td>
	</tr>
	<tr class="style5">
		<td colspan="3">#LB_Documento#: #rsReporte.EMdocumento#</td>
		<td colspan="4">#LB_Moneda#: #rsReporte.Mnombre#</td>
		<td>&nbsp;</td>
	</tr>
	<tr class="style5">
		<td colspan="3">#LB_Cuenta#: #rsReporte.CdescripcionEnc#</td>
		<td colspan="3">#LB_TipoCambio#: #NumberFormat(rsReporte.EMtipocambio, ",.0000")#</td>
		<td colspan="1" align="right">#LB_MontoDocumento#: #NumberFormat(rsReporte.EMtotal, ",.00")#</td>
		<cfset tmpM=rsReporte.EMtotal>
		<cfset tmpCamb=rsReporte.EMtipocambio>
		<cfset tmpML=(tmpM*tmpCamb)>
		<td colspan="1" align="right">#LB_MontoDocumentoMonedaLocal#: #NumberFormat(tmpML, ",.00")#</td>
		
	</tr>
	</cfoutput>

 	<cfset LvarNumeroLinea = LvarNumeroLinea + 3>
	<cfset LvarMultiplicador = 1>
	
	<cfif rsReporte.BTtipo EQ 'C'>
		<cfset LvarMultiplicador = -1>
	</cfif>
	<cfif isdefined("rsReporte.SNcodigo") and len(trim(rsReporte.SNcodigo)) GT 0>
			<cfquery name="rsSocio" datasource="#session.dsn#">
				select s.SNnumero, s.SNnombre, s.SNidentificacion
				from SNegocios s
				where s.SNid = #rsReporte.SNid#
			</cfquery>
			<cfquery name="rsDireccion" datasource="#session.dsn#">
				select SNDcodigo, SNcodigoext, SNnombre
				from SNDirecciones di
				where di.SNid = #rsReporte.SNid#
				  and di.id_direccion = #rsReporte.id_direccion#
			</cfquery>
			<cfset imprimirEncabezado()>
			<cfoutput>
			<tr class="style5">
				<td colspan="7" >&nbsp;</td>
			</tr>
			<tr class="style5">
				<td colspan="7" align="center"><strong>*** <cfif rsReporte.TpoSocio eq 1>#LB_CuentasPorCobrar#<cfelse>#LB_CuentasPorPagar#</cfif> ***</strong></td>
			</tr>
			<tr class="style5">
				<td colspan="5"><cfif rsReporte.TpoSocio eq 1>#LB_Cliente#<cfelse>#LB_Proveedor#</cfif>:&nbsp;#rsSocio.SNnumero#&nbsp;#rsSocio.SNidentificacion#&nbsp;#rsSocio.SNnombre#</td>
				<td colspan="2" align="right">#LB_CodigoTransaccion#: #rsReporte.TpoTransaccion#</td>
			</tr>
			<tr class="style5">
				<td colspan="7">#LB_Direccion#: #rsDireccion.SNDcodigo# #rsDireccion.SNcodigoext# #rsDireccion.SNnombre#</td>
			</tr>
			<tr class="style5">
				<td colspan="7">#LB_Descripcion#: #rsReporte.EMdescripcion#</td>
			</tr>
			<tr class="style5">
				<td colspan="7" >&nbsp;</td>
			</tr>
			</cfoutput>
			<cfset LvarNumeroLinea = LvarNumeroLinea + 5>
	<cfelse>
		<cfquery name="rsDetalleMovBanco" datasource="#session.DSN#">
			select 
				b.DMdescripcion,
				g.Cformato,
				g.Cdescripcion,
				round(b.DMmonto, 2) * #LvarMultiplicador# as DMmonto
			from DMovimientos b
					inner join CContables g
					on b.Ccuenta = g.Ccuenta 
			where b.EMid    = #rsReporte.EMid#
			order by DMlinea
		</cfquery>
		<cfif rsDetalleMovBanco.recordcount LT 1>
			<cfset imprimirEncabezado()>
			<cfoutput>
			<tr class="style5">
				<td>&nbsp;</td>
				<td colspan="6" align="center"><strong>*** #UCase(MSG_NoHayDatosParaReportar)# ***</strong></td>
			</tr>
			<tr class="style6">
				<td>&nbsp;</td>
				<td colspan="2">&nbsp;</td>
				<td>&nbsp;</td> 
				<td colspan="2">&nbsp;</td>
				<td align="right">&nbsp;</td>
			</tr>
			</cfoutput>
			<cfset LvarNumeroLinea = LvarNumeroLinea + 2>
		<cfelse>
			<cfset imprimirEncabezado()>
			<cfoutput>
				<tr class="style6">
					<td>&nbsp;</td>
					<td colspan="2">&nbsp;</td>
					<td>&nbsp;</td> 
					<td colspan="2">&nbsp;</td>
					<td align="right">&nbsp;</td>
				</tr>
				<tr class="style5">
					<td>&nbsp;</td>
					<td colspan="2"><strong>#LB_Descripcion#</strong></td>
					<td><strong>#LB_Cuenta#</strong></td> 
					<td colspan="2">&nbsp;</td>
					<td align="right"><strong>#LB_Monto#</strong></td>
					<td align="right"><strong>#LB_MontoMonedaLocal#</strong></td>
				</tr>
			</cfoutput>
			<cfset LvarNumeroLinea = LvarNumeroLinea + 2>
			

			<cfoutput query="rsDetalleMovBanco">
				<cfset imprimirEncabezado()>
				<tr class="style5">
					<td>&nbsp;</td>
					<td colspan="2">#rsDetalleMovBanco.DMdescripcion#</td>
					<td>#rsDetalleMovBanco.Cformato#</td> 
					<td colspan="2">#rsDetalleMovBanco.Cdescripcion#</td>
					<td align="right">#numberformat(rsDetalleMovBanco.DMmonto, ",.00")# </td>
					<cfset tmpM=rsDetalleMovBanco.DMmonto>
					<cfset tmpCamb=rsReporte.EMtipocambio>
					<cfset tmpML=(tmpM*tmpCamb)>
					<td align="right">#numberformat(tmpML, ",.00")# </td>
				</tr>
				
				<cfset LvarNumeroLinea = LvarNumeroLinea + 1>
			</cfoutput>
			<cfoutput>
				<tr class="style6">
					<td>&nbsp;</td>
					<td colspan="2">&nbsp;</td>
					<td>&nbsp;</td> 
					<td colspan="2">&nbsp;</td>
					<td align="right">&nbsp;</td>
				</tr>
			</cfoutput>
			<cfset LvarNumeroLinea = LvarNumeroLinea + 1>
		</cfif>
		
	</cfif>
	<cfif rsReporte.CBcodigo NEQ LvarCBcodigo >
		<cfset LvarCBcodigo = rsReporte.CBcodigo>
	</cfif>
	<cfif rsReporte.Bdescripcion NEQ LvarBdescripcion>
		<cfset LvarBdescripcion = rsReporte.Bdescripcion>
	</cfif>
	<cfset LvarSumaDetallesA = LvarSumaDetallesA + rsReporte.EMtotal>
	<cfset LvarSumaDetallesAML = LvarSumaDetallesAML + (rsReporte.EMtotal*rsReporte.EMtipocambio)>
	<cfset LvarSumaDetallesB = LvarSumaDetallesB + rsReporte.EMtotal>
	<cfset LvarSumaDetallesBML = LvarSumaDetallesBML + (rsReporte.EMtotal*rsReporte.EMtipocambio)>
	<tr>
		<td colspan="8" style="border-top:outset; border-width:thin">&nbsp;</td>
	</tr>
	<cfset LvarNumeroLinea = LvarNumeroLinea + 1>
	
	
</cfloop>
<cfif (rsReporte.CBcodigo NEQ LvarCBcodigo) and LvarCBcodigo neq "">
	<cfoutput>
		<tr class="style4">
			<td align="left" colspan="6">#LB_TotalCuenta#:</td>
			<td align="right" colspan="1">#numberFormat(LvarSumaDetallesA,',.00')#</td>			
			<td align="right" colspan="1">#numberFormat(LvarSumaDetallesAML,',.00')#</td>
		</tr>
		<cfset LvarSumaDetallesA = 0.00>
	</cfoutput>
</cfif>

<cfoutput>
	<tr>
	<td align="left" colspan="8">&nbsp;</td>
	</tr>
	<tr class="style4" style="background:##f0f0f0; ">
		<td align="left" colspan="6">#LB_TotalGeneral#:</td>
		<td align="right" colspan="1"><!---#numberFormat(LvarSumaDetallesB,',.00')#---></td><!--- suma total general monto cuenta --->
		<td align="right" colspan="1">#numberFormat(LvarSumaDetallesBML,',.00')#</td><!--- suma total general moneda local --->
	</tr>

	</table>
</cfoutput>

	<!---
	<cfreport format="#form.formato#" template= "RPRegistroMovBancariosMasivo.cfr" query="rsReporte">
	<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
		<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
	</cfif>
	</cfreport>
	--->

<cffunction name="imprimirEncabezado">
	<cfif LvarNumeroLinea GT 55>
		<cfset LvarPagina = LvarPagina + 1>
		<cfif LvarPagina GT 1>
			<cfoutput>
			</table>
			<br style='page-break-after:always'>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			</cfoutput>
		</cfif>
		<cfoutput>
			<tr class="style1">
				<td colspan="4" align="left" bgcolor="##E4E4E4">#LB_Fecha#: #DateFormat(now(), "DD/MM/YYYY")#</td>
				<td colspan="4" align="right" bgcolor="##E4E4E4">#LB_Pagina#: #LvarPagina#</td>
			</tr>
			<tr>
				<td colspan="8" align="center" bgcolor="##E4E4E4"><strong>#Session.Enombre#</strong></td>
			</tr>
			<tr>
				<td colspan="8" align="center" bgcolor="##E4E4E4"><strong>#subtitulo#</strong></td>
			</tr>
			<tr class="style6">
				<td colspan="8" align="center" bgcolor="##E4E4E4">&nbsp;</td>
			</tr>
		</cfoutput>
		<cfset LvarNumeroLinea = 4>
		<cfif LvarPagina EQ 1>
			<cfflush interval="128">
		</cfif>
	</cfif>
</cffunction>
