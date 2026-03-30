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

<cfif isdefined("Url.CJM00COD") and not isdefined("Form.CJM00COD")>
	<cfparam name="Form.CJM00COD" default="#Url.CJM00COD#">
</cfif>

<cfif isdefined("Url.CJM00DES") and not isdefined("Form.CJM00DES")>
	<cfparam name="Form.CJM00DES" default="#Url.CJM00DES#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CJM00COD") and Len(Trim(Form.CJM00COD)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(a.CJM00COD) like '%" & #UCase(Form.CJM00COD)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "a.CJM00COD=" & Form.CJM00COD>
</cfif>
<cfif isdefined("Form.CJM00DES") and Len(Trim(Form.CJM00DES)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(a.CJM00DES) like '%" & #UCase(Form.CJM00DES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "a.CJM00DES=" & Form.CJM00DES>
</cfif>
<html>
<head>
<title>Catálogo de Fondos</title>
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
					<input name="CJM00COD" type="text" id="name" size="5" maxlength="5" value="<cfif isdefined("Form.CJM00COD")>#Form.CJM00COD#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="CJM00DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CJM00DES")>#Form.CJM00DES#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<cfif not isdefined("filtrarUsuario") or len(trim(filtrarUsuario))eq 0>
	<cfset filtrarUsuario = false>
</cfif>

<cfif filtrarUsuario>
	<cfquery name="rsUsuarioFondo" datasource="#session.Fondos.dsn#">
		select count (1) as cantidad
		from CJM010 a, CJM000 b 
		where a.CJM00COD = b.CJM00COD 
		   and CJM10LOG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
		   and CJM10EST = 'A'
	</cfquery>
	<cfif rsUsuarioFondo.cantidad eq 0 >
		<cfset filtrarUsuario = false>
	</cfif>
</cfif>

<cfif filtrarUsuario>
	<cfinvoke 
	 component="sif.fondos.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CJM000 a, CJM010 b"/>
		<cfinvokeargument name="columnas" value="a.CJM00COD,a.CJM00DES"/>
		<cfinvokeargument name="desplegar" value="CJM00COD,CJM00DES"/>
		<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" a.CJM00COD = b.CJM00COD
												and CJM00EST='A'  
												and CJM10LOG = '#session.usuario#' 
												#filtro#  
												order by CJM00COD"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
		<cfinvokeargument name="formName" value="listaFondos"/>
		<cfinvokeargument name="MaxRows" value="20"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="CJM00COD,CJM00DES"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	</cfinvoke>
<cfelse>
	<cfinvoke 
	 component="sif.fondos.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CJM000 a"/>
		<cfinvokeargument name="columnas" value="a.CJM00COD,a.CJM00DES"/>
		<cfinvokeargument name="desplegar" value="CJM00COD,CJM00DES"/>
		<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" a.CJM00EST='A' #filtro# order by a.CJM00COD"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
		<cfinvokeargument name="formName" value="listaFondos"/>
		<cfinvokeargument name="MaxRows" value="20"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="CJM00COD,CJM00DES"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	</cfinvoke>
</cfif>

</body>
</html>
