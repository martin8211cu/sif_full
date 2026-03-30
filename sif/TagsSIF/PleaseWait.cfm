<CFSETTING ENABLECFOUTPUTONLY="YES">
<!--- Optional Attributes --->
<CFPARAM NAME="Attributes.DISPLAY" DEFAULT="HTML">
<CFPARAM NAME="Attributes.JAVASCRIPT" DEFAULT="NO">
<CFPARAM NAME="Attributes.CHECKFOR" DEFAULT="PleaseWait">
<CFPARAM NAME="Attributes.BGCOLOR" DEFAULT="##FFFFFF">
<CFPARAM NAME="Attributes.FONTFACE" DEFAULT="Arial">
<CFPARAM NAME="Attributes.FONTSIZE" DEFAULT="2">
<CFPARAM NAME="Attributes.TITLE" DEFAULT="">
<CFPARAM NAME="Attributes.MESSAGE" DEFAULT="">
<CFPARAM NAME="Attributes.RequestTimeout" DEFAULT="">
<CFPARAM NAME="Attributes.SERVER_NAME" DEFAULT="#CGI.SERVER_NAME#">
<CFPARAM NAME="Attributes.PROTOCOL" DEFAULT="#CGI.SERVER_PORT#">
<CFIF ParameterExists(Caller.FORM.fieldnames)>
	<CFPARAM NAME="Attributes.FIELDNAMES" DEFAULT="#FORM.fieldnames#">
<CFELSE>
	<CFPARAM NAME="Attributes.FIELDNAMES" DEFAULT="">
</CFIF>

<CFSET Attributes.PROTOCOL = LCase(Attributes.PROTOCOL)>
<CFIF Attributes.PROTOCOL IS "443">
	<CFSET Attributes.PROTOCOL = "https">
<CFELSEIF Lcase(Attributes.PROTOCOL) NEQ "https">
	<CFSET Attributes.PROTOCOL = "http">
</CFIF>

<CFSET Attributes.FIELDNAMES = UCase(Attributes.FIELDNAMES)>

<CFSET Attributes.DISPLAY = Ucase(Attributes.DISPLAY)>
<CFSET Attributes.JAVASCRIPT = Ucase(Attributes.JAVASCRIPT)>

<CFIF (Attributes.JAVASCRIPT NEQ "YES") AND (Attributes.JAVASCRIPT NEQ "NO")>
	<CFSET Attributes.JAVASCRIPT = "NO">
</CFIF>

<CFIF Attributes.DISPLAY IS "JAVASCRIPT">
	<CFSET Attributes.JAVASCRIPT = "YES">
</CFIF>

<!---
<CFIF ((Trim(Attributes.TITLE) IS "") AND (IsDefined("Attributes.FIELDNAMES")) AND (Attributes.JAVASCRIPT IS "NO")) OR (Attributes.DISPLAY IS "JAVASCRIPT")>
	<CFSET Attributes.TITLE = "Warning!">
<CFELSEIF Trim(Attributes.TITLE) IS "">
	<CFSET Attributes.TITLE = "Please Wait... Processing Request.">
</CFIF>
--->
<CFIF ((Trim(Attributes.TITLE) IS "") AND (IsDefined("Attributes.FIELDNAMES")) AND (Attributes.JAVASCRIPT IS "NO")) OR (Attributes.DISPLAY IS "JAVASCRIPT")>
	<CFSET Attributes.TITLE = "Advertencia!">
<CFELSEIF Trim(Attributes.TITLE) IS "">
	<CFSET Attributes.TITLE = "Por favor espere... Procesando.">
</CFIF>

<CFIF ((Trim(Attributes.MESSAGE) IS "") AND (Trim(Attributes.FIELDNAMES) NEQ "") AND (Attributes.JAVASCRIPT IS "NO")) OR (Attributes.DISPLAY IS "JAVASCRIPT")>
	<CFSET Attributes.MESSAGE = "El proceso en ejecuci&oacute;n " & Chr(13) & Chr(10)>
	<CFSET Attributes.MESSAGE = Attributes.MESSAGE & "podr&iacute;a tomar varios minutos para completarse.">
<CFELSEIF Trim(Attributes.MESSAGE) IS "">
	<CFSET Attributes.MESSAGE = "Por favor espere... Se esta ejecutando el proceso" & Chr(13) & Chr(10)>
	<CFSET Attributes.MESSAGE = Attributes.MESSAGE & " y podr&iacute;a tomar varios minutos para completarse.">
</CFIF>

<CFSET Query_String = CGI.QUERY_STRING>
<CFIF (Trim(Attributes.RequestTimeout) NEQ "") AND (Val(Attributes.RequestTimeout) GT 0)>
	<CFIF Len(Query_String) GT 0>
	<CFSET Query_String = Query_String & "&">
	</CFIF>
	<CFSET Query_String = Query_String & "RequestTimeout=#Attributes.RequestTimeout#">
</CFIF>

<!---<CFSET PageToReload = "#Attributes.PROTOCOL#://#Attributes.SERVER_NAME##CGI.SCRIPT_NAME#?#Variables.Query_String#">--->
<CFSET PageToReload = "#Attributes.SERVER_NAME#?#Variables.Query_String#">
<CFIF Right(PageToReload,1) NEQ "?">
	<CFSET PageToReload = PageToReload & "&">
</CFIF>
<CFSET PageToReload = PageToReload & Attributes.CHECKFOR & "=OK">

<CFIF CGI.HTTP_REFERER IS "">
	<CFSET HTTP_REFERER = "#Attributes.SERVER_NAME#/">
<CFELSE>
	<CFSET HTTP_REFERER = CGI.HTTP_REFERER>
</CFIF>

<CFIF Trim(Attributes.FIELDNAMES) NEQ "">
	<CFSET strHiddenForm = "<FORM ACTION=""#Variables.PageToReload#"" METHOD=""POST"" NAME=""cfPleaseWait"">" & Chr(13) & Chr(10)>
	<CFLOOP INDEX="strVar" LIST="#Attributes.FIELDNAMES#" DELIMITERS=",">
		<CFSET strHiddenForm = strHiddenForm & "<INPUT TYPE=""HIDDEN"" NAME=""#strVar#"" VALUE=""#Evaluate(strVar)#"">" & Chr(13) & Chr(10)>
	</CFLOOP>
	<CFIF Attributes.JAVASCRIPT IS "NO">
		<!---<CFSET strHiddenForm = strHiddenForm & "<CENTER><INPUT TYPE=""Submit"" VALUE=""Click to Continue""></CENTER>" & Chr(13) & Chr(10)>--->
	</CFIF>
	<CFSET strHiddenForm = strHiddenForm & "</FORM>" & Chr(13) & Chr(10)>
</CFIF>

<CFIF (IsDefined("URL.#Attributes.CHECKFOR#") IS "No") AND (Attributes.DISPLAY IS "JAVASCRIPT")>

<CFOUTPUT>
<HTML>
<HEAD>
	<TITLE>#Attributes.TITLE#</TITLE>
</HEAD>
<BODY BGCOLOR="#Attributes.BGCOLOR#"<CFIF Trim(Attributes.FIELDNAMES) NEQ ""> onLoad="this.document.forms[0].submit()"</CFIF>>

<CFIF Trim(Attributes.FIELDNAMES) NEQ "">
#strHiddenForm#
</CFIF>

<SCRIPT LANGUAGE="JavaScript">
<!--
result = confirm('#REReplace(Attributes.MESSAGE, "#Chr(13)##Chr(10)#", "\n", "ALL")#\n\nClick "OK" para continuar,\nclick "CANCEL" para regresar');
if( result==true ) {
	<CFIF Trim(Attributes.FIELDNAMES) NEQ "">
		this.document.forms[0].submit();
	<CFELSE>
		self.location = '#Variables.PageToReload#';
	</CFIF>
} else {
	self.location = '#Variables.HTTP_REFERER#';		// no estoy seguro de esto
}
//-->
</SCRIPT>

</BODY>
</HTML>
</CFOUTPUT>

<CFELSEIF (IsDefined("URL.#Attributes.CHECKFOR#") IS "No") AND (Attributes.DISPLAY IS "HTML")>


<CFOUTPUT>
<HTML>
<HEAD>
	<TITLE>#Attributes.TITLE#</TITLE>
<CFIF Trim(Attributes.FIELDNAMES) IS "">
	<META HTTP-EQUIV="REFRESH" CONTENT="0; URL=#Variables.PageToReload#">
</CFIF>
</HEAD>
<BODY BGCOLOR="#Attributes.BGCOLOR#"<CFIF Trim(Attributes.FIELDNAMES) NEQ ""> onLoad="this.document.forms[0].submit()"</CFIF>>


<FONT FACE="#Attributes.FONTFACE#" SIZE="#Attributes.FONTSIZE#">

<CENTER><H4>#Attributes.TITLE#</H4></CENTER>

<P><CENTER><TABLE WIDTH="300" BORDER="0"><TR><TD><FONT FACE="#Attributes.FONTFACE#" SIZE="#Attributes.FONTSIZE#">
#Attributes.MESSAGE#
</FONT><a href="javascript:history.back();">Regresar</a></TD></TR></TABLE></CENTER></P>

<CFIF Trim(Attributes.FIELDNAMES) NEQ "">
#strHiddenForm#
</CFIF>

<CFIF (Trim(Attributes.FIELDNAMES) NEQ "") AND (Attributes.JAVASCRIPT IS "YES")>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//document.cfPleaseWait.submit()
	//this.document.forms[0].submit();
//-->
</SCRIPT>
</CFIF>

</FONT>
</BODY>
</HTML>
</CFOUTPUT>


</CFIF>

<CFIF IsDefined("URL.#Attributes.CHECKFOR#") IS "No">
	<CFABORT>
</CFIF>

<CFSETTING ENABLECFOUTPUTONLY="NO">
