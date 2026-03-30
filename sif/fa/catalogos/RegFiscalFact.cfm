 <cfquery name="rsLista" datasource="#session.DSN#">
	 select id_RegFiscal,codigo_RegFiscal, Ecodigo,nombre_RegFiscal
	 from FARegFiscal
     where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cf_templateheader title="Tipo de Pago de Factura">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo R&eacute;gimen Fiscal">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="30%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="codigo_RegFiscal, nombre_RegFiscal"/>
							<cfinvokeargument name="etiquetas"        value="C&oacute;digo, Nombre Reg.Fiscal"/>
							<cfinvokeargument name="formatos"         value="V, V"/>
							<cfinvokeargument name="align"            value="left, left"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="RegFiscalFact.cfm "/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="id_RegFiscal">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="formRegFiscalFac.cfm">
				    </td>
				</tr>
			</table>             	
		<cf_web_portlet_end>
<cf_templatefooter>  