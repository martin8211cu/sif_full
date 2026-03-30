<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfoutput>
	<form action="prepagos.cfm" method="post" name="form1" id="form1" style="margin:0">
		<input type="hidden" name="AGid" value="#session.saci.agente.id#" />
			<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>	
			  <tr>
				<td width="50%" colspan="2">
					<cf_identificacion
						id = "#session.saci.persona.id#"
						form = "form1"
						incluyeTabla = "true"
						alignEtiquetas = "right"					
						colspan = "4"
						porFila = "false"
						filtrarPersoneria = ""
						soloAgentes = "true"
						sufijo = "_F"
						ocultarPersoneria = "true"
						editable = "false"
						funcion = "CargarAgente"
						Ecodigo = "#session.Ecodigo#"
						Conexion = "#session.DSN#"
						readOnly = "true"
					>
				</td>
				<td colspan="3">
					<input name="Nombre" readonly="true" type="text" id="Nombre" value="<cfif isdefined('form.Nombre') and form.Nombre NEQ ''>#form.Nombre#</cfif>" size="50" maxlength="50" class="cajasinbordeb" style="" tabindex="-1">
				</td>
			  </tr>
			  <tr>
				<td align="right"><strong>Tarjeta</strong></td>
				<td>
					<cfset idTar = "">
					<cfif isdefined('form.TJid_F') and form.TJid_F NEQ ''>
						<cfset idTar = Form.TJid_F>
					</cfif>			
					<cf_prepago sufijo="_F" id="#idTar#" agente="AGid">
				</td>
			  <td align="right"><strong>Estado</strong></td>
			  <td><select name="TJestado_F" id="TJestado_F">
				<option value="NI" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'NI'> selected</cfif>>(Todos)</option>
				<option value="CE" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'CE'> selected</cfif>>Cerrada</option>
				<option value="AC" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'AC'> selected</cfif>>Activa</option>			
				<option value="A" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'A'> selected</cfif>>Anulada</option>			
				<option value="B" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'B'> selected</cfif>>Bloqueada</option>
				<option value="C" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'C'> selected</cfif>>Consumida</option>
				<option value="U" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'U'> selected</cfif>>En Uso</option>
				<option value="L" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'L'> selected</cfif>>Liquidada</option>
				<option value="SL" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'SL'> selected</cfif>>Sin Liquidar</option>
				<option value="V" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'V'> selected</cfif>>Vencida</option>
			  </select></td>
			  <td align="center">
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
			  </td>
			  </tr>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>			  
			</table>
	</form>
</cfoutput>		

<script language="javascript" type="text/javascript">
	function CargarAgente(){
		formatMascara_F();	//funcion que se encuentra en el tag de identificacion, se usa para dar formato a la identificacion dependiendo de la personeria. Se ejecuta al traer un nuevo identificador.
		document.form1.Nombre.value = document.form1.nom_razonp_F.value;
	}
	CargarAgente();
</script>