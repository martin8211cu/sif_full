<!--- AGREGA LISTA DE EMPLEADOS, LISTA DE ITEMS A EVALUAR, Y LISTA DE EVALUADORES  A UNA RELACION DE EVALUACION
	Notas:
		1. Como los items a evaluar están asociadas a conocimientos y habilidades y los conocimientos y habilidades están asociados 
			a cada puesto se agreagan los registro por Puesto, es decir, se recorre  una lista con los puestos a evaluar y se agregan
			todoos los Empleados de ese puesto y los items a evaluar para cada empleado, y los evaluadores para cada empleado, los 
			evaluadores que se agregan son el mismo empleado y el jefe.
 --->
<!--- Query para saber si se usa Cuestionario específico (Si es especifico no se llena la  tabla RHNotasEvalDes
o Cuestionario por habilidades si se llena la tabla RHNotasEvalDes ---->
<cfquery name="rsPCid" datasource="#session.DSN#">
	select PCid 
	from RHEEvaluacionDes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
</cfquery>

<cfset DEBUG=FALSE>
<cfsetting requesttimeout="36000">
<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.CFIDLIST" type="string" default="">
<cfparam name="FORM.ODIDLIST" type="string" default="">
<cfparam name="FORM.EMPLEADOIDLIST" type="string" default="">
<cfparam name="FORM.PUESTOIDLIST" type="string" default="">
<cfparam name="FORM.OPT" type="numeric" default="0"><!--- 0 = Centro Funcional, 1 = Oficina / Departamento--->
<cfparam name="FORM.PARAMS" type="string" default="">
<cfparam name="FORM.FECHA" type="string" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
<cfif isdefined("FORM.DEID") and len(trim(FORM.DEID)) eq 0><cfset FORM.DEID = 0></cfif>
<cfparam name="FORM.DEID" type="numeric" default="0">
<cfparam name="FORM.DEIDLIST" type="string" default="">

<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		set nocount on
		select CFid, #nivel# as nivel, null as CFidresp
		from CFuncional
		where CFid = #arguments.cfid#
		set nocount off
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		set nocount on
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = #session.Ecodigo#
		set nocount off
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

<cffunction name="convertListItemsToString" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset arrstr[i] = "'" & arr[i] & "'">
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>

<cffunction name="processpuesto" returntype="string">
	<cfargument name="list" type="string">
	<cfreturn convertListItemsToString(list)>
</cffunction>

<cffunction name="processod" returntype="string">
	<cfargument name="list" type="string">
	<cfreturn convertListItemsToString(list)>
</cffunction>

<cffunction name="processcf" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset cf = ListToArray(arr[i],'|')>
		<cfif cf[2] eq 1>
			<cfset cfs = getCentrosFuncionalesDependientes(cf[1])>
			<cfloop query="cfs">
				<cfset ArrayAppend(arrstr,cfid)>
			</cfloop>
		<cfelse>
			<cfset ArrayAppend(arrstr,cf[1])>
		</cfif>
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>

<cffunction name="getListaEmpleados" returntype="query">
	<cfargument name="fecha" required="no" type="string" default="#FORM.FECHA#">
	<cfargument name="opt" required="no" type="numeric" default="#FORM.OPT#">
	<cfargument name="cfidlist" required="no" type="string" default="#FORM.CFIDLIST#">
	<cfargument name="odidlist" required="no" type="string" default="#FORM.ODIDLIST#">
	<cfargument name="empleadoidlist" required="no" type="string" default="#FORM.EMPLEADOIDLIST#">
	<cfargument name="puestoidlist" required="no" type="string" default="#FORM.PUESTOIDLIST#">
	<cfargument name="deid" required="no" type="numeric" default="#FORM.DEID#">
	<cfargument name="deidlist" required="no" type="string" default="#FORM.DEIDLIST#">
	
	<cfquery name="rs" datasource="#session.dsn#">
		set nocount on
		select a.DEid IDEmpleado, 
		  Jefe = (select min(l.DEid) from LineaTiempo l where l.RHPid = c.RHPid and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(FORM.FECHA,'YYYYMMDD')#"> between l.LTdesde and l.LThasta), 
		  Jefe2= (select min(l.DEid) from LineaTiempo l where l.RHPid = c2.RHPid and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(FORM.FECHA,'YYYYMMDD')#"> between l.LTdesde and l.LThasta),
		  c.CFidresp, a.RHPid, c.RHPid, a.RHPcodigo
		from LineaTiempo a, RHPlazas b, CFuncional c, CFuncional c2
		where <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(FORM.FECHA,'YYYYMMDD')#"> between a.LTdesde and a.LThasta
		  and a.RHPid = b.RHPid 
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and b.Ecodigo = c.Ecodigo
		  and b.CFid = c.CFid
		  and c.CFidresp *= c2.CFid
		  <cfif arguments.deid gt 0>
		    and a.DEid = #arguments.deid#
		  </cfif>
		  <cfif len(trim(arguments.deidlist)) gt 0>
		  	and a.DEid in (#arguments.deidlist#)
		  </cfif>		  
		  <cfif len(trim(arguments.empleadoidlist)) gt 0>		  	
			and a.DEid in (#arguments.empleadoidlist#)
		  </cfif>		
		  <cfif len(trim(arguments.puestoidlist)) gt 0>
		    and a.RHPcodigo in (#processpuesto(arguments.puestoidlist)#)
		  </cfif>
		  <cfif arguments.opt eq 0>
		    <cfif len(trim(arguments.cfidlist)) gt 0>
		    and c.CFid in (#processcf(arguments.cfidlist)#)
		    </cfif>
		  <cfelse>
		  	<cfif len(trim(arguments.odidlist)) gt 0>
			<!--- and (convert(varchar,c.Ocodigo) + '|' + convert(varchar,c.Dcodigo)) in (#processod(arguments.odidlist)#) --->
			and {fn concat(convert(varchar,c.Ocodigo),{fn concat('|',convert(varchar,c.Dcodigo))})} in (#processod(arguments.odidlist)#)
			</cfif>
		  </cfif>
	  set nocount off
	</cfquery>
	<cfreturn rs>
</cffunction>

<cftransaction>

<cfset RSEMPL = getListaEmpleados()>

<cfif RSEMPL.RECORDCOUNT>
	<cfloop query="RSEMPL">
		<!--- JUSTIFICACION DEL "IF NOT EXISTS"
				Si el empleado ya fue agregado en esta lista, ya fueron agregados los demás datos también, en un momento determinado,
				con ciertos criterios determinados, y estos podrían haber cambiado hasta este momento, pero si genero varias veces, 
				se espera que la razón sea agregar mas empleados a la evaluación y regenerar los datos porque cambiaron los criterios.
				Si se determina que es común regenerar los criterios durante el proceso de agregar empleados a la evaluación se debe 
				desarrollar un comportamiento que permita esta acción.
				Resumen: Actualmente en este proceso se pregunta si existe la persona en la tabla RHListaEvalDes, si existe no se inserta
				ningún registro ni en esta tabla ni en las demás tablas involucradas (RHEvaluadoresDes, RHNotasEvalDes), esto implica que
				si se cambiaron los items de evaluacion estos no se van a actualizar para los empleados agregados previamente. Solo los 
				empleados que se están agregando nuevos reflejarán los nuevos items.
		--->

		<cfquery name="ABC_CFC_INSERTA" datasource="#Session.DSN#">
			set nocount on
			
			if not exists ( select 1 from RHListaEvalDes where RHEEid = #FORM.RHEEID# and DEid = #RSEMPL.IDEmpleado# )
				insert into RHListaEvalDes 
				(RHEEid, DEid, RHPcodigo, Ecodigo, promglobal, RHLEnotajefe, RHLEnotaauto, RHLEpromotros)
				values (#FORM.RHEEID#, #RSEMPL.IDEmpleado#, '#RSEMPL.RHPcodigo#', #SESSION.ECODIGO#, null, null, null, null)

			if not exists ( select 1 from RHEvaluadoresDes where RHEEid = #FORM.RHEEID# and DEid = #RSEMPL.IDEmpleado# and DEideval = #RSEMPL.IDEmpleado# )
				insert into RHEvaluadoresDes 
				(RHEEid, DEid, DEideval, RHEDtipo)
				values (#FORM.RHEEID#, #RSEMPL.IDEmpleado#, #RSEMPL.IDEmpleado#, 'A')
			
			<cfif LEN(TRIM(RSEMPL.JEFE)) gt 0 AND RSEMPL.JEFE NEQ RSEMPL.IDEmpleado>
				if not exists ( select 1 from RHEvaluadoresDes where RHEEid = #FORM.RHEEID# and DEid = #RSEMPL.IDEmpleado# and DEideval = #RSEMPL.JEFE# )
					insert into RHEvaluadoresDes 
					(RHEEid, DEid, DEideval, RHEDtipo)
					values (#FORM.RHEEID#, #RSEMPL.IDEmpleado#, #RSEMPL.JEFE#, 'J')
			<cfelseif LEN(TRIM(RSEMPL.JEFE2)) gt 0 AND RSEMPL.JEFE2 NEQ RSEMPL.IDEmpleado>
				if not exists ( select 1 from RHEvaluadoresDes where RHEEid = #FORM.RHEEID# and DEid = #RSEMPL.IDEmpleado# and DEideval = #RSEMPL.JEFE2# )
					insert into RHEvaluadoresDes 
					(RHEEid, DEid, DEideval, RHEDtipo)
					values (#FORM.RHEEID#, #RSEMPL.IDEmpleado#, #RSEMPL.JEFE2#, 'J')
			</cfif>		
	
			<cfif isdefined("rsPCid.PCid") and not len(trim(rsPCid.PCid))>
				if not exists ( select 1 from RHNotasEvalDes where RHEEid = #FORM.RHEEID# and DEid = #RSEMPL.IDEmpleado# )
				begin
					insert into RHNotasEvalDes 
					(RHEEid, DEid, RHCid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso)
					select #FORM.RHEEID#, #RSEMPL.IDEmpleado#, a.RHCid, null, null, null, null, null
					from RHConocimientos a, RHConocimientosPuesto b
					where a.RHCid = b.RHCid
					and b.RHPcodigo = '#RSEMPL.RHPcodigo#'
					and b.Ecodigo = #SESSION.ECODIGO#
	
					insert into RHNotasEvalDes 
					(RHEEid, DEid, RHHid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso)
					select distinct #FORM.RHEEID#, #RSEMPL.IDEmpleado#, a.RHHid, null, null, null, null, null
					from RHHabilidades a, RHHabilidadesPuesto b
					where a.RHHid = b.RHHid
						and a.Ecodigo = b.Ecodigo
						and b.RHPcodigo = '#RSEMPL.RHPcodigo#'
						and b.Ecodigo = #SESSION.ECODIGO#
				end
			</cfif>
			
			update RHEEvaluacionDes set RHEEestado = 1 where RHEEid = #FORM.RHEEID# and RHEEestado = 0
			
			set nocount off
		</cfquery>
<!----
	insert RHNotasEvalDes 
	(RHEEid, DEid, RHICid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso)
	select #FORM.RHEEID#, #RSEMPL.IDEmpleado#, RHICid, null, null, null, null, null
	from RHIConocimiento a, RHConocimientosPuesto b
	where a.RHCid = b.RHCid
	and b.RHPcodigo = '#RSEMPL.RHPPUESTO#'
	and b.Ecodigo = #SESSION.ECODIGO#

	insert RHNotasEvalDes 
	(RHEEid, DEid, RHIHid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso)
	select #FORM.RHEEID#, #RSEMPL.IDEmpleado#, RHIHid, null, null, null, null, null
	from RHIHabilidad a, RHHabilidadesPuesto b, RHPreguntasCompetencia c
	where a.RHHid = b.RHHid
	and b.RHHid = c.idcompetencia
	and b.Ecodigo = c.Ecodigo
	and c.RHPCtipo = 'H'
	and b.RHPcodigo = '#RSEMPL.RHPPUESTO#'
----->
	</cfloop>
</cfif>

<CFIF DEBUG>
	<cfdump var="#RSEMPL#">
	<cfquery name="rsRHEEvaluacionDes" datasource="#Session.DSN#">
		select * from RHEEvaluacionDes where RHEEid = #FORM.RHEEID#
	</cfquery>
	<cfdump var="#rsRHEEvaluacionDes#">
	<cfquery name="rsRHListaEvalDes" datasource="#Session.DSN#">
		select * from RHListaEvalDes where RHEEid = #FORM.RHEEID# <cfif FORM.DEID gt 0> and DEid = #FORM.DEID#</cfif> <cfif len(trim(FORM.DEIDLIST)) gt 0> and DEid in (#FORM.DEIDLIST#)</cfif>
	</cfquery>
	<cfdump var="#rsRHListaEvalDes#">
	<cfquery name="rsRHEvaluadoresDes" datasource="#Session.DSN#">
		select * from RHEvaluadoresDes where RHEEid = #FORM.RHEEID#  <cfif FORM.DEID gt 0> and DEid = #FORM.DEID#</cfif> <cfif len(trim(FORM.DEIDLIST)) gt 0> and DEid in (#FORM.DEIDLIST#)</cfif> order by RHEDtipo
	</cfquery>
	<cfdump var="#rsRHEvaluadoresDes#">
	<cfquery name="rsRHNotasEvalDes" datasource="#Session.DSN#">
		select * from RHNotasEvalDes where RHEEid = #FORM.RHEEID# <cfif FORM.DEID gt 0> and DEid = #FORM.DEID#</cfif> <cfif len(trim(FORM.DEIDLIST)) gt 0> and DEid in (#FORM.DEIDLIST#)</cfif>
	</cfquery>
	<cfdump var="#rsRHNotasEvalDes#">
	<cftransaction action = "rollback"/>
	<cfabort>
</CFIF>

</cftransaction>

<cfif isdefined("FORM.BTNGENERAREMPL") and FORM.BTNGENERAREMPL eq 1>
	<!--- ES INCLUIDO DESDE EL ARCHIVO REGISTRO_CRITERIOS_EMPLEADOS_LISTA_SQL, EL CONTINUA LA EJECUCION--->
<cfelse>
	<cflocation url="registro_evaluacion.cfm?RHEEid=#FORM.RHEEID#&SEL=3">
</cfif>

<!--- ESTA FUNCION HACE LO MISMO QUE LA QUE SE ESTÁ USANDO PERO LO HACE DEL LADO DE SYBASE 
** UNOS MILISEGUNDOS MAS RÁPIDO PERO HACE USO DE UNA TABLA TEMPORAL NO SE ACOSTUMBRA **
<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfquery name="rs" datasource="#session.dsn#">
		set nocount on
		if exists(select 1 from sysobjects where name = '##cfuncional') drop table ##cfuncional
		create table ##cfuncional (cfid numeric, nivel int, cfidresp numeric null)
		insert ##cfuncional (cfid, nivel, cfidresp) select #arguments.cfid#, 1, null
		declare @nivel int, @fi datetime
		select @nivel = 1
		while (1=1) begin
			insert ##cfuncional (cfid, nivel, cfidresp)
			select CFid, @nivel + 1, CFidresp
			from ##cfuncional a, CFuncional b
			where a.nivel = @nivel
			   and b.CFidresp = a.cfid
		
			if @@rowcount = 0 break
		
			select @nivel = @nivel + 1
		end
		select * from ##cfuncional order by nivel
		drop table ##cfuncional
		set nocount off
	</cfquery>
	<cfreturn rs>
</cffunction>
--->