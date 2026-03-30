<!---------

	Creado por: Ana Villavicencio
	Fecha de creación: 15 de noviembre del 2005
	Motivo:	Reporte de impresión de de documentos conciliados independientemente.
	
---------->

<cfif isdefined('url.EChasta') and not isdefined('form.EChasta')>
	<cfset form.EChasta = url.EChasta>
</cfif>
<cfif isdefined('url.Bid') and not isdefined('form.Bid')>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif isdefined('url.CBid') and not isdefined('form.CBid')>
	<cfset form.CBid = url.CBid>
</cfif>

<cfif isdefined('form.EChasta') and LEN(TRIM(form.EChasta))>
	<cfquery name="rsEstadoCta" datasource="#session.DSN#">
		select ECid
		from ECuentaBancaria
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		  and EChasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(LSDateFormat(form.EChasta,'dd/mm/yyyy'))#">
		  and ECaplicado = 'S'
		  and EChistorico = 'S'
	</cfquery>
	<cfset form.ECid = rsEstadoCta.ECid>
</cfif>

<cfif isdefined('form.ECid') and LEN(form.ECid) GT 0>
	<cfset vparams ="">
	<cfset vparams = vparams & "&EChasta=" & form.EChasta & "&Bid=" & form.Bid & "&CBid=" & form.CBid>
	
	<!---****************** Consultas Encabezado 				******************--->
	
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>	
	<cfquery name="rsDatosEncab" datasource="#session.DSN#">
		select ECdescripcion, Bdescripcion, CBdescripcion
		from ECuentaBancaria ec
		inner join CuentasBancos cb
		   on ec.Bid = cb.Bid
		  and ec.CBid = cb.CBid
		inner join Bancos b
		   on cb.Ecodigo = b.Ecodigo
		  and cb.Bid = b.Bid
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
	        and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	<!---****************** Consultas Detalle ******************--->
	<cfquery name="rsLibrosConciliados" datasource="#Session.DSN#">
		select MLdescripcion,MLdocumento, BTdescripcion ,MLfecha, MLmonto, 
			   ml.BTid,t.BTcodigo,t.BTdescripcion,MLtipomov
		from MLibros ml
		inner join BTransacciones t
		   on ml.Ecodigo = t.Ecodigo
		  and ml.BTid = t.BTid
		  and ml.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		where MLconciliado = 'S'
		  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		  and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		 and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#"> 
		order by MLfecha
	</cfquery>
	<cfquery name="rsSumaDebitosL" dbtype="query">
		select sum(MLmonto) as totalDebitos
		from rsLibrosConciliados
		where MLtipomov = 'D'
	</cfquery>
	<cfquery name="rsSumaCreditosL" dbtype="query">
		select sum(MLmonto) as totalCreditos
		from rsLibrosConciliados
		where MLtipomov = 'C'
	</cfquery>
	<cfquery name="rsBancosConciliados" datasource="#Session.DSN#">
		select DCReferencia,Documento ,BTEdescripcion , DCfecha, DCmontoori, 
		       dc.BTEcodigo, c.BTEtipo
		from ECuentaBancaria a 
			inner join DCuentaBancaria dc
			   on a.ECid = dc.ECid
			 and dc.DCconciliado = 'N' 

			left outer join TransaccionesBanco c
		  	  on dc.Bid = c.Bid
			 and dc.BTEcodigo = c.BTEcodigo
			 
		where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		order by DCfecha
	</cfquery>
	<cfquery name="rsSumaDebitosB" dbtype="query">
		select sum(DCmontoori) as totalDebitos
		from rsBancosConciliados
		where BTEtipo = 'D'
	</cfquery>
	<cfquery name="rsSumaCreditosB" dbtype="query">
		select sum(DCmontoori) as totalCreditos
		from rsBancosConciliados
		where BTEtipo = 'C'
	</cfquery>
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	
	<cfif not isdefined("url.imprimir")>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_rhimprime datos="/sif/mb/Reportes/formDocConciliadosIndep.cfm" paramsuri="#vparams#">
										
				</td>	
			</tr>
		</table>
	</cfif>
	<cfoutput>
	<table  width="80%"  align="center" border="0">
		<tr>
			<td><font size="4"><strong>#rsEmpresa.Edescripcion#</strong></font></td>
			<td align="right"><font size="2"><strong>#LSDateFormat(Now(),'dd/mm/yyyy')#</strong></font></td>		
		</tr>
		<tr><td colspan="2"><font size="3"><strong>Documentos Conciliados Independientemente</strong></font></td></tr>
		<tr><td colspan="2"><font size="2"><strong>Banco:&nbsp;#rsDatosEncab.Bdescripcion#</strong></font></td></tr>
		<tr><td colspan="2"><font size="2"><strong>Cuenta:&nbsp;#rsDatosEncab.CBdescripcion#</strong></font></td></tr>
		<tr><td colspan="2"><font size="2"><strong>Estado de Cuenta:&nbsp;#rsDatosEncab.ECdescripcion#</strong></font></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="85%" valign="top">
					<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td align="center" valign="top"><span style="font-size:16px"><strong>BANCOS</strong></span></td></tr>
						<tr> 
							<td width="48%" align="center" valign="top"> 
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<cfset transaccion = ''>
									<cfset transAnterior = ''>
									<cfset totalTransD = 0>
									<cfset totalTransC = 0>
									
									<tr class="subTitulo" bgcolor="E2E2E2"> 
										<td ><strong>&nbsp;Fecha</strong></td>
										<td ><strong>Documento</strong></td>
										<td ><strong>Referencia</strong></td>
										<td align="right"><strong>D&eacute;bito</strong></td>
										<td align="right"><strong>Cr&eacute;dito</strong></td>
									</tr>
									<cfloop query="rsBancosConciliados">
											<!--- <cfset totalBancosD = totalBancosD + totalTransD>
											<cfset totalBancosC = totalBancosC + totalTransC> --->
										<cfif BTEtipo EQ 'D'>
											<cfset totalTransD = totalTransD + DCmontoori>
										<cfelse>
											<cfset totalTransC = totalTransC + DCmontoori>
										</cfif>
										<tr <cfif rsBancosConciliados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
											<td>&nbsp;&nbsp;#LSDateFormat(DCfecha,'dd/mm/yyyy')#</td>
											<td nowrap>#Documento#&nbsp;&nbsp;</td>
											<td nowrap>#DCReferencia#&nbsp;&nbsp;</td>
											<td align="right"><cfif BTEtipo EQ 'D'>#LSCurrencyFormat(DCmontoori,'none')#<cfelse>0.00</cfif></td>
											<td align="right"><cfif BTEtipo EQ 'C'>#LSCurrencyFormat(DCmontoori,'none')#<cfelse>0.00</cfif></td>
										</tr>
										<cfif isdefined("url.imprimir")>
											<cfif rsBancosConciliados.RecordCount mod 35 EQ 1>☺♀
												<cfif rsBancosConciliados.RecordCount NEQ 1>
													<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
													
													<tr class="subTitulo"> 
														<td ><strong>Fecha</strong></td>
														<td ><strong>Documento</strong></td>
														<td ><strong>Referencia</strong></td>
														<td align="right"><strong>D&eacute;bito</strong></td>
														<td align="right"><strong>Cr&eacute;dito</strong></td>
													</tr>
												</cfif>
											</cfif>	
										</cfif>
										
									</cfloop>
								
									<tr><td colspan="4">&nbsp;</td></tr>
									<tr>
										<td colspan="3" align="right"><span style=" font-size: 14px"><strong>TOTAL DOCUMENTOS EN BANCOS:</strong></span></td>
										<td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(rsSumaDebitosB.totalDebitos,'none')#</span></td>
										<td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(rsSumaCreditosB.totalCreditos,'none')#</span></td>
									</tr>
									<tr><td colspan="5">&nbsp;</td></tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<cfif isdefined("url.imprimir")>
							<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
						</cfif>
						<tr><td align="center" valign="top"><span style="font-size:16px"><strong>LIBROS</strong></span></td></tr>
						<tr> 
							<td width="48%" align="center" valign="top"> 
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<cfset totalTransD = 0>
									<cfset totalTransC = 0>
									<cfset totalLibrosD = 0>
									<cfset totalLibrosC = 0>
									<tr class="subTitulo" bgcolor="E2E2E2"> 
										<td ><strong>&nbsp;Fecha</strong></td>
										<td ><strong>Documento</strong></td>
										<td ><strong>Referencia</strong></td>
										<td align="right"><strong>D&eacute;bito</strong></td>
										<td align="right"><strong>Cr&eacute;dito</strong></td>
									</tr>
									<cfloop query="rsLibrosConciliados">
										<cfset totalLibrosD = totalLibrosD + totalTransD>
										<cfset totalLibrosC = totalLibrosC + totalTransC>
										<cfif #MLtipomov# EQ 'D'>
											<cfset totalTransD = totalTransD + MLmonto>
										<cfelse>
											<cfset totalTransC = totalTransC + MLmonto>
										</cfif>
										<tr <cfif rsLibrosConciliados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
											<td>&nbsp;&nbsp;#LSDateFormat(MLfecha,'dd/mm/yyyy')#</td>
											<td nowrap>#MLdocumento#&nbsp;&nbsp;</td>
											<td nowrap>#MLdescripcion#&nbsp;&nbsp;</td>
											<td align="right"><cfif #MLtipomov# EQ 'D'>#LSCurrencyFormat(MLmonto,'none')#<cfelse>0.00</cfif></td>
											<td align="right"><cfif #MLtipomov# EQ 'C'>#LSCurrencyFormat(MLmonto,'none')#<cfelse>0.00</cfif></td>
										</tr>
										<cfif isdefined("url.imprimir")>
											<cfif rsLibrosConciliados.RecordCount mod 35 EQ 1>☺♀
												<cfif rsLibrosConciliados.RecordCount NEQ 1>
													<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
													<tr class="subTitulo"> 
														<td><strong>Fecha</strong></td>
														<td><strong>Documento</strong></td>
														<td><strong>Referencia</strong></td>
														<td align="right"><strong>D&eacute;bito</strong></td>
														<td align="right"><strong>Cr&eacute;dito</strong></td>
													</tr>
												</cfif>
											</cfif>	
										</cfif>
										<cfif CurrentRow EQ RecordCount>
											<cfset totalLibrosD = totalLibrosD + totalTransD>
											<cfset totalLibrosC = totalLibrosC + totalTransC>
										</cfif>
									</cfloop>
								  	<tr><td colspan="4">&nbsp;</td></tr>
									<tr>
										<td colspan="3" align="right"><span style=" font-size: 14px"><strong>TOTAL DOCUMENTOS EN LIBROS:</strong></span></td>
										<td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(rsSumaDebitosL.totalDebitos,'none')#</span></td>
										<td align="right"><span style=" font-size: 12px">&nbsp;&nbsp;#LSCurrencyFormat(rsSumaCreditosL.totalCreditos,'none')#</span></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						
					</table>
			</td>
		</tr>
	</table>
	<table width="100%" align="center">
		<cfif isdefined("url.imprimir")>
			<tr><td><h6>&nbsp;</h6></td></tr>
			<tr align="center"><td> --------------------------- Fin del Reporte --------------------------- </td></tr>
		</cfif>
	</table>
	</cfoutput>
<cfelse>
	<table width="100%" align="center">
		<tr><td><h6>&nbsp;</h6></td></tr>
		<tr align="center"><td> --------------------------- No hay datos que mostrar --------------------------- </td></tr>
	</table>
</cfif> 

		