<!--- Tag de Cuentas --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate  key="LB_ListaDeCatalogoDeNivelIndependiente">Lista de Catalogo de Nivel Independiente</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">
	<cfinclude template="ConlisCuentasFinancierasParams.cfm">
	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset fnUrlToFormParam ("nivel", "")>
	<cfset fnUrlToFormParam ("CatalogoID", "")>
	
	<cfif isdefined("url.Ocodigo")>
		<cfset fnUrlToFormParam ("Ocodigo", "")>
		<cfset LvarOcodigo=form.Ocodigo>
	</cfif>
	
	<cfset navegacion = GvarUrlToFormParam>
	
	<cfset filtro = "">
	<cfif Len(Trim(Form.txt_codigo))>
		<cfset filtro = filtro & " and v.PCDvalor like '%#Form.txt_codigo#%'">
	</cfif>
	<cfif Len(Trim(Form.txt_descripcion))>
		<cfset filtro = filtro & " and upper(v.PCDdescripcion) like '%#UCase(Form.txt_descripcion)#%'">
	</cfif>
	
	<script language="javascript" type="text/javascript">
		function AsignarNivel(valor, descripcion) {
			if (window.parent.sbResultadoConLisCFnivel) {
				window.parent.sbResultadoConLisCFnivel(valor, descripcion, <cfoutput>#form.nivel#</cfoutput>);
			}
		}
	</script>
	<cfquery name="rsTitulo" datasource="#Session.DSN#">
		select PCEdescripcion as Titulo, PCEcodigo
		  from PCECatalogo
		 where PCEcatid = #form.CatalogoID#
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	     <td align="center" class="tituloListas"><cfoutput><cf_translate  key="LB_Nivel">Nivel</cf_translate> #form.nivel#: <cf_translate  key="LB_Catalogo">Catálogo</cf_translate> '#rsTitulo.PCEcodigo# - #rsTitulo.Titulo#'</cfoutput></td>
      </tr>
	  <tr>
		<td class="areaFiltro">
			<cfoutput>
			<form name="filtroCuentas" method="post" style="margin: 0;" action="#GetFileFromPath(GetTemplatePath())#" style="margin:0;">
				<cfloop collection="#Form#" item="i">
					<cfset v = StructFind(Form, i)>
					<cfif CompareNoCase(i, "txt_codigo") and CompareNoCase(i, "txt_descripcion") and Len(Trim(v))>
						<input type="hidden" name="#i#" value="#v#">
					</cfif>
				</cfloop>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_CODIGO"
				Default="C&oacute;digo"
				returnvariable="LB_CODIGO"/>
		
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DESCRIPCION"
				Default="Descripci&oacute;n"
				returnvariable="LB_DESCRIPCION"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Buscar"
				Default="Buscar"
				returnvariable="BTN_Buscar"/>

				
				<table width="100%"  border="0" cellspacing="0" cellpadding="3">
				  <tr>
					<td align="right" class="fileLabel">#LB_CODIGO#:</td>
					<td>
						<input name="txt_codigo" type="text" size="10" maxlength="10" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
					</td>
					<td align="right" class="fileLabel">#LB_DESCRIPCION#:</td>
					<td>
						<input name="txt_descripcion" type="text" size="40" maxlength="80" value="<cfif isdefined('Form.txt_descripcion')>#Form.txt_descripcion#</cfif>">
					</td>
					<td align="center">
						<input name="btnBuscar" type="submit" value="#BTN_Buscar#">
					</td>
				  </tr>
				</table>
			</form>
			</cfoutput>
		</td>
	  </tr>
	  <tr>
		<td>
			<cfset LvarConsulta =''>
			<cfif isdefined("LvarOcodigo") and LvarOcodigo neq -1>
				<cfif len(trim(LvarOcodigo)) GT 0>
					<cfset LvarConsulta =	'and exists (Select 1 
												from PCDCatalogoValOficina vo
												where vo.PCDcatid = v.PCDcatid
												   and vo.Ocodigo = ' & #LvarOcodigo#&')' >
				</cfif>
			</cfif>
			
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="PCECatalogo c, PCDCatalogo v"/>
				<cfinvokeargument name="columnas" value="v.PCDvalor as Valor, v.PCDdescripcion as Descripcion"/>
					<cfinvokeargument name="desplegar" value="Valor, Descripcion"/>
					<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="c.PCEcatid = #form.CatalogoID#
														   and c.PCEactivo = 1
														   and v.PCEcatid = c.PCEcatid
														   and ( (c.PCEempresa = 1 and v.Ecodigo = #session.Ecodigo#) or (c.PCEempresa = 0 and v.Ecodigo is null) )
														   and v.PCDactivo = 1
														   
														   and	(												   
																	(c.PCEoficina = 1 
																	#LvarConsulta#
																			     )
																	or
															
																	c.PCEoficina = 0 
															
																  )		
																  
															and (
																	(
																	c.PCEvaloresxmayor = 1
																	and exists (Select 1
																			  from PCDCatalogoPorMayor cxm
																			  where cxm.PCEcatid = c.PCEcatid
																				and cxm.PCDcatid = v.PCDcatid
																				and cxm.Cmayor = '#trim(form.Cmayor)#'
																				and cxm.Ecodigo = #session.ecodigo#)
																	)
																	
																	or
																	
																	c.PCEvaloresxmayor = 0
																	
																)			
														   
														   #filtro#
														   order by v.PCDvalor, v.PCDdescripcion"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="listaCuentas"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="funcion" value="AsignarNivel"/>
				<cfinvokeargument name="fparams" value="Valor, Descripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	  </tr>
	</table>

</body>
</html>
