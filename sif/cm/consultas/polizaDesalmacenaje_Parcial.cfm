<br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td class="tituloListas" align="center" style="text-transform:uppercase " colspan="10">Líneas de la nueva P&oacute;liza</td>
    </tr>
    <tr class="SubTitulo">
    	<td>Descripci&oacute;n</td>
        <td>Orden de Compra</td>
        <td>Tipo</td>
        <td>Código Aduanal</td>
        <td>País</td>
        <td>Impuestos</td>
        <td>Cantidad</td>
        <td>Unidad</td>
        <td>FOB</td>
        <td>Peso</td>
    </tr>
		<cfoutput query="rsLDPD">
            <tr>
                <td>#rsLDPD.DPDdescripcion#</td>
                <td>#rsLDPD.EOnumero#</td>
                <td>#rsLDPD.CMtipodesc#</td>
                <td>#rsLDPD.CAdescripcion#</td>
                <td>#rsLDPD.Pnombre#&nbsp;</td>
                <td>#rsLDPD.Idescripcion#</td>
                <td><cfif rsLDPD.DPDcantidad gt 0><input name="DPDcantidad_#DOlinea#" value="#rsLDPD.DPDcantidad#" type="text" /><cfelse>#rsLDPD.DPDcantidad#<input name="DPDcantidad_#DOlinea#" value="0" type="hidden" /></cfif></td>
                <td>#rsLDPD.Udescripcion#</td>
                <td>#rsLDPD.DPDmontofobreal#</td>
                <td>#rsLDPD.DPDpeso#</td>
            </tr>
<!---             <tr>
            	<td colspan="10" align="center"><input name="CrearPolizaParcial" value="Crear Poliza Parcial" type="submit"/></td>
            </tr> --->
        </cfoutput>
</table>