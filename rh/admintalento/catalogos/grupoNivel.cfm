<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" 			  Default="Recursos Humanos" 			component="sif.Componentes.Translate" method="Translate" 	returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" />
<cfinvoke Key="LB_CODIGO" 					  Default="C&oacute;digo"				component="sif.Componentes.Translate" method="Translate"	returnvariable="LB_CODIGO"			XmlFile="/rh/generales.xml"  />
<cfinvoke Key="LB_DESCRIPCION" 				  Default="Descripci&oacute;n" 			component="sif.Componentes.Translate" method="Translate"	returnvariable="LB_DESCRIPCION"		XmlFile="/rh/generales.xml" />	
<cfinvoke Key="MSG_DeseaEliminarElRegegistro" Default="Desea eliminar el registro?" component="sif.Componentes.Translate" method="Translate"	returnvariable="MSJ_Eliminar"		XmlFile="/rh/generales.xml" />	
<cfinvoke Key="LB_Grupos_de_Nivel" 			  Default="Recursos Humanos" 			component="sif.Componentes.Translate" method="Translate"	returnvariable="LB_Titulo" />
<cfinvoke Key="LB_Peso" 					  Default="Peso" 						component="sif.Componentes.Translate" method="Translate"	returnvariable="LB_Peso" />
<cfinvoke Key="MSG_La_suma_de_los_pesos_no_debe_ser_mayor_a_100" Default="La suma de los pesos no debe ser mayor a 100" component="sif.Componentes.Translate" method="Translate"	returnvariable="MSJ_Suma"/>	
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("url.RHGNid") and len(trim(url.RHGNid))>
	<cfset form.RHGNid = url.RHGNid >
</cfif>

<cf_templateheader title="#LB_RecursosHumanos#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_Titulo#">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td width="50%" valign="top">
								<cfquery name="rsLista" datasource="#session.DSN#" result="rsListaGrupoNivel">
									select a.RHGNid, a.RHGNcodigo, a.RHGNdescripcion
									from RHGrupoNivel a
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									order by a.RHGNcodigo, a.RHGNdescripcion
								</cfquery>
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="RHGNcodigo,RHGNdescripcion"/>
									<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
									<cfinvokeargument name="formatos" value="V,V"/>
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="grupoNivel.cfm"/>
									<cfinvokeargument name="keys" value="RHGNid"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
								</cfinvoke>
							</td>
							<td width="50%" valign="top"><cfinclude template="grupoNivel-form.cfm"></td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>