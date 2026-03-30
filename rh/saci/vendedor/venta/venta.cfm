<cfif Len(session.saci.vendedor.id) is 0 or session.saci.vendedor.id is 0>
  <cfthrow message="Usted no está registrado como vendedor autorizado, por favor verifíquelo.">
</cfif>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

<!---Seleccionar el parámetro que indica si se debe mostrar el tab de contactos (227)--->
<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="227" returnvariable="mostrarcontactos"/>
<cfif mostrarcontactos eq 'S'>
	<br />
	<cfinclude template="venta-params.cfm">
	<cf_tabs width="100%">
		<cf_tab text="Registro de Cliente" selected="#form.tab eq 1#">
			<div style="vertical-align:top;">
				<cfif form.tab eq 1>
					<cfinclude template="venta-cliente.cfm">
				</cfif>
			</div>
		</cf_tab>
		<cf_tab text="Registro de Representantes" selected="#form.tab eq 2#">
			<div style="vertical-align:top;">
				<cfif form.tab eq 2>
					<cfinclude template="venta-representantes.cfm">
				</cfif>
			</div>
		</cf_tab>
		<cf_tab text="Contrato de Servicios" selected="#form.tab eq 3#">
			<div style="vertical-align:top;">
				<cfif form.tab eq 3>
					
					<!-----Se agrega validacion por interfaz de restriccion de spam------->
					<cfquery name="rs" datasource="#Session.DSN#">
						select b.Pid as Cedula, b.Ppersoneria,
									 case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end as NombreCompleto
							from ISBpersona b
						where b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
					</cfquery>

					<cfquery name="personaRepresentante" datasource="#Session.DSN#">
						select count(1) as cant
							from ISBpersonaRepresentante a
						where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
						and RJtipo = 'L'
					</cfquery>
					
					<cfif rs.recordCount gt 0 and len(rs.Cedula) gt 0>
						<cfinvoke component="saci.ws.intf.H048_restriccion_por_spam" method="tiene_restriccion" returnvariable="wsr">
							<cfinvokeargument name="cedula" value="#rs.Cedula#">
							<cfinvokeargument name="S02CON" value="0">
						</cfinvoke>
						<cfif wsr>
							<cfoutput>
								<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
								<input type="hidden" name="AgPaquete" value="#session.saci.vendedor.agentes#" />
								<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
								<cfif form.paso eq 7>
									<cfset form.paso = 0>
								</cfif>
								<cfinclude template="venta-hiddens.cfm">
								<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td valign="top" align="center" nowrap>
											<font color="red">
												<strong>
													El Cliente: #rs.Cedula#&nbsp;-&nbsp;#rs.NombreCompleto#, tiene restricción por spam
												</strong>
											</font>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
								</table>
								</form>
							</cfoutput>	
						<cfelseif personaRepresentante.cant eq 0 and rs.Ppersoneria eq 'J'>
							<cfoutput>
								<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
								<input type="hidden" name="AgPaquete" value="#session.saci.vendedor.agentes#" />
								<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
								<cfif form.paso eq 7>
									<cfset form.paso = 0>
								</cfif>
								<cfinclude template="venta-hiddens.cfm">
								<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td valign="top" align="center" nowrap>
											<font color="red">
												<strong>
													El Cliente: #rs.Cedula#&nbsp;-&nbsp;#rs.NombreCompleto#, no tiene Representante Legal
												</strong>
											</font>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
								</table>
								</form>
							</cfoutput>							
						<cfelse>
							<cfinclude template="venta-contrato.cfm">
						</cfif>
					</cfif>
				</cfif>
			</div>
		</cf_tab>
		<cf_tab text="Usuario SACI" selected="#form.tab eq 4#">
			<div style="height: 300; vertical-align:top; ">
				<cfif form.tab eq 4>
					<cfinclude template="venta-usuario.cfm">
				</cfif>
			</div>
		</cf_tab>
	</cf_tabs>
	<br />
<cfelse>
	<br />
	<cfinclude template="venta-params.cfm">
	<cf_tabs width="100%">
		<cf_tab text="Registro de Cliente" selected="#form.tab eq 1#">
			<div style="vertical-align:top;">
				<cfif form.tab eq 1>
					<cfinclude template="venta-cliente.cfm">
				</cfif>
			</div>
		</cf_tab>
<!---		<cf_tab text="Registro de Contacto" selected="#form.tab eq 2#">
			<div style="vertical-align:top;">
				<cfif form.tab eq 2>
					<cfinclude template="venta-representantes.cfm">
				</cfif>
			</div>
		</cf_tab>--->
		<cf_tab text="Contrato de Servicios" selected="#form.tab eq 2#">
			<div style="vertical-align:top;">
				<cfif form.tab eq 2>
					
					<!-----Se agrega validacion por interfaz de restriccion de spam------->
					<cfquery name="rs" datasource="#Session.DSN#">
						select b.Pid as Cedula, b.Ppersoneria,
									 case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) end as NombreCompleto
							from ISBpersona b
						where b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
					</cfquery>

					<cfquery name="personaRepresentante" datasource="#Session.DSN#">
						select count(1) as cant
							from ISBpersonaRepresentante a
						where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
						and RJtipo = 'L'
					</cfquery>
					
					<cfif rs.recordCount gt 0 and len(rs.Cedula) gt 0>
						<cfinvoke component="saci.ws.intf.H048_restriccion_por_spam" method="tiene_restriccion" returnvariable="wsr">
							<cfinvokeargument name="cedula" value="#rs.Cedula#">
							<cfinvokeargument name="S02CON" value="0">
						</cfinvoke>
						<cfif wsr>
							<cfoutput>
								<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
								<input type="hidden" name="AgPaquete" value="#session.saci.vendedor.agentes#" />
								<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
								<cfif form.paso eq 7>
									<cfset form.paso = 0>
								</cfif>
								<cfinclude template="venta-hiddens.cfm">
								<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td valign="top" align="center" nowrap>
											<font color="red">
												<strong>
													El Cliente: #rs.Cedula#&nbsp;-&nbsp;#rs.NombreCompleto#, tiene restricción por spam
												</strong>
											</font>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
								</table>
								</form>
							</cfoutput>	
						<cfelseif personaRepresentante.cant eq 0 and rs.Ppersoneria eq 'J'>
							<cfoutput>
								<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
								<input type="hidden" name="AgPaquete" value="#session.saci.vendedor.agentes#" />
								<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
								<cfif form.paso eq 7>
									<cfset form.paso = 0>
								</cfif>
								<cfinclude template="venta-hiddens.cfm">
								<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td valign="top" align="center" nowrap>
											<font color="red">
												<strong>
													El Cliente: #rs.Cedula#&nbsp;-&nbsp;#rs.NombreCompleto#, no tiene Representante Legal
												</strong>
											</font>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
								</table>
								</form>
							</cfoutput>							
						<cfelse>
							<cfinclude template="venta-contrato.cfm">
						</cfif>
					</cfif>
				</cfif>
			</div>
		</cf_tab>
		<cf_tab text="Usuario SACI" selected="#form.tab eq 3#">
			<div style="height: 300; vertical-align:top; ">
				<cfif form.tab eq 3>
					<cfinclude template="venta-usuario.cfm">
				</cfif>
			</div>
		</cf_tab>
	</cf_tabs>
	<br />
</cfif>	
	<script type="text/javascript" language="javascript">
		function tab_set_current (n) {
			var params = '';
			var pq = '';
			if (document.form1.Pquien != undefined && document.form1.Pquien.value != '') {
				pq = document.form1.Pquien.value;
				document.form1.pq.value = pq;
				params = params + '&pq=' + pq;
			} else if (n != '1') {
				alert('Debe registrar o seleccionar un cliente antes de continuar');
				return false;
			}
			
			<!--- Se mantiene la cuenta y el paso solamente si es la misma persona con la que se ha estado trabajando --->
			if (pq != '' && pq == '<cfoutput>#Form.Pquien#</cfoutput>') {
				if (document.form1.CTid != undefined && document.form1.CTid.value != '') {
					params = params + '&cue=' + document.form1.CTid.value;
				} else if (document.form1.cue != undefined && document.form1.cue.value != '') {
					params = params + '&cue=' + document.form1.cue.value;
				}
				if (document.form1.paso != undefined && document.form1.paso.value != '') {
					params = params + '&paso=' + document.form1.paso.value;
				}
			}
			
			<cfoutput>
			location.href = '#CurrentPage#?tab='+escape(n)+params;
			</cfoutput>										
		}
	</script>
	
<cf_templatefooter>
