<cf_template>
<cf_templatearea name="title">SOIN
</cf_templatearea>
<cf_templatearea name="left">
</cf_templatearea>
<cf_templatearea name="body">


<cfif IsDefined("url.yy") or IsDefined("form.yy")>

<cfset session.debug = false>

<cffunction name="zz">

<cfquery datasource="asp">
select uno mas dos from DUAL
</cfquery>

</cffunction>

<cffunction name="yy">

<cfset zz()>
</cffunction>


<cfset yy()>
</cfif>
<form method="post" action="test.cfm?a=9&b=6" target="xxxyyy">
	<input type="text" value="1234" name="yy">
	<input type="submit">
</form>

<iframe src="about:blank" name="xxxyyy" width="300" height="300">


</iframe>

</cf_templatearea>
</cf_template>