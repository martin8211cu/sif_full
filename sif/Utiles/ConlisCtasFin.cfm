<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Cuentas Financieras</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">
	<cfinclude template="ConlisCuentasFinancierasParams.cfm">
	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
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
	
	<!---<script language="javascript" type="text/javascript">
		function Asignar(valor, descripcion) {
			if (window.parent.sbResultadoConLisCFformato) {
				window.parent.sbResultadoConLisCFformato(valor, descripcion);
				window.parent.sbSeleccionarOK();
			}
		}
	</script>
--->

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center" class="tituloListas"><strong>Lista de Cuentas Financieras</strong></td>
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
					<td align="right" class="fileLabel">C&oacute;digo:</td>
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
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CFinanciera a 
													inner join CContables c on a.Ccuenta = c.Ccuenta
													left join Caracteristicas aux on coalesce(c.Mcodigo,1) = aux.Mcodigo"/>
				<cfinvokeargument name="columnas" value="rtrim(a.CFformato) as Valor, 
															case when CFdescripcionF is null OR CFdescripcionF = CFdescripcion then CFdescripcion else CFdescripcionF || ' (' || CFdescripcion || ')' end as Descripcion,
															a.CFmovimiento as Movimiento, aux.Cdescripcion as Auxiliar"/>
				<cfinvokeargument name="desplegar" value="Valor, Descripcion, Movimiento,Auxiliar"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Acepta Movs.,Auxiliar"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
														   and a.Cmayor = '#form.Cmayor#'
														   #filtro#
														   order by a.CFformato, a.CFdescripcion"/>
				<cfinvokeargument name="align" value="left, left, center, left"/>
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

