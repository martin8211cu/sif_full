<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_El_Valor_debe_estar_en_el_rango_0_100." default="El Valor debe estar en el rango 0 - 100."	 returnvariable="LB_Rango" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_La_Deduccion_no_se_puede_eliminar_pues_esta_asociada_a_una_Relacion_de_Calculo" default="La Deducción no se puede eliminar, pues esta asociada a una Relación de Cálculo"	 returnvariable="LB_EliminarDeduccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo_de_Deduccion" default="Tipo de Deducción"	 returnvariable="LB_Tipo_de_Deduccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Valor" default="Valor" returnvariable="LB_Valor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Porcentaje" default="Porcentaje" returnvariable="LB_Porcentaje" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Inicial" default="Fecha Inicial" returnvariable="LB_Fecha_Inicial" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Controla_Saldo" default="Controla Saldo" returnvariable="LB_Controla_Saldo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FondoAhorro" default="Fondo Ahorro" returnvariable="LB_FondoAhorro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Monto" default="Monto" returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Saldo" default="Saldo" returnvariable="LB_Saldo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TMontoInteres" default="Pr&eacute;stamo FOA" returnvariable="LB_TMontoInteres" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Interes" default="Inter&eacute;s" returnvariable="LB_Interes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MontoInteres" default="Monto de Int&eacute;res" returnvariable="LB_MontoInteres" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Debe_contener_una_fecha_valida" default="debe contener una fecha válida." returnvariable="LB_FechaValida" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_El_Valor_no_puede_ser_mayor_al_Monto" default="El Valor no puede ser mayor al Monto." returnvariable="LB_ValorMayorMonto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tasa" default="Tasa" returnvariable="LB_Tasa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Monto_de_Interes" default="Monto de Interés" returnvariable="LB_Monto_de_Interes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Socio_de_Negocio" default="Socio de Negocio" returnvariable="LB_Socio_de_Negocio" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>

<cfinvoke key="LB_NoAplica" default="No Aplica" returnvariable="LB_NoAplica" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Inicio" default="Inicio" returnvariable="LB_Inicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Reinicio" default="Reinicio" returnvariable="LB_Reinicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_VUMA" default="VUMA" returnvariable="LB_VUMA" component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_VUMI" default="VUMI" returnvariable="LB_VUMI" component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_CuotaFija" default="Cuota Fija" returnvariable="LB_CuotaFija" component="sif.Componentes.Translate" method="Translate">
<cfinvoke key="LB_FONACOT" default="FONACOT" returnvariable="LB_FONACOT" component="sif.Componentes.Translate" method="Translate">

<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfset lvarEnProceso = false>
<cfset lvarEnHistorico = false>
<cfif modo EQ "CAMBIO" and isdefined('form.DEid') and isdefined('form.Did')>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		Select Did, DEid, Ddescripcion, a.SNcodigo, rtrim(b.SNnumero) as SNnumero, b.SNnombre,
		       Dfechaini, Dfechafin,
			   Dmetodo, Dvalor, Dmonto, Dtasa, Dsaldo, Dmontoint, a.Dactivo, a.Dcontrolsaldo, a.Dreferencia,
			   TDid, a.ts_rversion, coalesce(a.Dinicio,0) as Dinicio,DmontoFOA,DinteresFOA
		from DeduccionesEmpleado a, SNegocios b
		where a.Ecodigo=b.Ecodigo
		  and a.SNcodigo=b.SNcodigo
		  and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- Verifica si la deduccion esta en un proceso de calculo de nomina --->
	<cfquery name="rsDeducionEnProceso" datasource="#Session.DSN#">
		select count(1) as cantidad
		from DeduccionesCalculo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	</cfquery>
	<!--- Si la deduccion esta presente no puede ser modifica al menos que sea eliminada del calculo de nomina--->
	<cfif rsDeducionEnProceso.cantidad gt 0>
		<cfset lvarEnProceso = true>
	</cfif>

	<!--- Verifica si la deduccion esta el historico de nominas pagadas --->
	<cfquery name="rsDeducionHistorico" datasource="#Session.DSN#">
		select count(1) as cantidad
		from HDeduccionesCalculo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	</cfquery>
	<!--- Si la deduccion esta presente no puede ser modifica al menos que sea eliminada del calculo de nomina--->
	<cfif rsDeducionHistorico.cantidad gt 0>
		<cfset lvarEnHistorico = true>
	</cfif>

	<cfif len(trim(rsform.TDid)) eq 0>
		<cfset lvarTDid = -1>
	<cfelse>
		<cfset lvarTDid = rsform.TDid>
	</cfif>

	<cfquery name="rsTDeduccionRenta" datasource="#session.DSN#">
		select 1
		from TDeduccion
		where TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTDid#">
		and TDrenta > 0
	</cfquery>

	<cfquery name="rsCalculo" datasource="#session.DSN#">
		select 1
		from DeduccionesCalculo
		where Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>

	<cfquery name="rsHCalculo" datasource="#session.DSN#">
		select 1
		from HDeduccionesCalculo
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	</cfquery>

	<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
		select TDid, TDcodigo, TDdescripcion, TDfinanciada
		from TDeduccion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarTDid#">
	</cfquery>

	<cfquery name="rsDeduccionPlan" datasource="#Session.DSN#">
		select 1
		from DeduccionesEmpleadoPlan
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	</cfquery>

    <cfquery  name="rsDfondoahorro" datasource="#Session.DSN#">
    	select DEid,DFA
        from DeduccionesEmpleado
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
           and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
    </cfquery>

	<cfquery name="rsDeduccAsoc" datasource="#session.DSN#">
		select 1
		from ACAsociados a
		inner join ACAportesAsociado b
			on b.ACAid = a.ACAid
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		union
		select 1
		from ACAsociados a
		inner join ACCreditosAsociado b
			on b.ACAid = a.ACAid
		inner join ACPlanPagos c
			on c.ACCAid = b.ACCAid
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	</cfquery>
</cfif>




<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>

<script language="JavaScript1.2" type="text/javascript">
	function porcentaje(){
		if ( document.form1.Dmetodo.value == 0 ){
			var numero = new Number(qf(document.form1.Dvalor.value))
			if ( numero < 0 || numero > 100  ){
				<cfoutput>alert('#LB_Rango#')</cfoutput>;
				document.form1.Dvalor.value = 0.00
				document.form1.Dvalor.value = LSNumberFormat(fm(document.form1.Dvalor.value ,2),"99.9999" )
			}
			return;
		}
	}

function validar(){
	<cfif modo neq 'ALTA'>
		if ( trim(document.form1.botonSel.value) == 'Baja' ){
			<cfif rsCalculo.recordCount gt 0 or rsHCalculo.recordCount gt 0 >
				<cfoutput>alert('#LB_EliminarDeduccion#') </cfoutput>
				return false;
			</cfif>
		}
	</cfif>

	document.form1.Dvalor.value    = qf(document.form1.Dvalor.value);
	document.form1.Dmonto.value    = qf(document.form1.Dmonto.value);
	document.form1.Dtasa.value     = qf(document.form1.Dtasa.value);
	document.form1.Dsaldo.value    = qf(document.form1.Dsaldo.value);
	document.form1.Dmontoint.value = qf(document.form1.Dmontoint.value);
	document.form1.Dsaldo.disabled = false;
	document.form1.Dactivo.disabled = false;
	document.form1.Dcontrolsaldo.disabled = false;
	document.form1.TDdescripcion.disabled = false;
	document.form1.Dmetodo.disabled = false;
	document.form1.Dmonto.disabled = false;

	return true;
}

function mostrar_datos(valor){
	var etiquetas1 =  document.getElementById('etiquetas1');
	var campos1    =  document.getElementById('campos1');
	var etiqFondoA =  document.getElementById('etiqFondoA');
	var campoFondoA =  document.getElementById('campoFondoA');
	var etiq2FondoA =  document.getElementById('etiq2FondoA');
	var campo2FondoA =  document.getElementById('campo2FondoA');

	if (valor){
		etiquetas1.style.display = ''
		campos1.style.display    = ''
		etiqFondoA.style.display = ''
		campoFondoA.style.display = ''
		etiq2FondoA.style.display = ''
		campo2FondoA.style.display = ''
	}
	else{
		etiquetas1.style.display = 'none'
		campos1.style.display    = 'none'
		etiqFondoA.style.display = 'none'
		campoFondoA.style.display = 'none'
		etiq2FondoA.style.display = 'none'
		campo2FondoA.style.display = 'none'
	}
}

function saldo(obj){
	document.form1.Dsaldo.value = obj.value;
}

function montofoa(obj){ <!---SML. Modificacion para calculo de prestamo de FOA--->
	var porcentaje = obj.value;
	var monto = document.form1.DTmontointeres.value.replace(',','');

	var total = 0;
	var totalm = 0;
	total = (monto * porcentaje)/100;
	totalm = (parseFloat(total) + parseFloat(monto));
	<!---alert(monto);--->
	document.form1.Dminteres.value = total;
	document.form1.Dmonto.value = totalm;
	document.form1.Dmonto.onblur = saldo(document.form1.Dmonto);
}


	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisTipoDeduccion() {
		popUpWindow("/cfmx/rh/Utiles/ConlisTipoDeduccion.cfm?form=form1&id=TDid&desc=TDdescripcion",250,200,400,350);
	}

	function funcTDid(){
		var _tdid = document.form1.TDid.value;
		var _frame = document.getElementById("frtdcomportam");
		_frame.src = "/cfmx/rh/expediente/catalogos/tdcomportam.cfm?tdid="+_tdid;
	}
</script>
<iframe id="frtdcomportam" name="frtdcomportam" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<form method="post" enctype="multipart/form-data" name="form1" action="<cfoutput>#trim(action)#</cfoutput>" onsubmit="javascript:return validar();" >
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<cfif isdefined("action") and action neq "ResultadoModify-sql.cfm" and action neq "ResultadoModifyEsp-sql.cfm">
			<tr>
				<td width="5%">&nbsp;</td>
				<td colspan="2" align="center" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>"><cfif modo neq 'ALTA'><cf_translate key="LB_Modifica_deduccion">Modificar Deducci&oacute;n</cf_translate><cfelse><cf_translate key="LB_Agregar_deduccion">Agregar Deducci&oacute;n</cf_translate></cfif></td>
			</tr>
		</cfif>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" class="fileLabel"><cfoutput>#LB_Tipo_de_Deduccion#</cfoutput></td>
		</tr>

		<cfoutput>
		<tr>
			<td>&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_rhtipodeduccion query="#rsTipoDeduccion#" size="60" onChange="CargaSN();" readOnly="true">
				<cfelse>
					<cf_rhtipodeduccion size="60" onChange="CargaSN();">
				</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td><td colspan="2" class="fileLabel">#LB_Descripcion#</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="Ddescripcion" type="text" id="Ddescripcion" onfocus="this.select();" <cfif modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount>readonly</cfif>
					value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.Ddescripcion)#</cfoutput></cfif>" size="74" maxlength="80">
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">

					<tr>
						<td class="fileLabel"><cf_translate key="LB_Referencia">Referencia</cf_translate></td>
						<td width="5%">&nbsp;</td>
						<td class="fileLabel"><cf_translate key="LB_Socio">Socio</cf_translate></td>
					</tr>
					<tr>

						<td>
							 <cfif modo EQ "CAMBIO" and rsDeduccionPlan.recordCount>
							 	#trim(rsForm.Dreferencia)#
							 	<input name="Dreferencia" type="hidden" value="#trim(rsForm.Dreferencia)#">
							 <cfelse>
								<input name="Dreferencia" type="text" id="Dreferencia" onfocus="this.select();" <cfif modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount>readonly</cfif>
									value="<cfif modo NEQ 'ALTA'>#trim(rsForm.Dreferencia)#</cfif>" size="30" maxlength="20">
							 </cfif>
						</td>
						<td width="5%">&nbsp;</td>
						<td>
							<cfif modo NEQ "ALTA">
								<cf_rhsociosnegociosFA query="#rsForm#">
								<script language="JavaScript1.2" type="text/javascript">
									<cfif modo neq 'ALTA'>
										document.form1.SNnumero.focus();
										document.form1.SNnumero.blur();
									</cfif>
								</script>
							<cfelse>
								<cf_rhsociosnegociosFA>
							</cfif>
						</td>
					</tr>

					<!---ljimenez Movimiento de inicio de deduccion--->

					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
						ecodigo="#session.Ecodigo#" pvalor="2025" default="" returnvariable="vUsaSBC"/>

					<cfif #vUsaSBC# EQ 1 and modo NEQ "CAMBIO">
						<tr>
							<td class="fileLabel"><cf_translate key="LB_Movimiento">Movimiento</cf_translate></td>
							<td width="5%">&nbsp;</td>
						</tr>
						<tr>
							<td>
								<cfif (modo EQ "CAMBIO" and rsDeduccionPlan.recordCount) or (modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount)>
									<cfif rsForm.Dinicio EQ 0>
										#LB_NoAplica#
									<cfelseif rsForm.Dinicio EQ 1>
										#LB_Inicio#
									<cfelseif rsForm.Dinicio EQ 2>
										#LB_Reinicio#
									</cfif>
									<input type="hidden" name="Dinicio" value="#rsForm.Dinicio#">
								<cfelse>
									<select name="Dinicio" <cfif isdefined("rsTDeduccionRenta") and rsTDeduccionRenta.RecordCount gt 0>disabled</cfif>>
										<option value="0"  <cfif modo NEQ 'ALTA' and rsForm.Dinicio eq 0 >selected</cfif> >#LB_NoAplica#</option>
										<option value="1"  <cfif modo NEQ 'ALTA' and rsForm.Dinicio eq 1 >selected</cfif> >#LB_Inicio#</option>
										<option value="2"  <cfif modo NEQ 'ALTA' and rsForm.Dinicio eq 1 >selected</cfif> >#LB_Reinicio#</option>
									</select>
								</cfif>
							</td>
						</tr>
						<!---ljimenez Movimiento de inicio de deduccion--->
					</cfif>

					<tr>
						<td class="fileLabel"><cf_translate key="LB_Metodo">M&eacute;todo</cf_translate></td>
						<td width="5%">&nbsp;</td>
						<td class="fileLabel">#LB_Valor#</td>
					</tr>

					<tr>
						<td>
							<cfif (modo EQ "CAMBIO" and rsDeduccionPlan.recordCount) or (modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount)>
								<cfif rsForm.Dmetodo EQ 0>
									#LB_Porcentaje#
								<cfelseif rsForm.Dmetodo EQ 1>
									#LB_Valor#
								<cfelseif rsForm.Dmetodo eq 2>
									#LB_VUMA#
								<cfelseif rsForm.Dmetodo eq 3>
									#LB_VUMI#
								<cfelseif rsForm.Dmetodo eq 4>
									#LB_CuotaFija#
								</cfif>
								<input type="hidden" name="Dmetodo" value="#rsForm.Dmetodo#">
							<cfelse>
								<select name="Dmetodo" onchange="javascript:porcentaje();" <cfif isdefined("rsTDeduccionRenta") and rsTDeduccionRenta.RecordCount gt 0>disabled</cfif>>
									<option value="0" <cfif modo NEQ 'ALTA' and rsForm.Dmetodo eq 0 >selected</cfif> >#LB_Porcentaje#</option>
									<option value="1" <cfif modo NEQ 'ALTA' and rsForm.Dmetodo eq 1 >selected</cfif> >#LB_Valor#</option>
									<option value="2" <cfif modo NEQ 'ALTA' and rsForm.Dmetodo eq 2 >selected</cfif> >#LB_VUMA#</option>
									<option value="3" <cfif modo NEQ 'ALTA' and rsForm.Dmetodo eq 3 >selected</cfif> >#LB_VUMI#</option>
									<option value="4" <cfif modo NEQ 'ALTA' and rsForm.Dmetodo eq 4 >selected</cfif> >#LB_CuotaFija#</option>
									<option value="5" <cfif modo NEQ 'ALTA' and rsForm.Dmetodo eq 5 >selected</cfif> >#LB_FONACOT#</option>
								</select>
							</cfif>
						</td>

						<td>&nbsp;</td>

						<td>
							<cfif modo EQ "CAMBIO" and rsDeduccionPlan.recordCount>
								<input name="Dvalor" type="text" style="text-align: right; border: none;" <cfif modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount>readonly</cfif>
								value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsForm.Dvalor, '0.00')#<cfelse>0.00</cfif>" size="30" maxlength="14" readonly>
							<cfelse>
								<input name="Dvalor" type="text" style="text-align: right;" onfocus="javascript:this.value=qf(this); this.select();" <cfif modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount>readonly</cfif>
								onblur="javascript: fm(this,4); porcentaje();" onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsForm.Dvalor, '99.9999')#<cfelse>0.00</cfif>" size="30" maxlength="14" >
<!---								onblur="javascript: fm(this,4); porcentaje();" onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.Dvalor, 'none')#<cfelse>0.00</cfif>" size="30" maxlength="14" >--->
							</cfif>
						</td>
					</tr>

					<tr>
						<td class="fileLabel">#LB_Fecha_Inicial#</td>
						<td>&nbsp;</td>
						<td class="fileLabel"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
					</tr>

					<tr>
						<td>
							<cfif modo neq 'ALTA' >
								<cfset fechaini = LSDateFormat(rsForm.Dfechaini,"dd/mm/yyyy") >
							<cfelse>
								<cfset fechaini = "" >
							</cfif>
							<cfif (modo EQ "CAMBIO" and rsDeduccionPlan.recordCount) or (modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount)>
								#fechaini#
								<input type="hidden" name="Dfechaini" value="#fechaini#">
							<cfelse>
								<cf_sifcalendario form="form1" name="Dfechaini" value="#fechaini#">
							</cfif>
						</td>

						<td>&nbsp;</td>

						<td>
							<cfif modo neq 'ALTA' >
								<cfset fechafin = LSDateFormat(rsForm.Dfechafin,"dd/mm/yyyy") >
							<cfelse>
								<cfset fechafin = "" >
							</cfif>
							<cfif (modo EQ "CAMBIO" and rsDeduccionPlan.recordCount) or (modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount)>
								#fechafin#
								<input type="hidden" name="Dfechafin" value="#fechafin#">
							<cfelse>
								<cf_sifcalendario form="form1" name="Dfechafin" value="#fechafin#">
							</cfif>
						</td>
					</tr>

					<tr>
                                            <td class="fileLabel" valign="middle" align="left">

						<cfif modo EQ "CAMBIO" and rsDfondoahorro.recordCount>
							<cfif rsDfondoahorro.DFA eq 1>
								<!---<img src="/cfmx/rh/imagenes/checked.gif">#LB_FondoAhorro#
								<input name="DfondoAhorro" type="hidden" value="1">--->
                                <input name="DfondoAhorro"  type="checkbox" <cfif modo neq 'ALTA'> checked value="1"</cfif> >#LB_FondoAhorro#
							<cfelse>
								<!---<img src="/cfmx/rh/imagenes/unchecked.gif">#LB_FondoAhorro#--->
                                <input name="DfondoAhorro"  type="checkbox" <cfif modo neq 'ALTA'> unchecked value="0"</cfif>>#LB_FondoAhorro#
							</cfif>
						<cfelse>

							<input name="DfondoAhorro" type="checkbox" <cfif modo eq 'ALTA'>unchecked value="0"</cfif>>#LB_FondoAhorro#
						</cfif>

						</td>

						<td>&nbsp;</td>

						<td class="fileLabel" valign="middle" >
						<cfif modo EQ "CAMBIO" and rsDeduccionPlan.recordCount>
							<cfif rsForm.Dcontrolsaldo eq 1>
								<img src="/cfmx/rh/imagenes/checked.gif">#LB_Controla_Saldo#
								<input name="Dcontrolsaldo" type="hidden" value="1">
							<cfelse>
								<img src="/cfmx/rh/imagenes/unchecked.gif">#LB_Controla_Saldo#
							</cfif>
						<cfelse>
							<input name="Dcontrolsaldo" <cfif modo neq 'ALTA' and ( rsCalculo.RecordCount gt 0 or rsHCalculo.RecordCount gt 0 or rsTDeduccionRenta.RecordCount gt 0 or rsDeduccAsoc.REcordCount)>disabled</cfif> type="checkbox" value="1" <cfif modo eq 'ALTA'>checked<cfelseif rsForm.Dcontrolsaldo eq 1 >checked</cfif> onclick="javascript:mostrar_datos(this.checked)" >#LB_Controla_Saldo#
						</cfif>
						</td>
						<!---<td class="fileLabel" valign="middle" >
                        	<input name="Dactivo" type="checkbox" value="A" <cfif (modo neq 'ALTA' and rsTipoDeduccion.TDfinanciada eq 1) or (modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount) >disabled</cfif> <cfif modo eq 'ALTA'>checked<cfelseif rsForm.Dactivo eq 1 >checked</cfif> ><cf_translate key="LB_Activa">Activa</cf_translate>
                        </td>--->
					</tr>
					<tr>
                    <td class="fileLabel" valign="middle" >
                        	<input name="Dactivo" type="checkbox" value="A" <cfif (modo neq 'ALTA' and rsTipoDeduccion.TDfinanciada eq 1) or (modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount) >disabled</cfif> <cfif modo eq 'ALTA'>checked<cfelseif rsForm.Dactivo eq 1 >checked</cfif> ><cf_translate key="LB_Activa">Activa</cf_translate>
                        </td>
                    </tr>
					<tr id="etiquetas1">
						<td class="fileLabel">#LB_Monto#</td>
						<td>&nbsp;</td>
						<td class="fileLabel">#LB_Saldo#</td>
					</tr>

					<tr id="campos1">
						<td>
							<cfif modo EQ "CAMBIO" and rsDeduccionPlan.recordCount and lvarEnHistorico>
								<input name="Dmonto" type="text" style="text-align: right; border: none;"
								value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.Dmonto, 'none')#<cfelse>0.00</cfif>" size="30" maxlength="14" readonly>
							<cfelseif modo neq 'ALTA' and rsDeduccionPlan.recordCount>
								<input name="Dmonto" type="text"  value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.Dmonto, 'none')#<cfelse>0.00</cfif>" <cfif modo NEQ 'ALTA' and rsDeduccAsoc.REcordCount>readonly</cfif>
								size="30" maxlength="14" style="text-align: right;" onblur="javascript: fm(this,2); this.value=qf(this); <cfif modo eq 'ALTA'>saldo(this);</cfif>"
								onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
							<cfelse>
								<input name="Dmonto" type="text"  value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.Dmonto, 'none')#<cfelse>0.00</cfif>" <cfif modo NEQ 'ALTA' and (isdefined('rsDeduccAsoc') and (rsDeduccAsoc.REcordCount or lvarEnHistorico))>disabled</cfif>
								size="30" maxlength="14" style="text-align: right;" onblur="javascript: fm(this,2); <cfif modo eq 'ALTA' or (modo EQ "CAMBIO" and not lvarEnHistorico)>saldo(this);</cfif>"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
							</cfif>
						</td>
						<td>&nbsp;</td>
						<td><input name="Dsaldo" type="text" readonly value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.Dsaldo, 'none')#<cfelse>0.00</cfif>" size="30" maxlength="14" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
					</tr>
                    <tr id="etiq2FondoA"> <!---SML. Modificacion para  prestamos de FOA--->
                    	<td width="33.3%">
                        	#LB_TMontoInteres#
                        </td>
                        <td width="33.3%">

                        </td>
                        <td width="33.3%">

                        </td>
                    </tr>
                    <tr id="campo2FondoA">
	                    <td width="33.3%">
                        <input name="DTmontointeres" type="text" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.DmontoFOA, 'none')#<cfelse>0.00</cfif>" size="30" maxlength="14" style="text-align: right;" onblur="javascript: fm(this,2);">
                        </td>
                        <td width="33.3%">
                        </td>
                        <td width="33.3%">
                        </td>
                    </tr>
                    <tr id="etiqFondoA">
                    	<td width="33.3%">
                        	#LB_Interes#
                        </td>
                        <td width="33.3%">

                        </td>
                        <td width="33.3%">
                         	#LB_MontoInteres#
                        </td>
                    </tr>
                    <tr id="campoFondoA">
	                    <td width="33.3%">
                        	<input name="Dinteres" type="text" style="text-align: right;" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.DinteresFOA, 'none')#<cfelse>0.00</cfif>" size="5" maxlength="10" onblur="javascript: fm(this,2); montofoa(this);">
                        </td>
                        <td width="33.3%">
                        </td>
                        <td width="33.3%">
                        	<cfif isdefined('rsForm.DmontoFOA') and rsForm.DmontoFOA GT 0>
                            <input name="Dminteres" id="Dminteres" type="text" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.Dmonto - rsForm.DmontoFOA, 'none')#<cfelse>0.00</cfif>" size="30" maxlength="14" style="text-align: right;" disabled="disabled" onblur="javascript: fm(this,2);">
                            <cfelse>
                            <input name="Dminteres" id="Dminteres" type="text" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.DmontoFOA,'none')#<cfelse>0.00</cfif>" size="30" maxlength="14" style="text-align: right;" disabled="disabled" onblur="javascript: fm(this,2);">
                            </cfif>
                        </td>
                    </tr> <!---SML. Final Modificacion para  prestamos de FOA--->
					<cfif isdefined('rsForm') and rsForm.Dcontrolsaldo and lvarEnHistorico>
					<tr>
						<td colspan="3">
							<span style="color:##FF0000">* La deducci&oacute;n ha sido aplicada en un proceso de c&aacute;lculo de n&oacute;mina por lo cual se encuentra en hist&oacute;ricos y para no afectar el hist&oacute;rico el monto no puede ser modificado.</span>
						</td>
					</tr>
					</cfif>

					<cfif modo neq 'ALTA' and rsDeduccionPlan.recordCount>
					<tr>
						<td colspan="4" style="font-variant:small-caps; font-size:12px"><font color="##FF0000"><strong><cf_translate key="Esta_deduccion_tiene_un_plan_de_pago_asociada">Esta deducci&oacute;n tiene un plan de pago asociada</cf_translate></strong></font></td>
					</tr>
					</cfif>

					<tr>
						<td colspan="4" align="center">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td colspan="5" align="center">
			<!--- <cfinclude template="/rh/portlets/pBotones.cfm"> --->
			<cfset Lvar_exclude = ''>
			<cfif modo neq 'ALTA' and rsDeduccAsoc.REcordCount><cfset Lvar_exclude = 'Cambio,Baja'></cfif>
			<cf_botones modo="#modo#" exclude="#Lvar_exclude#">
			</td>
		</tr>

		<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">
		<input type="hidden" name="Did" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Did#</cfoutput></cfif>">
		<input type="hidden" name="Dtasa"    value="0.00" >
		<input type="hidden" name="Dmontoint"  value="0.00" >
		<cfif isdefined("RCNid")>
			<input type="hidden" name="RCNid"  value="#RCNid#" >
		</cfif>
		<cfif isdefined("Tcodigo")>
			<input type="hidden" name="Tcodigo"  value="#Tcodigo#" >
		</cfif>

		<iframe name="SocioNegociox" id="SocioNegociox" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
		</cfoutput>
	</table><!--- deducciones--->
</form>

<script language="JavaScript1.2" type="text/javascript">
//------------------------------------------------------------------------------------------
	<cfif modo neq 'ALTA' and rsDeduccionPlan.recordCount>
		<cfif rsForm.Dcontrolsaldo EQ 1>
			mostrar_datos(true);
		<cfelse>
			mostrar_datos(false);
		</cfif>
	<cfelseif modo neq 'ALTA'>
		mostrar_datos(document.form1.Dcontrolsaldo.checked);
	</cfif>
//------------------------------------------------------------------------------------------
	var BanderaDed = "P";
	function buscarDed(){}
//------------------------------------------------------------------------------------------
	function limpiaFiltradoDed(){
		document.formFiltroListaDed.filtradoDed.value = "";
	}
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//------------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = this.description + ' ' + <cfoutput>"#LB_FechaValida#"</cfoutput>;
	}

	function fechaBlur(obj)
	{

	}
	_addValidator("isFecha", _Field_isFecha);

	function _Field_isValor(){
		var valor = new Number(qf(objForm.Dvalor.obj.value))
		var monto = new Number(qf(objForm.Dmonto.obj.value))

		if ( (objForm.Dmetodo.obj.value == 1) && ( objForm.Dcontrolsaldo.obj.checked ) && ( valor > monto ) ){
			this.error = <cfoutput>"#LB_ValorMayorMonto#"</cfoutput>;
		}
	}
	_addValidator("isValor", _Field_isValor);
	<cfoutput>
	objForm.TDdescripcion.required = true;
	objForm.TDdescripcion.description = "#LB_Tipo_de_Deduccion#";

	<!---
	objForm.Ddescripcion.required = true;
	objForm.Ddescripcion.description = "#LB_Descripcion#";
	--->

	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description = "#LB_Socio_de_Negocio#";

	objForm.Dvalor.required = true;
	objForm.Dvalor.description = "#LB_Valor#";
	objForm.Dvalor.validateValor();

	objForm.Dfechaini.required = true;
	objForm.Dfechaini.description = "#LB_Fecha_Inicial#";

	/*objForm.Dfechafin.required = true;
	objForm.Dfechafin.description = "Fecha Final";	*/

	objForm.Dmonto.required = true;
	objForm.Dmonto.description = "#LB_Monto#";

	objForm.Dtasa.required = true;
	objForm.Dtasa.description = "#LB_Tasa#";

	objForm.Dsaldo.required = true;
	objForm.Dsaldo.description = "#LB_Saldo#";

	objForm.Dmontoint.required = true;
	objForm.Dmontoint.description = "#LB_Monto_de_Interes#";
	</cfoutput>
	objForm.Dfechaini.validateFecha();
	objForm.Dfechafin.validateFecha();

	buscarDed();

	//------------------------------------------------------------------------------------------
	function CargaSN(){
		<!---<cfif trim(rsCargarCF.Pvalor) eq 1>--->
			var TDid=document.form1.TDid.value;

			//var DEid = document.form1.DEid.value;
			document.getElementById('SocioNegociox').src = 'CargaSocioNegocio.cfm?TDid='+TDid;
		<!---</cfif>	--->
	}
//------------------------------------------------------------------------------------------
</script>
