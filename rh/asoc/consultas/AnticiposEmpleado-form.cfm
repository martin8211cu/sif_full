<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_EstadodelEmpleado" Default="Estado del Empleado" returnvariable="LB_EstadodelEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfset params = ''>
                    <cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
						<cfset params = params & '&DEid=' & form.DEid>
					</cfif>
					<cfif isdefined('form.ACCTid') and LEN(TRIM(form.ACCTid))>
						<cfset params = params & '&ACCTid=' & form.ACCTid>
					</cfif>
					<cfif isdefined('form.chkSaldoCero') and LEN(TRIM(form.chkSaldoCero))>
						<cfset params = params & '&chkSaldoCero=' & form.chkSaldoCero>
					</cfif>
					<cfif isdefined('form.chkCorte') and LEN(TRIM(form.chkCorte))>
						<cfset params = params & '&chkCorte=' & form.chkCorte>
					</cfif>
					<cfif isdefined('form.Fdesde') and LEN(TRIM(form.Fdesde))>
						<cfset params = params & '&Fdesde=' & form.Fdesde>
					</cfif>
					<cfif isdefined('form.Fhasta') and LEN(TRIM(form.Fhasta))>
						<cfset params = params & '&Fhasta=' & form.Fhasta>
					</cfif>
	                <cf_reportWFormat url="/rh/asoc/consultas/AnticiposEmpleado-rep.cfm" orientacion="portrait" regresar="AnticiposEmpleado.cfm" params="#params#" pagina="true">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>
