<cfset modo = 'ALTA'>

<cfif isdefined ('url.PCEMid') and not isdefined('form.PCEMid')>
	<cfset form.PCEMid = url.PCEMid>
</cfif>

<cfif isdefined ('url.Ctipo') and not isdefined('form.Ctipo')>
	<cfset form.Ctipo = url.Ctipo>
</cfif>

<cfif  isdefined('form.PCEMid')and len(trim(form.PCEMid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cf_templateheader title="Configuración del Nivel de la Cuenta">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Configuración del Nivel de la Cuenta">
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif modo eq 'CAMBIO'>
					<cfquery name="rsDatos" datasource="#session.dsn#">
						select Ctipo,Cdescripcion, Cmayor
						 from CtasMayor
						where Ecodigo = #session.Ecodigo#
						and PCEMid = #form.PCEMid#
						and Ctipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ctipo#">
					</cfquery>	
				<cfelse>
					<cfquery name="rsListaIngreso" datasource="#session.dsn#">
						select Cmayor as Cmayor1,Cdescripcion as Cdescripcion1,PCEMid, Ctipo 
						 from CtasMayor
						where Ecodigo = #session.Ecodigo#
						and Ctipo in ('I','P')
						and PCEMid is not null 
						and exists (select 1 
										from PCNivelMascara   
			      					where PCEMid = CtasMayor.PCEMid
					 					and PCNpresupuesto =1)	
						order by Cmayor				
					</cfquery>	
					
					<cfquery name="rsListaEgresos" datasource="#session.dsn#">
						select Cmayor as Cmayor2,Cdescripcion as Cdescripcion2,PCEMid,Ctipo
						 from CtasMayor
						where Ecodigo = #session.Ecodigo#
						and Ctipo in ('G','P')
						and PCEMid is not null
						and exists (select 1 
										from PCNivelMascara   
			      					where PCEMid = CtasMayor.PCEMid
					 					and PCNpresupuesto =1)	
						order by Cmayor				
					</cfquery>
					
					<cfquery name="rsListaIngresoTransferencia" datasource="#session.dsn#">
						select Cmayor as Cmayor3,Cdescripcion as Cdescripcion3,PCEMid, Ctipo 
						 from CtasMayor
						where Ecodigo = #session.Ecodigo#
						and Ctipo = 'C'
						and PCEMid is not null 
						and exists (select 1 
										from PCNivelMascara   
			      					where PCEMid = CtasMayor.PCEMid
					 					and PCNpresupuesto =1)			
						order by Cmayor				
					</cfquery>	
					
					<cfquery name="rsListaEgresosTransferencia" datasource="#session.dsn#">
						select Cmayor as Cmayor4,Cdescripcion as Cdescripcion4,PCEMid,Ctipo
						 from CtasMayor
						where Ecodigo = #session.Ecodigo#
						and Ctipo in ('C')<!---falta definir este tipo --->
						and PCEMid is not null 
						and exists (select 1 
										from PCNivelMascara   
			      					where PCEMid = CtasMayor.PCEMid
					 					and PCNpresupuesto =1)	
						order by Cmayor				
					</cfquery>
				</cfif>
					
				<cfif modo eq 'ALTA'>
					<cfoutput>
						<form action="ConfiguracionNivelCuenta.cfm" name="form1" method="post">
							<table cellpadding="0" cellspacing="0" >
									<tr>
										<td align="center" colspan="4">
											<input type="radio" name="TipoCuenta"  id="TipoCuenta" value="1"  onclick="seleccionar('I')" checked="checked"/>Ingresos
										</td>
										<td align="center">
											<input type="radio" name="TipoCuenta"  id="TipoCuenta"  value="2" onclick="seleccionar('E')" <cfif isdefined("url.TipoCuenta") and len(trim(url.TipoCuenta)) and url.TipoCuenta eq 2>checked="checked"</cfif>/>Egresos
										</td>
										
										<td align="center">
											<input type="radio" name="TipoCuenta"  id="TipoCuenta"  value="2" onclick="seleccionar('IT')" <cfif isdefined("url.TipoCuenta") and len(trim(url.TipoCuenta)) and url.TipoCuenta eq 3>checked="checked"</cfif>/>Ingresos-Transferencias
										</td>
										
										<td align="center">
											<input type="radio" name="TipoCuenta"  id="TipoCuenta"  value="2" onclick="seleccionar('ET')" <cfif isdefined("url.TipoCuenta") and len(trim(url.TipoCuenta)) and url.TipoCuenta eq 4>checked="checked"</cfif>/>Egresos-Transferencias
										</td>
									</tr>	
									<tr><td>&nbsp;</td></tr>
								</table>
						</form>
					</cfoutput>
				</cfif>
			</td>
		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"> 
		<tr>
			<cfif modo EQ 'CAMBIO'>
				<td valign="top">
					<cfset Ctipo 	= #rsDatos.Ctipo#>
					<cfset Cmayor 	= #rsDatos.Cmayor#>
					<cfset Cdescripcion = #rsDatos.Cdescripcion#>
					<cfinclude template="ConfiguracionNivelCuentaDetalle.cfm">
				</td>
			<cfelse>
				<td align="center">
					<cfinclude template="ConfiguracionNivelCuenta_form.cfm">
				 </td>
			</cfif>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>