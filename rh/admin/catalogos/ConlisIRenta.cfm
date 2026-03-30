<html>
<head>
<title>Lista de Tablas de Impuesto de Renta</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfquery name="conlis" datasource="sifcontrol">
	select rtrim(IRcodigo) as IRcodigo, ltrim(rtrim(IRdescripcion)) as  IRdescripcion 
	from ImpuestoRenta
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
	// limpia las cuentas
	window.opener.document.form1.IRcodigo.value      = valor1;
	window.opener.document.form1.IRdescripcion.value = valor2; 
	window.close();	
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
    <tr> 
      <td width="44%" nowrap  class="tituloListas"><div align="left">Código</div></td>
      <td width="28%" nowrap  class="tituloListas"><div align="left">Descripción</div></td>
      <td width="1%" nowrap class="tituloListas"><div align="right"> 
          <input type="submit" name="Filtrar" value="Filtrar">
      </div></td>
    </tr>
    <tr> 
      <td nowrap><input name="Ccodigo" type="text" size="40" maxlength="100"></td>
      <td colspan="2" nowrap><input name="IRdescripcion" type="text" size="40" maxlength="60"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td nowrap <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="Ccodigo#conlis.CurrentRow#" value="#conlis.IRcodigo#"> 
        <a href="javascript:Asignar('#conlis.IRcodigo#', '#JSStringFormat(conlis.IRdescripcion)#');">#conlis.IRcodigo#</a></td>
        <td colspan="2" nowrap <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#conlis.IRcodigo#', '#JSStringFormat(conlis.IRdescripcion)#');">#conlis.IRdescripcion#</a></td>
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
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> </table> <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>


