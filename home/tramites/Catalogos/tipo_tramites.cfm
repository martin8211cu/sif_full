<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Tipos de Tr&aacute;mite
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipos de Tr&aacute;mite">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
			<tr><td>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td width="50%" valign="top">
							<cfquery name="rsLista" datasource="#session.tramites.dsn#">
								select id_tipotramite, codigo_tipotramite, nombre_tipotramite 
								from TPTipoTramite
								order by 2, 3
							</cfquery>
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="codigo_tipotramite, nombre_tipotramite"/>
								<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
								<cfinvokeargument name="formatos" value="V,V"/>
								<cfinvokeargument name="align" value="left,left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="irA" value="tipo_tramites.cfm"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="keys" value="id_tipotramite"/>
							</cfinvoke>

						</td>
						<td width="50%" valign="top"><cfinclude template="tipo_tramites-form.cfm">
						</td>
					</tr>
				</table>
			</td></tr>
		</table>
	<cf_web_portlet_end>
</cf_templatearea>
</cf_template>