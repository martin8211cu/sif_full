
<!--- <cfdump var="#form#">
<cfdump var="#url#">  --->
<script>
function Limpiar(){
	document.form2.RHJMUfecha2.value='';
	<!--- document.form2.RHIid2.options[0].selected=true; --->
}
</script>
<!--- form1 --->
<cfif isdefined("url.RHJMUfecha") and len(trim(url.RHJMUfecha))NEQ 0>
	<cfset form.RHJMUfecha = url.RHJMUfecha>
</cfif> 

<cfif isdefined("url.RHIid") and len(trim(url.RHIid))NEQ 0>
	<cfset form.RHIid = url.RHIid>
</cfif>

<!--- form2 --->
<cfif isdefined("url.RHJMUfecha2") and len(trim(url.RHJMUfecha2))NEQ 0>
	<cfset form.RHJMUfecha2 = url.RHJMUfecha2>
</cfif> 

<cfif isdefined("url.RHIid2") and len(trim(url.RHIid2))NEQ 0>
	<cfset form.RHIid2 = url.RHIid2>
</cfif>

<!--- navegacion --->
<cfset navegacion = "">
<cfif isdefined("form.RHJMUfecha2")>
	<cfset navegacion = navegacion & "RHJMUfecha2="& form.RHJMUfecha2>	
</cfif>
<cfif isdefined("form.RHIid2")>
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
					
					<form name="form2" action="justificacionAdelantadaMarca.cfm" method="post">
						<table width="100%" class="tituloListas" cellpadding="0">
							<tr valign="top">
								<td width="23%"  class="fileLabel" align="left"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
								<td width="66%"  class="fileLabel" align="left"><cf_translate key="LB_Situacion">Situación</cf_translate></td>
								<td  rowspan="2" valign="middle" nowrap="nowrap">
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
										<cfinvokeargument name="index" value="2"/>
										
										<cfif isdefined("form.RHIid2") and len(trim(form.RHIid2))neq 0>
											<cfinvokeargument name="RHIid" value="#form.RHIid2#"/>	
										</cfif>	
											
									</cfinvoke>	
								</td>
								
							</tr>
						</table>
					</form>
					<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
					<cfset UsuDEid = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'DatosEmpleado')>
					<cfquery name="rsJustificaciones" datasource="#session.DSN#">
						select 
							RHJMUid,
							DEid,
							Ecodigo,
							RHJMUsituacion,
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
							RHJMUfecha,
							case RHJMUjustificacion
							when null then ''
							else RHJMUjustificacion end as RHJMUjustificacion,
							RHJMUprocesada
							
							<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
							,'#form.RHJMUfecha2#' as RHJMUfecha2
							</cfif>
							
							<cfif isdefined('form.RHIid2') and len(trim(form.RHIid2))NEQ 0>
							,'#form.RHIid2#' as RHIid2
							</cfif> 
							 
						from RHJustificacionMarcasUsuario 
						where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UsuDEid.llave#"> 
							and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and RHJMUprocesada =0

							<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
								and RHJMUfecha = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSDateFormat(LSParseDateTime(form.RHJMUfecha2), 'yyyy-mm-dd 00:00:00')#">
							</cfif>
							<cfif isdefined('form.RHIid2') and len(trim(form.RHIid2))NEQ 0>
								and RHJMUsituacion =<cfqueryparam value="#LSParseNumber(LSNumberFormat(form.RHIid2,"_"))#" cfsqltype="cf_sql_integer">
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
						Key="LB_Situacion"
						Default="Situaci&oacute;n"
						returnvariable="LB_Situacion"/>

					<cfinvoke
						Component= "rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaEmpl">
							<cfinvokeargument name="query" value="#rsJustificaciones#"/>
							<cfinvokeargument name="desplegar" value="RHJMUfecha,RHJMUsituacionx"/>
							<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Situacion#"/>
							<cfinvokeargument name="formatos" value="D,V"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="justificacionAdelantadaMarca.cfm"/>
							<cfinvokeargument name="keys" value="RHJMUid"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>	
							<cfinvokeargument name="maxrows" value="5"/>								
					</cfinvoke>
					
				</td>
				<td width="50%" valign="top">
					<!--- Form Justificaciones --->
				 	<cfinclude template="justificacionAdelantadaMarca-form.cfm">
				</td>
			  </tr>
			  
			  <tr>
			  	<td>&nbsp; </td>
			  </tr>
			  
			  <tr  valign="top"  style=" border-top-color:#CCCCCC" >
			  	
				<td width="100%" align="center" colspan="2">
					
					<center>
						 <table width="70%">
						 	<tr>
						 		<td valign="top" align="center">
									<div style="border-bottom:double;">
										<strong><cf_translate key="LB_ListaDeJustificacionesQueSeEncuentranEnProceso">Lista de Justificaciones que se encuentran en proceso</cf_translate></strong>
									</div><!--- Lista de Justificaciones q estan actualmente en un lote --->
								 </td>
							</tr>
						 	<tr>
								<td valign="top">
									<cfquery name="rsJustificaciones2" datasource="#session.DSN#">
										select a.RHJMUid, b.RHCMfregistro,b.RHCMhoraentrada, b.RHCMhorasalida, b.RHCMjustificacion  
										from  RHControlMarcas b, RHJustificacionMarcasUsuario a
											where a.DEid = b.DEid
											and a.RHJMUfecha = b.RHCMfregistro
											and a.RHJMUprocesada = 1
											and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UsuDEid.llave#">  
									</cfquery>
								<!--- Variables de Traduccion --->
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Fecha"
									Default="Fecha"
									returnvariable="LB_Fecha"/>
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
									<cfinvokeargument name="desplegar" value="RHCMfregistro,RHCMhoraentrada, RHCMhorasalida,RHCMjustificacion"/>
									<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_HoraEntrada#,#LB_HoraSalida#,#LB_Justificacion#"/>
									<cfinvokeargument name="formatos" value="D,D,D,V"/>
									<cfinvokeargument name="align" value="left,left,left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="showLink" value="false"/>
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

