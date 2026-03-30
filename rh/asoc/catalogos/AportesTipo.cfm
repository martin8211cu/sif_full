<!--- ReporteAusentismo.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<!--- Variables de Traducción --->
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_nav__SPdescripcion" 
	Default="#nav__SPdescripcion#" 
	returnvariable="LB_nav__SPdescripcion"/>
	
<!--- Pintado de la Pantalla de Filtros --->
<cf_templateheader title="#LB_nav__SPdescripcion#">

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
	<cfif isdefined("Url.ACATid") and not isdefined("Form.ACATid")>
		<cfparam name="Form.ACATid" default="#Url.ACATid#">
		<cfset form.modo = 'CAMBIO'>
	</cfif>
		
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfinclude template="AportesTipo-etiquetas.cfm">
		<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top" width="40%">		
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="ACAportesTipo"/>
						<cfinvokeargument name="columnas" value="ACATid, ACATcodigo, ACATdescripcion "/>
						<cfinvokeargument name="desplegar" value="ACATcodigo, ACATdescripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="keys" value="ACATid"/>
						<cfinvokeargument name="irA" value="AportesTipo.cfm"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
					</cfinvoke>
				</td>
				<td valign="top" width="60%" align="center">	
					<cfinclude template="AportesTipo-form.cfm">
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
