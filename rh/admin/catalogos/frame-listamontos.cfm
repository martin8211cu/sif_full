<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_data" default="1">
<cfquery name="data" datasource="#Session.dsn#">
	select RHMCid, Ecodigo, CSid, RHMCcodigo, 
			RHMCdescripcion = case when datalength(RHMCdescripcion) < 30 then RHMCdescripcion else substring(RHMCdescripcion,1,27) + '...' end, 
			RHMCfecharige, 
			RHMCfechahasta = case isnull(RHMCfechahasta,'61000101') when '61000101' then 'Indefinido' else convert(varchar,RHMCfechahasta,103) end , 
			RHMCcomportamiento, RHMCtopeporc, RHMCestadometodo = case RHMCestadometodo when 1 then 'Aplicado' else 'Pendiente' end, 
			RHMCindicador, RHMCvalor
	from RHMetodosCalculo
	where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
</cfquery>
<cfset MaxRows_data=10>
<cfset StartRow_data=Min((PageNum_data-1)*MaxRows_data+1,Max(data.RecordCount,1))>
<cfset EndRow_data=Min(StartRow_data+MaxRows_data-1,data.RecordCount)>
<cfset TotalPages_data=Ceiling(data.RecordCount/MaxRows_data)>
<cfset QueryString_data=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PageNum_data=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif>
<cfset params = "">
<cfset tempPos=ListContainsNoCase(QueryString_data,"RHCAid=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&RHCAid=" & Form.RHCAid>
<cfset tempPos=ListContainsNoCase(QueryString_data,"CSid=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&CSid=" & Form.CSid>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PAGENUMPADRE=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&PAGENUMPADRE=" & Form.PAGENUMPADRE>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PAGENUM=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&PAGENUM=" & Form.PAGENUM>


<table width="100%"  border="0" cellspacing="0" cellpadding="0">

  <tr>
	<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
	<td class="tituloListas" align="left" height="17" nowrap>C&oacute;digo</td>
	<td class="tituloListas" align="left" height="17" nowrap>Descripci&oacute;n</td>
	<td class="tituloListas" align="left" height="17" nowrap>Fecha Rige</td>
	<td class="tituloListas" align="left" height="17" nowrap>Fecha Hasta</td>
	<td class="tituloListas" align="left" height="17" nowrap>Estado</td>
	<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
  </tr> 
  
  <cfoutput query="data" maxrows="#MaxRows_data#" startrow="#StartRow_data#">
	<tr class=<cfif data.CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif data.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<td align="left" width="18" height="18" nowrap onclick="javascript: ProcesarMonto('#RHMCid#');">
			<cfif isdefined("Form.RHMCid") and comparenocase('#data.RHMCid#','#Form.RHMCid#') EQ 0 and not isdefined("NuevoMonto")>
				<img src="/cfmx/rh/imagenes/addressGo.gif" width="18" height="18"> 
			</cfif>
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.RHMCcodigo#
			</a>
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.RHMCdescripcion#
			</a>
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#LSDateFormat(data.RHMCfecharige,'dd/mm/yyyy')#
			</a>
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.RHMCfechahasta#
			</a>
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.RHMCestadometodo#
			</a>
		</td>
		<td align="left" width="18" height="18" nowrap onclick="javascript: ProcesarMonto('#RHMCid#');"></td>
	</tr> 
  </cfoutput>
  
  <cfif data.RecordCount lte 0>
	<tr><td align="center" colspan="6" class="listaCorte">
		No se ha agregado ninguna vigencia.
	</td></tr>
  </cfif>

</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">

  <cfoutput>
    <tr>
	  <cfif PageNum_data GT 1>
        <td align="center">
        	<a href="#CurrentPage#?PageNum_data=1#QueryString_data##params#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a>
        </td>
	  </cfif>
      <cfif PageNum_data GT 1>
	    <td align="center">
          <a href="#CurrentPage#?PageNum_data=#Max(DecrementValue(PageNum_data),1)##QueryString_data##params#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a>
        </td>
	  </cfif>
	  <cfif PageNum_data LT TotalPages_data>
        <td align="center">
          <a href="#CurrentPage#?PageNum_data=#Min(IncrementValue(PageNum_data),TotalPages_data)##QueryString_data##params#"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a>
		</td>
	  </cfif>
	  <cfif PageNum_data LT TotalPages_data>
		<td align="center">
          <a href="#CurrentPage#?PageNum_data=#TotalPages_data##QueryString_data##params#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a>
      	</td>
	  </cfif>
    </tr>
  </cfoutput>
  
</table>
</body>
</html>
