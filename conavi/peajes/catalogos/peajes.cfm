<!---<cfdump var="#form#">--->
<cfparam name="modo" default="ALTA"></cfparam>
<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo=#url.modo#>
</cfif>
<cfif modo neq 'ALTA' and isdefined('url.Pid') and len(trim('url.Pid'))>
	<cfset form.Pid=url.Pid>
</cfif>
<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Catalogo de peajes" skin="#Session.Preferences.Skin#">
<table width="100%" border="1" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cf_dbfunction name="OP_CONCAT"returnvariable="_Cat">
					<cfquery name="rsSelectPeajes" datasource="#session.dsn#">
						select  p.Pid, rtrim(cf.CFcodigo) #_Cat# '-' #_Cat# rtrim(cf.CFdescripcion) as CentroFuncional, p.Pcodigo, p.Pdescripcion 
						from Peaje p 
						inner join CFuncional cf on cf.CFid=p.CFid and cf.Ecodigo = #session.Ecodigo#
						<cfif isdefined('form.filtro_CentroFuncional') and len(trim(form.filtro_CentroFuncional))  and form.filtro_CentroFuncional neq -1>
							and (lower(cf.CFcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_CentroFuncional)#%"> or 
								lower(cf.CFdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_CentroFuncional)#%">	
								)
						</cfif>
						where p.Ecodigo = #session.Ecodigo#
						<cfif isdefined('form.filtro_Pcodigo') and len(trim(form.filtro_Pcodigo))>
						and lower(p.Pcodigo) like <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_Pcodigo)#%">
						</cfif>
						<cfif isdefined('form.filtro_Pdescripcion') and len(trim(form.filtro_Pdescripcion))>
						and lower(p.Pdescripcion) like <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_Pdescripcion)#%">
						</cfif>
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsSelectPeajes#" 
						conexion="#session.dsn#"
						desplegar="Pcodigo, Pdescripcion, CentroFuncional"
						etiquetas="Código del Peaje , Descripción, Centro Funcional"
						formatos="S,S,S"
						mostrar_filtro="true"
						align="left,left,left"
						checkboxes="N"
						ira="peajes.cfm"
						keys="Pid">
					</cfinvoke>
				</td>
				<td width="50%" valign="top">
					<cfinclude template="peajes_form.cfm">
				</td>
			</tr>
		</table>
<cf_web_portlet_end>
<cf_templatefooter>