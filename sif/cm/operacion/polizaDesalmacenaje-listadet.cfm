<br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="SubTitulo" align="center" style="text-transform:uppercase ">Detalles de la P&oacute;liza</td>
	</tr>
</table>
<cfinvoke component="sif.Componentes.pListas"	method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="query" 				value="#rsLDPD#"/>
	<cfinvokeargument name="desplegar" 			value="DPDdescripcion, EOnumero, CMtipodesc, CAdescripcion, Pnombre, Idescripcion, DPDcantidad, Udescripcion, DPDmontofobreal, DPDpeso"/>
	<cfinvokeargument name="etiquetas" 			value="Descripci&oacute;n, Orden de Compra, Tipo, Código Aduanal, País, Impuestos, Cantidad, Unidad, FOB, Peso"/>
	<cfinvokeargument name="formatos" 			value="S,S,S,S,S,S,M,S,M,M"/>
	<cfinvokeargument name="align" 				value="left,left,left,left,left,left,right,left,right,right"/>
	<cfinvokeargument name="ajustar" 			value="N,N,N,S,N,N,N,N,N,N"/>
	<cfinvokeargument name="keys" 				value="EPDid, DPDlinea"/>
	<cfinvokeargument name="irA" 				value="polizaDesalmacenaje.cfm"/>
	<cfinvokeargument name="showEmptyListMsg"	value="true"/>
	<cfinvokeargument name="maxRows" 			value="10"/>
	<cfinvokeargument name="pageindex" 			value="2"/>
	<cfinvokeargument name="formname" 			value="lista2"/>
	<cfinvokeargument name="totales" 			value="DPDmontofobreal,DPDpeso"/>
	<cfinvokeargument name="navegacion" 		value="EPDID=#Form.EPDid#"/>
</cfinvoke>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top" width="48%">
		<br>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="SubTitulo" align="center" style="text-transform:uppercase ">Facturas de la P&oacute;liza</td>
			</tr>
		</table>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLFP#">
			<cfinvokeargument name="cortes" value="FPafectadesc">
			<cfinvokeargument name="desplegar" value="Ddocumento, DDIconsecutivo, Cdescripcion, gastoexclusivo, FMmonto">
			<cfinvokeargument name="etiquetas" value="Factura, L., Concepto, G.E.*, Monto">
			<cfinvokeargument name="formatos" value="S,S,S,S,M">
			<cfinvokeargument name="align" value="left,left,left,left,right">
			<cfinvokeargument name="ajustar" value="N,N,S,N">
			<cfinvokeargument name="keys" value="EPDid, FPid">
			<cfinvokeargument name="irA" value="polizaDesalmacenaje.cfm">
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="maxRows" value="10"/>
			<cfinvokeargument name="pageindex" value="3"/>
			<cfinvokeargument name="formname" value="lista3"/>
			<cfinvokeargument name="totales" value="FMmonto">
			<cfinvokeargument name="navegacion" value="EPDID=#Form.EPDid#"/>
		</cfinvoke>
	</td>
	<td align="center" width="4%">&nbsp;</td>
	<td valign="top" width="48%">
		<br>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="SubTitulo" align="center" style="text-transform:uppercase ">Impuestos de la P&oacute;liza</td>
			</tr>
		</table>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLIP#">
			<cfinvokeargument name="desplegar" value="Ddocumento, DDIconsecutivo, Idescripcion, CMIPmonto">
			<cfinvokeargument name="etiquetas" value="Factura, L., Impuesto, Monto">
			<cfinvokeargument name="formatos" value="S,S,S,M">
			<cfinvokeargument name="align" value="left,left,left,right">
			<cfinvokeargument name="ajustar" value="N,N,S,N">
			<cfinvokeargument name="keys" value="EPDid, Icodigo">
			<cfinvokeargument name="irA" value="polizaDesalmacenaje.cfm">
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="maxRows" value="10"/>
			<cfinvokeargument name="pageindex" value="4"/>
			<cfinvokeargument name="formname" value="lista4"/>
			<cfinvokeargument name="totales" value="CMIPmonto">
			<cfinvokeargument name="navegacion" value="EPDID=#Form.EPDid#"/>
		</cfinvoke>
	</td>
  </tr>
</table>