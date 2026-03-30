<html>
<head>
<title>
	Lista de Cajas
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">	
	Select 	FCcodigo,
			FCdesc,
			convert(varchar,FCid) as FCid
	from FCajas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.Filtrar") and (Form.FCcodigo NEQ "")>
  	  and upper(FCcodigo) like '%#Ucase(Form.FCcodigo)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.FCdesc NEQ "")>
	  and upper(FCdesc) like '%#Ucase(Form.FCdesc)#%'
	</cfif>
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">

function Asignar(valor1, valor2) {

	limpiar();
		
	window.opener.document.<cfoutput>#url.form#.#url.fcid#</cfoutput>.value = valor1;
	window.opener.document.<cfoutput>#url.form#.#url.fcdesc#</cfoutput>.value = valor2;
	window.close();
	
}

function limpiar() {
	window.opener.document.<cfoutput>#url.form#.#url.fcid#</cfoutput>.value = "";
	window.opener.document.<cfoutput>#url.form#.#url.fcdesc#</cfoutput>.value = "";
}
</script>

<body>
<form action="" method="post" name="conlis">
  <table width="100%" border="0" cellspacing="0">
    <tr>
      <td width="20%"  class="tituloListas">C&oacute;digo</td>
      <td colspan="2" width="70%" class="tituloListas"><div align="left">Descripci&oacute;n</div></td>
      <td width="10%" class="tituloListas"><div align="right">
          <input type="submit" name="Filtrar" value="Filtrar">
          </div></td>
    </tr>
    <tr>
      <td><input type="text" name="FCcodigo" size="30" maxlength="15"></td>
      <td colspan="3"><input type="text" name="FCdesc" size="70" maxlength="60"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
	  	<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.FCid)#','#JSStringFormat(conlis.FCdesc)#');">#conlis.FCcodigo#</a></td>
        <td colspan="3" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
          <a href="javascript: Asignar('#JSStringFormat(conlis.FCid)#','#JSStringFormat(conlis.FCdesc)#');">#conlis.FCdesc#</a></td>
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="4">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> 
        </table>
        <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>