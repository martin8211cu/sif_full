
<!--- Trae las cuentas del cliente en session --->
<cfquery name="rsCuentas" datasource="#session.DSN#">
	select a.CTid, a.CUECUE
	from ISBcuenta a
	where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#">
	and a.Habilitado = 1
	and ((select count(1) from ISBproducto x 
		where x.CTid = a.CTid
		and x.CTcondicion not in ('C','0','X'))>0)
	and a.CUECUE != 0
</cfquery>

<cfoutput>
<form method="post" name="form1" action="gestion.cfm" onsubmit="return valida_continuar();">
	<input name="PQcodigo_n" type="hidden" value="<cfif isdefined("form.PQcodigo_n") and len(trim(form.PQcodigo_n))>#form.PQcodigo_n#</cfif>"/>
	<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
		<input name="LGnumero_#iLog#" type="hidden" value="<cfif isdefined("form.LGnumero_#iLog#") and len(trim(form["LGnumero_#iLog#"]))>#form['LGnumero_#iLog#']#</cfif>"/>					
		<input name="login_#iLog#" type="hidden" value="<cfif isdefined("form.login_#iLog#") and len(trim(form["login_#iLog#"]))>#form['login_#iLog#']#</cfif>"/>					
		<cfif rsPaquete.PQtelefono EQ 1>
				<input name="LGtelefono_#iLog#" type="hidden" value="<cfif isdefined("form.LGtelefono_#iLog#") and len(trim(form["LGtelefono_#iLog#"]))>#form['LGtelefono_#iLog#']#</cfif>"/>					
		</cfif>
		<cfloop query="rsServiciosDisponibles">
			<input name="chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#" type="hidden" value="<cfif isdefined("form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#") and len(trim(form["chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#"]))>#form['chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#']#</cfif>"/>					
		</cfloop>
	</cfloop>	
	<input name="CTid_n" type="hidden" value="<cfif isdefined("form.CTid_n") and len(trim(form.CTid_n))>#form.CTid_n#</cfif>"/>
	
	<cfinclude template="gestion-hiddens.cfm">
	
	<table cellpadding="4" cellspacing="4" width="100%" border="0" height="200">
		<tr>
			<td align="center" height="10%" valign="top" nowrap>
				<cfinclude template="opcionesSel.cfm">
			</td>
			<td width="300" rowspan="2" align="center" valign="top" nowrap>
				<cf_web_portlet_start tipo="box">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<td valign="top" id="CT0">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr><td class="cfmenu_menu">
							<b>Indicaciones:</b><br>
							Seleccione la cuenta en que desea agregar el nuevo servicio y haga clic en "Continuar".<br>
							Para obtener más información sobre la cuenta, debe posicionar el puntero del mouse 
							sobre la cuenta.
						</td></tr></table>
					</td>
					
					<cfloop query="rsCuentas">
						<cfset idCue= rsCuentas.CTid>
						<cfquery name="rsNum" datasource="#session.DSN#">
								select a.CTid, a.Pquien, a.CUECUE, a.CTtipoUso
								from ISBcuenta a
								where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idCue#">
								and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#">
						</cfquery>
							
						<cfquery name="rsPQ" datasource="#session.DSN#">
							select a.Contratoid,b.PQcodigo,b.PQnombre,b.PQdescripcion
							from ISBproducto a
								inner join ISBpaquete b
									on b.PQcodigo = a.PQcodigo
								inner join ISBcuenta c
									on c.CTid = a.CTid
									and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#">
							where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idCue#">
							and a.CTcondicion not in ('C','0','X') <!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
							order by a.Contratoid
						</cfquery>
						
						<td  nowrap align="center" valign="top" id="CT#idCue#" style="display:none">
							
							<table border="0" width="380" cellspacing="2" cellpadding="2" >
								<tr><td class="cfmenu_menu" valign="top">
								<b>Indicaciones:</b><br>
								Seleccione la cuenta en que desea agregar el nuevo servicio y haga clic en "Continuar".<br>
								</td></tr>
								
								<tr><td class="cfmenu_menu" valign="top" align="center">
									<b style="color:##990000">Cuenta
									<cfif ExisteCuenta and rsNum.CUECUE GT 0>#rsNum.CUECUE#<cfelseif rsNum.CTtipoUso EQ 'U'>&lt;Por Asignar&gt;<cfelseif rsNum.CTtipoUso EQ 'A'>(Acceso) &lt;Por Asignar&gt;<cfelseif rsNum.CTtipoUso EQ 'F'>(Facturaci&oacute;n) &lt;Por Asignar&gt;</cfif>
									</b>
								</td></tr>
								
								<tr><td class="cfmenu_menu" valign="top">
									<table cellpadding="0" cellspacing="0" border="0">
									<tr><td class="cfmenu_menu"><strong>Nombre</strong></td>
										<td class="cfmenu_menu"><strong>Descripci&oacute;n</strong></td></tr>
									<cfloop query="rsPQ">
									<tr><td class="cfmenu_menu" >#rsPQ.PQnombre#</td>
										<td class="cfmenu_menu" >#rsPQ.PQdescripcion#</td></tr>
									</cfloop>
									</table>
								</td></tr>
							</table>
							
						</td>
					</cfloop>
				</tr>
				</table>				<cf_web_portlet_end>
			</td>			
		</tr>	
		<tr>
			<td align="center" valign="top" nowrap>
				<center><strong>Elija la cuenta a la que desea agregar el nuevo servicio.</strong></center><br />
				<table border="0"cellspacing="2" cellpadding="2">
					<cfloop query="rsCuentas">
						<tr>
							<td><input name="rcuenta" id="rcuenta" type="radio" value="#rsCuentas.CTid#" <cfif isdefined("form.CTid_n") and len(trim(form.CTid_n)) and form.CTid_n EQ rsCuentas.CTid>checked</cfif> onchange="javascript: doShowInfoCuenta('#rsCuentas.CTid#')"/><td>
							<td><label id="L#rsCuentas.CTid#" style="font-style:normal;color:##999999" onmouseover="javascript: showInfoCuenta('#rsCuentas.CTid#')">Cuenta <cfif rsCuentas.CUECUE NEQ 0>#rsCuentas.CUECUE#<cfelse>< Por asignar ></cfif></label> </td>
						</tr>
					</cfloop>
				</table>
				<br><cf_botones values="Cancelar,Volver,Continuar" names="Cancelar,Regresar,Siguiente">
			</td>
		</tr>
		
	</table>
</form>
	<script language="javascript" type="text/javascript">
		function valida_continuar(){
			if(document.form1.botonSel.value == 'Regresar'){
				document.form1.adser.value = 2;//indica que el siguiente paso es la eleccion de los logines
				return true;
			}
			else if(document.form1.botonSel.value == 'Cancelar'){
					document.form1.adser.value = 1;
					document.form1.PQcodigo_n.value = "";
				}
				else{
					var error_msg = '';
					var checked=false;
					var i;
					var id = "";
					
					if(#rsCuentas.RecordCount#==1){
						if(document.form1.rcuenta.checked)	
						{	checked=true;
							id = document.form1.rcuenta.value;
						}
					}
					else{
						for (i=0;i<#rsCuentas.RecordCount#;i++){ 
						   if(document.form1.rcuenta[i].checked){ 
								id = document.form1.rcuenta[i].value;
								checked=true;
								 break;
							} 
						}
					}
					if(checked == false ){
						var error_msg = '\n Debe elegir la cuenta a la que va a agregar el nuevo servicio.';
					}
					
					if( error_msg != ''){
						alert("Por favor revise los siguiente datos:"+error_msg);
						 return false;
					}
					else{
						document.form1.CTid_n.value = id;
						document.form1.adser.value = 4;//indica que el siguiente paso es la eleccion de los logines
						return true;
					}
				}
			
		}
		function doShowInfoCuenta(id){
			showInfoCuenta(id);
		}
		
		function showInfoCuenta(id){
			document.getElementById("CT0").style.display="none";
			<cfloop query="rsCuentas">
				document.getElementById("CT#rsCuentas.CTid#").style.display="none";
				document.getElementById("L#rsCuentas.CTid#").style.color="##999999";
			</cfloop>
			if(id != undefined){
				document.getElementById('CT'+id).style.display="";
				document.getElementById('L'+id).style.color="##000000";
			}
			else
				document.getElementById("CT0").style.display="";
		}
	</script>
</cfoutput>