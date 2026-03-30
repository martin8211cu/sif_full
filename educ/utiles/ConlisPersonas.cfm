<html>
<head>
<title>Lista de Personas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

	<cfif isdefined("Url.f") and not isdefined("Form.f")>
		<cfparam name="Form.f" default="#Url.f#">
	</cfif>
	<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
		<cfparam name="Form.p1" default="#Url.p1#">
	</cfif>
	<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
		<cfparam name="Form.p2" default="#Url.p2#">
	</cfif>


	<cfif isdefined("Url.FPid") and not isdefined("Form.FPid")>
		<cfparam name="Form.FPid" default="#Url.FPid#">
	</cfif>
	<cfif isdefined("Url.FNombre") and not isdefined("Form.FNombre")>
		<cfparam name="Form.FNombre" default="#Url.FNombre#">
	</cfif>
	<cfif isdefined("Url.FPapellido1") and not isdefined("Form.FPapellido1")>
		<cfparam name="Form.FPapellido1" default="#Url.FPapellido1#">
	</cfif>
	<cfif isdefined("Url.FPapellido2") and not isdefined("Form.FPapellido2")>
		<cfparam name="Form.FPapellido2" default="#Url.FPapellido2#">
	</cfif>
		
	
	<cfset filtro = "">
	<cfset additionalCols = "">
	<cfset navegacion = "">
	
	<cfif isdefined("Form.FPid") and Len(Trim(Form.FPid)) NEQ 0>
		<cfset filtro = filtro &  " and upper(Pid) like upper('%#Form.FPid#%')" >
		<cfset additionalCols = additionalCols & "'#Form.FPid#' as FPid, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPid=" & Form.FPid>
	</cfif>	
	<cfif isdefined("Form.FNombre") and Len(Trim(Form.FNombre)) NEQ 0>
		<cfset filtro = filtro &  " and upper(Pnombre) like upper('%#Form.FNombre#%')" >
		<cfset additionalCols = additionalCols & "'#Form.FNombre#' as FNombre, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FNombre=" & Form.FNombre>
	</cfif>	
	<cfif isdefined("Form.FPapellido1") and len(trim(Form.FPapellido1)) NEQ 0>
		<cfset filtro = filtro &  " and upper(Papellido1) like upper('%#Form.FPapellido1#%')" >
		<cfset additionalCols = additionalCols & "'#Form.FPapellido1#' as FPapellido1, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPapellido1=" & Form.FPapellido1>
	</cfif>	
	<cfif isdefined("Form.FPapellido2") and len(trim(Form.FPapellido2)) NEQ 0>
		<cfset filtro = filtro &  " and upper(Papellido2) like upper('%#Form.FPapellido2#%')" >
		<cfset additionalCols = additionalCols & "'#Form.FPapellido2#' as FPapellido2, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPapellido2=" & Form.FPapellido2>
	</cfif>	
	
	<cfoutput>
	
		<script language="javascript" type="text/javascript">
			function Asignar(persona, nombre) {
				if (window.opener != null) {
					<cfoutput>
					window.opener.document.#Form.f#.#Form.p1#.value = persona;
					window.opener.document.#Form.f#.#Form.p2#.value = nombre;
					</cfoutput>
					window.opener.CargaPersona(persona);
					window.close();
				}
			}
		</script>
	
		<table width="100%"  border="0" cellspacing="0" cellpadding="3">
		  <tr>
			<td>
			<form style="margin:0; " name="filtroUsuarios" method="post" action="#GetFileFromPath(GetTemplatePath())#">
				<input type="hidden" name="f" value="#Form.f#">
				<input type="hidden" name="p1" value="#Form.p1#">
				<input type="hidden" name="p2" value="#Form.p2#">
			  <table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
				  <td align="left" nowrap  class="label"><span class="label">Identificaci&oacute;n</span></td>
				  <td align="left" nowrap class="label">Nombre</td>
				  <td align="left" nowrap class="label">Apellidos</td>
				  <td nowrap>&nbsp;</td>
				</tr>
				<tr>
					<td align="left" style="padding-right: 5px;" nowrap>
						<input name="fPid" type="text" id="fPid" size="15" maxlength="60" value="<cfif isdefined("Form.fPid")>#Form.fPid#</cfif>" style="width: 100%;">
					</td>
					<td align="left" style="padding-right: 5px;" nowrap>
						<input name="fNombre" type="text" id="fNnombre" size="15" maxlength="60" value="<cfif isdefined("Form.fNombre")>#Form.fNombre#</cfif>" style="width: 100%;">
					</td>
					<td align="left" style="padding-right: 5px;" nowrap>
						<input name="fPapellido1" type="text" id="fPapellido1" size="15" maxlength="60" value="<cfif isdefined("Form.fPapellido1")>#Form.fPapellido1#</cfif>">
						<input name="fPapellido2" type="text" id="fPapellido2" size="15" maxlength="60" value="<cfif isdefined("Form.fPapellido2")>#Form.fPapellido2#</cfif>">
					</td>
					<td width="20%" align="center" nowrap>
					  <input class="label" name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
					  <input class="label" name="btnLimpiar" type="button" id="btnBuscar" value="Limpiar" onClick="limpiar();">
					</td>
				</tr>
			  </table>
			</form>
			</td>
		  </tr>
		  <tr>
			<td>
			  <!--- Lista de Personas asociadas a esta empresa --->
			  <!--- 
			  OJO faltan los usuarios incluidos directamente en el framework:
				select *
				  from asp..Usuario u, 
					asp..DatosPersonales dp, 
					asp..Direcciones dir,
					asp..Empresa e,
					Empresas es
				 where	es.Ecodigo = e.Ereferencia
				   and  u.CEcodigo = e.CEcodigo
				   and	not exists (Select * from asp..UsuarioReferencia ur
								 where ur.Ecodigo = e.Ecodigo
								   and ur.Usucodigo = u.Usucodigo
								   and ur.STabla = 'PersonaEducativo'
						)
				
				   and u.datos_personales = dp.datos_personales
				   and u.id_direccion = dir.id_direccion
			   --->
			  <cfinvoke 
				 component="sif.rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Usuario a, DatosPersonales b, UsuarioReferencia c"/>
				<cfinvokeargument name="columnas" value="#additionalCols# convert(varchar, a.Usucodigo) as Usucodigo, convert(varchar, a.CEcodigo) as CEcodigo, 
														b.Pid, b.Pnombre, b.Papellido1, b.Papellido2,
														b.Pnombre || rtrim(' ' || b.Papellido1 || rtrim(' ' || b.Papellido2)) as NombreCompleto, 
														a.Uestado, c.llave as Ppersona
														"/>
				<cfinvokeargument name="desplegar" value="Pid, Papellido1, Papellido2, Pnombre"/>
				<cfinvokeargument name="etiquetas" value="Identificación, Apellido1, Apellido2, Nombre"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.CEcodigo = #Session.CEcodigo#
													and a.datos_personales = b.datos_personales
													and a.Usucodigo = c.Usucodigo
													and c.STabla = 'PersonaEducativo'
													and c.Ecodigo = #Session.EcodigoSDC#
													#filtro#
													order by b.Pid, b.Papellido1, b.Papellido2, b.Pnombre"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="Ppersona, NombreCompleto"/>
				<cfinvokeargument name="keys" value="CEcodigo, Usucodigo"/>
				<cfinvokeargument name="Conexion" value="asp"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="maxRows" value="20"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			  </cfinvoke>
			</td>
		  </tr>
		</table>
	</cfoutput>

</body>
</html>
