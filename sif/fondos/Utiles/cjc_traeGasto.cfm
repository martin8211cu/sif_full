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

<cfif isdefined("Url.CP7SUB") and not isdefined("Form.CP7SUB")>
	<cfparam name="Form.CP7SUB" default="#Url.CP7SUB#">
</cfif>

<cfif isdefined("Url.CP7DES") and not isdefined("Form.CP7DES")>
	<cfparam name="Form.CP7DES" default="#Url.CP7DES#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CP7SUB") and Len(Trim(Form.CP7SUB)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " CP7SUB >= " & #Form.CP7SUB# >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CP7SUB=" & Form.CP7SUB>
</cfif>
<cfif isdefined("Form.CP7DES") and Len(Trim(Form.CP7DES)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(CP7DES) like '%" & #UCase(Form.CP7DES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CP7DES=" & Form.CP7DES>
</cfif>
<html>
<head>
<title>Catálogo de Objeto de Gasto</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>

<cfoutput>
	<form style="margin:0; " name="filtroFondos" method="post">
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Código</strong></td>
				<td> 
					<input name="CP7SUB" type="text" id="name" size="5" maxlength="5" value="<cfif isdefined("Form.CP7SUB")>#Form.CP7SUB#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="CP7DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CP7DES")>#Form.CP7DES#</cfif>">
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
	<cfinvokeargument name="tabla" value="CPM007"/>
	<cfinvokeargument name="columnas" value="CP7SUB,CP7DES"/>
	<cfinvokeargument name="desplegar" value="CP7SUB,CP7DES"/>
	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" 1=1 #filtro# order by CP7SUB"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaFondos"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CP7SUB,CP7DES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>

</body>
</html>
