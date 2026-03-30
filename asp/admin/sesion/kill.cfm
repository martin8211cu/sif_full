<cfinvoke component="home.Componentes.aspmonitor" method="MonitoreoLogout">
	<cfinvokeargument name="reason"	 value="K">
	<cfinvokeargument name="sessionid"	 value="#form.victim#">
</cfinvoke>

<cflocation url="index.cfm?aspsessid=#HTMLEditFormat(form.victim)#" addtoken="no">