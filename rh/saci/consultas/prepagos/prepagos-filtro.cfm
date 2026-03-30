<form action="prepagos.cfm" method="post" name="form1" id="form1" style="margin:0">
	<cfoutput>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>	
		  <tr>
			<td colspan="2">
				<cfset agente = "">
				<cfif isdefined('form.Pquien_F') and form.Pquien_F NEQ ''>
					<cfset agente = Form.Pquien_F>
				</cfif>
				<cf_identificacion
					id = "#agente#"
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
				>				
			</td>
			<td colspan="3">
				<input name="Nombre" class="cajasinbordeb" type="text" id="Nombre" value="<cfif isdefined('form.Nombre') and form.Nombre NEQ ''>#form.Nombre#</cfif>" size="70" maxlength="70" readonly>
			</td>
		  </tr>
		  <tr>
			<td align="right">Tarjeta:</td>
			<td>
				<cfset idTar = "">
				<cfif isdefined('form.TJid_F') and form.TJid_F NEQ ''>
					<cfset idTar = Form.TJid_F>
				</cfif>			
				<cf_prepago sufijo = "_F" id = "#idTar#">
			</td>
		  <td align="right">Estado:</td>
		  <td><select name="TJestado_F" id="TJestado_F">
            <option value="NI" <cfif isdefined('form.TJestado_F') and form.TJestado_F EQ 'NI'> selected</cfif>>No Importa</option>
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
	</cfoutput>		
</form>

<script language="javascript" type="text/javascript">
	function CargarAgente(){
		formatMascara_F();		//funcion que se encuentra en el tag de identificacion, se usa para dar formato a la identificacion dependiendo de la personeria. Se ejecuta al traer un nuevo identificador.
		document.form1.Nombre.value = document.form1.nom_razonp_F.value;
	}
</script>