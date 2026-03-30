<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Punto de Venta - Vendedores
	</cf_templatearea>
	
	<cf_templatecss>
	<cf_templatearea name="body">
	
		<cf_web_portlet border="true" skin="#session.preferences.skin#" titulo="Cajas">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					<cfquery name="lista" datasource="#session.DSN#">
						Select FAM21CED,FAM21NOM,CFdescripcion, FAM21PCO
						from FAM021 A, CFuncional B
						where A.CFid = B.CFid						
						  and A.Ecodigo = B.Ecodigo
						  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by A.FAM21NOM
					</cfquery>
					
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value=" FAM21CED,FAM21NOM,CFdescripcion, FAM21PCO"/>
							<cfinvokeargument name="etiquetas" value=" Identificacion, Nombre, Descripcion, (%)Comision"/>
							<cfinvokeargument name="formatos" value="V, V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="vendedores.cfm"/>
							<cfinvokeargument name="keys" value="FAX04CVD"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="vendedores-form.cfm"></td>
			</tr>		
		</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>