<html>
<head>
<title>Seleccionar Donante</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>
<cfquery name="conlis" datasource="#session.DSN#">
	select convert(varchar, MEpersona) as MEEid, 
	       Pid as MEEidentificacion,
		   isnull(Pnombre,'Anónimo') + ' ' + isnull(Papellido1, '') as MEEnombre
	from MEPersona
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and activo = 1

	<cfif isdefined("form.Filtrar") and Len(Trim(form.MEEidentificacion)) GT 0>
		and upper(Pid) like '%#Ucase(form.MEEidentificacion)#%'
	</cfif>
	<cfif isdefined("form.Filtrar") and Len(Trim(form.MEEnombre)) GT 0>
		and ( upper(Pnombre) like '%#Ucase(form.MEEnombre)#%' or upper(Papellido1) like '%#Ucase(form.MEEnombre)#%' )
	</cfif>

</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=15>
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
      <td width="16%" bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">Identificación</font></div></td>
	  <td width="84%" bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">Nombre</font></div></td>
    </tr>
    <tr>
  	  <td><input name="MEEidentificacion" type="text" size="10" maxlength="10"></td> 
      <td>
	  	  <input name="MEEnombre" type="text" size="50" maxlength="50">
          <input type="submit" name="Filtrar" value="Filtrar">
	  </td>
    </tr>

    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="MEEid#conlis.CurrentRow#" value="#conlis.MEEid#"> 
          <a href="javascript:Asignar(#conlis.MEEid#, '#JSStringFormat(conlis.MEEnombre)#');">#conlis.MEEidentificacion#</a>
		</td>
	  
        <td <cfif conlis.CurrentRow MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="MEEid#conlis.CurrentRow#" value="#conlis.MEEid#"> 
          <a href="javascript:Asignar(#conlis.MEEid#, '#JSStringFormat(conlis.MEEnombre)#');">#conlis.MEEnombre#</a>
		</td>
      </tr>
    </cfoutput> 

    <tr> 
      <td colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="/cfmx/sif/imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a> 
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

