<cfparam name="url.fID" default="">
<cfparam name="url.fHora" default="">
<cfparam name="url.fMillis" default="">
<cfparam name="url.fMethod" default="">
<cfparam name="url.fURI" default="">
<cfparam name="url.fArgs" default="">
<cfparam name="url.fSrvprocid" default="">
<cfparam name="url.fSessionid" default="">
<cfparam name="url.fHistoriaid" default="">
<cfparam name="url.srt" default="1">
<cfparam name="url.sr2" default="d">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfif ListFind('1,2,3,4,5,6,7,8,9',url.srt) is 0>
	<cfset url.srt = 1>
</cfif>
<cfif ListFind('a,d',url.sr2) is 0>
	<cfset url.sr2 = 1>
</cfif>
<cfif REFind('^\d{1,2}/\d{1,2}/\d{1,4}( \d{1,2}:\d{1,2}(:\d{1,2})?)?$', url.fHora)>
	<cfset fHoraDate = LSParseDateTime(url.fHora)>
	<cfif Year(fHoraDate) gt 1990 and Year(fHoraDate) le 3500>
		<!--- esto reduce la vida util del sistema a mil quinientos años :) --->
		<cfset url.fHora = DateFormat(fHoraDate, 'DD/MM/YYYY') & ' ' & TimeFormat(fHoraDate, 'HH:MM:SS')>
	<cfelse>
		<cfset url.fHora = ''>
	</cfif>
<cfelse>
	<cfset url.fHora = ''>
</cfif>

<cftransaction isolation="read_uncommitted">
<cfquery datasource="aspmonitor" name="lista" maxrows="500">
	<cf_dbrowcount1 rows="500" datasource="aspmonitor">
select *
from MonRequest
where 1=1
<cfif Application.dsinfo.asp.type is 'oracle'>
  and rownum < 500
</cfif>
<cfif len(url.fID)>
  and requestid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fID#">
</cfif>
<cfif len(url.fHora)>
  and requested <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fHoraDate#">
</cfif>
<cfif len(url.fMillis)>
  and millis > <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fMillis#">
</cfif>
<cfif len(url.fMethod)>
  and upper(method) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(url.fMethod)#">
</cfif>
<cfif len(url.fURI)>
  and lower(uri) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fURI)#%">
</cfif>
<cfif len(url.fSrvprocid)>
  and srvprocid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fSrvprocid#">
</cfif>
<cfif len(url.fSessionid)>
  and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fSessionid#">
</cfif>
<cfif len(url.fHistoriaid)>
  and historiaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fHistoriaid#">
</cfif> 
order by 
	<cfif     url.srt is 1> requestid
	<cfelseif url.srt is 2>	requested
	<cfelseif url.srt is 3>	millis
	<cfelseif url.srt is 4>	method
	<cfelseif url.srt is 5>	uri
	<cfelseif url.srt is 6>	args
	<cfelseif url.srt is 7>	srvprocid
	<cfelseif url.srt is 8>	sessionid
	<cfelseif url.srt is 9>	historiaid
	<cfelse> requestid </cfif>
	<cfif url.sr2 is 'a'>asc<cfelse>desc</cfif> 

	<cf_dbrowcount1 rows="500" datasource="aspmonitor">
</cfquery>

</cftransaction>

<cfparam name="PageNum_lista" default="1">
<cfset MaxRows_lista=10>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,lista.RecordCount)>
<cfset TotalPages_lista=Ceiling(lista.RecordCount/MaxRows_lista)>
<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif><cf_templateheader title="Actividad del servidor">
<cfinclude template="/home/menu/pNavegacion.cfm">

<style type="text/css">
<!--
.filtro {
	width: 100%;
	border: 1px solid;
}
-->
</style>

  <form action="index.cfm" method="get" name="form1" id="form1">
<div class="subTitulo">Actividad del servidor</div>
	  <table border="0" cellpadding="2" cellspacing="0" width="100%" align="center">
        <tr class="tituloListas">
          <td nowrap><a href="javascript:srto(1)"><strong>N&uacute;m
            <cfif url.srt is 1><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(2)"><strong>Hora
            <cfif url.srt is 2><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(3)"><strong>ms
            <cfif url.srt is 3><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(4)"><strong>M&eacute;todo
            <cfif url.srt is 4><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(5)"><strong>URI
            <cfif url.srt is 5><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(6)"><strong>Args
            <cfif url.srt is 6><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(7)"><strong>Servidor
            <cfif url.srt is 7><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(8)"><strong>Sesi&oacute;n
            <cfif url.srt is 8><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap><a href="javascript:srto(9)"><strong>Historia
            <cfif url.srt is 9><cfif url.sr2 is 'a'>&uarr;<cfelse>&darr;</cfif></cfif></strong></a></td>
          <td nowrap>&nbsp;</td>
        </tr>
        <cfoutput>
          <tr class="tituloListas">
            <td>&nbsp;</td>
            <td nowrap>d/m/y h:m:s</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
          <td><input type="text" name="fID" id="fID" value="#url.fID#" onFocus="this.select()" size="10" class="filtro"></td>
          <td><input type="text" name="fHora" id="fHora" value="#url.fHora#" onFocus="this.select()" size="10" class="filtro" onKeyUp="this.style.color = this.value.match(/^\d{1,2}\/\d{1,2}\/\d{1,4} \d{1,2}:\d{1,2}:\d{1,2}$/) ? 'black' : 'red'"></td>
          <td><input type="text" name="fMillis" id="fMillis" value="#url.fMillis#" onFocus="this.select()" size="10" class="filtro"></td>
          <td><input type="text" name="fMethod" id="fMethod" value="#url.fMethod#" onFocus="this.select()" size="10" class="filtro"></td>
          <td><input type="text" name="fURI" id="fURI" value="#url.fURI#" onFocus="this.select()" size="10" class="filtro"></td>
          <td><input type="text" name="fArgs" id="fArgs" value="#url.fArgs#" onFocus="this.select()" size="10" class="filtro"></td>
          <td><input type="text" name="fSrvprocid" id="fSrvprocid" value="#url.fSrvprocid#" onFocus="this.select()" size="10" class="filtro"></td>
          <td><input type="text" name="fSessionid" id="fSessionid" value="#url.fSessionid#" onFocus="this.select()" size="10" class="filtro"></td>
          <td><input type="text" name="fHistoriaid" id="fHistoriaid" value="#url.fHistoriaid#" onFocus="this.select()" size="10" class="filtro"></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td colspan="9" align="right"><input type="submit" name="g" value="Buscar">
		  <input type="hidden" name="srt" value="#url.srt#">
		  <input type="hidden" name="sr2" value="#url.sr2#"></td>
          <td>&nbsp;</td>
        </tr></cfoutput>
        <cfoutput query="lista" startRow="#StartRow_lista#" maxRows="#MaxRows_lista#">
          <tr class="<cfif lista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
            <td nowrap>#requestid#</td>
            <td nowrap>#DateFormat(requested,'DD/MM/YYYY')# #TimeFormat(requested,'HH:MM:SS.LLL')#</td>
            <td nowrap align="right"><cfif len(millis) neq 0 and millis ge 0>#millis#</cfif></td>
            <td nowrap>#method#</td>
            <td nowrap>#uri#</td>
            <td nowrap>-</td>
            <td nowrap>#srvprocid#</td>
            <td nowrap>#sessionid#</td>
            <td nowrap>#historiaid#</td>
            <td nowrap>&nbsp;</td>
          </tr>
        </cfoutput>
        <tr>
          <td colspan="10"><table border="0" align="center">
                <cfoutput>
                  <tr>
                    <td width="22" align="center"><cfif PageNum_lista GT 1>
                        <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#"><img src="First.gif" border=0></a>
                      </cfif>
                    </td>
                    <td width="18" align="center"><cfif PageNum_lista GT 1>
                        <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#"><img src="Previous.gif" border=0></a>
                      </cfif>
                    </td>
                    <td width="18" align="center"><cfif PageNum_lista LT TotalPages_lista>
                        <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#"><img src="Next.gif" border=0></a>
                      </cfif>
                    </td>
                    <td width="22" align="center"><cfif PageNum_lista LT TotalPages_lista>
                        <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#"><img src="Last.gif" border=0></a>
                      </cfif>
                    </td>
                  </tr>
                </cfoutput>
                      </table></td>
          </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="8">&nbsp; <cfoutput>Registros #StartRow_lista# a #EndRow_lista# de #lista.RecordCount# </cfoutput> </td>
          <td>&nbsp;</td>
        </tr>
      </table>
    </form>
<cfoutput><script type="text/javascript">
<!--
function srto(n) {
	document.form1.srt.value = n;
	document.form1.sr2.value = <cfif url.sr2 is 'd'>(n==#url.srt#) ? 'a' : 'd'; <cfelse>	'd'; </cfif>
	document.form1.submit();
}
//-->
</script></cfoutput>

<cf_templatefooter>
