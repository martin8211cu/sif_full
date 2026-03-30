<style type="text/css">
<!--
.style7 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: ##FFFFFF; }
.style8 {color: ##FFFFFF}
-->
</style>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Evaluaciones"
Default="Evaluaciones"
returnvariable="LB_Titulo"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="<cfoutput>#LB_Titulo#</cfoutput>"> 
		<!--- Opciones del Menú --->
        <!--- Consulta las opciones que van en el menú --->
        <cfif isdefined("session.Usucodigo") and isdefined("session.EcodigoSDC")> <!--- Usucodigo --->
            <table border="0" width="100%" cellpadding="2" cellspacing="0">
                <tr>
                    <td align="center" colspan="4">
                        <img  border="0" src="imagenes/principal.JPG" width="770" height="120"/>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="4">&nbsp;
                        
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="4">
                    	 <a href="index.cfm" ><img  border="0" src="imagenes/regresar.gif" /></a>
                        
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="4">&nbsp;
                        
                    </td>
                </tr>
                 <tr>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/arriba.JPG" />
                    </td>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/arriba.JPG" />
                    </td>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/arriba.JPG" />
                    </td>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/arriba.JPG" />
                    </td>
                </tr>
                <tr>
                    <td align="center" width="25%">
                        <a href="catalogo/DatosVariables.cfm" ><strong><cf_translate key="LB_Datos_Variables">Datos Variables</cf_translate></strong></a>
                    </td>
                    <td align="center" width="25%">
                        <a href="catalogo/Unidades.cfm" ><strong><cf_translate key="LB_Unidades_de_Medida">Unidades de Medida</cf_translate></strong></a>
                    </td>
                    <td align="center" width="25%">
                        <a href="cuestionarios/cuestionario-lista.cfm" ><strong><cf_translate key="LB_Formulacion">Formulaci&oacute;n</cf_translate></strong></a>
                    </td>
                    <td align="center" width="25%">
                        <a href="AMenu.cfm" ><strong><cf_translate key="LB_Aplicar_Pruebas">Aplicar Pruebas</cf_translate></strong></a>
                      
                    </td>
                </tr>
                
                
                 <tr>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/abajo.JPG" />
                    </td>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/abajo.JPG" />
                    </td>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/abajo.JPG" />
                    </td>
                    <td align="center" width="25%">
                        <img  border="0" src="imagenes/abajo.JPG" />
                    </td>
                </tr>
        
                
                <tr>
                    <td  width="25%" valign="top" height="150">
                        <fieldset><legend><cf_translate key="LB_Datos_Variables">Datos Variables</cf_translate></legend>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                                <tr>
                                    <td>&nbsp;</td>
                                    <td align="left" valign="top">
                                        <cf_translate  key="LB_AyudaProyecto">
                                            
                                        </cf_translate>
                                    </td>
                                    <td>&nbsp;</td>	
                                
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                    <td  width="25%" valign="top" height="150">
                        <fieldset><legend><cf_translate key="LB_Unidades_de_Medida">Unidades de Medida</cf_translate></legend>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                                <tr>
                                    <td>&nbsp;</td>
                                  <td align="left" valign="top">
                                      <cf_translate  key="LB_AyudaProyecto">
                                        
                                    </cf_translate>
                                  </td>
                                    <td>&nbsp;</td>	
                                
                                </tr>
                            </table>
                        </fieldset>            
                    </td>
                   <td  width="25%" valign="top" height="150">
                        <fieldset><legend><cf_translate key="LB_Formulacion">Formulaci&oacute;n</cf_translate></legend>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                                <tr>
                                    <td>&nbsp;</td>
                                  <td align="left" valign="top">
                                      <cf_translate  key="LB_AyudaProyecto">
                                         
                                      </cf_translate>
                                  </td>
                                    <td>&nbsp;</td>	
                                </tr>
                            </table>
                        </fieldset>              
                    </td>
                   <td  width="25%" valign="top" height="150">
                        <fieldset><legend><cf_translate key="LB_Aplicar_Pruebas">Aplicar Pruebas</cf_translate></legend>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                                <tr>
                                    <td>&nbsp;</td>
                                    <td align="left" valign="top">
                                        <cf_translate  key="LB_AyudaProyecto">
                                          
                                        </cf_translate>
                                    </td>
                                    <td>&nbsp;</td>	
                                </tr>
                            </table>
                        </fieldset> 
                    </td>
                </tr>
            </table>
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
        
