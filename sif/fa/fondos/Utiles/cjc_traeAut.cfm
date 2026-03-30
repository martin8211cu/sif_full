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

<cfif isdefined("Url.CP9COD") and not isdefined("Form.CP9COD")>
	<cfparam name="Form.CP9COD" default="#Url.CP9COD#">
</cfif>

<cfif isdefined("Url.CP9DES") and not isdefined("Form.CP9DES")>
	<cfparam name="Form.CP9DES" default="#Url.CP9DES#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CP9COD") and Len(Trim(Form.CP9COD)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(CPM009.CP9COD) like '%" & #UCase(Form.CP9COD)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPM009.CP9COD=" & Form.CP9COD>
</cfif>
<cfif isdefined("Form.CP9DES") and Len(Trim(Form.CP9DES)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " upper(CP9DES) like '%" & #UCase(Form.CP9DES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CP9DES=" & Form.CP9DES>
</cfif>
<html>
<head>
<title>Catálogo de Autorizadores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroAutorizadores" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Código</strong></td>
				<td> 
					<input name="CP9COD" type="text" id="name" size="20" maxlength="20" value="<cfif isdefined("Form.CP9COD")>#Form.CP9COD#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="CP9DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.CP9DES")>#Form.CP9DES#</cfif>">
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
	<cfinvokeargument name="tabla" value="CJM005,CPM009,CJM001"/>
 	<cfinvokeargument name="columnas" value="CJM005.CP9COD,CP9DES"/>
	<cfinvokeargument name="desplegar" value="CP9COD,CP9DES"/>
	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="CJM005.CP9COD = CPM009.CP9COD  AND CJM005.CJM00COD = CJM001.CJM00COD  AND CJM005.CJM05EST = 'A'  AND CJM001.CJ01ID='#trim(session.Fondos.Caja)#'  #filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaAutorizadores"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CP9COD,CP9DES"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>