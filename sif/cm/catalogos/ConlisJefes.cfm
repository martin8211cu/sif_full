<cfparam name="catalogo" default="S">
<html>
<head>
<title>Lista de Jefes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>

</head>
<cfif catalogo EQ 'S'>
<cfquery name="conlis2" datasource="#Session.DSN#">	
		select 
			CMSid as CMid, 
			CMSnombre as CMnombre, 
			Usucodigo, 
			ts_rversion		
		from CMSolicitantes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined("Form.Filtrar") and (Form.CMnombre NEQ "")>
		  and upper(CMSnombre) like '%#Ucase(Form.CMnombre)#%'
		</cfif>	  
		order by CMSnombre
</cfquery>	
<cfelseif catalogo EQ 'C'>
<cfquery name="conlis2" datasource="#Session.DSN#">	
		select 
			CMCid as CMid, 
			CMCnombre as CMnombre, 
			Usucodigo, 
			ts_rversion		
		from CMCompradores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined("Form.Filtrar") and (Form.CMnombre NEQ "")>
		  and upper(CMCnombre) like '%#Ucase(Form.CMnombre)#%'
		</cfif>	  
		order by CMCnombre 
</cfquery>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis2.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis2.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis2.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">
function Asignar(valor1, valor2) 
{
	limpiar();
	window.opener.document.<cfoutput>#url.form#.#url.usu#</cfoutput>.value = valor1;
	window.opener.document.<cfoutput>#url.form#.#url.nombre#</cfoutput>.value = valor2;	
	window.close();
}

function limpiar() 
{
	// si es el catálogo de solicitantes
	if ('<cfoutput>#url.catalogo#</cfoutput>' == 'S') { 
		window.opener.document.<cfoutput>#url.form#.#url.usu#</cfoutput>.value = "";
		window.opener.document.<cfoutput>#url.form#.#url.nombre#</cfoutput>.value = "";	
	}
	// si es el catálogo de compradores
	if ('<cfoutput>#url.catalogo#</cfoutput>' == 'C') { 
		window.opener.document.<cfoutput>#url.form#.#url.usu#</cfoutput>.value = "";
		window.opener.document.<cfoutput>#url.form#.#url.nombre#</cfoutput>.value = "";	
	}
}
</script>

<body>
<form action="" method="post" name="conlis">
  <table width="38%" align="center" border="0" cellpadding="2" cellspacing="0">
    <tr class="areaFiltro">
      <td><strong>Nombre:</strong>&nbsp;</td>
      <td nowrap>
        <input name="CMnombre" type="text" size="40" maxlength="60">
      </td>
      <td> <font color="#FFFFFF">
        <input type="submit" name="Filtrar" value="Filtrar">
      </font> </td>
    </tr>
    <cfoutput query="conlis2" startrow="#StartRow_conlis#" maxrows="#MaxRows_conlis#">
      <tr>
        <td colspan="3" <cfif conlis2.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> <a href="javascript:Asignar('#conlis2.Usucodigo#', '#JSStringFormat(conlis2.CMnombre)#');">#conlis2.CMnombre#</a> </td>
      </tr>
    </cfoutput>
    <tr>
      <td colspan="3">&nbsp; </td>
    </tr>
    <tr>
      <td colspan="3">&nbsp;
          <table border="0" width="50%" align="center">
            <cfoutput>
              <tr>
                <td width="23%" align="center">
                  <cfif PageNum_conlis GT 1>
                    <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a>
                  </cfif>
                </td>
                <td width="31%" align="center">
                  <cfif PageNum_conlis GT 1>
                    <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a>
                  </cfif>
                </td>
                <td width="23%" align="center">
                  <cfif PageNum_conlis LT TotalPages_conlis>
                    <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a>
                  </cfif>
                </td>
                <td width="23%" align="center">
                  <cfif PageNum_conlis LT TotalPages_conlis>
                    <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a>
                  </cfif>
                </td>
              </tr>
            </cfoutput>
        </table></td>
    </tr>
  </table>
</form>
</body>
</html>