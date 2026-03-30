<cfparam name="url.ds" default="asp,aspmonitor,minisif,sifcontrol,sifinterfaces,sifpublica">
<!--- <cfparam name="url.ds" default="asp,aspmonitor,isb,minisif,sifcontrol,sifinterfaces,sifpublica"> --->
<cfparam name="url.type" default="sybase">
<cfparam name="url.username" default="">
<cfparam name="url.password" default="">
<cfparam name="url.host" default="10.7.7.198">
<cfparam name="url.port" default="5000">
<cfparam name="url.sid" default="">
<cfparam name="url.ok" default="">
<cfparam name="url.verify" default="">
<cfparam name="url.syb" default="">
<cfparam name="url.ora" default="">
<cfparam name="url.mss" default="">

<cfif Len(url.syb)>
	<!--- convertir datasources principales a sybase --->
	<cfset url.ds="asp,aspmonitor,isb,minisif,sifcontrol,sifinterfaces,sifpublica">
	<cfset url.type="sybase">
	<cfset url.username="(usuario)">
	<cfset url.password="">
	<cfset url.host='10.7.7.198'>
	<cfset url.port='5000'>
	<cfset url.sid=''>
	
	<cfset url.user_asp = url.username>
	<cfset url.user_aspmonitor = url.username>
	<cfset url.user_isb = url.username>
	<cfset url.user_minisif = url.username>
	<cfset url.user_sifcontrol = url.username>
	<cfset url.user_sifinterfaces = url.username>
	<cfset url.user_sifpublica = url.username>
	<cfset url.db_asp = 'asp'>
	<cfset url.db_aspmonitor = 'aspmonitor'>
	<cfset url.db_isb = 'isb'>
	<cfset url.db_minisif = 'minisif'>
	<cfset url.db_sifcontrol = 'sif_control'>
	<cfset url.db_sifinterfaces = 'sif_interfaces'>
	<cfset url.db_sifpublica = 'sif_publica'>
<cfelseif Len(url.ora)>
	<!--- convertir datasources principales a oracle --->
	<cfset url.ds="asp,aspmonitor,isb,minisif,sifcontrol,sifinterfaces,sifpublica">
	<cfset url.type="oracle">
	<cfset url.username="">
	<cfset url.password="asp128">
	<cfset url.host='10.7.7.199'>
	<cfset url.port='1521'>
	<cfset url.sid='orcl'>
	
	<cfset url.user_asp = 'asp'>
	<cfset url.user_aspmonitor = 'aspmonitor'>
	<cfset url.user_isb = 'isb'>
	<cfset url.user_minisif = 'minisif'>
	<cfset url.user_sifcontrol = 'sif_control'>
	<cfset url.user_sifinterfaces = 'sif_interfaces'>
	<cfset url.user_sifpublica = 'sif_publica'>

	<cfset url.db_asp = ''>
	<cfset url.db_aspmonitor = ''>
	<cfset url.db_minisif = ''>
	<cfset url.db_isb = ''>
	<cfset url.db_sifcontrol = ''>
	<cfset url.db_sifinterfaces = ''>
	<cfset url.db_sifpublica = ''>
	
<cfelseif Len(url.mss)>
	<!--- convertir datasources principales a sqlserver --->
	<cfset url.ds="asp,aspmonitor,isb,minisif,sifcontrol,sifinterfaces,sifpublica">
	<cfset url.type="sqlserver">
	<cfset url.username="(usuario)">
	<cfset url.password="">
	<cfset url.host='SQLSERVER_DESA'>
	<cfset url.port='1433'>
	<cfset url.sid=''>
	
	<cfset url.user_asp = url.username>
	<cfset url.user_aspmonitor = url.username>
	<cfset url.user_isb = url.username>
	<cfset url.user_minisif = url.username>
	<cfset url.user_sifcontrol = url.username>
	<cfset url.user_sifinterfaces = url.username>
	<cfset url.user_sifpublica = url.username>
	<cfset url.db_asp = 'asp'>
	<cfset url.db_aspmonitor = 'aspmonitor'>
	<cfset url.db_isb = 'isb'>
	<cfset url.db_minisif = 'minisif'>
	<cfset url.db_sifcontrol = 'sif_control'>
	<cfset url.db_sifinterfaces = 'sif_interfaces'>
	<cfset url.db_sifpublica = 'sif_publica'>
</cfif>