<html>
<head>
<title><cf_translate key="LB_ListaDePlazas">Lista de Plazas</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(id, name, desc) {
	if (window.opener != null) {
		<cfoutput>
		//llega bien el id en mozila
		window.opener.document.#Url.form#.#Url.id#.value = id; //si funciona en mozila
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		//if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		</cfoutput>
		window.close();
	}
}
</script>

<cfset LvarEmpresa = Session.Ecodigo>
<cfset Lvarvfyplz = 0>

<cfif isdefined("Url.RHPpuesto") and not isdefined("Form.RHPpuesto")>
	<cfparam name="Form.RHPpuesto" default="#Url.RHPpuesto#">
</cfif>

<cfif isdefined("Url.CFid") and not isdefined("Form.CFid")>
	<cfparam name="Form.CFid" default="#Url.CFid#">
</cfif>

<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif>
<cfif isdefined("Url.RHPdescripcion") and not isdefined("Form.RHPdescripcion")>
	<cfparam name="Form.RHPdescripcion" default="#Url.RHPdescripcion#">
</cfif>

<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>
<!--- Parámetro para verificar el porcentaje de la plaza --->
<cfif isdefined("Url.vfyplz") and not isdefined("Form.vfyplz")>
	<cfset Lvarvfyplz = Url.vfyplz>
<cfelseif isdefined("Form.vfyplz")>
	<cfset Lvarvfyplz = Form.vfyplz>
</cfif>

<cfset navegacion = "empresa=" & LvarEmpresa & "&vfyplz=" & Lvarvfyplz>

<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFid=" & Form.CFid>
</cfif> 
<cfif isdefined("Form.RHPpuesto") and Len(Trim(Form.RHPpuesto)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPpuesto=" & Form.RHPpuesto>
</cfif> 
<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & Form.RHPcodigo>
</cfif>
<cfif isdefined("Form.RHPdescripcion") and Len(Trim(Form.RHPdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPdescripcion =" & Form.RHPdescripcion>
</cfif>
<cfquery name="rsCFuncional" datasource="#session.DSN#">
	select CFcodigo from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#"> and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFid#">
</cfquery>
<cfoutput>
<form name="filtroEmpleado" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<input type="hidden" name="vfyplz" value="#Lvarvfyplz#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
		<td> 
			<input name="RHPcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.RHPcodigo")>#Form.RHPcodigo#</cfif>">
		</td>
		<td align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
		<td> 
			<input name="RHPdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.RHPdescripcion")>#Form.RHPdescripcion#</cfif>">
		</td>
		<td align="center">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="BTN_Filtrar"
				default="Filtrar"
				xmlfile="/rh/generales.xml"
				returnvariable="BTN_Filtrar"/>
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsPlazas" datasource="#Session.DSN#">
	select  rtrim(a.RHPcodigo) as RHPcodigo, a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.CFid, 
			100.00 - coalesce(sum(b.LTporcplaza), 0.00) as Disponible
	from RHPlazas a
		left outer join LineaTiempo b
			on a.RHPid = b.RHPid
			and a.Ecodigo = b.Ecodigo
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between b.LTdesde and b.LThasta
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
	and a.RHPactiva = 1
	<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid)) NEQ 0>
		and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
	</cfif>
	<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
		and upper(a.RHPcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.RHPcodigo)#%">
	</cfif>
	<cfif isdefined("Form.RHPdescripcion") and Len(Trim(Form.RHPdescripcion)) NEQ 0>
		and upper(a.RHPdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.RHPdescripcion)#%">
	</cfif>
	<cfif isdefined("Form.RHPpuesto") and Len(Trim(Form.RHPpuesto)) NEQ 0>
		and a.RHPpuesto like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(Form.RHPpuesto))#%">
	</cfif>
	group by rtrim(a.RHPcodigo), a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.CFid
	<cfif Lvarvfyplz EQ 0>
	having coalesce(sum(b.LTporcplaza), 0) < 100
	</cfif>
</cfquery>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Codigo"
	default="C&oacute;digo"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_NoSeEncontraronPlazasEnElCentrofuncional"
	default="No se encontraron Plazas en el Centro funcional"
	returnvariable="MSG_NoSeEncontraronPlazasEnElCentrofuncional"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_ParaElPuesto"
	default="para el puesto"
	returnvariable="MSG_ParaElPuesto"/>	
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsPlazas#"/>
	<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value="S,S"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisPlazaconcursos.cfm"/>
	<cfinvokeargument name="formName" value="form"/> <!--- analizar--->
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> <!--- analizar--->
	<cfinvokeargument name="fparams" value="RHPid, RHPcodigo, RHPdescripcion"/> <!--- analizar--->
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		
	<cfinvokeargument name="EmptyListMsg" value="--- #MSG_NoSeEncontraronPlazasEnElCentrofuncional#: #rsCFuncional.CFcodigo# #MSG_ParaElPuesto#: #Form.RHPpuesto# ---"/>
</cfinvoke>

</body>
</html>
