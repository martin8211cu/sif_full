<cfparam name="url.num_msg" type="numeric">

<cfquery datasource="asp" name="msg">
	select msg_corto, msg_largo
	from APMensajes
	where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	  and num_msg = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.num_msg#">
</cfquery>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Detalle del mensaje # HTMLEditFormat( url.num_msg )#</title>
<cfif Len(msg.msg_largo)>
	<cfset detalle = Replace( msg.msg_largo, Chr(13), '<br>', 'all')>
<cfelse>
	<cfset detalle = '<br>'>
</cfif>
<script type="text/javascript">
	window.parent.showmsg('<b>#JSStringFormat ( msg.msg_corto ) #</b><br># JSStringFormat (  detalle ) #');
</script>
</head>

<body>
</body>
</html>
</cfoutput>