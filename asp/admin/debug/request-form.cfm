<cfif IsDefined('url.debugid') And Len(url.debugid)>
<cfinclude template="detail-form.cfm">
<cfelse>
<cfset headerList = 'Debug ID,Uri,Memoria,Duración,Fecha'>
<cfset headerArray = ListToArray(headerList)>

<cfparam name="url.sortBy" default="executionTime">
<cfset columnList = 'debugid,uri,memoryDelta,executionTime,requested'>
<cfset columnArray = ListToArray(columnList)>

<cfset naturalOrder = ListToArray('desc,asc,desc,desc,desc')>
<cfset filterMode = ListToArray('GT,LIKE,GT,GT,DATE')>
<cfset tableName = 'MonDebugQRequest'>

<cfset onclick = " 'debugDetail(&quot;' & JSStringFormat(debugid) & '&quot;)' ">

<cfinclude template="listas.cfm">

<script type="text/javascript">
	function debugDetail(debugid){
		location.href = 'index.cfm?tab=request&debugid=' + escape(debugid);
	}
</script>
</cfif>