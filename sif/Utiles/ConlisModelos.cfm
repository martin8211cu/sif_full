<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(key, name,desc) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.keyMod#.value = key;
			window.opener.document.#Url.form#.#Url.nameMod#.value = name;		
			window.opener.document.#Url.form#.#Url.descMod#.value = desc;
			if (window.opener.#Url.funcionMod#){<!---Se agrega para llamar a funcionMod en Cambio de Valores a Activo Fijo RVD 04/06/2014 --->
					window.opener.#Url.funcionMod#(#Url.Aid#,key);<!---Se agrega para llamar a funcionMod en Cambio de Valores a Activo Fijo RVD 04/06/2014 --->
				}
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.AFMMcodigo_filtro") and not isdefined("Form.AFMMcodigo_filtro")>
	<cfparam name="Form.AFMMcodigo_filtro" default="#Url.AFMMcodigo_filtro#">
</cfif>
<cfif isdefined("Url.AFMMdescripcion_filtro") and not isdefined("Form.AFMMdescripcion_filtro")>
	<cfparam name="Form.AFMMdescripcion_filtro" default="#Url.AFMMdescripcion_filtro#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.AFMMcodigo_filtro") and Len(Trim(Form.AFMMcodigo_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(AFMMcodigo) like '%" & #UCase(Form.AFMMcodigo_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AFMMcodigo_filtro=" & Form.AFMMcodigo_filtro>
</cfif>
<cfif isdefined("Form.AFMMdescripcion_filtro") and Len(Trim(Form.AFMMdescripcion_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(AFMMdescripcion) like '%" & #UCase(Form.AFMMdescripcion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AFMMdescripcion_filtro=" & Form.AFMMdescripcion_filtro>
</cfif>
<html>
<head>
<title>Lista de Modelos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMarcas" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloAlterno">
	  <tr>
		<td><font size="3"><strong>Modelos de la Marca</strong></font></td>
	  </tr>
	  <tr>
		<td><font size="3"><strong>#Url.marca#</strong></font></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>	  
	</table>

<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">	
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="AFMMcodigo_filtro" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.AFMMcodigo_filtro")>#Form.AFMMcodigo_filtro#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="AFMMdescripcion_filtro" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.AFMMdescripcion_filtro")>#Form.AFMMdescripcion_filtro#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaModelos">
	<cfinvokeargument name="tabla" value="AFMModelos"/>
	<cfinvokeargument name="columnas" value="AFMMid, AFMMcodigo,AFMMdescripcion"/>
	<cfinvokeargument name="desplegar" value="AFMMcodigo, AFMMdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo=#Session.Ecodigo#
		and AFMid=#url.codMarca#
				#filtro# 
			order by AFMMdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisModelos.cfm"/>
	<cfinvokeargument name="formName" value="listaModelos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="AFMMid, AFMMcodigo, AFMMdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>