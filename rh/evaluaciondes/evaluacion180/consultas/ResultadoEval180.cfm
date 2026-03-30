<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Autoevaluacion"
	Default="Autoevalua&oacute;n"
	returnvariable="LB_Autoevaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluadoPor"
	Default="Evaluado por"
	returnvariable="LB_EvaluadoPor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionDeConceptos"
	Default="Evaluaci&oacute;n de Conceptos"
	returnvariable="LB_EvaluacionDeConceptos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionDeJefaturas"
	Default="Evaluaci&oacute;n de Jefaturas"
	returnvariable="LB_EvaluacionDeJefaturas"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_OtrasEvaluaciones"
	Default="Otras Evaluaciones"
	returnvariable="LB_OtrasEvaluaciones"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_LogrosObtenidos"
	Default="Logros Obtenidos"
	returnvariable="LB_LogrosObtenidos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RetosYPlanesDeAccion"
	Default="Retos y Planes de Acci&oacute;n"
	returnvariable="LB_RetosYPlanesDeAccion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoUsaTabla"
	Default="No usa tabla"
	returnvariable="LB_NoUsaTabla"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoSeEncontraronRegistros"
	Default="No se encontraron registros"
	returnvariable="LB_NoSeEncontraronRegistros"/>	

<!--- FIN VARIABLES DE TRADUCCION --->
﻿<!--- Creación de la tabla del reporte --->
<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.DSN#">
	<cf_dbtempcol name="tipoid"			type="int"			mandatory="yes" >
	<cf_dbtempcol name="tipo"			type="varchar(255)"	mandatory="yes" >
	<cf_dbtempcol name="DEid"			type="numeric"		mandatory="yes" > 
	<cf_dbtempcol name="TEcodigo"		type="varchar(255)"	mandatory="no" > 	
	<cf_dbtempcol name="TEVvalor"		type="char(3)"		mandatory="no" > 
	<cf_dbtempcol name="IAEpregunta"	type="varchar(255)"	mandatory="yes" >
	<cf_dbtempcol name="respuestaE"		type="text"			mandatory="no" >
	<cf_dbtempcol name="respuestaJ"		type="text"			mandatory="no" >
	<cf_dbtempcol name="respuesta"		type="text"			mandatory="no" >
</cf_dbtemp>

<!--- Funcion para buscar las dependencias de un centro funcional --->
<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, null as CFidresp
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
 
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and isdefined("url.chkDep")>
	<cfset cf = getCentrosFuncionalesDependientes(url.CFid) >
	<cfset vsCFuncionales = ValueList(cf.CFid)>
</cfif>
 
<cfquery name="rsInfoEmpleados" datasource="#session.DSN#">
	select 
	REdescripcion,
	REdesde,
	REhasta,
	RHPdescripcion as puesto, 
	CFdescripcion as centrofuncional,
	Ddescripcion as Departamento,
	{fn concat({fn concat({fn concat({fn concat(DEE.DEnombre , ' ' )}, DEE.DEapellido1 )}, ' ' )}, DEE.DEapellido2 )} as Empleado,
	a.DEid,
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		case c.REaplicajefe  when 1 then 
		{fn concat('#LB_EvaluadoPor# ',{fn concat({fn concat({fn concat({fn concat(DEJ.DEnombre , ' ' )}, DEJ.DEapellido1 )}, ' ' )}, DEJ.DEapellido2 )})} else  'Autoevaluación' end as Evaluador
	<cfelse>
		'#LB_Autoevaluacion#' as Evaluador  
	</cfif>

	from RHRegistroEvaluadoresE  a
	inner join RHEmpleadoRegistroE b
		on a.REid = b.REid
		and a.DEid = b.DEid
		and (b.EREnojefe = 0 or b.EREnoempleado = 0)
	inner join RHRegistroEvaluacion c
		on a.REid = c.REid
	inner join DatosEmpleado DEE
		on   a.DEid =  DEE.DEid
		and a.Ecodigo = DEE.Ecodigo	
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		left outer join DatosEmpleado DEJ
			on   a.REEevaluadorj =  DEJ.DEid
			and a.Ecodigo = DEJ.Ecodigo	
	</cfif>	
	inner join LineaTiempo lt
		on lt.Ecodigo = a.Ecodigo
		and lt.DEid = a.DEid
		and c.REdesde between LTdesde and LThasta
	inner join RHPlazas pl
		on  lt .RHPid = pl.RHPid
		and   lt.Ecodigo = pl.Ecodigo
	inner join  CFuncional cf
		on   cf.CFid  = pl.CFid 
		and  cf.Ecodigo = pl.Ecodigo
		<cfif isdefined("url.CFid") and len(trim(url.CFid)) and not(isdefined("url.chkDep"))>
			and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
		<cfelseif isdefined("vsCFuncionales") and len(trim(vsCFuncionales))>
			and cf.CFid in (#vsCFuncionales#)
		</cfif>		
	inner join  Departamentos Dep
		on   cf.Dcodigo  = Dep.Dcodigo
		and  cf.Ecodigo = Dep.Ecodigo
	where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.REid#">	
		and  a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0>
			and  a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">	
		</cfif>
	
</cfquery>

<cfquery name="insertRespuestas" datasource="#session.DSN#">
	insert into ##datos( tipoid, tipo, DEid, IAEpregunta, respuestaE, respuestaJ, respuesta, TEcodigo, TEVvalor)
	select  1, '#LB_EvaluacionDeConceptos#' as  tipo,
	b.DEid, 
	case when {fn LENGTH(f.IAEpregunta)} > 0 then f.IAEpregunta else f.IAEdescripcion end as IAEpregunta,
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		convert(text,emp.TEVnombre) as respuestaE, 
		convert(text,jef.TEVnombre) as respuestaJ,
		null,
		<cf_dbfunction name="to_char" args="emp.TEcodigo">, 
		emp.TEVvalor
	<cfelse>
		null,
		null,
		convert(text,TEVnombre) as respuesta,
		null,
		g.TEVvalor
	</cfif>
	from  RHRegistroEvaluacion  a 
	inner join RHRegistroEvaluadoresE b
		on a.REid = b.REid
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0>
			and  b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">	
		</cfif>
	inner join RHEmpleadoRegistroE c
		on b.REid = c.REid
		and b.DEid = c.DEid
		<cfif isdefined("url.tipo") and url.tipo eq '2'>
			and c.EREnojefe = 0
		<cfelse>
			and c.EREnoempleado = 0
		</cfif>
	inner join RHConceptosDelEvaluador d
		   on b.REEid =d.REEid
	inner join RHIndicadoresRegistroE e
		on   d.IREid  = e.IREid 
		and e.IREevaluasubjefe = 0
		<cfif isdefined("url.tipo") and url.tipo eq '2'>
		and e.IREevaluajefe = 0
		</cfif>
	inner join RHIndicadoresAEvaluar f
			 on e.IAEid = f.IAEid
		and  f.IAEtipoconc = 'T'
	<cfif isdefined("url.tipo") and url.tipo eq '2'>	
		left outer join TablaEvaluacionValor  emp
			on e.TEcodigo = emp.TEcodigo
			and convert(char,CDERespuestae) =   emp.TEVvalor
	    left outer join TablaEvaluacionValor  jef
			on e.TEcodigo = jef.TEcodigo
			and convert(char,CDERespuestaj) =   jef.TEVvalor	
	<cfelse>
		left outer join TablaEvaluacionValor  g
			on e.TEcodigo = g.TEcodigo
			and convert(char,CDERespuestae) =   g.TEVvalor
	</cfif>	
	where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
			and a.REaplicajefe = 1
			and ( a.REaplicaempleado = 0 or  a.REaplicaempleado = 1)
		<cfelse>
			and a.REaplicaempleado = 1
		</cfif>
	and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.REid#">
</cfquery>		

<cfquery name="insertRespuestas" datasource="#session.DSN#">
	insert into ##datos( tipoid, tipo, DEid, IAEpregunta, respuestaE, respuestaJ, respuesta, TEcodigo, TEVvalor)
	<!--- ****************************************************************************************** --->
	select  2, '#LB_EvaluacionDeJefaturas#' as  tipo,
	b.DEid, 
	case when {fn LENGTH(f.IAEpregunta)} > 0 then f.IAEpregunta else f.IAEdescripcion end as IAEpregunta,
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		convert(text,emp.TEVnombre) as respuestaE, 
		convert(text,jef.TEVnombre) as respuestaJ,
		null,
		<cf_dbfunction name="to_char" args="emp.TEcodigo">, 
		emp.TEVvalor
	<cfelse>
		null,
		null,
		convert(text,TEVnombre) as respuesta, 
		null,
		g.TEVvalor
	</cfif>
	from  RHRegistroEvaluacion  a 
	inner join RHRegistroEvaluadoresE b
		on a.REid = b.REid
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0>
			and  b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">	
		</cfif>
	inner join RHEmpleadoRegistroE c
		on b.REid = c.REid
		and b.DEid = c.DEid
		<cfif isdefined("url.tipo") and url.tipo eq '2'>
			and c.EREnojefe = 0
		<cfelse>
			and c.EREnoempleado = 0
		</cfif>
	inner join RHConceptosDelEvaluador d
		   on b.REEid =d.REEid
	inner join RHIndicadoresRegistroE e
		on   d.IREid  = e.IREid 
		and e.IREevaluasubjefe = 1
	inner join RHIndicadoresAEvaluar f
			 on e.IAEid = f.IAEid
		and  f.IAEtipoconc = 'T'
	<cfif isdefined("url.tipo") and url.tipo eq '2'>	
		left outer join TablaEvaluacionValor  emp
			on e.TEcodigo = emp.TEcodigo
			and convert(char,CDERespuestae) =   emp.TEVvalor
	    left outer join TablaEvaluacionValor  jef
			on e.TEcodigo = jef.TEcodigo
			and convert(char,CDERespuestaj) =   jef.TEVvalor	
	<cfelse>
		left outer join TablaEvaluacionValor  g
			on e.TEcodigo = g.TEcodigo
			and convert(char,CDERespuestae) =   g.TEVvalor
	</cfif>	
	where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.tipo") and url.tipo eq '2'>
			and a.REaplicajefe = 1
			and ( a.REaplicaempleado = 0 or  a.REaplicaempleado = 1)
		<cfelse>
			and a.REaplicaempleado = 1
		</cfif>
	and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.REid#">	
</cfquery>	

<cfquery name="insertRespuestas" datasource="#session.DSN#">

	insert into ##datos( tipoid, tipo, DEid, IAEpregunta, respuestaE, respuestaJ, respuesta, TEcodigo, TEVvalor)
	<!--- ****************************************************************************************** --->
	select  3,  '#LB_OtrasEvaluaciones#' as  tipo,
	b.DEid, 
	case when {fn LENGTH(f.IAEpregunta)} > 0 then f.IAEpregunta else f.IAEdescripcion end as IAEpregunta,
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		CDERespuestae as respuestaE, 
		CDERespuestaj as respuestaJ,
		null,
		null,
		null  
	<cfelse>
		null,
		null,
		CDERespuestae as respuesta,
		null,
		IAEcodigo
	</cfif>	
	from  RHRegistroEvaluacion  a 
	inner join RHRegistroEvaluadoresE b
		on a.REid = b.REid
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0>
			and  b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">	
		</cfif>
	inner join RHEmpleadoRegistroE c
		on b.REid = c.REid
		and b.DEid = c.DEid
		<cfif isdefined("url.tipo") and url.tipo eq '2'>
			and c.EREnojefe = 0
		<cfelse>
			and c.EREnoempleado = 0
		</cfif>
	inner join RHConceptosDelEvaluador d
		   on b.REEid =d.REEid
	inner join RHIndicadoresRegistroE e
		on   d.IREid  = e.IREid 
	inner join RHIndicadoresAEvaluar f
			 on e.IAEid = f.IAEid
		and  f.IAEtipoconc != 'T'
	where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
			and a.REaplicajefe = 1
			and ( a.REaplicaempleado = 0 or  a.REaplicaempleado = 1)
		<cfelse>
			and a.REaplicaempleado = 1
		</cfif>
	and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.REid#">	

</cfquery>

<cfif isdefined("url.tipo") and url.tipo eq '2'>
	<cfquery name="rsOtros" datasource="#session.DSN#">
		insert into ##datos( tipoid, tipo, DEid, IAEpregunta, respuestaE, respuestaJ, respuesta, TEcodigo, TEVvalor)
		<!--- ****************************************************************************************** --->
		select  5,  '#LB_LogrosObtenidos#' as  tipo,
		DEid,'',null,null,null,null,null  
		from RHEmpleadoRegistroE
	</cfquery>		
	<cfquery name="rsOtros" datasource="#session.DSN#">
		insert into ##datos( tipoid, tipo, DEid, IAEpregunta, respuestaE, respuestaJ, respuesta, TEcodigo, TEVvalor)
		<!--- ****************************************************************************************** --->
		select  6,  '#LB_RetosYPlanesDeAccion#' as  tipo,
		DEid,'',null,null,null,null,null  
		from RHEmpleadoRegistroE
	</cfquery>
</cfif>

<cfquery name="rsRespuestas" datasource="#session.DSN#">
	select 	a.tipoid, 
			a.tipo, 
			a.DEid, 
			coalesce(a.TEcodigo,'#LB_NoUsaTabla#') as TEcodigo, 
			a.TEVvalor, 
			a.IAEpregunta, 
			a.respuestaE, 
			a.respuestaJ, 
			a.respuesta,
			b.TEnombre
	from  ##datos a
	
	left outer join TablaEvaluacion b
	on b.TEcodigo = convert(numeric,a.TEcodigo)
	
	order by a.DEid, a.tipoid, a.IAEpregunta,a.TEcodigo,TEVvalor
</cfquery>

<cfquery name="rsReporte" dbtype="query">
	select	REdescripcion,
			REdesde,
			REhasta,
			puesto, 
			centrofuncional,
			Departamento,
			Empleado,
			rsInfoEmpleados.DEid,
			Evaluador,  
			tipo,
			tipoid,
			IAEpregunta,
			TEcodigo,
			TEnombre,
			TEVvalor,
			<cfif isdefined("url.tipo") and url.tipo eq '2'>
				respuestaE,
				respuestaJ
			<cfelse>
				respuesta
			</cfif>

	from rsInfoEmpleados , rsRespuestas

	where rsInfoEmpleados.DEid = rsRespuestas.DEid

	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		order by DEid,tipoid,IAEpregunta,TEcodigo,TEVvalor
	<cfelse>
		order by DEid,tipoid,IAEpregunta,TEcodigo,TEVvalor
	</cfif>

</cfquery>

<cfquery name="Request.rsTablas" datasource="#session.DSN#">
	select a.TEcodigo, b.TEnombre, a.TEVnombre, a.TEVvalor, a.TEVequivalente
	from TablaEvaluacionValor a
	
	inner join TablaEvaluacion b
	on b.TEcodigo=a.TEcodigo
	and b.Ecodigo=<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	where exists ( 	select 1
					from ##datos d
					where <cf_dbfunction name="to_number" args="d.TEcodigo"> = a.TEcodigo )
</cfquery>



<cfif rsReporte.recordcount gt 0>
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		<!--- <cfinclude template="ReporteEval180Jefe.cfm"> --->
		<cfreport format="#url.formato#" template= "ResultadoEval180Jefe.cfr" query="rsReporte">
			<cfreportparam name="empresa" value="#session.enombre#">
		</cfreport>	
	<cfelse>
		<cfreport format="#url.formato#" template= "ResultadoEval180Auto.cfr" query="rsReporte">
			<cfreportparam name="empresa" value="#session.enombre#">
		</cfreport>	
	</cfif>

	<!---<cfdump var="#rsReporte#">--->

<cfelse>

<!--- OJOOOO SI SE SELECCIONA UNA PERSONA EN PARTICULAR VALIDAR QUE EN LA 
RELACION NO ESTE CHEQUEADO COMO NO EVALUAR  --->
<!--- OJOOOO SI SE SELECCIONA UNA PERSONA y UN CENTRO FUNCIONAL VER SI SON IGUALES  --->

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno"
	Default="Reportes de Retroalimentación - Evaluación del Desempeño"
	returnvariable="LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno"/>	
	<cfoutput>
		<cf_templateheader title="#LB_RecursosHumanos#">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno#'>
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="10%" align="center" cellpadding="2" cellspacing="0">
					<tr><td colspan="2" align="center" style="padding:8px;" nowrap="nowrap"><strong><font size="2">#LB_ReportesDeRetroalimentacionEvaluacionDelDesempenno#</font></strong></td></tr>
					<!--- <tr>
						<td align="left" nowrap="nowrap"><strong>Rango de fechas:</strong></td>
						<td align="left" nowrap="nowrap"> del #LSDateformat(vDesde, 'dd/mm/yyyy')# al #LSDateformat(vHasta, 'dd/mm/yyyy')#</td>
					</tr> --->
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center" colspan="2"><cfoutput>#LB_NoSeEncontraronRegistros#</cfoutput></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
		<cf_templatefooter>
	</cfoutput>	
</cfif>










