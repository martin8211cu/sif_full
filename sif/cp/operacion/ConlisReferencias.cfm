<html>
<head>
<title>Lista de Documentos de Referencia</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="a.IDdocumento"> as IDdocumento, a.CPTcodigo, a.Ddocumento, b.CPTdescripcion
	from EDocumentosCP a
	   inner join CPTransacciones b
	      on a.CPTcodigo = b.CPTcodigo 
	     and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = #Session.Ecodigo# 
	and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#"> 
	and b.CPTtipo = 'C'
	and coalesce(b.CPTpago, 0) != 1
	
	<cfif isdefined("Form.Filtrar") and (Form.IDdocumento NEQ "")>
	  and a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CPTcodigo NEQ "")>
	  and upper(a.CPTcodigo) like '%#Ucase(Form.CPTcodigo)#%'
	</cfif>	  	
	<cfif isdefined("Form.Filtrar") and (Form.Ddocumento NEQ "")>
	  and upper(a.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CPTdescripcion NEQ "")>
	  and upper(b.CPTdescripcion) like '%#Ucase(Form.CPTdescripcion)#%'
	</cfif>
	order by a.IDdocumento, a.CPTcodigo, a.Ddocumento, b.CPTdescripcion
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

<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>
<script language="JavaScript1.2">
function Asignar(valor1, valor2, valor3) {
	window.opener.document.<cfoutput>#url.form#.#url.docref#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.ref#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#.#url.ref1#</cfoutput>.value=valor3;
	window.close();
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
    <tr> 
      <td width="29%"  class="tituloListas"><div align="left">C&oacute;digo</div></td>
      <td width="29%"  class="tituloListas"><div align="left">Tipo</div></td>
      <td width="18%" class="tituloListas"><div align="left">Documento</div></td>
      <td width="18%" nowrap class="tituloListas"><div align="left">Transacci&oacute;n</div>
        </td>
      <td width="6%" class="tituloListas"> 
        <input type="submit" name="Filtrar" value="Filtrar">
        </td>
    </tr>
    <tr> 
      <td>
	  	<input name="IDdocumento" type="text" size="18" maxlength="18"
			onBlur="javascript:fm(this,0); "
			onFocus="javascript:this.value=qf(this); this.select();"
			onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
      <td><input name="CPTcodigo" type="text" size="4" maxlength="4"></td>
      <td><input type="text" name="Ddocumento" size="20" maxlength="20"></td>
      <td><input type="text" name="CPTdescripcion" size="20" maxlength="20"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="IDdocumento#conlis.CurrentRow#" value="#conlis.IDdocumento#"> 
          <a href="javascript:Asignar('#conlis.IDdocumento#', '#JSStringFormat(conlis.CPTcodigo)#', '#JSStringFormat(conlis.Ddocumento)#');">#conlis.IDdocumento#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#conlis.IDdocumento#', '#JSStringFormat(conlis.CPTcodigo)#', '#JSStringFormat(conlis.Ddocumento)#');">#conlis.CPTcodigo#</a></td>
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#conlis.IDdocumento#', '#JSStringFormat(conlis.CPTcodigo)#', '#JSStringFormat(conlis.Ddocumento)#');">#conlis.Ddocumento#</a></td>
        <td nowrap <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#conlis.IDdocumento#', '#JSStringFormat(conlis.CPTcodigo)#', '#JSStringFormat(conlis.Ddocumento)#');">#conlis.CPTdescripcion#</a></td>
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