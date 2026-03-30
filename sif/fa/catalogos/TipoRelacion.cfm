<cfparam name="LvarPagina" default="TipoRelacion.cfm">
<cfparam name="LvarSQLPagina" default="SQLTipoRelacion.cfm">

 <cfquery name="rsLista" datasource="#session.DSN#">
	select empId, 
	CSATcodigo,CSATdescripcion,CSATDefault
	from CSATTipoRel
</cfquery>

<cf_templateheader title="Tipo de Relacion">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Tipo de Relacion">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="CSATcodigo, CSATdescripcion,CSATDefault"/>
							<cfinvokeargument name="etiquetas"        value="C&oacute;digo Relacion&nbsp;&nbsp;, Nombre Relacion&nbsp;&nbsp;, C&oacute;digo Default&nbsp;"/>
							<cfinvokeargument name="formatos"         value="V, V, V"/>
							<cfinvokeargument name="align"            value="center, center ,left"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="#LvarPagina#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="empId">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="formTipoRelacion.cfm">
				    </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>