<cfparam name="LvarPagina" default="ZonaVenta.cfm">
<cfparam name="LvarSQLPagina" default="SQLZonaVenta.cfm">

 <cfquery name="rsLista" datasource="#session.DSN#">
	 select id_zona,codigo_zona, pais,Ecodigo,nombre_zona
	 from ZonaVenta where Ecodigo = #session.Ecodigo#
</cfquery>
<cf_templateheader title="Zonas de Venta">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Zonas de Venta">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="codigo_zona, nombre_zona"/>
							<cfinvokeargument name="etiquetas"        value="C&oacute;digo, Nombre Zona"/>
							<cfinvokeargument name="formatos"         value="V, V"/>
							<cfinvokeargument name="align"            value="left, left"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="#LvarPagina#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="id_zona">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="formZonaVenta.cfm">
				    </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>