<cf_navegacion name="UsucodigoParticipante" default="" session>
<cf_navegacion name="UsucodigoNombre" default="" session>

<cfif isdefined("form.UsucodigoParticipante") and form.UsucodigoParticipante NEQ "">
	<cfif form.UsucodigoParticipante EQ "-1">
		<cfset form.UsucodigoNombre = "** SIN RESPONSABLE ASIGNADO **">
		<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkloadNull" returnvariable="workload">
			<cfinvokeargument name="Usucodigo" value="#form.UsucodigoParticipante#">
		</cfinvoke>
		<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_GestionDeTramitesNull"
				Default="Gesti&oacute;n de Tr&aacute;mites Pendientes sin Participante Asignado"
				returnvariable="LB_GestionDeTramites"/>
	<cfelse>
		<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
			<cfinvokeargument name="Usucodigo" value="#form.UsucodigoParticipante#">
		</cfinvoke>
		<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_GestionDeTramitesUno"
				Default="Gesti&oacute;n de Tr&aacute;mites Pendientes Asignados a un Participante"
				returnvariable="LB_GestionDeTramites"/>
	</cfif>
<cfelse>
	<cfinvoke component="sif.Componentes.Workflow.Management" method="getAllOpenProcesses" returnvariable="workload">
		<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
	</cfinvoke>
	<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_GestionDeTramitesTodos"
			Default="Gesti&oacute;n de Tr&aacute;mites Pendientes de todos los Participantes"
			returnvariable="LB_GestionDeTramites"/>
</cfif>
<cf_template>
	<cf_templatearea name="title">
		<cfoutput><cf_translate key="LB_GestionDeTramites">Gesti&oacute;n de Tr&aacute;mites Pendientes</cf_translate></cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">

		<cf_web_portlet_start border="true" titulo="#LB_GestionDeTramites#" skin="#Session.Preferences.Skin#">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cf_dbfunction name="OP_Concat" returnvariable="_CAT">
				<form name="formFiltro" action="consola.cfm" method="post">
					<table>
						<tr>
							<td>
								<strong>PARTICPANTE :</strong>
							</td>
							<td>
								<cf_conlis title="LISTA DE EMPLEADOS"
									campos = "UsucodigoParticipante, Usulogin, Nombre" 
									desplegables = "N,S,S" 
									modificables = "N,S,N" 
									size = "0,15,40"
									asignar="UsucodigoParticipante,Usulogin,Nombre"
									asignarformatos="S,S,S"
									tabla="
											Usuario u 
												inner join DatosPersonales dp 
													on dp.datos_personales = u.datos_personales
												inner join WfxActivity b
													join WfxActivityParticipant a 
														on a.ActivityInstanceId = b.ActivityInstanceId
													join WfxProcess c
														on c.ProcessInstanceId = b.ProcessInstanceId
													join WfProcess d
														on d.ProcessId = c.ProcessId
													join WfActivity f
														on f.ActivityId = b.ActivityId
													join Empresas e
														on e.Ecodigo = c.Ecodigo
														and e.Ecodigo = #session.Ecodigo#
												on a.Usucodigo = u.Usucodigo
											"
									columnas="distinct u.Usucodigo as UsucodigoParticipante, Pid, Usulogin, Pnombre #_CAT#' '#_CAT# Papellido1 #_CAT#' '#_CAT# Papellido2 as Nombre"
									filtro="
												c.State != 'COMPLETED'
												  and ( 
														b.State != 'COMPLETED' 
													or 	
														(b.State = 'COMPLETED' and f.IsFinish = 0 and not exists (select 1 from WfxTransition t where t.FromActivityInstance = b.ActivityInstanceId))
													  )
											"
									desplegar="Pid, Usulogin, Nombre"
									etiquetas="Identificación,Login,Nombre"
									formatos="S,S,S"
									align="left,left,left"
									showEmptyListMsg="true"
									EmptyListMsg=""
									form="formFiltro"
									width="800"
									height="500"
									left="70"
									top="20"
									filtrar_por="Pid,Usulogin,Pnombre #_CAT#' '#_CAT# Papellido1 #_CAT#' '#_CAT# Papellido2"
									index="1"
									funcion="fnSubmit"
									funcionValorEnBlanco="fnNoSubmit"
									traerInicial="#form.UsucodigoParticipante NEQ "" AND form.UsucodigoParticipante NEQ "-1" AND form.UsucodigoParticipante NEQ ""#"
									traerFiltro="u.Usucodigo = #form.UsucodigoParticipante#"
								/> 
								<script language="javascript">
									<cfoutput>
									var LvarNombre = '#form.UsucodigoNombre#'
									</cfoutput>
									document.formFiltro.Nombre.value = LvarNombre;
									function fnSubmit()
									{
										LvarNombre = document.formFiltro.Nombre.value;
										if (document.formFiltro.UsucodigoParticipante.value != '<cfoutput>#form.UsucodigoParticipante#</cfoutput>')
											document.formFiltro.submit();
									}
									function fnNoSubmit()
									{
										document.formFiltro.Nombre.value = LvarNombre;
									}
								</script>
							</td>
							<td>
								<img src="/cfmx/sif/imagenes/NONE_D.gif" style="cursor:pointer" onclick="document.formFiltro.UsucodigoParticipante.value='-1'; document.formFiltro.submit();" title="Sin Responsables asignado"/>
								<img src="/cfmx/sif/imagenes/deletesmall.gif" style="cursor:pointer" onclick="document.formFiltro.UsucodigoParticipante.value=''; document.formFiltro.submit();" title="Todos los Trámites"/>
							</td>
						</tr>
					</table>
				</form>  
			<cfset request.lista_actividades_superuser = true>
			<cfinclude template="lista_actividades.cfm">
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
