
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
	Key="LB_Habilitado"
	Default="Habilitado"
	returnvariable="LB_Habilitado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilitado_para_Consultas"
	Default="Habilitado para Consultas"
	returnvariable="LB_Habilitado_para_Consultas"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreDelOferente"
	Default="Nombre del oferente"
	returnvariable="LB_NombreDelOferente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_OferenteExterno"
	Default="Oferente Externo"
	returnvariable="LB_OferenteExterno"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CurriculumVitae"
	Default="Curriculum Vitae"
	returnvariable="LB_CurriculumVitae"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="ListaDeOferentesExternos"
	Default="Lista de Oferentes Externos"
	returnvariable="ListaDeOferentesExternos"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReferenciasVerificadas"
	Default="Ref. verificadas"
	returnvariable="LB_ReferenciasVerficadas"/>	

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>	
<cf_templateheader title="#ListaDeOferentesExternos#">
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
		<cfif isdefined("Form.RHOid")>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOid=" & #form.RHOid#>				
		</cfif>
		<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
		</cfif>
		<cfif isdefined("Form.RHOidentificacionFiltro") and Len(Trim(Form.RHOidentificacionFiltro)) NEQ 0>
			<cfset filtro = filtro & " and upper(RHOidentificacion)  like '%" & UCase(Form.RHOidentificacionFiltro) & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOidentificacionFiltro=" & Form.RHOidentificacionFiltro>
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

		<cf_web_portlet_start border="true" titulo="#LB_CurriculumVitae#" skin="#Session.Preferences.Skin#">
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
									<input name="RHOidentificacionFiltro" type="text" id="RHOidentificacionFiltro" 
									size="15" maxlength="60" 
									value="<cfif isdefined('form.RHOidentificacionFiltro')><cfoutput>#form.RHOidentificacionFiltro#</cfoutput></cfif>">								</td>
								<td align="right" nowrap >#LB_NombreDelOferente#:&nbsp;</td>
								<td><input name="nombreFiltro" type="text" id="nombreFiltro" size="50" maxlength="260" 
									value="<cfif isdefined('form.nombreFiltro')>#form.nombreFiltro#</cfif>" /></td>
								<td align="right" nowrap >#LB_Habilitado#:&nbsp;</td>
								<td>
									<select name="RHAprobadoFiltro" id="RHAprobadoFiltro" >
										<option value=""><cf_translate key="CMB_Todos">Todos</cf_translate></option>									
										<option value="0" <cfif isdefined("form.RHAprobadoFiltro") and form.RHAprobadoFiltro EQ '0'> selected</cfif>><cf_translate key="CMB_NO">No</cf_translate></option>
										<option value="1" <cfif isdefined("form.RHAprobadoFiltro") and form.RHAprobadoFiltro EQ '1'> selected</cfif>><cf_translate key="CMB_SI">Si</cf_translate></option>
									</select></td>
								<td>
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
						select RHOid, RHOidentificacion, case when coalesce(RHAprobado,0) = 1 then '<cf_translate  key="LB_SI">Si</cf_translate>' else '<cf_translate  key="LB_NO">No</cf_translate>' end as Publicado,
							<cf_dbfunction name="concat" args="RHOapellido1,' ',RHOapellido2, ' ', RHOnombre"> as nombreOferente, 
							1 as o, 1 as sel ,'ALTA' as modo, RHAprobado
						from DatosOferentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						<!---<cfif isdefined("filtro") and len(trim(filtro))>--->
						<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
							and upper(<cf_dbfunction name="concat" args="RHOapellido1,' ',RHOapellido2, ' ', RHOnombre">) like '%#UCase(Form.nombreFiltro)#%'
						</cfif>
						<cfif isdefined("Form.RHOidentificacionFiltro") and Len(Trim(Form.RHOidentificacionFiltro)) NEQ 0>
							and upper(RHOidentificacion)  like '%#UCase(Form.RHOidentificacionFiltro)#%'
						</cfif>
						<cfif isdefined("Form.RHAprobadoFiltro") and Len(Trim(Form.RHAprobadoFiltro)) NEQ 0>
							and coalesce(RHAprobado,0)  = #Form.RHAprobadoFiltro# 
							<!---and coalesce(RHORefValida,0)  = #Form.RHAprobadoFiltro# --->
						</cfif>
						and DEid is null
						order by RHOidentificacion, RHOapellido1, RHOapellido2, RHOnombre
					</cfquery>
					
					<!---<cfdump var="#Form.RHAprobadoFiltro#">
					<cf_dump var="#rsLista#">--->
					
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaEmpl">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="RHOidentificacion,nombreOferente,Publicado"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_OferenteExterno#,#LB_Habilitado_para_Consultas#"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="formName" value="listaEmpleados"/>	
						<cfinvokeargument name="align" value="left,left,Center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="curriculum.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="keys" value="RHOid"/>
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