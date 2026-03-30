<html>
<head>
	<cf_templatecss>
	<title>Web Services</title>
</head>

<body style=" margin:0 ">

<cfif isdefined("Url.id_documento") and Len(Trim(Url.id_documento))>
	<cfparam name="Form.id_documento" default="#Url.id_documento#">
</cfif>
<cfif isdefined("Url.id_requisito") and Len(Trim(Url.id_requisito))>
	<cfparam name="Form.id_requisito" default="#Url.id_requisito#">
</cfif>

<cfif isdefined("Form.id_documento") and Len(Trim(Form.id_documento)) and isdefined("Form.id_requisito") and Len(Trim(Form.id_requisito))>
	<cfquery name="rsServicio" datasource="#session.tramites.dsn#">
		select a.id_servicio, a.nombre_servicio
		from WSServicio a
		where a.id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
	</cfquery>
	
	<cfquery name="rsMetodos" datasource="#session.tramites.dsn#">
		select b.id_servicio, b.id_metodo, b.nombre_metodo || ' (' || a.nombre_servicio || ')' as nombre_metodo, b.clase_input, b.clase_output, b.activo
		from WSServicio a
			inner join WSMetodo b
				on b.id_servicio = a.id_servicio
		where a.id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
		and b.activo = 1
	</cfquery>

	<cfset modo = "ALTA">
	<cfif isdefined("Form.id_metodo") and Len(Trim(Form.id_metodo))>
		<cfset modo = "CAMBIO">
	</cfif>
	
	<cfif modo EQ "CAMBIO">
		<cfquery name="rsData" datasource="#session.tramites.dsn#">
			select id_requisito, id_metodo, secuencia, tipo_proceso, BMUsucodigo, BMfechamod
			from TPRequisitoWSMetodo
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
			and id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_metodo#">
		</cfquery>
	</cfif>

	<cfquery name="rsLista" datasource="#session.tramites.dsn#">
		select '#Form.id_documento#' as id_documento, a.id_requisito, a.id_metodo as id_metodo_del, a.secuencia, b.nombre_metodo,
			   case a.tipo_proceso 
					when 1 then 'Guardar 1er Resultado en Tramite'
					when 2 then 'Guardar todos los Resultados en Expediente'
					when 3 then 'Verifica Existencia'
					when 0 then 'Ignorar Resultados'
					else ''
			   end as tipo,
			   '<img src=#Chr(34)#/cfmx/home/imagenes/Documentos2.gif#Chr(34)# onClick=#Chr(34)#javascript: CambiarMetodo(''' || <cf_dbfunction name="to_char" args="a.id_metodo"> || ''')#Chr(34)# onMouseOver=#Chr(34)#this.style.cursor = ''pointer'';#Chr(34)#>' as cambiar,
			   '<img src=#Chr(34)#/cfmx/home/imagenes/Borrar01_S.gif#Chr(34)# onClick=#Chr(34)#javascript: EliminarMetodo(''' || <cf_dbfunction name="to_char" args="a.id_metodo"> || ''')#Chr(34)# onMouseOver=#Chr(34)#this.style.cursor = ''pointer'';#Chr(34)#>' as eliminar
		from TPRequisitoWSMetodo a
			inner join WSMetodo b
				on b.id_metodo = a.id_metodo
		where a.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
		order by a.secuencia
	</cfquery>

	<cfoutput>
	<form name="form1" method="post" action="wsservicio-sql.cfm" style="margin: 0;">
		<input type="hidden" name="id_requisito" value="#Form.id_requisito#">
		<input type="hidden" name="id_documento" value="#Form.id_documento#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td bgcolor="##ECE9D8" style="padding:3px;" colspan="2">
				<font size="1">
					M&eacute;todos a Invocar del WebService
				</font>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td align="right" nowrap class="fileLabel">M&eacute;todo:</td>
			<td>
				<select name="id_metodo">
				<cfloop query="rsMetodos">
					<option value="#rsMetodos.id_metodo#"<cfif isdefined("url.MODMET") and url.IDM EQ rsMetodos.id_metodo> selected</cfif>>#rsMetodos.nombre_metodo#</option>
				</cfloop>
				</select>
				<cfif rsMetodos.recordCount EQ 0>
					Debe configurar los servicios externos de conexi&oacute;n antes de continuar
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right" nowrap class="fileLabel">Tipo Proceso:</td>
			<td nowrap>
				<select name="tipo_proceso">
					<option value="1"<cfif isdefined("url.MODMET") and url.TP EQ "1"> selected</cfif>>Guardar 1er Resultado en Tramite</option>
					<option value="2"<cfif isdefined("url.MODMET") and url.TP EQ "2"> selected</cfif>>Guardar todos los Resultados en Expediente</option>
					<option value="3"<cfif isdefined("url.MODMET") and url.TP EQ "3"> selected</cfif>>Verifica Existencia</option>
					<option value="0"<cfif isdefined("url.MODMET") and url.TP EQ "0"> selected</cfif>>Ignorar Resultados</option>
				</select>
			</td>
		  </tr>
		  <tr>
			<td width="25%" align="right" nowrap class="fileLabel">Secuencia:</td>
			<td nowrap>
				<input type="text" name="secuencia" value="<cfif isdefined("url.MODMET")>#url.S#</cfif>">
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="2" align="center">
				<cf_botones>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</form>
	</cfoutput>	
	
	<cf_qforms name="form1">
	<script language="javascript" type="text/javascript">
		objForm.id_metodo.required = true;
		objForm.id_metodo.description = "Método";
		objForm.tipo_proceso.required = true;
		objForm.tipo_proceso.description = "Tipo Proceso";
	</script>
	
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="secuencia, nombre_metodo, tipo, cambiar, eliminar"/>
		<cfinvokeargument name="etiquetas" value="Secuencia, Nombre M&eacute;todo, Tipo, &nbsp;, &nbsp;"/>
		<cfinvokeargument name="formatos" value="S,S,S,S,S"/>
		<cfinvokeargument name="align" value="left, left, left, right, right"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="formName" value="listaMetodos"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="irA" value="wsservicio-sql.cfm"/>
		<cfinvokeargument name="keys" value="id_requisito, id_documento, id_metodo_del"/>
		<cfinvokeargument name="maxRows" value="0"/>
	</cfinvoke> 
	
	<cfoutput>
	<script language="javascript" type="text/javascript">
		function EliminarMetodo(id_metodo) {
			document.listaMetodos.ID_REQUISITO.value = '#Form.id_requisito#';
			document.listaMetodos.ID_DOCUMENTO.value = '#Form.id_documento#';
			document.listaMetodos.ID_METODO_DEL.value = id_metodo;
			document.listaMetodos.submit();
		}
		function CambiarMetodo(id_metodo) {
			document.listaMetodos.ID_REQUISITO.value = '#Form.id_requisito#';
			document.listaMetodos.ID_DOCUMENTO.value = '#Form.id_documento#';
			document.listaMetodos.ID_METODO_DEL.value = "-" + id_metodo;
			document.listaMetodos.submit();
		}
	</script>
	</cfoutput>
	
</cfif>

</body>
</html>
