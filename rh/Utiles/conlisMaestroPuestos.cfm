<html>
<head>
<title><cfoutput><cf_translate key="LB_ListaDeMaestroDePuestos">Lista de Maestro de Puestos</cf_translate></cfoutput></title>
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
			if (window.opener.func#Url.codigo#) {window.opener.func#Url.codigo#()}		
			</cfoutput>
			window.close();
		}
	}
</script>

<cfoutput>
<form name="filtro" method="get">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong><cf_translate XmlFile="/rh/generales.xml" key="LB_Codigo">C&oacute;digo</cf_translate></strong></td>
		<td> 
			<input name="fRHMPPcodigo" type="text" id="fRHMPPcodigo" size="10" maxlength="10" value="<cfif isdefined("url.fRHMPPcodigo")>#url.fRHMPPcodigo#</cfif>">
		</td>
		<td align="right"><strong><cf_translate XmlFile="/rh/generales.xml"  key="LB_Descripcion">C&Descripci&oacute;n;digo</cf_translate></strong></td>
		<td> 
			<input name="fRHMPPdescripcion" type="text" id="fRHMPPdescripcion" size="40" maxlength="80" value="<cfif isdefined("url.fRHMPPdescripcion")>#url.fRHMPPdescripcion#</cfif>">
		</td>
		<td align="center">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Filtrar"/>
		
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>

	<input type="hidden" name="id" value="#url.id#">
	<input type="hidden" name="codigo" value="#url.codigo#">
	<input type="hidden" name="desc" value="#url.desc#">
	<input type="hidden" name="formulario" value="#url.formulario#">
	<input type="hidden" name="empresa" value="#url.empresa#">
	<cfif isdefined("url.RHCid") and len(trim(url.RHCid)) >
		<input type="hidden" name="RHCid" value="#url.RHCid#">
	</cfif>
	<cfif isdefined("url.RHTTid") and len(trim(url.RHTTid)) >
		<input type="hidden" name="RHTTid" value="#url.RHTTid#">
	</cfif>

</form>
</cfoutput>

<cfquery name="rsPlazas" datasource="#Session.DSN#">
	select pp.RHMPPid, 
		   pp.RHMPPcodigo,
		   pp.RHMPPdescripcion
	from RHMaestroPuestoP pp
	where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.empresa#">
	<cfif isdefined("url.fRHMPPcodigo") and len(trim(url.fRHMPPcodigo))>
		and RHMPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.fRHMPPcodigo#">
	</cfif>
	<cfif isdefined("url.fRHMPPdescripcion") and len(trim(url.fRHMPPdescripcion))>
		and upper(RHMPPdescripcion) like '%#ucase(url.fRHMPPdescripcion)#%'
	</cfif>
	<!--- Si viene la tabla salarial se asume que tambien viene la categoria --->
	<cfif isdefined("url.RHTTid") and len(trim(url.RHTTid))>
		and exists (
			select 1
			from RHCategoriasPuesto x
			where x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTTid#">
			<cfif isdefined("url.RHCid") and len(trim(url.RHCid)) >
				and x.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
			</cfif>
			and x.RHMPPid = pp.RHMPPid
		)
	</cfif>
</cfquery>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripción"
XmlFile="/rh/generales.xml"
returnvariable="LB_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="Código"
XmlFile="/rh/generales.xml"
returnvariable="LB_Codigo"/>		


<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsPlazas#"/>
	<cfinvokeargument name="desplegar" value="RHMPPcodigo, RHMPPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisMaestroPuestos.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHMPPid, RHMPPcodigo, RHMPPdescripcion"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="form_method" value="get"/>
</cfinvoke>
</body>
</html>
