<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfinclude template="../Utiles/sifConcat.cfm">
<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc,limite, utilizado) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		
		if ( window.opener.document.form1.credito_limite ){
			window.opener.document.form1.credito_limite.value = limite;
			if ( window.opener.fm ){
				window.opener.fm(window.opener.document.form1.credito_limite,2)
			}
		}
		
		if ( window.opener.document.form1.credito_utilizado ){
			window.opener.document.form1.credito_utilizado.value = utilizado;
			if ( window.opener.fm ){
				window.opener.fm(window.opener.document.form1.credito_utilizado,2)
			}
		}
		
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.CDidentificacion") and not isdefined("Form.CDidentificacion")>
	<cfparam name="Form.CDidentificacion" default="#Url.CDidentificacion#">
</cfif>
<cfif isdefined("Url.CDnombre") and not isdefined("Form.CDnombre")>
	<cfparam name="Form.CDnombre" default="#Url.CDnombre#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >
<cfif isdefined("Form.CDidentificacion") and Len(Trim(Form.CDidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(CDidentificacion) like '%" & UCase(Form.CDidentificacion) & "%'">
	<cfset navegacion = navegacion & "&CDidentificacion=" & Form.CDidentificacion>
</cfif>
<cfif isdefined("Form.CDnombre") and Len(Trim(Form.CDnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CDnombre) like '%" & UCase(Form.CDnombre) & "%'">
	<cfset navegacion = navegacion & "&CDnombre=" & Form.CDnombre>
</cfif>

<html>
<head>
<title>Lista de Clientes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisClienteDetallista.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>N&uacute;mero</strong></td>
				<td> 
					<input name="CDidentificacion" type="text" id="codigo" size="10" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.CDidentificacion")>#Form.CDidentificacion#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="CDnombre" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.CDnombre")>#Form.CDnombre#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.codigo") and len(trim(form.codigo))>
						<input type="hidden" name="codigo" value="#form.codigo#">
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
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="ClienteDetallista"/>
			<cfinvokeargument name="columnas" value="CDid,CDidentificacion,CDnombre#_Cat#' '#_Cat#CDapellido1#_Cat#' '#_Cat#CDapellido2 as CDnombre, coalesce(CDlimitecredito,0) as CDlimitecredito, coalesce(CDcreditoutilizado,0) as CDcreditoutilizado"/>
			<cfinvokeargument name="desplegar" value="CDidentificacion, CDnombre"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# #filtro# order by CDidentificacion"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisClienteDetallista.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="CDid, CDidentificacion, CDnombre,CDlimitecredito, CDcreditoutilizado"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>