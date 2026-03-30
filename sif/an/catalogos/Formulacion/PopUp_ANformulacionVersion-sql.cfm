<cfif url.guardar>
	<cfquery datasource="#session.dsn#">
		insert into ANformulacionVersion
		(
			ANFid,         
			CPPid,         
			CVid,
			Ecodigo
		)
		values
		(
			#url.ANFid#,
			#url.CPPid#,
			#url.CVid#,
			#session.Ecodigo#
		)
	</cfquery>
<cfelse>
	<cfquery datasource="#session.dsn#">
		delete from ANformulacionVersion 
		where ANFid = #url.ANFid#
		  and CPPid = #url.CPPid#
		  and CVid  = #url.CVid#
		  and Ecodigo = #session.Ecodigo#
	</cfquery>
</cfif>

