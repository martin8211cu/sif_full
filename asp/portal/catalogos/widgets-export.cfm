
<cfset chk = listToArray(form.chk)>
<cfquery name="q_WidBase" datasource="asp">
	select WidID, WidParentId  from Widget where WidID in (#form.chk#);
</cfquery>

<cfloop query="#q_WidBase#">
	<cfif q_WidBase.WidParentId neq '' && !arrayContains(chk, q_WidBase.WidParentId)>
		<cfset arrayAppend(chk, q_WidBase.WidParentId)>
	</cfif>
</cfloop>

<cfquery name="q_WidToExport" datasource="asp">
	select * from Widget where WidID in (#arrayToList(chk)#) order by WidParentId asc;
</cfquery>
<cfquery name="q_WidParamsToExport" datasource="asp">
	select * from WidgetParametros where WidID in (#arrayToList(chk)#) order by WidID asc;
</cfquery>

<cfset colsW = listToArray(q_WidToExport.columnList)>
<cfset colsP = listToArray(q_WidParamsToExport.columnList)>

<cfset widgets = []>
<cfloop query="q_WidToExport">
	<cfset widget = []>
	<cfset params = []>
	<cfloop array="#colsW#" index="i" item="t">
		<cfset value = CleanVal(q_WidToExport['#colsW[i]#'])>
		<cfset arrayAppend(widget, '"#colsW[i]#":"#value#"')>
	</cfloop>
	<cfquery name="q_params" dbtype="query">
		select * from q_WidParamsToExport where WidID = #q_WidToExport.WidID#
	</cfquery>
	<cfloop query="q_params">
		<cfset param = []>
		<cfloop array="#colsP#" index="i" item="t">
			<cfset value = CleanVal(q_params['#colsP[i]#'])>
			<cfset arrayAppend(param, '"#colsP[i]#":"#value#"')>
		</cfloop>
		<cfset  arrayAppend(params, "{#ArrayToList(param)#}")>
	</cfloop>
	<cfset arrayAppend(widget, '"Params":[#ArrayToList(params)#]')>
	<cfset arrayAppend(widgets, "{#ArrayToList(widget)#}")>
</cfloop>
<cfset widgets = "[#ArrayToList(widgets)#]">


<script>

	download("export_widgets<cfoutput>#DateFormat(Now(),'yyyymmdd')#</cfoutput>.txt","<cfoutput>#Replace(widgets,'"','\"','all')#</cfoutput>");

	function download(filename, text) {
				var element = document.createElement('a');
				element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
				element.setAttribute('download', filename);
				element.style.display = 'none';
				document.body.appendChild(element);
				element.click();
				document.body.removeChild(element);
			}
</script>

<cffunction  name="CleanVal">
	<cfargument  name="value">
	<cfset v = trim(arguments.value)>
	<cfset v = replace(v, "'", "",'all')>
	<cfset v = replace(v, '"', '','all')>
	<cfset v = replace(v, ",", ";",'all')>
	<cfset v = replace(v, "}", ")",'all')>
	<cfset v = replace(v, "{", "(",'all')>
	<cfset v = replace(v, "]", ")",'all')>
	<cfset v = replace(v, "[", ")",'all')>
	<cfset v = replace(v, ":", "-",'all')>
	<cfset v = replace(v, "á", "a",'all')>
	<cfset v = replace(v, "é", "e",'all')>
	<cfset v = replace(v, "í", "i",'all')>
	<cfset v = replace(v, "ó", "o",'all')>
	<cfset v = replace(v, "ú", "u",'all')>
	<cfset v = replace(v, "Á", "A",'all')>
	<cfset v = replace(v, "É", "E",'all')>
	<cfset v = replace(v, "Í", "I",'all')>
	<cfset v = replace(v, "Ó", "O",'all')>
	<cfset v = replace(v, "Ú", "U",'all')>
	<cfset v = replace(v, "\r", "",'all')>
	<cfset v = replace(v, "\n", " ",'all')>
	<cfreturn v>
</cffunction>

<!---
<cfset componentPath = "crc.Componentes.TransferData">
	<cfset componentOBJ = createObject("component","#componentPath#")>
	<cfset result = componentOBJ.Exportar(
			tableName = "Widget"
		,	keyColumnName = "WidCodigo"
		,	export = #q_WidToExport#
	)>
--->