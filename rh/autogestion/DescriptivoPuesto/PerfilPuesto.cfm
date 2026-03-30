<!--- <cfdump  var="#Form#"> --->


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">

<cfif isdefined("Url.RHDPPid") and not isdefined("Form.RHDPPid")>
	<cfparam name="Form.RHDPPid" default="#Url.RHDPPid#">
</cfif>

<cfif isdefined("Url.USUARIO") and not isdefined("Form.USUARIO")>
	<cfparam name="Form.USUARIO" default="#Url.USUARIO#">
</cfif>

<!--- 1er paso 
	lo que tenemos que hacer es verificar si ya existe una proceso de modificación del descriptivo
	si este existe y aun se encuentra en proceso de edición puede ser editado por otro usuario.
	en caso de que no exista se creará un nuevo proceso con el usuario que lo invoco.
--->
<cfif isdefined("Form.RHDPPid") and Form.RHDPPid eq -1>
	<cflocation url="SQLPerfilPuesto.cfm?RHPcodigo=#form.RHPcodigo#&btnNuevo=btnNuevo&USUARIO=#form.USUARIO#">
<cfelseif isdefined("form.RHDPPid") and len(trim(form.RHDPPid))>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SinAsignar"
	Default="Sin asignar"
	returnvariable="LB_SinAsignar"/>
	
	<cfquery name="data" datasource="#session.DSN#">
		select a.RHPcodigo, coalesce(a.RHPcodigoext,'#LB_SinAsignar#') as RHPcodigoext , a.RHPdescpuesto ,
		case when a.CFid is not null then
			{fn concat(CFcodigo,{fn concat('-',CFdescripcion)})}
		else	
			'#LB_SinAsignar#'
		end	 as centrofuncional,coalesce(a.CFid,-1) as CFid
		from RHPuestos a
		inner join RHDescripPuestoP x
			on a.RHPcodigo = x.RHPcodigo
			and a.Ecodigo = x.Ecodigo
			and x.RHDPPid = <cfqueryparam value="#form.RHDPPid#" cfsqltype="cf_sql_numeric">
		left outer join CFuncional b
			on a.CFid = b.CFid
			and  a.Ecodigo = b.Ecodigo
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfquery name="rsForm" datasource="#session.DSN#">
	select Observaciones,RHDPmision,RHDPobjetivos,RHDPPid,RHPcodigo
	from RHDescripPuestoP
	where RHDPPid = <cfqueryparam value="#form.RHDPPid#" cfsqltype="cf_sql_numeric">
	and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

		<script language="JavaScript" type="text/JavaScript">
		<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		//-->
		</script>

		<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr> 
				<td valign="top"> 
					<cfif form.USUARIO eq 'ASESOR'>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_PerfilIdealDelPuesto"
						Default="Perfil ideal del puesto"
						returnvariable="LB_PerfilIdealDelPuesto"/>
					<cfelse>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_AprobarPerfilIdealDelPuesto"
						Default="Aprobar perfil ideal de puesto"
						returnvariable="LB_PerfilIdealDelPuesto"/>
					</cfif>
						
						
					<cf_web_portlet_start border="true" titulo="#LB_PerfilIdealDelPuesto#" skin="#Session.Preferences.Skin#">
						<cfif isdefined("Url.codigoFiltro") and not isdefined("Form.codigoFiltro")>
							<cfparam name="Form.codigoFiltro" default="#Url.codigoFiltro#">
						</cfif>
						<cfif isdefined("Url.descripcionFiltro") and not isdefined("Form.descripcionFiltro")>
							<cfparam name="Form.descripcionFiltro" default="#Url.descripcionFiltro#">
						</cfif>	
						<cfif isdefined("Url.UsuarioFiltro") and not isdefined("Form.UsuarioFiltro")>
							<cfparam name="Form.UsuarioFiltro" default="#Url.UsuarioFiltro#">
						</cfif>								
						<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
							<cfparam name="Form.filtrado" default="#Url.filtrado#">
						</cfif>	
						<cfif isdefined("Url.USUARIO") and not isdefined("Form.USUARIO")>
							<cfparam name="Form.USUARIO" default="#Url.USUARIO#">
						</cfif>	
						
						<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
							<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
						</cfif>
						<cfif isdefined("Url.RHDPPid") and not isdefined("Form.RHDPPid")>
							<cfparam name="Form.RHDPPid" default="#Url.RHDPPid#">
						</cfif>
						<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
							<cfparam name="Form.sel" default="#Url.sel#">
						</cfif>
						<cfif not isdefined("Url.sel") and not isdefined("Form.sel")>
							<cfparam name="Form.sel" default="1">
						</cfif>
						
						<cfif isdefined("Url.o") and not isdefined("Form.o")>
							<cfparam name="Form.o" default="#Url.o#">
						</cfif>
						
						<cfif not isdefined("Url.o") and not isdefined("Form.o")>
							<cfparam name="Form.o" default="1">
						</cfif>
						
						<cfif isdefined("Form.o")>
							<cfset tabChoice = Val(Form.o)>
						</cfif>
						
						
						<cfset filtro = "">
						<cfset navegacion = "">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
						<cfif isdefined("Form.RHPcodigo")>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & #form.RHPcodigo#>				
						</cfif>
						<cfif isdefined("Form.codigoFiltro") and Len(Trim(Form.codigoFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(RHPcodigo) like '%" & #UCase(Form.codigoFiltro)# & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "codigoFiltro=" & Form.codigoFiltro>
						</cfif>
						<cfif isdefined("Form.UsuarioFiltro") and Len(Trim(Form.UsuarioFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(coalesce(c.Usulogin,'"&UCase(Form.UsuarioFiltro) &"'))  like '%" & UCase(Form.UsuarioFiltro) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "UsuarioFiltro=" & Form.UsuarioFiltro>
						</cfif>						
						<cfif isdefined("Form.descripcionFiltro") and Len(Trim(Form.descripcionFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(RHPdescpuesto)  like '%" & UCase(Form.descripcionFiltro) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcionFiltro=" & Form.descripcionFiltro>
						</cfif>
						<cfif isdefined("Form.sel") and form.sel NEQ 1>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
						</cfif>
						<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
								</td>
							</tr>	  
							<tr style="display: ;" id="verPagina"> 
						  <tr>
								<td bgcolor="#A0BAD3" >
									<cfinclude template="frame-botones.cfm">
								</td>
						  </tr>								
								
								<td> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td style="padding-left:20px;">
												<cfif isdefined("form.RHDPPid") and len(trim(form.RHDPPid))>
													<fieldset><legend><cf_translate key="LB_InformacionGeneralDelPuesto" >Informaci&oacute;n general del puesto</cf_translate></legend>
												  <table width="100%" border="0">
														  <tr>
														  	<td>&nbsp;															</td>
														  </tr>	
														  <tr>
															
															<td width="15%">
																<b><cf_translate key="LB_CodigoExterno" >C&oacute;digo Externo</cf_translate></b>														
															</td>
															<td width="15%" nowrap>
																<b>
															  <cf_translate key="LB_Codigo" >C&oacute;digo</cf_translate></b>															
															</td>
															<td width="35%" nowrap>
																<b><cf_translate key="LB_Descripcion" >Descripci&oacute;n</cf_translate></b>														
															</td>
															<td width="35%" nowrap>
																<b>
															  <cf_translate key="LB_CentroFuncional" >Centro Funcional</cf_translate></b>															
															</td>
														  </tr>
														  <tr>
															<td >
																<font color="navy"><cfoutput>#data.RHPcodigoext#</cfoutput></font>															
															</td>
															<td >
																<font color="navy"><cfoutput>#data.RHPcodigo#</cfoutput></font>															
															</td>
															<td nowrap="nowrap">
																<font color="navy"><cfoutput>#data.RHPdescpuesto#</cfoutput></font>															
															</td>
															<td nowrap="nowrap">
																<font color="navy"><cfoutput>#data.centrofuncional#</cfoutput></font>
															</td>
														  </tr>
													</table>
													
													</fieldset>
												</cfif>
											</td>
										</tr>
										<tr> 
										 <td align="left" colspan="2">
											<fieldset><legend><cf_translate key="LB_Observaciones" >Observaciones</cf_translate></legend>
												<table width="100%" border="0">
													<tr>
														<td width="45%">
															<form name="formObservacion" method="post" action="SQLPerfilPuesto.cfm">
																<textarea tabindex="1" 	name="Observaciones" cols="80" rows="5"><cfif isdefined('rsForm.Observaciones') and len(trim(rsForm.Observaciones)) gt 0><cfoutput>#rsForm.Observaciones#</cfoutput></cfif></textarea>
																<input type="hidden" 	name="RHDPPid" 		id="RHDPPid" value="<cfoutput>#Trim(rsForm.RHDPPid)#</cfoutput>">
																<input type="hidden" 	name="Boton" 	        id="Boton" value="">
																<cfoutput>
																<input name="USUARIO" 	type="hidden" value="#FORM.USUARIO#">
																<input name="sel"    	type="hidden" value="#FORM.sel#">
																<input name="o" 	 	type="hidden" value="#FORM.o#">
																</cfoutput>

															</form>
														</td>
														<td valign="top">
															<cfinclude template="formPuestos-mensajeria.cfm">
														</td>
													</tr>
												</table>
											</fieldset>
										  </td>
										</tr>										
										<tr>
										<cfinclude template="formPuestos-header.cfm">
										<td>
											<table width="100%" border="0">
												<tr>
													<td>
														<cf_tabs width="100%">
															<cf_tab text=#tabNames[1]#   selected="#tabChoice eq 1#">
																<cfif tabChoice eq 1>
																	<cfinclude template="formPuestos-frmision.cfm">
																</cfif>
															</cf_tab>
															<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
																<cfif tabChoice eq 2>
																	<cfinclude template="formPuestos-frespecificaciones.cfm">
																</cfif>
															</cf_tab>
															<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
																<cfif tabChoice eq 3>
																	<cfinclude template="formPuestos-frhabilidades.cfm">
																</cfif>
															</cf_tab>
															<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
																<cfif tabChoice eq 4>
																	<cfinclude template="formPuestos-frconocimientos.cfm">
																</cfif>
															</cf_tab>
															<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5#">
																<cfif tabChoice eq 5>
																	<cfinclude template="formPuestos-frvalores.cfm">
																</cfif>
															</cf_tab>
														</cf_tabs>	
								  					</td>
												</tr>
											  </table>
										  </td>
									  </tr>
									</table>
					  			</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
						<script type="text/javascript">
						<!--
							function tab_set_current (n){
							<cfif form.USUARIO eq 'ASESOR'>
								validaDEid(escape(n),'PerfilPuesto.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
							<cfelse>
								validaDEid(escape(n),'ApruebaPerfilPuesto.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
							</cfif>
							}
						//-->
						</script>	
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="ALT_Mantenimientos"
						Default="Mantenimientos"
						returnvariable="ALT_Mantenimientos"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="ALT_ListaDePuestos"
						Default="Lista de puestos"
						returnvariable="ALT_ListaDePuestos"/>

						<script language="JavaScript" type="text/javascript">
							var Bandera = "L";
							function buscar(){
								<cfif form.USUARIO eq 'ASESOR'>
									location.href = '/cfmx/rh/autogestion/DescriptivoPuesto/Puestos-lista.cfm';
								<cfelse>
									location.href = '/cfmx/rh/autogestion/DescriptivoPuesto/ApruebaPuestos-lista.cfm';
								</cfif>
									
							}				
							<cfif isdefined("form.RHPcodigo")>
								function reporte(){
									<cfoutput>
										location.href="PuestosReport.cfm?RHPcodigo=#Trim(form.RHPcodigo)#&Regresar=Puestos.cfm?RHPcodigo=#Trim(form.RHPcodigo)#&o=1&sel=1";
									</cfoutput>
								}
							</cfif>
							
							
							
							
						</script>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>