<cfset request.error.backs = 1>
<cfset request.error.URL = 'mamamia.cfm'>
<cf_template>
<cf_templatearea name="title">SOIN
</cf_templatearea>
<cf_templatearea name="left">
</cf_templatearea>
<cf_templatearea name="body">


<cfif IsDefined("url.yy") or IsDefined("form.yy")>

<cfset session.debug = false>
<cfset form.aaa = 'aaa'>
<cfset form.stru = StructNew()>
<cfset form.stru.a = 'valor a'>
<cfset form.stru.b = 'valor b'>


<cffunction name="zz">

<cfquery datasource="asp">
select uno mas dos <cfqueryparam cfsqltype="cf_sql_bigint" value="33"> from DUAL
</cfquery>

</cffunction>

<cffunction name="yy">

<cfset zz()>
</cffunction>


<cfset yy()>
</cfif>
<form method="post" action="test.cfm?a=9&b=6">
	<input type="text" value="1234" name="yy">
	<input type="submit">
</form>

</cf_templatearea>
</cf_template>