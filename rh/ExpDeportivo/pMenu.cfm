<!--- Opciones del Menú --->
<!--- Consulta las opciones que van en el menú --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Instituciones" Default="Instituciones" returnvariable="LB_Instituciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Jugadores" Default="Jugadores" returnvariable="LB_Jugadores"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Evaluaciones" Default="Evaluaciones" returnvariable="LB_Evaluaciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Consultas" Default="Consultas" returnvariable="LB_Consultas"/>

<cfif isdefined("session.Usucodigo") and isdefined("session.EcodigoSDC")>
<!---  --->
 <!--- Usucodigo --->
 <table border="0" width="100%" cellpadding="2" cellspacing="0">
	<!--- 	 <tr>
        	<td align="center" colspan="4">
            	<img  border="0" src="imagenes/principal.JPG" width="770" height="120"/>
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
        </tr>  --->
       <tr>
        	<td align="center" width="25%">
            	<a href="Proyecto/index.cfm" ><strong>Instituciones</strong></a>
            </td>
            <td align="center" width="25%">
            	<a href="JMenu.cfm" ><strong><cf_translate key="LB_Jugadores">Jugadores</cf_translate></strong></a>
            </td>
            <td align="center" width="25%">
            	<a href="EMenu.cfm" ><strong><cf_translate key="LB_Evaluaciones">Evaluaciones</cf_translate></strong></a>
            </td>
            <td align="center" width="25%">
            	<a href="CMenu.cfm" ><strong><cf_translate key="LB_Consultas">Consultas</cf_translate></strong></a>
            </td>
        </tr> 
        
       
         <!--- <tr>
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
                <fieldset><legend><cf_translate key="LB_Instituciones">Instituciones</cf_translate></legend>
                	<table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                    	<tr>
                        	<td>&nbsp;</td>
                            <td align="left" valign="top">
                                <cf_translate  key="LB_AyudaInstituciones">
                                    En esta &aacute;rea se pueden crear Instituciones y asociarles equipos o divisiones.<br>
                                    Por ejemplo se puede crear selecci&oacute;n nacional como un Instituciones y sus divisiones o equipos 
                                    ser&iacute;an mayor, sub-17 etc.
                                </cf_translate>
                            </td>
                            <td>&nbsp;</td>	
                        
                        </tr>
                    </table>
                </fieldset>
            </td>
            <td  width="25%" valign="top" height="150">
                <fieldset><legend><cf_translate key="LB_Jugadores">Jugadores</cf_translate></legend>
                	<table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                    	<tr>
                        	<td>&nbsp;</td>
                          <td align="left" valign="top">
                              <cf_translate  key="LB_AyudaJugadores">
                                 Aqu&iacute; se agregan los jugadores y cuerpo t&eacute;cnico a los Instituciones.<br>
                                   Una vez creados los jugadores se pueden asignar a los diferentes equipos.<br>  
                                   Tambi&eacute;n se puede consultar el expediente (ficha t&eacute;cnica) de un jugador. 
                            </cf_translate>
                          </td>
                            <td>&nbsp;</td>	
                        
                        </tr>
                    </table>
                </fieldset>            
            </td>
           <td  width="25%" valign="top" height="150">
                <fieldset><legend><cf_translate key="LB_Evaluaciones">Evaluaciones</cf_translate></legend>
                	<table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                    	<tr>
                        	<td>&nbsp;</td>
                          <td align="left" valign="top">
                              <cf_translate  key="LB_AyudaEvaluaciones">
                                 <p>El usuario de la aplicaci&oacute;n podr&aacute; realizarle a los jugadores
                                   una serie de evaluaciones de tipo medicas,f&iacute;sicas.
                              </cf_translate>
                          </td>
                            <td>&nbsp;</td>	
                        </tr>
                    </table>
                </fieldset>              
            </td>
           <td  width="25%" valign="top" height="150">
                <fieldset><legend><cf_translate key="LB_Consultas">Consultas</cf_translate></legend>
                	<table width="100%" border="0" cellspacing="0" cellpadding="2" height="150">
                    	<tr>
                        	<td>&nbsp;</td>
                            <td align="left" valign="top">
                                <cf_translate  key="LB_AyudaConsultas">
                                   
                                </cf_translate>
                            </td>
                            <td>&nbsp;</td>	
                        </tr>
                    </table>
                </fieldset> 
            </td>
        </tr> --->
	</table>
</cfif>
 