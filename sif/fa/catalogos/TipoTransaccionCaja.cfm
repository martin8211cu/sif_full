<cf_templateheader title="Tipos de Transacción por Caja">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Configuraci&oacute; de Cajas">
			<cfparam name="LvarPagina" default="TipoTransaccionCaja.cfm">
			<cfparam name="LvarSQLPagina" default="SQLTiposTransacciones.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="55%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" 		value="TipoTransaccionCaja as a
																		inner join FCajas as b on a.Ecodigo=#session.Ecodigo# and a.FCid=b.FCid and a.Ecodigo=b.Ecodigo
																		inner join CCTransacciones as c on a.CCTcodigo=c.CCTcodigo and a.Ecodigo=c.Ecodigo
																		left join FMT001 d on a.FMT01COD=d.FMT01COD and a.Ecodigo=d.Ecodigo "/>
							<cfinvokeargument name="columnas" 	value="b.FCcodigo, rtrim(b.FCcodigo)+', '+ rtrim(b.FCdesc) as Caja, b.FCdesc, case isnull(substring(c.CCTdescripcion,30,1),'') when '' then c.CCTdescripcion else substring(c.CCTdescripcion,1,26) + '...' end as CCTdescripcion, convert(varchar,a.FCid) as FCid, convert(varchar,a.CCTcodigo) as CCTcodigo, isnull(d.FMT01DES, '-') as Formato"/>
							<cfinvokeargument name="desplegar" 	value="FCdesc,CCTdescripcion"/>
							<cfinvokeargument name="etiquetas" 	value="Caja,Transacción"/>
							<cfinvokeargument name="formatos" 	value="S,S"/>
							<cfinvokeargument name="filtro" 	value=" a.Ecodigo = #Session.Ecodigo# order by b.FCcodigo, FCdesc"/>
							<cfinvokeargument name="align" 		value="left,left"/>
							<cfinvokeargument name="ajustar" 	value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="Cortes" 	value="Caja"/>
                            <cfinvokeargument name="mostrar_filtro"         value="true"/>
							<cfinvokeargument name="filtrar_automatico" 	value="true"/>
                            <cfinvokeargument name="filtrar_por" 	value="FCdesc,CCTdescripcion"/>
                            <cfinvokeargument name="incluyeForm" 	value="true"/>
							<cfinvokeargument name="irA" 		    value="#LvarPagina#"/>
						</cfinvoke>
					</td>
					<td valign="top" width="45%">
						<cfinclude template="formTipoTransaccionCaja.cfm">
					</td>
			  	</tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>