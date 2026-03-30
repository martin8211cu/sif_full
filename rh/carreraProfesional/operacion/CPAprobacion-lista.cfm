<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinclude template="CPEmpleados-etiquetas.cfm">
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
															 as NombreEmp,RHACPfdesde,RHACPfhasta"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion,NombreEmp,RHACPfdesde,RHACPfhasta"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Empleado#,#LB_FechaInicio#,#LB_FechaFin#"/>
						<cfinvokeargument name="formatos" value="S,S,D,D"/>
						<cfinvokeargument name="filtro" value="a.Ecodigo=#session.Ecodigo#
																and a.RHACPestado = 40
																order by BMfechaalta"/>
						<cfinvokeargument name="align" value="left,left,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="CPAprobacion.cfm"/>
						<cfinvokeargument name="keys" value="RHACPlinea"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="maxRows" value="20"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="DEidentificacion,#NombreEmp#,RHACPfdesde,RHACPfhasta"/>						
					</cfinvoke>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
