<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc) {
	if (window.opener != null) {
		<cfoutput>			
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = 'Relacion Masiva';
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.CJX19REL") and not isdefined("Form.CJX19REL")>
	<cfparam name="Form.CJX19REL" default="#Url.CJX19REL#">
	<!--- <cfparam name="Form.CJX19DES" default="#Url.CJX19REL#"> --->
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CJX19REL") and Len(Trim(Form.CJX19REL)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " CJX019.CJX19REL = " & #UCase(Form.CJX19REL)#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CJX019.CJX19REL =" & Form.CJX19REL>
</cfif>
<!--- 
<cfif isdefined("Form.CJX19REL") and Len(Trim(Form.CJX19REL)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(CJX19REL) like '%" & #UCase(Form.CJX19REL)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CJX19REL=" & Form.CJX19REL>
</cfif> --->

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
					<input name="CJX19REL" type="text" id="name" size="5" maxlength="5" value="<cfif isdefined("Form.CJX19REL")>#Form.CJX19REL#</cfif>">
				</td>
				<!--- 
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="CJM00DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CJM00DES")>#Form.CJM00DES#</cfif>">
				</td> --->
				
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
	<cfinvokeargument name="tabla" value="CJX019"/>
 	<cfinvokeargument name="columnas" value="CJX19REL, CJX19FED, CJX19FEP"/>
	<cfinvokeargument name="desplegar" value="CJX19REL, CJX19FED, CJX19FEP"/>
	<cfinvokeargument name="etiquetas" value="Código, Fecha de Creacion, Fecha de Posteo"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" CJX19EST='P' and CJ01ID = '#session.Fondos.Caja#' #filtro#"/>
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaRelaciones"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CJX19REL"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>
