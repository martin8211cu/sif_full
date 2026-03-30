<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>
<cfif IsDefined('url.tab')>
	<cfset form.tab = url.tab>
<cfelse>
	<cfparam name="form.tab" default="1">
</cfif>
<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
	<cfset form.tab = 1 >
</cfif>

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin){
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doImpuestoRenta() {
		popUpWindow("ConlisIRenta.cfm?form=form1&id=CMSid&nombre=CMSnombre",250,200,650,350);
	}
	
	function asignar(obj, tipo){
		if (trim(obj.value) == '') {
			switch (tipo){
				case 'S' :
					obj.value = 7;
				break;
				case 'B' :
					obj.value = 14;
				break;
				case 'Q' :
					obj.value = 15;
				break;
				case 'M' :
					obj.value = 30;
				break;
			}
		}
		return;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function validar(){
		document.form1.RedondeoMonto.value = qf(document.form1.RedondeoMonto);
		document.form1.SMmensual.value = qf(document.form1.SMmensual);
		return true
	}

</script>

 <!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select Pvalor 
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- obtiene los datos,  si ya existen --->
<cfset definidos              	= ObtenerDato(5)>		<!--- Parametrizacion Definida --->
<cfset PvalorPagoNomina       	= ObtenerDato(7)>		<!--- RH, Banco Virtual --->
<cfset PvalorIContable        	= ObtenerDato(20)>	<!--- Interfaz contable --->
<cfset PvalorACUnificado      	= ObtenerDato(25)>	<!--- Asiento Contable Unificado --->
<cfset PvalorIRenta           	= ObtenerDato(30)>	<!--- Impuesto Renta --->
<cfset PvalorTPSemanal        	= ObtenerDato(40)>	<!--- Tipo Pago Semanal --->
<cfset PvalorTPBisemanal      	= ObtenerDato(50)>	<!--- Tipo Pago Bisemanal --->
<cfset PvalorTPQuincenal      	= ObtenerDato(60)>	<!--- Tipo Pago Quincenal --->
<cfset PvalorTPMensual        	= ObtenerDato(70)>	<!--- Tipo Pago Mensual --->
<cfset PvalorCNMensual        	= ObtenerDato(80)>	<!--- Calculo Mensual --->
<cfset PvalorDiasTipoNomina   	= ObtenerDato(90)>	<!--- Calculo Quincenal --->
<cfset PvalorRedondeoMonto    	= ObtenerDato(110)>	<!--- Redondeo a monto --->
<cfset PvalorTipoRedondeo     	= ObtenerDato(120)>	<!--- Tipo de Redondeo --->
<cfset PvalorSMmensual        	= ObtenerDato(130)>	<!--- Salario minimo mensual --->
<cfset PvalorCuentaRenta      	= ObtenerDato(140)>	<!--- Cuenta Contable de renta --->
<cfset PvalorCuentaPagos      	= ObtenerDato(150)>	<!--- Cuenta Contable de pagos no Realizados --->
<cfset PvalorPeriodos         	= ObtenerDato(160)>	<!--- Cantidad de Periodos para Calculo Salario Promedio --->
<cfset PvalorCorreoPago       	= ObtenerDato(170)>	<!--- Manda correo de boleta de pago --->
<cfset PvalorAdministrador    	= ObtenerDato(180)>	<!--- Administrador --->
<cfset PvalorCorreoBoleta     	= ObtenerDato(190)>	<!--- Cuenta de Correo (DE:) en boleta de Pago  --->
<cfset PvalorAgendaMedica     	= ObtenerDato(220)>	<!--- Codigo de Agenda Medica --->
<cfset PvalorTipoEvaluacion   	= ObtenerDato(230)>	<!--- Tipo de evaluacion del desempeño  --->
<cfset PvalorDiasAntesVac     	= ObtenerDato(260)>	<!--- Cantidad de Dias antes para asignar Vacaciones  --->
<cfset PvalorProcesaEnf       	= ObtenerDato(270)>	<!--- Procesa dias de enfermedad --->
<cfset PvalorUltimaCorridaVac 	= ObtenerDato(280)>	<!--- Ultima fecha de coorida de vacaciones --->
<cfset PvalorScriptMarcas 	  	= ObtenerDato(290)>   <!--- Nombre del Script de Importacion de Marcas de Reloj --->
<cfset PvalorNumeroPatronal   	= ObtenerDato(300)>   <!--- Numero Patronal para reporte Seguro Social --->
<cfset PvalorImpSeguroSocial  	= ObtenerDato(310)>   <!--- Importador para archivo de Seguro Social --->
<cfset PvalorImpINS  		  	= ObtenerDato(320)>   <!--- Importador para archivo del INS --->
<cfset PvalorCalculaComisionSB  = ObtenerDato(330)>   <!--- Calcula comision con Salario Base --->
<cfset PvalorIncidenciaRebajoSB	= ObtenerDato(340)>   <!--- Incidencia para Rebajo para salario por calculo de comisiones  --->
<cfset PvalorIncidenciaSB 		= ObtenerDato(350)>   <!--- Incidencia para Salario Base --->
<cfset PvalorIncidenciaAjusteSB	= ObtenerDato(360)>   <!--- Incidencia para ajuste de salario base --->
<cfset PvalorScriptComisiones	= ObtenerDato(370)>   <!--- Script de Importacion de Comisiones --->
<cfset PvalorIncidenciasSalRec	= ObtenerDato(380)>   <!--- Incidencias por salario recibido --->
<cfset PvalorScriptPagoNomina	= ObtenerDato(390)>   <!--- Script de Exportacion de Pago de Nomina --->
<cfset PvalorRequiereCFConta	= ObtenerDato(400)>   <!--- Requerir Centro Funcional de Contabilizacion --->
<cfset PvalorRequiereSucAds		= ObtenerDato(410)>   <!--- Requerir Sucursal Adscrita CCSS --->
<cfset PvalorRequierePolIns		= ObtenerDato(420)>   <!--- Requerir Numero de Poliza del Ins --->
<cfset PvalorProteccionTrab		= ObtenerDato(430)>   <!--- Fecha de Corte en Cálculo de Cesantia (Boleta) --->
<cfset PvalorPeriodosLiq		= ObtenerDato(440)>   <!--- Cantidad de Periodos para Cálculo de Salario Promedio (Boleta)--->
<cfset PvalorBenziger		    = ObtenerDato(450)>   <!--- Usa test de Bezinger --->
<cfset PvalorAccionNombramiento = ObtenerDato(460)>   <!--- Accion Nombramiento --->
<cfset PvalorAccionCambio		= ObtenerDato(470)>   <!--- Accion Cambio --->
<cfset PvalorAutorizaMarcas     = ObtenerDato(480)>   <!--- Autorización de Marcas para RH--->

<!--- valida la existencia de los datos --->
<cfif PvalorPagoNomina.RecordCount GT 0 >
<!--- Usa RH, banco virtual --->
<cfset existePagoNomina = true><cfelse><cfset existePagoNomina = false ></cfif>		
<!--- Usa Interfaz Contable --->
<cfif PvalorIContable.RecordCount GT 0 ><cfset existeIContable = 1><cfelse><cfset existeIContable = 0 ></cfif>				
<!--- Impuesto de Renta--->	
<cfif PvalorIRenta.RecordCount GT 0 ><cfset existeIRenta = 1><cfelse><cfset existeIRenta = 0 ></cfif>
<!--- Dias para Calculo de nomina Quincenal --->
<cfif PvalorDiasTipoNomina.RecordCount GT 0 ><cfset existeDiasTipoNomina = 1><cfelse><cfset existeDiasTipoNomina = 0 ></cfif>	
<!--- Cuenta Contable de Renta --->
<cfif PvalorCuentaRenta.RecordCount GT 0 ><cfset existeCuentaRenta = 1><cfelse><cfset existeCuentaRenta = 0 ></cfif>		
<!--- Cuenta Contable de pagos no realizados --->
<cfif PvalorCuentaPagos.RecordCount GT 0 ><cfset existeCuentaPagos = 1><cfelse><cfset existeCuentapagos = 0 ></cfif>		
<!--- Manda correo de boleta de pago --->
<cfif PvalorCorreoPago.RecordCount GT 0 ><cfset existeCorreoPago = 1 ><cfelse><cfset existeCorreoPago = 0 ></cfif>		
<!--- Usuario Administrador --->		
<cfif PvalorAdministrador.RecordCount GT 0 and len(trim(PvalorAdministrador.Pvalor)) GT 0><cfset existeAdministrador = 1 ><cfelse><cfset existeAdministrador = 0 ></cfif>		

		<table width="100%" cellpadding="2" cellspacing="0" style="vertical-align:top; ">
			<TR><TD valign="top">
			<form style="margin:0; " action="SQLParametros2.cfm" method="post" name="form1" onSubmit="javascript: return validar();" >			
			<input type="hidden" name="tab" value="<cfif isdefined('form.tab') and form.tab NEQ ''><cfoutput>#form.tab#</cfoutput><cfelse>1</cfif>">
			<cf_tabs width="100%" onclick="tab_set_current_param">

				<cf_tab text="Contabilizaci&oacute;n" id="1" selected="#form.tab is '1'#">
					<!--- <cfif form.tab eq '1'> --->
						
							<cfinclude template="contabilidad-tab.cfm">
<!--- 						</form>		 --->
					<!--- </cfif> --->
				</cf_tab>

				<cf_tab text="N&oacute;mina" id="2" selected="#form.tab is '2'#">
					<!--- <cfif form.tab eq '2'> --->
<!--- 						<form style="margin:0; " action="SQLParametros2.cfm" method="post" name="form2" > --->
							<cfinclude template="nomina-tab.cfm">
						<!--- </form>	 --->
					<!--- </cfif> --->
				</cf_tab>
				<cf_tab text="Acciones de Personal" id="3" selected="#form.tab is '3'#">
					<!--- <cfif form.tab eq '3'> --->
						<!--- <form style="margin:0; " action="SQLParametros2.cfm" method="post" name="form3" > --->
							<cfinclude template="acciones-tab.cfm">
						<!--- </form> --->
					<!--- </cfif> --->
				</cf_tab>
				<cf_tab text="M&oacute;dulos" id="4" selected="#form.tab is '4'#">
					<!--- <cfif form.tab eq '4'> --->
						<!--- <form style="margin:0; " action="SQLParametros2.cfm" method="post" name="form4" > --->
							<cfinclude template="modulos-tab.cfm">
						<!--- </form>	 --->
					<!--- </cfif> --->
				</cf_tab>
				<cf_tab text="Otros" id="5" selected="#form.tab is '5'#">				
					<!--- <cfif form.tab eq '5'> --->
						<!--- <form style="margin:0; " action="SQLParametros2.cfm" method="post" name="form5" > --->
							<cfinclude template="otros-tab.cfm">
						<!--- </form>		 --->
					<!--- </cfif> --->
				</cf_tab>
				 
			</cf_tabs>
			</form>
			</TD></TR>
		</table>

<script language="javascript1.2" type="text/javascript">
	function doAdministrador() {
		popUpWindow("ConlisUsuarios2.cfm",250,200,650,350);
	}
	
	function mostrar_tabla(tipo){
		document.getElementById('id_tabla').style.visibility = tipo;
	}
	
	function salario_base(valor){
		var f = document.form1;
		if ( valor ){
			f['RHrebajo'].disabled = false;
			f['RHincidencia'].disabled = false;
			f['RHajuste'].disabled = false;
			f['impComision'].disabled = false;
		}
		else{
			f['RHrebajo'].disabled = true;
			f['RHincidencia'].disabled = true;
			f['RHajuste'].disabled = true;
			f['impComision'].disabled = true;
		}
	}
	salario_base(document.form1.CalculaComision.checked)
	
	/*function x(n){
		if (tab_current == n) return;
		tab_set_style(tab_current, 'nor', 'none');
		tab_current = n;
		tab_set_style(tab_current, 'sel', 'block');
		document.form1.tab.value = n;
	}*/
	
	function tab_set_current_param (n){
		/*var param = "";
		<cfif isdefined("form.identificacion_persona") and form.identificacion_persona NEQ ''>
			param = param + "&identificacion_persona=<cfoutput>#JSStringFormat(form.identificacion_persona)#</cfoutput>";
		</cfif>					
		<cfif isdefined("form.id_tipoident") and form.id_tipoident NEQ ''>
			param = param + "&id_tipoident=<cfoutput>#JSStringFormat(form.id_tipoident)#</cfoutput>";
		</cfif>*/

		document.form1.tab.value = n;
		location.href='Parametros2.cfm?tab='+escape(n);
	}			
	
</script>