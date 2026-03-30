<cfquery name="rsSQL" datasource="asp">
	select SMNcodigo
	  from SMenues mn
	 where SScodigo = 'SIF'
	   and SMcodigo = 'AF'
	   and <cf_dbfunction name='to_char' args="SMNexplicativo" isNumber="no"> = '*CONSULTAS_AF*'
</cfquery>
<cflocation url="/cfmx/home/menu/modulo.cfm?n=#rsSQL.SMNcodigo#">

