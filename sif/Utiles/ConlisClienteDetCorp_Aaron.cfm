<!--<html>
<head>
<!---<title>Lista de <cfoutput><cfif Url.tipo EQ "P">Proveedores<cfelseif Url.tipo EQ "C">Clientes<cfelse>Socios de Negocio</cfif></cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>--->
</head>--->


<cf_templatecss>
<cfquery name="conlis" datasource="#Session.DSN#">	
	select CDCcodigo, CDCnombre, CDCidentificacion
	from ClientesDetallistasCorp 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	<!---<cfif isdefined("Url.tipo") and (Len(Trim(Url.tipo)) GT 0)>
		<cfif Url.tipo EQ "P">
		  and SNtiposocio != 'C'
		<cfelseif Url.tipo EQ "C">
		  and SNtiposocio != 'P'
		</cfif>	  
	</cfif>--->
	<cfif isdefined("Form.Filtrar") and (Form.CDCidentificacion NEQ "")>
  	  and upper(CDCidentificacion) like '%#Ucase(Form.CDCidentificacion)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.CDCnombre NEQ "")>
	  and upper(CDCnombre) like '%#Ucase(Form.CDCnombre)#%'
	</cfif>	  
	  <!---and SNinactivo = 0--->
	order by CDCnombre, CDCidentificacion 
</cfquery>
<!---
<cfif Url.tipo EQ "P">
	<cfset socio = "Proveedor">
<cfelseif Url.tipo EQ "C">
	<cfset socio = "Cliente">
<cfelse>
	<cfset socio = "Socio">
</cfif>--->

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
function Asignar(valor1, valor2, valor3) {
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#.#url.identificacion#</cfoutput>.value=valor3;
	window.close();
	<cfif isdefined("url.FuncJSalCerrar") and Len(Trim(url.FuncJSalCerrar)) GT 0><cfoutput>window.opener.#url.FuncJSalCerrar#;</cfoutput></cfif>
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
    <tr> 
      <td width="44%"  class="tituloListas"><div align="left"><cfoutput>Cliente Detallista Corporativo</cfoutput></div></td>
      <td width="28%" class="tituloListas"><div align="left">Nombre</div></td>
      <td width="1%" class="tituloListas"><div align="right"> 
          <input type="submit" name="Filtrar" value="Filtrar">
          </div></td>
    </tr>
    <tr> 
      <td><input name="CDCidentificacion" type="text" size="40" maxlength="100"></td>
      <td colspan="2"><input name="CDCnombre" type="text" size="40" maxlength="60"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><input type="hidden" name="CDCidentificacion#conlis.CurrentRow#" value="#conlis.CDCidentificacion#"> 
          <a href="javascript:Asignar('#conlis.CDCcodigo#', '#JSStringFormat(conlis.CDCnombre)#', '#JSStringFormat(conlis.CDCidentificacion)#');">#conlis.CDCidentificacion#</a></td>
        <td colspan="2" <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>><a href="javascript:Asignar('#conlis.CDCcodigo#', '#JSStringFormat(conlis.CDCnombre)#', '#JSStringFormat(conlis.CDCidentificacion)#');">#conlis.CDCnombre#</a></td>
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
          </cfoutput> </table> <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>

