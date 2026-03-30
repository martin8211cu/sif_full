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

<cfquery name="rsDatos" datasource="#Session.Edu.DSN#">
	set nocount on
	declare @pid numeric, @hoy datetime
	
	select @hoy = getDate()
	
	delete ProcParams where PPfecha < dateadd(hh, -1, @hoy)
	delete ProcParamsId where PPIid not in (select distinct PPIid from ProcParams)
	
	insert ProcParamsId(PPIdescripcion)
	values('sp_ProgresoGrupo')
	
	select @pid = @@identity
	
	<cfloop index="k" from="1" to="#ListLen(Form.checkCurso,',')#">
		insert ProcParams(PPIid, PPvalue, PPfecha)
		values(@pid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(ListGetAt(Form.checkCurso, k, ','))#">, @hoy)
	</cfloop>
	
	exec sp_ProgresoGrupo @Nivel = 3, @ParamId = @pid 
		<cfif isdefined("Form.GRcodigo") AND Form.GRcodigo NEQ -1>
		 , @GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GRcodigo#">
		</cfif>
		<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ -1>
		 , @PEevaluacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		</cfif>
	set nocount off
</cfquery>

<cfquery name="rsProgress" dbtype="query">
	select Nivel, Ccodigo, Ecodigo, GRcodigo,
		   PEcodigo, ECcodigo, ECcomponente, Peso, 
		   Nota, Ganado, Evaluado, Progreso, PesoConcepto,
		   EvaluadoConcepto, GanadoC, EvaluadoC, ProgresoC,
		   ProgresoF, AjusteF, ProgresoA, ProgresoA2, Valor, 
		   ValorAjuste, ValorAsignado, Cnombre, Enombre,
		   PEnombre, ECnombre, CEnombre, GRnombre,
		   Morden, ConDatos
	from rsDatos
	<cfif isdefined("Form.PEcodigo") AND Form.PEcodigo NEQ -1>
	where Nivel = '3'
	<cfelse>
	where Nivel = '4'
	</cfif>
	<cfif isdefined("Form.filtroNota")>
	and ProgresoA2 < <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.filtroPorcentaje#" scale="2">
	</cfif>
</cfquery>

<cffunction name="pintarPiePag" access="public" output="true">
	<cfset firmas = false>
	<cfif isdefined("Form.firmaAlumno") OR isdefined("Form.firmaEncargado") OR isdefined("Form.firmaProfesor") OR isdefined("Form.firmaDirector") OR isdefined("Form.firmaAdicional")>
		<cfset firmas = true>
	</cfif>
	<cfif firmas>
		<cfset posTD = 0>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr><td colspan="3">&nbsp;</td></tr>
		<cfloop index="indexFirma" from="1" to="5">
			<cfswitch expression="#indexFirma#">
				<cfcase value="1"><cfset varFirma="Form.firmaAlumno"><cfset varTexto="Estudiante"></cfcase>
				<cfcase value="2"><cfset varFirma="Form.firmaEncargado"><cfset varTexto="Encargado"></cfcase>
				<cfcase value="3"><cfset varFirma="Form.firmaProfesor"><cfset varTexto=#Request.Translate('RptProgTit16','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#></cfcase>
				<cfcase value="4"><cfset varFirma="Form.firmaDirector"><cfset varTexto=#Request.Translate('RptProgTit17','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#></cfcase>
				<cfcase value="5"><cfset varFirma="Form.firmaAdicional"><cfset varTexto=#Request.Translate('RptProgTit19','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#>
					<cfif isdefined("Form.nombreAdicional")><cfset varTexto = Form.nombreAdicional><cfelse><cfset varTexto=""></cfif>
				</cfcase>
			</cfswitch>
			<cfif isdefined(varFirma)>
				<cfif posTD MOD 3 EQ 0><tr></cfif>
				<td align="<cfif posTD MOD 3 EQ 0>left<cfelseif posTD MOD 3 EQ 1>center<cfelse>right</cfif>">
					#RepeatString("_", 20)#<br>#Request.Translate('RptProgTit18','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# #varTexto#
				</td>
				<cfif posTD MOD 3 EQ 2></tr></cfif>
				<cfset posTD = posTD + 1>
			</cfif>
		</cfloop>
		<cfset posTD = posTD - 1>
		<cfif posTD MOD 3 NEQ 2>
			<cfloop condition="posTD MOD 3 NEQ 2">
				<td>&nbsp;</td>
				<cfset posTD = posTD + 1>
			</cfloop>
			</tr>
		</cfif>
		</table>
	</cfif>
</cffunction>


<cfif isdefined("Form.checkTabla")>
	<cfset codigosCursosTabla = Replace(Form.checkTabla, ' ', '', 'all') & ",">
</cfif>
<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">

<cfif rsProgress.RecordCount EQ 0>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr <cfif Form.enPantalla EQ 1>class="encabReporte"</cfif>> 
			<td colspan="5" >#Request.Translate('RptProgTit12','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#</td>
		</tr>
		<tr> 
			<td colspan="5" align="center"> ------------------ #Request.Translate('RptProgTit13','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# ------------------ </td>
		</tr>
		</table>
	</cfoutput>
<cfelse>
	<cfset alumnoActual = 0>
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
		<cfif (rsProgress.GRcodigo NEQ grupoActual) OR (rsProgress.PEnombre NEQ periodoActual)>
			<cfif rsProgress.currentRow NEQ 1>
				<!--- Cierre de columnas de cursos sin notas --->
				<cfloop condition="materiaindex LT (rsMaterias.recordCount + 1)">
						<td class="subrayado" align="center" style="padding-right: 3px;">&nbsp;</td>
						<cfset materiaindex = materiaindex + 1>
				</cfloop>
				</tr>
				</table>
				<cfif Form.enPantalla EQ 0>
					<cfinvoke method="pintarPiePag"></cfinvoke>
				</cfif>
			</cfif>

			<cfset grupoActual = Trim(rsProgress.GRcodigo)>
			<cfset periodoActual = rsProgress.PEnombre>
			<cfset inicioGrupo = 1>
			<cfset materiaindex = 1>

			<cfquery name="rsMaterias" dbtype="query">
				select distinct Cnombre, Ccodigo
				from rsProgress
				where GRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#grupoActual#">
				order by Morden, Cnombre
			</cfquery>
			<cfset materias = ValueList(rsMaterias.Ccodigo)>

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
								<td><strong>#Request.Translate('RptProgTit10','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong> <cfif Len(Trim(rsProgress.PEnombre)) NEQ 0>#rsProgress.PEnombre#<cfelse>Curso Lectivo</cfif></td>
							</tr>		
							<tr <cfif Form.enPantalla EQ 1>class="encabReporte"</cfif>>
								<td>
									<strong>#Request.Translate('RptProgTit15','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')# </strong>
									<cfif isdefined("Form.preguntasText") and Len(Trim(Form.preguntasText)) NEQ 0>
										#Form.preguntasText#
									<cfelse>
										#RepeatString("_", 40)#
									</cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</cfoutput> 
			</table>
			<table width="100%" border="0" cellspacing="0" <cfif Form.enPantalla EQ 1>class="EncabBloque"</cfif> cellpadding="0" style="border-collapse: collapse; empty-cells: show; ">
				<cfoutput>
					<tr>
						<td align="center"><strong>#Request.Translate('RptProgTit14','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong></td>
						<td><strong>#Request.Translate('RptProgTit03','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong></td>
					</tr>
				</cfoutput>
				<cfoutput query="rsMaterias">
					<tr>
						<td align="center" nowrap>#rsMaterias.CurrentRow#</td>
						<td nowrap>#rsMaterias.Cnombre#</td>
					</tr>	
				</cfoutput>
				
			</table>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td  class="subrayado"><cfoutput><strong>#Request.Translate('RptProgTit09','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#:</strong></cfoutput></td>
				<cfoutput query="rsMaterias">
					<td  class="subrayado" align="center" >#rsMaterias.CurrentRow# </td>
				</cfoutput>
			</tr>
		</cfif>
		
			<cfif Trim(rsProgress.Ecodigo) NEQ alumnoActual>
				<cfif inicioGrupo NEQ 1>
					<!--- Cierre de columnas de cursos sin notas --->
					<cfloop condition="materiaindex LT (rsMaterias.recordCount + 1)">
							<td class="subrayado" align="center" style="padding-right: 3px;">&nbsp;</td>
							<cfset materiaindex = materiaindex + 1>
					</cfloop>
					</tr>
				</cfif>
				
				<tr>
				<cfset alumnoActual = Trim(rsProgress.Ecodigo)>
				<cfset primero = 1>
				<cfset materiaindex = 1>
			
			</cfif>
		<cfoutput>
		
			<cfif primero EQ 1>
				<td class="subrayado" nowrap>#rsProgress.Enombre#</td>
			</cfif>
			<cfif isdefined("codigosCursosTabla") and Find(Trim(rsProgress.Ccodigo)&",",codigosCursosTabla) NEQ 0>
				<cfset NotaProgreso = rsProgress.ValorAsignado>
			<cfelse>
				<cfif Len(Trim(rsProgress.ProgresoA)) NEQ 0>
					<cfset NotaProgreso = LSNumberFormat(rsProgress.ProgresoA,"0.00")>
				<cfelse>
					<cfset NotaProgreso = "">
				</cfif>
			</cfif>

			<cfloop condition="Trim(rsProgress.Ccodigo) NOT EQUAL Trim(ListGetAt(materias, materiaindex, ','))">
					<td class="subrayado" align="center" style="padding-right: 3px;">&nbsp;</td>
					<cfset materiaindex = materiaindex + 1>
			</cfloop>
			<td class="subrayado" align="center" style="padding-right: 3px;"><cfif Len(Trim(NotaProgreso)) NEQ 0>#NotaProgreso#<cfelse>&nbsp;</cfif></td>
		</cfoutput>
		<cfset primero = primero + 1>
		<cfset inicioGrupo = inicioGrupo + 1>
		<cfset materiaindex = materiaindex + 1>
	</cfloop>
	<cfif rsProgress.recordCount GT 0>
			<!--- Cierre de columnas de cursos sin notas --->
			<cfloop condition="materiaindex LT (rsMaterias.recordCount + 1)">
					<td class="subrayado" align="center" style="padding-right: 3px;">&nbsp;</td>
					<cfset materiaindex = materiaindex + 1>
			</cfloop>
			</tr>
			</table>
			<cfif Form.enPantalla EQ 0>
				<cfinvoke method="pintarPiePag"></cfinvoke>
			</cfif>
	</cfif>
</cfif>
