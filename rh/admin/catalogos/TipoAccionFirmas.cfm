<!--- VARIBLES DE TRADUCCION --->
<cfinvoke key="LB_AdministracionDeNomina" default="Administraci&oacute;n de N&oacute;mina" returnvariable="LB_AdministracionDeNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" xmlfile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FirmasTipoAccion" default="Firmas Tipo de Acci&oacute;n" returnvariable="LB_FirmasTipoAccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Autorizador" default="Autorizador" returnvariable="LB_Autorizador" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Usuario" default="Empleado" returnvariable="LB_Usuario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Solicita" default="Solicitante" returnvariable="LB_Solicita" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jefe" default="Jefe" returnvariable="LB_Jefe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EncargadoCF" default="Encargado Centro Funcional" returnvariable="LB_EncargadoCF" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Firmante" default="Firmante" returnvariable="LB_Firmante" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Orden" default="Orden" returnvariable="LB_Orden" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIBLES DE TRADUCCION --->

<cfif isdefined('url.RHTid') and not isdefined('form.RHTid')>
	<cfset form.RHTid = url.RHTid>
</cfif>

<!--- LEER DESCRIPCION TIPO ACCION --->
<cfquery name="rsRHTipoAccion" datasource="#session.DSN#">
	select RHTdesc
	from RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#"> 
</cfquery>
<cfif isdefined("rsRHTipoAccion") and rsRHTipoAccion.RecordCount neq 0 and not isdefined("form.RHTdesc")>
	<cfset form.RHTdesc = rsRHTipoAccion.RHTdesc>
</cfif>

<!--- Pinta los encabezados muetra la seccion de la Lista --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>

	<cf_web_portlet_start border="true" titulo="#LB_FirmasTipoAccion#" skin="#Session.Preferences.Skin#">
			<cfset regresar = "/cfmx/rh/admin/catalogos/TipoAccion.cfm">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
			<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			<table width="100%" border="0" cellspacing="1" cellpadding="1">
                <td align="center" colspan="2"><strong><font size="2">
                  <cf_translate key="LB_FirmasdelaAccion">Firmas de la Acci&oacute;n</cf_translate>
                  : </font></strong> <font size="2"><cfoutput>#form.RHTdesc#</cfoutput></font> </td>
              </tr>
              <tr>
                <td valign="top" width="40%"><cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
                  <cfinvokeargument name="conexion" value="#Session.DSN#"/>
                  <cfinvokeargument name="columnas" value="RHFid, RHTid, RHFOrden,													
															case RHFtipo when 1 then '#LB_Autorizador#'
																		 when 2 then '#LB_Usuario#'
															 			 when 3 then '#LB_Solicita#'
																		 when 4 then '#LB_Jefe#'
																		 when 5 then '#LB_EncargadoCF#' 
															end	as Tipo"/>
                  <cfinvokeargument name="tabla" value="RHFirmasAccion"/>
                  <cfinvokeargument name="desplegar" value="RHFOrden, tipo"/>
                  <cfinvokeargument name="etiquetas" value="#LB_Orden#, #LB_Firmante#"/>
                  <cfinvokeargument name="formatos" value="I,S"/>
                  <cfinvokeargument name="align" value="center, left"/>
                  <cfinvokeargument name="irA" value="TipoAccionFirmas.cfm"/>
                  <cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and RHTid = #form.RHTid# order by RHFtipo"/>
                  <cfinvokeargument name="ajustar" value="N"/>
                  <cfinvokeargument name="keys" value="RHFid"/>
                  <cfinvokeargument name="showEmptyListMsg" value="true"/>
                  <!--- <cfinvokeargument name="MaxRows" value="2"/> --->
                  </cfinvoke>                </td> <!--- Hace el llamado al include para la parte del matenimiento --->	
                <td valign="top" width="60%" align="center"><cfinclude template="formTipoAccionFirmas.cfm"></td>
              </tr>
            </table>
			<cf_web_portlet_end>
<cf_templatefooter>