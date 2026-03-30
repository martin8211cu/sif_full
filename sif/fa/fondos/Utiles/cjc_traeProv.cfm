<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.id#.value   = id;
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.PROCED") and not isdefined("Form.PROCED")>
	<cfparam name="Form.PROCED" default="#Url.PROCED#">
</cfif>

<cfif isdefined("Url.PRONOM") and not isdefined("Form.PRONOM")>
	<cfparam name="Form.PRONOM" default="#Url.PRONOM#">
</cfif>

<cfif isdefined("Url.PROCOD") and not isdefined("Form.PROCOD")>
	<cfparam name="Form.PROCOD" default="#Url.PROCOD#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.PROCED") and Len(Trim(Form.PROCED)) NEQ 0>
	<cfset filtro = filtro & cond & " upper(PROCED) like '%" & #UCase(Form.PROCED)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PROCED=" & Form.PROCED>
	<cfset cond = " and">
</cfif>
<cfif isdefined("Form.PRONOM") and Len(Trim(Form.PRONOM)) NEQ 0>
 	<cfset filtro = filtro & cond & " upper(PRONOM) like '%" & #UCase(Form.PRONOM)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PRONOM=" & Form.PRONOM>
	<cfset cond = " and">
</cfif>
<html>
<head>
<title>Catálogo de Proveedores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroEmpleado" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Cédula</strong></td>
				<td> 
					<input name="PROCED" type="text" id="name" size="16" maxlength="16" value="<cfif isdefined("Form.PROCED")>#Form.PROCED#</cfif>">
				</td>
				<td align="right"><strong>Nombre</strong></td>
				<td> 
					<input name="PRONOM" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.PRONOM")>#Form.PRONOM#</cfif>">
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
	<cfinvokeargument name="tabla" value="CPM002"/>
 	<cfinvokeargument name="columnas" value="PROCED,PROCOD,PRONOM"/>
	<cfinvokeargument name="desplegar" value="PROCED,PRONOM"/>
	<cfinvokeargument name="etiquetas" value="Cédula,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="listaProveedores"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="PROCOD,PROCED,PRONOM"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>