
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<cfset LB_RecursosHumanos = t.translate('LB_RecursosHumanos','Recursos Humanos','/rh/generales.xml')>
<cfset LB_Formatos = t.translate('LB_Formatos','Formatos','/rh/generales.xml')>

<cf_templateheader title="#LB_RecursosHumanos# - #LB_Formatos#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_RecursosHumanos# - #LB_Formatos#'>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
							<td colspan="2"><cfinclude template="formFormatosTipos.cfm"></td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>
