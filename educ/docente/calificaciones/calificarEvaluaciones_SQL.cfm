<cfinclude template="commonDocencia.cfm">
<cfscript>
	sbInitFromSession("cboProfesor", "-999",true);
	sbInitFromSession("cboCurso", "-999",true);
	sbInitFromSession("cboPeriodo", "-999",true); 

	sbInitFromSession("cboOrdenamiento", "0", false);
	sbInitFromSession("cboXAlumno", "0", false);
	sbInitFromCookieChks("chkCalcular","0", false);
</cfscript>

<cfquery datasource="#Session.DSN#" name="qryCurso">
    set nocount on
    select 	convert(varchar,m.Mcodigo) as Mcodigo,
			convert(varchar,c.Ccodigo) as Ccodigo,
			m.MtipoCicloDuracion,
			c.PEcodigo,
		 	c.CtipoCalificacion, c.CpuntosMax, c.CunidadMin, c.Credondeo, c.TEcodigo,
			c.Cestado, c.CestadoCalificacion
      from Curso c, Materia m
     where c.Ccodigo = #session.Ccodigo#
       and c.Mcodigo = m.Mcodigo
    set nocount off
</cfquery>
<cfif qryCurso.MtipoCicloDuracion EQ 'L'>
	IR A CALIFICAR CURSO POR PERIODO LECTIVO
	<cfabort>
</cfif>

<cfset GvarCursoTipoCalificacion = qryCurso.CtipoCalificacion>
<cfif qryCurso.CtipoCalificacion EQ "T">
	<cfset GvarTablaMateria = qryCurso.TEcodigo>
<cfelse>
	<cfset GvarTablaMateria = "">
</cfif>

<cfquery datasource="#Session.DSN#" name="qryValoresTabla">
  set nocount on
  select convert(varchar,TEcodigo) as Tabla, TEVvalor as Codigo, TEVnombre as Descripcion, 
  	     TEVequivalente as EVorden, 
         TEVequivalente as Equivalente, TEVminimo as Minimo, TEVmaximo as Maximo
    from TablaEvaluacionValor vt
   where exists(
           select *
             from CursoEvaluacion cev
            where cev.Ccodigo    = #session.Ccodigo#
              and cev.PEcodigo   = #session.PEcodigo#
              and cev.CEVtipoCalificacion = 'T'
			  and cev.TEcodigo   = vt.TEcodigo
		   )
   or    exists(
           select *
             from CursoAmpliacion cam
            where cam.Ccodigo    = #session.Ccodigo#
              and cam.CAMtipoCalificacion = 'T'
			  and cam.TEcodigo   = vt.TEcodigo
		   )
      <cfif GvarTablaMateria neq "">
      or vt.TEcodigo = #GvarTablaMateria#
	  </cfif>		   
  set nocount off
</cfquery>
<cftransaction>
	<cfoutput>
		<cfif isdefined("btnAbrir")>
			<cfset LvarEstadoCurso = "1">
			<cfquery datasource="#Session.DSN#">
				update Curso
				   set CestadoCalificacion = #LvarEstadoCurso#
				 where Ccodigo   = #session.Ccodigo#
			</cfquery>
<!---
				<cfset LvarAsunto = "Notificacion Automatica por apertura de Periodo de Evaluacion Cerrado">
				<cfset LvarMsg = "Por este medio se le comunica que las evaluaciones del periodo #qryCorreos.Periodo#, del curso #qryCorreos.Curso#, las cuales se encontraban cerradas, han sido abiertas por el usuario '#qryUsuActual.Nombre#' (Login='#qryUsuActual.Login#'), por medio de la opción de Abrir Periodo en la pantalla de Evaluar Periodo">
				<cfset fnNotificarCorreoBuzon ("","","","",LvarAsunto,LvarMSG,'Mensaje automático', LvarAsunto, qryCorreos, true)>
 --->
		<cfelseif isdefined("btnAmpliacion")>
			<cfset LvarEstadoCurso = "2">
			<cfquery datasource="#Session.DSN#">
				update Curso
				   set CestadoCalificacion = #LvarEstadoCurso#
				 where Ccodigo   = #session.Ccodigo#
				update CursoEvaluacion
				   set CEVestado = 2
				 where Ccodigo   = #session.Ccodigo#
				   and PEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.PEcodigo#">
			</cfquery>
		<cfelseif isdefined("btnReAbrir")>
			<cfset LvarEstadoCurso = "2">
			<cfquery datasource="#Session.DSN#">
				update Curso
				   set CestadoCalificacion = #LvarEstadoCurso#
				 where Ccodigo   = #session.Ccodigo#

				delete AlumnoMateria 
				 where Ccodigo = #session.Ccodigo#
			</cfquery>
<!---
				<cfset LvarAsunto = "Notificacion Automatica por apertura de Periodo de Evaluacion Cerrado">
				<cfset LvarMsg = "Por este medio se le comunica que las evaluaciones del periodo #qryCorreos.Periodo#, del curso #qryCorreos.Curso#, las cuales se encontraban cerradas, han sido abiertas por el usuario '#qryUsuActual.Nombre#' (Login='#qryUsuActual.Login#'), por medio de la opción de Abrir Periodo en la pantalla de Evaluar Periodo">
				<cfset fnNotificarCorreoBuzon ("","","","",LvarAsunto,LvarMSG,'Mensaje automático', LvarAsunto, qryCorreos, true)>
 --->
		<cfelseif isdefined("btnCerrar")>
			<cfset LvarEstadoCurso = "3">
			<cfquery datasource="#Session.DSN#">
				update Curso
				   set CestadoCalificacion = #LvarEstadoCurso#
				 where Ccodigo   = #session.Ccodigo#
				update CursoAlumno
				   set CAestado = 
							case trr.TRRtipo
								when '1' then 20	<!--- APROBADO --->
								when '2' then 11	<!--- REPROBADO 02=APLAZADO --->
								when '3' then 11	<!--- REPROBADO --->
							end
				  from CursoAlumno ca, Curso c, TablaResultadoRango trr
				 where ca.Ccodigo = #session.Ccodigo#
				   and c.Ccodigo  = ca.Ccodigo
				   and c.TRcodigo = trr.TRcodigo
				   and ca.CAestado <> 10	<!--- RETIRADO --->
				   and ca.CAporcFinal*100 between trr.TRRminimo and trr.TRRmaximo

				insert into AlumnoMateria (Apersona, Mcodigo, MPcodigo, Ccodigo, AMestado, AMfecha)
				select ca.Apersona
					 , c.Mcodigo
					 , convert(numeric,	substring(min(
							right('00000'+convert(varchar,mp.PBLsecuencia),5) + 
							right('00000'+convert(varchar,mp.MPsecuencia),5)+
							convert(varchar,mp.MPcodigo)
						),11,18)) as MPcodigo
					 , ca.Ccodigo
					 , 25 as AMestado	-- Asignacion de Elegible
					 , getdate() as AMfecha
				  from CursoAlumno ca
					 , Curso c
					 , PlanEstudiosAlumno pea
					 , PlanEstudios pes
					 , MateriaPlan mp
					 , Materia m
					 , MateriaElegible ele
				 where c.Ccodigo = #session.Ccodigo#
				   and c.CestadoCalificacion = 3
				
				   and ca.Ccodigo = c.Ccodigo
				   and ca.CAestado = 20
				
				   and pea.Apersona = ca.Apersona
				   and pea.PEAactivo = 1
				
				   and pes.PEScodigo = pea.PEScodigo
				   and pes.PESestado = 1
				   and convert(varchar,getdate(),112) between isnull(convert(varchar,pes.PESdesde,112),convert(varchar,getdate(),112))
														  and isnull(convert(varchar,pes.PEShasta,112),isnull(convert(varchar,pes.PESmaxima,112),convert(varchar,getdate(),112)))
				   and mp.PEScodigo = pes.PEScodigo
				
				   and m.Mcodigo = mp.Mcodigo
				   and m.Mtipo = 'E'
				
				   and ele.Mcodigo = m.Mcodigo
				   and ele.McodigoElegible = c.Mcodigo
				
				   -- Que no haya aprobado ya la Materia Electiva
				   and not exists(select * from AlumnoMateria am
								   where am.Apersona = ca.Apersona
									 and am.MPcodigo = mp.MPcodigo
								 )
				   -- Que no haya aprobado ya la Materia Elegible en el mismo plan (ganada por segunda vez)
				   and not exists(select * from AlumnoMateria am, MateriaPlan mp1
								   where am.Apersona = ca.Apersona
									 and am.Mcodigo  = c.Mcodigo
							 
									 and mp1.MPcodigo  = am.MPcodigo
									 and mp1.PEScodigo = mp.PEScodigo
								 )
				   -- Que la Materia no sea Materia regular del Plan
				   and not exists(select * from MateriaPlan mp1, Materia m1
								   where mp1.Mcodigo  = c.Mcodigo
									 and mp1.PEScodigo = mp.PEScodigo
									 and m1.Mcodigo = mp1.Mcodigo
									 and m1.Mtipo = 'M'
								 )
				group by ca.Ccodigo, ca.Apersona, c.Mcodigo, mp.PEScodigo
				   
			</cfquery>
		<cfelseif isdefined("btnGrabar")>
			<cfset LvarEstadoCurso = qryCurso.CestadoCalificacion>
		</cfif>
		<cfif LvarEstadoCurso EQ "1">
			<cfloop from="1" to="#form.txtCols#" index="LvarCol">
				<cfif LvarEstadoCurso NEQ "1">
					<cfparam name="form.chkCerrar#LvarCol#" default="1">
				<cfelse>
					<cfparam name="form.chkCerrar#LvarCol#" default="0">
				</cfif>
				<cfif isdefined("form.txtCEVtipoCalificacion#LvarCol#")>
					<cfset LvarTipoCalificacion = Evaluate("form.txtCEVtipoCalificacion#LvarCol#")>
					<cfif LvarTipoCalificacion EQ "2">
						<cfset LvarPuntosMax = Evaluate("form.txtCEVpuntosMax#LvarCol#")>
					<cfelseif LvarTipoCalificacion EQ "T">
						<cfset LvarTabla = Evaluate("form.txtTEcodigo#LvarCol#")>
					</cfif>
				</cfif>
				<cfset LvarEstado = Evaluate("form.hdnCerrar#LvarCol#")>
				<cfif Evaluate("form.chkCerrar#LvarCol#") EQ "0">
					<cfif LvarEstado EQ "2">
	<!---
						<cfset comp = Evaluate("form.txtCEVcodigo#LvarCol#")>
						<cfset LvarAsunto = "Notificacion Automatica por apertura de Componente de Evaluacion Cerrado">
						<cfset LvarMsg = "Por este medio se le comunica que las evaluaciones #qryCorreos.Evaluacion#, correspondientes al Periodo #qryCorreos.Periodo# del curso #qryCorreos.Curso#, las cuales se encontraban cerradas, han sido abiertas por el usuario '#qryUsuActual.Nombre#' (Login='#qryUsuActual.Login#'), por medio de la opción de Abrir Evaluación en la pantalla de Evaluar Periodo">
						<cfset fnNotificarCorreoBuzon ("","","","",LvarAsunto,LvarMSG,'Mensaje automático', LvarAsunto, qryCorreos, true)>
	 --->
					</cfif>
					<cfset LvarEstado = "1">
				<cfelse>
					<cfset LvarEstado = "2">
				</cfif>
				<cfquery datasource="#Session.DSN#">
				update CursoEvaluacion
				   set CEVestado = #LvarEstado#
				 where Ccodigo   = #session.Ccodigo#
				   and PEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.PEcodigo#">
				   and CEVcodigo = #Evaluate("form.txtCEVcodigo#LvarCol#")#
				<cfloop from="1" to="#form.txtRows#" index="LvarLin">
					<cfif LvarTipoCalificacion EQ "1">
						<cfset LvarNota = Evaluate("form.txtNota#LvarLin#_#LvarCol#")>
						<cfif LvarNota NEQ "">
							<cfset LvarPrc = LvarNota / 100>
							<cfset LvarNota = numberformat(LvarNota,"0.00") & "%">
						</cfif>
					<cfelseif LvarTipoCalificacion EQ "2">
						<cfset LvarNota = trim(Evaluate("form.txtNota#LvarLin#_#LvarCol#"))>
						<cfif LvarNota NEQ "">
							<cfset LvarPrc = LvarNota / LvarPuntosMax>
						</cfif>
						<cfset LvarNota = LvarNota & "pts">
					<cfelse>
						<cfset LvarNota = "">
						<cfset LvarPrc = Evaluate("form.cboValor#LvarLin#_#LvarCol#")>
						<cfif LvarPrc NEQ "">
							<cfset LvarNota = fnObtenerCodigoDeTabla(LvarTabla, LvarPrc)>
							<cfset LvarPrc = LvarPrc / 100>
						</cfif>
					</cfif>
					<cfif LvarNota EQ "">
						delete CursoAlumnoEvaluacion 
						where Ccodigo   = #session.Ccodigo#
						  and PEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.PEcodigo#">
						  and Apersona = #Evaluate("form.txtApersona#LvarLin#")#
						  and CEVcodigo = #Evaluate("form.txtCEVcodigo#LvarCol#")#
					<cfelse>
						if exists (select * 
									 from CursoAlumnoEvaluacion 
									where Ccodigo   = #session.Ccodigo#
									  and PEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.PEcodigo#">
									  and Apersona = #Evaluate("form.txtApersona#LvarLin#")#
									  and CEVcodigo = #Evaluate("form.txtCEVcodigo#LvarCol#")#
								)
							update CursoAlumnoEvaluacion
							   set CAEnota = '#LvarNota#'
								 , CAEporcentaje = #LvarPrc#
								 --, ACcerrado    = '#Evaluate("form.chkCerrar#LvarCol#")#'
						   where Ccodigo   = #session.Ccodigo#
							 and PEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.PEcodigo#">
							 and Apersona = #Evaluate("form.txtApersona#LvarLin#")#
							 and CEVcodigo = #Evaluate("form.txtCEVcodigo#LvarCol#")#
					  else
						insert into CursoAlumnoEvaluacion
							   (Ccodigo, PEcodigo, Apersona, CEVcodigo, CAEnota, CAEporcentaje)
						values (
								 #session.Ccodigo#
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.PEcodigo#">
								,#Evaluate("form.txtApersona#LvarLin#")# 
								,#Evaluate("form.txtCEVcodigo#LvarCol#")#
								,'#LvarNota#' 
								,#LvarPrc#
								)
					</cfif>
				</cfloop>
				</cfquery>
			</cfloop>
<!--- 
==================================================================================== 
AMPLIACIONES Y AJUSTE
==================================================================================== 
--->
		<cfelseif LvarEstadoCurso EQ "2" and isdefined("form.txtColsAmpl")>
			<cfloop from="1" to="#form.txtColsAmpl#" index="LvarCol">
				<cfif isdefined("form.CAMtipoCalificacion#LvarCol#")>
					<cfset LvarTipoCalificacion = Evaluate("form.CAMtipoCalificacion#LvarCol#")>
					<cfif LvarTipoCalificacion EQ "2">
						<cfset LvarPuntosMax = Evaluate("form.CAMpuntosMax#LvarCol#")>
					<cfelseif LvarTipoCalificacion EQ "T">
						<cfset LvarTabla = Evaluate("form.TEcodigoAmpl#LvarCol#")>
					</cfif>
				</cfif>
				<cfquery datasource="#Session.DSN#">
				<cfloop from="1" to="#form.txtRows#" index="LvarLin">
					<cfif LvarTipoCalificacion EQ "1">
						<cfset LvarNota = Evaluate("form.txtExtra#LvarLin#_#LvarCol#")>
						<cfif LvarNota NEQ "">
							<cfset LvarPrc = LvarNota / 100>
							<cfset LvarNota = numberformat(LvarNota,"0.00") & "%">
						</cfif>
					<cfelseif LvarTipoCalificacion EQ "2">
						<cfset LvarNota = trim(Evaluate("form.txtExtra#LvarLin#_#LvarCol#"))>
						<cfif LvarNota NEQ "">
							<cfset LvarPrc = LvarNota / LvarPuntosMax>
						</cfif>
					<cfelse>
						<cfset LvarNota = "">
						<cfset LvarPrc = Evaluate("form.cboExtra#LvarLin#_#LvarCol#")>
						<cfif LvarPrc NEQ "">
							<cfset LvarNota = fnObtenerCodigoDeTabla(LvarTabla, LvarPrc)>
							<cfset LvarPrc = LvarPrc / 100>
						</cfif>
					</cfif>
					<cfif LvarNota EQ "">
						delete CursoAlumnoAmpliacion
						where Ccodigo   = #session.Ccodigo#
						  and CAMsecuencia = #Evaluate("form.CAMsecuencia#LvarCol#")#
						  and Apersona = #Evaluate("form.txtApersona#LvarLin#")#
					<cfelse>
						if exists (select * 
									 from CursoAlumnoAmpliacion
									where Ccodigo   = #session.Ccodigo#
									  and Apersona = #Evaluate("form.txtApersona#LvarLin#")#
									  and CAMsecuencia = #Evaluate("form.CAMsecuencia#LvarCol#")#
								)
							update CursoAlumnoAmpliacion
							   set CAAnota = '#LvarNota#'
								 , CAAporcentaje = #LvarPrc#
						   where Ccodigo   = #session.Ccodigo#
							 and Apersona = #Evaluate("form.txtApersona#LvarLin#")#
							 and CAMsecuencia = #Evaluate("form.CAMsecuencia#LvarCol#")#
					  else
						insert into CursoAlumnoAmpliacion
							   (Ccodigo, Apersona, CAMsecuencia, CAAnota, CAAporcentaje)
						values (
								 #session.Ccodigo#
								,#Evaluate("form.txtApersona#LvarLin#")# 
								,#Evaluate("form.CAMsecuencia#LvarCol#")#
								,'#LvarNota#' 
								,#LvarPrc#
								)
					</cfif>
				</cfloop>
				</cfquery>
			</cfloop>

		</cfif>

		<cfquery datasource="#Session.DSN#">
		<cfloop from="1" to=#form.txtRows# index="LvarLin">
			<cfset LvarProgreso = Evaluate("form.txtProgreso#LvarLin#")>
			<cfset LvarProgresoPrc = replace(replace(LvarProgreso,"%",""),"pts","")>
			<cfset LvarAjuste   = Evaluate("form.txtAjuste#LvarLin#")>
			<cfset LvarAjustePrc   = replace(replace(LvarAjuste,"%",""),"pts","")>
			<cfset LvarFinal = Evaluate("form.txtFinal#LvarLin#")>
			<cfset LvarFinalPrc = replace(replace(LvarFinal,"%",""),"pts","")>

			<cfif LvarProgresoPrc EQ "">
				<cfset LvarProgresoPrc = 0>
				<!---
 				<cfset LvarAjuste = "">
				<cfset LvarAjustePrc = "">
				 --->
 				<cfset LvarFinal = "">
				<cfset LvarFinalPrc = "0">
			</cfif>
			<cfif qryCurso.CtipoCalificacion EQ "1">
				<cfset LvarProgresoPrc = LvarProgresoPrc/100>
				<cfif LvarAjustePrc NEQ "">
					<cfset LvarAjustePrc   = LvarAjustePrc/100>
					<cfset LvarAjuste = LvarAjuste & "%">
				</cfif>
				<cfif LvarFinalPrc NEQ "">
					<cfset LvarFinalPrc   = LvarFinalPrc/100>
				</cfif>
			<cfelseif qryCurso.CtipoCalificacion EQ "2">
				<cfset LvarProgresoPrc = LvarProgresoPrc/qryCurso.CpuntosMax>
				<cfif LvarAjustePrc NEQ "">
					<cfset LvarAjustePrc   = LvarAjustePrc/qryCurso.CpuntosMax>
					<cfset LvarAjuste   = LvarAjuste & "pts">
				</cfif>
				<cfif LvarFinalPrc NEQ "">
					<cfset LvarFinalPrc   = LvarFinalPrc/qryCurso.CpuntosMax>
				</cfif>
			<cfelse>
				<cfset LvarProgresoPrc = fnObtenerValorDeTabla(qryCurso.TEcodigo, LvarProgreso)>
				<cfif LvarProgresoPrc EQ "">
					<cfset LvarProgresoPrc = 0>
				<cfelse>
					<cfset LvarProgresoPrc = LvarProgresoPrc/100>
				</cfif>
				<cfif LvarAjustePrc NEQ "">
					<cfset LvarAjuste = fnObtenerCodigoDeTabla(qryCurso.TEcodigo, LvarAjustePrc)>
					<cfset LvarAjustePrc = LvarAjustePrc/100>
				<cfelse >
					<cfset LvarAjuste = "">
				</cfif>
				<cfset LvarFinalPrc = fnObtenerValorDeTabla(qryCurso.TEcodigo, LvarFinal)>
				<cfif LvarFinalPrc EQ "">
					<cfset LvarFinalPrc = 0>
				<cfelse>
					<cfset LvarFinalPrc = LvarFinalPrc/100>
				</cfif>
			</cfif>
			<cfset LvarProgresoPrc = numberformat(LvarProgresoPrc,"0.0000")>

			<cfif LvarEstadoCurso EQ "1">
				update CursoAlumno
				   set CAporcProgreso = #LvarProgresoPrc#
					 , CAestado = 01	<!--- CURSANDO --->
				     , CAporcFinal = null
					 , CAnotaFinal = null
				 where Ccodigo   = #session.Ccodigo#
				   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate("form.txtApersona#LvarLin#")#">
				   and CAestado <> 10	<!--- RETIRADO --->
			<cfelse>
				update CursoAlumno
				   set CAestado = 
							case trr.TRRtipo
								when '1' then 20	<!--- APROBADO --->
								<cfif LvarEstadoCurso EQ "2">
								when '2' then 02	<!--- APLAZADO --->
								<cfelse>
								when '2' then 11	<!--- REPROBADO --->
								</cfif>
								when '3' then 11	<!--- REPROBADO --->
							end
				     , CAporcProgreso = #LvarProgresoPrc#
				<cfif LvarAjuste NEQ "">
					<cfset LvarAjustePrc   = numberformat(LvarAjustePrc,"0.0000")>
					 , CAporcAjuste   = #LvarAjustePrc#
					 , CAnotaAjuste   = '#LvarAjuste#'
				<cfelse>
					 , CAporcAjuste   = null
					 , CAnotaAjuste   = null
				</cfif>
					 , CAporcFinal    = #LvarFinalPrc#
					 , CAnotaFinal    = '#LvarFinal#'
				  from CursoAlumno ca, Curso c, TablaResultadoRango trr
				 where ca.Ccodigo = #session.Ccodigo#
				   and Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate("form.txtApersona#LvarLin#")#">
				   and CAestado <> 10	<!--- RETIRADO --->
				   and c.Ccodigo  = ca.Ccodigo
				   and trr.TRcodigo = c.TRcodigo
				   and #LvarFinalPrc*100# between trr.TRRminimo and trr.TRRmaximo
			</cfif>
		</cfloop>
		</cfquery>
<!--- ====================================================================================
		  <cfloop from="1" to=#form.txtRows# index="LvarLin">
			  <cfquery datasource="#Session.DSN#">
				set nocount on

				<cfif LvarGanado eq ""><cfset LvarGanado = "null"><cfelse><cfset LvarGanado = Replace(LvarGanado, "%", "")></cfif>
				<cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
				<cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
				  if exists(select * from AlumnoCalificacionPerEval
							 where PEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
							   and Ecodigo      = #Evaluate("form.txtApersona#LvarLin#")#
							   and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
							   and Ccodigo      = #session.Ccodigo#
							)
					begin
						update AlumnoCalificacionPerEval 
						   set ACPEnota           = #LvarGanado#
							 , ACPEnotacalculada  = #LvarAjuste#
							 , ACPEnotaprog       = #LvarProgreso#
							 , ACPEvalor          = <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>
							 , ACPEvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
							 , ACPEvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
							 , ACPEcerrado        = '#form.chkCerrar0#'
						 where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
						   and Ecodigo  = #Evaluate("form.txtApersona#LvarLin#")#
						   and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						   and Ccodigo  = #session.Ccodigo#
					end
				  else
				  begin   
					insert into AlumnoCalificacionPerEval 
						   (PEcodigo, Ecodigo, CEcodigo, Ccodigo, 
							ACPEnota, ACPEnotacalculada, ACPEnotaprog, 
							ACPEvalor, ACPEvalorcalculado, ACPEvalorprog, 
							ACPEcerrado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">, 
							#Evaluate("form.txtApersona#LvarLin#")#, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
							#session.Ccodigo#, 
							#LvarGanado#,  
							#LvarAjuste#, 
							#LvarProgreso#,
							<cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>,
							<cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
							<cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
							'#form.chkCerrar0#')
				  end
				</cfif>
				set nocount off
			  </cfquery>
				
			  <!---  Actualiza el período del Curso Complementario --->
			  <cfif qryComplementaria.Curso neq "">
				<cfquery datasource="#Session.DSN#" name="qryComplementos">
				  set nocount on
				  select round(avg (ACPEnota),2)           as Ganado,
						 round(avg (ACPEnotacalculada),2)  as Ajuste,
						 round(avg (ACPEnotaprog),2)       as Progreso
					from AlumnoCalificacionPerEval n, 
						 Curso c, MateriaElectiva ME, Materia MRc, Curso CRc
				   where c.Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
					 and n.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
					 and n.Ecodigo  = #Evaluate("form.txtApersona#LvarLin#")#
					 and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					 and n.Ccodigo  = CRc.Ccodigo
					 and ME.Melectiva     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Materia#">
					 and ME.Mconsecutivo  = MRc.Mconsecutivo
					 and MRc.Melectiva    = 'R'
					 and CRc.Mconsecutivo = MRc.Mconsecutivo
					 and CRc.CEcodigo     = c.CEcodigo
					 and CRc.PEcodigo     = c.PEcodigo
					 and CRc.SPEcodigo    = c.SPEcodigo
					 and CRc.GRcodigo     = c.GRcodigo
				  set nocount off
				</cfquery>
				<cfif qryComplementaria.Tabla eq "">
				  <cfset LvarGanado = qryComplementos.Ganado>
				  <cfset LvarAjuste   = qryComplementos.Ajuste>
				  <cfset LvarProgreso = qryComplementos.Progreso>
				  <cfset LvarGanadoValor = "">
				  <cfset LvarAjusteValor   = "">
				  <cfset LvarProgresoValor = "">
				<cfelse>
				  <cfset LvarGanado = qryComplementos.Ganado>
				  <cfset LvarAjuste   = qryComplementos.Ajuste>
				  <cfset LvarProgreso = qryComplementos.Progreso>
		
				  <cfset LvarGanadoValor = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarGanado)>
				  <cfset LvarAjusteValor   = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarAjuste)>
				  <cfset LvarProgresoValor = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarProgreso)>
				</cfif>
				<cfquery datasource="#Session.DSN#">
				set nocount on
				<cfif LvarGanado eq "" and LvarAjuste eq "" and LvarProgreso eq "">
				  delete AlumnoCalificacionPerEval 
				   where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
					 and Ecodigo  = #Evaluate("form.txtApersona#LvarLin#")#
					 and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					 and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
				<cfelse>
				  <cfif LvarGanado eq ""><cfset LvarGanado = "null"><cfelse><cfset LvarGanado = Replace(LvarGanado, "%", "")></cfif>
				  <cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
				  <cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
				  if exists(select * from AlumnoCalificacionPerEval
							 where PEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
							   and Ecodigo      = #Evaluate("form.txtApersona#LvarLin#")#
							   and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
							   and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
							)
					update AlumnoCalificacionPerEval 
					   set ACPEnota           = #LvarGanado#
						 , ACPEnotacalculada  = #LvarAjuste#
						 , ACPEnotaprog       = #LvarProgreso#
						 , ACPEvalor          = <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>
						 , ACPEvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
						 , ACPEvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
						 , ACPEcerrado        = '#form.chkCerrar0#'
					 where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
					   and Ecodigo  = #Evaluate("form.txtApersona#LvarLin#")#
					   and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
				  else   
					insert into AlumnoCalificacionPerEval 
						   (PEcodigo, Ecodigo, CEcodigo, Ccodigo, 
							ACPEnota, ACPEnotacalculada, ACPEnotaprog, 
							ACPEvalor, ACPEvalorcalculado, ACPEvalorprog, 
							ACPEcerrado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">, 
							#Evaluate("form.txtApersona#LvarLin#")#, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">, 
							#LvarGanado#,  
							#LvarAjuste#, 
							#LvarProgreso#,
							<cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>,
							<cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
							<cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
							'#form.chkCerrar0#')
				</cfif>
				set nocount off
				</cfquery>
			  </cfif>
		  </cfloop>
 --->	</cfoutput>
</cftransaction>

<cflocation url="calificarEvaluaciones.cfm?form.chkCalcular">
<!--- <cfoutput>
<form action="SQL" method="post" name="sql">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
 --->