<cfif not isdefined ("form.QPcteid") and isdefined ("url.QPcteid")>
	<cfset form.QPcteid = url.QPcteid>
</cfif>
<cfif isdefined("form.QPcteid") and len(trim(form.QPcteid))>
	<cfquery name="rsDato" datasource="#session.dsn#">
		select
				b.QPtipoCteDes,
				a.QPcteid, 
				a.QPtipoCteid, 
				a.QPcteDocumento, 
				a.QPcteNombre, 
				a.QPcteDireccion, 
				a.QPcteTelefono1,
				a.QPcteTelefono2, 
				a.QPcteTelefonoC, 
				a.QPcteCorreo, 
				a.BMusucodigo,
				a.BMFecha,
				a.ts_rversion 
			from QPcliente a
				inner join QPtipoCliente b
				on b.QPtipoCteid = a.QPtipoCteid
			where a.Ecodigo = #session.Ecodigo# 
			and  a.QPcteid=#form.QPcteid#
		order by a.QPcteNombre
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
<cfparam name="LvarCTEtipo" default="">
		<form action="QPassCliente_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); " onSubmit="return validar(this);"> 
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="right" nowrap>*<strong>Ident.:</strong>&nbsp;</td>
					<td align="left" nowrap="nowrap">
						<cfif modo EQ "ALTA"> 
							<select  tabindex="1" name="CTEtipo" onChange="cambiarMascara(this.value);">
								<cfloop query="rsTiposCliente">
									<option value="#rsTiposCliente.QPtipoCteid#">#rsTiposCliente.QPtipoCteDes#</option>
								</cfloop>
							</select>	
						<cfelse>
							<cfif modo NEQ 'ALTA'>#trim(rsDato.QPtipoCteDes)#</cfif>
						</cfif>
						<input tabindex="1" type="text" name="CTEidentificacion" size="30" value="<cfif modo NEQ "ALTA">#trim(rsDato.QPcteDocumento)#</cfif>" alt="Identificación"<cfif modo NEQ 'ALTA'>readonly=""</cfif>> 
					</td>
				</tr>
				<cfif modo EQ 'ALTA'>
				<tr>	
					<td>&nbsp;</td>
					<td align="center">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input  tabindex="-1" type="text" name="SNmask" size="30" readonly value="#LvarCTEtipo#" style="border:none;"> 
					</td>
				</tr>
				</cfif>
				<tr>
					<td align="right">*<strong>Cliente:</strong></td>
					<td colspan="3">
						<input type="text" name="QPcteNombre" maxlength="101" size="40" id="QPcteNombre" tabindex="1" style="border-spacing:inherit"  value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteNombre)#</cfif>"<cfif modo NEQ 'ALTA'>readonly=""</cfif>/> 
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Direcci&oacute;n:</strong></td>
					<td colspan="2">
						<textarea  
							cols="45" 
							rows="3" 
							name="QPcteDireccion" 
							maxlength="255" 
							tabindex="1"><cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteDireccion)#</cfif></textarea>
					</td>
				</tr>	
				<tr>
					<td align="right"><strong>Telefono:</strong></td>
					<td colspan="2">
						<input type="text" name="QPcteTelefono1" maxlength="21" size="20" id="QPcteTelefono1" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteTelefono1)#</cfif>" />
				</tr>					
				
				<tr>
					<td align="right"><strong>Tel. Cel:</strong></td>
					<td colspan="2">
						<input type="text" name="QPcteTelefono2" maxlength="21" size="20" id="QPcteTelefono2" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteTelefono2)#</cfif>" />
				</tr>	
				<tr>
					<td align="right"><strong>Tel. Casa:</strong></td>
					<td colspan="2">
						<input type="text" name="QPcteTelefonoC" maxlength="21" size="20" id="QPcteTelefonoC" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteTelefonoC)#</cfif>" />
				</tr>			
				<tr>
					<td align="right" nowrap="nowrap"><strong>Correo Electr&oacute;nico:</strong></td>
					<td colspan="2">
						<input type="text" name="QPcteCorreo" maxlength="101" size="40" id="QPcteCorreo" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteCorreo)#</cfif>" />
				</tr>	
				<tr>
				<td>&nbsp;</td>
					<td align="center">
						<iframe id="frInfoC" name="frInfoC" src="frInfoC.cfm" frameborder="1" height="0" width="0"  scrolling="no"></iframe>
					</td>
				 </tr>			
				<tr><td colspan="3"></td></tr>
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cf_botones modo="#modo#" tabindex="1">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<cfset ts = "">
						<cfif modo NEQ "ALTA">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsDato.ts_rversion#" returnvariable="ts">        
							</cfinvoke>
							<input type="hidden" name="QPcteid" value="#rsDato.QPcteid#" >
							<input type="hidden" name="ts_rversion" value="#ts#" >
							<cfelse>
							<input type="hidden" name="QPcteid" value="">
						</cfif>
					</td>
				</tr>
			</table>
		</form>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.QPcteNombre.description = "Cliente";
		objForm.CTEidentificacion.description = "Identificacin";
	function habilitarValidacion() 
	{
		objForm.QPcteNombre.required = true;
		objForm.CTEidentificacion.required = true;
	}
	function trim(dato) {
		return dato.replace(/^\s*|\s*$/g,"");
	}
	
	function validarEmail(valor) {
		if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(valor)){
			return (true)
		} 
		else {
			return (false);
		}
	}

	function  validar(){
		var error = false;
		var mensaje = 'Se presentaron los siguientes errores:\n';
			
			if ( trim(document.form1.QPcteCorreo.value) != '' ){
				if (validarEmail(document.form1.QPcteCorreo.value) == false){
					error = true;
					mensaje = mensaje + " - El correo electrónico no tiene un formato valido.\n";
				}
			}
		
		if (error){
			alert(mensaje);
			return false;
		}
		return true;	
	}
	
		<cfif modo EQ "ALTA">
			document.form1.CTEtipo.focus();
		</cfif>
	
		function funcCliente(){
			document.getElementById("frInfoC").src = "frInfoC.cfm?CTEidentificacion="+document.form1.CTEidentificacion.value+"&CTEtipo="+document.form1.CTEtipo.value;
		}
</script>
</cfoutput>
