<cfsetting requesttimeout="10">
<cfset LvarNow = now()>
<cfloop index="i" from="1" to="10000000">
	<cfif dateDiff("s",LvarNow,now()) GTE LvarSeg><cfexit></cfif>
</cfloop>
<cfabort>



<cfapplication name="SIF_ASP">
<cfset rsInterfaces.NumeroInterfaz = 1>
		<cfhttp url="http://localhost/cfmx/sif/aa/index.cfm?NI=#rsInterfaces.NumeroInterfaz#" timeout="1" >
		</cfhttp>
<cfdump var="#cfhttp#">
<cfdump var="#application#">
<cfdump var="#LvarSiguienteActivacion#">
<cfdump var="#dateDiff("s",LvarSiguienteActivacion,now())#">*
<cfdump var="#dateDiff("s",createdatetime(1932,1,1,1,1,2),createdatetime(2000,1,2,1,1,3))#">*
<cfabort>

<cfquery datasource="sifinterfaces" name="rsSQL">
	select 0 as AA_row,* from Interfaz
</cfquery>
<cfquery dbtype="query">
	select AA_row, * from rsSQL
</cfquery>
<cfset application.interfaz.rs = rsSQL>
<cfdump var="#application.interfaz.rs#">
<cfloop index="r" from="1" to="#application.interfaz.rs.recordCount#">
	<cfset rsSQL.AA_row[r] = "#R#">
</cfloop>
<cfset c = 1>
<cfloop index="r" from="1" to="#application.interfaz.rs.recordCount#">
	<cfif application.interfaz.rs.NumeroInterfaz[r] EQ "8">
		<cfset application.interfaz.rs.Descripcion[r] = "hola">
	</cfif>
</cfloop>

<cfdump var="#application.interfaz.rs#">
