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

<cfif isdefined("Url.EScodificacion_filtro") and not isdefined("Form.EScodificacion_filtro")>
	<cfparam name="Form.EScodificacion_filtro" default="#Url.EScodificacion_filtro#">
</cfif>
<cfif isdefined("Url.ESnombre_filtro") and not isdefined("Form.ESnombre_filtro")>
	<cfparam name="Form.ESnombre_filtro" default="#Url.ESnombre_filtro#">
</cfif>

<cfset navegacion = "">
<cfset filtro = "">
<cfif isdefined('Url.quitar') and Url.quitar NEQ ''>
	<cfoutput>
		<cfset filtro = filtro & " and EScodigo not in (#Url.quitar#)">
	</cfoutput>
</cfif>
<cfif isdefined("Form.EScodificacion_filtro") and Len(Trim(Form.EScodificacion_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(EScodificacion) like '%" & #UCase(Form.EScodificacion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EScodificacion_filtro=" & Form.EScodificacion_filtro>
</cfif>
<cfif isdefined("Form.ESnombre_filtro") and Len(Trim(Form.ESnombre_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(ESnombre) like '%" & #UCase(Form.ESnombre_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ESnombre_filtro=" & Form.ESnombre_filtro>
</cfif>

<html>
<head>
<title>Lista de <cfoutput>#session.parametros.Escuela#</cfoutput>s</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../css/educ.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
<form name="materia_lista" method="post" style="margin: 0">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="9%" align="right"><strong>C&oacute;digo</strong></td>
		<td width="10%"> 
			<input name="EScodificacion_filtro" type="text" id="EScodificacion_filtro" size="15" maxlength="15" value="<cfif isdefined("Form.EScodificacion_filtro")>#Form.EScodificacion_filtro#</cfif>">
		</td>
		<td width="10%" align="right"><strong>
	  Descripci&oacute;n</strong></td>
		<td> 
			<input name="ESnombre_filtro" type="text" id="ESnombre_filtro" size="50" maxlength="50" value="<cfif isdefined("Form.ESnombre_filtro")>#Form.ESnombre_filtro#</cfif>">
		</td>
	    <td align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Buscar"></td>
	</tr>	
</table>
</form>
</cfoutput>

<cfinvoke 
 component="educ.componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="
		Escuela e
		, Facultad f"/>
	<cfinvokeargument name="columnas" value="
			e.EScodigo
			, ESnombre
			, EScodificacion
			, Fnombre
			, e.Fcodigo"/>
	<cfinvokeargument name="desplegar" value="ESnombre, EScodificacion"/>
	<cfinvokeargument name="etiquetas" value="#session.parametros.Escuela#, Codificaci&oacute;n"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
				e.Ecodigo = #Session.Ecodigo# 			
				and e.Fcodigo=f.Fcodigo
				and e.Ecodigo=f.Ecodigo			
				#filtro# 
			Order by Fnombre,ESnombre"/>
	<cfinvokeargument name="align" value="left,center"/>
	<cfinvokeargument name="ajustar" value="N,N"/>
	<cfinvokeargument name="irA" value="ConlisEscuela.cfm"/>
	<cfinvokeargument name="formName" value="listaEscuelas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="EScodigo"/>
	<cfinvokeargument name="debug" value="N"/>	
	<cfinvokeargument name="Cortes" value="Fnombre"/>		
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>