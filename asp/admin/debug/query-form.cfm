<cfset headerList = 'Debug ID,Template,Nombre,Duración,Fecha'>
<cfset headerArray = ListToArray(headerList)>

<cfparam name="url.sortBy" default="executionTime">
<cfset columnList = 'debugid,template,queryName,executionTime,fecha'>
<cfset columnArray = ListToArray(columnList)>

<cfset naturalOrder = ListToArray('desc,asc,asc,desc,desc')>
<cfset filterMode = ListToArray('GT,LIKE,LIKE,GT,DATE')>
<cfset tableName = 'MonDebugQSQL'>

<cfset onclick = " 'debugDetail(&quot;' & JSStringFormat(debugid) & '&quot;)' ">

<cfinclude template="listas.cfm">

<script type="text/javascript">
	function debugDetail(debugid){
		location.href = 'index.cfm?tab=request&debugid=' + escape(debugid);
	}
</script>