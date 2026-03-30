<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc) {
	if (window.opener != null) {
		<cfoutput>
		//window.opener.document.#Url.form#.#Url.id#.value   = id;
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.DEPCOD") and not isdefined("Form.DEPCOD")>
	<cfparam name="Form.DEPCOD" default="#Url.DEPCOD#">
</cfif>

<cfif isdefined("Url.DEPDES") and not isdefined("Form.DEPDES")>
	<cfparam name="Form.DEPDES" default="#Url.DEPDES#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.DEPCOD") and Len(Trim(Form.DEPCOD)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(DEPCOD) like '%" & #UCase(Form.DEPCOD)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEPCOD=" & Form.DEPCOD>
</cfif>
<cfif isdefined("Form.DEPDES") and Len(Trim(Form.DEPDES)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(DEPDES) like '%" & #UCase(Form.DEPDES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEPDES=" & Form.DEPDES>
</cfif>
<html>
<head>
<title>Catálogo de Departamentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/sif/V5/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroDepartamento" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Código</strong></td>
				<td> 
					<input name="DEPCOD" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.DEPCOD")>#Form.DEPCOD#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="DEPDES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.DEPDES")>#Form.DEPDES#</cfif>">
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
	<cfinvokeargument name="tabla" value="PLX002,CJM017"/>
 	<cfinvokeargument name="columnas" value="DEPCOD,DEPDES"/>
	<cfinvokeargument name="desplegar" value="DEPCOD,DEPDES"/>
	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="DEPCOD = I04COD #filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaDepartamento"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="DEPCOD,DEPDES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>