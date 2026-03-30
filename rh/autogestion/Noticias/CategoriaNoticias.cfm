<!--- VARIBLES DE TRADUCCION --->
<cfinvoke Key="LB_CategoriasDeNoticias" Default="Categor&iacute;as de Noticias" returnvariable="LB_CategoriasDeNoticias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CODIGOCAT" Default="C&oacute;digo Categor&iacute;a" returnvariable="LB_CODIGOCAT" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIBLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cf_web_portlet_start border="true" titulo="#LB_CategoriasDeNoticias#" skin="#Session.Preferences.Skin#">
			<cfset regresar = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>
			<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
				<td valign="top" width="45%">
					<cfquery name="rsLista" datasource="#session.DSN#">
						select a.IdCategoria, a.CodCategoria, a.DescCategoria
						from CategoriaNoticias a							
						order by a.CodCategoria
					</cfquery>
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="CodCategoria,DescCategoria"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGOCAT#,#LB_DESCRIPCION#"/>
						<cfinvokeargument name="formatos" value="V,V"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value=""/>
						<cfinvokeargument name="keys" value="IdCategoria"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<!----<cfinvokeargument name="navegacion" value="#navegacion#"/>---->
					</cfinvoke>
				</td>				
				<td valign="top" width="55%" align="center"><cfinclude template="formCategoriaNoticias.cfm"></td>
			  </tr>
			</table>		        
	<cf_web_portlet_end>
<cf_templatefooter>