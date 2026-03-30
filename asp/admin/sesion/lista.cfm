<cfparam name="url.fecha" default="">
<cfparam name="url.fecha2" default="">
<cfparam name="url.sid"  default="">
<cfparam name="url.hora"  default="">
<cfparam name="url.login" default="">
<cfparam name="url.ip" default="">
<cfparam name="url.proceso" default="">
<cfparam name="url.aspsessid" default="">

<cfif Len(url.fecha) and REFind('^\d{2}/\d{2}/\d{4}$', url.fecha)>
	<cfset url.fecha = LSParseDateTime(url.fecha)>
<cfelse>
	<cfset url.fecha = ''>
</cfif>

<cfquery dataSource="aspmonitor" name="cant">
	select count(1) as n
	from MonProcesos mp
	where 1=1
	<cfif Len(url.sid)>
	  and mp.sessionid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.sid#">
	</cfif>
	<cfif Len(url.fecha)>
	  and mp.desde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url.fecha#"> 
	  				   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,url.fecha)#">
	</cfif>
	<cfif Len(url.login)>
		and lower(login) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.login)#%">
	</cfif>
	<cfif Len(url.ip)>
		and lower(ip) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.ip)#%">
	</cfif>
	<cfif len(url.proceso)>
		and (lower(SScodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.proceso)#%">
		  or lower(SMcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.proceso)#%">
		  or lower(SPcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.proceso)#"> 
		  )
	</cfif>
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_data" default="1">
<cfset MaxRows_data=50>
<cfset StartRow_data=Min((PageNum_data-1)*MaxRows_data+1,Max(cant.n,1))>
<cfset EndRow_data=Min(StartRow_data+MaxRows_data-1,cant.n)>
<cfset TotalPages_data=Ceiling(cant.n/MaxRows_data)>
<cfset QueryString_data=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PageNum_data=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")>
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_data,"aspsessid=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")>
</cfif>

<cfquery datasource="aspmonitor" name="data" maxrows="#StartRow_data + MaxRows_data#">
	select
	  sessionid, login, mp.SScodigo, mp.SMcodigo, mp.SPcodigo,
	  desde, acceso,
	  login,
	  ip, sessionid
	from MonProcesos mp
	where 1=1
	<cfif Len(url.sid)>
	  and mp.sessionid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.sid#">
	</cfif>
	<cfif Len(url.fecha)>
	  and mp.desde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url.fecha#"> 
	  				   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,url.fecha)#">
	</cfif>
   	<cfif Len(url.fecha2)>
	  and mp.acceso between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url.fecha2#"> 
	  				   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,url.fecha2)#">
	</cfif>
	<cfif Len(url.login)>
		and lower(login) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.login)#%">
	</cfif>
	<cfif Len(url.ip)>
		and lower(ip) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.ip)#%">
	</cfif>
	<cfif len(url.proceso)>
		and (lower(SScodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.proceso)#%">
		  or lower(SMcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.proceso)#%"> 
		  or lower(SPcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(url.proceso)#%"> 
		  )
	</cfif>
	order by 1 desc
	
</cfquery>


<form name="form1" method="get" action="">
      <table  border="0" cellspacing="0" cellpadding="2">
        <tr>
          <td>N&uacute;m</td>
          <td colspan="2">&Uacute;ltimo acceso </td>
          <td colspan="2">&Uacute;ltimo movimiento </td>
          <td>Login</td>
          <td>IP</td>
          <td>Proceso</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td><input name="sid" type="text" size="4" maxlength="10"></td>
          <td colspan="2"><cf_sifcalendario name="fecha"></td>
          <td colspan="2"><cf_sifcalendario name="fecha2"></td>
          <td><input name="login" type="text" size="8" maxlength="30"></td>
          <td><input name="ip" type="text" size="8" maxlength="30"></td>
          <td><input name="proceso" type="text" size="8" maxlength="30"></td>
          <td><input name="submit" type="submit" value="Buscar"></td>
        </tr>
          <cfoutput query="data" startRow="#StartRow_data#" maxRows="#MaxRows_data#">
            <tr style="cursor:hand;<cfif url.aspsessid is data.sessionid>background-color:skyblue;</cfif>" onClick="location.href='#CurrentPage#?PageNum_data=#PageNum_data##QueryString_data#&aspsessid=#sessionid#'"
			onMouseOver="window.status='sesion num #sessionid#'"
			onMouseOut="window.status=''"
			 class="<cfif data.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>">
              <td>#sessionid#</td>
              <td>#DateFormat(desde,'DD/MM/YY')#</td>
              <td>#TimeFormat(desde,'HH:mm')#</td>
              <td>#DateFormat(acceso,'DD/MM/YY')#</td>
              <td>#TimeFormat(acceso,'HH:mm')#</td>
              <td>#HTMLEditFormat(login)#</td>
              <td>#HTMLEditFormat(data.ip)#</td>
              <td>#HTMLEditFormat(SScodigo)# #HTMLEditFormat(SMcodigo)# #HTMLEditFormat(SPcodigo)#</td>
              <td>&nbsp;</td>
            </tr>
          </cfoutput>
        <tr>
          <td colspan="7">&nbsp;
            <table border="0" align="center">
              <cfoutput>
                <tr>
                  <td width="22" align="center">
                    <cfif PageNum_data GT 1>
                      <a href="#CurrentPage#?PageNum_data=1#QueryString_data#"><img src="First.gif" border=0></a>
                    </cfif>                  </td>
                  <td width="18" align="center">
                    <cfif PageNum_data GT 1>
                      <a href="#CurrentPage#?PageNum_data=#Max(DecrementValue(PageNum_data),1)##QueryString_data#"><img src="Previous.gif" border=0></a>
                    </cfif>                  </td>
                  <td width="18" align="center">
                    <cfif PageNum_data LT TotalPages_data>
                      <a href="#CurrentPage#?PageNum_data=#Min(IncrementValue(PageNum_data),TotalPages_data)##QueryString_data#"><img src="Next.gif" border=0></a>
                    </cfif>                  </td>
                  <td width="22" align="center">
                    <cfif PageNum_data LT TotalPages_data>
                      <a href="#CurrentPage#?PageNum_data=#TotalPages_data##QueryString_data#"><img src="Last.gif" border=0></a>
                    </cfif>                  </td>
                </tr>
              </cfoutput>
            </table></td>
          </tr>
      </table>
	  
	  




</form>