<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst)) GT 0>
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select id_inst,
			   id_direccion,
			   codigo_inst,
			   nombre_inst,
			   liq_dias,
			   liq_banco,
			   liq_cuenta,
			   BMUsucodigo,
			   BMfechamod,
			   ts_rversion
		from TPInstitucion 
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	</cfquery>

	<cfquery name="tipos" datasource="#session.tramites.dsn#">
		select b.id_tipoinst as id, 
			   b.codigo_tipoinst as codigo, 
			   b.nombre_tipoinst as nombre
		from TPRTipoInst a
			inner join TPTipoInst b
				on b.id_tipoinst = a.id_tipoinst
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#"> 
		order by b.nombre_tipoinst
	</cfquery>

	<cfquery name="rsDireccion" datasource="#session.tramites.dsn#">
		select a.atencion, a.direccion1, a.direccion2, a.ciudad, a.estado, a.cod_postal, a.pais
		from TPDirecciones a
		where a.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.id_direccion#">
	</cfquery>

	<cfset ts = ""> 
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
	</cfinvoke>

	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="60%" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td colspan="2" class="tituloIndicacion">
						<font size="2" color="black"><strong>Instituci&oacute;n</strong></font>
					</td>
				  </tr>
				  <tr>
					<td valign="top" align="center" width="1%">
						<img src="../public/logo_inst.cfm?id_inst=#rsDatos.id_inst#&amp;ts=#ts#" height="80" id="logo_inst_preview">
					</td>
					<td valign="top">
						<table align="center" width="100%" cellpadding="2" cellspacing="0">
							<tr> 
								<td class="fileLabel" width="15%" align="right" nowrap>C&oacute;digo:</td>
								<td nowrap>
									#rsDatos.codigo_inst#
								</td>
							</tr>
							<tr> 
								<td class="fileLabel" align="right" nowrap>Descripci&oacute;n:</td>
								<td nowrap>
									#rsDatos.nombre_inst#
								</td>
							</tr>
						</table>
					</td>
				  </tr>
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				</table>
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td colspan="2" class="tituloIndicacion">
							<font size="2" color="black"><strong>Tipos de Instituci&oacute;n a las que pertenece</strong></font>
						</td>
					</tr>
					<cfloop query="tipos">
						<tr>
							<td align="right" class="fileLabel">#codigo#</td>
							<td>#nombre#</td>
						</tr>
					</cfloop>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
			  	</table>
			</td>
			<td valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td colspan="2" class="tituloIndicacion">
						<font size="2" color="black"><strong>Direcci&oacute;n</strong></font>
					</td>
				  </tr>
				  <tr>
					<td width="20%" class="fileLabel" align="right">Atencion a:</td>
					<td>#rsDireccion.atencion#&nbsp;</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">Direcci&oacute;n 1:</td>
					<td>#rsDireccion.direccion1#&nbsp;</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">Direcci&oacute;n 2:</td>
					<td>#rsDireccion.direccion2#&nbsp;</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">Ciudad:</td>
					<td>#rsDireccion.ciudad#&nbsp;</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">Estado:</td>
					<td>#rsDireccion.estado#&nbsp;</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">C&oacute;digo Postal:</td>
					<td>#rsDireccion.cod_postal#&nbsp;</td>
				  </tr>
				  <tr>
					<td class="fileLabel" align="right">Pa&iacute;s:</td>
					<td>
						<cfquery name="nombre_pais" datasource="asp">
							select Pnombre
							from Pais
							where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDireccion.pais#">
						</cfquery>
						#nombre_pais.Pnombre#&nbsp;
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</cfoutput>
	
</cfif>
