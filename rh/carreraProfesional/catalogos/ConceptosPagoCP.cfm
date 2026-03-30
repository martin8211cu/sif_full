<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinclude template="ConceptosPagoCP-etiquetas.cfm">

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
						<cfinvokeargument name="tabla" 				value="CIncidentes"/>
						<cfinvokeargument name="columnas" 			value="CIid, CIcodigo, substring(CIdescripcion,1,39) as CIdescripcion, 
																			case when CItipo = 2  then '#LB_Importe#' else '#LB_Calculo#' end as Tipo"/>
						<cfinvokeargument name="desplegar" 			value="CIcodigo, CIdescripcion, Tipo"/>
						<cfinvokeargument name="etiquetas" 			value="#LB_Codigo#,#LB_Descripcion#,#LB_Metodo#"/>
						<cfinvokeargument name="formatos" 			value="S,S,S"/>
						<cfinvokeargument name="filtro" 			value="Ecodigo = #Session.Ecodigo# and CIcarreracp = 1"/>
						<cfinvokeargument name="align" 				value="left, left, left"/>
						<cfinvokeargument name="ajustar" 			value="N"/>
						<cfinvokeargument name="checkboxes" 		value="N"/>
						<cfinvokeargument name="keys" 				value="CIid"/>
						<cfinvokeargument name="irA" 				value="ConceptosPagoCP.cfm"/>
						<cfinvokeargument name="mostrar_filtro" 	value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="EmptyListMsg" 		value="true"/>
					</cfinvoke>
			  	</td>
				<td width="50%" valign="top" align="center">	
					<cfinclude template="ConceptosPagoCP-form.cfm">
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
