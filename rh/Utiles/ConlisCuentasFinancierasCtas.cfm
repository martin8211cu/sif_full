<!--- Tag de Cuentas --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate  key="LB_ListaDeCuentasFinancieras">Lista de Cuentas Financieras</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">
	<cfinclude template="ConlisCuentasFinancierasParams.cfm">
	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset fnUrlToFormParam ("Ecodigo", "")>
	<cfset navegacion = GvarUrlToFormParam>
	
	<cfset filtro = "">
	<cfif Trim(Form.movimiento) EQ "S">
		<cfset filtro = filtro & " and a.CFmovimiento = 'S'">
	</cfif>
	<cfif Trim(Form.auxiliares) EQ "S">
		<cfset filtro = filtro & " and exists (select 1 from CContables c where c.Ccuenta = a.Ccuenta and coalesce(c.Mcodigo, 1) != 1)">
	</cfif>
	<cfif Len(Trim(Form.txt_codigo))>
		<cfset filtro = filtro & " and a.CFformato like '%#Form.txt_codigo#%'">
	</cfif>
	<cfif Len(Trim(Form.txt_descripcion))>
		<cfset filtro = filtro & " and upper(a.CFdescripcion) like '%#UCase(Form.txt_descripcion)#%'">
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
		<cfset filtro = filtro & "
				 AND ( a.CFformato like '#fnComodinToMascara(rsCF.CFcuentac)#'
				    OR a.CFformato like '#fnComodinToMascara(rsCF.CFcuentaaf)#'
				    OR a.CFformato like '#fnComodinToMascara(rsCF.CFcuentainversion)#'
				    OR a.CFformato like '#fnComodinToMascara(rsCF.CFcuentainventario)#'
				    OR a.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingreso)#'
				    OR a.CFformato like '#fnComodinToMascara(rsCF.CFcuentagastoretaf)#'
				    OR a.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingresoretaf)#'
					)
				">
	</cfif>

	<script language="javascript" type="text/javascript">
		function Asignar(valor, descripcion) {
			if (window.parent.sbResultadoConLisCFformato) {
				window.parent.sbResultadoConLisCFformato(valor, descripcion);
				window.parent.sbSeleccionarOK();
			}
		}
	</script>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center" class="tituloListas"><strong><cf_translate  key="LB_ListaDeCuentasFinancieras">Lista de Cuentas Financieras</cf_translate></strong></td>
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
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_AceptaMovs"
				Default="Acepta Movs."
				returnvariable="LB_AceptaMovs"/>	
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Auxiliar"
				Default="Auxiliar"
				returnvariable="LB_Auxiliar"/>
				
				
					
				
				<table width="100%"  border="0" cellspacing="0" cellpadding="3">
				  <tr>
					<td align="right" class="fileLabel">#LB_CODIGO#:</td>
					<td>
						<input name="txt_codigo" type="text" size="10" maxlength="100" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
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
				<cfinvokeargument name="tabla" value="CFinanciera a 
													inner join CContables c on a.Ccuenta = c.Ccuenta
													left join Caracteristicas aux on coalesce(c.Mcodigo,1) = aux.Mcodigo"/>
				<cfinvokeargument name="columnas" value="rtrim(a.CFformato) as Valor, 
															case when CFdescripcionF is null OR CFdescripcionF = CFdescripcion then CFdescripcion else {fn concat ({fn concat({fn concat(CFdescripcionF , ' ('  )}, CFdescripcion  )},  ')' )} end as Descripcion,
															a.CFmovimiento as Movimiento, aux.Cdescripcion as Auxiliar"/>
				<cfinvokeargument name="desplegar" value="Valor, Descripcion, Movimiento,Auxiliar"/>
				<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#,#LB_AceptaMovs#,#LB_Auxiliar#"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.Ecodigo = #form.Ecodigo#
														   and a.Cmayor = '#form.Cmayor#'
														   #filtro#
														   order by a.CFformato, a.CFdescripcion"/>
				<cfinvokeargument name="align" value="left, left, center, left"/>
				<cfinvokeargument name="ajustar" value="N,S,S,S"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="listaCuentas"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="Valor, Descripcion"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
				<cfif form.CFid EQ -1>
					<cfinvokeargument name="EmptyListMsg" value="No se han definido cuentas para la cuenta mayor #form.Cmayor#"/>
				<cfelse>
					<cfinvokeargument name="EmptyListMsg" value="No hay cuentas asociadas a las máscaras del Centro Funcional en la cuenta mayor #form.Cmayor#"/>
				</cfif>
			</cfinvoke>
		</td>
	  </tr>
	</table>

</body>
</html>
