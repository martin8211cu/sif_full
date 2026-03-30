<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Titulo" returnvariable="LB_Titulo" default = "Lista de Cuentas de Mayor" xmlfile="ConlisCuentasFinancierasMayor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" returnvariable="LB_Codigo" default = "C&oacute;digo" xmlfile="ConlisCuentasFinancierasMayor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" returnvariable="LB_Descripcion" default = "Descripci&oacute;n" xmlfile="ConlisCuentasFinancierasMayor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Buscar" Default="Buscar" returnvariable="BTN_Buscar" xmlfile="ConlisCuentasFinancierasMayor.xml"/>	
<!--- Tag de Cuentas --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cfoutput>#LB_Titulo#</cfoutput></title>
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
	    <td align="center" class="tituloListas"><strong><cfoutput>#LB_Titulo#</cfoutput></strong></td>
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
					<td align="right" class="fileLabel">#LB_Codigo#:</td>
					<td>
						<input name="txt_codigo" type="text" size="10" maxlength="4" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
					</td>
					<td align="right" class="fileLabel">#LB_Descripcion#:</td>
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
        	<!---Parametro para tomar la descripcion de la cuenta de mayor segun el idioma--->
            <cfquery datasource="#session.dsn#" name="rsParametroIdioma">
            	select coalesce(Pvalor,0) as Valor
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and Pcodigo = 200010
            </cfquery>
            <cfset varParametroI = rsParametroIdioma.Valor>
            
			<cfif varParametroI EQ 1>
            	<cfset vartabla =  "CtasMayor a left join CtasMayorIdioma b inner join Idiomas c on b.Iid = c.Iid and c.Icodigo =  '#session.Idioma#' on a.Ecodigo = b.Ecodigo and a.Cmayor = b.Cmayor">
                <cfset varcampos = "rtrim(a.Cmayor) as Valor, coalesce(b.CdescripcionMI, a.Cdescripcion) as Descripcion">
            <cfelse>
            	<cfset vartabla =  "CtasMayor a">
                <cfset varcampos = "rtrim(a.Cmayor) as Valor, a.Cdescripcion as Descripcion">
            </cfif>
            
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#vartabla#"/>
				<cfinvokeargument name="columnas" value="#varcampos#"/> <!--- ABG: Esta es para la descripcion en la lista de CM--->
					<cfinvokeargument name="desplegar" value="Valor, Descripcion"/>
					<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
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
