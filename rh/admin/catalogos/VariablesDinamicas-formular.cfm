<cfparam name="form.RHDVDid" default="-1">

<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<cfif isdefined('url.CIid') and not isdefined('form.CIid')>
		<cfset form.CIid = url.CIid>
	</cfif>
	<cfparam name="form.CIid" default="-1">
	<cf_web_portlet_start titulo="Formular Variable">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfset regresar = "VariablesDinamicas.cfm">
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarStatusText = ArrayNew(1)>			 
					<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
					<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
					<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
				  <cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr> 
				<td colspan="2" align="left">
				<cfinclude template="TiposIncidencia-formularform.cfm">
				</td>
				<td >&nbsp;</td>
			</tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>