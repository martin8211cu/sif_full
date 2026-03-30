<cfparam name="form.ds" default="">
<cfinvoke component="asp.parches.comp.misc" method="dsinfotype2dbms" dsinfotype="#Application.dsinfo.asp.type#"
	returnvariable="dbms"/>
<cfset session.instala.dbms = dbms>
<cfset session.instala.ds = form.ds>
	
<cfif IsDefined('form.aplicar')>
	<cflocation url="ds.cfm">
<cfelse>
	<cflocation url="../ejecuta/ejecuta.cfm">
</cfif>