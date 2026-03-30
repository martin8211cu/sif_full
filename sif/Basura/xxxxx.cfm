<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_Recordset1" default="1">
<cfquery name="Recordset1" datasource="asp">
select Usulogin, Usucodigo from Usuario order by Usulogin
</cfquery>
<cfset MaxRows_Recordset1=10>
<cfset StartRow_Recordset1=Min((PageNum_Recordset1-1)*MaxRows_Recordset1+1,Max(Recordset1.RecordCount,1))>
<cfset EndRow_Recordset1=Min(StartRow_Recordset1+MaxRows_Recordset1-1,Recordset1.RecordCount)>
<cfset TotalPages_Recordset1=Ceiling(Recordset1.RecordCount/MaxRows_Recordset1)>
<cfset QueryString_Recordset1=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_Recordset1,"PageNum_Recordset1=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_Recordset1=ListDeleteAt(QueryString_Recordset1,tempPos,"&")>
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>
<table border="0" cellpadding="2" cellspacing="0">
  <tr>
    <td>Usulogin</td>
    <td>Usucodigo</td>
  </tr>
  <cfoutput query="Recordset1" startRow="#StartRow_Recordset1#" maxRows="#MaxRows_Recordset1#">
    <tr>
      <td>#Recordset1.Usulogin#</td>
      <td>#Recordset1.Usucodigo#</td>
    </tr>
  </cfoutput>
</table>
<p>
  <cfoutput>Records #StartRow_Recordset1# to #EndRow_Recordset1# of #Recordset1.RecordCount# </cfoutput>
<table border="0" width="50%" align="center">
  <cfoutput>
    <tr>
      <td width="23%" align="center"><cfif PageNum_Recordset1 GT 1>
          <a href="#CurrentPage#?PageNum_Recordset1=1#QueryString_Recordset1#">First</a>
        </cfif>
      </td>
      <td width="31%" align="center"><cfif PageNum_Recordset1 GT 1>
          <a href="#CurrentPage#?PageNum_Recordset1=#Max(DecrementValue(PageNum_Recordset1),1)##QueryString_Recordset1#">Previous</a>
        </cfif>
      </td>
      <td width="23%" align="center"><cfif PageNum_Recordset1 LT TotalPages_Recordset1>
          <a href="#CurrentPage#?PageNum_Recordset1=#Min(IncrementValue(PageNum_Recordset1),TotalPages_Recordset1)##QueryString_Recordset1#">Next</a>
        </cfif>
      </td>
      <td width="23%" align="center"><cfif PageNum_Recordset1 LT TotalPages_Recordset1>
          <a href="#CurrentPage#?PageNum_Recordset1=#TotalPages_Recordset1##QueryString_Recordset1#">Last</a>
        </cfif>
      </td>
    </tr>
  </cfoutput>
</table>
</p>
</body>
</html>
