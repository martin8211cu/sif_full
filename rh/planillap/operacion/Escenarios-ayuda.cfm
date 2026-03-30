<html><head><title>Ayuda del Sistema</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>
<cf_templatecss>
<cfif isdefined('url.tipo') and url.tipo EQ 6>
<!--- AYUDA DE LA CARGAS PATRONALES --->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td class="tituloIndicacion"><p align=center><strong>Definición de Cargas Patronales</font></strong></td>
		<td><img name="imasist" src="/cfmx/sif/imagenes/asistente1.gif"></td>
	</tr>
    <tr>
    	<td align="center" colspan="2">
			<table width="90%" cellpadding="4" cellspacing="4" border="0">
            	<tr>
                	<td>
                        <p align="justify">
                            <cf_translate key="TXT_Pantalla">
                                Esta secci&oacute;n muestra las Cargas Patronales definidas en el sistema y el valor sugerido a cada una de ellas ya sea monto o porcentaje.  
                                Este valor sugerido es el valor asignado en el Mantenimiento de Cargas Obrero Patronales.
                            </cf_translate>
                        </p>
                	</td>
            	</tr>
                <tr><td>&nbsp;</td></tr>
                <tr><td valign="middle"><img src="../images/btn_importar.PNG"><cf_translate key="TXT_Importar">Importa la informaci&oacute;n de las Cargas Patronales.  cuan</cf_translate></td></tr>
                <tr><td><img src="../../imagenes/unchecked.gif"> <cf_translate key="TXT_unCheck">Indicador para no aplicar cargas sobre este registro.</cf_translate></td></tr>
                <tr><td><img src="../../imagenes/checked.gif"> <cf_translate key="TXT_Check">Indicador para aplicar cargas sobre este registro.</cf_translate></td></tr>
                <tr><td><cf_translate key="TXT_Valor">En la caja de texto se puede indicar otro valor al sugerido.</cf_translate></td></tr>
                <tr><td valign="middle"><img src="../images/btn_modificar.PNG"><cf_translate key="TXT_Modificar">Cuando se haya realizado alguna modificaci&oacute;n se debe de hacer click en el bot&oacute;n modificar.</cf_translate></td></tr>
            </table>
        </td>
    </tr>
</table>

</cfif>
<div align="center">
  <input type="button" name="cerrar" value="Cerrar" onClick="window.close();" class="btnNormal">
</div>

</body>
</html>

<script>
	function funcCerrar(){
		
		alert('entra');
		}
</script>