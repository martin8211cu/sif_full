
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CalificacionesDeCursos"
	Default="Calificaciones de cursos"
	returnvariable="LB_CalificacionesDeCursos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Codigo"
	default="C&oacute;digo"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Materia"
	default="Materia"
	returnvariable="LB_Materia"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_CodCurso"
	default="Cod.Curso"
	returnvariable="LB_CodCurso"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Curso"
	default="Curso"
	returnvariable="LB_Curso"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_NoSeEncontraronRegistros"
	default="No se encontraron registros"
	returnvariable="MSG_NoSeEncontraronRegistros"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Institucion"
	default="Instituci&oacute;n"
	returnvariable="LB_Institucion"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_NotaMinimaDelCurso"
	default="Nota m&iacute;nima del curso"
	returnvariable="LB_NotaMinimaDelCurso"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Idenfificacion"
	default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Calificacion"
	default="Calificaci&oacute;n"
	returnvariable="LB_Calificacion"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Nombre"
	default="Nombre"
	returnvariable="LB_Nombre"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_NoSeHaSeleccionadoElCurso"
	default="No se ha seleccionado el curso"
	returnvariable="LB_NoSeHaSeleccionadoElCurso"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DebeIndicarLaNotaMinimaDelCurso"
	default="Debe indicar la nota mínima del curso"
	returnvariable="MSG_DebeIndicarLaNotaMinimaDelCurso"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_LaNotaNoDebeSerMayorA100"
	default="La nota no debe ser mayor a 100"
	returnvariable="MSG_LaNotaNoDebeSerMayorA100"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_EstaSeguroQueDeseaEliminarEsteAlumnoDelCurso"
	default="Esta seguro que desea eliminar este alumno del curso"
	returnvariable="MSG_EstaSeguroQueDeseaEliminarEsteAlumnoDelCurso"/> 


<!--- FIN VARIABLES DE TRADUCCION --->
<!--- <cfif isdefined('form.RHCid') and form.RHCid GT 0>
	<cfquery name="rsCurso" datasource="#session.DSN#">
    	select RHCnombre,RHIAnombre
        from RHCursos a
        inner join RHInstitucionesA b
        	on b.RHIAid = a.RHIAid
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">	
    </cfquery>
    <cfdump var="#rsCurso#">
</cfif> --->
<cf_templateheader title="#LB_RecursosHumanos#">
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
			//-->
		</script>
		<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CalificacionesDeCursos#'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr> 
					<td valign="top" align="center" width="50%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">							
							<tr>
							<td colspan="3">
							<cfquery name="rs" datasource="#session.dsn#">
							select 
							distinct m.Mnombre,ec.*/*c.RHCnombre,
									c.RHCcodigo,
									m.Mnombre,
									ec.Mcodigo,
									ec.RHCid,
									ec.RHEMestado*/
							from RHEmpleadoCurso ec
								inner join RHCursos c
									on c.RHCid = ec.RHCid
								inner join LineaTiempo lt 
								on lt.DEid=ec.DEid 
								and c.RHCfdesde between lt.LTdesde and lt.LThasta 
								inner join RHMateria m
									on m.Mcodigo = c.Mcodigo
									and m.CEcodigo = #session.CEcodigo#
								
								left outer join RHOfertaAcademica d
								  on d.Mcodigo = m.Mcodigo
								  and d.Ecodigo = ec.Ecodigo
								left outer join RHInstitucionesA e
								  on d.RHIAid = e.RHIAid
								and e.Ecodigo = ec.Ecodigo
							where ec.Ecodigo = #session.Ecodigo#
								  and ec.RHEMestado = 0
								  and ec.RHEStatusCurso = 1
								  and c.RHCtipo != 'P' 
								  and c.RHCfdesde between lt.LTdesde and lt.LThasta
								 -- and ec.DEid in (select DEid from RHEmpleadoCurso where RHCid=c.RHCid and c
							
							</cfquery>
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="valP"/>
						<cfset LvarF=''>

						<!--- <cfif valP gt 0>
							<cfset LvarF='and ec.RHECestado = 50'>
						<cfelse>
							<cfset LvarF=''>
						</cfif> --->
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRel">
									<cfinvokeargument name="tabla" value="RHEmpleadoCurso ec
																		inner join RHCursos c
																			on c.RHCid = ec.RHCid
																		inner join LineaTiempo lt 
																		on lt.DEid=ec.DEid 
																		and c.RHCfdesde between lt.LTdesde and lt.LThasta 
																		inner join RHMateria m
																			on m.Mcodigo = c.Mcodigo
																			and m.CEcodigo = #session.CEcodigo#
																		
																		left outer join RHOfertaAcademica d
																		  on d.Mcodigo = m.Mcodigo
																		  and d.Ecodigo = ec.Ecodigo
																		left outer join RHInstitucionesA e
																		  on d.RHIAid = e.RHIAid
																		and e.Ecodigo = ec.Ecodigo"/>
									<cfinvokeargument name="columnas" value="distinct c.RHCnombre,
																			c.RHCcodigo,
																			m.Mnombre,
																			ec.Mcodigo,
																			ec.RHCid,
																			ec.RHEMestado"/>
									<cfinvokeargument name="desplegar" value="Mnombre,RHCcodigo,RHCnombre"/>
									<cfinvokeargument name="etiquetas" value="#LB_Materia#,#LB_CodCurso#,#LB_Curso#"/>
									<cfinvokeargument name="formatos" value="V, V, V"/>
									<cfinvokeargument name="filtro" value="ec.Ecodigo = #session.Ecodigo#
																			  and ec.RHEMestado = 0
																			  and ec.RHEStatusCurso = 1
																			  and c.RHCtipo != 'P' 
																			  and c.RHCfdesde between lt.LTdesde and lt.LThasta #LvarF#"/>
									<cfinvokeargument name="align" value="left, left, left"/>
									<cfinvokeargument name="ajustar" value=""/>				
									<cfinvokeargument name="irA" value="calificaciones.cfm"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="maxRows" value="15"/>
									<cfinvokeargument name="keys" value="RHCid"/>
									<cfinvokeargument name="mostrar_filtro" value="true"/>
									<cfinvokeargument name="filtrar_automatico" value="true"/>
									<cfinvokeargument name="filtrar_por" value="Mnombre,RHCcodigo,RHCnombre"/>
									<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
									<cfinvokeargument name="debug" value="N"/>
								</cfinvoke>
							</td>							
						  </tr>
						</table>						
					</td>
					<!---LA OTRA LISTA ---->					
					<td width="50%" valign="top">	
						<form name="form1" method="post" action="calificaciones-sql.cfm" onSubmit="javascript: return funcValidaciones()">				
							<cfoutput>
								<input name="RHCid" type="hidden" value="<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>#form.RHCid#</cfif>">
								<input name="Mcodigo" type="hidden" value="<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>#form.Mcodigo#</cfif>">
								<input name="RHEMestado" type="hidden" value="<cfif isdefined("form.RHEMestado") and len(trim(form.RHEMestado))>#form.RHEMestado#</cfif>">
                                <input name="RHCnombre" type="hidden" value="<cfif isdefined("form.RHCnombre") and len(trim(form.RHCnombre))>#form.RHCnombre#</cfif>">
                                
							</cfoutput>
							<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
								<cfquery name="rsLista2" datasource="#session.DSN#">
									select  b.DEidentificacion,
											{fn concat({fn concat({fn concat({fn concat(b.DEapellido1  , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )}as nombre,
											a.RHCid,
											b.DEid,
											a.RHEMnota,
											a.RHEMnotamin									
									from RHEmpleadoCurso a
										inner join RHCursos c
													on c.RHCid = a.RHCid
													inner join LineaTiempo lt 
													on lt.DEid=a.DEid 
													and c.RHCfdesde between lt.LTdesde and lt.LThasta 
										inner join DatosEmpleado b
											on a.DEid = b.DEid
											and a.Ecodigo = b.Ecodigo
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">																			
										and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">												
										and a.RHEStatusCurso = 1
										
										order by  b.DEapellido1, b.DEapellido2, b.DEnombre
                                 </cfquery>
                                 <!--- <cfif valP gt 0>
											and a.RHECestado = 50
										</cfif> --->
							</cfif>
							<table width="100%" cellpadding="0" cellspacing="0">
								<cfif isdefined("form.RHCnombre") and len(trim(form.RHCnombre))>
									<tr><td>&nbsp;</td></tr>
									<cfoutput>
									<tr>																					 						
										<td align="center" colspan="5"><strong>#LB_Curso#:&nbsp;#form.RHCnombre#</strong></td>
									</tr>
									<tr>
										<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
											<cfquery name="inst" datasource="#session.DSN#">
												select b.RHIAnombre,a.RHCfdesde,a.RHCfhasta
												from RHCursos a
													inner join RHInstitucionesA b
														on a.RHIAid = b.RHIAid
														and a.Ecodigo = b.Ecodigo
												where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
													and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
											</cfquery>	
										</cfif>		
										<td align="center" colspan="5"><strong>#LB_Institucion#:&nbsp;<cfif isdefined("inst") and inst.RHIAnombre NEQ ''>#inst.RHIAnombre#<cfelse>'No especificada'</cfif></strong></td>
									</tr>
									<tr>
										<td align="center" colspan="5"><strong>Fechas:&nbsp;<cfif isdefined("inst") and inst.RHCfdesde NEQ '' and inst.RHCfhasta NEQ ''>#LSDateFormat(inst.RHCfdesde,'DD/MM/YYYY')#&nbsp;-&nbsp;#LSDateFormat(inst.RHCfhasta,'DD/MM/YYYY')#</cfif></strong></td>
									</tr>
									</cfoutput>
									<tr><td colspan="5">&nbsp;</td></tr>
									<tr>
										<td>&nbsp;</td>
										<td><strong><cfoutput>#LB_NotaMinimaDelCurso#</cfoutput>:</strong></td>
										<td colspan="3"><input type="text" name="RHEnotamin" value="<cfif isdefined("rsLista2") and len(trim(rsLista2.RHEMnotamin))><cfoutput>#rsLista2.RHEMnotamin#</cfoutput></cfif>" size="6" onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" maxlength="6"></td>
									</tr>
									<tr><td colspan="5">&nbsp;</td></tr>
								</cfif>								
								<cfoutput>
								<tr>
									<td width="2" class="titulolistas">&nbsp;</td>
									<td class="titulolistas"><strong>#LB_Identificacion#</strong></td>
									<td class="titulolistas"><strong>#LB_Nombre#</strong></td>
									<td class="titulolistas"><strong>#LB_Calificacion#</strong></td>
									<td class="titulolistas">&nbsp;</td>
									<td class="titulolistas">&nbsp;</td>
								</tr>
								</cfoutput>
								<cfif isdefined("rsLista2") and rsLista2.RecordCount NEQ 0>
									<cfoutput query="rsLista2">
										<tr class="<cfif rsLista2.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">								
											<td width="2">&nbsp;</td>
											<td nowrap="nowrap">#rsLista2.DEidentificacion#</td>
											<td nowrap="nowrap">#rsLista2.nombre#</td>
											<td>
												<input name="RHEMnota_#rsLista2.DEid#" value="#rsLista2.RHEMnota#" type="text" size="6" maxlength="6" class="flat" onBlur="javascript:fm(this,2);" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};">
												<input name="DEid" value="#rsLista2.DEid#" type="hidden">
											</td>
											<td align="center">
												<img src="/cfmx/rh/imagenes/Borrar01_S.gif" onclick="javascript: funcCambiarEstatus(#rsLista2.DEid#); "  />
											</td>
											<td><img src="/cfmx/rh/imagenes/iindex.gif" border="0" onclick="javascript: funcReporte(#rsLista2.DEid#,#rsLista2.RHCid#)"></td>
										</tr>
									</cfoutput>
									<tr><td>&nbsp;</td></tr>
									<tr><td colspan="4" align="center"><cf_botones names="btnAgregar,btnFinalizar,btnImportar" values="Agregar,Finalizar,Importar"></td></tr>								
									<tr><td>&nbsp;</td></tr>
								<cfelse>
									<tr><td>&nbsp;</td></tr>
									<tr><td colspan="4" align="center"><strong>---- <cfoutput>#LB_NoSeHaSeleccionadoElCurso#</cfoutput> ----</strong></td></tr>
								</cfif>
								
							</table>
						</form>
					</td>
				</tr>
			</table>
			<script type="text/javascript" language="javascript1.2">
				function funcValidaciones(){
					if (document.form1.RHEnotamin.value == ''){
						alert("<cfoutput>#MSG_DebeIndicarLaNotaMinimaDelCurso#</cfoutput>");
						return false;
					}
					if (document.form1.RHEnotamin.value > 100){
						alert("<cfoutput>#MSG_LaNotaNoDebeSerMayorA100#</cfoutput>");
						return false;
					}
					return true;
				}
				
				function funcCambiarEstatus(valorDEid){
					var _RHCid = document.form1.RHCid.value;
					var _RHCnombre = document.form1.RHCnombre.value;
					var _Mcodigo = document.form1.Mcodigo.value;
					if(confirm("<cfoutput>#MSG_EstaSeguroQueDeseaEliminarEsteAlumnoDelCurso#</cfoutput>")){
						window.location.href = "calificaciones-sql.cfm?btnEliminar=1&DEid="+valorDEid+"&RHCid="+_RHCid+"&RHCnombre="+_RHCnombre+"&Mcodigo="+_Mcodigo;
					}
				}
				
				function funcbtnImportar(){
					document.form1.action = "/cfmx/rh/capacitacion/catalogos/importadorCalificaciones.cfm"
				}
				/*
				function funcValida(vObjeto){
					alert(vObjeto.value)
				}
				*/
				function funcReporte(DEid,RHCid){
					var Mcodigo = document.form1.Mcodigo.value;		
					 var PARAM  = "/cfmx/rh/capacitacion/catalogos/calificacion_justificacion.cfm?DEid="+ DEid + "&RHCid=" + RHCid +"&Mcodigo=" + Mcodigo;
					open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=180')  
				} 
			</script>
		<cf_web_portlet_end>
<cf_templatefooter>
