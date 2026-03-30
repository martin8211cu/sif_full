<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EvaluacionesDeDesempenoPendientes" default="Evaluaciones de Desempe&ntilde;o Pendientes"returnvariable="LB_EvaluacionesDeDesempenoPendientes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnaEvaluacion" default="Debe seleccionar al menos una evaluación" returnvariable="MSG_DebeSeleccionarAlMenosUnaEvaluación" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Puesto" default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeEncontraronRegistros" default="No se encontraron Registros" returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Autoevaluacion" default="Autoevaluación" returnvariable="LB_Autoevaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jefe" default="Jefe" returnvariable="LB_Jefe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Subordinado" default="Colaborador" returnvariable="LB_Subordinado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Companero" default="Compañero" returnvariable="LB_Companero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_JefeAlterno" default="Jefe Alterno" returnvariable="LB_JefeAlterno" component="sif.Componentes.Translate" method="Translate"/>										
<cfinvoke key="BTN_Finalizar" default="Finalizar" returnvariable="BTN_Finalizar" component="sif.Componentes.Translate" method="Translate"/>

<!--- VARIABLES DE TRADUCCION --->
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
					<cfinclude template="/rh/Utiles/consulta-Empleado.cfm">
					<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
						<cfset form.tipo = url.tipo >
					</cfif>
					<cfif isdefined("url.fRelacion") and not isdefined("form.fRelacion")>
						<cfset form.fRelacion = url.fRelacion >
					</cfif>
					<cfif isdefined("url.fPCodigo") and not isdefined("form.fPCodigo")>
						<cfset form.fPCodigo = url.fPCodigo >
					</cfif>
					<cfif isdefined("url.fPDescripcion") and not isdefined("form.fPDescripcion")>
						<cfset form.fPDescripcion = url.fPDescripcion >
					</cfif>
					<cfif isdefined("url.fEmpleado") and not isdefined("form.fEmpleado")>
						<cfset form.fEmpleado = url.fEmpleado >
					</cfif>
					<cfif isdefined("url.fTipoRelacion") and not isdefined("form.fTipoRelacion")>
						<cfset form.fTipoRelacion = url.fTipoRelacion >
					</cfif>
	              	<script language="JavaScript1.2" type="text/javascript">
						function algunoMarcado(){
								var f = document.form2;
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
								document.form2.action = 'evaluar_des_finalizar.cfm?tipo=<cfoutput>#form.tipo#</cfoutput>';
								document.form2.submit();
							}
							return false;
						}
		       		</script>

					<cf_web_portlet_start titulo="#LB_EvaluacionesDeDesempenoPendientes#">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
							<tr>
								<td>
									<cfoutput>
										<form style="margin:0; " name="filtro" method="post" action="evaluar_des-lista.cfm">
											<table width="100%" cellpadding="0" cellspacing="0" class="tituloListas">
												<tr>
													<td><strong><cf_translate key="LB_Relacion">Relaci&oacute;n</cf_translate></strong></td>
													<td>
														<input type="text" name="fRelacion" size="20" maxlength="255" 
															value="<cfif isdefined("form.fRelacion") and  len(trim(form.fRelacion)) >#form.fRelacion#</cfif>" 
															onfocus="this.select();">
													</td>
													<td><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
													<td>
														<input type="text" name="fPCodigo" size="10" maxlength="10" 
															value="<cfif isdefined("form.fPCodigo") and  len(trim(form.fPCodigo)) >#form.fPCodigo#</cfif>" 
															onfocus="this.select();">
													</td>
													<td><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
													<td>
														<input type="text" name="fPDescripcion" size="20" maxlength="255" 
															value="<cfif isdefined("form.fPDescripcion") and  len(trim(form.fPDescripcion)) >#form.fPDescripcion#</cfif>" 
															onfocus="this.select();">
													</td>
													<td><strong><cf_translate key="LB_Empleado">Empleado</cf_translate></strong></td>
													<td>
														<input type="text" name="fEmpleado" size="20" maxlength="255" 
															value="<cfif isdefined("form.fEmpleado") and  len(trim(form.fEmpleado)) >#form.fEmpleado#</cfif>" 
															onfocus="this.select();" >
													</td>
													<td><strong><cf_translate key="LB_Relacion">Relaci&oacute;n</cf_translate></strong></td>
													<td>
														<select name="fTipoRelacion">
															<option value=""><cf_translate key="LB_Todos">Todos</cf_translate></option>
															<option value="J" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'J'>selected</cfif> ><cf_translate key="LB_Jefe">Jefe</cf_translate></option>
															<option value="E" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'E'>selected</cfif> ><cf_translate key="LB_Jefe_Alterno">Jefe Alterno</cf_translate></option>
															<option value="S" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'S'>selected</cfif> ><cf_translate key="LB_Colaborador">Colaborador</cf_translate></option>
															<option value="C" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'C'>selected</cfif> ><cf_translate key="LB_Companero">Compañero</cf_translate></option>
														</select>
													</td>
													<td align="left" nowrap="nowrap">
														<input type="submit" class="btnFiltrar" name="Filtrar" value="#BTN_Filtrar#">
														<input type="button" class="btnLimpiar" name="Limpiar" value="#BTN_Limpiar#" onclick="javascript:limpiar();"> 
														<input type="hidden" class="btnNormal" name="tipo" value="#form.tipo#">
													</td>
												</tr>
											</table>
										</form>
						
										<script language="javascript1.2" type="text/javascript">
											function limpiar(){
												document.filtro.fPCodigo.value = '';
												document.filtro.fPDescripcion.value = '';
												document.filtro.fEmpleado.value = '';
												document.filtro.fTipoRelacion.value =''
											}
										</script>
						
									</cfoutput>
								</td>
							</tr>

							<tr>
								<td>					
									<cfset navegacion = '&tipo=#form.tipo#'>

									<cf_dbfunction name="op_concat" returnvariable="_cat">
									
									<cf_dbfunction name="to_datechar" args="a.RHEEfdesde" returnvariable="Lvar_RHEEfdesde">
									<cf_dbfunction name="to_datechar" args="a.RHEEfhasta" returnvariable="Lvar_RHEEfhasta">
									
									<cf_dbfunction name="to_datechar" args="a1.RHEEfdesde" returnvariable="Lvar_RHEEfdesde2">
									<cf_dbfunction name="to_datechar" args="a1.RHEEfhasta" returnvariable="Lvar_RHEEfhasta2">
									<cf_dbfunction name="to_datechar" args="a3.RHEEfdesde" returnvariable="Lvar_RHEEfdesde3">
									<cf_dbfunction name="to_datechar" args="a3.RHEEfhasta" returnvariable="Lvar_RHEEfhasta3">
									
									<cf_dbfunction name="dateadd" args="1+#Lvar_RHEEfhasta#" delimiters="+" returnvariable="Lvar_RHEEfhasta1">
									<cf_dbfunction name="to_char" args="a.RHEEid" returnvariable="vRHEEid">	
                                    <cf_dbfunction name="to_char" args="b.DEid" returnvariable="vDEid">	
                                	<cf_dbfunction name="to_char" args="coalesce(a.PCid,-1)" returnvariable="vPCid">	
                                    <cf_dbfunction name="to_char" args="c.DEideval" returnvariable="vDEideval">							
									<cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre" returnvariable="nombre">
									<cf_dbfunction name="concat" args="#vDEid# %' '%#vRHEEid#%' '%e.RHPcodigo%' '%#vPCid#%' '%#vDEideval#" returnvariable="inactivecol" delimiters="%">
									<cf_dbfunction name="concat" args="'<a href=''javascript: reporte('%#vRHEEid#%','%#vDEid#%','%#vDEideval#%')''><img src=''/cfmx/rh/imagenes/findsmall.gif'' border=0></a>'" returnvariable="imprimir" delimiters="%">	
									<cf_dbfunction name="concat" args="'<a href=''javascript: editarDoc('%#vRHEEid#%','%#vDEid#%','%#vPCid#%','%#vDEideval#%','%'&quot;'%ltrim(rtrim(e.RHPcodigo))%'&quot;'%');''><img src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>'" returnvariable="editar" delimiters="%">	
			
									<cfset filtro = 'a.Ecodigo=#session.Ecodigo#
												 and e.Ecodigo = a.Ecodigo
												 and a.RHEEestado in (2,5)
												 and getdate() between #Lvar_RHEEfdesde#  and #Lvar_RHEEfhasta#'>
									<cfif form.tipo eq 'auto'>
										<cfset filtro = filtro & ' and c.DEid=#rsEmpleado.DEid# '>
									<cfelse>	
										<cfset filtro = filtro & ' and c.DEid!=#rsEmpleado.DEid# '>
									</cfif>
									
									<cfset campos_extra = '' >
									<cfif isdefined("form.fRelacion") and len(trim(form.fRelacion))>
										<cfset campos_extra = campos_extra & ", '#form.fRelacion#' as fRelacion" >
										<cfset navegacion = navegacion & "&fRelacion=#form.fRelacion#" >
									</cfif>
			
									<cfif isdefined("form.fPCodigo") and len(trim(form.fPCodigo))>
										<cfset filtro = filtro & " and upper(b.RHPcodigo) like  '%#Ucase(form.fPCodigo)#%' ">
										<cfset campos_extra = campos_extra & ", '#form.fPCodigo#' as fPcodigo" >
										<cfset navegacion = navegacion & "&fPCodigo=#form.fPCodigo#" >
									</cfif>

									<cfif isdefined("form.fPDescripcion") and len(trim(form.fPDescripcion))>
										<cfset filtro = filtro & " and upper(e.RHPdescpuesto) like  '%#Ucase(form.fPDescripcion)#%' ">
										<cfset campos_extra = campos_extra & ", '#form.fPDescripcion#' as fPDescripcion" >
										<cfset navegacion = navegacion & "&fPDescripcion=#form.fPDescripcion#" >
									</cfif>
									<cfif isdefined("form.fEmpleado") and len(trim(form.fEmpleado))>
										<cfset filtro = filtro & 
										" and upper(#nombre#) like '%#Ucase(form.fEmpleado)#%' ">
										
										<cfset campos_extra = campos_extra & ", '#form.fEmpleado#' as fEmpleado" >
										<cfset navegacion = navegacion & "&fEmpleado=#form.fEmpleado#" >
									</cfif>
			
									<cfif isdefined("form.fTipoRelacion") and len(trim(form.fTipoRelacion))>
										<cfset filtro = filtro & " and upper(c.RHEDtipo) =  '#Ucase(form.fTipoRelacion)#' ">
										<cfset campos_extra = campos_extra & ", '#form.fTipoRelacion#' as fTipoRelacion" >
										<cfset navegacion = navegacion & "&fTipoRelacion=#form.fTipoRelacion#" >
									</cfif>

									<cfset filtro = filtro &  ' and c.DEideval=#rsEmpleado.DEid#
																and a.RHEEid=b.RHEEid
																and a.RHEEid=c.RHEEid
																and b.RHEEid=c.RHEEid
																and b.DEid=c.DEid
																and b.DEid=d.DEid
																and c.DEid=d.DEid 
																and b.RHPcodigo=e.RHPcodigo 
			
																and a.RHEEid not in (	select PCUreferencia 
																						from PortalCuestionarioU pcu
																						where pcu.PCUestado=10
																						and pcu.PCUreferencia = a.RHEEid
																						and pcu.DEid = b.DEid
																						and pcu.DEideval= #rsEmpleado.DEid#) ' >
																
									<cfset filtro = filtro & ' order by a.RHEEdescripcion, e.RHPdescpuesto, nombre, relacion ' > 					
									<cfset filtro1 = "">
									<cfset filtro2 = "">
									<cfset filtro3 = "">
									<cfif form.tipo eq 'auto'>
										<cfset filtro1 =  '  and c1.DEid=#rsEmpleado.DEid#  and c1.DEideval=#rsEmpleado.DEid# '>
										<cfset filtro2 =  '  and c2.DEid=#rsEmpleado.DEid#  and c2.DEideval=#rsEmpleado.DEid# '>
										<cfset filtro3 =  '  and c3.DEid=#rsEmpleado.DEid#  and c3.DEideval=#rsEmpleado.DEid# '>
									<cfelse>	
										<cfset filtro1 =  '  and c1.DEid!=#rsEmpleado.DEid#  and c1.DEideval=#rsEmpleado.DEid# '>
										<cfset filtro2 =  '  and c2.DEid!=#rsEmpleado.DEid#  and c2.DEideval=#rsEmpleado.DEid# '>
										<cfset filtro3 =  '  and c3.DEid!=#rsEmpleado.DEid#  and c3.DEideval=#rsEmpleado.DEid# '>
									</cfif>
									
									
									

									<cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaRH"
										returnvariable="pListaCar">
											<cfinvokeargument name="tabla" value="RHEEvaluacionDes a, RHListaEvalDes b, RHEvaluadoresDes c, DatosEmpleado d, RHPuestos e "/>
											<cfinvokeargument name="columnas" value="a.RHEEid,
																					 PCid ,
																					 a.RHEEdescripcion,
																					 b.DEid, 
																					 coalesce(e.RHPcodigoext,e.RHPcodigo) as RHPcodigoext,
																					 e.RHPcodigo,
																					 c.DEideval,
																					 RHEEestado, 
																					 e.RHPdescpuesto, 
																					 #nombre# as nombre,
																					 case c.RHEDtipo when 'A' then '#LB_Autoevaluacion#' 
																					 when 'J' then '#LB_Jefe#' 
																					 when 'E' then '#LB_JefeAlterno#' 
																					 when 'S' then '#LB_Subordinado#' 
																					 when 'C' then '#LB_Companero#' end as relacion, 
																					 case when a.PCid  < 0 then
																						 case when 
																							(select 
																								count(pc.PCid)
																								from PortalCuestionario pc 
																								inner join PortalPregunta pp 
																									on pp.PCid= pc.PCid 
																								inner join RHNotasEvalDes RH
																									on RH.PCid = pc.PCid
																								where  pp.PPtipo in ( 'M' , 'O' , 'U' , 'V' )   
																								and    RH.RHEEid = a.RHEEid 
																								and    RH.DEid = b.DEid
																							  ) =
																							  (select 
																								count(r.PCid)
																							  from PortalRespuestaU r 
																						   where  r.PCUid = (select max(PCUid) from PortalCuestionarioU c1 
																												 where c1.Ecodigo= #session.Ecodigo# 
																												 and c1.DEid = d.DEid
																												 and c1.PCUreferencia  =  a.RHEEid ) ) then    
																							null 
																						else 
																							#inactivecol#
																						end 
																					 else
																					 
																						 case when 
																							(select 
																								count(pc.PCid)
																								from PortalCuestionario pc 
																								inner join PortalPregunta pp 
																									on pp.PCid= pc.PCid 
																								where  pp.PPtipo in ( 'M' , 'O' , 'U' , 'V' )   
																								and    pc.PCid  = a.PCid 
																							  ) =
																							  (select 
																								count(r.PCid)
																							  from PortalRespuestaU r 
																							   where  r.PCUid = (select max(PCUid) from PortalCuestionarioU c1 
																												 where c1.Ecodigo= #session.Ecodigo# 
																												   and c1.DEid = b.DEid
																												 #filtro1# 
																												 and c1.PCUreferencia  =  a.RHEEid ) ) then    
																							null 
																						else 
																							#inactivecol# 
																						end 
																						 
																					 
																					 end
																					 
																					  as inactivecol,
																																										
                                                                                     
																					 case when c.RHEDtipo in ('A','E','J','S','C') then 
																					 	#imprimir#
                                                                                     else '' end
                                                                                     as imprimir,
                                                                                     #editar# as editar, 
 																					 c.RHEDtipo, '#form.tipo#' as tipo #campos_extra#"/>
											<cfinvokeargument name="desplegar" value="RHPcodigoext, RHPdescpuesto, nombre, relacion,imprimir,editar"/>
											<cfinvokeargument name="etiquetas" value="#LB_Puesto#, #LB_Descripcion#, #LB_Empleado#, #LB_Tipo#,&nbsp;,&nbsp;"/>
											<cfinvokeargument name="formatos" value="V, V, V, V,V,V"/>
											<cfinvokeargument name="filtro" value="#filtro#"/>
											<cfinvokeargument name="align" value="left, left, left, left, left, left"/>
											<cfinvokeargument name="ajustar" value=""/>				
											<cfinvokeargument name="irA" value="evaluar_des.cfm"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="maxRows" value="30"/>
											<cfinvokeargument name="Cortes" value="RHEEdescripcion"/>
											<cfinvokeargument name="checkboxes" value="S"/>
                                            <cfinvokeargument name="showLink" value="FALSE"/>
											<cfinvokeargument name="keys" value="DEid,RHEEid,RHPcodigo,PCid,DEideval"/>
											<cfinvokeargument name="formName" value="form2"/>
											<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
											<cfinvokeargument name="debug" value="n"/>
                                            <cfinvokeargument name="inactivecol" value="inactivecol"/>
									</cfinvoke>		
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td align="center"><input type="button" class="btnAplicar" name="btnFinalizar" value="<cfoutput>#BTN_Finalizar#</cfoutput>" onclick="javascript: funcFinalizar()"></td></tr>
							<tr><td>&nbsp;</td></tr>
						</table>	  
		            <cf_web_portlet_end>
     			</td>	
			</tr>
		</table>
        <form action="evaluar_des.cfm" method="post" name="formX">
            <input type="hidden" name="DEid" value="">
            <input type="hidden" name="RHEEid" value="">
            <input type="hidden" name="RHPcodigo" value="">
            <input type="hidden" name="PCid" value="">
            <input type="hidden" name="DEideval" value="">
            <input type="hidden" name="tipo" value="<cfoutput>#form.tipo#</cfoutput>">
        </form>	
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function reporte(RHEEid,DEid, DEideval){
		
		<cfif form.tipo eq 'auto'>
			 var PARAM  = "/cfmx/rh/evaluaciondes/consultas/evaluacion-respuestas.cfm?Cual=A&RHEEid="+ RHEEid + "&DEid=" + DEid+ "&DEidEval=" + DEideval
		<cfelseif form.tipo eq 'otros'>
			 var PARAM  = "/cfmx/rh/evaluaciondes/consultas/evaluacion-respuestas.cfm?Cual=O&RHEEid="+ RHEEid + "&DEid=" + DEid+ "&DEidEval=" + DEideval
		<cfelse>
			 var PARAM  = "/cfmx/rh/evaluaciondes/consultas/evaluacion-respuestas.cfm?Cual=J&RHEEid="+ RHEEid + "&DEid=" + DEid+ "&DEidEval=" + DEideval
		</cfif> 
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')  
	}
	
	function editarDoc(RHEEid,DEid,PCid,DEideval,RHPcodigo){
		document.formX.DEid.value=DEid;
		document.formX.RHEEid.value=RHEEid;
		document.formX.RHPcodigo.value=RHPcodigo;
		document.formX.PCid.value=PCid;
		 document.formX.DEideval.value=DEideval; 
		document.formX.submit();
	}
</script>	