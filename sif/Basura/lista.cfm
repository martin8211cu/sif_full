<cfset Form.RHVTid = 22>
<cfset Form.RHTTid = 6>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_data" default="1">
<cfquery name="data" datasource="minisif">
	select RHMCid, RHMCcodigo, RHMCmonto
	from RHMontosCategoria
	where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
	and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
</cfquery>
<cfset MaxRows_data=10>
<cfset StartRow_data=Min((PageNum_data-1)*MaxRows_data+1,Max(data.RecordCount,1))>
<cfset EndRow_data=Min(StartRow_data+MaxRows_data-1,data.RecordCount)>
<cfset TotalPages_data=Ceiling(data.RecordCount/MaxRows_data)>
<cfset QueryString_data=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PageNum_data=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif>
<cfset params = "">
<cfset tempPos=ListContainsNoCase(QueryString_data,"RHTTid=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "RHTTid=" & Form.RHTTid>
<cfset tempPos=ListContainsNoCase(QueryString_data,"RHVTid=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "RHVTid=" & Form.RHVTid>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PAGENUMPADRE=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "PAGENUMPADRE=" & Form.PAGENUMPADRE>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PAGENUM=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "PAGENUM=" & Form.PAGENUM>


<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  
  
<cf_templatecss>
  <tr>
	<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
	<td class="tituloListas" align="left" width="18" height="17" nowrap>Montos</td>
  </tr> 
  
  <cfoutput query="data" maxrows="#MaxRows_data#" startrow="#StartRow_data#">
	<tr class=<cfif data.CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif data.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<td align="left" width="18" height="18" nowrap onclick="javascript: ProcesarMonto('#RHMCid#');">
			<cfif isdefined("Form.RHMCid") and comparenocase('#data.RHMCid#','#Form.RHMCid#') EQ 0 and not isdefined("NuevoMonto")>
				<img src="/cfmx/sif/imagenes/addressGo.gif" width="18" height="18"> 
			</cfif>
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.RHMCcodigo# - #LsCurrencyFormat(data.RHMCmonto,"none")#
			</a>
		</td>
	</tr> 
  </cfoutput>
  
  <cfif data.RecordCount lte 0>
	<tr><td align="center" colspan="2" class="listaCorte">
		No se ha agregado ningún monto a la vigencia.
	</td></tr>
  </cfif>

</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">

  <cfoutput>
    <tr>
      <td width="23%" align="center">
        <cfif PageNum_data GT 1>
          <a href="#CurrentPage#?PageNum_data=1#QueryString_data##params#"><img src="../First.gif" border=0></a>
        </cfif>
      </td>
      <td width="31%" align="center">
        <cfif PageNum_data GT 1>
          <a href="#CurrentPage#?PageNum_data=#Max(DecrementValue(PageNum_data),1)##QueryString_data##params#"><img src="../Previous.gif" border=0></a>
        </cfif>
      </td>
      <td width="23%" align="center">
        <cfif PageNum_data LT TotalPages_data>
          <a href="#CurrentPage#?PageNum_data=#Min(IncrementValue(PageNum_data),TotalPages_data)##QueryString_data##params#"><img src="../Next.gif" border=0></a>
        </cfif>
      </td>
      <td width="23%" align="center">
        <cfif PageNum_data LT TotalPages_data>
          <a href="#CurrentPage#?PageNum_data=#TotalPages_data##QueryString_data##params#"><img src="../Last.gif" border=0></a>
        </cfif>
      </td>
    </tr>
  </cfoutput>
  
</table>
</body>
</html>
