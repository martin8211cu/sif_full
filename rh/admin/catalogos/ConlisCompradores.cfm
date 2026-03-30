<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.CMCid") and not isdefined("Form.CMCid")>
	<cfparam name="Form.CMCid" default="#Url.CMCid#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>

<!--- Filtros --->
<cfif isdefined("url.CMCnombre") and not isdefined("form.CMCnombre")>
	<cfset form.CMCnombre = url.CMCnombre >
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(CMCid,nombre) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.CMCid#.value = CMCid;
		window.opener.document.#form.formulario#.#form.desc#.value = trim(nombre);
		if (window.opener.func#form.CMCid#) {window.opener.func#form.CMCid#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfset filtro = "">
<cfset navegacion = "&formulario=#form.formulario#&CMCid=#form.CMCid#&desc=#form.desc#" >
<cfif isdefined("Form.CMCnombre") and Len(Trim(Form.CMCnombre)) neq 0>
 	<cfset filtro = filtro & " and upper(CMCnombre) like '%" & ucase(Form.CMCnombre) & "%'">
	<cfset navegacion = navegacion & "&CMCnombre=" & Form.CMCnombre>
</cfif>

<html>
<head>
<title><cf_translate key="LB_ListaDeCompradores">Lista de Compradores</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroComprador" method="post" action="ConlisCompradores.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="tituloListas">
			<tr>
				<td width="1%" align="right"><strong><cf_translate key="LB_Compradores">Comprador</cf_translate></strong></td>
				<td> 
					<input name="CMCnombre" type="text" id="desc" size="25" maxlength="80" tabindex="1"
						onClick="this.select();" value="<cfif isdefined("Form.CMCnombre")>#Form.CMCnombre#</cfif>">
				</td>

				<td align="center">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Filtrar"
						Default="Filtrar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Filtrar"/>

					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#" tabindex="1">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.CMCid") and len(trim(form.CMCid))>
						<input type="hidden" name="CMCid" value="#form.CMCid#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfset select = " a.CMCid, 
						  a.CMCnombre " >
		<cfset from = " CMCompradores a " >
		<cfset where = " a.Ecodigo=#session.Ecodigo# " >
		<cfset where = where & filtro >
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Comprador"
			Default="Comprador"
			returnvariable="LB_Comprador"/>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="#from#"/>
			<cfinvokeargument name="columnas" value="#select#"/>
			<cfinvokeargument name="desplegar" value="CMCnombre"/>
			<cfinvokeargument name="etiquetas" value="#LB_Comprador#"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="#where#"/>
			<cfinvokeargument name="align" value="left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisCompradores.cfm"/>
			<cfinvokeargument name="formName" value="listaCompradores"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="CMCid,CMCnombre"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>