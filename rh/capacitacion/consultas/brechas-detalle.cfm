<!--- Creado por: 	  Yu Hui Wen  --->
<!--- Fecha: 		  27/05/2005  3:30 p.m. --->
<!--- Modificado por: --->
<!--- Fecha: 		  --->

<!--- <cf_dump var="#url#"> --->
<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, -1 as CFidresp
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cfid#">
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			   and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>

<cfif isdefined("url.CFid") and len(trim(url.CFid)) >
	<cfif isdefined("url.dependencias") >
		<cfset cf = getCentrosFuncionalesDependientes(url.CFid) >
		<cfset cf_lista = valuelist(cf.CFid) >
	<cfelse>
		<cfset cf_lista = url.CFid >
	</cfif>
</cfif>



<cfquery name="rsReporte1" datasource="#session.DSN#">
		select	1 as tipo,
				c.CFid,
				{fn concat(rtrim(c.CFcodigo),{fn concat(' ',c.CFdescripcion)})} as centrofunc,
				a.DEid as empleado,
				de.DEidentificacion as identificacion,
				rtrim({fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}) as nombreEmpleado,
				d.RHPdescpuesto as puesto,
				f.RHHid as id, 
				{fn concat(rtrim(f.RHHcodigo),{fn concat(' ',f.RHHdescripcion)})} as competencia,
				e.RHNnotamin * 100 as notaRequerida, 
				e.RHHtipo,
				case
					when e.RHHtipo = 0 then 'Competencia Primordial' 
					when e.RHHtipo = 1 then 'Competencia Bsica' 
					when e.RHHtipo = 2 then 'Competencia Complementaria' 
					when e.RHHtipo = 3 then 'Competencia Deseable' 
					else ''
				end as prioridadCompetencia,
				coalesce(g.RHCEdominio, 0.00) as notaObtenida
		from LineaTiempo a
		
			inner join RHPlazas b
				on b.Ecodigo = a.Ecodigo
				and b.RHPid = a.RHPid
			
		
			inner join CFuncional c
				on c.Ecodigo = b.Ecodigo
				and c.CFid = b.CFid
	
			inner join RHPuestos d
				on d.Ecodigo = a.Ecodigo
				and d.RHPcodigo = a.RHPcodigo
		
			inner join RHHabilidadesPuesto e
				on e.Ecodigo = a.Ecodigo
				and e.RHPcodigo = a.RHPcodigo
				
		
			inner join RHHabilidades f
				on f.Ecodigo = e.Ecodigo
				and f.RHHid = e.RHHid
							
		
			inner join DatosEmpleado de
				on de.Ecodigo = a.Ecodigo
				and de.DEid = a.DEid
		
			left outer join RHCompetenciasEmpleado g
				on g.Ecodigo = a.Ecodigo
				and g.DEid = a.DEid
				and g.idcompetencia = f.RHHid
				
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and e.RHNnotamin is not null
		and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between a.LTdesde and a.LThasta
		<cfif isdefined("cf_lista") and len(trim(cf_lista))>
				and b.CFid in (#cf_lista#)
		 </cfif>
		 <cfif isdefined("url.RHHid") and len(trim(url.RHHid)) >
					and f.RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHHid#">
				<cfelseif isdefined("url.RHCid") and len(trim(url.RHCid)) >
					and f.RHHid = -1
				</cfif>	
		and g.RHCEfdesde >= (
					select max(x.RHCEfdesde) from RHCompetenciasEmpleado x
					where x.DEid = g.DEid
					and x.Ecodigo = g.Ecodigo 
					and x.tipo = g.tipo
					and x.idcompetencia = g.idcompetencia
				)
		and g.tipo = 'H'
		
		<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
			and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
		</cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	
		union
		select	2 as tipo,
				c.CFid,
				{fn concat(rtrim(c.CFcodigo),{fn concat(' ',c.CFdescripcion)})}  as centrofunc,
				a.DEid as empleado,
				de.DEidentificacion as identificacion,
				rtrim({fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}) as nombreEmpleado,
				d.RHPdescpuesto as puesto,
				f.RHCid as id, 
				{fn concat(rtrim(f.RHCcodigo),{fn concat(' ',f.RHCdescripcion)})} as competencia, 
				e.RHCnotamin * 100 as notaRequerida, 
				e.RHCtipo,
				case
					when e.RHCtipo = 0 then 'Competencia Primordial' 
					when e.RHCtipo = 1 then 'Competencia B sica' 
					when e.RHCtipo = 2 then 'Competencia Complementaria' 
					when e.RHCtipo = 3 then 'Competencia Deseable' 
					else ''
				end as prioridadCompetencia,
				coalesce(g.RHCEdominio, 0.00) as notaObtenida
		from LineaTiempo a
		
			inner join RHPlazas b
				on b.Ecodigo = a.Ecodigo
				and b.RHPid = a.RHPid
			
		
			inner join CFuncional c
				on c.Ecodigo = b.Ecodigo
				and c.CFid = b.CFid
		
			inner join RHPuestos d
				on d.Ecodigo = a.Ecodigo
				and d.RHPcodigo = a.RHPcodigo
		
			inner join RHConocimientosPuesto e
				on e.Ecodigo = a.Ecodigo
				and e.RHPcodigo = a.RHPcodigo
				
		
			inner join RHConocimientos f
				on f.Ecodigo = e.Ecodigo
				and f.RHCid = e.RHCid
				

			inner join DatosEmpleado de
				on de.Ecodigo = a.Ecodigo
				and de.DEid = a.DEid
		
			left outer join RHCompetenciasEmpleado g
				on g.Ecodigo = a.Ecodigo
				and g.DEid = a.DEid
				
				and g.idcompetencia = f.RHCid
				
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between a.LTdesde and a.LThasta
		and g.tipo = 'C'
		and e.RHCnotamin is not null
		and g.RHCEdominio >= 0
		and g.RHCEfdesde >= (
					select max(x.RHCEfdesde) from RHCompetenciasEmpleado x
					where x.DEid = g.DEid
					and x.Ecodigo = g.Ecodigo 
					and x.tipo = g.tipo
					and x.idcompetencia = g.idcompetencia
				)
		<cfif isdefined("url.RHHid") and len(trim(url.RHHid)) >
			and f.RHCid = -1
		<cfelseif isdefined("url.RHCid") and len(trim(url.RHCid)) >
			and f.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
		</cfif>
		<cfif isdefined("cf_lista") and len(trim(cf_lista))>
				and b.CFid in (#cf_lista#)
		  </cfif>
		<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
			and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
		</cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	order by c.CFid, tipo, id, identificacion
</cfquery>


<cfquery name="rsReporte2" dbtype="query">
	select 	CFid,
			centrofunc,
			tipo,
			id,
			competencia, 
			identificacion,
			nombreEmpleado,
			puesto,
			prioridadCompetencia,
			notaRequerida - notaObtenida as brecha
	from rsReporte1
	where notaObtenida < notaRequerida
	<cfif isdefined("url.Brecha") and len(trim(url.Brecha)) and url.Brecha gt 0 >
		and (notaRequerida - notaObtenida) >= #url.Brecha#
	</cfif>
	order by CFid, tipo,id,identificacion
</cfquery>
<!---  <cf_dump var="#rsReporte2#"> 

order by CFid, tipo, id, identificacion
 --->
<cfreport format="#url.formato#" template= "capacitacion.cfr" query="rsReporte2">
	<cfreportparam name="Edescripcion" value="#Session.Enombre#">
</cfreport>

