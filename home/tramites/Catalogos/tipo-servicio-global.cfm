<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales 
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>



<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Servicio Global'>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td colspan="2" valign="top">
			<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="50%">
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select codigo_tiposervg, nombre_tiposervg,id_tiposervg 
				from TPTipoServGlobal
				order by codigo_tiposervg
			</cfquery>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_tiposervg, nombre_tiposervg"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="tipo-servicio-global.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_tiposervg"/>
			</cfinvoke>
		</td>
		<td valign="top"><cfinclude template="tipo-servicio-global-form.cfm"></td>
	</tr>
	<tr> 
		<td colspan="2">&nbsp;</td>
		
	</tr> 
	</table>
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>
