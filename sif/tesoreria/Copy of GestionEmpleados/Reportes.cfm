<cfquery name="rsSQL" datasource="asp">
	select SMNcodigo
	  from SMenues mn
	 where SScodigo = 'SIF'
	   and SMcodigo = 'TES'
	   and <cf_dbfunction name='to_char' args="SMNexplicativo"> = 'ReportesTES'
</cfquery>
<cflocation url="/cfmx/home/menu/modulo.cfm?n=#rsSQL.SMNcodigo#">

