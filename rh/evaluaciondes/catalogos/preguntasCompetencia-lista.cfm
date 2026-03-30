<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start border="true" titulo="Preguntas por Competencia - Cuestionarios" skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">	
		<!--- Portal Cuestionario es una vista a sifcontrol --->
		<cfquery name="rsLista" datasource="#session.DSN#">
			select a.PCid, PCnombre
			from RHEvaluacionCuestionarios a
			inner join PortalCuestionario b
			on a.PCid=b.PCid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by PCnombre
		</cfquery>
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
						<cfinvokeargument name="query" 				value="#rsLista#">
						<cfinvokeargument name="desplegar" 			value="PCnombre">
						<cfinvokeargument name="etiquetas" 			value="Nombre">
						<cfinvokeargument name="formatos" 			value="S">
						<cfinvokeargument name="align" 				value="left">
						<cfinvokeargument name="ira" 				value="preguntasCompetencia.cfm">
						<cfinvokeargument name="botones" 			value="Nuevo">
						<cfinvokeargument name="keys" 				value="PCid">
						<cfinvokeargument name="showEmptyListMsg" 	value="true">
					</cfinvoke>	
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>