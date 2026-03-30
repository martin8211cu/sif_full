<cfparam name="modo" default="ALTA"></cfparam>
<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo=#url.modo#>
</cfif>
<cfif modo neq 'ALTA' and isdefined('url.ID_PPreciov') and len(trim('url.ID_PPreciov'))>
	<cfset form.ID_PPreciov=url.ID_PPreciov>
</cfif>
<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Catalogo de Plantillas de Vi&aacute;ticos">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cfquery name="rsSelectPlantillas" datasource="#session.dsn#">
						select gep.GEPVid, gep.GECVid, gep.GECid, gep.Mcodigo, gep.GEPVcodigo, gep.GEPVdescripcion,
							   gec.GECVid, gec.GECVcodigo, gec.GECVdescripcion,
							   ge.GECid, ge.GECconcepto,ge.GECdescripcion
							   
							from GEPlantillaViaticos gep 
								inner join GEClasificacionViaticos gec 
									on gep.GECVid = gec.GECVid 
								inner join GEconceptoGasto ge
									on ge.GECid=gep.GECid
								where 0 != 1
								and gec.Ecodigo=#session.Ecodigo#
								
						<cfif isdefined('form.filtro_GEPVcodigo') and len(trim(form.filtro_GEPVcodigo))>
							and rtrim(upper(GEPVcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_GEPVcodigo))#%">
						</cfif>
						<cfif isdefined('form.filtro_GEPVdescripcion')and len(trim(form.filtro_GEPVdescripcion))>
							and rtrim(upper(GEPVdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_GEPVdescripcion))#%">
						</cfif>	
						<cfif isdefined('form.filtro_GECVdescripcion')and len(trim(form.filtro_GECVdescripcion))>
							and rtrim(upper(GECVdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_GECVdescripcion))#%">
						</cfif>	
						<cfif isdefined('form.filtro_GECdescripcion')and len(trim(form.filtro_GECdescripcion))>
							and rtrim(upper(GECdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_GECdescripcion))#%">
						</cfif>	
							order by gep.GEPVcodigo
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsSelectPlantillas#" 
						conexion="#session.dsn#"
						desplegar="GEPVcodigo,GEPVdescripcion,GECVdescripcion,GECdescripcion"
						etiquetas="Cod,Descripción,Viático,Concepto Gasto"
						formatos="S,S,S,S"
						mostrar_filtro="true"
						align="left,left,left,left"
						ajustar="N,S,S,N"
						checkboxes="N"
						ira="catalogoPlantillaViaticos.cfm"
						keys="GEPVid">
					</cfinvoke>
				</td>
				<td width="30%" valign="top">
					<cfinclude template="catalogoPlantillaViaticos-Form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>