<!---
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isdefined("url.RHCfdesde") and len(trim(url.RHCfdesde))>
	<cfset form.RHCfdesde = url.RHCfdesde>
</cfif>
<cfif isdefined("url.RHCfhasta") and len(trim(url.RHCfhasta))>
	<cfset form.RHCfhasta = url.RHCfhasta>
</cfif>
<cfif isdefined("url.CFid") and len(trim(url.CFid))>
	<cfset form.CFid = url.CFid>
</cfif>
<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
----->

<!---Funcion para obtener las dependencias de un ctro funcional----->
<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<!--- Se puso 0 en vez de null ya que Oracle no lo aguanta con el union --->
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, 0 as CFidresp
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
				union all
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
<!---Si esta encendido el check de incluir dependencias--->
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("chkDep")>
	<cfset cf = getCentrosFuncionalesDependientes(url.CFid) >
	<cfset vsCFuncionales = ValueList(cf.CFid)>
</cfif>
<!---Query con los datos--->
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	c.DEid,
			e.RHECid,
			{fn concat(ltrim(rtrim(g.RHIAcodigo)),{fn concat('-',ltrim(rtrim(g.RHIAnombre)))})} as inst,
			f.RHCfdesde, 
			f.RHCfhasta,
			{fn concat(ltrim(rtrim(f.RHCcodigo)),{fn concat('-',ltrim(rtrim(f.RHCnombre)))})} as Curso,
			f.RHCprofesor,
			a.RHPpuesto,
			a.CFid,
			coalesce(ltrim(rtrim(j.RHPcodigoext)),ltrim(rtrim(j.RHPcodigo))) as RHPcodigo,
			coalesce(ltrim(rtrim(j.RHPcodigoext)),
			{fn concat(ltrim(rtrim(j.RHPcodigo)),{fn concat('-',ltrim(rtrim(j.RHPdescpuesto)))})}) as Puesto,		
			{fn concat(h.CFdescripcion,{fn concat('-',h.CFcodigo)})}	as CtroFuncional,
			k.DEidentificacion,
			{fn concat({fn concat({fn concat({fn concat(k.DEnombre , ' ' )}, k.DEapellido1 )}, ' ' )}, k.DEapellido2 )}  as NombreEmpleado, 
			f.duracion as Duracion
	from RHPlazas a
		inner join CFuncional h
			on h.Ecodigo = a.Ecodigo
			and h.CFid = a.CFid

		inner join RHPuestos j
			on j.Ecodigo = a.Ecodigo
			and j.RHPcodigo = a.RHPpuesto
			
		inner join LineaTiempo c
			on c.Ecodigo = a.Ecodigo
			and c.RHPid = a.RHPid
			and getdate() between c.LTdesde and c.LThasta
			<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			</cfif>
			
			inner join DatosEmpleado k
				on c.Ecodigo = k.Ecodigo
				and c.DEid = k.DEid
			
			inner join RHPuestos d
				on d.Ecodigo = c.Ecodigo
				and d.RHPcodigo=c.RHPcodigo
			
			inner join RHEmpleadoCurso e
				on e.Ecodigo = c.Ecodigo
				and e.DEid = c.DEid	
				
				inner join RHCursos f
					on e.RHCid = f.RHCid					
					<cfif isdefined("url.RHCfdesde") and len(trim(url.RHCfdesde))>						
						and f.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHCfdesde)#">
					</cfif>
					<cfif isdefined("url.RHCfhasta") and len(trim(url.RHCfhasta))>
						and f.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHCfhasta)#">
					</cfif>
					
					<cfif isdefined("url.tipo") and len(trim(url.tipo))>
						and f.RHCexterno = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tipo#">
					</cfif>
					
				inner join RHMateria m
					on f.Mcodigo = m.Mcodigo
					and m.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					
				inner join RHInstitucionesA  g
					on f.RHIAid = g.RHIAid
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("url.CFid") and len(trim(url.CFid)) and not(isdefined("url.chkDep"))><!---Si no esta encendido el check de incluir dependencias---->
		and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	<cfelseif isdefined("vsCFuncionales") and len(trim(vsCFuncionales))>
		and a.CFid in (#vsCFuncionales#)
	</cfif>		
	<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
		and a.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
	</cfif>
	 Order by a.CFid,a.RHPpuesto,14,f.RHCfhasta desc 
</cfquery>

<cfif rsDatos.recordcount gt 0 >
	<cfreport format="#url.formato#" template="baseEntCFuncional-rep.cfr" query="rsDatos">
		<cfreportparam name="Empresa" value="#session.Enombre#">
	</cfreport>
<cfelse>
	<table width="98%" cellpadding="0" cellspacing="0">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ReporteBaseEntrenamientoPorCentroFuncional"
		Default="Reporte Base entrenamiento por Centro Funcional"
		returnvariable="LB_ReporteBaseEntrenamientoPorCentroFuncional"/> 
		
		<cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.Enombre#</strong></td></tr>
			<tr>
			  <td align="center" style="font-size:13px"><strong>#LB_ReporteBaseEntrenamientoPorCentroFuncional#</strong></td>
			</tr>	
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong>-------- <cf_translate  XmlFile="/rh/generales.xml" key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --------</strong></td></tr>
		</cfoutput>
	</table>
</cfif>
