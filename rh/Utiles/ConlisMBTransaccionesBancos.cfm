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

<cfif isdefined("Url.BTEcodigo") and not isdefined("Form.fBTEcodigo")>
	<cfparam name="Form.fBTEcodigo" default="#Url.BTEcodigo#">
</cfif>
<cfif isdefined("url.BTEdescripcion") and not isdefined("form.fBTEdescripcion")> 
	<cfparam name="Form.fBTEdescripcion" default="#url.BTEdescripcion#">
</cfif>
<cfif isdefined("url.BTEtipo") and not isdefined("form.fBTEtipo")> 
	<cfparam name="Form.fBTEtipo" default="#url.BTEtipo#">
</cfif>


<cfset navegacion = "empresa=" & LvarEmpresa>
<cfif isdefined("Form.Banco") and Len(Trim(Form.Banco)) NEQ 0>
	<cfset filtro = filtro & " Bid  = #Form.Banco#">
</cfif>


<cfif isdefined("Form.fBTEcodigo") and Len(Trim(Form.fBTEcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(BTEcodigo) like '%" & #UCase(trim(Form.fBTEcodigo))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BTEcodigo=" & Form.fBTEcodigo>
</cfif>
<cfif isdefined("Form.fBTEdescripcion") and Len(Trim(Form.fBTEdescripcion))>
 	<cfset filtro = filtro & " and upper(BTEdescripcion) like '%" & #UCase(trim(Form.fBTEdescripcion))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BTEdescripcion=" & Form.fBTEdescripcion>
</cfif>
<cfif isdefined("Form.fBTEtipo") and Len(Trim(Form.fBTEtipo)) and Form.fBTEtipo NEQ -1>
 	<cfset filtro = filtro & " and upper(BTEtipo) like '%" & #UCase(trim(Form.fBTEtipo))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "BTEtipo=" & Form.fBTEtipo>
</cfif>
<html>
<head>
<title><cf_translate  key="LB_TiposDeransaccion">Tipos&nbsp;de&nbsp;Transacci&oacute;n</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMBTransaccionesBancos" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CODIGO"
Default="C&oacute;digo"
XmlFile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DESCRIPCION"
Default="Descripci&oacute;n"
XmlFile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Tipo"
Default="Tipo"
returnvariable="LB_Tipo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>


<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>#LB_CODIGO#</strong></td>
		<td> 
			<input name="fBTEcodigo" type="text" id="name" size="6" maxlength="4" value="<cfif isdefined("Form.fBTEcodigo")>#Form.fBTEcodigo#</cfif>">
		</td>
		<td align="right"><strong>#LB_DESCRIPCION#</strong></td>
		<td> 
			<input name="fBTEdescripcion" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.fBTEdescripcion")>#Form.fBTEdescripcion#</cfif>">
		</td>
		<td align="right"><strong>#LB_Tipo#</strong></td>
		<td> 
			<!--- <input name="fBTEtipo" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.fBTEdescripcion")>#Form.fBTEdescripcion#</cfif>"> --->
			<select name="fBTEtipo">
				<option value="-1"><cf_translate  key="LB_Tipo">Tipo</cf_translate></option>
				<option value="C" <cfif isdefined("form.fBTEtipo") and form.fBTEtipo EQ 'C'>selected</cfif>><cf_translate  key="LB_Credito">Crédito</cf_translate></option>
				<option value="D" <cfif isdefined("form.fBTEtipo") and form.fBTEtipo EQ 'D'>selected</cfif>><cf_translate  key="LB_Debito">Débito</cf_translate></option>
			</select>
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="TransaccionesBanco"/>
	<cfinvokeargument name="columnas" value="Bid, BTEcodigo, BTEdescripcion, case when BTEtipo ='C' then 'Crédito' else 'Débito' end as BTEtipo"/>
	<cfinvokeargument name="desplegar" value="BTEcodigo, BTEdescripcion, BTEtipo"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#, #LB_Tipo#"/>
	<cfinvokeargument name="formatos" value="S, S, S"/>
    <cfinvokeargument name="filtro" value="#filtro#"/> 
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ConlisMBTransaccionesBancos.cfm"/>
	<cfinvokeargument name="formName" value="form1"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> 
	<cfinvokeargument name="fparams" value="BTEcodigo, BTEdescripcion, Bid, BTEtipo"/> 
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		

</cfinvoke>
</body>
</html>
