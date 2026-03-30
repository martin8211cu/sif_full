<cfset h_modo = 'ALTA'>
<cfif isdefined("form.id_horario") and len(trim(form.id_horario))>
	<cfset h_modo = 'CAMBIO' >
	
	<cfquery name="h_data" datasource="#session.tramites.dsn#">
		select id_horario, id_agenda, dia_semana, hora_desde, hora_hasta, id_requisito, cupo, ts_rversion
		from TPHorario
		where id_horario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_horario#">
	</cfquery>
</cfif>

<cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="formh" method="post" action="horario-sql.cfm" onSubmit="return validar(this);">
	<input type="hidden" name="id_inst" value="#form.id_inst#">
	<input type="hidden" name="id_tiposerv" value="#form.id_tiposerv#">
	<input type="hidden" name="id_agenda" value="#form.id_agenda#">
	<cfif h_modo neq 'ALTA'>
		<input type="hidden" name="id_horario" value="#data.id_horario#">
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="2" class="tituloMantenimiento"><font size="1"><cfif h_modo neq 'ALTA'>Modificar<cfelse>Agregar</cfif> Horario</font></td></tr>
		<tr>
			<td align="right">D&iacute;a:&nbsp;</td>
			<td>
				<select name="dia_semana">
					<option value="">-seleccionar-</option>
					<option value="1" <cfif h_modo neq 'ALTA' and h_data.dia_semana eq 1 >selected</cfif> >Domingo</option>
					<option value="2" <cfif h_modo neq 'ALTA' and h_data.dia_semana eq 2 >selected</cfif> >Lunes</option>
					<option value="3" <cfif h_modo neq 'ALTA' and h_data.dia_semana eq 3 >selected</cfif> >Martes</option>
					<option value="4" <cfif h_modo neq 'ALTA' and h_data.dia_semana eq 4 >selected</cfif> >Mi&eacute;rcoles</option>
					<option value="5" <cfif h_modo neq 'ALTA' and h_data.dia_semana eq 5 >selected</cfif> >Jueves</option>
					<option value="6" <cfif h_modo neq 'ALTA' and h_data.dia_semana eq 6 >selected</cfif> >Viernes</option>
					<option value="7" <cfif h_modo neq 'ALTA' and h_data.dia_semana eq 7 >selected</cfif> >S&acute;bado</option>
				</select>
			</td>
		</tr> 
		<tr>
			<td align="right">De:&nbsp;</td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%">
							<select name="hora_desde">
								<cfloop from="0" to="23" index="i">
									<cfset hora = RepeatString('0', 2-len(i)) & i> 
									<cfset hora1 = hora & ':00' > 
									<cfset hora2 = hora & ':30' > 
									<option value="#hora1#">#hora1#</option>
									<option value="#hora2#">#hora2#</option>
								</cfloop>
							</select>
						</td>
						<td width="1%" valign="middle">&nbsp;a&nbsp;</td>
						<td width="98%">
							<select name="hora_hasta">
								<cfloop from="0" to="23" index="i">
									<cfset hora = RepeatString('0', 2-len(i)) & i> 
									<cfset hora1 = hora & ':00' > 
									<cfset hora2 = hora & ':30' > 
									<option value="#hora1#">#hora1#</option>
									<option value="#hora2#">#hora2#</option>
								</cfloop>
							</select>
						</td>
					</tr>	
				</table> 
			</td>
		</tr>
		
		<tr>
			<td align="right">Requisito:&nbsp;</td>
			<td>
				<cfif h_modo neq 'ALTA'>
					<cfquery name="requisito" datasource="#session.tramites.dsn#">
						select id_requisito, codigo_requisito, nombre_requisito
						from TPRequisito
						where id_requisito = 1
					</cfquery>
					<cf_tprequisitos form="formh" query="#requisito#">
				<cfelse>	
					<cf_tprequisitos form="formh">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right">Cupo:&nbsp;</td>
			<td>
				<input type="text" name="cupo" value="<cfif h_modo NEQ 'ALTA'>#LSCurrencyFormat(h_data.cupo, 'none')#<cfelse>0</cfif>" tabindex="1" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
		</tr>
		
		<tr>
			<td colspan="2" align="center">
				<cfif h_modo neq 'ALTA'>
					<input type="submit" name="Modificar" value="Modificar" >
					<input type="submit" name="Eliminar" value="Eliminar" onClick=" return confirm('Desea eliminar el registro?');" >
					<input type="button" name="Nuevo" value="Nuevo" onClick="javascript: location.href='agenda.cfm?id_inst=#form.id_inst#&id_tiposerv=#form.id_tiposerv#'" >
				<cfelse>
					<input type="submit" name="Agregar" value="Agregar" >
				</cfif>
			</td>
		</tr>
	</table>

	<cfset ts = "">
	<cfif h_modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"></cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>
</cfoutput>

<!---
<script type="text/javascript" language="javascript1.2">
	function validar(f){
		var msj = '';
		
		if ( f.codigo_horario.value == '' ){
			msj = msj + ' - El campo Código es requerido.\n';
		}

		if ( f.nombre_horario.value == '' ){
			msj = msj + ' - El campo Nombre es requerido.\n';
		}

		if ( f.ubicacion.value == '' ){
			msj = msj + ' - El campo Ubicación es requerido.\n';
		}

		if ( msj != ''){
			msj = 'Se presentaron los siguientes errores:\n' + msj
			alert(msj);
			return false;
		}
		return true;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
</script>
--->