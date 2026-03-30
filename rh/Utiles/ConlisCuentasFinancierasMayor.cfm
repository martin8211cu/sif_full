<!--- Tag de Cuentas --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate  key="LB_ListaDeCuentasDeMayor">Lista de Cuentas de Mayor</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">
	<cfinclude template="ConlisCuentasFinancierasParams.cfm">
	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset fnUrlToFormParam ("Ctipo", "")>
	<cfset fnUrlToFormParam ("Ecodigo", "")>
	<cfset navegacion = GvarUrlToFormParam>
	
	<cfset filtro = "">
	<cfif Len(Trim(Form.txt_codigo))>
		<cfset filtro = filtro & " and a.Cmayor like '%#Form.txt_codigo#%'">
	</cfif>
	<cfif Len(Trim(Form.txt_descripcion))>
		<cfset filtro = filtro & " and upper(a.Cdescripcion) like '%#UCase(Form.txt_descripcion)#%'">
	</cfif>
	<cfif form.Ctipo NEQ "">
		<cfset filtro = filtro & " and upper(a.Ctipo) = '#Form.Ctipo#'">
	</cfif>

	<!--- Filtro por Centro Funcional --->
	<cfif Form.CFid NEQ "-1">
		<cfquery name="rsCF" datasource="#session.dsn#">
			select 	CFcodigo, 			CFdescripcion,
					CFcuentac, 			CFcuentaaf,
					CFcuentainversion, 	CFcuentainventario,
					CFcuentaingreso, 	CFcuentagastoretaf,
					CFcuentaingresoretaf
			  from CFuncional
			 where CFid = #Form.CFid#
		</cfquery>
		<cfset filtro = filtro & " AND (1=0">
		<cfif rsCF.CFcuentac NEQ "">
			<cfset filtro = filtro & " OR a.Cmayor like '#fnComodinToMascara(mid(rsCF.CFcuentac,1,4))#%'">
		</cfif>
		<cfif rsCF.CFcuentaaf NEQ "">
			<cfset filtro = filtro & " OR a.Cmayor like '#fnComodinToMascara(mid(rsCF.CFcuentaaf,1,4))#%'">
		</cfif>
		<cfif rsCF.CFcuentainversion NEQ "">
			<cfset filtro = filtro & " OR a.Cmayor like '#fnComodinToMascara(mid(rsCF.CFcuentainversion,1,4))#%'">
		</cfif>
		<cfif rsCF.CFcuentainventario NEQ "">
			<cfset filtro = filtro & " OR a.Cmayor like '#fnComodinToMascara(mid(rsCF.CFcuentainventario,1,4))#%'">
		</cfif>
		<cfif rsCF.CFcuentaingreso NEQ "">
			<cfset filtro = filtro & " OR a.Cmayor like '#fnComodinToMascara(mid(rsCF.CFcuentaingreso,1,4))#%'">
		</cfif>
		<cfif rsCF.CFcuentagastoretaf NEQ "">
			<cfset filtro = filtro & " OR a.Cmayor like '#fnComodinToMascara(mid(rsCF.CFcuentagastoretaf,1,4))#%'">
		</cfif>
		<cfif rsCF.CFcuentaingresoretaf NEQ "">
			<cfset filtro = filtro & " OR a.Cmayor like '#fnComodinToMascara(mid(rsCF.CFcuentaingresoretaf,1,4))#%'">
		</cfif>
		<cfset filtro = filtro & " ) ">
	</cfif>

	
	<script language="javascript" type="text/javascript">
		function Asignar(valor, descripcion) {
			if (window.parent.sbResultadoConLisCmayor) {
				window.parent.sbResultadoConLisCmayor(valor, descripcion);
			}
		}
	</script>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center" class="tituloListas"><strong><cf_translate  key="LB_ListaDeCuentasDeMayor">Lista de Cuentas de Mayor</cf_translate></strong></td>
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
						<input name="txt_codigo" type="text" size="10" maxlength="4" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
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
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CtasMayor a"/>
				<cfinvokeargument name="columnas" value="rtrim(a.Cmayor) as Valor, a.Cdescripcion as Descripcion"/>
					<cfinvokeargument name="desplegar" value="Valor, Descripcion"/>
					<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="a.Ecodigo = #form.Ecodigo#
														   #filtro#
														   order by a.Cmayor, a.Cdescripcion"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="listaCuentas"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="Valor, Descripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	  </tr>
	</table>

</body>
</html>
