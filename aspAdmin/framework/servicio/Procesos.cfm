<cfset dmodo = 'ALTA'>
<cfif isdefined("form.uri") and isdefined("form.tipo_uri") and isdefined("form.servicio") >
	<cfset dmodo = 'CAMBIO'>
</cfif>

<!--- descripcion del servicio y datos para el home --->
<cfquery name="rsServicio" datasource="sdc">
	select nombre, home_uri, home_tipo from Servicios where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#">
</cfquery>

<!--- procesos asignados a un servicio --->
<cfquery name="rsProcesos" datasource="sdc">
	select p.uri, 
			p.tipo_obj,
			p.tipo_uri,	
	       case p.tipo_obj when 'P' then 'Página' when 'D' then 'Directorio' when 'S' then 'Subdirectorios' when 'A' then 'Acción' when 'B' then 'Botón' when 'C' then 'Componente' end as dtipo_obj, 
		   case p.tipo_uri when 'J' then 'JSP' when 'C' then 'Cold Fusion' when 'D' then 'Dynamo' end as dtipo_uri, 
		   p.titulo, 
		   1 as orden
	from Procesos p
	where p.servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#">
	  and p.activo = 1
</cfquery>

<cfif dmodo neq 'ALTA'>
	<cfquery name="rsForm" datasource="sdc">
		select uri, tipo_uri, case tipo_uri when 'J' then 'JSP' when 'C' then 'Cold Fusion' when 'D' then 'Dynamo' end as dtipo_uri, servicio, tipo_obj, titulo 
		from Procesos
		where uri      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uri#" >
		  and tipo_uri = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_uri#" >
		  and servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#" >
  </cfquery>
</cfif>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" class="contenido" border="1">
	<tr class="itemtit">
		<td colspan="5" align="left">
			<strong>Servicio:</strong> (#form.servicio#)&nbsp;#rsServicio.nombre#
		</td>
	</tr>

	<form name="form2" method="post" action="SQLProcesos.cfm">
		<!--- Ocultos --->
		<input type="hidden" name="sistema" value="#form.sistema#">
		<input type="hidden" name="modulo" value="#form.modulo#">
		<input type="hidden" name="servicio" value="#form.servicio#">
		<input type="hidden" name="editar" value="#modo#">
	
		<tr class="itemtit">
			<td width="40%" colspan="2" align="left"><strong>T&iacute;tulo</strong></td>
			<td width="10%" style="text-align: center;" align="left" ><strong>Tipo</strong></td>
			<td width="10%" style="text-align: center;" align="left" ><strong>Plataforma</strong></td>
			<td width="40%" align="left"><strong>URI</strong></td>
		</tr>
	
		<!--- ========================================================================= --->
		<!---                                 Mantenimiento                             --->
		<!--- ========================================================================= --->
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="titulo" size="30" maxlength="30" onFocus="this.select();" value="<cfif dmodo neq 'ALTA'>#rsForm.titulo#</cfif>" ></td>
			<td>
				<select name="tipo_obj" onChange="change_uri(this.form)">
					<option value="P" <cfif dmodo neq 'ALTA' and rsForm.tipo_obj eq 'P'> selected</cfif>>P&aacute;gina</option>
					<option value="D" <cfif dmodo neq 'ALTA' and rsForm.tipo_obj eq 'D'> selected</cfif>>Directorio (sin subdirectorios)</option>
					<option value="S" <cfif dmodo neq 'ALTA' and rsForm.tipo_obj eq 'S'> selected</cfif>>Subdirectorios</option>
					<option value="A" <cfif dmodo neq 'ALTA' and rsForm.tipo_obj eq 'A'> selected</cfif>>Acci&oacute;n</option>
					<option value="B" <cfif dmodo neq 'ALTA' and rsForm.tipo_obj eq 'B'> selected</cfif>>Bot&oacute;n</option>
					<option value="C" <cfif dmodo neq 'ALTA' and rsForm.tipo_obj eq 'C'> selected</cfif>>Componente</option>
				</select>
			</td>
			<td>
				<cfif dmodo neq 'ALTA'>
					#rsForm.dtipo_uri#
					<input type="hidden" name="tipo_uri" value="#rsForm.tipo_uri#">
				<cfelse>
					<select name="tipo_uri">
						<option value="J" <cfif dmodo neq 'ALTA' and rsForm.tipo_uri eq 'J'> selected</cfif>>JSP</option>
						<option value="C" <cfif dmodo neq 'ALTA' and rsForm.tipo_uri eq 'C'> selected</cfif>>Cold Fusion</option>
						<option value="D" <cfif dmodo neq 'ALTA' and rsForm.tipo_uri eq 'D'> selected</cfif>>Dynamo</option>
						<option value="O" <cfif dmodo neq 'ALTA' and rsForm.tipo_uri eq 'O'> selected</cfif>>Otro</option>
					</select>
				</cfif>
			</td>
			<td>
				<cfif dmodo neq 'ALTA'>
					#rsForm.uri#
					<input type="hidden" name="uri" value="#rsForm.uri#">
				<cfelse>
					<input type="text" name="uri" size="50" maxlength="255" onFocus="this.select();" onChange="change_uri(this.form)">
				</cfif>
			</td>
		</tr>

		<tr>
			<td colspan="5" style="text-align: right;">
				<input type="submit" name="btnDGuardar" value="Guardar">
				<cfif dmodo neq 'ALTA' >
					<input type="submit" name="btnDBorrar" value="Eliminar" onClick="return borrar_detalle(this.form);">
					<input type="submit" name="btnDNuevo" value="Nuevo">
				</cfif>
				<input type="submit" name="btnHome" value="P&aacute;gina Inicial">
			</td>
		</tr>

		<tr>
			<td bgcolor="##F5F5F5" colspan="5" align="center" class="subTitulo">Listado de Procesos</td>
		</tr>

		<!--- ========================================================================= --->
	
		<cfloop query="rsProcesos">
			<tr bgcolor="<cfif not (rsProcesos.CurrentRow mod 2) >##FAFAFA</cfif>" >
				<td width="1%">
					<cfif rsServicio.home_uri eq rsProcesos.uri and rsServicio.home_tipo eq rsProcesos.tipo_uri >
						<img src="../../imagenes/Home01_T.gif" border="0" height="15" width="15" >
					</cfif>
				</td>		
				<td nowrap onClick="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );" ><a href="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );">#rsProcesos.titulo#</a></td>
				<td nowrap onClick="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );" ><a href="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );">#rsProcesos.dtipo_obj#</a></td>
				<td nowrap onClick="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );" ><a href="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );">#rsProcesos.dtipo_uri#</a></td>
				<td nowrap onClick="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );" ><a href="javascript:cargarProceso('#rsProcesos.uri#', '#rsProcesos.tipo_uri#' );">#rsProcesos.uri#</a></td>
			</tr>
		</cfloop>
	</form>
</table>
</cfoutput>


<script language="javascript1.2" type="text/javascript">
	objForm2 = new qForm("form2");

	objForm2.titulo.required = true;
	objForm2.titulo.description="Título";
	<cfif modo neq 'ALTA'>
		objForm2.uri.required = true;
		objForm2.uri.description="Uri";
	</cfif>

	function cargarProceso(uri, tipo_uri ) {
		document.form2.uri.value      = uri;
		document.form2.tipo_uri.value = tipo_uri;
		document.form2.action         = '';
		document.form2.submit();
	}
	
	function change_uri(f) {
		if (f.uri.value.charAt(0) != '/') {
			f.uri.value = "/" + f.uri.value;
		}
		if (f.tipo_obj.value == 'S' || f.tipo_obj.value == 'D') {
			if (f.uri.value.charAt(f.uri.value.length-1) != '/') {
				f.uri.value += "/";
			}
		} else if (f.uri.value.charAt(f.uri.value.length-1) == '/') {
			f.uri.value = f.uri.value.substring(0,f.uri.value.length-1);
		}

	}
	
	function borrar_detalle(f){
		if (confirm("Seguro de que desea eliminar el proceso?")) {
			objForm._allowSubmitOnError = true;
			objForm._showAlerts = false;
			return true;
		}
		return false;
	}
	
</script>

