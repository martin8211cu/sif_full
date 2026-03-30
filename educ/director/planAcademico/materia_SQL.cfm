<!--- <cfdump var="#form#">
<cfabort>

<cfinclude template="materiaCicloLectivo_fnSQL.cfm">  --->
<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
				<cfquery name="rsTTcodCurso" datasource="#Session.DSN#">
					Select convert(varchar,TTcodigoCurso) as TTcodigoCurso
					from CicloLectivo
					where CILcodigo=<cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">			
				</cfquery>

				<cfif isdefined('rsTTcodCurso') and rsTTcodCurso.recordCount GT 0>
					<cfquery name="ABC_conceptoEvaluac" datasource="#Session.DSN#">
						set nocount on
							insert Materia 
							(Ecodigo, Mtipo, Mcodificacion, Mnombre, Mactivo, Mexterna, Mcreditos, MhorasTeorica, MhorasEstudio, MhorasPractica, GAcodigo
							, MotrasCarreras, McursoLibre, Mrequisitos, McualquierCarrera, EScodigo, CILcodigo, MtipoCicloDuracion, TRcodigo
							, PEVcodigo, MtipoCalificacion, MpuntosMax, MunidadMin, Mredondeo, TEcodigo,TTcodigoCurso)
							values (
								<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
								, <cfqueryparam value="#form.Mtipo#" cfsqltype="cf_sql_varchar">
								, <cfqueryparam value="#form.Mcodificacion#" cfsqltype="cf_sql_varchar">
								, <cfqueryparam value="#form.Mnombre#" cfsqltype="cf_sql_varchar">
								<cfif isdefined('form.Mactivo') and form.Mactivo NEQ ''>
									, <cfqueryparam value="#form.Mactivo#" cfsqltype="cf_sql_bit">
								<cfelse>
									, 0					
								</cfif>
								<cfif isdefined('form.Mexterna') and form.Mexterna NEQ ''>
									, <cfqueryparam value="#form.Mexterna#" cfsqltype="cf_sql_bit">
								<cfelse>
									, 0					
								</cfif>
								, <cfqueryparam value="#form.Mcreditos#" cfsqltype="cf_sql_numeric">
								, <cfqueryparam value="#form.MhorasTeorica#" cfsqltype="cf_sql_numeric">
								, <cfqueryparam value="#form.MhorasEstudio#" cfsqltype="cf_sql_numeric">
								, <cfqueryparam value="#form.MhorasPractica#" cfsqltype="cf_sql_numeric">
								<cfif isdefined('form.GAcodigo') and form.GAcodigo NEQ '-1'>
									, <cfqueryparam value="#form.GAcodigo#" cfsqltype="cf_sql_numeric">
								<cfelse>
									, null
								</cfif>
								<cfif isdefined('form.MotrasCarreras') and form.MotrasCarreras NEQ ''>
									, <cfqueryparam value="#form.MotrasCarreras#" cfsqltype="cf_sql_integer">
								<cfelse>
									, 0					
								</cfif>
								<cfif isdefined('form.McursoLibre') and form.McursoLibre NEQ ''>
									, <cfqueryparam value="#form.McursoLibre#" cfsqltype="cf_sql_integer">
								<cfelse>
									, 0					
								</cfif>
								, <cfqueryparam value="#form.Mrequisitos#" cfsqltype="cf_sql_varchar">
		
								<cfif isdefined('form.McualquierCarrera')>
									, <cfqueryparam value="#form.McualquierCarrera#" cfsqltype="cf_sql_integer">
								<cfelse>
									, 0	
								</cfif>
								, <cfqueryparam value="#form.EScodigo#" cfsqltype="cf_sql_numeric">
								, <cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">
								, 'E'
								<cfif isdefined('form.TRcodigo') and form.TRcodigo NEQ '-1'>
									, <cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_numeric">
								<cfelse>
									, null
								</cfif>
								<cfif isdefined('form.PEVcodigo') and form.PEVcodigo NEQ '-1'>
									, <cfqueryparam value="#form.PEVcodigo#" cfsqltype="cf_sql_numeric">
								<cfelse>
									, null
								</cfif>
								, <cfqueryparam value="#form.MtipoCalificacion#" cfsqltype="cf_sql_char">
								<cfif isdefined('form.MpuntosMax') and form.MpuntosMax NEQ '-1'>
									, <cfqueryparam value="#form.MpuntosMax#" cfsqltype="cf_sql_numeric" scale="2">
								<cfelse>
									, null
								</cfif>
								<cfif isdefined('form.MunidadMin') and form.MunidadMin NEQ '-1'>
									, <cfqueryparam value="#form.MunidadMin#" cfsqltype="cf_sql_numeric" scale="2">						
								<cfelse>
									, null
								</cfif>
								<cfif isdefined('form.Mredondeo') and form.Mredondeo NEQ '-1'>
									, <cfqueryparam value="#form.Mredondeo#" cfsqltype="cf_sql_numeric" scale="3">
								<cfelse>
									, null
								</cfif>
								<cfif isdefined('form.TEcodigo') and form.TEcodigo NEQ '-1'>
									, <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
								<cfelse>
									, null					
								</cfif>
								, <cfqueryparam value="#rsTTcodCurso.TTcodigoCurso#" cfsqltype="cf_sql_numeric">
							)
						
						select @@identity as newMateria
						
						set nocount off
					</cfquery>
				</cfif>
			</cfif>
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_conceptoEvaluac" datasource="#Session.DSN#">
				set nocount on
					<cfif form.Mtipo EQ 'M'>	<!--- Materia Regular --->
						delete MateriaRequisito
						where Mcodigo = <cfqueryparam value="#Form.Mcodigo#"   cfsqltype="cf_sql_numeric">								
					<cfelseif form.Mtipo EQ 'E'>	<!--- Materia Electiva --->	
						delete MateriaElegible
						where Mcodigo = <cfqueryparam value="#Form.Mcodigo#"   cfsqltype="cf_sql_numeric">													
					</cfif>
								
					delete Materia
					where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
					  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#"   cfsqltype="cf_sql_numeric">
				set nocount off
			</cfquery>					   
			
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
				<cfquery name="rsTTcodCurso" datasource="#Session.DSN#">
					Select convert(varchar,TTcodigoCurso) as TTcodigoCurso
					from CicloLectivo
					where CILcodigo=<cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">			
				</cfquery>
			</cfif>			
						
			<cfquery name="ABC_conceptoEvaluac" datasource="#Session.DSN#">
				set nocount on				
					update Materia set
						Mcodificacion = <cfqueryparam value="#form.Mcodificacion#" cfsqltype="cf_sql_varchar">
						, Mnombre = <cfqueryparam value="#form.Mnombre#" cfsqltype="cf_sql_varchar">
						<cfif isdefined('form.Mactivo') and form.Mactivo NEQ ''>
							, Mactivo = <cfqueryparam value="#form.Mactivo#" cfsqltype="cf_sql_bit">
						<cfelse>
							, Mactivo = 0					
						</cfif>											
						<cfif isdefined('form.Mexterna') and form.Mexterna NEQ ''>
							, Mexterna = <cfqueryparam value="#form.Mexterna#" cfsqltype="cf_sql_bit">
						<cfelse>
							, Mexterna = 0					
						</cfif>											
						<cfif isdefined('form.Mcreditos') and form.Mcreditos NEQ ''>
							, Mcreditos = <cfqueryparam value="#form.Mcreditos#" cfsqltype="cf_sql_numeric">				
						</cfif>						
						<cfif isdefined('form.MhorasTeorica') and form.MhorasTeorica NEQ ''>
							, MhorasTeorica = <cfqueryparam value="#form.MhorasTeorica#" cfsqltype="cf_sql_numeric">
						</cfif>		
						<cfif isdefined('form.MhorasEstudio') and form.MhorasEstudio NEQ ''>
							, MhorasEstudio = <cfqueryparam value="#form.MhorasEstudio#" cfsqltype="cf_sql_numeric">
						</cfif>							
						<cfif isdefined('form.MhorasPractica') and form.MhorasPractica NEQ ''>
							, MhorasPractica = <cfqueryparam value="#form.MhorasPractica#" cfsqltype="cf_sql_numeric">
						</cfif>	
						<cfif isdefined('form.GAcodigo') and form.GAcodigo NEQ '-1'>
							, GAcodigo = <cfqueryparam value="#form.GAcodigo#" cfsqltype="cf_sql_numeric">
						<cfelse>
							, GAcodigo = null
						</cfif>
						<cfif isdefined('form.MotrasCarreras')>
							, MotrasCarreras = <cfqueryparam value="#form.MotrasCarreras#" cfsqltype="cf_sql_integer">
						<cfelse>
							, MotrasCarreras = 0	
						</cfif>						
						<cfif isdefined('form.McursoLibre') and form.McursoLibre NEQ ''>
							, McursoLibre = <cfqueryparam value="#form.McursoLibre#" cfsqltype="cf_sql_integer">
						<cfelse>
							, McursoLibre = 0					
						</cfif>
						<cfif isdefined('form.McualquierCarrera')>
							, McualquierCarrera = <cfqueryparam value="#form.McualquierCarrera#" cfsqltype="cf_sql_integer">
						<cfelse>
							, McualquierCarrera = 0	
						</cfif>												
						, EScodigo = <cfqueryparam value="#form.EScodigo#" cfsqltype="cf_sql_numeric">
						, CILcodigo = <cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">
						<cfif isdefined('rsTTcodCurso') and rsTTcodCurso.recordCount GT 0>
							, TTcodigoCurso = <cfqueryparam value="#rsTTcodCurso.TTcodigoCurso#" cfsqltype="cf_sql_numeric">				
						</cfif>
					where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
					  and Mcodigo  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
					  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				set nocount off
			</cfquery>
								  
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.CambioParam")>
			<cfquery name="ABC_conceptoEvaluac" datasource="#Session.DSN#">
				set nocount on				
					update Materia set
						MtipoCicloDuracion = <cfqueryparam value="#form.MtipoCicloDuracion#" cfsqltype="cf_sql_char">
						<cfif isdefined('form.TRcodigo') and form.TRcodigo NEQ '-1'>
							, TRcodigo = <cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_numeric">
						<cfelse>
							, TRcodigo = null					
						</cfif>
						<cfif isdefined('form.PEVcodigo') and form.PEVcodigo NEQ '-1'>
							, PEVcodigo = <cfqueryparam value="#form.PEVcodigo#" cfsqltype="cf_sql_numeric">
						<cfelse>
							, PEVcodigo = null					
						</cfif>
						, MtipoCalificacion = <cfqueryparam value="#form.MtipoCalificacion#" cfsqltype="cf_sql_char">
						<cfif isdefined('form.MpuntosMax') and form.MpuntosMax NEQ -1 and form.MpuntosMax NEQ "">
							, MpuntosMax = <cfqueryparam value="#form.MpuntosMax#" cfsqltype="cf_sql_numeric" scale="2">
						<cfelse>
							, MpuntosMax = null					
						</cfif>
						<cfif isdefined('form.MunidadMin') and form.MunidadMin NEQ -1 and form.MunidadMin NEQ "">
							, MunidadMin = <cfqueryparam value="#form.MunidadMin#" cfsqltype="cf_sql_numeric" scale="2">
						<cfelse>
							, MunidadMin = null					
						</cfif>
						<cfif isdefined('form.Mredondeo') and form.Mredondeo NEQ -1 and form.Mredondeo NEQ "">
							, Mredondeo = <cfqueryparam value="#form.Mredondeo#" cfsqltype="cf_sql_numeric" scale="3">
						<cfelse>
							, Mredondeo = null					
						</cfif>
						<cfif isdefined('form.TEcodigo') and form.TEcodigo NEQ '-1'>
							, TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
						<cfelse>
							, TEcodigo = null					
						</cfif>						
					where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
					  and Mcodigo  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
					  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)					
				set nocount off
			</cfquery>
			
			<cfset modo="CAMBIO">
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/educ/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfif not isdefined('form.Mcodigo') and isdefined('form.Alta')>
	<cfset valorMcodigo = ABC_conceptoEvaluac.newMateria>
	<cfset modo="CAMBIO">
<cfelseif isdefined('form.Cambio') or isdefined('form.Mcodigo')>
	<cfset valorMcodigo = form.Mcodigo>
</cfif>

<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
	<cfset fAction = "CarrerasPlanes.cfm">
	<cfif isdefined('form.Nuevo')>
		<cfset modo = "MPalta">
		<cfset valorMcodigo = ''>
	<cfelse>
		<cfset modo = "MPcambio">
	</cfif>
<cfelse>
	<cfset fAction = "materia.cfm">	
</cfif>	

<form action="<cfoutput>#fAction#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<!--- Parametros del mantenimiento de Materia Plan --->
		<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
			<input name="CILcodigo" type="hidden" value="#form.CILcodigo#">
		</cfif>
		<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
			<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
		</cfif>
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
		</cfif>
		<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
			<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
		</cfif>
		<input name="nivel" type="hidden" value="2">
		<input name="TabsPlan" type="hidden" value="3">
		 <!--- ********************************* --->
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="Mcodigo" type="hidden" value="<cfif isdefined("valorMcodigo") and modo NEQ 'ALTA'>#valorMcodigo#</cfif>">
		<input name="T" type="hidden" value="<cfif isdefined("form.Mtipo") and form.Mtipo NEQ ''>#form.Mtipo#<cfelse>M</cfif>">		
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>