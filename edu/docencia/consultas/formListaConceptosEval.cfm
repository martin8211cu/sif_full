	<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
		<cfparam name="Form.btnGenerar" default="#Url.btnGenerar#">
	</cfif> 

	<cfif isdefined("url.Ccodigo") and not isdefined("Form.Ccodigo")>
		<cfparam name="Form.Ccodigo" default="#url.Ccodigo#">
	</cfif>
	<cfif isdefined("url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfparam name="Form.PEcodigo" default="#url.PEcodigo#">
	</cfif>
	
	<cfif isdefined("url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfparam name="Form.rdCortes" default="#url.rdCortes#">
	</cfif>
	
	<!--- Consultas --->		 
	<cfif isdefined("Form.btnGenerar")>
		<cfquery name="rsPeriodoReporte" datasource="#Session.Edu.DSN#">
			select PEdescripcion
			from PeriodoEvaluacion pe, Nivel n
			where CEcodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and pe.Ncodigo	= n.Ncodigo
				and pe.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			order by PEorden
		</cfquery>
		
		<!---
		 <cfquery datasource="#Session.Edu.DSN#" name="rsProfesor">
			select Splaza 
			from Staff
			where Staff.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
			  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		</cfquery>
		--->
	
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

		<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_CONCEPTOCURSO" returncode="yes">
			<cfprocresult name="cons1">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Curso"   value="#Form.Ccodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Periodo"   value="#Form.PEcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Docente"   value="#usr.num_referencia#">
		</cfstoredproc>
	</cfif> 
		 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>			
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">		
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="area"> 
		<td colspan="2">Servicios Digitales al Ciudadano</td>
		<!--- <td width="20%">&nbsp;</td> --->
		<td  align="right">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
	</tr>
		<tr class="area"> 
		<td colspan="2">www.migestion.net</td>
		<!--- <td>&nbsp;</td> --->
	<td align="right">Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
	</tr>
		<tr class="area" align="center"> 
			<td colspan="3" class="tituloAlterno" align="center">
					<strong>Listado de Conceptos de Evaluación <br>
      (<cfoutput>Periodo: &nbsp; &nbsp; #rsPeriodoReporte.PEdescripcion#</strong></cfoutput>) 
    </td>
		</tr>
	<tr> 
		<td colspan="3" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
	</tr>
	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr>
 </table> 
 <cfif isdefined("form.btnGenerar")>
 	<cfset maxCols = 3>
 	<cfif cons1.recordCount GT 0>
	<!--- 	<cfif cons1.recordCount GT 0 > --->
			<cfoutput> 
					<cfset Prof = "">
					<cfset Curso = "">
					<cfset Materia = "">
					<table width="100%" cellspacing="0">
					<cfloop query="cons1">
						<cfif Curso NEQ cons1.NombreCurso>
							<cfset Curso = Cons1.NombreCurso>
							<cfset Concepto = Cons1.NombConcepto>
								<cfif #form.rdCortes# EQ 'CxG' and #cons1.CurrentRow# NEQ 1 and isdefined("url.rdCortes")>
									<!--- <table border="0" cellpadding="0" cellspacing="0" width="100%"> --->
										<tr class="pageEnd">
											<td colspan="3" valign="top">&nbsp;</td>
										</tr>
										<tr class="area"> 
											<td colspan="2">Servicios Digitales al Ciudadano</td>
											<!--- <td width="20%">&nbsp;</td> --->
					  						<td  align="right">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
										</tr>
											<tr class="area"> 
											<td colspan="2">www.migestion.net</td>
											<!--- <td>&nbsp;</td> --->
					  					<td align="right">Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
										</tr>
											<tr class="area" align="center"> 
												<td colspan="3" class="tituloAlterno" align="center">
													<strong>Listado de Conceptos de Evaluación <br>
                  (Periodo: &nbsp; &nbsp; #rsPeriodoReporte.PEdescripcion#</strong>) 
                </td>
											</tr>
										<tr> 
											<td colspan="3" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
										</tr>
										<tr> 
											<td colspan="3">&nbsp;</td>
										</tr>
									<!--- </table>  --->
								</cfif> 
							<!--- <cfif Prof NEQ cons1.Profesor> --->
							<cfset Prof = cons1.Profesor>
							<cfif #form.rdCortes# EQ 'CxG' and isdefined("url.rdCortes")>
							
								<tr >
									<td width="40%"  align="left"  nowrap ><strong>Profesor: &nbsp; &nbsp; #cons1.Profesor# &nbsp; </strong></td>
									<td width="40%" align="right"  nowrap >&nbsp;</td>
									<td width="20%" align="right"  nowrap ><strong><!--- Periodo 
									de Evaluación: &nbsp; &nbsp; #rsPeriodoReporte.PEdescripcion#  --->&nbsp; </strong></td>
								</tr>
							</cfif> 
							<cfif not isdefined("url.rdCortes")>
							<!--- pintar aqui los datos de la materia --->
							<tr class="subTitulo">
								<td  width="40%" align="left"  class="encabReporte"  nowrap ><strong>Curso &nbsp; &nbsp;<!---  #Cons1.NombreCurso# ---> &nbsp; </strong></td>
								<td  width="40%" align="center"  class="encabReporte"  nowrap ><strong>Concepto de Evaluación &nbsp; &nbsp;<!---  #Cons1.NombreCurso# ---> &nbsp; </strong></td>
				                <td  width="20%" align="center"  class="encabReporte"  nowrap ><strong>Porcentaje 
                  % &nbsp; &nbsp; 
                  <!---  #Cons1.NombreCurso# --->
                  &nbsp; </strong></td>
								<!--- <td  width="20%"align="left"  class="encabReporte"  nowrap ><strong>&nbsp; </strong></td> --->
							</tr>
							<cfelse>
								<!--- pintar aqui los datos de la materia --->
								<tr >
									<td  width="40%" align="left"    nowrap ><strong>Curso &nbsp; &nbsp;<!---  #Cons1.NombreCurso# ---> &nbsp; </strong></td>
									<td  width="40%" align="center"  nowrap ><strong>Concepto de Evaluación &nbsp; &nbsp;<!---  #Cons1.NombreCurso# ---> &nbsp; </strong></td>
									<td  width="20%" align="center"  nowrap ><strong>Porcentaje % &nbsp; &nbsp; &nbsp; </strong></td>
								</tr>
							</cfif>
 
						</cfif>
						<tr class="subTitulo"
							<cfif #cons1.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #cons1.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" > 
							<td width="40%" nowrap style="border: 1px solid ##000000"> 
								<cfif Compare(Trim(Materia),Trim(cons1.MateriaNombre)) NEQ 0>
									<cfset Materia = cons1.MateriaNombre >
									#Materia#  
								<cfelse>
									 &nbsp; 
								</cfif>
							</td>
							<td width="40%" nowrap align="center" style="border: 1px solid ##000000"> 
								#cons1.NombConcepto# 
							</td>
							<td width="20%" nowrap align="center" style="border: 1px solid ##000000"> 
								#cons1.Porcentaje# 
							</td>
						</tr>
						
					</cfloop>
					</table>
				</cfoutput> 
			<table width="100%"  cellspacing="0">
				<tr> 
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="4" align="center"> ------------------ Fin del Reporte ------------------ </td>
				</tr>
			</table>
		<!--- </cfif> --->
	<cfelse>
		<table width="100%" border="1" cellspacing="0"> 			
			<tr> 
				<td colspan="4" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">El 
				Curso no tiene Conceptos de Evaluación definidos</td>
			</tr>
			<tr> 
				<td colspan="4" align="center"> ------------------ 1 - No existen 
				Conceptos de Evaluación, para el curso solicitado  ------------------ </td>
			</tr>
			<tr> 
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr> 
				<td colspan="4" align="center"> ------------------ Fin del Reporte ------------------ </td>
			</tr>
		</table>
	</cfif>
</cfif>