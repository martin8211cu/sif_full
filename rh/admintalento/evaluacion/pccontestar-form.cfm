<cfif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'C'>
	<cfquery name="data" datasource="#session.DSN#"><!--- COMPORTAMIENTO /HABILIDAD --->
		select a.RHRSEid,a.RHERid,e.RHIEid,a.DEid,a.DEideval,f.RHHcodigo,f.RHHdescripcion,g.RHCOid,g.RHCOcodigo,g.RHCOdescripcion,g.RHGNid,x.RHDGNid
		from RHRSEvaluaciones z
		inner join  RHRERespuestas a
			on a.RHRSEid = z.RHRSEid 
		inner join RHDRelacionSeguimiento b
			on z.RHDRid= b.RHDRid
		inner join RHRelacionSeguimiento c
			on b.RHRSid = c.RHRSid
		inner join RHItemEvaluar e 
			on a.RHIEid = e.RHIEid
			and e.RHHid  is not null
		inner join RHHabilidades f
			on e.RHHid = f.RHHid
		inner join RHComportamiento g
			on e.RHHid = g.RHHid
		left outer join RHRespuestas x
			on a.RHERid = x.RHERid
			and g.RHCOid  = x.RHCOid 
			and e.RHIEid  = x.RHIEid
		where z.RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
		order by f.RHHcodigo,g.RHCOcodigo
	</cfquery>
<cfelseif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'O'>
	<cfquery name="data" datasource="#session.DSN#"> <!--- OBJETIVOS --->
		select a.RHRSEid,a.RHERid,e.RHIEid,a.DEid,a.DEideval,f.RHOStexto,c.RHGNid,x.RHDGNid,e.RHOSid
		from RHRSEvaluaciones z
		inner join  RHRERespuestas a
			on a.RHRSEid = z.RHRSEid 
		inner join RHDRelacionSeguimiento b
			on z.RHDRid= b.RHDRid
		inner join RHRelacionSeguimiento c
			on b.RHRSid = c.RHRSid
		inner join RHItemEvaluar e 
			on a.RHIEid = e.RHIEid
			and e.RHOSid is not null
			and e.RHIEid not in (#lista_RHIEid#)
		inner join RHObjetivosSeguimiento f
			on e.RHOSid = f.RHOSid
		left outer join RHRespuestas x
			on a.RHERid = x.RHERid
			and e.RHIEid  = x.RHIEid 
		where z.RHRSEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSEid#">
		order by e.RHIEorden
	</cfquery>
</cfif>	

<!--- <cfdump var="#RSUltima.RHRSEid#"> --->
<cfif data.recordCount GT 0>
	<cfoutput>
	<form name="form1" style="margin:0;" method="post" action="evaluar_des-sql.cfm" >
		<input type="hidden" name="RHRSEid" value="#form.RHRSEid#">
		<input type="hidden" name="tipo" value="#form.tipo#">
		<input type="hidden" name="TipoEval" value="#form.TipoEval#">
		<input type="hidden" name="DEideval" value="#form.DEideval#">
		<input type="hidden" name="DEid" value="#form.DEid#">
		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td align="center">
					<div align="center" style=" width:950px; height:300px; border:1px solid ##F1F1F1; overflow:auto; display:block; padding: 10 10 10 10;" > 
						<table width="100%" border="0" cellpadding="2" cellspacing="2">
							<cfif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'C'>
								<CFSET CORTE = "">
								<CFSET Combo = "">
								<CFSET Resp = "">
								<cfset RHCOid="">
								<cfset RHIEid="">
								<cfloop query="data">
									<CFSET Combo = data.RHGNid>
									<CFSET Resp = data.RHDGNid>
									<CFSET RHCOid = data.RHCOid>
									<CFSET RHIEid = data.RHIEid>
									<cfif trim(data.RHHcodigo) neq trim(CORTE)>
					                    <cfset CORTE = #trim(data.RHHcodigo)#>
										<tr><td>&nbsp;</td></tr>
										<tr><td colspan="3" style="padding:0; border-bottom: 1px solid black;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#data.RHHcodigo# - #data.RHHdescripcion#</strong></td></tr>
										<tr>
											<td>&nbsp;</td>
											<td><b><cf_translate  key="LB_Actual">Actual</cf_translate></b></td>
											<td><b><cf_translate  key="LB_Anterior">Anterior</cf_translate></b></td>
										</tr>
									</cfif>	
									<tr>
										<td colspan="1"  valign="top">
											<font style="font-family:Times New Roman', Times, serif; font-size:12px"></font>&iquest;&nbsp;#data.RHCOdescripcion#&nbsp;?</td>
										</td>
										<td colspan="1" valign="top">
											<cfquery name="Respuestas" datasource="#session.DSN#">
												select RHDGNid,RHDGNcodigo,RHDGNdescripcion from RHDGrupoNivel
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
												and RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Combo#">
												order by RHDGNpeso
											</cfquery>
											<select name="CMB_#RHIEid#_#RHCOid#" tabindex="1">
												<option value=""></option>
												<cfloop query="Respuestas">
												  <option value="#Respuestas.RHDGNid#"  <cfif isdefined("Respuestas.RHDGNid") and len(trim(Resp)) and Respuestas.RHDGNid eq Resp> selected </cfif>>
													#Respuestas.RHDGNdescripcion#</option>
												</cfloop>
											</select>	
										</td>
										<td colspan="1" valign="top">
											<cfif isdefined("RSUltima.RHRSEid") and len(trim(RSUltima.RHRSEid))>
												
												<cfquery name="RespuestasA" datasource="#session.DSN#">
													select y.RHDGNdescripcion
													from RHRSEvaluaciones z
													inner join  RHRERespuestas a
														on a.RHRSEid = z.RHRSEid 
													inner join RHDRelacionSeguimiento b
														on z.RHDRid= b.RHDRid
													inner join RHRelacionSeguimiento c
														on b.RHRSid = c.RHRSid
													inner join RHItemEvaluar e 
														on a.RHIEid = e.RHIEid
														and e.RHHid  is not null
													inner join RHHabilidades f
														on e.RHHid = f.RHHid
													inner join RHComportamiento g
														on e.RHHid = g.RHHid
													inner join  RHRespuestas x
														on a.RHERid = x.RHERid
														and g.RHCOid  = x.RHCOid 
														and e.RHIEid  = x.RHIEid
														and x.RHCOid = #RHCOid#
													inner join  RHDGrupoNivel y
														on y.RHDGNid = x.RHDGNid
													where z.RHRSEid = <cfif isdefined("RSUltima.RHRSEid") and len(trim(RSUltima.RHRSEid))>#RSUltima.RHRSEid#<cfelse>-1</cfif>
												</cfquery>
												<cfif RespuestasA.recordCount GT 0>
													<font color="##0000FF">#RespuestasA.RHDGNdescripcion#</font>
												<cfelse>
													&nbsp;
												</cfif>
											</cfif>
										</td>
									</tr>
								</cfloop>							
							<cfelseif isdefined("form.TipoEval") and len(trim(form.TipoEval)) and form.TipoEval eq 'O'>
								<CFSET Combo = "">
								<CFSET Resp = "">
								<CFSET RHIEid = "">
								<tr><td>&nbsp;</td></tr>
								<tr><td colspan="3" style="padding:0; border-bottom: 1px solid black;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate  key="LB_Objetivos">Objetivos</cf_translate></strong></td></tr>
								<tr>
									<td>&nbsp;</td>
									<td><b><cf_translate  key="LB_Actual">Actual</cf_translate></b></td>
									<td><b><cf_translate  key="LB_Anterior">Anterior</cf_translate></b></td>
								</tr>
								<cfloop query="data">
									<CFSET Combo = data.RHGNid>
									<CFSET Resp  = data.RHDGNid>
									<CFSET RHIEid = data.RHIEid>
									<cfif isdefined("RSUltima.RHRSEid") and len(trim(RSUltima.RHRSEid)) >
										<cfquery name="RespuestasA" datasource="#session.DSN#">
											select RHDGNdescripcion,coalesce(a.RHIEestado,0) as RHIEestado
											from RHRERespuestas a 
											inner join RHRespuestas b 
												on  a.RHIEid  = b.RHIEid
												and a.RHERid = b.RHERid 	
												and a.DEid = b.DEid
												and a.DEideval = b.DEideval
											inner join RHDGrupoNivel c
												on b.RHDGNid = c.RHDGNid
											where a.RHRSEid = <cfif isdefined("RSUltima.RHRSEid") and len(trim(RSUltima.RHRSEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#RSUltima.RHRSEid#" ><cfelse>-1</cfif>
											and a.RHIEid  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHIEid#">
											and a.DEid = #data.DEid#
											and a.DEideval = #data.DEideval#
										</cfquery>
										<!--- si el estado de la pregunta de la evaluación anterior es 1 no se evalua en esta. --->
										<cfif isdefined("RespuestasA") and RespuestasA.recordCount EQ 0><!--- no realizo la evaluacion --->
											<tr>
												<td colspan="1"  valign="top">
													<font style="font-family:Times New Roman', Times, serif; font-size:12px"></font>&iquest;&nbsp;#data.RHOStexto#&nbsp;?</td>
												</td>
												<td colspan="1" valign="top">
													<cfquery name="Respuestas" datasource="#session.DSN#">
														select RHDGNid,RHDGNcodigo,RHDGNdescripcion from RHDGrupoNivel
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
														and RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Combo#">
														order by RHDGNpeso
													</cfquery>
													<select name="CMB_#RHIEid#" tabindex="1">
														<option value=""></option>
														<cfloop query="Respuestas">
														  <option value="#Respuestas.RHDGNid#"  <cfif isdefined("Respuestas.RHDGNid") and len(trim(Resp)) and Respuestas.RHDGNid eq Resp> selected </cfif>>
															#Respuestas.RHDGNdescripcion#</option>
														</cfloop>
													</select>	
												</td>
												<td colspan="1" valign="top">&nbsp;
														
												</td>
											</tr>
										<cfelseif isdefined("RespuestasA") and RespuestasA.recordCount gt 0 and RespuestasA.RHIEestado eq 0><!--- realizo la evaluacion pero el estado es cero --->
											<tr>
												<td colspan="1"  valign="top">
													<font style="font-family:Times New Roman', Times, serif; font-size:12px"></font>&iquest;&nbsp;#data.RHOStexto#&nbsp;?</td>
												</td>
												<td colspan="1" valign="top">
													<cfquery name="Respuestas" datasource="#session.DSN#">
														select RHDGNid,RHDGNcodigo,RHDGNdescripcion from RHDGrupoNivel
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
														and RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Combo#">
														order by RHDGNpeso
													</cfquery>
													<select name="CMB_#RHIEid#" tabindex="1">
														<option value=""></option>
														<cfloop query="Respuestas">
														  <option value="#Respuestas.RHDGNid#"  <cfif isdefined("Respuestas.RHDGNid") and len(trim(Resp)) and Respuestas.RHDGNid eq Resp> selected </cfif>>
															#Respuestas.RHDGNdescripcion#</option>
														</cfloop>
													</select>	
												</td>
												<td colspan="1" valign="top">
														<font color="##0000FF">#RespuestasA.RHDGNdescripcion#</font>
												</td>
											</tr>										
										</cfif>
									<cfelse>
										<tr>
											<td colspan="1"  valign="top">
												<font style="font-family:Times New Roman', Times, serif; font-size:12px"></font>&iquest;&nbsp;#data.RHOStexto#&nbsp;?</td>
											</td>
											<td colspan="1" valign="top">
												<cfquery name="Respuestas" datasource="#session.DSN#">
													select RHDGNid,RHDGNcodigo,RHDGNdescripcion from RHDGrupoNivel
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
													and RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Combo#">
													order by RHDGNpeso
												</cfquery>
												<select name="CMB_#RHIEid#" tabindex="1">
													<option value=""></option>
													<cfloop query="Respuestas">
													  <option value="#Respuestas.RHDGNid#"  <cfif isdefined("Respuestas.RHDGNid") and len(trim(Resp)) and Respuestas.RHDGNid eq Resp> selected </cfif>>
														#Respuestas.RHDGNdescripcion#</option>
													</cfloop>
												</select>	
											</td>
											<td colspan="1" valign="top">&nbsp;
												
											</td>
										</tr>
									</cfif>
								</cfloop>							
							</cfif>
						</table>
					</div>
				</td>
			</tr> 
		</table>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Guardar"
			Default="Guardar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Guardar"/>
        <cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar_a_lista"
			Default="Regresar a lista"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Regresar_a_lista"/>		
		<table width="100%" align="center">
			<tr><td align="center">
			   <input  class="btnGuardar" tabindex="1" type="submit" name="guardar" value="#BTN_Guardar#" >
               <input  class="btnLimpiar" tabindex="1" type="button"  name="btn_regresar" value="#BTN_Regresar_a_lista#" onClick="javascript: location.href='evaluar_des-lista.cfm?tipo=#form.tipo#';">
			</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>

	</form>
	</cfoutput>
	
</cfif>