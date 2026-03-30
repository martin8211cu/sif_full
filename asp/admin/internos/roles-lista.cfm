<cfparam name="url.fRol" default=""><cfset url.fRol = Trim(url.fRol)>
<cfparam name="url.fUid" default=""><cfset url.fUid = Trim(url.fUid)>
<cfparam name="url.fNom" default=""><cfset url.fNom = Trim(url.fNom)>
<cfparam name="url.fEmp" default="">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_datos" default="1">
<cfset url.fEmp = Trim(url.fEmp)>


<cfquery datasource="asp" name="roles">
	select rtrim(SScodigo) as SScodigo, rtrim(SRcodigo) as SRcodigo, SRdescripcion
	from SRoles
	where SRinterno = 1
	order by SScodigo, SRcodigo
</cfquery>

<cfquery datasource="asp" name="datos">
	select u.Usulogin,u.Usucodigo,ur.Ecodigo,
		rtrim(r.SScodigo) SScodigo, rtrim(r.SRcodigo)SRcodigo, r.SRdescripcion,
		dp.Pnombre, dp.Papellido1, dp.Papellido2,
		e.Enombre
	from UsuarioRol ur, SRoles r, Usuario u, Empresa e, DatosPersonales dp
	where r.SScodigo = ur.SScodigo
	  and r.SRcodigo = ur.SRcodigo
	  and u.Usucodigo = ur.Usucodigo
	  and e.Ecodigo = ur.Ecodigo
	  and dp.datos_personales = u.datos_personales
	  and r.SRinterno = 1
	<cfif ListLen(url.fRol,'.') is 2>
	  and ur.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(url.fRol,1,'.')#">
	  and ur.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(url.fRol,2,'.')#">
	</cfif>
	<cfif Len(url.fUid)>
	  and lower(u.Usulogin) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fUid)#%">
	</cfif>
	<cfif Len(url.fNom)>
	  and (lower(dp.Pnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fNom)#%">
	  	or lower(dp.Papellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fNom)#%">
	  	or lower(dp.Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fNom)#%"> )
	</cfif>
	<cfif Len(url.fEmp)>
	  and lower(e.Enombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fEmp)#%">
	</cfif>
	order by SScodigo, SRcodigo, Usulogin, Pnombre, Papellido1, Papellido2, Enombre
</cfquery>
<cfset MaxRows_datos=10>
<cfset StartRow_datos=Min((PageNum_datos-1)*MaxRows_datos+1,Max(datos.RecordCount,1))>
<cfset EndRow_datos=Min(StartRow_datos+MaxRows_datos-1,datos.RecordCount)>
<cfset TotalPages_datos=Ceiling(datos.RecordCount/MaxRows_datos)>
<cfset QueryString_datos=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_datos,"PageNum_datos=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_datos=ListDeleteAt(QueryString_datos,tempPos,"&")>
</cfif>

<form action="roles.cfm" method="get" name="filtro" id="filtro">
<table border="0" cellspacing="0" cellpadding="0" width="95%">
  <tr>
    <td colspan="5" class="subTitulo">Definici&oacute;n de Grupos </td>
  </tr>
  <tr>
    <td colspan="5" >&nbsp;</td>
  </tr>
  <tr>
    <td colspan="5" class="tituloListas">Grupo: <cfoutput>
      <select name="fRol" id="select" onChange="this.form.submit()">
        <option value="" <cfif Len(url.fRol) is 0>selected</cfif>>-Todos-</option>
        <cfloop query="roles">
          <option value="#roles.SScodigo#.#roles.SRcodigo#" <cfif roles.SScodigo &' .' & roles.SRcodigo EQ url.fRol>selected</cfif>>
		  	#roles.SScodigo#.#roles.SRcodigo# - #roles.SRdescripcion#</option>
        </cfloop>
      </select>
    </cfoutput></td>
    </tr>
  <tr>
    <td class="tituloListas">&nbsp;</td>
    <td class="tituloListas">Usuario (login) </td>
    <td class="tituloListas">Nombre</td>
    <td class="tituloListas">Empresa</td>
    <td class="tituloListas">&nbsp;</td>
  </tr>
  <tr>
    <td class="tituloListas">
	  	<cfif Len(url.fRol) EQ 0>Grupo<cfelse>&nbsp;</cfif></td>
    <td class="tituloListas"><cfoutput>
      <input type="text" name="fUid" value="#HTMLEditFormat(Trim(url.fUid))#" onFocus="this.select()" size="20" maxlength="30" style="width:100%">
    </cfoutput></td>
    <td class="tituloListas"><cfoutput>
      <input type="text" name="fNom" value="#HTMLEditFormat(Trim(url.fNom))#" onFocus="this.select()" size="20" maxlength="30" style="width:100%">
    </cfoutput></td>
    <td class="tituloListas"><cfoutput>
      <input type="text" name="fEmp" value="#HTMLEditFormat(Trim(url.fEmp))#" onFocus="this.select()" size="20" maxlength="30" style="width:100%">
    </cfoutput></td>
    <td class="tituloListas"><input type="submit" name="Submit" value="Filtro"></td>
  </tr>
  <cfoutput query="datos" startRow="#StartRow_datos#" maxRows="#MaxRows_datos#">
    <tr class="<cfif CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"
		onMouseOver="listmov(this)"
		onMouseOut="listmout(this)"
		>
      <td>
	  	<cfif Len(url.fRol) EQ 0>
	  #SScodigo#.#SRcodigo# - #SRdescripcion# </cfif></td>
      <td>#Usulogin#</td>
      <td>#HTMLEditFormat( Pnombre)# #HTMLEditFormat( Papellido1)# # HTMLEditFormat( Papellido2 )#</td>
      <td>#Enombre#</td>
      <td><a title="Revocar" href="roles-delete-sql.cfm?u=#Usucodigo#&e=#Ecodigo#&s=#URLEncodedFormat(SScodigo)#&r=#URLEncodedFormat(SRcodigo)#">]Revocar[</a></td>
    </tr>
  </cfoutput>
    <tr>
      <td colspan="5">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="5">
        <table border="0" width="50%" align="center">
          <cfoutput>
            <tr>
              <td width="23%" align="center">
                <cfif PageNum_datos GT 1>
                  <a href="#CurrentPage#?PageNum_datos=1#QueryString_datos#"><img src="First.gif" border=0></a>
                </cfif>
              </td>
              <td width="31%" align="center">
                <cfif PageNum_datos GT 1>
                  <a href="#CurrentPage#?PageNum_datos=#Max(DecrementValue(PageNum_datos),1)##QueryString_datos#"><img src="Previous.gif" border=0></a>
                </cfif>
              </td>
              <td width="23%" align="center">
                <cfif PageNum_datos LT TotalPages_datos>
                  <a href="#CurrentPage#?PageNum_datos=#Min(IncrementValue(PageNum_datos),TotalPages_datos)##QueryString_datos#"><img src="Next.gif" border=0></a>
                </cfif>
              </td>
              <td width="23%" align="center">
                <cfif PageNum_datos LT TotalPages_datos>
                  <a href="#CurrentPage#?PageNum_datos=#TotalPages_datos##QueryString_datos#"><img src="Last.gif" border=0></a>
                </cfif>
              </td>
            </tr>
          </cfoutput>
        </table></td>
    </tr>
    <tr>
      <td colspan="5">&nbsp; <cfoutput>Mostrando registros #StartRow_datos# a #EndRow_datos# de #datos.RecordCount# </cfoutput> </td>
    </tr>
</table>
</form>
<script type="text/javascript">
<!--
	function listmov(elem) {
		elem.bg = elem.style.backgroundColor;
		elem.style.backgroundColor='#e4e8f3';
	}
	function listmout(elem) {
		elem.style.backgroundColor = elem.bg;
	}
//--></script>