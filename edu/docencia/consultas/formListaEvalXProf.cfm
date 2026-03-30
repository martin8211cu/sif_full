	<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
		<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
	</cfif> 
	<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
	</cfif> 	
	<cfif isdefined("Url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfparam name="Form.rdCortes" default="#Url.rdCortes#">
	</cfif> 	
	<cfif isdefined("Url.imprime") and not isdefined("Form.imprime")>
		<cfparam name="Form.imprime" default="#Url.imprime#">
	</cfif> 
	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif> 
	<cfif isdefined("Url.Grupo") and not isdefined("Form.Grupo")>
		<cfparam name="Form.Grupo" default="#Url.Grupo#">
	</cfif> 
	<cfif isdefined("Url.ECcodigo") and not isdefined("Form.ECcodigo")>
		<cfparam name="Form.ECcodigo" default="#Url.ECcodigo#">
	</cfif> 
	<cfif isdefined("Url.ckPxC") and not isdefined("Form.ckPxC")>
		<cfparam name="Form.ckPxC" default="#Url.ckPxC#">
	</cfif> 
	<cfif isdefined("Url.Splaza") and not isdefined("Form.Splaza")>
		<cfparam name="Form.Splaza" default="#Url.Splaza#">
	</cfif> 
	
	
	<!--- Consultas --->		 
		<cfquery datasource="#Session.Edu.DSN#" name="rsEvalXProf">
			exec sp_EVALDOCENTE 
				@CCentro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				  , @Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Splaza#">
				  
				<cfif isdefined("form.Mcodigo")  and form.Mcodigo NEQ "" and form.Mcodigo NEQ "-1">				
					, @materia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				</cfif>
				<cfif isdefined("form.PEcodigo") and form.PEcodigo NEQ "">
					, @periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
				</cfif>
				<cfif isdefined("form.Ncodigo")  and form.Ncodigo NEQ "">
					, @nivel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
				</cfif>
				<cfif isdefined("form.Grupo") and form.Grupo NEQ "">
					, @grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">
				</cfif>
				<cfif isdefined("form.ECcodigo")  and form.ECcodigo NEQ "-1">
					, @concepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECcodigo#">
				</cfif>												
		</cfquery>
				
		<cfquery name="rsConceptos" dbtype="query">
			Select distinct ECcodigo, ECnombre
			from rsEvalXProf
		</cfquery>

		<cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>	

		<cfinvoke 
		 component="edu.Componentes.usuarios"
		 method="get_usuario_by_cod"
		 returnvariable="usr">
			<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
			<cfinvokeargument name="sistema" value="edu"/>
			<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
			<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
			<cfinvokeargument name="roles" value="edu.docente"/>
		</cfinvoke>

		<cfquery datasource="#Session.Edu.DSN#" name="rsProf">
			select st.persona, (Papellido1 + ' ' + Papellido2 + ', '+ Pnombre) as NombProf
			from Staff st, PersonaEducativo pe
			where st.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
				and st.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
				and st.CEcodigo = pe.CEcodigo
				and st.persona = pe.persona
		</cfquery>
		
	<cfset ArrayNotas = ArrayNew(1)>
	<cfset hijoNotas = ArrayNew(1)>

<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="area"> 
		<td width="53%"><font size="2">Servicios Digitales al Ciudadano</font></td>
		<td width="18%">&nbsp;</td>
		<td width="29%"><div align="right">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </div></td>
	</tr>
	<tr class="area"> 
		<td><font size="2">www.migestion.net</font></td>
		<td>&nbsp;</td>
		<td><div align="right">Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></div></td>
	</tr>
	<tr> 
		<td colspan="3" class="tituloAlterno" align="center"><strong>INFORME DE EVALUACIONES</strong></td>
	</tr>
	<tr> 
		<td colspan="3" class="tituloAlterno" align="center"><strong>Docente : <cfoutput>#rsProf.NombProf#</cfoutput></strong></td>
	</tr>  
	<tr> 
		<td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
	</tr>
	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr>
  </TABLE>
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td colspan="3" nowrap>   
		
		  <cfset contCursos = 0>
		  <cfset vCursos = "">
		  <cfset vAlumno = ""> 
		  <cfset vAlumnoDescr = ""> 		  
		  <cfset vConcepto = "">  
		  <cfset vContConcepto = 0> 
		  <cfset vContAlumnos = 0>  		  
		  <cfset vTamColAlumno = 100 - (rsConceptos.recordCount * 10)>
		  <cfset vExisteNota = 0>  
		  
		  <cfif rsEvalXProf.recordCount GT 0>
			<cfoutput> 
				<cfloop query="rsEvalXProf" >
					<cfif vCursos NEQ #rsEvalXProf.Ccodigo#>
						<cfset vCursos = #rsEvalXProf.Ccodigo#>
						<cfset contCursos = contCursos + 1>
							<cfif vContConcepto GT 0>
								  <tr>
									<td class="subrayado">#vAlumnoDescr#</td>
									<cfloop query="rsConceptos">
										<cfset vExisteNota = 0>										
										<cfloop index = "LoopCountNotas" from = "1" to = "#ArrayLen(ArrayNotas)#">
											<cfif rsConceptos.ECcodigo EQ ArrayNotas[LoopCountNotas][1]>
												<cfset vExisteNota = 1> 												
												<td  width="15%" align="center" class="subrayado">
													#LSCurrencyFormat(ArrayNotas[LoopCountNotas][2],'none')#
												</td>
											</cfif>
										</cfloop>
										
										<cfif vExisteNota EQ 0>
											<td  width="15%" align="center" class="subrayado" nowrap>&nbsp;</td>
										</cfif> 
									</cfloop>	
								  </tr>
									<!---</table> CIERRA LA TABLA --->
			
								
								<cfset Temp = ArrayClear(ArrayNotas)>
								<cfset vContConcepto = 0>
								<cfset vConcepto = "">								
								<!--- <cfelse>
								</table> CIERRA LA TABLA --->							
							</cfif>
					<!--- </table> --->
			</TABLE>																				
				<cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PXC' and contCursos GT 1 and isdefined('form.imprime')>						
					<table width="100%" border="0" cellpadding="0" cellspacing="0"> 
						<tr>
							<td align="center">
								------------------ Fin del Reporte ------------------								
							</td>
						</tr>
					
						<tr class="pageEnd"> <!--- De la tabla externa --->
							<td colspan="3">
								<!--- <br class="pageEnd"> --->
								&nbsp;
							</td>
						</tr>
						
						<tr class="area"> 
							<td width="53%"><font size="2">Servicios Digitales al Ciudadano</font></td>
							<td width="18%">&nbsp;</td>
							<td width="29%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
						</tr>
						<tr class="area"> 
							<td><font size="2">www.migestion.net</font></td>
							<td>&nbsp;</td>
							<td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
						</tr>
						<tr> 
							<td colspan="3" class="tituloAlterno" align="center"><strong>INFORME DE EVALUACIONES</strong></td>
						</tr>
						<tr> 
							<td colspan="3" class="tituloAlterno" align="center"><strong>Docente : <cfoutput>#rsProf.NombProf#</cfoutput></strong></td>
						</tr>  
						<tr> 
							<td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
						</tr>
						<tr> 
							<td colspan="3">&nbsp;</td>
						</tr>
					</table> 
				</cfif>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
					<tr> 
						<td nowrap>Curso: 
							#rsEvalXProf.CursoNombre#</td>
						<td nowrap>Periodo de Evaluacion: #rsEvalXProf.PEdescripcion#</td>
					</tr>
					<tr>
						<td nowrap>Nivel:#rsEvalXProf.Ndescripcion#</td>
						<td nowrap>Grupo: #rsEvalXProf.GRnombre#</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="1" cellpadding="1"> 	<!--- ABRE LA TABLA --->
				  <tr>
					<td width="#vTamColAlumno#%" nowrap><strong>ALUMNO</strong></td>
					<cfif rsConceptos.recordCount GT 0>
						<cfloop query="rsConceptos">
							<td width="10%" nowrap align="center"><strong>#rsConceptos.ECnombre# <cfif isdefined('form.ckPxC')>(#rsEvalXProf.ECCporcentaje# %)</cfif></strong></td>
						</cfloop>
					</cfif>
				  </tr>
				<!---  </table> --->
			</cfif>
			<cfif vAlumno NEQ #rsEvalXProf.Ecodigo#>
				<!--- <table width="100%" border="0" cellpadding="0" cellspacing="0"> --->
					<cfset vContAlumnos = vContAlumnos + 1>
					<cfif vContConcepto GT 0>
						<tr>
							<td class="subrayado" nowrap>#vAlumnoDescr#</td>
								<cfloop query="rsConceptos">
									<cfset vExisteNota = 0>										
									<cfloop index = "LoopCountNotas" from = "1" to = "#ArrayLen(ArrayNotas)#">
										<cfif rsConceptos.ECcodigo EQ ArrayNotas[LoopCountNotas][1]>
											<cfset vExisteNota = 1> 												
											<td  width="15%" align="center" class="subrayado" nowrap>
												#LSCurrencyFormat(ArrayNotas[LoopCountNotas][2], 'none')#
											</td>
										</cfif>
									</cfloop>
									<cfif vExisteNota EQ 0>
										<td  width="15%" align="center" class="subrayado" nowrap>&nbsp;</td>
									</cfif>
								</cfloop>	
					  </tr>
				<!--- </table> --->
			</cfif>
		
			<cfset vAlumno = #rsEvalXProf.Ecodigo#>
			<cfset vAlumnoDescr ="#rsEvalXProf.NomAl#">								
			<cfset Temp = ArrayClear(ArrayNotas)>
			<cfset vContConcepto = 0>
			<cfset vConcepto = "">														
											
				<cfif vConcepto NEQ #rsEvalXProf.ECcodigo#>
					<cfset vConcepto = #rsEvalXProf.ECcodigo#>							
					<cfset vContConcepto = vContConcepto + 1>
					
					<cfset hijoNotas[1] =  rsEvalXProf.ECcodigo>							
					<cfset hijoNotas[2] =  rsEvalXProf.Nota>							
					<cfset ArrayNotas[#vContConcepto#] = hijoNotas>							
				</cfif>
			<cfelse>
		
			<cfif vConcepto NEQ #rsEvalXProf.ECcodigo#>
				<cfset vConcepto = #rsEvalXProf.ECcodigo#>							
				<cfset vContConcepto = vContConcepto + 1>

				<cfset hijoNotas[1] =  rsEvalXProf.ECcodigo>							
				<cfset hijoNotas[2] =  rsEvalXProf.Nota>							
				<cfset ArrayNotas[#vContConcepto#] = hijoNotas>
			<cfelse>
				<cfset hijoNotas[1] =  rsEvalXProf.ECcodigo>							
				<cfset hijoNotas[2] =  hijoNotas[2] + rsEvalXProf.Nota>							
				<cfset ArrayNotas[#vContConcepto#] = hijoNotas>													
			</cfif>					
		</cfif>			

					<cfif vContConcepto GT 0 AND rsEvalXProf.recordCount EQ rsEvalXProf.currentRow>
						<!--- <table width="100%" border="0" cellpadding="0" cellspacing="0"> --->
							  <tr>
								<td class="subrayado" nowrap>#vAlumnoDescr#</td>
								<cfloop query="rsConceptos">
									<cfset vExisteNota = 0>										
									<cfloop index = "LoopCountNotas" from = "1" to = "#ArrayLen(ArrayNotas)#">
										<cfif rsConceptos.ECcodigo EQ ArrayNotas[LoopCountNotas][1]>
											<cfset vExisteNota = 1> 												
											<td  width="15%" align="center" class="subrayado" nowrap>
												#LSCurrencyFormat(ArrayNotas[LoopCountNotas][2],'none')#
											</td>
										</cfif>
									</cfloop>
									
									<cfif vExisteNota EQ 0>
										<td  width="15%" align="center" class="subrayado" nowrap>&nbsp;</td>											
									</cfif> 
								</cfloop>	
							  </tr>
						<!--- </table> --->
					</cfif>				
						
				</cfloop>
			</cfoutput> 
			
		  </cfif>
		<!--- </table>   --->
		</td>
	</tr>  
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td align="center" nowrap>   	
				------------------ Fin del Reporte ------------------
			</td>
		</tr>  
	</table>  
<!--- </table>  --->
