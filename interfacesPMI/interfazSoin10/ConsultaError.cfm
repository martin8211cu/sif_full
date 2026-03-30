<title>Lista de errores</title>
<cf_templatecss>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de errores'>
	<cfif isdefined("Url.ID") and len(Url.ID)>
		<cfquery name="rsQuery" datasource="sifinterfaces">
			select 
				case Modulo when 'CC' then 'Documento Para Cuentas Por Cobrar' when 'CP' then 'Documento Para Cuentas Por Pagar' end as ModuloL,
				CodigoTransacion,
				Documento,
				CodigoMoneda,
				FechaDocumento,
				CodigoOficina,
				FechaVencimiento,
				NumeroSocio,
				CodigoRetencion,
				CuentaFinanciera,
				CodigoConceptoServicio,
				CodigoDireccionEnvio,
				CodigoDireccionFact
			from IE10 
			where EcodigoSDC  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#">
			and ID  = #Url.ID#
		</cfquery>
	
	
		<cfquery name="rsError" datasource="sifinterfaces">
			select 
				UsuarioBdInclusion,coalesce(MsgError,'Sin definir') as  MsgError
			from InterfazBitacoraProcesos 
			where IdProceso  = #Url.ID#
			and MsgError is not null
		</cfquery>
		<cfoutput>
			<table width="100%" border="0">
				<tr bgcolor="##CCCCCC">
					<td colspan="4" align="center"><strong>#trim(rsQuery.ModuloL)#</strong></td>
				</tr>
				<tr>
					<td><strong>Transacci&oacute;n</strong></td>
					<td>#rsQuery.CodigoTransacion#</td>
					<td><strong>Documento</strong></td>
					<td>#rsQuery.Documento#</td>
				</tr>
				<tr>
					<td><strong>Moneda</strong></td>
					<td>#rsQuery.CodigoMoneda#</td>
					<td><strong>Oficina</strong></td>
					<td>#rsQuery.CodigoOficina#</td>
				</tr>
				<tr>
					<td><strong>Fecha Documento</strong></td>
					<td>#LSDateformat(rsQuery.FechaDocumento,'dd/mm/yyyy')#</td>
					<td><strong>Fecha Vencimiento</strong></td>
					<td>#LSDateformat(rsQuery.FechaVencimiento,'dd/mm/yyyy')#</td>
				</tr>	
				<tr>
					<td><strong>Socio de Negocios</strong></td>
					<td>#rsQuery.NumeroSocio#</td>
					<td><strong>C&oacute;digo retenci&oacute;n</strong></td>
					<td>#rsQuery.CodigoRetencion#</td>
				</tr>
				<tr>
					<td><strong>Cuenta Financiera</strong></td>
					<td>#rsQuery.CuentaFinanciera#</td>
					<td><strong>Concepto de servicio</strong></td>
					<td>#rsQuery.CodigoConceptoServicio#</td>
				</tr>
				<tr>
					<td><strong>Direcci&oacute;n Envio</strong></td>
					<td>#rsQuery.CodigoDireccionEnvio#</td>
					<td><strong>Direcci&oacute;n Factura</strong></td>
					<td>#rsQuery.CodigoDireccionFact#</td>
				</tr>															

				<cfloop query="rsError">									
					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4"><strong>Interfaz ejecutada por</strong></td>
					</tr>
					<tr>
						<td colspan="4">#rsError.UsuarioBdInclusion#</td>
					</tr>
					<tr>
						<td colspan="4"><strong>Error generado</strong></td>
					</tr>
					<tr>
						<td colspan="4">#rsError.MsgError#</td>
					</tr>
				</cfloop> 				
				<tr  bgcolor="##CCCCCC">
					<td colspan="4">&nbsp;</td>
				</tr>
			</table>
		</cfoutput>
	<cfelse>
		<table width="100%" border="0">
			<tr>
				<td >&nbsp;</td>
			</tr>
			<tr bgcolor="##CCCCCC">
				<td align="center">Debe seleccionar al menos un documento</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
	</cfif>
<cf_web_portlet_end>

