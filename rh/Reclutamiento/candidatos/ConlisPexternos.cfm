<!--- Recibe conexion, form, name y desc --->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Lista_de_Puestos_Externos"
Default="Lista de Puestos Externos"
returnvariable="LB_Lista_de_Puestos_Externos"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
returnvariable="LB_Descripcion"/> 


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



<cfif isdefined("Url.RHOPDescripcion_filtro") and not isdefined("Form.RHOPDescripcion_filtro")>
	<cfparam name="Form.RHOPDescripcion_filtro" default="#Url.RHOPDescripcion_filtro#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHOPDescripcion_filtro") and Len(Trim(Form.RHOPDescripcion_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHOPDescripcion) like '%" & #UCase(Form.RHOPDescripcion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOPDescripcion_filtro=" & Form.RHOPDescripcion_filtro>
</cfif>
<html>
<head>
<title><cfoutput>#LB_Lista_de_Puestos_Externos#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMarcas" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloAlterno">
	  <tr>
		<td><font size="3"><strong>#LB_Lista_de_Puestos_Externos#</strong></font></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>	  
	</table>
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">	
	<tr>
		<td align="right"><strong>#LB_Descripcion#</strong></td>
		<td> 
			<input name="RHOPDescripcion_filtro" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.RHOPDescripcion_filtro")>#Form.RHOPDescripcion_filtro#</cfif>">
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
 returnvariable="pListaModelos">
	<cfinvokeargument name="tabla" value="RHOPuesto"/>
	<cfinvokeargument name="columnas" value="RHOPDescripcion"/>
	<cfinvokeargument name="desplegar" value="RHOPDescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="CEcodigo =#Session.CEcodigo#
	#filtro#  order by RHOPDescripcion"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisNivel.cfm"/>
	<cfinvokeargument name="formName" value="listaModelos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHOPDescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
</body>
</html>