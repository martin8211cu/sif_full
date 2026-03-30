<cfquery name="rsTipoIdentificacion" datasource="#Attributes.Conexion#">
	select a.Ppersoneria, a.Pfisica, a.Pdescripcion, a.Pregex, a.PetiquetaCaptura
	from ISBtipoPersona a
	<cfif Attributes.readonly and isdefined('rsProspectoTag') and rsProspectoTag.Ppersoneria NEQ ''>
		where a.Ppersoneria = <cfqueryparam cfsqltype="cf_sql_char" value="#rsProspectoTag.Ppersoneria#">
	</cfif> 			
	order by a.Pdescripcion desc
</cfquery>
<cfoutput>
	<tr>
		<td align="right"><label>Personer&iacute;a</label></td>
		<td>
			<cfif Attributes.readonly>
				#HTMLEditFormat(Trim(rsTipoIdentificacion.Pdescripcion))#
				<input type="hidden" name="Ppersoneria" value="#HTMLEditFormat(Trim(rsTipoIdentificacion.Ppersoneria))#">
			<cfelse>
				<select name="Ppersoneria" onChange="javascript: validar_identificacion();esJuridica();" tabindex="1">
					<cfloop query="rsTipoIdentificacion">
						<option value="#rsTipoIdentificacion.Ppersoneria#"<cfif isdefined("rsPersona") and rsPersona.Ppersoneria EQ rsTipoIdentificacion.Ppersoneria> selected</cfif> >#rsTipoIdentificacion.Pdescripcion#</option>
					</cfloop>
				</select>
			</cfif> 					
		</td>
		<cfif Attributes.porFila></tr><tr></cfif>
		<td align="right"><label>Identificaci&oacute;n</label></td>
		<td <cfif not Attributes.porFila> coldspan="3"</cfif>>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<cfif Attributes.readonly>
						<input name="Pid" 
							readonly="true"
							type="text"
							style="border:0; font-style:italic; background-color: transparent;"/>			
					<cfelse>
						<input name="Pid" 
							onkeyup="javascript: validar_identificacion();" 
							onchange="javascript: validar_identificacion();" 
							onfocus="javascript: validar_identificacion();" 
							type="text"/>					
					</cfif> 	
				</td>
				<td nowrap>
					<img src="/cfmx/saci/images/Borrar01_S.gif" name="img_ident_mal" width="20" height="18" border="0" id="img_ident_mal" style="display:none">
					<img src="/cfmx/saci/images/check-verde.gif" name="img_ident_ok" width="20" height="18" border="0" id="img_ident_ok"  style="display:none">
					<img src="/cfmx/saci/images/blank.gif" name="img_blank" id="img_blank" width="20" height="18" border="0">
				</td>
				<td nowrap>
					<input type="text" id="explicar_mascara" name="explicar_mascara" style="border:0; font-style:italic; background-color: transparent;" size="45" tabindex="-1" readonly="true">
				</td>
			  </tr>
			</table>
		</td>
	</tr>
	<script language="javascript" type="text/javascript">
		TPTipoIdent_regex = {<cfloop query="rsTipoIdentificacion"><cfif Len(Trim(Pregex))>
			'#JSStringFormat(Ppersoneria)#':/#Pregex#/, </cfif></cfloop>
			dummy: 0
			};
		TPTipoIdent_mascaras = {<cfloop query="rsTipoIdentificacion"><cfif Len(Trim(Pregex))>
			'#JSStringFormat(Ppersoneria)#':'#JSStringFormat(PetiquetaCaptura)#', </cfif></cfloop>
			dummy: 0
			}

		function validar_identificacion() {
			var f = document.forms.#Attributes.form#;
			if (!(f && f.Pid)) return;
			// regresa true si la identificacion es valida o si no esta restringida
			var ident = f.Pid.value;
			var tipoid = f.Ppersoneria.value;
			var mascara = TPTipoIdent_regex[tipoid];
			var imal = document.all ? document.all.img_ident_mal : document.getElementById('img_ident_mal');
			var iok = document.all ? document.all.img_ident_ok : document.getElementById('img_ident_ok');
			var iblank = document.all ? document.all.img_blank : document.getElementById('img_blank');
			iok.style.display  = ident.length && mascara && mascara.test(ident) ? '' : 'none';
			imal.style.display = ident.length && mascara && !mascara.test(ident) ? '' : 'none';
			iblank.style.display = ident.length ? 'none' : '';
			f.explicar_mascara.value = TPTipoIdent_mascaras[tipoid]?'Capturar como: '+TPTipoIdent_mascaras[tipoid]:'';
			return (!mascara) || mascara.test(ident);
		}
		validar_identificacion();
	</script>
	
</cfoutput>
