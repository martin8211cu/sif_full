<html>
<head>
<title>Lista de Usuarios por Tipo de Acción </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<!--- Filtros ---->
<cfset fIdentificacion = "">
<cfset fPapellido1 = "">
<cfset fPapellido2 = "">
<cfset fPnombre = "">

<!--- Lista de Usuarios Autorizados --->
<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
	select distinct Usucodigo from RHUsuarioTipoAccion 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	and RHTid = <cfqueryparam value="#url.RHTid#" cfsqltype="cf_sql_numeric"> 
</cfquery>

<!--- Lista de Usuarios Activos por Empresa --->
<cfquery name="conlis" datasource="asp">
	select distinct a.Usucodigo, 
		   a.CEcodigo, b.Pid as fIdentificacion,
		   b.Pnombre, b.Papellido1, b.Papellido2,
		   b.Pnombre || ' ' || b.Papellido1 || ' '  ||  b.Papellido2 as Nombre, 
		  (case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as Estado 
	from Usuario a, DatosPersonales b, vUsuarioProcesos c 
	where a.datos_personales = b.datos_personales 
	  and a.Usucodigo = c.Usucodigo 
	  and c.Ecodigo = <cfqueryparam value="#session.EcodigoSDC#" cfsqltype="cf_sql_numeric">
	  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and a.Uestado = 1 
	  and a.Utemporal = 0
	<cfif rsUsuariosAutorizados.recordCount GT 0>
	  and a.Usucodigo not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#ValueList(rsUsuariosAutorizados.Usucodigo, ',')#">)
	</cfif>

	<cfif isdefined("form.Filtrar") and Len(Trim(Form.fIdentificacion)) GT 0>
		and b.Pid like '%#Ucase(Form.fIdentificacion)#%'
		<cfset fIdentificacion = Ucase(Form.fIdentificacion)>
	</cfif>

	<cfif isdefined("form.Filtrar") and Len(Trim(Form.Papellido1)) GT 0>
		and upper(Papellido1) like '%#Ucase(Form.Papellido1)#%'
		<cfset fPapellido1 = Ucase(Form.Papellido1)>
	</cfif>

	<cfif isdefined("form.Filtrar") and Len(Trim(Form.Papellido2)) GT 0>
		and upper(Papellido2) like '%#Ucase(Form.Papellido2)#%'
		<cfset fPapellido2 = Ucase(Form.Papellido2)>
	</cfif>

	<cfif isdefined("form.Filtrar") and Len(Trim(Form.Pnombre)) GT 0>
		and upper(Pnombre) like '%#Ucase(Form.Pnombre)#%'
		<cfset fPnombre = Ucase(Form.Pnombre)>		
	</cfif>
	order by b.Papellido1, b.Papellido2, b.Pnombre
</cfquery>

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

<script language="JavaScript1.2" type="text/javascript">
	function Asignar(valor1, valor2) {
		window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value = valor1;
		window.opener.document.<cfoutput>#url.form#.#url.nombre#</cfoutput>.value = valor2;		
		window.close();
	}
	function limpiarCampos() {
	
		document.conlis.fIdentificacion.value = '';	
		document.conlis.Papellido1.value = '';
		document.conlis.Papellido2.value = '';
		document.conlis.Pnombre.value = '';
	}
</script>

<form action="" method="post" name="conlis">
  <table width="100%" border="0" cellspacing="0">
	<cfoutput>
    
	<tr>
	  <td width="16%"  class="tituloListas" nowrap><div align="left">Identificación</div></td> 
      <td width="16%" class="tituloListas"><div align="left">1&ordf; Apellido</div></td>
	  <td width="16%" class="tituloListas"><div align="left">2&ordf; Apellido</div></td>
	  <td width="84%"  class="tituloListas"><div align="left">Nombre</div></td>	  
    </tr>
	
	<!--- Filtros --->
    <tr>
      <td><input name="fIdentificacion" type="text" size="20" maxlength="60" value="#fIdentificacion#"></td>
  	  <td><input name="Papellido1" type="text" size="20" maxlength="10" value="#fPapellido1#"></td> 
      <td><input name="Papellido2" type="text" size="20" maxlength="10" value="#fPapellido2#"></td>
      <td nowrap>
	  	  <input name="Pnombre" type="text" size="20" maxlength="50" value="#fPnombre#">
          <input type="submit" name="Filtrar" value="Filtrar">
		  <input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript: limpiarCampos();">
	  </td>
    </tr>
	
	</cfoutput>

    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr>
        <td nowrap <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
			<input type="hidden" name="Usucodigo#conlis.CurrentRow#" value="#conlis.Usucodigo#"> 
          <a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.Nombre)#');">#conlis.fIdentificacion#</a>
		</td> 
	  
        <td nowrap <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
			<input type="hidden" name="Usucodigo#conlis.CurrentRow#" value="#conlis.Usucodigo#"> 
          <a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.Nombre)#');">#conlis.Papellido1#</a>
		</td>
	  
		<td nowrap <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
			<input type="hidden" name="Usucodigo#conlis.CurrentRow#" value="#conlis.Usucodigo#"> 
          <a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.Nombre)#');">#conlis.Papellido2#</a>
		</td>
        
		<td nowrap <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
			<input type="hidden" name="Usucodigo#conlis.CurrentRow#" value="#conlis.Usucodigo#"> 
          <a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.Nombre)#');">#conlis.Pnombre#</a>
		</td>
      
	  </tr>
    </cfoutput> 

    <tr> 
      <td colspan="5">&nbsp; </td>
    </tr>
	
    <tr> 
      <td colspan="5">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> 
        </table>
        <div align="center"> </div></td>
    </tr>
	
  </table>
</form>

</body>
</html>
