<cfquery datasource="#session.tramites.dsn#" name="rsTPTipoIdent">
	select id_tipo, id_vista_ventanilla as id_vista, nombre_tipoident, es_fisica
	from TPTipoIdent
	where id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tipoident#">
</cfquery>

	<cfoutput>

<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="50%" valign="top">


		<table width="98%" align="center" border="0" cellpadding="1" cellspacing="0" >
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
										<td width="1%" nowrap><strong>#trim(rsTPTipoIdent.nombre_tipoident)#:</strong>&nbsp;</td>
										<td>#data.identificacion_persona#</td>
									</tr>
									<tr>
										<td width="1%" nowrap><strong>Fecha de Nacimiento:</strong>&nbsp;</td>
										<td>#DateFormat( data.nacimiento , 'dd/mm/yyyy' )#</td>
									</tr>
									<tr>
										<td width="1%" nowrap><strong>Sexo:</strong>&nbsp;</td>
										<td><cfif data.sexo eq 'F'>Femenino<cfelse>Masculino</cfif></td>
									</tr>
									
									<form name="form2" method="post" action="datos-generales-sql.cfm" style="margin:0;" enctype="multipart/form-data">
										<input type="hidden" name="id_instancia" value="#form.id_instancia#">
										<input type="hidden" name="id_persona" value="#form.id_persona#">

										<tr>
											<td valign="top"><strong>Foto:</strong></td>
											<td valign="top"><input name="foto" type="file" id="foto" ><input type="submit" name="ModificarFoto" value="Modificar Foto"></td>
										</tr>
										
									</form>
								</table>
							</td>
						</tr>
				  </table>
				</td>
			</tr>

			<tr><td>&nbsp;</td></tr>

			<tr>
				<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Informaci&oacute;n de Contacto</strong></td>
			</tr>
			
				<tr>
					<td>
					<cfinclude template="../../vistas/datos-generales-ventanilla.cfm">
					</td>
				</tr>		

			<tr><td>&nbsp;</td></tr>			
			
		</table>
		
</td>
    <td width="50%" valign="top">
	
	<cfinclude template="lugares-tramite.cfm">
	
	
	</td>
  </tr>
</table>
	</cfoutput>
