<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfset index = "">
<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
</cfif>



<script language="JavaScript" type="text/javascript">
	function Asignar(codigo,desc) {	
		if (window.opener != null) {
			<cfoutput>
			window.opener.document.#form.formulario#.Tcodigo<cfoutput>#index#</cfoutput>.value = trim(codigo);
			window.opener.document.#form.formulario#.Tdescripcion<cfoutput>#index#</cfoutput>.value = desc;
			</cfoutput>
			window.close();
		}
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
</script>

<!--- Filtro --->
<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")>
	<cfparam name="Form.Tcodigo" default="#Url.Tcodigo#">
</cfif>
<cfif isdefined("Url.Tdescripcion") and not isdefined("Form.Tdescripcion")>
	<cfparam name="Form.Tdescripcion" default="#Url.Tdescripcion#">
</cfif>

<cfset filtro = "">

<cfset navegacion = "&formulario=#form.formulario#&index=#index#" >
<cfif isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(Tcodigo) like '%" & UCase(Form.Tcodigo) & "%'">
	<cfset navegacion = navegacion & "&Tcodigo=" & Form.Tcodigo>
</cfif>
<cfif isdefined("Form.Tdescripcion") and Len(Trim(Form.Tdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Tdescripcion) like '%" & UCase(Form.Tdescripcion) & "%'">
	<cfset navegacion = navegacion & "&Tdescripcion=" & Form.Tdescripcion>
</cfif>

<html>
<head>
<title>Lista de Tipos de Nómina</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisTiposNomina.cfm" >
		<cfif Len(Trim(index))>
			<input type="hidden" name="idx" value="#index#">
		</cfif>
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="Tcodigo" type="text" id="codigo" size="5" maxlength="5" onClick="this.select();" value="<cfif isdefined("Form.Tcodigo")>#Form.Tcodigo#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="Tdescripcion" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.Tdescripcion")>#Form.Tdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
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
		<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
			select Tcodigo, Tdescripcion
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif isdefined("filtro") and len(trim(filtro))>
				#preservesinglequotes(filtro)#
			</cfif>
			order by Tcodigo
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsTiposNomina#"/>
			<cfinvokeargument name="desplegar" value="Tcodigo, Tdescripcion"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisTiposNomina.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Tcodigo, Tdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>