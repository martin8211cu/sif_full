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

<cfif isdefined("Url.CG5CON") and not isdefined("Form.CG5CON")>
	<cfparam name="Form.CG5CON" default="#Url.CG5CON#">
</cfif>

<cfif isdefined("Url.CG5DES") and not isdefined("Form.CG5DES")>
	<cfparam name="Form.CG5DES" default="#Url.CG5DES#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CG5CON") and Len(Trim(Form.CG5CON)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " CG5CON  >=" & #Form.CG5CON#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CG5CON=" & Form.CG5CON>
</cfif>
<cfif isdefined("Form.CG5DES") and Len(Trim(Form.CG5DES)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(CG5DES) like '%" & #UCase(Form.CG5DES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CG5DES=" & Form.CG5DES>
</cfif>
<html>
<head>
<title>Asientos Contables</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroasientos" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Asiento</strong></td>
				<td> 
					<input name="CG5CON" type="text" id="name" size="20" maxlength="20" value="<cfif isdefined("Form.CG5CON")>#Form.CG5CON#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="CG5DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CG5DES")>#Form.CG5DES#</cfif>">
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
	<cfinvokeargument name="tabla" value="CGM005"/>
 	<cfinvokeargument name="columnas" value="CG5CON,CG5DES"/>
	<cfinvokeargument name="desplegar" value="CG5CON,CG5DES"/>
	<cfinvokeargument name="etiquetas" value="Asiento,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" 1=1  #filtro# order by CG5CON" />
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaasientos"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CG5CON,CG5DES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>
