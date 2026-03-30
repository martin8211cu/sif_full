<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_lista" default="1">
<cfparam name="sort" default="1" type="numeric">
<cfparam name="url.id" default="0" type="numeric">

<cfquery datasource="asp" name="lista">
select SMTPid, SMTPcreado, SMTPdestinatario, SMTPasunto
from SMTPQueue
<cfif abs(sort) is 1>
	order by SMTPcreado desc
<cfelseif abs(sort) is 2>
	order by upper(SMTPdestinatario)
<cfelseif abs(sort) is 3>
	order by upper(SMTPasunto)
</cfif>
<cfif sort lt 0> desc </cfif>
</cfquery>
<cfset MaxRows_lista=16>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,lista.RecordCount)>
<cfset TotalPages_lista=Ceiling(lista.RecordCount/MaxRows_lista)>
<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<table width="377" border="0" cellpadding="2" cellspacing="0">
  <cfset link = CurrentPage & "?PageNum_lista="& PageNum_lista >
  <cfif isdefined("url.id")><cfset link = link & "&id=" & lista.SMTPid>
  </cfif>
  <cfoutput>
  <tr>
  <td width="22"></td>
  <td width="15"></td>
    <td width="59" valign="top" ><a href="#link#&sort=<cfif sort is 1>-1<cfelse>1</cfif>"><strong>Fecha</strong></a></td>
    <td width="244" valign="top"><a href="#link#&sort=<cfif sort is 2>-2<cfelse>2</cfif>"><strong>Para</strong></a><br>
<a href="#link#&sort=<cfif sort is 3>-3<cfelse>3</cfif>"><strong>Asunto</strong></a></td>
    <td width="17"></td></tr></cfoutput>
  <cfoutput query="lista" startRow="#StartRow_lista#" maxRows="#MaxRows_lista#">
  	<cfset link = "index.cfm?PageNum_lista="& PageNum_lista & "&id=" & lista.SMTPid & "&sort=" & sort>
    <tr class="lista<cfif lista.CurrentRow mod 2 is 1>Par<cfelse>Non</cfif>" style="text-indent:0"
		<cfif lista.SMTPid is url.id> style="background-color:##e4e8f3"
		<cfelse>
		onmouseover="style.backgroundColor='##E4E8F3';"
		onmouseout="style.backgroundColor='##<cfif lista.CurrentRow mod 2 is 0>ffffff<cfelse>fafafa</cfif>';"
		</cfif>
		>
		<td><cfif lista.SMTPid is url.id><img src="images/addressGo.gif" width="17" height="15">
		</cfif></td>
      <td valign="top"><a href="#link#">#lista.CurrentRow#</a></td>
      <td valign="top"><a href="#link#">#DateFormat(lista.SMTPcreado,'dd/mm/yy')#</a></td>
      <td valign="top"><a href="#link#">#HTMLEditFormat(lista.SMTPdestinatario)#<br>#HTMLEditFormat(lista.SMTPasunto)#</a></td>
      <td valign="top"><a href="#link#"></a></td>
    </tr>
  </cfoutput>
  <cfif lista.RecordCount eq 0>
  <tr><td colspan="5"><br><br><strong>No hay correos pendientes de env&iacute;o</strong></td></tr>
  </cfif>
</table>

<table border="0" width="50%" align="center">
  <cfoutput>
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
  </cfoutput>
</table>

<cfoutput>Mostrando #StartRow_lista# a #EndRow_lista# de #lista.RecordCount# </cfoutput> 