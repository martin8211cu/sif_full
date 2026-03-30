
<html>
<head>
<title>Lista de Documentos de Referencia</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">
	select a.CCTcodigo, a.Ddocumento, b.CCTdescripcion
	from Documentos a, CCTransacciones b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
	and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#"> 
	and b.CCTtipo = 'D'
	and coalesce(b.CCTpago, 0) != 1
	and a.Ecodigo = b.Ecodigo
	and a.CCTcodigo = b.CCTcodigo 
 	<cfif isdefined("Form.Filtrar") and (Form.CCTcodigo NEQ "")>
	  and upper(a.CCTcodigo) like '%#Ucase(Form.CCTcodigo)#%'
	</cfif>	  	
	<cfif isdefined("Form.Filtrar") and (Form.Ddocumento NEQ "")>
	  and upper(a.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CCTdescripcion NEQ "")>
	  and upper(b.CCTdescripcion) like '%#Ucase(Form.CCTdescripcion)#%'
	</cfif>
	order by a.CCTcodigo, a.Ddocumento, b.CCTdescripcion
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
function Asignar(valor2, valor3) {
	window.opener.document.<cfoutput>#url.form#.#url.ref#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#.#url.ref1#</cfoutput>.value=valor3;
	window.close();
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="100%" border="0" cellspacing="0">
    <tr> 
      <td width="29%"  class="tituloListas"><div align="left">Tipo</div></td>
      <td width="18%"  class="tituloListas"><div align="left">Documento</div></td>
      <td width="18%" nowrap class="tituloListas"><div align="left">Transacci&oacute;n &nbsp;</div>
        </td>
      <td width="6%" class="tituloListas">
        <input type="submit" name="Filtrar" value="Filtrar">
        </td>
    </tr>
    <tr> 
      <td><input name="CCTcodigo" type="text" size="4" maxlength="4"></td>
      <td><input type="text" name="Ddocumento" size="20" maxlength="20"></td>
      <td><input type="text" name="CCTdescripcion" size="20" maxlength="20"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#', '#JSStringFormat(conlis.Ddocumento)#');">#conlis.CCTcodigo#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#', '#JSStringFormat(conlis.Ddocumento)#');">#conlis.Ddocumento#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#JSStringFormat(conlis.CCTcodigo)#', '#JSStringFormat(conlis.Ddocumento)#');">#conlis.CCTdescripcion#</a></td>
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


