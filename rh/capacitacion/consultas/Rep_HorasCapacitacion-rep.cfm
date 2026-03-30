
<cf_dbtemp name="CFHorascapacita" returnvariable="CFHorascapacita" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid"   		 	type="numeric"     mandatory="yes">
	<cf_dbtempcol name="DEidentificacion"   type="char(60)"    mandatory="yes">
	<cf_dbtempcol name="DEnombre"   	 	type="char(100)"   mandatory="yes">
	<cf_dbtempcol name="DEapellido1"   	 	type="char(80)"    mandatory="yes">
	<cf_dbtempcol name="DEapellido2"   	 	type="char(80)"    mandatory="yes">
	<cf_dbtempcol name="CFid"   		 	type="numeric"    	mandatory="yes">
	<cf_dbtempcol name="CFcodigo"   	 	type="char(10)"    mandatory="yes">
	<cf_dbtempcol name="CFdescripcion"   	type="char(60)"    mandatory="yes">
	<cf_dbtempcol name="RHPcodigo"   	 	type="char(10)"    mandatory="yes">
	<cf_dbtempcol name="RHPdescripcion"   	type="char(80)"    mandatory="yes">
	<cf_dbtempcol name="TotalHorasEmpleado"	type="float"     mandatory="no">

</cf_dbtemp>

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
<!---Si esta encendido el check de incluir dependencias--->
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.chkDep")>
	<cfset cf = getCentrosFuncionalesDependientes(url.CFid) >
	<cfset vsCFuncionales = ValueList(cf.CFid)>
</cfif>


<cfquery name="rsDatos" datasource="#session.DSN#" result="prueba">
	insert into #CFHorascapacita# (DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2,CFid,CFcodigo,CFdescripcion,RHPcodigo,RHPdescripcion,TotalHorasEmpleado)
	select 	c.DEid,k.DEidentificacion,k.DEnombre,k.DEapellido1,
		k.DEapellido2,h.CFid,h.CFcodigo,h.CFdescripcion,a.RHPcodigo,a.RHPdescripcion,0   
	from RHPlazas a
		inner join CFuncional h
			on h.Ecodigo = a.Ecodigo
			and h.CFid = a.CFid
			
		inner join LineaTiempo c
			on c.Ecodigo = a.Ecodigo
			and c.RHPid = a.RHPid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHCfhasta)#">  between c.LTdesde and c.LThasta
			
		inner join DatosEmpleado k
			on c.Ecodigo = k.Ecodigo
			and c.DEid = k.DEid
		inner join RHPuestos d
			on d.Ecodigo = c.Ecodigo
			and d.RHPcodigo=c.RHPcodigo
			
			
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("url.CFid") and len(trim(url.CFid)) and not(isdefined("url.chkDep"))>
		and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	<cfelseif isdefined("vsCFuncionales") and len(trim(vsCFuncionales))>
		and a.CFid in (#vsCFuncionales#)
	</cfif>	
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>	
	<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
		and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
	</cfif>	
	order by a.CFid,c.DEid
</cfquery>
<cfquery name="rsDatos" datasource="#session.DSN#">
	 update  #CFHorascapacita#  
	 set TotalHorasEmpleado = coalesce((	select sum(coalesce(b.duracion, 0))
											from RHEmpleadoCurso a
											
											left join RHCursos b
												on a.RHCid = b.RHCid
												
											
											where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  and a.RHEMestado in (10, 20)
											  and a.RHEStatusCurso = 1
											  and a.RHECfhasta  between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHCfdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHCfhasta)#">
											  and a.DEid = #CFHorascapacita#.DEid 
											  <cfif isdefined("url.tipo") and len(trim(url.tipo))>
													and RHCexterno = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tipo#">
											  </cfif>
											group  by  a.DEid )
									  ,0)
</cfquery>

<cfset empleados ="">
<cfset centrofuncional ="">
<cfset puesto ="">

<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset empleados = 'Para el empleado ' & url.DEIDENTIFICACION &' ' & trim(url.NOMBREEMP) >
<cfelse>
	<cfset empleados = 'Para todos los empleados'>
</cfif>
<cfif isdefined("url.CFID") and len(trim(url.CFID))>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFcodigo, CFdescripcion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfquery>
	<cfset centrofuncional = 'Para el centro funcional ' & trim(rsCFuncional.CFCODIGO) & ' - ' & trim(rsCFuncional.CFdescripcion)>
	<cfif isdefined("url.chkDep")>
		<cfset centrofuncional = centrofuncional & ' incluyendo sus dependencias'>
	</cfif>
<cfelse>
	<cfset centrofuncional = 'Para todos los centros funcionales'>
</cfif>
<cfquery name="rsPuesto" datasource="#session.DSN#">
	select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigo, RHPdescpuesto
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
</cfquery>

<cfif isdefined("url.RHPCODIGO") and len(trim(url.RHPCODIGO))>
	<cfset puesto = 'Para el puesto ' & trim(rsPuesto.RHPCODIGO) & ' - ' & trim(rsPuesto.RHPdescpuesto)>
<cfelse>
	<cfset puesto = 'Para todos los puestos'>
</cfif>


<cfif isdefined("url.resumido") and len(trim(url.resumido)) and url.resumido eq 'R'>
	<cfquery name="rsDatos" datasource="#session.DSN#">
			select 	
			'#session.Enombre#' as  Edescripcion,
			'#url.RHCfdesde#' as RHCfdesde,
			'#url.RHCfhasta#' as RHCfhasta,
			'#centrofuncional#' as CFuncionales,
			'#empleados#' as empleados,
			'#puesto#' as  puestos, 
			CFid,CFcodigo,CFdescripcion,
			sum(coalesce(a.TotalHorasEmpleado, 0)) as  TotalHorasCF,
			(sum(coalesce(a.TotalHorasEmpleado, 0))) * 1.00 / count(a.DEid) as promedio
			from #CFHorascapacita# a
			group  by  CFid,CFcodigo,CFdescripcion
	</cfquery>
<cfelse>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 
			'#session.Enombre#' as  Edescripcion,
			'#url.RHCfdesde#' as RHCfdesde,
			'#url.RHCfhasta#' as RHCfhasta,
			'#centrofuncional#' as CFuncionales,
			'#empleados#' as empleados,
			'#puesto#' as  puestos, 	
			DEidentificacion,DEnombre,DEapellido1,DEapellido2,CFcodigo,CFdescripcion,RHPcodigo,RHPdescripcion,TotalHorasEmpleado 
			from  #CFHorascapacita#
			order by DEapellido2,DEapellido1,DEnombre
	</cfquery>	
</cfif>
<cfif rsDatos.recordcount gt 0 >
	<cfif isdefined("url.resumido") and len(trim(url.resumido)) and url.resumido eq 'R'>
		<cfreport format="#url.formato#" template="Rep_HorasCapacitacion-repRES.cfr" query="rsDatos">
		</cfreport>
	<cfelse>
		<cfreport format="#url.formato#" template="Rep_HorasCapacitacion-repDET.cfr" query="rsDatos">
		</cfreport>	
	</cfif>
<cfelse>
	<table width="98%" cellpadding="0" cellspacing="0">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ReporteDeHorasDeCapacitacion"
		Default="Reporte de horas de capacitación"
		returnvariable="LB_ReporteDeHorasDeCapacitacion"/> 
		
		<cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.Enombre#</strong></td></tr>
			<tr>
			  <td align="center" style="font-size:13px"><strong>#LB_ReporteDeHorasDeCapacitacion#</strong></td>
			</tr>	
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong>-------- <cf_translate  XmlFile="/rh/generales.xml" key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --------</strong></td></tr>
		</cfoutput>
	</table>
</cfif>




