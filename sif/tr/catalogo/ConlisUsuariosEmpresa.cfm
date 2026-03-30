<cfsetting enablecfoutputonly="yes">
<!--- url.o = ordenamiento --->
<cfparam name="url.o" default="1">
<cfif url.o neq 1 and url.o neq 2 and url.o neq 3 and url.o neq 4>
	<cfset url.o = 1>
</cfif>
<!--- url.s = sistema --->
<cfparam name="url.s" default="">
<!--- url.m = modulo  --->
<cfparam name="url.m" default="">
<!--- url.p = proceso  --->
<cfparam name="url.p" default="">
<!--- url.e = empresa --->
<cfparam name="url.e" default="">

<!--- filtros Cedula, Nombre, Estado --->
<cfparam name="url.fC" default="">
<cfparam name="url.fN" default="">
<cfparam name="url.fA" default="">
<cfparam name="url.fE" default="">

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery datasource="asp" name="lista">
	select  <cfif len(url.s) or len(url.m) or len(url.e)> distinct </cfif>
		u.Usucodigo, dp.Pid,
		ltrim(rtrim(dp.Pnombre))  nombre,
		ltrim(rtrim(dp.Papellido1)) #_Cat# ' ' #_Cat# ltrim(rtrim(dp.Papellido2)) apellido,
		u.Uestado, u.Utemporal, u.Usulogin,
			case when Uestado=1 and Utemporal=0 then 1
			     when Uestado=1 and Utemporal=1 then 2
				 else 3
			end estadoint
	from Usuario u, DatosPersonales dp <cfif len(url.s) or len(url.m) or len(url.e)>, vUsuarioProcesos up</cfif>
	where u.datos_personales = dp.datos_personales
	  and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	<cfif len(url.fC)>
	  and lower(dp.Pid) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fC))#%">
	</cfif>
	<cfif len(url.fN)>
	  and (lower(dp.Pnombre   ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fN))#%">)
	</cfif>
	<cfif len(url.fA)>
	  and (lower(dp.Papellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fA))#%">
	    or lower(dp.Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fA))#%">)
	</cfif>
	<cfif url.fE is 1>
	  and Uestado = 1 and Utemporal = 0
	<cfelseif url.fE is 2>
	  and Uestado = 1 and Utemporal = 1
	<cfelseif url.fE is 3>
	  and Uestado = 0
	</cfif>
	<cfif len(url.s) or len(url.m) or len(url.e)>
	  and up.Usucodigo = u.Usucodigo
	</cfif>
	<cfif len(url.s)>
	  and up.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	</cfif>
	<cfif len(url.m)>
	  and up.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	</cfif>
	<cfif len(url.p)>
	  and up.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">
	</cfif>
	<cfif len(url.e)>
	  and up.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.e#">
	</cfif>
	<cfif url.o is 1>
		order by Pid, upper(dp.Pnombre), upper(dp.Papellido1), upper(dp.Papellido2), estadoint
	<cfelseif url.o is 2>
		order by upper(dp.Pnombre), upper(dp.Papellido1), upper(dp.Papellido2), Pid, estadoint
	<cfelseif url.o is 3>
		order by estadoint, Pid, upper(dp.Pnombre), upper(dp.Papellido1), upper(dp.Papellido2)
	<cfelseif url.o is 4>
		order by upper(dp.Papellido1), upper(dp.Papellido2), upper(dp.Pnombre), Pid, estadoint
	<cfelse>
		order by Pid, upper(dp.Pnombre), upper(dp.Papellido1), upper(dp.Papellido2), estadoint
	</cfif>
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_lista" default="1">
<cfset MaxRows_lista=10>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,lista.RecordCount)>
<cfset TotalPages_lista=Ceiling(lista.RecordCount/MaxRows_lista)>
<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<title>Seleccione un usuario</title>
</head>

<body>
<div class="subTitulo">
Seleccione un usuario</div>
<form action="ConlisUsuariosEmpresa.cfm" method="get" name="form1">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr class="tituloListas">
    <td>&nbsp;</td>
    <td><a href="ConlisUsuariosEmpresa.cfm?o=1">C&eacute;dula</a> <cfif url.o is 1>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td><a href="ConlisUsuariosEmpresa.cfm?o=2">Nombre</a> <cfif url.o is 2>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td><a href="ConlisUsuariosEmpresa.cfm?o=4">Apellidos</a> <cfif url.o is 4>&darr;</cfif></td>
    <td><a href="ConlisUsuariosEmpresa.cfm?o=3">Estado</a> <cfif url.o is 3>&darr;</cfif></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="fC" type="text" id="fC" value="#HTMLEditFormat(url.fC)#" onFocus="this.select()"></td>
    <td>&nbsp;</td>
    <td><input name="fN" type="text" id="fN" value="#HTMLEditFormat(url.fN)#" onFocus="this.select()"></td>
    <td>&nbsp;</td>
    <td><input name="fA" type="text" id="fA" value="#HTMLEditFormat(url.fA)#" onFocus="this.select()"></td>
    <td><select name="fE" id="fE" onChange="form.submit()">
      <option  <cfif url.fE is "">selected</cfif>>Todos</option>
      <option value="1" <cfif url.fE is 1>selected</cfif>>Activo</option>
      <option value="2" <cfif url.fE is 2>selected</cfif>>Temporal</option>
      <option value="3" <cfif url.fE is 3>selected</cfif>>Desactivado</option>
    </select></td>
    <td>&nbsp;</td>
  </tr>
  <cfloop query="lista" startRow="#StartRow_lista#" endRow="#StartRow_lista+MaxRows_lista-1#">
    <tr onclick="regresar(#Usucodigo#,'#JSStringFormat(Pid)#','#JSStringFormat(nombre)# #JSStringFormat(apellido)#')"
		style="cursor:pointer"
		class="<cfif lista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"
		onMouseOver="listmov(this)"
		onMouseOut="listmout(this)" >
      <td>&nbsp;</td>
      <td>#Pid#</td>
      <td>&nbsp;</td>
      <td>#nombre#</td>
      <td>&nbsp;</td>
      <td>#apellido#</td>
      <td><cfif Uestado is 0>
        Desactivado
            <cfelseif Utemporal is 1>Temporal<cfelse>Activo</cfif></td>
      <td>&nbsp;</td>
    </tr>
  </cfloop>
  <tr>
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
    <td>&nbsp;</td>
    <td colspan="6">&nbsp;
      <table border="0" width="50%" align="center">
          <tr>
            <td width="23%" align="center"><cfif PageNum_lista GT 1>
                <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#"><img src="../../imagenes/First.gif" width="18" height="13" border=0></a>
              </cfif>
            </td>
            <td width="31%" align="center"><cfif PageNum_lista GT 1>
                <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#"><img src="../../imagenes/Previous.gif" width="14" height="13" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center"><cfif PageNum_lista LT TotalPages_lista>
                <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#"><img src="../../imagenes/Next.gif" width="14" height="13" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center"><cfif PageNum_lista LT TotalPages_lista>
                <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#"><img src="../../imagenes/Last.gif" width="18" height="13" border=0></a>
              </cfif>
            </td>
          </tr>
      </table></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
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
    <td>&nbsp;</td>
    <td colspan="6">&nbsp; Mostrando usuarios #StartRow_lista# a #EndRow_lista# de #lista.RecordCount# </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" value="Buscar"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table> 
</form>

<script type="text/javascript">
<!--
	function listmov(elem) {
		elem.bg = elem.style.backgroundColor;
		elem.style.backgroundColor='##e4e8f3';
	}
	function listmout(elem) {
		elem.style.backgroundColor = elem.bg;
	}
	function regresar(uid,cedula,nombre) {
		window.opener.document.SeleccionarUsuario(uid,cedula,nombre);
		window.close();
	}
//--></script>
</body>
</html>
</cfoutput>
