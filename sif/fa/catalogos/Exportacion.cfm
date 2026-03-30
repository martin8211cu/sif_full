<cfparam name="LvarPagina" default="Exportacion.cfm">
<cfparam name="LvarSQLPagina" default="SQLExportacion.cfm">

 <cfquery name="rsLista" datasource="#session.DSN#">
	select IdExportacion, 
	CSATcodigo,CSATdescripcion,CONVERT(VARCHAR(10),CSATfechaVigencia,103) AS CSATfechaVigencia,
	case 
	when
	CSATestatus = '0' then 'Inactivo'
	else 'Activo'
	end CSATestatus,
	isnull(CSATdefault,0) as CSATdefault
	from CSATExportacion
</cfquery>

<cf_templateheader title="Exportación">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Exportacion">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="CSATcodigo, CSATdescripcion,CSATfechaVigencia,CSATestatus"/>
							<cfinvokeargument name="etiquetas"        value="C&oacute;digo Exportacion&nbsp;&nbsp;, Nombre Exportacion&nbsp;&nbsp;, Fecha de Vigencia &nbsp;&nbsp;,Estatus&nbsp;&nbsp;"/>
							<cfinvokeargument name="formatos"         value="V, V, V, V"/>
							<cfinvokeargument name="align"            value="left, left, left, left"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="#LvarPagina#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="IdExportacion">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="formExportacion.cfm">
				    </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>