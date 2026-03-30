<cfif #id# NEQ "">
	<cfquery datasource="#session.dsn#" name="listaDliqui">
	Select 
		DL.GELGid,
		DL.GELGnumeroDoc,
		DL.GELGfecha,
		DL.GELGdescripcion,
		DL.GELGmontoOri,
		case
			when DL.Icodigo is null 
			then (select GECdescripcion from GEconceptoGasto where GECid = DL.GECid)
			else <cf_dbfunction name="concat" args="'IMPUESTO ',DL.Icodigo">
		end as GECdescripcion,
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
		from GEliquidacion m
			inner join GEliquidacionGasto DL
				on DL.GELid=m.GELid
		where m.GELid =#id#
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
			PageIndex="26"
			desplegar="GELGnumeroDoc,GELGfecha,GELGproveedor, GECdescripcion,GELGdescripcion,MonedaDetalle,GELGmontoOri,GELGtotalOri,GELGtotal"
			etiquetas="Documento,Fecha,Proveedor, Concepto, Descripci&oacute;n&nbsp;,Moneda<br>Documento,Monto<br>Documento,Autorizado<br>Documento,Autorizado<br>LIQ. #listaDliqui.MonedaEncabezado#"
			formatos="I,D,S,S,S,S,M,M,M,M"
			align="Right,center,left,left,left,right,right,right,right,right"
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
