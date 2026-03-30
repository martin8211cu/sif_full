		<table width="100%">
			<cfset vCodCliente = 0 >
			<cfset vCliente = '' >
			<cfset vIdCliente = '' >
			<cfset vDocumento = 'Todos' >
			<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo)) >
				<cfset vCodCliente = url.CDCcodigo >
				<cfquery name="cliente" datasource="#session.DSN#">
					select CDCidentificacion, CDCnombre
					from ClientesDetallistasCorp
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#">
				</cfquery>
				<cfset vCliente = cliente.CDCnombre >
				<cfset vIdCliente = trim(cliente.CDCidentificacion) >
			</cfif>
		
			<cfif isdefined("url.FAX14DOC") and len(trim(url.FAX14DOC)) >
				<cfset vDocumento = url.FAX14DOC >
				
				<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo)) eq 0>
					<cfquery name="cliente" datasource="#session.DSN#">
						select a.CDCcodigo, a.CDCidentificacion, a.CDCnombre
						from ClientesDetallistasCorp a
						
						inner join FAX014 b
						on b.CDCcodigo=a.CDCcodigo
						and b.FAX14DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX14DOC#">
						
						where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>
					<cfset vCliente = cliente.CDCnombre >
					<cfset vIdCliente = trim(cliente.CDCidentificacion) >
					<cfset vCodCliente = cliente.CDCcodigo >
				</cfif>
			</cfif>
			
			<cfquery name="clientedest" datasource="#session.DSN#">
				select CDCidentificacion, CDCnombre
				from ClientesDetallistasCorp
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigoDest#">
			</cfquery>
			
			<cfquery name="rsLista" datasource="#session.DSN#">
				select  a.FAX14DOC, 
						(select Miso4217 from Monedas where Mcodigo = a.Mcodigo) as moneda,
						a.FAX14MON as montoAdelanto,
						b.FAX16MON as montoTrasladado,
						b.FAX16OBS as motivoTranslado,
						(	select u.Usulogin 
							from Usuario u 
							where u.Usucodigo = b.BMUsucodigo) as usuario
					from FAX014 a 
				
					inner join FAX016 b
						  on a.CDCcodigo = b.CDCcodigo 
						  and a.FAX14CON = b.FAX14CON
				
					where a.FAX14STS = '2' 
					  and a.FAX14MON = a.FAX14MAP
					  and b.FAX16CON = ( select max(x.FAX16CON) 
										 from FAX016 x 
										 where x.CDCcodigo = a.CDCcodigo 
										 and x.FAX14CON = a.FAX14CON )
					  and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#" > 
					<cfif isdefined("url.chk") and len(trim(url.chk))>
					  and a.FAX14CON in (#url.chk#)
					</cfif>
			</cfquery>						
					
			<tr>
				<td>
					<cfoutput>
					<table width="100%" align="center" cellpadding="3" cellspacing="0" class="areaFiltro">
						<tr><td colspan="2" align="center"><strong>#session.Enombre#</strong></td></tr>

						<tr>
							<td colspan="2" align="center"><strong>Resumen de NC/Adelantos Trasladados</strong></td>
						</tr>
						<tr>
							<td width="50%"><strong>Cliente Origen:&nbsp;</strong>#vCliente#</td>
							<td width="50%" ><strong>Cliente Destino:&nbsp;</strong>#clientedest.CDCnombre#</td>
						</tr>
						<tr>
							<td><strong>Identificaci&oacute;n:&nbsp;</strong>#vIdCliente#</td>
							<td ><strong>Identificaci&oacute;n:&nbsp;</strong>#clientedest.CDCidentificacion#</td>
						</tr>
						<tr>											
							<td nowrap="nowrap" colspan="2"><strong>Motivo:&nbsp;</strong>#url.FABmotivo#</td>
						</tr>
					</table>
					</cfoutput>
				</td>
			</tr>

			<tr><td>
				<table width="100%" cellpadding="1" cellspacing="0" >
					<tr>
						<td class="tituloListas">&nbsp;</td>
						<td class="tituloListas">Documento</td>
						<td class="tituloListas">Moneda</td>
						<td class="tituloListas" align="right">Monto Adelanto</td>
						<td class="tituloListas" align="right">Monto Trasladado</td>
						<td class="tituloListas" align="center">Usuario</td>
					</tr>

					<cfoutput>
					</cfoutput>
					<cfoutput query="rsLista">
						<tr class="<cfif rsLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaNonSel';" onmouseout="this.className='<cfif rsLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>';">
							<td style="padding-left:20px;" ></td>
							<td >#rsLista.FAX14DOC#</td>
							<td >#rsLista.moneda#</td>
							<td align="right" >#LSNumberFormat(rsLista.montoAdelanto, ',9.00')#</td>
							<td align="right" >#LSNumberFormat(rsLista.montoTrasladado, ',9.00')#</td>
							<td align="center"  >#rsLista.usuario#</td>
						</tr>
					</cfoutput>
				</table>
			</td></tr>
			<tr><td>&nbsp;</td></tr>
			<cfif not isdefined("url.imprimir")>
			<tr>
				<td align="center" >
					<input type="button" tabindex="1"  name="btnRegresar" class="btnAnterior" value="Nuevo Traslado de NC/Adelantos" onclick="javascript:location.href='opmovad.cfm'" />
				</td>
			</tr>
			</cfif>
		</table>