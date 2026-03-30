<style type="text/css">
<!--
.style2 {
	font-size: 7px;
	font-weight: bold;
	font-family: "Times New Roman", Times, serif;
}
-->
</style>
<cfif not ExisteRepro>
	<center>--- No existen servicios por reprogramar ---</center>
<cfelse>
	<!---Consulta el plazo de vencimiento en dias para los logines que estan retirados--->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">	
		<cfinvokeargument name="Pcodigo" value="40">
	</cfinvoke>
	<!---Trae nombre del paquete y codigo--->
	<cfquery name="rsPQ" datasource="#session.DSN#">
		select a.PQcodigo,b.PQnombre, a.Contratoid, b.PQtelefono   
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo=a.PQcodigo
				and b.Habilitado=1
		where
			a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
			and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
	</cfquery>
	
	<cfif rsPQ.RecordCount GT 0>
		<!---Trae los logines--->
		<cfquery name="rsLog" datasource="#session.DSN#">
			select distinct
				a.CNsuscriptor,a.CNnumero  
				,b.LGnumero,b.LGlogin,b.LGprincipal,b.LGtelefono
				, coalesce((select sum(x.SVcantidad) from ISBservicio x 
							where x.PQcodigo = a.PQcodigo 
							and x.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPQ.PQcodigo#">
							and x.TScodigo = 'CABM' 
							and x.Habilitado = 1), 0)as Cantidad_CABM
				
			from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid=a.Contratoid
					and b.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
					and b.Habilitado=2
					<!---and datediff( day, b.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->	
			where
				a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg_rep#">
				and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsPQ.PQcodigo#">
				and a.CTcondicion not in ('C','0','X') 				<!---Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
				and (select count(1) 								<!---significa que al menos debe haber un servicio retirado que no este vencido---> 
						from ISBlogin z
						where z.Contratoid = a.Contratoid
						and z.Habilitado=2							<!---significa que al menos debe haber un servicio retirado que no este vencido---> 
						<!---and datediff( day, z.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->
					) > 0
				order by a.Contratoid				
		</cfquery>
			
		<cfset cantLogines = 0>
		
		<cfif isdefined('rsLog')>
			<cfset cantLogines = rsLog.RecordCount>
		</cfif>

		<cfif cantLogines EQ 0>
			<center>--- No existen servicios por reprogramar ---</center>
		<cfelse>
			<cfoutput>
				<form name="form1" method="post" style="margin: 0;" action="gestion-repro-producto-apply.cfm" onsubmit="javascript: return validarRepro(this);">
					<cfinclude template="gestion-hiddens.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="2">	  
						<!---Campo de Paquete--->
						<tr><td align="center" colspan="6">
							<table border="0" cellspacing="0" cellpadding="2">	  
								<tr>
									<td align="right"><label><cf_traducir key="paquete">Paquete</cf_traducir></label></td>
									<td>
										<input type="hidden" name="PQcodigo" value="#rsPQ.PQcodigo#"/>
										#rsPQ.PQnombre#
									</td>
								</tr>
							</table>	
						</td></tr>
						
						<!---Campos de Subscriptor--->
						<cfif rsLog.Cantidad_CABM GT 0>
							<tr><td colspan="6" align="center">
								<table width="100%" cellpadding="0" cellspacing="0"><tr>
								<td align="right"><label>Nombre Suscriptor</label></td>
								<td>
									<input type="text" name="CNsuscriptor" size="20" maxlength="50" value="#rsLog.CNsuscriptor#" tabindex="1" />
								</td>
								<td align="right"><label>No. Suscriptor</label></td>
								<td>
									<input type="text" name="CNnumero" size="20" maxlength="20" value="#rsLog.CNnumero#" tabindex="1" />
								</td>
								</tr></table>
							</td></tr>
						</cfif>
						
						<cfset cont = 1>
						<cfset logi ="">
						<cfset logid ="">
						
						<cfif cantLogines GT 0>							
							<cfif cantLogines GT 1>
								<tr><td width="5%"align="center" nowrap="nowrap">
										<table cellpadding="0" cellspacing="0" border="0"><tr>
										<td><input name="todos" id="todos" type="checkbox" tabindex="1" onchange="javascript:chekear();"/></td>
										<td align="right"><label style="font-size:9px; font-style:normal;">Todos</label></td>
										</tr></table>
									    <hr /></td>
									<td colspan="5">&nbsp;</td>
								</tr>
							</cfif>
							
							<cfloop query="rsLog">								
								<!---Campos de Logines--->
								<tr>
								  <td colspan="6">&nbsp;</td>
								</tr>
								<cfset logi = rsLog.LGlogin>
								<cfset logid = rsLog.LGnumero>
								
								<tr>
								<td align="center">
									<input 	name="LogsRep" 
											id="c_#cont#" 
											type="checkbox" 
											tabindex="1"
											<cfif rsLog.LGprincipal>
												  checked="true"
											</cfif>
											value="#logid#" 
											onchange="javascript:revisarCk();<cfif rsLog.LGprincipal>loginPrincipal(this);</cfif>"
											 />
								</td><!--- 											 <cfif rsLog.RecordCount EQ 1>checked</cfif> --->
								<td width="7%" nowrap="nowrap" align="right"><label><cf_traducir key="login">Login</cf_traducir></label></td>
								<td width="14%" nowrap>
									<cfset session.saci.depositoGaranOK = true>	
									<cf_login
									idpersona = "#form.cli#"
									loginid = "#logid#"
									value = "#logi#"
									form = "form1"
									sufijo = "#cont#"
									Ecodigo = "#session.Ecodigo#"
									Conexion = "#session.DSN#">
								</td>
								
								<!---Campos de Servicios(redonly)--->
								<cfquery name="rsServ" datasource="#session.DSN#">
									select 	c.TScodigo   
									from 	ISBserviciosLogin c
									where	c.LGnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#logid#">
											and c.Habilitado=1
											and c.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsPQ.PQcodigo#">
								</cfquery>	
								<td width="7%" nowrap="nowrap" align="right"><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td>
								<cfif rsServ.RecordCount GT 0>
									<cfset servs =valueList(rsServ.TScodigo)>
									<td width="22%">#servs#</td>
								<cfelse>
									<td width="10%">Sin servicios</td>
								</cfif>
								<td width="33%" nowrap>
									<cfif rsLog.LGprincipal>
										<span class="style2">(Log&iacute;n Principal)</span>									
										<cfelse>
										&nbsp;
									</cfif>
								</td>	
								</tr>
								
								<!---Campos de Sobres--->
								<tr><td>&nbsp;</td>
									<td align="right" nowrap><label>No. <cf_traducir key="sobre">Sobre</cf_traducir></label></td>
									<td><table border="0" cellpadding="0" cellspacing="0">
											<tr><td>&nbsp;&nbsp;</td>
											<td>
											<!---FALTA: no se si el agente es obligatorio si lo tuviera--->
											<!---<cf_sobre
												form = "form1"
												agente = ""
												sufijo = "#cont#"
												responsable = "0"
												mostrarNoAsignados = "true"
												Ecodigo = "#session.Ecodigo#"
												Conexion = "#session.DSN#"
												size="18"
											>--->
											
											<cf_campoNumerico 
												name="Snumero#cont#" 
												decimales="-1" 
												size="20" 
												maxlength="10"
											>
											</td>
											<td>&nbsp;</td></tr>
										</table>
									</td>
									
									<cfif rsPQ.PQtelefono EQ 1>
										<!---Campos de Telefonos (readOnly)--->
										<td align="right">
											<label><cf_traducir key="tel">Tel&eacute;fono</cf_traducir></label>
										</td>
										<td>
											<cfif len(trim(rsLog.LGtelefono))>#rsLog.LGtelefono#<cfelse>Aún sin definir</cfif>
										</td>
										<td>&nbsp;</td>	
									<cfelse>
										<td>&nbsp;</td>
										<td width="1%">&nbsp;</td>	
										<td width="1%">&nbsp;</td>								
									</cfif>
								</tr>
								<cfset cont = 1+cont>
							</cfloop>
						</cfif>
						
						<tr><td colspan="6"><cf_botones values="Reactivar" names="Reactivar"></td></tr>
						
					</table>
								
					<cfif cantLogines GT 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="center">
 									<cf_depoGaran
										CTid="#form.CTid#"
										idpersona="#form.Cli#"
										idcontrato="#form.pkg_rep#"
										PQcodigo="#rsPQ.PQcodigo#"
										Gid="-1"
										creaMP="montoApagar">
								</td>
							</tr>
						</table>
										
					</cfif>
					
					<cfif isdefined("url.MsgError") and len(url.MsgError)>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="center">
									<label style="color:red">Existen sobres ingresados Inválidos</label>
								</td>
							</tr>
						</table>
						</cfif>
						
				</form>
				
				<script type="text/javascript">
				<!--
					function loginPrincipal(obj){
						obj.checked="true"
					}
					function revisarCk(){
						var contCKs=0;
						<cfloop query="rsLog">	if(document.getElementById("c_#rsLog.CurrentRow#").checked)contCKs++;</cfloop>
						if (contCKs == #rsLog.RecordCount#)
							document.getElementById("todos").checked=true;
						else
							document.getElementById("todos").checked=false;
					}
					function chekear() {
						if(document.getElementById("todos").checked){
							<cfloop query="rsLog">	document.getElementById("c_#rsLog.CurrentRow#").checked=true;	</cfloop>
						}
						else{
							<cfloop query="rsLog">	
								<cfif rsLog.LGprincipal NEQ 1>
									document.getElementById("c_#rsLog.CurrentRow#").checked=false;	
								</cfif>
							</cfloop>
						}
					}
					function validarRepro(formulario) {
				
						var error_input;
						var error_msg = '';
						
						var hayCheks=false;
						var blank=false;
						var iok=true;
						var sobre=true;
						var repiteSobre=false;
						var varDepoG=true;
						var varDepoG_session=#session.saci.depositoGaranOK#;
						
						
						var sobresArray = new Array();
						for (i=0; i<#rsLog.RecordCount#; i++)
							sobresArray[i] = "";

					
						
						<cfloop query="rsLog">
							if(document.getElementById("c_#rsLog.CurrentRow#").checked){ 
								hayCheks=true;
								if (document.form1.Login#rsLog.CurrentRow#.value == ''){	blank=true;	}
								if (document.form1.Login#rsLog.CurrentRow#.value != '' && document.getElementById("img_login_ok#rsLog.CurrentRow#").style.display == 'none') { iok = false; }
								if (document.form1.Snumero#rsLog.CurrentRow#.value == ''){	sobre=false;}
								else {sobresArray[#rsLog.CurrentRow#-1]=document.form1.Snumero#rsLog.CurrentRow#.value;}
							 }
						</cfloop>
						
						for (i=0; i < #rsLog.RecordCount#; i++){	
							if(sobresArray[i]!=""){	
								for (j = i; j < #rsLog.RecordCount#; j++){
									if(sobresArray[j]!="" && i!=j){
										if (sobresArray[i] == sobresArray[j])repiteSobre=true;
									}
								}
							}
						}
						
						if (hayCheks == false)
							error_msg += "\n - Debe seleccionar al menos un login para reprogramar el paquete.";
						
						if (blank == true)
							error_msg += "\n - Los logines que va a reprogramar no pueden quedar en blanco.";
							
						if (iok == false)
							error_msg += "\n - Debe validar todos los logines que va a reprogramar.";
						
						if (sobre == false)
							error_msg  +="\n - Debe elegir un sobre para cada login que va a reprogramar";
							
						if (repiteSobre)
							error_msg  +="\n - Debe elegir sobres sobres diferentes para cada login";
							
						if(!varDepoG_session)
							error_msg  +="\n - No se encuentra disponible la Interfaz 'Depósito de Garantía', no se permite la reactivación.";											
						
						<!---Valida si los campos de suscriptor estan definidos--->						
						if (document.form1.CNsuscriptor != undefined)
						{
							if(document.form1.CNsuscriptor.value == "")
								error_msg  +="\n - Debe ingresar el nombre del suscriptor ";

							if(document.form1.CNnumero.value == "")
								error_msg  +="\n - Debe ingresar el número de suscriptor ";								
						}
						
						
						//alert(document.form1.CNsuscriptor.value);

						<!--- Validacion terminada --->
						if (error_msg.length != "") {
							alert("Por favor revise los siguientes datos:"+error_msg);
							return false;
						}
						else{
							if(window.validarDepoGaran)	// Funcion de validacion para el tag depoGaran
								varDepoG = validarDepoGaran();

							if(varDepoG){
							
							
								if(confirm("¿Esta seguro que desea reactivar el servicio?"))
									return true;				
								else 
									return false;							
							}else{
								return false;
							}
						}
					}
				//-->
				</script>
			</cfoutput>
		</cfif>
	</cfif>
</cfif>