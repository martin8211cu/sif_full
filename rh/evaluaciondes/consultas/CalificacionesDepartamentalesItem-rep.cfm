<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="CalificacionesDepartamentalesItem.cfm"
		FileName="CalificacionesDepartamentalesItem.xls"
		title="CalificacionesDepartamentalesItem">

<cfquery name="nam" datasource="#session.dsn#">
	select RHEEdescripcion from RHEEvaluacionDes where RHEEid=#form.RHEEid#
</cfquery>

<cfif isdefined('form.CFid') and len(trim(form.CFid))>
	<cfquery name="rsCF" datasource="#session.dsn#">
		select CFcodigo,CFdescripcion from CFuncional where CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
</cfif>

<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cfinvoke key="Cuestionario" default="<b>Cuestionario</b>" returnvariable="LB_Cuestionario" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_Centro" default="<b>Centro Funcional</b>" returnvariable="LB_Centro" component="sif.Componentes.Translate"  method="Translate"/>
				<cfset filtro1 = LB_Cuestionario&': #nam.RHEEdescripcion#'>
				<cfif isdefined("rsCF") and rsCF.RecordCount gt 0>
					<cfset filtro2 = LB_Centro &':  #ucase(rsCF.CFcodigo)# - #rsCF.CFdescripcion#'>
					<cf_EncReporte
					Titulo="Evaluación de Cuestionarios"
					Color="##E3EDEF"
					filtro1="#filtro1#"
					filtro2="#filtro2#"
					Cols= 11>
				<cfelse>
					<cf_EncReporte
					Titulo="Evaluación de Cuestionarios"
					Color="##E3EDEF"
					filtro1="#filtro1#"
					Cols= 11>
				</cfif>
					
			</td>
		</tr>
	</table>
</cfoutput>
	
	<!---Cuestionarios Estandar--->
	<cfquery name="rsCuestio" datasource="#session.dsn#">
		select PCid from RHEEvaluacionDes where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>	
	
	<cfif rsCuestio.PCid LT 0>				<!--- POR CONOCIMIENTOS --->
		El cuestionario elegido no es estandar, es por Conocimientos <cfabort>
	<cfelseif rsCuestio.PCid EQ -1>			<!--- POR HABILIDADES --->
		El cuestionario elegido no es estandar, es por Habilidades <cfabort>
	<cfelseif rsCuestio.PCid EQ -2>			<!--- POR CONOCIMIENTOS y/o HABILIDADES--->
		El cuestionario elegido no es estandar, es por Habilidades y/o Conocimientos <cfabort>
	</cfif>
	
	<cfquery name="rsPartes" datasource="#session.dsn#">
		select PPparte,PCPdescripcion from PortalCuestionarioParte where PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuestio.PCid#">
	</cfquery>
	
	<cfquery name="rsPuestosDEid" datasource="#session.dsn#">
		select distinct a.RHPcodigo, b.RHPdescpuesto,a.DEid
		from RHListaEvalDes a
		inner join RHPuestos b
			on a.RHPcodigo = b.RHPcodigo
			and a.Ecodigo = b.Ecodigo
		where a.RHEEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		group by a.RHPcodigo, b.RHPdescpuesto,a.DEid
		order by a.RHPcodigo, b.RHPdescpuesto,a.DEid
	</cfquery>
	
<cfoutput>	

	<cfquery name="rsPuestos" dbtype="query">
		select  distinct RHPcodigo, RHPdescpuesto from rsPuestosDEid
	</cfquery>
	
	
	<table width="90%" align="center" cellpadding="0" cellspacing="0" border="0">
	
	<cfloop query="rsPuestos">
		
		<cfquery name="rsDEid" dbtype="query">
			select  distinct DEid from rsPuestosDEid where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPuestos.RHPcodigo#">
		</cfquery>
		
		<cfset rsDEidList= 0>
		<cfif rsDEid.RecordCount GT 0>
			<cfset rsDEidList = valueList(rsDEid.DEid,',')>
		</cfif>
		
		
		<tr><td bgcolor="CCCCCC"><cfoutput><strong>#rsPuestos.RHPdescpuesto#</strong></cfoutput></td></tr>
		<tr><td>
				<table width="100%" align="center">
					<cfset totalF=0>
					<cfset porcentaje=0>
					<cfset calif=0>
						<cfloop query="rsPartes">
									
								<tr>		
									<td colspan="3" bgcolor="F0F0F0">#rsPartes.PCPdescripcion#</td>	
								</tr>
								
								<tr>
									<td width="77%"><strong>Pregunta:</strong></td>
									<td width="77%"><strong>Promedio:</strong></td>
									<td width="77%"><strong>Porcentaje:</strong></td>
								</tr>
								
								<tr>
								<!---Este query selecciona el id de las preguntas por cada parte del curestionario--->
										<cfquery name="rsDet" datasource="#session.dsn#">
											 select p.PPid
											from PortalRespuestaU ru
											inner join PortalPreguntaU pu
												 inner join RHEEvaluacionDes e
													 on e.PCid=e.PCid
													 and e.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
												 inner join PortalCuestionarioU cu
												on cu.PCUid=pu.PCUid
												and cu.PCUreferencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
												and cu.DEid in (<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#rsDEidList#">)
												inner join PortalPregunta p
												on p.PPid=pu.PPid
												and p.PCid=pu.PCid
												and PPparte=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPartes.PPparte#">
												on pu.PCUid=ru.PCUid
											and pu.PCid=ru.PCid
											and pu.PPid=ru.PPid
											where ru.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuestio.PCid#">
											and ru.PCid=pu.PCid
											group by p.PPid
										</cfquery>
										
										<cfif rsDet.RecordCount EQ 0>
											<tr>
												<td width="77%" colspan="3">NOTA: Para este puesto aun no se respondio ninguna pregunta</td>
											</tr>
										</cfif>
										
										<cfloop query="rsDet">
										<!---Trae el valor de la respuesta de acuerdo a la pregunta del query de arriba--->
										<cfquery name="rsDetD" datasource="#session.dsn#">
												<!---select coalesce((ru.PRUvalor*PPvalor/(select max(PRvalor) from PortalRespuesta where PCid=#rsCuestio.PCid# and PPid=p.PPid)),0) as valor,p.PPid--->
												select cu.DEid,coalesce(ru.PRUvalor,0) as total,Coalesce(PPvalor,0)as PPvalor, Coalesce((select max(PRvalor) from PortalRespuesta where PCid=#rsCuestio.PCid# and PPid=p.PPid),0) as valor,p.PPid
												from PortalRespuestaU ru
												inner join PortalPreguntaU pu
													 inner join RHEEvaluacionDes e
													 on e.PCid=e.PCid
													 and e.RHEEid=#form.RHEEid#
												inner join PortalCuestionarioU cu									
													on cu.PCUid=pu.PCUid
													and cu.PCUreferencia=#form.RHEEid#
													and cu.DEid in (<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#rsDEidList#">)
												inner join PortalPregunta p
													on p.PPid=pu.PPid
													and p.PCid=pu.PCid
													and PPparte=#rsPartes.PPparte#
												on pu.PCUid=ru.PCUid
													and pu.PCid=ru.PCid
													and pu.PPid=ru.PPid
												where ru.PCid=#rsCuestio.PCid#
												and ru.PCid=pu.PCid
												--and ru.PRUvalor > -1
												and p.PPid=#rsDet.PPid#
												and cu.DEid in (<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#rsDEidList#">)
												group by cu.DEid,p.PPid,ru.PRUvalor,p.PPvalor
										</cfquery>
										
										<cfif rsDet.recordcount gt 0 >
											
											<cfquery name="rsTotal" dbtype="query"
>
select sum(total) as total from rsDetD
</cfquery>											
											<cfset respuestasTotal = rsTotal.total>
											<cfset valorPregunta = rsDetD.PPvalor>
											<cfset valorOpcionMax = rsDetD.RecordCount * rsDetD.valor>
											<cfif session.usuario EQ 'soinrh5'>
											<cfdump var="#respuestasTotal#"><br />
											<cfdump var="#valorPregunta#"><br />
											<cfdump var="#valorOpcionMax#"><br />
											<cfdump var="#rsDetD#">
											</cfif>
											<cfset promedio =  respuestasTotal * (valorPregunta/valorOpcionMax)>
											<cfset Porcentaje =  (respuestasTotal / valorOpcionMax) * 100>
											<cfquery name="rsPreg" datasource="#session.dsn#">
												select PPpregunta from PortalPregunta where PPid=#rsDet.PPid#
											</cfquery>									
											<tr>
												<td>#rsPreg.PPpregunta#</td>
												<td>#NumberFormat(promedio,",0.00")#</td>
												<td>#NumberFormat(Porcentaje,",0.00")#</td>
											</tr>
										
										</cfif>
									</cfloop>
								</tr>		
						</cfloop>
				</table>
				</td></tr>
			</cfloop>
		</table>
</cfoutput>

	
	
	
	
	
	
