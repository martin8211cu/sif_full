<cf_templateheader title="Cuentas por cobrar">
		
	
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mensajes Punto de Venta'>
			<script language="JavaScript1.2" type="text/javascript">
				function socios(){
					document.form1.action     = "SNcorporativo.cfm";
					document.form1.modo.value = "CAMBIO";
					document.form1.submit();
				}
			</script>

            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td colspan="2" valign="top">
					<cfinclude template="../../portlets/pNavegacionAD.cfm">
				</td>
              </tr>

              <tr> 
                <td valign="top" width="50%"> <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
				 returnvariable="pListaRet">
                    <cfinvokeargument name="tabla" value="MensajesPV"/>
                    <cfinvokeargument name="columnas" value="MPVid, SNCcodigo, MPVmsg, case MPVleido when 0 then '<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>'
								else'<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>' end as Leido"/>
                    <cfinvokeargument name="desplegar" value="MPVmsg, Leido"/>
                    <cfinvokeargument name="etiquetas" value="Mensaje, Le&iacute;do " />
                    <cfinvokeargument name="formatos" value="S,S"/>
                    <cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# 
											and SNCcodigo=#Form.SNCcodigo# 
											order by MPVid"/>
                    <cfinvokeargument name="align" value="left, left"/>
                    <cfinvokeargument name="ajustar" value="N"/>
                    <cfinvokeargument name="checkboxes" value="N"/>
                    <cfinvokeargument name="irA" value="MensajesPV.cfm"/>
                    <cfinvokeargument name="keys" value="MPVid"/>
                  </cfinvoke> </td>
                <td><cfinclude template="MensajesPV-form.cfm"> &nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
            	
		<cf_web_portlet_end>	
		<cf_templatefooter>