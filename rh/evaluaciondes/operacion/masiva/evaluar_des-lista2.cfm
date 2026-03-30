<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluaciones_del_Desempeno_a_Otro_Grupal" default="Evaluaciones del Desempe&ntilde;o a Otro (Grupal)" returnvariable="LB_Evaluaciones_del_Desempeno_a_Otro_Grupal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnaEvaluacion" default="Debe seleccionar al menos una evaluaci&oacute;n" returnvariable="MSG_DebeSeleccionarAlMenosUnaEvaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluacion_por_habilidad" default="Evaluaci&oacute;n por habilidad :" returnvariable="LB_Evaluacion_por_habilidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluacion_por_habilidad_conocimientos" default="Evaluaci&oacute;n por habilidad y conocimientos:" returnvariable="LB_Evaluacion_por_habilidad_conocimientos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluacion_por_conocimientos" default="Evaluaci&oacute;n por conocimientos:" returnvariable="LB_Evaluacion_por_conocimientos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluacion_por_cuestionario" default="Evaluaci&oacute;n por cuestionario :" returnvariable="LB_Evaluacion_por_cuestionario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Puesto" default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeEncontraronRegistros" default="No se encontraron Registros" returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Autoevaluacion" default="Autoevaluación" returnvariable="LB_Autoevaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jefe" default="Jefe" returnvariable="LB_Jefe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Subordinado" default="Colaborador"returnvariable="LB_Subordinado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Companero" default="Compañero" returnvariable="LB_Companero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_JefeAlterno" default="Jefe Alterno" returnvariable="LB_JefeAlterno" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_EnProceso" default="En proceso" returnvariable="LB_EnProceso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SinEvaluar" default="Sin Evaluar" returnvariable="LB_SinEvaluar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Estado" default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_SinEvaluar" default="Sin evaluar" returnvariable="LB_SinEvaluar" component="sif.Componentes.Translate" method="Translate"/>   
<cfinvoke key="LB_EvaluacionCompleta" default="Evaluaci&oacute;n completa"returnvariable="LB_EvaluacionCompleta" component="sif.Componentes.Translate" method="Translate"/>       	
<cfinvoke key="LB_mensaje" default="Si alguna evaluaci&oacute;n marcada para finalizar no se encuentra completada no sera tomada en cuenta." returnvariable="LB_mensaje" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Finalizar" default="Finalizar" returnvariable="BTN_Finalizar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Evaluar" default="Evaluar" returnvariable="BTN_Evaluar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate"method="Translate"/>		

<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
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
					<cfif isdefined("url.RHEEid") and not isdefined("form.RHEEid")>
						<cfset form.RHEEid = url.RHEEid >
					</cfif>
                    <cfif isdefined("url.PCid") and not isdefined("form.PCid")>
						<cfset form.PCid = url.PCid >
					</cfif>
                    
					<cfif isdefined("url.fEmpleado") and not isdefined("form.fEmpleado")>
						<cfset form.fEmpleado = url.fEmpleado >
					</cfif>
					<cfif isdefined("url.fTipoRelacion") and not isdefined("form.fTipoRelacion")>
						<cfset form.fTipoRelacion = url.fTipoRelacion >
					</cfif>
					<cfif isdefined("url.fRHPcodigo") and not isdefined("form.fRHPcodigo")>
						<cfset form.fRHPcodigo = url.fRHPcodigo >
					</cfif>
						
					<cfquery datasource="#session.dsn#"  name="Rs_Evaluacion">
						select 
						case PCid 
							 when -2 then {fn concat('#LB_Evaluacion_por_habilidad_conocimientos#',{fn concat(' ',RHEEdescripcion)})}
						 	 when -1 then {fn concat('#LB_Evaluacion_por_habilidad#',{fn concat(' ',RHEEdescripcion)})}
							 when  0 then {fn concat('#LB_Evaluacion_por_conocimientos#',{fn concat(' ',RHEEdescripcion)})}
							 else {fn concat('#LB_Evaluacion_por_cuestionario#',{fn concat(' ',RHEEdescripcion)})}
						end as  RHEEdescripcion
						from RHEEvaluacionDes where RHEEid =#form.RHEEid#
					</cfquery>	
					<cf_web_portlet_start titulo="#LB_Evaluaciones_del_Desempeno_a_Otro_Grupal#">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
							<tr>
								<td>
									<cfoutput>
										<form style="margin:0; " name="filtro" method="post" action="evaluar_des-lista2.cfm">
                                        <cfquery datasource="#session.dsn#"  name="Rs_Puestos">
                                            select   distinct coalesce(e.RHPcodigoext,e.RHPcodigo) as RHPcodigoext, e.RHPcodigo, RHPdescpuesto
                                            from RHEEvaluacionDes a, RHListaEvalDes b,RHPuestos e
                                            where  a.Ecodigo=#session.Ecodigo#
                                            and a.RHEEid =#form.RHEEid#
                                            and a.RHEEid=b.RHEEid
                                            and b.RHPcodigo=e.RHPcodigo 	
                                            order by RHPdescpuesto
                                        </cfquery>	
                                            <table width="100%" cellpadding="0" cellspacing="0" class="tituloListas">
												<tr><td colspan="7"><strong>#Rs_Evaluacion.RHEEdescripcion#</strong></td></tr> 
                                                <tr><td colspan="7">&nbsp;</td></tr>
                                                <tr>
													<td><strong><cf_translate key="LB_Empleado">Empleado</cf_translate></strong></td>
													<td>
														<input type="text" name="fEmpleado" size="30" maxlength="255" 
															value="<cfif isdefined("form.fEmpleado") and  len(trim(form.fEmpleado)) >#form.fEmpleado#</cfif>" 
															onfocus="this.select();" >
													</td>
                                                    <td><strong><cf_translate key="LB_Relacion">Puestos</cf_translate></strong></td>
													<td>
                                                        <select name="fRHPcodigo">
															<option value="">Todos</option>
                                                                <cfloop query="Rs_Puestos">
                                                                    <option value="#Rs_Puestos.RHPcodigo#" <cfif isdefined("form.fRHPcodigo") and trim(form.fRHPcodigo) eq trim(Rs_Puestos.RHPcodigo) >selected</cfif> >#Rs_Puestos.RHPcodigoext#-#Rs_Puestos.RHPdescpuesto#</option>
                                                                </cfloop>
														</select>
													</td>
													<td><strong><cf_translate key="LB_Relacion">Relaci&oacute;n</cf_translate></strong></td>
													<td>
														<select name="fTipoRelacion">
															<option value="">Todos</option>
															<option value="J" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'J'>selected</cfif> >Jefe</option>
															<option value="E" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'E'>selected</cfif> >Jefe Alterno</option>
															<option value="S" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'S'>selected</cfif> >Subordinado</option>
															<option value="C" <cfif isdefined("form.fTipoRelacion") and trim(form.fTipoRelacion) eq 'C'>selected</cfif> >Compa&ntilde;ero</option>
															
														</select>
													</td>
													<td align="left" nowrap="nowrap">
														<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
														<input type="button" name="Limpiar" value="#BTN_Limpiar#" onclick="javascript:limpiar();"> 
														<input type="hidden" name="RHEEid" value="#form.RHEEid#">
                                                        <input type="hidden" name="PCID" value="#form.PCID#">
													</td>
												</tr>
                                                <tr>
													<td colspan="6">
														<input name="chkTodos" type="checkbox" value="" border="0" onclick="javascript:Marcar(this);" style="background:background-color ">
                                                		<label for="chkTodos">Seleccionar Todos</label>
	                                                </td>
                                                </tr>
											</table>
										</form>
									</cfoutput>
								</td>
							</tr>
							<tr>
								<td>					
									<cfset navegacion = ''>
                                    <cfif isdefined("form.PCID") and len(trim(form.PCID))>
										<cfset navegacion = navegacion & "&PCID=#form.PCID#" >
									</cfif>
									<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid))>
										<cfset navegacion = navegacion & "&RHEEid=#form.RHEEid#" >
									</cfif>
                                    
									<cf_dbfunction name="to_datechar" args="'#LSDateFormat(Now(),'dd-mm-yyyy')#'" returnvariable="Lvar_GetDate">
									<cf_dbfunction name="to_datechar" args="a.RHEEfdesde" returnvariable="Lvar_RHEEfdesde">
									<cf_dbfunction name="to_datechar" args="a.RHEEfhasta" returnvariable="Lvar_RHEEfhasta">
							
									<cf_dbfunction name="to_datechar" args="a1.RHEEfdesde" returnvariable="Lvar_RHEEfdesde2">
									<cf_dbfunction name="to_datechar" args="a1.RHEEfhasta" returnvariable="Lvar_RHEEfhasta2">
									<cf_dbfunction name="to_datechar" args="a3.RHEEfdesde" returnvariable="Lvar_RHEEfdesde3">
									<cf_dbfunction name="to_datechar" args="a3.RHEEfhasta" returnvariable="Lvar_RHEEfhasta3">
									
									<cf_dbfunction name="dateadd" args="1|#Lvar_RHEEfhasta#" delimiters="|" returnvariable="Lvar_RHEEfhasta1">
									<cf_dbfunction name="to_char" args="a.RHEEid" returnvariable="vRHEEid">	
                                    <cf_dbfunction name="to_char" args="b.DEid" returnvariable="vDEid">	
                                	<cf_dbfunction name="to_char" args="coalesce(a.PCid,-1)" returnvariable="vPCid">	
                                    <cf_dbfunction name="to_char" args="c.DEideval" returnvariable="vDEideval">							
									<cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre" returnvariable="nombre">
									<cf_dbfunction name="concat" args="#vDEid# % '|' %#vRHEEid#%'|'%e.RHPcodigo%'|'%#vPCid#%'|'%#vDEideval#" returnvariable="inactivecol" delimiters="%">
									<cf_dbfunction name="concat" args="'<a href=''javascript: reporte('|#vRHEEid#|','|#vDEid#|')''><img src=''/cfmx/rh/imagenes/findsmall.gif'' border=0></a>'" returnvariable="imprimir" delimiters="|">	
									<cf_dbfunction name="concat" args="'<a href=''javascript: editarDoc('|#vRHEEid#|','|#vDEid#|','|#vPCid#|','|#vDEideval#|','|'&quot;'|ltrim(rtrim(e.RHPcodigo))|'&quot;'|');''><img src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>'" returnvariable="editar" delimiters="|">	

									 <cf_dbfunction name="to_char" args="a.RHEEid" returnvariable="vRHEEid">	
                                     <cf_dbfunction name="to_char" args="b.DEid" returnvariable="vDEid">								
									
									
									<cfset filtro = 'a.Ecodigo=#session.Ecodigo#
												 and e.Ecodigo = a.Ecodigo
												 and a.RHEEestado in (2,5)
												 and a.RHEEid =#form.RHEEid#
												 and getdate() 
												 between #Lvar_RHEEfdesde#  and #Lvar_RHEEfhasta#'>
									<cfset filtro = filtro & ' and c.DEid!=#rsEmpleado.DEid# '>
									<cfset filtro1 =  '  on c1.DEid!=#rsEmpleado.DEid#  and c1.DEideval=#rsEmpleado.DEid# '>
									<cfset filtrox =  '  and c1.DEid!=#rsEmpleado.DEid#  and c1.DEideval=#rsEmpleado.DEid# '>
									<cfset filtro2 =  '  on c2.DEid!=#rsEmpleado.DEid#  and c2.DEideval=#rsEmpleado.DEid# '>
									<cfset filtro3 =  ' and c3.DEid!=#rsEmpleado.DEid#  and c3.DEideval=#rsEmpleado.DEid# '>
									
									<cfset campos_extra = '' >
									<cfif isdefined("form.fRelacion") and len(trim(form.fRelacion))>
										<cfset filtro = filtro & " and upper(a.RHEEdescripcion) like  '%#Ucase(form.fRelacion)#%' ">
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
			
									<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo))>
										<cfset filtro = filtro & " and upper(e.RHPcodigo) =  '#Ucase(form.fRHPcodigo)#' ">
										<cfset campos_extra = campos_extra & ", '#form.fRHPcodigo#' as fRHPcodigo" >
										<cfset navegacion = navegacion & "&fRHPcodigo=#form.fRHPcodigo#" >
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
																
									<cfset filtro = filtro & ' order by a.RHEEdescripcion, e.RHPdescpuesto, nombre, RHEDtipo ' >							
                                    
                                     <cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaRH"
										returnvariable="pListaCar">
											<cfinvokeargument name="tabla" value="RHEEvaluacionDes a, RHListaEvalDes b, RHEvaluadoresDes c, DatosEmpleado d, RHPuestos e "/>
											<cfinvokeargument name="columnas" value="a.RHEEid, PCid, a.RHEEdescripcion, b.DEid, 
																					 coalesce(e.RHPcodigoext,e.RHPcodigo) as RHPcodigoext, e.RHPcodigo, c.DEideval, RHEEestado, 
																					 e.RHPdescpuesto, 
																					 #nombre# as nombre,
																					 case c.RHEDtipo when 'A' then '#LB_Autoevaluacion#' 
																					 when 'J' then '#LB_Jefe#' 
																					 when 'E' then '#LB_JefeAlterno#' 
																					 when 'S' then '#LB_Subordinado#' 
																					 when 'C' then '#LB_Companero#' end as relacion, 
																					 
																					 case when a.PCid  > 0 then
																					  	'#LB_EnProceso#' 
																					 when    (select 
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
																								#filtrox# 
																								and c1.PCUreferencia  =  a.RHEEid ) ) then  
																							'#LB_EvaluacionCompleta#'
																						 when    (select 
																								count(pc.PCid)
																								from PortalCuestionario pc 
																								inner join PortalPregunta pp 
																									on pp.PCid= pc.PCid 
																								inner join RHNotasEvalDes RH
																									on RH.PCid = pc.PCid
																								where  pp.PPtipo in ( 'M' , 'O' , 'U' , 'V' )   
																								and    RH.RHEEid = a.RHEEid 
																								and    RH.DEid = b.DEid
																							  ) >
																								(select 
																								count(r.PCid)
																								from PortalRespuestaU r 
																								where  r.PCUid = (select max(PCUid) from PortalCuestionarioU c1 
																								where c1.Ecodigo= #session.Ecodigo# 
																								#filtrox# 
																								and c1.PCUreferencia  =  a.RHEEid ) ) 
																							  and 
																							  (select 
																								count(r.PCid)
																								from PortalRespuestaU r 
																								where  r.PCUid = (select max(PCUid) from PortalCuestionarioU c1 
																								where c1.Ecodigo= #session.Ecodigo# 
																								#filtrox# 
																								and c1.PCUreferencia  =  a.RHEEid ) ) > 0	
																								then  
																							'#LB_EnProceso#'
                                                                                       end	as estado, 
																					   case when a.PCid  > 0 then
																					   1
																					   when    (select 
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
																								#filtrox# 
																								and c1.PCUreferencia  =  a.RHEEid ) ) then  
																						1 
																						else 0   
                                                                                       end	as estatus,                                                                                       
                                                                                    case when c.RHEDtipo in ('A','E','J') then 
    																					#imprimir#
																					else
                                                                                    	''
                                                                                     end   as imprimir,
																					
																					c.RHEDtipo #campos_extra#"/>
																					 
											
                                            <cfif form.PCid LTE 0>
                                                <cfinvokeargument name="desplegar" value="nombre, relacion,estado,imprimir"/>
                                                <cfinvokeargument name="etiquetas" value="#LB_Empleado#, #LB_Tipo#,#LB_Estado#,&nbsp;"/>
                                                <cfinvokeargument name="align" value="left, left,left,left "/>
                                                <cfinvokeargument name="formatos" value="V, V,V,V"/>
											<cfelse>
                                                <cfinvokeargument name="desplegar" value="nombre, relacion,imprimir"/>
                                                <cfinvokeargument name="etiquetas" value="#LB_Empleado#, #LB_Tipo#,&nbsp;"/>
                                                <cfinvokeargument name="align" value="left, left,left "/>
                                                <cfinvokeargument name="formatos" value="V,V,V"/>
											</cfif>
											
                                            <cfinvokeargument name="filtro" value="#filtro#"/>
											<cfinvokeargument name="ajustar" value=""/>				
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="maxRows" value="30"/>
											<cfinvokeargument name="Cortes" value="RHPdescpuesto"/>
											<cfinvokeargument name="checkboxes" value="S"/>
											<cfinvokeargument name="showLink" value="FALSE"/>
											<cfinvokeargument name="keys" value="DEid,RHEEid,RHPcodigo,PCid,DEideval,estatus"/>
											<cfinvokeargument name="formName" value="form2"/>
											<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
											<cfinvokeargument name="filtrar_automatico" value="true"/>
											<cfinvokeargument name="debug" value="N"/>
											
									</cfinvoke>		


								</td>
							</tr>
                            <cfif form.PCid LTE 0>
                           		<tr><td>&nbsp;</td></tr>
                                <tr><td><cfoutput>#LB_mensaje#</cfoutput></td></tr>
                            </cfif>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td align="center">
									<input type="button" name="btnRegresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onclick="javascript: funcRegresar()">
									<input type="button" name="btnEvaluar" value="<cfoutput>#BTN_Evaluar#</cfoutput>" onclick="javascript: funcEvaluar()">
									<input type="button" name="btnFinalizar" value="<cfoutput>#BTN_Finalizar#</cfoutput>" onclick="javascript: funcFinalizar()">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>	  
		            <cf_web_portlet_end>
     			</td>	
			</tr>
		</table>	
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function reporte(RHEEid,DEid){
		var PARAM  = "/cfmx/rh/evaluaciondes/consultas/evaluacion-respuestas.cfm?Cual=J&RHEEid="+ RHEEid + "&DEid=" + DEid
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400') 
	}
	
	function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.form2.chk.length; counter++)
			{
				if ((!document.form2.chk[counter].checked) && (!document.form2.chk[counter].disabled))
					{  document.form2.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.form2.chk.disabled)) {
				document.form2.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.form2.chk.length; counter++)
			{
				if ((document.form2.chk[counter].checked) && (!document.form2.chk[counter].disabled))
					{  document.form2.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.form2.chk.disabled)) {
				document.form2.chk.checked = false;
			}
		};
	}
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
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnaEvaluacion#</cfoutput>');
			return false;
		}					
	function funcFinalizar(){
		if(algunoMarcado()){
			document.form2.action = 'evaluar_des_finalizar.cfm';
			document.form2.submit();
		}
		return false;
	}
	
	
	function funcEvaluar(){
		if(algunoMarcado()){
			document.form2.action = 'evaluar_masivo.cfm';
			document.form2.submit();
		}
		return false;
	}
	
	
	function  funcRegresar(){
		location.href ="evaluar_des-lista.cfm";
	}
	
	function limpiar(){
		document.filtro.fPCodigo.value = '';
		document.filtro.fPDescripcion.value = '';
		document.filtro.fEmpleado.value = '';
		document.filtro.fRHPcodigo.value =''
		document.filtro.fTipoRelacion.value =''
	}

</script>