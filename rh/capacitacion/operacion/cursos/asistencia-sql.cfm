<cfinvoke component="rh.Componentes.RH_ProgramacionCursos" method="init" returnvariable="curso">
<cfif isdefined ('form.AgregaDet')>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update RHEmpleadoCurso set
		RHECjust='#form.just#'
		where RHCid=#form.RHCid#
		and DEid=#form.DEid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
		<script language="JavaScript1.2">
				window.close();
			</script>
<cfelse>

<cfif isdefined("form.Guardar")>
	<cfif form.contador gt 0 >
		<cftransaction>
		<cfset curso.eliminarAsistencia(form.RHCid, form.fecha_registro, session.DSN) >
		
		<cfloop from="1" to="#contador#" index="i">
			<cfset horas = form['horas_#i#'] >
			<cfif not len(trim(horas))><cfset horas = 0></cfif>
			<cfset curso.insertarAsistencia( form.RHCid, 
											 form['RHDCid_#i#'], 
											 form['DEid_#i#'], 
											 form['fecha_#i#'], 
											 horas, 
											 session.DSN, 
											 session.Usucodigo) >
		</cfloop>
		</cftransaction>
	</cfif>
</cfif>

<cfif isdefined("form.finalizar")>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">	
<cftransaction>
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2118" default="" returnvariable="UsaPor"/>
	<cfif UsaPor gt 0>
		<cfquery name="rs" datasource="#session.dsn#">
			select sum(RHAChoras) as horas, de.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# de.DEapellido2#LvarCNCT# ' '#LvarCNCT# de.DEnombre as nombre, ec.DEid,c.duracion
			from RHEmpleadoCurso ec 
			inner join RHAsistenciaCurso a
						on a.RHCid=ec.RHCid
						and a.DEid=ec.DEid
			inner join RHCursos c 
			on c.RHCid=ec.RHCid 
			and c.RHCtipo = 'P'
			inner join RHDiasCurso dc 
			on dc.RHCid=c.RHCid 
			and dc.RHDCactivo=1 
			and dc.RHDCid=a.RHDCid
			inner join DatosEmpleado de 
			on de.DEid=ec.DEid
			where ec.RHCid=#form.RHCid# 
			and ec.RHEMestado in (0, 10, 20, 30) 
			and ec.Ecodigo = #session.Ecodigo#
			and ec.RHECestado = 50
			group by de.DEnombre, de.DEapellido1, de.DEapellido2, ec.DEid,RHECjust,c.duracion
			order by de.DEapellido1, de.DEapellido2, de.DEnombre
		</cfquery>
		<cfloop query="rs">
			<cfset LvarT=0>
			<cfset LvarT=rs.horas*100/rs.duracion>
			<cfquery name="insert" datasource="#Session.DSN#">
				update RHEmpleadoCurso
					set RHEMnotamin = <cfif isdefined("UsaPor") and len(trim(UsaPor))><cfqueryparam cfsqltype="cf_sql_numeric" value="#UsaPor#"></cfif>,
						RHEMnota = <cfif isdefined("LvarT") and len(trim(LvarT))><cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarT#"></cfif>,
						RHEMestado = <cfif isdefined("LvarT") and len(trim(LvarT))>
										<cfif  LvarT GTE UsaPor>
											10
										<cfelseif LvarT LT UsaPor>
											20
										<cfelse>
											0
										</cfif>
									<cfelse>
										0
									</cfif>								
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DEid#">
					and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">			
			</cfquery>
		</cfloop>
		<!---Verifica si el curso cobra si se pierde--->
			<cfquery name="rsCurso" datasource="#session.dsn#">
				select RHECcobrar,RHCnombre,RHCfdesde,RHECtotempleado from RHCursos where 
				RHCid=#form.RHCid#
				and RHCtipo = 'P'
			</cfquery>

			<!---Se buscan los empleados que perdieron los cursos--->
			<cfif isdefined ('rsCurso') and rsCurso.RHECcobrar eq 1>
				<cfquery name="rsEmp" datasource="#session.dsn#">
					select * from RHEmpleadoCurso 
					where RHEMestado=20
					and RHECjust is null
					and RHCid=#form.RHCid#
				</cfquery>
				
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2111" default="" returnvariable="LvarTDid"/>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2108" default="" returnvariable="LvarCuotas"/>
		
				<cfif LvarCuotas gt 0>
					<cfset monto = rsCurso.RHECtotempleado/LvarCuotas>
				<cfelse>
					<cfset monto = rsCurso.RHECtotempleado>
				</cfif>
				
			<!---Se ingresan las deducciones--->
					<cfloop query="rsEmp">
							<cfquery name="ABC_Insdeducciones" datasource="#Session.DSN#">
								insert Into DeduccionesEmpleado ( DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin, 
															 Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo, Ulocalizacion, Dactivo, 
															 Dcontrolsaldo, Dreferencia  )
								values (	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="9999">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTDid#">,
									'Por perdida de curso'#LvarCNCT# '#rsCurso.RHCnombre#',
									1,
									<cfqueryparam cfsqltype="cf_sql_money" value="#monto#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(rsCurso.RHCfdesde)#">,
									null,
									#rsCurso.RHECtotempleado#,
									0,
									#rsCurso.RHECtotempleado#,
									0, 
									1,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
									1,
									1,
									null)					
							</cfquery>
					</cfloop>
			</cfif>
	<cfelse>
		<!--- marca como aprobados los cursos de participacion --->
		<cfquery datasource="#session.DSN#">
			update RHEmpleadoCurso
			set RHEMestado = 10
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			and exists ( select 1
						 from RHCursos
						 where RHCid = RHEmpleadoCurso.RHCid
							and RHCtipo = 'P' )
		</cfquery>		
	</cfif>
</cftransaction>
	

</cfif>

<cfset parametros = '&traer=true' >
<cfif isdefined("form.fecha_registro")>
	<cfset parametros = parametros & '&fecha_registro=#form.fecha_registro#' >
</cfif>
<cfif isdefined("form.filtro_RHIAid")>
	<cfset parametros = parametros & '&filtro_RHIAid=#form.filtro_RHIAid#' >
</cfif>
<cfif isdefined("form.filtro_RHACid")>
	<cfset parametros = parametros & '&filtro_RHACid=#form.filtro_RHACid#' >
</cfif>
<cfif isdefined("form.filtro_RHGMid") >
	<cfset parametros = parametros & '&filtro_RHGMid=#form.filtro_RHGMid#' >
</cfif>
<cfif isdefined("form.filtro_Mnombre")>
	<cfset parametros = parametros & '&filtro_Mnombre=#form.filtro_Mnombre#' >
</cfif>
<cfif isdefined("form.filtro_RHCfdesde")>
	<cfset parametros = parametros & '&filtro_RHCfdesde=#form.filtro_RHCfdesde#' >
</cfif>
<cfif isdefined("form.filtro_RHCfhasta")>
	<cfset parametros = parametros & '&filtro_RHCfhasta=#form.filtro_RHCfhasta#' >
</cfif>
<cfif isdefined("form.pageNum_lista")>
	<cfset parametros = parametros & '&pageNum_lista=#form.pageNum_lista#' >
</cfif>

<cfif isdefined("form.finalizar")>
	<cflocation url="asistencia-lista.cfm?ok=true#parametros#">
</cfif>

<cflocation url="asistencia.cfm?RHCid=#form.RHCid##parametros#">
</cfif>