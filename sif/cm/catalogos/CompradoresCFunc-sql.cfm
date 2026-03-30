<cfif isdefined("form.Agregar")>
	<cfquery name="checkExists" datasource="#Session.DSN#">
		select 1
		from CMCompradoresCF
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
	</cfquery>
	<cfif checkExists.recordCount EQ 0>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into CMCompradoresCF ( CFid, CMCid, CMCCFfecha, Usucodigo )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="update" datasource="#session.DSN#">
		delete from CMCompradoresCF
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
	</cfquery>
</cfif>

<cflocation url="CompradoresCFunc.cfm">