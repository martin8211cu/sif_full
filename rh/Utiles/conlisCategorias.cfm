
<!--- Recibe conexion, form, name y desc --->

<cfif not isdefined ('url.key') and isdefined ('url.id')>
<cfset url.key=url.id>
</cfif>
<script language="JavaScript" type="text/javascript">
function Asignar(key, name,desc) {
	if (window.opener != null) {
		<cfoutput>
<!---			var descAnt = window.opener.document.#Url.form#.#Url.desc#.value;
--->					
			window.opener.document.#Url.form#.#Url.key#.value = key;
			window.opener.document.#Url.form#.#Url.name#.value = name;		
			window.opener.document.#Url.form#.#Url.desc#.value = desc;
			
			if (window.opener.func#Url.key#) window.opener.func#Url.key#(window.opener.document.#Url.form#.#Url.key#);
		</cfoutput>
		window.close();
	}
}
</script>


<cfif isdefined("Url.clasACcodigodesc_filtro") and not isdefined("Form.clasACcodigodesc_filtro")>
	<cfparam name="Form.clasACcodigodesc_filtro" default="#Url.clasACcodigodesc_filtro#">
</cfif>
<cfif isdefined("Url.clasACdescripcion_filtro") and not isdefined("Form.clasACdescripcion_filtro")>
	<cfparam name="Form.clasACdescripcion_filtro" default="#Url.clasACdescripcion_filtro#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.clasACcodigodesc_filtro") and Len(Trim(Form.clasACcodigodesc_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(ACcodigodesc) like '%" & #UCase(Form.clasACcodigodesc_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "clasACcodigodesc_filtro=" & Form.clasACcodigodesc_filtro>
</cfif>
<cfif isdefined("Form.clasACdescripcion_filtro") and Len(Trim(Form.clasACdescripcion_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(ACdescripcion) like '%" & #UCase(Form.clasACdescripcion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "clasACdescripcion_filtro=" & Form.clasACdescripcion_filtro>
</cfif>
<html>
<head>
<title>Lista de Categorías</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMarcas" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="clasACcodigodesc_filtro" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.clasACcodigodesc_filtro")>#Form.clasACcodigodesc_filtro#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="clasACdescripcion_filtro" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.clasACdescripcion_filtro")>#Form.clasACdescripcion_filtro#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfif isdefined('url.RHTTid') and LEN(TRIM(url.RHTTid)) and isdefined('url.RHMPPid') and LEN(TRIM(url.RHMPPid))>
	<cfquery name="rsCat" datasource="#session.dsn#">
	select b.RHCid,RHCcodigo,RHCdescripcion
		from RHCategoriasPuesto a
			inner join RHTTablaSalarial c
				on a.RHTTid = c.RHTTid
			inner join RHMaestroPuestoP d
				on a.RHMPPid = d.RHMPPid
			left outer join RHCategoria b
				on a.RHCid = b.RHCid
		where a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTTid#">
			and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPPid#">
		order by d.RHMPPcodigo, d.RHMPPdescripcion, c.RHTTcodigo, c.RHTTdescripcion
	</cfquery>
<cfelse>
	<cfquery name="rsCat" datasource="#session.dsn#">
	select RHCid,RHCcodigo,RHCdescripcion
		from RHCategoria a
		where a.Ecodigo=#session.Ecodigo#
	</cfquery>
</cfif>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsCat#"/>
	<cfinvokeargument name="desplegar" value="RHCcodigo,RHCdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisCategorias.cfm"/>
	<cfinvokeargument name="formName" value="listaMarcas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHCid,RHCcodigo,RHCdescripcion"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
</body>
</html>