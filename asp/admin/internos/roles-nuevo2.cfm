<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_users" default="1">
<cfparam name="url.NuevoRol" default="">
<cfif ListLen(url.NuevoRol,'.') NEQ 2>
	<cflocation url="roles.cfm">
</cfif>
<cfset SScodigo = ListGetAt(url.NuevoRol, 1, '.')>
<cfset SRcodigo = ListGetAt(url.NuevoRol, 2, '.')>

<cfquery datasource="asp" name="users">
	select distinct u.Usulogin, dp.Pnombre, dp.Papellido1, dp.Papellido2, u.Usucodigo,
		ce.CEnombre
	from Usuario u, DatosPersonales dp, CuentaEmpresarial ce
	where u.datos_personales = dp.datos_personales
	  and u.Utemporal = 0
	  and ce.CEcodigo = u.CEcodigo
	  and Usucodigo not in (
	  	select Usucodigo
		from UsuarioRol
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SScodigo#">
		  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SRcodigo#">
		)
	  and (
	  	lower (u.Usulogin) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.Usuario)#%">
		or
		lower (dp.Pnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.Usuario)#%">
		or
		lower (dp.Papellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.Usuario)#%">
		or
		lower (dp.Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.Usuario)#%">
		)
	order by CEnombre, Usulogin, Pnombre, Papellido1, Papellido2, Usucodigo
</cfquery>
<cfset MaxRows_users=10>
<cfset StartRow_users=Min((PageNum_users-1)*MaxRows_users+1,Max(users.RecordCount,1))>
<cfset EndRow_users=Min(StartRow_users+MaxRows_users-1,users.RecordCount)>
<cfset TotalPages_users=Ceiling(users.RecordCount/MaxRows_users)>
<cfset QueryString_users=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_users,"PageNum_users=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_users=ListDeleteAt(QueryString_users,tempPos,"&")>
</cfif>
<cf_templateheader title="Asignaci&oacute;n de roles internos">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Asignaci&oacute;n de grupos internos">
<form action="roles-nuevo3.cfm" method="get" name="form1" >	
<cfoutput>
  <strong>Grupo seleccionado:</strong> #HTMLEditFormat(url.NuevoRol)#</cfoutput>  
<br>
<br>
  Seleccione el usuario a quien desee incluir en este grupo <br>
<table width="95%" border="0" cellpadding="4" cellspacing="0">
  <tr>
    <td width="20%" class="tituloListas">Cuenta Empresarial </td>
    <td width="20%" class="tituloListas">Usuario</td>
    <td width="20%" class="tituloListas">Nombre</td>
    <td width="30%" class="tituloListas">&nbsp;</td>
    <td width="10%" class="tituloListas">&nbsp;</td>
  </tr>
  <cfset listaPar=false>
  <cfoutput query="users" startRow="#StartRow_users#" maxRows="#MaxRows_users#">
  	<cfset listaPar = not listaPar>
	<cfset link = "roles-nuevo3.cfm?SScodigo=" & HTMLEditFormat(SScodigo) & "&SRcodigo=" & HTMLEditFormat(SRcodigo) & "&uid=" & HTMLEditFormat(users.Usucodigo)>
	<cfif RecordCount is 1>
		<cflocation url="#link#" addtoken="no">
	</cfif>
    <tr class="<cfif listaPar>listaPar<cfelse>listaNon</cfif>" style="text-indent:0" onclick="location.href='#link#';">
      <td valign="top"><a href="#link#">#CEnombre#</a></td>
      <td valign="top"><a href="#link#">#Usulogin#</a></td>
      <td valign="top"><a href="#link#">
	  	# HTMLEditFormat( Pnombre) #
		#HTMLEditFormat(Papellido1)#
		#HTMLEditFormat(Papellido2)#</a></td>
      <td valign="top"> </td>
      <td valign="top"></td>
    </tr>
  </cfoutput>
  <tr>
    <td colspan="5">
      <table border="0" align="center">
        <cfoutput>
          <tr>
            <td width="22" align="center">
              <cfif PageNum_users GT 1>
                <a href="#CurrentPage#?PageNum_users=1#QueryString_users#"><img src="First.gif" border=0></a>
              </cfif>
            </td>
            <td width="18" align="center">
              <cfif PageNum_users GT 1>
                <a href="#CurrentPage#?PageNum_users=#Max(DecrementValue(PageNum_users),1)##QueryString_users#"><img src="Previous.gif" border=0></a>
              </cfif>
            </td>
            <td width="18" align="center">
              <cfif PageNum_users LT TotalPages_users>
                <a href="#CurrentPage#?PageNum_users=#Min(IncrementValue(PageNum_users),TotalPages_users)##QueryString_users#"><img src="Next.gif" border=0></a>
              </cfif>
            </td>
            <td width="22" align="center">
              <cfif PageNum_users LT TotalPages_users>
                <a href="#CurrentPage#?PageNum_users=#TotalPages_users##QueryString_users#"><img src="Last.gif" border=0></a>
              </cfif>
            </td>
          </tr>
        </cfoutput>
      </table></td>
  </tr>
  <tr>
    <td colspan="5">&nbsp; <cfoutput>Registros #StartRow_users# a  #EndRow_users# de #users.RecordCount# </cfoutput> </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

</form>
<cf_web_portlet_end><cf_templatefooter>
