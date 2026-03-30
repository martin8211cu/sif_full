<!--- 
Como forzar el tipo de dato en una columna en excel
Bernal Mora 9-10-14 
ejemplo
<td class="encabReporte" style="mso-number-format:'\@'">
en el td anterior se forzo con el style a que le de formato de texto	

Styling Excel cells with mso-number-format
mso-number-format:"0"							NO Decimals
mso-number-format:"0\.000"						3 Decimals
mso-number-format:"\#\,\#\#0\.000"				Comma with 3 dec
mso-number-format:"mm\/dd\/yy"					Date7
mso-number-format:"mmmm\ d\,\ yyyy"				Date9
mso-number-format:"m\/d\/yy\ h\:mm\ AM\/PM"		D -T AMPM
mso-number-format:"Short Date"					01/03/1998
mso-number-format:"Medium Date"					01-mar-98
mso-number-format:"d\-mmm\-yyyy"				01-mar-1998
mso-number-format:"Short Time"					5:16
mso-number-format:"Medium Time"					5:16 am
mso-number-format:"Long Time"					5:16:21:00
mso-number-format:"Percent"						Percent - two decimals
mso-number-format:"0%"							Percent - no decimals
mso-number-format:"0\.E+00"						Scientific Notation
mso-number-format:"\@"							Text
mso-number-format:"\#\ ???\/???"				Fractions - up to 3 digits (312/943)
mso-number-format:"\0022£\0022\#\,\#\#0\.00"	£12.76
mso-number-format:"\#\,\#\#0\.00_ \;\[Red\]\-\#\,\#\#0\.00\ "	2 decimals, negative numbers in red and signed(1.56 -1.56)
 --->

<cfsilent>
	<cfif ThisTag.ExecutionMode NEQ "START">
		<cfreturn>
	</cfif>

	<cfhtmlhead text="
	<style>
		@media print 
		{
			.noprint 
			{
				display: none;
			}
			.Corte_Pagina
			{
				PAGE-BREAK-AFTER: always
			}
		}
		@media screen 
		{
			.Corte_Pagina
			{
				border:dotted 1px ##FF0000;
				margin-top:20px;
				margin-bottom:20px;
			}
		}
		a { text-decoration:none;color:black; }
		a:hover 
		{ 
			text-decoration:underline;color:black; 
		}
		table 
		{
			mso-displayed-decimal-separator:""\."";
			mso-displayed-thousand-separator:""\,"";
		}
	</style>
	">
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
	<CFPARAM NAME="Attributes.flatCSS" 		DEFAULT="false">

	<cfset Attributes.FileName = trim(Attributes.FileName)>

	<!--- <cfif find(":",Attributes.FileName) + find(";",Attributes.FileName) + find(",",Attributes.FileName) + find("/",Attributes.FileName) + find("\",Attributes.FileName) NEQ 0 OR find(".",Attributes.FileName) NEQ len(Attributes.FileName)-3>
		<cf_errorCode	code = "50672" msg = "El Attributes.FileName no puede contener los siguientes caracteres ':/\;,.'">
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
		<cf_errorCode	code = "50673" msg = "El Attributes.FileName debe tener extensión .xls o .doc">
	</cfif>

	<cfif isdefined("form.btnDownload") or isdefined("url.btnDownload")>
		<cfcontent type="application/vnd.ms-#LvarDLtype#; charset=windows-1252">
		<cfheader name="Content-Disposition" value="attachment; filename=#Attributes.FileName#" ><!---charset="utf-8"---> 
		<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	</cfif>
</cfsilent>
<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
		"http://www.w3.org/TR/html4/loose.dtd">
	<html 	xmlns:o="urn:schemas-microsoft-com:office:office"
			xmlns:x="urn:schemas-microsoft-com:office:excel"
			xmlns="http://www.w3.org/TR/REC-html40">
		<head>
			<title>#Attributes.Title#</title>
            <cfif Application.dsinfo['asp'].type is 'db2'>
	            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            </cfif>
		</head>
		<body #Attributes.bodytag#>
</cfoutput>

<cfsilent>
	<cfif isdefined("form.btnDownload") or isdefined("url.btnDownload")>
		<cfif Attributes.flatCSS>
			<cfset request.flatCSS = true>
		</cfif>
		<cfreturn>
	</cfif>
</cfsilent>

<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0" class="noprint">
		<tr >
			<td align="right">
				<cfif Attributes.back>
				<a onClick="fnImgBack();">		<img class="noprint" src="/cfmx/sif/imagenes/back.png" 			border="0" style="cursor:pointer" class="noprint" title="Regresar"></a>
				</cfif>
				<cfif Attributes.back2>
				<a onClick="fnImgBack2();">		<img class="noprint" src="/cfmx/sif/imagenes/back.png" 			border="0" style="cursor:pointer" class="noprint" title="Regresar"></a>
				</cfif>
				<cfif Attributes.close>
				<a onClick="fnImgClose();">		<img class="noprint" src="/cfmx/sif/imagenes/imgClose.gif" 			border="0" style="cursor:pointer" class="noprint" title="Cerrar"></a>
				</cfif>
				<cfif Attributes.print>
				<a onClick="fnImgPrint();">		<img src="/cfmx/sif/imagenes/impresora.gif"	border="0" style="cursor:pointer" class="noprint" title="Imprimir"></a>
				</cfif>
				<cfif Attributes.download>
				<a onClick="fnImgDownload();">	<img src="/cfmx/sif/imagenes/Cfinclude.gif"		border="0" style="cursor:pointer" class="noprint" title="Download"></a>
				</cfif>
			</td>
		</tr>
	</table>
	<form name="frmImgImprimir" method="#Attributes.method#" action="#Attributes.irA#" style="display:none;">
		<cfif Attributes.method EQ "post">
		    <cfloop item="LvarItem" collection="#form#">
		        <cfif mid(LvarItem,1,3) NEQ "BTN" AND LvarItem NEQ "FIELDNAMES">
		        	<input type="hidden" name="#LvarItem#" value="#form[LvarItem]#">
		        </cfif>
		    </cfloop>
		<cfelse>
			<cfloop item="LvarItem" collection="#url#">
		        <cfif mid(LvarItem,1,3) NEQ "BTN" AND LvarItem NEQ "FIELDNAMES">
		        	<input type="hidden" name="#LvarItem#" value="#url[LvarItem]#">
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


