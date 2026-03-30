<cfif isdefined("Url.onChange") and not isdefined("Form.onChange")>
	<cfparam name="Form.onChange" default="#Url.onChange#">
</cfif>

<cfif isdefined("Url.TDcodigo") and not isdefined("Form.TDcodigo")>
	<cfparam name="Form.TDcodigo" default="#Url.TDcodigo#">
</cfif>

<cfif isdefined("Url.TDdescripcion") and not isdefined("Form.TDdescripcion")>
	<cfparam name="Form.TDdescripcion" default="#Url.TDdescripcion#">
</cfif>

<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.id#.value   = id;
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		if (window.opener.func#Url.id#){ window.opener.func#Url.id#(); }
		<cfif isdefined('form.onChange') and len(trim(form.onChange))>
			eval('window.opener.#form.onChange#') //funcion que simula ejecutarse en el onchange.
		</cfif>
		</cfoutput>
		window.close();
	}
}
</script>

<cfset filtro = "">

<!--- muestra solo las de tipo financiada --->
<cfif isdefined("url.financiada") and url.financiada eq 1 >
	<cfset filtro = filtro & " and a.TDfinanciada = 1 " >
</cfif>

<cfset navegacion = "">

<cfif isdefined("Form.TDcodigo") and Len(Trim(Form.TDcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(TDcodigo) like '%" & #UCase(Form.TDcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TDcodigo=" & Form.TDcodigo>
</cfif>
<cfif isdefined("Form.TDdescripcion") and Len(Trim(Form.TDdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(TDdescripcion) like '%" & #UCase(Form.TDdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TDdescripcion=" & Form.TDdescripcion>
</cfif>
<html>
<head>
<title>Lista de Tipos de Deducción</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroEmpleado" method="post">
		<input type="hidden" name="onChange" value="#Form.onChange#">	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="TDcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.TDcodigo")>#Form.TDcodigo#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="TDdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.TDdescripcion")>#Form.TDdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<!---sacamos la deduccion de subsidio al salario de las nominas anteriores del periodo--->
<cfset vTDidsubc = 0 >
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2033" default="0" returnvariable="vTDidsubc"/>

<!--- Requiere Validación --->
<cfif isdefined("Url.val") and Url.val EQ 1>
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="TDeduccion a, RHUsuarioTDeduccion b"/>
		<cfinvokeargument name="columnas" value="a.TDid, rtrim(a.TDcodigo) as TDcodigo, a.TDdescripcion"/>
		<cfinvokeargument name="desplegar" value="TDcodigo, TDdescripcion"/>
		<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# 
											   and a.Ecodigo = b.Ecodigo
											   and a.TDid  = b.TDid 
											   and b.Usucodigo = #Session.Usucodigo#
											   and a.TDid <> #vTDidsubc#
											   #filtro# 
											   union
											   select a.TDid, rtrim(a.TDcodigo) as TDcodigo, a.TDdescripcion
											   from TDeduccion a
											   where a.Ecodigo = #Session.Ecodigo#
											   #filtro#
											   and not exists (
												select 1 from RHUsuarioTDeduccion b where a.TDid = b.TDid and a.Ecodigo = b.Ecodigo
											   )
											   order by 2, 3"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="conlisTDeduccion.cfm"/>
		<cfinvokeargument name="formName" value="listaTDeduccion"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="TDid,TDcodigo,TDdescripcion"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#url.conexion#"/>
		<cfinvokeargument name="debug" value="N"/>
	</cfinvoke>
<!--- NO Requiere Validación --->
<cfelse>
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="TDeduccion a"/>
		<cfinvokeargument name="columnas" value="a.TDid, rtrim(a.TDcodigo) as TDcodigo, a.TDdescripcion"/>
		<cfinvokeargument name="desplegar" value="TDcodigo, TDdescripcion"/>
		<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# 
											   and a.TDid <> #vTDidsubc#	
											   #filtro# 
											   order by 2, 3"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="conlisTDeduccion.cfm"/>
		<cfinvokeargument name="formName" value="listaTDeduccion"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="TDid,TDcodigo,TDdescripcion"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	</cfinvoke>
</cfif>

</body>
</html>