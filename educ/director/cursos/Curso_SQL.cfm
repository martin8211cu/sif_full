<cfif isdefined("Form.btnActivar") and Session.Menues.SScodigo EQ 'RH'>
	<cfsetting requesttimeout="#3600*24#">
</cfif>

<cfif isdefined('form.AltaD') or isdefined('form.CambioD')>
	<cfif isdefined('form.CCEorden') and form.CCEorden NEQ ''>
		<cfset varCCEorden = form.CCEorden>
	<cfelse>
		<cfquery name="qryCCEorden" datasource="#Session.DSN#">
			select (max(CCEorden) + 1) as CCEorden
			from CursoConceptoEvaluacion		
			where Ccodigo=<cfqueryparam value="#form.Ccodigo#" cfsqltype="cf_sql_numeric">
				and PEcodigo=<cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif isdefined('qryCCEorden') and qryCCEorden.recordCount GT 0 and qryCCEorden.CCEorden GT 0>
			<cfset varCCEorden = qryCCEorden.CCEorden>
		<cfelse>
			<cfset varCCEorden = 1>	
		</cfif>	
	</cfif>
</cfif>

<cfif isdefined("Form.btnActivar")>
	<!--- Sistema RH. Enviar correo a los empleados que tengan en su puesto competencias asociadas al curso que se está activando --->
	<cfif Session.Menues.SScodigo EQ 'RH'>
		<!---
		<cfquery name="rsEmpleadosRH" datasource="#Session.DSN#">
			select d.DEid
			from Curso a, RHHabilidadesMaterias b, RHHabilidadesPuesto c, LineaTiempo d
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			and a.Ecodigo = b.Ecodigo
			and a.Mcodigo = b.Mcodigo
			and b.Ecodigo = c.Ecodigo
			and b.RHHid = c.RHHid
			and c.Ecodigo = d.Ecodigo
			and c.RHPcodigo = d.RHPcodigo
			and getDate() between d.LTdesde and d.LThasta
			union
			select d.DEid
			from Curso a, RHConocimientosMaterias b, RHConocimientosPuesto c, LineaTiempo d
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			and a.Ecodigo = b.Ecodigo
			and a.Mcodigo = b.Mcodigo
			and b.Ecodigo = c.Ecodigo
			and b.RHCid = c.RHCid
			and c.Ecodigo = d.Ecodigo
			and c.RHPcodigo = d.RHPcodigo
			and getDate() between d.LTdesde and d.LThasta
		</cfquery>

		<cfquery name="rsAvisoEmpleados" datasource="asp">
			select rtrim(h.Pnombre || ' ' || rtrim(h.Papellido1 || ' ' || h.Papellido2)) || ' <' || rtrim(h.Pemail1) || '>' as destinatario
			from UsuarioReferencia e, UsuarioReferencia f, Usuario g, DatosPersonales h
			where e.STabla = 'DatosEmpleado'
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			<cfif rsEmpleadosRH.recordCount GT 0>
			and convert(numeric, e.llave) in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#ValueList(rsEmpleadosRH.DEid, ',')#" separator=",">)
			and e.llave in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(rsEmpleadosRH.DEid, ',')#" separator=",">)
			<cfelse>
			and convert(numeric, e.llave) = 0
			and e.llave = '0'
			</cfif>
			and e.Ecodigo = f.Ecodigo
			and f.STabla = 'PersonaEducativo'
			and e.Usucodigo = f.Usucodigo
			and f.Usucodigo = g.Usucodigo
			and g.Utemporal = 0
			and g.Uestado = 1
			and g.datos_personales = h.datos_personales
			and rtrim(h.Pemail1) is not null
		</cfquery>
		--->
	
		<cfquery name="rsAvisoEmpleados" datasource="#Session.DSN#">
			select rtrim(h.Pnombre || ' ' || rtrim(h.Papellido1 || ' ' || h.Papellido2)) || ' <' || rtrim(h.Pemail1) || '>' as destinatario
			from Curso a, RHHabilidadesMaterias b, RHHabilidadesPuesto c, LineaTiempo d, UsuarioReferencia e, UsuarioReferencia f, Usuario g, DatosPersonales h
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			and a.Ecodigo = b.Ecodigo
			and a.Mcodigo = b.Mcodigo
			and b.Ecodigo = c.Ecodigo
			and b.RHHid = c.RHHid
			and c.Ecodigo = d.Ecodigo
			and c.RHPcodigo = d.RHPcodigo
			and getDate() between d.LTdesde and d.LThasta
			and e.STabla = 'DatosEmpleado'
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			and convert(numeric, e.llave) = d.DEid
			and e.llave = convert(varchar, d.DEid)
			and e.Ecodigo = f.Ecodigo
			and f.STabla = 'PersonaEducativo'
			and e.Usucodigo = f.Usucodigo
			and f.Usucodigo = g.Usucodigo
			and g.Utemporal = 0
			and g.Uestado = 1
			and g.datos_personales = h.datos_personales
			and rtrim(h.Pemail1) is not null
			
			union
			
			select rtrim(h.Pnombre || ' ' || rtrim(h.Papellido1 || ' ' || h.Papellido2)) || ' <' || rtrim(h.Pemail1) || '>' as destinatario
			from Curso a, RHConocimientosMaterias b, RHConocimientosPuesto c, LineaTiempo d, UsuarioReferencia e, UsuarioReferencia f, Usuario g, DatosPersonales h
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			and a.Ecodigo = b.Ecodigo
			and a.Mcodigo = b.Mcodigo
			and b.Ecodigo = c.Ecodigo
			and b.RHCid = c.RHCid
			and c.Ecodigo = d.Ecodigo
			and c.RHPcodigo = d.RHPcodigo
			and getDate() between d.LTdesde and d.LThasta
			and e.STabla = 'DatosEmpleado'
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			and convert(numeric, e.llave) = d.DEid
			and e.llave = convert(varchar, d.DEid)
			and e.Ecodigo = f.Ecodigo
			and f.STabla = 'PersonaEducativo'
			and e.Usucodigo = f.Usucodigo
			and f.Usucodigo = g.Usucodigo
			and g.Utemporal = 0
			and g.Uestado = 1
			and g.datos_personales = h.datos_personales
			and rtrim(h.Pemail1) is not null
		</cfquery>
		
		<cfif rsAvisoEmpleados.recordCount GT 0>
			<cfquery name="rsParametroFrom" datasource="#Session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Pcodigo = 190
			</cfquery>
			<cfset From = Trim(rsParametroFrom.Pvalor)>
			
			<cfquery name="rsCurso" datasource="#Session.DSN#">
				select rtrim(b.Mcodificacion) || ' ' || b.Mnombre as Mnombre, b.Mcreditos
				from Curso a, Materia b
				where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and a.Ecodigo = b.Ecodigo
				and a.Mcodigo = b.Mcodigo
			</cfquery>
			
			<cfquery name="rsHorario" datasource="#Session.DSN#">
				select (case a.HOdia when 1 then 'D' when 2 then 'L' when 3 then 'K' when 4 then 'M' when 5 then 'J' when 6 then 'V' when 7 then 'S' else '' end) as Dia, 
					 a.HOinicio, 
					 a.HOfinal, 
					 case when a.AUcodigo is null then '(No asig)' else b.AUcodificacion end as AUcodificacion
				from Horario a, Aula b
				where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and a.AUcodigo *= b.AUcodigo
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				order by a.HOdia, a.HOinicio, a.HOfinal
			</cfquery>
			
			<cfsavecontent variable="Message">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>Se acaba de abrir un nuevo curso que podr&iacute;a ser de su inter&eacute;s. A continuaci&oacute;n se muestran los detalles del curso: </td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="left">
						<table width="70%"  border="0" cellspacing="0" cellpadding="0" style="border: 1px solid black; ">
						  <tr align="center">
							<td colspan="2" nowrap style="font-weight: bold; border-bottom: 1px solid black; ">Datos del Curso</td>
						  </tr>
						  <tr>
							<td align="right" nowrap style="font-weight:bold; padding-right: 10px;">Nombre del Curso:</td>
							<td nowrap>#rsCurso.Mnombre#</td>
						  </tr>
						  <tr>
							<td align="right" nowrap style="font-weight:bold; padding-right: 10px;">Cr&eacute;ditos:</td>
							<td nowrap>#rsCurso.Mcreditos#</td>
						  </tr>
						  <tr>
							<td align="right" valign="top" nowrap style="font-weight:bold; padding-right: 10px;">Horario:</td>
							<td nowrap>
								<cfif rsHorario.recordCount EQ 0>
								(NO ASIGNADO)
								<cfelse>
									<table border="0" width="100%" cellpadding="2" cellspacing="0">
										<tr>
											<td width="4%" style="padding-right: 10px; border-bottom: 1px solid black;" nowrap><strong>Dia</strong></td>
											<td width="20%" style="padding-right: 10px; border-bottom: 1px solid black;" nowrap><strong>Hora</strong></td>
											<td style="padding-right: 10px; border-bottom: 1px solid black;" nowrap><strong>Lugar</strong></td>
										</tr>
										<cfloop query="rsHorario">
											<tr>
												<td style="padding-right: 10px;" nowrap><strong>#Dia#</strong></td>
												<td style="padding-right: 10px;" nowrap>&nbsp;#HOinicio#&nbsp;-&nbsp;#HOfinal#</td>
												<td style="padding-right: 10px;" nowrap>&nbsp;#AUcodificacion#</td>
											</tr>
										</cfloop>
									</table>
								</cfif>				
							</td>
						  </tr>
					  </table>	
					</td>
				  </tr>
				</table>
			</cfoutput>
			</cfsavecontent>
			
			<cftransaction>
				<cftry>
					<cfloop query="rsAvisoEmpleados">
						<cfset correo = rsAvisoEmpleados.destinatario>
						<cfquery name="rsEnviar" datasource="asp">
							insert SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
							values(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#From#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#correo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Nuevo Curso">,
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Message#">,
								1
							)
						</cfquery>
					</cfloop>
				<cfcatch type="any">
					<cftransaction action="rollback">
					<cfinclude template="../../errorpages/BDerror.cfm">
					<cfabort>
				</cfcatch>
				</cftry>
			
			</cftransaction>
		</cfif>
	</cfif>
</cfif>

<cftransaction>
	<cftry>
		<cfif isdefined("Form.btnCambiar")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				update Curso
				   set CmatriculaMaxima = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Cupo#">,
					   CsolicitudMaxima = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Cupo#">,
					   DOpersona = <cfif form.DOpersona EQ "">null<cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DOpersona#"></cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>
		<cfelseif isdefined("Form.btnAsistente")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				delete CursoDocente
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				<cfparam name="form.DOpersona" default="">
				<cfset LvarAsistentes = ListToArray(Replace(Form.DOpersona, ' ', '', 'all'), ',')>
				<cfloop index="i" from="1" to="#ArrayLen(LvarAsistentes)#">
				  insert into CursoDocente (Ccodigo, DOpersona, DOCtipo)
				  values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">,
				  			#LvarAsistentes[i]#,
							'3')
				</cfloop>
			</cfquery>
		<cfelseif isdefined("Form.btnActivar")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				update Curso
				   set Cestado = 1
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>
			<cfset modo = 'LISTA'>
			<cfset form.Ccodigo = "">
		<cfelseif isdefined("Form.btnCerrar")>
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				update Curso
				   set Cestado = 2
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>		
			<cfset modo = 'LISTA'>
			<cfset form.Ccodigo = "">
		<cfelseif isdefined("Form.CambioParam")>
			<!--- Consulta para revisar si el codigo del Plan de Evaluacion (PEVcodigo)
				es diferente al que actualmente se encuentra guardado en la tabla de Curso --->
			<cfquery name="PlanEval_Curso" datasource="#Session.DSN#">
				Select PEVcodigo
				from Curso
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			</cfquery>		
		
			<cfif form.PEVcodigo NEQ '-1'>
				<cfif isdefined('PlanEval_Curso') and PlanEval_Curso.recordCount GT 0>
					<cfif (PlanEval_Curso.PEVcodigo EQ '') or (PlanEval_Curso.PEVcodigo NEQ form.PEVcodigo)>	<!--- El curso tenia un Plan de Evaluacion Propio --->
						<cfquery name="qryPeriodo_Curso" datasource="#Session.DSN#">
							select cp.PEcodigo
							from CursoPeriodo cp
								, Curso c
								, PeriodoEvaluacion pe
							where cp.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
								and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								and cp.Ccodigo=c.Ccodigo
								and cp.PEcodigo=pe.PEcodigo
								and c.Ecodigo=pe.Ecodigo							
						</cfquery>	
						<cfif isdefined('qryPeriodo_Curso') and qryPeriodo_Curso.recordCount GT 0>
							<cfquery name="qryBorra_CursoConcEval" datasource="#Session.DSN#">
								delete CursoConceptoEvaluacion
								where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
									and PEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#qryPeriodo_Curso.PEcodigo#">
							</cfquery>
						</cfif>

						<!--- Insercion de los nuevos registros para el nuevo plan de evaluacion
							seleccionado para el curso --->
						<cfif isdefined('qryPeriodo_Curso') and qryPeriodo_Curso.recordCount GT 0>
							<cfquery name="qryBorra_CursoConcEval" datasource="#Session.DSN#">
								insert CursoConceptoEvaluacion 
								(Ccodigo, PEcodigo, CEcodigo, CCEporcentaje, CCEorden)
								Select #Form.Ccodigo# as Ccodigo
									, #qryPeriodo_Curso.PEcodigo# as PEcodigo
									, CEcodigo
									, PECporcentaje
									, PECorden
								from PlanEvaluacionConcepto
								where PEVcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEVcodigo#">
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			
			<cfquery name="ABC_Curso" datasource="#Session.DSN#">
				set nocount on				
					update Curso
					   set CtipoCalificacion = <cfqueryparam value="#form.CtipoCalificacion#" cfsqltype="cf_sql_char">
							, TRcodigo = <cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_numeric">
							<cfif isdefined('form.PEVcodigo') and form.PEVcodigo NEQ '-1'>
								, PEVcodigo = <cfqueryparam value="#form.PEVcodigo#" cfsqltype="cf_sql_numeric">
							<cfelse>
								, PEVcodigo = null					
							</cfif>
							<cfif isdefined("Form.CpuntosMax") and Len(Trim(Form.CpuntosMax))>
								, CpuntosMax = <cfqueryparam value="#Form.CpuntosMax#" cfsqltype="cf_sql_numeric" scale="2">
							<cfelse>
								, CpuntosMax = null
						    </cfif>
							<cfif isdefined("Form.CunidadMin") and Len(Trim(Form.CunidadMin))>
								, CunidadMin = <cfqueryparam value="#Form.CunidadMin#" cfsqltype="cf_sql_numeric" scale="2">
							<cfelse>
								, CunidadMin = null
						    </cfif>
							<cfif isdefined("Form.Credondeo") and Len(Trim(Form.Credondeo))>
								, Credondeo = <cfqueryparam value="#Form.Credondeo#" cfsqltype="cf_sql_numeric" scale="3">
							<cfelse>
								, Credondeo = null
						    </cfif>
							<cfif isdefined("Form.TEcodigo") and Len(Trim(Form.TEcodigo))>
								, TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEcodigo#">						   
							<cfelse>
								, TEcodigo = null
						    </cfif>
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
						and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				set nocount off
			</cfquery>			
			
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.CambioD")>			
			<cfquery name="ABC_CursoConceptoEvaluacion" datasource="#Session.DSN#">
				set nocount on		
					update CursoConceptoEvaluacion set
						CCEporcentaje = <cfqueryparam value="#Form.CCEporcentaje#" cfsqltype="cf_sql_smallint">
					where CEcodigo   = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
						and PEcodigo  = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
						and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">			  
				set nocount off
			</cfquery>
						  
			<cfset modoD="CAMBIO">					
			<cfset modo="CAMBIO">		
		<cfelseif isdefined("Form.BajaD")>			
			<cfquery name="ABC_CursoConceptoEvaluacion" datasource="#Session.DSN#">
				set nocount on		
					delete CursoConceptoEvaluacion
					where CEcodigo   = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
						and PEcodigo  = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
						and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">			  
				set nocount off
			</cfquery>
						  
			<cfset modoD="ALTA">					
			<cfset modo="CAMBIO">			
		<cfelseif isdefined("Form.AltaD")>			
			<cfquery name="ABC_CursoConceptoEvaluacion" datasource="#Session.DSN#">
				set nocount on		
					insert CursoConceptoEvaluacion 
						(Ccodigo, PEcodigo, CEcodigo, CCEporcentaje, CCEorden)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
						, <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#Form.CCEporcentaje#" cfsqltype="cf_sql_smallint">
						, <cfqueryparam value="#varCCEorden#" cfsqltype="cf_sql_smallint">						
					)
				set nocount off
			</cfquery>
						  
			<cfset modoD="ALTA">					
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.NuevoD")>			
			<cfset modoD="ALTA">					
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0 
				and isdefined("Form._Rows") and Len(Trim(Form._Rows)) NEQ 0 
				and isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0
				and isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0				
				and isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0>

			<!--- Obtener todas las llaves --->
			<cfset listaValores = "">
			<cfloop index="i" from="1" to="#Form._Rows#">
				<cfif isdefined('Form.CEcodigo_#form.PEcodigo#_'&i)>
					<cfif listaValores NEQ ''>
						<cfset listaValores = listaValores & "," & Evaluate('Form.CEcodigo_#form.PEcodigo#_'&i)>
					<cfelse>
						<cfset listaValores = Evaluate('Form.CEcodigo_#form.PEcodigo#_'&i)>				
					</cfif>
				</cfif>
			</cfloop>		
			<!--- Si la acción es bajar --->
			<cfif Form._ActionTag EQ "pushDown">
				<cfset pos = ListFind(listaValores, Form.CEcodigo, ',')>	<!--- posicion del item a bajar --->
				<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
					<cfset swap_CEcodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
				</cfif>
			<!--- Si la acción es subir --->
			<cfelseif Form._ActionTag EQ "pushUp">
				<cfset pos = ListFind(listaValores, Form.CEcodigo, ',')>	<!--- posicion del item a subir --->
				<cfif pos NEQ 0 and (pos-1) GT 0>
					<cfset swap_CEcodigo = ListGetAt(listaValores, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
				</cfif>		
			</cfif>			
		
			<cfif isdefined("swap_CEcodigo")>
				<cfquery name="updOrden" datasource="#Session.DSN#">
					declare @o1 smallint, @o2 smallint
					select @o1 = CCEorden
					from CursoConceptoEvaluacion
					where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
						and PEcodigo = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
						and CEcodigo = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
										
					select @o2 = CCEorden
					from CursoConceptoEvaluacion
					where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
						and PEcodigo = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_CEcodigo#">
				
					update CursoConceptoEvaluacion set CCEorden = @o2
					where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
						and PEcodigo = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
						and CEcodigo = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
				
					update CursoConceptoEvaluacion set CCEorden = @o1
					where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
						and PEcodigo = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_CEcodigo#">
				</cfquery>
			</cfif>
		<cfelseif isdefined("Form.AddProf") and form.AddProf NEQ '' and isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
			<cfquery name="A_ProfMateria" datasource="#Session.DSN#">
				insert DocenteMateria 
				(DOpersona, Mcodigo, DOMtipo, DOMfecha, DOMactivo)
				values (
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AddProf#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
					, '1'
					, getDate()
					, 1)		
			</cfquery>
		
			<cfset modoD="ALTA">					
			<cfset modo="CAMBIO">
		</cfif>				 									
	
	<cfcatch type="any">
		<cftransaction action="rollback">
		<cfinclude template="../../errorpages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>

<cfoutput>
<form action="<cfif session.MoG EQ "G">CursoGeneracion.cfm<cfelse>CursoMantenimiento.cfm</cfif>" method="post">
		<cfif isdefined("form.CILtipoCicloDuracion")>
			<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
			<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
			<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
			<cfif form.CILtipoCicloDuracion EQ "E">
			<input type="hidden" name="PEcodigo" id="PEcodigo" value="#Form.PEcodigo#">	
			</cfif>
			<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
			<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
			<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
			<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
			<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
			<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
			<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
		</cfif>
		<cfif isdefined("modoD") and modoD EQ 'CAMBIO'>
			<input name="modoD" type="hidden" value="<cfif isdefined("modoD")>#modoD#</cfif>">
			<input name="CEcodigo" type="hidden" value="<cfif isdefined("form.CEcodigo")>#form.CEcodigo#</cfif>">
			<cfif not isdefined("form.CILtipoCicloDuracion")>
				<input name="PEcodigo" type="hidden" value="<cfif isdefined("form.PEcodigo")>#form.PEcodigo#</cfif>">						
			</cfif>
		</cfif>		
		<input type="hidden" name="Ccodigo" id="Ccodigo" value="#form.Ccodigo#">
	<input type="hidden" name="btnCursos" value="1">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
