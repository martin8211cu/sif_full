<cfquery name="rsAllContratos" datasource="#session.DSN#">
	select  a.Contratoid, 
			b.PQcodigo, b.Ecodigo, b.Miso4217, b.MRidMayorista, b.PQnombre, b.PQdescripcion, b.PQinicio, b.PQcierre,
			b.PQcomisionTipo, b.PQcomisionPctj, b.PQcomisionMnto, b.PQtoleranciaGarantia, b.PQtarifaBasica, 
			b.PQcompromiso, b.PQhorasBasica, b.PQprecioExc, b.Habilitado, b.PQroaming, b.PQmailQuota, b.PQinterfaz, b.PQtelefono, 
		   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
	from ISBproducto a
		inner join ISBpaquete b
			on b.PQcodigo = a.PQcodigo
			and b.Habilitado=1
		inner join ISBcuenta c
			on c.CTid = a.CTid
			and c.Habilitado=1
			and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente#">
	where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
		and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
		and a.CTcondicion not in ('C','0','X') 
	order by a.Contratoid
</cfquery>

<cfif isdefined("session.saci.cambioPQ.PQnuevo") and len(trim(session.saci.cambioPQ.PQnuevo)) and session.saci.cambioPQ.estado EQ 1>
	<cfquery name="rsPQnuevo" datasource="#session.DSN#">
		select	b.PQcodigo, b.Ecodigo, b.Miso4217, b.MRidMayorista, b.PQnombre, b.PQdescripcion, b.PQinicio, b.PQcierre,
				b.PQcomisionTipo, b.PQcomisionPctj, b.PQcomisionMnto, b.PQtoleranciaGarantia, b.PQtarifaBasica, 
				b.PQcompromiso, b.PQhorasBasica, b.PQprecioExc, b.Habilitado, b.PQroaming, b.PQmailQuota, b.PQinterfaz, b.PQtelefono,
				(select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
		from ISBpaquete b
		where	b.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
				and b.Habilitado=1 
		order by b.PQcodigo
	</cfquery>
</cfif>
<!------------------------------- Despliega el paquete seleccionado y modificable -------------------------------------->
<!---Consulta el plazo de vencimiento en dias para los logines que estan retirados--->
<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">	
	<cfinvokeargument name="Pcodigo" value="40">
</cfinvoke>
<cfquery name="rsLogines" datasource="#session.DSN#">
	select a.LGnumero, a.Contratoid, coalesce(a.Snumero, 0) as Snumero, a.LGlogin, a.LGrealName, a.LGcese, a.LGserids, a.Habilitado, a.LGmostrarGuia,a.LGprincipal
	,case a.Habilitado when 1 then 'Activo' else 'Retirado' end as estado
	from ISBlogin a
	where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAllContratos.Contratoid#">
		and ((a.Habilitado = 1) or
	 		( 	(a.Habilitado=2) ))<!---and 
				(datediff( day, a.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">	)))--->
	order by a.LGprincipal desc, a.LGnumero
</cfquery>
<cfset loginesid = ValueList(rsLogines.LGnumero, ',')>
<cfset sobresnum = ValueList(rsLogines.Snumero, ',')>
<cfset logines = ValueList(rsLogines.LGlogin, ',')> 

<cfoutput>

	<form name="form1" method="post" style="margin: 0;" action="gestion-paquetes-apply.cfm" onsubmit="javascript: return validar(this);">
		<cfinclude template="gestion-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">	  
		  	<!-------------------------------------Pintado del PAQUETE ACTUAL en base de datos--------------------------------------->
		  	<tr>
				<td align="right"><label><cf_traducir key="paquete">Paquete</cf_traducir></label></td>
				<td>
				
					<input type="hidden" name="CTid" value="#form.CTid#"/>
					<input type="hidden" name="Contratoid" value="#rsAllContratos.Contratoid#" />
					<input type="hidden" name="CTcondicion" value="1" />
					<input type="text" name="PQcodigo1"  class="cajasinbordeb" style="text-align: right;" width="10" value="<cfoutput>#rsAllContratos.PQnombre#</cfoutput>" readonly tabindex="1"/>
				</td>
			<!---</tr>
			<tr>--->
				<td align="right" nowrap><label>Tarifa B&aacute;sica
												<!---<cf_traducir key="tarifa">Tarifa</cf_traducir>
												<cf_traducir key="basica">B&aacute;sica</cf_traducir>--->
										 </label>
				</td>
				<td>
					<input type="text" name="PQtarifaBasica1"  class="cajasinbordeb" style="text-align: right;" width="10" value="<cfoutput>#LSNumberFormat(rsAllContratos.PQtarifaBasica,',9.00')#</cfoutput>" readonly tabindex="1" />
				</td>
			</tr>
			<tr>
				<td  align="right" nowrap><label>	Derecho Hora Mensual
													<!---<cf_traducir key="derecho">Derecho</cf_traducir> 
													<cf_traducir key="hora">Hora</cf_traducir>s
													<cf_traducir key="mensual">Mensuales</cf_traducir>--->
										  </label>
				</td>
				<td>
					<input type="text" name="PQhorasBasica1"  class="cajasinbordeb" style="text-align: right;" width="10" value="<cfoutput>#LSNumberFormat(rsAllContratos.PQhorasBasica,',9.00')#</cfoutput>" readonly tabindex="1"/>
				</td>
			<!---</tr>
		
			<tr>--->
				<td  align="right" nowrap><label>	Costo Hora Adicional
													<!---<cf_traducir key="costo">Costo</cf_traducir>
													<cf_traducir key="hora">Hora </cf_traducir>
													<cf_traducir key="adicional">Adicional</cf_traducir>--->
										  </label>
				</td>
				<td>
					<input type="text" name="PQprecioExc1" class="cajasinbordeb" style="text-align: right;" width="10" value="<cfoutput>#LSNumberFormat(rsAllContratos.PQprecioExc,',9.00')#</cfoutput>" readonly tabindex="1"/>
				</td>
			</tr>
			<tr>
				<td  align="right" nowrap><label>	Cantidad de Correos
													<!---<cf_traducir key="cantidad">Cantidad</cf_traducir> 
													<cf_traducir key="de">de</cf_traducir> 
													<cf_traducir key="correo">Correo</cf_traducir>--->
										</label>
				</td>
				<td>
					<input type="text" name="CantidadCorreos1" class="cajasinbordeb" style="text-align: right;" width="10" value="<cfoutput>#LSNumberFormat(rsAllContratos.CantidadCorreos,',9.00')#</cfoutput>" readonly  tabindex="1"/>
				</td>
			<!---</tr>
		
			<tr>--->
				<td align="right" nowrap><label>Cuota Mail</label></td>
				<td>
					<input type="hidden" name="PQmailQuota1" value="#LSNumberFormat(rsAllContratos.PQmailQuota,'9')#"/>
					<input type="text" name="PQmailQuo" class="cajasinbordeb" style="text-align: right;" width="10" value="#LSNumberFormat(rsAllContratos.PQmailQuota,'9')# &nbsp;KB" readonly tabindex="1" /> 
					<script language="javascript" type="text/javascript">
						function solicitarCampos1() {	<!--- Determina que tipos de servicio va a tener cada login --->
							<cfoutput>
							for (var i=1; i<=3; i++) {
								var x = eval('document.form1.Login_Tipo_'+i+'_#rsAllContratos.Contratoid#');
								x.value = "0";
							}
							for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_CABM1.value); i++) {
								var x = eval('document.form1.Login_Tipo_'+i+'_#rsAllContratos.Contratoid#');
								x.value = "" + (parseInt(x.value) + 1);
							}
							for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_ACCS1.value); i++) {
								var x = eval('document.form1.Login_Tipo_'+i+'_#rsAllContratos.Contratoid#');
								x.value = "" + (parseInt(x.value) + 2);
							}
							for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_MAIL1.value); i++) {
								var x = eval('document.form1.Login_Tipo_'+i+'_#rsAllContratos.Contratoid#');
								x.value = "" + (parseInt(x.value) + 4);
							}
							document.form1.PQtarifaBasica1.value = document.form1.vPQtarifaBasica1.value;
							document.form1.PQhorasBasica1.value = document.form1.vPQhorasBasica1.value;
							document.form1.PQprecioExc1.value = document.form1.vPQprecioExc1.value;
							document.form1.PQmailQuota1.value = document.form1.vPQmailQuota1.value;
							document.form1.CantidadCorreos1.value = document.form1.vCantidadCorreos1.value;
							for (var i=1; i<=3; i++) {
								var x = eval('document.form1.Login_Tipo_'+i+'_#rsAllContratos.Contratoid#');
								var y = eval('document.form1.Login_'+i+'_#rsAllContratos.Contratoid#');
								var z = eval('document.form1.Snumero_'+i+'_#rsAllContratos.Contratoid#');
								if (x.value == '0') {
									y.disabled = true;
									<!--- z.disabled = true; --->
								} else {
									y.disabled = false;
									<!--- z.disabled = false; --->
								}
							}
							</cfoutput>	
						}
					</script>
				</td>
			</tr>
			<tr><td colspan="4"><hr /></td></tr>
			<tr class="tituloAlterno" align="center"><td colspan="4">Logines Asociados</td></tr>
			<tr><td colspan="4">	
				<table width="100%"cellpadding="1" cellspacing="0" border="0">
					<tr class="subTitulo">
						<td><label><cf_traducir key="login">Login</cf_traducir></label></td>
						<td><label><cf_traducir key="estado">Estado</cf_traducir></label></td>
						<td>&nbsp;<label><cf_traducir key="servicio">Servicio</cf_traducir></label></td>
					</tr>
					<cfset cont = 1>
					<cfloop query="rsLogines">
						<cfset id= rsLogines.LGnumero>
						<cfset est= rsLogines.estado>
						<cfquery name="rsServicios" datasource="#session.DSN#">
							select distinct b.TScodigo,b.TSnombre
							,case when b.TStipo='A' then  '<img src=''/cfmx/saci/images/outlog.gif''  border=''0'' style=''border:0;margin:0;'' width=''13'' height=''14''>'
								  when b.TStipo='C' then '<img src=''/cfmx/saci/images/outlog1.gif''  border=''0'' style=''border:0;margin:0;'' width=''13'' height=''14''>'
											else '' end as tipo
							from ISBserviciosLogin a
								inner join ISBservicioTipo b
								on b.TScodigo = a.TScodigo
								and b.Habilitado = 1
							where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
							and a.Habilitado = 1
						</cfquery>
						<tr>
							<td valign="top">#ListGetAt(logines, cont, ',')#<cfif rsLogines.LGprincipal EQ 1>(Principal)</cfif></td>
							<td valign="top">#est#</td>
							<td>
								<cfloop query="rsServicios">
									<table border="0" cellpadding="0" cellspacing="0"><tr>
									<td height="14" width="13" align="right" nowrap>#rsServicios.tipo#</td>
									<td>#rsServicios.TSnombre#<br></td>
									</tr></table>
								</cfloop>
								<br />
							</td>
						</tr>
						<cfset cont = 1+cont>
					</cfloop>
				</table>
			</td></tr>
		</table>
	</form>
</cfoutput>
