<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#">
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
	  <cfset Session.Params.ModoDespliegue = 0>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">		    	            
					<!--- ---> <cfinclude template="/rh/Utiles/consulta-Empleado.cfm">
					<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
						<cfset form.tipo = url.tipo >
					</cfif>

					<cfif isdefined("url.fRHRSdescripcion") and not isdefined("form.fRHRSdescripcion")>
						<cfset form.fRHRSdescripcion = url.fRHRSdescripcion >
					</cfif>
					<cfif isdefined("url.fEmpleado") and not isdefined("form.fEmpleado")>
						<cfset form.fEmpleado = url.fEmpleado >
					</cfif>
					<cfif isdefined("url.fRHRStipo") and not isdefined("form.fRHRStipo")>
						<cfset form.fRHRStipo = url.fRHRStipo >
					</cfif>
					<!--- <cfif isdefined("url.fRHERtipo") and not isdefined("form.fRHERtipo")>
						<cfset form.fRHERtipo = url.fRHERtipo >
					</cfif> --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_EvaluacionesDeGestionDeTalento"
						Default="Evaluaciones de Gesti&oacute;n de talento"
						returnvariable="LB_EvaluacionesDeGestionDeTalento"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DebeSeleccionarAlMenosUnaEvaluacion"
						Default="Debe seleccionar al menos una evaluación"
						returnvariable="MSG_DebeSeleccionarAlMenosUnaEvaluación"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_EstaSeguroQueDeseaFinalizarLaEvaluacion"
						Default="Esta seguro que desea finalizar la evaluación"
						returnvariable="MSG_EstaSeguroQueDeseaFinalizarLaEvaluacion"/>
					
	              	<script language="JavaScript1.2" type="text/javascript">
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
								alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnaEvaluación#</cfoutput>');
								return false;
							}					
						function funcFinalizar(){
							if(algunoMarcado()){
								if (confirm('<cfoutput>#MSG_EstaSeguroQueDeseaFinalizarLaEvaluacion#</cfoutput>')){
									document.lista.action = 'evaluar_des_lista-sql.cfm?tipo=<cfoutput>#form.tipo#</cfoutput>';
									document.lista.submit();
								}
							}
							return false;
						}
		       		</script>

					<cf_web_portlet_start titulo="#LB_EvaluacionesDeGestionDeTalento#">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
							<tr>
								<td>
									<cfoutput>
										<form style="margin:0; " name="filtro" method="post" action="evaluar_des-lista.cfm">
											<table width="100%" cellpadding="0" cellspacing="0" class="tituloListas">
												<tr>
													<td><strong>
													<cf_translate key="LB_Evaluacion" XmlFile="/rh/generales.xml">Evaluaci&oacute;n</cf_translate>
													</strong></td>
													<td>
														<input type="text" name="fRHRSdescripcion" size="20" maxlength="255" 
															value="<cfif isdefined("form.fRHRSdescripcion") and  len(trim(form.fRHRSdescripcion)) >#form.fRHRSdescripcion#</cfif>" 
															onfocus="this.select();">
													</td>
													<td><strong><cf_translate key="LB_Empleado">Empleado</cf_translate></strong></td>
													<td>
														<input type="text" name="fEmpleado" size="30" maxlength="255" 
															value="<cfif isdefined("form.fEmpleado") and  len(trim(form.fEmpleado)) >#form.fEmpleado#</cfif>" 
															onfocus="this.select();" >
													</td>
													<td><strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong></td>
													<td>
														<select name="fRHRStipo">
															<option value="">Todos</option>
															<option value="O" <cfif isdefined("form.fRHRStipo") and trim(form.fRHRStipo) eq 'O'>selected</cfif> >Objetivo</option>
															<option value="C" <cfif isdefined("form.fRHRStipo") and trim(form.fRHRStipo) eq 'C'>selected</cfif> >Comportamiento</option>
															
														</select>
													</td>
													<td align="left" nowrap="nowrap">
														<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Filtrar" Default="Filtrar" XmlFile="/rh/generales.xml" returnvariable="BTN_Filtrar"/>
														<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Limpiar" Default="Limpiar" XmlFile="/rh/generales.xml" returnvariable="BTN_Limpiar"/>
														<input type="submit" class="btnFiltrar" name="Filtrar" value="#BTN_Filtrar#">
														<input type="button" class="btnLimpiar" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();"> 
														<input type="hidden" name="tipo" value="#form.tipo#">
													</td>
												</tr>
											</table>
										</form>
						
										<script language="javascript1.2" type="text/javascript">
											function limpiar(){
												document.filtro.fRHRSdescripcion.value = '';
												document.filtro.fEmpleado.value = '';
												document.filtro.fRHRStipo.value ='';
											}
										</script>
						
									</cfoutput>
								</td>
							</tr>
							<tr>
								<td>					
									<cfset navegacion = '&tipo=#form.tipo#'>
									<cfset Lvar_GetDate = LSDateFormat(Now(),'yyyyMMdd')>
									<cf_dbfunction name="to_datechar" args="a.RHDRfinicio" returnvariable="Lvar_RHDRfinicio">
									<cf_dbfunction name="to_datechar" args="a.RHDRffin" returnvariable="Lvar_RHDRffin">
									<cf_dbfunction name="to_char" args="c.RHRSEid" returnvariable="Lvar_to_char_RHRSEid">
									<cfset filtro = 'a.RHDRestado = 20
												 and ''#Lvar_GetDate#''
												 between #Lvar_RHDRfinicio#  and #Lvar_RHDRffin#'>
									<cfif form.tipo eq 'auto'>
										<cfset filtro = filtro & ' and c.DEid=#rsEmpleado.DEid#'>
									<cfelse>	
										<cfset filtro = filtro & ' and c.DEid!=#rsEmpleado.DEid#'>
									</cfif>
									
									<cfset campos_extra = '' >

									<cfif isdefined("form.fRHRSdescripcion") and len(trim(form.fRHRSdescripcion))>
										<cfset filtro = filtro & " and upper(b.RHRSdescripcion) like  '%#Ucase(form.fRHRSdescripcion)#%' ">
										<cfset campos_extra = campos_extra & ", '#form.fRHRSdescripcion#' as fRHRSdescripcion" >
										<cfset navegacion = navegacion & "&fRHRSdescripcion=#form.fRHRSdescripcion#" >
									</cfif>
									
									<cfif isdefined("form.fEmpleado") and len(trim(form.fEmpleado))>
										<cfset filtro = filtro & 
										" and {fn concat(upper(d.DEnombre),{fn concat(' ',{fn concat(upper(d.DEapellido1),{fn concat(' ',upper(d.DEapellido2))})})})} like '%#Ucase(form.fEmpleado)#%' ">
										<cfset campos_extra = campos_extra & ", '#form.fEmpleado#' as fEmpleado" >
										<cfset navegacion = navegacion & "&fEmpleado=#form.fEmpleado#" >
									</cfif>
			
									<cfif isdefined("form.fRHRStipo") and len(trim(form.fRHRStipo))>
										<cfset filtro = filtro & " and upper(b.RHRStipo) =  '#Ucase(form.fRHRStipo)#' ">
										<cfset campos_extra = campos_extra & ", '#form.fRHRStipo#' as fRHRStipo" >
										<cfset navegacion = navegacion & "&fRHRStipo=#form.fRHRStipo#" >
									</cfif>

									<cfset filtro = filtro &  ' and c.DEideval=#rsEmpleado.DEid#
																and a.RHRSid     = b.RHRSid
																and a.RHDRid     = c.RHDRid
																and c.DEid 		 = d.DEid
																and c.RHRSEestado = 10' >
									<cfset filtro = filtro & ' order by b.RHRStipo,b.RHRSdescripcion,nombre' >							
									<!--- Variables de Traduccion --->
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Evaluacion" Default="Evaluaci&oacute;n" returnvariable="LB_Evaluacion"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo" Default="Tipo" returnvariable="LB_Tipo"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Relacion" Default="Relaci&oacute;n" returnvariable="LB_Relacion"/>	
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_NoSeEncontraronRegistros" Default="No se encontraron Registros" returnvariable="MSG_NoSeEncontraronRegistros"/>	
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Autoevaluacion" Default="Autoevaluación" returnvariable="LB_Autoevaluacion"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Jefe" Default="Jefe" returnvariable="LB_Jefe"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Subordinado" Default="Subordinado" returnvariable="LB_Subordinado"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Companero" Default="Compañero" returnvariable="LB_Companero"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_JefeAlterno" Default="Jefe Alterno" returnvariable="LB_JefeAlterno"/>		
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Comportamiento" Default="Comportamiento" returnvariable="LB_Comportamiento"/>										
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Objetivo" Default="Objetivo" returnvariable="LB_Objetivo"/>
									<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Imprimir" Default="Imprimir" returnvariable="LB_Imprimir"/>
									<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="LB_Editar" Default="Editar" returnvariable="LB_Editar"/>		
										
									<cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaRH"
										returnvariable="pListaCar">
											<!--- and '#Lvar_GetDate#' between x.RHIEfinicio and x.RHIEffin  --->
											<cfinvokeargument name="tabla" value="RHDRelacionSeguimiento a,RHRelacionSeguimiento b,RHRSEvaluaciones c,DatosEmpleado d"/>
											<cfinvokeargument name="columnas" value="c.RHRSEid,
																					b.RHRSdescripcion,
																					{fn concat(d.DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',d.DEapellido2)})})})} as nombre, 
																					{fn concat('<a href=''javascript: reporte(', {fn concat(#Lvar_to_char_RHRSEid#,{fn concat(',',{fn concat('0',');''><img alt=''#LB_Imprimir#''src=''/cfmx/rh/imagenes/findsmall.gif'' border=''0''></a>')})})})} as imprimir,
																					{fn concat('<a href=''javascript: editar(', {fn concat(#Lvar_to_char_RHRSEid#,{fn concat(',',{fn concat('0',');''><img  alt=''#LB_Editar#''src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>')})})})} as editar,
																					case 
																						when b.RHRStipo = 'C' then '#LB_Comportamiento#' 
																						else '#LB_Objetivo#' end as RHRStipo,																					
																					case when b.RHRStipo = 'C' 
																					then
																					
																						 case when (select  count(w.RHERid)    from RHRERespuestas t , RHRespuestas w   where c.RHRSEid = t.RHRSEid and  t.RHERid = w.RHERid) 
																							!=
																						   (select count (y.RHCOid) from RHRERespuestas t ,RHItemEvaluar x,RHComportamiento y where c.RHRSEid = t.RHRSEid and t.RHIEid = x.RHIEid and x.RHHid is not null and x.RHHid = y.RHHid) 
																						 then c.RHRSEid else  null end 
																						 
																					else 
																						 case when (select  count(w.RHERid)    from RHRERespuestas t , RHRespuestas w    where c.RHRSEid = t.RHRSEid and  t.RHERid = w.RHERid) 
																						 !=
																						(select count (x.RHIEid) from RHRERespuestas t , RHItemEvaluar x 
																							where  t.RHRSEid  = c.RHRSEid
																								and t.RHIEid = x.RHIEid 
																								and x.RHOSid is not null 
																								
																								and  x.RHIEid not in (
																										select distinct yy.RHIEid 
																										from RHRERespuestas yy
																										where coalesce(yy.RHIEestado,0) != 0  
																										and yy.RHRSEid in (select 	zz.RHRSEid 
																															from RHDRelacionSeguimiento xx	
																															inner join RHRSEvaluaciones zz 
																																on xx.RHDRid = zz.RHDRid 
																																and zz.DEideval = c.DEideval 
																																and zz.RHRSEestado in( 20,30) 
																																and zz.RHRSEid < t.RHRSEid
																															where xx.RHRSid = a.RHRSid
																														  )
																										 )								
																						
																						
																						)
		
																						 then c.RHRSEid else  null end 
																					end inactivecol,
																					 '#form.tipo#' as tipo #campos_extra#"/>
											<cfinvokeargument name="desplegar" value="RHRSdescripcion, nombre,imprimir,editar"/>
											<cfinvokeargument name="etiquetas" value="#LB_Evaluacion#, #LB_Empleado#,&nbsp;,&nbsp;"/>
											<cfinvokeargument name="formatos" value="V, V, V,V"/>
											<cfinvokeargument name="align" value="left, left ,Center,Center"/>
											<cfinvokeargument name="inactivecol" value="inactivecol"/>
											<cfinvokeargument name="filtro" value="#filtro#"/>
											<cfinvokeargument name="ajustar" value=""/>				
											<cfinvokeargument name="irA" value="evaluar_des.cfm"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="maxRows" value="30"/>
											<cfinvokeargument name="Cortes" value="RHRStipo"/>
											<cfinvokeargument name="checkboxes" value="S"/>
											<cfinvokeargument name="showLink" value="FALSE"/>
											<cfinvokeargument name="keys" value="RHRSEid"/>
											<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
											<cfinvokeargument name="debug" value="n"/>
									</cfinvoke>		
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td align="center">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Finalizar"
										Default="Finalizar"
										returnvariable="BTN_Finalizar"/>
									<input type="button"  class="btnAplicar" name="btnFinalizar" value="<cfoutput>#BTN_Finalizar#</cfoutput>" onClick="javascript: funcFinalizar()">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>	  
		            <cf_web_portlet_end>
     			</td>	
			</tr>
		</table>
        <form action="evaluar_des.cfm" method="post" name="formX">
            <input type="hidden" name="RHRSEid" value="">
            <input type="hidden" name="tipo" value="<cfoutput>#form.tipo#</cfoutput>">
        </form>	
		
<cf_templatefooter>
<script language="javascript" type="text/javascript">

	function reporte(RHRSEid,nada){
		 var PARAM  = "/cfmx/rh/admintalento/evaluacion/evaluacion-respuestas.cfm?RHRSEid="+ RHRSEid+ '&tipo=<cfoutput>#form.tipo#</cfoutput>';
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=500')  
	}
	
	function editar(RHRSEid,nada){
   	    document.formX.RHRSEid.value=RHRSEid;
		document.formX.submit();
	}

</script>	