<cfquery name="rsDatAl" datasource="#Session.DSN#">
	Select Apersona,(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as nombreAl,Pid
	from Alumno
	where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>

<cfif isdefined('rsDatAl') and rsDatAl.recordCount GT 0>
	<cfquery name="rsNotas" datasource="#Session.DSN#">
		Select CtipoCalificacion
			, CpuntosMax
			, CunidadMin
			, Credondeo
			, c.TEcodigo
			, cce.CEcodigo
			, CEnombre
			, CCEporcentaje
			, cev.CEVcodigo
			, CEVnombre + case when CEVtipoCalificacion = '2' then ' ('+convert(varchar,CEVpuntosMax)+' pts)' end as CEVnombre
			, CEVpeso
			, CAEnota
			, CAEporcentaje
		from CursoConceptoEvaluacion cce
			, ConceptoEvaluacion ce
			, CursoEvaluacion cev
			, CursoAlumnoEvaluacion cae
			, Curso c
		where cce.Ccodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
			and Apersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatAl.Apersona#">
			and ce.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
--			and CEVestado = 2
			and cce.CEcodigo=ce.CEcodigo
			and cce.PEcodigo=cev.PEcodigo
			and cce.Ccodigo=cev.Ccodigo
			and cce.CEcodigo=cev.CEcodigo
			and cev.Ccodigo=cae.Ccodigo
			and cev.PEcodigo=cae.PEcodigo
			and cev.CEVcodigo=cae.CEVcodigo
			and ce.Ecodigo=c.Ecodigo
			and cae.PEcodigo=c.PEcodigo
			and cae.Ccodigo = c.Ccodigo			
		order by CEorden,CCEorden
	</cfquery>
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2"><strong><font size="2">Alumno:</font></strong><font size="2"> #rsDatAl.nombreAl# (#rsDatAl.Pid#)</font></td>
	  </tr>
	  <tr>
		<td width="58%"><hr></td>
		<td width="39%">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="2">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="18%">&nbsp;</td>
		    <td width="17%" align="center" nowrap bgcolor="##DBDBDB"><strong>% Concepto</strong></td>
		    <td width="17%" align="center" nowrap bgcolor="##DBDBDB"><strong>Nota</strong></td>
		    <td width="18%" align="center" nowrap bgcolor="##DBDBDB"><strong>&nbsp;&nbsp;Peso %&nbsp;&nbsp;</strong></td>
		    <td width="18%" align="center" nowrap bgcolor="##DBDBDB"><strong>&nbsp;&nbsp;Evaluado %&nbsp;&nbsp;</strong></td>
		    <td width="15%" align="center" nowrap bgcolor="##DBDBDB"><strong>Ganado %</strong></td>
		    <td width="14%" align="center" nowrap bgcolor="##DBDBDB"><strong>&nbsp;&nbsp;Progreso
		        %</strong></td>
	      </tr>
		  
		  <cfif isdefined('rsNotas') and rsNotas.recordCount GT 0>
				<cfset tipoCalif = rsNotas.CtipoCalificacion>
				<cfset varCPorcenConc = rsNotas.CCEporcentaje>				
				<cfset varConcepto = "">
				<cfset varCursoEval = "">
				<cfset totalProgrCurso = 0>	
				<cfset totalAporte = 0>
				<cfset totalGanado = 0>
				<cfset totalGeneral = 0>
				<cfset totalConceptos = 0>
				
				<cfset totAporte = 0>
				<cfset totPeso = 0>
				<cfset totGanado = 0>
				<cfset nombreConc = "">				
				
			  <cfloop query="rsNotas">
			  	<cfif varConcepto NEQ rsNotas.CEcodigo>	
					<cfif totAporte NEQ 0 and totPeso NEQ 0 and totGanado NEQ 0>
						<cfset totalGeneral = totalGeneral + (((totGanado / totAporte) * 100) * varCPorcenConc)>					
						<tr bgcolor="##D9DDBD">
							<td nowrap >&nbsp;&nbsp;<strong>Progreso #nombreConc#</strong></td>
							<td align="center" nowrap>&nbsp;</td>
							<td align="center" nowrap>&nbsp;&nbsp;</td>
							<td align="center" nowrap>&nbsp;&nbsp;<strong>#round(totPeso * 100) / 100#</strong></td>
							<td align="center" nowrap>&nbsp;&nbsp;<strong>#round(totAporte * 100) / 100#</strong></td>
							<td align="center" nowrap>&nbsp;&nbsp;<strong>#round(totGanado * 100) / 100#</strong></td>
							<td align="center" nowrap>&nbsp;&nbsp;<strong>#round(((totGanado / totAporte) * 100) * 100) / 100#</strong></td>			
						</tr>					
						<tr><td>&nbsp;</td></tr>
						<cfset varCPorcenConc = rsNotas.CCEporcentaje>
					</cfif>
					<cfset totalConceptos = totalConceptos + rsNotas.CCEporcentaje>
					<cfset totalAporte = totalAporte + totAporte>
					<cfset totalGanado = totalGanado + totGanado>					
					
					<cfset totAporte = 0>
					<cfset totGanado = 0>
					<cfset totPeso = 0>					
					<cfset nombreConc = rsNotas.CEnombre>
					<cfset varConcepto = rsNotas.CEcodigo>				
					<tr bgcolor="##C0D1E4">
						<td nowrap style="font-size:12px; font-weight:bold">
							Concepto: &nbsp;&nbsp;#rsNotas.CEnombre#                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           									
						</td>
					    <td><strong>&nbsp;&nbsp;#rsNotas.CCEporcentaje#</strong></td>
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>
					</tr>
				</cfif>
				
			  	<cfif varCursoEval NEQ rsNotas.CEVcodigo>
					<cfset varCursoEval = rsNotas.CEVcodigo>
					<cfset varAporte = 0>
					<cfset varGanado = 0>
					<tr>
						<td nowrap>&nbsp;&nbsp;#rsNotas.CEVnombre#</td>
						<td nowrap align="center">&nbsp;</td>
						<td nowrap align="center">&nbsp;&nbsp;#rsNotas.CAEnota#</td>
						<td nowrap align="center">&nbsp;&nbsp;#rsNotas.CEVpeso#</td>
						<cfset totPeso = totPeso + rsNotas.CEVpeso>
						<cfset varAporte = (rsNotas.CCEporcentaje * rsNotas.CEVpeso) / 100>
						<td nowrap align="center">&nbsp;&nbsp;#varAporte#</td>
						<cfset varGanado = (rsNotas.CAEporcentaje * varAporte)>
						<td nowrap align="center">#round(varGanado * 100) / 100#</td>
						<cfset totGanado = totGanado + varGanado>
						<cfset totAporte = totAporte + varAporte>
						<td nowrap align="center">&nbsp;</td>
					</tr>					
				</cfif>				
			  </cfloop>
				<cfif totAporte NEQ 0 and totPeso NEQ 0 and totGanado NEQ 0>
					<cfset totalAporte = totalAporte + totAporte>
					<cfset totalGanado = totalGanado + totGanado>				
					<cfset totalGeneral = totalGeneral + (((totGanado / totAporte) * 100) * varCPorcenConc)>			

					<tr bgcolor="##D9DDBD">
						<td nowrap ><strong>&nbsp;&nbsp;Progreso #nombreConc#</strong></td>
						<td nowrap align="center">&nbsp;</td>
						<td nowrap align="center">&nbsp;&nbsp;</td>
						<td nowrap align="center">&nbsp;&nbsp;<strong>#round(totPeso * 100) / 100#</strong></td>
						<td nowrap align="center">&nbsp;&nbsp;<strong>#round(totAporte * 100) / 100#</strong></td>
						<td nowrap align="center">&nbsp;&nbsp;<strong>#round(totGanado * 100) / 100#</strong></td>
						<td nowrap align="center">&nbsp;&nbsp;<strong>#round(((totGanado / totAporte) * 100) * 100) / 100#</strong></td>			
					</tr>	
				</cfif>
				
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>		  
			  <tr bgcolor="##DCD1C0">
				<td><strong>Totales</strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="center"><font size="2"><strong>#round(totalAporte * 100) / 100#</strong></font></td>
				<td align="center"><font size="2"><strong>#round(totalGanado * 100) / 100#</strong></font></td>
				<td align="center"> <font size="2"><strong>#round(((totalGanado / totalAporte) * 100) * 100) / 100#</strong></font>			</td>
			  </tr>							  
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>			  
			  </tr>
			<cfif tipoCalif EQ 1>		<!--- Porcentaje --->
				<cfset notaProgr = 0>
 				<cfset notaProgr = round((totalGeneral / totalConceptos) * 100) / 100>

				<tr bgcolor="##DCD1C0">
					<td colspan="5"><font size="3"><strong>NOTA DE PROGRESO</strong></font></td>
					<td align="center">&nbsp;</td>
					<td align="center"> <font size="3"><strong>#notaProgr#%</strong></font></td>
				</tr>
			<cfelseif tipoCalif EQ 2>	<!--- Redondeo --->
				<cfset notaProgr = 0>
				<cfset notaProgr = ((totalGeneral / totalConceptos / rsNotas.CpuntosMax / rsNotas.CunidadMin) + rsNotas.Credondeo ) * rsNotas.CunidadMin>
			
				<tr bgcolor="##DCD1C0">
					<td colspan="5"><font size="3"><strong>NOTA DE PROGRESO</strong></font></td>
					<td align="center">&nbsp;</td>
					<td align="center"> <font size="3"><strong>#round(notaProgr * 100) / 100#%</strong></font>	</td>
				</tr>			
			<cfelseif tipoCalif EQ 3>	<!--- Por Simbologia --->						
				<cfquery name="rsNotaProg" datasource="#Session.DSN#">
					select TEVvalor
					from TablaEvaluacionValor
					where TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNotas.TEcodigo#">
						and 
							<cfqueryparam cfsqltype="cf_sql_float" value="#(totalGeneral / totalConceptos)#"> 
								BETWEEN TEVminimo and TEVmaximo
				</cfquery>

				<cfif isdefined('rsNotaProg') and rsNotaProg.recordCount GT 0>
					<tr bgcolor="##DCD1C0">
						<td colspan="5"><font size="3"><strong>NOTA DE PROGRESO</strong></font></td>
						<td align="center">&nbsp;</td>
						<td align="center"> <font size="3"><strong>#rsNotaProg.TEVvalor#</strong></font>	</td>
					</tr>
				</cfif>
			</cfif>			  
		  </cfif>
	    </table>
		</td>
	  </tr>
	</table>
</cfoutput>