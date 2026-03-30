	
	<cfquery name="tipo" datasource="tramites_cr">
		select nombre_tipoident
		from TPTipoIdent
		where id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tipoident#">
	</cfquery>

	<cfoutput>
		<!---<table width="510" align="left" border="1" cellpadding="1" cellspacing="0" >--->
		<table width="98%" align="center" border="0" cellpadding="1" cellspacing="0" >
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Datos Personales</strong></td>
			</tr>
			<tr>
				<td>
					<table width="510" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td valign="top" width="78">
								<cfif Len(data.foto) GT 1>
									<cfinvoke component="sif.Componentes.DButils"
									method="toTimeStamp"
									returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
									</cfinvoke>
									<img align="middle" width="78" height="90" src="/cfmx/home/tramites/Operacion/gestion/foto_persona.cfm?s=#URLEncodedFormat(data.id_persona)#&amp;ts=#tsurl#" border="0" alt="foto" >
								<cfelse>
									<img align="middle"  width="78" height="90" src="/cfmx/home/public/not_avail.gif" border="0" alt="sin foto" >
								</cfif>
							</td>
							<td valign="top" width="432">
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td width="1%" nowrap><strong>Nombre:</strong>&nbsp;</td>
										<td>#data.nombre# #data.apellido1# #data.apellido2#</td>
									</tr>
									<tr>
										<td width="1%" nowrap><strong>#trim(tipo.nombre_tipoident)#:</strong>&nbsp;</td>
										<td>#data.identificacion_persona#</td>
									</tr>
									<tr>
										<td width="1%" nowrap><strong>Sexo:</strong>&nbsp;</td>
										<td><cfif data.sexo eq 'F'>Femenino<cfelse>Masculino</cfif></td>
									</tr>
									
									<form name="form2" method="post" action="datos-generales-sql.cfm" style="margin:0;" enctype="multipart/form-data">
										<input type="hidden" name="id_instancia" value="#form.id_instancia#">
										<input type="hidden" name="id_persona" value="#form.id_persona#">

										<tr>
											<td><strong>Foto:</strong></td>
											<td><input name="foto" type="file" id="foto" ><input type="submit" name="ModificarFoto" value="Modificar Foto"></td>
										</tr>
										
									</form>
									
									<!---
									<tr>
										<td></td>
										<td><input type="submit" name="Modificar" value="Modificar Datos Personales"></td>
									</tr>
									--->
								</table>

								<!---
								<table cellpadding="2" cellspacing="0" width="432">
									<tr>
										<td valign="top">
										#data.nombre# #data.apellido1# #data.apellido2#</td>
									</tr>
									<tr>
										<td valign="top">  
											<cfif len(trim(data.id_direccion))>
												<cf_tr_direccion key="#data.id_direccion#" action="display">
											</cfif>
										</td>
									</tr>
								</table>
								--->
							</td>
						</tr>
				  </table>
				</td>
			</tr>

			<tr><td>&nbsp;</td></tr>

			<tr>
				<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Informaci&oacute;n de Contacto</strong></td>
			</tr>
			
			<form name="form1" method="post" action="datos-generales-sql.cfm" style="margin:0;">
				<input type="hidden" name="id_instancia" value="#form.id_instancia#">
				<input type="hidden" name="id_persona" value="#form.id_persona#">
				<tr>
					<td>
						<table width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td width="1%" nowrap><strong>Telefono Casa:</strong>&nbsp;</td>
								<td><input type="text" name="casa" size="30" maxlength="30" value="#data.casa#" onFocus="javascript:this.select();"></td>
							</tr>
							<tr>
								<td width="1%" nowrap><strong>Telefono Oficina:</strong>&nbsp;</td>
								<td><input type="text" name="oficina" size="30" maxlength="30" value="#data.oficina#" onFocus="javascript:this.select();"></td>
							</tr>
							<tr>
								<td width="1%" nowrap><strong>Telefono Celular:</strong>&nbsp;</td>
								<td><input type="text" name="celular" size="30" maxlength="30" value="#data.celular#" onFocus="javascript:this.select();"></td>
							</tr>
							<tr>
								<td width="1%" nowrap><strong>Fax:</strong>&nbsp;</td>
								<td><input type="text" name="fax" size="30" maxlength="30" value="#data.fax#" onFocus="javascript:this.select();"></td>
							</tr>
							<tr>
								<td width="1%" nowrap><strong>Correo Electr&oacute;nico:</strong>&nbsp;</td>
								<td><input type="text" name="email" size="60" maxlength="60" value="#data.email1#" onFocus="javascript:this.select();"></td>
							</tr>
							
							<tr>
								<td></td>
								<td><input type="submit" name="Modificar" value="Modificar Datos Personales"></td>
							</tr>
						</table>
					</td>
				</tr>				
				
			</form>

			<tr><td>&nbsp;</td></tr>			
			
		</table>
	</cfoutput>
