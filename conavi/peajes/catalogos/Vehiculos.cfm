<cfparam name="modo" default="ALTA"></cfparam>
<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo=#url.modo#>
</cfif>
<cfif modo neq 'ALTA' and isdefined('url.PVid') and len(trim('url.PVid'))>
	<cfset form.PVid=url.PVid>
</cfif>
<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Catalogo de Vehículos">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cfquery name="rsSelectVehiculos" datasource="#session.dsn#">
						select  PVid,PVcodigo,PVdescripcion,PVoficial, 
						case 
                        when 
                             PVoficial = '1'  
                        then 
                        	'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
                        else
                            '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
                        end as encargadoIco
						from PVehiculos
						where 0 != 1
						and Ecodigo=#session.Ecodigo#
						<cfif isdefined('form.filtro_PVcodigo') and len(trim(form.filtro_PVcodigo))>
							and rtrim(upper(PVcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_PVcodigo))#%">
						</cfif>
						<cfif isdefined('form.filtro_PVdescripcion') and len(trim(form.filtro_PVdescripcion))>
							and rtrim(upper(PVdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_PVdescripcion))#%">
						</cfif>
						<cfif isdefined('form.filtro_encargadoIco') and len(trim(form.filtro_encargadoIco)) and form.filtro_encargadoIco NEQ -1>
							and rtrim(upper(PVoficial)) like <cfqueryparam cfsqltype="cf_sql_char" value="%#rtrim(Ucase(form.filtro_encargadoIco))#%">
						</cfif>
					</cfquery>
					
					<cfquery name="rscombo" datasource="#session.DSN#">
                        select -1 value, 'todos' description from dual
						union
					    select 0 value, 'No Oficial' description from dual
						union
						select 1 value, 'Oficial' description from dual
						order by 1
					 </cfquery>
					
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsSelectVehiculos#" 
						conexion="#session.dsn#"
						desplegar="PVcodigo, PVdescripcion,encargadoIco"
						etiquetas="Código, Descripción, Oficial"
						formatos="S,S,I"
						mostrar_filtro="true"
						align="left,left,left"
						checkboxes="N"
						ira="Vehiculos.cfm"
						keys="PVid"
						rsencargadoIco="#rscombo#">
					</cfinvoke>
				</td>
				<td width="50%" valign="top">
					<cfinclude template="Vehiculos-Form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>