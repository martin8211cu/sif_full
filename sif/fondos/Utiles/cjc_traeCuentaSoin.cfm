<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc, desccuenta,  nbanco) {
	if (window.opener != null) {
		<cfoutput>					
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.id_bancosoin.value = desccuenta;
		window.opener.document.#Url.form#.nbancosoin.value = nbanco;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.Nid_bancosoin" default="#Url.id#">
	<cfparam name="Form.Nname" default="#Url.name#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.fid_bancosoin") and Len(Trim(Form.fid_bancosoin)) NEQ 0>
	<cfset cond = " and"> 
	<cfset filtro = filtro & cond & " upper(B.B01COD) like '%" & #UCase(Form.fid_bancosoin)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "B01COD =" & Form.Nid_bancosoin>
</cfif>

<cfif isdefined("Form.fcuentasoin") and Len(Trim(Form.fcuentasoin)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(B.BANCUE) like '%" & #UCase(Form.fcuentasoin)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BANCUE=" & Form.fcuentasoin>
</cfif>

<cfif isdefined("Form.fdescuenta") and Len(Trim(Form.fdescuenta)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(B.BANDES) like '%" & #UCase(Form.fdescuenta)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BANDES=" & Form.fdescuenta>
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
					<input name="fid_bancosoin" type="text" id="name" size="5" maxlength="5" value="<cfif isdefined("Form.fid_bancosoin")>#Form.fid_bancosoin#</cfif>">
				</td>				
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="fcuentasoin" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.fcuentasoin")>#Form.fcuentasoin#</cfif>">
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
	<cfinvokeargument name="tabla" value="B01ARC A,BANARC B"/>
 	<cfinvokeargument name="columnas" value="A.B01COD, A.B01DES, B.BANCUE, B.BANDES"/>
	<cfinvokeargument name="desplegar" value="B01COD, B01DES, BANCUE, BANDES"/>
	<cfinvokeargument name="etiquetas" value="Código Banco, Nombre de Banco, Cuenta Corriente, Descripcion"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="A.B01COD = B.B01COD #filtro#"/>
	<cfinvokeargument name="align" value="left, left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="frmbancos"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="BANCUE, BANDES, B01COD, B01DES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>

