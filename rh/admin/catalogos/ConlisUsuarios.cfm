<html>
<head>
<title><cf_translate key="LB_ListaDeUsuariosPorTipoDeExpediente">Lista de Usuarios por Tipo de Expediente</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<!--- Filtros ---->
<cfset fPapellido1 = "">
<cfset fPapellido2 = "">
<cfset fPnombre = "">

<!--- Lista de Usuarios Activos por Empresa --->
<cfquery name="conlis" datasource="asp">
	select distinct a.Usucodigo, 
		b.Pnombre, b.Papellido1, b.Papellido2,
		{fn concat(b.Pnombre,
		{fn concat(' ', 
		{fn concat(b.Papellido1,
		{fn concat(' ',b.Papellido2)})})})}		   
		as NombreCompleto
	from vUsuarioProcesos p, Usuario a, DatosPersonales b
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and p.Usucodigo = a.Usucodigo
	  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and a.Uestado = 1
	  and a.Utemporal = 0
	  and a.datos_personales = b.datos_personales

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
		document.conlis.Papellido1.value = '';
		document.conlis.Papellido2.value = '';
		document.conlis.Pnombre.value = '';
	}
</script>

<form action="" method="post" name="conlis">
  <table width="100%" border="0" cellspacing="0">
	<cfoutput>
    
	<tr> 
      <td width="16%"  class="tituloListas" align="left"><cf_translate key="LB_Apellido1">1&ordf; Apellido</cf_translate></td>
	  <td width="16%"  class="tituloListas" align="left"><cf_translate key="LB_Apellido2">2&ordf; Apellido</cf_translate></td>
	  <td width="84%"  class="tituloListas" align="left"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>	  
    </tr>
	
	<!--- Filtros --->
    <tr>
  	  <td><input name="Papellido1" type="text" size="20" maxlength="10" value="#fPapellido1#" tabindex="1"></td> 
      <td><input name="Papellido2" type="text" size="20" maxlength="10" value="#fPapellido2#" tabindex="1"></td>
      <td>
	  	  <input name="Pnombre" type="text" size="20" maxlength="50" value="#fPnombre#" tabindex="">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Limpiar"
			Default="Limpiar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Limpiar"/>

          <input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
		  <input type="button" name="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript: limpiarCampos();" tabindex="1">
	  </td>
    </tr>
	
	</cfoutput>

    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
	  
        <td nowrap <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
			<input type="hidden" name="Usucodigo#conlis.CurrentRow#" value="#conlis.Usucodigo#"> 
          <a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.NombreCompleto)#');">#conlis.Papellido1#</a>
		</td>
	  
		<td nowrap <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
			<input type="hidden" name="Usucodigo#conlis.CurrentRow#" value="#conlis.Usucodigo#"> 
          <a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.NombreCompleto)#');">#conlis.Papellido2#</a>
		</td>
        
		<td nowrap <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
			<input type="hidden" name="Usucodigo#conlis.CurrentRow#" value="#conlis.Usucodigo#"> 
          <a href="javascript:Asignar('#conlis.Usucodigo#', '#JSStringFormat(conlis.NombreCompleto)#');">#conlis.Pnombre#</a>
		</td>
      
	  </tr>
    </cfoutput> 

    <tr> 
      <td colspan="4">&nbsp; </td>
    </tr>
	
    <tr> 
      <td colspan="4">&nbsp; <table border="0" width="50%" align="center">
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
       </td>
    </tr>
	
  </table>
</form>

</body>
</html>
