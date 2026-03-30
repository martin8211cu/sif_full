<cf_template>
	<cf_templatearea name="title">
		Catálogo de Proyectos
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Catálogo de Proyectos">
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" width="50%">
                	<cfinclude template="../../Utiles/sifConcat.cfm"> 
					<cfquery name="rsLista" datasource="#session.DSN#">
						select CTPcodigo, CTPdescripcion, SNnumero, SNnombre, SNnumero#_Cat#'-'#_Cat#SNnombre as socio
						from CTProyectos a

						inner join SNegocios b
						on a.Ecodigo=b.Ecodigo
						 and a.SNcodigo=b.SNcodigo

						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						order by SNnumero, CTPdescripcion
					</cfquery>
					

                  <cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="CTPdescripcion"/>
						<cfinvokeargument name="etiquetas" value="Descripción"/>
						<cfinvokeargument name="formatos" value="S"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="Proyectos.cfm"/>
						<cfinvokeargument name="cortes" value="socio"/>
					</cfinvoke>
				</td>
				<td valign="top" width="50%">
					<cfinclude template="formProyectos.cfm">
				</td>
			  </tr>
			</table><br>
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>