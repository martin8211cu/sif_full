<cfquery name="rsReferencia" datasource="asp">
	select llave
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
</cfquery>

<cfif len(trim(rsReferencia.llave)) eq 0>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_UstedNoHaSidoDefinidoComoEmpleadoDeLaEmpresa"
		Default="Usted no ha sido definido como empleado de la empresa"
		returnvariable="MSG_UstedNoHaSidoDefinidoComoEmpleadoDeLaEmpresa"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ONoTieneLosPermisosRequeridos"
		Default="o no tiene los permisos requeridos"
		returnvariable="MSG_ONoTieneLosPermisosRequeridos"/>
	<cf_throw message="#MSG_UstedNoHaSidoDefinidoComoEmpleadoDeLaEmpresa# #session.Enombre# #MSG_ONoTieneLosPermisosRequeridos#" errorcode="8050">
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Evaluacion180Jefe"
		Default="Evaluaci&oacute;n del Desempe&ntilde;o de Jefaturas"
		returnvariable="LB_Evaluacion180Jefe"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Filtrar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Limpiar"
		Default="Limpiar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Limpiar"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Relacion"
		Default="Relaci&oacute;n"
		returnvariable="LB_Relacion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Desde"
		Default="Desde"
		returnvariable="LB_Desde"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Hasta"
		Default="Hasta"
		returnvariable="LB_Hasta"/>									
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoSeEncontraronRegistros"
		Default="No se encontraron Registros"
		returnvariable="MSG_NoSeEncontraronRegistros"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DebeSeleccionarAlMenosUnaEvaluacion"
		Default="Debe seleccionar al menos una evaluación"
		returnvariable="MSG_DebeSeleccionarAlMenosUnaEvaluacion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_EstaSeguroAQueDeseaAplicarLasEvaluacionesSeleccionadas"
		Default="¿Esta seguro(a) que desea aplicar las evaluaciones seleccionadas?"
		returnvariable="MSG_EstaSeguroAQueDeseaAplicarLasEvaluacionesSeleccionadas"/>
						
		
	<cf_web_portlet_start titulo="#LB_Evaluacion180Jefe#" border="true" skin="#Session.Preferences.Skin#">
	<cfinclude template="../../../../portlets/pNavegacion.cfm">
		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">		
					<cfset navegacion = ''>	
					<cfset fecha = Now()>
					<cfif isdefined("url.REdescripcion") and not isdefined("form.REdescripcion")>
						<cfset form.REdescripcion = url.REdescripcion >
					</cfif>
					<cfif isdefined("form.REdescripcion") and len(trim(form.REdescripcion))>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "REdescripcion=" & Form.REdescripcion>
					</cfif>	
					<cfif isdefined("url.fdesde") and not isdefined("form.fdesde")>
						<cfset form.fdesde = url.fdesde >
					</cfif>	
					<cfif isdefined("form.fdesde") and len(trim(form.fdesde))>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fdesde=" & Form.fdesde>
					</cfif>							
					<!---Averiguar el DEid del usuario logueado---->
					<cfquery name="rsDEid" datasource="#session.DSN#">
						select llave as DEid
						from UsuarioReferencia
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							and STabla = 'DatosEmpleado'
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
					</cfquery>
					<table width="100%" cellpadding="0" cellspacing="0">						
						<tr>
							<td>
								<cf_dbfunction name="to_char" args="CDERespuestaj" returnvariable="Lvar_to_char_CDERespuestaj">									
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaCar">
										<cfinvokeargument name="tabla" value="RHRegistroEvaluacion a
																				inner join RHEmpleadoRegistroE b
																					on a.REid = b.REid
																					and b.DEidjefe =#rsDEid.DEid#"/>
										<cfinvokeargument name="columnas" value="distinct a.REid,a.REdescripcion,a.REdesde,a.REhasta,
											(select  distinct x.REid
												from RHRegistroEvaluadoresE v 
												inner join RHConceptosDelEvaluador x
													on   v.REid = x.REid
													and  v.REEid = x.REEid
												inner join RHIndicadoresRegistroE y
													on x.IREid = y.IREid
													and not (y.IREevaluasubjefe = 0 and
															 y.IREevaluajefe = 1)
												inner join RHIndicadoresAEvaluar z
													on y.IAEid = z.IAEid
													and z.IAEtipoconc = 'T'
												inner join RHEmpleadoRegistroE z1
													on v.REid = z1.REid
													and v.DEid = z1.DEid
													and z1.EREnojefe = 0			
												where  x.REid = a.REid
												and  #Lvar_to_char_CDERespuestaj#  is  null
												and v.REEevaluadorj = #rsDEid.DEid#
											)
											 as inactivecol"/>
										<cfinvokeargument name="desplegar" value="REdescripcion, REdesde, REhasta"/>
										<cfinvokeargument name="etiquetas" value="#LB_Relacion#, #LB_Desde#, #LB_Hasta#"/>
										<cfinvokeargument name="formatos" value="V, D, D"/>
										<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo#
																				and a.REestado = 1
																				and '#LSDateFormat(Now(),'yyyymmdd')#' between a.REdesde and a.REhasta
																				and a.REid in (
																					select  distinct g.REid   
																					from RHRegistroEvaluadoresE g
																					inner join RHEmpleadoRegistroE b
																					   on g.REid = b.REid
																					  and g.DEid = b.DEid
																					  and b.DEidjefe = #rsDEid.DEid#
																					where REEfinalj != 1
																					  and  g.REid = a.REid
																				)"/>
										<cfinvokeargument name="align" value="left, left, left"/>
										<cfinvokeargument name="ajustar" value=""/>				
										<cfinvokeargument name="irA" value="Evaluacion_Jefe.cfm"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="maxRows" value="30"/>
										<cfinvokeargument name="keys" value="REid"/>
										<cfinvokeargument name="checkboxes" value="S">
										<cfinvokeargument name="botones" value="Aplicar"/>
										<cfinvokeargument name="mostrar_filtro" value="true"/>
										<cfinvokeargument name="filtrar_automatico" value="true"/>
										<cfinvokeargument name="filtrar_por" value="a.REdescripcion,a.REdesde,a.REhasta"/>
										<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
										<cfinvokeargument name="inactivecol" value="inactivecol"/>
								</cfinvoke>		
							</td>
						</tr>
						<!--- <tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">								
								<input type="button" name="btnFinalizar" value="<cfoutput>#BTN_Finalizar#</cfoutput>" onClick="javascript: funcFinalizar()">
							</td>
						</tr> --->
						<tr><td>&nbsp;</td></tr>
					</table>	
     			</td>	
			</tr>
	  </table>	
		<script language="javascript1.2" type="text/javascript">
			function limpiar(){
				document.filtro.REdescripcion.value = '';
				document.filtro.fdesde.value = '';												
			}

			function algunoMarcado(){
				var f = document.lista;
				if (f.chk) {
					if (f.chk.checked) {
						return true;
					} else {
						for (var i=0; i<f.chk.length; i++) {
							if (f.chk[i].checked) { 
								return true;
							}
						}
					}
				}
				return false;
			}
			
			function funcAplicar(){
				if (algunoMarcado()){
					if(confirm('<cfoutput>#MSG_EstaSeguroAQueDeseaAplicarLasEvaluacionesSeleccionadas#</cfoutput>')){
						
						document.lista.action = "EvaluacionJefe-listaSQL.cfm";
						document.lista.submit();
						//return false;
					}
					else{
						return false;
					}
			} else {
				alert("<cfoutput>#MSG_DebeSeleccionarAlMenosUnaEvaluacion#</cfoutput>!");
				return false;
			}
					}
		</script>		
  	<cf_web_portlet_end>
<cf_templatefooter>