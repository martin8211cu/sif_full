
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Identificacion"/>
 
 	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreEmpleado"
	Default="Nombre del Empleado"
	returnvariable="LB_NombreEmpleado"/>
 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CurriculumVitae"
	Default="Curriculum Vitae"
	returnvariable="LB_CurriculumVitae"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="CurriculumVitaePersonalInterno"
	Default="Curriculum Vitae del Personal Interno"
	returnvariable="CurriculumVitaePersonalInterno"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReferenciasVerificadas"
	Default="Ref. verificadas"
	returnvariable="LB_ReferenciasVerficadas"/>	

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>	
<cf_templateheader>
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">

		<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
		</cfif>
		<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
			<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.DEidentificacionFiltro) & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
		</cfif>
		<cfif isdefined("Form.RHAprobadoFiltro") and Len(Trim(Form.RHAprobadoFiltro)) NEQ 0>
			<cfset filtro = filtro & " and coalesce(RHAprobado,0)   = " & Form.RHAprobadoFiltro>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHAprobadoFiltro=" & Form.RHAprobadoFiltro>
		</cfif>
		<cfif isdefined("Form.RHORefValidaFiltro") and Len(Trim(Form.RHORefValidaFiltro)) NEQ 0>
			<cfset filtro = filtro & " and coalesce(RHORefValida,0)  =" & Form.RHORefValidaFiltro>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHORefValidaFiltro=" & Form.RHORefValidaFiltro>
		</cfif>
		
		<cfif isdefined("Form.sel") and form.sel NEQ 1>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
		</cfif>	
		<!--- VIENE DE REGISTRO DE CONCURSANTES - RECLUTAMIENTO Y SELECCION --->
		<cfif isdefined("Form.RegCon")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RegCon=" & form.RegCon>				
		</cfif>		
		<cfif isdefined("Form.RHCconcurso")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHCconcurso=" & form.RHCconcurso>				
		</cfif>	

		<cf_web_portlet_start border="true"  skin="#Session.Preferences.Skin#">
		<table width="99%" align="center" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td valign="middle" align="right">  
					<cfoutput>
					<form name="formFiltroListaEmpl" method="post" action="" style="margin:0; "><!----action="OferenteExterno.cfm" ---->
						<input type="hidden" name="filtrado" 
						value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
						<input type="hidden" name="sel" 
						value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
						<cfif isdefined("Form.RegCon")>
							<input name="RHCconcurso" type="hidden" value="#form.RHCconcurso#">
							<input name="RegCon" type="hidden" value="#form.RegCon#">				
						</cfif>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
							<tr> 
								<td align="right" width="1%" >#LB_Identificacion#:&nbsp;</td>
								<td>
									<input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" 
									size="15" maxlength="60" 
									value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>">								</td>
								<td align="right" nowrap >#LB_NombreEmpleado#:&nbsp;</td>
								<td><input name="nombreFiltro" type="text" id="nombreFiltro" size="50" maxlength="260" 
									value="<cfif isdefined('form.nombreFiltro')>#form.nombreFiltro#</cfif>" /></td>
                                  <input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">								</td>
							</tr>
						</table>
				  </cfoutput>
					</form>
				</td>
			</tr>				  							
				
			<tr>
				<td>
					<cfquery name="rsLista" datasource="#session.DSN#">
						select DEid, DEidentificacion,<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2, ' ', DEnombre"> as nombreOferente
						from DatosEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						<!---<cfif isdefined("filtro") and len(trim(filtro))>--->
						<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
							and upper(<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2, ' ', DEnombre">) like '%#UCase(Form.nombreFiltro)#%'
						</cfif>
						<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
							and upper(DEidentificacion)  like '%#UCase(Form.DEidentificacionFiltro)#%'
						</cfif>
						order by DEidentificacion, DEapellido1, DEapellido2, DEnombre
					</cfquery>
					
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaEmpl">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion,nombreOferente"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_NombreEmpleado#"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="formName" value="listaEmpleados"/>	
						<cfinvokeargument name="align" value="left,left,Center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="curriculumPI.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="keys" value="DEid"/>
						<cfinvokeargument name="showEmptyListMsg" value="yes"/>
					</cfinvoke>
				</td>		
			</tr>						
				
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<form name="formNuevoEmplLista" method="post" action="curriculum.cfm">
						<cf_botones include = "btnNuevoLista" includevalues = "Nuevo Curriculum" 
							regresarMenu='true' exclude='Alta,Limpiar'>
					</form>
				</td>		
			</tr>			
		</table>
		<cf_web_portlet_end>

<cf_templatefooter>