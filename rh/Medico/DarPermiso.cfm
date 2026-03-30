<cfparam name="form.Usucodigo" type="numeric">
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="yes">
</cfinvoke>
<cfinvoke component="home.Componentes.Agenda" method="ListarPermisos" returnvariable="permisos">
	<cfinvokeargument name="Agenda" value="#url.ag#"/>
	<cfinvokeargument name="Usucodigo" value="#form.Usucodigo#"/>
</cfinvoke>


<cf_template>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Agenda M&eacute;dica - Opciones">
<cfinclude template="/home/menu/pNavegacion.cfm">
<style type="text/css">
<!--
.permiso_warning_32 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	color: #993300;
	font-weight: bold;
}
-->
</style>


  <div class="tituloListas">Indique qu&eacute; permisos desea otorgar al
  usuario <cfoutput>
  #form.Pnombre# #form.Papellido1# #form.Papellido2#
  </cfoutput> </div>
  
  <form name="form1" method="post" action="DarPermiso-sql.cfm">
  <cfoutput>
    <input type="hidden" name="Usucodigo" value="#form.Usucodigo#">
    <input type="hidden" name="agenda" value="#url.ag#">
</cfoutput>
    <table width="484">
<cfif form.Usucodigo is session.Usucodigo>
      <tr>
        <td width="2" valign="top">&nbsp;</td>
        <td width="21" valign="top">
        <td colspan="2" valign="top"><span class="permiso_warning_32">Precauci&oacute;n:<br> 
        Va a modificar sus propios permisos sobre la agenda.</span></td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top">      
        <td colspan="2" valign="top">&nbsp;</td>
      </tr></cfif>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><input name="propietario" type="checkbox" id="propietario" value="1" <cfif form.Usucodigo is session.Usucodigo> disabled</cfif> <cfif permisos.propietario is 1>checked</cfif>>
        <td colspan="2" valign="top"><label for="propietario"><strong>Actuar como propietario de la agenda.</strong> Si usted da este permiso, el usuario podr&iacute;a modificar los permisos de esta agenda, e incluso descalificarlo a usted para accederla.</label></td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><input name="lectura" type="checkbox" id="lectura" value="1" <cfif permisos.lectura is 1>checked</cfif>>
        <td colspan="2" valign="top"><label for="lectura"><strong>Leer la agenda.</strong> Este permiso le permitir&aacute; leer el contenido de la agenda y las citas planeadas, pero no podr&aacute; modificar la agenda. </label></td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><input name="escritura" type="checkbox" id="escritura" value="1" <cfif permisos.escritura is 1>checked</cfif>>
        <td colspan="2" valign="top"><label for="escritura"><strong>Modificar la agenda.</strong> Con este permiso, el usuario tendr&aacute; control total de su agenda, pudiendo crear citas, y examinar y modificar las existentes, pero no podr&aacute; modificar ni transferir los permisos existentes sobre la agenda. </label></td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"><input name="citar" type="checkbox" id="citar" value="1" <cfif permisos.citar is 1>checked</cfif>>          
        <td colspan="2" valign="top"><label for="citar"><strong>Crear citas.</strong> Al asignar este permiso, el usuario podr&iacute;a definir nuevas citas que le involucren, y ver su tiempo libre, pero no podr&aacute; ver el contenido de su agenda y sus citas. </label></td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top" nowrap>&nbsp;    </td>
        <td width="156" valign="top" nowrap>
		<cf_boton texto="&nbsp;&nbsp;&lt;&lt;&nbsp;Regresar&nbsp;&nbsp;" index="1" 
					estilo="2" link="Permisos.cfm?ag=#url.ag#"> </td>
        <td width="285" valign="top" nowrap> 
		<cf_boton texto="&nbsp;&nbsp;Asignar&nbsp;permisos&nbsp;&gt;&gt;&nbsp;&nbsp;" index="2" 
					estilo="2" funcion="form1.submit();"> </td>
      </tr>
    </table>
  </form>  
  <br>
<br>
<cf_web_portlet_end></cf_templatearea></cf_template>