<!---Datos de la cuenta--->
<cfquery name="rsCompruebaCuenta" datasource="#session.DSN#">
	select CUECUE, CTid
	from ISBcuenta
	where  Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#"> 
	and CTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid_n#">
</cfquery>

<!---Tipos de depósito de Garantía--->
<cfquery name="rsTipo" datasource="#session.DSN#">
	select FIDCOD,FIDDES  from SSXFID 
	where FIDCOD=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Gtipo_n#">
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
	
	<!--- Campos para el deposito de garantia --->
	<input name="CTid_n" type="hidden" value="<cfif isdefined("form.CTid_n") and len(trim(form.CTid_n))>#form.CTid_n#</cfif>"/>
	<input name="Gtipo_n" type="hidden" value="<cfif isdefined("form.Gtipo_n") and len(trim(form.Gtipo_n))>#form.Gtipo_n#</cfif>"/>
	<input name="Gmonto_n" type="hidden" value="<cfif isdefined("form.Gmonto_n") and len(trim(form.Gmonto_n))>#form.Gmonto_n#</cfif>"/>
	<input name="MISO4217_n" type="hidden" value="<cfif isdefined("form.MISO4217_n") and len(trim(form.MISO4217_n))>#form.MISO4217_n#</cfif>"/>	
	<input name="EFid_n" type="hidden" value="<cfif isdefined("form.EFid_n") and len(trim(form.EFid_n))>#form.EFid_n#</cfif>"/>	
	<input name="Gref_n" type="hidden" value="<cfif isdefined("form.Gref_n") and len(trim(form.Gref_n))>#form.Gref_n#</cfif>"/>		
	<input name="Ginicio_n" type="hidden" value="<cfif isdefined("form.Ginicio_n") and len(trim(form.Ginicio_n))>#form.Ginicio_n#</cfif>"/>		
	<input name="Gcustodio_n" type="hidden" value="<cfif isdefined("form.Gcustodio_n") and len(trim(form.Gcustodio_n))>#form.Gcustodio_n#</cfif>"/>			
	<input name="Gobs_n" type="hidden" value="<cfif isdefined("form.Gobs_n") and len(trim(form.Gobs_n))>#form.Gobs_n#</cfif>"/>			
	
	<cfinclude template="gestion-hiddens.cfm">
	
	<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr class="areaFiltro"><td align="center" valign="top" colspan="3">
			<center><strong>Comprobar la información del nuevo servicio</strong></center>
		</td></tr>
		<tr><td width="24%" align="right"><label>Cuenta:</label>&nbsp;&nbsp;</td> <td colspan="2"><cfif rsCompruebaCuenta.CUECUE NEQ 0>#rsCompruebaCuenta.CUECUE#<cfelse>< No asignada ></cfif></td> </tr>
		<tr><td align="right"><label>Depósito:</label>&nbsp;&nbsp;</td> <td width="20%">#rsTipo.FIDDES#</td> 
		  <td width="55%"><label>Monto: </label>&nbsp;&nbsp;
		  	#form.Gmonto_n#&nbsp;<cfif isdefined('form.miso4217_n') and len(trim(form.miso4217_n))>#form.miso4217_n#</cfif>
		  </td>
		</tr>
		<tr><td align="right"><label>Servicio:</label>&nbsp;&nbsp;</td> <td colspan="2">#rsPaquete.PQdescripcion#</td> </tr>
		<tr><td colspan="3"><hr></td></tr>
		</tr>
			
		<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
			<cfif isdefined("form.login_#iLog#") and len(trim(form["login_#iLog#"]))>
			<tr>
			  <td bgcolor="##DDEDFF" align="right"><label>Log&iacute;n:</label>&nbsp;&nbsp;</td>
				<td colspan="2" bgcolor="##DDEDFF"><table border="0" cellpadding="2" cellspacing="0"><tr>
					<td>#form['login_#iLog#']#</td>
				<cfif rsPaquete.PQtelefono EQ 1>
					<cfif isdefined("form.LGtelefono_#iLog#") and len(trim(form["LGtelefono_#iLog#"]))>
					<td align="right">&nbsp;&nbsp;-&nbsp;&nbsp;</td> <td>#form['LGtelefono_#iLog#']#</td>
					</cfif>
				</cfif>
			  </tr></table>			</td></tr>
			<tr><td>&nbsp;</td>
				<td colspan="2"><table border="0" cellpadding="2" cellspacing="0">
				<cfset conta = 0>
				<cfset pintaEncab = true>
				<cfset anterior = "">
				<cfloop query="rsServiciosDisponibles">
					<cfif isdefined("form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#") and len(trim(form["chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#"]))>
						<cfif rsServiciosDisponibles.TScodigo NEQ anterior>
							<cfset anterior = #rsServiciosDisponibles.TScodigo#>
							<cfset conta = 0>
						</cfif>
						<cfset conta = conta + 1>
					</cfif>
					<cfif conta NEQ 0 >
						<cfif pintaEncab>
							<tr class="areaFiltro">
								<td align="center">
									Servicio
								</td>
								<td align="center">
									Cantidad
								</td>
							</tr>					
							<cfset pintaEncab = false>
						</cfif>
						<tr>
							<td>
								-&nbsp;#rsServiciosDisponibles.descripcion#
							</td>
							<td align="right">
								#conta#
							</td>
						</tr>
					</cfif>
				</cfloop>
				</table>
			</td></tr>
			<tr>
			  <td colspan="3">&nbsp;</td>
			  <td width="1%"></td>
			</cfif>
		</cfloop>
		<tr><td align="center" colspan="3"><cf_botones values="Cancelar,Volver,Terminar" names="Cancelar,Regresar,Guardar"></td></tr>				
	</table>
	
	
	</form>
	
	<script language="javascript" type="text/javascript">
		function valida_continuar(){
				var error_msg = '';
				if( error_msg != ''){
					alert("Por favor revise los siguiente datos:"+error_msg);
					 return false;
				}
				else{ 
					if(document.form1.botonSel.value == 'Regresar')
						document.form1.adser.value = 4;//indica que el siguiente paso es la eleccion de los logines
					
					else if(document.form1.botonSel.value == 'Cancelar'){
						document.form1.adser.value = 1;
						document.form1.PQcodigo_n.value = "";
					}
					
					else if(document.form1.botonSel.value == 'Guardar'){
						document.form1.adser.value = 6;//indica que el siguiente paso es la eleccion de los logines
						document.form1.action="gestion-servicios-apply.cfm";
					}
					return true;
				}
				
		}
	</script>
</cfoutput>