<cfinvoke component="sif.Componentes.Translate"	Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos"method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate"	Default="Parametrizaci&oacute;n de Areas de Indicadores" returnvariable="LB_Parametros" method="Translate" Key="LB_ParametrizacionDeAreasDeIndicadores"/>		
<cfinvoke component="sif.Componentes.Translate"	Key="LB_CODIGO" Default="Codigo" returnvariable="LB_CODIGO" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" Key="LB_DESCRIPCION" Default="Descripcion" returnvariable="LB_DESCRIPCION" XmlFile="/rh/generales.xml" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" Key="BTN_Filtrar" Default="Filtrar" returnvariable="BTN_Filtrar" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" XmlFile="/rh/generales.xml" method="Translate"/>
	<cf_templateheader title="#LB_RecursosHumanos#">		
		<cfif isdefined("url.AreaEid") and len(trim(url.AreaEid))>
			<cfset form.AreaEid = url.AreaEid>
		</cfif>		
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfif isdefined("form.FILTRO_CODAREA") and len(trim(form.FILTRO_CODAREA))>
			<cfset filtro = filtro & " and CodArea = #form.FILTRO_CODAREA# " >
			<cfset navegacion = navegacion & "&FILTRO_CODAREA=#form.FILTRO_CODAREA#" >
		</cfif>
		<cfif isdefined("form.FILTRO_DESCAREA") and len(trim(form.FILTRO_DESCAREA)) gt 0 >
			<cfset filtro = filtro & " and upper(DescArea) like '%#ucase(form.FILTRO_DESCAREA)#%' " >
			<cfset navegacion = navegacion & "&FILTRO_DESCAREA=#form.FILTRO_DESCAREA#" >
		</cfif>
	  	<cf_web_portlet_start titulo="#LB_Parametros#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">              
			  <tr> 
                <td width="50%" valign="top">
					<cfquery name="rs_lista" datasource="#session.DSN#">
						select AreaEid, CodArea, DescArea
						from AreaIndEncabezado a 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							#preservesinglequotes(filtro)#
					</cfquery>
					<cfinvoke component="rh.Componentes.pListas" method="pListaquery" returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rs_lista#"/>
						<cfinvokeargument name="desplegar" value="CodArea, DescArea"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
						<cfinvokeargument name="formatos" value="V, V"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="areasindicador.cfm"/>
						<cfinvokeargument name="keys" value="AreaEid"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="CodArea, DescArea"/>
					</cfinvoke>					
				</td>
                <td width="1%" valign="top">&nbsp;</td>
                <td width="58%" valign="top"><cfinclude template="areasindicador-form.cfm"></td>
              </tr>
			 </table>
	  <cf_web_portlet_end>
<cf_templatefooter>
