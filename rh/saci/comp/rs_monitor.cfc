<cfcomponent>
	<cffunction name="monitor" access="public" returntype="void">
		<cfargument name="datasource" type="string" required="yes">
		
		<cfquery datasource="#arguments.datasource#" name="ISBrsServidor">
			select nombreRS, nombreASE, nombreRSSD, datasource
			from ISBrsServidor
			where activo = 1
		</cfquery>
		<cfquery datasource="#arguments.datasource#" name="fecha">
			select getdate() as EVfecha
		</cfquery>
		
		<cfloop query="ISBrsServidor">
		
			<cfquery datasource="#ISBrsServidor.datasource#" name="free_space">
				select
					usage = convert(varchar(20), m.description),
					sizeMB = sum (size * (
						select  (v.low)
						from master.dbo.spt_values v
						 where v.number = 1
						 and v.type = 'E' ) / 1048576),
					freeMB = sum (curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) * (
						select (v.low)
						from master.dbo.spt_values v
						where v.number = 1
						  and v.type = 'E' ) / 1048576)
					from master.dbo.sysusages u,
					 master.dbo.sysdevices v,
					 master.dbo.spt_values b,
					 master.dbo.sysmessages m
					where u.dbid = db_id()
						and vstart between v.low and v.high 
						and v.status & 2 = 2 
						and b.type = 'S'
						and u.segmap & 7 = b.number
						and b.msgnum = m.error
						and isnull(m.langid, 0) = 0
					group by convert(varchar(20), m.description)
			</cfquery>
			<cfquery datasource="#ISBrsServidor.datasource#" name="log_free">
				select (lct_admin('logsegment_freepages', db_id()) -
						lct_admin('reserved_for_rollbacks', db_id()) )
						* v.low / 1048576 as logfreeMB
				from master.dbo.spt_values v
				where v.number = 1
				and v.type = 'E' 
			</cfquery>
			<cfquery datasource="#ISBrsServidor.datasource#" name="sd_space">
				select sum(num_segs) as num_segs, sum(allocated_segs) as allocated_segs
				from rs_diskpartitions
				where status = 1
			</cfquery>
			<cfset  datTotalMB = 0>
			<cfset  datDispMB = 0>
			<cfset  logTotalMB = 0>
			<cfset  logDispMB = log_free.logfreeMB>
			<cfloop query="free_space">
				<cfif FindNoCase('log only', usage)>
					<!--- log only --->
					<cfset logTotalMB = logTotalMB + free_space.sizeMB>
				<cfelse>
					<!--- data only / data and log --->
					<cfset datTotalMB = datTotalMB + free_space.sizeMB>
					<cfset datDispMB = datDispMB + free_space.freeMB>
				</cfif>
			</cfloop>
		
			<cfquery datasource="#ISBrsServidor.datasource#" name="status">
				<!--- Used by the Dsi (outbound queue): --->
				select 'out' as dsitype, dsname+'.'+dbname as dsi, count(db.dbname) as space_used, db.dist_status
				from rs_segments seg, rs_databases db
				where seg.q_number = db.dbid and seg.q_type = 0 and
				seg.q_number <= 16777317 and seg.used_flag > 0 group by db.dsname,db.dbname
				
				union
				
				<!---Used by the Dsi (inbound queue) --->
				select 'in' as dsitype, dsname+'.'+ dbname as dsi, count(db.dbname) as space_used, db.dist_status
				from rs_segments seg, rs_databases db
				where seg.q_number = db.dbid and seg.q_type = 1 and
				seg.q_number <= 16777317 and seg.used_flag > 0 group by db.dsname,db.dbname
				
				union
				
				<!--- Used by the route (RSI) --->
				select 'rsi' as dsitype, si.name as dsi, count(si.name) space_used, 1-rs.suspended as dist_status
				from rs_segments seg, rs_sites si, rs_routes rs
				where seg.q_number = si.id and seg.q_number >= 16777317
				and seg.used_flag > 0 and si.id = rs.dest_rsid group by si.name,rs.suspended
				
				order by 1
			</cfquery>
			
			<cfset dsiUP = 0>
			<cfset dsiDN = 0>
			<cfloop query="status">
				<cfif status.dist_status EQ 1>
					<cfset dsiUP = dsiUP + 1>
				<cfelse>
					<cfset dsiDN = dsiDN + 1>
				</cfif>
			</cfloop>
			
			<cfquery datasource="#arguments.datasource#">
				insert into ISBrsEvento (EVfecha, nombreRS, datTotalMB, datDispMB, logTotalMB, logDispMB, sdTotalMB, sdDispMB, dsiUP, dsiDN)
				values(
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha.EVfecha#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBrsServidor.nombreRS#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#datTotalMB#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#datDispMB#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#logTotalMB#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#logDispMB#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#sd_space.num_segs#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#sd_space.num_segs - sd_space.allocated_segs#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#dsiUP#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#dsiDN#">)
			</cfquery>
			<cfset myNombreRS = ISBrsServidor.nombreRS>
			<cfloop query="status">
				<cfquery datasource="#arguments.datasource#">
					insert into ISBrsEventoDSI (EVfecha, nombreRS, tipoDSI, nombreDSI, espacio, activo)
					values (
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha.EVfecha#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#myNombreRS#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#status.dsitype#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#status.dsi#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#status.space_used#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#status.dist_status EQ 1#">)
				</cfquery>
			</cfloop>
			
			<cfquery datasource="#arguments.datasource#">
				update ISBrsServidor
				set EVfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha.EVfecha#">
				where nombreRS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBrsServidor.nombreRS#">
			</cfquery>
			
		
		</cfloop>
		
	</cffunction>
	
	
</cfcomponent>