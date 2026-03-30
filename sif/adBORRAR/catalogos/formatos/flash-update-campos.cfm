<cfsetting enablecfoutputonly="yes">
<!--- <cflog file="editor_update" text="entrando... flash-update-campos"> --->
<cftry>
<!---
<cflog file="editor_update" text="  form=#StructKeyList(form)#">
--->

<cfif IsDefined('url.FMT01COD') and not  IsDefined('form.FMT01COD')>
	<cfset form.FMT01COD = url.FMT01COD>
</cfif>

<cfloop from="0" to="1000" index="i">
	<cfif StructKeyExists(form,'item'&i)>
		<cfset item = form['item'&i]>
		<!--- 
		<cflog file="editor_update" text="  item[# i #]:  # item #"> --->
		
		<cfset item_array = ListToArray(item,'&')>
		<cfset item_struct = StructNew()>
		<cfloop from="1" to="#ArrayLen(item_array)#" index="j">
			<cfset key = URLDecode( ListFirst(item_array[j],'=') )>
			<cfset value = URLDecode( ListLast(item_array[j],'=') )>
			<cfset item_struct[key] = value>
			<!--- 
			<cflog file="editor_update" text="    :# key #">
			<cflog file="editor_update" text="    :# key #:  # value #"> --->
		</cfloop>
		<cfquery datasource="#session.dsn#">
			update FMT002
				   set FMT02FIL = <cfqueryparam value="#item_struct.x#"   cfsqltype="cf_sql_float"   >
					  ,FMT02COL = <cfqueryparam value="#item_struct.y#"   cfsqltype="cf_sql_float"   >
					  ,FMT02LON = <cfqueryparam value="#item_struct.width#"   cfsqltype="cf_sql_float" >
				   where FMT01COD = <cfqueryparam value="#form.FMT01COD#" cfsqltype="cf_sql_char"    >
					 and FMT02LIN = <cfqueryparam value="#item_struct.linea#" cfsqltype="cf_sql_integer" >
		</cfquery>
		<!---
		<cflog file="editor_update" text="    Q: update FMT002 set campo = '#item_struct.campo#' where FMT02LIN = #item_struct.linea#">

        <cflog file="editor_update" text="    Q: session.FMT01COD: #session.FMT01COD#">
		--->
	<cfelse>
		<cfbreak>
	</cfif>
</cfloop>
<!---
<cflog file="editor_update" text="  url=#StructKeyList(url)#">
<cflog file="editor_update" text="saliendo... flash-update-campos">--->
	<cfheader name="update-status" value="success">
	<cfoutput>error=false&msg=Ok</cfoutput>
<cfcatch type="any">
	<cflog file="editor_update" text="ERROR: #cfcatch.Message# #cfcatch.Detail#">
	<cfheader name="update-status" value="failure: #cfcatch.Message#">
	<cfoutput>error=true&msg=URLEncodedFormat('ERROR: ' & cfcatch.Message)</cfoutput>
</cfcatch>

</cftry>
