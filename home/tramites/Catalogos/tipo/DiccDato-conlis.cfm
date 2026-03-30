<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Lista de Tipos</title>
</head>

<body>
<script language="javascript" type="text/javascript">
function asignar(id_tipo,nombre_tipo,tipo){ 
	window.opener.document.form1.id_tipocampo.value = id_tipo;
	window.opener.document.form1.nombre_tipo.value = nombre_tipo;
	window.opener.document.form1.tipo.value = tipo;
	window.close();
}
</script>
<cfparam name="url.filtro_tipo" default="*">
<cfparam name="url.filtro_nombre_tipo" default="">
<cfset navegacion = "id_tipopadre=" & url.id_tipopadre>
<cfif isdefined("url.filtro_nombre_tipo") and Len(Trim(url.filtro_nombre_tipo))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_nombre_tipo=" & url.filtro_nombre_tipo>
</cfif>

<cfquery name="rsLista" datasource="#session.tramites.dsn#">
	select 	id_tipo,
			nombre_tipo, 
			'' as clase,
			'' tipo,
			nombre_tabla,
			(select nombre_documento from TPDocumento dc where dc.id_tipo = DDTipo.id_tipo) as nombre_documento,
			es_documento,clase_tipo,tipo_dato,nombre_tabla,longitud,escala,
			1 as tab
	from DDTipo
	where id_tipo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipopadre#">
	<cfif Len(Trim(url.filtro_nombre_tipo))>
		and upper(nombre_tipo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_nombre_tipo)#%">
	</cfif>
	<cfif url.filtro_tipo eq 'D'>
		and es_documento = 1
		and exists (select 1 from TPDocumento where TPDocumento.id_tipo = DDTipo.id_tipo)
	<cfelseif ListFind('F,N,B,S',url.filtro_tipo) >
		and clase_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="S">
		and tipo_dato = <cfqueryparam cfsqltype="cf_sql_char" value="#url.filtro_tipo#">
	<cfelseif Len(Trim(url.filtro_tipo)) and url.filtro_tipo NEQ "*">
		and clase_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.filtro_tipo#">
		and es_documento = 0
	</cfif>
	order by es_documento,clase_tipo desc, nombre_tipo
</cfquery>
<cfset diccdatoui = CreateObject("component", "diccdatoui")>
<cfloop query="rsLista">
	<cfset rsLista.clase = diccdatoui.describeClase(es_documento,clase_tipo,tipo_dato,nombre_tabla)>
	<cfset rsLista.tipo  = diccdatoui.describeTipo (es_documento,clase_tipo,tipo_dato,nombre_tabla,longitud,escala,nombre_documento)>
</cfloop>

<script language="javascript" type="text/javascript">
	function funcNuevo() {
		document.listaTipos.TAB.value = '1';
	}

	function funcFiltrar() {
		document.listaTipos.TAB.value = '0';
	}
</script>


<table width="99%"  border="0" cellspacing="0" cellpadding="2" align="center">
  <tr>
    <td><form name="form_filtro" method="get" style="margin:0 ">
	
<cfoutput>
	<input type="hidden" name="id_tipopadre" value="#URLEncodedFormat(id_tipopadre)#">
	</cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <!--DWLayoutTable-->
      		<tr>
			<td class="tituloListas" align="left" width="18" height="17" nowrap></td>

						
			
			<td width="223" align="left" class="tituloListas"><strong>Nombre</strong></td><td colspan="4" align="left" class="tituloListas"><strong>Tipo</strong></td>
			
		</tr>
		<tr>
			<td align="left" nowrap class="tituloListas"></td>
				<td>
			    <input type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()" 
								onkeypress="if((event.which?event.which:event.keyCode)==13){if (window.funcFiltrar) funcFiltrar();  this.form.submit();}"
								name="filtro_nombre_tipo" value="">		  </td>
			
				<td width="522" align="left" valign="top">
					
						<select name="filtro_tipo" onchange="if (window.funcFiltrar) funcFiltrar();  this.form.submit();">
								
								<option value="*" <cfif url.filtro_tipo eq '*'>selected</cfif>>Todos</option>
								<option value="C" <cfif url.filtro_tipo eq 'C'>selected</cfif>>Complejo</option>
								<option value="T" <cfif url.filtro_tipo eq 'T'>selected</cfif>>Concepto Interno</option>
								<option value="D" <cfif url.filtro_tipo eq 'D'>selected</cfif>>Documento</option>
								<option value="L" <cfif url.filtro_tipo eq 'L'>selected</cfif>>Lista Valores</option>
								<optgroup label="Tipo Simple">
								
								<option value="F" <cfif url.filtro_tipo eq 'F'>selected</cfif>>Fecha</option>
								
								<option value="N" <cfif url.filtro_tipo eq 'N'>selected</cfif>>N&uacute;mero</option>

								
								<option value="B" <cfif url.filtro_tipo eq 'B'>selected</cfif>>S&iacute;/No</option>
								
								<option value="S" <cfif url.filtro_tipo eq 'S'>selected</cfif>>Alfanum&eacute;rico</option>
								</optgroup>
								

																
					    </select>			    </td>
					<td colspan="3"><input type="button" value="Filtrar" name="butFiltrar" onclick="if (window.funcFiltrar) funcFiltrar();  this.form.submit();" tabindex="0"></td>
		</tr>
    </table></form></td>
  </tr>
  <tr>
    <td>
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
			<cfinvokeargument name="funcion" value="asignar"/>
			<cfinvokeargument name="fparams" value="id_tipo,nombre_tipo,tipo"/>
			<cfinvokeargument name="keys" value="id_tipo"/>
			<cfinvokeargument name="irA" value=""/>
			<cfinvokeargument name="cortes" value="clase"/>
			<cfinvokeargument name="maxRows" value="20"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="form_method" value="get"/>
		</cfinvoke> 
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>

</body>
</html>
