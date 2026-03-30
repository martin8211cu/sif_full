<cfif isdefined("form.ALTACF")>
	<cfif isdefined("form.dependencias")>
		<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
			CFid = "#form.CFpk#"
			Nivel = 5
			returnvariable="Dependencias"/>
		<cfset Centros = ValueList(Dependencias.CFid)>
	</cfif>
	<cfquery name="t" datasource="#session.DSN#">
		insert INTO RHCFGruposRegistroE(GREid, CFid, Ecodigo, BMfechaalta, BMUsucodigo)
		select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">,
				CFid,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		from CFuncional
		<cfif not isdefined("form.dependencias")>
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfelse>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  <!--- and CFpath like '#ruta#%' --->
			  and CFid in (#Centros#)
			  and not exists( select 1
			  				  from RHCFGruposRegistroE
							  where GREid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
							  and CFid = CFuncional.CFid )
		</cfif>
		<!------Verificar que ese cfuncional no este en ningún grupo de la evaluación----->
		  and not exists(select 1
						from RHRegistroEvaluacion a
							inner join RHGruposRegistroE b
								on a.REid = b.REid
							inner join RHCFGruposRegistroE c
								on b.GREid = c.GREid
								and CFuncional.CFid = c.CFid
						 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						 	and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#"> 
						 )
	</cfquery>
<cfelseif isdefined("form.btnEliminar")>
	<!--- OBTENER LOS EMPLEADOS QUE PERTENECEN A EL CENTRO FUNCIONAL GRUPO QUE SE QUIERE ELIMINAR --->
	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		select c.DEid
		from RHGruposRegistroE a
		inner join RHCFGruposRegistroE b
			on b.GREid = a.GREid
			and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">	
		inner join RHEmpleadoRegistroE c
			on c.REid = a.REid
		inner join LineaTiempo lt 
			on lt.Ecodigo = c.Ecodigo 
			and lt.DEid = c.DEid 
			and getDate() between lt.LTdesde and lt.LThasta 
		inner join RHPlazas p 
			on p.RHPid = lt.RHPid 
			and p.CFid = b.CFid
		where a.GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
			and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery name="rsEvaluadores" datasource="#session.DSN#">
		select c.REEid
		from RHGruposRegistroE a
		inner join RHCFGruposRegistroE b
			on b.GREid = a.GREid
			and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
		inner join RHRegistroEvaluadoresE c
			on c.REid = a.REid
		inner join LineaTiempo lt 
			on lt.Ecodigo = c.Ecodigo 
			and lt.DEid = c.DEid 
			and getDate() between lt.LTdesde and lt.LThasta 
		inner join RHPlazas p 
			on p.RHPid = lt.RHPid 
			and p.CFid = b.CFid
		where a.GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
			and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfif rsEmpleados.RecordCount>
		<cfset Lvar_listEmpleados = ValueList(rsEmpleados.DEid)>
	<cfelse>
		<cfset Lvar_listEmpleados = 0>
	</cfif>
	<cfif rsEvaluadores.RecordCount>
		<cfset Lvar_listREEid = ValueList(rsEvaluadores.REEid)>
	<cfelse>
		<cfset Lvar_listREEid = 0>
	</cfif>
	<!--- BORRAR TABLA RHConceptosDelEvaluador,RHConceptosDelEvaluador, RHGruposRegistroE, RHEmpleadoRegistroE --->
	<cfquery datasource="#session.DSN#">
		delete from RHConceptosDelEvaluador
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and REEid in (#Lvar_listREEid#)
		  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery datasource="#session.DSN#"	>
		delete from RHRegistroEvaluadoresE 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid in (#Lvar_listEmpleados#)
		  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery datasource="#session.DSN#"	>
		delete from RHEmpleadoRegistroE 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid in (#Lvar_listEmpleados#)
		  and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<!--- ELIMINAR EL CENTRO FUNCIONAL --->
	<cfquery datasource="#session.DSN#">
		delete from RHCFGruposRegistroE
		where GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
	</cfquery>
</cfif>

<cflocation url="registro_evaluacion.cfm?REid=#form.REid#&GREid=#form.GREid#&sel=4&Estado=#form.Estado#">