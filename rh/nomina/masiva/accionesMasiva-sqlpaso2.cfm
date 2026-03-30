<cfif isdefined("Form.btnAgregar")>
	<cfset signo = 1>
	<cfif isdefined("Form.negativo")>
		<cfset signo = -1>
	</cfif>
	<!--- Chequear si ya existe no lo inserta --->
	<cfquery name="checkExists" datasource="#Session.DSN#">
		select 1
		from RHComponentesAccionM
		where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
		<cfif Form.tipoaccion EQ 1 and Form.accion EQ 1>
			and RHCAMtagregar = 1
		<cfelse>
			and RHCAMtagregar = 0
		</cfif>
		<cfif Form.tipoaccion EQ 1 and (Form.accion EQ 2 or Form.accion EQ 3)>
			and RHCAMtmodificar = 1
		<cfelse>
			and RHCAMtmodificar = 0
		</cfif>
		<cfif Form.tipoaccion EQ 0>
			and RHCAMteliminar = 1
		<cfelse>
			and RHCAMteliminar = 0
		</cfif>
	</cfquery>
	
	<cfif checkExists.recordCount EQ 0>
		<cfquery name="rsInsert" datasource="#Session.DSN#">
			insert into RHComponentesAccionM(RHAid, CSid, RHCAMtagregar, RHCAMtmodificar, RHCAMmodificars, RHCAMteliminar, RHCAMvagregar, RHCAMvmodificar, Ecodigo, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">, 
				<cfif Form.tipoaccion EQ 1 and Form.accion EQ 1>1<cfelse>0</cfif>,
				<cfif Form.tipoaccion EQ 1 and (Form.accion EQ 2 or Form.accion EQ 3)>1<cfelse>0</cfif>,
				<cfif Form.tipoaccion EQ 1 and Form.accion EQ 3>1<cfelse>0</cfif>,
				<cfif Form.tipoaccion EQ 0>1<cfelse>0</cfif>,
				<cfif Form.tipoaccion EQ 1 and Form.accion EQ 1 and isdefined("Form.puntos")>
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.puntos#"> * #signo#,
				<cfelse>
					0.00,
				</cfif>
				<cfif Form.tipoaccion EQ 1 and (Form.accion EQ 2 or Form.accion EQ 3) and isdefined("Form.puntos")>
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.puntos#"> * #signo#,
				<cfelse>
					0.00,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
	</cfif>


<cfelseif isdefined("Form.RHCAMid_del") and Len(Trim(Form.RHCAMid_del))>

	<cfquery name="rsDel" datasource="#Session.DSN#">
		delete from RHComponentesAccionM
		where RHCAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCAMid_del#">
	</cfquery>

</cfif>

