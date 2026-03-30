<cf_templateheader title="Cuentas Bancarias por Moneda">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Tipo de Cuentas Bancarias por Moneda">
			<cfparam name="LvarPagina" default="CuentaPorMoneda.cfm">
			<cfparam name="LvarSQLPagina" default="CuentaPorMoneda_SQL.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  	<td valign="top" width="30%">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 		value="CuentasPorMoneda a inner join Bancos b on a.Bid = b.Bid and a.Ecodigo = b.Ecodigo
                        											inner join CuentasBancos c on a.CBid = c.CBid and a.Ecodigo = c.Ecodigo
                                                                    inner join Monedas d on a.Mcodigo = d.Mcodigo and a.Ecodigo = d.Ecodigo
                                                                    inner join BTransacciones bt on bt.BTid = a.BTid"/>
						<cfinvokeargument name="columnas" 	value="a.Bid, a.CBid ,a.Mcodigo,a.BTid,CBPMid, CBdescripcion, Bdescripcion, Mnombre,CBcodigo,BTdescripcion"/>
						<cfinvokeargument name="desplegar" 	value="Bdescripcion,CBcodigo,Mnombre,BTdescripcion"/>
						<cfinvokeargument name="etiquetas" 	value="Banco,Cuenta,Moneda,Tipo transacc"/>
						<cfinvokeargument name="formatos" 	value="S,S,S,S"/>
						<cfinvokeargument name="filtro" 	value="a.Ecodigo = #Session.Ecodigo#"/>
						<cfinvokeargument name="align" 		value="left,left,left,left"/>
						<cfinvokeargument name="ajustar" 	value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" 		value="#LvarPagina#"/>
					</cfinvoke>
				</td>
				<td >
					<cfinclude template="CuentaPorMoneda_form.cfm">
				</td>
			  </tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>