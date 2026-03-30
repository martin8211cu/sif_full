<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeExportadores"
	Default="Lista de Exportadores "
	returnvariable="LB_ListaDeExportadores"/> 


	<cf_templatearea name="title">
		<cfoutput>#LB_ListaDeExportadores#</cfoutput>
	</cf_templatearea>


	<cfif not isdefined('form.Modulo') and isdefined('url.Modulo')>
		<cfset form.Modulo = url.Modulo>
	</cfif>
	<cfif not isdefined('form.Modulo') and not isdefined('url.Modulo')>
		<cfset form.Modulo = 'TODOS'>
	</cfif>
	
	<cf_templatearea name="body">
     <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ListaDeExportadores#">
	 
	  <table width="100%" border="1" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="100%" valign="top">
					<cf_sifimportar  mode="out" Nuevo="true" Modulo = "#form.Modulo#" ListaDeExportacion ="true" >
					</cf_sifimportar>
				</td>
              </tr>
		</table>
		<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>


