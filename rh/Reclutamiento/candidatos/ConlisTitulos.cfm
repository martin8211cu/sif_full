<!--- Recibe conexion, form, name y desc --->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Lista_de_Titulos"
Default="Lista de Titulos"
returnvariable="LB_Lista_de_Titulos"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
returnvariable="LB_Descripcion"/> 


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Filtrar"
Default="Filtrar"
xmlFile="/rh/generales.xml"
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
<cfif isdefined("Url.RHOTDescripcion_filtro") and not isdefined("Form.RHOTDescripcion_filtro")>
	<cfparam name="Form.RHOTDescripcion_filtro" default="#Url.RHOTDescripcion_filtro#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.GAcodigo_filtro") and Len(Trim(Form.GAcodigo_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(GAcodigo) like '%" & #UCase(Form.GAcodigo_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "GAcodigo_filtro=" & Form.GAcodigo_filtro>
</cfif>
<cfif isdefined("Form.RHOTDescripcion_filtro") and Len(Trim(Form.RHOTDescripcion_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and (upper(RHOTDescripcion) like '%" & #UCase(Form.RHOTDescripcion_filtro)# & "%' or upper(RHEOtrotitulo) like '%" & #UCase(Form.RHOTDescripcion_filtro)# & "%') ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOTDescripcion_filtro=" & Form.RHOTDescripcion_filtro>
</cfif>
<html>
<head>
<title><cfoutput>#LB_Lista_de_Titulos#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMarcas" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloAlterno">
	  <tr>
		<td><font size="3"><strong>#LB_Lista_de_Titulos#</strong></font></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>	  
	</table>
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">	
	<tr>
		<td align="right"><strong>#LB_Descripcion#</strong></td>
		<td> 
			<input name="RHOTDescripcion_filtro" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.RHOTDescripcion_filtro")>#Form.RHOTDescripcion_filtro#</cfif>">
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
	<cfinvokeargument name="tabla" value="RHEducacionEmpleado a 
										left outer join RHOTitulo b
										on a.RHOTid  =  b.RHOTid  
										and CEcodigo = #Session.CEcodigo# "/>
	<cfinvokeargument name="columnas" value="distinct coalesce(b.RHOTDescripcion,coalesce(a.RHEOtrotitulo,'')) as RHOTDescripcion"/>
	<cfinvokeargument name="desplegar" value="RHOTDescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="len(ltrim(coalesce(b.RHOTDescripcion,coalesce(a.RHEOtrotitulo,'')))) <> 0 #filtro#  order by RHOTDescripcion"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisNivel.cfm"/>
	<cfinvokeargument name="formName" value="listaModelos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHOTDescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
</body>
</html>