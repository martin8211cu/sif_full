 	<cfif isdefined("Url.Grupo") and not isdefined("Form.Grupo")>
		<cfparam name="Form.Grupo" default="#Url.Grupo#">
	</cfif> 
 	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif> 	
	<cfif isdefined("Url.Alumno") and not isdefined("Form.Alumno")>
		<cfparam name="Form.Alumno" default="#Url.Alumno#">
	</cfif> 	
	<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
	</cfif> 
	<cfif isdefined("Url.TituloRep") and not isdefined("Form.TituloRep")>
		<cfparam name="Form.TituloRep" default="#Url.TituloRep#">
	</cfif> 
	<cfif isdefined("Url.TituloFecha") and not isdefined("Form.TituloFecha")>
		<cfparam name="Form.TituloFecha" default="#Url.TituloFecha#">
	</cfif> 	
	<cfif isdefined("Url.FechaRep") and not isdefined("Form.FechaRep")>
		<cfparam name="Form.FechaRep" default="#Url.FechaRep#">
	</cfif> 
	<cfif isdefined("Url.ckObs") and not isdefined("Form.ckObs")>
		<cfparam name="Form.ckObs" default="#Url.ckObs#">
	</cfif> 	
	<cfif isdefined("Url.ckPM") and not isdefined("Form.ckPM")>
		<cfparam name="Form.ckPM" default="#Url.ckPM#">
	</cfif> 	
	<cfif isdefined("Url.ckA") and not isdefined("Form.ckA")>
		<cfparam name="Form.ckA" default="#Url.ckA#">
	</cfif> 
	<cfif isdefined("Url.ckP") and not isdefined("Form.ckP")>
		<cfparam name="Form.ckP" default="#Url.ckP#">
	</cfif> 	
	<cfif isdefined("Url.ckD") and not isdefined("Form.ckD")>
		<cfparam name="Form.ckD" default="#Url.ckD#">
	</cfif> 
	<cfif isdefined("Url.ckAD") and not isdefined("Form.ckAD")>
		<cfparam name="Form.ckAD" default="#Url.ckAD#">
	</cfif> 
	<cfif isdefined("Url.ckAdic1") and not isdefined("Form.ckAdic1")>
		<cfparam name="Form.ckAdic1" default="#Url.ckAdic1#">
	</cfif> 	
	<cfif isdefined("Url.ckAdic2") and not isdefined("Form.ckAdic2")>
		<cfparam name="Form.ckAdic2" default="#Url.ckAdic2#">
	</cfif> 	
	<cfif isdefined("Url.ckEsc") and not isdefined("Form.ckEsc")>
		<cfparam name="Form.ckEsc" default="#Url.ckEsc#">
	</cfif> 	
	<cfif isdefined("Url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfparam name="Form.rdCortes" default="#Url.rdCortes#">
	</cfif> 
	<cfif isdefined("Url.imprime") and not isdefined("Form.imprime")>
		<cfparam name="Form.imprime" default="#Url.imprime#">
	</cfif> 	
	<cfif isdefined("Url.nomAdicio1") and not isdefined("Form.nomAdicio1")>
		<cfparam name="Form.nomAdicio1" default="#Url.nomAdicio1#">
	</cfif> 	
	<cfif isdefined("Url.nomAdicio2") and not isdefined("Form.nomAdicio2")>
		<cfparam name="Form.nomAdicio2" default="#Url.nomAdicio2#">
	</cfif> 

	<!--- Consultas --->
	<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_NOTAS_PREESCOLAR" returncode="no">
		<cfprocparam dbvarname=@CCentro cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#" type="in">
		<cfprocparam dbvarname=@grupo cfsqltype="cf_sql_numeric" value="#form.Grupo#" type="in">
		<cfprocparam dbvarname=@alumno cfsqltype="cf_sql_numeric" value="#form.Alumno#" type="in">
		<cfprocparam dbvarname=@periodo cfsqltype="cf_sql_numeric" value="#form.PEcodigo#" type="in">
			
		<cfprocresult name="rsNotasPrees" resultset="1">
		<cfprocresult name="rsAlumnos" resultset="2">	 
		<cfprocresult name="rsPeriodos" resultset="3">
		<cfprocresult name="rsCentroEducativo" resultset="4">	 
	</cfstoredproc>

	<cfif isdefined('form.ckEsc')>
		<cfquery name="rsEvaluacValores" dbtype="query">
			Select distinct EVTcodigo
			from rsNotasPrees
		</cfquery>	
	
		<cfif rsEvaluacValores.recordCount GT 0>
			<cfset ListaEVTcodigos = ValueList(rsEvaluacValores.EVTcodigo)>
			<cfif ListLen(ListaEVTcodigos) GT 0>
				<cfquery datasource="#Session.Edu.DSN#" name="rsEscValoracion">
					select EVvalor, EVdescripcion
					from EvaluacionValoresTabla evt, EvaluacionValores ev
					where CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
						and evt.EVTcodigo=ev.EVTcodigo
						and evt.EVTcodigo in (#ListaEVTcodigos#)
					order by EVorden
				</cfquery>
			</cfif> 
		</cfif>
	</cfif>

<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="area"> 
    <td colspan="2">&nbsp; </td>
  </tr>
  <tr class="area"> 
    <td colspan="2">&nbsp; </td>
  </tr>
  <tr class="area"> 
    <td colspan="2">&nbsp; </td>
  </tr>
  <tr class="area"> 
    <td width="73%">&nbsp;</td>
    <td width="27%">
		<cfoutput> 
			<cfif isdefined('form.TituloFecha') and form.TituloFecha NEQ ''>
				#form.TituloFecha#
			<cfelse>
				Fecha de Entrega: 
			</cfif>	
		
			<cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>
				#form.FechaRep# 
			<cfelse>
				#LSdateFormat(Now(),'dd/MM/YY')# 
			</cfif>
		</cfoutput> 
	  </td>
  </tr>
  <tr class="area"> 
    <td width="73%">&nbsp;</td>
    <td> 
      <!--- Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput> --->
    </td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="2" align="center" class="tituloAlterno"> <strong> 
      <cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
        <cfoutput>#form.TituloRep#</cfoutput> 
        <cfelse>
        REPORTE DE NOTAS PARA PRESCOLAR 
      </cfif>
      </strong> </td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="2" align="center" class="tituloAlterno"> <strong><cfoutput>#rsNotasPrees.GRnombre#</cfoutput></strong> </td>
  </tr>
  <tr> 
    <td colspan="2" align="center" class="tituloAlterno"> <strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
  </tr>
  <tr> 
    <td colspan="2" align="center" class="tituloAlterno">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="center" class="tituloAlterno"><hr></td>
  </tr>
  <tr> 
    <td colspan="2"> 
		<cfset tamEval = 96>
		<cfset vAlumno = "">
		<cfset vMateria = "">
		<cfset vCodPeriodo = "">
		<cfset vContAlumnos = 0>	
		<cfif rsPeriodos.recordCount GT 0>
			<cfset tamEval = 96 - (rsPeriodos.recordCount * 10)>
		</cfif>
	   
		<cfif rsAlumnos.recordCount GT 0> 
			<table width="100%" border="0" cellspacing="1" cellpadding="1">		
				<cfoutput query="rsAlumnos">
					<cfif vAlumno NEQ rsAlumnos.persona>
						<cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA' and vContAlumnos GT 0 and isdefined('form.imprime')>
										<tr> 
											<td> 
												<cfinclude template="AgregadosListaEvalPree.cfm"> 
											</td>
										</tr>
										<tr> 
											<td align="center">------------------ Fin del Reporte ------------------</td>
										</tr>									
										<tr> 
											<td align="center">
												<table width="100%" border="0">										
													<tr> 
													  <td align="center">&nbsp;</td>
													</tr>
													<tr> 
													  <td align="center">
														  <table width="100%" border="0">
														  <tr>
															  <td><strong><font size="2">Servicios Digitales al Ciudadano</font></strong></td>
															  <td align="right"><strong><font size="2">www.migestion.net</font></strong></td>
														  </tr>
														</table>
													  </td>
													</tr>			
												</table>							  
											</td>
										</tr>
										<tr> 
										  <td align="center">&nbsp;</td>
										</tr>
									</table>
								 </td>
							  </tr>			
							  <tr class="pageEnd">	  <!--- Corte de Impresion --->
								<td colspan="2">&nbsp; 
									
								 </td>
							  </tr>					
							  <tr> 
								<td colspan="2"> 			
									<table width="100%" border="0" cellspacing="1" cellpadding="1">															
										<tr> 
										  <td align="center">	<!--- ENCABEZADO se repite si hay corte por alumno --->
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr class="area"> 
												<td colspan="2">&nbsp; </td>
											  </tr>
											  <tr class="area"> 
												<td colspan="2">&nbsp; </td>
											  </tr>
											  <tr class="area"> 
												<td colspan="2">&nbsp; </td>
											  </tr>
											  <tr class="area"> 
												<td width="73%">&nbsp;</td>
												<td width="27%">
														<cfif isdefined('form.TituloFecha') and form.TituloFecha NEQ ''>
															#form.TituloFecha#
														<cfelse>
															Fecha de Entrega: 
														</cfif>	
													
														<cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>
															#form.FechaRep# 
														<cfelse>
															#LSdateFormat(Now(),'dd/MM/YY')# 
														</cfif>
												  </td>
											  </tr>
											  <tr class="area"> 
												<td width="73%">&nbsp;</td>
												<td> 
												  <!--- Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput> --->
												</td>
											  </tr>
											  <tr class="tituloAlterno"> 
												<td colspan="2" align="center" class="tituloAlterno"> <strong> 
												  <cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
													#form.TituloRep# 
													<cfelse>
													REPORTE DE NOTAS PARA PRESCOLAR 
												  </cfif>
												  </strong> </td>
											  </tr>
											  <tr class="tituloAlterno"> 
												<td colspan="2" align="center" class="tituloAlterno"> <strong>#rsNotasPrees.GRnombre#</strong> </td>
											  </tr>
											  <tr> 
												<td colspan="2" align="center" class="tituloAlterno"> <strong>#rsCentroEducativo.CEnombre#</strong></td>
											  </tr>
											  <tr> 
												<td colspan="2" align="center" class="tituloAlterno">&nbsp;</td>
											  </tr>
											  <tr> 
												<td colspan="2" align="center" class="tituloAlterno"><hr></td>
											  </tr>	
											</table>							    						  
										  </td>
										</tr>					
						</cfif>

						<cfset vContAlumnos = vContAlumnos + 1>
						<cfset vAlumno ="#rsAlumnos.persona#">
	
						<cfquery name="rsMateriasXAlumno" dbtype="query">
							Select distinct Ccodigo, Mnombre
							from rsNotasPrees
							where persona=#vAlumno#
							order by Morden
						</cfquery>		
		
						<tr> 
							<td class="areaFiltro"> 
								<font size="3">
									<strong>
										#rsAlumnos.NombreAl#
									</strong>
								</font> 
							</td>
						</tr>
						<tr> 
							<td> 
								<!--- Encabezado de los periodos --->
								<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
									<tr> 
										<td width="4%">&nbsp;</td>
										<td width="#tamEval#%" align="center">&nbsp;</td>
										<cfloop query="rsPeriodos">
											<td width="10%" align="center"><strong>#rsPeriodos.PEdescripcion#</strong></td>
										</cfloop>
									</tr>
								</table>
							</td>
						</tr>
						
						<cfif rsMateriasXAlumno.recordCount GT 0>
							<cfset rsEvaluaciones = ''>
							<cfset rsNotas = ''>							
							<cfloop query="rsMateriasXAlumno">
								<cfset vMateria ="#rsMateriasXAlumno.Ccodigo#">
								<tr>
									<td><strong>#rsMateriasXAlumno.Mnombre#</strong></td>
								</tr>
								
 								<cfquery name="rsEvaluaciones" dbtype="query">
									Select ECnombre
									from rsNotasPrees
									where persona=#vAlumno#
										and Ccodigo=#rsMateriasXAlumno.Ccodigo#
									group by ECnombre
									order by ECplaneada
								</cfquery>								
																
								<cfif rsEvaluaciones.recordCount GT 0>
									<tr>
										<td>
											<table width="100%" border="0">										
												<cfloop query="rsEvaluaciones">											
													<tr>
														<td width="4%">&nbsp;</td>
														<td class="subrayado" width="#tamEval#%">#rsEvaluaciones.ECnombre#</td>														

														<cfquery name="rsNotas" dbtype="query">
															Select EVTcodigo, ACnota, ACvalor, PEcodigo
															from rsNotasPrees
															where persona=#vAlumno#
																and Ccodigo=#vMateria#
																and ECnombre='#rsEvaluaciones.ECnombre#'
														</cfquery>												  
														<cfloop query="rsPeriodos">
															<cfset vCodPeriodo = #rsPeriodos.PEcodigo#>
															<td class="subrayado" width="10%" align="center">																													
																<cfif rsNotas.recordCount GT 0>															
																	<cfloop query="rsNotas">
																		<cfif rsNotas.PEcodigo EQ vCodPeriodo>
																		  <cfif rsNotas.EVTcodigo EQ "">
																			<cfif rsNotas.ACnota NEQ "">
																			  #rsNotas.ACnota#
																			<cfelse>
																			   N/A
																			</cfif>
																		  <cfelse>
																			<cfif rsNotas.ACvalor NEQ "">
																			  #rsNotas.ACvalor#
																			<cfelse>
																				N/A
																			</cfif>
																		  </cfif>
																		<cfelse>
																			&nbsp;
																		</cfif>														
																	</cfloop>	<!--- Ciclo de Notas --->																		
																</cfif>																
															</td>																															
														</cfloop>	<!--- Ciclo de Periodos --->												  															
												  </tr>
												</cfloop>	<!--- Ciclo de Evaluaciones --->											
											</table>											
										</td>
									</tr>									
								</cfif> 
							</cfloop>	<!--- Ciclo de Materias --->			
						</cfif>
					</cfif>						
				</cfoutput>	<!--- Ciclo de Alumnos --->
			</table>			
		</cfif>
	<td> 
  </tr>
</table>
<!--- Area de:
			Observaciones
			Escalas de valoracion
			y Firmas
 --->
<cfinclude template="AgregadosListaEvalPree.cfm">

<table width="100%" border="0">
	<tr> 
	  <td align="center">------------------ Fin del Reporte ------------------</td>
	</tr>  
	<tr> 
	  <td align="center">&nbsp;</td>
	</tr>
	<tr> 
	  <td align="center">
		  <table width="100%" border="0">
		  <tr>
			  <td><strong><font size="2">Servicios Digitales al Ciudadano</font></strong></td>
			  <td align="right"><strong><font size="2">www.migestion.net</font></strong></td>
		  </tr>
		</table>
	  </td>
	</tr>			
</table>
