<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
<cfinclude template="../../ad/catalogos/EncDatosSocio.cfm">
<cfif isdefined("url.tabs") and len(trim(url.tabs)) and not isdefined("form.tabs")>
	<cfset form.tabs = url.tabs>
</cfif>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<cfset regresa = ' '>
			<cfif isdefined('form.CxP')>
				<cfset regresa = "../../cp/consultas/analisisSocioCP.cfm?SNcodigo=#form.SNcodigo#&Ocodigo_F=#form.Ocodigo_F#">
			<cfelse>
				<cfset regresa = "../../cc/consultas/analisisSocio.cfm?SNcodigo=#form.SNcodigo#&Ocodigo_F=#form.Ocodigo_F#">
			</cfif>
			
			<cfif isdefined("form.CatSoc")>
				<cfset regresa = regresa & '&CatSoc=#form.CatSoc#'>
			</cfif>
			<cfparam name="form.tabs" default="1">
			<cfset LvarReadOnly =1>
			 <cf_tabs width="100%">
				<cf_tab text="Datos Generales" selected="#form.tabs eq 1#"> 
					<cfinclude template="../../ad/catalogos/DatosSocio.cfm">
				</cf_tab>
				<cf_tab text="Clasificación General" selected="#form.tabs eq 2#">
					<cfinclude template="../../ad/catalogos/DatosSClasif.cfm">
				</cf_tab> 
				<cf_tab text="Detalle" selected="#form.tabs eq 3#">
					<cfinclude template="../../ad/catalogos/DatosSInfoCred.cfm">
				</cf_tab>  
				<cf_tab text="Anotaciones" selected="#form.tabs eq 5#">
					 <cfinclude template="Anotaciones.cfm">
				</cf_tab>
				<cf_tab text="Documentos" selected="#form.tabs eq 6#">
					 <cfinclude template="ObjetosSN.cfm">
				</cf_tab>
			</cf_tabs>
		</td>
	</tr>
</table>
		<cf_web_portlet_end>
<cf_templatefooter>
