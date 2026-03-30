	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DatosVariables"
	Default="Datos Variables"
	returnvariable="LB_DatosVariables"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Tipo"
		Default="Tipo"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Tipo"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Normal"
		Default="Normal"
		returnvariable="LB_Normal"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Poliza"
		Default="P&oacute;liza"
		returnvariable="LB_Poliza"/>


	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">		
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_DatosVariables#'>
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfquery name="rsLista" datasource="#session.DSN#">
						select 	a.RHEDVid, a.RHEDVcodigo, a.Ecodigo,
								a.RHEDVdescripcion, a.RHDEorden	, 
								case when a.RHEDVtipo = 0 then '#LB_Normal#' when a.RHEDVtipo = 1 then '#LB_Poliza#' else 'Tipo sin definir(2)'  end as tipo													
						from RHEDatosVariables a																
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					
					<!---- Se crea una estructura rsLista2 donde se cargan los datos del query para usar la funcion REreplaceNocase()--->			
					<cfset rsLista2 = querynew("RHEDVid, RHEDVcodigo, Ecodigo, RHEDVdescripcion, RHDEorden,tipo")>
					<cfset cont = 1>
					<cfloop query="rsLista">
						<cfset res = queryaddrow(rsLista2)>
						<cfset res = querysetcell(rsLista2, 'RHEDVid', rsLista.RHEDVid, cont)>
						<cfset res = querysetcell(rsLista2, 'RHEDVcodigo', rsLista.RHEDVcodigo, cont)>
						<cfset res = querysetcell(rsLista2, 'Ecodigo', rsLista.Ecodigo, cont)>
						<cfset res = querysetcell(rsLista2, 'RHEDVdescripcion', REReplaceNoCase(rsLista.RHEDVdescripcion, '<[^>]*>', '', 'all'), cont)>
						<cfset res = querysetcell(rsLista2, 'RHDEorden', rsLista.RHDEorden, cont)>
						<cfset res = querysetcell(rsLista2, 'tipo', rsLista.tipo, cont)>
						<cfset cont = cont + 1>
					</cfloop>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Codigo"
						Default="C&oacute;digo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Codigo"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Descripcion"
						Default="Descripci&oacute;n"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Descripcion"/>

					<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista2#"/>
							<cfinvokeargument name="desplegar" value="RHEDVcodigo, RHEDVdescripcion, tipo"/> 
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Tipo#"/>
							<cfinvokeargument name="formatos" value="V,V,V"/>
							<cfinvokeargument name="align" value="left,left,left"/>
							<cfinvokeargument name="ajustar" value="N,N,N"/>
							<cfinvokeargument name="irA" value="DatosVariables.cfm"/>
							<cfinvokeargument name="botones" value="Nuevo"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="RHEDVid"/>
						</cfinvoke>
					</td>
				</tr>
		</table>			
		<cf_web_portlet_end>
<cf_templatefooter>	