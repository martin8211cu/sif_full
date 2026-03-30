<cfquery name="rsEntidades" datasource="#Attributes.Conexion#">
	select rtrim(a.EFid) as EFid, a.EFnombre
	from ISBentidadFinanciera a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	and a.Habilitado = 1
	order by a.EFnombre, a.EFid
</cfquery>

<cfif ExisteCuenta>

	<cfquery name="rsCobroCuenta" datasource="#Attributes.Conexion#">
		select CTid, CTcobro, CTtipoCtaBco, CTbcoRef, CTmesVencimiento, CTanoVencimiento, CTverificadorTC, EFid, MTid, PpaisTH, CTcedulaTH, CTnombreTH, CTapellido1TH, CTapellido2TH, BMUsucodigo
		from ISBcuentaCobro 
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val(rsCuenta.CTid)#">
	</cfquery>
	
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<cfif ExisteCuenta>
			<tr><td  width="100"align="#Attributes.alignEtiquetas#" nowrap><label>Forma de Cobro</label></td>
				<td>
					<cfif rsCobroCuenta.CTcobro EQ "4">
						Cuenta Corriente RACSA
					<cfelseif rsCobroCuenta.CTcobro EQ "2">
						Descargo autom&aacute;tico a tarjeta
					<cfelseif rsCobroCuenta.CTcobro EQ "3">
						Pago autom&aacute;tico de recibos 
					</cfif>
				</td>
				<td></td>
				<td></td>
			  </tr>
		  	<cfif rsCobroCuenta.CTcobro EQ "2">
			<tr><td width="100%" colspan="2">
					
					<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0>
						<cfquery name="rsDatosTarjeta" datasource="#Attributes.Conexion#">
							select CTbcoRef as NumTarjeta,
								CTmesVencimiento as MesTarjeta,
								CTanoVencimiento as AnoTarjeta,
								CTverificadorTC as VerificaTarjeta,
								PpaisTH as Ppais,
								MTid as MTid,
								CTcedulaTH as CedulaTarjeta,
								CTnombreTH as NombreTarjeta ,
								CTapellido1TH as Apellido1Tarjeta,
								CTapellido2TH as Apellido2Tarjeta
							from ISBcuentaCobro 
							where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.CTid#">
						</cfquery>
						
						<cf_tarjeta 
							query="#rsDatosTarjeta#"
							readOnly="true"
							form="#Attributes.form#"
							sufijo="#Attributes.sufijo#">
					</cfif>
				</td>
			</tr>
			</cfif>
			 
			<cfif rsCobroCuenta.CTcobro EQ "3"> 
				<tr>
					<td colspan="2" width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
							<tr>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Banco</label></td>
								<td>
									<cfif isdefined("rsCobroCuenta") and rsCobroCuenta.RecordCount GT 0>
										<cfset id_entidad = rsCobroCuenta.EFid>
										<cf_entidad
											id="#id_entidad#"
											readOnly="true"
										>			
									<cfelse>
										 &lt;No Especificado&gt;
									</cfif>	
								</td>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Tipo Cuenta</label></td>
								<td>
									<cfif rsCobroCuenta.CTtipoCtaBco EQ "C">
										Corriente
									<cfelseif rsCobroCuenta.CTtipoCtaBco EQ "A">
										Ahorro
									</cfif>	
								</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>N&uacute;m. Cuenta</label></td>
								<td>
									<cfif len(trim(rsCobroCuenta.CTbcoRef))>
										#rsCobroCuenta.CTbcoRef#
									</cfif>
								</td>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>C&eacute;dula</label></td>
								<td>
									<cfif len(trim(rsCobroCuenta.CTcedulaTH))>
										#rsCobroCuenta.CTcedulaTH#
									<cfelse>
										&lt;No Especificado&gt;
									</cfif>
								</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Nombre</label></td>
								<td>
									<cfif len(trim(rsCobroCuenta.CTnombreTH))>
										#rsCobroCuenta.CTnombreTH#
									</cfif>
								</td>
								<td align="#Attributes.alignEtiquetas#" nowrap><label>Apellidos</label></td>
								<td>
									<cfif len(trim(rsCobroCuenta.CTapellido1TH))>
										#rsCobroCuenta.CTapellido1TH#
									</cfif>
								</td>
								<td>
									<cfif len(trim(rsCobroCuenta.CTapellido2TH))>
										#rsCobroCuenta.CTapellido2TH#
									</cfif>
								</td>
							</tr>
						</table>
								
					</td>
				</tr>
			</cfif>
		<cfelse>
			<tr><td>&nbsp;</td></tr>	
		</cfif>
	</table>
</cfoutput>