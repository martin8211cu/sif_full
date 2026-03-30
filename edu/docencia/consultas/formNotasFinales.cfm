 	<cfif isdefined("Url.Grupo") and not isdefined("Form.Grupo")>
		<cfparam name="Form.Grupo" default="#Url.Grupo#">
	</cfif> 
	<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
		<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
	</cfif> 
	
	<cfif isdefined("Url.ECcodigo") and not isdefined("Form.ECcodigo")>
		<cfparam name="Form.ECcodigo" default="#Url.ECcodigo#">
	</cfif> 	
	<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
	</cfif> 
	<cfif isdefined("Url.TituloRep") and not isdefined("Form.TituloRep")>
		<cfparam name="Form.TituloRep" default="#Url.TituloRep#">
	</cfif> 	
	<cfif isdefined("Url.FechaRep") and not isdefined("Form.FechaRep")>
		<cfparam name="Form.FechaRep" default="#Url.FechaRep#">
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
	<cfif isdefined("Url.ckPxC") and not isdefined("Form.ckPxC")>
		<cfparam name="Form.ckPxC" default="#Url.ckPxC#">
	</cfif> 
	<cfif isdefined("Url.ckEst") and not isdefined("Form.ckEst")>
		<cfparam name="Form.ckEst" default="#Url.ckEst#">
	</cfif> 
	<cfif isdefined("Url.ckPG") and not isdefined("Form.ckPG")>
		<cfparam name="Form.ckPG" default="#Url.ckPG#">
	</cfif> 

	<cfif isdefined("Url.ckPCF") and not isdefined("Form.ckPCF")>
		<cfparam name="Form.ckPCF" default="#Url.ckPCF#">
	</cfif> 
	<cfif isdefined("Url.ckEsc") and not isdefined("Form.ckEsc")>
		<cfparam name="Form.ckEsc" default="#Url.ckEsc#">
	</cfif> 
	
	<cfif isdefined("Url.ckInci") and not isdefined("Form.ckInci")>
		<cfparam name="Form.ckInci" default="#Url.ckInci#">
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
	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif> 
	<cfif isdefined("Url.ckObs") and not isdefined("Form.ckObs")>
		<cfparam name="Form.ckObs" default="#Url.ckObs#">
	</cfif> 

	<!--- Consultas --->
  	<cfquery datasource="#Session.Edu.DSN#" name="rsNotasFinales_Principal">
		set nocount on
			exec sp_NOTASFINALES 
				@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				,@grupo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">			
				
				<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'>
					,@alumno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">			
				</cfif>
				<cfif isdefined('form.Ncodigo') and form.Ncodigo NEQ '-1' >
					,@nivel=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">			
				</cfif>				
				<!--- <cfif isdefined('form.PEcodigo') and form.PEcodigo NEQ '' >
					,@periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">			
				</cfif> 
 				<cfif isdefined('form.ECcodigo') and form.ECcodigo NEQ '-1' >
					,@concepto=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECcodigo#">			
				</cfif>
				<cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ '-1' >
					,@materia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">			
				</cfif>  --->								
		set nocount off
	</cfquery>	

	<cfquery name="rsNotasFinales" dbtype="query">
		Select *
		from rsNotasFinales_Principal
		where TipoNI = 'N'
		order by NombreAl, Orden, Mconsecutivo
		<!--- order by NombreAl, Norden, Gorden, Morden, GRnombre, PEorden, PEdescripcion, fecha --->
	</cfquery>

	<cfif isdefined('form.ckObs')>	<!--- Las Observaciones --->
		<cfquery name="rsPeriodos" dbtype="query">
			Select distinct PEcodigo,PEdescripcion
			from rsNotasFinales
		</cfquery> 
	</cfif>
	<cfif isdefined('form.ckInci')>	<!--- Sub Consulta para las Incidencias por alumno --->
		<cfquery name="cons1" dbtype="query">
			select *
			from rsNotasFinales_Principal 
			where TipoNI = 'I'
			order by Norden, Gorden, Morden, Cnombre, NombreAl, fecha asc
		</cfquery>	
	</cfif>

	<cfquery name="rsPeriodos" dbtype="query">
		select distinct PEdescripcion 
		from rsNotasFinales
		order by PEorden
	</cfquery>	
	<cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
		select CEnombre from CentroEducativo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	</cfquery>
	
	<cfset ArrayNotas = ArrayNew(1)>
	<cfset hijoNotas = ArrayNew(1)>
	
<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="area"> 
    <td width="62%"><font size="2">Servicios Digitales al Ciudadano</font></td>
    <td width="17%">&nbsp;</td>
    <td width="21%">Fecha de Entrega: <cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#LSdateFormat(Now(),'dd/MM/YY')#</cfif></cfoutput> </td>
  </tr>
  <tr class="area"> 
    <td><font size="2">www.migestion.net</font></td>
    <td>&nbsp;</td>
    <td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="3" align="center" class="tituloAlterno">
		<strong>
			<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
				<cfoutput>#form.TituloRep#</cfoutput>			
			<cfelse>
        REPORTE DE NOTAS FINALES 
      </cfif>
		</strong>
	</td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="3" align="center" class=>
      <strong>GRUPO: <cfoutput>#rsNotasFinales.GRnombre#</cfoutput></strong>
	</td>
  </tr>  
  <tr> 
    <td colspan="3" align="center" class="tituloAlterno"> <strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong> <hr></td>
  </tr>
  
	<cfset vMateria ="">
	<cfset vMateriaDescr ="">
	<cfset vConcepto ="">
	<cfset vComponente ="">
	<cfset vAlumno ="">
	<cfset tamEval = 96>
	<cfset vContConcepto = 0>
	<cfset vContAlumnos = 0>  
	<cfset vContMaterias = 0> 
	<cfset vExisteNota = 0>  
  
  <tr> 
   <td colspan="3"> 
		<cfif rsNotasFinales.recordCount GT 0>
			<cfset tamEval = 96 - (rsNotasFinales.recordCount * 15)>
		</cfif>
		<cfif rsNotasFinales.recordCount GT 0>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">		
				<cfloop query="rsNotasFinales"><cfoutput>
					<cfif vAlumno NEQ rsNotasFinales.NombreAl>
						<cfset NumTitElect = 0>
						<cfset vContAlumnos = vContAlumnos + 1>
						<cfif vContMaterias GT 0>	<!--- Materia --->
							<tr>
								<td> 						
									<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
									  <tr> 
										
                  <td width="4%" nowrap></td>									  
										<td width="#tamEval#%">#vMateriaDescr#</td>
										<cfif vExisteNota EQ 0>
												<td width="15%" align="center">&nbsp;</td>											
										</cfif>											
									  </tr>
									</table>
								</td>
							</tr> 
							<cfif isdefined('form.ckPG')>
								<tr>
									<td> 
										<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
											<tr> 
												<td  nowrap width="4%"></td>									  
												<td width="#tamEval#%"><strong>PROMEDIO FINAL</strong>
													<cfset prom = 0>
													<cfquery name="rsPromedio" dbtype="query">
														 select sum(Cal_Per) as Promedio, count(*) as num 
														 from rsNotasFinales
														 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
														 and Cal_Per > 0
														 and Orden in (0,1)
														 group by PEdescripcion
													</cfquery> 
												</td>
												<!--- <cfset PromGen = 0>
												<cfset NumPer = 0> --->
												<cfloop query="rsPromedio">
													<cfset prom = rsPromedio.Promedio / rsPromedio.num > 
													<!--- <cfset PromGen = PromGen + prom>
													<cfset NumPer = NumPer+1> --->
													<td width="15%" align="center" ><cfoutput>#LSNumberFormat(prom,"0.00")#</cfoutput></td>
												</cfloop>
												<cfif isdefined('form.ckPCF')>
<!--- 													<cfset UltPromGen = PromGen / NumPer> --->
													<cfset PromFin = 0>
													<cfquery name="rsPromedioFin" dbtype="query">
														 select sum(Cal_PerFin) as PromedioFin, count(*) as numFin
														 from rsNotasFinales
														 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
														   and Cal_PerFin > 0
														   and Orden in (0,1)
														 group by PEdescripcion
													</cfquery> 
													<td width="15%" align="center" >
														<strong>
															<cfoutput>
																<cfif len(trim(rsPromedioFin.PromedioFin)) GT 0 and  len(trim(rsPromedioFin.NumFin)) GT 0>
																	<cfset UltPromGen = rsPromedioFin.PromedioFin / rsPromedioFin.NumFin>
																	 #LSNumberFormat(UltPromGen,"0.00")#
																<cfelse>
																	&nbsp;	 
																</cfif>
															</cfoutput>
														</strong>
								                   </td> 
					  								<td width="15%" align="center" ><strong>
														<cfquery name="rsAplazadoFin" dbtype="query">
															 select count(*) as Numaplazado
															 from rsNotasFinales
															 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
															   and Cal_PerFin < NotaMinima 
															   and Cal_PerFin > 0
															   and Orden in (0,1)
															
														</cfquery> 

														<cfif rsAplazadoFin.RecordCount GT 0 >
															<cfif rsAplazadoFin.Numaplazado EQ 0>
																Promovido
															<cfelseif rsAplazadoFin.Numaplazado LT 4>
																Aplazado
															<cfelseif rsAplazadoFin.Numaplazado GTE 4>
																Aplazado del Grado
															<cfelse>
																&nbsp;
															</cfif>
														</cfif>
													</td>
												</cfif>
											</tr>
										</table>
									</td>
								</tr> 
							</cfif>
							<cfif isdefined('form.ckEsc')>
							<!---   <table width="100%" border="0" cellspacing="1" cellpadding="1"> --->
								<!--- <tr> 
								  <td>&nbsp;</td>
								  <td>&nbsp;</td>
								</tr>   --->
								<tr> 
								  <td  class="areaFiltro" align="center"><strong>ESCALA DE VALORACI&Oacute;N</strong></td>
								</tr>
								<cfif isdefined('form.ckEsc')>
									<cfquery name="rsEvaluacValores" dbtype="query">
										Select distinct EVTcodigo
										from rsNotasFinales
										where NombreAl =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#vAlumno#">
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
								<tr> 
								  <td align="center"  class="subrayado">N / A = No Aplica</td>
								  <!--- <td class="subrayado">No Aplica</td> --->
								</tr>
								<cfif isdefined('rsEscValoracion')>
									<cfoutput>
										<cfloop query="rsEscValoracion">
											<tr> 
											  <td align="center" class="subrayado">#rsEscValoracion.EVvalor# = #rsEscValoracion.EVdescripcion#</td>
											 <!---  <td class="subrayado">#rsEscValoracion.EVdescripcion#</td> --->
											</tr>
										</cfloop>	
									</cfoutput>
								</cfif>
							 <!---  </table> --->
							</cfif>
						</cfif>
						<cfif isdefined('form.ckInci') and vContAlumnos GT 1>
							<!--- AQUI PONER LAS INCIDENCIAS --->							
							<tr>
								<td>
									<cfinclude template="incidenciasNotas.cfm"> 
								</td>
							</tr>
							<!--- Hasta Aqui INCIDENCIAS --->														
						</cfif>
						<cfset vAlumno ="#rsNotasFinales.NombreAl#">
						<cfset Temp = ArrayClear(ArrayNotas)>											
						<cfset vMateria ="">					
						<cfset vContMaterias = 0>

						<cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA' and vContAlumnos GT 1 and isdefined('form.imprime')>
									<tr>
										<td>
											<cfinclude template="AgregadosNotasFinales.cfm">						
										</td>
									</tr>
									<tr>
										<td align="center">
											------------------ Fin del Reporte ------------------								
										</td>
									</tr>
								</table>
							</td>
						</tr>	<!--- Cierra fila externa con el colspan de 3 --->						
									
						<tr class="pageEnd">	<!--- Corte por Impresión --->
							<td colspan="3">
								<!--- <br class="pageEnd"> ---> &nbsp;
							</td>
						</tr>
				<tr>
					<td colspan="3">										
						<table width="100%" border="0" cellspacing="1" cellpadding="1">							
							<tr>
								<td>							
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr class="area"> 
										<td width="62%"><font size="2">Servicios Digitales al Ciudadano</font></td>
										<td width="17%">&nbsp;</td>
										<td width="21%">Fecha de Entrega: <cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#LSdateFormat(Now(),'dd/MM/YY')#</cfif></cfoutput> </td>
									  </tr>
									  <tr class="area"> 
										<td><font size="2">www.migestion.net</font></td>
										<td>&nbsp;</td>
										<td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
									  </tr>
									  <tr class="tituloAlterno"> 
										<td colspan="3" align="center" class="tituloAlterno">
											<strong>
												<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
													<cfoutput>#form.TituloRep#</cfoutput>			
												<cfelse>
											REPORTE DE NOTAS FINALES 
										  </cfif>
											</strong>
										</td>
									  </tr>
									  <tr class="tituloAlterno"> 
										<td colspan="3" align="center" class=>
										  <strong>GRUPO: <cfoutput>#rsNotasFinales.GRnombre#</cfoutput></strong>
										</td>
									  </tr>  
									  <tr> 
										<td colspan="3" align="center" class="tituloAlterno"> <strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong> <hr></td>
									  </tr>							
									</table>
								</td>
							</tr>									
						</cfif>
						<tr> 
               			 	<td class="areaFiltro"> 
								<table width="100%" border="0" cellspacing="1" cellpadding="1">
								  <tr>
									<td width="50%">Alumno :#rsNotasFinales.NombreAl#</td>
									<td width="50%">Grupo: #rsNotasFinales.GRnombre#</td>
								  </tr>
								  <tr>
									<td>Nivel: #rsNotasFinales.Ndescripcion#</td>
			                        <td><!--- Per&iacute;odo de Evaluaci&oacute;n: #rsNotasFinales.PEdescripcion# ---> &nbsp</td>
								  </tr>
								</table>
							</td>
						</tr>
 						<tr> 
							<td>
								<!--- Encabezado de los Conceptos --->				
								<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">								
								  <tr> 
									<td width="4%">&nbsp;</td>
			                        <td width="#tamEval#%"><strong>MATERIA</strong></td>
									<cfif isdefined('form.ckPxC')>
										<cfloop query="rsPeriodos">
											<td width="15%" align="center"><strong>#rsPeriodos.PEdescripcion#</strong></td>
										</cfloop>
									</cfif>
									<cfif isdefined('form.ckPCF')>
										<td width="15%" align="center"><strong>%Promedio por curso</strong></td>
									</cfif>
									<cfif isdefined('form.ckEst')>
										<td width="15%" align="center"><strong>Estado</strong></td>
									</cfif>

								  </tr>
								</table>							
							</td>
						</tr> 					
					</cfif>
					
					<cfif vMateria NEQ rsNotasFinales.Mconsecutivo>	<!--- Materia --->
						<!--- <cfset vContMaterias = vContMaterias + 1> --->
						<cfset vMateria ="#rsNotasFinales.Mconsecutivo#">												  
						<cfset vMateriaDescr ="#rsNotasFinales.Mnombre#">
											
						<cfif vContMaterias GT 0>	<!--- Detalle del listado por materia --->				
							<tr>
								<td> 						
									<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
										<cfif rsNotasFinales.Orden EQ 1  and NumTitElect EQ 0>
											<cfset NumTitElect = 1>
											<tr>
												<td width="4%">&nbsp;</td>
												<td width="#tamEval#%"><strong>ELECTIVAS</strong></td>			
											</tr>
										</cfif>
									  <tr> 				
										<td width="4%">&nbsp;</td>									  
										<td width="#tamEval#%">#vMateriaDescr#</td>
										<cfquery name="rsNotas" dbtype="query">
											 select *
											 from rsNotasFinales
											 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
											   and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMateria#"> 
										</cfquery>
										<cfif isdefined('form.ckPxC')>
											<cfset cant = 0>
											<cfloop query="rsNotas">
												<td width="15%" align="center">#rsNotas.Calificacion_Periodo# </td>
											 </cfloop>  
										</cfif>
										<cfif isdefined('form.ckPCF')>
											<td width="15%" align="center"><strong>#rsNotas.Calificacion_Final#</strong></td>
										</cfif>
										<cfif isdefined('form.ckEst')>
											
											<td width="15%" align="center">
												<strong>
												<cfif len(trim(#rsNotas.Calificacion_Final#)) NEQ 0 and  #rsNotas.Calificacion_Final# LT #rsNotas.NotaMinima#>
													Aplazado
												<cfelseif len(trim(#rsNotas.Calificacion_Final#)) NEQ 0 and  #rsNotas.Calificacion_Final# GTE #rsNotas.NotaMinima#>
													Promovido
												<cfelse>
													&nbsp;
												</cfif>
												
												</strong>
											</td>
										</cfif>
										
									  </tr>
									</table>
								</td>
							</tr> 
														
						</cfif>
						<cfset vContMaterias = vContMaterias + 1>
					</cfif>					
				</cfoutput></cfloop>
				<cfoutput>
				
					<cfif vContMaterias GT 0>	<!--- Detalle del listado por materia --->				
						<tr>
							<td> 						
								<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
									<cfif rsNotasFinales.Orden EQ 1 and NumTitElect EQ 0>
										<cfset NumTitElect = 1>
										<tr>
											<td width="4%">&nbsp;</td>
											<td width="#tamEval#%"><strong>ELECTIVAS</strong></td>			
										</tr>
									</cfif>
								  <tr> 
									<td width="4%">&nbsp;</td>									  
									<td width="#tamEval#%"><!--- #vMateriaDescr# ---></td>								
								  </tr>
								</table>
							</td>
						</tr>
						<cfif isdefined('form.ckPG')>
								<tr>
									<td> 
										<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
											<tr> 
												<td  nowrap width="4%">&nbsp;</td>									  
												<td width="#tamEval#%"><strong>PROMEDIO FINAL</strong>
													<cfset prom = 0>
													<cfquery name="rsPromedio" dbtype="query">
														 select sum(Cal_Per) as Promedio, count(*) as num 
														 from rsNotasFinales
														 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
														 and Cal_Per > 0
														 and Orden in (0,1)
														 group by PEdescripcion
													</cfquery> 
												</td>
												<cfloop query="rsPromedio">
													<cfset prom = rsPromedio.Promedio / rsPromedio.num > 
													<td width="15%" align="center" ><cfoutput>#LSNumberFormat(prom,"0.00")#</cfoutput></td>
												</cfloop>
												<cfif isdefined('form.ckPCF')>
													<cfset PromFin = 0>
													<cfquery name="rsPromedioFin" dbtype="query">
														 select sum(Cal_PerFin) as PromedioFin, count(*) as numFin
														 from rsNotasFinales
														 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
														   and Cal_PerFin > 0
														   and Orden in (0,1)
														 group by PEdescripcion
													</cfquery> 
													
														<strong>
															<cfoutput>
																<cfif len(trim(rsPromedioFin.PromedioFin)) GT 0 and  len(trim(rsPromedioFin.NumFin)) GT 0>
																	<cfset UltPromGen = rsPromedioFin.PromedioFin / rsPromedioFin.NumFin>
																	 <td width="15%" align="center" >
																	 	#LSNumberFormat(UltPromGen,"0.00")#
													                 </td> 																	 
																</cfif>
															</cfoutput>
														</strong>
					  								<td width="15%" align="center" ><strong>
														<cfquery name="rsAplazadoFin" dbtype="query">
															 select count(*) as Numaplazado
															 from rsNotasFinales
															 where NombreAl = <cfqueryparam cfsqltype="cf_sql_char" value="#vAlumno#">
															   and Cal_PerFin < NotaMinima 
															   and Cal_PerFin > 0
															   and Orden in (0,1)
														</cfquery> 
														<cfif rsAplazadoFin.RecordCount GT 0 >
															<cfif rsAplazadoFin.Numaplazado EQ 0>
																Promovido
															<cfelseif rsAplazadoFin.Numaplazado LT 4>
																Aplazado
															<cfelseif rsAplazadoFin.Numaplazado GTE 4>
																Aplazado del Grado
															<cfelse>
																&nbsp;
															</cfif>
														</cfif>
													</td>
													
												</cfif>
											</tr>
										</table>
									</td>
								</tr> 
							</cfif>
						<cfif isdefined('form.ckEsc')>
								<tr> 
								  <td  class="areaFiltro" align="center"><strong>ESCALA DE VALORACI&Oacute;N</strong></td>
								</tr>
								<cfif isdefined('form.ckEsc')>
									<cfquery name="rsEvaluacValores" dbtype="query">
										Select distinct EVTcodigo
										from rsNotasFinales
										where NombreAl =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#vAlumno#">
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
								<tr> 
								  <td align="center"  class="subrayado">N / A = No Aplica</td>
								  <!--- <td class="subrayado">No Aplica</td> --->
								</tr>
								<cfif isdefined('rsEscValoracion')>
									<cfoutput>
										<cfloop query="rsEscValoracion">
											<tr> 
											  <td align="center" class="subrayado">#rsEscValoracion.EVvalor# = #rsEscValoracion.EVdescripcion#</td>
											 <!---  <td class="subrayado">#rsEscValoracion.EVdescripcion#</td> --->
											</tr>
										</cfloop>	
									</cfoutput>
								</cfif>
							 <!---  </table> --->
							</cfif>
						<!--- </cfif> --->
	
						<cfif isdefined('form.ckInci')>
							<!--- AQUI PONER LAS INCIDENCIAS --->							
							<tr>
								<td>
									<cfinclude template="incidenciasNotas.cfm"> 
								</td>
							</tr>
							<!--- Hasta Aqui INCIDENCIAS --->														
						</cfif>

						<!--- <cfset Temp = ArrayClear(ArrayNotas)>					
						<cfset vConcepto ="">
						<cfset vContConcepto = 0> --->
					</cfif>			
				</cfoutput>				
			</table>			
		<cfelse>
			&nbsp;
		</cfif>
	</td>
  </tr>   
</table>

<!--- Area de Firmas--->

<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td><cfinclude template="AgregadosNotasFinales.cfm"></td>
  </tr>
  <tr>
    <td align="center">------------------ Fin del Reporte ------------------</td>
  </tr>
</table>