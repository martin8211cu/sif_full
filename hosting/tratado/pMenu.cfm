<!--- Opciones del Menú --->
<!--- Consulta las opciones que van en el menú --->
<cfif isdefined("session.Usucodigo") and isdefined("session.EcodigoSDC")> <!--- Usucodigo --->
	<table border="0" width="100%" cellpadding="2" cellspacing="0">
		<tr>
        	<td align="center" colspan="3">
            	<img  border="0" src="images/tratado.JPG" width="770" height="120"/>
            </td>
        </tr>
        <tr>
        	<td align="center" colspan="3">&nbsp;
            	
            </td>
        </tr>
        
         <tr>
        	<td align="center" width="25%">
            	<a href="/cfmx/hosting/tratado/operacion/empresas/Empresas-lista.cfm" ><img  border="0" src="images/empresas.JPG" width="130" height="130"/></a>
            </td>
            <td align="center" width="25%">
            	<a href="/cfmx/hosting/tratado/operacion/personas/Personas-lista.cfm" ><img  border="0" src="images/personasL.JPG" width="130" height="130"/></a>
            </td>
            <td align="center" width="25%">
                <a href="/cfmx/hosting/tratado/consultas/Consultas.cfm" ><img  border="0" src="images/consultas.JPG" width="130" height="130"/></a>
            </td>
        </tr>
        <tr>
        	<td align="center" width="25%">
            	<a href="/cfmx/hosting/tratado/operacion/empresas/Empresas-lista.cfm" ><strong>
            	<cf_translate key="LB_Empresas">Empresas</cf_translate>
            	</strong></a>
            </td>
            <td align="center" width="25%">
            	<a href="/cfmx/hosting/tratado/operacion/personas/Personas-lista.cfm" ><strong>
            	<cf_translate key="LB_Personas">Personas</cf_translate>
            	</strong></a>
            </td>
            <td align="center" width="25%">
            	<a href="/cfmx/hosting/tratado/consultas/Consultas.cfm" ><strong><cf_translate key="LB_Consultas">Consultas</cf_translate></strong></a>
            </td>
        </tr>
        <tr>
        	<td  width="33%" valign="top" height="100">
                <fieldset><legend><cf_translate key="LB_Empresas">Empresas</cf_translate></legend>
                	<table width="100%" border="0" cellspacing="0" cellpadding="2" height="100">
                    	<tr>
                        	<td>&nbsp;</td>
                            <td align="left" valign="top">
                                <cf_translate  key="LB_AyudaEmpresas">&Aacute;rea donde el usuario define las diferentes empresas que se sincronizaran con el padr&oacute;n electoral.
                                </cf_translate>
                            </td>
                            <td>&nbsp;</td>	
                        
                        </tr>
                    </table>
                </fieldset>
            </td>
            <td  width="33%" valign="top" height="100">
                <fieldset><legend><cf_translate key="LB_Personas">Personas</cf_translate></legend>
                	<table width="100%" border="0" cellspacing="0" cellpadding="2" height="100">
                    	<tr>
                        	<td>&nbsp;</td>
                          <td align="left" valign="top">
                              <cf_translate  key="LB_AyudaPersonas">
                                 Aqu&iacute; se importan e incluyen las diferentes personas asociadas a las empresas.
                            </cf_translate>
                          </td>
                            <td>&nbsp;</td>	
                        
                        </tr>
                    </table>
                </fieldset>            
            </td>
           <td  width="33%" valign="top" height="100">
                <fieldset><legend><cf_translate key="LB_Consultas">Consultas</cf_translate></legend>
                	<table width="100%" border="0" cellspacing="0" cellpadding="2" height="100">
                    	<tr>
                        	<td>&nbsp;</td>
                            <td align="left" valign="top">
                                <cf_translate  key="LB_AyudaConsultas">
                                   	Se puede realizar una consulta por diferentes criterios de b&uacute;squeda. <br><br>
                                    Adem&aacute;s se puede consultar las personas de aquellas empresas que no 
                                    lograron sincronizarse con el padr&oacute;n electoral.

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
