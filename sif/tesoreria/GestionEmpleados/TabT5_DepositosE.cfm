<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloListaComprobantesRecepcionCajaEjectivoEntregados" default ="Lista de Comprobantes de Recepcion de Caja de Efectivo Entregados" returnvariable="LB_TituloListaComprobantesRecepcionCajaEjectivoEntregados" xmlfile = "TabT5_DepositosE.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Caja" default ="Caja" returnvariable="LB_Caja" xmlfile = "TabT5_DepositosE.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Comprobante" default ="Comprobante" returnvariable="LB_Comprobante" xmlfile = "TabT5_DepositosE.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default ="Fecha" returnvariable="LB_Fecha" xmlfile = "TabT5_DepositosE.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MonedaDeposito" default ="Moneda Dep&oacute;sito" returnvariable="LB_MonedaDeposito" xmlfile = "TabT5_DepositosE.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoDeposito" default ="Monto Dep&oacute;sito" returnvariable="LB_MontoDeposito" xmlfile = "TabT5_DepositosE.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoLiq" default ="Monto LIQ" returnvariable="LB_MontoLiq" xmlfile = "TabT5_DepositosE.xml">

<cfif form.GELid NEQ "">

	<cfquery datasource="#session.dsn#" name="listaDep">
		select 
			a.GELDEid,
			a.GELDreferencia,
			a.GELDtotalOri,
			a.GELDtotal,
			a.GELid,
			a.GELDfecha,
			a.CCHid,
			(select Mo.Miso4217
				from Monedas Mo
				where DL.Mcodigo=Mo.Mcodigo
			)as MonedaEncabezado,
			a.Mcodigo, m.Miso4217,
			b.CCHid,
			b.CCHcodigo
		from GEliquidacionDepsEfectivo a
			inner join Monedas m
				on m.Mcodigo = a.Mcodigo
			inner join CCHica b 
				 on b.CCHid=a.CCHid
				and b.CCHtipo in (2,3)
			inner join GEliquidacion DL
				on DL.GELid = a.GELid
		where a.GELid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GELid#">
	</cfquery>
	
</cfif>
<!---LISTA--->

<table width="100%" border="0" align="left" >
	<tr>
		<td width="100%" valign="top">
			<cfset titulo = '#LB_TituloListaComprobantesRecepcionCajaEjectivoEntregados#'>
			<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#" width="70%">
			
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#listaDep#"
					desplegar="CCHcodigo,GELDreferencia,GELDfecha,Miso4217,GELDtotalOri,GELDtotal"
					etiquetas="#LB_Caja#, #LB_Comprobante#, #LB_Fecha#, #LB_MonedaDeposito#, #LB_MontoDeposito#, #LB_MontoLiq#. #listaDep.MonedaEncabezado#"
					formatos="S,S,D,S,M,M"
					align="left,right,center,right,right,right"
					showLink="no"
					form_method="post"	
					showEmptyListMsg="yes"
					PageIndex="53"
					MaxRows="0"	
				/>
			<cf_web_portlet_end>
		</td>
	</tr>
</table>
	
 
