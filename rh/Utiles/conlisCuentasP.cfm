<html>
<head>
<title>Lista de Cuentas Presupuesto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
	<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
	
	<!--- Variables de la pantalla Original --->
	<cfif isdefined("Url.f") and not isdefined("Form.f")>
		<cfparam name="Form.f" default="#Url.f#">
	</cfif>
	
	<cfif isdefined("Url.m") and not isdefined("Form.m")>
		<cfparam name="Form.m" default="#Url.m#">
	</cfif>
	<cfparam name="Form.m" default="">
	
	<cfif isdefined("Url.d") and not isdefined("Form.d")>
		<cfparam name="Form.d" default="#Url.d#">
	</cfif>
	<cfparam name="Form.d" default="">
	
	<cfif isdefined("Url.CPcuenta") and not isdefined("Form.CPcuenta")>
		<cfparam name="Form.CPcuenta" default="#Url.CPcuenta#">
	</cfif>
	<cfif isdefined("Url.CPformato") and not isdefined("Form.CPformato")>
		<cfparam name="Form.CPformato" default="#Url.CPformato#">
	</cfif>

	<!--- Variables de los Filtros --->	
	<cfif isdefined("Url.fCPformato") and not isdefined("Form.fCPformato")>
		<cfparam name="Form.fCPformato" default="#Url.fCPformato#">
	</cfif>
	<cfif isdefined("Url.fDescripcion") and not isdefined("Form.fDescripcion")>
		<cfparam name="Form.fDescripcion" default="#Url.fDescripcion#">
	</cfif>	 
	
	<!--- **************************************************************************** ---> 
	<!--- **************************************************************************** --->
	
	<script language="javascript1.2" type="text/javascript">
		function Asignar(cuenta, formato, descripcion)
		{
			if (window.opener != null) {
				<cfoutput>
					window.opener.document.#Form.f#.#Form.CPcuenta#.value = cuenta;
				<cfif Len(Trim(Form.m)) NEQ 0>
					window.opener.document.#Form.f#.#Form.CPformato#.value = formato.substring(5);
				<cfelse>
					window.opener.document.#Form.f#.#Form.CPformato#.value = formato;
				</cfif>
				<cfif Len(Trim(Form.d)) NEQ 0>
					if (window.opener.document.#Form.f#.#Form.d#)
						window.opener.document.#Form.f#.#Form.d#.value = descripcion;
				</cfif>
				</cfoutput>
				window.close();
			}	
		}
	</script>
	
	<cfset filtro = "" >
	<cfset navegacion = "" >
	
	<!--- Nombre de los campos de la pantalla Original --->
	<cfif isdefined("Form.f") and Len(Trim(Form.f)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f>
	</cfif>
	<cfif Len(Trim(Form.m)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "m=" & Form.m>
	</cfif>
	<cfif isdefined("Form.CPcuenta") and Len(Trim(Form.CPcuenta)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPcuenta=" & Form.CPcuenta>
	</cfif>
	<cfif isdefined("Form.CPformato") and Len(Trim(Form.CPformato)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPformato=" & Form.CPformato>
	</cfif>

	<!--- Filtros del conlis --->
	<cfif Len(Trim(Form.m)) NEQ 0>
		<cfset filtro = filtro & " and Cmayor = '#Form.m#'" >
	</cfif>

	<cfif isdefined("Form.fCPformato") and Len(Trim(Form.fCPformato)) NEQ 0>
		<cfset filtro = filtro & " and upper(CPformato) like '%#UCase(Form.fCPformato)#%'" >
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCPformato=" & Form.fCPformato>
	</cfif>
	<cfif isdefined("Form.fDescripcion") and Len(Trim(Form.fDescripcion)) NEQ 0>
		<cfset filtro = filtro & " and upper(coalesce(CPdescripcionF,CPdescripcion)) like '%#UCase(Form.fDescripcion)#%' or upper(CPdescripcion) like '%#UCase(Form.fDescripcion)#%'" >
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPdescripcionF=" & Form.fDescripcion & " or CPdescripcion=" & Form.fDescripcion >
	</cfif>

	<!--- **************************************************************************** ---> 
	<!--- **************************************************************************** --->
	
	<cfoutput>
		<form name="filtroCuentasP" method="post" action="#CurrentPage#" style="margin:0; ">
			<input type="hidden" name="f" value="#Form.f#">
			<input type="hidden" name="m" value="#Form.m#">
			<input type="hidden" name="CPcuenta" value="#Form.CPcuenta#">
			<input type="hidden" name="CPformato" value="#Form.CPformato#">

			<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr> 
					<td nowrap align="right">Cuenta:</td>
					<td> 
						<input name="fCPformato" type="text" id="CPformato" size="20" maxlength="60" value="<!--- <cfif isdefined("Form.RHTcodigo")>#Form.RHTcodigo#</cfif> --->">
					</td>
					<td nowrap align="right">Descripci&oacute;n:</td>
					<td> 
						<input name="fDescripcion" type="text" id="Descripcion" size="40" maxlength="80" value="<!--- <cfif isdefined("Form.RHTdesc")>#Form.RHTdesc#</cfif> --->">
					</td>
					<td align="center" rowspan="2">
						<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
					</td>
				</tr>
				<tr>
					<td nowrap align="right">Centro Funcional:</td>
					<td colspan="4"> 
						<cf_CPSegUsu_setCFid Consultar="true" name="CFidFiltro"> 
						<cf_CPSegUsu_cboCFid value="#form.CFidFiltro#" Consultar="true" name="CFidFiltro"> 
					</td>
				</tr>
			</table>
		</form>
	</cfoutput>
	
	<!--- **************************************************************************** ---> 
	<!--- **************************************************************************** --->
	
	<cf_CPSegUsu_where Consultar="true" name="CFidFiltro" aliasCuentas="CPresupuesto" returnVariable="LvarCFfiltro">
	
	<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="CPresupuesto"/>
		<cfinvokeargument name="columnas" value="CPcuenta, CPformato, coalesce(CPdescripcionF,CPdescripcion) as Descripcion"/>
		<cfinvokeargument name="desplegar" value="CPformato, Descripcion"/>
		<cfinvokeargument name="etiquetas" value="Formato Cuenta, Descripci&oacute;n"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" Ecodigo = #Session.Ecodigo# and CPmovimiento = 'S' #filtro# #LvarCFfiltro# order by Ecodigo, Cmayor, CPformato"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="conlisCuentasP.cfm"/>
		<cfinvokeargument name="formName" value="listaCuentasP"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="CPcuenta, CPformato, Descripcion"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>
	
</body>
</html>

