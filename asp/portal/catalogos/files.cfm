<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Seleccionar</title>
<style type="text/css">
*,td { 
	font-size:12px;
	font-family:Arial, Helvetica, sans-serif;
}
a {
	text-decoration: none;
	color: black;
}
</style>
</head>

<body style="margin:0">
<cfparam name="url.p" type="string" default="">

<cfif Find('..',url.p) or Find('%',url.p)>
	<cfset url.p = ''>
</cfif>

<cfoutput>

<cfset path = ExpandPath("")>

<cfset miniurl="">
<div style="height:400px;overflow:auto;width:300px">
<table border="0" cellpadding="2" cellspacing="0" width="270">
<cfset maxlevel = ListLen(url.p,'/')>

<cfset level = 1>
	<tr onMouseOver="files_over(this)" onMouseOut="files_out(this)">
		<td width="16">
		<a href="files.cfm"><img src="foldericon.png" width="16" height="16" border="0"></a></td>
		<td colspan="#maxlevel+2#">
		<a href="files.cfm">&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a> </td>
		</tr>

<cfloop list="#url.p#" delimiters="/" index="dirpart">
	<cfset level = level + 1>
	<cfif DirectoryExists(path & '/' & dirpart)>
		<cfset miniurl = miniurl & '/' & dirpart>
		<cfset path = ExpandPath(miniurl)>
		<tr onMouseOver="files_over(this)" onMouseOut="files_out(this)">
		<cfif level gt 1><td colspan="#level-1#">&nbsp;</td></cfif>
		<td width="16">
		<a href="files.cfm?p=#URLEncodedFormat(miniurl)#"><img src="foldericon.png" width="16" height="16" border="0"></a></td>
		<td colspan="#maxlevel-level+3#">
		<a href="files.cfm?p=#URLEncodedFormat(miniurl)#">#dirpart#&nbsp;&nbsp;</a> </td>
		</tr>
	<cfelse>
		<cfbreak>
	</cfif>
</cfloop>

<cfset url.p = miniurl>

<cfdirectory action="list" directory="#path#" name="dir">

<cfquery dbtype="query" name="dir2">
	select *
	from dir
	where name not like '~%'
	  and name not like '[_]%'
	  and name not like '%.LCK'
	  and name != 'CFIDE'
	  and name != 'WEB-INF'
	  and name != 'META-INF'
	  and name != 'cfdocs'
	  and name != 'Application.cfm'
	  and name != 'OnRequestEnd.cfm'
	order by type
</cfquery>


<cfloop query="dir2">
	<tr onMouseOver="files_over(this)" onMouseOut="files_out(this)">
	<cfif type is 'Dir'>
	<td colspan="#level#">&nbsp;</td><td><a href="files.cfm?p=#URLEncodedFormat(p & '/' & name)#">
		<img src="foldericon.png" width="16" height="16" border="0"></a></td>
		<td width="100%"><a href="files.cfm?p=#URLEncodedFormat(p & '/' & name)#">#name#&nbsp;&nbsp;</a></td>
	<cfelse>
		<td colspan="#level#">&nbsp;</td><td><a href="javascript:seleccionar('#JSStringFormat(name)#')">
		<img src="file.png" width="16" height="16" border="0"></a></td>
		<td width="100%"><a href="javascript:seleccionar('#JSStringFormat(name)#')">#name#&nbsp;&nbsp;</a></td>
	</cfif>
	</tr>
</cfloop>
</table>
</div>

<script type="text/javascript">
<!--
	function seleccionar(name){
		window.opener.conlisFilesSelect('#JSStringFormat(url.p)#/' + name);
	}
	function files_over(tr){
		tr.style.backgroundColor = '##ededed';
		tr.style.color = 'white';
	}
	function files_out(tr){
		tr.style.backgroundColor = 'white';
		tr.style.color = 'black';
	}
//-->
</script>

</cfoutput>
</body>
</html>
