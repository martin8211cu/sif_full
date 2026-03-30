<cf_templateheader title="Lista de Empleados">
<cf_dbfunction name="OP_concat"	returnvariable="_cat">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" titulo="Lista de Empleados" skin="#Session.Preferences.Skin#">
					<cfinclude template="../../portlets/pNavegacion.cfm">
				
					<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
						<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
					</cfif>

					<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
						<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
					</cfif>		

					<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
						<cfparam name="Form.filtrado" default="#Url.filtrado#">
					</cfif>	

					<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
						<cfparam name="Form.DEid" default="#Url.DEid#">
					</cfif>
	
					<cfset filtro = "">
					<cfset navegacion = "">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
					<cfif isdefined("Form.DEid")>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & #form.DEid#>				
					</cfif>
	
					<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
						<cfset filtro = filtro & " and upper((DEapellido1 #_cat# ' ' #_cat# DEapellido2 #_cat# ', ' #_cat# DEnombre)) like '%" & #UCase(Form.nombreFiltro)# & "%'">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
					</cfif>

					<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
						<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.DEidentificacionFiltro) & "%'">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
					</cfif>

					<br>
					<form style="margin:0;" name="filtro" method="post" action="listaEmpleados.cfm">
						<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
						<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
						
						<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
							<tr> 
								<td height="17" class="fileLabel" align="right">Identificaci&oacute;n</td>
								<td><input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>"></td>
								<td class="fileLabel" align="right">Nombre del empleado</td>
								<td><input name="nombreFiltro" type="text" id="nombreFiltro2" size="70" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
								<td colspan="2" rowspan="2">
									<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
									<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
								</td>
							</tr>
						</table>
					</form>

					<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
						<tr id="verLista"> 
							<td> 
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
										<cf_dbfunction name="to_char"	args="DEid" returnvariable="DEid">
											<cfinvoke 
												component="sif.Componentes.pListas"
												method="pListaRH"
												returnvariable="pListaEmpl">
												<cfinvokeargument name="tabla" value="DatosEmpleado"/>
												<cfinvokeargument name="columnas" value="#PreserveSingleQuotes(DEid)# as DEid, DEidentificacion, (DEapellido1 #_cat# ' ' #_cat# DEapellido2 #_cat# ', ' #_cat# DEnombre) as nombreEmpl,o=1,sel=1,'ALTA' modo"/>
												<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
												<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Empleado"/>
												<cfinvokeargument name="formatos" value=""/>
												<cfinvokeargument name="formName" value="listaEmpleados"/>	
												<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by DEidentificacion, DEapellido1, DEapellido2, DEnombre"/>
												<cfinvokeargument name="align" value="left,left"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="irA" value="registroDeducciones.cfm"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
												<cfinvokeargument name="keys" value="DEid"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
											</cfinvoke>
											<br>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
	<script language="javascript1.2" type="text/javascript">
		function limpiar(){
			document.filtro.DEidentificacionFiltro.value = '';
			document.filtro.nombreFiltro.value = '';
		}
	</script>
<cf_templatefooter>