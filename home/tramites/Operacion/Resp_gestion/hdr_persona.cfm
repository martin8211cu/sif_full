<cfif isdefined("url.id_persona") and not isdefined("form.id_persona")>
	<cfparam name="form.id_persona" default="#url.id_persona#">
</cfif>

<cfif isdefined("form.id_persona") and len(trim(form.id_persona))>
	<cfquery name="data" datasource="#session.tramites.dsn#">
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
		<table width="100%" align="center" border="0" cellpadding="3" cellspacing="0" >
			<tr>
				<td colspan="4" class="subTitulo">Datos Personales </td>
			</tr>
	
			<tr>
				<td colspan="2" valign="top">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td width="1%" valign="middle" nowrap><strong>C&eacute;dula:&nbsp;</strong></td>
							<td valign="middle">#trim(data.id_persona)#
								<input name="id_persona" type="hidden" value="#data.id_persona#">
							</td>
						</tr>
						<tr>
							<td valign="middle"><strong>Nombre:&nbsp;</strong></td>
							<td valign="middle">#data.nombre# #data.apellido1# #data.apellido2#</td>
						</tr>
						<!---
						<tr>
							<td valign="middle"><strong>Direcci&oacute;n:&nbsp;</strong></td>
							<td valign="middle">#data.direccion#</td>
						</tr>
						--->
						<tr>
							<td>
								<cfif Len(data.foto) GT 1>
									<cfinvoke component="sif.Componentes.DButils"
									method="toTimeStamp"
									returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
									</cfinvoke>
									<img align="middle" width="78" height="90" src="/cfmx/home/tramites/Operacion/gestion/foto_persona.cfm?s=#URLEncodedFormat(data.id_persona)#&amp;ts=#tsurl#" border="0" >
								<cfelse>
									<img align="middle"  width="78" height="90" src="/cfmx/home/public/not_avail.gif" border="0" >
								</cfif>

							</td>
							<td>
								<cf_tr_direccion key="#data.id_direccion#" action="display">
							</td>
						</tr>
					</table>
				</td>
			</tr>
	
			<tr>
				<td colspan="4" class="subTitulo">&nbsp;</td>
			</tr>
		</table>
	</cfoutput>
</cfif>