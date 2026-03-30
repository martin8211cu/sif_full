<cfparam name="url.sortBy" default="-none-">
<cfparam name="url.sortReverse" type="boolean" default="no">
<cfset classNames = ListToArray('listaNon,listaPar')>

<cfif Not ListFind(columnList, url.sortBy)>
	<cfset url.sortBy = ListFirst(columnList)>
</cfif>
<cfif Not ListFind('sybase,oracle,db2', Application.dsinfo.aspmonitor.type)>
	<cfthrow message="Base de datos no soportada: #Application.dsinfo.aspmonitor.type#">
</cfif>


<cfquery datasource="aspmonitor" name="lista" maxrows="500">
	select
		<cfif ListFind('sqlserver,sybase', Application.dsinfo.aspmonitor.type)>
			top 500</cfif>
		#columnList#
	from #tableName#
	where 1=1
	<cfloop from="1" to="#ArrayLen(headerArray)#" index="i">
	<cfparam name="url.filtro_#columnArray[i]#" default="">
	<cfif Len(url['filtro_' & columnArray[i]])>
		<cfif filterMode[i] is 'GT'>
		and #columnArray[i]# > <cfqueryparam cfsqltype="cf_sql_numeric" value="#url['filtro_' & columnArray[i]]#">
		<cfelseif filterMode[i] is 'DATE'>
		and #columnArray[i]# > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url['filtro_' & columnArray[i]]#">
		<cfelseif filterMode[i] is 'LIKE'>
		and upper(#columnArray[i]#) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase( url['filtro_' & columnArray[i]])#%">
		</cfif>
	</cfif>
	</cfloop>
	<cfif ListFind('oracle', Application.dsinfo.aspmonitor.type)>
		and rownum < 500</cfif>
	order by #url.sortBy# <cfif (naturalOrder[ListFind(columnList,url.sortBy)] EQ 'asc') EQ (url.sortReverse)>desc</cfif>
</cfquery>
<form method="get" action="index.cfm"><input type="hidden" name="tab" value="<cfoutput>#url.tab#</cfoutput>" />
<table cellpadding="2" cellspacing="0" width="850">
<tr class="tituloListas">
<cfloop from="1" to="#ArrayLen(headerArray)#" index="i">
<cfoutput>
<td align="center" style="cursor:pointer" onclick="sortBy(&quot;#columnArray[i]#&quot;)" nowrap="nowrap">
<cfif url.sortBy is columnArray[i]><cfif url.sortReverse>&uarr;<cfelse>&darr;</cfif></cfif>
#headerArray[i]#
</td>
</cfoutput>
</cfloop>
</tr>
<tr class="tituloListas">
<cfloop from="1" to="#ArrayLen(headerArray)#" index="i">
<cfoutput>
<td align="center">
<input type="text" style="width:100%" name="filtro_#columnArray[i]#" value="#url['filtro_' & columnArray[i]]#" onkeypress="if((event.which?event.which:event.keyCode)==13){ this.form.submit();return false; }">
</td>
</cfoutput>
</cfloop>
</tr>
<cfoutput query="lista">
	<cfset className = classNames[1+CurrentRow mod 2]>
	<tr style="cursor:pointer" class="#className#"
		onmouseover="className=&quot;#className#Sel&quot;;"
		onmouseout="className=&quot;#className#&quot;;"
		onclick="#Evaluate(onclick)#">
	<cfloop from="1" to="#ArrayLen(headerArray)#" index="i">
	<cfset valor=Evaluate('lista.' & columnArray[i])>
	<td nowrap="nowrap"><div style="width:100%;overflow:hidden">
		<cfif IsDate(valor)>#TimeFormat(valor,'HH:mm:ss')# #DateFormat(valor)#
		<cfelseif IsNumeric(valor) And filterMode[i] is 'GT'>
			<cfif valor LT 0>
			(#NumberFormat(Abs(valor))#)
			<cfelse>
			#NumberFormat(valor)#
			</cfif>
		<cfelse>
		# HTMLEditFormat(valor) #</cfif></div></td>
	</cfloop>
	</tr>
</cfoutput>
</table></form>
<cfoutput>
<script type="text/javascript">
	function sortBy(column){
		var newurl = 'index.cfm?tab=#url.tab#&sortBy=' + escape(column);
		<cfif Not url.sortReverse>
		if (column == '#JSStringFormat(url.sortBy)#'){
			newurl += '&sortReverse=yes';
		}</cfif>
		location.href  = newurl;
	}
</script>
</cfoutput>