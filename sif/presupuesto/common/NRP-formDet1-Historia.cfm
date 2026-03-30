<cfif not LvarMostrarHistoria>
	<cf_errorCode	code = "50464" msg = "La Historia del NRP no se permite en este momento">
</cfif>
<cf_web_portlet_start titulo="Historia de la línea del NRP">
	<cfoutput>
	<table width="60%" align="center">
		<tr>
			<td>
				Linea
			</td>
			<td>
				#rsLista.CPNRPDlinea#
			</td>
		</tr>
		<tr>
			<td>
				Mes
			</td>
			<td>
				 #rsLista.MesDescripcion#
			</td>
		</tr>
		<tr>
			<td>
				Cuenta Presupuesto
			</td>
			<td>
				 #rsLista.CuentaPresupuesto#
			</td>
		</tr>
		<tr>
			<td>
				Oficina
			</td>
			<td>
				 #rsLista.Oficodigo# - #rsLista.Odescripcion#
			</td>
		</tr>
		<tr>
			<td>
				Tipo Control
			</td>
			<td>
				#rsLista.TipoControl# (*)
			</td>
		</tr>
		<tr>
			<td>
				Cálculo Control
			</td>
			<td>
				#rsLista.CalculoControl#
			</td>
		</tr>
		<tr>
			<td>
				Tipo Movimiento
			</td>
			<td>
				#rsLista.TipoMovimiento#
			</td>
		</tr>
		<tr>
			<td>&nbsp;
				
			</td>
			<td>&nbsp;
				
			</td>
		</tr>
		<tr>
			<td>
				<strong>DATOS HISTORICOS DEL RECHAZO (1)</strong>
			</td>
			<td>
			</td>
		</tr>
		<tr>
			<td>
				Disponible Antes del Rechazo
			</td>
			<td align="right">
				#LsCurrencyFormat(rsLista.CPNRPDdisponibleAntes,"none")#
			</td>
		</tr>
		<tr>
			<td>
				Monto Movimiento
			</td>
			<td align="right">
				#rsLista.Signo#&nbsp;#LsCurrencyFormat(rsLista.Monto,"none")#
			</td>
		</tr>
		<tr>
			<td>
				Rechazos Aprobados Pendientes <strong>(2)</strong> antes del Rechazo
			</td>
			<td align="right">
				#LsCurrencyFormat(rsLista.CPNRPDpendientesAntes,'none')#
			</td>
		</tr>
		<tr <cfif rsLista.CPNRPDconExceso> style="color:##FF0000"</cfif>>
			<td>
				Disponible Neto Rechazado
	<cfif rsLista.CPNRPDconExceso EQ "1">
				<BR>(<strong>Provocó Rechazo Presupuestario</strong>)
	</cfif>
			</td>
			<td align="right">
				#LsCurrencyFormat(rsLista.DisponibleNeto,'none')#
			</td>
		</tr>
		<tr>
			<td>&nbsp;
				
			</td>
			<td>&nbsp;
				
			</td>
		</tr>
		<tr>
			<td>
				<strong>DATOS HISTORICOS DE LA APROBACION</strong>
			</td>
			<td>
			</td>
		</tr>
		<tr>
			<td>
				Disponible Antes de la Aprobación
			</td>
			<td align="right">
				#LsCurrencyFormat(rsLista.CPNRPDdisponibleAntesAprobar,'none')#
			</td>
		</tr>
		<cfif rsNRPD_TOT.DisponibleTotal eq "">
			<cfset rsNRPD_TOT.DisponibleTotal = 0>
		</cfif>
		<cfset LvarExcesoAprobar = rsLista.CPCPtipoControl NEQ "0" AND rsNRPD_TOT.DisponibleTotal lt 0>
		<cfset LvarExcesoAprobarTipo = 0>
		<cfif LvarExcesoAprobar>
			<cfif -rsNRPD_TOT.MontoTotal LT rsNRPD_TOT.DisponibleTotal>
				<cfset LvarExcesoAprobarTipo = 1>
			<cfelse>
				<cfset LvarExcesoAprobarTipo = 2>
			</cfif>
		</cfif>
		<tr <cfif rsNRPD_TOT.MovimientosCuenta EQ 1 AND LvarExcesoAprobarTipo EQ 1> style="color:##FF0000"</cfif>>
			<td>
				Monto Movimiento
				<cfif rsNRPD_TOT.MovimientosCuenta EQ 1 AND LvarExcesoAprobarTipo EQ 1>
					<cfif LvarExcesoConTraslado>
						<BR>(<strong>Determina el máximo Traslado a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "1">
						<BR>(<strong>Determina el máximo Exceso a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "2">
						<BR>(<strong>No permite la Aprobación</strong>)
					</cfif>
				</cfif>
			</td>
			<td align="right">
				#rsLista.Signo#&nbsp;#LsCurrencyFormat(rsLista.Monto,'none')#
			</td>
		</tr>
		<tr <cfif rsNRPD_TOT.MovimientosCuenta EQ 1 AND  LvarExcesoAprobarTipo EQ 2> style="color:##FF0000"</cfif>>
			<td>
				Disponible Generado durante la Aprobación
				<cfif rsNRPD_TOT.MovimientosCuenta EQ 1 AND LvarExcesoAprobarTipo EQ 2>
					<cfif LvarExcesoConTraslado>
						<BR>(<strong>Determina el máximo Traslado a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "1">
						<BR>(<strong>Determina el máximo Exceso a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "2">
						<BR>(<strong>No permite la Aprobación</strong>)
					</cfif>
				</cfif>
			</td>
			<td align="right">
				#LsCurrencyFormat(rsLista.DisponibleTotalAprobar,'none')#
			</td>
		</tr>
	<cfif rsNRPD_TOT.MovimientosCuenta GT 1>
		<tr <cfif LvarExcesoAprobarTipo EQ 1> style="color:##FF0000"</cfif>>
			<td>
				Monto Total de Movimientos de la Cuenta
				<cfif LvarExcesoAprobarTipo EQ 2>
					<cfif LvarExcesoConTraslado>
						<BR>(<strong>Determina el máximo Traslado a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "1">
						<BR>(<strong>Determina el máximo Exceso a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "2">
						<BR>(<strong>No permite la Aprobación</strong>)
					</cfif>
				</cfif>
			</td>
			<td align="right">
				#LsCurrencyFormat(rsNRPD_TOT.DisponibleTotal,'none')#
			</td>
		</tr>
		<tr <cfif LvarExcesoAprobarTipo EQ 2> style="color:##FF0000"</cfif>>
			<td>
				Disponible Final de la Cuenta durante la Aprobación
				<cfif LvarExcesoAprobarTipo EQ 2>
					<cfif LvarExcesoConTraslado>
						<BR>(<strong>Determina el máximo Traslado a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "1">
						<BR>(<strong>Determina el máximo Exceso a Autorizar</strong>)
					<cfelseif rsLista.CPCPtipoControl EQ "2">
						<BR>(<strong>No permite la Aprobación</strong>)
					</cfif>
				</cfif>
			</td>
			<td align="right">
				#LsCurrencyFormat(rsNRPD_TOT.DisponibleTotal,'none')#
			</td>
		</tr>
</cfif>
<cfif LvarExcesoAprobar>
	<cfif LvarExcesoConTraslado>
		<tr>
			<td>
				<strong>Máximo Traslado Autorizado en la Aprobación (3)</strong>
			</td>
			<td align="right">
				<strong>#LsCurrencyFormat(rsNRPD_TOT.ExcesoTotal,'none')#</strong>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td>
				Excesos ya Autorizados antes de la Aprobación
			</td>
			<td align="right">
				#LsCurrencyFormat(rsLista.CPNRPDextraordinAntesAprobar,'none')#
			</td>
		</tr>
		<cfif rsLista.CPCPtipoControl EQ "1">
		<tr>
			<td>
				<strong>Máximo Exceso Autorizado en la Aprobación (3)</strong>
			</td>
			<td align="right">
				<strong>#LsCurrencyFormat(rsNRPD_TOT.ExcesoTotal,'none')#</strong>
			</td>
		</tr>
		</cfif>
	</cfif>
<cfelseif rsLista.CPCPtipoControl NEQ "0">
		<tr>
			<td>
				<strong>No Genera Exceso Autorizado en la Aprobación (3)</strong>
			</td>
		</tr>
</cfif>
<cfif rsEncabezado.CPNAPnum NEQ "">
	<cfquery name="rsNAPD" datasource="#Session.DSN#">
		select	
				case when a.CPNAPDsigno < 0 then '(-)' when a.CPNAPDsigno > 0 then '(+)' else '(n/a)' end as Signo,
				a.CPNAPDmonto as Monto,
				a.CPNAPDdisponibleAntes,
				a.CPNAPDdisponibleAntes + a.CPNAPDsigno*a.CPNAPDmonto as CPNAPDdisponibleGenerado
		from 	CPNAPdetalle a
			inner join CPNAP b
				on b.Ecodigo = #Session.Ecodigo# 
				  and b.Ecodigo = a.Ecodigo 
				  and b.CPNAPnum = a.CPNAPnum
		where	a.Ecodigo = #Session.Ecodigo# 
		  and 	a.CPNAPnum = #rsEncabezado.CPNAPnum#
		  and 	a.CPNAPDlinea = #url.Lin#
	</cfquery>
	<cfquery name="rsNAP_ME" datasource="#Session.DSN#">
		select	exD.CPNAPDmonto as Excedente,
				case exD.CPNAPDtipoMov
					when 'A'  	then 'Presupuesto Ordinario'
					when 'M'  	then 'Presupuesto Extraordinario'
					when 'ME'  	then 'Excesos Autorizados'
					when 'VC' 	then 'Variación Cambiaria'
					when 'T'  	then 'Traslados'
					when 'TE'  	then 'Traslados con Aut.Externa'
					when 'RA' 	then 'Reservas de Períodos Anteriores'
					when 'CA' 	then 'Compromisos  de Períodos Anteriores'
					when 'RP' 	then 'Provisiones Presupuestarias'
					when 'RC' 	then 'Reservas'
					when 'CC' 	then 'Compromisos'
					when 'E'  	then 'Ejecuciones Contables'
					when 'E2'  	then 'Ejecuciones No Contables'
					when 'EJ'  	then 'Ejercido'
					when 'P'  	then 'Pagados'
					else ''
				end as TipoMovimiento
		  from 	CPNAP exE
			inner join CPNAPdetalle exD
				 on exD.Ecodigo 	= #Session.Ecodigo# 
				and exD.CPcuenta 	= #rsLista.CPcuenta#
				and exD.CPCano		= #rsLista.CPCano#
				and exD.CPCmes		= #rsLista.CPCmes#
				and exD.Ocodigo		= #rsLista.Ocodigo#
				and exD.Ecodigo 	= exE.Ecodigo
				and exD.CPNAPnum 	= exE.CPNAPnum
		where	exE.Ecodigo = #Session.Ecodigo# 
		  and 	exE.CPNAPnumModificado = #rsEncabezado.CPNAPnum#
	</cfquery>
	<cfquery name="rsNRPD_TOT" datasource="#Session.DSN#">
		select 	count(1) as MovimientosCuenta,
				min (coalesce(x.CPNRPDdisponibleAntesAprobar,0) + x.CPNRPDsigno*x.CPNRPDmonto) as DisponibleTotal
		  from CPNRPdetalle x
		 where x.Ecodigo 	= #Session.Ecodigo# 
		   and x.CPNRPnum 	= #rsEncabezado.CPNRPnum#
		   and x.CPcuenta 	= #rsLista.CPcuenta#
		   and x.CPCano		= #rsLista.CPCano#
		   and x.CPCmes		= #rsLista.CPCmes#
		   and x.Ocodigo	= #rsLista.Ocodigo#
	</cfquery>
		<tr>
			<td>&nbsp;
				
			</td>
			<td>&nbsp;
				
			</td>
		</tr>
		<tr>
			<td>
				<strong>DATOS HISTORICOS DE LA APLICACION</strong> (NAP: #rsEncabezado.CPNAPnum#)
			</td>
			<td>
			</td>
		</tr>
		<tr>
			<td>
				<strong>#rsNAP_ME.TipoMovimiento# Generados en la Aplicacion</strong>
			</td>
			<td align="right">
				<strong>#LsCurrencyFormat(rsNAP_ME.Excedente,'none')#</strong>
			</td>
		</tr>
		<tr>
			<td>
				Disponible Antes de la Aplicacion
			</td>
			<td align="right">
				#LsCurrencyFormat(rsNAPD.CPNAPDdisponibleAntes,'none')#
			</td>
		</tr>
		<tr>
			<td>
				Monto Movimiento
			</td>
			<td align="right">
				#rsNAPD.Signo#&nbsp;#LsCurrencyFormat(rsNAPD.Monto,'none')#
			</td>
		</tr>
		<tr>
			<td>
				Disponible Real Generado
			</td>
			<td align="right">
				#LsCurrencyFormat(rsNAPD.CPNAPDdisponibleGenerado,'none')#
			</td>
		</tr>
</cfif>					
		<tr>
			<td>&nbsp;
				
			</td>
			<td>&nbsp;
				
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table>
					<tr>
						<td width="1" valign="top">
							<strong>(*)</strong>
						</td>
						<td>
					<cfif rsLista.CPCPtipoControl EQ "0">
							Una Cuenta Presupuestaria cuyo Tipo de Control sea Abierto, no genera ni Rechazo ni Exceso Presupuestario.
					<cfelseif rsLista.CPCPtipoControl EQ "1">
						<cfif LvarExcesoConTraslado>
							Una Cuenta Presupuestaria cuyo Tipo de Control sea Restringido, puede generar Rechazo Presupuestario y puede ser Aprobado con Traslados.
						<cfelse>
							Una Cuenta Presupuestaria cuyo Tipo de Control sea Restringido, puede generar Rechazo Presupuestario y puede ser Aprobado.
						</cfif>
					<cfelseif rsLista.CPCPtipoControl EQ "2">
						<cfif LvarExcesoConTraslado>
							Una Cuenta Presupuestaria cuyo Tipo de Control sea Restrictivo, puede generar Rechazo Presupuestario y puede ser Aprobado con Traslados.
						<cfelse>
							Una Cuenta Presupuestaria cuyo Tipo de Control sea Restrictivo, puede generar Rechazo Presupuestario pero no pueden ser Aprobado (no generan Excesos), y generarán Excesos Autorizados únicamente si se excede su presupuesto cuando son enviados desde un Módulo Origen cuyo Control haya sido Abierto.
						</cfif>
					</cfif>
						</td>
					</tr>
				<cfif rsLista.CPCPtipoControl EQ "1">
					<tr>
						<td width="1" valign="top">
							<strong>(1)</strong>
						</td>
						<td>
							La línea del documento provoca un rechazo presupuestario únicamente cuando genera un Disponible Neto negativo (Disponible Anterior - Monto - Pendientes)
						</td>
					</tr>
					<tr>
						<td width="1" valign="top">
							<strong>(2)</strong>
						</td>
						<td>
							Los Rechazos Aprobados Pendientes de Aplicar son el total de movimientos por Documento que disminuyen el Presupuesto de una cuenta, oficina, año y mes de presupuesto, para todos aquellos NRPs que han sido Aprobados pero que están pendientes de Aplicación y no han sido Cancelados.<BR>
							Su objetivo es calcular el Disponible Neto que determina cuando se debe provocar un Rechazo Presupuestario (NRP)
						</td>
					</tr>
					<tr>
						<td width="1" valign="top">
							<strong>(3)</strong>
						</td>
						<td>
					<cfif LvarExcesoConTraslado>
						<cfset LvarTipoAutorizado = "Traslado">
					<cfelse>									
						<cfset LvarTipoAutorizado = "Exceso">
					</cfif>
							El documento podría generar un #LvarTipoAutorizado# Autorizado cuando genera un Disponible Final negativo para la misma cuenta, oficina, año y mes de presupuesto.<BR>
							Sin embargo, el #LvarTipoAutorizado# Autorizado se generará en el momento de la Aplicación, y su monto dependerá del orden en que se apliquen los documentos con NRPs pendientes, por cancelación de NRPs Aprobados pendientes de aplicar y por otros documentos que den fondos a la cuenta. Es posible que durante la aplicación no se genere #LvarTipoAutorizado# Autorizado.<BR>
							Sin embargo, aunque no se pueda determinar el monto exacto del #LvarTipoAutorizado# Autorizado que se generará en la aplicación futura del documento, durante la Aprobación del NRP se está aceptando que la cuenta pueda llegar en algún momento a excederse, <strong>como máximo</strong>, en el monto de 'Máximo #LvarTipoAutorizado# Autorizado en la Aprobación'.
						</td>
					</tr>
				</cfif>
				</table>
			</td>
		</tr>
	</table>
	</cfoutput>
<cf_web_portlet_end>
