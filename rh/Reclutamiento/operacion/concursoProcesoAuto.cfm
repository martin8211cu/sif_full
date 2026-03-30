
<cfquery name="RSDeid" datasource="#session.DSN#">
    select ltrim(rtrim(llave)) as Deid  from UsuarioReferencia  
    where  Usucodigo   = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
    and STabla = 'DatosEmpleado'
    and Ecodigo = <cfqueryparam value="#session.EcodigoSDC#" cfsqltype="cf_sql_numeric">
</cfquery> 

<cfif len(trim(RSDeid.DEid)) GT 0>
 <cfinvoke component="rh.Componentes.RH_Funciones" 
    method="DeterminaJefe"
    DEid = "#RSDeid.DEid#"
    fecha = "#Now()#"
    returnvariable="esjefe">
<cfelse>
<cfset esjefe = false>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>




 <cfif isdefined("esjefe.CFID") and len(trim(esjefe.CFID))>
        <cf_templateheader title="#nav__SPdescripcion#">
            <cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
                <cfoutput>#pNavegacion#</cfoutput>
                <cfinclude template="concursoProcesoAuto-update.cfm">
                <cfinclude template="concursoProcesoAuto-config.cfm">
                <cfinclude template="concursoProcesoAuto-getData.cfm">
                <cfif isdefined("url.flag")>
                    <cfset Form.flag = url.flag>
                </cfif>
                <br>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="1%">&nbsp;</td>
                    <!--- Columna de Ayuda --->
                    <td valign="top">
                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td>&nbsp;</td>
                            <td>
                                <cf_web_portlet_start titulo='#Gdescpasos[Gpaso+1]#'>
                                    <br>
                                    <cfinclude template="concursoProceso-paso#Gpaso#.cfm">
                                    <br>
                                <cf_web_portlet_end>
                            </td>
                            <td>&nbsp;</td>
                          </tr>
                        </table>
                    </td>
                    <!--- Columna de Menú de Pasos y Sección de Ayuda --->
                    <td><td>&nbsp;</td></td>
                    <td width="1%">&nbsp;</td>
                  </tr>
                </table>
                <br>
            <cf_web_portlet_end>
	<cf_templatefooter>
<cfelse>
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="MENU_SolicitudDeAperturaDeConcursos"
    Default="Solicitud de Apertura de Concursos"
    returnvariable="MENU_SolicitudDeAperturaDeConcursos"/>    
    <cf_templateheader title="#MENU_SolicitudDeAperturaDeConcursos#">
        <cf_web_portlet_start titulo="<cfoutput>#MENU_SolicitudDeAperturaDeConcursos#</cfoutput>">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="center">
                        <cf_translate key="LB_Mensaje" >Para poder ingresar a esta opci&oacute;n es necesario que el usuario sea jefe </cf_translate>
                    </td>
                </tr>
            </table>
       
        <cf_web_portlet_end>
    <cf_templatefooter>
</cfif>

