<cf_templateheader title="Punto de Venta - Monedas de Facturación">
<cf_templatecss>
	
<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Monedas de Facturación">
<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
				<cfquery name="lista" datasource="#session.DSN#">
				
					Select a.FAP02CON, a.Mcodigo, a.FAP02FAC, a.FAP02COB, b.Mnombre, b.Miso4217
					from FAP002 a
					
					inner join Monedas b
					on b.Mcodigo=a.Mcodigo
					and b.Ecodigo=a.Ecodigo
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					order by b.Mnombre
					
				</cfquery>
				
				<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#lista#"/>
						<cfinvokeargument name="etiquetas" value=" C&oacute;digo, Moneda"/>
						<cfinvokeargument name="desplegar" value=" Miso4217,Mnombre"/>
						<cfinvokeargument name="formatos" value="V,V"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="monedas_facturacion.cfm"/>
						<cfinvokeargument name="keys" value="FAP02CON"/>
						<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
			</td>
		<td width="50%" valign="top"><cfinclude template="monedas_facturacion-form.cfm"></td>
	</tr>		
</table>
<cf_web_portlet_end>
<cf_templatefooter>
