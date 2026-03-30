	<cfquery name="data" datasource="#session.DSN#">
		select DEid, 
			   RHOid,
			   RHCdescalifica,
			   RHCrazondeacalifica
		from RHConcursantes 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCPid#">
	</cfquery>

	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
		<cfoutput>
			<form action="Evaluaciones-SQL.cfm" method="post" name="formDescalifica" style="margin:0; " onSubmit="return validar(this);">
				<cfif len(trim(data.DEid))>
					<cfquery name="nombre" datasource="#session.DSN#">
						select DEidentificacion as identificacion, DEnombre as nombre, DEapellido1 as apellido1, DEapellido2 as apellido2
						from DatosEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DEid#">
					</cfquery>
				<cfelse>
					<cfquery name="nombre" datasource="#session.DSN#">
						select RHOidentificacion as identificacion, RHOnombre as nombre, RHOapellido1 as apellido1, RHOapellido2 as apellido2
						from DatosOferente
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHOid#">
					</cfquery>
				</cfif>
				
				<tr>
					<td width="35%">&nbsp;</td>
					<td width="20%" align="right"><strong>Concursante:</strong>&nbsp;</td>
					<td>#nombre.nombre# #nombre.apellido1# #nombre.apellido2#</td>
				</tr>

				<tr>
					<td width="7%">&nbsp;</td>
					<td width="20%" align="right"><strong>Identificaci&oacute;n:&nbsp;</strong></td>
					<td width="73%" colspan="3">#nombre.identificacion#</td>
				</tr>
				<tr>
					<td width="7%">&nbsp;</td>
					<td align="right" valign="top"><strong>Justificaci&oacute;n:&nbsp;</strong></td>
					<td colspan="2" width="20%">
						<textarea name="RHCrazondeacalifica" id="RHCrazondeacalifica" rows="6" cols="50" ><cfif len(trim(data.RHCrazondeacalifica))>#trim(data.RHCrazondeacalifica)#</cfif></textarea>
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td colspan="5" align="center">
						<input type="submit" name="Descalificar" <cfif data.RHCdescalifica eq 0 >onClick="javascript: return confirm('Desea descalificar al concursante?');"</cfif> value="<cfif data.RHCdescalifica eq 0 >Descalificar<cfelse>Modificar</cfif>">
						<input type="button" name="Regresar" value="Regresar" onClick="javascript:regresar();" >
					</td>
				</tr>	

				<input name="RHCPid" type="hidden" value="#form.RHCPid#">
				<input name="RHCconcurso" type="hidden" value="#form.RHCconcurso#">
			</form>
		</cfoutput>
	</table>

	<script type="text/javascript" language="javascript1.2">
		function validar(f){
			var error='';
			
			if ( f.RHCrazondeacalifica.value == '' ){
				error = ' - El campo Justificación es requerido.';
			}
			
			if (error != '' ){
				alert( 'Se presentaron los siguientes errores:\n' + error )
				return false;
			}
			
			return true;
		}

		function regresar(){
			document.formDescalifica.onSubmit='';
			document.formDescalifica.action = 'RegistroEval.cfm';
			document.formDescalifica.submit();
		}
	</script>