<cfinclude template="ProyeccionRentaA-translate.cfm">
<!--- CONSULTAS --->
<cfif isdefined("Url.Filtro_NombreEmpl") and not isdefined("Form.Filtro_NombreEmpl")>
	<cfparam name="Form.Filtro_NombreEmpl" default="#Url.Filtro_NombreEmpl#">
</cfif>
<cfif isdefined("Url.Filtro_DEidentificacion") and not isdefined("Form.Filtro_DEidentificacion")>
	<cfparam name="Form.Filtro_DEidentificacion" default="#Url.Filtro_DEidentificacion#">
</cfif>		
<cfif isdefined("Url.Filtro_estado") and not isdefined("Form.Filtro_estado")>
	<cfparam name="Form.Filtro_estado" default="#Url.Filtro_estado#">
</cfif>		
<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
	<cfparam name="Form.filtrado" default="#Url.filtrado#">
</cfif>	
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>		
<cfset filtro = "">
<cfset navegacion = "">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
<cfif isdefined("Form.DEid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & #form.DEid#>				
</cfif>
<cfif isdefined("Form.Filtro_NombreEmpl") and Len(Trim(Form.Filtro_NombreEmpl)) NEQ 0>
	<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like '%" & #UCase(Form.Filtro_NombreEmpl)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_NombreEmpl=" & Form.Filtro_NombreEmpl>
</cfif>
<cfif isdefined("Form.Filtro_DEidentificacion") and Len(Trim(Form.Filtro_DEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.Filtro_DEidentificacion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_DEidentificacion=" & Form.Filtro_DEidentificacion>
</cfif>
<cfif isdefined("Form.Filtro_estado") and Len(Trim(Form.Filtro_estado)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_estado=" & Form.Filtro_estado>
</cfif>
<cfif isdefined("Form.sel") and form.sel NEQ 1>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
</cfif>		

<cfquery name="rsLista" result="rsLista_PlistaResult_" datasource="#session.DSN#">
	select DEid,
		   DEidentificacion,
		   DEtarjeta,
		   DEapellido1 #_Cat# ' ' #_Cat# DEapellido2 #_Cat# ' ' #_Cat# DEnombre as nombreEmpl,
		  '' as Estado

	from DatosEmpleado

	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("filtro") and len(trim(filtro))>
		#PreserveSingleQuotes(filtro)#
	</cfif>
	
	<cfif isdefined("Form.Filtro_estado") and listfind('0,1', form.Filtro_estado) >
		and <cfif Form.Filtro_estado eq '0'>not</cfif> exists (	select 1
																from LineaTiempo lt
																where lt.DEid = DatosEmpleado.DEid
																  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta )
	</cfif>
	
	order by DEidentificacion, DEapellido1 #_Cat# ' ' #_Cat# DEapellido2 #_Cat# ' ' #_Cat# DEnombre
</cfquery>
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
  <cfquery datasource="#session.dsn#" name="rsEstado">
	select '' as value, '#LB_Todos#' as description, '0' as ord from dual
	union
	select '1' as value, '#LB_Activos#' as description, '1' as ord from dual
	union
	select '0' as value, '#LB_Inactivos#' as description, '2' as ord from dual
	order by 3,2
</cfquery>
<!--- FIN CONSULTAS --->
<cfsilent>
<cfinvoke key="LB_Proyeccion_de_Renta" default="Proyecci&oacute;n de Renta" returnvariable="LB_Proyeccion_de_Renta" component="sif.Componentes.Translate" method="Translate"/>
</cfsilent>
<cf_templateheader title="#LB_RecursosHumanos#">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" titulo="<cfoutput>#nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">

	   					<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
								<cfset regresar = "javascript:history.back();">
							<cfelse>
								<cfset regresar = "/cfmx/rh/index.cfm">
							</cfif>		
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>	 						
							<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
								<cfset Autorizacion = 1>							
								<tr>
									<td>
										
										<cfinclude template="../../autogestion/operacion/ProyeccionRenta.cfm">
									</td>
								</tr>
							<cfelse>
								<tr> 
									<td> 
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td>
	
													<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaEmpl">
														<cfinvokeargument name="query" 					value="#rsLista#"/>
														<cfinvokeargument name="useAJAX" 				value="yes">
														<cfinvokeargument name="queryresult" 			value="#rsLista_PlistaResult_#">
														<cfinvokeargument name="datasource" 			value="#session.DSN#">
														<cfinvokeargument name="desplegar" 				value="DEidentificacion, nombreEmpl,Estado"/>
														<cfinvokeargument name="etiquetas" 				value="#vIdentificacion#,#vEmpleado#,Estado"/>
														<cfinvokeargument name="align" 					value="left,left,center"/>
														<cfinvokeargument name="formatos" 				value="S,S,S"/>
														<cfinvokeargument name="formName" 				value="listaEmpleados"/>	
														<cfinvokeargument name="ajustar" 				value="N"/>
														<cfinvokeargument name="irA" 					value="ProyeccionRentaA.cfm"/>
														<cfinvokeargument name="navegacion" 			value="#navegacion#"/>
														<cfinvokeargument name="keys" 					value="DEid"/>
														<cfinvokeargument name="filtrar_automatico" 	value="true"/>
														<cfinvokeargument name="mostrar_filtro" 		value="true"/>
														<cfinvokeargument name="rsEstado" 				value="#rsEstado#"/>
														<cfinvokeargument name="filtrar_por" 		 	value="DEidentificacion | DEnombre #_Cat# ' ' #_Cat# DEapellido1 #_Cat# ' ' #_Cat# DEapellido2 |Estado"/>
														<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
													</cfinvoke>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</cfif>
     			 		</table>
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
<cf_templatefooter>