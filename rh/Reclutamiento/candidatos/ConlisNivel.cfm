<!--- Recibe conexion, form, name y desc --->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Lista_de_Niveles"
Default="Lista de Niveles"
returnvariable="LB_Lista_de_Niveles"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="C&oacute;digo"
returnvariable="LB_Codigo"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
returnvariable="LB_Descripcion"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Filtrar"
Default="Filtrar"
returnvariable="LB_Filtrar"/> 

<script language="JavaScript" type="text/javascript">
function Asignar(name) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.name#.value = name;		
		</cfoutput>
		window.close();
	}
}
</script>


<cfif isdefined("Url.GAcodigo_filtro") and not isdefined("Form.GAcodigo_filtro")>
	<cfparam name="Form.GAcodigo_filtro" default="#Url.GAcodigo_filtro#">
</cfif>
<cfif isdefined("Url.GAnombre_filtro") and not isdefined("Form.GAnombre_filtro")>
	<cfparam name="Form.GAnombre_filtro" default="#Url.GAnombre_filtro#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.GAcodigo_filtro") and Len(Trim(Form.GAcodigo_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(GAcodigo) like '%" & #UCase(Form.GAcodigo_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "GAcodigo_filtro=" & Form.GAcodigo_filtro>
</cfif>
<cfif isdefined("Form.GAnombre_filtro") and Len(Trim(Form.GAnombre_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(GAnombre) like '%" & #UCase(Form.GAnombre_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "GAnombre_filtro=" & Form.GAnombre_filtro>
</cfif>
<html>
<head>
<title><cfoutput>#LB_Lista_de_Niveles#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMarcas" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloAlterno">
	  <tr>
		<td><font size="3"><strong>#LB_Lista_de_Niveles#</strong></font></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>	  
	</table>
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">	
	<tr>
		<td align="right"><strong>#LB_Descripcion#</strong></td>
		<td> 
			<input name="GAnombre_filtro" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.GAnombre_filtro")>#Form.GAnombre_filtro#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#LB_Filtrar#">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaModelos">
	<cfinvokeargument name="tabla" value="GradoAcademico"/>
	<cfinvokeargument name="columnas" value="GAnombre"/>
	<cfinvokeargument name="desplegar" value="GAnombre"/>
	<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo=#Session.Ecodigo#
	#filtro#  order by GAnombre"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisNivel.cfm"/>
	<cfinvokeargument name="formName" value="listaModelos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="GAnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
</body>
</html>