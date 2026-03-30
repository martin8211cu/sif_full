<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ResultadoDeLaEvaluacion"
	Default="Resultado de la Evaluaci&oacute;n"
	returnvariable="LB_ResultadoDeLaEvaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionDelDesempenoPorColaborador"
	Default="Evaluaci&oacute;n del Desempe&ntilde;o por Colaborador"
	returnvariable="LB_EvaluacionDelDesempenoPorColaborador"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluacion"
	Default="Evaluaci&oacute;n"
	returnvariable="LB_Evaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Colaborador"
	Default="Colaborador"
	returnvariable="LB_Colaborador"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidad"
	Default="Habilidad"
	returnvariable="LB_Habilidad"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nivel"
	Default="Nivel"
	returnvariable="LB_Nivel"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NotaMin"
	Default="Nota M&iacute;n."
	returnvariable="LB_NotaMin"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Peso"
	Default="Peso"
	returnvariable="LB_Peso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Autoeval"
	Default="Autoeval."
	returnvariable="LB_Autoeval"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jefatura"
	Default="Jefatura"
	returnvariable="LB_Jefatura"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Otros"
	Default="Otros"
	returnvariable="LB_Otros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_JCS"
	Default="JCS"
	returnvariable="LB_JCS"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PromedioActual"
	Default="Promedio Actual"
	returnvariable="LB_PromedioActual"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PromedioAnterior"
	Default="Promedio Anterior"
	returnvariable="LB_PromedioAnterior"/>


<!--- FIN VARIABLES DE TRADUCCION --->	
<cfif isdefined('url.Formato') and url.formato EQ 'HTML'>
 <cf_htmlreportsheaders
	title="#LB_ResultadoDeLaEvaluacion#" 
	filename="ResultadoEvaluacion.xls" 
	back="no" irA="" close="true" download="no">
</cfif>
	<form name="form1" action="RepResultadoEvaluacion.cfm" method="get">
		<cfoutput>
		<input name="RHEEid" type="hidden" value="<cfif isdefined('url.RHEEid')>#url.RHEEid#</cfif>">
		<input name="DEid" type="hidden" value="<cfif isdefined('url.DEid')>#url.DEid#</cfif>">
		</cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			
			<tr class="noprint">
				<td align="right" >
					<strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong>
					<select name="formato" tabindex="1" onchange="javascript: document.form1.submit();">
						<option value="HTML" <cfif isdefined('formato') and formato EQ 'HTML'>selected</cfif>>HTML</option>
						<option value="FlashPaper" <cfif isdefined('formato') and formato EQ 'FlashPaper'>selected</cfif>>FlashPaper</option>
						<option value="pdf" <cfif isdefined('formato') and formato EQ 'pdf'>selected</cfif>>Adobe PDF</option>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2">
					<!--- SI EL FORMATO ES HTML --->
					<!--- Ultima evaluacion del empleado --->
					<cfquery name="rsUltima"  datasource="#session.DSN#">
						select max(k.RHEEid) as RHEEid
						from RHListaEvalDes k
						
						inner join RHEEvaluacionDes k1
						on k1.RHEEid=k.RHEEid
						and k1.RHEEfhasta <= (select RHEEfhasta 
												from RHEEvaluacionDes 
												where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">)
						and k1.RHEEestado=3
						
						where k.RHEEid!=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
						and k.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
					</cfquery>
					
					<cfset vRHEEid_ultima = 0 >
					<cfif len(trim(rsUltima.RHEEid))>
						<cfset vRHEEid_ultima = rsUltima.RHEEid >
					</cfif>
					
					<!--- <cf_dbtemp name="tmp_reporte" returnvariable="tmp_reporte" datasource="#session.DSN#">
						<cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="yes">
						<cf_dbtempcol name="peso" 		type="float" 	mandatory="yes">
						<cf_dbtempcol name="notaauto" 	type="float" 	mandatory="no">
						<cf_dbtempcol name="notajefe" 	type="float" 	mandatory="no">
						<cf_dbtempcol name="notaotros"	type="float" 	mandatory="no">
						<cf_dbtempcol name="notajcs" 	type="float" 	mandatory="no">
						<cf_dbtempcol name="pesototal" 	type="float" 	mandatory="no">	
					</cf_dbtemp> --->
					
					<cfquery name="insertTemp" datasource="#session.DSN#">
						<!--- insert into ##tmp_reporte(DEid, peso, notaauto, notajefe, notaotros, notajcs, pesototal ) ---> 
						select 		a.DEid,
									c.RHHpeso as peso,
									coalesce(a.RHNEDnotaauto, 0) as notaauto,
									coalesce(a.RHNEDnotajefe, 0) as notajefe, 
									coalesce(a.RHNEDpromotros, 0) as notaotros,
									coalesce(a.RHNEDpromJCS, 0) as notajcs,
									(select sum(RHHpeso)
									 from RHHabilidadesPuesto 
									 where RHPcodigo=c.RHPcodigo
									 and Ecodigo = #session.Ecodigo# ) as pesototal
						from RHNotasEvalDes a
						
						inner join RHListaEvalDes b
						on b.RHEEid=a.RHEEid
						and b.DEid=a.DEid
						and b.Ecodigo= #session.Ecodigo#
						
						inner join RHHabilidadesPuesto c
						on c.RHPcodigo=b.RHPcodigo
						and c.Ecodigo=b.Ecodigo
						and c.RHHid=a.RHHid
						
						inner join RHHabilidades d
						on d.Ecodigo=c.Ecodigo
						and d.RHHid=c.RHHid
						
						where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHEEid_ultima#">
						  and a.RHHid is not null
						  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
					</cfquery>	
					
					
					<cfquery name="rsNotaAnterior"  dbtype="query">
						select 	DEid,
								sum((notaauto * (peso/pesototal))) as notaauto, 
								sum((notajefe * (peso/pesototal))) as notajefe, 
								sum((notaotros * (peso/pesototal))) as notaotros,
								sum((notajcs * (peso/pesototal))) as notajcs
						from insertTemp
						group by DEid
					</cfquery>
					
					
					<cfquery datasource="#session.DSN#" name="rs" >
						select '#session.Enombre#' as empresa,
								f.RHEEdescripcion,
						
									f.RHEEfdesde as inicio,
						
									f.RHEEfhasta as fin,
									{fn concat(rtrim(g.DEidentificacion),{fn concat(' - ',{fn concat(g.DEnombre,{fn concat(' ',{fn concat(g.DEapellido1,{fn concat(' ',g.DEapellido2)})})})})})} as DEidentificacion,
									{fn concat(rtrim(coalesce(e.RHPcodigoext,e.RHPcodigo)),{fn concat(' - ',e.RHPdescpuesto)})} as RHPdescpuesto,
									{fn concat(rtrim(d.RHHcodigo),{fn concat(' - ',d.RHHdescripcion)})}as RHHdescripcion, 
									h.RHNcodigo, 
									(c.RHNnotamin*100) as notamin, 
									c.RHHid,
									c.RHHpeso, 
									b.DEid,
									coalesce(a.RHNEDnotaauto, 0) as autoevaluacion,
									coalesce(a.RHNEDnotajefe, 0) as notajefe, 
									coalesce(a.RHNEDpromotros, 0) as notaotros,
									coalesce(a.RHNEDpromJCS, 0) as notajcs,
									
									<cfif len(trim(rsNotaAnterior.notajefe))>'#rsNotaAnterior.notajefe#'<cfelse>'0'</cfif> as notajefeant,
									<cfif len(trim(rsNotaAnterior.notaauto))>'#rsNotaAnterior.notaauto#'<cfelse>'0'</cfif> as notaautoant,
									<cfif len(trim(rsNotaAnterior.notaotros))>'#rsNotaAnterior.notaotros#'<cfelse>'0'</cfif> as promotrosant,
									<cfif len(trim(rsNotaAnterior.notajcs))>'#rsNotaAnterior.notajcs#'<cfelse>'0'</cfif> as relativo_anterior,
					
					
									coalesce( round((a.RHNEDnotajefe*c.RHHpeso)/100, 4), 0) as pesoobtenido,
									coalesce( round((a.RHNEDpromotros*c.RHHpeso)/100, 4) , 0) as puntos_otros,
									coalesce( round((a.RHNEDpromJCS*c.RHHpeso)/100, 4) , 0) as puntos_jefe_otros,
									case when a.RHNEDpromJCS < (c.RHNnotamin*100) then '*' else '' end as paso,
									(select sum(RHHpeso)
									 from RHHabilidadesPuesto 
									 where RHPcodigo=c.RHPcodigo
									 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> ) as suma_pesos
					
						from RHNotasEvalDes a
						
						inner join RHListaEvalDes b
						on b.RHEEid=a.RHEEid
						and b.DEid=a.DEid
						and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						
						inner join RHHabilidadesPuesto c
						on c.RHPcodigo=b.RHPcodigo
						and c.Ecodigo=b.Ecodigo
						and c.RHHid=a.RHHid
						
						inner join RHHabilidades d
						on d.Ecodigo=c.Ecodigo
						and d.RHHid=c.RHHid
						
						inner join RHPuestos e
						on e.Ecodigo=c.Ecodigo
						and e.RHPcodigo=c.RHPcodigo
						
						inner join RHEEvaluacionDes f
						on f.RHEEid=b.RHEEid
						and f.Ecodigo=b.Ecodigo
						and f.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						
						inner join DatosEmpleado g
						on g.DEid=b.DEid
						and g.Ecodigo=b.Ecodigo
						
						left outer join RHNiveles h
						on h.RHNid=c.RHNid
						and h.Ecodigo=c.Ecodigo
						
						where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
						  and a.RHHid is not null
						  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
						order by g.DEidentificacion	, coalesce((a.RHNEDnotajefe+a.RHNEDpromotros)/2,0) desc 
					</cfquery>
					<cfif isdefined('url.Formato') and url.formato EQ 'HTML'>
						<cfoutput>
							<cfset TotalAutoEvaluacion = 0>
							<cfset TotalJefe = 0>
							<cfset TotalOtros = 0>
							<cfset TotalJCS = 0>
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr bgcolor="E3EDEF"><td colspan="2">&nbsp;</td></tr>
								<tr bgcolor="E3EDEF">
									<td align="center" colspan="2"><font size="4px" style="color:6188A5;">#rs.Empresa#</font></td>
								</tr>
								<tr bgcolor="E3EDEF">
									<td align="center" colspan="2"><font size="4px">#LB_EvaluacionDelDesempenoPorColaborador#</font></td>
								</tr>
								<tr bgcolor="E3EDEF"><td colspan="2">&nbsp;</td></tr>
								<tr><td height="40" colspan="2"><font size="4px">#LB_Evaluacion#:&nbsp;#rs.RHEEdescripcion#</font></td></tr>
								<tr bgcolor="DADADA">
									<font size="4px">
										<td>#LB_Colaborador#:&nbsp;</td>
										<td>#rs.DEidentificacion#</td>
									</font>
								</tr>
								<tr bgcolor="DADADA">
									<font size="3px">
										<td width="5%">#LB_Puesto#:&nbsp;</td>
										<td>#rs.RHPdescpuesto#</td>
									</font>
								</tr>
								<tr>
									<td colspan="2">
										<table width="100%" cellpadding="2" cellspacing="0" border="0">
											<tr bgcolor="E3EDEF">
												<font size="3">
													<td width="40%">#LB_Habilidad#</td>
													<td>#LB_Nivel#</td>
													<td align="right">#LB_NotaMin#</td>
													<td align="right">#LB_Peso#</td>
													<td align="right">#LB_Autoeval#</td>
													<td align="right">#LB_Jefatura#</td>
													<td align="right">#LB_Otros#</td>
													<td align="right">#LB_JCS#</td>
													<td width="1%">&nbsp;</td>
												</font>
											</tr>
											<cfif rs.recordcount gt 0>
											<cfloop query="rs">
												<tr>
													<font size="3">
														<td width="40%">#RHHDescripcion#</td>
														<td align="center" width="5%">#RHNcodigo#</td>
														<td align="right">#LSNumberFormat(NotaMin,'_,___.__')#</td>
														<td align="right">#LSNumberFormat(RHHpeso,'_,___.__')#</td>
														<td align="right">#LSNumberFormat(Autoevaluacion,'_,___.__')#</td>
														<td align="right">#LSNumberFormat(NotaJefe,'_,___.__')#</td>
														<td align="right">#LSNumberFormat(NotaOtros,'_,___.__')#</td>
														<td align="right">#LSNumberFormat(NotaJCS,'_,___.__')#</td>
														<td align="right" width="1%"><font style="color:ff0000">#paso#</span></td>
													</font>
												</tr>
												<cfset TotalAutoEvaluacion = TotalAutoEvaluacion + (autoevaluacion*(RHHpeso/suma_pesos))>
												<cfset TotalJefe = TotalJefe + (NotaJefe*(RHHpeso/suma_pesos))>
												<cfset TotalOtros = TotalOtros + (NotaOtros*(RHHpeso/suma_pesos))>
												<cfset TotalJCS = TotalJCS + (NotaJCS*(RHHpeso/suma_pesos))>
											</cfloop>
											<tr>
												<td height="1" colspan="2"></td>
												<td height="1" bgcolor="999999" colspan="7"></td>
											</tr>
											<tr>
												<td align="right"><strong>#LB_PromedioActual#</strong></td>
												<td colspan="3">&nbsp;</td>
												<td align="right">#round(TotalAutoEvaluacion*100)/100#</td>
												<td align="right">#round(TotalJefe*100)/100#</td>
												<td align="right">#round(TotalOtros*100)/100#</td>
												<td align="right">#round(TotalJCS*100)/100#</td>
											</tr>
											<tr>
											
												<td align="right"><strong>#LB_PromedioAnterior#</strong></td>
												<td colspan="3">&nbsp;</td>
												<td align="right">#round(rs.notaautoant*100)/100#</td>
												<td align="right">#round(rs.notajefeant*100)/100#</td>
												<td align="right">#round(rs.promotrosant*100)/100#</td>
												<td align="right">#round(rs.relativo_anterior*100)/100#</td>
											</tr>
											</cfif>
										</table>
									</td>
								</tr>
							</table>
						</cfoutput>
					<cfelse>
						<iframe id="ReporteP" frameborder="0" name="ReporteP" width="950"  height="600" 
								style="visibility:visible;border:none; vertical-align:top" 
								src="../consultas/evaluacion-colaborador.cfm?RHEEid=<cfoutput>#url.RHEEid#</cfoutput>&DEid=<cfoutput>#url.DEid#</cfoutput>&Formato=<cfoutput>#url.formato#</cfoutput>"></iframe>
					</cfif>
				</td>	
			</tr>
		</table>	
	</form>
<script language="JavaScript" type="text/JavaScript">

	function funcRegresar(){
		window.close();
		return false;
	}
	</script>