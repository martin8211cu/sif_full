<cfquery name="rsSQL" datasource="asp">
	select SMNcodigo
	  from SMenues mn
	 where SScodigo = 'SIF'
	   and SMcodigo = 'ASC'
	   and <cf_dbfunction name='to_char' args="SMNexplicativo" isNumber="no"> = 'Contiene los catálogos de los módulos auxiliares del sistema'
</cfquery>
<cflocation url="/cfmx/home/menu/modulo.cfm?n=#rsSQL.SMNcodigo#">

