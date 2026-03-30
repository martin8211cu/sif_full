<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Donaciones por Tipo de Pago
</cf_templatearea>
<cf_templatearea name="body">
<cfset navBarItems = ArrayNew(1)>
<cfset navBarLinks = ArrayNew(1)>
<cfset navBarStatusText = ArrayNew(1)>
	
<cfset ArrayAppend(navBarItems,'Donaciones')>
<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">

	<table width="100%" cellpadding="5" cellspacing="0">
		<tr><td><cfinclude template="../pNavegacion.cfm"></td></tr>
		<tr><td colspan="2">
		<cfinclude template="filtro.cfm">
		</td>
		</tr>
	
		<cfquery name="rs" datasource="#session.DSN#" >
			<cfif isdefined("form.fVer") and form.fVer eq 'D'>
				select a.MEDproyecto, c.MEDnombre, coalesce(b.Pnombre,'Anónimo') + ' ' + coalesce(b.Papellido1,'') + ' ' + coalesce(b.Papellido2,'') as Pnombre, 
					   a.MEDfecha as fMEDfecha, convert(varchar, a.MEDfecha, 103) as MEDfecha, a.MEDmoneda ,a.MEDimporte, a.MEDtctipo, a.MEDtcnumero, a.MEDtcvence
				from MEDDonacion a, MEPersona b, MEDProyecto c
				where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.MEDforma_pago='T'
				and a.MEpersona*=b.MEpersona
				and a.MEDproyecto=c.MEDproyecto
				<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
					and a.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#">
				</cfif>
				and a.MEDfecha between <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(vfecha1, 'yyyymmdd')#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(vfecha2, 'yyyymmdd')#">
				<cfif isdefined("form.fMoneda") and len(trim(form.fMoneda)) gt 0>
					and a.MEDmoneda = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fMoneda#">
				</cfif>
				order by c.MEDnombre, Pnombre, fMEDfecha desc, a.MEDmoneda
			<cfelse>
				select a.MEDproyecto, b.MEDnombre, a.MEDmoneda, a.MEDtctipo, a.MEDfecha as fMEDfecha, convert(varchar, a.MEDfecha, 103) as MEDfecha, sum(MEDimporte) as MEDimporte
				from MEDDonacion a, MEDProyecto b
				where a.MEDproyecto=b.MEDproyecto
				and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.MEDforma_pago='T'

				<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
					and a.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#">
				</cfif>
				and a.MEDfecha between <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(vfecha1, 'yyyymmdd')#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(vfecha2, 'yyyymmdd')#">
				<cfif isdefined("form.fMoneda") and len(trim(form.fMoneda)) gt 0>
					and a.MEDmoneda = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fMoneda#">
				</cfif>
	
				group by a.MEDproyecto, b.MEDnombre, a.MEDmoneda, a.MEDtctipo , a.MEDfecha, convert(varchar, a.MEDfecha, 103) 
				order by b.MEDnombre, fMEDfecha desc, a.MEDmoneda, a.MEDtctipo
			</cfif>
		</cfquery>

		<cfif RS.RecordCount gte 1>
			<tr><td>
				<cfif isdefined("form.fVer") and form.fVer eq 'D' >
					<table width="100%" cellpadding="2" cellspacing="0">
						
							<cfoutput >
							<cfquery name="proyecto" dbtype="query">
								select distinct MEDproyecto, MEDnombre, MEDmoneda, MEDtctipo
								from rs
								order by MEDnombre
							</cfquery>
							
							<cfloop query="proyecto">

								<cfif trim(proyecto.MEDtctipo) eq 'VISA'>
									<cfset tipotarjeta = "Visa">
								<cfelseif trim(proyecto.MEDtctipo) eq 'AMEX'>
									<cfset tipotarjeta = "American Express">
								<cfelseif trim(proyecto.MEDtctipo) eq 'MC'>
									<cfset tipotarjeta = "MasterCard">
								</cfif>

								<tr class="areaFiltro"><td colspan="3"><b>#proyecto.MEDnombre# (#proyecto.MEDmoneda#) </b></td>
								<td rowspan="2" colspan="2" align="right">
									<cfif proyecto.MEDtctipo eq "AMEX">
										<img src="../images/card/AMEX.gif" alt="American Express" width="35" height="36" >
									<cfelseif trim(proyecto.MEDtctipo) eq "MC">
										<img src="../images/card/MC.gif" alt="Master Card" width="45" height="29" >
									<cfelseif proyecto.MEDtctipo eq "VISA">
										<img src="../images/card/VISA.gif" alt="Visa" width="38" height="24" >
									</cfif>
								</td>
								
								</tr>
								<tr class="areaFiltro"><td colspan="3"><b>Tipo de Pago: #tipotarjeta#</b></td></tr>
								<tr class="tituloListas">
									<td colspan="2"><b>Fecha</b></td>
									<td><b>Donante</b></td>
									<td><b>N&uacute;mero Tarjeta</b></td>
									<td align="right"><b>Monto</b></td>
								</tr>
								
								<cfquery name="data" dbtype="query">
									select * from rs 
									where MEDproyecto=#proyecto.MEDproyecto# 
									  and MEDmoneda = '#proyecto.MEDmoneda#'
									  and MEDtctipo = '#proyecto.MEDtctipo#'
								</cfquery>
								
								<cfset total = 0 >	
								<cfloop query="data">
									<tr class="<cfif data.CurrentRow mod 2 eq 0 >listaPar<cfelse>listaNon</cfif>" >
										<td>#data.MEDfecha#</td>
										<td colspan="2">#data.Pnombre#</td> 
										<td >#data.MEDtcnumero#</td> 
										<td align="right">#LSNumberFormat(data.MEDimporte, ',9.00')#</td>
									</tr>
									<cfset total = total + data.MEDimporte > 
								</cfloop>
								
								<tr class="listaNon">
									<td><b>Total</b></td>
									<td colspan="4" align="right"><b>#data.MEDmoneda# #LSNumberFormat(total, ',9.00')#</b></td>
								</tr>	
	
							</cfloop>
							</cfoutput>
				<cfelse>
					<cfoutput>
 					<table width="100%" cellpadding="0" cellspacing="0" >
						<cfquery name="proyecto" dbtype="query">
							select distinct MEDproyecto, MEDnombre, MEDmoneda, MEDtctipo
							from rs
							order by MEDnombre
						</cfquery>

						<cfloop query="proyecto">
							<tr class="areaFiltro">
								<td colspan="2"><b>#proyecto.MEDnombre# (#proyecto.MEDmoneda#) </b></td>
								<td align="right"><cfif proyecto.MEDtctipo eq "AMEX">
										<img src="../images/card/AMEX.gif" alt="American Express" width="35" height="36" >
									<cfelseif trim(proyecto.MEDtctipo) eq "MC">
										<img src="../images/card/MC.gif" alt="Master Card" width="45" height="29" >
									<cfelseif proyecto.MEDtctipo eq "VISA">
										<img src="../images/card/VISA.gif" alt="Visa" width="38" height="24" >
									</cfif>
								</td>
							</tr>
							<tr class="tituloListas">
								<td><b>Fecha</b></td>
								<td><b>Tipo de Tarjeta</b></td>
								<td align="right"><b>Monto</b></td>
							</tr>
							
							<cfquery name="data" dbtype="query">
								select * 
								from rs 
								where MEDproyecto=#proyecto.MEDproyecto# 
								  and MEDmoneda = '#proyecto.MEDmoneda#'
								  and MEDtctipo = '#proyecto.MEDtctipo#'
							</cfquery>

							<cfset total = 0 >	
							<cfloop query="data">
								<tr class="<cfif data.CurrentRow mod 2 eq 0 >listaPar<cfelse>listaNon</cfif>" >
									<td>#data.MEDfecha#</td>
									<td>#data.MEDtctipo#</td>
									<td align="right">#LSNumberFormat(data.MEDimporte, ',9.00')#</td>
								</tr>
								<cfset total = total + data.MEDimporte > 
							</cfloop>
							
							<tr class="listaNon">
								<td><b>Total</b></td>
								<td colspan="4" align="right"><b>#data.MEDmoneda# #LSNumberFormat(total, ',9.00')#</b></td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
						
						</cfloop>

					</table>
					</cfoutput>

				</cfif>
			</td></tr>

			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><em>Donaciones por proyecto</em></td></tr>
			<tr><td>&nbsp;</td></tr>

		<cfelse>
			<tr><td align="center"><b>No se encontraron Resultados<b></td></tr>	
		</cfif>
	</table>


</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
</cf_template>
