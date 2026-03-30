<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke Key="LB_ElCampoFechaDesdeEsRequerido" Default="El campo Fecha desde es requerido" returnvariable="LB_ElCampoFechaDesdeEsRequerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ElCampoFechaHastaEsRequerido" Default="El campo Fecha hasta es requerido" returnvariable="LB_ElCampoFechaHastaEsRequerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DebeSeleccionarUnEmpleadoOGrupoDeMarcas" Default="Debe seleccionar un empleado o un grupo de marcas" returnvariable="LB_SelEmpleadoGrupo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ElCampoEmpleadoEsRequerido" Default="El campo Empleado es requerido"	 returnvariable="LB_ElCampoEmpleadoEsRequerido" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ElCampoGrupoDeMarcasEsRequerido" Default="El campo Grupo de Marcas es requerido"	 returnvariable="LB_ElCampoGrupoDeMarcasEsRequerido" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Empleado" Default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDeGrupos" Default="Lista de Grupos"	 returnvariable="LB_ListaDeGrupos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo"	 returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n"	 returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ListaDeGrupos" Default="Lista de Grupos"	 returnvariable="LB_ListaDeGrupos" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="RepPlanificaciones-form.cfm" onSubmit="javascript: return funcValidar();">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>                   
				    <tr>
						<td width="35%" valign="top">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ReporteDePlanificacionesHechasALosEmpleados">
                            		El Reporte de Planificaciones muestra el detalle de la planificaci&oacute;n de jornadas hechas a los empleados.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                            	<tr>
                                	<td width="26%" align="right" nowrap="nowrap"><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate>:</td>
                                    <td width="29%">
                                    	<cfif isdefined("Form.fdesde")>
											<cfset fechaD = Form.fdesde>
										<cfelse>
											<cfset fechaD = "">
										</cfif>
										<cf_sifcalendario form="form1" value="#fechaD#" name="fdesde" tabindex="1">
                                    </td>
									<td width="14%" align="right" nowrap><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>:</td>
                                    <td width="31%">
                                    	<cfif isdefined("Form.fhasta")>
											<cfset fechaH = Form.fhasta>
										<cfelse>
											<cfset fechaH = "">
										</cfif>
										<cf_sifcalendario form="form1" value="#fechaH#" name="fhasta" tabindex="1">
									</td>
                                </tr>								
								<tr>
									<td colspan="4" align="center">
										<table align="center">
											<tr>
												<td align="right"><cf_translate key="LB_EmpleadoEspecifico">Empleado espec&iacute;fico</cf_translate></td>
												<td>
													<input type="radio" value="EMP" name="opcional" onClick="javascript: funcCambiar(this.value);" checked>
												</td>
												<td>&nbsp;</td>
												<td align="right" nowrap><cf_translate key="LB_EmpleadosDeUnGrupoDeMarcas">Empleados de un Grupo de Marcas</cf_translate></td>
												<td>
													<input type="radio" value="GRU" name="opcional" onClick="javascript: funcCambiar(this.value);">
												</td>
											</tr>
										</table>
									</td>																		
                                </tr>								
                            	<tr>
                                	<td align="right" id="LB_Emp" style="display:;" nowrap>
										<cf_translate key="LB_SeleccioneElEmpleado">Seleccione el Empleado</cf_translate>:
									</td>
									<td colspan="3" id="TD_Emp" style="display:;">
										<cf_rhempleado tabindex="1">
									</td>									
									<td align="right" id="LB_Grup" style="display:none;" nowrap><cf_translate key="LB_SeleccioneElGrupo">Seleccione el Grupo</cf_translate>:</td>
									<td colspan="3" id="TD_Grup" style="display:none;">
                                    	<cf_conlis
										   campos="Gid,Gcodigo,Gdescripcion"
										   desplegables="N,S,S"
										   modificables="N,S,N"
										   size="0,20,40"
										   title="#LB_ListaDeGrupos#"
										   tabla="RHCMGrupos"
										   columnas="Gid,Gcodigo,Gdescripcion"
										   filtro="Ecodigo = #session.Ecodigo# order by Gdescripcion"
										   desplegar="Gcodigo,Gdescripcion"
										   filtrar_por="Gcodigo,Gdescripcion"										   
										   etiquetas="#LB_Codigo#,#LB_Descripcion#"
										   formatos="S,S"
										   align="left,left"
										   asignar="Gid,Gcodigo,Gdescripcion"
										   asignarformatos="S,S,S"
										   showemptylistmsg="true"
										   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
										   tabindex="1"> 										
                                    </td>									
                                </tr>             
                            </table>
                        </td>
                   	</tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr><td nowrap align="center" colspan="2"><cf_botones values="Generar" tabindex="1"></td></tr>
              </table>
          </form>
		  <script language="javascript1.2" type="text/javascript">
			function funcCambiar(valor){
				if(valor == 'EMP'){
					document.getElementById("LB_Emp").style.display = '';
					document.getElementById("TD_Emp").style.display = '';
					document.getElementById("LB_Grup").style.display = 'none';
					document.getElementById("TD_Grup").style.display = 'none';
				}
				else{
					document.getElementById("LB_Emp").style.display = 'none';
					document.getElementById("TD_Emp").style.display = 'none';
					document.getElementById("LB_Grup").style.display = '';
					document.getElementById("TD_Grup").style.display = '';
				}
			}
			function funcValidar(){
				var error = false;
				var mensaje = 'Se presentaron los siguientes errores:\n';
				<cfoutput>
				if ( document.form1.fdesde.value == '' ){
					error = true;
					mensaje += ' - #LB_ElCampoFechaDesdeEsRequerido#\n';
				}
				if ( document.form1.fhasta.value == '' ){
					error = true;
					mensaje += ' - #LB_ElCampoFechaHastaEsRequerido#\n';
				}							
				if (!document.form1.opcional[0].checked && !document.form1.opcional[1].checked)	{
					error = true;
					mensaje += ' - #LB_SelEmpleadoGrupo#\n';
				}
				if(document.form1.opcional[0].checked){
					if(document.form1.DEid.value == ''){
						error = true;
						mensaje += ' - #LB_ElCampoEmpleadoEsRequerido#\n';
					}
				}
				if(document.form1.opcional[1].checked){
					if(document.form1.Gid.value == ''){
						error = true;
						mensaje += ' - #LB_ElCampoGrupoDeMarcasEsRequerido#\n';
					}
				}				
				
				if (error){
					alert(mensaje);
					return false
				}
				</cfoutput>
				return true;
			}
		  </script>
	<cf_web_portlet_end>
<cf_templatefooter>
