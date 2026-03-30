<cfparam name="modo" default="ALTA"></cfparam>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo=#url.modo#>
</cfif>
<cfif modo neq 'ALTA' and isdefined('url.ID_PEmpleado') and len(trim('url.ID_PEmpleado'))>
	<cfset form.ID_PEmpleado=url.ID_PEmpleado>
</cfif>
<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Catalogo de Empleados">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cfquery name="rsSelectEmpleados" datasource="#session.dsn#">
						select pe.ID_PEmpleado, pe.DEid, pe.PEfechaini, pe.PEfechafin, p.Pid,
						 p.Pcodigo,de.DEidentificacion,p.Pdescripcion,
						 de.DEapellido1 #_Cat# ' ' #_Cat# de.DEapellido2 #_Cat# ' ' #_Cat# de.DEnombre as NombreEmp1
						from PEmpleado pe inner join Peaje p 
							on pe.Pid = p.Pid 
						inner join DatosEmpleado de
							on de.DEid=pe.DEid
						where 0 != 1
						and p.Ecodigo=#session.Ecodigo#
						<cfif isdefined('form.filtro_Pcodigo') and len(trim(form.filtro_Pcodigo))>
							and rtrim(upper(Pcodigo)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_Pcodigo))#%">
						</cfif>
						<cfif isdefined('form.filtro_DEidentificacion') and len(trim(form.filtro_DEidentificacion))>
							and rtrim(upper(DEidentificacion)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.filtro_DEidentificacion))#%">
						</cfif>
						<cfif isdefined('form.filtro_PEfechaini')and len(trim(form.filtro_PEfechaini))>
							and PEfechaini = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.filtro_PEfechaini)#">
						</cfif>	
						<cfif isdefined('form.filtro_PEfechafin')and len(trim(form.filtro_PEfechafin))>
							and PEfechafin = <cfqueryparam cfsqltype="cf_sql_date" value="#form.filtro_PEfechafin#">
						</cfif>	
					</cfquery>
					
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsSelectEmpleados#" 
						conexion="#session.dsn#"
						desplegar="Pcodigo,Pdescripcion,DEidentificacion,NombreEmp1,PEfechaini,PEfechafin"
						etiquetas="Código Peaje, Peaje,Cedula Empleado,Empleado,Inicio,Final"
						formatos="S,S,S,S,D,D"
						mostrar_filtro="true"
						align="left,left,left,left,left,left"
						checkboxes="N"
						ira="Empleado.cfm"
						keys="ID_PEmpleado">
					</cfinvoke>
				</td>
				<td width="50%" valign="top">
					<cfinclude template="Empleado-Form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>