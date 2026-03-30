
<!---===== Verificar que el usuario es autorizador ======--->
<cfquery name="rsVerificaAutorizador" datasource="#session.DSN#">
	select 1
	from RHCMAutorizadoresGrupo 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_RecursosHumanos"
    Default="Recursos Humanos"
    XmlFile="/rh/generales.xml"
    returnvariable="LB_RecursosHumanos"/>

<cfif rsVerificaAutorizador.RecordCount nEQ 0>
    <cf_templateheader title="#LB_RecursosHumanos#">
          <cfinclude template="/rh/Utiles/params.cfm">
          <cfset Session.Params.ModoDespliegue = 1>
          <cfset Session.cache_empresarial = 0>
            <table width="100%" cellpadding="2" cellspacing="0">
                <tr>
                    <td valign="top">
                        <cfinvoke component="sif.Componentes.TranslateDB"
                            method="Translate"
                            VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
                            Default="Planificación de Jornadas"
                            VSgrupo="103"
                            returnvariable="nombre_proceso"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_Identificacion"
                            Default="Identificaci&oacute;n"	
                            returnvariable="LB_Identificacion"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_Nombre"
                            Default="Nombre"	
                            returnvariable="LB_Nombre"/>						
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_Nombre_del_empleado"
                            Default="Nombre de Empleado"	
                            returnvariable="LB_Nombre_del_empleado"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_ParametrosGeneracionMasiva"
                            Default="Par&aacute;metros Para Generaci&oacute;n Masiva"	
                            returnvariable="LB_ParametrosGeneracionMasiva"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_FechaInicio"
                            Default="Fecha Inicio"	
                            returnvariable="LB_FechaInicio"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_FechaVence"
                            Default="Fecha Vence"	
                            returnvariable="LB_FechaVence"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_Jornada"
                            Default="Jornada"	
                            returnvariable="LB_Jornada"/>					
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_HoraEntrada"
                            Default="Hora Entrada"	
                            returnvariable="LB_HoraEntrada"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_HoraSalida"
                            Default="Hora Salida"	
                            returnvariable="LB_HoraSalida"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_Libre"
                            Default="Libre"	
                            returnvariable="LB_Libre"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="LB_Jornada"
                            Default="Jornada"	
                            returnvariable="LB_Jornada"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="BTN_GenerarMasivo"
                            Default="Generar Masivo"	
                            returnvariable="BTN_GenerarMasivo"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="BTN_BorrarMasivo"
                            Default="Borrar Masivo"	
                            returnvariable="BTN_BorrarMasivo"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="MSG_FechaInicioMayorFechaVence"
                            Default="La fecha de inicio no puede ser mayor a la fecha de vencimiento"	
                            returnvariable="MSG_FechaDesdeMayorFechaHasta"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="MSG_Empleado"
                            Default="Empleado"	
                            returnvariable="MSG_Empleado"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="MSG_DeseaBorrarLaPlanificacionJornadasEmpleadoSeleccionadoEnRangoFechas"
                            Default="Desea borrar la planificación de jornadas de los empleados seleccionados en el rango de fechas indicado?"	
                            returnvariable="MSG_ConfirmaBorrado"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="MSG_LaCantidadRegistrosVisualizarNoMayorA50"
                            Default="La cantidad de registros a visualizar no puede ser mayor a 50	"	
                            returnvariable="MSG_CantidadMayor"/>
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="MSG_FechaInicialMenorAHoy"
                            Default="La fecha inicial no puede ser menor al día de hoy"	
                            returnvariable="MSG_FechaInicialMenorAHoy"/>
                        
                        <cfset vs_fechaActual = LSDateFormat(now(),'dd/mm/yyyy')>
                        
                        <!----=============== Chequear los empleados marcados ===============---->
                        <cfif isdefined("form.chk")>
                            <!----Tabla temporal para almacenar los Empleados (DEid) que fueron chequeados ---->
                            <cf_dbtemp name="EmpleadosSeleccionados" returnvariable="EmpleadosSeleccionados" datasource="#session.DSN#">
                                <cf_dbtempcol name="DEid" type="numeric" mandatory="yes">
                            </cf_dbtemp>
                            <!---Para cada empleado seleccionado insertar un registro--->
                            <cfloop list="#form.chk#" index="i">
                                <cfquery datasource="#session.DSN#">
                                    insert into #EmpleadosSeleccionados# (DEid)
                                    values(#i#)
                                </cfquery>
                            </cfloop>
                        </cfif>					
                        
                        <cfquery name="rsGrupos" datasource="#session.DSN#">
                            select  b.Gid, b.Gdescripcion
                            from RHCMAutorizadoresGrupo a
                                inner join RHCMGrupos b
                                    on a.Gid = b.Gid
                                    and a.Ecodigo = b.Ecodigo
                            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                            order by b.Gdescripcion
                        </cfquery>
                        <cfquery name="rsJornadas" datasource="#Session.DSN#">
                            select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
                            from RHJornadas
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and coalesce(RHJmarcar,0)=1
                        </cfquery>
                        
                        <cfset navegacion = ''>
                        <cfif isdefined("url.Identificacion") and len(trim(url.Identificacion)) and not isdefined("form.Identificacion")>
                            <cfset form.Identificacion = url.Identificacion>	
                        </cfif>
                        <cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
                            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Identificacion=" & Form.Identificacion>
                        </cfif>
                        <cfif isdefined("url.Nombre") and len(trim(url.Nombre)) and not isdefined("form.Nombre")>
                            <cfset form.Nombre = url.Nombre>	
                        </cfif>
                        <cfif isdefined("form.Nombre") and len(trim(form.Nombre))>
                            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Nombre=" & Form.Nombre>
                        </cfif>
                        <cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
                            <cfset form.Grupo = url.Grupo>	
                        </cfif>
                        <cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
                            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Grupo=" & Form.Grupo>
                        </cfif>
                        <cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
                            <cfset form.ver = url.ver>	
                        </cfif>
                        <cfif isdefined("form.ver") and len(trim(form.ver))>
                            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "ver=" & Form.ver>
                        </cfif>								
    
                        <cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
                            <cfinclude template="/rh/portlets/pNavegacion.cfm">
                            <cfoutput>
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <form name="form1" action="PlanificaJornadas-sql.cfm" method="post">
                                        <tr><td>&nbsp;</td></tr>
                                        <tr>
                                            <td width="16%"><strong>#LB_Identificacion#&nbsp;</strong></td>
                                            <td width="42%"><strong>#LB_Nombre#&nbsp;</strong></td>
                                            <td width="26%"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>&nbsp;</strong></td>
                                            <td width="8%"><strong><cf_translate key="LB_Ver">Ver</cf_translate>&nbsp;</strong></td>
                                        </tr>
                                        <tr>
                                            <td width="16%"><input type="text" name="Identificacion" value="<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>#form.Identificacion#</cfif>" size="20"></td>										
                                            <td width="42%"><input type="text" name="Nombre" value="<cfif isdefined("form.Nombre") and len(trim(form.Nombre))>#form.Nombre#</cfif>" size="60"></td>
                                            <td width="26%">
                                                <cfif rsGrupos.RecordCount LTE 1>
                                                    <input type="hidden" name="Grupo" value="#rsGrupos.Gid#">
                                                    #rsGrupos.Gdescripcion#
                                                <cfelse>
                                                    <select name="Grupo">
                                                        <option value="">--- <cf_translate key="LB_Todos">Todos</cf_translate> ---</option>
                                                        <cfloop query="rsGrupos">
                                                            <option value="#rsGrupos.Gid#" <cfif isdefined("form.Grupo") and len(trim(form.Grupo)) and form.Grupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
                                                        </cfloop>
                                                    </select>
                                                </cfif>
                                            </td>
                                            <td>
                                                <input type="text" name="ver" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#<cfelse>50</cfif>" size="7">
                                            </td>
                                            <td width="8%">
                                                <cfinvoke component="sif.Componentes.Translate"
                                                    method="Translate"
                                                    Key="BTN_Filtrar"
                                                    Default="Filtrar"
                                                    XmlFile="/rh/generales.xml"
                                                    returnvariable="BTN_Filtrar"/>											
                                                <input type="button" name="btnFiltrar" value="#BTN_Filtrar#" onClick="javascript: funcFiltrar();">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="5">
                                                <input type="checkbox" name="chkTodos" value="" onClick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
                                                <label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="5">
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="60%" valign="top">
                                                            <cfquery name="rsLista" datasource="#session.DSN#">
                                                                select b.DEid, c.DEidentificacion,
                                                                        {fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(' ',c.DEnombre)})})})} as NombreCompleto,
                                                                        <cfif isdefined("form.chk")><!---Chequear solo los marcados---->
                                                                            (select DEid from #EmpleadosSeleccionados# d
                                                                            where b.DEid = d.DEid) as Chequear 
                                                                        <cfelse>
                                                                            '' as Chequear
                                                                        </cfif>																	
                                                                from RHCMAutorizadoresGrupo a
                                                                    inner join RHCMEmpleadosGrupo b
                                                                        on a.Gid = b.Gid
                                                                        and a.Ecodigo = b.Ecodigo
                                                                    
                                                                        inner join DatosEmpleado c
                                                                            on b.DEid = c.DEid
                                                                            and b.Ecodigo = c.Ecodigo		
                                                                            <cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
                                                                                and upper(c.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Identificacion)#%">
                                                                            </cfif>
                                                                            <cfif isdefined("form.Nombre") and len(trim(form.Nombre))>
                                                                                and upper({fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(' ',c.DEnombre)})})})}) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Nombre)#%">
                                                                            </cfif>
                                                                where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                                                                    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                                                    <cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
                                                                        and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">
                                                                    </cfif>
                                                                order by {fn concat(c.DEapellido1,{fn concat(' ',{fn concat(c.DEapellido2,{fn concat(' ',c.DEnombre)})})})}
                                                            </cfquery>
                                                            
                                                            <cfset vnMaxrows = 50>
                                                            <cfif isdefined("form.ver") and len(trim(form.ver))>
                                                                <cfset vnMaxrows = form.ver>
                                                            </cfif>
                                                            
                                                            <cfinvoke 
                                                                 component="rh.Componentes.pListas"
                                                                 method="pListaQuery"
                                                                  returnvariable="pListaEmpl">
                                                                    <cfinvokeargument name="query" value="#rsLista#"/>
                                                                    <cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
                                                                    <cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre_del_empleado#"/>
                                                                    <cfinvokeargument name="formatos" value=""/>
                                                                    <cfinvokeargument name="align" value="left, left"/>
                                                                    <cfinvokeargument name="ajustar" value="N"/>
                                                                    <cfinvokeargument name="checkboxes" value="S"/>
                                                                    <cfinvokeargument name="irA" value="PlanificaJornadas-Empleado.cfm"/>
                                                                    <cfinvokeargument name="keys" value="DEid"/>
                                                                    <cfinvokeargument name="checkedcol" value="Chequear"/>
                                                                    <cfinvokeargument name="maxRows" value="#vnMaxrows#"/>
                                                                    <cfinvokeargument name="incluyeForm" value="false"/>
                                                                    <cfinvokeargument name="formName" value="form1"/>
                                                                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                                                                    <cfinvokeargument name="showEmptyListMsg" value="yes"/>
                                                            </cfinvoke>	
                                                        </td>
                                                        <td width="40%" valign="top">
                                                            <fieldset style="text-indent:inherit"><legend style="color:##000000"><strong>#LB_ParametrosGeneracionMasiva#</strong></legend>
                                                            <table width="100%" cellpadding="2" cellspacing="0">
                                                                <tr><td>&nbsp;</td></tr>
                                                                <tr>
                                                                    <td width="36%" align="right"><strong>#LB_FechaInicio#:&nbsp;</strong></td>
                                                                    <td width="64%">
                                                                        <cf_sifcalendario  tabindex="1" form="form1" name="RHPJfinicio" onBlur="funFechaInicial()">
                                                                    </td>																
                                                                </tr>
                                                                <tr>
                                                                    <td align="right"><strong>#LB_FechaVence#:&nbsp;</strong></td>
                                                                    <td>
                                                                        <cf_sifcalendario  tabindex="2" form="form1" name="RHPJffinal" onBlur="funcValidaFechas()">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right"><strong>#LB_Jornada#:&nbsp;</strong></td>
                                                                    <td>
                                                                        <select name="RHJid" onChange="javascript: funcTraeHorario(this.value);">
                                                                            <option value="">--- <cf_translate key="LB_Translate">Seleccionar</cf_translate> ---</option>
                                                                            <cfloop query="rsJornadas">
                                                                                <option value="#RHJid#" <cfif isdefined("form.RHJid") and form.RHJid EQ rsJornadas.RHJid> selected</cfif>>#rsJornadas.Descripcion#</option>
                                                                            </cfloop>
                                                                        </select>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right"><strong>#LB_HoraEntrada#:&nbsp;</strong></td>
                                                                    <td>
                                                                        <select id="RHPJfinicio_h" name="RHPJfinicio_h">
                                                                          <cfloop index="i" from="1" to="12">
                                                                            <option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("form.RHPJfinicio_h") and form.RHPJfinicio_h EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
                                                                          </cfloop>
                                                                        </select> :
                                                                        <select id="RHPJfinicio_m" name="RHPJfinicio_m">
                                                                          <cfloop index="i" from="0" to="59">
                                                                            <option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("form.RHPJfinicio_m") and form.RHPJfinicio_m EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
                                                                          </cfloop>
                                                                        </select>
                                                                        <select id="RHPJfinicio_s"  name="RHPJfinicio_s">
                                                                            <option value="AM" <cfif isdefined("form.RHPJfinicio_s") and form.RHPJfinicio_s EQ 'AM'> selected</cfif>>AM</option>
                                                                            <option value="PM" <cfif isdefined("form.RHPJfinicio_s") and form.RHPJfinicio_s EQ 'PM'> selected</cfif>>PM</option>
                                                                        </select>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right"><strong>#LB_HoraSalida#:&nbsp;</strong></td>
                                                                    <td>
                                                                        <select id="RHPJffinal_h" name="RHPJffinal_h">
                                                                          <cfloop index="i" from="1" to="12">
                                                                            <option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("form.RHPJffinal_h") and form.RHPJffinal_h EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
                                                                          </cfloop>
                                                                        </select> :
                                                                        <select id="RHPJffinal_m" name="RHPJffinal_m">
                                                                          <cfloop index="i" from="0" to="59">
                                                                            <option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("form.RHPJffinal_m") and form.RHPJffinal_m EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
                                                                          </cfloop>
                                                                        </select>
                                                                        <select id="RHPJffinal_s"  name="RHPJffinal_s">
                                                                            <option value="AM" <cfif isdefined("form.RHPJffinal_s") and form.RHPJffinal_s EQ 'AM'> selected</cfif>>AM</option>
                                                                            <option value="PM" <cfif isdefined("form.RHPJffinal_s") and form.RHPJffinal_s EQ 'PM'> selected</cfif>>PM</option>
                                                                        </select>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right"><strong><cf_translate key="LB_Libre">Libre</cf_translate>:&nbsp;</strong></td>
                                                                    <td>
                                                                        <input type="radio" name="optLibre" value="0" checked><label><cf_translate key="LB_No">No</cf_translate></label>
                                                                        <input type="radio" name="optLibre" value="1"><label><cf_translate key="LB_Si">Si</cf_translate></label>
                                                                    </td>
                                                                </tr>
                                                                <tr><td>&nbsp;</td></tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="80%" cellpadding="0" cellspacing="0" align="center">
                                                                            <tr>
                                                                                <td width="50%" align="right"><input type="submit" name="btnGenerarMasivo" value="#BTN_GenerarMasivo#" onClick="javascript:return funcValidaFechas();"></td>
                                                                                <td width="50%" align="right"><input type="submit" name="btnBorrarMasivo" value="#BTN_BorrarMasivo#" onClick="javascript:  if ( confirm('#MSG_ConfirmaBorrado#') ){funcDesHabilita(); return funcValidaFechas();} return false;"></td>
                                                                            </tr>
                                                                      </table></td>
                                                                </tr>
																<tr>
                                                                    <td colspan="2">
                                                                        <fieldset><legend><cf_translate key="LB_Advertencia">Advertencia</cf_translate></legend>
																			<table width="80%" cellpadding="0" cellspacing="0" align="center">
																				<tr>
																					<td>
																					<li><cf_translate key="LB_AyudaTexto1">El proceso de generaci&oacute;n masiva respetar&aacute; los cambios de jornadas realizados por acciones de personal.</cf_translate></li>
																					</td>
																				</tr>
																		  </table>
																	  </fieldset>
																	  </td>
                                                                </tr>
																
                                                            </table>
                                                            </fieldset>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </form>
                                </table>
                            </cfoutput>						
                        <cf_web_portlet_end>
                    </td>	
                </tr>
            </table>
            <iframe name="ifr_horario" id="ifr_horario" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" ></iframe>
            
            <cf_qforms form="form1">
            <script type="text/javascript" language="javascript1.2">
                objForm.RHPJfinicio.description="<cfoutput>#LB_FechaInicio#</cfoutput>";
                objForm.RHPJffinal.description="<cfoutput>#LB_FechaVence#</cfoutput>";
                objForm.chk.description="<cfoutput>#MSG_Empleado#</cfoutput>";
                objForm.RHJid.description="<cfoutput>#LB_Jornada#</cfoutput>";
                objForm.RHPJfinicio.required = true;
                objForm.RHPJffinal.required = true;
                objForm.chk.required = true;
                objForm.RHJid.required = true;			
    
                function funcDesHabilita(){
                    objForm.RHJid.required = false;			
                }
    
                function funcTraeHorario(pn_RHJid){
                    var params = '&form=form1&hinicio=RHPJfinicio_h&minicio=RHPJfinicio_m&sinicio=RHPJfinicio_s&hfin=RHPJffinal_h&mfin=RHPJffinal_m&sfin=RHPJffinal_s';				
                    document.getElementById("ifr_horario").src = "PlanificaJornadas-TraerHorario.cfm?RHJid="+pn_RHJid+"&psOrigen=L"+params;
                }
                
                function funcFiltrar(){
                    document.form1.action = '';
                    document.form1.submit();
                }
                
                function funcValidaFechas(){
                    var inicio = document.form1.RHPJfinicio.value.split('/');
                    var fechainicio = inicio[2] + inicio[1] + inicio[0]
                    var hasta = document.form1.RHPJffinal.value.split('/');
                    var fechafinal = hasta[2] + hasta[1] + hasta[0]
                    if (fechainicio > fechafinal){
                        <cfoutput>alert("#MSG_FechaDesdeMayorFechaHasta#")</cfoutput>;
                        document.form1.RHPJffinal.value = '';
                        document.form1.RHPJfinicio.value = '';
                        return false;
                    }				
                    return true;
                }
                
                function funFechaInicial(){
                    var inicio = document.form1.RHPJfinicio.value.split('/');
                    var fechainicio = inicio[2] + inicio[1] + inicio[0];
                    var fechaactual = <cfoutput>'#vs_fechaActual#'</cfoutput>;
                    var fechaactual = fechaactual.split('/');
                    var fechaactual = fechaactual[2]+fechaactual[1]+fechaactual[0]
                    /*
                    if (fechainicio < fechaactual){
                        <cfoutput>alert("#MSG_FechaInicialMenorAHoy#")</cfoutput>;
                        document.form1.RHPJfinicio.value = <cfoutput>'#vs_fechaActual#'</cfoutput>;
                    }*/			
                    funcValidaFechas();
                }
                
                function funcChequeaTodos(){		
                    if (document.form1.chkTodos.checked){			
                        if (document.form1.chk && document.form1.chk.type) {
                            document.form1.chk.checked = true
                        }
                        else{
                            if (document.form1.chk){
                                for (var i=0; i<document.form1.chk.length; i++) {
                                    document.form1.chk[i].checked = true					
                                }
                            }
                        }
                    }	
                    else{
                        <cfset url.Todos = 0>
                        if (document.form1.chk && document.form1.chk.type) {
                            document.form1.chk.checked = false
                        }
                        else{
                            if (document.form1.chk){
                                for (var i=0; i<document.form1.chk.length; i++) {
                                    document.form1.chk[i].checked = false					
                                }
                            }
                        }
                    }
                }
                function funcMarcar(){
                    var chequeados =0
                    if (document.form1.chk && document.form1.chk.type) {
                        if(document.form1.chk.checked){
                            document.form1.chkTodos.checked = true
                        }
                        else{
                            if (document.form1.chk){
                                document.form1.chkTodos.checked = false
                            }	
                        }
                    }
                    else{					
                        if (document.form1.chk){
                            for (var i=0; i<document.form1.chk.length; i++) {
                                if(document.form1.chk[i].checked){
                                    chequeados=chequeados+1
                                }				
                            }
                        }
                        if (document.form1.chk){
                            if(document.form1.chk.length == chequeados){
                                document.form1.chkTodos.checked = true
                            }
                            else{
                                document.form1.chkTodos.checked = false
                            }
                        }
                    }
                }
    
            </script>	
    <cf_templatefooter>

<cfelse>
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="MENU_PlanificadorDeJornadas"
    Default="Planificador de Jornadas"
    returnvariable="MENU_PlanificadorDeJornadas"/>    
    
    <cf_templateheader title="#LB_RecursosHumanos#">
		<cf_web_portlet_start titulo="#MENU_PlanificadorDeJornadas#">
         <table width="100%" cellpadding="2" cellspacing="0">
        	 <tr>
             	<td align="center">&nbsp;
             		
                </td>
             </tr>
             
             <tr>
             	<td align="center">
             		<cf_translate  key="LB_Ayuda1">Este usuario no tiene acceso a esta opci&oacute;n</cf_translate>
                </td>
             </tr>
              <tr>
             	<td align="center">
             		<cf_translate  key="LB_Ayuda2">Porque no es autorizador</cf_translate>
                </td>
             </tr>
              <tr>
             	<td align="center">
             		<cf_translate  key="LB_Ayuda3">Para tener acceso debe configurarse en el m&oacute;dulo de marcas</cf_translate>
                </td>
             </tr>
             <tr>
             	<td align="center">&nbsp;
             		
                </td>
             </tr>
         </table>
	 <cf_web_portlet_end>
    <cf_templatefooter>

</cfif>




