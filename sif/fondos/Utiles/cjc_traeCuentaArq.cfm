<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc, desccuenta,  nbanco) {
	if (window.opener != null) {
		<cfoutput>					
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.id_bancoarq.value = desccuenta;
		window.opener.document.#Url.form#.nbancoarq.value = nbanco;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.Nid_bancoarq" default="#Url.id#">
	<cfparam name="Form.Nname" default="#Url.name#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.fid_bancoarq") and Len(Trim(Form.fid_bancoarq)) NEQ 0>
	<cfset cond = " and"> 
	<cfset filtro = filtro & cond & " B.id_banco = " & #UCase(Form.fid_bancoarq)#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "id_banco =" & #Form.Nid_bancoarq#>
</cfif>

<cfif isdefined("Form.fcuentaarq") and Len(Trim(Form.fcuentaarq)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(B.cuenta_corriente) like '%" & #UCase(Form.fcuentaarq)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cuenta_corriente=" & #Form.fcuentaarq#>
</cfif>

<cfif isdefined("Form.fdescuenta") and Len(Trim(Form.fdescuenta)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(B.nombre_cuenta) like '%" & #UCase(Form.fdescuenta)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombre_cuenta=" & #Form.fdescuenta#>
</cfif>

<html>
<head>
<title>Relaciones que pueden Ajustarse</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroRel" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="left" style="width:50px"><strong>Código</strong></td>
				<td> 
					<input name="fid_bancoarq" type="text" id="name" size="5" maxlength="5" value="<cfif isdefined("Form.fid_bancosoin")>#Form.fid_bancosoin#</cfif>">
				</td>				
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="fcuentaarq" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.fcuentasoin")>#Form.fcuentasoin#</cfif>">
				</td>
				<td align="right"><strong>Descripción Cuenta</strong></td>
				<td> 
					<input name="fdescuenta" type="text" id="desccuenta" size="40" maxlength="80" value="<cfif isdefined("Form.fcuentasoin")>#Form.fcuentasoin#</cfif>">
				</td>
								
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
<cfinvoke 
 component="sif.fondos.Componentes.pListas"
 method="pLista"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="arquitectura..EBA01C A, arquitectura..EBA02C B"/>
 	<cfinvokeargument name="columnas" value="A.id_banco, A.nombre_banco, B.cuenta_corriente, B.nombre_cuenta"/>
	<cfinvokeargument name="desplegar" value="id_banco, nombre_banco, cuenta_corriente, nombre_cuenta"/>
	<cfinvokeargument name="etiquetas" value="Código Banco, Nombre de Banco, Cuenta Corriente, Descripcion"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="A.id_banco = B.id_banco #filtro#"/>
	<cfinvokeargument name="align" value="left, left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="frmbancos"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="cuenta_corriente, nombre_cuenta, id_banco, nombre_banco"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>

