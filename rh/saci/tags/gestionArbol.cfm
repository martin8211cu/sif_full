
<!--- Parametros del Tag --->
<cfparam 	name="Attributes.id_cliente"			type="string"	default="">						<!--- Id de la persona actual--->
<cfparam 	name="Attributes.id_contacto"			type="string"	default="">						<!--- Id del contacto--->
<cfparam 	name="Attributes.id_cuenta"				type="string"	default="">						<!--- Id de la cuenta --->
<cfparam 	name="Attributes.id_contrato"			type="string"	default="">						<!--- Id del contrato--->
<cfparam 	name="Attributes.id_login"				type="string"	default="">						<!--- Id del login--->
<cfparam 	name="Attributes.trafico"				type="boolean"	default="false">				<!--- Si se quiere mostrar la pantalla de trafico--->
<cfparam 	name="Attributes.cambioPassword"		type="boolean"	default="false">				<!--- Si se desea mostrar el cambio de Password--->
<cfparam 	name="Attributes.AgregarServicio"		type="boolean"	default="false">				<!--- Si se desea mostrar la pantalla de agregado de servicios--->
<cfparam 	name="Attributes.form"					type="string"	default="form1">				<!--- form--->
<cfparam 	name="Attributes.sufijo" 				type="string"	default="">						<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.Ecodigo" 				type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 				type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.rol" 					type="string"	default="">						<!--- roles: DAS, CLIENTE --->
<cfparam 	name="Attributes.infoServ" 				type="boolean"	default="false">				<!--- Si se desea mostrar la pantalla de informacion de servicios --->
<cfparam 	name="Attributes.recarga" 				type="boolean"	default="false">				<!--- Si se desea mostrar la pantalla de recarga de tarjetas de prepago --->

	<cfif not Len(Trim(Attributes.id_cliente))>
		<cfthrow message="Error: el id_cliente es obligatorio para el tag.">
	<cfelse>
		
		<cfset ExisteCliente = Len(Trim(Attributes.id_cliente))>
		<cfset ExisteCuenta = Len(Trim(Attributes.id_cuenta))>
		<cfset ExistePaquete = Len(Trim(Attributes.id_contrato))>
		<cfset ExisteContacto = Len(Trim(Attributes.id_contacto))>
		<cfset ExisteLog = Len(Trim(Attributes.id_login))>
		<cfset ExisteTrafico = Attributes.trafico>
		<cfset ExisteCambioPass = Attributes.cambioPassword>
		<cfset ExisteAddServicio= Attributes.AgregarServicio>
		<cfset ExisteInfoServ = Attributes.infoServ>
		<cfset ExisteRecarga = Attributes.recarga>
		
		
		<cfquery name="rsCliente" datasource="#Attributes.Conexion#">
			select Pid,Pnombre ||' '||Papellido as nombre
			from ISBpersona 
			where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_cliente#">
		</cfquery>
		
		<cfquery name="rsCuentas" datasource="#Attributes.Conexion#">
			select a.CTid, a.Pquien, a.CUECUE, a.ECidEstado, a.CTapertura, a.CTdesde, a.CThasta, a.CTcobrable, 
			   a.CTrefComision, a.CCclaseCuenta, a.GCcodigo, a.CTmodificacion, a.CTpagaImpuestos, a.Habilitado, 
			   a.CTobservaciones, a.CTtipoUso, a.CTcomision, a.BMUsucodigo, a.ts_rversion
			from ISBcuenta a
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_cliente#">
			and a.Habilitado = 1
			
			and ((select count(1) from ISBproducto x 
				where x.CTid = a.CTid
				and x.CTcondicion not in ('C','0','X'))>0)
			
			<!---and (	(select count(1) from ISBproducto x 
					where x.CTid = a.CTid
					and x.CTcondicion not in ('C','0','X') 
					and x.MRid is null							<!---significa que los productos no deben estar en estado retirado--->
					and x.CNfechaRetiro is null)>0
				)--->
		</cfquery>
		
		<script language="javascript" type="text/javascript">
			function goPage(f, cli) {
				f.cli.value = cli;
				
				if (arguments[2]) {						<!---id de la cuenta--->
					f.cue.value = arguments[2];
				} else {
					f.cue.value = '';
				}
				if (arguments[3]) {						<!---id del contrato--->
					f.pkg.value = arguments[3];
				} else {
					f.pkg.value = '';
				}
				if (arguments[4]) {						<!---Pquien (id del contacto)--->
					f.pqc.value = arguments[4];
				} else {
					f.pqc.value = '';
				}
				if (arguments[5]) {						<!---consulta de trafico--->
					f.traf.value = arguments[5];
				} else {
					f.traf.value = '';
				}
				if (arguments[6]) {						<!---id login--->
					f.logg.value = arguments[6];
					<cfif isdefined('form.lpaso') and form.lpaso EQ 10>	<!---No pinta los botones--->		
						f.pintaBotones.value = 0;						
					</cfif>					
				} else {
					f.logg.value = '';
				}
				if (arguments[7]) {						<!---cambio de password--->
					f.cpass.value = arguments[7];
				} else {
					f.cpass.value = '';
				}
				if (arguments[8]) {						<!---Agregar servicio--->
					f.adser.value = arguments[8];
				} else {
					f.adser.value = '';
				}
				
				if (arguments[9]) {						<!---consulta de Servicios ofrecidos --->
					f.infoServ.value = arguments[9];
				} else {
					f.infoServ.value = '';
				}
				
				if (arguments[10]) {						<!---consulta de Servicios ofrecidos --->
					f.recarga.value = arguments[10];
				} else {
					f.recarga.value = '';
				}
								
				f.pkg_rep.value = '';					
				f.submit();				
			}
		</script>
		

		<cfoutput>	
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outbase.gif" border="0" style="border:0;margin:0;"></td>
					<td  width="100%" colspan="8" align="left">
						<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<span style="vertical-align: middle">
						<cfif ExisteCliente and not ExisteCuenta><strong></cfif>#rsCliente.nombre#<cfif ExisteCliente and not ExisteCuenta></strong></cfif></span>						</a>					</td>
				  </tr>
				   <cfloop query="rsCuentas">
					  <cfset cuenta=rsCuentas.CTid>
					  
					  <tr>
					  	<td  height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outT.gif" border="0"  style="border:0;margin:0;"></td>	
						<cfif ExisteCuenta >		
							<cfif cuenta EQ Attributes.id_cuenta><cfset imag="/cfmx/saci/images/outcta1.gif">
							<cfelse><cfset imag="/cfmx/saci/images/outcta0.gif"></cfif>
						<cfelse><cfset imag="/cfmx/saci/images/outcta0.gif"></cfif>
						<td height="28" width="26" align="left" nowrap><img src="#imag#" border="0"  style="border:0;margin:0;"></td>
						<td  align="left" colspan="7">
							<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '#cuenta#');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
							<span style="vertical-align: middle">
							<cfif ExisteCuenta and not ExistePaquete and cuenta EQ Attributes.id_cuenta><strong></cfif>
								<cfif rsCuentas.CUECUE NEQ 0>Cuenta #rsCuentas.CUECUE#<cfelseif rsCuentas.CTtipoUso EQ 'U'>Cuenta &lt;Por Asignar&gt;<cfelseif rsCuentas.CTtipoUso EQ 'A'>Cuenta (Acceso) &lt;Por Asignar&gt;<cfelseif rsCuentas.CTtipoUso EQ 'F'>Cuenta (Facturaci&oacute;n) &lt;Por Asignar&gt;</cfif>
							<cfif ExisteCuenta and not ExistePaquete and cuenta EQ Attributes.id_cuenta></strong></cfif></span>
							</a>
						</td>
					  </tr>
					  
					<!--- Mostrar Paquetes --->
					  <cfif ExisteCuenta and cuenta EQ Attributes.id_cuenta>
						  <cfquery name="rsProductos" datasource="#Attributes.Conexion#">
							select a.Contratoid, b.*, 
								   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
							from ISBproducto a
								inner join ISBpaquete b
									on b.PQcodigo = a.PQcodigo
									and b.Habilitado=1
								inner join ISBcuenta c
									on c.CTid = a.CTid
									and c.Habilitado=1
									and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_cliente#">
							where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta#">
							and a.CTcondicion not in ('C','0','X')
							and (select count(1) from ISBproducto x 
								where x.CTid = a.CTid
								and x.Contratoid = a.Contratoid
								and x.CTcondicion not in ('C','0','X') 
								and x.MRid is null							<!---significa que los productos NO deben estar en estado retirado--->
								and x.CNfechaRetiro is null)>0
							order by a.Contratoid
						  </cfquery>
						  <cfloop query="rsProductos">
						  	  	<cfset contrato = rsProductos.Contratoid>
								<cfset indexPr=rsProductos.CurrentRow >
								<cfset cantidadPr=rsProductos.RecordCount>
							  	
								<tr>
									<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outV.gif"  border="0"  style="border:0;margin:0;"></td>	
									
									<cfif indexPr NEQ cantidadPr><cfset imag2="/cfmx/saci/images/outT.gif">
									<cfelse>	<cfset imag2="/cfmx/saci/images/outL.gif">	</cfif>
									<td height="28" width="26" align="left" nowrap><img src="#imag2#" border="0" style="margin:0; border:0"></td>
									
									<cfif ExistePaquete>
										<cfif contrato EQ Attributes.id_contrato><cfset imagPQ="/cfmx/saci/images/outpaq1.gif">
										<cfelse><cfset imagPQ="/cfmx/saci/images/outpaq0.gif"></cfif>
									<cfelse><cfset imagPQ="/cfmx/saci/images/outpaq0.gif"></cfif>
									
									<td height="28" width="26" align="left" nowrap> <img src="#imagPQ#"  border="0" style="border:0;margin:0;"></td>
									<td width="100%" colspan="6" align="left">
										<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '#Attributes.id_cuenta#', '#contrato#');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
										<cfset producto = rsProductos.PQdescripcion> 
										<span style="vertical-align: middle"><cfif ExisteCuenta and ExistePaquete and contrato EQ Attributes.id_contrato><strong></cfif><cfif Len(producto) GT 22>#Mid(producto, 1, 20)#...<cfelse>#producto#</cfif><cfif ExisteCuenta and ExistePaquete and contrato EQ Attributes.id_contrato></strong></cfif></span>
									  </a>
								  </td>
							  	</tr>
								
							  	<!--- Mostrar Logines --->
								<cfif ExistePaquete and contrato EQ Attributes.id_contrato>
									<cfquery name="rsLogines" datasource="#Attributes.Conexion#">
										select a.Contratoid, e.LGnumero,e.LGlogin
										from ISBproducto a
											inner join ISBpaquete b
												on b.PQcodigo = a.PQcodigo
												and b.Habilitado=1
											inner join ISBcuenta c
												on c.CTid = a.CTid
												and c.Habilitado=1
												and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_cliente#">
											inner join ISBlogin e
												on e.Contratoid = a.Contratoid 
												and e.Contratoid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#contrato#">
												and e.Habilitado = 1				<!---Que no posea Borrado logico--->
										where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta#">
										and a.CTcondicion not in ('C','0','X') <!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
										order by a.Contratoid
									</cfquery>
									 
									<cfloop query="rsLogines">
										<cfset loggin =rsLogines.LGnumero>	  
										
										<cfquery name="rsServicios" datasource="#session.dsn#">
											select distinct TScodigo
											from ISBserviciosLogin
											where LGnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#loggin#">
											and Habilitado = 1 
										</cfquery>
										<cfset serv = valueList(rsServicios.TScodigo)>
										<cfif listLen(serv)>
											<cfquery name="rsTipo" datasource="#session.dsn#">
												select distinct TStipo
												from ISBservicioTipo
												where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
												order by TStipo
											</cfquery>
											<cfset tipos = valueList(rsTipo.TStipo)>
										<cfelse>
											<cfset tipos = 'A'>
										</cfif>
										<tr>
											<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outV.gif" border="0"  style="border:0;margin:0;"></td>	
											<cfif indexPr NEQ cantidadPr>	
												<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outV.gif" border="0"  style="border:0;margin:0;"></td>	
											<cfelse>
												<td height="28" width="26" align="left" nowrap>&nbsp;</td>	
											</cfif>
											
											<cfif rsLogines.CurrentRow NEQ rsLogines.RecordCount>	
												<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outT.gif" border="0"  style="border:0;margin:0;"></td>	
											<cfelse>
												<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outL.gif" border="0"  style="border:0;margin:0;"></td>	
											</cfif>
											<cfif tipos EQ 'A'>				<!---tipo acceso--->
												<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outlog.gif"  border="0"  style="border:0;margin:0;"></td>		
											<cfelseif tipos EQ 'C'>			<!---tipo correo--->
												<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outlog1.gif"  border="0"  style="border:0;margin:0;"></td>
											<cfelseif tipos EQ 'A,C'>		<!---tipo acceso y correo--->
												<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outlog2.gif"  border="0"  style="border:0;margin:0;"></td>											
											</cfif>
											<td  width="100%"colspan="5" align="left">
												<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '#cuenta#', '#contrato#','','','#loggin#');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
												<span style="vertical-align: middle">
												<cfif ExisteCuenta and ExistePaquete and  ExisteLog and loggin EQ Attributes.id_login><strong></cfif>#rsLogines.LGlogin#<cfif ExisteCuenta and ExistePaquete and Existelog and loggin EQ Attributes.id_login></strong></cfif>
												</span>
											  </a>
										  </td>
										</tr>
									</cfloop>
								</cfif>
						</cfloop>
					  </cfif>
					
				  </cfloop>
				 
				 <tr>
				 	<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outT.gif" border="0" style="border:0;margin:0;"></td>	
					<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outtrf.gif" border="0" style="border:0;margin:0;"></td>	
					<td width="100%" colspan="7" align="left">
						<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '', '','','trafico');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<span style="vertical-align: middle">
						<cfif ExisteTrafico><strong></cfif>Tr&aacute;fico<cfif ExisteTrafico></strong></cfif></span>
					  </a>
				   </td>
				</tr>
				<cfif Attributes.rol EQ 'CLIENTE'>
					<tr>
						<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outT.gif" border="0" style="border:0;margin:0;"></td>	
						<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outsaci.gif" border="0" style="border:0;margin:0;"></td>	
						<td  colspan="7" align="left" nowrap>
							<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '', '','','','','cambioPass');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
							<span style="vertical-align: middle"><cfif ExisteCambioPass><strong></cfif>Cambio de Passwords<cfif ExisteCambioPass></strong></cfif></span></a></td>
					</tr>
					<cfif rsCuentas.RecordCount GT 0>
					<tr>
						<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outT.gif" border="0" style="border:0;margin:0;"></td>	
						<cfif ExisteAddServicio>
							<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outpaq1.gif" border="0" style="border:0;margin:0;"></td>	
						<cfelse>
							<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outpaq0.gif" border="0" style="border:0;margin:0;">
						</cfif>
						<td  colspan="7" align="left">
							<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '', '','','','','','AddServicio');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
							<span style="vertical-align: middle"><cfif ExisteAddServicio><strong></cfif>Agregar Servicios<cfif ExisteAddServicio></strong></cfif></span></a></td>
					</tr>  
					</cfif> 
					<tr>
						<cfif ExisteInfoServ>
							<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outpaq1.gif" border="0" style="border:0;margin:0;"></td>	
						<cfelse>
							<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outpaq0.gif" border="0" style="border:0;margin:0;"></td>	
						</cfif>					

						<td  colspan="8" align="left" nowrap>
							<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '', '','','','','','','infoServicios');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
							<span style="vertical-align: middle"><cfif ExisteInfoServ><strong></cfif>Informaci&oacute;n de Servicios<cfif ExisteInfoServ></strong></cfif></span></a></td>
					</tr>	<tr>
						<cfif ExisteRecarga>
							<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outpaq1.gif" border="0" style="border:0;margin:0;"></td>	
						<cfelse>
							<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outpaq0.gif" border="0" style="border:0;margin:0;"></td>	
						</cfif>					

						<td  colspan="8" align="left" nowrap>
							<a href="javascript: goPage(document.#Attributes.form#,'#Attributes.id_cliente#', '', '','','','','','','','recarga');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
							<span style="vertical-align: middle"><cfif ExisteRecarga><strong></cfif>Recarga de Prepagos<cfif ExisteRecarga></strong></cfif></span></a></td>
					</tr>				
				</cfif>
				<tr>
					<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outL.gif" border="0" style="border:0;margin:0;"></td>	
					<td height="28" width="26" align="left" nowrap><img src="/cfmx/saci/images/outsal.gif" border="0" style="border:0;margin:0;"></td>	
					<td colspan="7" align="left">
						<cfif isdefined("form.rol") and len(trim(form.rol))>
							<cfif form.rol EQ "Cliente">
								<cfset path="/cfmx/home/public/logout.cfm">
							<cfelse>
								<!---<cfset path="/cfmx/home/index.cfm">--->
								<!---<cfset path="/cfmx/home/menu/modulo.cfm?s=SACI&m=SACI">--->
								<cfset path="/cfmx/saci/das/gestion/gestion.cfm">
							</cfif>
						</cfif>
						<a href="#path#" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<span style="vertical-align: middle"><strong style="color:##FF0000">Salir</strong></span>
						</a>
					</td>
			  	</tr>
			</table>
	  </cfoutput>
			
		</cfif>
	