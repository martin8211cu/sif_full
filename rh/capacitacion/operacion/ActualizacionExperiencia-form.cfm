<cfset modoExperiencia = "ALTA">
<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid))>
	<cfset modoExperiencia = "CAMBIO">
</cfif>
<!--- Querys previos ---->
<cfinvoke Key="LB_NombreDeLaEmpresa" Default="Nombre de la empresa" returnvariable="LB_NombreDeLaEmpresa" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_TelefonoDeLaEmpresa" Default="Tel&eacute;fono de la empresa" returnvariable="LB_TelefonoDeLaEmpresa" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_Profesion_u_oficio" Default="Profesi&oacute;n u oficio" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_FechaDeIngreso" Default="Fecha de ingreso" returnvariable="LB_FechaDeIngreso" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_FechaDeRetiro" Default="Fecha de retiro" returnvariable="LB_FechaDeRetiro" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_MotivoDelRetiro" Default="Motivo del retiro" returnvariable="LB_MotivoDelRetiro" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_FuncionesYLogrosObtenidos" Default="Funciones y logros obtenidos" returnvariable="LB_FuncionesYLogrosObtenidos"component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="CHK_Actualmente" Default="Actualmente" returnvariable="CHK_Actualmente" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_AnnosLaborados" Default="A&ntilde;os Laborados" returnvariable="LB_AnnosLaborados" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/> 
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"XmlFile="/rh/generales.xml" />
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate"XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Eliminar" Default="Eliminar" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Nuevo" Default="Nuevo" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DeseaEliminarElRegistro" Default="Desea eliminar el registro" returnvariable="MSG_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>        
<cfinvoke Key="LB_MesDeInicio" Default="Mes de inicio" returnvariable="LB_MesDeInicio" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_AnoDeInicio" Default="Año de Inicio" returnvariable="LB_AnoDeInicio" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_MesDeRetiro" Default="Mes de retiro" returnvariable="LB_MesDeRetiro" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_AnoDeRetiro" Default="Año de retiro" returnvariable="LB_AnoDeRetiro" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_PuestoDesempenado" Default="Puesto desempeñado" returnvariable="LB_PuestoDesempenado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarElAnoYMesDeFinalizacion" Default="Debe seleccionar el año y mes de finalización" returnvariable="MSG_DebeSeleccionarElAnoYMesDeFinalizacion" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_ExperienciaDel" Default="Experiencia del" returnvariable="LB_ExperienciaDel" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_Oferente" Default="oferente"  returnvariable="LB_Oferente" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/> 
<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>  
<cfinvoke Key="LB_Actualmente" Default="Actualmente" returnvariable="LB_Actualmente" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke Key="LB_ExperienciaLaboral" Default="Experiencia laboral" returnvariable="LB_ExperienciaLaboral" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_Deseable" default="Deseable"returnvariable="LB_Deseable" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_Intercambiable" default="Intercambiable"returnvariable="LB_Intercambiable" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_Requerido" default="Requerido"returnvariable="LB_Requerido" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_ExperienciaRequerida" default="Experiencia Requerida" returnvariable="LB_ExperienciaRequerida" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_PendienteDeAprobar" default="Pendiente de Aprobar" returnvariable="LB_PendienteDeAprobar" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_Rechazada" default="Rechazada" returnvariable="LB_Rechazada" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="MSG_DeseaAprobarElEstudioRealizado" default="Desea aprobar el Estudio Realizado?" returnvariable="MSG_DeseaAprobarElEstudioRealizado" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/capacitacion/operacion/ActualizacionExperiencia.xml"/>
<cfinvoke key="LB_Aprobado" default="Aprobado" returnvariable="LB_Aprobado" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml"/>
 
<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
    <cfset destino = "AprobacionCV-sql.cfm" >   
    <cfset self='AprobacionCV.cfm'>
<cfelse>
    <cfset destino = "ActualizacionExperiencia-sql.cfm" > 
    <cfset self='ActualizacionExperiencia.cfm'>
</cfif>


<cfif modoExperiencia neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">		
		select 	RHEEid, RHEEnombreemp, RHEEtelemp, RHOPid, RHEEfechaini, RHEEfecharetiro,RHEEmotivo,
				Actualmente, RHEEfunclogros, ts_rversion, RHEEmotivo,RHEEpuestodes,RHEEAnnosLab,RHEEestado,RHEEObserv,
				RHEEDV1,RHEEDV2,RHEEDV3,RHEEDV4,RHEEDV5,RHEEDV6,RHEEDV7,RHEEDV8,RHEEDV9,RHEEDV10
		from RHExperienciaEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
          and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
</cfif>
<cfquery name="rsDatosVarAll" datasource="#Session.DSN#">
	select RHDVEcol,
		   RHDVEDatoV,
		   RHDVErequerido
	from RHDVExperiencia
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and RHDVEdisplay = 1
</cfquery>


<cfset consulta = 1>
<cfset consulta2 = 1>
<cfif not isdefined("fromAprobacionCV")>
    <table width="100%" cellpadding="0" cellspacing="0" align="center">
    	<tr>
    		<td colspan="2"><cfinclude template="../expediente/info-empleado.cfm"></td>
    	</tr>
    </table>
</cfif>
<cfinvoke key="LB_Educacion" default="Educacion" returnvariable="LB_Educacion" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Aprobar" default="Aprobar" returnvariable="LB_Aprobar" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Rechazar" default="Rechazar" returnvariable="LB_Rechazar"  xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Regresar" default="Regresar" returnvariable="LB_Regresar"  xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>

<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td width="50%" valign="top">
            <cfset LvarFormatData = 'dd/mm/yyyy'>
            <cfif findNoCase("en", session.idioma)>
                <cfset LvarFormatData = 'mm/dd/yyyy'>
            </cfif>
			<cfquery name="rsLista3" datasource="#session.DSN#">					
                select 	a.RHEEid,
                        {fn concat(a.RHEEnombreemp,{fn concat(' - ',{fn concat(a.RHEEpuestodes,{fn concat(' - ',case <cf_dbfunction name="date_format" args="RHEEfecharetiro,#LvarFormatData#"> when '01/01/6100' then '#LB_Actualmente#'else <cf_dbfunction name="date_format" args="RHEEfecharetiro,#LvarFormatData#"> end)})})})} as descripcion,
                        a.RHEEfechaini,
                        a.RHEEfecharetiro,
                        '3' as tab,
                            '#form.DEid#' as DEid,
                        2 as o, 1 as sel
                        ,case when a.RHEEestado = 1 then 'X' else '' end as estado
                                                            
                from RHExperienciaEmpleado a
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
                Order by a.RHEEfecharetiro desc
            </cfquery>

            <cfinvoke 
            component="rh.Componentes.pListas"
            method="pListaQuery"
            returnvariable="pListaRet">
                <cfinvokeargument name="query" value="#rsLista3#"/>
                <cfinvokeargument name="desplegar" value="descripcion,estado"/>
                <cfinvokeargument name="etiquetas" value="#LB_ExperienciaLaboral#,#LB_Aprobado#"/>
                <cfinvokeargument name="formatos" value="V,V"/>
                <cfinvokeargument name="align" value="left,center"/>
                <cfinvokeargument name="ajustar" value="S"/>
                <cfinvokeargument name="irA" value="#self#"/>
                <cfinvokeargument name="showEmptyListMsg" value="true"/>
                <cfinvokeargument name="keys" value="RHEEid"/>
                <cfinvokeargument name="formName" value="formExperienciaLista"/>
                <cfinvokeargument name="PageIndex" value="3"/>
            </cfinvoke>
		</td>
		<td width="50%" valign="top">
			<cfoutput>
			<form name="formEducacion" action="#destino#" method="post">
				<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
				<input type="hidden" name="RHEEid" value="<cfif isdefined('data')>#data.RHEEid#</cfif>">
                <cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
                    <input type="hidden" name="tab" value="3">
                </cfif>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
                        <td align="right" nowrap><strong>#LB_NombreDeLaEmpresa#:&nbsp;</strong></td>
                        <td><cfif modoExperiencia neq 'ALTA'>#trim(data.RHEEnombreemp)#</cfif></td>
                    </tr>
                    <tr>
                        <td align="right" nowrap><strong>#LB_TelefonoDeLaEmpresa#:&nbsp;</strong></td>
                        <td><cfif modoExperiencia neq 'ALTA'>#trim(data.RHEEtelemp)#</cfif></td>
                    </tr>
                    <tr>
                        <td align="right" nowrap><strong>#LB_Puesto#:&nbsp;</strong></td>
                        <td><cfif modoExperiencia neq 'ALTA'>#data.RHEEpuestodes#</cfif></td>
                    </tr>		
                    <tr>
                        <td align="right" nowrap><strong>#LB_FechaDeIngreso#:&nbsp;</strong></td>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                      <cfif modoExperiencia neq 'ALTA'>
										<cfset v_mes = '' >
										<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
										<cfset v_mes = listgetat(lista_meses, month(data.RHEEfechaini)) >
										#v_mes#
										</cfif> 
                                    </td>
                                    <td>&nbsp;</td>
                                    <td><cfif modoExperiencia neq 'ALTA'>#year(data.RHEEfechaini)#</cfif></td>
								
                                </tr>					
                            </table>
                        </td>
                    </tr>		
                    <tr>
                        <td align="right" nowrap><strong>#LB_FechaDeRetiro#:&nbsp;</strong></td>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                      <cfif modoExperiencia neq 'ALTA'>
										<cfset v_mes = '' >
										<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
										<cfset v_mes = listgetat(lista_meses, month(data.RHEEfecharetiro)) >
										#v_mes#
										</cfif> 
                                    </td>
                                    <td>&nbsp;</td>
                                    <td><cfif modoExperiencia neq 'ALTA'>#year(data.RHEEfecharetiro)#</cfif></td>
								
                                </tr>					
                            </table>
                        </td>
                    </tr>		
                    <tr>
                        <td align="right" nowrap><strong>#LB_AnnosLaborados#:&nbsp;</strong></td>
                        <td><cfif modoExperiencia NEQ 'ALTA'><cfoutput>#data.RHEEAnnosLab#</cfoutput><cfelse>0.00</cfif></td>
                    </tr>
                    <tr>
                        <td align="right"><strong>#LB_MotivoDelRetiro#:&nbsp;</strong></td>
                        <td>
							<cfif modoExperiencia NEQ 'ALTA'>
                        	<cfswitch expression="#data.RHEEmotivo#">
                            	<cfcase value="0"><cf_translate key="CMB_Renuncia">Renuncia</cf_translate></cfcase>
                                <cfcase value="10"><cf_translate key="CMB_Despido">Despido</cf_translate></cfcase>
                                <cfcase value="20"><cf_translate key="CMB_FinDeContrato">Fin de Contrato</cf_translate></cfcase>
                                <cfcase value="30"><cf_translate key="CMB_FinDeProyecto">Fin de proyecto</cf_translate></cfcase>
                                <cfcase value="40"><cf_translate key="CMB_CierreOperaciones">Cierre operaciones</cf_translate></cfcase>
                                <cfcase value="50"><cf_translate key="CMB_Otros">Otros</cf_translate></cfcase>
                            </cfswitch> 
							</cfif>
                        </td>
                    </tr>					
					<cfif isdefined('rsDatosVarAll') and rsDatosVarAll.recordCount GT 0>
						<tr><td colspan="2" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="DatosVariables">Datos Variables</cf_translate></td></tr>
						<tr><td colspan="2" align="center">&nbsp;</td></tr>
						<tr> 
							<td colspan="2" align="center">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<cfloop query="rsDatosVarAll">
									  <!--- Campos Variables de Datos del empleado --->
									  <tr> 
										<td width="21%" nowrap class="fileLabel"><cfoutput>#rsDatosVarAll.RHDVEDatoV#</cfoutput>:</td>
										<td width="79%"> 
										  <cfoutput> 
											<cfif modoExperiencia NEQ 'ALTA'><cfoutput>#Evaluate("data.#rsDatosVarAll.RHDVEcol#")#</cfoutput></cfif>
										  </cfoutput> 
										</td>
									  </tr>
									</cfloop>
								</table>
							</td>			
						</tr>
					</cfif>
                    <tr><td colspan="2" align="center" nowrap><strong>#LB_FuncionesYLogrosObtenidos#&nbsp;</strong></td><td>&nbsp;</td></tr>
                    <tr>			
                        <td colspan="2">
                            <cfif modoExperiencia neq 'ALTA'>
                                #trim(data.RHEEfunclogros)#
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                                <td align="right" nowrap><strong><cf_translate key="LB_Estado">Estado</cf_translate>:</strong></td>
                                <td><cfif modoExperiencia neq 'ALTA'><strong><cfif data.RHEEestado EQ 0>#LB_PendienteDeAprobar#<cfelseif data.RHEEestado EQ 2>#LB_Rechazada#</cfif></strong></cfif></td>
                            </tr>
                            <tr>
                        <td align="right" valign="top"><strong><cf_translate key="LB_Observ">Observaciones</cf_translate>:</strong></td>
                        <td><textarea name="RHEEObserv" cols="70" rows="7"><cfif modoExperiencia NEQ 'ALTA'>#data.RHEEObserv#</cfif></textarea></td>
                    </tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="4" align="center">
                            <cfif isdefined("fromAprobacionCV")>
							    <cfif modoExperiencia neq 'ALTA'>
                                    <cfif data.RHEEestado eq 1>
                                        <cf_botones values="#LB_Rechazar#" names="btnRechazar">
                                    <cfelse>    
                                        <cf_botones values="#LB_Aprobar#" names="btnAprobar">
                                    </cfif>
                                </cfif>
                            <cfelse>
                                <cfif modoExperiencia neq 'ALTA'><cf_botones values="#LB_Aprobar#,#LB_Rechazar#,#LB_Regresar#" names="btnAprobar,btnRechazar,btnRegresar"><cfelse><cf_botones values="Regresar"></cfif>
                            </cfif>
						</td>
					</tr>
				</table>
				<cfif modoExperiencia neq 'ALTA'>
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
				</cfif>
			</form>
			</cfoutput>
		</td>
	</tr>
</table> 

<script type="text/javascript">
	function funcRegresar(){
		document.formEducacion.DEid.value = '';
		document.formEducacion.RHEElinea.value = '';
		document.formEducacion.action = "ActualizacionEstudiosR.cfm";
	}
	
	function funcAprobar(){
		if (confirm('<cfoutput>#MSG_DeseaAprobarElEstudioRealizado#</cfoutput>')){
			return true;
		}else{
			return false;
		}
	}
</script>