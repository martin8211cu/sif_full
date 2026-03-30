<html>
<head>
<title>Lista de Usuarios de Facturaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="sif.css" rel="stylesheet" type="text/css">
</head>

	<!--- crea el filtro --->	
	<cfset filtro = "" >
	<cfif isdefined("Form.Filtrar") and (Form.Pnombre NEQ "")>
		<cfset filtro = " and upper(Pnombre) like '%#Ucase(Form.Pnombre)#%' ">
	</cfif>	  

	<cfif isdefined("Form.Filtrar") and (Form.Papellido1 NEQ "")>
		<cfset filtro = filtro & " and upper(Papellido1) like '%#Ucase(Form.Papellido1)#%' ">
	</cfif>

	<cfif isdefined("Form.Filtrar") and (Form.Papellido2 NEQ "")>
		<cfset filtro = filtro & " and upper(Papellido2) like '%#Ucase(Form.Papellido2)#%' ">
	</cfif>

	<cfinvoke 
	 component="sif.Componentes.UsuariosPermiso"
	 method="TraeUsuarios"
	 returnvariable="conlis">
		<cfinvokeargument name="rol" value="sif.usuario"/>
		<cfinvokeargument name="SDCEcodigo" value="#session.EcodigoSDC#"/>
		<cfinvokeargument name="filtro" value="#filtro#"/>
	</cfinvoke>

<!--- Modelo Viejo de Seguridad
<cfquery name="conlis" datasource="sdc">	
 	select convert(varchar,e.Usucodigo) as Usucodigo, e.Ulocalizacion, b.Edescripcion, e.Pid, e.Pnombre, e.Papellido1, e.Papellido2, e.Pemail1, e.Poficina, e.Pfax 
	from EmpresaConsecutivo a, Empresas b, ServiciosEmpresariales c, EmpresaUsuarioFuncion d, EmpresaUsuario e
	where a.ECconsec = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.Ecodigo = b.Ecodigo
	  and a.SEcodigo = c.SEcodigo
	  and a.Ecodigo = d.Ecodigo
	  and d.EUcodigo = e.EUcodigo
	  and upper(c.SEtipo) = 'SIF' 
	  and e.Usucodigo is not null
	  and e.Ulocalizacion is not null
	  and e.Usucodigo in (select Usucodigo from UsuarioRole where Rolcod=13)

	<cfif isdefined("Form.Filtrar") and (Form.Pnombre NEQ "")>
	  and upper(Pnombre) like '%#Ucase(Form.Pnombre)#%'
	</cfif>	  

	<cfif isdefined("Form.Filtrar") and (Form.Papellido1 NEQ "")>
	  and upper(Papellido1) like '%#Ucase(Form.Papellido1)#%'
	</cfif>

	<cfif isdefined("Form.Filtrar") and (Form.Papellido2 NEQ "")>
	  and upper(Papellido2) like '%#Ucase(Form.Papellido2)#%'
	</cfif>

	order by e.Pnombre, e.Papellido1, e.Papellido2 
</cfquery>
--->

<cfset CurrentPage        = GetFileFromPath(GetTemplatePath())>
<cfparam name             = "PageNum_conlis" default="1">
<cfset MaxRows_conlis     = 16>
<cfset StartRow_conlis    = Min((PageNum_conlis-1)*MaxRows_conlis+1, Max(conlis.RecordCount,1))>
<cfset EndRow_conlis      = Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis  = Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis = Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos            = ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>

<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">

function Asignar(valor1, valor2) {
	window.opener.document.form1.FASupervisor.value       = valor1;
	window.opener.document.form1.FANombreSupervisor.value = valor2;
	window.close();
}
</script>

<body>
<form action="" method="post" name="conlis">
	<table border="0" cellspacing="0">
		<tr class="areaFiltro">
			<td bgcolor="#006699" class="titulo" width="1%">&nbsp;</td>
			<td bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">Nombre</font></div></td>
			<td colspan="2" bgcolor="#006699" class="titulo"><div align="left"><font color="#FFFFFF">Apellidos</font></div></td>
			<td bgcolor="#006699" class="titulo"><div align="right"><font color="#FFFFFF"><input type="submit" name="Filtrar" value="Filtrar"></font></div></td>
		</tr>

		<tr class="areaFiltro">
			<td width="1%">&nbsp;</td>
			<td><input name="Pnombre"    type="text" size="40" maxlength="100"></td>
			<td><input name="Papellido1" type="text" size="40" maxlength="100"></td>
			<td><input name="Papellido2" type="text" size="40" maxlength="100"></td>
			<td>&nbsp;</td>
		</tr>
    
		<cfif conlis.RecordCount gt 0>
			<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
				<tr <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif> >
					<td>&nbsp;</td>
					<td nowrap > 
						<a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.Pnombre)#' +' '+ '#JSStringFormat(conlis.Papellido1)#' +' '+ '#JSStringFormat(conlis.Papellido2)#' );">#conlis.Pnombre#</a>
					</td>
					<td nowrap > 
						<a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.Pnombre)#' +' '+ '#JSStringFormat(conlis.Papellido1)#' +' '+ '#JSStringFormat(conlis.Papellido2)#');">#conlis.Papellido1#</a>
					</td>
					<td nowrap > 
						<a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.Pnombre)#' +' '+ '#JSStringFormat(conlis.Papellido1)#' +' '+ '#JSStringFormat(conlis.Papellido2)#' );">#conlis.Papellido2#</a>
					</td>
					<td>&nbsp;</td>
				</tr>
			</cfoutput> 
		<cfelse>		
			<tr><td colspan="5" align="center" ><font size="2">--- No hay datos ---</font></td></tr>
		</cfif>
    
	<tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="5">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="../../Imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="../../Imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="../../Imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="../../Imagenes/Last.gif" border=0></a> 
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


