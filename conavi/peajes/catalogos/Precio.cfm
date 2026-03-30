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
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Catalogo de Precios por Peaje por Vehiculo">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cfquery name="rsSelectPrecios" datasource="#session.dsn#">
						select pp.ID_PPreciov, pp.Mcodigo, pp.PPrecio, p.Pid, p.Pcodigo, pv.PVid, pv.PVcodigo
						from PPrecio pp inner join Peaje p 
						on pp.Pid = p.Pid 
						inner join PVehiculos pv
						on pv.PVid=pp.PVid
						where 0 != 1
						and p.Ecodigo=#session.Ecodigo#
						<cfif isdefined('form.filtro_Pcodigo') and len(trim(form.filtro_Pcodigo))>
							and rtrim(upper(Pcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_Pcodigo))#%">
						</cfif>
						<cfif isdefined('form.filtro_PVcodigo') and len(trim(form.filtro_PVcodigo))>
							and rtrim(upper(PVcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_PVcodigo))#%">
						</cfif>
						<cfif isdefined('form.filtros_PPrecio')and len(trim(form.filtros_PPrecio))>
							and pp.PPrecio  = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.filtros_PPrecio,',','','ALL')#00">
						</cfif>	
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsSelectPrecios#" 
						conexion="#session.dsn#"
						desplegar="Pcodigo,PVcodigo,PPrecio"
						etiquetas="Código Peaje,Codigo Vehiculo,Precio"
						formatos="S,S,M"
						mostrar_filtro="true"
						align="left,left,left"
						checkboxes="N"
						ira="Precio.cfm"
						keys="ID_PPreciov">
					</cfinvoke>
				</td>
				<td width="50%" valign="top">
					<cfinclude template="Precio-Form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>