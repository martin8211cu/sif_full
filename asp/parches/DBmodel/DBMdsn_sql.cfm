<cfif isdefined("url.op")>
	<cfif url.op EQ 1>
		<cflocation url="DBMdsn.cfm?IDmod=#url.IDmod#">
	<cfelseif url.op EQ 2>
		<cfquery name="rsSQL" datasource="asp">
			select s.IDsch, s.sch
			  from DBMmodelos m
				inner join DBMsch s
				 on s.IDsch = m.IDsch
			 where IDmod	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
		</cfquery>
		<cfset LvarIDsch = rsSQL.IDsch>
		<cfset LvarSch = rsSQL.sch>

		<cfquery name="rsSQL" datasource="asp">
			select IDdsn, activo, IDverUlt
			  from DBMdsn
			 where IDmod	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
			   and dsn		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(url.dsn)#">
		</cfquery>
		<cfif rsSQL.recordcount EQ 0>
			<cfquery datasource="asp">
				insert into DBMdsn (IDmod, dsn, activo)
				values (#url.IDmod#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(url.dsn)#">, 0)
			</cfquery>
			<cfquery name="rsSQL" datasource="asp">
				select IDdsn, activo, IDverUlt
				  from DBMdsn
				 where IDmod	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
				   and dsn		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(url.dsn)#">
			</cfquery>
		</cfif>
		<cfset LvarIDdsn = rsSQL.IDdsn>
		<cfset LvarActivo = rsSQL.activo>
		<cfset LvarIDverUlt = rsSQL.IDverUlt>

		<cfif listFind('asp,aspmonitor,aspsecure,sifpublica,sifinterfaces,sifcontrol',lcase(url.dsn))>
			<cfif lcase(url.dsn) NEQ lcase(LvarSch)>
				<cfthrow message="El DSN '#url.dsn#' pertenece a otro Schema">
			</cfif>
			<cfquery datasource="asp">
				update DBMdsn 
				   set activo = case when activo=1 then 0 else 1 end
				 where IDdsn = #LvarIDdsn#
			</cfquery>
		<cfelse>
			<cfif LvarActivo EQ "1" AND LvarIDverUlt EQ 0>
				<cfquery datasource="asp">
					delete from DBMgen 
					 where IDdsn = #LvarIDdsn#
				</cfquery>
				<cfquery datasource="asp">
					delete from DBMdsn 
					 where IDdsn = #LvarIDdsn#
				</cfquery>
			<cfelseif LvarActivo EQ "1">
				<cfquery datasource="asp">
					update DBMdsn 
					   set activo = 0
					 where IDdsn = #LvarIDdsn#
				</cfquery>
			<cfelse>
				<cfquery name="rsSQL" datasource="asp">
					select count(1) as cantidad
					  from DBMdsn d
						inner join DBMmodelos m
						 on m.IDmod = d.IDmod
					 where d.dsn		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(url.dsn)#">
					   and m.IDsch <> #LvarIDsch#
					   and d.activo = 1
				</cfquery>
				<cfif rsSQL.cantidad NEQ 0>
					<cfthrow message="El DSN '#url.dsn#' pertenece a otro Schema">
				</cfif>
				<cfif LvarActivo EQ "0">
					<cfquery datasource="asp">
						update DBMdsn 
						   set activo = 1
						 where IDdsn = #LvarIDdsn#
					</cfquery>
				<cfelse>
					<cfquery datasource="asp">
						insert into DBMdsn (IDmod, dsn, activo)
						values (#url.IDmod#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(url.dsn)#">, 1)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	<cfelseif url.op EQ 3>
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
		<cfinvokeargument name="refresh" value="yes">
		</cfinvoke>
	</cfif>
	<cflocation url="DBMdsn.cfm?IDmod=#url.IDmod#&x=#getTickCount()#">
</cfif>
<cflocation url="DBMdsn.cfm">