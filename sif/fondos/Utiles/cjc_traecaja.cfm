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

<cfif isdefined("Url.CJM01ID") and not isdefined("Form.CJM01ID")>
	<cfparam name="Form.CJM01ID" default="#Url.CJM01ID#">
</cfif>

<cfif isdefined("Url.CJ1DES") and not isdefined("Form.CJ1DES")>
	<cfparam name="Form.CJ1DES" default="#Url.CJ1DES#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CJM01ID") and Len(Trim(Form.CJM01ID)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(CJM001.CJ01ID) like '%" & #UCase(Form.CJM01ID)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CJM001.CJ01ID=" & Form.CJM01ID>
</cfif>
<cfif isdefined("Form.CJ1DES") and Len(Trim(Form.CJ1DES)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(CJ1DES) like '%" & #UCase(Form.CJ1DES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CJ1DES=" & Form.CJ1DES>
</cfif>
<html>
<head>
<title>Cat&aacute;logo de Fondos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroFondos" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="CJM01ID" type="text" id="name" size="5" maxlength="5" value="<cfif isdefined("Form.CJ01ID")>#Form.CJ01ID#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="CJ1DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CJ1DES")>#Form.CJ1DES#</cfif>">
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
	<cfinvokeargument name="tabla" value="CJM001"/>
 	<cfinvokeargument name="columnas" value="CJ01ID,CJ1DES"/>
	<cfinvokeargument name="desplegar" value="CJ01ID,CJ1DES"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" exists(Select 1 from CJX019 where CJM001.CJ01ID = CJX019.CJ01ID) #filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaFondos"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CJ01ID,CJ1DES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>
