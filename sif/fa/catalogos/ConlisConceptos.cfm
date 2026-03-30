
<html>
<head>
<title>Lista de Conceptos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfif isdefined("url.origen") and len(trim(url.origen)) gt 0>
	<cfset form.origen = "P">
<cfelse>
	<cfset form.origen = "LP">
</cfif>

<cfquery name="conlis" datasource="#session.DSN#">

	select convert(varchar, Cid) as Cid, Ccodigo, Cdescripcion  
	from Conceptos 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Ctipo = 'I'

	<cfif isdefined("form.Filtrar") and (form.Ccodigo NEQ "")>
		and upper(Ccodigo) like '%#Ucase(form.Ccodigo)#%'
	</cfif>

	<cfif isdefined("form.Filtrar") and (form.Cdescripcion NEQ "")>
		and upper(Cdescripcion) like '%#Ucase(form.Cdescripcion)#%'
	</cfif>

	order by Cdescripcion

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
function Asignar(valor1, valor2 ) {
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;

	// solo cuando lo llama la list ade precios
	<cfif form.origen eq 'LP'>
		window.opener.document.form1.DLdescripcion.value=valor2;
		window.opener.existe();
	</cfif>	

	window.close();
}
</script>

<body>
<form action="" method="post" name="conlis">
  <table width="97%" border="0" cellspacing="0">
    <tr> 
      <td width="50%"  class="tituloListas" colspan="2"><div align="left">Servicios</div></td>
    </tr>
    <tr> 
      <td><input name="Ccodigo" type="text" size="10" maxlength="10">
	  </td>
      <td><input name="Cdescripcion" type="text" size="50" maxlength="50">
          <input type="submit" name="Filtrar" value="Filtrar">
		  <input type="hidden" name="origen" value="<cfoutput>#form.origen#</cfoutput>">
	  </td>
	  
    </tr>

    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 

        <!--- codigo --->
		<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="Ccodigo#conlis.CurrentRow#" value="#conlis.Ccodigo#"> 
          <a href="javascript:Asignar(#conlis.Cid#, '#JSStringFormat(conlis.Cdescripcion)#');">#conlis.Ccodigo#</a>
		</td>

		<!--- Descripcion --->
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="Cdescripcion#conlis.CurrentRow#" value="#conlis.Cdescripcion#"> 
          <a href="javascript:Asignar(#conlis.Cid#, '#JSStringFormat(conlis.Cdescripcion)#');">#conlis.Cdescripcion#</a>
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
