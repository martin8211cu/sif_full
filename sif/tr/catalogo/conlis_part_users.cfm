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
<cfparam name="url.fE" default="1">

<cfquery datasource="#session.dsn#" name="existing_users">
	select distinct Usucodigo
	from WfActivityParticipant wfap, WfParticipant wfp
	where wfap.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
	  and wfap.ParticipantId = wfp.ParticipantId
	  and wfp.Usucodigo is not null
</cfquery>

<cfquery datasource="asp" name="lista">
	select  distinct
		u.Usucodigo, dp.Pid,
		ltrim(rtrim(dp.Pnombre))  nombre,
		{fn concat({fn concat(rtrim(dp.Papellido1) , '  ' )},  dp.Papellido2 )}apellido,
		u.Uestado, u.Utemporal, u.Usulogin,
			case when Uestado=1 and Utemporal=0 then 1
			     when Uestado=1 and Utemporal=1 then 2
				 else 3
			end estadoint,
		upper(dp.Pnombre) as upper_Pnombre, upper(dp.Papellido1) as upper_Papellido1, upper(dp.Papellido2) as upper_Papellido2
	from Usuario u, DatosPersonales dp <cfif len(url.s) or len(url.m) or len(url.e)>, vUsuarioProcesos up</cfif>
	where u.datos_personales = dp.datos_personales
	  and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  <cfif existing_users.RecordCount neq 0>
	  and u.Usucodigo not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(existing_users.Usucodigo)#" list="yes">)
	  </cfif>
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
		order by Pid, upper_Pnombre, upper_Papellido1, upper_Papellido2, estadoint
	<cfelseif url.o is 2>
		order by upper_Pnombre, upper_Papellido1, upper_Papellido2, Pid, estadoint
	<cfelseif url.o is 3>
		order by estadoint, Pid, upper_Pnombre, upper_Papellido1, upper_Papellido2
	<cfelseif url.o is 4>
		order by upper_Papellido1, upper_Papellido2, upper_Pnombre, Pid, estadoint
	<cfelse>
		order by Pid, upper_Pnombre, upper_Papellido1, upper_Papellido2, estadoint
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
Seleccione un usuario</div>
<form action="#CurrentPage#" method="get" name="form1"><input type="hidden" name="ActivityId" value="#HTMLEditFormat(url.ActivityId)#">
<table border="0" cellpadding="0" cellspacing="0" width="90%" align="center">
  <tr class="tituloListas">
    <td>&nbsp;</td>
    <td><a href="#CurrentPage#?o=1&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Cedula" XmlFile="/sif/generales.xml">C&eacute;dula</cf_translate></a> <cfif url.o is 1>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td><a href="#CurrentPage#?o=2&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Nombre" XmlFile="/sif/generales.xml">Nombre</cf_translate></a> <cfif url.o is 2>&darr;</cfif></td>
    <td>&nbsp;</td>
    <td><a href="#CurrentPage#?o=4&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Apellidos" XmlFile="/sif/generales.xml">Apellidos</cf_translate></a> <cfif url.o is 4>&darr;</cfif></td>
    <td><a href="#CurrentPage#?o=3&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Estado" XmlFile="/sif/generales.xml">Estado</cf_translate></a> <cfif url.o is 3>&darr;</cfif></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="fC" type="text" id="fC" value="#HTMLEditFormat(url.fC)#" onFocus="this.select()" tabindex="1"></td>
    <td>&nbsp;</td>
    <td><input name="fN" type="text" id="fN" value="#HTMLEditFormat(url.fN)#" onFocus="this.select()" tabindex="1"></td>
    <td>&nbsp;</td>
    <td><input name="fA" type="text" id="fA" value="#HTMLEditFormat(url.fA)#" onFocus="this.select()" tabindex="1"></td>
    <td><select name="fE" id="fE" onChange="form.submit()" tabindex="1">
      <option  <cfif url.fE is "">selected</cfif>><cf_translate key="CMB_Todos" XmlFile="/sif/generales.xml">Todos</cf_translate></option>
      <option value="1" <cfif url.fE is 1>selected</cfif>><cf_translate key="CMB_Activo">Activo</cf_translate></option>
      <option value="2" <cfif url.fE is 2>selected</cfif>><cf_translate key="CMB_Temporal">Temporal</cf_translate></option>
      <option value="3" <cfif url.fE is 3>selected</cfif>><cf_translate key="CMB_Desactivado">Desactivado</cf_translate></option>
    </select></td>
    <td>&nbsp;</td>
  </tr>
  <cfloop query="lista" startRow="#StartRow_lista#" endRow="#StartRow_lista+MaxRows_lista-1#">
    <tr onclick="regresar('HUMAN','#JSStringFormat(Pid)#','#JSStringFormat(nombre)# #JSStringFormat(apellido)#','',#Usucodigo#,'','')"
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
        <cf_translate key="LB_Desactivado">Desactivado</cf_translate>
            <cfelseif Utemporal is 1><cf_translate key="LB_Temporal">Temporal</cf_translate><cfelse><cf_translate key="LB_Activo">Activo</cf_translate></cfif></td>
      <td>&nbsp;</td>
    </tr>
  </cfloop>
  <tr><td colspan="8">&nbsp;</td></tr>
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
  <tr><td colspan="8">&nbsp;</td></tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="6">&nbsp; <cf_translate key="MSG_MostrandoUsuarios">Mostrando usuarios</cf_translate> #StartRow_lista# <cf_translate key="MSG_A">a</cf_translate> #EndRow_lista# <cf_translate key="MSG_De">de</cf_translate> #lista.RecordCount# </td>
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

		<input type="submit" value="#BTN_Buscar#" tabindex="1"></td>
    <td colspan="6">&nbsp;</td>
  </tr>
</table> 
</form>

</body>
</html>
</cfoutput>
