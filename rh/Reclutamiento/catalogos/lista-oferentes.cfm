
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
	Key="LB_MantenimientoOferenteExterno"
	Default="Mantenimiento Oferente Externo"
	returnvariable="LB_MantenimientoOferenteExterno"/>
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
			<cf_dbfunction name="concat" args=" and upper(RHOapellido1 ,' ',RHOapellido2,' ',RHOnombre) like '%" returnvariable="vCadena">
			<cfset filtro = filtro & #vCadena# & #UCase(Form.nombreFiltro)# & "%'">
			
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
		</cfif>
		<cfif isdefined("Form.RHOidentificacionFiltro") and Len(Trim(Form.RHOidentificacionFiltro)) NEQ 0>
			<cfset filtro = filtro & " and upper(RHOidentificacion)  like '%" & UCase(Form.RHOidentificacionFiltro) & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOidentificacionFiltro=" & Form.RHOidentificacionFiltro>
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

		<cf_web_portlet_start border="true" titulo="#LB_MantenimientoOferenteExterno#" skin="#Session.Preferences.Skin#">
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
									value="<cfif isdefined('form.RHOidentificacionFiltro')><cfoutput>#form.RHOidentificacionFiltro#</cfoutput></cfif>">
								</td>
								<td align="right" nowrap >#LB_NombreDelOferente#:&nbsp;</td>
								<td>
									<input name="nombreFiltro" type="text" id="nombreFiltro2" size="50" maxlength="260" 
									value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>">
								</td>
								<td align="right" width="1%" nowrap >#LB_ReferenciasVerficadas#:&nbsp;</td>
								<td>
									<select name="RHORefValidaFiltro">
										<option value=""><cf_translate key="LB_Todos">(Todos)</cf_translate></option>
										<option value="0" <cfif isdefined("form.RHORefValidaFiltro") and form.RHORefValidaFiltro EQ '0'> selected</cfif>><cf_translate key="LB_No">No</cf_translate></option>
										<option value="1" <cfif isdefined("form.RHORefValidaFiltro") and form.RHORefValidaFiltro EQ '1'> selected</cfif>><cf_translate key="LB_Si">Si</cf_translate></option>
									</select>									
						
								</td>
								<td>
                                  <input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
								</td>
							</tr>
						</table>
						</cfoutput>
					</form>
				</td>
			</tr>				  							
				
			<tr>
				<td>
					<cfquery name="rsLista" datasource="#session.DSN#">
						select RHOid, RHOidentificacion, 
							case  coalesce(RHORefValida,0) when 1 then 'Si' else 'No' end as RHORefValida,
							<cf_dbfunction name="concat" args="RHOapellido1,' ',RHOapellido2,' ',RHOnombre"> as nombreOferente,
							1 as o, 1 as sel ,'ALTA' as modo
						from DatosOferentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						<cfif isdefined("filtro") and len(trim(filtro))>
							#PreserveSingleQuotes(filtro)#
						</cfif>
						and DEid is null
						order by RHOidentificacion, RHOapellido1, RHOapellido2, RHOnombre
					</cfquery>
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaEmpl">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="RHOidentificacion, nombreOferente,RHORefValida"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_OferenteExterno#,#LB_ReferenciasVerficadas#"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="formName" value="listaEmpleados"/>	
						<cfinvokeargument name="align" value="left,left,center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="OferenteExterno.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="keys" value="RHOid"/>
						<cfinvokeargument name="showEmptyListMsg" value="yes"/>
					</cfinvoke>
				</td>		
			</tr>						
				
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<form name="formNuevoEmplLista" method="post" action="OferenteExterno.cfm">
						<input type="hidden" name="o" value="1">
						<input type="hidden" name="sel" value="1">
						<!--- <input name="btnNuevoLista" type="submit" value="Nuevo Oferente">	 --->			
						<cf_botones include = "btnNuevoLista" includevalues = "Nuevo Oferente" 
							regresarMenu='true' exclude='Alta,Limpiar'>
						<!--- VIENE DE REGISTRO DE CONCURSANTES - RECLUTAMIENTO Y SELECCION --->
						<cfif isdefined("Form.RegCon")>
							<input name="RHCconcurso" type="hidden" value="#form.RHCconcurso#">
							<input name="RegCon" type="hidden" value="#form.RegCon#">				
						</cfif>					
					</form>
				</td>		
			</tr>			
		</table>
		<cf_web_portlet_end>

<cf_templatefooter>