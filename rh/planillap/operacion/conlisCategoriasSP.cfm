<html>
<head>
<title>Lista de Categor&iacute;as de Pago</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<script language="JavaScript" type="text/javascript">
	function Asignar(id, codigo, descripcion) {
		if (window.opener != null) {
			window.opener.document.form1.RHCid.value = id;
			window.opener.document.form1.RHCcodigo.value = codigo;
			window.opener.document.form1.RHCdescripcion.value = descripcion;
			window.close();
		}
	}
</script>

<cfoutput>
<form name="filtro" method="get">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="fRHCcodigo" type="text" id="fRHCcodigo" size="10" maxlength="10" value="<cfif isdefined("url.fRHCcodigo")>#url.fRHCcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="fRHCdescripcion" type="text" id="fRHCdescripcion" size="40" maxlength="80" value="<cfif isdefined("url.fRHCdescripcion")>#url.fRHCdescripcion#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>

	<cfif isdefined("url.RHMPPid") and len(trim(url.RHMPPid)) >
		<input type="hidden" name="RHMPPid" value="#url.RHMPPid#">
	</cfif>
	<cfif isdefined("url.RHTTid") and len(trim(url.RHTTid)) >
		<input type="hidden" name="RHTTid" value="#url.RHTTid#">
	</cfif>

</form>
</cfoutput>

<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select pp.RHCid, 
		   pp.RHCcodigo,
		   pp.RHCdescripcion
	from RHCategoria pp
	where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("url.fRHCcodigo") and len(trim(url.fRHCcodigo))>
		and RHCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.fRHCcodigo#">
	</cfif>
	<cfif isdefined("url.fRHCdescripcion") and len(trim(url.fRHCdescripcion))>
		and upper(RHCdescripcion) like '%#ucase(url.fRHCdescripcion)#%'
	</cfif>
	<!--- Si viene la tabla salarial se asume que tambien viene la categoria --->
	and exists (
		select 1
		from RHCategoriasPuesto x
		where x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTTid#">
		and x.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPPid#">
		and x.RHCid = pp.RHCid
	)
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsCategorias#"/>
	<cfinvokeargument name="desplegar" value="RHCcodigo, RHCdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisCategoriasSP.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHCid, RHCcodigo, RHCdescripcion"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="form_method" value="get"/>
</cfinvoke>
</body>
</html>
