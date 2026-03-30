<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinclude template="CPEmpleados-etiquetas.cfm">
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfset rsRHACPestado = queryNew("value,description","Decimal,Varchar")>
<cfset queryAddRow(rsRHACPestado,5)>
<cfset querySetCell(rsRHACPestado,"value",-1,1)>
<cfset querySetCell(rsRHACPestado,"description","#LB_Todas#",1)>
<cfset querySetCell(rsRHACPestado,"value",10,2)>
<cfset querySetCell(rsRHACPestado,"description","#LB_Revision#",2)>
<cfset querySetCell(rsRHACPestado,"value",20,3)>
<cfset querySetCell(rsRHACPestado,"description","#LB_Rechazada#",3)>
<cfset querySetCell(rsRHACPestado,"value",30,4)>
<cfset querySetCell(rsRHACPestado,"description","#LB_PendienteAplicar#",4)>
<cfset querySetCell(rsRHACPestado,"value",40,5)>
<cfset querySetCell(rsRHACPestado,"description","#LB_Aplicada#",5)>
<!--- Pintado de la Pantalla de Filtros --->
<cf_templateheader title="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<table width="100%" style="vertical-align:top" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="100%" valign="top" align="center">	
					<cf_dbfunction name="concat" args="b.DEapellido1,' ',b.DEapellido2, ' ',b.DEnombre" returnvariable="NombreEmp">				
					<cfinvoke component="rh.Componentes.pListas" 
						method="pListaRH" 
						returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="RHAccionesCarreraP a 
															  inner join DatosEmpleado b
															  	on b.DEid = a.DEid
																and b.Ecodigo = a.Ecodigo"/>
						<cfinvokeargument name="columnas" value="RHACPlinea,
															b.DEidentificacion,
															#NombreEmp#
															 as NombreEmp,RHACPfdesde,RHACPfhasta	
															 ,case when a.RHACPestado = 20 then '#LB_Rechazada#'
														   when a.RHACPestado = 10 then '#LB_Revision#'
														   when a.RHACPestado = 30 then '#LB_PendienteAplicar#'
														   when a.RHACPestado = 40 then '#LB_Aplicada#'
														   when a.RHACPestado = 0 then '#LB_Registrada#'		
																end as RHACPestado"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion,NombreEmp,RHACPfdesde,RHACPfhasta,RHACPestado"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Empleado#,#LB_FechaInicio#,#LB_FechaFin#,#LB_Estado#"/>
						<cfinvokeargument name="formatos" value="S,S,D,D,S"/>
						<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo#
																and a.RHACPestado not in(0)
																order by RHACPestado"/>
						<cfinvokeargument name="align" value="left,left,left,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="CPEmpleados.cfm"/>
						<cfinvokeargument name="keys" value="RHACPlinea"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="maxRows" value="20"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="DEidentificacion,#NombreEmp#,RHACPfdesde,RHACPfhasta,a.RHACPestado"/>						
						<cfinvokeargument name="botones" value="Nuevo"/>
						<cfinvokeargument name="rsRHACPEstado" value="#rsRHACPEstado#">
					</cfinvoke>
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
