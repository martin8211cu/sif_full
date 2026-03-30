<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.Usucodigo") and not isdefined("Form.Usucodigo")>
	<cfparam name="Form.Usucodigo" default="#Url.Usucodigo#">
</cfif>
<cfif isdefined("Url.Nombre") and not isdefined("Form.Nombre")>
	<cfparam name="Form.Nombre" default="#Url.Nombre#">
</cfif>
<cfif isdefined("Url.Pid") and not isdefined("Form.Pid")>
	<cfparam name="Form.Pid" default="#Url.Pid#">
</cfif>

<!--- Filtros --->
<cfif isdefined("url.Pnombre") and not isdefined("form.Pnombre")>
	<cfset form.Pnombre = url.Pnombre >
</cfif>
<cfif isdefined("url.Papellido1") and not isdefined("form.Papellido1")>
	<cfset form.Papellido1 = url.Papellido1 >
</cfif>
<cfif isdefined("url.Papellido2") and not isdefined("form.Papellido2")>
	<cfset form.Papellido2 = url.Papellido2 >
</cfif>


<script language="JavaScript" type="text/javascript">
function trim(dato) {
	alert(dato);
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(deid,usucodigo) {//,nombre,Pid

	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.DEid#.value = deid;
		window.opener.document.#form.formulario#.#form.Usucodigo#.value = usucodigo;
		/*window.opener.document.#form.formulario#.#form.Pid#.value = trim(Pid);
		window.opener.document.#form.formulario#.#form.Nombre#.value = trim(nombre);
		if (window.opener.func#form.deid#) {window.opener.func#form.deid#()}*/
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfset filtro = "">
<cfset descripcion = "Empleados" >
<cfset navegacion = "&formulario=#form.formulario#&DEid=#form.DEid#&Usucodigo=#form.Usucodigo#&Nombre=#form.Nombre#" >
<cfif isdefined("Form.DEnombre") and Len(Trim(Form.DEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Pnombre) like '%" & UCase(Form.DEnombre) & "%'">
	<cfset navegacion = navegacion & "&DEnombre=" & Form.DEnombre>
</cfif>

<cfif isdefined("Form.Pnombre") and Len(Trim(Form.Pnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Pnombre) like '%" & UCase(Form.Pnombre) & "%'">
	<cfset navegacion = navegacion & "&Pnombre=" & Form.Pnombre>
</cfif>

<cfif isdefined("Form.Papellido1") and Len(Trim(Form.Papellido1)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Papellido1) like '%" & UCase(Form.Papellido1) & "%'">
	<cfset navegacion = navegacion & "&Papellido1=" & Form.Papellido1>
</cfif>

<cfif isdefined("Form.Papellido2") and Len(Trim(Form.Papellido2)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Papellido2) like '%" & UCase(Form.Papellido2) & "%'">
	<cfset navegacion = navegacion & "&Papellido2=" & Form.Papellido2>
</cfif>

<html>
<head>
<title>Lista de Empleados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisEmpleados.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Nombre</strong></td>
				<td> 
					<input name="Pnombre" type="text" id="desc" size="25" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.Pnombre")>#Form.Pnombre#</cfif>">
				</td>

				<td align="right"><strong>Apellidos</strong></td>
				<td width="1%"> 
					<input name="Papellido1" type="text" id="desc" size="25" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.Papellido1")>#Form.Papellido1#</cfif>">
				</td>

				<td> 
					<input name="Papellido2" type="text" id="desc" size="25" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.Papellido2")>#Form.Papellido2#</cfif>">
				</td>

				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.DEid") and len(trim(form.DEid))>
						<input type="hidden" name="DEid" value="#form.DEid#">
					</cfif>
					<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
						<input type="hidden" name="Usucodigo" value="#form.Usucodigo#">
					</cfif>
					<cfif isdefined("form.Nombre") and len(trim(form.Nombre))>
						<input type="hidden" name="Nombre" value="#form.Nombre#">
					</cfif>
					<cfif isdefined("form.Pid") and len(trim(form.Pid))>
						<input type="hidden" name="Pid" value="#form.Pid#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
	<cfset asp=#session.dsn#>
		<cfset select = " a.GEAid,a.GEAdescripcion " >
		<cfset from = " GEanticipo a
						 " >
		<cfset where = "  a.Ecodigo=#session.Ecodigo# " >

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pLista"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="#from#"/>
			<cfinvokeargument name="columnas" value="#select#"/>
			<cfinvokeargument name="desplegar" value="GEAid, GEAdescripcion"/>
			<cfinvokeargument name="etiquetas" value="Identificacion, Nombre"/>
			<cfinvokeargument name="formatos" value="S, S"/>
			<cfinvokeargument name="filtro" value="#where#"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisEmpleados.cfm"/>
			<cfinvokeargument name="formName" value="listaEmpleados"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="GEAid,GEAdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="conexion" value="#asp#"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>

