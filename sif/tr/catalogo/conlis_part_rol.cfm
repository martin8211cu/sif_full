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


<cfquery datasource="#session.dsn#" name="existing_roles">
  select distinct rtrim(rol) as rol
  from WfActivityParticipant wfap, WfParticipant wfp
  where wfap.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
    and wfap.ParticipantId = wfp.ParticipantId
    and wfp.rol is not null
</cfquery>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery datasource="asp" name="lista">

  select distinct r.SScodigo, r.SRcodigo, r.SRdescripcion,   {fn concat({fn concat(rtrim(r.SScodigo) , '.' )},  r.SRcodigo )}   as rol,
  upper(r.SScodigo) as c1, upper(r.SRcodigo) as c2, upper(r.SRdescripcion) as c3
  from SRoles r join ModulosCuentaE mce on r.SScodigo = mce.SScodigo
  where mce.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  <cfif existing_roles.RecordCount>
    and rtrim(r.SScodigo)#_Cat#'.'#_Cat#rtrim(r.SRcodigo) not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(existing_roles.rol)#" list="yes">)
  </cfif>
  <cfif len(url.fC)>
    and lower(r.SScodigo)#_Cat#'.'#_Cat#lower(r.SRcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fC))#%">
  </cfif>
  <cfif len(url.fN)>
    and (lower(r.SRdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(Trim(url.fN))#%">)
  </cfif>

  <cfif url.o is 1>
    order by upper(r.SScodigo), upper(r.SRcodigo), upper(r.SRdescripcion)
  <cfelseif url.o is 2>
    order by upper(r.SRdescripcion), upper(r.SScodigo), upper(r.SRcodigo)
  <cfelse>
    order by upper(r.SScodigo), upper(r.SRcodigo), upper(r.SRdescripcion)
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
<link href="../../css/web_portlet.css" rel="stylesheet" type="text/css">
<title><cf_translate key="LB_SeleccioneUnUsuario">Seleccione un usuario</cf_translate></title>
</head>

<body>

<cfinclude template="conlis_part_tab.cfm">

<div class="subTitulo">
<cf_translate key="LB_SeleccioneUnRol">Seleccione un Rol</cf_translate> </div>
<form action="#CurrentPage#" method="get" name="form1"><input type="hidden" name="ActivityId" value="#HTMLEditFormat(url.ActivityId)#">
<table border="0" cellpadding="0" cellspacing="0" width="90%" align="center">
  <tr class="tituloListas">
    <td>&nbsp;</td>
    <td><a href="#CurrentPage#?o=1&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Codigo" XmlFile="/sif/generales.xml">C&oacute;digo</cf_translate></a> <cfif url.o is 1>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td><a href="#CurrentPage#?o=2&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Nombre" XmlFile="/sif/generales.xml">Nombre</cf_translate></a> <cfif url.o is 2>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="fC" type="text" id="fC" value="#HTMLEditFormat(url.fC)#" onFocus="this.select()" tabindex="1"></td>
    <td>&nbsp;</td>
    <td><input name="fN" type="text" id="fN" value="#HTMLEditFormat(url.fN)#" onFocus="this.select()" tabindex="1"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <cfloop query="lista" startRow="#StartRow_lista#" endRow="#StartRow_lista+MaxRows_lista-1#">
  <cfset CurrentCode = Trim(SScodigo) & '.' & Trim(SRcodigo)>
    <tr onclick="regresar('ROLE', '#JSStringFormat(CurrentCode)#','#JSStringFormat(SRdescripcion)#','#JSStringFormat(CurrentCode)#','','','')"
    style="cursor:pointer"
    class="<cfif lista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"
    onMouseOver="listmov(this)"
    onMouseOut="listmout(this)" >
      <td>&nbsp;</td>
      <td>#CurrentCode#</td>
      <td>&nbsp;</td>
      <td>#SRdescripcion#</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </cfloop>
  <tr><td colspan="6">&nbsp;</td></tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4">&nbsp;
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
  <tr><td colspan="6">&nbsp;</td></tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4">&nbsp; <cf_translate key="MSG_MostrandoUsuarios">Mostrando usuarios</cf_translate> #StartRow_lista# <cf_translate key="MSG_A">a</cf_translate> #EndRow_lista# <cf_translate key="MSG_De">de</cf_translate> #lista.RecordCount# </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Buscar"
		Default="Buscar"
		XmlFile="/sif/generales.xml"
		returnvariable="BTN_Buscar"/>

		<input type="submit" value="#BTN_Buscar#" tabindex="1">
	</td>
    <td colspan="4">&nbsp;</td>
  </tr>
</table>
</form>


</body>
</html>
</cfoutput>