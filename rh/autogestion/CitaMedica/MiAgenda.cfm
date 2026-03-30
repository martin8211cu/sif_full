<cfparam name="url.fecha" default="">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
	<cfset url.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>
<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>

<cfset CitasParaHoy = ComponenteAgenda.ListarCitas(ComponenteAgenda.MiAgenda(), LSParseDateTime(url.fecha), true)>
<cfset Info = ComponenteAgenda.InfoAgenda(ComponenteAgenda.MiAgenda())>
<!--- 
<cfset ComponenteAgendaM = CreateObject("Component", "rh.Componentes.AgendaMedica")>
<cfset CitasParaHoy = ComponenteAgenda.ListarCitas(ComponenteAgendaM.AgendaMedica(), LSParseDateTime(url.fecha), true)>
<cfset Info = ComponenteAgenda.InfoAgenda(ComponenteAgendaM.AgendaMedica())>
 --->

<cf_templateheader> 
	<cf_web_portlet_start> 
		<cfoutput><div class="tituloListas"><cf_translate key="LB_MisCitasParaEl">Mis citas para el</cf_translate> #url.fecha#</div><br></cfoutput>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td valign="top">
				<cfif CitasParaHoy.RecordCount>
					<table width="652" border="0" cellpadding="2" cellspacing="0">
					<cfoutput query="CitasParaHoy">
					  <tr style="background-color:<cfif CitasParaHoy.CurrentRow mod 2 is 1>##ededed<cfelse>##ffffff</cfif> ">
						<td width="2" valign="top">&nbsp;</td>
						<td width="87" valign="top">#LSTimeFormat( Inicio, 'HH:MM' )# - #LSTimeFormat( Final, 'HH:MM' )#</td>
						<td width="3" valign="top">&nbsp;</td>
						<td width="322" valign="top" <cfif Len(cita) and (Eliminada OR AlguienElimino)> style="text-decoration:line-through;"</cfif>>#Texto#&nbsp;</td>
						<td width="2" valign="top">&nbsp;</td>
						<td width="68" valign="top">
							<cfif Len(cita) and Eliminada>
								
							<cfelseif Len(cita)>
								<cfif Notificar>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										key="ALT_NotificarAntesDeLaCita"
										default="Notificar antes de la cita"
										returnvariable="ALT_NotificarAntesDeLaCita"/>						
								  	<img src="alarm.gif" alt="#ALT_NotificarAntesDeLaCita#" width="12" height="16" border="0">
								</cfif>
								<cfif Confirmada>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										key="ALT_UstedYaConfirmoEstaCita"
										default="Usted ya confirmó esta cita"
										returnvariable="ALT_UstedYaConfirmoEstaCita"/>						
								  <img src="confirmed.gif" alt="#ALT_UstedYaConfirmoEstaCita#" width="16" height="16" border="0">
								</cfif>
								<cfif Not TodosVan>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										key="ALT_FaltaRecibirLaConfirmacionDeLaCita"
										default="Falta recibir la confirmación de la cita"
										returnvariable="ALT_FaltaRecibirLaConfirmacionDeLaCita"/>						
								  	<img src="pending.gif" alt="#ALT_FaltaRecibirLaConfirmacionDeLaCita#" width="16" height="16" border="0">
								</cfif>
							</cfif>&nbsp;
						</td>
						<td width="101" valign="top">
							<form name="formcancelar#CurrentRow#" method="post" action="CancelarCita.cfm" style="margin:0 ">
								<input type="hidden" name="cita" value="#cita#">
								<input type="hidden" name="fecha" value="#url.fecha#">
								<cfif Len(cita) and Eliminada>
									<input type="hidden" name="e" value="0">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										key="BTN_Confirmar"
										default="Confirmar"
										returnvariable="BTN_Confirmar"/>
									<!--- <cf_boton texto="&nbsp;&nbsp;#BTN_Confirmar#" index="#CurrentRow*10+2#" size="115" 
										estilo="2" funcion="formcancelar#CurrentRow#.submit();"> --->
								<cfelseif Len(cita)>
									<input type="hidden" name="e" value="1">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										key="BTN_CancelarCita"
										default="Cancelar cita"
										returnvariable="BTN_CancelarCita"/>
									<cf_boton texto="&nbsp;&nbsp;#BTN_CancelarCita#" index="#CurrentRow*10+2#" size="115"
										estilo="2" funcion="formcancelar#CurrentRow#.submit();">
								</cfif>
							</form>
						</td>
						<td width="17" valign="top">&nbsp;</td>
						</tr>
					</cfoutput>
					</table>
				<cfelse>
					== <cf_translate key="MSG_NoHayCitasRegistradas">No hay citas registradas</cf_translate> ==
		    	</cfif>
			</td>
		    <td valign="top" align="center"><cf_calendario value="#LSParseDateTime(url.fecha)#" onChange="location.href='?fecha='+escape(dmy)" >
		<br>
		<cfoutput>
		  <form name="formcita" method="get" action="ProgramarCita.cfm">
		<input type="hidden"  value="#url.fecha#" name="fecha" >
		<cfif LSParseDateTime(url.fecha) ge CreateDateTime(Year(Now()),Month(Now()), Day(Now()),0,0,0)>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="BTN_NuevaCita"
				default="Nueva cita"
				xmlfile="/rh/generales.xml"
				returnvariable="BTN_NuevaCita"/>
			<cf_boton texto="&nbsp;&nbsp;#BTN_NuevaCita#&nbsp;&nbsp;" index="1BIS" 
							estilo="2" size="150" funcion="formcita.submit();"></cfif>

		  </form></cfoutput></td>
		  </tr>
		</table>
	<cf_web_portlet_end> 
<cf_templatefooter>