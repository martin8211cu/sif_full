<cf_templateheader title="Punto de Venta - M&aacute;quinas por Impresoras">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Maquinas por Impresoras">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
				<cfquery name="lista" datasource="#session.DSN#">
					select a.FAM09MAQ, b.FAM09DES, a.FAM12COD, c.FAM12CODD, c.FAM12DES, a.CCTcodigo
					from FAM014 as a
				
					inner join FAM009 as b 
					on b.FAM09MAQ = a.FAM09MAQ 
					and b.Ecodigo = a.Ecodigo
						
					inner join FAM012 as c
					on c.FAM12COD = a.FAM12COD
					and c.Ecodigo = a.Ecodigo
												
					inner join FAM014 as d
					on d.FAM09MAQ = a.FAM09MAQ
					and d.CCTcodigo = a.CCTcodigo
										
												
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					order by a.FAM09MAQ, a.FAM12COD, a.CCTcodigo
				</cfquery>
					
				<cfinvoke 
				  component="sif.Componentes.pListas"
				  method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#lista#"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Maquina, C&oacute;digo, Impresora, Codigo"/>
				<cfinvokeargument name="desplegar" value="FAM09MAQ, FAM09DES, FAM12CODD, FAM12DES, CCTcodigo"/>
				<cfinvokeargument name="formatos" value="V, V, V, V, V"/>
				<cfinvokeargument name="align" value="left, left, left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="maq_imp.cfm"/>
				<cfinvokeargument name="keys" value="FAM09MAQ, CCTcodigo"/>
				<cfinvokeargument name="showemptylistmsg" value="true"/>
			</cfinvoke>
			</td>
			<td width="50%" valign="top"><cfinclude template="maq_imp-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
