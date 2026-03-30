<cfif isdefined("url.id_persona") and not isdefined("form.id_persona")>
	<cfparam name="form.id_persona" default="#url.id_persona#">
</cfif>

<cfif isdefined("form.id_persona") and len(trim(form.id_persona))>
	<cfquery name="data_persona" datasource="#session.tramites.dsn#">
		select 	p.id_persona,
				p.id_tipoident, 
			   	p.id_direccion, 
				p.identificacion_persona, 
				p.nombre, 
				p.apellido1, 
				p.apellido2, 
				p.nacimiento, 
				p.sexo, 
				p.casa, 
				p.oficina, 
				p.celular, 
				p.fax, 
				p.email1, 
				p.foto, 
				p.nacionalidad, 
				p.extranjero,
				coalesce(d.direccion1, d.direccion2) as direccion,
				p.ts_rversion
		from TPPersona p
		left join TPDirecciones d
		on p.id_direccion = d.id_direccion		
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	</cfquery>

	<cfoutput>
		<!---<table width="510" align="left" border="1" cellpadding="1" cellspacing="0" >--->
		<table width="100%" align="left" border="0" cellpadding="1" cellspacing="0" >
			<tr>
				<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Datos Personales</strong></td>
			</tr>
			<tr>
				<td>
					<table width="510" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td valign="top" width="78">
								<cfif Len(data_persona.foto) GT 1>
									<cfinvoke component="sif.Componentes.DButils"
									method="toTimeStamp"
									returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#data_persona.ts_rversion#"/>
									</cfinvoke>
									<img align="middle" width="78" height="90" src="/cfmx/home/tramites/Operacion/gestion/foto_persona.cfm?s=#URLEncodedFormat(data_persona.id_persona)#&amp;ts=#tsurl#" border="0" alt="foto" >
								<cfelse>
									<img align="middle"  width="78" height="90" src="/cfmx/home/public/not_avail.gif" border="0" alt="sin foto" >
								</cfif>
							</td>
							<td valign="top" width="432">
								<table cellpadding="2" cellspacing="0" width="432">
									<tr>
										<td valign="top">
										#data_persona.nombre# #data_persona.apellido1# #data_persona.apellido2#</td>
									</tr>
									<tr>
										<td valign="top">  
											<cfif len(trim(data_persona.id_direccion))>
												<cf_tr_direccion key="#data_persona.id_direccion#" action="display">
											</cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
				  </table>
				</td>
			</tr>
		</table>
	</cfoutput>
</cfif>