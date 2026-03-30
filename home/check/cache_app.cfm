
<cfif session.monitoreo.SScodigo NEQ 'sys' and session.monitoreo.SScodigo NEQ ''>
	<cfquery dbtype="query"	name="rsQcahes">
		select Ccache from session.querycahe
		where SScodigo = '#session.monitoreo.SScodigo#' 
			and Ecodigo = #session.EcodigoSDC#
	</cfquery>
	<cfif rsQcahes.recordCount GT 0 and rsQcahes.Ccache NEQ "">
		<cfset session.DSN = rsQcahes.Ccache>
	</cfif>
</cfif>