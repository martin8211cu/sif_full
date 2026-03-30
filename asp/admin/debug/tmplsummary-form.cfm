<cfset headerList = 'Debug ID,Template,Dur.Total,Cantidad,Dur.Promedio'>
<cfset headerArray = ListToArray(headerList)>

<cfparam name="url.sortBy" default="totalExecutionTime">
<cfset columnList = 'debugid,template,totalExecutionTime,instanceCount,avgExecutionTime'>
<cfset columnArray = ListToArray(columnList)>

<cfset naturalOrder = ListToArray('desc,asc,desc,desc,desc')>
<cfset filterMode = ListToArray('GT,LIKE,GT,GT,GT')>
<cfset tableName = 'MonDebugQSummary'>

<cfset onclick = " 'debugDetail(&quot;' & JSStringFormat(debugid) & '&quot;)' ">

<cfinclude template="listas.cfm">

<script type="text/javascript">
	function debugDetail(debugid){
		location.href = 'index.cfm?tab=request&debugid=' + escape(debugid);
	}
</script>