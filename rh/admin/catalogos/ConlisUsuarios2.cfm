<html>
<head>
<title>
	<cf_translate key="LB_ListaDeUsuariosDeFacturacion">Lista de Usuarios de Facturaci&oacute;n</cf_translate>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<!--- Crea el filtro --->	
<cfset filtro = "" >
<cfif isdefined("Form.Filtrar") and (Form.Pnombre NEQ "")>
	<cfset filtro = " and upper(c.Pnombre) like '%#Ucase(Form.Pnombre)#%' ">
</cfif>	  
<cfif isdefined("Form.Filtrar") and (Form.Papellido1 NEQ "")>
	<cfset filtro = filtro & " and upper(c.Papellido1) like '%#Ucase(Form.Papellido1)#%' ">
</cfif>
<cfif isdefined("Form.Filtrar") and (Form.Papellido2 NEQ "")>
	<cfset filtro = filtro & " and upper(c.Papellido2) like '%#Ucase(Form.Papellido2)#%' ">
</cfif>

<!--- Consulta para desplejar los usuarios administradores --->
<cfquery name="conlis" datasource="asp">
	select 
		distinct <cf_dbfunction name="to_char" args="a.Usucodigo"> as Usucodigo, 
		c.Pnombre, 
		c.Papellido1, 
		c.Papellido2
	from Usuario a, vUsuarioProcesos b, DatosPersonales c
	where a.Usucodigo = b.Usucodigo
		and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		and a.datos_personales = c.datos_personales
		<cfif len(trim(filtro)) gt 0>
			#preservesinglequotes(filtro)#
		</cfif>
		and a.Utemporal = 0
		and a.Uestado = 1
	order by c.Pnombre, c.Papellido1, c.Papellido2
</cfquery>

<!--- Asignación de variables y parametros --->
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

<!--- JavaScript --->
<script language="JavaScript1.2">
	function Asignar(valor1, valor2) {
		window.opener.document.form1.Adm_Usucodigo.value = valor1;
		window.opener.document.form1.Administrador.value = valor2;
		window.close();
	}
</script>

<body>
<form action="" method="post" name="conlis">
	<table border="0" cellspacing="0">
		<!--- Línea No. 1 --->
		<tr class="areaFiltro">
			<td class="tituloListas" width="1%">&nbsp;</td>
			<td class="tituloListas" align="left"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
			<td class="tituloListas" align="left"><cf_translate key="LB_PrimerApellido">Primer Apellido</cf_translate></td>
			<td class="tituloListas" align="left"><cf_translate key="LB_SegundoApellido">Segundo Apellido</cf_translate></td>
			<td class="tituloListas" align="right">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Filtrar"
					Default="Filtrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Filtrar"/>

				<input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
			</td>
		</tr>
		<!--- Línea No. 2 --->
		<tr class="areaFiltro">
			<td width="1%">&nbsp;</td>
			<td><input name="Pnombre"    type="text" size="20" maxlength="100"></td>
			<td><input name="Papellido1" type="text" size="20" maxlength="100"></td>
			<td><input name="Papellido2" type="text" size="20" maxlength="100"></td>
			<td>&nbsp;</td>
		</tr>
    	<!--- Línea No. 3 --->
		<cfif conlis.RecordCount gt 0>
			<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
				<tr <cfif #conlis.CurrentRow# MOD 2><cfoutput>class="listaPar"</cfoutput><cfelse><cfoutput>class="listaNon"</cfoutput></cfif> >
					<td>&nbsp;</td>
					<td nowrap><a href="javascript:Asignar('#conlis.Usucodigo#','#JSStringFormat(conlis.Pnombre)#'+' '+'#JSStringFormat(conlis.Papellido1)#'+' '+'#JSStringFormat(conlis.Papellido2)#');">#conlis.Pnombre#</a></td>
					<td nowrap><a href="javascript:Asignar('#conlis.Usucodigo#','#JSStringFormat(conlis.Pnombre)#'+' '+'#JSStringFormat(conlis.Papellido1)#'+' '+'#JSStringFormat(conlis.Papellido2)#');">#conlis.Papellido1#</a></td>
					<td nowrap><a href="javascript:Asignar('#conlis.Usucodigo#','#JSStringFormat(conlis.Pnombre)#'+' '+'#JSStringFormat(conlis.Papellido1)#'+' '+'#JSStringFormat(conlis.Papellido2)#');">#conlis.Papellido2#</a></td>
					<td>&nbsp;</td>
				</tr>
			</cfoutput> 
		<cfelse>		
			<tr>
				<td colspan="5" align="center" >
					<font size="2"> --- <cf_translate key="LB_NoHayDatos">No hay datos</cf_translate> --- </font>
				</td>
			</tr>
		</cfif>
	    <!--- Línea No. 4 --->
    	<tr> 
      		<td colspan="5"> 
				<table border="0" width="50%" align="center">&nbsp;
          			<cfoutput> 
            		<tr> 
              			<td colspan="4" align="center"> 
							<cfif PageNum_conlis GT 1>
                  				<a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a> 
                			</cfif>&nbsp;
							<cfif PageNum_conlis GT 1>
                  				<a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a> 
                			</cfif>&nbsp;&nbsp;
							<cfif PageNum_conlis LT TotalPages_conlis>
                  				<a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a> 
                			</cfif>&nbsp;
							<cfif PageNum_conlis LT TotalPages_conlis>
                  				<a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a> 
                			</cfif>
						</td>
            		</tr>
          			</cfoutput> 
        		</table>
			</td>
    	</tr>
  </table>
</form>
</body>
</html>

