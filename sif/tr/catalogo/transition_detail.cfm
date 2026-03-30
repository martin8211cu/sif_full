<cfif isdefined("url.TransitionId") and not isnumeric(url.TransitionId)>
	<cfquery name="rs_transition" datasource="#session.DSN#">
		select max(TransitionId) as id
		from WfTransition
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
	</cfquery>
	<cfset url.TransitionId = rs_transition.id >
</cfif>

<cfparam name="session.ProcessId" type="numeric">
<cfparam name="url.TransitionId" type="numeric">

<cfquery datasource="#session.dsn#" name="Transition">
	select tr.Name, tr.Description, a1.Name from_Name, a2.Name to_Name, tr.ReadOnly, p.PublicationStatus,
		tr.NotifyRequester, tr.NotifyEveryone, tr.AskForComments
	from WfTransition tr
		join WfActivity a1
			on tr.FromActivity = a1.ActivityId
		join WfActivity a2
			on tr.ToActivity = a2.ActivityId
		join WfProcess p
			on p.ProcessId = tr.ProcessId
	where tr.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
	  and tr.TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TransitionId#">
</cfquery>
<html>
<head>
<cf_templatecss>

<script type="text/javascript">
<!--
<cfif IsDefined('url.reloadflash') and url.reloadflash is 1>
if (document.all) {
	window.parent.document.diagrama.rewind();
} else {
	<cfoutput>
	window.parent.document.location.href='process.cfm?ProcessId=#session.ProcessId#&TransitionId=#url.TransitionId#';
	</cfoutput>
}
</cfif>
	if (window.top == window) {
		top.location.href = 'process.cfm?ProcessId=<cfoutput>#URLEncodedFormat(session.ProcessId)#</cfoutput>';
	}
//-->
</script>

</head><body>

<cfoutput><form action="transition_apply.cfm" method="post" name="form1">
<table width="100%" border="0" cellpadding="0" cellspacing="2">
      <tr> 
      <td width="29%" colspan="2" class="subTitulo"><strong><cf_translate key="LB_NombreDeLaTransicion">Nombre de la Transici&oacute;n</cf_translate> </strong></td> 
      <td width="71%" class="subTitulo"><strong><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
      </tr>
    <tr valign="top"> 
      <td colspan="2"><input name="TransitionId" type="hidden" id="TransitionId" value="#HTMLEditFormat(url.TransitionId)#">
	  <input name="Name" type="text" id="Name" onFocus="this.select()" size="40" maxlength="20" value="#HTMLEditFormat(Transition.Name)#"></td>
      <td rowspan="8"><textarea name="Description" cols="36" rows="7" id="Description" style="font-family:Arial, Helvetica, sans-serif">#HTMLEditFormat(Transition.Description)#</textarea></td>
    </tr>
    <tr valign="top">
      <td colspan="2"><cf_translate key="LB_Desde" XmlFile="/sif/generales.xml">Desde</cf_translate>: #Transition.from_Name# </td>
    </tr>
    <tr valign="top">
      <td colspan="2"><cf_translate key="LB_Hasta" XmlFile="/sif/generales.xml">Hacia</cf_translate>: #Transition.to_Name# </td>
    </tr>
    <tr valign="top">
      <td colspan="2"><em><cf_translate key="MSG_LasSiguientesOpcionesPermitenTenerUnMayorControlCuandoSeRealicenTransicionesDeRechazo">Las siguientes opciones permiten tener un mayor control cuando se realicen transiciones de rechazo</cf_translate>.</em></td>
      </tr>
    <tr valign="top">
      <td>        <input type="checkbox" id="AskForComments" name="AskForComments" value="1" <cfif Transition.AskForComments>checked</cfif>>        </td>
      <td><label for="AskForComments"><cf_translate key="CHK_SolicitarObservacionesCuandoSeRealiceEstaTransicion"><strong>Solicitar observaciones</strong> cuando se realice esta transici&oacute;n</cf_translate>.</label></td>
    </tr>
<!---
    <tr valign="top">
      <td><input type="checkbox" id="NotifyRequester" name="NotifyRequester" value="1" <cfif Transition.NotifyRequester>checked</cfif>>        </td>
      <td><label for="NotifyRequester"><cf_translate key="CHK_NotificarPorCorreoElectronicoAlSolicitanteDelTramiteCuandoSeEjecuteEstaTransicion"><strong>Notificar</strong> por correo electr&oacute;nico al <strong>solicitante</strong> del tr&aacute;mite cuando se ejecute esta transici&oacute;n</cf_translate>. </label></td>
    </tr>
    <tr valign="top">
      <td><input type="checkbox" id="NotifyEveryone" name="NotifyEveryone" value="1" <cfif Transition.NotifyEveryone>checked</cfif>>        </td>
      <td><label for="NotifyEveryone"><cf_translate key="LB_NotificarPorCorreoATodosLosParticipantesDelTramiteCuandoSeEjecuteEstaTransicion"><strong>Notificar</strong> por correo electr&oacute;nico a <strong>todos</strong> los participantes del tr&aacute;mite cuando se ejecute esta transici&oacute;n</cf_translate>. </label></td>
    </tr>
---> 
   <tr><td colspan="3">&nbsp;</td></tr>
    <tr><td colspan="3">&nbsp;</td></tr>
    <tr>
      <td colspan="3">
		<cfif not Transition.ReadOnly and Not ListFind('RELEASED,RETIRED', Transition.PublicationStatus)>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Aplicar"
			Default="Aplicar"
			XmlFile="/sif/generales.xml"
			returnvariable="BTN_Aplicar"/>

			<input type="submit" name="apply" value="#BTN_Aplicar#" tabindex="1">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Eliminar"
				Default="Eliminar"
				XmlFile="/sif/generales.xml"
				returnvariable="BTN_Eliminar"/>

	  		<input type="submit" name="delete" value="#BTN_Eliminar#" tabindex="1">
		</cfif>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cancelar"
			Default="Cancelar"
			XmlFile="/sif/generales.xml"
			returnvariable="BTN_Cancelar"/>
		<input type="button" name="cancelar" value="&lt;&lt; #BTN_Cancelar#" tabindex="1" onClick="location.href='process_detail.cfm'"></td>
    </tr>
  </table>
</form></cfoutput>
</body></html>