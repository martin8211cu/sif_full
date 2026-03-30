<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cfif isdefined("url.tab") and Len(Trim(url.tab))> 
		<br />
		<cfinclude template="agente-params.cfm">

			<cf_tabs width="100%" >
				<cf_tab text="Registro de Agente" selected="#form.tab eq 1#">
					<div style="vertical-align:top;">
						<cfif form.tab eq 1>
							<cfinclude template="agente_registro.cfm">
						</cfif>
					</div>
				</cf_tab>
				<cfset txtContacto = "Registro de Contactos">
				<cfif isdefined("Form.Pquien")>
					<cfquery name="rsContactos" datasource="#Session.DSN#">
						Select Count(1) as cant
							From ISBpersona a
								inner join ISBpersonaRepresentante b
								on a.Pquien = b.Pquien							
						Where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">		
					</cfquery>					
				   <cfif rsContactos.cant gt 0>			
						 <cfset txtContacto = "<u>Registro de Contactos &radic;</u>">
				  </cfif>
				</cfif>
				<cf_tab text=#txtContacto# selected="#form.tab eq 2#">
					<div style="vertical-align:top;">
						<cfif form.tab eq 2>
							<cfinclude template="agente-representantes.cfm">
						</cfif>
					</div>
				</cf_tab>
				<cfset txtCuentas = "Cuentas">
				<cfif isdefined("Form.Pquien")>
					<cfquery name="rsCuentas" datasource="#Session.DSN#">
						Select Count(1) as cant
							From ISBpersona a
								inner join ISBcuenta b
								on a.Pquien = b.Pquien								
						Where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">		
						and b.Habilitado = 1
					</cfquery>					
				   <cfif rsCuentas.cant gt 0>			
						 <cfset txtCuentas = "<u>Cuentas &radic;</u>">
				  </cfif>
				</cfif>
				
				<cf_tab text=#txtCuentas# selected="#form.tab eq 3#">
					<div style="vertical-align:top; ">
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
				
							<cfif personaRepresentante.cant eq 0 and rs.Ppersoneria eq 'J'>
								<cfoutput>									
									<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
									<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.ag))>#form.AGid#</cfif>" />
									<input type="hidden" name="ag" value="<cfif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
									<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and Len(Trim(form.tipo))>#form.tipo#</cfif>" />
									<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
										
										<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td valign="top" align="center" nowrap>
												<font color="red">
													<strong>
														El Cliente: #rs.Cedula#&nbsp;-&nbsp;#rs.NombreCompleto#, no tiene Representante Legal													</strong>												</font>											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
									</table>
									</form>
								</cfoutput>							
							<cfelse>	
								<cfinclude template="agente_cuenta.cfm">
							</cfif>													
						</cfif>
					</div>
				</cf_tab>	
				<cfset textCobetura = "Cobertura">
				<cfif isdefined("Form.Pquien")>
					<cfquery name="rsCobertura" datasource="#Session.DSN#">
						Select Count(1) as cant
							From ISBagente a
								inner join ISBagenteCobertura b
								on a.AGid = b.AGid
						Where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">		
						and b.Habilitado = 1
					</cfquery>
					
				   <cfif rsCobertura.cant gt 0>			
						 <cfset textCobetura = "<u>Cobertura &radic;</u>">
				  </cfif>
				</cfif>
				<cf_tab text=#textCobetura#  selected="#form.tab eq 4#">				
					<div style="vertical-align:top;">
						<cfif form.tab eq 4>
							<cfinclude template="agente_cobertura.cfm">
						</cfif>
					</div>	
				</cf_tab>
				<cfset txtProductos = "Productos">
				<cfif isdefined("Form.Pquien")>
					<cfquery name="rsProductos" datasource="#Session.DSN#">
						Select Count(1) as cant
							From ISBpersona a
								inner join ISBagente b
								on a.Pquien = b.Pquien
								inner join ISBagenteOferta c
								on b.AGid = c.AGid								
						Where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">		
					</cfquery>					
				   <cfif rsProductos.cant gt 0>			
						 <cfset txtProductos = "<u>Productos &radic;</u>">
				  </cfif>
				</cfif>

				<cf_tab text=#txtProductos# selected="#form.tab eq 5#">
					<div style="vertical-align:top;">
						<cfif form.tab eq 5>
							<cfinclude template="agente-productos.cfm">
						</cfif>
					</div>				
				</cf_tab>
				<cfset txtUsuario = "Usuario SACI">
				<cfif isdefined("Form.Pquien") and isdefined("Form.AGid")>
					<cfquery name="rsUsuario" datasource="#Session.DSN#">
					select Count(1) as cant
						from asp..Usuario a
							inner join asp..DatosPersonales b
						on a.datos_personales = b.datos_personales
							inner join ISBpersona c
						on b.Pid = c.Pid
							inner join UsuarioReferencia d
						on a.Usucodigo = d.Usucodigo 
						and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.AGid#">
						and STabla = 'ISBagente'   
					where c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
					</cfquery>					
				   <cfif rsUsuario.cant gt 0>			
						 <cfset txtUsuario = "<u>Usuario SACI &radic;</u>">
				  </cfif>
				</cfif>
				<cf_tab text="#txtUsuario#" selected="#form.tab eq 6#">
					<div style="height: 300; vertical-align:top; ">
						<cfif form.tab eq 6>
							<cfinclude template="agente-usuario.cfm">
						</cfif>
					</div>
				</cf_tab>
				<cfset txtValoraciones = "Valoraciones">
				<cfif isdefined("Form.Pquien")>
					<cfquery name="rsValoraciones" datasource="#Session.DSN#">
					Select Count(1) as cant
							From ISBpersona a
								inner join ISBagente b
								on a.Pquien = b.Pquien
								inner join ISBagenteValoracion c
								on b.AGid = c.AGid								
						Where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">								
					</cfquery>					
				   <cfif rsValoraciones.cant gt 0>			
						 <cfset txtValoraciones = "<u>Valoraciones &radic;</u>">
				  </cfif>
				</cfif>
				<cf_tab text=#txtValoraciones# selected="#form.tab eq 7#">
					<div style="height: 300; vertical-align:top; ">
						<cfif form.tab eq 7>
							<cfinclude template="agente-valoracion.cfm">
						</cfif>
					</div>
				</cf_tab>			
				<cf_tab text="Informaci&oacute;n de Servicios" selected="#form.tab eq 8#">
					<div style="vertical-align:top; ">
						<cfif form.tab eq 8>
							<cfinclude template="agente-InfoServicios.cfm">
						</cfif>
					</div>
				</cf_tab>
				<cf_tab text="Comprobaci&oacute;n Informaci&oacute;n Agente" selected="#form.tab eq 9#">
					<div style="vertical-align:top; ">
						<cfif form.tab eq 9>
							<cfinclude template="agente-resumen.cfm">
						</cfif>
					</div>
				</cf_tab>				
			</cf_tabs>
			<br />	
		<script type="text/javascript" language="javascript">
			function funcLista() {
				var params = '';

				<!--- Variables de la lista --->
				if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
					params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
				}
				if (document.form1.Filtro_Ppersoneria != undefined && document.form1.Filtro_Ppersoneria.value != '') {
					params = params + '&Filtro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
					params = params + '&hFiltro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
				}
				if (document.form1.Filtro_Pid != undefined && document.form1.Filtro_Pid.value != '') {
					params = params + '&Filtro_Pid=' + document.form1.Filtro_Pid.value;
					params = params + '&hFiltro_Pid=' + document.form1.Filtro_Pid.value;
				}
				if (document.form1.Filtro_nom_razon != undefined && document.form1.Filtro_nom_razon.value != '') {
					params = params + '&Filtro_nom_razon=' + document.form1.Filtro_nom_razon.value;
					params = params + '&hFiltro_nom_razon=' + document.form1.Filtro_nom_razon.value;
				}
				if (document.form1.Filtro_Habilitado != undefined && document.form1.Filtro_Habilitado.value != '') {
					params = params + '&Filtro_Habilitado=' + document.form1.Filtro_Habilitado.value;
					params = params + '&hFiltro_Habilitado=' + document.form1.Filtro_Habilitado.value;
				}
				
				<cfoutput>
				location.href = '#CurrentPage#?tab='+params;
				</cfoutput>
				return false;
			}

			function tab_set_current (n) {
				var params = '';
				var ag = '';
				if (document.form1.AGid != undefined && document.form1.AGid.value != '') {
					ag = document.form1.AGid.value;
					document.form1.ag.value = document.form1.AGid.value;
					params = params + '&ag=' + document.form1.ag.value;
					params = params + '&tipo=' + document.form1.tipo.value;
				} else if (n != '1') {
					alert('Debe registrar o seleccionar un agente antes de continuar');
					return false;
				}
				
				<!--- Se mantiene la cuenta y el paso solamente si es la misma persona con la que se ha estado trabajando --->


				if (ag != '' && ag == '<cfoutput>#Form.AGid#</cfoutput>') {					
					if (document.form1.CTid != undefined && document.form1.CTid.value != '') {
						params = params + '&cue=' + document.form1.CTid.value;
					} else if (document.form1.cue != undefined && document.form1.cue.value != '') {
						params = params + '&cue=' + document.form1.cue.value;
					}
					if (document.form1.paso != undefined && document.form1.paso.value != '') {
						params = params + '&paso=' + document.form1.paso.value;
					}
						//if (document.form1.tipo != undefined && document.form1.tipo.value != '') {
						//params = params + '&tipo=' + document.form1.tipo.value;
					//}

				}
				
				<!--- Variables de la lista --->
				if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
					params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
				}
				if (document.form1.Filtro_Ppersoneria != undefined && document.form1.Filtro_Ppersoneria.value != '') {
					params = params + '&Filtro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
					params = params + '&hFiltro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
				}
				if (document.form1.Filtro_Pid != undefined && document.form1.Filtro_Pid.value != '') {
					params = params + '&Filtro_Pid=' + document.form1.Filtro_Pid.value;
					params = params + '&hFiltro_Pid=' + document.form1.Filtro_Pid.value;
				}
				if (document.form1.Filtro_nom_razon != undefined && document.form1.Filtro_nom_razon.value != '') {
					params = params + '&Filtro_nom_razon=' + document.form1.Filtro_nom_razon.value;
					params = params + '&hFiltro_nom_razon=' + document.form1.Filtro_nom_razon.value;
				}
				if (document.form1.Filtro_Habilitado != undefined && document.form1.Filtro_Habilitado.value != '') {
					params = params + '&Filtro_Habilitado=' + document.form1.Filtro_Habilitado.value;
					params = params + '&hFiltro_Habilitado=' + document.form1.Filtro_Habilitado.value;
				}
				
				<cfoutput>
				location.href = '#CurrentPage#?tab='+escape(n)+params;
				</cfoutput>
			}
		</script>

	<cfelse>
		<cf_web_portlet_start titulo="Lista de Agentes">
			<cfinclude template="agente_lista.cfm">
		<cf_web_portlet_end> 
	</cfif>
	
<cf_templatefooter>
