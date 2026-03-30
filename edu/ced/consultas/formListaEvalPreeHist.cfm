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
	<cfif isdefined("Url.TituloProfClase") and not isdefined("Form.TituloProfClase")>
		<cfparam name="Form.TituloProfClase" default="#Url.TituloProfClase#">
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
	<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_NOTAS_PREESCOLAR_HIST" returncode="no">
		<cfprocparam dbvarname=@CCentro cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#" type="in">
		<cfprocparam dbvarname=@grupo cfsqltype="cf_sql_numeric" value="#form.Grupo#" type="in">
		<cfprocparam dbvarname=@alumno cfsqltype="cf_sql_numeric" value="#form.Alumno#" type="in">
		<cfprocparam dbvarname=@periodo cfsqltype="cf_sql_numeric" value="#form.PEcodigo#" type="in">
			
		<cfprocresult name="rsNotasPrees" resultset="1">
		<cfprocresult name="rsAlumnos" resultset="2">	 
		<cfprocresult name="rsPeriodos" resultset="3">
		<cfprocresult name="rsCentroEducativo" resultset="4">	 
		<cfprocresult name="rsCursoLectivo" resultset="5">	 
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
					where evt.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
						and evt.EVTcodigo=ev.EVTcodigo
						and evt.EVTcodigo in (#ListaEVTcodigos#)
					order by evt.EVTcodigo, ev.EVorden
				</cfquery>
			</cfif> 
		</cfif>
	</cfif>

<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">

<cfset vMateria = "">
<cfset vEvaluacion = "">
<cfif  isdefined("Session.Idioma") and Session.Idioma EQ "ES_CR">
	<cfset tituloDefault = "Informe Histórico de Preescolar">
<cfelseif isdefined("Session.Idioma") and Session.Idioma EQ "EN" >
	<cfset tituloDefault = "Historical Preschool Report Card">
</cfif>


<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center">
				<cfinclude template="../../portlets/pEncEmpresas.cfm">
			</td>
		</tr>
		<cfif isdefined('form.ckEsc')>
			<tr>
				<td>
					<table cellpadding="0" cellspacing="0" width="100%" border="0">
						<tr>
							<td colspan="2">
								<strong>#Request.Translate('RptProgTit24','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# &nbsp; &nbsp; </strong>
							</td>
						</tr>
						<cfloop query="rsEscValoracion">
							<tr> 
								<td align="center">#rsEscValoracion.EVvalor#</td>
								<td>#rsEscValoracion.EVdescripcion#</td>
							</tr>
						</cfloop>	
					</table>
				</td>
			</tr>
		</cfif>
		<tr>
			<td valign="top">
				<cfloop query="rsAlumnos">
					<cfif rsAlumnos.currentRow NEQ 1>
						<cfif Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1)>
							<cfloop condition="Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1) and (rsEvaluaciones.SPEdescripcion & rsEvaluaciones.PEdescripcion) NOT EQUAL ArregloPeriodo[Periodoindex]">
								<td class="subrayadoD" align="center" style="padding-right: 3px;">&nbsp;</td>
								<cfset Periodoindex = Periodoindex + 1>
							</cfloop>
						</cfif>
						</tr>
						</table>
					</cfif>
					<cfif isdefined("form.imprime") and rsAlumnos.CurrentRow NEQ 1>
						<tr>
							<td>
								<cfinclude template="AgregadosListaEvalPreeHist.cfm">
							</td>
						</tr>
					</cfif>
					<cfquery name="rsEvaluaciones" dbtype="query">
						select *
						from rsNotasPrees
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAlumnos.Ecodigo#">
					</cfquery>

					<cfset Periodoindex = 1>

					<table cellpadding="0" cellspacing="0" width="100%" border="0">
						<cfif isdefined("form.imprime") and isdefined('form.rdCortes') and form.rdCortes EQ 'PxA' and rsAlumnos.CurrentRow NEQ 1>
							<tr class="pageEnd">
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td  colspan="2" align="center">
									<cfinclude template="../../portlets/pEncEmpresas.cfm">
								</td>
							</tr>
							<cfif isdefined('form.ckEsc')>
								<tr>
									<td>
										<table cellpadding="0" cellspacing="0" width="100%" border="0">
											<tr>
												<td colspan="2">
													<strong>#Request.Translate('RptProgTit24','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# &nbsp; &nbsp; </strong>
												</td>
											</tr>
											<cfloop query="rsEscValoracion">
												<tr> 
													<td align="center">#rsEscValoracion.EVvalor#</td>
													<td>#rsEscValoracion.EVdescripcion#</td>
												</tr>
											</cfloop>	
										</table>
									</td>
								</tr>
							</cfif>
						</cfif>
						
						<tr> 
							<td class="areaFiltro"> 
								<font size="3">
									<strong>
										#rsAlumnos.NombreAl#
									</strong>
								</font> 
							</td>
							<td class="areaFiltro">
								<font size="3">
									 <strong>
										 <cfif len(trim(rsAlumnos.Pnacimiento)) neq 0>
												 #Request.Translate('RptProgTit20','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# &nbsp; &nbsp; 
												 #DateDiff("yyyy", rsAlumnos.Pnacimiento,  Now())# &nbsp; #Request.Translate('RptProgTit21','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# &nbsp; &nbsp; 
												 #DateDiff("m", DateAdd("yyyy", DateDiff("yyyy", rsAlumnos.Pnacimiento,  Now()), rsAlumnos.Pnacimiento), Now())# &nbsp; #Request.Translate('RptProgTit22','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#  &nbsp; &nbsp; 
												 #DateDiff("d", DateAdd("m", DateDiff("m", rsAlumnos.Pnacimiento,  Now()), rsAlumnos.Pnacimiento), Now())# &nbsp; #Request.Translate('RptProgTit23','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#
										 <cfelse>
										 	&nbsp;
										 </cfif>	
									 </strong>
								</font>
							</td>
						</tr>
						<cfif isdefined("form.TituloProfClase") and len(trim(form.TituloProfClase)) neq 0>
							<tr>
								<td class="areaFiltro">
									<font size="3">
										 <strong>
											#Request.Translate('RptProgTit15','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# &nbsp; &nbsp; #form.TituloProfClase#
										 </strong>
									</font>
								</td>
								<td class="areaFiltro">&nbsp;
									
								</td>
							</tr>
						</cfif>
					</table>
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td class="subrayadoTD" rowspan="2">&nbsp;</td>
							<cfloop query="rsCursoLectivo">
								<td class="subrayadoTD" align="center" <cfif rsPeriodos.recordCount GT 1>colspan="#rsPeriodos.recordCount#"</cfif>>#rsCursoLectivo.SPEdescripcion#</td>
							</cfloop>
						</tr>
						<tr>
							<cfset ArregloPeriodo = ArrayNew(1)> 
							<cfset idx = 1>
							<cfloop query="rsCursoLectivo">
								<cfset nombreCurso = rsCursoLectivo.SPEdescripcion >
								<cfloop query="rsPeriodos">
									<cfset ArregloPeriodo[idx] = nombreCurso & rsPeriodos.PEdescripcion>
									<cfset idx = idx + 1>
									<td  class="subrayadoTD" align="center"> #rsPeriodos.PEdescripcion#</td>
								</cfloop>
								
							</cfloop>
							<!--- <cfdump var="#rsCursoLectivo#">
							<cfdump var="#ArregloPeriodo#"> --->
						</tr>
						<cfloop query="rsEvaluaciones">
							<cfif vMateria NEQ rsEvaluaciones.Mnombre>
								<cfif rsEvaluaciones.currentRow NEQ 1>
									<cfif Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1)>
										<cfloop condition="Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1) and (rsEvaluaciones.SPEdescripcion & rsEvaluaciones.PEdescripcion) NOT EQUAL ArregloPeriodo[Periodoindex]">
											<td class="subrayadoD" align="center" style="padding-right: 3px;">&nbsp;</td>
											<cfset Periodoindex = Periodoindex + 1>
										</cfloop>
									</cfif>
									</tr>
								</cfif>

								<cfset vMateria = rsEvaluaciones.Mnombre>
								<cfset vEvaluacion = "">
								<cfset Periodoindex = 1>
								<cfset materiaTitulo = true>

								<tr>
									<td class="subrayadoD" colspan="#(rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1#" style="padding-right: 3px;">
										<b>#vMateria#</b>
									</td>
							</cfif>
							<cfif vEvaluacion NEQ rsEvaluaciones.ECnombre>
								<cfif materiaTitulo>
									<cfset materiaTitulo = false>
								<cfelse>
									<cfif Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1)>
										<cfloop condition="Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1) and (rsEvaluaciones.SPEdescripcion & rsEvaluaciones.PEdescripcion) NOT EQUAL ArregloPeriodo[Periodoindex]">
											<td class="subrayadoD" align="center" style="padding-right: 3px;">&nbsp;</td>
											<cfset Periodoindex = Periodoindex + 1>
										</cfloop>
									</cfif>
								</cfif>
								</tr>

								<cfset vEvaluacion = rsEvaluaciones.ECnombre>
								<cfset Periodoindex = 1>

								<tr>
									<td class="subrayadoD" style="padding-right: 3px;">
										&nbsp;  &nbsp; &nbsp; #vEvaluacion#
									</td>
							</cfif>
							
							<cfloop condition="Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1) and (rsEvaluaciones.SPEdescripcion & rsEvaluaciones.PEdescripcion) NOT EQUAL ArregloPeriodo[Periodoindex]">
									<td class="subrayadoD" align="center" style="padding-right: 3px;">&nbsp;</td>
									<cfset Periodoindex = Periodoindex + 1>
							</cfloop>
							
							<td align="center" class="subrayadoD" style="padding-right: 3px;" nowrap>
								<cfif rsEvaluaciones.EVTcodigo EQ "">
									#LSCurrencyFormat(rsEvaluaciones.ACnota,'none')#
								<cfelse>
									#rsEvaluaciones.ACvalor#
								</cfif>
								&nbsp;
							</td>
							<cfset Periodoindex = Periodoindex + 1>
						</cfloop>
				</cfloop>

				<cfif rsEvaluaciones.recordCount GT 0>
						<!--- Cierre de columnas de cursos sin notas --->
						<cfif Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1)>
							<cfloop condition="Periodoindex LT ((rsCursoLectivo.recordCount * rsPeriodos.recordCount)+1) and (rsEvaluaciones.SPEdescripcion & rsEvaluaciones.PEdescripcion) NOT EQUAL ArregloPeriodo[Periodoindex]">
								<td class="subrayadoD" align="center" style="padding-right: 3px;">&nbsp;</td>
								<cfset Periodoindex = Periodoindex + 1>
							</cfloop>
						</cfif>
						</tr>
						</table>
				</cfif>	
			</td>
		</tr>
		<cfif isdefined("form.imprime")>
			<tr>
				<td>
					<cfinclude template="AgregadosListaEvalPreeHist.cfm">
				</td>
			</tr>
		</cfif>
	</table>
</cfoutput>
