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
	<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
		<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
	</cfif> 
	<cfif isdefined("Url.ckObs") and not isdefined("Form.ckObs")>
		<cfparam name="Form.ckObs" default="#Url.ckObs#">
	</cfif> 

	<!--- Consultas --->
  	<cfquery datasource="#Session.Edu.DSN#" name="rsEvaluaciones_Principal">
		set nocount on
			exec sp_EVALUACIONES
				@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				,@grupo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">			
				
				<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'>
					,@alumno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">			
				</cfif>
				<cfif isdefined('form.Ncodigo') and form.Ncodigo NEQ '-1' >
					,@nivel=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">			
				</cfif>				
				<cfif isdefined('form.PEcodigo') and form.PEcodigo NEQ '' >
					,@periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">			
				</cfif> 
 				<cfif isdefined('form.ECcodigo') and form.ECcodigo NEQ '-1' >
					,@concepto=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECcodigo#">			
				</cfif>
				<cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ '-1' >
					,@materia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">			
				</cfif> 								
		set nocount off
	</cfquery>	
	
	<cfquery name="rsEvaluaciones" dbtype="query">
		Select Ccodigo , GRcodigo, GRnombre, Ncodigo, Ndescripcion, Ecodigo, persona, NombreAl, Mconsecutivo, Mnombre ,
		    ECcodigo, ECnombreConcepto, PEcodigo, PEdescripcion, ECnombre, ECcomponente, EVTcodigo, ACvalor, ACnota, Nota, ECCporcentaje, TipoNI 
		from rsEvaluaciones_Principal
		where TipoNI = 'N'
	</cfquery>
	<cfif isdefined('form.ckInci')>	<!--- Sub Consulta para las Incidencias por alumno --->
		<cfquery name="cons1" dbtype="query">
			select *
			from rsEvaluaciones_Principal 
			where TipoNI = 'I'
			order by Norden, Gorden, Morden, Cnombre, NombreAl, fecha asc
		</cfquery>	
	</cfif>

	<cfquery name="rsConceptos" dbtype="query">
		Select distinct ECcodigo,ECnombreConcepto
		from rsEvaluaciones
		order by ECnombreConcepto
	</cfquery>

	 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
		select CEnombre from CentroEducativo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	</cfquery>
	<cfif isdefined('form.ckObs')>	<!--- Las Observaciones --->
		<cfquery name="rsPeriodos" dbtype="query">
			Select distinct PEcodigo,PEdescripcion
			from rsEvaluaciones
		</cfquery> 
	</cfif>
	
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
    <td><!--- Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput> ---></td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="3" align="center" class="tituloAlterno">
		<strong>
			<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
				<cfoutput>#form.TituloRep#</cfoutput>			
			<cfelse>
        REPORTE DE EVALUACIONES 
      </cfif>
		</strong>
	</td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="3" align="center" class=>
      <strong>GRUPO: <cfoutput>#rsEvaluaciones.GRnombre#</cfoutput></strong>
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
		<cfif rsConceptos.recordCount GT 0>
			<cfset tamEval = 92 - (rsConceptos.recordCount * 10)>
		</cfif>
		<cfif rsEvaluaciones.recordCount GT 0>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">		
				<cfloop query="rsEvaluaciones"><cfoutput>
					<cfif vAlumno NEQ rsEvaluaciones.NombreAl>
						<cfset vContAlumnos = vContAlumnos + 1>
						<cfif vContMaterias GT 0>	<!--- Materia --->
							<tr>
								<td> 						
									<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
									  <tr> 
										<td width="2%">&nbsp;</td>									  
										<td align="left" width="#tamEval#%">#vMateriaDescr#</td>
										<cfloop query="rsConceptos">
											<cfset vExisteNota = 0>										
											<cfloop index = "LoopCountNotas" from = "1" to = "#ArrayLen(ArrayNotas)#">
												<cfif rsConceptos.ECcodigo EQ ArrayNotas[LoopCountNotas][2]>
													<cfset vExisteNota = 1> 												
													<td nowrap width="10%" align="center">
														<cfif isdefined('form.ckPxC')><strong>(#ArrayNotas[LoopCountNotas][1]# %)</strong></cfif>&nbsp;&nbsp;
														#ArrayNotas[LoopCountNotas][3]#
													</td>
												</cfif>
											</cfloop>
											
											<cfif vExisteNota EQ 0>
													<td width="10%" align="center">&nbsp;</td>											
											</cfif>											
										</cfloop>											
									  </tr>
									</table>
								</td>
							</tr> 

							<cfif isdefined('form.ckInci')>
								<!--- AQUI PONER LAS INCIDENCIAS --->							
								<tr>
									<td>
										<cfinclude template="incidenciasObs.cfm"> 
									</td>
								</tr>
								<!--- Hasta Aqui INCIDENCIAS --->														
							</cfif>
						</cfif>
						
						<cfset vAlumno ="#rsEvaluaciones.NombreAl#">
						<cfset Temp = ArrayClear(ArrayNotas)>											
						<cfset vMateria ="">					
						<cfset vConcepto ="">						
						<cfset vContMaterias = 0>
						<cfset vContConcepto = 0>						
					
						<cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA' and vContAlumnos GT 1 and isdefined('form.imprime')>
									<tr>
										<td>
											<cfinclude template="AgregadosListaEvalPree.cfm">						
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
									
						<tr class="pageEnd"><!--- Corte por Impresión --->
							<td colspan="3">&nbsp;
								
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
										<td><!--- Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput> ---></td>
									  </tr>
									  <tr class="tituloAlterno"> 
										<td colspan="3" align="center" class="tituloAlterno">
											<strong>
												<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
													<cfoutput>#form.TituloRep#</cfoutput>			
												<cfelse>
											REPORTE DE EVALUACIONES 
										  </cfif>
											</strong>
										</td>
									  </tr>
									  <tr class="tituloAlterno"> 
										<td colspan="3" align="center" class=>
										  <strong>GRUPO: <cfoutput>#rsEvaluaciones.GRnombre#</cfoutput></strong>
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
									
                <td width="50%">Alumno :&nbsp;<strong><font size="2">#rsEvaluaciones.NombreAl#</font></strong></td>
									<td width="50%">Grupo: #rsEvaluaciones.GRnombre#</td>
								  </tr>
								  <tr>
									<td>Nivel: #rsEvaluaciones.Ndescripcion#</td>
			                        <td>Per&iacute;odo de Evaluaci&oacute;n: #rsEvaluaciones.PEdescripcion#</td>
								  </tr>
								</table>
							</td>
						</tr>
 						<tr> 
							<td>
								<!--- Encabezado de los Conceptos --->				
								<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">								
								  <tr> 
									<td width="2%">&nbsp;</td>
			                        <td width="#tamEval#%"><strong>MATERIA</strong></td>
									<cfloop query="rsConceptos">
										<td width="10%" align="center"><strong><cfif isdefined('form.ckPxC')>(%)</cfif>&nbsp;&nbsp;#rsConceptos.ECnombreConcepto#</strong></td>
									</cfloop>
								  </tr>
								</table>							
							</td>
						</tr> 					
					</cfif>
					
					<cfif vMateria NEQ rsEvaluaciones.Mconsecutivo>	<!--- Materia --->
						<cfif vContMaterias GT 0>	<!--- Detalle del listado por materia --->				
							<tr>
								<td> 						
									<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
									  <tr> 				
										
                    <td width="2%">&nbsp;</td>									  
										<td align="left" width="#tamEval#%">#vMateriaDescr#</td>									  
										<cfloop query="rsConceptos">
											<cfset vExisteNota = 0>										
 											<cfloop index = "LoopCountNotas" from = "1" to = "#ArrayLen(ArrayNotas)#">
												<cfif rsConceptos.ECcodigo EQ ArrayNotas[LoopCountNotas][2]>
													<cfset vExisteNota = 1> 												
													<td nowrap width="10%" align="center">
														<cfif isdefined('form.ckPxC')><strong>(#ArrayNotas[LoopCountNotas][1]# %)</strong></cfif>&nbsp;&nbsp;
														#ArrayNotas[LoopCountNotas][3]#
													</td>
												</cfif>
											</cfloop> 
											
											<cfif vExisteNota EQ 0>
												<td width="10%" align="center">&nbsp;</td>											
											</cfif>											
										</cfloop>
									  </tr>
									</table>
								</td>
							</tr> 
														
							<cfset Temp = ArrayClear(ArrayNotas)>					
							<cfset vConcepto ="">
							<cfset vContConcepto = 0>
						</cfif>
						<cfset vContMaterias = vContMaterias + 1>
						<cfset vMateria ="#rsEvaluaciones.Mconsecutivo#">												  
						<cfset vMateriaDescr ="#rsEvaluaciones.Mnombre#">												  						
						
						<cfif vConcepto NEQ rsEvaluaciones.ECcodigo>	<!--- Concepto --->
							<cfset vConcepto ="#rsEvaluaciones.ECcodigo#">												  
							<cfset vContConcepto = vContConcepto + 1>
							
							<cfset hijoNotas[1] =  rsEvaluaciones.ECCporcentaje>
							<cfset hijoNotas[2] =  rsEvaluaciones.ECcodigo>							
							<cfset hijoNotas[3] =  rsEvaluaciones.Nota>							
							<cfset ArrayNotas[#vContConcepto#] = hijoNotas>														
						</cfif>
					<cfelse>
						<cfif vConcepto NEQ rsEvaluaciones.ECcodigo>	<!--- Concepto --->
							<cfset vConcepto ="#rsEvaluaciones.ECcodigo#">												  
							<cfset vContConcepto = vContConcepto + 1>
							
							<cfset hijoNotas[1] =  rsEvaluaciones.ECCporcentaje>
							<cfset hijoNotas[2] =  rsEvaluaciones.ECcodigo>							
							<cfset hijoNotas[3] =  rsEvaluaciones.Nota>							
							<cfset ArrayNotas[#vContConcepto#] = hijoNotas>							
						<cfelse>
							<cfset hijoNotas[1] =  rsEvaluaciones.ECCporcentaje>
							<cfset hijoNotas[2] =  rsEvaluaciones.ECcodigo>							
							<cfset hijoNotas[3] =  hijoNotas[3] + rsEvaluaciones.Nota>							
							<cfset ArrayNotas[#vContConcepto#] = hijoNotas>						
						</cfif>
					</cfif>					
				</cfoutput></cfloop>
				
				<cfoutput>
					<cfif vContMaterias GT 0>	<!--- Detalle del listado por materia --->				
						<tr>
							<td> 						
								<table width="100%" border="0" cellspacing="1" cellpadding="1" class="subrayado">
								  <tr> 
									<td width="2%">&nbsp;</td>									  
									<td align="left" width="#tamEval#%">#vMateriaDescr#</td>								
										<cfloop query="rsConceptos">
											<cfset vExisteNota = 0>										
 											<cfloop index = "LoopCountNotas" from = "1" to = "#ArrayLen(ArrayNotas)#">
												<cfif rsConceptos.ECcodigo EQ ArrayNotas[LoopCountNotas][2]>
													<cfset vExisteNota = 1> 												
													<td nowrap width="10%" align="center">
														<cfif isdefined('form.ckPxC')><strong>(#ArrayNotas[LoopCountNotas][1]# %)</strong></cfif>&nbsp;&nbsp;
														#ArrayNotas[LoopCountNotas][3]#
													</td>
												</cfif>
											</cfloop>
											
											<cfif vExisteNota EQ 0>
												<td width="10%" align="center">&nbsp;</td>											
											</cfif>											
										</cfloop>									
								  </tr>
								</table>
							</td>
						</tr> 
						<cfif isdefined('form.ckInci')>
							<!--- AQUI PONER LAS INCIDENCIAS --->							
							<tr>
								<td>
									<cfinclude template="incidenciasObs.cfm"> 
								</td>
							</tr>
							<!--- Hasta Aqui INCIDENCIAS --->														
						</cfif>

						<cfset Temp = ArrayClear(ArrayNotas)>					
						<cfset vConcepto ="">
						<cfset vContConcepto = 0>
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
    <td><cfinclude template="AgregadosListaEvalPree.cfm">
	</td>
  </tr>
  <tr>
    <td align="center">------------------ Fin del Reporte ------------------</td>
  </tr>
</table>