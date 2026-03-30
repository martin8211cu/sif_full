<!---Traer los puestos y centro funcional---->
<cfif isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
<cfif isdefined("url.CFid") and not isdefined("form.CFid")>
	<cfset form.CFid = url.CFid>
</cfif>

<cfquery name="rsPuesto" datasource="#session.DSN#">
	select 	lt.RHPcodigo, 
			lt.DEid, 
			p.CFid,
			p.RHPdescripcion,
			c.CFdescripcion
	from LineaTiempo lt	
		inner join RHPlazas p
			on p.Ecodigo=lt.Ecodigo
			and p.RHPid=lt.RHPid	
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
		inner join CFuncional c
			on p.Ecodigo = c.Ecodigo
			and p.CFid = c.CFid
	where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta 
		and lt.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
			and lt.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		</cfif>
		order by  lt.RHPcodigo		
</cfquery>
<table width="100%" cellpadding="0" cellspacing="0">
	<cfoutput>
		<tr><td colspan="6" align="center"><strong>#Session.Enombre#</strong></td></tr>
		<tr><td colspan="6" align="center"><strong>Reporte de indicadores de capacitación</strong></td></tr>
		<tr><td>&nbsp;</td></tr>
	</cfoutput>
	<tr>
		<td class="titulolistas">&nbsp;</td>
		<td class="titulolistas"><strong>Puesto</strong></td>
		<td class="titulolistas"><strong>Centro Funcional</strong></td>
		<td class="titulolistas"><strong>Cantidad</strong></td>
		<td class="titulolistas"><strong>Valor</strong></td>
		<td class="titulolistas">&nbsp;</td>	
	</tr>
	<cfif isdefined("rsPuesto") and rsPuesto.RecordCount NEQ 0>
		<cfoutput query="rsPuesto" group="RHPcodigo"><!---Recorrido de puesto(s)--->
			<cfset vncant = 0><!--Variable para guardar la cantidad de empleados del puesto--->
			<cfset vncantOK = 0><!---Variable con la cantidad mayor que 70(OK)--->
			<cfset vnsumPuesto = 0><!---Variable con la suma de la notas minimas de las habilidades y conocimientos---->
			<cfset vnPorcentaje = 0><!---Variable con el porcentaje del valor---->
			<!--- Habilidades del puesto --->
			<tr>
				<td>&nbsp;</td>
				<td>
					<cfquery name="Puesto" datasource="#session.DSN#">
						select RHPdescpuesto from RHPuestos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPuesto.RHPcodigo#">						
					</cfquery>
					<a href="IndCapacitacion.cfm?RHPcodigo=#rsPuesto.RHPcodigo#&Opcion=1">#Puesto.RHPdescpuesto#</a>
				</td>
				<td>#rsPuesto.CFdescripcion#</td>		
				<cfquery name="habilidades_requeridas" datasource="#session.DSN#">
					select a.RHHid, b.RHHcodigo, b.RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota
					from RHHabilidadesPuesto a
					
					inner join RHHabilidades b
					on a.Ecodigo=b.Ecodigo
					and a.RHHid=b.RHHid
					
					where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPuesto.RHPcodigo#">
					  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					order by b.RHHcodigo
				</cfquery>
				<cfif habilidades_requeridas.RecordCount NEQ 0>
					<cfset habilidades_puesto = valuelist(habilidades_requeridas.RHHid) >
				</cfif>	

				<!---SUMA de las notas minimas de las habilidades requeridas--->
				<cfif isdefined("habilidades_puesto") and len(trim(habilidades_puesto))>
					<cfquery name="habilidades" datasource="#session.DSN#">
						select coalesce(sum(coalesce(a.RHNnotamin,0)*100),0) as nota, a.RHPcodigo
						from RHHabilidadesPuesto a		
							inner join RHHabilidades b
								on a.Ecodigo=b.Ecodigo
								and a.RHHid=b.RHHid		
						where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPuesto.RHPcodigo#">
						  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and a.RHHid in (#habilidades_puesto#)
						Group by a.RHPcodigo
					</cfquery>
					<cfif isdefined("habilidades") and len(trim(habilidades.nota))>
						<cfset vnsumPuesto = vnsumPuesto + habilidades.nota>
					</cfif>
				</cfif>
				<!---Conocimientos del puesto--->
				<cfquery name="conocimientos_requeridos" datasource="#session.DSN#">
					select a.RHCid, b.RHCcodigo, b.RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota
					from RHConocimientosPuesto a
					
					inner join RHConocimientos b
					on a.Ecodigo=b.Ecodigo
					and a.RHCid=b.RHCid
					
					where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPuesto.RHPcodigo#">
					  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					order by b.RHCcodigo
				</cfquery>
				<cfif isdefined("conocimientos_requeridos") and conocimientos_requeridos.RecordCount NEQ 0 and len(trim(conocimientos_requeridos.RHCid))>
					<cfset conocimientos_puesto = valuelist(conocimientos_requeridos.RHCid)>
				</cfif>
				
				<cfif isdefined("conocimientos_puesto") and len(trim(habilidades_puesto))>
					<!--- SUMA de la nota minima de los conocimientos --->
					<cfquery name="conocimientos" datasource="#session.DSN#">
						select coalesce(sum(coalesce(a.RHCnotamin,0)*100),0) as nota, a.RHPcodigo
						from RHConocimientosPuesto a		
							inner join RHConocimientos b
								on a.Ecodigo=b.Ecodigo
								and a.RHCid=b.RHCid		
						where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPuesto.RHPcodigo#">
						  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and a.RHCid in (#conocimientos_puesto#)
						group by a.RHPcodigo
					</cfquery>
					<cfif isdefined("conocimientos") and len(trim(conocimientos.nota))>
						<cfset vnsumPuesto = vnsumPuesto + conocimientos.nota>
					</cfif>
				</cfif>
				
				<cfoutput><!----Recorrido de los empleados del puesto --->	
					<cfset vncant = vncant + 1>
					<cfset vnsumPosee = 0><!--Variable con la suma de la nota obtenida por el empleado tanto en habilidades como conocimientos--->													
					<!---Habilidades del empleado--->
					<cfif isdefined("habilidades_puesto") and len(trim(habilidades_puesto))>
						<cfquery name="habilidades_poseidas" datasource="#session.DSN#">
							select  coalesce(sum(case when RHCEdominio > c.RHNnotamin then coalesce(c.RHNnotamin,0)*100
										else RHCEdominio end),0) as nota
							from RHCompetenciasEmpleado a					
								inner join RHHabilidades b
									on a.Ecodigo=b.Ecodigo
									and a.idcompetencia=b.RHHid
									inner join RHHabilidadesPuesto c
										on b.Ecodigo = c.Ecodigo
										and b.RHHid = c.RHHid
										and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPuesto.RHPcodigo#">
								
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPuesto.DEid#">
									and tipo='H'
									and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
									and idcompetencia in (#habilidades_puesto#)			
						</cfquery>
						<cfif isdefined("habilidades_poseidas") and habilidades_poseidas.RecordCount NEQ 0>
							<cfset vnsumPosee = vnsumPosee + habilidades_poseidas.nota>
						</cfif>						
					</cfif>
					<!----Conocimientos del empleado---->
					<cfif isdefined("conocimientos_puesto") and len(trim(conocimientos_puesto))>
						<cfquery name="conocimientos_poseidos" datasource="#session.DSN#">
							select  coalesce(sum(case when a.RHCEdominio > c.RHCnotamin then  coalesce(c.RHCnotamin,0) * 100
											else a.RHCEdominio end),0) as nota
			
							from RHCompetenciasEmpleado a
								inner join RHConocimientos b
									on a.Ecodigo=b.Ecodigo
									and a.idcompetencia=b.RHCid
									
									inner join RHConocimientosPuesto c
										on b.Ecodigo = c.Ecodigo
										and b.RHCid = c.RHCid
										and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPuesto.RHPcodigo#">		   											
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPuesto.DEid#">
								and tipo='C'
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
								and idcompetencia in (#conocimientos_puesto#)
						</cfquery>
						<cfif isdefined("conocimientos_poseidos") and conocimientos_poseidos.RecordCount NEQ 0>
							<cfset vnsumPosee = vnsumPosee + conocimientos_poseidos.nota>
						</cfif>
					</cfif>
					<cfif vnsumPosee GTE vnsumPuesto>						
						<cfset vncantOK = vncantOK + 1>
					</cfif>				
				</cfoutput>				
				<td>#vncant#</td>
				<td>
					<cfset vnPorcentaje = (vncantOK * 100)/vncant>
					#vnPorcentaje#
				</td>
				<cfif not isdefined("url.imprimir")>
					<td>
						<cfif vnPorcentaje LT 70>
							<img src="/cfmx/rh/imagenes/Borrar01_S.gif" name="CFimagen" width="18" height="14" border="0" align="absmiddle">
						<cfelse>
							<img src="/cfmx/rh/imagenes/w-check.gif" name="CFimagen2" width="18" height="14" border="0" align="absmiddle">
						</cfif>	
					</td>
				</cfif>	
			</tr>
		</cfoutput>	
	<cfelse>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="6" align="center">------- No se encontraron registros -------</td></tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>
	<tr><td colspan="6">
		<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)) and isdefined("url.Opcion") and url.Opcion EQ 1>
			<cfinclude template="DetalleIndCapacitacion.cfm">
		</cfif>
	</td></tr>	
</table>


