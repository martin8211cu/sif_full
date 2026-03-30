<cfset params = '' >

<cfif isdefined("form.btnNuevo")>
	<cflocation url="registro_evaluacion.cfm?REid=#form.REid#&sel=4">
</cfif>
<cfif isdefined("form.Siguiente")>
	<cflocation url="registro_evaluacion.cfm?REid=#form.REid#&sel=5&Estado=#form.Estado#">
</cfif>
<cfif isdefined("form.Anterior")>
	<cflocation url="registro_evaluacion.cfm?REid=#form.REid#&sel=3&Estado=#form.Estado#">
</cfif>
<cfset params = "&Estado=#form.Estado#">
<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="insert" datasource="#session.DSN#">
		insert INTO RHGruposRegistroE( REid, GREnombre, Ecodigo, BMfechaalta, BMUsucodigo)
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GREnombre#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="insert">
	</cftransaction>
	<cfset params = params &'&GREid=#insert.identity#' >

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update RHGruposRegistroE
		set GREnombre =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GREnombre#">
		where GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
	</cfquery>	
	<cfset params = '&GREid=#form.GREid#' >
<cfelseif isdefined("form.BAJA")>
	<!--- OBTENER LOS EMPLEADOS QUE PERTENECEN A EL GRUPO QUE SE QUIERE ELIMINAR --->
	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		select c.DEid
		from RHGruposRegistroE a
		inner join RHCFGruposRegistroE b
			on b.GREid = a.GREid	
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
	<!--- VERIFICA QUE HAYA AL MENOS UN EMPLEADO DEL GRUPO PARA BORRAR. --->
	<!--- BORRAR TABLA RHConceptosDelEvaluador,RHConceptosDelEvaluador, RHCFGruposRegistroE,RHGruposRegistroE --->
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
	<!--- ELIMINAR LOS CENTROS FUNCIONALES DEL GRUPO --->
	<cfquery datasource="#session.DSN#">
		delete from RHCFGruposRegistroE
		where GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
	</cfquery>
	<!--- ELIMINAR EL GRUPO --->
	<cfquery datasource="#session.DSN#">
		delete from RHGruposRegistroE
		where GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
	</cfquery>	
</cfif>

<cflocation url="registro_evaluacion.cfm?REid=#form.REid#&sel=4#params#">