<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	//-->
</script>
<cfinclude template="../../../Utiles/sifConcat.cfm">
<cfif isdefined("url.AnexoId") and not isdefined("form.AnexoId")>
	<cfset form.AnexoId = url.AnexoId>
</cfif>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Permisos'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td valign="top" align="center">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td colspan="3">
					<cfquery name="rsLista" datasource="#session.DSN#">
						select  case when a.Usucodigo is null then a.APnombre
								else c.Pnombre#_Cat#' '#_Cat#Papellido1#_Cat#' '#_Cat#Papellido2  end as usuario,
								a.APDid,3 as tab, #form.AnexoId# as AnexoId
						from AnexoPermisoDef a
							left outer  join Usuario b
								on a.Usucodigo = b.Usucodigo
								and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
								left outer join DatosPersonales c
									on b.datos_personales = c.datos_personales						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
						order by usuario
					</cfquery>

					<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="usuario"/>
						<cfinvokeargument name="etiquetas" value="Usuarios"/>
						<cfinvokeargument name="formatos" value="V"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="anexo.cfm?AnexoId=#form.AnexoId#&tab=3"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<!---<cfinvokeargument name="navegacion" value="#navegacion#"/>---->
						<cfinvokeargument name="keys" value="APDid"/>
					</cfinvoke>							
				</td>
			  </tr>
			</table>
		</td>
		<td width="40%" valign="top">
			<cfinclude template="anexo-permisos-form.cfm">
		</td>
	</tr>
</table>
<cf_web_portlet_end>
