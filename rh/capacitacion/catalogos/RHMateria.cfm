<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Curso"
	Default="Curso"
	returnvariable="LB_Curso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Siglas"
	Default="Siglas"
	returnvariable="LB_Siglas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Activo"
	Default="Activo"
	returnvariable="LB_Activo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_InActivo"
	Default="Inactivo"
	returnvariable="LB_InActivo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ambos"
	Default="Ambos"
	returnvariable="LB_Ambos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MSGNoHayRegistrosRelacionados"
	Default="No hay registros relacionados"
	returnvariable="LB_MSGNoHayRegistrosRelacionados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MantenimientoDeCursosParaCapacitacion"
	Default="Mantenimiento de Cursos para Capacitaci&oacute;n"
	returnvariable="LB_MantenimientoDeCursosParaCapacitacion"/>

﻿<!--- FIN VARIABLES DE TRADUCCION --->

<!--- CONSULTAS --->
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfset rsEstado = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsEstado,3)>
<cfset querySetCell(rsEstado,"value","",1)>
<cfset querySetCell(rsEstado,"description","#LB_Ambos#",1)>
<cfset querySetCell(rsEstado,"value",0,2)>
<cfset querySetCell(rsEstado,"description","#LB_Inactivo#",2)>
<cfset querySetCell(rsEstado,"value",1,3)>
<cfset querySetCell(rsEstado,"description","#LB_Activo#",3)>

<!---  FIN DE CONSULTAS--->

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

﻿<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start border="true" titulo="#LB_MantenimientoDeCursosParaCapacitacion#" skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td valign="top" width="50%" align="center">
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaRel">
							<cfinvokeargument name="tabla" value="RHMateria"/>
							<cfinvokeargument name="columnas" value="Mcodigo, 
                            										case when LEN(Mnombre) > 30 then substring(Mnombre,1,30)#_Cat# '...' else Mnombre end as Mnombre, 
                                                                    Msiglas, Mactivo,
																	case when Mactivo = 1 then '<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>' end as Activo"/>
							<cfinvokeargument name="desplegar" value="Mnombre, Msiglas, Activo"/>
							<cfinvokeargument name="etiquetas" value="#LB_Curso#, #LB_Siglas#, #LB_Activo#"/>
							<cfinvokeargument name="formatos" value="S,S,S"/>
							<cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo#
																	order by Mnombre, Msiglas"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="false,false,true"/>				
							<cfinvokeargument name="irA" value="RHMateria.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="maxRows" value="30"/>
							<cfinvokeargument name="keys" value="Mcodigo"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="filtrar_por" value="Mnombre|Msiglas|Mactivo"/>
							<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
							<cfinvokeargument name="EmptyListMsg" value="#LB_MSGNoHayRegistrosRelacionados#"/>
							<cfinvokeargument name="rsActivo" value="#rsEstado#"/>
							<cfinvokeargument name="showlink" value="true"/>
					</cfinvoke>	
				</td>
				<td valign="top"><cfinclude template="RHMateria-form.cfm"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

