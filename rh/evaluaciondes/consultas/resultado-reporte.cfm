<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="resultado.cfm"
		FileName="ResultadoEvaluacion.xls"
		title="ResultadoEvaluacion">
		
	<cfoutput>
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinvoke key="LB_CentroFuncional" default="<b>Centro Funcional</b>" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_Empleado" default="<b>Colaborador</b>" returnvariable="LB_Empleado" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro1 = LB_CentroFuncional&': #ucase(form.CFid)# - #Form.CFdescripcion#'>
					<cfset filtro2 = LB_Empleado&': #ucase(Form.DEidentificacion)# - #Form.NombreEmp#'>
						<cf_EncReporte
						Titulo="Resultado de Evaluación"
						Color="##E3EDEF"
						filtro1="#filtro1#"
						filtro2="#filtro2#"
						Cols= 11>
				</td>
			</tr>
		</table>
	</cfoutput>

	<cfquery name="rsCF" datasource="#session.dsn#">
		select Pvalor from RHParametros where Ecodigo=#session.Ecodigo# 
		and Pcodigo=2107
	</cfquery>
	
	<cfquery name="rsParam" datasource="#session.dsn#">
		select Pvalor from RHParametros where Ecodigo=#session.Ecodigo#
		and Pcodigo='2106'
	</cfquery>
<!---Reporte Detallado--->
<cfif isdefined('form.radio1') and form.radio1 eq 0>
	
	<!---En este primer query obtengo los CF de acuerdo a los parametros definidos, esto porque los cortes son por centro funcional--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select b.CFid,cf.CFdescripcion
		from RHListaEvalDes a 
		inner join RHEEvaluacionDes b 
			on a.Ecodigo=b.Ecodigo 
			and a.RHEEid=b.RHEEid 
			and ( b.RHEEestado=3) 
			and b.PCid <= 0 	
		inner join RHPuestos c 
			on a.RHPcodigo=c.RHPcodigo 
			and a.Ecodigo=c.Ecodigo 	
		<!---Valido por cual centro funcional se tiene que ir--->
		<cfif rsCF.Pvalor eq 0>
			inner join LineaTiempo l
				inner join RHPlazas p
					inner join CFuncional cf
					on cf.CFid=p.CFid
				 on l.RHPid=p.RHPid
				 and p.CFid=#form.CFid#
			on l.DEid=a.DEid
			and b.RHEEfhasta betwen LThasta and LTdesde
		<cfelse>
			inner join CFuncional cf
			on cf.CFid=b.CFid
		</cfif>	
		inner join DatosEmpleado de
		on de.DEid=a.DEid
			where  1=1
			<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
			and a.DEid= #form.DEid#
			</cfif>
			and a.Ecodigo=#session.Ecodigo#
			<cfif rsCF.Pvalor eq 1>
				<cfif isdefined ('form.CFid') and len(trim(form.CFid)) gt 0>
					and b.CFid=#form.CFid#
				</cfif>
			</cfif>
			<cfif isdefined ('form.fecha1') and len(trim(form.fecha1)) gt 0>
				and RHEEfdesde>= '#LSDateFormat(form.fecha1,'MM/DD/YYYY')#'
			</cfif>
			<cfif isdefined ('form.fecha2') and len(trim(form.fecha2)) gt 0>
				and RHEEfdesde<='#LSDateFormat(form.fecha2,'MM/DD/YYYY')#'
			</cfif>	
			group by b.CFid,cf.CFdescripcion
	</cfquery>
		
	<table width="100%">
		<cfloop query="rsSQL">
			<tr bgcolor="def1f5">
				<td colspan="4">
					<strong>Centro Funcional:</strong><cfoutput>#rsSQL.CFdescripcion#</cfoutput>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
				<!---En este primer query obtengo los los empleados asociados al CF definido arriba, esto xq es nota global y si el empleado esta en 5 relaciones en el mismo CF debe aparecer solamente una vez--->
				<cfquery name="rsSQL1" datasource="#session.dsn#">
					select b.CFid,cf.CFdescripcion,de.DEidentificacion,de.DEid,
					de.DEnombre #LvarCNCT#' '#LvarCNCT#de.DEapellido1#LvarCNCT#' '#LvarCNCT#de.DEapellido2 as nombre	,
					<cf_dbfunction name="date_part"	args="YYYY,RHEEfdesde"> as fecha
					from RHListaEvalDes a 
					inner join RHEEvaluacionDes b 
						on a.Ecodigo=b.Ecodigo 
						and a.RHEEid=b.RHEEid 
						and ( b.RHEEestado=3) 
						and b.PCid <= 0 	
					inner join RHPuestos c 
						on a.RHPcodigo=c.RHPcodigo 
						and a.Ecodigo=c.Ecodigo 				
					<!---Valido por cual centro funcional se tiene que ir--->
					<cfif rsCF.Pvalor eq 0>
						inner join LineaTiempo l
							inner join RHPlazas p
								inner join CFuncional cf
								on cf.CFid=p.CFid
							 on l.RHPid=p.RHPid
							 and p.CFid=#rsSQL.CFid#
						on l.DEid=a.DEid
						and b.RHEEfhasta betwen LThasta and LTdesde
					<cfelse>
						inner join CFuncional cf
						on cf.CFid=b.CFid
					</cfif>
					
					inner join DatosEmpleado de
					on de.DEid=a.DEid
						where  1=1
						<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
						and a.DEid= #form.DEid#
						</cfif>
						and a.Ecodigo=#session.Ecodigo#
						<cfif rsCF.Pvalor eq 1>
							<cfif isdefined ('rsSQL.CFid') and len(trim(rsSQL.CFid)) gt 0>
								and b.CFid=#rsSQL.CFid#
							</cfif>
						</cfif>
						<cfif isdefined ('form.fecha1') and len(trim(form.fecha1)) gt 0>
							and RHEEfdesde>= '#LSDateFormat(form.fecha1,'MM/DD/YYYY')#'
						</cfif>
						<cfif isdefined ('form.fecha2') and len(trim(form.fecha2)) gt 0>
							and RHEEfdesde<='#LSDateFormat(form.fecha2,'MM/DD/YYYY')#'
						</cfif>
						group by de.DEid,b.CFid,cf.CFdescripcion,de.DEidentificacion,de.DEnombre,de.DEapellido1,de.DEapellido2,<cf_dbfunction name="date_part"	args="YYYY,RHEEfdesde">
				</cfquery>
				<tr>
					<td><strong>Cedula</strong></td>
					<td><strong>Nombre</strong></td>
					<td><strong>Promedio</strong></td>
				</tr>
				<cfset LvarGloT=0>
				<cfset LvarTotal=0>
				<cfoutput>
					<cfloop query="rsSQL1">
						<!---Saco las notas por todos los empleados--->
						<cfquery name="rsSQL2" datasource="#session.dsn#">
							select Porc_dist,coalesce(RHNEDnotajefe,0) as RHLEnotajefe,coalesce(RHNEDpromotros,0) as RHLEpromotros,RHEEfdesde						
							from RHListaEvalDes a 
							
							inner join RHNotasEvalDes z
							on a.RHEEid=z.RHEEid
							and a.DEid=z.DEid
							
							inner join RHEEvaluacionDes b 
								on a.Ecodigo=b.Ecodigo 
								and a.RHEEid=b.RHEEid 
								and ( b.RHEEestado=3) 
								and b.PCid <= 0 	
							inner join RHPuestos c 
								on a.RHPcodigo=c.RHPcodigo 
								and a.Ecodigo=c.Ecodigo 
							
							<!---Valido por cual centro funcional se tiene que ir--->
							<cfif rsCF.Pvalor eq 0>
								inner join LineaTiempo l
									inner join RHPlazas p
										inner join CFuncional cf
										on cf.CFid=p.CFid
									 on l.RHPid=p.RHPid
									 and p.CFid=#rsSQL.CFid#
									 and l.DEid=#rsSQL1.DEid#
								on l.DEid=a.DEid
								and b.RHEEfhasta betwen LThasta and LTdesde
							<cfelse>
								inner join CFuncional cf
								on cf.CFid=b.CFid
							</cfif>
							
							inner join DatosEmpleado de
							on de.DEid=a.DEid
								where  1=1						
								and a.DEid= #rsSQL1.DEid#
								and a.Ecodigo=#session.Ecodigo#
								<cfif rsCF.Pvalor eq 1>
									<cfif isdefined ('rsSQL.CFid') and len(trim(rsSQL.CFid)) gt 0>
										and b.CFid=#rsSQL.CFid#
									</cfif>
								</cfif>
								<cfif isdefined ('form.fecha1') and len(trim(form.fecha1)) gt 0>
									and RHEEfdesde>= '#LSDateFormat(form.fecha1,'MM/DD/YYYY')#'
								</cfif>
								<cfif isdefined ('form.fecha2') and len(trim(form.fecha2)) gt 0>
									and RHEEfdesde<='#LSDateFormat(form.fecha2,'MM/DD/YYYY')#'
								</cfif>
						</cfquery>
	
							<cfset LvarGlo=0>
							
							<cfloop query="rsSQL2">
								<cfset LvarPorcJ=#rsSQL2.Porc_dist#>
								<cfset LvarPorcO=100-LvarPorcJ>
								<cfset LvarGlobalJ=#rsSQL2.RHLEnotajefe#*#LvarPorcJ#/100>
								<cfset LvarGlobalO=#rsSQL2.RHLEpromotros#*#LvarPorcO#/100>
								<cfset LvarGlobalt=LvarGlobalJ+LvarGlobalO>	
								<cfset LvarGlo=LvarGlo+LvarGlobalt>							
							</cfloop>
								<tr>
									<td>#rsSQL1.DEidentificacion#</td>
									<td>#rsSQL1.nombre#</td>
								<cfif rsParam.Pvalor eq 1>
									<td align="center"><cfif len(trim(LvarGlo))>#LSNumberFormat(LvarGlo,',9.00')#<cfelse>-</cfif></td>
								<cfelse>
									<td align="center">-</td>
								</cfif>
								</tr>
								<cfset LvarGloT=LvarGloT+LvarGlo>
								<cfset LvarTotal=LvarTotal+1>
							
					</cfloop>
					<tr bgcolor="CCCCCC">
						<td colspan="4" align="right">
							<cfset LvarGnral=LvarGloT/LvarTotal>
							<strong>Total:</strong>#LSNumberFormat(LvarGnral,',9.00')#
						</td>
					</tr>
				</cfoutput>
				<tr><td>&nbsp;</td></tr>
		</cfloop>
	</table>
<!---Reporte Resumido--->
<cfelse>
	<cfquery name="rsSQL1" datasource="#session.dsn#">
		select de.DEidentificacion,de.DEid,
		de.DEnombre #LvarCNCT#' '#LvarCNCT#de.DEapellido1#LvarCNCT#' '#LvarCNCT#de.DEapellido2 as nombre	,
		<cf_dbfunction name="date_part"	args="YYYY,RHEEfdesde"> as fecha
		from RHListaEvalDes a 
		inner join RHEEvaluacionDes b 
			on a.Ecodigo=b.Ecodigo 
			and a.RHEEid=b.RHEEid 
			and ( b.RHEEestado=3) 
			and b.PCid <= 0 	
		inner join RHPuestos c 
			on a.RHPcodigo=c.RHPcodigo 
			and a.Ecodigo=c.Ecodigo 				
		<!---Valido por cual centro funcional se tiene que ir--->
		<cfif rsCF.Pvalor eq 0>
			inner join LineaTiempo l
				inner join RHPlazas p
					inner join CFuncional cf
					on cf.CFid=p.CFid
				 on l.RHPid=p.RHPid
				 and p.CFid=#rsSQL.CFid#
			on l.DEid=a.DEid
			and b.RHEEfhasta betwen LThasta and LTdesde
		<cfelse>
			inner join CFuncional cf
			on cf.CFid=b.CFid
		</cfif>
		
		inner join DatosEmpleado de
		on de.DEid=a.DEid
			where  1=1
			<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
			and a.DEid= #form.DEid#
			</cfif>
			and a.Ecodigo=#session.Ecodigo#
			<cfif rsCF.Pvalor eq 1>
				<cfif isdefined ('form.CFid') and len(trim(form.CFid)) gt 0>
					and b.CFid=#form.CFid#
				</cfif>
			</cfif>
			<cfif isdefined ('form.fecha1') and len(trim(form.fecha1)) gt 0>
				and RHEEfdesde>= '#LSDateFormat(form.fecha1,'MM/DD/YYYY')#'
			</cfif>
			<cfif isdefined ('form.fecha2') and len(trim(form.fecha2)) gt 0>
				and RHEEfdesde<='#LSDateFormat(form.fecha2,'MM/DD/YYYY')#'
			</cfif>
			group by de.DEid,de.DEidentificacion,de.DEnombre,de.DEapellido1,de.DEapellido2,<cf_dbfunction name="date_part"	args="YYYY,RHEEfdesde">
	</cfquery>
<cfoutput>
	<table width="100%">
			<cfloop query="rsSQL1">
				<tr bgcolor="CCCCCC"><td colspan="2"><strong>#rsSQL1.nombre#</strong></td></tr>
				<cfquery name="rsSQL2" datasource="#session.dsn#">
						select Porc_dist,coalesce(RHLEnotajefe,0) as RHLEnotajefe,coalesce(RHLEpromotros,0) as RHLEpromotros,RHEEfdesde						
						from RHListaEvalDes a 
						inner join RHEEvaluacionDes b 
							on a.Ecodigo=b.Ecodigo 
							and a.RHEEid=b.RHEEid 
							and ( b.RHEEestado=3) 
							and b.PCid <= 0 	
						inner join RHPuestos c 
							on a.RHPcodigo=c.RHPcodigo 
							and a.Ecodigo=c.Ecodigo 
						
						<!---Valido por cual centro funcional se tiene que ir--->
						<cfif rsCF.Pvalor eq 0>
							inner join LineaTiempo l
								inner join RHPlazas p
									inner join CFuncional cf
									on cf.CFid=p.CFid
								 on l.RHPid=p.RHPid
								 and p.CFid=#rsSQL.CFid#
								 and l.DEid=#rsSQL1.DEid#
							on l.DEid=a.DEid
							and b.RHEEfhasta betwen LThasta and LTdesde
						<cfelse>
							inner join CFuncional cf
							on cf.CFid=b.CFid
						</cfif>
						
						inner join DatosEmpleado de
						on de.DEid=a.DEid
							where  1=1						
							and a.DEid= #rsSQL1.DEid#
							and a.Ecodigo=#session.Ecodigo#
							<cfif rsCF.Pvalor eq 1>
								<cfif isdefined ('rsSQL.CFid') and len(trim(rsSQL.CFid)) gt 0>
									and b.CFid=#rsSQL.CFid#
								</cfif>
							</cfif>
							<cfif isdefined ('form.fecha1') and len(trim(form.fecha1)) gt 0>
								and RHEEfdesde>= '#LSDateFormat(form.fecha1,'MM/DD/YYYY')#'
							</cfif>
							<cfif isdefined ('form.fecha2') and len(trim(form.fecha2)) gt 0>
								and RHEEfdesde<='#LSDateFormat(form.fecha2,'MM/DD/YYYY')#'
							</cfif>
								and <cf_dbfunction name="date_part"	args="YYYY,RHEEfdesde">=#rsSQL1.fecha#
					</cfquery>
					<cfset LvarGlo=0>
					<tr>
						<td>Año</td>
						<td>Promedio</td>
					</tr>
					<cfloop query="rsSQL2">
						<cfset LvarPorcJ=#rsSQL2.Porc_dist#>
						<cfset LvarPorcO=100-LvarPorcJ>
						<cfset LvarGlobalJ=#rsSQL2.RHLEnotajefe#*#LvarPorcJ#/100>
						<cfset LvarGlobalO=#rsSQL2.RHLEpromotros#*#LvarPorcO#/100>
						<cfset LvarGlobalt=LvarGlobalJ+LvarGlobalO>	
						<cfset LvarGlo=LvarGlo+LvarGlobalt>					
					</cfloop>
				<tr>
					<td>#rsSQL1.fecha#</td>
					<td>#LvarGlo#</td>
				</tr>	
				<tr><td>&nbsp;</td></tr>
			</cfloop>
	</table>
</cfoutput>
</cfif>