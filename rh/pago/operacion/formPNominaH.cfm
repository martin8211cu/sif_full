<!--- Parámetros de la lista de la lista de detalles de la Nómina --->
<cfinvoke component="rh.Componentes.Boletapago" method="GetRutaBoleta" returnvariable="ruta"/>


<cfset irA = "SQLPNominaH.cfm">
<cfset showlink = "false">
<cfset filtro = "">
<cfset navegacion = "">
<cfset checkboxes = "S">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Exportar"
Default="Exportar"
returnvariable="BTN_Exportar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Pagar"
Default="Pagar"
returnvariable="BTN_Pagar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Rechazar"
Default="Rechazar"
returnvariable="BTN_Rechazar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Finalizar"
Default="Finalizar"
returnvariable="BTN_Finalizar"/>


<cfset botones = "#BTN_Exportar#, #BTN_Pagar#, #BTN_Rechazar#"><!--- , Pendiente --->
<cfset maxrows = 15>
<cfset showestado = true>
<!--- <cfif rsPendientes.RecordCount eq 0> --->
	<!--- <cfset botones = botones & ", #BTN_Finalizar#"> --->
<!--- </cfif> --->

<!--- Manejo de la navegación de la lista de detalles de la Nómina --->
<cfif isDefined('Url.ERNid') and not isDefined('Form.ERNid')>
	<cfset Form.ERNid = Url.ERNid>
</cfif>
<cfif not isDefined('Form.ERNid')>
	<cflocation url="listaPNominaH.cfm">
</cfif>
<cfset navegacion = "ERNid=" & Form.ERNid>
<cfif isDefined("Url._DRNestado") and not isDefined("Form._DRNestado")>
	<cfset Form._DRNestado = Url._DRNestado>
</cfif>
<cfif isdefined("Form._DRNestado") and Len(Trim(Form._DRNestado)) NEQ 0 and (Trim(Form._DRNestado) NEQ 0)>
	<cfset filtro = filtro & " and a.HDRNestado = " & Trim(Form._DRNestado)>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "_DRNestado=" & Form._DRNestado>
</cfif>


<!--- Consultas --->
<!--- 1. ERNomina --->
<cfquery name="rsERNomina" datasource="#Session.DSN#">
	select 	1 as dato
	from HERNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		and HERNestado in (3,4)
</cfquery>
<!--- Integridad: Protege integridad de datos en caso de pantalla cargada con cache. --->
<cfif rsERNomina.RecordCount lte 0>
	<cflocation url="listaPNominaH.cfm">
</cfif>
<!--- 1. Pendientes: Consulta los detalles de la nómina con estado pendiente. --->
<cfquery name="rsPendientes" datasource="#Session.DSN#">
	select 1 as dato
	from HDRNomina 
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
	and HDRNestado = 3
</cfquery>

<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript">
	function hayAlgunoMarcado() {
		var form = document.lista;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_MarqueUnoOMasRegistrosParaRealizarEstaAccion."
		Default="Marque uno, o más registros, para realizar esta acción."
		returnvariable="MSG_MarqueUnoOMasRegistrosParaRealizarEstaAccion"/>		
		
		if (!result) {alert("<cfoutput>#MSG_MarqueUnoOMasRegistrosParaRealizarEstaAccion#</cfoutput>");}
		return result;
	}
	<!--- <cfif rsPendientes.RecordCount eq 0> --->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ParaPoderFinalizarNoDebeExistirNingunRegistroPendiente"
	Default="Para poder finalizar, No debe existir ningún registro pendiente."
	returnvariable="MSG_ParaPoderFinalizarNoDebeExistirNingunRegistroPendiente"/>	
	
	function hayAlgunoPendiente(){<cfif rsPendientes.RecordCount eq 0>return false;<cfelse>alert("<cfoutput>#MSG_ParaPoderFinalizarNoDebeExistirNingunRegistroPendiente#</cfoutput>"); return true;</cfif>}
	<!--- </cfif> --->
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEstablecerComoPagadosLosRegistrosMarcados"
	Default="¿Desea Establecer como Pagados los Registros Marcados?"
	returnvariable="MSG_DeseaEstablecerComoPagadosLosRegistrosMarcados"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEstablecerComoRechazadosLosRegistrosMarcados"
	Default="¿Desea Establecer como Rechazados los Registros Marcados?"
	returnvariable="MSG_DeseaEstablecerComoRechazadosLosRegistrosMarcados"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEstablecerComoPendientesLosRegistrosMarcados"
	Default="¿Desea Establecer como Pendientes los Registros Marcados?"
	returnvariable="MSG_DeseaEstablecerComoPendientesLosRegistrosMarcados"/>
	
	
	function funcPagar(){var result=false;document.lista.ERNID.value="<cfoutput>#form.ERNid#</cfoutput>";if (hayAlgunoMarcado()&&confirm("<cfoutput>#MSG_DeseaEstablecerComoPagadosLosRegistrosMarcados#</cfoutput>")) result=true;return result;};
	function funcRechazar(){var result=false;document.lista.ERNID.value="<cfoutput>#form.ERNid#</cfoutput>";if (hayAlgunoMarcado()&&confirm("<cfoutput>MSG_DeseaEstablecerComoRechazadosLosRegistrosMarcados</cfoutput>")) result=true;return result;};
	function funcPendiente(){var result=false;document.lista.ERNID.value="<cfoutput>#form.ERNid#</cfoutput>";if (hayAlgunoMarcado()&&confirm("<cfoutput>#MSG_DeseaEstablecerComoPendientesLosRegistrosMarcados#</cfoutput>")) result=true;return result;};

	<!--- <cfif rsPendientes.RecordCount eq 0> --->
	function funcFinalizar(){
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaFinalizarElRegistroDePagoDeEstaNomina"
	Default="¿Desea Finalizar el Registro de Pago de Esta Nómina?"
	returnvariable="MSG_DeseaFinalizarElRegistroDePagoDeEstaNomina"/>
	
		var result = false;
		document.lista.ERNID.value = "<cfoutput>#form.ERNid#</cfoutput>";
		if (!hayAlgunoPendiente() && confirm("<cfoutput>#MSG_DeseaFinalizarElRegistroDePagoDeEstaNomina#</cfoutput>")){ 
			result = true;
		}	
		
		return result;
	};
	
	function funcEnviarEmails() {
		var width = 450;
		var height = 200;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var nuevo = window.open('#Ruta.pago#?ERNid=#Form.ERNid#&historico=H','ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}

	function funcEnviarSMS() {
		var width = 450;
		var height = 200;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var nuevo = window.open('/cfmx/rh/pago/operacion/EnviarSMS.cfm?ERNid=#Form.ERNid#&historico=H','ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}

	<cfif isdefined("Form.ERNid") and Len(Trim(Form.ERNid))>
		<cfquery name="rsRelacionNomina" datasource="#Session.DSN#">
			select RCNid
			from HERNomina
			where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		</cfquery>

		<cfif rsRelacionNomina.recordCount and Len(Trim(rsRelacionNomina.RCNid))>
			function funcRepAsiento() {
				var width = 450;
				var height = 200;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				<cfoutput>
				var nuevo = window.open('../consultas/RepAsientos-rpt.cfm?RCNid=#rsRelacionNomina.RCNid#','RepAsiento','resizable=yes,top='+top+',left='+left+',width='+width+',height='+height);
				</cfoutput>
				nuevo.focus();
			}
		</cfif>
	</cfif>

	<!--- </cfif> --->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaMarcarComoPagadosLosRegistrosPendientes"
	Default="¿Desea Marcar como pagados los registros pendientes?"
	returnvariable="MSG_DeseaMarcarComoPagadosLosRegistrosPendientes"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaMarcarComoRechazadosLosRegistrosPendientes"
	Default="¿Desea Marcar como rechazados los registros pendientes?"
	returnvariable="MSG_DeseaMarcarComoRechazadosLosRegistrosPendientes"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaMarcarComoPendientesTodosLosRegistrosDeEstaNomina"
	Default="¿Desea Marcar como pendientes todos los registros de esta Nómina?"
	returnvariable="MSG_DeseaMarcarComoPendientesTodosLosRegistrosDeEstaNomina"/>
	
	function funcPagarAll(){var result=false;if (confirm("<cfoutput>#MSG_DeseaMarcarComoPagadosLosRegistrosPendientes#</cfoutput>")) result=true;return result;};
	function funcRechazarAll(){var result=false;if (confirm("<cfoutput>#MSG_DeseaMarcarComoRechazadosLosRegistrosPendientes#</cfoutput>")) result=true;return result;};
	function funcPendienteAll(){var result=false;if (confirm("<cfoutput>#MSG_DeseaMarcarComoPendientesTodosLosRegistrosDeEstaNomina#</cfoutput>")) result=true;return result;};
	
	function funcMensajeBoleta(){
		location.href = '../../admin/catalogos/MensajeBoletaPago.cfm?ruta=../../pago/operacion/PNominaH.cfm?ERNid='+document.formSel.ERNid.value;
	}
</script>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="65%" valign="top">
		<!--- Columna 1 --->
		<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
		  <tr>
		  	<td>&nbsp;
			</td>
		  </tr>
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="2" cellpadding="0">
				  <tr>
					<td valign="middle" width="1%" align="left" nowrap><strong><cf_translate  key="LB_Ver">Ver</cf_translate>:&nbsp;</strong></td>
					<!---<td valign="baseline" width="1%">&nbsp;</td>--->
				  	<td valign="baseline" align="left" >
						<form action="PNominaH.cfm" method="post"  name="formSel" style="margin:0;">
							<select name="_DRNestado" onChange="javascript: this.form.submit();">
								<option value="0"><cf_translate  key="CMB_Todos">Todos</cf_translate></option>
								<option value="1" <cfif (isDefined("Form._DRNestado")) and (Form._DRNestado EQ 1)>selected</cfif>><cf_translate  key="CMB_Pagados">Pagados</cf_translate></option>
								<option value="2" <cfif (isDefined("Form._DRNestado")) and (Form._DRNestado EQ 2)>selected</cfif>><cf_translate  key="CMB_Rechazados">Rechazados</cf_translate></option>
								<!--- <option value="3" <cfif (isDefined("Form._DRNestado")) and (Form._DRNestado EQ 3)>selected</cfif>>Pendientes</option> --->
							</select><input type="hidden" name="ERNid" value="<cfoutput>#Form.ERNid#</cfoutput>">
						</form>
					</td>
					<!---
					<td valign="baseline" align="left" nowrap>
						&nbsp;
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Enviar"
						Default="Enviar"
						returnvariable="BTN_Enviar"/>
						<input type="button" style="width:80px;" onClick="javascript:funcEnviarEmails();" value="<cfoutput>#BTN_Enviar#</cfoutput>">&nbsp;<cf_translate  key="LB_EnviarBoletasDePagoPorCorreo">Enviar Boletas de Pago por Correo</cf_translate>
					</td>
					<td valign="baseline" align="right" nowrap>
						<!--- <cfif isdefined("Form.ERNid") and Len(Trim(Form.ERNid)) and rsRelacionNomina.recordCount and Len(Trim(rsRelacionNomina.RCNid))>
							<a href="javascript: funcRepAsiento();"><cf_translate  key="LB_VerAsientoAGenerar">Ver Asiento a Generar</cf_translate></a>
						<cfelse>
							&nbsp;
						</cfif> --->
					</td>
					--->
				  </tr>
	
					<!---
					<cfquery name="dataSMS"	 datasource="#session.DSN#">
						select Pvalor 
						from Parametros 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and Pcodigo = 610
					</cfquery>
				  <cfif dataSMS.recordCount gt 0 and trim(dataSMS.Pvalor) eq 1 >
					  <tr>
						<td colspan="2">&nbsp;</td>
						<td valign="baseline" align="left" nowrap><!---colspan="2" --->						
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_EnviarSMS"
							Default="Enviar SMS"
							returnvariable="BTN_EnviarSMS"/>						
							&nbsp;&nbsp;<input type="button" style="width:80px;" onClick="javascript:funcEnviarSMS();" value="<cfoutput>#BTN_EnviarSMS#</cfoutput>">&nbsp;<cf_translate  key="LB_EnviarNotificacionDePagoMedianteSMS">Enviar notificaci&oacute;n de pago mediante SMS</cf_translate>
						</td>
						<td align="right">
							<a href="javascript: funcMensajeBoleta();"><cf_translate  key="LB_EditarMensajeEnBoleta">Editar Mensaje en Boleta</cf_translate></a>
						</td>
					</tr>
					
				 </cfif>
				 --->
				</table>
				<br>
			</td>
		  </tr>
		  <tr>
			<td>
				<cfinclude template="filtroDNominaH.cfm">
				<cfinclude template="listaDNominaH.cfm">
			</td>
		  </tr>
		  <!--- <tr>
			<td>
				<form action="SQLPNominaH.cfm" method="post" name="formSel">
				<input type="hidden" name="ERNid" value="<cfoutput>#Form.ERNid#</cfoutput>">
				<!---
				<div align="center">
					<input type="submit" name="btnFinalizar" id="btnFinalizar" value="Finalizar" alt="Finalizar Registro de Pago de Nómina."
						onClick="javascript:  return funcFinalizar()  ;">
				</div> --->
				</form>
			</td>
		  </tr> --->
		</table>
	</td>
    <td width="35%" valign="top"> &nbsp; 
		<!--- Columna 2 --->
<br><br><br><br>
		<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
		<form action="SQLPNominaH.cfm" method="post" name="formButs">
		<input type="hidden" name="ERNid" value="<cfoutput>#Form.ERNid#</cfoutput>">
		  <tr>
		  	<td class="ayuda">
				<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				  <tr>
					<td align="center">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_PagarTodos"
						Default="Pagar Todos"
						returnvariable="BTN_PagarTodos"/> 
					
						<input type="submit" name="btnPagarAll" id="btnPagarAll" value="<cfoutput>#BTN_PagarTodos#</cfoutput>" alt="Marcar como pagados<!---  los registros pendientes. --->"
						onClick="javascript:  return funcPagarAll()  ;">
					</td>
				  </tr>
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				  <tr>
					
                  <td align="justify"> <div align="justify">
				      <cf_translate  key="AYUDA_MarcarComoPagadosTodosLosRegistros">
					  Marcar como pagados 
                      todos los registros. Pondría estado de pagado a todos los 
                      registros correspondientes a esta nómina.
					  </cf_translate></div></td><!--- Marcar como pagados 
                      los registros pendientes. Pondría estado de pagado a los 
                      registros correspondientes a esta nómina que se encuentren 
                      en estado pendiente. --->
				  </tr>
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		  <tr>
		  	<td>&nbsp;
			</td>
		  </tr>
		  <tr>
		  	<td class="ayuda">
				<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				  <tr>
					<td align="center">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_RechazarTodos"
						Default="Rechazar Todos"
						returnvariable="BTN_RechazarTodos"/> 
						
						<input type="submit" name="btnRechazarAll" id="btnRechazarAll" value="<cfoutput>#BTN_RechazarTodos#</cfoutput>" alt="Marcar como rechazados<!---  los registros pendientes --->."
						onClick="javascript:  return funcRechazarAll()  ;">
					</td>
				  </tr>
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				  <tr>
					
                  <td align="justify"> <div align="justify">
				      <cf_translate  key="LB_MarcarComoRechazadosTodosLosRegistros">
					  Marcar como rechazados 
                      todos los registros. Pondría estado de rechazado a todos
                      los registros correspondientes a esta nómina.
					  </cf_translate>
					  </div></td><!---Marcar como rechazados 
                      los registros pendientes. Pondría estado de rechazado a 
                      los registros correspondientes a esta nómina que se encuentren 
                      en estado pendiente.--->
				  </tr>
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		  <tr>
		  	<td>&nbsp;
			</td>
		  </tr>

			<!--- <cfquery name="rsExportado" datasource="#session.DSN#">
				select HERNexportado from HERNomina
				where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">
			</cfquery> --->   <!---  Este campo no está en el histórico de ERNomina---> 
		  
			<!--- <cfif isDefined("botones") and len(trim(botones)) NEQ 0 and rsExportado.ERNexportado eq 0> --->
			<cfif isDefined("botones") and len(trim(botones)) NEQ 0 >
				<script language="javascript1.2" type="text/javascript">
					function desactivar_botones(valor){
						document.lista.btnPagar.disabled = valor;
						document.lista.btnRechazar.disabled = valor;
						 if ( document.lista.btnFinalizar ){
							document.lista.btnFinalizar.disabled = valor;
						 }
						
						document.formButs.btnPagarAll.disabled = valor;
						document.formButs.btnRechazarAll.disabled = valor;
					}

					function funcExportar() {
						var top = (screen.height - 500) / 2;
						var left = (screen.width - 450) / 2;
						window.open('/cfmx/rh/pago/operacion/exportar.cfm?ERNid=<cfoutput>#form.ERNid#</cfoutput>', 'Exportar','menu=no,scrollbars=yes,top='+top+',left='+left+',width=350,height=200');
						return false;
					}

					desactivar_botones(false);
				</script>
			</cfif>		  
		  
		  <!--- <tr>
		  	<td class="ayuda">
				<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				  <tr>
					<td align="center">
						<input type="submit" name="btnPendienteAll" id="btnPendienteAll" value="Pendientes Todos" alt="Marcar como pendientes todos los registros."
						onClick="javascript:  return funcPendienteAll()  ;">
					</td>
				  </tr>
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				  <tr>
					
                  <td align="justify"> <div align="justify">Marcar como pendientes 
                      todos los registros. Pondría estado de pendiente a todos 
                      los registros correspondientes a esta nómina. </div></td>
				  </tr>
				  <tr>
					<td>&nbsp;
					</td>
				  </tr>
				</table>
			</td>
		  </tr> --->
		</form>
		</table>
	</td>
  </tr>
</table>