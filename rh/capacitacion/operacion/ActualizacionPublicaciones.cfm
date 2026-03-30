
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<!----- Etiquetas de traduccion------>
<cfset LB_ActualizacionPublicaciones = t.translate('LB_ActualizacionPublicaciones','Actualización de Publicaciones','/rh/generales.xml')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>


<cf_templateheader title="#LB_ActualizacionPublicaciones#"> 
	<cf_web_portlet_start titulo="#LB_ActualizacionPublicaciones#">
		<cfif not isdefined('form.DEid') or len(trim(form.DEid)) EQ 0 >
			<cf_dbfunction name="concat" args="de.DEapellido1,' ', de.DEapellido2,' ', de.DEnombre" returnvariable="Lvar_Nombre">
			<table width="99%" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td>
						<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaRH"
							mostrar_filtro="true"
							filtrar_automatico="true"
							columnas="distinct RHP.DEid, de.DEidentificacion, #Lvar_Nombre# as NombreCompleto" 
							desplegar="DEidentificacion, NombreCompleto"
							filtrar_por="de.DEidentificacion, #Lvar_Nombre#"    
							etiquetas="#LB_Identificacion#, #LB_Nombre#"
							align="left,left"
							formatos="S,S"
							tabla="RHPublicaciones RHP
									inner join DatosEmpleado de
										on de.DEid = RHP.DEid
										and de.Ecodigo = #session.Ecodigo#"
							filtro="RHP.RHPEstado = 0"
							ira="ActualizacionPublicaciones.cfm"
							showemptylistmsg="true"
							debug="N"
						/>
					</td>
				</tr>		
			</table>
		<cfelse>
			<cfinclude template="ActualizacionPublicaciones-form.cfm">
		</cfif>		
	<cf_web_portlet_end>	
<cf_templatefooter>