<cfset navegacion = "tab=#Form.tab#">
<cfif isdefined("Form.filtro_tipo") and Len(Trim(Form.filtro_tipo))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_tipo=" & Form.filtro_tipo>
</cfif>
<cfif isdefined("Form.filtro_nombre_tipo") and Len(Trim(Form.filtro_nombre_tipo))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_nombre_tipo=" & Form.filtro_nombre_tipo>
</cfif>
<cfif Form.tab NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "modoLista=1">
</cfif>

<cfquery name="rsLista" datasource="#session.tramites.dsn#">
	select 	id_tipo,
			nombre_tipo, 
			'' as clase,
			'' as tipo,
			es_documento,clase_tipo,tipo_dato,nombre_tabla,longitud,escala,
			(select nombre_documento from TPDocumento dc where dc.id_tipo = DDTipo.id_tipo) as nombre_documento,
			1 as tab
	from DDTipo
	where es_documento = 0
	<cfif isdefined("Form.filtro_nombre_tipo") and Len(Trim(Form.filtro_nombre_tipo))>
		and upper(nombre_tipo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.filtro_nombre_tipo)#%">
	</cfif>
	<cfif isdefined("Form.filtro_tipo") and Len(Trim(Form.filtro_tipo)) and 
		(Form.filtro_tipo EQ "F" or Form.filtro_tipo EQ "N" or Form.filtro_tipo EQ "B" or Form.filtro_tipo EQ "S")>
		and clase_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="S">
		and tipo_dato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.filtro_tipo#">
	<cfelseif isdefined("Form.filtro_tipo") and Len(Trim(Form.filtro_tipo)) and Form.filtro_tipo NEQ "*">
		and clase_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.filtro_tipo#">
	</cfif>
	order by clase_tipo desc, nombre_tipo
</cfquery>
<cfset diccdatoui = CreateObject("component", "diccdatoui")>
<cfloop query="rsLista">
	<cfset rsLista.clase = diccdatoui.describeClase(es_documento,clase_tipo,tipo_dato,nombre_tabla)>
	<cfset rsLista.tipo  = diccdatoui.describeTipo (es_documento,clase_tipo,tipo_dato,nombre_tabla,longitud,escala)>
</cfloop>

<script language="javascript" type="text/javascript">
	function nuevo(){
		document.filtro.tab.value = '1';
		document.filtro.action = "DiccDato.cfm";
		document.filtro.submit()
	}
	
	function listado(){
		location.href='../../Consultas/DiccDato.cfr';	
	}

</script>

<!--- <cfset q = QueryNew("value,description")>
<cfset QueryAddRow(q, 8)>
<cfset QuerySetCell(q, "value", "*", 1)>
<cfset QuerySetCell(q, "description", "Todos", 1)>
<cfset QuerySetCell(q, "value", "F", 2)>
<cfset QuerySetCell(q, "description", "Fecha", 2)>
<cfset QuerySetCell(q, "value", "N", 3)>
<cfset QuerySetCell(q, "description", "N&uacute;mero", 3)>
<cfset QuerySetCell(q, "value", "B", 4)>
<cfset QuerySetCell(q, "description", "S&iacute;/No", 4)>
<cfset QuerySetCell(q, "value", "S", 5)>
<cfset QuerySetCell(q, "description","Alfanum&eacute;rico", 5)>
<cfset QuerySetCell(q, "value", "L", 6)>
<cfset QuerySetCell(q, "description", "Lista Valores", 6)>
<cfset QuerySetCell(q, "value", "C", 7)>
<cfset QuerySetCell(q, "description", "Complejo", 7)>
<cfset QuerySetCell(q, "value", "T", 8)>
<cfset QuerySetCell(q, "description", "Concepto Interno", 8)> --->

<table width="99%"  border="0" cellspacing="0" cellpadding="2" align="center">
	<tr bgcolor="F5F5F5">
		<td width="3%">&nbsp;</td>
		<td width="67%"><strong>Nombre</strong></td>
		<td width="30%" colspan="2"><strong>Tipo</strong></td>
	</tr>
	<tr bgcolor="F5F5F5"> 
		<cfoutput>
		<form name="filtro" method="post">
			<td>&nbsp;</td>
			<td><input name="filtro_nombre_tipo" type="text" size="100" value="<cfif isdefined('Form.filtro_nombre_tipo')>#Form.filtro_nombre_tipo#</cfif>"></td>
			<td>
				<select name="filtro_tipo">
					<option value="*" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ '*'>selected</cfif>>Todos</option>
					<option value="F" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ "F">selected</cfif>>Fecha</option>
					<option value="N" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ "N">selected</cfif>>N&uacute;mero</option>
					<option value="B" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ "B">selected</cfif>>S&iacute;/No</option>
					<option value="S" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ "S">selected</cfif>>Alfanum&eacute;rico</option>
					<option value="L" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ "L">selected</cfif>>Lista Valores</option>
					<option value="C" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ "C">selected</cfif>>Complejo</option>
					<option value="T" <cfif isdefined("Form.filtro_tipo") and form.filtro_tipo EQ "T">selected</cfif>>Concepto Interno</option>
				</select>
			</td>
			<td>
				<input name="Imprimir" type="button" value="Imprimir" onClick="javascript: listado();">
				<input name="Nuevo" type="button" value="Nuevo" onClick="javascript: nuevo();">
				<input name="Filtrar" type="submit" value="Filtrar">
			</td>
			<input name="tab" type="hidden" value="#form.tab#">
			<input name="currentPage" type="hidden" value="#CurrentPage#">
		</form>
		</cfoutput>
	</tr>
  	<tr><td>&nbsp;</td></tr>
  	<tr>	
    	<td colspan="4">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="nombre_tipo,tipo"/>
				<cfinvokeargument name="etiquetas" value="Nombre,Tipo"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="formName" value="listaTipos"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="irA" value="#CurrentPage#"/>
				<cfinvokeargument name="keys" value="id_tipo, tab"/>
				<!---<cfinvokeargument name="botones" value="Nuevo"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/> 
				<cfinvokeargument name="rstipo" value="#q#"/> --->
				<cfinvokeargument name="cortes" value="clase"/>
				<cfinvokeargument name="maxRows" value="20"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke> 
		</td>
  	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
