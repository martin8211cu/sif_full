<cfif isdefined("url.id_persona") and len(trim(url.id_persona))>
	<cfquery name="persona" datasource="tramites_cr">
		select identificacion_persona, nombre, apellido1, apellido2
		from TPPersona
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	</cfquery>
</cfif>

<cfquery name="rsTramites" datasource="tramites_cr">
	select fecha_inicio, nombre_tramite, it.id_tramite, it.id_instancia, it.id_persona
	from TPInstanciaTramite it 
	left outer join TPTramite t
	  on it.id_tramite = t.id_tramite
	where id_persona = <cfif isdefined("url.id_persona") and len(trim(url.id_persona))><cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#"><cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.user#"></cfif>
	  and completo = 0
</cfquery>


<cfinvoke component="home.tramites.componentes.tramites"
	method="permisos_obj"
	id_funcionario="#session.tramites.id_funcionario#"
	tipo_objeto="T"
	returnvariable="tramites_validos" >
</cfinvoke>

	<cfquery name="combotramite" datasource="tramites_cr">
		select t.id_tramite, t.codigo_tramite, t.nombre_tramite,
			i.id_inst, i.nombre_inst
		from TPTramite t
			join TPInstitucion i
				on t.id_inst = i.id_inst
		<cfif Len(tramites_validos)>
		where id_tramite in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#tramites_validos#" list="yes">)
		<cfelse>
		where 1=0
		</cfif>
		order by i.nombre_inst, i.id_inst, t.codigo_tramite, t.id_tipotramite
	</cfquery>

<table width="530" align="center"  style=" border:1px solid #595959 ">
	<tr><td bgcolor="#595959"><font size="2" color="#FFFFFF" face="Geneva, Arial, Helvetica, sans-serif"><strong>Iniciar Tr&aacute;mites</strong></font></td></tr>
	<tr>
		<td>
			<table width="515" align="center" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="3" align="center" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15"><div align="left"><b>Seleccionar Tr&aacute;mite</b></div></td>
				</tr>
				<cfoutput>
				<form name="form1" method="post" action="nuevo-sql.cfm" style="margin:0;">
				<input type="hidden" name="id_persona" value="#url.id_persona#">
				<tr>
					<td colspan="3">
						<!---
						<cfquery name="combotramite" datasource="tramites_cr">
							select t.id_tramite, t.codigo_tramite, t.nombre_tramite,
								i.id_inst, i.nombre_inst
							from TPTramite t
								join TPInstitucion i
									on t.id_inst = i.id_inst
							order by i.nombre_inst, i.id_inst, t.codigo_tramite, t.id_tipotramite
						</cfquery>
						---->

						<select name="id_tramite" <cfif isdefined("url.noexistepersona")>onFocus="javascript: document.getElementById('error1').style.display='none';"</cfif> >
							<option value="" >- seleccionar -</option>
							<cfset c_inst="">
							<cfloop query="combotramite">
								<cfif (c_inst neq id_inst) or CurrentRow EQ 1>
									<cfif CurrentRow NEQ 1>
										</optgroup>
									</cfif>
									<cfset c_inst = id_inst>
									<optgroup label="#HTMLEditFormat(nombre_inst)#">
								</cfif>
								<option value="#id_tramite#" <cfif isdefined("url.id_tramite") and url.id_tramite eq combotramite.id_tramite>selected</cfif> >
									#trim(HTMLEditFormat(codigo_tramite))# - #HTMLEditFormat(nombre_tramite)#
							  </option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr><td><input type="submit" name="procesar" value="Iniciar"></td></tr> 
				</form>
				</cfoutput>
				
				<!---
				<cfif rsTramites.recordcount gt 0>
				<cfoutput query="rsTramites">
					<tr> 
						<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="left"><a style="color:##666666" href="/cfmx/bancovirtual/ventanilla/tramite.cfm?id_persona=#rsTramites.id_persona#&id_instancia=#rsTramites.id_instancia#&id_tramite=#rsTramites.id_tramite#">#rsTramites.nombre_tramite#</a></div></td>
						<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="center"><a style="color:##666666" href="/cfmx/bancovirtual/ventanilla/tramite.cfm?id_persona=#rsTramites.id_persona#&id_instancia=#rsTramites.id_instancia#&id_tramite=#rsTramites.id_tramite#">#LSDateFormat(rsTramites.fecha_inicio,'dd/mm/yyyy')#</a></div></td>
						<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="center"><a style="color:##666666" href="/cfmx/bancovirtual/ventanilla/tramite.cfm?id_persona=#rsTramites.id_persona#&id_instancia=#rsTramites.id_instancia#&id_tramite=#rsTramites.id_tramite#"><img src="../images/bullet_flecha2.gif" border="0"></a></div></td>
					</tr>
				</cfoutput>
				<cfelse>	
					<tr> 
						<td align="center" colspan="3" bgcolor="" class="bajada" height="15" id=color7><div align="left">No existen tramites pendientes</div></td>
					</tr>
				</cfif>
				--->
			</table> 
		</td>
	</tr>
</table>