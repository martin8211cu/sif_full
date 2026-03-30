<cf_templateheader title="Cajas">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Cajas">
		<cfparam name="LvarPagina" default="Cajas.cfm">
		<cfparam name="LvarSQLPagina" default="SQLCajas.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			 	<tr>
			  		<td valign="top" width="40%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" 		value="FCajas"/>
							<cfinvokeargument name="columnas" 	value="convert(varchar,FCid) as FCid,FCcodigo,case isnull(substring(FCdesc,30,1),'') when '' then FCdesc else substring(FCdesc,1,26) + '...' end FCdesc"/>
							<cfinvokeargument name="desplegar" 	value="FCcodigo,FCdesc"/>
							<cfinvokeargument name="etiquetas" 	value="Código,Descripción"/>
							<cfinvokeargument name="formatos" 	value="S,S"/>
							<cfinvokeargument name="filtro" 	value="Ecodigo = #Session.Ecodigo# order by FCcodigo, FCdesc"/>
							<cfinvokeargument name="align" 		value="left,left"/>
							<cfinvokeargument name="ajustar" 	value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" 		value="FCid"/>
							<cfinvokeargument name="irA" 		value="#LvarPagina#"/>
                          	<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="filtrar_por" value="FCcodigo,FCdesc"/>
						</cfinvoke>
					</td>
					<td>
						<cfinclude template="formCajas.cfm">
					</td>
			 	</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>