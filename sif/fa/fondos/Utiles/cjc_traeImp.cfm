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

<cfif isdefined("Url.I92COD") and not isdefined("Form.I92COD")>
	<cfparam name="Form.I92COD" default="#Url.I92COD#">
</cfif>

<cfif isdefined("Url.I92DES") and not isdefined("Form.I92DES")>
	<cfparam name="Form.I92DES" default="#Url.I92DES#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.I92COD") and Len(Trim(Form.I92COD)) NEQ 0>
	<cfset filtro = filtro & cond & " upper(I92ARC.I92COD) like '%" & #UCase(Form.I92COD)# & "%'">
	<cfset cond = " and">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "I92ARC.I92COD=" & Form.I92COD>
</cfif>
<cfif isdefined("Form.I92DES") and Len(Trim(Form.I92DES)) NEQ 0>
 	<cfset filtro = filtro & cond & " upper(I92DES) like '%" & #UCase(Form.I92DES)# & "%'">
	<cfset cond = " and">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "I92DES=" & Form.I92DES>
</cfif>
<html>
<head>
<title>Catálogo de Impuestos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroImpuestos" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Código</strong></td>
				<td> 
					<input name="I92COD" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.I92COD")>#Form.I92COD#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="I92DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.I92DES")>#Form.I92DES#</cfif>">
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
	<cfinvokeargument name="tabla" value="I92ARC"/>
 	<cfinvokeargument name="columnas" value="I92COD,I92DES"/>
	<cfinvokeargument name="desplegar" value="I92COD,I92DES"/>
	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaImpuestos"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="I92COD,I92DES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>