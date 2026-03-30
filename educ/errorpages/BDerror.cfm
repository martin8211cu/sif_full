<html>
<head>
<title>Error</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/educ/css/educ.css" rel="stylesheet" type="text/css">
<cf_templatecss>
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="24%"><img src="/cfmx/educ/Imagenes/logo.gif" width="170" height="62"></td>
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td width="4%"><span class="titulo"></span></td>
    <td width="8%" bgcolor="#003366"><font color="#FFFFFF"><cfif isdefined("Session.rutaImagenes")><img src="/cfmx/educ/Imagenes/Stop01_T.gif" width="48" height="48"></cfif><span class="titulo"></span></font></td>
    <td width="49%" bgcolor="#003366"><div align="left"><font color="#FFFFFF">&nbsp;<strong><font size="3">Error!</font></strong></font></div></td>
    <td width="15%">&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#F5F5F5" class="contenido-lborder">&nbsp;</td>
    <td bgcolor="#F5F5F5" class="contenido-rborder">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
	<cfif isdefined("url.errType")>
		<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Tipo:</font></div></td>
		<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-rborder"><font size="2">
    	<cfoutput>#url.errType#</cfoutput>
	<cfelseif isdefined("cfcatch.Type")>
			<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Tipo:</font></div></td>
			<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-rborder"><font size="2">
			<cfoutput>#cfcatch.Type#</cfoutput>
	<cfelse>
			<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></div></td>
			<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-rborder"><font size="2">
	</cfif>
	   &nbsp;</font></td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Mensaje:</font></div></td>
    <td valign="top" bgcolor="#F5F5F5" class="contenido-rborder"><font size="2"> 
      <cfif isdefined("cfcatch.SQLState")>
        <cfoutput>#cfcatch.SQLState#<br>
        </cfoutput> 
      </cfif>
	<cfif isdefined("url.errMsg")>
      <cfoutput>#URLDecode(url.errMsg)#</cfoutput><br>
	<cfelse>
		<cfif isdefined("cfcatch.Message")>
	      <cfoutput>#cfcatch.Message#</cfoutput><br>
		</cfif>
	</cfif>
      <br>
      <font color="#FF3300">
	<cfif isdefined("url.errDet")>
	  <cfoutput>#url.errDet#</cfoutput>
	<cfelse>
		<cfif isdefined("cfcatch.Detail")>
		  <cfoutput>#cfcatch.Detail#</cfoutput>
		</cfif>
	</cfif>
	  </font></font><br> &nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
        <cfif isdefined("cfcatch.SQLState")>
          SQL: 
          <cfelse>
          &nbsp; 
        </cfif>
        </font></div></td>
    <td valign="top" bgcolor="#F5F5F5" class="contenido-rborder"><font size="2"> 
      <cfif isdefined("cfcatch.sql")>
        <cfoutput>#cfcatch.sql#</cfoutput> 
      </cfif>
      &nbsp;</font></td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder">&nbsp;</td>
    <td valign="top" bgcolor="#F5F5F5" class="contenido-rborder">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lrborder"><div align="center">
        <input type="button" name="Button" value="Regresar" onClick="javascript:history.back()">
      </div></td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2" align="center" valign="middle" nowrap bgcolor="#F5F5F5" class="contenido-lbrborder"><div align="center">&nbsp; 
<cfif isdefined("Session.tblError") and Session.tblError neq "">
  <cfoutput>#Session.tblError#</cfoutput>
  <cfset Session.tblError = "">
</cfif>
      </div></td>
    <td>&nbsp;</td>
  </tr>
</table>

</body>
</html>
