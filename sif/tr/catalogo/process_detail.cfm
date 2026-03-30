<cfparam name="session.ProcessId" type="numeric">

<cfinvoke component="sif.Componentes.Workflow.WfProcess" method="findById" returnvariable="Process">
	<cfinvokeargument name="ProcessId" value="#session.ProcessId#">
</cfinvoke>

<cfquery datasource="#session.dsn#" name="usado">
	select count(1) as cantidad
	from WfxProcess
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Process.ProcessId#">
</cfquery>

<html>
<head>
<cf_templatecss>
<cf_templatecss>

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ElNombreEsRequerido"
			Default="El nombre es requerido"
			XmlFile="/sif/generales.xml"
			returnvariable="LB_ElNombreEsRequerido"/>

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_LaDesccripcionEsRequerida"
			Default="La descripción es requerida"
			XmlFile="/sif/generales.xml"
			returnvariable="LB_LaDesccripcionEsRequerida"/>


<script type="text/javascript">
<!--
<cfparam name="url.reloadflash" default="0">
<cfif url.reloadflash is '1'>
if (document.all) {
	window.parent.document.diagrama.rewind();
} else {
	<cfoutput>
	window.parent.document.location.href='process.cfm?ProcessId=#session.ProcessId#';
	</cfoutput>
}
</cfif>
	if (window.top == window) {
		top.location.href = 'process.cfm?ProcessId=<cfoutput>#URLEncodedFormat(session.ProcessId)#</cfoutput>';
	}
	
	function validarForm(f) {
		if (f.Name.value.match(/^\s*$/)) {
			alert("#LB_ElNombreEsRequerido#");
			f.Name.focus();
			return false;
		}if (f.Description.value.match(/^\s*$/)) {
			alert("#LB_LaDesccripcionEsRequerida#");
			f.Description.focus();
			return false;
		}
		return true;
	}

//-->
</script>

</head><body>

<cfoutput><form action="process_apply.cfm" method="post" name="form1" id="form1" target="_top" onSubmit="return validarForm(this);">
<table width="932" border="0" cellpadding="1" cellspacing="0">
  <!--DWLayoutTable-->
	  <tr>
	    <td width="230" class="subTitulo"><strong><cf_translate key="LB_NombreDelTramite" XmlFile="/sif/generales.xml">Nombre del Tr&aacute;mite</cf_translate></strong></td>
	    <td width="321" class="subTitulo"><strong><cf_translate key="LB_DocumentacionDetallada">Documentaci&oacute;n detallada</cf_translate> </strong></td>
        <td width="373" class="subTitulo"><!--DWLayoutEmptyCell-->&nbsp;</td>
	  </tr>
    <tr> 
      <td valign="top">
	  <input name="ProcessId" type="hidden" id="ProcessId" value="#HTMLEditFormat(Process.ProcessId)#">
	  <input name="Name" tabindex="1" type="text" id="Name" onFocus="this.select()" size="40" maxlength="20" value="#HTMLEditFormat(Process.Name)#"></td> 
      <td rowspan="9" valign="top"><textarea tabindex="3" name="Documentation" cols="60" rows="7" id="Documentation" style="font-family:Arial, Helvetica, sans-serif;width:320px">#HTMLEditFormat(Process.Documentation)#</textarea></td>
      <td rowspan="9" valign="top">&nbsp;
	  </td>
    </tr>
    <tr> 
      <td valign="top"><strong><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
      </tr>
    <tr>
      <td valign="top"><input name="Description" tabindex="2" type="text" id="Description" onFocus="this.select()" size="40" maxlength="255" value="#HTMLEditFormat(Process.Description)#"></td>
      </tr>
    <tr>
      <td valign="top"><strong><cf_translate key="LB_Estado" XmlFile="/sif/generales.xml">Estado</cf_translate></strong></td>
    </tr>
    <tr>
      <td valign="top">
	  <cfif Process.PublicationStatus is 'RELEASED'>
	  	<img src="lock.gif" width="12" height="14" border="0" align="absmiddle" >
	  	<span title="RELEASED" style="background-color:##66CC00">&nbsp;&nbsp;&nbsp;</span>
		<cf_translate key="LB_Aprobrado">Aprobado</cf_translate>
	  <cfelseif Process.PublicationStatus is 'UNDER_TEST'>
	  	<span title="UNDER_TEST" style="background-color:##CCCC00">&nbsp;&nbsp;&nbsp;</span>
		<cf_translate key="LB_SeEstaProbando">Se est&aacute; probando</cf_translate>
	  <cfelseif Process.PublicationStatus is 'UNDER_REVISION'>
	  	<span title="UNDER_REVISION" style="background-color:##993333">&nbsp;&nbsp;&nbsp;</span>
		<cf_translate key="LB_EnConstruccion">En construcci&oacute;n</cf_translate>
	  <cfelseif Process.PublicationStatus is 'RETIRED'>
	  	<span title="RETIRED" style="background-color:##CCCCCC">&nbsp;&nbsp;&nbsp;</span>
		<cf_translate key="LB_Retirado">Retirado</cf_translate>
	  <cfelse>#Process.PublicationStatus#
	  </cfif></td>
      </tr>
    <tr>
      <td valign="top"><strong><cf_translate key="LB_Version">Versi&oacute;n</cf_translate></strong></td>
    </tr>
    <tr>
      <td valign="top">#Replace(Process.Version,' ','','all')#
	  <cfif Usado.cantidad><br>
	  	<cf_translate key="MSG_EstaVersionDelTramiteSeHaUsado">Esta versi&oacute;n del tr&aacute;mite se ha usado</cf_translate> #usado.cantidad# <cf_translate key="LB_Veces">veces</cf_translate>.
	  </cfif>
	  </td>
    </tr>
    <tr>
      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
    </tr>
    <tr>
      <td valign="top" nowrap>
	  <cfif ListFind('UNDER_REVISION,UNDER_TEST', Process.PublicationStatus)>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Aplicar"
			Default="Aplicar"
			XmlFile="/sif/generales.xml"
			returnvariable="BTN_Aplicar"/>
	 	  <input type="submit" name="apply" value="#BTN_Aplicar#">
	 </cfif>
	  <cfif Not ListFind('RELEASED', Process.PublicationStatus)>
	  	  <cfset msg = Process.validar()>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Publicar"
			Default="Publicar"
			returnvariable="BTN_Publicar"/>
		<cfif ArrayLen(msg)>
			<input type="button" name="publish2" value="#BTN_Publicar#" 
			  	onClick="javascript:alert('#JSStringFormat(ArrayToList(msg,Chr(13)))#')">		  
		<cfelse>
			  <input type="submit" name="publish" value="#BTN_Publicar#">
		</cfif>
	</cfif>
	 <cfif Usado.Cantidad is 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Eliminar"
			Default="Eliminar"
			XmlFile="/sif/generales.xml"
			returnvariable="BTN_Eliminar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EstaSeguroDeQueDeseaEliminarEsteTramite"
			Default="¿Está seguro de que desea eliminar este trámite?"
			returnvariable="MSG_EstaSeguroDeQueDeseaEliminarEsteTramite"/>

	    <input type="submit" name="delete" value="#BTN_Eliminar#"
			onClick="if (confirm('#MSG_EstaSeguroDeQueDeseaEliminarEsteTramite#')){form.target='_top';}else{return false;}" >
	</cfif>
	  <cfif ListFind('RELEASED', Process.PublicationStatus)>
  			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_ReabrirDefinicion"
			Default="Reabrir definici&oacute;n"
			returnvariable="BTN_ReabrirDefinicion"/>
  			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DeseaReabrirLaDefinicionDeEsteTramiteEstoCrearaUnaNuevaVersionDelTramite"
			Default="¿Desea reabrir la definición de este trámite?\nEsto creará una nueva versión del trámite."
			returnvariable="MSG_DeseaReabrirLaDefinicionDeEsteTramiteEstoCrearaUnaNuevaVersionDelTramite"/>

		  <input type="submit" name="reopen" value="#BTN_ReabrirDefinicion#" onClick="return confirm('#MSG_DeseaReabrirLaDefinicionDeEsteTramiteEstoCrearaUnaNuevaVersionDelTramite#');">

  			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_RetirarInactivar"
			Default="Retirar / inactivar"
			returnvariable="BTN_RetirarInactivar"/>
  			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DeseaRetirarLaDefinicionDeEsteTramite"
			Default="¿Desea retirar la definición de este trámite?\nEsto impedirá que se continue utilizando este trámite hasta que se publique de nuevo una versión del trámite."
			returnvariable="MSG_DeseaRetirarLaDefinicionDeEsteTramite"/>
		  <input type="submit" name="retire" value="#BTN_RetirarInactivar#" onClick="return confirm('#MSG_DeseaRetirarLaDefinicionDeEsteTramite#');">
	  </cfif>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cancelar"
			Default="Cancelar"
			XmlFile="/sif/generales.xml"
			returnvariable="BTN_Cancelar"/>

	  <input type="button" name="cancelar" value="&lt;&lt; #BTN_Cancelar#" onClick="window.open('process_list.cfm','_top')"></td>
    </tr>
  </table>
</form></cfoutput>
</body></html>