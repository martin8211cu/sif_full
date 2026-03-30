<cfinvoke key="LB_Titulo" default="Usuarios de Solicitudes de Gastos de Empleado"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadGE.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start _start titulo="#LB_Titulo#">

		<cf_navegacion name="Usucodigo" default="" navegacion="">
		<cf_navegacion name="CFid" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
				<td align="center">
				<cfif form.Usucodigo EQ '' AND NOT isdefined("btnNuevo") AND NOT isdefined("btnNuevoCF")>
					<cfif isdefined("btnNuevo")>
						<cfset form.CFid = "">
					</cfif>
					<cfinclude template="seguridadGE_list.cfm">
				<cfelse>
					<cfinclude template="seguridadGE_form.cfm">
				</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_start _end>
<cf_templatefooter>

