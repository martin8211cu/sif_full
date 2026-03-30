<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Catalogo de Nivel Independiente</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">
	<cfinclude template="/sif/Utiles/ConlisCuentasFinancierasParams.cfm">
	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset fnUrlToFormParam ("nivel", "")>
	<cfset fnUrlToFormParam ("CatalogoID", "")>
	<cfset navegacion = GvarUrlToFormParam>
	
	<cfset filtro = "">
	<cfif Len(Trim(Form.txt_codigo))>
		<cfset filtro = filtro & " and v.PCDvalor like '%#Form.txt_codigo#%'">
	</cfif>
	<cfif Len(Trim(Form.txt_descripcion))>
		<cfset filtro = filtro & " and upper(v.PCDdescripcion) like '%#UCase(Form.txt_descripcion)#%'">
	</cfif>
	
	<script language="javascript" type="text/javascript">
		function AsignarNivel(valor, descripcion, ref) {
			if (window.opener.sbResultadoConLisCFnivel) {
				window.opener.sbResultadoConLisCFnivel(valor, descripcion, <cfoutput>#form.nivel#</cfoutput>, ref);
			}
			window.close();
		}
	</script>
	<cfquery name="rsTitulo" datasource="#Session.DSN#">
		select PCEdescripcion as Titulo
		  from PCECatalogo
		 where PCEcatid = #form.CatalogoID#
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center" class="tituloListas"><cfoutput>Lista del Catalogo '#rsTitulo.Titulo#' para el Nivel #form.nivel#</cfoutput></td>
      </tr>
	  <tr>
		<td class="areaFiltro">
			<cfoutput>
			<form name="filtroCuentas" method="post" style="margin: 0;" action="#GetFileFromPath(GetTemplatePath())#" >
				<cfloop collection="#Form#" item="i">
					<cfset v = StructFind(Form, i)>
					<cfif CompareNoCase(i, "txt_codigo") and CompareNoCase(i, "txt_descripcion") and Len(Trim(v))>
						<input type="hidden" name="#i#" value="#v#">
					</cfif>
				</cfloop>
				<table width="100%"  border="0" cellspacing="0" cellpadding="3">
				  <tr>
					<td align="right" class="fileLabel">C&oacute;digo:</td>
					<td>
						<input name="txt_codigo" type="text" size="10" maxlength="10" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
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
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="PCECatalogo c, PCDCatalogo v"/>
				<cfinvokeargument name="columnas" value="v.PCEcatid as ref, v.PCDvalor as Valor, v.PCDdescripcion as Descripcion"/>
					<cfinvokeargument name="desplegar" value="Valor, Descripcion"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="c.PCEcatid = #form.CatalogoID#
														   and c.PCEactivo = 1
														   and v.PCEcatid = c.PCEcatid
														   and ( (c.PCEempresa = 1 and v.Ecodigo = #session.Ecodigo#) or (c.PCEempresa = 0 and v.Ecodigo is null) )
														   and v.PCDactivo = 1
														   #filtro#
														   order by v.PCDvalor, v.PCDdescripcion"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="listaCuentas"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="funcion" value="AsignarNivel"/>
				<cfinvokeargument name="fparams" value="Valor, Descripcion, ref"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	  </tr>
	</table>

</body>
</html>
