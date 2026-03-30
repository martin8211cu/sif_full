<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinclude template="ConceptosCarreraP-etiquetas.cfm">

<!--- Pintado de la Pantalla de Filtros --->
<cf_templateheader title="#LB_nav__SPdescripcion#">

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
	<cfif isdefined("Url.CIid") and not isdefined("Form.CIid")>
		<cfparam name="Form.CIid" default="#Url.CIid#">
		<cfset form.modo = 'CAMBIO'>
	</cfif>
	<cfif isdefined('url.PageNum_lista')><cfset form.Pagina = url.PageNum_lista></cfif>
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<table width="100%" style="vertical-align:top" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="50%" valign="top">		
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 				value="ConceptosCarreraP a
																			inner join TipoConceptoCP b
																				on b.TCCPid = a.TCCPid"/>
						<cfinvokeargument name="columnas" 			value="CCPid,CCPcodigo, CCPdescripcion,a.TCCPid, TCCPdesc, a.CCPprioridad"/>
						<cfinvokeargument name="desplegar" 			value="CCPcodigo, CCPdescripcion, CCPprioridad"/>
						<cfinvokeargument name="etiquetas" 			value="#LB_Codigo#,#LB_Descripcion#,#LB_Prioridad#"/>
						<cfinvokeargument name="formatos" 			value="S,S,I"/>
						<cfinvokeargument name="filtro" 			value="1=1 order by a.TCCPid"/>
						<cfinvokeargument name="align" 				value="left, left, center"/>
						<cfinvokeargument name="ajustar" 			value="N"/>
						<cfinvokeargument name="checkboxes" 		value="N"/>
						<cfinvokeargument name="Cortes"				value="TCCPdesc"/>
						<cfinvokeargument name="keys" 				value="CCPid"/>
						<cfinvokeargument name="irA" 				value="ConceptosCarreraP.cfm"/>
						<cfinvokeargument name="mostrar_filtro" 	value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="EmptyListMsg" 		value="true"/>
					</cfinvoke>
			  	</td>
				<td width="50%" valign="top" align="center">	
					<cfinclude template="ConceptosCarreraP-form.cfm">
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
