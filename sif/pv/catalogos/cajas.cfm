<cf_templateheader title="Punto de Venta - Cajas">
<cf_templatecss>
	
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Cajas">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					<cfquery name="lista" datasource="#session.DSN#">
						select Ocodigo, FAM01COD, FAM01CODD, FAM09MAQ, 
						FAM01DES, FAM01RES, FAM01TIP, FAM01COB,FAM01STS,FAM01STP,Ccuenta, I02MOD, CCTcodigoAP,
						CCTcodigoDE, CCTcodigoFC, CCTcodigoCR, CCTcodigoRC, CCTcodigoRC, FAM01NPR, FAM01NPA,
						Aid, Mcodigo, FAM01TIF, FAPDES
						from FAM001
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by FAM01CODD
					</cfquery>
					
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value=" FAM01CODD,FAM01DES"/>
							<cfinvokeargument name="etiquetas" value=" C&oacute;digo, Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value="V, V"/>
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="cajas.cfm"/>
							<cfinvokeargument name="keys" value="FAM01COD"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="cajas-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
