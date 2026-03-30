<!--- Nombres de los campos para llenar --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>

<cfif isdefined("Url.Usucodigo") and not isdefined("Form.Usucodigo")>
	<cfparam name="Form.Usucodigo" default="#Url.Usucodigo#">
</cfif>

<cfif isdefined("Url.Nombre2") and not isdefined("Form.Nombre2")>
	<cfparam name="Form.Nombre2" default="#Url.Nombre2#">
</cfif>

<cfif isdefined("Url.Cedula") and not isdefined("Form.Cedula")>
	<cfparam name="Form.Cedula" default="#Url.Cedula#">
</cfif>

<!--- Filtros --->
<cfif isdefined("url.Pnombre") and not isdefined("form.Pnombre")>
	<cfset form.Pnombre = url.Pnombre >
</cfif>

<cfif isdefined("url.Pid") and not isdefined("form.Pid")>
	<cfset form.Pid = url.Pid>
</cfif>

<cfif isdefined("url.Papellido1") and not isdefined("form.Papellido1")>
	<cfset form.Papellido1 = url.Papellido1 >
</cfif>

<cfif isdefined("url.Papellido2") and not isdefined("form.Papellido2")>
	<cfset form.Papellido2 = url.Papellido2 >
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(usucodigo,nombre) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.Usucodigo#.value = usucodigo;
		window.opener.document.#form.formulario#.#form.Nombre2#.value = trim(nombre);
		if (window.opener.func#form.Usucodigo#) {window.opener.func#form.Usucodigo#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfset filtro = "">
<cfset descripcion = "Usuarios" >

<cfset navegacion = "&formulario=#form.formulario#&Usucodigo=#form.Usucodigo#&Nombre2=#form.Nombre2#" >
<cfif isdefined("Form.Pnombre") and Len(Trim(Form.Pnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.Pnombre) like '%" & UCase(Form.Pnombre) & "%'">
	<cfset navegacion = navegacion & "&Pnombre=" & Form.Pnombre>
</cfif>

<cfif isdefined("Form.Pid") and Len(Trim(Form.Pid)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.Pid) like '%" & UCase(Form.Pid) & "%'">
	<cfset navegacion = navegacion & "&Pid=" & Form.Pid>
</cfif>

<cfif isdefined("Form.Papellido1") and Len(Trim(Form.Papellido1)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.Papellido1) like '%" & UCase(Form.Papellido1) & "%'">
	<cfset navegacion = navegacion & "&Papellido1=" & Form.Papellido1>
</cfif>

<cfif isdefined("Form.Papellido2") and Len(Trim(Form.Papellido2)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.Papellido2) like '%" & UCase(Form.Papellido2) & "%'">
	<cfset navegacion = navegacion & "&Papellido2=" & Form.Papellido2>
</cfif>


<html>
<head>
<title><cf_translate key="LB_ListaDeUsuariosEmpresariales">Lista de Usuarios Empresariales</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisUsuariosA.cfm" >
		<table width="77%" border="0" cellpadding="2" cellspacing="0" class="tituloListas">
			<tr>
            	<td width="9%" align="right"><strong><cf_translate key="LB_Cedula">Identificaci&oacute;n</cf_translate></strong></td>

                <td width="16%">
					<input name="Pid" type="text" id="desc" size="15" maxlength="80" tabindex="1"
						onClick="this.select();" value="<cfif isdefined("Form.Pid")>#Form.Pid#</cfif>">
				</td>

				<td width="9%" align="right"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>

                <td width="16%">
					<input name="Pnombre" type="text" id="desc" size="15" maxlength="80" tabindex="1"
						onClick="this.select();" value="<cfif isdefined("Form.Pnombre")>#Form.Pnombre#</cfif>">
				</td>

				<td width="7%" align="right"><strong><cf_translate key="LB_Apellidos">Apellidos</cf_translate></strong></td>

                <td width="15%">
					<input name="Papellido1" type="text" id="desc" size="20" maxlength="80" tabindex="1"
						onClick="this.select();" value="<cfif isdefined("Form.Papellido1")>#Form.Papellido1#</cfif>">
				</td>

                <td width="16%">
					<input name="Papellido2" type="text" id="desc" size="20" maxlength="80" tabindex="1"
						onClick="this.select();" value="<cfif isdefined("Form.Papellido2")>#Form.Papellido2#</cfif>">
				</td>

				<td width="37%" align="center">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Filtrar"
						Default="Filtrar"
						XmlFile="/sif/generales.xml"
						returnvariable="BTN_Filtrar"/>

					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
						<input type="hidden" name="Usucodigo" value="#form.Usucodigo#">
					</cfif>
					<cfif isdefined("form.Nombre2") and len(trim(form.Nombre2))>
						<input type="hidden" name="Nombre2" value="#form.Nombre2#">
					</cfif>
                    <cfif isdefined("form.Cedula") and len(trim(form.Cedula))>
						<input type="hidden" name="Cedula" value="#form.Cedula#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>

	<tr><td>
		<cfset select = " distinct a.Usucodigo,
						  b.Pnombre,
						  b.Pid,
						  b.Papellido1,
						  b.Papellido2,
						  {fn concat({fn concat({fn concat({fn concat(
						  b.Pnombre , ' ' )}, b.Papellido1 )},  ' '  )},  b.Papellido2 )} as Nombre " >
		<cfset from = " Usuario a
						inner join DatosPersonales b
						on a.datos_personales = b.datos_personales
						 #filtro#
						inner join vUsuarioProcesos c
						on a.Usucodigo = c.Usucodigo
   						   and c.Ecodigo = #session.EcodigoSDC# " >
		<cfset where = " a.CEcodigo = #session.CEcodigo#
   					 and a.Uestado = 1
   					 and a.Utemporal = 0 " >

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Nombre"
			Default="Nombre"
			returnvariable="LB_Nombre"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Cedula"
			Default="Cedula"
			returnvariable="LB_Cedula"/>

        <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
        	returnvariable="pListaRet">
            <cfinvokeargument name="tabla" value="#from#"/>
            <cfinvokeargument name="columnas" value="#select#"/>
            <cfinvokeargument name="desplegar" value="Pid, Nombre"/>
            <cfinvokeargument name="etiquetas" value="Identificación, Nombre"/>
            <cfinvokeargument name="formatos" value="S,S"/>
            <cfinvokeargument name="filtro" value="#where#"/>
            <cfinvokeargument name="align" value="left, left"/>
            <cfinvokeargument name="ajustar" value="N"/>
            <cfinvokeargument name="checkboxes" value="N"/>
            <cfinvokeargument name="irA" value="ConlisUsuariosE.cfm"/>
            <cfinvokeargument name="fparams" value="Usucodigo,Nombre"/>
            <cfinvokeargument name="navegacion" value="#navegacion#"/>
            <cfinvokeargument name="debug" value="N"/>
            <cfinvokeargument name="mostrar_filtro" value="false"/>
            <cfinvokeargument name="filtrar_automatico" value="true"/>
            <cfinvokeargument name="maxRows" value="15"/>
            <cfinvokeargument name="incluyeForm" value="true"/>
            <cfinvokeargument name="formName" value="listaUsuarios"/>
            <cfinvokeargument name="conexion" value="asp"/>
            <cfinvokeargument name="funcion" value="Asignar"/>
        </cfinvoke>

	</td></tr>
</table>

</body>
</html>