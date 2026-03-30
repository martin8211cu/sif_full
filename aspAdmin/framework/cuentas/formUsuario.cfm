<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">

<!-- Establecimiento del modo -->
<!--- se supone que este mantenimento siempre entra en cambio, a no ser qeu se llame desde otro lado--->
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA' >
	<cfquery name="rsForm" datasource="sdc">
		select convert(varchar, Usucodigo) as Usucodigo, Ulocalizacion, Pnombre, Papellido1, Papellido2, TIcodigo,  Pid, Psexo, Pdireccion, Ppais, 
			   isnull(Poficina, '') as Poficina, Pcelular, Pcasa, isnull(Pfax, '') as Pfax, Ppagertel, 
			   Ppagernum, Pemail1, Pemail2, convert(varchar, Pnacimiento, 103) as Pnacimiento
		from Usuario
		where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
	</cfquery>
</cfif>

<cfquery name="rsPais" datasource="sdc">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsIdentificacion" datasource="sdc">
	select TIcodigo, TInombre 
	from TipoIdentificacion
</cfquery>

<cfoutput>

<form name="form1" method="post" action="SQLUsuario.cfm">
	<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">
	<cfif isdefined("form.Usucodigo") and isdefined("form.Ulocalizacion")>
		<input type="hidden" name="Usucodigo" value="#form.Usucodigo#">
		<input type="hidden" name="Ulocalizacion" value="#form.Ulocalizacion#">
	</cfif>
<table border="0" cellpadding="0" cellspacing="0" width="100%">

	<tr class="itemtit"><td colspan="2"><font size="2"><b>Datos del Administrador Empresarial</b></font></td></tr>	
	<tr>
		<td width="1%">&nbsp;</td>
		<td valign="top" width="100%">
			<table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">

				<tr>
					<td colspan="3" class="subTitulo"><div align="center">Identificaci&oacute;n</div></td>
				</tr>

				<tr>
					<td class="etiqueta">Nombre</td>
					<td class="etiqueta">Apellidos</td>
				</tr>
				
				<tr>
					<td width="1%" ><input name="Pnombre" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pnombre)#</cfif>" size="30" maxlength="60" onFocus="this.select()" ></td>
					<td width="1%">
						<input name="Papellido1" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Papellido1)#</cfif>" size="30" maxlength="60" onFocus="this.select()" >
					</td>
					<td width="1%">
						<input name="Papellido2" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Papellido2)#</cfif>" size="30" maxlength="60" onFocus="this.select()" >
					</td>

				</tr>
				
				<tr>
					<td colspan="3">Identificaci&oacute;n</td>
				</tr>
				
				<tr>
					<td >
						<select name="TIcodigo">
							<cfloop query="rsIdentificacion">
								<option value="#rsIdentificacion.TIcodigo#" <cfif modo neq 'ALTA' and  rsForm.TIcodigo eq rsIdentificacion.TIcodigo>selected</cfif> >#rsIdentificacion.TInombre#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<input name="Pid" type="text" value="<cfif modo neq 'ALTA'>#rsForm.Pid#</cfif>" size="30" maxlength="60" onFocus="this.select()" >
					</td>
				</tr>
				
				<tr>
					<td colspan="2">Sexo</td>
					<td >Fecha de Nacimiento</td>
				</tr>

				<tr>
					<td colspan="2">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="1%"><input type="radio" name="Psexo" value="M" <cfif modo neq 'ALTA' and rsForm.Psexo eq 'M'>checked<cfelse>checked</cfif>  onFocus="this.select()" ></td>
								<td>Masculino</td>
								<td width="1%"><input type="radio" name="Psexo" value="F" <cfif modo neq 'ALTA' and rsForm.Psexo eq 'F'>checked</cfif>  onFocus="this.select()" ></td>
								<td>Femenino</td>
							</tr>
						</table>
					</td>

					<td>
						<cfif modo neq 'ALTA'><cfset value = rsForm.Pnacimiento><cfelse><cfset value = ""></cfif>
						<cf_sifcalendario name="Pnacimiento" value="#value#">
					</td>	
				</tr>

				<tr><td>&nbsp;</td></tr>


				<tr>
					<td colspan="3" class="subTitulo" ><div align="center">Ubicaci&oacute;n</div></td>
				</tr>


				<tr>
					<td colspan="3" >
						<table width="100%" border="0" align="left" cellpadding="1" cellspacing="1">
							<tr>
								<td colspan="3">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td>Pa&iacute;s</td>
											<td>&nbsp;</td>
											<td>Direcci&oacute;n</td>
										</tr>
										<tr>
											<td valign="top" >
												<select name="Ppais">
													<cfloop query="rsPais">
														<option value="#rsPais.Ppais#" <cfif modo neq 'ALTA' and  rsForm.Ppais eq rsPais.Ppais>selected</cfif> >#rsPais.Pnombre#</option>
													</cfloop>
												</select>
											</td>
											
											<td width="1%">&nbsp;</td>

											<td>
												<textarea name="Pdireccion" cols="40" rows="3" ><cfif modo neq 'ALTA'>#trim(rsForm.Pdireccion)#</cfif></textarea>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								<td colspan="2" >
									<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
											<td height="21" colspan="2" class="subTitulo" ><div align="center">Otros Datos</div></td>
										</tr>
										
										<tr>
											<td >Tel. Oficina</td>
											<td >Tel. Celular</td>
										</tr>
										
										<tr>
											<td><input name="Poficina" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Poficina)#</cfif>" size="50" maxlength="30" onFocus="this.select()" ></td>
											<td><input name="Pcelular" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pcelular)#</cfif>" size="50" maxlength="30" onFocus="this.select()" ></td>
										</tr>
										
										<tr>
											<td>Tel. Habitaci&oacute;n</td>
											<td>Tel. Fax</td>
										</tr>
										
										<tr>
											<td><input name="Pcasa" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pcasa)#</cfif>" size="50" maxlength="30" onFocus="this.select()" ></td>
											<td><input name="Pfax" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pfax)#</cfif>" size="50" maxlength="30" onFocus="this.select()" ></td>
										</tr>
										
										<tr>
											<td >Email (*)</td>
											<td >Email adicional</td>
										</tr>
										
										<tr>
											<td><input name="Pemail1" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pemail1)#</cfif>" size="50" maxlength="60" onFocus="this.select()" ></td>
											<td><input name="Pemail2" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pemail2)#</cfif>" size="50" maxlength="60" onFocus="this.select()" ></td>
										</tr>
										
									</table>
								</td>
							</tr>

						</table>
					</td>
				</tr>

			</table>
		</td>
		
		<td width="5%" valign="top">&nbsp;</td>

		<td width="1%"></td>

	</tr>
	
	<tr>
		<td colspan="5" align="center">
			<cfinclude template="../../portlets/pBotones.cfm">
			<input type="button" name="Regresar" value="Regresar" onClick="javascript:regresar();">
		</td>
	</tr>
	
</table>
</form>
</cfoutput>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Pnombre.required    = true;
	objForm.Pnombre.description = "Nombre";

	objForm.TIcodigo.required    = true;
	objForm.TIcodigo.description = "Tipo de Identificación";

	objForm.Pid.required    = true;
	objForm.Pid.description = "Identificación";

	objForm.Ppais.required    = true;
	objForm.Ppais.description = "País";
	
	function regresar(){
		document.form1.action = 'listaAdmin.cfm';
		document.form1.submit();
	}
	
	function deshabilitarValidacion(){
		objForm.Pnombre.required  = false;
		objForm.TIcodigo.required = false;
		objForm.Pid.required      = false;
	}
	
</script>