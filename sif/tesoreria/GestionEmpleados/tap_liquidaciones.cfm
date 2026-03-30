<cfif #form.GELid# NEQ "">
	<cfquery datasource="#session.dsn#" name="listaDliqui">
	Select 
	DL.GELGid,
		DL.GELGnumeroDoc,
		DL.GELGfecha,
		DL.GELGdescripcion,
		DL.GELGtotalOri,
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
			)as MonedaEncabezado
		from GEliquidacionGasto DL,GEconceptoGasto cg, GEliquidacion m
		where DL.GELid =#form.GELid#
		and DL.GECid = cg.GECid
		and m.GELid=DL.GELid 

	</cfquery>
</cfif>
<table width="100%" border="0">
	<tr><td width="100%" valign="top">
		<cfset titulo = 'Lista de Documentos Liquidantes'>
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			<cfquery datasource="#session.dsn#" name="listaFact">
				select * from GEliquidacionGasto    	
				where GELid=#form.GELid#
			</cfquery>
					
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#listaDliqui#"
			formName="listaLiqui"
			PageIndex="2"
			desplegar="GELGnumeroDoc,GELGfecha,GELGproveedor, GECdescripcion,GELGdescripcion,GELGtotalOri,MonedaDetalle,GELGtotalOri,MonedaEncabezado"
			etiquetas="N&uacute;m.Documento,Fecha,Proveedor, Concepto, Descripci&oacute;n&nbsp;,Monto,MonedaD,MontoLiquidante,MonedaE"
			formatos="I,D,S,S,S,M,S,M,S"
			align="center,center,center,center,center,center,center,center,center"
			form_method="post"	
			showEmptyListMsg="yes"
			keys="GELGid,GELid"
			maxRows="6"
			showLink="no"
			/>							
		<cf_web_portlet_end>
	</td>
	<td width="933">
</td>
</tr>
</table>