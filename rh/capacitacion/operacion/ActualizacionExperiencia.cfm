<cfinclude template="ActualizacionExperiencia-translate.cfm">
<cf_templateheader title="#LB_nav__SPdescripcion#">
		<cf_templatecss>
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
		<cf_dbfunction name="concat" args="b.DEapellido1,' ', b.DEapellido2,' ',b.DEnombre" returnvariable="Lvar_Nombre">
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
			<cfif not isdefined('form.DEid') or LEN(TRIM(form.DEid)) EQ 0 >
			<table width="99%" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td>
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaRH"
						mostrar_filtro="true"
						filtrar_automatico="true"
						columnas="distinct a.DEid, b.DEidentificacion,#Lvar_Nombre# as NombreCompleto" 
						desplegar="DEidentificacion,NombreCompleto"
						filtrar_por="b.DEidentificacion, #Lvar_Nombre#"    
						etiquetas="#LB_Identificacion#,#LB_Nombre#"
						align="left,left"
						formatos="S,S"
						tabla="RHExperienciaEmpleado a
								inner join DatosEmpleado b
									on b.DEid = a.DEid
									and b.Ecodigo = a.Ecodigo"
						filtro="a.RHEEestado = 0
								  and a.Ecodigo = #session.Ecodigo#"
						ira="ActualizacionExperiencia.cfm"
						showemptylistmsg="true"
						debug="N"
					/>
				</td>
			</tr>
			</table>
			<cfelse>
				<cfinclude template="ActualizacionExperiencia-form.cfm">
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>