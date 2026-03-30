<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 12-8-2005.
		Motivo: Nuevo mantenimiento de la tabla: TPTipoDocumento.
 --->

<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Mantenimiento Tipo de Documentos
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento Tipo de Documentos'>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="40%">
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select 
					id_tipodoc, 
					codigo_tipodoc as codigo, 
					nombre_tipodoc as nombre
				from TPTipoDocumento
				order by codigo_tipodoc
			</cfquery>

			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo, nombre"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Nombre"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="TipoDocumento.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_tipodoc"/>
			</cfinvoke>
		</td>
		<td valign="top">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td valign="top"><cfinclude template="TipoDocumento_form.cfm"></td>
	</tr>
	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr> 
	</table>
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>