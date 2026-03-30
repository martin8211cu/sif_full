
<cfquery name="rsAllContratos" datasource="#session.DSN#">
	select a.Contratoid, b.*, 
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
		and a.CTcondicion = '1'
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
<cfquery name="rsLogines" datasource="#session.DSN#">
	select a.LGnumero, a.Contratoid, coalesce(a.Snumero, 0) as Snumero, a.LGlogin, a.LGrealName, a.LGcese, a.LGserids, a.Habilitado, a.LGmostrarGuia,a.LGprincipal
	from ISBlogin a
	where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAllContratos.Contratoid#">
		and a.Habilitado=1
	order by a.LGprincipal desc, a.LGnumero
</cfquery>
<cfset loginesid = ValueList(rsLogines.LGnumero, ',')>
<cfset sobresnum = ValueList(rsLogines.Snumero, ',')>
<cfset logines = ValueList(rsLogines.LGlogin, ',')> 

<cfoutput>
	  <form name="form1" method="post" style="margin: 0;" action="gestion-paquetes-apply.cfm" onsubmit="javascript: return validar(this);">
		<cfinclude template="gestion-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">	  
		  <tr>
			<td align="right">Paquete</td>
			<td align="center">
			
				<input type="hidden" name="CTid" value="#form.CTid#"/>
				<input type="hidden" name="Contratoid" value="#rsAllContratos.Contratoid#" />
				<input type="hidden" name="CTcondicion" value="1" />
				<cf_paquete 
					id = "#rsAllContratos.PQcodigo#"
					sufijo = "1"
					agente = ""
					form = "form1"
					Ecodigo = "#session.Ecodigo#"
					Conexion = "#session.DSN#"
					funcion = "solicitarCampos1"
					readOnly = "true"
				>
			</td>
			<td colspan="2">&nbsp;</td>
		  </tr>
		
		  <tr>
			<td align="right" nowrap>Tarifa B&aacute;sica</td>
			<td>
				<input type="text" name="PQtarifaBasica<cfoutput>1</cfoutput>"  class="cajasinbordeb" style="text-align: right;" width="20" value="<cfoutput>#LSNumberFormat(rsAllContratos.PQtarifaBasica,',9.00')#</cfoutput>" readonly tabindex="1" />
			</td>
			<td  align="right" nowrap>Derecho Horas Mensuales</td>
			<td>
				<input type="text" name="PQhorasBasica<cfoutput>1</cfoutput>"  class="cajasinbordeb" style="text-align: right;" width="20" value="<cfoutput>#LSNumberFormat(rsAllContratos.PQhorasBasica,',9.00')#</cfoutput>" readonly tabindex="1"/>
			</td>
		  </tr>
	
		  <tr>
			<td  align="right" nowrap>Costo Hora Adicional</td>
			<td>
				<input type="text" name="PQprecioExc<cfoutput>1</cfoutput>" class="cajasinbordeb" style="text-align: right;" width="20" value="<cfoutput>#LSNumberFormat(rsAllContratos.PQprecioExc,',9.00')#</cfoutput>" readonly tabindex="1"/>
			</td>
			<td  align="right" nowrap>Cantidad de Correos</td>
			<td>
				<input type="text" name="CantidadCorreos<cfoutput>1</cfoutput>" class="cajasinbordeb" style="text-align: right;" width="20" value="<cfoutput>#LSNumberFormat(rsAllContratos.CantidadCorreos,',9.00')#</cfoutput>" readonly  tabindex="1"/>
			</td>
		  </tr>
	
		  <tr>
			<td  align="right" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
			<td  align="right" nowrap>Cuota Mail</td>
			<td>
				<input type="text" name="PQmailQuota1" class="cajasinbordeb" style="text-align: right;" width="20" value="#LSNumberFormat(rsAllContratos.PQmailQuota,'9')#" readonly tabindex="1" /> KB
				<script language="javascript" type="text/javascript">
					function solicitarCampos1() {
						<!------------------------------ Determina que tipos de servicio va a tener cada login ------------------------------->
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
						<!-------------------------------------------------------------------------------------------------------------------->
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
		  <cfset cont = 1>
		  <cfloop query="rsLogines">
			  <tr>
				<td align="right">Login&nbsp;<cfoutput>#cont#</cfoutput>
					<cfif rsLogines.LGprincipal EQ 1>(Principal)</cfif></td>
				<td align="left">
					<input type="hidden" name="LGnumero_#cont#_<cfoutput>#rsAllContratos.Contratoid#</cfoutput>" value="<cfif ListLen(loginesid) GTE cont>#ListGetAt(loginesid, cont, ',')#</cfif>"/>
					<input type="text"  class="cajasinbordeb" style="text-align: center;" readonly name="Login_#cont#_#rsAllContratos.Contratoid#" size="35" maxlength="30" value="<cfif ListLen(logines) GTE cont>#ListGetAt(logines, cont, ',')#</cfif>"  tabindex="1"/>
					<input type="hidden" name="Login_Tipo_#cont#_#rsAllContratos.Contratoid#" value="0" />
				</td>
			  </tr>
			  <cfset cont = 1+cont>
		  </cfloop>	
		 	
		<cfquery name="rsExisteTarea" datasource="#session.DSN#">
			select TPid,TPxml
			from ISBtareaProgramada 
			where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
					and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
					and TPestado = 'P'
					and TPtipo = 'CP'
		</cfquery>
		<tr><td colspan="4">
				<hr />
		</td></tr>
		<!-------------------------------------------------------------------------------------------------------------------->
		<!-------------------------------------Pintado del XML con un XSL si existe la Tarea Programada--------------------------------------->
		<!-------------------------------------------------------------------------------------------------------------------->
		<cfif isdefined("rsExisteTarea.TPid") and len(trim(rsExisteTarea.TPid))>
		<tr valign="top"><td class="tituloAlterno" align="center" colspan="4"> Tarea Programada</td></tr>	
		<tr><td colspan="4">
			<!--- PRUEBA imprime los datos del XML (este codigo es solo para verificar el XML)--->
			<cfsavecontent variable="Lvarxsl"><cfinclude template="/saci/xsd/cambioPaquete.xsl"></cfsavecontent>
			<cfoutput>#XmlTransform(rsExisteTarea.TPxml, Lvarxsl)#</cfoutput>
		</td></tr>
		<tr><td colspan="4">
				<hr />
		</td></tr>
		</cfif>
		
		<!-------------------------------------------------------------------------------------------------------------------->
		<!-------------------------------------Pintado para modificar el paquete actual--------------------------------------->
		<!-------------------------------------------------------------------------------------------------------------------->
		<tr valign="top"><td class="tituloAlterno" align="center" colspan="4"> Nuevo Paquete</td></tr>	
		<tr>
			<td align="right" valign="middle">Paquete</td>
			<td colspan="3" valign="top">
				<cfif isdefined("session.saci.cambioPQ.PQnuevo")and len(trim(session.saci.cambioPQ.PQnuevo)) and session.saci.cambioPQ.estado EQ 1><!---para saber si esta en el estado de terminar---> 
					<cfset PQnuevo=session.saci.cambioPQ.PQnuevo>
					<cfset read="true">
					&nbsp;
				<cfelse>
					<cfset PQnuevo ="">
					<cfset read="false">				
				</cfif>
				<cf_paquete 
					id = "#PQNuevo#"
					sufijo = "2"
					agente = ""
					form = "form1"
					funcion = "solicitarCampos2"
					Ecodigo = "#session.Ecodigo#"
					Conexion = "#session.DSN#"
					idCambioPaquete="#rsAllContratos.PQcodigo#"
					readOnly="#read#"
				>
			</td>
		  </tr>
	
		  <tr>
			<td align="right" nowrap>Tarifa B&aacute;sica</td>
			<td>
				<input type="text" name="PQtarifaBasica2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.PQtarifaBasica") and len(trim(rsPQnuevo.PQtarifaBasica))><cfoutput>#LSNumberFormat(rsPQnuevo.PQtarifaBasica,',9.00')#</cfoutput></cfif>" width="20" readonly  tabindex="1"/>
			</td>
			<td align="right" nowrap>Derecho Horas Mensuales</td>
			<td>
				<input type="text" name="PQhorasBasica2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.PQhorasBasica") and len(trim(rsPQnuevo.PQhorasBasica))><cfoutput>#LSNumberFormat(rsPQnuevo.PQhorasBasica,',9.00')# </cfoutput></cfif>"width="20" readonly  tabindex="1"/>
			</td>
		  </tr>
	
		  <tr>
			<td align="right" nowrap>Costo Hora Adicional</td>
			<td>
				<input type="text" name="PQprecioExc2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.PQprecioExc") and len(trim(rsPQnuevo.PQprecioExc))><cfoutput> #LSNumberFormat(rsPQnuevo.PQprecioExc,',9.00')#</cfoutput></cfif>"width="20" readonly  tabindex="1"/>
			</td>
			<td align="right" nowrap>Cantidad de Correos</td>
			<td>
				<input type="text" name="CantidadCorreos2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.CantidadCorreos") and len(trim(rsPQnuevo.CantidadCorreos))><cfoutput>#LSNumberFormat(rsPQnuevo.CantidadCorreos,',9.00')# </cfoutput></cfif>"width="20" readonly  tabindex="1"/>
			</td>
		  </tr>
	
		  <tr>
			<td align="right" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
			<td align="right" nowrap>Cuota Mail</td>
			<td>
				<input type="text" name="PQmailQuota2" class="cajasinbordeb" style="text-align: right;" width="20"  value="<cfif isdefined("rsPQnuevo.PQmailQuota") and len(trim(rsPQnuevo.PQmailQuota))><cfoutput>#LSNumberFormat(rsPQnuevo.PQmailQuota,'9')# </cfoutput></cfif>" readonly  tabindex="1"/> KB
				<script language="javascript" type="text/javascript">
					function solicitarCampos2() {
						<!------------------------------ Determina que tipos de servicio va a tener cada login ------------------------------->
						for (var i=1; i<=3; i++) {
							var x = eval('document.form1.Login_Tipo_'+i);
							x.value = "0";
						}
						for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_CABM2.value); i++) {
							var x = eval('document.form1.Login_Tipo_'+i);
							x.value = "" + (parseInt(x.value) + 1);
						}
						
						for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_ACCS2.value); i++) {
							var x = eval('document.form1.Login_Tipo_'+i);
							x.value = "" + (parseInt(x.value) + 2);
						}
						for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_MAIL2.value); i++) {
							var x = eval('document.form1.Login_Tipo_'+i);
							x.value = "" + (parseInt(x.value) + 4);
						}
						<!-------------------------------------------------------------------------------------------------------------------->
						document.form1.PQtarifaBasica2.value = document.form1.vPQtarifaBasica2.value;
						document.form1.PQhorasBasica2.value = document.form1.vPQhorasBasica2.value;
						document.form1.PQprecioExc2.value = document.form1.vPQprecioExc2.value;
						document.form1.PQmailQuota2.value = document.form1.vPQmailQuota2.value;
						document.form1.CantidadCorreos2.value = document.form1.vCantidadCorreos2.value;
						for (var i=1; i<=3; i++) {
							var x = eval('document.form1.Login_Tipo_'+i);
							var y = eval('document.form1.Login_'+i);
							var z = eval('document.form1.Snumero_'+i);
							if (x.value == '0') {
								y.disabled = true;
								<!--- z.disabled = true; --->
							} else {
								y.disabled = false;
								<!--- z.disabled = false; --->
							}
						}
					}
				</script>
			</td>
		  </tr>
		
			<tr id="log1">
				<td align="right">Login 1 (Principal)</td>
				<td>
					<input type="text" name="Login_1" size="35" maxlength="30" class="cajasinbordeb" style="text-align: right;"   tabindex="1"/>
					<input type="hidden" name="Login_Tipo_1" value="0"/>
				</td>
			  </tr>
			  <tr id="log2">
				<td align="right">Login 2</td>
				<td>
					<input type="text" name="Login_2" size="35" maxlength="30" class="cajasinbordeb" style="text-align: right;"  tabindex="1"/>
					<input type="hidden" name="Login_Tipo_2" value="0" />
				</td>
			  </tr>
			  <tr id="log3">
				<td align="right">Login 3</td>
				<td>
					<input type="text" name="Login_3" size="35" maxlength="30" class="cajasinbordeb" style="text-align: right;"  tabindex="1"/>
					<input type="hidden" name="Login_Tipo_3" value="0" />
				</td>		
			  </tr>
			  
			  <cfif isdefined("session.saci.cambioPQ") and session.saci.cambioPQ.estado EQ 1>
			  <tr valign="top"><td class="tituloAlterno" align="center" colspan="4">Estado de los servicios conflictivos con el nuevo paquete</td></tr>
			  <tr><td colspan="4">
					
					<cfset arrLogB = ListToArray(session.saci.cambioPQ.logBorrar.login,",")>
					<cfset arrSerB = ListToArray(session.saci.cambioPQ.logBorrar.servicios,",")>
					
					<cfset arrLogC = ListToArray(session.saci.cambioPQ.logConservar.login,",")>
					<cfset arrSerC = ListToArray(session.saci.cambioPQ.logConservar.servicios,",")>
					
					<cfset arrPqPA = ListToArray(session.saci.cambioPQ.pqAdicional.cod,",")>
					<cfset arrLogPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.login,",")>
					<cfset arrSerPA = ListToArray(session.saci.cambioPQ.pqAdicional.logMover.servicios,",")>
					
					<table width="90%" border="0" cellspacing="1" cellpadding="0">	
						
						<cfif ArrayLen(arrLogC)>						
							<tr><td colspan="2" class="tituloAlterno"><strong>Servicios por conservar</strong></td></tr>
							<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
							<cfloop index="cont" from = "1" to = "#ArrayLen(arrLogC)#">
								<tr><td>#arrLogC[cont]#</td><td>#arrSerC[cont]#</td></tr>
							</cfloop>
						</cfif>
						
						<cfif ArrayLen(arrLogB)>	
							<tr><td colspan="2" class="tituloAlterno"><strong>Servicios por Borrar</strong></td></tr>
							<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
							<cfloop index="cont" from = "1" to = "#ArrayLen(arrLogB)#">
								<tr><td>#arrLogB[cont]#</td><td>#arrSerB[cont]#</td></tr>
							</cfloop>
						</cfif>
						
						<cfif ArrayLen(arrPqPA)>					
							<tr><td colspan="2" class="tituloAlterno"><strong>Paquetes Nuevos</strong></td></tr>
							<cfloop index="cont" from = "1" to = "#ArrayLen(arrPqPA)#">	
								<tr><td colspan="2"><strong>#arrPqPA[cont]#</strong></td></tr>
								<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
								<cfloop index="cont2" from = "1" to = "#ArrayLen(arrLogPA)#">
									<tr><td>#arrLogPA[cont2]#</td><td>#arrSerPA[cont2]#</td></tr>
								</cfloop>
							</cfloop>
						</cfif>
					</table>
		  </td></tr>
		  </cfif>
		  
		  
		  <tr><td align="right" colspan="4">
		 	
			 <cfif isdefined("session.saci.cambioPQ.estado") and session.saci.cambioPQ.estado EQ 1>	
				<cfset etiqueta = "Cancelar,Terminar">
			 <cfelse>
			 	<cfif isdefined("Session.saci.cambioPQ")><!---Borra la session en caso de que exista--->
					<cfset StructDelete(Session.saci, "cambioPQ")>
				</cfif>
				<cfset etiqueta = "Verificar"> 
			 </cfif>
			 		
			<cf_botones names="#etiqueta#" values="#etiqueta#" tabindex="1">
			
		   </td></tr>
		   
	</table>
	</form>
	<script type="text/javascript" language="javascript">
		document.getElementById("log1").style.display="none";
		document.getElementById("log2").style.display="none";
		document.getElementById("log3").style.display="none";
		
		function funcVerificar()
		{
			document.form1.action="gestion.cfm";
			document.form1.submit();
		}			
		<!-- Validación de los paquetes--->
		function validar(formulario)
		{
			var error_input;
			var error_msg = '';
			if (formulario.PQcodigo2.value == "") {
					error_msg += "\n - El codigo de Paquete no puede quedar en blanco.";
					error_input = formulario.PQcodigo2;
			}	
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
		}

	</script>
</cfoutput>
