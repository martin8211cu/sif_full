<cfif isdefined("url.catalogo") and not isdefined("form.catalogo")>
	<cfset form.catalogo = url.catalogo>
</cfif>
<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario = url.formulario>
</cfif>
<cfif isdefined("url.usu") and not isdefined("form.usu")>
	<cfset form.usu = url.usu>
</cfif>
<cfif isdefined("url.nombre") and not isdefined("form.nombre")>
	<cfset form.nombre = url.nombre>
</cfif>

<html>
<head>
<title>
	<cfif isDefined("form.catalogo")>
		Lista de <cfif form.catalogo EQ 'S'>Solicitantes<cfelseif form.catalogo EQ 'C'>Compradores</cfif>
	</cfif>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfquery name="rs" datasource="#Session.DSN#">
	<cfif form.catalogo eq 'S'>
		select Usucodigo from CMSolicitantes where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfelseif form.catalogo eq 'C'>	
		select Usucodigo from CMCompradores where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfif>	
</cfquery>

<cfset usucodigos = "">
<cfoutput query="rs" >
	<cfset usucodigos = usucodigos & "#rs.Usucodigo#" & ",">
</cfoutput>

<cfif len(trim(usucodigos)) gt 0 >
	<cfset usucodigos = Mid(usucodigos, 1, Len(usucodigos)-1)>
</cfif>	

<cfset filtro = "">
<cfif len(trim(usucodigos)) gt 0 >
	<cfset filtro = " and a.Usucodigo not in (#usucodigos#) ">
</cfif>	
<cfif isdefined("Form.Filtrar") and len(trim(form.Pid)) >
	<cfset filtro = filtro & " and upper(Pid) like '%#Ucase(Form.Pid)#%' ">
</cfif>
<cfif isdefined("Form.Filtrar") and len(trim(Form.Pnombre))>
  <cfset filtro = filtro & " and upper(Pnombre) like '%#Ucase(Form.Pnombre)#%' ">
</cfif>	  
<cfif isdefined("Form.Filtrar") and len(trim(Form.Papellido1))>
	<cfset filtro = " and upper(Papellido1) like '%#Ucase(Form.Papellido1)#%' " >
</cfif>
<cfif isdefined("Form.Filtrar") and len(trim(Form.Papellido2))>
	<cfset filtro = " and upper(Papellido2) like '%#Ucase(Form.Papellido2)#%' " >
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfset select = " distinct a.Usucodigo, a.Usulogin, 
						   d.Papellido1 #_Cat# ' ' #_Cat# d.Papellido2 #_Cat# ' ' #_Cat# d.Pnombre as pNombre, d.Pid, 
						   d.Pemail1, d.Pfax, d.Poficina ">
<cfset from = " Usuario a, UsuarioProceso b, DatosPersonales d " >							   
<cfset where = " a.CEcodigo = #Session.CEcodigo# 
			 and a.Uestado = 1
			 and a.Utemporal = 0
			 and a.Usucodigo = b.Usucodigo
			 and b.Ecodigo = #session.EcodigoSDC# 
			 and b.SScodigo = 'SIF'
			 and a.datos_personales = d.datos_personales " >
<cfset where = where & filtro>

<script language="JavaScript1.2">
	function Asignar(valor1, valor2, valor3, valor4, valor5) {
		window.opener.document.<cfoutput>#form.formulario#.#form.usu#</cfoutput>.value = valor1;
		window.opener.document.<cfoutput>#form.formulario#.#form.nombre#</cfoutput>.value = valor2;
		// si es el catálogo de solicitantes
		if ('<cfoutput>#form.catalogo#</cfoutput>' == 'S') { 
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMSemail.value = valor3;
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMStelefono.value = valor4;
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMSfax.value = valor5;
		}
		// si es el catálogo de compradores	
		if ('<cfoutput>#form.catalogo#</cfoutput>' == 'C') { 
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMCemail.value = valor3;
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMCtelefono.value = valor4;
			window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMCfax.value = valor5;
		}
		window.close();
	}
</script>

<body>
	<table border="0" cellspacing="0" align="center">
		<tr>
			<td>
				<cfoutput>
				<form style="margin:0;" action="ConlisSolicitantesUsuarios.cfm" method="post" name="conlis">
					<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
						<tr class="areaFiltro">
							<td align="right"><strong>Apellidos&nbsp;</strong></td>
							<td><input name="Papellido1" type="text" size="15" maxlength="100"></td>
							<td><input name="Papellido2" type="text" size="15" maxlength="100"></td>
							<td align="right"><strong>Nombre&nbsp;</strong></td>
							<td><input name="Pnombre" type="text" size="15" maxlength="60"></td>
							<td align="right"><strong>Identificaci&oacute;n&nbsp;</strong></td>
							<td><input type="text" name="Pid" size="15"></td>
							<td>
								<input type="submit" name="Filtrar" value="Filtrar">
								<input type="hidden" name="catalogo" value="<cfif isdefined("form.catalogo")>#form.catalogo#</cfif>">
								<input type="hidden" name="formulario" value="<cfif isdefined("form.formulario")>#form.formulario#</cfif>">
								<input type="hidden" name="usu" value="<cfif isdefined("form.usu")>#form.usu#</cfif>">
								<input type="hidden" name="nombre" value="<cfif isdefined("form.nombre")>#form.nombre#</cfif>">
							</td>
						</tr>
					</table>
				</form>
				</cfoutput>
			</td>
		</tr>
		
		<tr>
			<td>
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="#from#"/>
					<cfinvokeargument name="columnas" value="#select#"/>
					<cfinvokeargument name="desplegar" value="pNombre, Pid"/>
					<cfinvokeargument name="etiquetas" value="Nombre, Identificación"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="#where# order by pNombre"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value=""/>
					<cfinvokeargument name="irA" value="ConlisSolicitantesUsuarios.cfm"/>
					<cfinvokeargument name="formName" value="conlis"/>
					<cfinvokeargument name="MaxRows" value="1"/>
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="fparams" value="Usucodigo, pNombre, Pemail1, Poficina, Pfax"/>
					<!---<cfinvokeargument name="navegacion" value="#navegacion#"/>--->
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="conexion" value="asp"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
				</cfinvoke>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</body>
</html>