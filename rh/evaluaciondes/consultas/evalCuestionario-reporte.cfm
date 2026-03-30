<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="evalCuestionario.cfm"
		FileName="Evaluacion.xls"
		title="evalCuestionario">

<cfquery name="nam" datasource="#session.dsn#">
	select RHEEdescripcion from RHEEvaluacionDes where RHEEid=#form.RHEEid#
</cfquery>
<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cfinvoke key="Cuestionario" default="<b>Cuestionario</b>" returnvariable="LB_Cuestionario" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="LB_Empleado" default="<b>Colaborador</b>" returnvariable="LB_Empleado" component="sif.Componentes.Translate"  method="Translate"/>
				<cfset filtro1 = LB_Cuestionario&': #nam.RHEEdescripcion#'>
				<cfset filtro2 = LB_Empleado&':  #ucase(Form.DEidentificacion)# - #Form.NombreEmp#'>
					<cf_EncReporte
					Titulo="Evaluación de Cuestionarios"
					Color="##E3EDEF"
					filtro1="#filtro1#"
					filtro2="#filtro2#"
					Cols= 11>
			</td>
		</tr>
	</table>
</cfoutput>
<!---                                            Reporte Resumido                                                    --->
<cfif form.radio1 eq 0>
	<cfquery name="rsCuestio" datasource="#session.dsn#">
		select PCid from RHEEvaluacionDes where RHEEid=#form.RHEEid#
	</cfquery>
	
	
	<cfquery name="rsPartes" datasource="#session.dsn#">
		select PPparte,PCPdescripcion from PortalCuestionarioParte where PCid=#rsCuestio.PCid#
	</cfquery>


<table width="70%" align="center">
	<tr>
		<td width="77%"><strong>Encabezado:</strong></td>
		<td width="23%"><strong>Porcentaje:</strong></td>
	</tr>
<cfset Porcentaje_partes_total=0>
<cfset Partes=0>
<cfloop query="rsPartes">		
	<tr>
		<td><cfoutput>#rsPartes.PCPdescripcion#</cfoutput></td>
			
		<cfquery name="rsDet" datasource="#session.dsn#">							
			select  (ru.PRUvalor*PPvalor/(select max(PRvalor) from PortalRespuesta where PCid=#rsCuestio.PCid# and PPid=p.PPid)) as valor,PRUvalor,PPvalor,cu.DEid,
			p.PPid
			from PortalRespuestaU ru 
			inner join PortalPreguntaU pu 
			inner join PortalCuestionarioU cu
			on cu.PCUid=pu.PCUid
			and cu.DEid in (select DEid from RHEvaluadoresDes where RHEEid=#form.RHEEid# )
			and cu.PCUreferencia=#form.RHEEid#
			inner join PortalPregunta p 
			on p.PPid=pu.PPid 
			and p.PCid=pu.PCid 
			and PPparte=#rsPartes.PPparte#
			on pu.PCUid=ru.PCUid 
			and pu.PCid=ru.PCid 
			and pu.PPid=ru.PPid 
			where ru.PCid=#rsCuestio.PCid# 
			and ru.PRUvalor > -1
			--group by PRUvalor,PPvalor,p.PPid
		</cfquery>	
		
		<cfquery name="Eval" datasource="#session.dsn#">
			select count(1) cantidad from RHEvaluadoresDes where RHEEid=#form.RHEEid#
		</cfquery> 


		<cfset Porcentaje_total_parte=0>
		
		<cfif rsDet.recordcount gt 0 and len(trim(rsDet.valor)) gt 0>
			<cfset Partes=Partes+1>
			<cfoutput query="rsDet" group="DEid">		
				<cfquery name="rsDetD" datasource="#session.dsn#">							
					select  sum(PRUvalor) as obtenido
					from PortalRespuestaU ru 
					inner join PortalPreguntaU pu 
						inner join PortalCuestionarioU cu
						on cu.PCUid=pu.PCUid
						and cu.DEid in (#rsDet.DEid#  )
						and cu.PCUreferencia=#form.RHEEid#
						
						inner join PortalPregunta p 
						on p.PPid=pu.PPid 
						and p.PCid=pu.PCid 
						and PPparte=#rsPartes.PPparte#
					on pu.PCUid=ru.PCUid 
					and pu.PCid=ru.PCid 
					and pu.PPid=ru.PPid 
					
					where ru.PCid=#rsCuestio.PCid# 
					and ru.PRUvalor > -1
					--group by PRUvalor,PPvalor,p.PPid
				</cfquery>	

				<cfquery name="rsVal" datasource="#session.dsn#">
					select sum(PPvalor) valor 
					from PortalPregunta 
					where PCid=#rsCuestio.PCid#
					and PPparte=#rsPartes.PPparte#
					and PPid in (select ru.PPid 
								from PortalRespuestaU  ru
								inner join PortalPreguntaU pu 
								inner join PortalCuestionarioU cu
								on cu.PCUid=pu.PCUid
								and cu.DEid in (#rsDet.DEid# )
								and cu.PCUreferencia=#form.RHEEid#
								inner join PortalPregunta p 
								on p.PPid=pu.PPid 
								and p.PCid=pu.PCid 
								and PPparte=#rsPartes.PPparte#
								on pu.PCUid=ru.PCUid 
								and pu.PCid=ru.PCid 
								and pu.PPid=ru.PPid 
								where ru.PCid=#rsCuestio.PCid# 
								and ru.PRUvalor > -1 )
				</cfquery>

				<cfset Porcentaje_Unitario= rsDetD.obtenido*100/rsVal.valor>				
				<cfset Porcentaje_total_parte=Porcentaje_total_parte+Porcentaje_Unitario/Eval.cantidad>
				
			</cfoutput>	
		<td align="left"><cfoutput>#NumberFormat(Porcentaje_total_parte,",0.00")#</cfoutput></td>		
		<cfelse>
			<td align="left">-</td>				
		</cfif>		
	</tr>		
	<cfset Porcentaje_partes_total=Porcentaje_partes_total+Porcentaje_total_parte>


</cfloop>

	<tr><td colspan="2"><hr /></td></tr>
	<tr>
		<td>Promedio</td>
	<cfif isdefined('Porcentaje_partes_total') and Porcentaje_partes_total gt 0>
		<td><cfoutput>#NumberFormat((Porcentaje_partes_total/Partes),",0.00")#</cfoutput></td>
		<cfelse>
		<td>&nbsp;</td>
	</cfif>
	</tr>
	</table>

</cfif>

<!---                                            Reporte Detallado                                                    --->
<cfif form.radio1 eq 1>
	<cfif not isdefined('form.DEid') or len(trim(form.DEid)) eq 0>
		<cfthrow message="Debe de seleccionar un empleado">
	</cfif>
	<cfquery name="rsCuestio" datasource="#session.dsn#">
		select PCid from RHEEvaluacionDes where RHEEid=#form.RHEEid#
	</cfquery>	
	
	<cfquery name="rsPartes" datasource="#session.dsn#">
		select PPparte,PCPdescripcion from PortalCuestionarioParte where PCid=#rsCuestio.PCid#
	</cfquery>
	
<cfoutput>	
<table width="70%" align="center">
	<cfset totalF=0>
	<cfset porcentaje=0>
	<cfset calif=0>
	<tr>
		<td width="77%"><strong>Encabezado:</strong></td>
		<td width="77%"><strong>Puntaje:</strong></td>
		<!---<td width="77%"><strong>Puntaje total:</strong></td> no borrar--->
		<td width="77%"><strong>Calificacion:</strong></td>
		<!---<td width="23%"><strong>Porcentaje:</strong></td> no borrar--->
	</tr>
		<cfloop query="rsPartes">
					
				<tr>		
					<td colspan="3" bgcolor="CCCCCC">#rsPartes.PCPdescripcion#</td>	
				</tr>
				<tr>
				<!---Este query selecciona el id de las preguntas por cada parte del curestionario--->
						<cfquery name="rsDet" datasource="#session.dsn#">
							 select p.PPid
							from PortalRespuestaU ru
							inner join PortalPreguntaU pu
								 inner join RHEEvaluacionDes e
									 on e.PCid=e.PCid
									 and e.RHEEid=#form.RHEEid#
								 inner join PortalCuestionarioU cu
								on cu.PCUid=pu.PCUid
								and cu.PCUreferencia=#form.RHEEid#
								and cu.DEid in (select DEid from RHEvaluadoresDes where RHEEid=#form.RHEEid# )
								inner join PortalPregunta p
								on p.PPid=pu.PPid
								and p.PCid=pu.PCid
								and PPparte=#rsPartes.PPparte#
								on pu.PCUid=ru.PCUid
							and pu.PCid=ru.PCid
							and pu.PPid=ru.PPid
							where ru.PCid=#rsCuestio.PCid#
							and ru.PCid=pu.PCid
							<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
								and cu.DEid=#form.DEid#
							</cfif>
							group by p.PPid
						</cfquery>
						
						<cfloop query="rsDet">
						<!---Trae el valor de la respuesta de acuerdo a la pregunta del query de arriba--->
						<cfquery name="rsDetD" datasource="#session.dsn#">
								select coalesce((ru.PRUvalor*PPvalor/(select max(PRvalor) from PortalRespuesta where PCid=#rsCuestio.PCid# and PPid=p.PPid)),0) as valor,p.PPid
								from PortalRespuestaU ru
								inner join PortalPreguntaU pu
									 inner join RHEEvaluacionDes e
									 on e.PCid=e.PCid
									 and e.RHEEid=#form.RHEEid#
								inner join PortalCuestionarioU cu									
								on cu.PCUid=pu.PCUid
								and cu.PCUreferencia=#form.RHEEid#
								and cu.DEid in (select DEid from RHEvaluadoresDes where RHEEid=#form.RHEEid#)
									inner join PortalPregunta p
									on p.PPid=pu.PPid
									and p.PCid=pu.PCid
									and PPparte=#rsPartes.PPparte#
									on pu.PCUid=ru.PCUid
								and pu.PCid=ru.PCid
								and pu.PPid=ru.PPid
								where ru.PCid=#rsCuestio.PCid#
								and ru.PCid=pu.PCid
								and ru.PRUvalor > -1
								<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
									and cu.DEid=#form.DEid#
								</cfif>
								and p.PPid=#rsDet.PPid#
								group by p.PPid,ru.PRUvalor,p.PPvalor
						</cfquery>
						
						<cfset LvarT=0>
						
						<cfquery dbtype="query" name="rs">
							select sum(valor) as valor from rsDetD
						</cfquery>
						<cfset LvarT=rs.valor>
						
						<cfif rsDet.recordcount gt 0 and len(trim(LvarT)) gt 0>
							<cfquery name="Eval" datasource="#session.dsn#">
								select count(1) cantidad from RHEvaluadoresDes where RHEEid=#form.RHEEid#
							</cfquery> 
							
							<cfquery name="rsValI" datasource="#session.dsn#">
								select PPvalor from PortalPregunta 
								where PCid=#rsCuestio.PCid#
								and PPparte=#rsPartes.PPparte#
								and PPid=#rsDet.PPid#
							</cfquery>
							
							<cfquery name="rsVal" datasource="#session.dsn#">
								select sum(PPvalor) as valorP from PortalPregunta where PCid=#rsCuestio.PCid#
								and PPparte=#rsPartes.PPparte#
							</cfquery>				
							
									<cfquery name="rsPreg" datasource="#session.dsn#">
										select PPpregunta from PortalPregunta where PPid=#rsDet.PPid#
									</cfquery>									
									
									<cfset valorP=#rsVal.valorP#*#Eval.cantidad#>
									<cfset total=#LvarT#*100/#valorP#>
									<!---<cfdump var="#rsVal.valorP#"><br />
									<cfdump var="#Eval.cantidad#"><br />
									valorP<cfdump var="#valorP#"><br />
									LvarT<cfdump var="#LvarT#"><br />
									total<cfdump var="#total#"><br />--->
									<cfset porcentaje=porcentaje+100>
							
									<tr>
										<td>#rsPreg.PPpregunta#</td>
										<!---<td>#NumberFormat(LvarT,",0.00")#</td>
										<td>#NumberFormat(rsVal.valorP,",0.00")#</td>--->
										<td>#NumberFormat(rsDetD.valor,",0.00")#</td>
										<!---<td>#NumberFormat(rsValI.PPvalor,",0.00")#</td> no borrar--->
										<td><cfset calif=rsDetD.valor*100/rsValI.PPvalor>#NumberFormat(calif,",0.00")#</td>
										<!---<td>#NumberFormat(total,",0.00")#</td> no borrar--->
									</tr>
						
						</cfif>
						</cfloop>
				</tr>		
		</cfloop>
</table>
</cfoutput>
</cfif>

<!---                                            Reporte Desarrollo                                                    --->
<cfif form.radio1 eq 2>
	<cfquery name="rsCuestio" datasource="#session.dsn#">
		select PCid from RHEEvaluacionDes where RHEEid=#form.RHEEid#
	</cfquery>

	<cfquery name="rsPartes" datasource="#session.dsn#">
		select distinct(c.PPparte),c.PCPdescripcion from PortalCuestionarioParte c
		inner join PortalPregunta p
		on c.PCid=p.PCid
		and c.PPparte=p.PPparte
		and p.PPtipo='D'
		where c.PCid=#rsCuestio.PCid#
	</cfquery>
	
<cfoutput>	
<table width="70%" align="center">
<!---	<tr>
		<td width="77%"><strong>Parte:</strong></td>
	</tr>--->
		<cfloop query="rsPartes">					
				<tr>		
					<td colspan="2"  class="tituloListas">Parte: #rsPartes.PCPdescripcion#</td>	
				</tr>				
				
				<cfquery name="rsId" datasource="#session.dsn#">
					select p.PPid from PortalPregunta p
						inner join PortalPreguntaU pu
						on p.PCid=pu.PCid
						and p.PPid=pu.PPid
						and pu.PCUtexto is not null
					where p.PCid=#rsCuestio.PCid#
					and p.PPparte=#rsPartes.PPparte#
					and p.PPtipo='D'
					group by p.PPid
				</cfquery>
	
				<cfloop query="rsId">
					<cfif len(trim(rsId.PPid)) gt 0>
						<cfquery name="rsNom" datasource="#session.dsn#">
							select PPpregunta from PortalPregunta where PCid=#rsCuestio.PCid# and PPid=#rsId.PPid#
						</cfquery>
						
						<cfquery name="rsPreg" datasource="#session.dsn#">						
							select pu.PCUtexto from PortalPregunta p
								inner join PortalPreguntaU pu
								on p.PCid=pu.PCid
								and p.PPid=pu.PPid
								and pu.PCUtexto is not null
							where p.PCid=#rsCuestio.PCid#
							and p.PPid=#rsId.PPid#

						</cfquery>
						<cfif rsPreg.recordcount gt 0>
							<tr><td bgcolor="CCCCCC" colspan="2" >#rsNom.PPpregunta#</td></tr>	
							<cfloop query="rsPreg">
								<tr><td>#rsPreg.PCUtexto#</td></tr>
							</cfloop>
						</cfif>
					</cfif>
				</cfloop>			
		</cfloop>
</table>
</cfoutput>
</cfif>
	
	
	
	
	
	
