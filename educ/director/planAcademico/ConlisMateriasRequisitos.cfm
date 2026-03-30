<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(cod) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.cod#.value = cod;
			<cfif isdefined('Url.btn') and Url.btn NEQ ''>
				window.opener.document.#Url.form#.#Url.btn#.value = 1;			
			</cfif>
			window.opener.document.#Url.form#.submit();			
		</cfoutput>
		
		window.close();
	}
}
</script>

<cfif isdefined("Url.Mcodificacion_filtro") and not isdefined("Form.Mcodificacion_filtro")>
	<cfparam name="Form.Mcodificacion_filtro" default="#Url.Mcodificacion_filtro#">
</cfif>
<cfif isdefined("Url.Mnombre_filtro") and not isdefined("Form.Mnombre_filtro")>
	<cfparam name="Form.Mnombre_filtro" default="#Url.Mnombre_filtro#">
</cfif>
<cfif isdefined("Url.EScodigo_filtro") and not isdefined("Form.EScodigo_filtro")>
	<cfparam name="Form.EScodigo_filtro" default="#Url.EScodigo_filtro#">
</cfif>

<cfset navegacion = "">
<cfif isdefined('Url.tipo') and Url.tipo NEQ ''>
	<cfoutput>
		<cfset filtro = "  and Mtipo = '#Url.tipo#'">
	</cfoutput>
<cfelse>
	<cfset filtro = "">
</cfif>
<cfif isdefined('Url.quitar') and Url.quitar NEQ ''>
	<cfoutput>
		<cfset filtro = filtro & " and Mcodigo not in (#Url.quitar#)">
	</cfoutput>
</cfif>
<cfif isdefined("Form.Mcodificacion_filtro") and Len(Trim(Form.Mcodificacion_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(Mcodificacion) like '%" & #UCase(Form.Mcodificacion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodificacion_filtro=" & Form.Mcodificacion_filtro>
</cfif>
<cfif isdefined("Form.Mnombre_filtro") and Len(Trim(Form.Mnombre_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Mnombre) like '%" & #UCase(Form.Mnombre_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre_filtro=" & Form.Mnombre_filtro>
</cfif>
<cfif isdefined("Form.EScodigo_filtro") and Len(Trim(Form.EScodigo_filtro)) NEQ 0 and Form.EScodigo_filtro NEQ '-1'>
 	<cfset filtro = filtro & " and EScodigo = " & #Form.EScodigo_filtro#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EScodigo_filtro=" & Form.EScodigo_filtro>
</cfif>
<cfinclude template="/educ/queries/qryEscuela.cfm">


<cfset filtro = filtro & " and ((EScodigo in (" & #ValueList(rsEscuela.EScodigo)# & ")) or (MotrasCarreras = 1))">

<html>
<head>
<title>Lista de Materias</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/educ/css/educ.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
<form name="materia_lista" method="post" style="margin: 0">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="9%" align="right"><strong>C&oacute;digo</strong></td>
		<td width="10%"> 
			<input name="Mcodificacion_filtro" type="text" id="Mcodificacion_filtro" size="15" maxlength="15" value="<cfif isdefined("Form.Mcodificacion_filtro")>#Form.Mcodificacion_filtro#</cfif>">
		</td>
		<td width="10%" align="right"><strong>Descripci&oacute;n</strong></td>
		<td colspan="2"> 
			<input name="Mnombre_filtro" type="text" id="Mnombre_filtro" size="50" maxlength="50" value="<cfif isdefined("Form.Mnombre_filtro")>#Form.Mnombre_filtro#</cfif>">
		</td>
	  </tr>
	<tr>
		<td align="right"><strong>#session.parametros.Escuela#:</strong></td>
		<td colspan="3">
			<select name="EScodigo_filtro" id="EScodigo_filtro">
				<option value="-1" <cfif isdefined('form.EScodigo_filtro') and form.EScodigo_filtro EQ '-1'> selected</cfif>>--
				TODAS --</option>			
			  <cfloop query="rsEscuela">
				<option value="#rsEscuela.EScodigo#" <cfif isdefined('form.EScodigo_filtro') and form.EScodigo_filtro EQ rsEscuela.EScodigo> selected</cfif>>#rsEscuela.ESnombre#</option>
			  </cfloop>
			</select>		
		</td>
		<td width="55%" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
	</tr>	
</table>
</form>
</cfoutput>

<cfinvoke 
 component="educ.componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="Materia"/>
	<cfinvokeargument name="columnas" value="convert(varchar, Mcodigo) as Mcodigo, Mcodificacion, Mnombre, case Mtipo when 'M' then 'Regular' when 'E' then 'Electiva' else 'Otro tipo' end as Tipo"/>
	<cfinvokeargument name="desplegar" value="Mcodificacion, Mnombre, Tipo"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción, Tipo"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
			Ecodigo = #Session.Ecodigo# 			
				and Mactivo = 1
				#filtro# 
			Order by Mnombre"/>
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisMaterias.cfm"/>
	<cfinvokeargument name="formName" value="listaMaterias"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Mcodigo"/>
	<cfinvokeargument name="debug" value="N"/>	
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>