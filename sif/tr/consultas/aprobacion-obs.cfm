<cf_template>

	<cf_templatearea name="title">
		<cfoutput><cf_translate key="LB_GestionDeTramites">Gesti&oacute;n de Tr&aacute;mites</cf_translate></cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AprobacionDeTramites"
	Default="Aprobaci&oacute;n de Tr&aacute;mites"
	returnvariable="LB_AprobacionDeTramites"/>
<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_AprobacionDeTramites#">



<cfquery datasource="#session.dsn#" name="hdr">
	select xp.ProcessInstanceId, xp.ProcessId,
		p.Description AS ProcessDescription,
		p.Name AS ProcessName,
		a.Description AS ActivityDescription,
		a.Name AS ActivityName,
		xp.Description AS ProcessInstanceDescription, e.Edescripcion,
		xp.RequesterId
	from WfxProcess xp
		join WfProcess p
			on p.ProcessId = xp.ProcessId
		join Empresas e
			on e.Ecodigo = xp.Ecodigo
		left join WfxActivity xa
			on xa.ProcessInstanceId = xp.ProcessInstanceId
			  and xa.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">
		left join WfActivity a
			on a.ActivityId = xa.ActivityId
	where xp.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
</cfquery>

<cfif Len(hdr.RequesterId)>
	<cfquery datasource="asp" name="requester">
		select u.Usulogin, 
			{fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})} as FullName
		from Usuario u
			join DatosPersonales dp
				on u.datos_personales = dp.datos_personales
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.RequesterId#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="responsables">
	select xap.Name, xap.Description, xap.Usucodigo
	from WfxActivityParticipant xap
	where xap.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">
</cfquery>

	<cfquery datasource="#session.dsn#" name="transition_info">
		select AskForComments, NotifyRequester, NotifyEveryone, Name
		from WfTransition
		where TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TransitionId#">
	</cfquery>
	
<cfinclude template="/home/menu/pNavegacion.cfm">

	<cfoutput>
		<form action="aprobacion-apply.cfm" method="get" name="form1" id="form1" onSubmit="return validar(this);">
	
	<input type="hidden" name="from" value="#HTMLEditFormat(url.from)#">
	<input type="hidden" name="ProcessInstanceId" value="#HTMLEditFormat(url.ProcessInstanceId)#">
	<input type="hidden" name="ActivityInstanceId" value="#HTMLEditFormat(url.ActivityInstanceId)#">
	<input type="hidden" name="TransitionId" value="#HTMLEditFormat(url.TransitionId)#">

	<table width="771"  border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="50" valign="top">&nbsp;</td>
        <td width="166" valign="top">&nbsp;</td>
        <td width="505" valign="top">&nbsp;</td>
        <td width="50" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_"TramiteNumero>Tr&aacute;mite N&uacute;mero</cf_translate> </strong></td>
        <td valign="top">#hdr.ProcessInstanceId#</td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_Empresa">Empresa</cf_translate></strong></td>
        <td valign="top">#hdr.Edescripcion#</td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_TipoTramite">Tipo Tr&aacute;mite</cf_translate> </strong></td>
        <td valign="top">#hdr.ProcessName#<br>
      #hdr.ProcessDescription#</td>
        <td valign="top">&nbsp;</td>
      </tr>
      <cfif IsDefined('requester')>
        <tr>
          <td>&nbsp;</td>
          <td><strong><cf_translate key="LB_SolicitadoPor">Solicitado por</cf_translate> </strong></td>
          <td>#requester.FullName#</td>
          <td>&nbsp;</td>
        </tr>
      </cfif>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
        <td valign="top"><strong>#hdr.ProcessInstanceDescription#</strong></td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_Actividad">Actividad</cf_translate></strong></td>
        <td valign="top">#hdr.ActivityName#<br>#hdr.ActivityDescription#</td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_Responsable">Responsable</cf_translate></strong></td>
        <td valign="top"><cfloop query="responsables">
            <cfif responsables.Usucodigo is session.Usucodigo and responsables.RecordCount gt 1>
          #responsables.Description# &larr;
          <cfelse>
          #responsables.Description#
            </cfif>
            <br>
        </cfloop></td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_AccionSolicitada">Acci&oacute;n solicitada</cf_translate> </strong></td>
        <td valign="top"><strong>#transition_info.Name#</strong></td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr><td colspan="4" valign="top">&nbsp;</td></tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td colspan="2" valign="top"><em> 
		<cf_translate key="MSG_ParaContinuarDebeIndicarEnElCampoDeObservacionesLasRazonesPorLasCualesEstaTomandoEstaAccion">
			Para continuar, debe indicar en el campo de Observaciones las razones por las cuales est&aacute; tomando esta acci&oacute;n.<br>
		</cf_translate>
		<cf_translate key="MSG_EstasObservacionesQuedaranRegistradasEnLaInformacionDelTramite">
			Estas observaciones quedar&aacute;n registradas en la informaci&oacute;n del tr&aacute;mite.<br>
		</cf_translate>
	    	<cfif transition_info.NotifyRequester or transition_info.NotifyEveryone>
				<cf_translate key="MSG_EstasObservacionesSeranEnviadasPorCorreoElectronicoA">
		  			Estas observaciones</em><em> ser&aacute;n enviadas por correo electr&oacute;nico a
				</cf_translate>
	        <cfif transition_info.NotifyRequester And transition_info.NotifyEveryone>
				<cf_translate key="MSG_LaPersonaQueInicioYLasPersonasQueHanAprobadoEsteTramite">
			    la persona que inici&oacute; y las personas que han aprobado este tr&aacute;mite
				</cf_translate>.				
		      <cfelseif transition_info.NotifyRequester>
			  <cf_translate key="MSG_LaPersonaQueInicioEsteTramite">
			    la persona que inici&oacute; este tr&aacute;mite
				</cf_translate>.
		      <cfelseif transition_info.NotifyEveryone>
			  	<cf_translate key="MSG_LasPersonasQueHanAprovadoEsteTramite">
			    las personas que han aprobado este tr&aacute;mite
				</cf_translate>.
		    </cfif>
	    </cfif>	    </em> </td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr><td colspan="4" valign="top">&nbsp;</td></tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:</strong></td>
        <td valign="top">&nbsp;</td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td colspan="2" valign="top"><textarea cols="120" rows="10" style="font-family:Arial, Helvetica, sans-serif;font-size:12px" name="TransitionComments" id="TransitionComments"></textarea></td>
        <td valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td colspan="2" valign="top"><input type="submit" value="#HTMLEditFormat(transition_info.Name)#&nbsp;&gt;&gt;"></td>
        <td valign="top">&nbsp;</td>
      </tr>
    </table> 
	
	    </form>
	</cfoutput>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeIndicarEnElCampoDeObservacionesLaRazonPorLaCualEstaTomandoEstaAccion"
	Default="Debe indicar en el campo de observaciones la razón por la cual está tomando esta acción"
	returnvariable="MSG_DebeIndicarEnElCampoDeObservacionesLaRazonPorLaCualEstaTomandoEstaAccion"/>

<script type="text/javascript">
<!--
	function validar(f) {
		if (f.TransitionComments.value.length == 0) {
			alert("<cfoutput>#MSG_DebeIndicarEnElCampoDeObservacionesLaRazonPorLaCualEstaTomandoEstaAccion#</cfoutput>.");
			return false;
		}
		return true;
	}
//-->
</script>
	
</cf_web_portlet>
</cf_templatearea>
</cf_template>
