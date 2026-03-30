<cf_templateheader title="Tipos de transacciones">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de tipos de transacciones">
			<cfparam name="LvarPagina" default="TiposTransacciones.cfm">
			<cfparam name="LvarSQLPagina" default="SQLTipoTransaccionCaja.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			 	<tr>
			  		<td valign="top" width="30%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" 		value="FAtransacciones a inner join CCTransacciones ct
                                                                          on a.CCTcodigo = ct.CCTcodigo
                                                                          and a.Ecodigo = ct.Ecodigo"/>
							<cfinvokeargument name="columnas" 	value="ct.CCTcodigo, ct.CCTdescripcion, ct.CCTtipo, ct.Ecodigo"/>
							<cfinvokeargument name="desplegar" 	value="CCTcodigo,CCTdescripcion, CCTtipo"/>
							<cfinvokeargument name="etiquetas" 	value="Código,Descripción, Tipo"/>
							<cfinvokeargument name="formatos" 	value="S,S,S"/>
							<cfinvokeargument name="filtro" 	value="a.Ecodigo = #Session.Ecodigo# "/>
							<cfinvokeargument name="align" 		value="left,left, left"/>
							<cfinvokeargument name="ajustar" 	value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" 		value="CCTcodigo, Ecodigo"/>
							<cfinvokeargument name="irA" 		value="#LvarPagina#"/>
                          	<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="filtrar_por" value="CCTcodigo, CCTdescripcion, CCTtipo"/>
						</cfinvoke>
					</td>
					<td>
						<cfinclude template="formTiposTransacciones.cfm">
					</td>
			 	</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>