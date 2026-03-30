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
		Key="LB_AutoevaluacionEvaluacionDelDesempenoDeJefaturas"
		Default="Autoevaluaci&oacute;n Evaluación del Desempeño de Jefaturas"
		returnvariable="LB_AutoevaluacionEvaluacionDelDesempenoDeJefaturas"/>	
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
		
	<cf_web_portlet_start titulo="#LB_AutoevaluacionEvaluacionDelDesempenoDeJefaturas#" border="true" skin="#Session.Preferences.Skin#">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">		    	            										
					<cfset navegacion = ''>	
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
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaCar">
										<cfinvokeargument name="tabla" value="RHRegistroEvaluacion a 
																				inner join RHEmpleadoRegistroE b
																					on a.REid = b.REid
																					and b.EREnoempleado = 0
																					and b.DEid =#rsDEid.DEid#
																				inner join RHRegistroEvaluadoresE c
																					on a.REid = c.REid
																					and c.DEid = #rsDEid.DEid#
																					and c.REEfinale = 0"/>
										<cfinvokeargument name="columnas" value="b.DEid,a.REid,a.REdescripcion,a.REdesde,a.REhasta"/>
										<cfinvokeargument name="desplegar" value="REdescripcion, REdesde, REhasta"/>
										<cfinvokeargument name="etiquetas" value="#LB_Relacion#, #LB_Desde#, #LB_Hasta#"/>
										<cfinvokeargument name="formatos" value="V, D, D"/>
										<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo#
																				and a.REestado = 1
																				and REaplicaempleado = 1
																				and '#LSDateFormat(Now(),'yyyymmdd')#' between a.REdesde and a.REhasta"/>
										<cfinvokeargument name="align" value="left, left, left"/>
										<cfinvokeargument name="ajustar" value=""/>				
										<cfinvokeargument name="irA" value="autoevaluacion_empleado.cfm"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="maxRows" value="30"/>
										<cfinvokeargument name="keys" value="REid"/>
										<cfinvokeargument name="checkboxes" value="S"/>
										<cfinvokeargument name="mostrar_filtro" value="true"/>
										<cfinvokeargument name="filtrar_automatico" value="true"/>
										<cfinvokeargument name="filtrar_por" value="a.REdescripcion,a.REdesde,a.REhasta"/>
										<cfinvokeargument name="botones" value="Aplicar"/>
										<!----<cfinvokeargument name="formName" value="form2"/>---->
										<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
								</cfinvoke>		
							</td>
						</tr>						
						<tr><td>&nbsp;</td></tr>
					</table>	
     			</td>	
			</tr>
		</table>	
		<script language="javascript1.2" type="text/javascript">
			function funcAplicar(){
				document.lista.DEID.value = <cfoutput>'#rsDEid.DEid#'</cfoutput>;
				document.lista.action = 'autoevaluacion_empleado-sql.cfm';					
			} 
			function limpiar(){
				document.filtro.REdescripcion.value = '';
				document.filtro.fdesde.value = '';												
			}
		</script>		
  	<cf_web_portlet_end>
<cf_templatefooter>