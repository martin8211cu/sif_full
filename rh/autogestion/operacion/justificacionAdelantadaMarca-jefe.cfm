

 <!---  <cfdump var="#form#">
<cfdump var="#url#"> --->



<script>
function Limpiar(){
	document.form2.DEid2.value='';
	document.form2.DEidentificacion2.value='';
	document.form2.DEid22.value='';
	document.form2.RHJMUfecha2.value='';
	document.form2.RHIid2.options[0].selected=true;

}
</script>

<!--- form2 --->
<cfif isdefined("url.DEid2") and len(trim(url.DEid2))NEQ 0>
	<cfset form.DEid2 = url.DEid2>
</cfif>

<cfif isdefined("url.RHJMUfecha2") and len(trim(url.RHJMUfecha2))NEQ 0>
	<cfset form.RHJMUfecha2 = url.RHJMUfecha2>
</cfif> 

<cfif isdefined("url.RHIid2") and len(trim(url.RHIid2))NEQ 0>
	<cfset form.RHIid2 = url.RHIid2>
</cfif>

<!--- navegacion --->
<cfset navegacion = "">
<cfif isdefined("form.DEid2") and len(trim(form.DEid2))NEQ 0>
	<cfset navegacion = navegacion  &  "DEid2="&form.DEid2>	
</cfif>

<cfif isdefined("form.RHJMUfecha2") and len(trim(form.RHJMUfecha2))NEQ 0>
	 <cfset navegacion = navegacion & "RHJMUfecha2="& form.RHJMUfecha2>	
	<!--- <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "RHJMUfecha2="&form.RHJMUfecha2>	 --->
</cfif>

<cfif isdefined("form.RHIid2") and len(trim(form.RHIid2))NEQ 0>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "RHIid2="&form.RHIid2>	
</cfif>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="50%" valign="top"><!--- Lista de Justificaciones --->
					
					<form name="form2" action="justificacionAdelantadaMarca-jefe.cfm" method="post">
						<table width="100%" class="tituloListas"><!---  border="0"  cellpadding="0" cellspacing="0"--->
							
							<tr valign="top">
								<td width="23%"  class="fileLabel" align="left"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
								<td width="66%"  class="fileLabel" align="left"><cf_translate key="LB_Situacion">Situación</cf_translate></td>
							</tr>
							
							<tr valign="top">
								<td nowrap>
									<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
										<cfset RHJMUfecha = LSDateFormat(form.RHJMUfecha2,'dd/mm/yyyy')>
										<cf_sifcalendario  form="form2" name="RHJMUfecha2" value="#RHJMUfecha#" tabindex="1">
									<cfelse>
										<cfset RHJMUfecha = ''>
										<cf_sifcalendario  form="form2" name="RHJMUfecha2" value="" tabindex="1">
									</cfif>
								</td>
								
								<td>
									<cfinvoke
										Component= "rh.Componentes.RH_inconsistencias"
										method="RHInconsistencias"
										returnvariable="rhIncons">
										
										<cfif isdefined("form.RHIid2") and len(trim(form.RHIid2))neq 0>
											<cfinvokeargument name="RHIid" value="#form.RHIid2#"/>	
										</cfif>
										
										<cfinvokeargument name="index" value="2"/>		
										<cfinvokeargument name="tabindex" value="1"/>
									</cfinvoke>
								</td>
							</tr>
							<tr>
								<td nowrap  colspan="2" align="left" class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
							</tr>	
							<tr>
								<td nowrap colspan="2" align="left" >
									<cfif isdefined("Form.DEid2") and Len(Trim(Form.DEid2))>
										<cf_rhempleado nombre="DEid2" form='form2' tabindex="1" size = "15" index="2" idempleado="#Form.DEid2#"> 
									<cfelse>
										<cf_rhempleado nombre="DEid2" form='form2' tabindex="1" size = "15" index="2">
									</cfif> 
								</td>
							</tr>
							<tr>
								<td colspan="2" align="right">
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
									<cfoutput>
									<input name="btnFiltrar" type="submit" value="#BTN_Filtrar#">
									<input name="btnLimpiar" type="button"  value="#BTN_Limpiar#" onClick="Limpiar()">
									</cfoutput>
								</td>
							</tr>
						</table>
					</form>
					
					<cfquery name="rsJustificaciones" datasource="#session.DSN#">
						select 
							a.RHJMUid,
							a.DEid,
							a.Ecodigo,
							a.RHJMUsituacion,
							case RHJMUsituacion
								when 0 then '<cf_translate key="LB_OmisionDeMarcaDeEntrada">Omisión de Marca de Entrada</cf_translate>'
								when 1 then '<cf_translate key="LB_OmisionDeMarcaDeSalida">Omisión de Marca de Salida</cf_translate>'
								when 2 then '<cf_translate key="LB_DiaExtra">Día Extra</cf_translate>'
								when 3 then '<cf_translate key="LB_DiaLibre">Día Libre</cf_translate>'
								when 4 then '<cf_translate key="LB_LlegadaAnticipada">Llegada Anticipada</cf_translate>'
								when 5 then '<cf_translate key="LB_LlegadaTardia">Llegada Tardía</cf_translate>'
								when 6 then '<cf_translate key="LB_SalidaAnticipada">Salida Anticipada</cf_translate>'
								when 7 then '<cf_translate key="LB_SalidaTarde">Salida Tarde</cf_translate>' end
							as RHJMUsituacionx,
							a.RHJMUfecha,
							a.RHJMUjustificacion,
							a.RHJMUprocesada,
							(select {fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})}
								from 
								DatosEmpleado b
								where b.DEid = a.DEid
							)as nombreEmp
							
							<!--- para no perder el filtro --->
							<cfif isdefined('form.DEid2') and len(trim(form.DEid2))NEQ 0>
							,'#form.DEid2#' as DEid2
							</cfif> 
							
							<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
							,'#form.RHJMUfecha2#' as RHJMUfecha2
							</cfif>
							
							<cfif isdefined('form.RHIid2') and len(trim(form.RHIid2))NEQ 0>
							,'#form.RHIid2#' as RHIid2
							</cfif> 
							 
						from RHJustificacionMarcasUsuario a
						where   
							a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and RHJMUprocesada =0

							<cfif isdefined('form.DEid2') and len(trim(form.DEid2))NEQ 0>
								and a.DEid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.DEid2#">
							</cfif>
							
							<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
								and a.RHJMUfecha = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSDateFormat(LSParseDateTime(form.RHJMUfecha2), 'yyyy-mm-dd 00:00:00')#">
							</cfif>
							
							<cfif isdefined('form.RHIid2') and len(trim(form.RHIid2))NEQ 0>
								and a.RHJMUsituacion =<cfqueryparam value="#LSParseNumber(LSNumberFormat(form.RHIid2,"_"))#" cfsqltype="cf_sql_integer">
							</cfif>
					</cfquery>
					<!--- Variables de Traduccion --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Fecha"
						Default="Fecha"
						returnvariable="LB_Fecha"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Empleado"
						Default="Empleado"
						returnvariable="LB_Empleado"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Situacion"
						Default="Situación"
						returnvariable="LB_Situacion"/>
					
					<cfinvoke
						Component= "rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaEmpl">
							<cfinvokeargument name="query" value="#rsJustificaciones#"/>
							<cfinvokeargument name="desplegar" value="RHJMUfecha,nombreEmp,RHJMUsituacionx"/>
							<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Empleado#,#LB_Situacion#"/>
							<cfinvokeargument name="formatos" value="D,V,V"/>
							<cfinvokeargument name="align" value="left,left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="justificacionAdelantadaMarca-jefe.cfm"/>
							<cfinvokeargument name="keys" value="RHJMUid"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>	
							<cfinvokeargument name="maxrows" value="5"/> 	
					</cfinvoke>
					
				</td>
				<td>&nbsp; </td>
				<td width="50%" valign="top">
					<!--- Form Justificaciones --->
				 	<cfinclude template="justificacionAdelantadaMarca-jefeForm.cfm">
				</td>
			  </tr>
			  
			  <tr>
			  	<td colspan="3">&nbsp; </td>
			  </tr>
			  
			  <tr  valign="top">
			  	
				<td width="100%" align="center" colspan="3">
					
					<center>
						<table width="90%"  cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top" align="center">
									<div style="border-bottom:double;">
										<strong>
											<cf_translate key="LB_ListaDeJustificacionesQueSeEncuentranEnProceso">
											Lista de Justificaciones que se encuentran en proceso
											</cf_translate>
										</strong>
									</div><!--- Lista de Justificaciones q estan actualmente en un lote --->
								</td>
							</tr>
							
							<tr><td valign="top">
							<cfquery name="rsJustificaciones2" datasource="#session.DSN#">
								select a.RHJMUid, b.RHCMfregistro,b.RHCMhoraentrada, b.RHCMhorasalida, b.RHCMjustificacion,  
									{fn concat(d.DEnombre,{fn concat(' ',{fn concat(d.DEapellido1,{fn concat(' ',d.DEapellido2)})})})} as empleado
								from  RHControlMarcas b, RHJustificacionMarcasUsuario a, DatosEmpleado d
								where a.DEid = b.DEid
									and d.DEid = b.DEid
									and a.RHJMUfecha = b.RHCMfregistro
									and a.RHJMUprocesada = 1
									<cfif isdefined('form.DEid2') and len(trim(form.DEid2))NEQ 0>
									and a.DEid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.DEid2#">
									</cfif>  
							</cfquery>
							<!--- Variables de Traduccion --->
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Fecha"
								Default="Fecha"
								returnvariable="LB_Fecha"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Empleado"
								Default="Empleado"
								returnvariable="LB_Empleado"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_HoraEntrada"
								Default="Hora Entrada"
								returnvariable="LB_HoraEntrada"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_HoraSalida"
								Default="Hora Salida"
								returnvariable="LB_HoraSalida"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Justificacion"
								Default="Justificación"
								returnvariable="LB_Justificacion"/>
							<cfinvoke
								Component= "rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaEmpl">
									<cfinvokeargument name="query" value="#rsJustificaciones2#"/>
									<cfinvokeargument name="desplegar" value="RHCMfregistro,empleado,RHCMhoraentrada, RHCMhorasalida, RHCMjustificacion"/>
									<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Empleado#,#LB_HoraEntrada#,#LB_HoraSalida#,#LB_Justificacion#"/>
									<cfinvokeargument name="formatos" value="D,V,D,D,V"/>
									<cfinvokeargument name="align" value="left,left,left,left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="showLink" value="false"/>
									<cfinvokeargument name="irA" value="justificacionAdelantadaMarca-jefe.cfm"/>
									<cfinvokeargument name="maxrows" value="4"/>
									<cfinvokeargument name="PageIndex" value="2"/>
									<cfinvokeargument name="formname" value="lista2"/>  	
							</cfinvoke>
						</td></tr></table>	
					</center>
				</td>
			  </tr>
			</table>
			<br>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

