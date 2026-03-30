<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!---
	Pone los encabezado del documento HTML desde el inicio hasta <Body> inclusive
	y la lógica para regresar, imprimir y download
--->

<cfparam name="Attributes.irA" 			type="string">
<cfparam name="Attributes.FileName"		type="string">
<cfparam name="Attributes.bodyTag" 		type="string" default="">
<cfparam name="Attributes.title" 		type="string" default="">
<cfparam name="Attributes.back" 		type="boolean" default="yes">
<cfparam name="Attributes.back2" 		type="boolean" default="no">
<cfparam name="Attributes.close" 		type="boolean" default="false">
<cfparam name="Attributes.print" 		type="boolean" default="yes">
<cfparam name="Attributes.download" 	type="boolean" default="yes">
<cfparam name="Attributes.preview" 		type="boolean" default="yes">
<cfparam name="Attributes.method" 		type="string" default="post">
<cfparam name="Attributes.param" 		type="string" default="">

<cfset Attributes.FileName = trim(Attributes.FileName)>

<!--- <cfif find(":",Attributes.FileName) + find(";",Attributes.FileName) + find(",",Attributes.FileName) + find("/",Attributes.FileName) + find("\",Attributes.FileName) NEQ 0 OR find(".",Attributes.FileName) NEQ len(Attributes.FileName)-3>
	<cfthrow message="El Attributes.FileName no puede contener los siguientes caracteres ':/\;,.'">
</cfif> --->

<cfset Attributes.FileName = Replace(Attributes.FileName, ":", "_", "all")>
<cfset Attributes.FileName = Replace(Attributes.FileName, ";", "_", "all")>
<cfset Attributes.FileName = Replace(Attributes.FileName, ",", "_", "all")>
<cfset Attributes.FileName = Replace(Attributes.FileName, "/", "_", "all")>
<cfset Attributes.FileName = Replace(Attributes.FileName, "\", "_", "all")>
<cfset Attributes.FileName = Replace(Left(Attributes.FileName,Len(Attributes.FileName)-4), ".", "_", "all") & Right(Attributes.FileName,4)>

<cfif findNoCase(".xls",Attributes.FileName)>
	<cfset LvarDLtype = "excel">
<cfelseif findNoCase(".doc",Attributes.FileName)>
	<cfset LvarDLtype = "word">
<cfelse>
	<cfthrow message="El Attributes.FileName debe tener extensión .xls o .doc">
</cfif>

<cfif isdefined("form.btnDownload") or isdefined("url.btnDownload")>
	<cfcontent type="application/vnd.ms-#LvarDLtype#">
	<cfheader name="Content-Disposition" value="attachment; filename=#Attributes.FileName#">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>
</cfsilent>
<cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
		"http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<title>#Attributes.Title#</title>
			<style type="text/css">
			table
				{mso-displayed-decimal-separator:"\.";
				mso-displayed-thousand-separator:"\,";}
		
			</style>
			
		</head>
		<body #Attributes.bodytag#>
</cfoutput>
<cfsilent>

<cfif isdefined("form.btnDownload") or isdefined("url.btnDownload")>
	<cfreturn>
</cfif>

<cfhtmlhead text="
<style>
	@media print {
		.noprint 
		{
			display: none;
		}
	}
	a { text-decoration:none;color:black; }
	a:hover { text-decoration:underline;color:black; }
</style>
">
</cfsilent><cfoutput>
<table width="100%" cellpadding="2" cellspacing="0" class="noprint">
	<tr >
		<td align="right">
			<cfif Attributes.back>
			<a onClick="fnImgBack();">		<img class="noprint" src="/imagenes/back.png" 			border="0" style="cursor:pointer" class="noprint" title="Regresar"></a>
			</cfif>
			<cfif Attributes.back2>
			<a onClick="fnImgBack2();">		<img class="noprint" src="/imagenes/back.png" 			border="0" style="cursor:pointer" class="noprint" title="Regresar"></a>
			</cfif>
			<cfif Attributes.close>
			<a onClick="fnImgClose();">		<img class="noprint" src="/imagenes/imgClose.gif" 			border="0" style="cursor:pointer" class="noprint" title="Regresar"></a>
			</cfif>
			<cfif Attributes.print>
			<a onClick="fnImgPrint();">		<img src="/imagenes/impresora.gif"	border="0" style="cursor:pointer" class="noprint" title="Imprimir"></a>
			</cfif>
			<cfif Attributes.download>
			<a onClick="fnImgDownload();">	<img src="/imagenes/Cfinclude.gif"		border="0" style="cursor:pointer" class="noprint" title="Download"></a>
			</cfif>
		</td>
	</tr>
</table>
<form name="frmImgImprimir" method="#Attributes.method#" action="#Attributes.irA#" style="display:none;">
<cfif Attributes.method EQ "post">
    <cfloop item="LvarItem" collection="#form#">
        <cfif mid(LvarItem,1,3) NEQ "BTN" AND LvarItem NEQ "FIELDNAMES">
        #LvarItem#=<input type="text" name="#LvarItem#" value="#form[LvarItem]#"><BR>
        </cfif>
    </cfloop>
<cfelse>
	<cfloop item="LvarItem" collection="#url#">
        <cfif mid(LvarItem,1,3) NEQ "BTN" AND LvarItem NEQ "FIELDNAMES">
        #LvarItem#=<input type="text" name="#LvarItem#" value="#url[LvarItem]#"><BR>
        </cfif>
    </cfloop>
</cfif>

	<input type="submit" name="btnDownload" value="Download">
</form>
<script language="javascript">
	function fnImgDownload()
	{
		<cfif isdefined("Attributes.param") and len(trim(Attributes.param))>
			document.frmImgImprimir.action = "#CGI.SCRIPT_NAME#?X=#rand()##Attributes.param#";
		<cfelse>
			document.frmImgImprimir.action = "#CGI.SCRIPT_NAME#?X=#rand()#";
		</cfif>
		document.frmImgImprimir.btnDownload.click();
	}

	function fnImgBack()
	{
		document.frmImgImprimir.action = "#Attributes.irA#";
		document.frmImgImprimir.submit();
	}
	
	function fnImgBack2()
	{
		location.href="#Attributes.irA#";
	}
	
	function fnImgClose()
	{
		window.close();
	}
	
	function fnImgPrint()
	{
	<cfif Attributes.preview>
		if (document.all)
			{
			try
				{
				var OLECMDID = 7;
				/* OLECMDID values:
				* 6 - print
				* 7 - print preview
				* 1 - open window
				* 4 - Save As
				*/
				var PROMPT = 1; // 2 DONTPROMPTUSER 
				var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
				document.body.insertAdjacentHTML('beforeEnd', WebBrowser); 
				WebBrowser1.ExecWB(OLECMDID, PROMPT);
				WebBrowser1.outerHTML = "";
			}
			catch (e)
			{
				window.print();
			}
		}
		else
	</cfif>
			window.print();
	}
</script>
</cfoutput>
