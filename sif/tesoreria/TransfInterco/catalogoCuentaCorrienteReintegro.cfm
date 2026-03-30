<cfparam name="modo" default="ALTA"></cfparam>
<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo=#url.modo#>
</cfif>
<cfif modo neq 'ALTA' and isdefined('url.CBid') and len(trim('url.CBid'))>
	<cfset form.CBid=url.CBid>
</cfif>
<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Catalogo de Cuenta Corriente Reintegro">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100%" valign="top">
					<cfquery name="rsSelectCuentas" datasource="#session.dsn#">
						select cb.CBid, m.Mcodigo, m.Mnombre, b.Bid,TESRCBmontoMax,TESRCBmontoMin,b.Bdescripcion,cb.CBdescripcion, ''as blanco
							from TESreintegroCB a  
							inner join CuentasBancos cb
								on cb.CBid = a.CBid
								and cb.Ecodigo = a.Ecodigo
							inner join Bancos b
								on cb.Bid = b.Bid 
								and cb.Ecodigo = b.Ecodigo
							inner join Monedas m 
								on m.Mcodigo = cb.Mcodigo	
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								
						<cfif isdefined('form.filtro_Bdescripcion') and len(trim(form.filtro_Bdescripcion))>
							and rtrim(upper(Bdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_Bdescripcion))#%">
						</cfif>
						<cfif isdefined('form.filtro_CBdescripcion')and len(trim(form.filtro_CBdescripcion))>
							and rtrim(upper(CBdescripcion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_CBdescripcion))#%">
						</cfif>	
						<cfif isdefined('form.filtro_TESRCBmontoMax')and len(trim(form.filtro_TESRCBmontoMax))>
							and rtrim(upper(TESRCBmontoMax)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_TESRCBmontoMax))#%">
						</cfif>	
						<cfif isdefined('form.TESRCBmontoMin')and len(trim(form.filtro_TESRCBmontoMin))>
							and rtrim(upper(TESRCBmontoMin)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_TESRCBmontoMin))#%">
						</cfif>	
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsSelectCuentas#" 
						conexion="#session.dsn#"
						desplegar="Bdescripcion,CBdescripcion,TESRCBmontoMax,TESRCBmontoMin,blanco"
						etiquetas="Banco,Cuenta Bancaria,Monto Max,Monto Min,"
						formatos="S,S,M,M,U"
						mostrar_filtro="true"
						align="left,left,right,right,right"
						ajustar="N,N,S,N,N"
						checkboxes="N"
						ira="catalogoCuentaCorrienteReintegro.cfm"
						keys="CBid">
					</cfinvoke>
			  </td>
				<td  valign="top">
					<cfinclude template="catalogoCuentaCorrienteReintegro-Form.cfm">
			  </td>
			</tr>
</table>
	<cf_web_portlet_end>
<cf_templatefooter>