<!--- <cfif isdefined("Url.ckTE") and not isdefined("Form.ckTE")>
	<cfparam name="Form.ckTE" default="#Url.ckTE#">
</cfif> 
<cfif isdefined("Url.ckTG") and not isdefined("Form.ckTG")>
	<cfparam name="Form.ckTG" default="#Url.ckTG#">
</cfif>  --->
<cfif isdefined("Url.TituloRep") and not isdefined("Form.TituloRep")>
		<cfparam name="Form.TituloRep" default="#Url.TituloRep#">
	</cfif> 
<cfif isdefined("Url.rdCortes") and not isdefined("Form.rdCortes")>
	<cfparam name="Form.rdCortes" default="#Url.rdCortes#">
</cfif> 
<cfif isdefined("Url.FechaRep") and not isdefined("Form.FechaRep")>
	<cfparam name="Form.FechaRep" default="#Url.FechaRep#">
</cfif> 
<cfif isdefined("Url.preguntasText") and not isdefined("Form.preguntasText")>
	<cfparam name="Form.preguntasText" default="#Url.preguntasText#">
</cfif> 
<cfif isdefined("Url.enPantalla") and not isdefined("Form.enPantalla")>
	<cfparam name="Form.enPantalla" default="#Url.enPantalla#">
</cfif> 
<!---
Nivel 
--Ccodigo            
--Ecodigo            
--PEcodigo           
ECcodigo           
ECcomponente       
Peso               
Nota               
Ganado             
Evaluado           
Progreso           
PesoConcepto       
EvaluadoConcepto   
GanadoC            
EvaluadoC          
ProgresoC          
ProgresoF          
AjusteF            
ProgresoA          
Valor 
ValorAjuste 
ValorAsignado 
--Cnombre
--PEnombre
ECnombre
--CEnombre
ConDatos
--Enombre

no trae
GRcodigo, GRnombre, Morden, Equivalencia
--->

<cfquery name="rsProgress" datasource="#Session.Edu.DSN#">
select ce.CEnombre, 
	convert(varchar,a.Ecodigo) as Ecodigo,
	pe.Papellido1, pe.Papellido2, pe.Pnombre,
	convert(varchar,gr.GRcodigo) as GRcodigo, 
	gr.GRnombre, 
	peval.PEcodigo, 
	peval.PEdescripcion,
	Morden,
	convert(varchar,c.Ccodigo) as Ccodigo,
	case m.Melectiva when 'S' then c.Cnombre else m.Mnombre end as Cnombre,
	acpe.ACPEnotaprog, 
	acpe.ACPEvalorprog, 
	ev.EVequivalencia,
	isnull(ev.EVequivalencia,acpe.ACPEnotaprog) as progreso,
	(select sum(ec.ECporcentaje * ecc.ECCporcentaje / 100)
		from AlumnoCalificacion ac, EvaluacionCurso ec, EvaluacionConceptoCurso ecc
		where ac.Ccodigo=c.Ccodigo and ac.Ecodigo = a.Ecodigo and ec.PEcodigo = peval.PEcodigo
		and ac.ECcomponente = ec.ECcomponente
		and ec.ECcodigo = ecc.ECcodigo
		and ec.PEcodigo = ecc.PEcodigo
		and ec.Ccodigo = ecc.Ccodigo) as evaluado,
	(select sum(ec.ECporcentaje * ecc.ECCporcentaje / 100 * isnull(evalores.EVequivalencia,ac.ACnota) / 100)
		from AlumnoCalificacion ac, EvaluacionCurso ec, EvaluacionConceptoCurso ecc, EvaluacionValores evalores
		where ac.Ccodigo=c.Ccodigo and ac.Ecodigo = a.Ecodigo and ec.PEcodigo = peval.PEcodigo
		and ec.EVTcodigo *= evalores.EVTcodigo and ac.ACvalor *= evalores.EVvalor
		and ac.ECcomponente = ec.ECcomponente
		and ec.ECcodigo = ecc.ECcodigo
		and ec.PEcodigo = ecc.PEcodigo
		and ec.Ccodigo = ecc.Ccodigo) as ganado
from AlumnoCalificacionCurso acc, Alumnos a, PersonaEducativo pe, Curso c, Materia m, Grupo gr, GrupoAlumno gra,
Staff s, PersonaEducativo pest, CentroEducativo ce, Grado g, PeriodoEvaluacion peval, AlumnoCalificacionPerEval acpe, EvaluacionValores ev
where ce.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
and ce.CEcodigo = acc.CEcodigo
and acc.Ecodigo = a.Ecodigo
and a.persona = pe.persona
and a.Ecodigo = gra.Ecodigo
and gra.GRcodigo = gr.GRcodigo
and gr.SPEcodigo = c.SPEcodigo
and acc.Ccodigo = c.Ccodigo
and c.Mconsecutivo = m.Mconsecutivo
and (m.Melectiva = 'R' or m.Melectiva = 'S')
and c.Splaza *= s.Splaza
and s.persona *= pest.persona
and gr.Gcodigo = g.Gcodigo
and m.Ncodigo = peval.Ncodigo
and acc.CEcodigo *= acpe.CEcodigo and acc.Ccodigo *= acpe.Ccodigo and acc.Ecodigo *= acpe.Ecodigo
and peval.PEcodigo *= acpe.PEcodigo
and m.EVTcodigo *= ev.EVTcodigo and acpe.ACPEvalorprog *= ev.EVvalor
and c.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#">
<cfif isdefined("Form.GRcodigo") AND Form.GRcodigo NEQ -1>
and gr.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GRcodigo#">
</cfif>
<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ -1>
and peval.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
</cfif>
<cfif isdefined("Form.Ecodigo") AND Form.Ecodigo NEQ -1>
and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
</cfif>
<cfif NOT isdefined("Form.checkTodosCursos")>
<cfif NOT isdefined("Form.checkCurso")>
and c.Ccodigo is null
<cfelse>
	and c.Ccodigo in (
	<cfset codigos = Replace(Form.checkCurso,chr(44)," ","all")>
	<cfset index = 1>
	<cfset codigoCurso = GetToken(codigos,index)>
	<cfloop condition="codigoCurso NEQ ''">
	    <cfif index NEQ 1>,</cfif>
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#codigoCurso#">
		<cfset index = index + 1>
		<cfset codigoCurso = GetToken(codigos,index)>
	</cfloop>)
</cfif>
</cfif>
<cfif isdefined("Form.filtroNota")>
and exists (select 1 from AlumnoCalificacionPerEval f1, Curso f2, Materia f3, EvaluacionValores f4
where acc.CEcodigo = f1.CEcodigo and acc.Ccodigo = f1.Ccodigo and acc.Ecodigo = f1.Ecodigo
and peval.PEcodigo = f1.PEcodigo and f1.Ccodigo = f2.Ccodigo and f2.Mconsecutivo = f3.Mconsecutivo
and f3.EVTcodigo *= f4.EVTcodigo and f1.ACPEvalorprog *= f4.EVvalor
and f1.ACPEnotaprog < <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.filtroPorcentaje#">
and f4.EVequivalencia < <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.filtroPorcentaje#">)
</cfif>
and a.Aretirado = 0
order by g.Gorden, gr.GRnombre, peval.PEorden, pe.Papellido1, pe.Papellido2, pe.Pnombre,  Morden, Cnombre
</cfquery>
<!--- order by g.Gorden, gr.GRnombre, peval.PEorden, pe.Papellido1, pe.Papellido2, pe.Pnombre, Morden --->
<cffunction name="pintarPiePag" access="public" output="true">
	<cfset firmas = false>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif isdefined("Form.firmaAlumno") OR isdefined("Form.firmaEncargado") OR isdefined("Form.firmaProfesor")
			OR isdefined("Form.firmaDirector") OR isdefined("Form.firmaAdicional")>
			<cfset firmas = true>
		</cfif>
		<cfset preguntas = false>
		<cfif isdefined("Form.preguntasText") AND Form.preguntasText NEQ "">
			<cfset preguntas = true>
		</cfif>
		<cfif preguntas OR firmas>
			<tr>
				<td>
					<cfif firmas>Despu&eacute;s de revisar este reporte, por favor f&iacute;rmelo y regr&eacute;selo al colegio.</cfif>
					<cfif preguntas>Si tiene alg&uacute;n desacuerdo o alg&uacute;n interrogante por favor preguntar a:
				<cfif isdefined("Form.preguntasText")>#JSStringFormat(Form.preguntasText)#<cfelse>#RepeatString("_", 20)#</cfif></cfif>
				</td>
			</tr>
		</cfif>
		<cfset posTD = 0>
		<cfloop index = "indexFirma" from = "1" to = "5">
			<cfswitch expression="#indexFirma#">
				<cfcase value="1"><cfset varFirma="Form.firmaAlumno"><cfset varTexto="Estudiante"></cfcase>
				<cfcase value="2"><cfset varFirma="Form.firmaEncargado"><cfset varTexto="Encargado"></cfcase>
				<cfcase value="3"><cfset varFirma="Form.firmaProfesor"><cfset varTexto="Profesor"></cfcase>
				<cfcase value="4"><cfset varFirma="Form.firmaDirector"><cfset varTexto="Director"></cfcase>
				<cfcase value="5">
				<cfset varFirma="Form.firmaAdicional">
				<cfif isdefined("Form.nombreAdicional")><cfset varTexto=Form.nombreAdicional><cfelse><cfset varTexto=""></cfif>
				</cfcase>
			</cfswitch>
			<cfif isdefined(varFirma)>
				<cfif posTD MOD 3 EQ 0><tr></cfif>
				<td align="<cfif posTD MOD 3 EQ 0>left<cfelseif posTD MOD 3 EQ 1>center<cfelse>right</cfif>"
				<cfif posTD MOD 3 EQ 1>colspan="5"</cfif>>
				#RepeatString("_", 20)#<br>Firma #varTexto#</td>
				<cfif posTD MOD 3 EQ 2></tr></cfif>
				<cfset posTD = posTD + 1>
			</cfif>
		</cfloop>
		<cfset restTD = posTD MOD 3>
		<cfif restTD GT 0>
			<cfloop index="indexRest" from="#restTD#" to="2"><td></td></cfloop>
			</tr>
		</cfif>
	</table>
</cffunction>
<cfif isdefined("Form.checkTabla")>
	<cfset codigosCursosTabla = Form.checkTabla & ",">
</cfif>
</table>
<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">

<cfif rsProgress.RecordCount EQ 0>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<!--- <tr><td colspan="5"><strong>No hay datos</strong></td></tr> --->
		<tr <cfif Form.enPantalla EQ 1>class="encabReporte"</cfif>> 
			<td colspan="5" >#Request.Translate('RptProgTit12','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#</td>
		</tr>
		<tr> 
			<td colspan="5" align="center"> ------------------ #Request.Translate('RptProgTit13','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# ------------------ </td>
		</tr>
		</table>
	</cfoutput>
<cfelse>
	<cfset reporteIniciado = 0>
	<cfset alumnoActual = 0>
	<!--- <cfset Session.Idioma = "EN"> --->
	<cfif rsProgress.CurrentRow EQ 1>
		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr class="area"> 
					<td width="35%" style="font-size: 7pt;">Servicios Digitales al Ciudadano</td>
					<td width="30%" colspan="3">&nbsp;</td>
					<td width="35%" style="font-size: 7pt; text-align: right">
						#Request.Translate('RptProgTit08','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#: 
						<cfif isdefined("form.FechaRep") and len(trim(form.FechaRep)) neq 0>
							<cfif Session.Idioma EQ "EN">
								#LSdateFormat(form.FechaRep,'MM/dd/YYYY')#
							<cfelse>
								#LSdateFormat(form.FechaRep,'dd/MM/YYYY')#
							</cfif>
						<cfelse>
							<cfif Session.Idioma EQ "EN">
								#LSdateFormat(Now(),'MM/dd/YYYY')#
							<cfelse>
								#LSdateFormat(Now(),'dd/MM/YYYY')#
							</cfif>
						</cfif> 
					</td>
				</tr>
				<tr class="area"> 
					<td style="font-size: 7pt;">www.migestion.net</td>
					<td colspan="3">&nbsp;</td>
					<td style="text-align: right">&nbsp;<!--- Hora: #TimeFormat(Now(),"hh:mm:ss")# ---></td>
				</tr>
				<tr class="tituloAlterno"> 
					<td colspan="5" align="center" class="tituloAlterno">
						<strong>
							<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
								#form.TituloRep#
							<cfelse>
								#Request.Translate('RptProgTit02','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#
							</cfif>
						</strong>
					</td>
				</tr>
				<tr class="tituloAlterno"> 
					<td colspan="5" align="center" class="tituloAlterno">
						<strong>#rsProgress.CEnombre#</strong><hr>
					</td>
				</tr>
			</table>
		</cfoutput>
	</cfif>
	
		
	<cfset grupoActual = '0'>
	<cfset periodoActual = ''>
	<cfloop query="rsProgress">
		<cfflush interval="10">
	<!--- 	<cfif rsProgress.Pnombre NEQ periodoActual>
			<cfset periodoActual = rsProgress.Pnombre>
			<cfset grupoActual = rsProgress.GRcodigo>
			<tr> 
				<td colspan="5" nowrap>
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr <cfif Form.enPantalla EQ 1>class="encabReporte"</cfif>> 
							<td style="font-size: 9pt;" nowrap><strong>#Request.Translate('RptProgTit11','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#</strong>: #rsProgress.GRnombre#</td>
						</tr>  
						<tr <cfif Form.enPantalla EQ 1>class="encabReporte"</cfif>>
							<td ><strong>#Request.Translate('RptProgTit10','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong> #rsProgress.PEdescripcion#</td>
						</tr>		
					</table>
				</td>
			</tr>
		</cfif>  --->
		<cfif (rsProgress.GRcodigo NEQ grupoActual) OR (rsProgress.PEdescripcion NEQ periodoActual)>
			<cfset grupoActual = rsProgress.GRcodigo>
			<cfset periodoActual = rsProgress.PEdescripcion>
			<cfset inicioGrupo = 1>
			<cfset materiaindex = 1>
			<!--- <cfset nomPeriodo = ""> --->
			
			<cfquery name="rsMaterias" dbtype="query">
				select distinct Cnombre, Ccodigo
				from rsProgress
				where GRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#grupoActual#">
				order by Morden, Cnombre
			</cfquery>
			<cfset materias = ValueList(rsMaterias.Ccodigo)>
			 <!--- <cfdump var="#materias#"> --->
			<cfif reporteIniciado EQ 1>
				<cfif Form.enPantalla EQ 0>
					<cfinvoke method="pintarPiePag"></cfinvoke>
				</cfif>
			</cfif>
			<cfif rsProgress.currentRow NEQ 1>
			</tr>
			</table>
			</cfif>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PxA' and rsProgress.CurrentRow NEQ 1>
				<tr class="pageEnd">
					<td >&nbsp;</td>
				</tr>
			</cfif>
			<cfoutput>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" >
							<cfif  Form.enPantalla EQ 0 and isdefined("Url.rdCortes") and form.rdCortes EQ 'PxA' and rsProgress.CurrentRow NEQ 1>
								<tr class="area"> 
									<td width="35%" style="font-size: 7pt;">Servicios Digitales al Ciudadano</td>
									<td width="30%" colspan="3">&nbsp;</td>
									<td width="35%" style="font-size: 7pt; text-align: right">
										#Request.Translate('RptProgTit08','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#: 
										<cfif isdefined("form.FechaRep") and len(trim(form.FechaRep)) neq 0>
											<cfif Session.Idioma EQ "EN">
												#LSdateFormat(form.FechaRep,'MM/dd/YYYY')#
											<cfelse>
												#LSdateFormat(form.FechaRep,'dd/MM/YYYY')#
											</cfif>
										<cfelse>
											<cfif Session.Idioma EQ "EN">
												#LSdateFormat(Now(),'MM/dd/YYYY')#
											<cfelse>
												#LSdateFormat(Now(),'dd/MM/YYYY')#
											</cfif>
										</cfif> 
									</td>
								</tr>
								<tr class="area"> 
									<td style="font-size: 7pt;">www.migestion.net</td>
									<td colspan="3">&nbsp;</td>
									<td style="text-align: right">&nbsp;<!--- Hora: #TimeFormat(Now(),"hh:mm:ss")# ---></td>
								</tr>
								<tr class="tituloAlterno"> 
									<td colspan="5" align="center" class="tituloAlterno">
										<strong>
											<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
												#form.TituloRep#
											<cfelse>
												#Request.Translate('RptProgTit02','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#
											</cfif>
										</strong>
									</td>
								</tr>
								
								<tr class="tituloAlterno"> 
									<td colspan="5" align="center" class="tituloAlterno">
										<strong>#rsProgress.CEnombre#</strong><hr>
									</td>
								</tr>
							</cfif>
						</table>
					</td>
				</tr>
				<tr> 
					<td nowrap>
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr <cfif Form.enPantalla EQ 1>class="encabReporte"</cfif>> 
								<td style="font-size: 9pt;" nowrap><strong>#Request.Translate('RptProgTit11','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#</strong>: #rsProgress.GRnombre#</td>
							</tr>  
							<tr <cfif Form.enPantalla EQ 1>class="encabReporte"</cfif>>
								<td ><strong>#Request.Translate('RptProgTit10','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong> #rsProgress.PEdescripcion#</td>
							</tr>		
						</table>
					</td>
				</tr>
			</cfoutput> 
			</table>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr> 
					<td>
						<table width="100%" border="0" cellspacing="0"  <cfif Form.enPantalla EQ 1>class="EncabBloque"</cfif> cellpadding="0" style="border-collapse: collapse; empty-cells: show; ">
							<cfoutput>
								<tr>
									<td align="center"><strong>#Request.Translate('RptProgTit14','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong></td>
									<td ><strong>#Request.Translate('RptProgTit03','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong></td>
								</tr>
							</cfoutput>
							<cfoutput query="rsMaterias">
								<tr>
									<td align="center">#rsMaterias.CurrentRow#</td>
									<td >#rsMaterias.Cnombre#</td>
								</tr>	
							</cfoutput>
							
						</table>
					</td>
				</tr>
			</table>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td  class="subrayado"><cfoutput><strong>#Request.Translate('RptProgTit09','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong></cfoutput></td>
				<cfoutput query="rsMaterias">
					<td  class="subrayado" align="center" >#rsMaterias.CurrentRow# </td>
				</cfoutput>
			</tr>
		</cfif>
		
			<cfif rsProgress.Ecodigo NEQ alumnoActual>
				<cfif inicioGrupo NEQ 1>
				</tr>
				</cfif>
				
				<tr>
				<cfset alumnoActual = rsProgress.Ecodigo>
				<cfset primero = 1>
				<cfset materiaindex = 1>
				<cfset reporteIniciado = 1>
			
			</cfif>
		<cfoutput>
		
			<cfif primero EQ 1>
				<td class="subrayado">#rsProgress.Papellido1# #rsProgress.Papellido2#, #rsProgress.Pnombre#</td>
			</cfif>
			<cfif (isdefined("codigosCursosTabla") AND Find(rsProgress.Ccodigo&",",codigosCursosTabla) NEQ 0)>
				<cfset NotaProgreso = rsProgress.ACPEvalorprog>
			<cfelse>
				<cfset NotaProgreso = rsProgress.progreso>
			</cfif>
			
			<!--- <td  class="subrayado" align="center"> #rsProgress.Cnombre# #LSNumberFormat(NotaProgreso,"0.00")#</td> --->
			<cfloop condition="Trim(rsProgress.Ccodigo) NOT EQUAL Trim(ListGetAt(materias, materiaindex, ','))">
					<td  class="subrayado" align="center">&nbsp; </td>
					<cfset materiaindex = materiaindex + 1>
			</cfloop>
			<td  class="subrayado" align="center">#LSNumberFormat(NotaProgreso,"0.00")#</td>
		</cfoutput>
		<cfset primero = primero + 1>
		<cfset inicioGrupo = inicioGrupo + 1>
		<cfset materiaindex = materiaindex + 1>
	</cfloop>
	</table>

	<cfif Form.enPantalla EQ 0>
		<cfinvoke method="pintarPiePag"></cfinvoke>
	</cfif>
</cfif>
</table>
