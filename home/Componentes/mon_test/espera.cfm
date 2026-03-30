<cfif IsDefined('url.qti')>
	Quitar Threads Inactivos...
	<cfinvoke component="home.Componentes.aspmonitor" method="QuitarThreadsInactivos" />
	Listo
<cfelseif IsDefined('url.borrar')>
	Borrar Estructuras...
	<cfset StructDelete(server,'monitor_accesos')>
	<cfset StructDelete(server,'monitor_thread')>
	Listo
<cfelseif IsDefined('url.gc')>
	Recoger la basura...
	<cfset CreateObject("java","java.lang.System").gc()>
	Listo
<cfelseif IsDefined('url.sec')>
	<cfparam name="url.sec" default="5">
	<cfparam name="url.loc" default="0">
	<cfoutput>
	
		Soy #Request.MonPacket.ThreadName#<br />
		Son las # TimeFormat(Now(), 'hh:mm:ss')#<br />
		Estoy esperando #url.sec# segundos...
		(loc=# HTMLEditFormat( url.loc )#)
		#RepeatString(' ', 500)#
	</cfoutput>
	<cfflush>
	<cfset thr = CreateObject("java", "java.lang.Thread")>
	<cfset thr.sleep( JavaCast('long', url.sec*1000))>
	<cfoutput><br />Listo
	</cfoutput>
	
	<cfif url.loc>
		<cflocation url="espera.cfm?sec=0">
	</cfif>
<cfelse>
	Qué hago?
</cfif>
