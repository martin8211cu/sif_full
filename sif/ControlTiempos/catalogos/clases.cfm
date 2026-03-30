<cf_template>
	<cf_templatearea name="title">
		Clases de Actividad
	</cf_templatearea>
	<cf_templatearea name="body">
		<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>
		<cf_web_portlet titulo="Clases de Actividad">
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" width="50%"> 
					<cfquery name="rsLista" datasource="#session.DSN#">
						select CTCAcodigo, CTCAdescripcion
						from CTClaseActividad
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						order by CTCAorden, CTCAdescripcion
					</cfquery>

					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="CTCAdescripcion"/>
						<cfinvokeargument name="etiquetas" value="Descripción"/>
						<cfinvokeargument name="formatos" value="S"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="clases.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="yes"/>
					</cfinvoke>
				</td>
				<td valign="top" width="50%">
					<cfinclude template="clases-form.cfm">
				</td>
			  </tr>
			</table><br>
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>