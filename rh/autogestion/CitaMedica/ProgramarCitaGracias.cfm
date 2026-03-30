<cfparam name="url.cita">

<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
</cfinvoke>
<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.MiAgenda()>
<cfset info = ComponenteAgenda.InfoCita(CodigoAgenda, url.cita)>

<cf_template>
<cf_templatearea name="body">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MiAgenda"
	Default="Mi agenda"
	returnvariable="LB_MiAgenda"/>
<cf_web_portlet_start titulo="#LB_MiAgenda#">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cfoutput>
  <div class="tituloListas"><cf_translate key="LB_CitaMedicaRealizada">Cita médica realizada</cf_translate></div>
  <br></cfoutput>
  
<cfoutput>
<form name="form1" method="get" action="MiAgenda.cfm">
<input type="hidden" name="fecha" value="#LSDateFormat(info.fecha,'DD/MM/YYYY')#">
<table border="0">
  <tr valign="top">
    <td><cf_translate key="LB_Asunto">Asunto</cf_translate></td>
    <td># (info.texto)#</td>
  </tr>
  <tr valign="top">
    <td width="132"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
    <td width="296"><cf_locale name="date" value="#info.fecha#"/></td>
  </tr>
  <tr valign="top">
    <td><cf_translate key="LB_Inicio">Inicio</cf_translate></td>
    <td>#TimeFormat(info.inicio,'HH:MM')#</td>
  </tr>
  <tr valign="top">
    <td><cf_translate key="LB_Final">Final</cf_translate></td>
    <td>#TimeFormat(info.final,'HH:MM')#</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Listo"
	Default="Listo"
	returnvariable="BTN_Listo"/>
		  <cf_boton texto="&nbsp;&nbsp;#BTN_Listo#&nbsp;&nbsp;" index="1" 
					estilo="2" size="200" funcion="form1.submit();"></td>
  </tr>
</table>

</form></cfoutput>
<cf_web_portlet_end>
</cf_templatearea>
</cf_template>