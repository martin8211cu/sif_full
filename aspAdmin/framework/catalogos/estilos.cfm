<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfif IsDefined("url.skin")>
	set to <cfoutput>#url.skin#</cfoutput>
	<cfset session.Preferences.skin = url.skin><br>
	now is <cfoutput>#session.Preferences.skin#</cfoutput>
</cfif>
<a href="estilos.cfm">self</a><br>
<cfsetting enablecfoutputonly="yes">
	<cffile action="read" file="#  ExpandPath('/aspAdmin/css/web_portlet.css') #" variable="css">
	<cfset arr = ListToArray(css, chr(10) & chr(13))>
	<cfset skins = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset line = Trim(arr[i])>
		<cfif Left(line, 2) EQ "/*" and Right(line,2) EQ "*/">
			<cfset line = Trim(Mid(line, 3, Len(line) - 4))>
			<cfif ListLen(line,":") EQ 3 AND ListGetAt(line,1,":") EQ "name">
				<cfset ArrayAppend(skins, ListGetAt(line, 2, ":") & "," & ListGetAt(line, 3, ":"))>
			</cfif>
		</cfif>
	</cfloop>
<cfsetting enablecfoutputonly="no">

<form><select name="skin">
	<cfloop from="1" to="#ArrayLen(skins)#" index="i">
		<cfoutput><option value="#ListGetAt(skins[i],1)#" <cfif 
			ListGetAt(skins[i],1) EQ session.preferences.skin>selected</cfif>>#
			ListGetAt(skins[i],2)#</option></cfoutput>
	</cfloop>
</select>
<input type="submit">
</form>

	now is <cfoutput>#session.Preferences.skin#</cfoutput>

</body>
</html>
