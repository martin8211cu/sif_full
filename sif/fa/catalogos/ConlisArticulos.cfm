
<html>
<head>
<title>Lista de Ar&iacute;culos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfif isdefined("url.origen") and len(trim(url.origen)) gt 0>
	<cfset form.origen = "P">
<cfelse>
	<cfset form.origen = "LP">
</cfif>

<cfquery name="conlis" datasource="#session.DSN#">

	select distinct convert(varchar, a.Aid) as Aid, b.Acodigo, b.Adescripcion
	from Existencias a, Articulos b
	where a.Aid=b.Aid
	  and a.Ecodigo=b.Ecodigo
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("form.Filtrar") and (form.Acodigo NEQ "")>
		and upper(b.Acodigo) like '%#Ucase(form.Acodigo)#%'
	</cfif>

	<cfif isdefined("form.Filtrar") and (form.Adescripcion NEQ "")>
		and upper(b.Adescripcion) like '%#Ucase(form.Adescripcion)#%'
	</cfif>

	order by b.Adescripcion

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
		window.opener.cambia_articulo(valor1);
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
      <td width="50%" class="tituloListas" colspan="2"><div align="left">Artículos</div></td>
    </tr>
    <tr> 
      <td><input name="Acodigo" type="text" size="15" maxlength="15">
	  </td>
      <td><input name="Adescripcion" type="text" size="50" maxlength="80">
          <input type="submit" name="Filtrar" value="Filtrar">
		  <input type="hidden" name="origen" value="<cfoutput>#form.origen#</cfoutput>">
	  </td>
	  
    </tr>

    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 

        <!--- codigo --->
		<td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="Acodigo#conlis.CurrentRow#" value="#conlis.Acodigo#"> 
          <a href="javascript:Asignar(#conlis.Aid#, '#JSStringFormat(conlis.Adescripcion)#');">#conlis.Acodigo#</a>
		</td>

		<!--- Descripcion --->
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
			<input type="hidden" name="Adescripcion#conlis.CurrentRow#" value="#conlis.Adescripcion#"> 
          <a href="javascript:Asignar(#conlis.Aid#, '#JSStringFormat(conlis.Adescripcion)#');">#conlis.Adescripcion#</a>
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
