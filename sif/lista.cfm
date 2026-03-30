<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_data" default="1">
<cfquery name="data" datasource="minisif">
SELECT *
FROM dbo.RHMontosCategoria 
</cfquery>
<cfset MaxRows_data=10>
<cfset StartRow_data=Min((PageNum_data-1)*MaxRows_data+1,Max(data.RecordCount,1))>
<cfset EndRow_data=Min(StartRow_data+MaxRows_data-1,data.RecordCount)>
<cfset TotalPages_data=Ceiling(data.RecordCount/MaxRows_data)>
<cfset QueryString_data=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PageNum_data=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")>
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<table border="0" width="50%" align="center">

<cfoutput startrow="#StartRow_data#" maxrows="#MaxRows_data#" query="data">
<tr><td>#data.RHMCcodigo#</td></tr>
</cfoutput>


  <cfoutput>
    <tr>
      <td width="23%" align="center">
        <cfif PageNum_data GT 1>
          <a href="#CurrentPage#?PageNum_data=1#QueryString_data#"><img src="First.gif" border=0></a>
        </cfif>
      </td>
      <td width="31%" align="center">
        <cfif PageNum_data GT 1>
          <a href="#CurrentPage#?PageNum_data=#Max(DecrementValue(PageNum_data),1)##QueryString_data#"><img src="Previous.gif" border=0></a>
        </cfif>
      </td>
      <td width="23%" align="center">
        <cfif PageNum_data LT TotalPages_data>
          <a href="#CurrentPage#?PageNum_data=#Min(IncrementValue(PageNum_data),TotalPages_data)##QueryString_data#"><img src="Next.gif" border=0></a>
        </cfif>
      </td>
      <td width="23%" align="center">
        <cfif PageNum_data LT TotalPages_data>
          <a href="#CurrentPage#?PageNum_data=#TotalPages_data##QueryString_data#"><img src="Last.gif" border=0></a>
        </cfif>
      </td>
    </tr>
  </cfoutput>
</table>
</body>
</html>
