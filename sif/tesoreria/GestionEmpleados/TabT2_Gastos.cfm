<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default ="Documento" returnvariable="LB_Documento" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default ="Fecha" returnvariable="LB_Fecha" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Proveedor" default ="Proveedor" returnvariable="LB_Proveedor" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Concepto" default ="Concepto" returnvariable="LB_Concepto" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default ="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MonedaDoc" default ="Moneda Doc" returnvariable="LB_MonedaDoc" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoDoc" default ="Monto Doc" returnvariable="LB_MontoDoc" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_AutorizadoDoc" default ="Autorizado Doc" returnvariable="LB_AutorizadoDoc" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_AutorizadoLIQ" default ="Autorizado LIQ" returnvariable="LB_AutorizadoLIQ" xmlfile = "TabT2_Gastos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloListaDocumentosLiquidantes" default ="Lista de Documentos Liquidantes" returnvariable="LB_TituloListaDocumentosLiquidantes" xmlfile = "TabT2_Gastos.xml">

<cfif #form.GELid# NEQ "">
	<cfquery datasource="#session.dsn#" name="listaDliqui">
	Select
	DL.GELGid,
		DL.GELGnumeroDoc,
		DL.GELGfecha,
		DL.GELGdescripcion,
		DL.GELGmontoOri,
		DL.GECid,
		cg.GECid,
		cg.GECdescripcion,
		DL.GELGproveedor,
		DL.GELid,
		DL.GELGtotalOri,
		DL.GELGtotal,
		(select Mo.Miso4217
					from Monedas Mo
					where DL.Mcodigo=Mo.Mcodigo
		)as MonedaDetalle,
					(select Mo.Miso4217
					from Monedas Mo
					where m.Mcodigo=Mo.Mcodigo
			)as MonedaEncabezado,
		CASE WHEN rep.CEfileId IS NOT NULL
            THEN '<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif'' alt=''Mostrar CFDI'' onclick=''InfCFDI('+ cast(rep.ID_Documento as varchar) + ',' + cast(rep.ID_Linea as varchar) + ',' + cast(rep.CEfileId as varchar) + ');''>'
            ELSE ''
		END AS CFDI
		from GEliquidacionGasto DL
		inner join GEconceptoGasto cg
			on DL.GECid = cg.GECid
		inner join GEliquidacion m
			on m.GELid=DL.GELid
		left join CERepoTMP rep
			on rep.ID_Documento = m.GELid
			and rep.ID_Linea = DL.GELGid
		where DL.GELid =#form.GELid#

	</cfquery>
</cfif>
<table width="100%" border="0">
	<tr><td width="100%" valign="top">
		<cfset titulo = '#LB_TituloListaDocumentosLiquidantes#'>
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#listaDliqui#"
				formName="listaLiqui"
				PageIndex="25"
				desplegar="GELGnumeroDoc,GELGfecha,GELGproveedor, GECdescripcion,GELGdescripcion,MonedaDetalle,GELGmontoOri,GELGtotalOri,GELGtotal,CFDI"
				etiquetas="#LB_Documento#,#LB_Fecha#,#LB_Proveedor#, #LB_Concepto#, #LB_Descripcion#,#LB_MonedaDoc#,#LB_MontoDoc#,#LB_AutorizadoDoc#,#LB_AutorizadoLIQ# #listaDliqui.MonedaEncabezado#,CFDI"
				formatos="I,D,S,S,S,S,M,M,M,S"
				align="left,center,left,left,left,center,right,right,right,center"
				form_method="post"
				showEmptyListMsg="yes"
				keys="GELGid,GELid"
				maxRows="0"
				showLink="no"
			/>
		<cf_web_portlet_end>
	</td>
</tr>
</table>
<br />

<script type="text/javascript" language="javascript">

	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function InfCFDI(IDContable,Dlinea,IdRep) {
		var left = 10;//(window.screen.availWidth - window.screen.width*0.6) /2;
		var top = 10;//(window.screen.availHeight - window.screen.height*0.75) /2;
		popUpWindowIns("/cfmx/sif/ce/consultas/popUp-CEInfoCFDI.cfm?IDContable=" + IDContable + "&Dlinea=" + Dlinea + "&IdRep=" + IdRep + "&aux=true", 'width='+window.screen.width*0.6+', height='+window.screen.height*0.75+', top='+top+', left='+left);
	}
</script>
