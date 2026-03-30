<cf_templateheader title="Compras - Tipo de Transacciones">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipo de Transacciones'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="2">
						<cfinclude template="../../portlets/pNavegacionCM.cfm">
					</td>
				</tr>

				<tr> 
					<td valign="top"> 
						<cfquery name="rsLista" datasource="#session.DSN#">
							select CPcodigo, CPdescripcion
							from TTransaccionI
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by CPcodigo
						</cfquery>

						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="CPcodigo,CPdescripcion"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value="V, V"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="TipoTransaccion.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CPcodigo"/>
						</cfinvoke>
					</td>
					<td width="55%">
						<cfinclude template="TipoTransaccion-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>