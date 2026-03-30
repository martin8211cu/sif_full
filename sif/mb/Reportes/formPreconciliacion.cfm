<!---------

	Creado por: Ana Villavicencio
	Fecha de creación: 15 de noviembre del 2005
	Motivo:	Reporte de impresión de de documentos preconciliados.
	
---------->

<cfif isdefined('url.EChasta') and not isdefined('form.EChasta')>
	<cfparam name="form.EChasta" default="#url.EChasta#">
</cfif>	

	<cfset vparams ="">
	<cfset vparams = vparams & "&EChasta=" & form.EChasta>
	
	<!---****************** Consultas Encabezado 				******************--->
	
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>	
	<cfquery name="rsDatosEncab" datasource="#session.DSN#">
		select ECid, ECdescripcion, Bdescripcion, CBdescripcion
		from ECuentaBancaria ec
		inner join CuentasBancos cb
		   on ec.Bid = cb.Bid
		  and ec.CBid = cb.CBid
		  and ec.ECaplicado = 'N'
		inner join Bancos b
		   on cb.Ecodigo = b.Ecodigo
		  and cb.Bid = b.Bid
		where 1 = 1
        and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
        and EChasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EChasta)#">
        <cfif isdefined("form.Bid") and len(trim(form.Bid))>
	        and cb.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
        </cfif>
        <cfif isdefined("form.CBid") and len(trim(form.CBid))>
	        and cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
        </cfif>
	</cfquery>
	<cfif isdefined('rsDatosEncab') and rsDatosEncab.RecordCount GT 0>
		<cfset form.ECid = rsDatosEncab.ECid>
	
	<!---****************** Consultas Detalle ******************--->
	<cfquery name="rsLibrosConciliados" datasource="#Session.DSN#">
		select CDLfecha,CDLdocumento, CDLmonto, 
			   t.BTcodigo,CDLtipomov,CDLgrupo
		from CDLibros ml
		inner join BTransacciones t
		   on ml.CDLidtrans= t.BTid
		where CDLconciliado = 'S'
		  and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		order by CDLgrupo
	</cfquery>

	<cfquery name="rsSumaDebitosL" dbtype="query">
		select sum(CDLmonto) as totalDebitos
		from rsLibrosConciliados
		where CDLtipomov = 'D'
	</cfquery>
	<cfquery name="rsSumaCreditosL" dbtype="query">
		select sum(CDLmonto) as totalCreditos
		from rsLibrosConciliados
		where CDLtipomov = 'C'
	</cfquery>
	<cfquery name="rsBancosConciliados" datasource="#Session.DSN#">
		select CDBdocumento , CDBmonto, BTEcodigo, CDBtipomov, CDBgrupo
		from CDBancos 
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		  and CDBconciliado = 'S'
		order by CDBgrupo
	</cfquery>
	
	<cfquery name="rsSumaDebitosB" dbtype="query">
		select sum(CDBmonto) as totalDebitos
		from rsBancosConciliados
		where CDBtipomov = 'D'
	</cfquery>
	<cfquery name="rsSumaCreditosB" dbtype="query">
		select sum(CDBmonto) as totalCreditos
		from rsBancosConciliados
		where CDBtipomov = 'C'
	</cfquery>
	<cfquery name="rsGrupos" datasource="#session.DSN#">
		select distinct CDBgrupo as grupo
		from CDBancos
		where CDBconciliado = 'S'
				  and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		union
		select distinct CDLgrupo as grupo
		from CDLibros
		where CDLconciliado = 'S'
				  and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
	</cfquery>
	</cfif>
<cfif isdefined('form.ECid') and LEN(form.ECid) GT 0>	
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<cfif not isdefined("url.imprimir")>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_rhimprime datos="/sif/mb/Reportes/formPreconciliacion.cfm" paramsuri="#vparams#">
										
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
		<tr><td colspan="2"><font size="3"><strong>Reporte de Preconciliaci&oacute;n</strong></font></td></tr>
		<tr><td colspan="2"><font size="2"><strong>Banco:&nbsp;#rsDatosEncab.Bdescripcion#</strong></font></td></tr>
		<tr><td colspan="2"><font size="2"><strong>Cuenta:&nbsp;#rsDatosEncab.CBdescripcion#</strong></font></td></tr>
		<tr><td colspan="2"><font size="2"><strong>Estado de Cuenta:&nbsp;#rsDatosEncab.ECdescripcion#</strong></font></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	</cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="85%" valign="top">
					<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td valign="top">
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr bgcolor="E2E2E2">
										<td><strong>&nbsp;Fecha</strong></td>
										<td><strong>&nbsp;Tipo</strong></td>
										<td><strong>&nbsp;Doc. Libro</strong></td>
										<td align="right"><strong>D&eacute;bitos</strong></td>
										<td align="right"><strong>Cr&eacute;ditos</strong></td>
									</tr>
									<cfoutput query="rsLibrosConciliados" >
										<tr height="15" <cfif rsLibrosConciliados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td>#LSDateFormat(CDLfecha,'dd/mm/yyyy')#</td>
											<td>#BTcodigo#</td>
											<td>#CDLdocumento#</td>
											<cfif CDLtipomov EQ 'D'>
												<td align="right">#CDLmonto#</td>
												<td align="right">0.00</td>
											<cfelse>
												<td align="right">0.00</td>
												<td align="right">#CDLmonto#</td>
											</cfif>
										</tr>
									</cfoutput>
								</table>
							</td>
							<td>&nbsp;&nbsp;</td>
							<td valign="top">
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr bgcolor="E2E2E2">
										<td><strong>&nbsp;Doc. Banco</strong></td>
										<td align="right"><strong>D&eacute;bitos</strong></td>
										<td align="right"><strong>Cr&eacute;ditos</strong></td>
									</tr>
									<cfoutput query="rsBancosConciliados">
										<tr height="15" <cfif rsBancosConciliados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td>#CDBdocumento#</td>
											<cfif CDBtipomov EQ 'D'>
												<td align="right">#CDBmonto#</td>
												<td align="right">0.00</td>
											<cfelse>
												<td align="right">0.00</td>
												<td align="right">#CDBmonto#</td>
											</cfif>
										</tr>
									</cfoutput>
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
<cfelse>
	<table width="100%" align="center">
		<tr><td><h6>&nbsp;</h6></td></tr>
		<tr align="center"><td> --------------------------- No hay datos que mostrar --------------------------- </td></tr>
	</table>
</cfif> 
		