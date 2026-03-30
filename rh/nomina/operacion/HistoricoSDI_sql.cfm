<cfif isdefined('form.BTNEliminar')>
    <cfquery name="rsDelHistorico" datasource="#session.DSN#">
        delete from RHHistoricoSDI
        where
			RHHaplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
		and RHHfuente = <cfqueryparam cfsqltype="cf_sql_numeric" value="2">
    </cfquery>
</cfif>

<cfif isdefined('form.BTNAplicar')>
    <cftransaction>
        <cfquery name="rsUpdateDE" datasource="#session.dsn#">
            update DatosEmpleado
			set DEsdi =  coalesce((select a.RHHmonto from RHHistoricoSDI a
									where a.DEid = DatosEmpleado.DEid
									and RHHaplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
									and RHHfuente = <cfqueryparam cfsqltype="cf_sql_numeric" value="2">
									and a.Ecodigo = DatosEmpleado.Ecodigo
									and RHHperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHperiodo1#">
									and RHHmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHmes1#">),0)
            where
				DatosEmpleado.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DatosEmpleado.DEid in (select a.DEid from RHHistoricoSDI a
										where a.DEid = DatosEmpleado.DEid
										and RHHaplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
										and RHHfuente = <cfqueryparam cfsqltype="cf_sql_numeric" value="2">
									  )
        </cfquery>

        <cfquery name="rsUpdateDE" datasource="#session.dsn#">
            update
				RHHistoricoSDI
			set RHHaplicado  =  1
			where
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHHaplicado = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			and RHHfuente = <cfqueryparam cfsqltype="cf_sql_numeric" value="2">
			and RHHperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHperiodo1#">
			and RHHmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHmes1#">
        </cfquery>

    </cftransaction>
</cfif>


<cflocation url="CalculoSDI-lista.cfm">