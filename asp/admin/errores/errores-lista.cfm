<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_lista" default="1">
<cfparam name="url.sort" default="-1" type="numeric">
<cfparam name="url.id" default="0" type="numeric">

<cfparam name="url.fFecha" default="">
<cfparam name="url.fLogin" default="">
<cfparam name="url.fComponente" default="">
<cfparam name="url.fTitulo" default="">
<cfif REFind('^\d\d\/\d\d\/\d\d$',url.fFecha) is 0><cfset url.fFecha = ''><cfelse><cfset filtroFecha=LSParseDateTime(url.fFecha)></cfif>

<cfquery datasource="aspmonitor" name="lista">
select errorid, cuando, componente, titulo, leido, login, sessionid, ip
from MonErrores
where eliminar = 0 
<cfif len(url.fFecha)>
  and cuando >= <cfqueryparam cfsqltype="cf_sql_date" value="#filtroFecha#">
  and cuando <  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,filtroFecha)#">
</cfif>
<cfif len(url.fLogin)>
  and (lower (login) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fLogin)#%">
    or lower (ip) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fLogin)#%">)
</cfif>
<cfif len(url.fComponente)>
  and lower (componente) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fComponente)#%">
</cfif>
<cfif len(url.fTitulo)>
  and(lower (titulo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fTitulo)#%">
   or lower (detalle) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fTitulo)#%">)
</cfif>
<cfif abs(url.sort) is 1>
	order by errorid
<cfelseif abs(url.sort) is 2>
	order by upper(componente)
<cfelseif abs(url.sort) is 3>
	order by upper(titulo)
</cfif>
<cfif url.sort lt 0> desc </cfif>
</cfquery>
<cfset MaxRows_lista=40>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,lista.RecordCount)>
<cfset TotalPages_lista=Ceiling(lista.RecordCount/MaxRows_lista)>
<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
<style type="text/css">
<!--
.inputfiltro {
	border: 1px solid;
	width: 100%;
}
-->
</style>

 <cfoutput><form action="index.cfm" name="form1" method="get">
<table width="485" border="0" cellpadding="2" cellspacing="0">
  <cfset link = CurrentPage & "?PageNum_lista="& PageNum_lista >
  <cfif Len(url.fLogin)><cfset link = link & "&fLogin=" & url.fLogin></cfif>
  <cfif Len(url.fComponente)><cfset link = link & "&fComponente=" & url.fComponente></cfif>
  <cfif Len(url.fTitulo)><cfset link = link & "&fTitulo=" & url.fTitulo></cfif>
  <cfset tit_link = link & '&sort=' & url.sort>
  <cfif isdefined("url.id")><cfset link = link & "&id=" & lista.errorid></cfif>
  <tr>
  <td width="22" valign="top"></td>
  <td width="15" valign="top"></td>
    <td width="59" valign="top" ><a href="#link#&sort=<cfif url.sort is 1>-1<cfelse>1</cfif>"><cfif url.sort is 1> &uarr; <cfelseif url.sort is -1> &darr; </cfif><strong>Fecha</strong></a></td>
    <td width="104" valign="top">Login / IP </td>
    <td width="104" valign="top"><a href="#link#&sort=<cfif url.sort is 2>-2<cfelse>2</cfif>"><cfif url.sort is 2> &uarr; <cfelseif url.sort is -2> &darr; </cfif><strong>Componente</strong></a></td>
    <td width="157" valign="top"><a href="#link#&sort=<cfif url.sort is 3>-3<cfelse>3</cfif>"><cfif url.sort is 3> &uarr; <cfelseif url.sort is -3> &darr; </cfif><strong>T&iacute;tulo</strong></a></td>
  </tr>
  <tr>
    <td valign="top" colspan="2"><input type="submit" value="Buscar">
	<input type="hidden" name="id" value="#HTMLEditFormat(url.id)#">
	<input type="hidden" name="sort" value="#HTMLEditFormat(url.sort)#">
	</td>
    <td valign="top"><input type="text" size="10" name="fFecha" value="#HTMLEditFormat(url.fFecha)#" onFocus="this.select()" class="inputfiltro"></td>
    <td valign="top"><input type="text" size="8" name="fLogin" value="#HTMLEditFormat(url.fLogin)#" onFocus="this.select()" class="inputfiltro"></td>
    <td valign="top"><input type="text" size="10" name="fComponente" value="#HTMLEditFormat(url.fComponente)#" onFocus="this.select()" class="inputfiltro"></td>
    <td valign="top"><input type="text" size="10" name="fTitulo" value="#HTMLEditFormat(url.fTitulo)#" onFocus="this.select()" class="inputfiltro"></td>
  </tr>
  <cfloop query="lista" startRow="#StartRow_lista#" endRow="#StartRow_lista+MaxRows_lista-1#">
  	<cfset link = tit_link & "&id=" & lista.errorid>
	<cfif lista.leido is 0 and lista.errorid neq url.id>
		<cfset style=' style="font-weight:bold;" '>
	<cfelse>
		<cfset style=' '>
	</cfif>
    <tr class="lista<cfif lista.CurrentRow mod 2 is 1>Par<cfelse>Non</cfif>"
		<cfif lista.errorid is url.id> style="background-color:##e4e8f3;text-indent:0"
		<cfelse> style="text-indent:0"
		onmouseover="style.backgroundColor='##E4E8F3';"
		onmouseout="style.backgroundColor='##<cfif lista.CurrentRow mod 2 is 0>ffffff<cfelse>fafafa</cfif>';"
		</cfif>
		>
		<td valign="top"><cfif lista.errorid is url.id><img src="images/addressGo.gif" width="17" height="15">
		</cfif></td>
      <td valign="top"><a href="#link#" #style#>#lista.errorid#</a></td>
      <td valign="top"><a href="#link#" #style#>#DateFormat(lista.cuando,'dd/mm/yy')#
	  <br>#TimeFormat(lista.cuando,'HH:mm:ss')#</a></td>
      <td valign="top"><a href="#link#" #style#>#lista.login#
	  <br>#REReplace(lista.ip,'/.*$','')#</a></td>
      <td valign="top"><a href="#link#" #style#>#lista.componente#</a></td>
      <td valign="top"><a href="#link#" #style#>#lista.titulo#</a></td>
    </tr>
  </cfloop>
  <cfif lista.RecordCount eq 0>
  <tr><td colspan="6"><br><br>
  <strong>No hay errores pendientes de revisi&oacute;n </strong></td>
  </tr>
  </cfif>
</table>
 
<table border="0" width="50%" align="center">
    <tr>
      <td width="23%" align="center">
        <cfif PageNum_lista GT 1>
          <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#"><img src="images/First.gif" border=0></a>
        </cfif>
      </td>
      <td width="31%" align="center">
        <cfif PageNum_lista GT 1>
          <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#"><img src="images/Previous.gif" border=0></a>
        </cfif>
      </td>
      <td width="23%" align="center">
        <cfif PageNum_lista LT TotalPages_lista>
          <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#"><img src="images/Next.gif" border=0></a>
        </cfif>
      </td>
      <td width="23%" align="center">
        <cfif PageNum_lista LT TotalPages_lista>
          <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#"><img src="images/Last.gif" border=0></a>
        </cfif>
      </td>
    </tr>
</table>

Mostrando #StartRow_lista# a #EndRow_lista# de #lista.RecordCount#
</form></cfoutput> 
