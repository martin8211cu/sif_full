<cf_templateheader title="Análisis de memoria">
<cf_web_portlet_start titulo="Monitor">
<cfinclude template="/home/menu/pNavegacion.cfm">


<cfset jSystem = CreateObject("java", "java.lang.System")>
<cfset runtime = CreateObject("java", "java.lang.Runtime")>
<cfset runtime = runtime.getRuntime()>
<cfset thread = CreateObject("java", "java.lang.Thread")>
<cfset array = CreateObject("java", "java.lang.reflect.Array")>
<cfset tarray = array.newInstance(thread.getClass(), thread.activeCount())>

<cfset JavaVersion = jSystem.getProperty("java.version")>
<cfset JavaVmVersion = jSystem.getProperty("java.vm.version")>
<cfset JavaVmVendor = jSystem.getProperty("java.vm.vendor")>

<cfset Ahora = Now()>

<cfset enumerateThreadCount = thread.currentThread().enumerate(tarray) >

<cfinvoke component="home.Componentes.aspmonitor" method="QuitarThreadsInactivos" ></cfinvoke>

<cfquery datasource="aspmonitor" name="defaulthost" maxrows="1">
	select c.hostname
	from MonServerProcess c
	where c.srvprocid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Application.srvprocid#">
</cfquery>

<cfparam name="url.serverhost" default="#defaulthost.hostname#">

<cfquery datasource="aspmonitor" name="hosts" maxrows="240">
	select distinct hostname, upper(hostname) as hostupper, max (last_access) as last_accessed
	from MonServerProcess
	where last_access > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-30,Now())#">
	group by upper(hostname), hostname
	order by hostupper, hostname
</cfquery>

<cfoutput>
<table border="0">
  <tr>
    <td width="1">&nbsp;</td>
    <td width="1">&nbsp;</td>
    <td width="936">&nbsp;</td>
    <td width="384">&nbsp;</td>
    <td width="110">&nbsp;</td>
    <td width="1">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" bgcolor="##CCCCCC">An&aacute;lisis de memoria </td>
    <td bgcolor="##CCCCCC" align="center">
	<cfif hosts.RecordCount GT 1>
	<form id="form2svr" name="form2svr" method="get" action="." style="margin:0">
      Servidor:
	  <select name="serverhost" onchange="this.form.submit()">
	  <cfloop query="hosts">
	  <option value="# HTMLEditFormat ( hostname ) #" <cfif url.serverhost EQ hostname>selected</cfif>>
	  <cfif defaulthost.hostname EQ hostname>&gt;&gt;</cfif>
	  # HTMLEditFormat ( hostname ) #
	  <cfif defaulthost.hostname EQ hostname>[local]
	  <cfelseif DateDiff('n', last_accessed, Now()) GT 60>
	  	<cfset inact = DateDiff('n', last_accessed, Now())>
	  	(
		<cfif inact GE 60*24>
		#Int (inact / 60 / 24) #d # Int(inact / 60) Mod 24 #h
		<cfelse>
		# Int(inact / 60) Mod 24 #:# NumberFormat( inact Mod 60, '00' )#</cfif> inactivo )
	  </cfif>
	  
	  </option>
	</cfloop>
	  </select>
        </form>
		</cfif>
    </td>
    <td bgcolor="##CCCCCC" align="right">
	<cfif url.serverhost EQ defaulthost.hostname>
	<cfform name="form1" id="form1" method="post" action="." style="margin:0">
      <cfinput type="submit" value="Liberar Memoria" name="liberar">
    </cfform></cfif></td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="3">
		<cfquery datasource="aspmonitor" name="copia_monitor" maxrows="240">
			select a.fecha, a.totalMemory, a.freeMemory, a.maxMemory
			from MonServerStats a
				join MonServerProcess b
					on a.srvprocid = b.srvprocid
			where a.fecha > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n',-240,Now())#">
			  and b.hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.serverhost#">
			order by a.fecha asc
		</cfquery>
		<cfif copia_monitor.RecordCount >
			<cfchart format="flash" showlegend="yes" showmarkers="no" chartwidth="900" yaxistitle="Memoria(MB)" yaxistype="">
				<cfchartseries type="line" serieslabel="Máximo JVM (-Xmx)" >
					<cfloop query="copia_monitor">
						<cfchartdata item="#TimeFormat(fecha,'HH:mm')#" value="#Int(maxMemory/1048576)#">
					</cfloop>
				</cfchartseries>
				<!---
				<cfchartseries type="line" serieslabel="Memoria disponible">
					<cfloop query="copia_monitor">
						<cfchartdata item="#TimeFormat(fecha,'HH:mm')#" value="#Int(freeMemory/1048576)#">
					</cfloop>
				</cfchartseries>
				--->
				<cfchartseries type="line" serieslabel="Asignada JVM" >
					<cfloop query="copia_monitor">
						<cfchartdata item="#TimeFormat(fecha,'HH:mm')#" value="#Int(totalMemory/1048576)#">
					</cfloop>
				</cfchartseries>
				<cfchartseries type="line" serieslabel="Asignada Objetos" seriescolor="000000" >
					<cfloop query="copia_monitor">
						<cfchartdata item="#TimeFormat(fecha,'HH:mm')#" value="#Int((totalMemory-freeMemory)/1048576)#">
					</cfloop>
				</cfchartseries>
			</cfchart>
		<cfelse>
			No hay datos para graficar.<br />
			<cfif defaulthost.hostname EQ url.serverhost>
				Active la tarea programada haciendo 
				<a href="/cfmx/sif/tasks/schedule.cfm" target="_blank" style="text-decoration:underline;">clic aqu&iacute;.</a>
			<cfelse>
				Active la tarea en esta misma página en el servidor <strong># HTMLEditFormat ( url.serverhost ) #</strong>
			</cfif>
		</cfif>	</td>
    <td>&nbsp;</td>
    </tr>
  <cfif defaulthost.hostname EQ url.serverhost>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" bgcolor="##CCCCCC">Hilos monitoreados del JVM. Versión de java: #JavaVersion# (#JavaVmVersion#), #JavaVmVendor#</td>
    <td>&nbsp;</td>
    </tr>

  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="3">
	
	<table border="0" bgcolor="##CCCCCC" width="100%">
  <tr>
    <td colspan="2"><em>thread</em></td>
    <td><em>prioridad</em></td>
    <td><em>vivo</em></td>
    <td><em>profundidad</em></td>
    <td><em>grupo</em></td>
    <td><em>IP</em></td>
    <td><em>usuario</em></td>
    <td><em>ruta</em></td>
    <td><em>sesi&oacute;n</em></td>
    <td><em>hora</em></td>
    <td nowrap><em>duraci&oacute;n(ms) </em></td>
  </tr>
<cfif IsDefined('server.monitor_thread')>
	<cflock name="server_monitor_thread" timeout="1" throwontimeout="yes" type="exclusive">
		<cfset my_threads = StructCopy(server.monitor_thread)>
	</cflock>
</cfif>
  
  <cfloop from="1" to="#enumerateThreadCount#" index="i">
  
	<cfif IsDefined('my_threads') and StructKeyExists(my_threads, tarray[i].getName())>
		<cfset current = my_threads[tarray[i].getName()]>
		<cfset thread_listed = true>
		<cfif IsDefined('current.getStackTrace')>
		<cfset stack_trace = current.getStackTrace()>
		</cfif>

  <tr>
    <td nowrap bgcolor="##FFFFFF">
	  <cfif tarray[i].getName() EQ thread.currentThread().getName()>
	  	(*)<cfelse>&nbsp;
	  </cfif></td>
	<cfset tarray[i].resume()>
    <td nowrap bgcolor="##FFFFFF">#tarray[i].getName()#</td>
    <td bgcolor="##FFFFFF">#tarray[i].getPriority()#</td>
    <td bgcolor="##FFFFFF">#tarray[i].isAlive()#</td>
	<cftry>
		<cfset LvarCSF = tarray[i].countStackFrames()>
	<cfcatch type="any">
		<cfset LvarCSF = "? (no suspended)">
	</cfcatch>
	</cftry>
    <td bgcolor="##FFFFFF">#LvarCSF#</td>
    <td bgcolor="##FFFFFF">#tarray[i].getThreadGroup().getName()#</td>
	<td bgcolor="##FFFFFF">
	
		<cfset current = my_threads[tarray[i].getName()]>
		#current.ipaddr#	</td>
    <td bgcolor="##FFFFFF">
      <cfset current = my_threads[tarray[i].getName()]>
  #current.login#    </td>
    <td bgcolor="##FFFFFF">
      <cfset current = my_threads[tarray[i].getName()]>
  #current.scriptName#    </td>
    <td align="right" bgcolor="##FFFFFF">#current.sessionid#    </td>
    <td align="right" nowrap bgcolor="##FFFFFF">
      #TimeFormat(current.startTime,'HH:mm')#</td>
    <td align="right" bgcolor="##FFFFFF">&nbsp;
      <cfif Len(current.finishTime)>#NumberFormat(current.finishTime.getTime()-current.startTime.getTime())#
	  <cfelse>#NumberFormat(Ahora.getTime()-current.startTime.getTime())#
	  </cfif></td>
  </tr>
  
  <cfelse>
  

  
  <tr>
    <td nowrap bgcolor="##FFFFFF">
	  <cfif tarray[i].getName() EQ thread.currentThread().getName()>
	  	(*)<cfelse>&nbsp;
	  </cfif></td>
	<cfset tarray[i].resume()>
    <td nowrap bgcolor="##FFFFFF">#tarray[i].getName()#</td>
    <td bgcolor="##FFFFFF">#tarray[i].getPriority()#</td>
    <td bgcolor="##FFFFFF">#tarray[i].isAlive()#</td>
	<cftry>
		<cfset LvarCSF = tarray[i].countStackFrames()>
	<cfcatch type="any">
		<cfset LvarCSF = "? (no suspended)">
	</cfcatch>
	</cftry>
    <td bgcolor="##FFFFFF">#LvarCSF#</td>
    <td bgcolor="##FFFFFF">#tarray[i].getThreadGroup().getName()#</td>
	<td bgcolor="##FFFFFF">&nbsp;</td>
    <td bgcolor="##FFFFFF">&nbsp;</td>
    <td bgcolor="##FFFFFF">&nbsp;
	<cfif IsDefined('stack_trace')>
	<cfdump var="#stack_trace#">
	</cfif>	</td>
    <td align="right" bgcolor="##FFFFFF">&nbsp;</td>
    <td align="right" nowrap bgcolor="##FFFFFF">&nbsp;</td>
    <td align="right" bgcolor="##FFFFFF">&nbsp;</td>
  </tr>
  	</cfif>
  </cfloop>
</table></td><td>&nbsp;</td></tr>


<cfelse>

  <tr>
    <td>&nbsp;</td>
    <td colspan="4" bgcolor="##CCCCCC">
	Servidor externo.</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
    <td colspan="3">
	No se muestran los hilos del JVM en servidores externos.
	<br /><ul><li><a href=".">Ver servidor local</a></li></ul>
	</td>
    <td>&nbsp;</td>
    </tr>

</cfif>

</table>
</cfoutput>	
	
	
<cf_web_portlet_end>
<cf_templatefooter>
