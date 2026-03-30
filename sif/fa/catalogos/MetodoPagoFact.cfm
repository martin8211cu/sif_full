 <cfquery name="rsLista" datasource="#session.DSN#">
	 select MPid,CSATcodigo,CSATdescripcion
	 from CSATMetPago
</cfquery>
<cf_templateheader title="Método de Pago de Factura">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo Meotodo de Pago de Factura">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="30%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="CSATcodigo, CSATdescripcion"/>
							<cfinvokeargument name="etiquetas"        value="C&oacute;digo, Descripción Método Pago"/>
							<cfinvokeargument name="formatos"         value="V, V"/>
							<cfinvokeargument name="align"            value="left, left"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="MetodoPagoFact.cfm "/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="MPid">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="formMetodoPagoFac.cfm">
				    </td>
				</tr>
			</table>             	
		<cf_web_portlet_end>
<cf_templatefooter>  