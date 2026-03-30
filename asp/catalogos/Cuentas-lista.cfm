<!--- Hay que obtener los datos del Administrador Correcto --->
<cfquery name="rsAdministrador" datasource="asp">
	select b.Pnombre, b.Papellido1, b.Papellido2
	from Usuario a, DatosPersonales b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
	and a.datos_personales = b.datos_personales
</cfquery>

<cfif isdefined("Url.FCEcuenta") and not isdefined("Form.FCEcuenta")>
	<cfparam name="Form.FCEcuenta" default="#Url.FCEcuenta#">
</cfif>
<cfif isdefined("Url.FCEnombre") and not isdefined("Form.FCEnombre")>
	<cfparam name="Form.FCEnombre" default="#Url.FCEnombre#">
</cfif>

<cfset filtro = "">
<cfset additionalCols = "">
<cfset navegacion = "o=1">
<cfif isdefined("Form.FCEcuenta") and Len(Trim(Form.FCEcuenta)) NEQ 0>
	<cfset filtro = filtro & " and upper(CEcuenta) = '" & UCase(Form.FCEcuenta) & "'">
	<cfset additionalCols = additionalCols & "'#Form.FCEcuenta#' as FCEcuenta, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FCEcuenta=" & Form.FCEcuenta>
</cfif>
<cfif isdefined("Form.FCEnombre") and Len(Trim(Form.FCEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CEnombre) like '%" & UCase(Form.FCEnombre) & "%'">
	<cfset additionalCols = additionalCols & "'#Form.FCEnombre#' as FCEnombre, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FCEnombre=" & Form.FCEnombre>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfoutput>
<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">

<script language="javascript" type="text/javascript">
	function funcCancelar2() {
		<cfif isdefined("Session.Progreso.Pantalla") and Session.Progreso.Pantalla EQ "1">
			showList(false);
		</cfif>
		<cfif isdefined("Session.Progreso.Pantalla") and Session.Progreso.Pantalla NEQ "1">
			location.href = '/cfmx/asp/index.cfm';
		</cfif>
	}
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" class="tituloProceso" align="center">
		Trabajar con Cuentas Empresariales
	</td>
  </tr>
  <tr>
	<td colspan="2" class="tituloPersona" nowrap>
		#rsAdministrador.Pnombre#
		#rsAdministrador.Papellido1#
		#rsAdministrador.Papellido2#
	</td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
  	<td colspan="2" bgcolor="##A0BAD3">
		<cfinclude template="frame-cancelar.cfm">
	</td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td width="20%" rowspan="2" valign="top" class="textoAyuda">
		Seleccione la cuenta empresarial con la cual desea trabajar
	</td>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top">
		<form name="filtroCuentas" method="post" action="#CurrentPage#">
			<input type="hidden" name="o" value="1">
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			  <tr> 
				<td align="right" class="etiquetaCampo" nowrap>No. Cuenta</td>
				<td nowrap> 
					<input name="FCEcuenta" type="text" id="FCEcuenta" size="20" maxlength="60" value="<cfif isdefined("Form.FCEcuenta")>#Form.FCEcuenta#</cfif>">				</td>
				<td align="right" class="etiquetaCampo" nowrap>Descripción</td>
				<td nowrap> 
					<input name="FCEnombre" type="text" id="FCEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FCEnombre")>#Form.FCEnombre#</cfif>">				</td>
				<td width="20%" align="center" nowrap>
				  <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">				</td>
			  </tr>
		  </table>
		</form>
	</td>
  </tr>
  <tr>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top">
		<cfinvoke 
		 component="commons.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="CuentaEmpresarial"/>
			<cfinvokeargument name="columnas" value="#additionalCols# CEcodigo, CEcuenta, CEnombre"/>
			<cfinvokeargument name="desplegar" value="CEcuenta, CEnombre"/>
			<cfinvokeargument name="etiquetas" value="Cuenta Empresarial, Descripción"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="1=1 
												  #filtro# 
												  order by CEcuenta, CEnombre"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="#CurrentPage#"/>
			<cfinvokeargument name="keys" value="CEcodigo"/>
			<cfinvokeargument name="Conexion" value="asp"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="maxRows" value="20"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td>
  </tr>
</table>
</cfoutput>
