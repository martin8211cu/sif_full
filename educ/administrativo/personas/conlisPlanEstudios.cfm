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

<cfif isdefined("Url.PEScodificacion_filtro") and not isdefined("Form.PEScodificacion_filtro")>
	<cfparam name="Form.PEScodificacion_filtro" default="#Url.PEScodificacion_filtro#">
</cfif>
<cfif isdefined("Url.PESnombre_filtro") and not isdefined("Form.PESnombre_filtro")>
	<cfparam name="Form.PESnombre_filtro" default="#Url.PESnombre_filtro#">
</cfif>

<cfset navegacion = "">
<cfset filtro = "">
<cfif isdefined('Url.quitar') and Url.quitar NEQ ''>
	<cfoutput>
		<cfset filtro = filtro & " and PEScodigo not in (#Url.quitar#)">
	</cfoutput>
</cfif>
<cfif isdefined("Form.PEScodificacion_filtro") and Len(Trim(Form.PEScodificacion_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(PEScodificacion) like '%" & #UCase(Form.PEScodificacion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PEScodificacion_filtro=" & Form.PEScodificacion_filtro>
</cfif>
<cfif isdefined("Form.PESnombre_filtro") and Len(Trim(Form.PESnombre_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(PESnombre) like '%" & #UCase(Form.PESnombre_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PESnombre_filtro=" & Form.PESnombre_filtro>
</cfif>

<html>
<head>
<title>Lista de Planes de Estudio</title>
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
			<input name="PEScodificacion_filtro" type="text" id="PEScodificacion_filtro" size="15" maxlength="15" value="<cfif isdefined("Form.PEScodificacion_filtro")>#Form.PEScodificacion_filtro#</cfif>">
		</td>
		<td width="10%" align="right"><strong>
	  Descripci&oacute;n</strong></td>
		<td> 
			<input name="PESnombre_filtro" type="text" id="PESnombre_filtro" size="50" maxlength="50" value="<cfif isdefined("Form.PESnombre_filtro")>#Form.PESnombre_filtro#</cfif>">
		</td>
	    <td align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
	</tr>	
</table>
</form>
</cfoutput>

<cfinvoke 
 component="educ.componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="PlanEstudios pes, GradoAcademico ga"/>
	<cfinvokeargument name="columnas" value="
		convert(varchar,PEScodigo) as PEScodigo
		, PEScodificacion
		, GAnombre + ' en ' + PESnombre as PESnombre"/>
	<cfinvokeargument name="desplegar" value="PEScodificacion, PESnombre"/>
	<cfinvokeargument name="etiquetas" value="Codigo, Plan de Estudios"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
				 ga.Ecodigo = #session.Ecodigo#
				 and ga.GAcodigo = pes.GAcodigo
				 and PESestado=1
				 and (getDate() between PESdesde and isnull(PEShasta,getDate()))
				#filtro# 
			Order by PESnombre"/>
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value="N,N"/>
	<cfinvokeargument name="irA" value="conlisPlanEstudios.cfm"/>
	<cfinvokeargument name="formName" value="listaPlanEstudios"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="PEScodigo"/>
	<cfinvokeargument name="debug" value="N"/>	
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>