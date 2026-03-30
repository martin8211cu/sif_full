<html>
<head>
<title>Lista de Organizaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<cf_templatecss>
</head>
<cfquery name="conlis" datasource="#session.DSN#">
	select convert(varchar,EScodigo) as EScodigo, 
		ESOcodificacion, 
		ESOnombre, 
		ts_rversion
	from EstructuraOrganizacional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	
	<cfif isdefined("form.Filtrar") and Len(Trim(form.ESOcodificacion)) GT 0>
		and upper(ESOcodificacion) like '%#Ucase(form.ESOcodificacion)#%'
	</cfif>

	<cfif isdefined("form.Filtrar") and Len(Trim(form.ESOnombre)) GT 0>
		and upper(ESOnombre) like '%#Ucase(form.ESOnombre)#%'
	</cfif>
	
	order by ESOnombre
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
		window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
		window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
		window.close();
	}
</script>

<body>
<form action="" method="post" name="conlis">
  <table width="97%" border="0" cellspacing="0">
    <tr> 
      <td width="16%" bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">C&oacute;digo</font></div></td>
	  <td width="84%" bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">Descripci&oacute;n</font></div></td>
    </tr>
    <tr>
  	  <td><input name="ESOcodificacion" type="text" size="10" maxlength="10"></td> 
      <td>
	  	  <input name="ESOnombre" type="text" size="50" maxlength="50">
          <input type="submit" name="Filtrar" value="Buscar">
	  </td>
    </tr>

    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="EScodigo#conlis.CurrentRow#" value="#conlis.EScodigo#"> 
          <a href="javascript:Asignar(#conlis.EScodigo#, '#JSStringFormat(conlis.ESOnombre)#');">#conlis.ESOcodificacion#</a>
		</td>
	  
        <td <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="EScodigo#conlis.CurrentRow#" value="#conlis.EScodigo#"> 
          <a href="javascript:Asignar(#conlis.EScodigo#, '#JSStringFormat(conlis.ESOnombre)#');">#conlis.ESOnombre#</a>
		</td>
      </tr>
    </cfoutput> 

    <tr> 
      <td colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp; <table border="0" width="50%" align="center">
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

