<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>
<!--- SE VERIFICA SI EL USUARIO ES JEFE DE ALGUN CENTRO FUNCIONAL (OPCION TRAMITES PARA SUBORDINADOS) --->
﻿<cfif isdefined("Url.Jefe") and not isdefined("Form.Jefe")>
	<cfset Form.Jefe = Url.Jefe>
</cfif>
﻿<cfif isdefined("Url.CentroF") and not isdefined("Form.CentroF")>
	<cfset Form.CentroF = Url.CentroF>
</cfif>
<cfif isdefined("Url.DEidSub") and not isdefined("Form.DEidSub")>
	<cfset Form.DEidSub = Url.DEidSub>
</cfif>
<cfif isdefined('form.DEidSub') and LEN(TRIM(form.DEidSub))>
	<cfset form.DEid = form.DEidSub>
</cfif>
<!--- FIN (TRAMITE PARA SUBORDINADOS) --->
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfset Form.sel = Url.sel>
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
  <tr>
    <td>
		<cfif not isdefined("form.Jefe") or (isdefined('form.DEidSub') and form.DEidSub GT 0)>
		<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</cfif>
	</td>
  </tr>
  <tr>
    <td class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;">
		<cfif isdefined("Form.Cambio")>  
		  <cfset modo="CAMBIO">
		<cfelse>  
		  <cfif not isdefined("Form.modo")>    
			<cfset modo="ALTA">
		  <cfelseif Form.modo EQ "CAMBIO">
			<cfset modo="CAMBIO">
		  <cfelse>
			<cfset modo="ALTA">
		  </cfif>  
		</cfif>
		<cfif modo EQ "CAMBIO">
			<cf_translate key="Editar">Editar</cf_translate> <cfif Session.Params.ModoDespliegue EQ 0><cf_translate key="LB_Tramite" xmlfile="/rh/generales.xml">Tr&aacute;mite</cf_translate><cfelse><cf_translate key="LB_Accion" xmlfile="/rh/generales.xml">Acci&oacute;n</cf_translate></cfif>
		<cfelse>
			<cfif Session.Params.ModoDespliegue EQ 0><cf_translate key="LB_Nuevo_Tramite">Nuevo Tr&aacute;mite</cf_translate><cfelse><cf_translate key="LB_Nueva_Accion">Nueva Acci&oacute;n</cf_translate></cfif>
		</cfif>
	</td>
  </tr>
  <tr>
    <td><cfinclude template="/rh/nomina/operacion/Acciones-form.cfm"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <cfif modo NEQ "CAMBIO">
  <tr>
    <td class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;">
		<cfif Session.Params.ModoDespliegue EQ 0>
			<cf_translate key="LB_Lista_de_Tramites">Lista de Tr&aacute;mites</cf_translate>
		<cfelse>
			<cf_translate key="LB_Lista_de_Acciones">Lista de Acciones</cf_translate>
		</cfif>
	</td>
  </tr>
  <tr>
    <td><cfinclude template="/rh/nomina/operacion/Acciones-listaForm.cfm"></td>
  </tr>
  </cfif>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>