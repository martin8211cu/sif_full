<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cfif isdefined("url.PCid") and not isdefined("form.PCid")>
		<cfset form.PCid = url.PCid >
	</cfif>

	<cfif isdefined("url.PPid") and not isdefined("form.PPid")>
		<cfset form.PPid = url.PPid >
	</cfif>
	<cfif isdefined("url.PageNum_lista") and not isdefined("form.pagenum")>
		<cfset form.pagenum = url.PageNum_lista >
	</cfif>

	<cf_web_portlet_start border="true" titulo="Preguntas por Competencia - Cuestionarios" skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">	
		<table width="100%" cellspacing="2" cellpadding="0">
			<tr>
				<td valign="top" width="50%">
						<cfquery name="rsListaPreguntas" datasource="#session.DSN#">
							select 	a.PCid, 
									a.PPid as PPid, 
									<!---'Parte ' || <cf_dbfunction name="to_char" args="PPparte" datasource="sifcontrol"> as PPparte, --->
									{fn concat('Parte ',<cf_dbfunction name="to_char" args="PPparte" datasource="sifcontrol">)} as PPparte,
									a.PPnumero as PPnumero, 
									a.PPpregunta as PPpregunta, 
									a.PPtipo as PPtipo, 
									a.PPvalor as PPvalor,
									case when (select count(1) from RHPreguntasCompetencia b where a.PCid=b.PCid and a.PPid=b.PPid  ) > 0 then '<img src=/cfmx/rh/imagenes/checked.gif>' else '<img src=/cfmx/rh/imagenes/unchecked.gif>' end as imagen
							from PortalPregunta a
							where a.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
							  and a.PPtipo != 'E'
							order by a.PPparte, a.PPnumero, a.PPtipo
						</cfquery>
						
						<cfset navegacion = "&PCid=#form.PCid#" >
						<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
							<cfinvokeargument name="query" 			value="#rsListaPreguntas#">
							<cfinvokeargument name="desplegar" 		value="PPnumero,PPpregunta,imagen">
							<cfinvokeargument name="etiquetas" 		value="Numero,Pregunta">
							<cfinvokeargument name="formatos" 		value="S,S,S">
							<cfinvokeargument name="align" 			value="left,left,center">
							<cfinvokeargument name="ira" 			value="preguntasCompetencia.cfm">
							<cfinvokeargument name="keys" 			value="PPid,PCid">
							<cfinvokeargument name="showEmptyListMsg" value="true">
							<cfinvokeargument name="ajustar"		value="S">
							<cfinvokeargument name="navegacion"		value="#navegacion#">
							<cfinvokeargument name="cortes"			value="PPparte">
						</cfinvoke>	
				</td>
				<td width="50%" valign="top"><cfinclude template="preguntasCompetencia-form.cfm"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>

	<cf_web_portlet_end>
<cf_templatefooter>