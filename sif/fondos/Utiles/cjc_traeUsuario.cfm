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

<cfif isdefined("Url.CGE20NOL") and not isdefined("Form.CGE20NOL")>
	<cfparam name="Form.CGE20NOL" default="#Url.CGE20NOL#">
</cfif>

<cfif isdefined("Url.CGE20NOC") and not isdefined("Form.CGE20NOC")>
	<cfparam name="Form.CGE20NOC" default="#Url.CGE20NOC#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CGE20NOL") and Len(Trim(Form.CGE20NOL)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(CGE20NOL) like '%" & #UCase(Form.CGE20NOL)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CGE20NOL=" & Form.CGE20NOL>
</cfif>
<cfif isdefined("Form.CGE20NOC") and Len(Trim(Form.CGE20NOC)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(CGE20NOC) like '%" & #UCase(Form.CGE20NOC)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CGE20NOC=" & Form.CGE20NOC>
</cfif>
<html>
<head>
<title>Catálogo de Usuarios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>

<cfoutput>
	<form style="margin:0; " name="filtroUsuarios" method="post">
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Login</strong></td>
				<td> 
					<input name="CGE20NOL" type="text" id="name" size="5" maxlength="5" value="<cfif isdefined("Form.CGE20NOL")>#Form.CGE20NOL#</cfif>">
				</td>
				<td align="right"><strong>Nombre</strong></td>
				<td> 
					<input name="CGE20NOC" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CGE20NOC")>#Form.CGE20NOC#</cfif>">
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
	<cfinvokeargument name="tabla" value="CGE020"/>
	<cfinvokeargument name="columnas" value="CGE20NOL,CGE20NOC"/>
	<cfinvokeargument name="desplegar" value="CGE20NOL,CGE20NOC"/>
	<cfinvokeargument name="etiquetas" value="Login,Nombre"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" 1=1 #filtro# order by CGE20NOL"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaUsuarios"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CGE20NOL,CGE20NOC"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>

</body>
</html>
