<cfset headerList = 'Debug ID,Template,Tipo,Mensaje,Fecha'>
<cfset headerArray = ListToArray(headerList)>

<cfparam name="url.sortBy" default="debugid">
<cfset columnList = 'debugid,template,exceptionType,message,fecha'>
<cfset columnArray = ListToArray(columnList)>

<cfset naturalOrder = ListToArray('desc,asc,asc,asc,desc')>
<cfset filterMode = ListToArray('GT,LIKE,LIKE,LIKE,DATE')>
<cfset tableName = 'MonDebugQException'>

<cfset onclick = " 'debugDetail(&quot;' & JSStringFormat(debugid) & '&quot;)' ">

<cfinclude template="listas.cfm">

<script type="text/javascript">
	function debugDetail(debugid){
		location.href = 'index.cfm?tab=request&debugid=' + escape(debugid);
	}
</script>