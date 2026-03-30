<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/sif/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ExportacionASAP" default="Exportaci&oacute; a SAP" returnvariable="LB_ExportacionASAP" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfif isdefined('CPid1') and LEN(TRIM(CPid1))>
						<cfset form.CPid = CPid1>
						<cfset form.CPcodigo = CPcodigo1>
						<cfset form.Tcodigo = Tcodigo1>
					<cfelseif isdefined('CPid2') and LEN(TRIM(CPid2))>
						<cfset form.CPid = CPid2>
						<cfset form.CPcodigo = CPcodigo2>
						<cfset form.Tcodigo = Tcodigo2>
					</cfif>
					<cfset params = ''>
                    <cfif isdefined('form.busca') and LEN(TRIM(form.busca)) GT 0>
						<cfset params = params & '&busca=' & form.busca>
					</cfif>
					<cfif isdefined('form.Clave') and LEN(TRIM(form.Clave))>
						<cfset params = params & '&Clave=' & form.Clave>
					</cfif>
					<cfif isdefined('form.CodExterno') and LEN(TRIM(form.CodExterno))>
						<cfset params = params & '&CodExterno=' & form.CodExterno>
					</cfif>
					<cfif isdefined('form.CPcodigo') and LEN(TRIM(form.CPcodigo))>
						<cfset params = params & '&CPcodigo=' & form.CPcodigo>
					</cfif>
					<cfif isdefined('form.CPdescripcion') and LEN(TRIM(form.CPdescripcion))>
						<cfset params = params & '&CPdescripcion=' & form.CPdescripcion>
					</cfif>
					<cfif isdefined('form.CPid') and LEN(TRIM(form.CPid))>
						<cfset params = params & '&CPid=' & form.CPid>
					</cfif>
					<cfif isdefined('form.Empleado') and LEN(TRIM(form.Empleado))>
						<cfset params = params & '&Empleado=' & form.Empleado>
					</cfif>
					<cfif isdefined('form.Orden') and LEN(TRIM(form.Orden))>
						<cfset params = params & '&Orden=' & form.Orden>
					</cfif>
					<cfif isdefined('form.Tcodigo') and LEN(TRIM(form.Tcodigo))>
						<cfset params = params & '&Tcodigo=' & form.Tcodigo>
					</cfif>
					<cfif isdefined('form.Todos') and LEN(TRIM(form.Todos))>
						<cfset params = params & '&Todos=' & form.Todos>
					</cfif>
					<cfif isdefined("form.TipoNomina") and len(trim(form.TipoNomina)) GT 0>
						<cfset params= params & '&TipoNomina='& #form.TipoNomina#>
					</cfif>
	                <cf_reportWFormat url="/rh/nomina/consultas/ExportaSAP-rep.cfm" orientacion="portrait" regresar="ExportaSAP.cfm" params="#params#">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>

