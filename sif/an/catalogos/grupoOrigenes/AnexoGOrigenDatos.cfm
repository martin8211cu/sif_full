<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Mantenimiento de Grupo de Origenes de Datos para Calculo" returnvariable="LB_Titulo" xmlfile="AnexoGOrigenDatos.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">

		<cf_navegacion name="Ecodigo"	default="#session.Ecodigo#" navegacion="">
		<cf_navegacion name="GODid"		default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="AnexoGOrigenDatos_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="AnexoGOrigenDatos_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.GODid EQ '' AND  NOT isdefined("btnNuevo")>
					<cfinclude template="AnexoGOrigenDatos_list.cfm">
				<cfelse>
					<cfinclude template="AnexoGOrigenDatos_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

