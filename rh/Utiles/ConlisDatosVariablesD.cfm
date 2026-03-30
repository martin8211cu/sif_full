<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.RHEDVid2") and not isdefined("Form.RHEDVid2")>
	<cfparam name="Form.RHEDVid2" default="#Url.RHEDVid2#">
</cfif>
<cfif isdefined("Url.RHDDVcodigo") and not isdefined("Form.RHDDVcodigo")>
	<cfparam name="Form.RHDDVcodigo" default="#Url.RHDDVcodigo#">
</cfif>
<cfif isdefined("Url.RHDDVdescripcion") and not isdefined("Form.RHDDVdescripcion")>
	<cfparam name="Form.RHDDVdescripcion" default="#Url.RHDDVdescripcion#">
</cfif>
<cfif isdefined("Url.RHDDVlinea") and not isdefined("Form.RHDDVlinea")>
	<cfparam name="Form.RHDDVlinea" default="#Url.RHDDVlinea#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(RHEDVid, RHDDVcodigo, RHDDVdescripcion, RHDDVlinea) {
	var DescFormateada;
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.RHEDVid2#.value = RHEDVid;
		window.opener.document.#form.formulario#.#form.RHDDVcodigo#.value = trim(RHDDVcodigo);
		window.opener.document.#form.formulario#.#form.RHDDVdescripcion#.value = RHDDVdescripcion;
		window.opener.document.#form.formulario#.#form.RHDDVlinea#.value = RHDDVlinea;
		if (window.opener.func#form.RHDDVcodigo#) {
			window.opener.func#form.RHDDVcodigo#()
		}
		// Invocar una funcion de recuperacion de datos si la funcion existe 
		if (window.opener.recuperar && window.opener.document.form1) {
			window.opener.recuperar(window.opener.document.form1);
		}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.descripcion") and not isdefined("Form.descripcion")>
	<cfparam name="Form.descripcion" default="#Url.descripcion#">
</cfif>

<cfset filtro = "">
<cfset desc = "Datos Variables" >

<cfset navegacion = "&formulario=#form.formulario#&RHDDVcodigo=#form.RHDDVcodigo#&RHDDVdescripcion=#form.RHDDVcodigo#&RHEDVid2=#form.RHEDVid2#">
<cfif isdefined("Form.codigo") and Len(Trim(Form.codigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHDDVcodigo) like '%" & UCase(Form.codigo) & "%'">
	<cfset navegacion = navegacion & "&codigo=" & Form.codigo>
</cfif>
<cfif isdefined("Form.descripcion") and Len(Trim(Form.descripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHDDVdescripcion) like '%" & UCase(Form.descripcion) & "%'">
	<cfset navegacion = navegacion & "&descripcion=" & Form.descripcion>
</cfif>
<cfif isdefined("url.Vid") and not isdefined ("form.Vid")>
	<cfset filtro = filtro & " and RHEDVid =" & url.Vid>
</cfif>
<html>
<head>
<title><cf_translate  key="LB_ListaDeDatosVariables">Lista de Datos Variables</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

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
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>


<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisDatosVariablesD.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>#LB_CODIGO#</strong></td>
				<td> 
					<input name="codigo" type="text" id="codigo" size="10" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.codigo")>#Form.codigo#</cfif>">
				</td>
				<td align="right"><strong>#LB_DESCRIPCION#</strong></td>
				<td> 
					<input name="descripcion" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.descripcion")>#Form.descripcion#</cfif>">					
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.RHEDVid2") and len(trim(form.RHEDVid2))>
						<input type="hidden" name="RHEDVid2" value="#form.RHEDVid2#">
					</cfif>
					<cfif isdefined("form.RHDDVcodigo") and len(trim(form.RHDDVcodigo))>
						<input type="hidden" name="RHDDVcodigo" value="#form.RHDDVcodigo#">
					</cfif>
					<cfif isdefined("form.RHDDVdescripcion") and len(trim(form.RHDDVdescripcion))>
						<input type="hidden" name="RHDDVdescripcion" value="#form.RHDDVdescripcion#">
					</cfif>
					<cfif isdefined("form.RHDDVlinea") and len(trim(form.RHDDVlinea))>
						<input type="hidden" name="RHDDVlinea" value="#form.RHDDVlinea#">
					</cfif>
					<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and len(trim(form.tipo))>#form.tipo#</cfif>">
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">		
			select RHEDVid, RHDDVcodigo, RHDDVdescripcion, RHDDVlinea
			from RHDDatosVariables
			where  Ecodigo= <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer">			
			<cfif isdefined("filtro") and len(trim(filtro))>
				#preservesinglequotes(filtro)#
			</cfif>
			order by RHDDVcodigo			
		</cfquery>
																
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="RHDDVcodigo, RHDDVdescripcion"/>
	        <cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisDatosVariablesD.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="RHEDVid, RHDDVcodigo, RHDDVdescripcion, RHDDVlinea"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>