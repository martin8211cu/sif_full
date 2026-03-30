<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloListaDepositosBancariosEntregados" default ="Lista de Dep&oacute;sitos Bancarios Entregados" returnvariable="LB_TituloListaDepositosBancariosEntregados" xmlfile = "TabT3_Depositos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default ="Cuenta" returnvariable="LB_Cuenta" xmlfile = "TabT3_Depositos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumDeposito" default ="N&uacute;m. Dep&oacute;sito" returnvariable="LB_NumDeposito" xmlfile = "TabT3_Depositos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default ="Fecha" returnvariable="LB_Fecha" xmlfile = "TabT3_Depositos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MonedaDeposito" default ="Moneda Dep&oacute;sito" returnvariable="LB_MonedaDeposito" xmlfile = "TabT3_Depositos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoDeposito" default ="Monto Dep&oacute;sito" returnvariable="LB_MontoDeposito" xmlfile = "TabT3_Depositos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoLiq" default ="Monto LIQ" returnvariable="LB_MontoLiq" xmlfile = "TabT3_Depositos.xml">
        
<cfif form.GELid NEQ "">

	<cfquery datasource="#session.dsn#" name="listaDet">
		select 
			a.GELid,
			a.GELDid,
			b.CBcodigo,
			t.BTcodigo,
			a.Ecodigo,
			a.BMUsucodigo,
			a.GELDid,
			a.GELDreferencia,
			a.GELDtotalOri,
			a.GELDfecha,
			a.Mcodigo,
			a.GELDtipoCambio,
			a.GELDtotal,
			a.Mcodigo,
			b.CBdescripcion ,
		
			(select Mo.Miso4217
				from Monedas Mo
				where DL.Mcodigo=Mo.Mcodigo
			)as MonedaEncabezado,

			(select Mo.Miso4217
				from Monedas Mo
				where a.Mcodigo=Mo.Mcodigo					
			)as MonedaDetalle
			
		from GEliquidacionDeps a
			inner join CuentasBancos b
				 on b.CBid = a.CBid
				and b.CBesTCE = 0
			inner join BTransacciones t
				 on t.BTid = a.BTid
			inner join GEliquidacion DL
				on DL.GELid = a.GELid
		where  a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	 </cfquery>
	</cfif>
<!---LISTA--->

<table width="100%" border="0" align="left" >
	<tr>
		<td width="100%" valign="top">
			<cfset titulo = '#LB_TituloListaDepositosBancariosEntregados#'>
			<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#" width="70%">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#listaDet#"
					desplegar="CBcodigo,BTcodigo,GELDreferencia,GELDfecha,MonedaDetalle,GELDtotalOri,GELDtotal"
					etiquetas="#LB_Cuenta#, ,#LB_NumDeposito#, #LB_Fecha#,#LB_MonedaDeposito#, #LB_MontoDeposito#, #LB_MontoLiq#. #listaDet.MonedaEncabezado#"
					formatos="S,S,S,D,S,M,M"
					align="left,left,left,center,right,right,right"
 				    form_method="post"	
					showEmptyListMsg="yes"
					keys="GELDid,GELid"
					incluyeForm="yes"
					formName="formDepo"
					PageIndex="23"
					MaxRows="0"
					showLink="no"
				
				/>
				<cf_web_portlet_end>
		</td>
	</tr>
</table>
	
 
