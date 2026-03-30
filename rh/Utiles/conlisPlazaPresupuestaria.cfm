<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ListaDePlazasPresupuestarias"
Default="Lista de Plazas Presupuestarias"
returnvariable="LB_ListaDePlazasPresupuestarias"/>


<html>
<head>
<title><cfoutput>#LB_ListaDePlazasPresupuestarias#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<script language="JavaScript" type="text/javascript">
	function Asignar(id, codigo, descripcion) {
		if (window.opener != null) {
			<cfoutput>
			window.opener.document.#Url.formulario#.#Url.id#.value = id;
			window.opener.document.#Url.formulario#.#Url.codigo#.value = codigo;
			window.opener.document.#Url.formulario#.#Url.desc#.value = descripcion;
			</cfoutput>
			window.close();
		}
	}
</script>

<cfoutput>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CODIGO"
Default="C&oacute;digo"
XmlFile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DESCRIPCION"
Default="Descripci&oacute;n"
XmlFile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>
			
<form name="filtro" method="get">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>#LB_CODIGO#</strong></td>
		<td> 
			<input name="fRHPPcodigo" type="text" id="fRHPPcodigo" size="10" maxlength="10" value="<cfif isdefined("url.fRHPPcodigo")>#url.fRHPPcodigo#</cfif>">
		</td>
		<td align="right"><strong>#LB_DESCRIPCION#</strong></td>
		<td> 
			<input name="fRHPPdescripcion" type="text" id="fRHPPdescripcion" size="40" maxlength="80" value="<cfif isdefined("url.fRHPPdescripcion")>#url.fRHPPdescripcion#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>

	<input type="hidden" name="id" value="#url.id#">
	<input type="hidden" name="codigo" value="#url.codigo#">
	<input type="hidden" name="desc" value="#url.desc#">
	<input type="hidden" name="formulario" value="#url.formulario#">

</form>
</cfoutput>

<cfquery name="rsPlazas" datasource="#Session.DSN#">
	select pp.RHPPid, 
		   pp.RHPPcodigo,
		   pp.RHPPdescripcion
	from RHPlazaPresupuestaria pp
	where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	<cfif isdefined("url.fRHPPcodigo") and len(trim(url.fRHPPcodigo))>
		and RHPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.fRHPPcodigo#">
	</cfif>

	<cfif isdefined("url.fRHPPdescripcion") and len(trim(url.fRHPPdescripcion))>
		and upper(RHPPdescripcion) like '%#ucase(url.fRHPPdescripcion)#%'
	</cfif>
	
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsPlazas#"/>
	<cfinvokeargument name="desplegar" value="RHPPcodigo, RHPPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisPlazaPresupuestaria.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHPPid, RHPPcodigo, RHPPdescripcion"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="form_method" value="get"/>
</cfinvoke>
</body>
</html>
