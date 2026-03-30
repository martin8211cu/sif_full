<cfif #id# NEQ "">
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
			)as MonedaEncabezado,
		case when DL.Confirmado = 'S' then 'checked' end as Chequear
		from GEliquidacionGasto DL,GEconceptoGasto cg, GEliquidacion m
		where DL.GELid =#id#
		and DL.GECid = cg.GECid
		and m.GELid=DL.GELid 

	</cfquery>
</cfif>
<table width="100%" border="0">
	<tr><td width="100%" valign="top">
		<cfset titulo = 'Lista de Documentos Liquidantes'>
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#listaDliqui#"
			formName="listaLiqui"
			checkedCol="Chequear"
			lineaazul = "chequear neq ''"
			PageIndex="2"
			desplegar="GELGnumeroDoc,GELGfecha,GELGproveedor, GECdescripcion,GELGdescripcion,GELGtotalOri,MonedaDetalle,GELGtotalOri,MonedaEncabezado"
			etiquetas="N&uacute;m.Documento,Fecha,Proveedor, Concepto, Descripci&oacute;n&nbsp;,Monto,MonedaD,MontoLiquidante,MonedaE"
			formatos="I,D,S,S,S,M,S,M,S"
			align="center,center,center,center,center,center,center,center,center"
			form_method="post"	
			showEmptyListMsg="yes"
			keys="GELGid,GELid"
			maxRows="0"
			showLink="no"
			ira="TransaccionCustodiaP_sql.cfm?GELid=#id#"
			checkboxes = "S"
			botones = "Confirmar"
			/>	
			<!---checkAll = "S"  con este check se puede seleccionar todo--->
						
		<cf_web_portlet_end>
	</td>
	<td width="933">
</td>
</tr>
</table>
 <script language="javascript">
 	function funcConfirmar()	 
	{
	var cont=0;
	<cfif #listaDliqui.recordCount# GT 1>
		for(i=0; cnt=document.listaLiqui.chk[i]; i++) {
	
			if (cnt.type=='checkbox')
				if (cnt.checked) {
					cont++;
					break;
				}
		}
	<cfelseif #listaDliqui.recordCount# EQ 1>
		if (document.listaLiqui.chk.checked)
		cont++;
//		alert (cont)
	<cfelse>
		alert ("NO existen facturas registradas!");
			return false;
	</cfif>
	if (cont == 0)
	{
		 	alert ("No selecciono ninguna Factura!");
			return false;
	}
	else
	{
		return true;
	}
}
 </script>
