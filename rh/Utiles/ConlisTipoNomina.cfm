<html>
<head>
<title><cf_translate  key="LB_ListaDeTiposDeNomina">Lista de Tipos de N&oacute;mina</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>



<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>
<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
	<cfparam name="Form.p3" default="#Url.p3#">
</cfif>

<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")>
	<cfparam name="Form.Tcodigo" default="#Url.Tcodigo#">
</cfif>
<cfif isdefined("Url.Tdescripcion") and not isdefined("Form.Tdescripcion")>
	<cfparam name="Form.Tdescripcion" default="#Url.Tdescripcion#">
</cfif>
<cfif isdefined("Url.onChange") and not isdefined("Form.onChange")>
	<cfparam name="Form.onChange" default="#Url.onChange#">
</cfif>


<script language="JavaScript" type="text/javascript">
function Asignar(cod, desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p2#.value = cod;
		window.opener.document.#Form.f#.#Form.p3#.value = desc;
		
		<cfif isdefined('form.onChange') and len(trim(form.onChange))>
			eval('window.opener.#form.onChange#();') //funcion que simula ejecutarse en el onchange.
		</cfif>
			
		</cfoutput>
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.Tcodigo") and Len(Trim(Form.Tcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.Tcodigo) like '%" & #UCase(Form.Tcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tcodigo=" & Form.Tcodigo>
</cfif>
<cfif isdefined("Form.Tdescripcion") and Len(Trim(Form.Tdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.Tdescripcion) like '%" & #UCase(Form.Tdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tdescripcion=" & Form.Tdescripcion>
</cfif>

<!---query que trae la UNION entre los tipos de nomina que no tienen restrigcion, los que no necesitan permiso y los Une con los que el usuario posee permiso de ver--->
<cfquery name="rsTiposPerm" datasource="#session.DSN#">
	select  rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion
	from TiposNomina a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("Url.excepto")>
		 and a.Tcodigo <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Url.excepto#">
	</cfif>
	and a.Tcodigo not in (select x.Tcodigo from TiposNominaPermisos x where  x.Ecodigo= a.Ecodigo
		and x.Tcodigo=a.Tcodigo )
	UNION
	select  rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion
	from TiposNomina a
		inner join TiposNominaPermisos b
		on b.Ecodigo= a.Ecodigo
		and b.Tcodigo=a.Tcodigo 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">


</cfquery>



<cfquery name="rsTiposPermitidos" dbtype="query">
	select  * from rsTiposPerm
	order by Tcodigo
</cfquery>

<cfif rsTiposPermitidos.RecordCount GT 0 >
 	<cfset filtro = filtro & " and upper(a.Tcodigo) in ('" & #UCase(replaceNoCase(valueList(rsTiposPermitidos.Tcodigo),",","','",'all'))# & "')">	
</cfif>



<cfoutput>
<form name="filtroTipoNomina" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="onChange" value="#Form.onChange#">

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

<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">#LB_CODIGO#</td>
    <td> 
      <input name="Tcodigo" type="text" id="Tcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.Tcodigo")>#Form.Tcodigo#</cfif>">
    </td>
    <td align="right">#LB_DESCRIPCION#</td>
    <td> 
      <input name="Tdescripcion" type="text" id="Tdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.Tdescripcion")>#Form.Tdescripcion#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#">
    </td>
  </tr>
</table>
</form>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TipoDeNomina"
Default="Tipo de N&oacute;mina"
returnvariable="LB_TipoDeNomina"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_NombreDeNomina"
Default="Nombre de N&oacute;mina"
returnvariable="LB_NombreDeNomina"/>

</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="TiposNomina a"/>
	<cfinvokeargument name="columnas" value="rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion"/>
	<cfinvokeargument name="desplegar" value="Tcodigo,Tdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_TipoDeNomina#,#LB_NombreDeNomina#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" a.Ecodigo = #Session.Ecodigo#
											#filtro#
											order by a.Tcodigo"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisTipoNomina.cfm"/>
	<cfinvokeargument name="formName" value="listaTipoNomina"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Tcodigo, Tdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
