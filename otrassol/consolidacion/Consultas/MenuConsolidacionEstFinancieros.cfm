<cfquery name="rsSQL" datasource="asp">
         select SMNcodigo
      from SMenues mn
     where SScodigo = 'OTROS'
       and SMcodigo = 'CONS'
       and <cf_dbfunction name='to_char' args="SMNexplicativo" isNumber="no"> = '*CONSULTAS_ESTADOSFINANCIEROS*'
</cfquery>
<cflocation url="/cfmx/home/menu/modulo.cfm?n=#rsSQL.SMNcodigo#">