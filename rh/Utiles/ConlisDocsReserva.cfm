<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Documentos de Reserva</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">
	<cfset GvarUrlToFormParam = "">
	<cffunction name="fnUrlToFormParam">
		<cfargument name="LprmNombre"  type="string" required="yes">
		<cfargument name="LprmDefault" type="string" required="yes">
		
		<cfparam name="url[LprmNombre]" default="#LprmDefault#">
		<cfparam name="form[LprmNombre]" default="#url[LprmNombre]#">
		<cfif isdefined("GvarUrlToFormParam")>
			<cfif len(trim(GvarUrlToFormParam))>
				<cfset GvarUrlToFormParam = GvarUrlToFormParam & "&">
			</cfif>
			<cfset GvarUrlToFormParam = GvarUrlToFormParam & "#LprmNombre#=" & Form[LprmNombre]>
		</cfif>
	</cffunction>

	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset fnUrlToFormParam ("p1", "")>
	<cfset fnUrlToFormParam ("p2", "")>
	<cfset fnUrlToFormParam ("p3", "")>
	<cfset navegacion = GvarUrlToFormParam>
	
	<cfset filtro = "">
	<cfif Len(Trim(Form.txt_codigo))>
		<cfset filtro = filtro & " and b.CPDEnumeroDocumento like '%#Form.txt_codigo#%'">
	</cfif>
	<cfif Len(Trim(Form.txt_descripcion))>
		<cfset filtro = filtro & " and upper(b.CPDEdescripcion) like '%#UCase(Form.txt_descripcion)#%'">
	</cfif>
	
	<script language="javascript" type="text/javascript">
		<cfoutput>
		function Asignar(id, descripcion) {
			window.opener.document.#Form.p1#.#Form.p2#.value = id;
			window.opener.document.#Form.p1#.#Form.p3#.value = descripcion;
			window.close();
		}
		</cfoutput>
	</script>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center" class="tituloListas"><strong>Lista de Documentos de Reserva</strong></td>
      </tr>
	  <tr>
		<td class="areaFiltro">
			<cfoutput>
			<form name="filtroCuentas" method="post" style="margin: 0;" action="#GetFileFromPath(GetTemplatePath())#">
				<cfloop collection="#Form#" item="i">
					<cfset v = StructFind(Form, i)>
					<cfif CompareNoCase(i, "txt_codigo") and CompareNoCase(i, "txt_descripcion") and Len(Trim(v))>
						<input type="hidden" name="#i#" value="#v#">
					</cfif>
				</cfloop>
				<table width="100%"  border="0" cellspacing="0" cellpadding="3">
				  <tr>
					<td align="right" class="fileLabel">No. Documento:</td>
					<td>
						<input name="txt_codigo" type="text" size="10" maxlength="100" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
					</td>
					<td align="right" class="fileLabel">Descripci&oacute;n:</td>
					<td>
						<input name="txt_descripcion" type="text" size="40" maxlength="80" value="<cfif isdefined('Form.txt_descripcion')>#Form.txt_descripcion#</cfif>">
					</td>
					<td align="center">
						<input name="btnBuscar" type="submit" value="Buscar">
					</td>
				  </tr>
				</table>
			</form>
			</cfoutput>
		</td>
	  </tr>
	  <tr>
		<td>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CPDocumentoE b, CPresupuestoPeriodo c"/>
				<cfinvokeargument name="columnas" value=" b.CPDEid, b.CPPid, b.CPDEfecha, b.CPDEnumeroDocumento, b.CPDEdescripcion,
														  (case c.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end) || ': '
														  || convert(varchar, c.CPPfechaDesde, 103) || ' - ' || convert(varchar, c.CPPfechaHasta, 103) as DescripcionPeriodo
														  "/>
					<cfinvokeargument name="desplegar" value="DescripcionPeriodo, CPDEnumeroDocumento, CPDEdescripcion, CPDEfecha"/>
					<cfinvokeargument name="etiquetas" value="Per&iacute;odo, No. Documento, Descripci&oacute;n, Fecha"/>
					<cfinvokeargument name="formatos" value="V,V,V,D"/>
					<cfinvokeargument name="filtro" value=" b.Ecodigo = #Session.Ecodigo#
															--and b.CPDEaplicado = 1
															and b.CPDEtipoDocumento = 'R'
															and b.CPPid = c.CPPid
															and c.CPPestado = 0
															#filtro#
															order by c.CPPfechaHasta desc, b.CPDEnumeroDocumento, b.CPDEdescripcion, b.CPDEfecha
															"/>
				<cfinvokeargument name="align" value="left, left, left, center"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="listaDocumentos"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="CPDEid, CPDEdescripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="EmptyListMsg" value="-- No hay documentos de reserva disponibles --"/>
			</cfinvoke>
		</td>
	  </tr>
	</table>

</body>
</html>
