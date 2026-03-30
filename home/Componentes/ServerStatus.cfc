<cfcomponent hint="Componente que devuelve el status del server">
	<cffunction name="get" returntype="numeric">
		<!---Obtienen Memoria Libre de la JVM--->
		<cfset runtime     = CreateObject("java","java.lang.Runtime").getRuntime()>		
		<cfset MemoriaFree = Round((runtime.freeMemory() * 100 / runtime.maxMemory()))>
		
		<cfif MemoriaFree LTE 30>
			<cfreturn 9>
		</cfif>
		<!---Disponible en los procesadores de base de datos--->
		<cfquery datasource="Monitor">
			update master.dbo.spt_monitor
				set lastrun  = getdate(),
					cpu_busy = @@cpu_busy
			where datediff(ss,lastrun,@@boottime) > 0
		</cfquery>
		<cfquery name="result" datasource="Monitor">
			select
				convert(int,
				(((@@cpu_busy - cpu_busy)
				* ((@@timeticks / 1000.0) / 1000))
				/ (select count(*) from master.dbo.sysengines))) * 100
				/ (select  CASE WHEN datediff(ss, lastrun, getdate()) = 0 then 1 else datediff(ss, lastrun, getdate()) end
					from master.dbo.spt_monitor) cpu_busy
			from master.dbo.spt_monitor
		</cfquery>
		<cfif (100-result.cpu_busy) LTE 40>
			<cfreturn 9>
		</cfif>
		<cfreturn 1>
	</cffunction>
</cfcomponent>