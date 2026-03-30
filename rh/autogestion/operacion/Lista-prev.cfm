<cfinvoke key="BTN_Aceptar" default="Continuar" returnvariable="BTN_Aceptar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Regresar" default="Cancelar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Imprimir" default="Imprimir" returnvariable="BTN_Imprimir" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>

<cfoutput>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_RecursosHumanos"
	default="Recursos Humanos"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
	<!--
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
	//-->
</script>
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<cfinvoke component="sif.Componentes.TranslateDB"
				method="Translate"
				VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
				Default="Planificaci&oacute;n de Jornadas"
				VSgrupo="103"
				returnvariable="nombre_proceso"/>
			
			<cf_web_portlet_start titulo="#nombre_proceso#">		  	      
				<cfinclude template="/rh/portlets/pNavegacion.cfm">			      
				<cfoutput>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top"><td>&nbsp;</td></tr>
					<tr valign="top"> 
						<td align="center">
                            <form name="form1" method="post" action="PlanificaJornadas-sql.cfm">
                                <cfif isdefined('form.chk')><input type="hidden" name="chk" value="#Form.chk#"></cfif>
                                <cfif isdefined('form.RHJid')><input type="hidden" name="RHJid" value="#Form.RHJid#"></cfif>
                                <cfif isdefined('form.RHPJffinal')><input type="hidden" name="RHPJffinal" value="#Form.RHPJffinal#"></cfif>
                                <cfif isdefined('form.RHPJfinicio')><input type="hidden" name="RHPJfinicio" value="#Form.RHPJfinicio#"></cfif>
								<cfif isdefined('form.RHPJffinal_h')><input type="hidden" name="RHPJffinal_h" value="#Form.RHPJffinal_h#"></cfif>
								<cfif isdefined('form.RHPJffinal_m')><input type="hidden" name="RHPJffinal_m" value="#Form.RHPJffinal_m#"></cfif>
								<cfif isdefined('form.RHPJffinal_s')><input type="hidden" name="RHPJffinal_s" value="#Form.RHPJffinal_s#"></cfif>
								<cfif isdefined('form.RHPJfinicio_h')><input type="hidden" name="RHPJfinicio_h" value="#Form.RHPJfinicio_h#"></cfif>
                               	<cfif isdefined('form.RHPJfinicio_m')><input type="hidden" name="RHPJfinicio_m" value="#Form.RHPJfinicio_m#"></cfif>
                                <cfif isdefined('form.RHPJfinicio_s')><input type="hidden" name="RHPJfinicio_s" value="#Form.RHPJfinicio_s#"></cfif>
                                <cfif isdefined('form.ver')><input type="hidden" name="ver" value="#Form.ver#"></cfif>
                                <cfif isdefined('form.optLibre')><input type="hidden" name="optLibre"     value="#Form.optLibre#"></cfif>
								
								<cfquery  name="RS_Jornada"datasource="#session.DSN#">
									select RHJcodigo ,RHJdescripcion  from  RHJornadas 
									where RHJid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">
								</cfquery>	

                                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                	<tr>
                                    	<td  width="100%">
                                        	<fieldset><legend><cf_translate key="LB_ParametrosGeneracionMasiva">Par&aacute;metros Para Generaci&oacute;n Masiva</cf_translate></legend>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
                                                    <tr>
                                                      <td  width="6%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio:</cf_translate></td>
                                                      <td  width="10%"> #Form.RHPJfinicio#</td>
                                                      <td width="6%"  align="left" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Vence">Fecha Vence:</cf_translate></td>
                                                      <td width="50%"> #Form.RHPJffinal#</td>
													</tr>
													
													<tr>
                                                      <td  width="6%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Jornada">Jornada:</cf_translate></td>
                                                      <td  width="10%" nowrap="nowrap">#RS_Jornada.RHJcodigo#&nbsp;#RS_Jornada.RHJdescripcion#</td>
                                                      <td width="6%"  align="left" nowrap class="fileLabel"><cf_translate key="LB_Libre">Libre:</cf_translate></td>
                                                      <td width="50%"> 
														  <cfswitch expression="#Form.optLibre#">
																<cfcase value="1">
																	<cf_translate  key="LB_Si">Si</cf_translate>
																</cfcase>
																<cfcase value="0">
																	<cf_translate  key="LB_No">No</cf_translate>
																</cfcase>
															</cfswitch>
														</td>
													</tr>		
													
													<tr>
                                                      <td  width="6%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Hora_Entrada">Hora Entrada:</cf_translate></td>
                                                      <td  width="10%"><cfif RHPJfinicio_h lt 10>0</cfif>#Form.RHPJfinicio_h#:<cfif RHPJfinicio_m lt 10>0</cfif>#Form.RHPJfinicio_m#&nbsp;#Form.RHPJfinicio_s#</td>
                                                      <td width="6%"  align="left" nowrap class="fileLabel"><cf_translate key="LB_Hora_Salida">Hora Salida:</cf_translate></td>
                                                      <td width="50%"><cfif RHPJffinal_h lt 10>0</cfif>#Form.RHPJffinal_h#:<cfif RHPJffinal_m lt 10>0</cfif>#Form.RHPJffinal_m#&nbsp;#Form.RHPJffinal_s#</td>
													</tr>	
					                                <tr>
                                                        <td colspan="4" align="center">&nbsp;</td>
                                                     </tr>
                                                    <tr>
                                                        <td colspan="4" align="center">
                                                            <table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
                                                                <tr>
                                                                    <td align="right" nowrap>
                                                                        <input type="submit"    name="btnContinuar" value="#BTN_Aceptar#" tabindex="1" >
                                                                        <input type="button"   	onclick="javascript:regresar()" name="btnregresar" value="#BTN_Regresar#" tabindex="1" >
                                                                        <input type="button"  	id="Imprimir" name="Imprimir" value="#BTN_Imprimir#" onclick="imprimir();">
                                                                    </td>
                                                                </tr>
                                                            </table>                                                        
                                                        </td>
                                                     </tr>
                                                </table>                                            
                                            </fieldset>
                                        </td>
                                     </tr>
                                     <tr>
                                        <td  width="100%" height="84" valign="top">
                                           <fieldset><legend style="color:##FF0000">
                                           <cf_translate key="LB_ayuda">Empleados con problemas a la hora de realizar la planificaci&oacute;n masiva. </cf_translate>
                                           </legend>
                                           		<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
													<tr>
                                                        <td    align="left" nowrap class="fileLabel">
															<li>
                                                        	<cf_translate key="LB_Motivos1">En el rango de fechas existen colaboradores con jornadas de diferente tipo a la indicada en los par&aacute;metros </cf_translate>
                                                        	</li>
														</td>
                                                    </tr> 
													<tr>
                                                        <td    align="left" nowrap class="fileLabel">
															<li>
                                                        	<cf_translate key="LB_Motivos2">Existen acciones de personal que pueden haber modificado las jornadas de los colaboradores</cf_translate>
                                                        	</li>
														</td>
                                                    </tr>  
													<tr bgcolor="##CCCCCC">
                                                        <td  width="10%"align="left" nowrap class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
                                                     </tr> 
                                                     <cfloop query="RS_empleados">
														<cfset LvarListaNon = (RS_empleados.CurrentRow MOD 2)>
														<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>

                                                        <tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">                                                      
                                                            <td align="left" nowrap>#trim(RS_empleados.Empleado)#</td>
                                                       </tr> 
                                                     </cfloop>
                                                </table>
                                           </fieldset>
                                       </td>
                                    </tr>
                                </table>
                                
                            </form>
						</td>
					</tr>
					<tr valign="top"> <td>&nbsp;</td></tr>
				</table>
                </cfoutput>			      
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
<cf_templatefooter>



</cfoutput>
<script language="JavaScript">
	function regresar(){
		document.form1.action='PlanificaJornadas-sql.cfm';
		document.form1.submit();
	
	}
	
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
        tablabotones.style.display = ''
	}
	
</script>