<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	

<cfinvoke Key="LB_ReporteDatosFunc" Default="Reporte de datos de los funcionarios activos" returnvariable="LB_ReporteDatosFunc" component="sif.Componentes.Translate" method="Translate"/>

<!---<cf_dump var="#form#">--->
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_ReporteDatosFunc#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_ReporteDatosFunc#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
				<cfset params = ''>
				
					<cfif isdefined('form.cmb_Dep') and (form.cmb_Dep NEQ -1) >
						<cfset params = params & '&Dcodigo=' & form.cmb_Dep>
					</cfif>					
					<cfif isdefined ('form.TDid') and len(trim(form.TDid))>
						<cfset params = params & '&TDid=' & form.TDid>
					</cfif>					
					<cfif isdefined('form.cmb_CSid') and (form.cmb_CSid NEQ -1) >
						<cfset params = params & '&CSid=' & form.cmb_CSid>
					</cfif>					
					<cfif isdefined('form.cmb_Puesto') and (form.cmb_Puesto NEQ -1) >
						<cfset params = params & '&RHPcodigo=' & form.cmb_Puesto>
					</cfif>					
					<cfif isdefined('form.cmb_CatPuesto') and (form.cmb_CatPuesto NEQ -1) >
						<cfset params = params & '&RHCid=' & form.cmb_CatPuesto>
					</cfif>
					<cfif isdefined('form.cmb_Sexo') and (form.cmb_Sexo NEQ -1) >
						<cfset params = params & '&DEsexo=' & form.cmb_Sexo>
					</cfif>
                   <cfif isdefined('form.cmb_Sede') and (form.cmb_Sede NEQ -1) >
						<cfset params = params & '&Ocodigo=' & form.cmb_Sede>
					</cfif>
				   <cfif isdefined('form.cmb_Prest') and (form.cmb_Prest NEQ -1) >
						<cfset params = params & '&DClinea=' & form.cmb_Prest>
					</cfif>
				    <cfif isdefined('form.cmb_Persep') and (form.cmb_Persep NEQ -1) >
						<cfset params = params & '&CIid=' & form.cmb_Persep>
					</cfif>
				   
<cf_reportWFormat url="/rh/nomina/consultas/RepDatosFuncActivos-rep.cfm" orientacion="portrait" regresar="RepDatosFuncActivos.cfm"params="#params#">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>

