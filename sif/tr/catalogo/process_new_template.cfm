<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
		<cf_translate key="LB_DefinirTramite">Definir Tr&aacute;mite</cf_translate>
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
<!--- <cfinclude template="/home/menu/pNavegacion.cfm"> --->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DefinirTramite"
	Default="Definir Tr&aacute;mite"
	returnvariable="LB_DefinirTramite"/>

	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_DefinirTramite#">



<cfoutput><div style="background-color:##ededed;"><br>
&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_SelecioneELTipoDeTramiteQueDeseaCrear">Seleccione el tipo de tr&aacute;mite que desea crear</cf_translate></strong><br>
<br></div>
<table width="80%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><form name="form1" method="post" action="process_new.cfm">
		<cfif Len(session.WfPackageBaseName)>
			<cfset Plantillas = session.WfPackageBaseName>
		<cfelse>
			<cfinvoke component="sif.Componentes.Workflow.plantillas" method="ListarPlantillas" returnvariable="Plantillas" />
		</cfif>
      <cfloop from="1" to="#ArrayLen(Plantillas)#" index="n">
        <input type="radio" name="plantilla" id="plantilla_#n#" tabindex="1" value="#HTMLEditFormat(ListFirst(Plantillas[n]))#" <cfif n is 1>checked</cfif>>
        <label for="plantilla_#n#"> #HTMLEditFormat(ListRest(Plantillas[n]))# </label>
        <br>
      </cfloop>
	  <br>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_NuevoTramite"
	Default="Nuevo Trámite"
	returnvariable="BTN_NuevoTramite"/>

      <input type="submit" name="Submit" value="#BTN_NuevoTramite#" tabindex="1">
    </form></td>
  </tr>
</table>

</center>
</cfoutput> <br>
<br>
<br>
<br>
<br>
<br>
<br>

	</cf_web_portlet>
</cf_templatearea>
</cf_template>
