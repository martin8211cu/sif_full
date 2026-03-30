<!--- Recibe conexion, form, name, desc, id y peso --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc,id, tipo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.#Url.id#.value = id;
		window.opener.document.#Url.form#.#Url.tipo#.value = tipo;

		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		</cfoutput>
		window.close();
	}
}
</script>

<cfset filtro = "">

<cfset LvarEmpresa = Session.Ecodigo>

<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.Banco") and not isdefined("Form.Banco")>
	<cfparam name="Form.Banco" default="#Url.Banco#">
</cfif>

<cfif isdefined("Url.BTcodigo") and not isdefined("Form.fBTcodigo")>
	<cfparam name="Form.fBTcodigo" default="#Url.BTcodigo#">
</cfif>
<cfif isdefined("url.BTdescripcion") and not isdefined("form.fBTdescripcion")>
	<cfparam name="form.fBTdescripcion" default="#url.BTdescripcion#">
</cfif>
<cfif isdefined("url.BTtipo") and not isdefined("form.fBTtipo")>
	<cfparam name="form.fBTtipo" default="#url.BTtipo#">
</cfif>

<cfset navegacion = "empresa=" & LvarEmpresa>

<cfif isdefined("Form.fBTcodigo") and Len(Trim(Form.fBTcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(BTcodigo) like '%" & #UCase(trim(Form.fBTcodigo))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BTcodigo=" & Form.fBTcodigo>
</cfif>
<cfif isdefined("Form.fBTdescripcion") and Len(Trim(Form.fBTdescripcion))>
 	<cfset filtro = filtro & " and upper(BTdescripcion) like '%" & #UCase(trim(Form.fBTdescripcion))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BTdescripcion=" & Form.fBTdescripcion>
</cfif>
<cfif isdefined("Form.fBTtipo") and Len(Trim(Form.fBTtipo)) and Form.fBTtipo NEQ -1>
 	<cfset filtro = filtro & " and upper(BTtipo) like '%" & #UCase(trim(Form.fBTtipo))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BTtipo=" & Form.fBTtipo>
</cfif>

<html>
<head>
<title>Tipos&nbsp;de&nbsp;Transacci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMBTransaccionesLibros" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="fBTcodigo" type="text" id="name" size="6" maxlength="4" value="<cfif isdefined("Form.fBTcodigo")>#Form.fBTcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="fBTdescripcion" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.fBTdescripcion")>#Form.fBTdescripcion#</cfif>">
		</td>
		<td>
			<select name="fBTtipo">
				<option value="-1">Todos</option>
				<option value="C" <cfif isdefined("fBTtipo") and form.fBTtipo EQ 'C'>selected</cfif>>Cr&eacute;dito</option>
				<option value="D">D&eacute;bito</option>
			</select>
		</td>
		
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="BTransacciones"/>
	<cfinvokeargument name="columnas" value="BTid, BTcodigo, BTdescripcion, case when BTtipo ='C' then 'Crédito' else 'Débito' end as BTtipo"/>
	<cfinvokeargument name="desplegar" value="BTcodigo, BTdescripcion,  BTtipo"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Tipo"/>
	<cfinvokeargument name="formatos" value="S, S, S"/>
    <cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa# #filtro#"/> 
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ConlisMBTransaccionesLibros.cfm"/>
	<cfinvokeargument name="formName" value="form1"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> 
	<cfinvokeargument name="fparams" value="BTcodigo, BTdescripcion, BTid, BTtipo"/> 
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		

</cfinvoke>
</body>
</html>
