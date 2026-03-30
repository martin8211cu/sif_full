<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
	</cf_templatearea>
<cf_templatearea name="body">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>	  
	  	<!----============== TRADUCCION =================---->
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Planificación de Jornadas"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaInicio"
			Default="Fecha Inicio"	
			returnvariable="LB_FechaInicio"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaFinal"
			Default="Fecha Final"	
			returnvariable="LB_FechaFinal"/>					
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Generar"
			XmlFile="/rh/generales.xml"
			Default="Generar"	
			returnvariable="BTN_Generar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_ActualizarDatos"
			Default="Actualizar Datos"	
			returnvariable="BTN_ActualizarDatos"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar"
			XmlFile="/rh/generales.xml"
			Default="Regresar"	
			returnvariable="BTN_Regresar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_FechaInicioMayorFechaVence"
			Default="La fecha de inicio no puede ser mayor a la fecha final"	
			returnvariable="MSG_FechaDesdeMayorFechaHasta"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DebeSeleccionarLaFechaIncialLaFechaFinal"
			Default="Debe seleccionar la fecha incial y la fecha final"	
			returnvariable="MSG_SeleccionarFechas"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ConfirmaActualiza"
			Default="Esta seguro que desea actualizar la planificación del empleado?"	
			returnvariable="MSG_ConfirmaActualiza"/>		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_FechaInicialMenorAHoy"
			Default="La fecha inicial no puede ser menor al día de hoy"	
			returnvariable="MSG_FechaInicialMenorAHoy"/>
		
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid>
		</cfif>
		<cfif isdefined("url.fechaInicial") and len(trim(url.fechaInicial)) and not isdefined("form.fechaInicial")>
			<cfset form.fechaInicial = url.fechaInicial>
		</cfif>
		<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal)) and not isdefined("form.fechaFinal")>
			<cfset form.fechaFinal = url.fechaFinal>
		</cfif>
		
		<cfset vs_fechaActual = LSDateFormat(now(),'dd/mm/yyyy')>
		
		<cfquery name="rsEmpleado" datasource="#Session.DSN#"><!----Busca la ULTIMA jornada definida en la linea del tiempo (para los empleados que no estan activos actualmente)---->
			select 	max(lt.LTdesde),	
					a.DEid, 
					a.NTIcodigo, 
					a.DEidentificacion, 
					a.DEnombre, 
					a.DEapellido1, 
					a.DEapellido2, 
					n.NTIdescripcion,
					lt.RHJid,
					j.RHJdescripcion as Jornada,
					case when datepart(hh, j.RHJhoraini) > 12 then datepart(hh, j.RHJhoraini) - 12 when datepart(hh, j.RHJhoraini) = 0 then 12 else datepart(hh, j.RHJhoraini) end as hinicio,
					datepart(mi, j.RHJhoraini) as minicio,
					case when datepart(hh,j.RHJhoraini) < 12 then 'AM' else 'PM' end as tinicio,
					case when datepart(hh, j.RHJhorafin) > 12 then datepart(hh, j.RHJhorafin) - 12 when datepart(hh, j.RHJhorafin) = 0 then 12 else datepart(hh, j.RHJhorafin) end as hfinal,
					datepart(mi,j.RHJhorafin) as mfinal,
					case when datepart(hh, j.RHJhorafin) < 12 then 'AM' else 'PM' end as tfinal
			from DatosEmpleado a, NTipoIdentificacion n, LineaTiempo lt, RHJornadas j
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and a.NTIcodigo = n.NTIcodigo
				and a.DEid = lt.DEid
				and a.Ecodigo = lt.Ecodigo
				and lt.RHJid = j.RHJid
				and a.Ecodigo = j.Ecodigo
			group by  a.DEid, 
					   a.NTIcodigo, 
					   a.DEidentificacion, 
					   a.DEnombre, 
					   a.DEapellido1, 
					   a.DEapellido2, 
					   n.NTIdescripcion,
					   j.RHJdescripcion 
		</cfquery>
		
		<cfquery name="rsJornadas" datasource="#Session.DSN#">
			select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
			from RHJornadas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfif isdefined("form.fechaInicial") and len(trim(form.fechaInicial))>
			<cfset vd_fechaInicial = LSParseDateTime(form.fechaInicial)>
		<cfelse>
			<cfset vd_fechaInicial = now()>
		</cfif>
		
		<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
			<cfset vd_fechaFinal = LSParseDateTime(form.fechaFinal)>
		<cfelse>
			<cfset vd_fechaFinal = DateAdd("d", 6, "#vd_fechaInicial#")><!---Fecha del dia + 6 dias para presentar 7 días de la semana apartir de hoy---->
		</cfif>
	
		<!---Tabla temporal para almacenar todas las fechas del rango seleccionado---->
		<cf_dbtemp name="TempRangoFechas" returnvariable="TempRangoFechas" datasource="#session.DSN#">
			<cf_dbtempcol name="tmpfecha" 	type="datetime"		mandatory="yes">
		</cf_dbtemp>
		
		<cfset vd_fecha = CreateDateTime(year(vd_fechaInicial), month(vd_fechaInicial), day(vd_fechaInicial), 00, 00,0)><!---Variable con la fecha---->
		<cfloop condition = "#vd_fecha# LTE #vd_fechaFinal#">
			<cfquery datasource="#session.DSN#">
				insert into #TempRangoFechas# (tmpfecha)
				values(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_fecha#">)
			</cfquery>			
			<cfset vd_fecha = DateAdd("d", 1, vd_fecha)><!---Siguiente día del rango--->
		</cfloop>
		
		<!----Jornadas definidas en el planificador para el empleado en el rango del dia actual + 6 dias mas ------>
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select 	a.RHPJid,
					c.tmpfecha,
					case when a.RHPJid is null then 
						#rsEmpleado.hinicio#
					else					
						case when datepart(hh, a.RHPJfinicio) > 12 then datepart(hh, a.RHPJfinicio) - 12 when datepart(hh, a.RHPJfinicio) = 0 then 12 else datepart(hh, a.RHPJfinicio) end
					end as hinicio,
					
					case when a.RHPJid is null then 
						#rsEmpleado.minicio#
					else						
						datepart(mi, a.RHPJfinicio) 
					end as minicio,
					
					case when a.RHPJid is null then
						'#rsEmpleado.tinicio#'
					else	
						case when datepart(hh, a.RHPJfinicio) < 12 then 'AM' else 'PM' end 
					end as tinicio,
					
					case when a.RHPJid is null then
						#rsEmpleado.hfinal#
					else	
						case when datepart(hh, a.RHPJffinal) > 12 then datepart(hh, a.RHPJffinal) - 12 when datepart(hh, a.RHPJffinal) = 0 then 12 else datepart(hh, a.RHPJffinal) end 
					end as hfinal,
					
					case when a.RHPJid is null then
						#rsEmpleado.mfinal#
					else	
						datepart(mi, a.RHPJffinal) 
					end as mfinal,
					
					case when a.RHPJid is null then
						'#rsEmpleado.tfinal#'
					else					
						case when datepart(hh, a.RHPJffinal) < 12 then 'AM' else 'PM' end 
					end as tfinal,
					
					case when a.RHJid is null then 
						#rsEmpleado.RHJid#
					else
						a.RHJid
					end as Jornada,
					
					a.RHPlibre					
			from #TempRangoFechas# c
				left outer join RHPlanificador a
					on <cf_dbfunction name="date_format" args="c.tmpfecha,yyyymmdd"> = <cf_dbfunction name="date_format" args="a.RHPJfinicio,yyyymmdd">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and a.RHPJfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#vd_fechaInicial#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#vd_fechaFinal#">					
				left outer join RHJornadas b
					on a.RHJid = b.RHJid
		</cfquery>
		
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">						
					<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfoutput>
						<table width="100%" cellpadding="0" cellspacing="0">
							<form name="form1" action="PlanificaJornadas-Empleado-sql.cfm" method="post" onSubmit="javascript: funcValidaFechas();">
								<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
								<input type="hidden" name="RHPJid_eliminar" value=""><!---Campo para guardar el RHPJid de la jornada a eliminar--->
								<tr>
									<td><cfinclude template="PlanificaJornadas-empheader.cfm"></td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="13%" align="right"><strong>#LB_FechaInicio#:&nbsp;</strong></td>
												<td width="7%">
													<cf_sifcalendario  tabindex="1" form="form1" name="fechaInicial" value="#LSDateFormat(vd_fechaInicial,'dd/mm/yyyy')#" onBlur="funFechaInicial()">
												</td>
												<td width="13%" align="right"><strong>#LB_FechaFinal#:&nbsp;</strong></td>
												<td width="15%">
													<cf_sifcalendario  tabindex="1" form="form1" name="fechaFinal" value="#LSDateFormat(vd_fechaFinal,'dd/mm/yyyy')#" onBlur="funcValidaFechas()">
												</td>
												<td width="23%"><input type="button" name="btnGenerar" value="#BTN_Generar#" onClick="javascript: return funGenerar();"></td>
												<td width="17%">
													<input type="submit" name="btnActualizar" value="#BTN_ActualizarDatos#" onClick="javascript: if ( confirm('#MSG_ConfirmaActualiza#') ){return true;} return false;">
												</td>
												<td width="12%"><input type="button" name="btnRegresar" value="#BTN_Regresar#" onClick="javascript: location.href = 'PlanificaJornadas.cfm';"></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td>
										<table width="100%" cellpadding="2" cellspacing="0">
											<tr class="tituloListas">
												<td width="2%">&nbsp;</td>
												<td width="13%"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate></strong></td>
												<td width="31%"><strong><cf_translate key="LB_Jornada">Jornada</cf_translate></strong></td>
												<td width="20%"><strong><cf_translate key="LB_HoraEntrada">Hora Entrada</cf_translate></strong></td>
												<td width="20%"><strong><cf_translate key="LB_HoraSalida">Hora Salida</cf_translate></strong></td>
												<td width="7%" align="center"><strong><cf_translate key="LB_Libre">Libre</cf_translate></strong></td>
												<td width="7%">&nbsp;</td>
											</tr>
											<cfloop query="rsDatos">
												<cfset vs_id = LSDateFormat(rsDatos.tmpfecha,'yyyymmdd')>		<!---Variable con un identificador para cada fecha--->
												<input type="hidden" name="RHPJid" value="#rsDatos.RHPJid#">	<!---Id's de los días que si estan en planificador (Eliminar/Crear)--->
												<input type="hidden" name="IDfechas" value="#vs_id#">			<!---Variable con los identificadores de cada fecha creados (Crear)--->												
												<cfset vs_jornada = rsDatos.Jornada>							<!---Variable con la jornada (Se utiliza asi porque siempre usaba el mismo valor)---->
												<tr>
													<td>&nbsp;</td>
													<td>#LSDateFormat(rsDatos.tmpfecha,'dd/mm/yyyy')#</td>
													<td>														
														<select name="RHJid_#vs_id#" onChange="javascript: funcTraeHorario(this.value,'#vs_id#');">
															<cfloop query="rsJornadas">																
																<option value="#rsJornadas.RHJid#" <cfif vs_jornada EQ rsJornadas.RHJid> selected</cfif>>#rsJornadas.Descripcion#</option>
															</cfloop>
														</select>
													</td>
													<td>
														<select name="RHPJfinicioH_#vs_id#">
														  <cfloop index="i" from="1" to="12">
															<option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("rsDatos.hinicio") and rsDatos.hinicio EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
														  </cfloop>
														</select> :
														<select name="RHPJfinicioM_#vs_id#">
														  <cfloop index="i" from="0" to="59">
															<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("rsDatos.minicio") and rsDatos.minicio EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
														  </cfloop>
														</select>
														<select name="RHPJfinicioS_#vs_id#">
															<option value="AM" <cfif isdefined("rsDatos.tinicio") and rsDatos.tinicio EQ 'AM'> selected</cfif>>AM</option>
															<option value="PM" <cfif isdefined("rsDatos.tinicio") and rsDatos.tinicio EQ 'PM'> selected</cfif>>PM</option>
														</select>
													</td>
													<td>
														<select name="RHPJffinalH_#vs_id#">
														  <cfloop index="i" from="1" to="12">
															<option value="<cfoutput>#i#</cfoutput>"  <cfif isdefined("rsDatos.hfinal") and rsDatos.hfinal EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
														  </cfloop>
														</select> :
														<select name="RHPJffinalM_#vs_id#">
														  <cfloop index="i" from="0" to="59">
															<option value="<cfoutput>#i#</cfoutput>" <cfif isdefined("rsDatos.mfinal") and rsDatos.mfinal EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
														  </cfloop>
														</select>
														<select name="RHPJffinalS_#vs_id#">
															<option value="AM" <cfif isdefined("rsDatos.tfinal") and rsDatos.tfinal EQ 'AM'> selected</cfif>>AM</option>
															<option value="PM" <cfif isdefined("rsDatos.tfinal") and rsDatos.tfinal EQ 'PM'> selected</cfif>>PM</option>
														</select>
													</td>
													<td align="center">
														<input type="checkbox" name="RHPlibre_#vs_id#" <cfif rsDatos.RHPlibre EQ 1>checked</cfif>>
													</td>
													<td>
														<cfif len(trim(rsDatos.RHPJid))>
															<img border="0" style="cursor:pointer;" src="/cfmx/rh/imagenes/Borrar01_S.gif" onClick="javascript: funcEliminar('#rsDatos.RHPJid#')">
														<cfelse>
															&nbsp;
														</cfif>
													</td>
												</tr>
											</cfloop>
										</table>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</form>
						</table>
					</cfoutput>						
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>
		<iframe name="ifr_horario" id="ifr_horario" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" ></iframe>
		<script type="text/javascript" language="javascript1.2">						
			function funGenerar(){
				if (document.form1.fechaInicial.value != '' && document.form1.fechaFinal.value != ''){
					if (funFechaInicial()){
						var inicio = document.form1.fechaInicial.value.split('/');
						var fechainicio = inicio[2] + inicio[1] + inicio[0]
						var hasta = document.form1.fechaFinal.value.split('/');
						var fechafinal = hasta[2] + hasta[1] + hasta[0]
						if (fechainicio > fechafinal){
							<cfoutput>alert("#MSG_FechaDesdeMayorFechaHasta#")</cfoutput>;
							return false;
						}							
					}
					document.form1.action = '';
					document.form1.submit();
					return true;
				}	
				else{
					<cfoutput>alert("#MSG_SeleccionarFechas#")</cfoutput>;
					return false;
				}						
			}
			
			function funcTraeHorario(pn_RHJid,prn_idObjeto){
				var params = '';
				params = '&form=form1&hinicio=RHPJfinicioH_'+prn_idObjeto+'&minicio=RHPJfinicioM_'+prn_idObjeto+'&sinicio=RHPJfinicioS_'+prn_idObjeto+'&hfin=RHPJffinalH_'+prn_idObjeto+'&mfin=RHPJffinalM_'+prn_idObjeto+'&sfin=RHPJffinalS_'+prn_idObjeto;
				document.getElementById("ifr_horario").src = "PlanificaJornadas-TraerHorario.cfm?RHJid="+pn_RHJid+params;
			}
			
			function funcEliminar(prn_RHPJid){
				document.form1.RHPJid_eliminar.value = prn_RHPJid;
				document.form1.submit();
			}
			
			function funcValidaFechas(){
				var inicio = document.form1.fechaInicial.value.split('/');
				var fechainicio = inicio[2] + inicio[1] + inicio[0]
				var hasta = document.form1.fechaFinal.value.split('/');
				var fechafinal = hasta[2] + hasta[1] + hasta[0]
				if (fechainicio > fechafinal){
					<cfoutput>alert("#MSG_FechaDesdeMayorFechaHasta#")</cfoutput>;
					document.form1.fechaInicial.value = '';
					document.form1.fechaFinal.value = '';
					return false;
				}
				return true;
			}
			
			function funFechaInicial(){
				var inicio = document.form1.fechaInicial.value.split('/');
				var fechainicio = inicio[2] + inicio[1] + inicio[0];
				var fechaactual = <cfoutput>'#vs_fechaActual#'</cfoutput>;
				var fechaactual = fechaactual.split('/');
				var fechaactual = fechaactual[2]+fechaactual[1]+fechaactual[0]
				if (fechainicio < fechaactual){
					<cfoutput>alert("#MSG_FechaInicialMenorAHoy#")</cfoutput>;
					document.form1.fechaInicial.value = <cfoutput>'#vs_fechaActual#'</cfoutput>;
				}			
				funcValidaFechas();
			}			
		</script>
	</cf_templatearea>
</cf_template>


