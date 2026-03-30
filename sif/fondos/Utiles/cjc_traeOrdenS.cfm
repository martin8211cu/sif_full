<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.CJM16COD") and not isdefined("Form.CJM16COD")>
	<cfparam name="Form.CJM16COD" default="#Url.CJM16COD#">
</cfif>

<cfif isdefined("Url.CJM16DES") and not isdefined("Form.CJM16DES")>
	<cfparam name="Form.CJM16DES" default="#Url.CJM16DES#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CJM16COD") and Len(Trim(Form.CJM16COD)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(CJM16COD) like '%" & #UCase(Form.CJM16COD)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CJM16COD=" & Form.CJM16COD>
</cfif>
<cfif isdefined("Form.CJM16DES") and Len(Trim(Form.CJM16DES)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(CJM16DES) like '%" & #UCase(Form.CJM16DES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CJM16DES=" & Form.CJM16DES>
</cfif>
<html>
<head>
<title>Catálogo de Ordenes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroOrdenes" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Código</strong></td>
				<td> 
					<input name="CJM16COD" type="text" id="name" size="14" maxlength="14" value="<cfif isdefined("Form.CJM16COD")>#Form.CJM16COD#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="CJM16DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CJM16DES")>#Form.CJM16DES#</cfif>">
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
	<cfinvokeargument name="tabla" value="CJM016"/>
 	<cfinvokeargument name="columnas" value="CJM16COD,CJM16DES"/>
	<cfinvokeargument name="desplegar" value="CJM16COD,CJM16DES"/>
	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="CJM16CIE <> 1  #filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaOrdenes"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CJM16COD,CJM16DES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>
