<cfparam name="LvarPagina" default="ObjetoImpuesto.cfm">
<cfparam name="LvarSQLPagina" default="SQLObjetoImpuesto.cfm">

 <cfquery name="rsLista" datasource="#session.DSN#">
	select IdObjImp, 
	CSATcodigo,CSATdescripcion,CONVERT(VARCHAR(10),CSATfechaVigencia,103) AS CSATfechaVigencia,
	case 
	when
	CSATestatus = '0' then 'Inactivo'
	else 'Activo'
	end CSATestatus
	from CSATObjImpuesto
</cfquery>

<cf_templateheader title="Objetos de Impuesto">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Objetos de Impuestos">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="CSATcodigo, CSATdescripcion,CSATfechaVigencia,CSATestatus"/>
							<cfinvokeargument name="etiquetas"        value="C&oacute;digo Impuesto&nbsp;&nbsp;, Nombre Impuesto&nbsp;&nbsp;, Fecha de Vigencia &nbsp;&nbsp;,Estatus"/>
							<cfinvokeargument name="formatos"         value="V, V, V, V"/>
							<cfinvokeargument name="align"            value="center, left, center, center"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="#LvarPagina#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="IdObjImp">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="formObjetoImpuesto.cfm">
				    </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>