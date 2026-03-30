<cfoutput> 

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ModificarMisDatos" default="Modificar Mis Datos" returnvariable="LB_ModificarMisDatos" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
	<cfif not isdefined('form.DEid')>
		<cfset form.DEid=#rsEmpleado.DEid#>
	</cfif>
  <table width="95%" border="0" cellspacing="0" cellpadding="3" style="margin-left: 10px; margin-right: 10px;">
    <cfif Session.Params.ModoDespliegue EQ 1>
		<tr> 
		  <td colspan="2">&nbsp;</td>
		</tr>
	</cfif>
	<cfif tabAccess[2]>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="DatosGenerales">DATOS GENERALES</cf_translate></td>
    </tr>
	</cfif>
    <tr> 
      <td valign="top" nowrap> 
		<cfif tabAccess[2]>
		  <cfinclude template="frame-general.cfm">
	 	<cfelse>
		  <cfinclude template="frame-infoEmpleado.cfm">
     	</cfif> 
	  </td>
      <td align="center" valign="top" nowrap>
		<cfif isdefined('rsModificaDE') and not isdefined("Url.Imprimir") and (rsModificaDE.RecordCount GT 0 and rsModificaDE.Pvalor EQ 1) >
			<cf_boton texto="#LB_ModificarMisDatos#" index="1"  link="/cfmx/rh/autogestion/autogestion.cfm" estilo="8" size="200">
		</cfif>
	  	<cfinclude template="frame-jerarquiaPuesto.cfm">
	  </td>
    </tr>
	<cfif tabAccess[8]>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="Vacaciones">VACACIONES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="frame-vacaciones.cfm">
	  </td>
    </tr>
	</cfif>
	<cfif tabAccess[3]>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="ListaDeFamiliares">LISTA DE FAMILIARES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="frame-familiares.cfm">
	  </td>
    </tr>
	</cfif>
	
	<cfif tabAccess[4]>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="SituacionActual">SITUACION ACTUAL</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="frame-situacionActual.cfm">
	  </td>
    </tr>
	</cfif>
	<cfif tabAccess[5]>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="Cargas">CARGAS</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="frame-cargas.cfm">
	  </td>
    </tr>	
	</cfif>
	
	<cfif tabAccess[6]>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="Deducciones">DEDUCCIONES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="frame-deducciones.cfm">
	  </td>
    </tr>
	</cfif>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaPermisoOpcion"
		Sistema="RH" Modulo="AUTO" Proceso="EXPED_BEN"
		Usuario = "#session.Usucodigo#" returnvariable="AccesoBeneficios">
	<cfif AccesoBeneficios.RecordCount>
		<cfif tabAccess[12]>
		<tr>
		  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="Beneficios">BENEFICIOS</cf_translate></td>
		</tr>
		<tr>
		  <td colspan="2" valign="top" nowrap>
			  <cfinclude template="frame-beneficios.cfm">
		  </td>
		</tr>
		</cfif>
	</cfif>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaPermisoOpcion"
		Sistema="RH" Modulo="AUTO" Proceso="EXPED_OT"
		Usuario = "#session.Usucodigo#" returnvariable="AccesoOtrosExp">
	<cfif AccesoOtrosExp.RecordCount>
		<cfif tabAccess[9]>
		<tr>
		  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="OtrosExpedientes">OTROS EXPEDIENTES</cf_translate></td>
		</tr>
		<tr>
		  <td colspan="2" valign="top" nowrap>
			  <cfinclude template="frame-expedientes.cfm">
		  </td>
		</tr>
		</cfif>
	</cfif>
	
	<cfif tabAccess[7]>
    <tr>
	  <td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="Anotaciones">ANOTACIONES</cf_translate></td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>
		  <cfinclude template="frame-anotaciones.cfm">
	  </td>
    </tr>
	</cfif>
    <tr>
      <td colspan="2" >&nbsp;</td>
    </tr>
  </table>
<cfelse>
	<cf_translate key="MSG_LosDatosDeSuExpedienteLaboralNoEstanDisponibles">Los datos de su Expediente Laboral no est&aacute;n disponibles</cf_translate>
</cfif>
</cfoutput>