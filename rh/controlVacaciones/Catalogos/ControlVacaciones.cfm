<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Salario_Promedio"        Default="Salario Promedio"	component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Salario_Promedio">
<cfinvoke Key="LB_Salario_Promedio_Diario" Default="Salario Promedio Diario" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Salario_Promedio_Diario">
<cfinvoke Key="LB_Periodo"					Default="Periodo"					component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Periodo">
<cfinvoke Key="LB_Fecha"					Default="Fecha"					component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Fecha">
<cfinvoke Key="LB_Titulo"			Default="Control de Vacaciones"					component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Titulo">
<cfinvoke Key="LB_Saldodias"       			Default="Saldo Dias"					component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Saldodias">
<cfinvoke Key="LB_RecursosHumanos" 			 Default="Recursos Humanos" 			component="sif.Componentes.Translate" method="Translate" 	returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" />
<cfinvoke Key="MSG_DeseaEliminarElRegegistro" Default="Desea eliminar el registro?" component="sif.Componentes.Translate" method="Translate"	returnvariable="MSJ_Eliminar"		XmlFile="/rh/generales.xml" />	
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset form.DEid = url.DEid >
</cfif>
<cfif isdefined("url.DVAperiodo") and len(trim(url.DVAperiodo))>
	<cfset form.DVAperiodo = url.DVAperiodo >
</cfif>
<cfif isdefined("url.DVAid") and len(trim(url.DVAid))>
	<cfset form.DVAid = url.DVAid >
</cfif>


<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_Titulo#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="/rh/portlets/pEmpleado.cfm">					
				</tr>							
				<tr><td>
					<table width="100%" cellpadding="2" cellspacing="0">				
						<tr>
							<td width="50%" valign="top">
								<cfquery name="rsLista" datasource="#session.DSN#" result="rsListaGrupoNivel">
									select DEid, DVAperiodo, DVAsaldodias, DVASalarioProm, DVAfecha, DVASalarioPdiario, DVAid
									from DVacacionesAcum
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
									and (DVASalarioPdiario<>0	  or  DVASalarioProm<>0)
								</cfquery>
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario"/>
									<cfinvokeargument name="etiquetas" value="#LB_Periodo#,#LB_Saldodias#,#LB_Salario_Promedio#,#LB_Salario_Promedio_Diario#"/>
									<cfinvokeargument name="formatos" value="I,M,M,M"/>
									<cfinvokeargument name="align" value="left,center,right,right"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="ControlVacaciones.cfm"/>
									<cfinvokeargument name="keys" value="DVAid, DEid, DVAperiodo"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
								</cfinvoke>
							</td>
							<td width="50%" valign="top"><cfinclude template="ControlVacaciones-form.cfm"></td>
						</tr>
					</table> 
				</td></tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>