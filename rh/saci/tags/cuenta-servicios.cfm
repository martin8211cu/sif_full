<!--- Obtener la cantidad máxima de logines que se pueden asignar por paquete --->

<cfinvoke component="saci.ws.intf.base" method="servpaq" returnvariable="maxlogines">
	<cfinvokeargument name="paquete" value="">
</cfinvoke>

<cfquery name="maxServicios" datasource="#Attributes.Conexion#">
	select max(cant) as cantidad
	from (
		select coalesce(sum(SVcantidad), 0) as cant
		from ISBservicio
		where Habilitado = 1
		group by PQcodigo
	) temporal
</cfquery>

<cfset maxServicios.cantidad = maxlogines>


<cfquery name="rsServiciosDisponibles" datasource="#Attributes.Conexion#">
	select TScodigo
	from ISBservicioTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	order by TSnombre
</cfquery>

<cfif ExisteCuenta>
	<cfquery name="rsAllContratos" datasource="#Attributes.Conexion#">
		select a.Contratoid, a.CNsuscriptor, a.CNnumero, a.CTcondicion,
			   b.PQcodigo, b.Miso4217, b.MRidMayorista, b.PQnombre, b.PQcomisionTipo, b.PQcomisionPctj, b.PQcomisionMnto, b.PQtoleranciaGarantia, b.PQtarifaBasica, b.PQcompromiso, b.PQhorasBasica, b.PQprecioExc, b.PQroaming, b.PQmailQuota, b.PQtelefono, b.PQinterfaz,
			   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
			   <cfloop query="rsServiciosDisponibles">
			   , coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#
			   </cfloop>
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo = a.PQcodigo
			inner join ISBcuenta c
				on c.CTid = a.CTid
				and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		<cfif Attributes.vista EQ 1 or Attributes.vista EQ 3>
		and a.CTcondicion = 'C'
		<cfelseif Attributes.vista EQ 2>
		and a.CTcondicion = '0'
		</cfif>
		order by a.Contratoid
	</cfquery>
	

	
	
	<cfquery name="rsContratosAprobados" datasource="#Attributes.Conexion#">
		select b.PQcodigo, b.PQnombre
			   <cfloop query="rsServiciosDisponibles">
			   , coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#
			   </cfloop>
			   ,e.ECnombre
			   , Case when CTcondicion = 'C' Then 'Captura'
			   		  when CTcondicion = '0' Then 'Documentación Pendiente'
					  when CTcondicion = '1' Then 'Aprobado'
					  when CTcondicion = 'X' then 'Rechazado'
				else
					 'estado sin definir'
				End contratoen	 	  	
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo = a.PQcodigo
			inner join ISBcuenta c
				on c.CTid = a.CTid
				and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
			inner join ISBcuentaEstado e
				on e.ECidEstado = c.ECidEstado
			
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		and a.CTcondicion not in ('C','X')	<!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
		order by a.Contratoid
	</cfquery>
			
</cfif>


<cfif Attributes.vista NEQ 2>
	<cfset permiteAgregarPaquetes = Attributes.vista NEQ 3>
	<cfoutput>
		<input type="hidden" name="CTid" value="<cfif ExisteCuenta>#rsCuenta.CTid#</cfif>">		
		<input type="hidden" name="CTtipoUso" value="<cfif ExisteCuenta>#rsCuenta.CTtipoUso#</cfif>">
		<input type="hidden" name="CTcobrable" value="<cfif Attributes.cobrable>C<cfelse>S</cfif>">	<!--- Variable que indica si una una cuenta es cobrable o de servicio --->
		<input type="hidden" name="cantPaquetes" value="<cfif permiteAgregarPaquetes>#rsAllContratos.recordCount+1#<cfelse>#rsAllContratos.recordCount#</cfif>" />
		<cfset ts = "">
		<cfif ExisteCuenta>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsCuenta.ts_rversion#" returnvariable="ts"></cfinvoke>
		</cfif>	
		<input type="hidden" name="ts_rversion" value="#ts#">		
		
		<!--- Iframe utilizado para la asignación de sobres a logines por javascript --->
		<iframe id="frSobre" name="frSobre" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="4" class="subTitulo"><strong>Configurar Servicios</strong></td>
		  </tr>
		  <tr>
			<td width="15%" valign="top" align="#Attributes.alignEtiquetas#"><label>No. Cuenta</label></td>
			<td nowrap>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td nowrap>
						<cfif ExisteCuenta>
							<cfif rsCuenta.CUECUE GT 0>#rsCuenta.CUECUE#<cfelse>&lt;Por Asignar&gt;</cfif> <cfif rsCuenta.CTtipoUso EQ 'A'>(Acceso)<cfelseif rsCuenta.CTtipoUso EQ 'F'>(Especial)</cfif>
						<cfelse>
							&lt;Por Asignar&gt;
						</cfif>
					</td>
				  </tr>
				  <cfif ExisteCuenta and isdefined("LvarFacturacionCUECUE")>
				  <tr>
					<td nowrap>
						<cfif LvarFacturacionCUECUE GT 0>#LvarFacturacionCUECUE#<cfelse>&lt;Por Asignar&gt;</cfif> (Especial)
					</td>
				  </tr>
				  </cfif>
				</table>
			</td>
			<td valign="top" align="#Attributes.alignEtiquetas#"><label>Fecha de Apertura</label></td>
			<td valign="top">
				<cfset apertura = LSDateFormat(Now(), 'dd/mm/yyyy')>
				<cfif ExisteCuenta>
					<cfset apertura = LSDateFormat(rsCuenta.CTapertura, 'dd/mm/yyyy')>
				</cfif>
				<input type="hidden" name="CTapertura" value="#apertura#" />
				#apertura#
			</td>
		  </tr>
		  <tr>
			<td width="15%" align="#Attributes.alignEtiquetas#"><label>Grupo de Cobro</label></td>
			<td>
				<cfset grupo = "">
				<cfif ExisteCuenta>
					<cfset grupo = rsCuenta.GCcodigo>
				</cfif>
				<cf_grupoCobro
					id = "#grupo#"
					form = "#Attributes.form#"
					sufijo = ""
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
				>
			</td>
			<td align="#Attributes.alignEtiquetas#"><label>Clase de Cuenta</label></td>
			<td>
				<cfset clasecuenta = "">
				<cfif ExisteCuenta>
					<cfset clasecuenta = rsCuenta.CCclaseCuenta>
				</cfif>
				<cf_claseCuenta
					id = "#clasecuenta#"
					form = "#Attributes.form#"
					sufijo = ""
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
				>
			</td>
		  </tr>
	
		  <cfif Isdefined(session.saci.vendedor.agentes) and session.saci.vendedor.agentes neq 0>
		  <tr>
			<td align="#Attributes.alignEtiquetas#" valign="top" nowrap><label>Código de Agente</label></td>
			<td colspan="3">
			#session.saci.vendedor.agentes#
			</td>
		  </tr>
		</cfif>
		  <tr>
			<td align="#Attributes.alignEtiquetas#" valign="top" nowrap><label>Observaciones</label></td>
			<td colspan="3">
				<cfif Attributes.readOnly>
					<cfif ExisteCuenta>#HTMLEditFormat(Trim(rsCuenta.CTobservaciones))#</cfif>
				<cfelse>
					<textarea name="CTobservaciones" id="CTobservaciones" rows="2" style="width: 100%" onblur="javascript: this.value = this.value.toUpperCase();" tabindex="1"><cfif ExisteCuenta>#HTMLEditFormat(Trim(rsCuenta.CTobservaciones))#</cfif></textarea>
				</cfif>
			</td>
		  </tr>	  
		  <tr>
		  	<td colspan="4">
			<center><label>La información de localización es sugerida de los datos de persona&nbsp;&nbsp;</label>
				<a style="color:##990033; font-weight:bold" href="javascript:show_info_location(true);">Cambiar</a>&nbsp;/
				<a style="color:##990033; font-weight:bold" href="javascript:show_info_location(false);">Ocultar</a>
			</center>
			<span id="info_location" width="100%" style="visibility:visible; display:inline;">
				<hr />
				<cfset pcambio = false>
				<cfif ExisteCuenta>
					<cfquery name="rs_cta" datasource="#Attributes.Conexion#">
						select count(1) as r
							from ISBlocalizacion where RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
					 </cfquery>
					 					 
					 <cfif rs_cta.r gt 0>
						<cfset Attributes.RefId = Attributes.id>
						<cfset Attributes.Ltipo = "C">
						<cfset pcambio = true>
					 </cfif>
					
				</cfif>
				
				<cfif pcambio>
					<cf_persona 
							id = "#Attributes.idpersona#"
							form = "#Attributes.form#"
							incluyeTabla = "true"
							porFila = "false"
							sufijo = "#Attributes.sufijo#"
							TypeLocation = "#Attributes.Ltipo#"
							RefIdLocation = "#Attributes.RefId#"
							showOnlyLocation = "true"
						>
				<cfelse>
					<cf_persona 
							form = "#Attributes.form#"
							incluyeTabla = "true"
							porFila = "false"
							sufijo = "#Attributes.sufijo#"
							TypeLocation = "#Attributes.Ltipo#"
							RefIdLocation = "#Attributes.RefId#"							
							showOnlyLocation = "true"
						>
				</cfif>
				
				<hr />				
			</span>
			</td>
		  </tr>
		  
		  <tr>
		  	<td align="center" valign="top" colspan="4">
				<cfset idx = "-1">
				<cfif ExisteCuenta>
					<cfset idx = Attributes.id>
				</cfif>
				<cf_atrExtendidos
					tipo="4"
					id="#idx#"
					form="#Attributes.form#"
					columnas="3"
					sufijo="#Attributes.sufijo#"
					incluyeTabla="true"
				>
			</td>
		</tr>
		
		<tr align="center">
			<td colspan="4">&nbsp;</td>
		 </tr>
	
		<!--- Solo se pueden visualizar paquetes cuando se esta registrando una cuenta de acceso tanto para un cliente o un agente --->
		<cfif ExisteCuenta and (rsCuenta.CTtipoUso EQ 'U' or rsCuenta.CTtipoUso EQ 'A')>
			<!--- Desplegar los paquetes ya seleccionados y NO modificables --->
			<cfloop query="rsContratosAprobados">
			  <cfif rsContratosAprobados.currentRow EQ 1>
			  <tr align="center">
				<td colspan="4" class="subTitulo"><strong>Productos aprobados anteriormente</strong></td>
			  </tr>
			  </cfif>
	
			  <tr>
				<td align="#Attributes.alignEtiquetas#"><label>Paquete</label></td>
				<td>
				
					<cf_paquete 
						id = "#rsContratosAprobados.PQcodigo#"
						sufijo = "X#rsContratosAprobados.currentRow#"
						agente = "#Attributes.filtroAgente#"
						form = "#Attributes.form#"
						filtroPaqInterfaz = "0"
						readOnly = "true"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
						showCodigo="false"
					>(#rsContratosAprobados.contratoen#)
				</td>
				<td align="#Attributes.alignEtiquetas#"><label>Estado de la cuenta</label></td>
				<td>
					#rsContratosAprobados.ECnombre#
				</td>
			  </tr>
	
			</cfloop>
			<!--- Desplegar los paquetes ya seleccionados y modificables --->

			<cfloop query="rsAllContratos">
	
			  <cfquery name="rsLogines" datasource="#Attributes.Conexion#">
				select a.LGnumero, a.Contratoid, coalesce(a.Snumero, 0) as Snumero, a.LGlogin, coalesce(a.LGtelefono, ' ') as LGtelefono, a.LGrealName, a.LGcese, a.LGserids, a.Habilitado, a.LGmostrarGuia
				from ISBlogin a
				where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAllContratos.Contratoid#">
				order by a.LGprincipal desc, a.LGnumero
			  </cfquery>
			  <cfset loginesid = ValueList(rsLogines.LGnumero, ',')>
			  <cfset sobresnum = ValueList(rsLogines.Snumero, ',')>
			  <cfset logines = ValueList(rsLogines.LGlogin, ',')>
			  <cfset telefonos = ValueList(rsLogines.LGtelefono, ',')>
			  <!--- Armar la estructura con los servicios de cada login asociado al contrato --->
			  <cfset loginServ = StructNew()>
			  <cfloop from="1" to="#ListLen(loginesid)#" index="i">
				<cfquery name="rsServiciosLogin" datasource="#Attributes.Conexion#">
					select rtrim(TScodigo) as TScodigo
					from ISBserviciosLogin
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(loginesid, i, ',')#">
					and Habilitado = 1
				</cfquery>
				<cfset loginServ['#ListGetAt(loginesid, i, ',')#'] = ValueList(rsServiciosLogin.TScodigo, ',')>
			  </cfloop>
			  
			  <cfif rsAllContratos.currentRow EQ 1>
			  <tr align="center">
				<td colspan="4" class="subTitulo"><strong>Productos agregados a la cuenta</strong></td>
			  </tr>
			  </cfif>
		
			  <tr>
				<td align="#Attributes.alignEtiquetas#"><label>Paquete</label></td>
				<td colspan="3">
					<cfif Attributes.readOnly>
						<input type="hidden" name="Contratoid#rsAllContratos.currentRow#" value="#rsAllContratos.Contratoid#" class="cajasinbordeb" readonly />
						<input type="hidden" name="CTcondicion#rsAllContratos.currentRow#" value="<cfif Attributes.vista EQ 2>0<cfelse>C</cfif>" class="cajasinbordeb" readonly />
					<cfelse>	
						<input type="hidden" name="Contratoid#rsAllContratos.currentRow#" value="#rsAllContratos.Contratoid#" />
						<input type="hidden" name="CTcondicion#rsAllContratos.currentRow#" value="<cfif Attributes.vista EQ 2>0<cfelse>C</cfif>" />
					</cfif>
					<!------ esto se quito para hacer el conlis visible siempre y porder asignar cualquier paquete que cumpla con 
									 la condicion PQutilizadoagente = 1
									 
						readOnly = "#(ExisteCuenta and rsCuenta.CTtipoUso EQ 'A') or Attributes.readOnly#"
					-------->
					<cf_paquete 
						id = "#rsAllContratos.PQcodigo#"
						sufijo = "#rsAllContratos.currentRow#"
						agente = "#Attributes.filtroAgente#"
						form = "#Attributes.form#"
						funcion = "solicitarCampos#rsAllContratos.currentRow#"
						filtroPaqInterfaz = "0"
						PQutilizadoagente = "true"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
						showCodigo="false"
					>
				</td>
			  </tr>
			  
			  <tr id="trSuscriptor#rsAllContratos.currentRow#" <cfif not (isdefined("rsAllContratos.Cantidad_CABM") and rsAllContratos.Cantidad_CABM GT 0)> style="display: none;"</cfif>>
				<td align="#Attributes.alignEtiquetas#" nowrap><label>Nombre Suscriptor</label></td>
				<td>
					<cfif Attributes.readOnly>
						#rsAllContratos.CNsuscriptor#
					<cfelse>
						<input type="text" name="CNsuscriptor#rsAllContratos.currentRow#" onblur="javascript: this.value = this.value.toUpperCase()" size="30" maxlength="50" value="#rsAllContratos.CNsuscriptor#" tabindex="1" />
					</cfif>
				</td>
				<td align="#Attributes.alignEtiquetas#" nowrap><label>No. Suscriptor</label></td>
				<td>
					<cfif Attributes.readOnly>
						#rsAllContratos.CNnumero#
					<cfelse>
						<input type="text" name="CNnumero#rsAllContratos.currentRow#" size="30" maxlength="20" value="#rsAllContratos.CNnumero#" tabindex="1" />
					</cfif>
				</td>
			  </tr>
	
			  <tr>
				<td align="#Attributes.alignEtiquetas#" nowrap><label>Tarifa B&aacute;sica</label></td>
				<td>
					<input type="text" name="PQtarifaBasica#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQtarifaBasica,',9.00')#" tabindex="-1" readonly />	
				</td>
				<td align="#Attributes.alignEtiquetas#" nowrap><label>Derecho Horas Mensuales</label></td>
				<td>
					<input type="text" name="PQhorasBasica#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQhorasBasica,',9.00')#" tabindex="-1" readonly />
				</td>
			  </tr>
		
			  <tr>
				<td align="#Attributes.alignEtiquetas#" nowrap><label>Costo Hora Adicional</label></td>
				<td>
					<input type="text" name="PQprecioExc#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQprecioExc,',9.00')#" tabindex="-1" readonly />
				</td>
				<td align="#Attributes.alignEtiquetas#" nowrap><label>Cantidad de Correos</label></td>
				<td>
					<input type="text" name="CantidadCorreos#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.CantidadCorreos,',9.00')#" tabindex="-1" readonly />
				</td>
			  </tr>
		
			  <tr>
				<td align="#Attributes.alignEtiquetas#" nowrap>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="#Attributes.alignEtiquetas#" nowrap><label>Cuota Mail</label></td>
				<td>

					<input type="text" name="PQmailQuota#rsAllContratos.currentRow#" class="cajasinbordeb" style="text-align: right;" size="20" value="#LSNumberFormat(rsAllContratos.PQmailQuota,'9')#" tabindex="-1" readonly /> KB
					<script language="javascript" type="text/javascript">
						function cargarServicios#rsAllContratos.currentRow#() {
							var tdServicio;
							var cantidad = 0;
							var existeCABM = false;
							var cantidadconmutados = 0;
							var cantidadcorreos = 0;
							var chkaccs;
							var chkmail;
							

							if (document.#Attributes.form#.vCantidad_MAIL#rsAllContratos.currentRow#)
								cantidadcorreos = parseInt(document.#Attributes.form#.vCantidad_MAIL#rsAllContratos.currentRow#.value);

							 
							 if (document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.currentRow#)
								cantidadconmutados = parseInt(document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.currentRow#.value)	
							
							 if (parseInt(document.#Attributes.form#.vCantidadCable#rsAllContratos.currentRow#.value) > 0)
						 			existeCABM = true; // El paquete tiene servicio de cable.
							
								if (existeCABM)
									cantidad = 	(cantidadconmutados+cantidadcorreos);
								else{		
										if (cantidadcorreos > 0 )
									 	cantidad = cantidadcorreos;
										else
									 	cantidad = cantidadconmutados; 											
									}
							<cfloop query="rsServiciosDisponibles">
								tdServicio = document.getElementById('td#Trim(rsServiciosDisponibles.TScodigo)#_#rsAllContratos.Contratoid#');																
								if (parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.currentRow#.value) > 0) {
									tdServicio.style.display = '';
								} else {
									tdServicio.style.display = 'none';
								}
								for (var i=1; i<=#maxServicios.cantidad#; i++) {
									tdServicio = document.getElementById('td#Trim(rsServiciosDisponibles.TScodigo)#_'+i+'_#rsAllContratos.Contratoid#');
									if (parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.currentRow#.value) > 0) {
										tdServicio.style.display = '';
									} else {
										tdServicio.style.display = 'none';
									}
								}
								for (var i=1; i<=#maxServicios.cantidad#; i++) {
									var x = eval('document.#Attributes.form#.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i+'_#rsAllContratos.Contratoid#');
									<!--- Aplica para el registro de Agentes únicamente --->
									
									if (existeCABM) 
									{
										
										if (i == 1) // nivel 1
											if (x.value == 'ACCS') // en el nivel uno no se permite el acceso conmutado
												x.style.display = 'none';
											else{
												x.style.display = '';
												<cfif Isdefined('session.saci.vendedor.agentes') and session.saci.vendedor.agentes eq 0>
													x.checked = true;
												</cfif>

												}
										else if (i >= 2) 
											{ 
												chkaccs = eval('document.#Attributes.form#.chk_ACCS_'+i+'_#rsAllContratos.Contratoid#');
												chkmail =  eval('document.#Attributes.form#.chk_MAIL_'+i+'_#rsAllContratos.Contratoid#');	
												
												if (i <= parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.currentRow#.value) && x.value == 'CABM'
													|| (x.checked && x.value == 'ACCS')
													|| (x.value == 'ACCS' && cantidadconmutados > 0 && !chkmail.checked)
													|| (x.checked == 'MAIL' && x.value == 'MAIL')
													|| (x.value == 'MAIL' && cantidadcorreos > 0 && chkaccs.style.display == 'none') )
												{	
													if (x.value == 'ACCS')
														cantidadconmutados = cantidadconmutados-1;
													else if (x.value == 'MAIL')
														cantidadcorreos = cantidadcorreos-1;
													
														x.style.display = '';
											
												}else
														
														x.style.display = 'none';
											}
										
									}								 	 
									else {
										
										<cfif Isdefined('session.saci.vendedor.agentes') and session.saci.vendedor.agentes eq 0>
											x.checked = (i <= parseInt(document.#Attributes.form#.vCantidadM_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.currentRow#.value));
										</cfif>
										
										if (i <= parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.currentRow#.value))
												x.style.display = '';
											else
												x.style.display = 'none';
												
					 				} // existecable
								}			
											
							</cfloop>
						
							for (var i=cantidad+1; i<=#maxServicios.cantidad#; i++) {
								document.getElementById("tr_"+ i + "_#rsAllContratos.Contratoid#").style.display="none";
							}
							for (var i=1; i<=cantidad; i++) {
								document.getElementById("tr_"+ i + "_#rsAllContratos.Contratoid#").style.display="";
							}
							
						}
					
						function solicitarCampos#rsAllContratos.currentRow#() {
							var tdTelefono1, tdTelefono2;
							
							document.#Attributes.form#.PQtarifaBasica#rsAllContratos.currentRow#.value = fm(document.#Attributes.form#.vPQtarifaBasica#rsAllContratos.currentRow#.value,2);
							document.#Attributes.form#.PQhorasBasica#rsAllContratos.currentRow#.value = fm(document.#Attributes.form#.vPQhorasBasica#rsAllContratos.currentRow#.value,2);
							document.#Attributes.form#.PQprecioExc#rsAllContratos.currentRow#.value = fm(document.#Attributes.form#.vPQprecioExc#rsAllContratos.currentRow#.value,2);
							document.#Attributes.form#.PQmailQuota#rsAllContratos.currentRow#.value = document.#Attributes.form#.vPQmailQuota#rsAllContratos.currentRow#.value;
							document.#Attributes.form#.CantidadCorreos#rsAllContratos.currentRow#.value = fm(document.#Attributes.form#.vCantidadCorreos#rsAllContratos.currentRow#.value,2);
							if (document.#Attributes.form#.vCantidad_CABM#rsAllContratos.currentRow# && parseInt(document.#Attributes.form#.vCantidad_CABM#rsAllContratos.currentRow#.value) > 0) {
								// Mostrar los campos solicitados para cable modem
								var a = document.getElementById("trSuscriptor#rsAllContratos.currentRow#");
								if (a) a.style.display = '';
							} else {
								// Ocultar los campos solicitados para cable modem
								var a = document.getElementById("trSuscriptor#rsAllContratos.currentRow#");
								if (a) a.style.display = 'none';
							}
							<!--- Mostrar los campos de telefonos si aplica --->
							for (var i=1; i<=#maxServicios.cantidad#; i++) {
								
								tdTelefono1 = document.getElementById('tdTelefono1_'+i+'_#rsAllContratos.Contratoid#');
								tdTelefono2 = document.getElementById('tdTelefono2_'+i+'_#rsAllContratos.Contratoid#');								
								if (document.#Attributes.form#.vPQtelefono#rsAllContratos.currentRow# 
								   && parseInt(document.#Attributes.form#.vPQtelefono#rsAllContratos.currentRow#.value) == 1
								   && document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.currentRow# != undefined
								   && (i <= parseInt(document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.currentRow#.value)) )	
								{	
									tdTelefono1.style.display = '';
									tdTelefono2.style.display = '';
								} else {
									tdTelefono1.style.display = 'none';
									tdTelefono2.style.display = 'none';
								}
							}
							<!--- Marcar los checks con los servicios que tiene cada paquete --->
							cargarServicios#rsAllContratos.currentRow#();
						}
					</script>
				</td>
			  </tr>
			  
			  <tr>
			  <td colspan="4">
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr>
						<td colspan="4">&nbsp;</td>
						<cfloop query="rsServiciosDisponibles">
						<td id="td#Trim(rsServiciosDisponibles.TScodigo)#_#rsAllContratos.Contratoid#" align="center" <cfif Evaluate('rsAllContratos.Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#') EQ 0> style="display:none;"</cfif>><label>#HTMLEditFormat(rsServiciosDisponibles.TScodigo)#</label></td>
						</cfloop>
					</tr>
					
					<!---obtiene la cantidad de servicios permitidos por paquete--->
					<cfquery name="rsCantidadServ" datasource="#Attributes.conexion#">
						select  Sum(SVcantidad)as cantServ  from ISBservicio where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsAllContratos.PQcodigo#">
					</cfquery>
					
					<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
					  <tr id="tr_#iLog#_#rsAllContratos.Contratoid#" <cfif rsCantidadServ.cantServ gt 0 and iLog GT rsCantidadServ.cantServ> style="display:none"</cfif>>
						<td align="#Attributes.alignEtiquetas#"><label>Login #iLog#</label></td>
						<td>
							<table border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td>
									<cfset loginid = "">
									<cfset valLogin = "">
									<cfif ListLen(logines) GTE iLog>
										<cfset loginid = ListGetAt(loginesid, iLog, ',')>
										<cfset valLogin = ListGetAt(logines, iLog, ',')>
									</cfif>
									<cf_login
										idpersona = "#Attributes.idpersona#"
										loginid = "#loginid#"
										value = "#valLogin#"
										form = "#Attributes.form#"
										sufijo = "_#iLog#_#rsAllContratos.Contratoid#"
										Ecodigo = "#Attributes.Ecodigo#"
										Conexion = "#Attributes.Conexion#"
									>
								</td>
								
								<cfif ListLen(logines) GTE iLog>
									<cfset es_acceso = ListFind(loginServ['#ListGetAt(loginesid, iLog, ',')#'], 'ACCS', ',')>
								<cfelse>
									<cfset es_acceso = 0>
								</cfif>
								
								<td id="tdTelefono1_#iLog#_#rsAllContratos.Contratoid#" <cfif rsAllContratos.PQtelefono EQ 0 or es_acceso EQ 0> style="display: none;"</cfif>>
									&nbsp;&nbsp;<label>Tel&eacute;fono</label>&nbsp;&nbsp;
								</td>
								<td id="tdTelefono2_#iLog#_#rsAllContratos.Contratoid#" <cfif rsAllContratos.PQtelefono EQ 0 or es_acceso EQ 0> style="display: none;"</cfif>>
									<cfset valTel = "">
									<cfif ListLen(logines) GTE iLog>
										<cfset valTel = Trim(ListGetAt(telefonos, iLog, ','))>
									</cfif>
									<cfif Attributes.readOnly>
										#valTel#
									<cfelse>	
										<cf_campoNumerico nullable="true" name="LGtelefono_#iLog#_#rsAllContratos.Contratoid#" decimales="-1" size="12" maxlength="15" value="#valTel#" tabindex="1">
									</cfif>
									
								</td>
							  </tr>
							</table>
						</td>
						<td align="#Attributes.alignEtiquetas#"><label>No. Sobre</label></td>
						<td>
							<cfset snum = "">
							<cfif ListLen(loginesid) GTE iLog and ListLen(sobresnum) GTE iLog>
								<cfset snum = ListGetAt(sobresnum, iLog, ',')>
							</cfif>
							<cfif Len(Trim(Attributes.filtroAgente))>
								<cfset LvarResponsable = "1">
							<cfelse>
								<cfset LvarResponsable = "0">
							</cfif>
<!--- 							<cf_sobre
								numero = "#snum#"
								form = "#Attributes.form#"
								agente = "#Attributes.filtroAgente#"
								sufijo = "_#iLog#_#rsAllContratos.Contratoid#"
								responsable = "#LvarResponsable#"
								mostrarNoAsignados = "true"
								Ecodigo = "#Attributes.Ecodigo#"
								Conexion = "#Attributes.Conexion#"
								readOnly = "#Attributes.readOnly#"
							>	 --->	

							<cf_campoNumerico 
								nullable="true" 
								name="Snumero_#iLog#_#rsAllContratos.Contratoid#" 
								decimales="-1" size="12" maxlength="15" 
								value="#snum#" 
								tabindex="1">							
							
						</td>
						<cfset conContrato = rsAllContratos.Contratoid>
						
						<cfloop query="rsServiciosDisponibles">
						<td id="td#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#_#conContrato#" align="center" <cfif Evaluate('rsAllContratos.Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#') EQ 0> style="display:none;"</cfif>>
							<cfset chequeado = ListLen(loginesid) GTE iLog AND ListFind(loginServ['#ListGetAt(loginesid, iLog, ',')#'], '#Trim(rsServiciosDisponibles.TScodigo)#', ',') NEQ 0>
							<input type="checkbox" name="chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#_#conContrato#" onclick="return ReadOnlyAttr(this)" value="#Trim(rsServiciosDisponibles.TScodigo)#"<cfif chequeado> checked</cfif> tabindex="1"<cfif Attributes.readOnly>readonly</cfif>/>
						</td>
						</cfloop>
					  </tr>				  
				  </cfloop>
				</table>
			  </td>
			  </tr>
	
			  <tr>
				<td colspan="4">
					<!--- Precargar los servicios que pueden tenerse con el paquete seleccionado, si aún no se han digitado logines --->
					<cfif rsLogines.recordCount gte 0>
						<script language="javascript" type="text/javascript">
							cargarServicios#rsAllContratos.currentRow#();
						</script>
					</cfif>
					<cfif Attributes.vista NEQ 2>
						<cfif permiteAgregarPaquetes>
							<hr />
						<cfelseif rsAllContratos.currentRow NEQ rsAllContratos.recordCount>
							<hr />
						</cfif>
					</cfif>
				</td>
			  </tr>
			</cfloop>
			
		</cfif> <!--- rsCuenta.CUECUE EQ 'U' or rsCuenta.CUECUE EQ 'A' --->
		
		<!--- Solo se pueden agregar paquetes cuando se esta registrando para un cliente y no esta en true el atributo readOnly--->
		<cfif Attributes.vista NEQ 2 and permiteAgregarPaquetes and not Attributes.readOnly>

		  <!--- Agregar nuevo Paquete --->
		  <tr align="center">
			<td colspan="4" class="subTitulo"><strong>Agregar nuevo producto a la cuenta</strong></td>
		  </tr>
	
		  <tr>
			<td align="#Attributes.alignEtiquetas#"><label>Paquete</label></td>
			<td colspan="3">

				<input type="hidden" name="CTcondicion#rsAllContratos.recordCount+1#" value="<cfif Attributes.vista EQ 2>0<cfelse>C</cfif>" />
				<cf_paquete 
					sufijo = "#rsAllContratos.recordCount+1#"
					agente = "#Attributes.filtroAgente#"
					form = "#Attributes.form#"
					funcion = "solicitarCampos#rsAllContratos.recordCount+1#"
					filtroPaqInterfaz = "0"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
					showCodigo="false"
				>
			</td>
		  </tr>

		  <tr id="trSuscriptor#rsAllContratos.recordCount+1#" style="display: none;">
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Nombre Suscriptor</label></td>
			<td>
				<input type="text" name="CNsuscriptor#rsAllContratos.recordCount+1#" onblur="javascript: this.value = this.value.toUpperCase()" size="30" maxlength="50" value="" tabindex="1" />
			</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>No. Suscriptor</label></td>
			<td>
				<input type="text" name="CNnumero#rsAllContratos.recordCount+1#" size="30" maxlength="20" value="" tabindex="1" />
			</td>
		  </tr>
	
		  <tr>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Tarifa B&aacute;sica</label></td>
			<td>
				<input type="text" name="PQtarifaBasica#rsAllContratos.recordCount+1#" class="cajasinbordeb" style="text-align: right;" size="20" tabindex="-1" readonly />
			</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Derecho Horas Mensuales</label></td>
			<td>
				<input type="text" name="PQhorasBasica#rsAllContratos.recordCount+1#" class="cajasinbordeb" style="text-align: right;" size="20" tabindex="-1" readonly />
			</td>
		  </tr>
	
		  <tr>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Costo Hora Adicional</label></td>
			<td>
				<input type="text" name="PQprecioExc#rsAllContratos.recordCount+1#" class="cajasinbordeb" style="text-align: right;" size="20" tabindex="-1" readonly />
			</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Cantidad de Correos</label></td>
			<td>
				<input type="text" name="CantidadCorreos#rsAllContratos.recordCount+1#" class="cajasinbordeb" style="text-align: right;" size="20" tabindex="-1" readonly />
			</td>
		  </tr>
	
		  <tr>
			<td align="#Attributes.alignEtiquetas#" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
			<td align="#Attributes.alignEtiquetas#" nowrap><label>Cuota Mail</label></td>
			<td>
				<input type="text" name="PQmailQuota#rsAllContratos.recordCount+1#" class="cajasinbordeb" style="text-align: right;" size="20" tabindex="-1" readonly /> KB
				<script language="javascript" type="text/javascript">
					
					function cargarServicios#rsAllContratos.recordCount+1#() {
						var tdServicio;
						var cantidad = 0;
						var existeCABM = false;
						var cantidadconmutados = 0;
						var cantidadcorreos = 0;
						var chkaccs;

							if (document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.recordCount+1#)
								cantidadconmutados = parseInt(document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.recordCount+1#.value)	
							
						
							if (document.#Attributes.form#.vCantidad_MAIL#rsAllContratos.recordCount+1#)
								cantidadcorreos = parseInt(document.#Attributes.form#.vCantidad_MAIL#rsAllContratos.recordCount+1#.value);

							if (parseInt(document.#Attributes.form#.vCantidadCable#rsAllContratos.recordCount+1#.value) > 0)
						 		existeCABM = true; // El paquete tiene servicio de cable.
							
							if (existeCABM)
								cantidad = 	(cantidadconmutados+cantidadcorreos);
							else {
									if (cantidadcorreos > 0 )
									 cantidad = cantidadcorreos;
									else
									 cantidad = cantidadconmutados; 											
								}
						
						<cfloop query="rsServiciosDisponibles">												
							tdServicio = document.getElementById('td#Trim(rsServiciosDisponibles.TScodigo)#');
							
							if (parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.recordCount+1#.value) > 0) {
								tdServicio.style.display = '';
							} else {
								tdServicio.style.display = 'none';
							}
							for (var i=1; i<=#maxServicios.cantidad#; i++) {
								tdServicio = document.getElementById('td#Trim(rsServiciosDisponibles.TScodigo)#_'+i);								
									if (parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.recordCount+1#.value) > 0)	
								 	{
										tdServicio.style.display = '';
								
								
									} else {
										tdServicio.style.display = 'none';
									}
					
							}
							for (var i=1; i<=#maxServicios.cantidad#; i++) {
								var x = eval('document.#Attributes.form#.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i);
	
								<!--- Marca los check según la cantidad permitida --->
								
											//&& (i <= parseInt(document.#Attributes.form#.vCantidadM_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.recordCount+1#.value)) );																
								
								if (existeCABM) 
								{
									if (i == 1) // nivel 1
										if (x.value == 'ACCS') // en el nivel uno no se permite el acceso conmutado
											x.style.display = 'none';
										else{
											x.style.display = '';
											x.checked = true;											
											}
									else if (i >= 2) // si existe un conmutado lo muestra.
										if ((x.value == 'ACCS') && cantidadconmutados > 0)
										{
											x.style.display = '';
											cantidadconmutados = cantidadconmutados-1;	
										}
										else {	
												chkaccs = eval('document.#Attributes.form#.chk_ACCS_'+i); 	
												if ((i <= parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.recordCount+1#.value)
													&& chkaccs.style.display == 'none') 
														|| (chkaccs.style.display == 'none' && x.value == 'MAIL' && cantidadcorreos > 0)) // no existen un acceso conmutado
												{	
													if (x.value = 'MAIL')
														cantidadcorreos = cantidadcorreos-1;
													x.style.display = '';
													x.checked = false;
												}
												else {
									     			x.style.display = 'none';}
											 }	
								}								 	 
								else {	// no es un servicio de cableras

										 x.checked =  (i <= parseInt(document.#Attributes.form#.vCantidadM_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.recordCount+1#.value));
										if (i <= parseInt(document.#Attributes.form#.vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##rsAllContratos.recordCount+1#.value))
										 	x.style.display = '';
										else
									    	x.style.display = 'none';
									}					
								}
						</cfloop>
						for (var i=cantidad+1; i<=#maxServicios.cantidad#; i++) {
							document.getElementById("tr_"+i).style.display="none";
						}
						for (var i=1; i<=cantidad; i++) {
							document.getElementById("tr_"+i).style.display="";
						}
					}
				
					function solicitarCampos#rsAllContratos.recordCount+1#() {
						var tdTelefono1, tdTelefono2;
						var x;
						document.#Attributes.form#.PQtarifaBasica#rsAllContratos.recordCount+1#.value = fm(document.#Attributes.form#.vPQtarifaBasica#rsAllContratos.recordCount+1#.value,2);
						document.#Attributes.form#.PQhorasBasica#rsAllContratos.recordCount+1#.value = fm(document.#Attributes.form#.vPQhorasBasica#rsAllContratos.recordCount+1#.value,2);
						document.#Attributes.form#.PQprecioExc#rsAllContratos.recordCount+1#.value = fm(document.#Attributes.form#.vPQprecioExc#rsAllContratos.recordCount+1#.value,2);
						document.#Attributes.form#.PQmailQuota#rsAllContratos.recordCount+1#.value = document.#Attributes.form#.vPQmailQuota#rsAllContratos.recordCount+1#.value;
						document.#Attributes.form#.CantidadCorreos#rsAllContratos.recordCount+1#.value = fm(document.#Attributes.form#.vCantidadCorreos#rsAllContratos.recordCount+1#.value,-1);
						if (document.#Attributes.form#.vCantidad_CABM#rsAllContratos.recordCount+1# && parseInt(document.#Attributes.form#.vCantidad_CABM#rsAllContratos.recordCount+1#.value) > 0) {
							// Mostrar los campos solicitados para cable modem
							var a = document.getElementById("trSuscriptor#rsAllContratos.recordCount+1#");
							if (a) a.style.display = '';
						} else {
							// Ocultar los campos solicitados para cable modem
							var a = document.getElementById("trSuscriptor#rsAllContratos.recordCount+1#");
							if (a) a.style.display = 'none';
						}
						<!--- Mostrar los campos de telefonos si aplica --->
						for (var i=1; i<=#maxServicios.cantidad#; i++) {
							tdTelefono1 = document.getElementById('tdTelefono1_'+i);
							tdTelefono2 = document.getElementById('tdTelefono2_'+i);							
							if (document.#Attributes.form#.vPQtelefono#rsAllContratos.recordCount+1# 
							    && parseInt(document.#Attributes.form#.vPQtelefono#rsAllContratos.recordCount+1#.value) == 1
								&& document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.recordCount+1# != undefined
								&& (i <= parseInt(document.#Attributes.form#.vCantidad_ACCS#rsAllContratos.recordCount+1#.value)))
							{ 

								tdTelefono1.style.display = '';
								tdTelefono2.style.display = '';
							} else {
								tdTelefono1.style.display = 'none';
								tdTelefono2.style.display = 'none';
							}
						}
						
						<!--- Marcar los checks con los servicios que tiene cada paquete --->
						cargarServicios#rsAllContratos.recordCount+1#();
					}				
						
				</script>
			</td>
		  </tr>
		
		  <tr>
		  <td colspan="4">
			<table border="0" width="100%" cellspacing="0" cellpadding="2">
				<tr>
					<td colspan="4">&nbsp;</td>
					<cfloop query="rsServiciosDisponibles">
					<td id="td#Trim(rsServiciosDisponibles.TScodigo)#" align="center" style="display: none;"><label>#HTMLEditFormat(rsServiciosDisponibles.TScodigo)#</label></td>
					</cfloop>
				</tr>
			  <cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
			  <tr id="tr_#iLog#" style="display:none">
				<td align="#Attributes.alignEtiquetas#"><label>Login #iLog#</label></td>
				<td>
					<table border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>
							<cf_login
								idpersona = "#Attributes.idpersona#"
								value = ""
								form = "#Attributes.form#"
								sufijo = "_#iLog#"
								Ecodigo = "#Attributes.Ecodigo#"
								Conexion = "#Attributes.Conexion#"
							>
						</td>
						
						<td id="tdTelefono1_#iLog#" style="display: none;">
							&nbsp;&nbsp;<label>Tel&eacute;fono</label>&nbsp;&nbsp;
						</td>
						<td id="tdTelefono2_#iLog#" style="display: none;">
							<cf_campoNumerico  nullable="true" name="LGtelefono_#iLog#" decimales="-1" size="12" maxlength="15" value="" tabindex="1">
						</td>
					  </tr>
					</table>
				</td>
				<td align="#Attributes.alignEtiquetas#"><label>No. Sobre</label></td>
				<td>
					<cfif Len(Trim(Attributes.filtroAgente))>
						<cfset LvarResponsable = "1">
					<cfelse>
						<cfset LvarResponsable = "0">
					</cfif>
<!--- 					<cf_sobre
						form = "#Attributes.form#"
						agente = "#Attributes.filtroAgente#"
						sufijo = "_#iLog#"
						responsable = "#LvarResponsable#"
						mostrarNoAsignados = "true"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
					> --->
					<cf_campoNumerico 
						nullable="true" 
						name="Snumero_#iLog#" 
						decimales="-1" size="12" maxlength="15" 
						value="" 
						tabindex="1">		
				</td>
				<cfloop query="rsServiciosDisponibles">
				<td id="td#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#" align="center" style="display: none;"><input type="checkbox" name="chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#" onclick="return ReadOnlyAttr(this)" value="#Trim(rsServiciosDisponibles.TScodigo)#" tabindex="1"/></td>
				</cfloop>
			  </tr>
			  </cfloop>
			</table>
		  </td>
		  </tr>
		  
		</cfif> <!--- permiteAgregarPaquetes --->
		</table>
	
		<script language="javascript" type="text/javascript">
		function ReadOnlyAttr(obj) {

			if (obj.name.indexOf('CABM_1') > 0 || obj.name.indexOf('ACCS_1') > 0 || 
					obj.name.indexOf('MAIL_1') > 0) {
				return false;}
			else
				return true;	
		}
		
		
		
		function show_info_location(v){
			if(v == true){
				document.all.info_location.style.visibility= "visible"; 
				document.all.info_location.style.display = "inline";
			}else{
				document.all.info_location.style.visibility= "hidden"; 
				document.all.info_location.style.display = "none";				
			}
			return;
		}
		
		ActualizaValoresExtendidos#Attributes.sufijo#(4,document.#Attributes.form#.CTid#Attributes.sufijo#.value);
			function validarLogines() {
				var iok = true;
				var iok2 = false;
				
				//el siguiente codigo fue comentado por que al parecer no posee funcionalidad alguna
				<!--- Loop para limpiar los campos login que no tengan un servicio marcado --->
				<!---<cfloop query="rsAllContratos">
					<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">iok2 = false;
						<cfloop query="rsServiciosDisponibles">
							if (document.#Attributes.form#.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#_#rsAllContratos.Contratoid#.checked) { iok2 = true; }
						</cfloop>
						if (!iok2) { document.#Attributes.form#.Login_#iLog#_#rsAllContratos.Contratoid#.value = ''; }
					</cfloop>
				</cfloop>--->
	
				<!--- Validacion de Logines para paquetes por Modificar --->
				<cfloop query="rsAllContratos"><cfloop from="1" to="#maxServicios.cantidad#" index="iLog">if (document.#Attributes.form#.Login_#iLog#_#rsAllContratos.Contratoid#.value != '' && document.getElementById("img_login_ok_#iLog#_#rsAllContratos.Contratoid#").style.display == 'none') { iok = false; }
				</cfloop></cfloop>
				<!--- Validacion de Logines para paquetes por Agregar --->
				<cfif permiteAgregarPaquetes and not Attributes.readOnly>
				<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">if (document.#Attributes.form#.Login_#iLog#.value != '' && document.getElementById("img_login_ok_#iLog#").style.display == 'none') { iok = false; }
				</cfloop>
				</cfif>
				return iok;
			}
		</script>
	</cfoutput>
<cfelse>
	<input type="hidden" name="CTid" value="<cfif ExisteCuenta><cfoutput>#rsCuenta.CTid#</cfoutput></cfif>">
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr><td>
			<cfinclude template="cuenta-resumen-consul.cfm">
		</td></tr>
		<tr align="center"><td class="subTitulo">Mecanismo de Env&iacute;o</td></tr>
		<tr><td>
			<cfinclude template="cuenta-resumen-envio.cfm">	
		</td></tr>
		<tr align="center"><td class="subTitulo">Forma de Cobro</td></tr>
		<tr><td>
			<cfinclude template="cuenta-resumen-cobro.cfm">	
		</td></tr>
		<tr><td>
			<cfinclude template="cuenta-resumen-garantia.cfm">	
		</td></tr>	
	</table>
</cfif>
