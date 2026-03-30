<!---
	Archivo: Conlis de Usuarios
	Utilizado por: 	formUsuariosCaja.cfm -uc-
					formVendedores.cfm -ve-
	Para diferenciarlos en este Archivo se recibe un parámetro, pantalla, para el form UsuariosCaja se recibe uc...
	y para el form Vendedores se recibe ve.
 --->

<html>
<head>
<title>
	Lista de Usuarios
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfif not (url.catalogo eq "uc" or url.catalogo eq "ve")>
	<cfabort>
</cfif>
<!--- filtro --->
	<cfset filtro = "">
   	<cfif isdefined("Form.Filtrar") and (Form.Usulogin NEQ "")>
  	  <cfset filtro = filtro & " and upper(a.Usulogin) like '%#Ucase(Form.Usulogin)#%' ">
	</cfif>
	
	<cfif isdefined("Form.Filtrar") and (Form.Pnombre NEQ "")>
	  <cfset filtro = filtro & " and upper(b.Pnombre) like '%#Ucase(Form.Pnombre)#%' ">
	<!---  <cfset filtro = filtro & " and b.Pnombre like 'HILDA%' ">--->
	</cfif>	  

	<cfif isdefined("Form.Filtrar") and (Form.Papellido1 NEQ "")>
		<cfset filtro = " and upper(b.Papellido1) like '%#Ucase(Form.Papellido1)#%' " >
	</cfif>
	
	<cfinclude template="../../Utiles/sifConcat.cfm">
	
	<!--- Chequear si se debe obtener los usuarios por empresa --->
	<cfquery name="rsUsuarios" datasource="asp">
		select distinct
			   a.Usucodigo as EUcodigo, 
			   a.Usucodigo as Usucodigo, 
			   '#Session.Ulocalizacion#' as Ulocalizacion, 
			   a.Usulogin, 
		       b.Pnombre, 
			   b.Papellido1, 
			   b.Papellido2, 
			   b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 pNombreCompleto,
			   b.Pid, 
			   b.Pemail1
		from Usuario a, DatosPersonales b, UsuarioProceso c
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and a.datos_personales = b.datos_personales
		and a.Usucodigo = c.Usucodigo
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
		and c.SScodigo = 'SIF'        
		#preservesinglequotes(filtro)#
		order by b.Pid, pNombreCompleto
	</cfquery>

<cfif url.catalogo eq "uc">
	<cfquery name="rsAlterno" datasource="#Session.DSN#">
		select convert(varchar, a.EUcodigo) EUcodigo
		from UsuariosCaja a, FCajas b
		where a.FCid = b.FCid
			and b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric" >
			and a.FCid = <cfqueryparam value="#url.FCid#" cfsqltype="cf_sql_numeric" >
	</cfquery>
<cfelseif url.catalogo eq "ve">
	<cfquery name="rsAlterno" datasource="#Session.DSN#">
		select convert(varchar, EUcodigo) EUcodigo
		from FVendedores
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric" >
	</cfquery>	
</cfif>
<!---
<cfquery name="conlis" dbtype="query">
	select *
	from rsUsuarios
	where not EUcodigo in 
	(
	select rsUsuarios.EUcodigo
	from rsUsuarios, rsUsuariosCaja
	where 
		rsUsuarios.EUcodigo = rsUsuariosCaja.EUcodigo
	)	
</cfquery>
--->

<!--- Query para manejar resultados--->
<cfset conlis = QueryNew("EUcodigo,Usucodigo,Ulocalizacion,Pid,Pnombre,Papellido1,Papellido2,pNombreCompleto,Usulogin")>

<cfloop query="rsUsuarios">
	<cfquery name="rsExiste" dbtype="query">
		select 1 from rsAlterno where EUcodigo = '#rsUsuarios.EUcodigo#'
	</cfquery>
	<cfif rsExiste.RecordCount EQ 0>
		<!--- Agrega la fila procesada --->
		<cfset fila = QueryAddRow(conlis, 1)>
		<cfset tmp  = QuerySetCell(conlis, "EUcodigo",		#rsUsuarios.EUcodigo#) >
		<cfset tmp  = QuerySetCell(conlis, "Usucodigo",		#rsUsuarios.Usucodigo#) >
		<cfset tmp  = QuerySetCell(conlis, "Ulocalizacion",	#rsUsuarios.Ulocalizacion#) >
		<cfset tmp  = QuerySetCell(conlis, "Pid",			#rsUsuarios.Pid#) >
		<cfset tmp  = QuerySetCell(conlis, "Pnombre",		#rsUsuarios.Pnombre#) >
		<cfset tmp  = QuerySetCell(conlis, "Papellido1",	#rsUsuarios.Papellido1#) >
		<cfset tmp  = QuerySetCell(conlis, "Papellido2",	#rsUsuarios.Papellido2#) >
		<cfset tmp  = QuerySetCell(conlis, "pNombreCompleto",#rsUsuarios.pNombreCompleto#) >
		<cfset tmp  = QuerySetCell(conlis, "Usulogin",		#rsUsuarios.Usulogin#) >
	</cfif>
</cfloop>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">

function Asignar(valor1, valor2, valor3, valor4, valor5) {
	limpiar();
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.EUcodigo#</cfoutput>.value = valor1;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Usucodigo#</cfoutput>.value = valor2;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Ulocalizacion#</cfoutput>.value = valor3;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Usulogin#</cfoutput>.value = valor4;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Nombre#</cfoutput>.value = valor5;
	window.close();
}

function limpiar() {
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.EUcodigo#</cfoutput>.value = "";
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Usucodigo#</cfoutput>.value = "";
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Ulocalizacion#</cfoutput>.value = "";
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Usulogin#</cfoutput>.value = "";
	window.opener.document.<cfoutput>#url.form#</cfoutput>.<cfoutput>#url.Nombre#</cfoutput>.value = "";
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="55%" border="0" cellspacing="0" align="center">
    <tr>
      <td  class="tituloListas">&nbsp;</td>
	  <td width="25%" class="tituloListas">Login</td>
      <td width="33%"  class="tituloListas"><div align="left">Primer Apellido</div></td>
      <td width="11%" class="tituloListas"><div align="left">Nombre</div></td>
      <td class="tituloListas">&nbsp;</td>
    </tr>
    <tr class="areaFiltro">
	  <td>&nbsp;</td>	
      <td><input type="text" name="Usulogin"></td>
      <td><input name="Papellido1" type="text" size="40" maxlength="100"></td>
      <td><input name="Pnombre" type="text" size="40" maxlength="60"></td>
	  <td><input type="submit" name="Filtrar" value="Filtrar"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif>>
	  	<td>&nbsp;</td> 
	  	<td >
          <a href="javascript: Asignar('#JSStringFormat(conlis.EUcodigo)#','#JSStringFormat(conlis.Usucodigo)#','#JSStringFormat(conlis.Ulocalizacion)#','#JSStringFormat(conlis.Usulogin)#','#JSStringFormat(conlis.PnombreCompleto)#');">#conlis.Usulogin#</a></td>
        <td >
          <a href="javascript: Asignar('#JSStringFormat(conlis.EUcodigo)#','#JSStringFormat(conlis.Usucodigo)#','#JSStringFormat(conlis.Ulocalizacion)#','#JSStringFormat(conlis.Usulogin)#','#JSStringFormat(conlis.PnombreCompleto)#');">#conlis.pApellido1#</a></td>
        <td >
          <a href="javascript: Asignar('#JSStringFormat(conlis.EUcodigo)#','#JSStringFormat(conlis.Usucodigo)#','#JSStringFormat(conlis.Ulocalizacion)#','#JSStringFormat(conlis.Usulogin)#','#JSStringFormat(conlis.PnombreCompleto)#');">#conlis.pNombre#</a></td>
		<td>&nbsp;</td>		  
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="4">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="5">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../imagenes/Last.gif" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> 
        </table>
        <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>