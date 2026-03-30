 <cfif not isdefined("form.tab") and isdefined("url.tab") and not isdefined("form.tab")>
	 <cfset form.tab = url.tab >
  </cfif>
 <cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
	 <cfset form.tab = 1 >
  </cfif>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="BTN_Modificar" default="Modificar" xmlfile="/rh/generales.xml" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Retenciones" default="Retenciones" returnvariable="BTN_Retenciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Eliminar" default="Eliminar" xmlfile="/rh/generales.xml" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Nuevo" default="Nuevo" xmlfile="/rh/generales.xml" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Agregar" default="Agregar" xmlfile="/rh/generales.xml" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_formular" default="Formular" returnvariable="BTN_formular" component="sif.Componentes.Translate" method="Translate"/>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_ContieneUnValorQueYaExisteDebeDigitarUnoDiferente" default="contiene un valor que ya existe, debe digitar uno diferente." returnvariable="MSG_ContieneUnValorQueYaExisteDebeDigitarUnoDiferente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_CodigoDeTipoDeIncidencia" default="Código de Tipo de Incidencia" returnvariable="MSG_CodigoDeTipoDeIncidencia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DescripcionDeIncidencia" default="Descripción de Incidencia" returnvariable="MSG_DescripcionDeIncidencia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Factor" default="Factor" returnvariable="MSG_Factor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_RangoMinimo" default="Rango Mínimo" returnvariable="MSG_RangoMinimo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_RangoMaximo" default="Rango Máximo" returnvariable="MSG_RangoMaximo" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="MSG_Dias" default="Días" returnvariable="MSG_Dias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipoAjuste" default="Tipo de Ajuste" returnvariable="MSG_TipoAjuste" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ConceptoSAT" default="Concepto SAT" returnvariable="MSG_ConceptoSAT" component="sif.Componentes.Translate" method="Translate"/>


<!--- FIN VARIABLES DE TRADUCCION --->
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

<cfif isdefined('url.CIid') and url.CIid GT 0 and not isdefined('form.CIid')>
	<cfset form.CIid = url.CIid>
	<cfset modo = "CAMBIO">
<cfelseif isdefined('form.CIid') and LEN(TRIM(form.CIid))>
	<cfset modo = "CAMBIO">
</cfif>

<!--- CONSULTAS --->
<cfquery name="rsCodigos" datasource="#Session.DSN#">
	SELECT CIcodigo
	FROM CIncidentes
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CIcarreracp = 0
</cfquery>

<!---ljimenez leemos el parametro usa SBC para mostrar o no en panatalla campos relacionados con el SBC--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2025" default="" returnvariable="UsaSBC"/>


<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfset deshabilitar = false >
<cfif modo neq 'ALTA' >
	<cfquery name="rs" datasource="#Session.DSN#">
		select CIid, Ecodigo, CIcodigo, CIdescripcion, CIfactor, CItipo, CInegativo, CIcantmin, CIcantmax,
		       CInorealizado, CInorenta, CInocargas, CInoanticipo, CIfondoahorro, CInodeducciones, CIvacaciones, CIcuentac, CIredondeo,
			   CIafectasalprom, CInocargasley, CIafectacomision, CItipoexencion, CIexencion, ts_rversion, coalesce(CSid, 0) as CSid,
			   Ccuenta, Cformato,CISumarizarLiq,CIMostrarLiq,CInopryrenta, CIclave, CIcodigoext, CInomostrar,
			   coalesce(CIafectacostoHE,0) as CIafectacostoHE,
               coalesce(CImodFechaReg,0) as CImodFechaReg,
               coalesce(CImodNominaSP,0) as CImodNominaSP,
               CItipoAjuste,
               CIdiasAjuste,CIafectaSBC,  CIlimitaconcepto, CItipolimite, CItipometodo, CImontolimite, CIidexceso, CIafectaISN,
			   CIautogestion,
			   CIespecie,RHCSATid,CIexencionSDI,CItimbrar,CIExcluyePagoLiquido
		from CIncidentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
	</cfquery>

	<cfquery name="ligados" datasource="#session.DSN#">
		select CSid
		from ComponentesSalariales
		where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.CSid#">
		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>

	<cfif isdefined("rs.Ccuenta") and len(trim(rs.Ccuenta))>
		<cfquery name="rsCuenta" datasource="#session.DSN#">
			select a.Ccuenta, b.CFcuenta, a.Cformato
			from CContables a
				inner join CFinanciera b
					on a.Ccuenta = b.Ccuenta
					and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Ccuenta#">
		</cfquery>
	</cfif>

	<cfif ligados.recordcount gt 0 >
		<cfset deshabilitar = true >
	</cfif>
</cfif>
<cfquery name="rsVerificaParametro1000" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Pcodigo = 1000
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- VERIFICA PARAMETRO PARA MOSTRAR CLAVE Y CODIGO UTILIZADO EN PROCESO DE INTERFAZ CON SAP (OE) --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2010" default="" returnvariable="InterfazCatalogos"/>

<!--- FIN CONSULTAS --->
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function validaForm(f) {
		f.obj.CIfactor.value = qf(f.obj.CIfactor.value);
		f.obj.CIcantmin.value = qf(f.obj.CIcantmin.value);
		f.obj.CIcantmax.value = qf(f.obj.CIcantmax.value);
		f.obj.CIexencion1.value = qf(f.obj.CIexencion1.value);
		f.obj.CIexencion2.value = qf(f.obj.CIexencion2.value);

		f.obj.CItipo.disabled = false;
		f.obj.CInegativo.disabled = false;
		return true;
	}

	function chgExencion(tipoexencion) {
		var trex = document.getElementById("trexencion");
		var a = document.getElementById("exencion1");
		var b = document.getElementById("exencion2");
		switch(tipoexencion) {
			case '0': trex.style.display = 'none';
					  a.style.display = 'none';
					  b.style.display = 'none';
					  break;

			case '1': trex.style.display = '';
					  a.style.display = '';
					  b.style.display = 'none';
					  break;

			case '2': trex.style.display = '';
					  a.style.display = 'none';
					  b.style.display = '';
					  break;
		}
	}

	function checkNorealizado(obj, form) {
		// checks excluyentes
		if (obj.checked ) {
			form.CIredondeo.checked = false;
		}
	}

	function checkRedondeo(obj, form) {
		// checks excluyentes
		if (obj.checked ) {
			form.CInorealizado.checked = false;
		}
	}

	function checkMe(button, form) {

	if (button==true){
		if (form.CInorealizado.checked){
			form.CIredondeo.checked=false;
		}
		if (form.CIredondeo.checked){
			form.CInorealizado.checked=false;
		}
		if (form.CInorealizado.checked || form.CIredondeo.checked ) {
		form.CInorenta.checked = true;
		form.CInocargas.checked = true;
		form.CInodeducciones.checked = true;

		form.CInorenta.disabled = true;
		form.CInocargas.disabled = true;
		form.CInodeducciones.disabled = true;
		}

	}
	if (button==false){
		form.CInorenta.checked = false;
		form.CInocargas.checked = false;
		form.CInodeducciones.checked = false;

		form.CInorenta.disabled = false;
		form.CInocargas.disabled = false;
		form.CInodeducciones.disabled = false;

		}

		/*if (button.alt==0) {

			if (form.CInorealizado.checked || form.CIredondeo.checked ) {
				form.CInorenta.checked = true;
				form.CInocargas.checked = true;
				form.CInodeducciones.checked = true;
			}
		}
		else{
			form.CInorealizado.checked = false;
			form.CIredondeo.checked = false;
		}*/
	}

	function limpiaLimites(){

			var objDA = document.getElementById('comboInci1');
			var objDA2 = document.getElementById('comboInci2');
			var objDA3 = document.getElementById('comboInci3');
			var objDA4 = document.getElementById('comboInci4');
			var objDA5 = document.getElementById('comboInci5');

			document.form1.CIperiodo[0].disabled = true;
			document.form1.CIperiodo[1].disabled = true;
			objForm.CIperiodo.required = false;

			document.form1.CIimporte[0].disabled = true;
			document.form1.CIimporte[1].disabled = true;
			document.form1.CIimporte[2].disabled = true;
			document.form1.CIimporte[3].disabled = true;
			document.form1.CIimporte[4].disabled = true;

			document.form1.monto1.disabled = true;
			document.form1.monto2.disabled = true;
			document.form1.monto3.disabled = true;
			document.form1.DCvsmg.disabled = true;
			document.form1.FormularLimite.disabled = true;

			objForm.monto1.required = false;
			objForm.monto2.required = false;
			objForm.monto3.required = false;

			objForm.CIid1.required = false;
			objForm.CIid2.required = false;
			objForm.CIid3.required = false;
			objForm.CIid4.required = false;
			objForm.CIid5.required = false;

			//Desaparezco los comolist
			objDA.style.display = 'none';
			objDA2.style.display='none';
			objDA3.style.display='none';
			objDA4.style.display='none';
			objDA5.style.display='none';

			//limpio cualquier codigo seteado
			document.form1.CIid1.value="";
			document.form1.CIid2.value="";
			document.form1.CIid3.value="";
			document.form1.CIid4.value="";
			document.form1.CIid5.value="";
	}


	function activarPagosNoProcesados(obj) {

		 var objDA = document.getElementById('comboInci1');
		 var objDA2 = document.getElementById('comboInci2');
		 var objDA3 = document.getElementById('comboInci3');
		 var objDA4 = document.getElementById('comboInci4');
		 var objDA5 = document.getElementById('comboInci5');

		 devuelveMetodo();
		 //Si el check de Limites de concepto no esta seleccionado




		 if (document.form1.CIlimitesConcepto.checked==false ){
				document.form1.CIperiodo[0].disabled = true;
				document.form1.CIperiodo[1].disabled = true;
				objForm.CIperiodo.required = false;

				document.form1.CIimporte[0].disabled = true;
				document.form1.CIimporte[0].checked = false;
				document.form1.CIimporte[1].disabled = true;
				document.form1.CIimporte[2].disabled = true;
				document.form1.CIimporte[3].disabled = true;
				document.form1.CIimporte[4].disabled = true;


				document.form1.monto1.value="";
				document.form1.monto2.value="";
				document.form1.monto3.value="";
				document.form1.DCvsmg.options[0].selected=true;

				document.form1.monto1.disabled = true;
				document.form1.monto2.disabled = true;
				document.form1.monto3.disabled = true;
				document.form1.DCvsmg.disabled = true;
				document.form1.FormularLimite.disabled = true;

				objDA.style.display = 'none';
				objDA2.style.display='none';
				objDA3.style.display='none';
				objDA4.style.display='none';
				objDA5.style.display='none';

				objForm.CIid1.required = false;
				objForm.CIid2.required = false;
				objForm.CIid3.required = false;
				objForm.CIid4.required = false;
				objForm.CIid5.required = false;

				objForm.monto1.required = false;
				objForm.monto2.required = false;
				objForm.monto3.required = false;

				document.form1.CIcodigo1.value="";
				document.form1.CIdescripcion1.value="";
				document.form1.CIid1.value="";
				document.form1.CIcodigo2.value="";
				document.form1.CIdescripcion2.value="";
				document.form1.CIid2.value="";
				document.form1.CIcodigo3.value="";
				document.form1.CIdescripcion3.value="";
				document.form1.CIid3.value="";
				document.form1.CIcodigo4.value="";
				document.form1.CIdescripcion4.value="";
				document.form1.CIid4.value="";
				document.form1.CIdescripcion5.value="";
				document.form1.CIid5.value="";
		 }

		//Activa desactiva CheckBox de Pagos No Procesados
		//Si se defina Limites se validan de acuerdo a el metodo el limite que se va a habilitar
		<!---se selecciono Horas--->


		if (obj.value==0) {
			//SE SELLECCIONO LIMITES DE MONTOS
		 if (document.form1.CIlimitesConcepto.checked==true ){
			<cfif modo EQ "ALTA">
				if (document.form1.CIimporte[0].checked == true	)
				{
					pintaHoras2();
				} else if (document.form1.CIimporte[3].checked == true	)
						{
							document.form1.CIcodigo4.value="";
							document.form1.CIdescripcion4.value="";
							document.form1.CIid4.value="";
							pintarVecesSalario2();
							document.form1.CIimporte[0].disabled = false;
						} else {
							pintaHoras2();
						}
			//SINO ESTA EN MODO CAMBIO
			<cfelse>
					<cfif rs.CItipometodo EQ 0 or rs.CItipometodo EQ 4 or rs.CItipometodo EQ 5>
						//Esta limitado por horas, pregunta si esta seleccionado
						if (document.form1.CIimporte[0].checked == true	)
						{
								pintaHoras2();
								document.form1.CIimporte[3].disabled = false;
								document.form1.CIimporte[4].disabled = false;
						} else if (document.form1.CIimporte[4].checked == true	)
						{	//Esta limitado por horas pero se selecciono calculo
							pintarFormularLimite2()
							document.form1.CIimporte[0].disabled = false;
							document.form1.CIimporte[3].disabled = false;
						} else { //Esta limitado por horas pero se Veces salario minimo
							pintarVecesSalario2();
							document.form1.CIimporte[0].disabled = false;
							document.form1.CIimporte[4].disabled = false;
						}
					</cfif>
			</cfif>

		  }<!---Fin de la seleccion del concepto de pago--->
		}<!---Fin de la seleccion de  Horas--->


		<!---alert(obj.value)--->

		<!---se selecciono Días--->
		if (obj.value==1) {
			// Se selecciono limites de monto
			if (document.form1.CIlimitesConcepto.checked==true ){

				<cfif modo EQ "ALTA">
					if (document.form1.CIimporte[1].checked == true	)
					{
						 pintaDias2();
					} else if (document.form1.CIimporte[3].checked == true	)
							{
								document.form1.CIcodigo4.value="";
								document.form1.CIdescripcion4.value="";
								document.form1.CIid4.value="";
								pintarVecesSalario2();
								document.form1.CIimporte[1].disabled = false;
							} else{
								 pintaDias2();
							}
				//Sino esta en modo cambio
				<cfelse>
					<cfif rs.CItipometodo EQ 1 or rs.CItipometodo EQ 4 or rs.CItipometodo EQ 5>
						//Esta limitado por dias, pregunta si esta seleccionado
						if (document.form1.CIimporte[1].checked == true	)
						{
								pintaDias2();
								document.form1.CIimporte[3].disabled = false;
								document.form1.CIimporte[4].disabled = false;
						} else if (document.form1.CIimporte[4].checked == true	)
						{	//Esta limitado por dias pero se selecciono calculo
							pintarFormularLimite2()
							document.form1.CIimporte[1].disabled = false;
							document.form1.CIimporte[3].disabled = false;
						} else { //Esta limitado por dias pero se Veces salario minimo
							pintarVecesSalario2();
							document.form1.CIimporte[1].disabled = false;
							document.form1.CIimporte[4].disabled = false;
						}
					</cfif>
				</cfif>
			}
		} <!---Fin de la seleccion de dias--->

		<!---se selecciono Importe--->
		if (obj.value==2) {
			objForm.CInorealizado.obj.disabled = false;
			objForm.CIredondeo.obj.disabled = false;
			<cfif isdefined("rsVerificaParametro1000") and rsVerificaParametro1000.RecordCount NEQ 0 and rsVerificaParametro1000.Pvalor EQ 1>
				document.getElementById('LBL_CIafectacostoHE').style.display = '';
			</cfif>
			 //Se selecciono limites de monto
			if (document.form1.CIlimitesConcepto.checked==true ){

				<cfif modo EQ "ALTA">
					if (document.form1.CIimporte[2].checked == true	)
					{
						pintarImporte2();
					} else if (document.form1.CIimporte[3].checked == true	)
							{
								document.form1.CIcodigo4.value="";
								document.form1.CIdescripcion4.value="";
								document.form1.CIid4.value="";
								pintarVecesSalario2();
								document.form1.CIimporte[2].disabled = false;
							} else {
								pintarImporte2();
							}
				//SINO ESTA EN MODO CAMBIO
				<cfelse>
						<cfif rs.CItipometodo EQ 2 or rs.CItipometodo EQ 5 or rs.CItipometodo EQ 4 >
							//Esta limitado por dias, pregunta si esta seleccionado
							if (document.form1.CIimporte[2].checked == true	)
							{
									pintarImporte2();
									document.form1.CIimporte[3].disabled = false;
									document.form1.CIimporte[4].disabled = false;
							} else if (document.form1.CIimporte[4].checked == true	)
							{	//Esta limitado por dias pero se selecciono calculo
								pintarFormularLimite2()
								document.form1.CIimporte[2].disabled = false;
								document.form1.CIimporte[3].disabled = false;
							} else { //Esta limitado por dias pero se Veces salario minimo
								pintarVecesSalario2();
								document.form1.CIimporte[2].disabled = false;
								document.form1.CIimporte[4].disabled = false;
							}

						</cfif>
				</cfif>

		   }
		}<!---fin se selecciono Importe--->


		if (obj.value==3) {
			 //Se selecciono limites de monto
			if (document.form1.CIlimitesConcepto.checked==true ){

				<cfif modo EQ "ALTA">
					if (document.form1.CIimporte[3].checked == true	)
					{
						pintarFormularLimite2();
					} else if (document.form1.CIimporte[4].checked == true	)
							{
								document.form1.CIcodigo4.value="";
								document.form1.CIdescripcion4.value="";
								document.form1.CIid4.value="";
								pintarVecesSalario2();
								document.form1.CIimporte[4].disabled = false;
							} else {
								pintarVecesSalario2();
							}
				//SINO ESTA EN MODO CAMBIO
				<cfelse>
						<cfif rs.CItipometodo EQ 4 or rs.CItipometodo EQ 5 >

							//Esta limitado por dias, pregunta si esta seleccionado
							if (document.form1.CIimporte[3].checked == true	)
							{
									pintarVecesSalario2();
									document.form1.CIimporte[4].disabled = false;
							} else if (document.form1.CIimporte[4].checked == true	)
							{	//Esta limitado por calculo pero se selecciono formular
								pintarFormularLimite2()
								document.form1.CIimporte[3].disabled = false;
							}


						</cfif>
				</cfif>

		   }
		}<!---fin se selecciono Importe--->

	}
	//-->



	<!---	Pintar las horas--->
	function pintaHoras2(){

		var objDA = document.getElementById('comboInci1');
		var objDA2 = document.getElementById('comboInci2');
		var objDA3 = document.getElementById('comboInci3');
		var objDA4 = document.getElementById('comboInci4');
		var objDA5 = document.getElementById('comboInci5');

		document.form1.CIimporte[0].disabled = false;
		document.form1.CIimporte[0].checked = true;
		document.form1.CIimporte[1].disabled = true;
		document.form1.CIimporte[2].disabled = true;
		document.form1.CIimporte[3].disabled = false;
		document.form1.CIimporte[4].disabled = false;

		document.form1.monto2.value="";
		document.form1.monto3.value="";
		document.form1.monto1.disabled = false;
		document.form1.monto2.disabled = true;
		document.form1.monto3.disabled = true;
		document.form1.DCvsmg.disabled = true;
		document.form1.FormularLimite.disabled = true;


		objDA.style.display = '';
		objDA2.style.display='none';
		objDA3.style.display='none';
		objDA4.style.display='none';
		objDA5.style.display='none';

		objForm.CIid1.required = true;
		objForm.CIid1.description = "Concepto";
		objForm.CIid2.required = false;
		objForm.CIid3.required = false;
		objForm.CIid4.required = false;
		objForm.CIid5.required = false;

		objForm.monto1.required = true;
		objForm.monto1.description = "Cantidad";
		objForm.monto2.required = false;
		objForm.monto3.required = false;


		document.form1.CIcodigo2.value="";
		document.form1.CIdescripcion2.value="";
		document.form1.CIid2.value="";
		document.form1.CIcodigo3.value="";
		document.form1.CIdescripcion3.value="";
		document.form1.CIid3.value="";
		document.form1.CIcodigo4.value="";
		document.form1.CIdescripcion4.value="";
		document.form1.CIid4.value="";
		document.form1.CIdescripcion5.value="";
		document.form1.CIid5.value="";
		document.form1.DCvsmg.options[0].selected=true;

	}

<!---	Pintar los dias en limitado por--->
	function pintaDias2() {

		 var objDA = document.getElementById('comboInci1');
		 var objDA2 = document.getElementById('comboInci2');
		 var objDA3 = document.getElementById('comboInci3');
		 var objDA4 = document.getElementById('comboInci4');
		 var objDA5 = document.getElementById('comboInci5');

		document.form1.CIimporte[0].disabled = true;
		document.form1.CIimporte[1].disabled = false;
		document.form1.CIimporte[1].checked = true;
		document.form1.CIimporte[2].disabled = true;
		document.form1.CIimporte[3].disabled = false;
		document.form1.CIimporte[4].disabled = false;

		document.form1.monto1.value="";
		document.form1.monto3.value="";

		document.form1.monto1.disabled = true;
		document.form1.monto2.disabled = false;
		document.form1.monto3.disabled = true;
		document.form1.DCvsmg.disabled = true;
		document.form1.FormularLimite.disabled = true;


		objDA.style.display = 'none';
		objDA2.style.display='';
		objDA3.style.display='none';
		objDA4.style.display='none';
		objDA5.style.display='none';

		//Habilitar los campos de Requerido
		objForm.CIid1.required = false;
		objForm.CIid2.required = true;
		objForm.CIid2.description = "Concepto";
		objForm.CIid3.required = false;
		objForm.CIid4.required = false;
		objForm.CIid5.required = false;

		objForm.monto1.required = false;
		objForm.monto2.required = true;
		objForm.monto2.description = "Cantidad";
		objForm.monto3.required = false;

		document.form1.CIcodigo1.value="";
		document.form1.CIdescripcion1.value="";
		document.form1.CIid1.value="";
		document.form1.CIcodigo3.value="";
		document.form1.CIdescripcion3.value="";
		document.form1.CIid3.value="";
		document.form1.CIcodigo4.value="";
		document.form1.CIdescripcion4.value="";
		document.form1.CIid4.value="";
		document.form1.CIdescripcion5.value="";
		document.form1.CIid5.value="";
		document.form1.DCvsmg.options[0].selected=true;
	}

	<!---pintar el importe--->
	function pintarImporte2(){
		var objDA = document.getElementById('comboInci1');
		 var objDA2 = document.getElementById('comboInci2');
		 var objDA3 = document.getElementById('comboInci3');
		 var objDA4 = document.getElementById('comboInci4');
		 var objDA5 = document.getElementById('comboInci5');

		document.form1.CIimporte[0].disabled = true;
		document.form1.CIimporte[1].disabled = true;
		document.form1.CIimporte[2].disabled = false;
		document.form1.CIimporte[2].checked = true;
		document.form1.CIimporte[3].disabled = false;
		document.form1.CIimporte[4].disabled = false;


		document.form1.monto1.value="";
		document.form1.monto2.value="";
		document.form1.monto1.disabled = true;
		document.form1.monto2.disabled = true;
		document.form1.monto3.disabled = false;
		document.form1.DCvsmg.disabled = true;
		document.form1.FormularLimite.disabled = true;

		objDA.style.display = 'none';
		objDA2.style.display='none';
		objDA3.style.display='';
		objDA4.style.display='none';
		objDA5.style.display='none';

		objForm.CIid1.required = false;
		objForm.CIid2.required = false;
		objForm.CIid3.required = true;
		objForm.CIid3.description = "Concepto";
		objForm.CIid4.required = false;
		objForm.CIid5.required = false;

		objForm.monto1.required = false;
		objForm.monto2.required = false;
		objForm.monto3.required = true;
		objForm.monto3.description = "Cantidad";

		document.form1.CIcodigo1.value="";
		document.form1.CIdescripcion1.value="";
		document.form1.CIid1.value="";
		document.form1.CIcodigo2.value="";
		document.form1.CIdescripcion2.value="";
		document.form1.CIid2.value="";
		document.form1.CIcodigo4.value="";
		document.form1.CIdescripcion4.value="";
		document.form1.CIid4.value="";
		document.form1.CIdescripcion5.value="";
		document.form1.CIid5.value="";
		document.form1.DCvsmg.options[0].selected=true;
    }

<!---	Pintar las veces de Salario minimo--->
	function pintarFormularLimite2(){
		var objDA = document.getElementById('comboInci1');
		var objDA2 = document.getElementById('comboInci2');
		var objDA3 = document.getElementById('comboInci3');
		var objDA4 = document.getElementById('comboInci4');
		var objDA5 = document.getElementById('comboInci5');

		document.form1.monto1.value="";
		document.form1.monto2.value="";
		document.form1.monto3.value="";

		if (document.form1.CItipo.value == 0){
			document.form1.CIimporte[0].disabled = false;
		}
		else {
			document.form1.CIimporte[0].disabled = true;
		}
		document.form1.CIimporte[1].disabled = true;
		document.form1.CIimporte[2].disabled = true;
		document.form1.CIimporte[3].disabled = false;
		document.form1.CIimporte[4].disabled = false;
		document.form1.CIimporte[4].checked = true;


		document.form1.monto1.disabled = true;
		document.form1.monto2.disabled = true;
		document.form1.monto3.disabled = true;
		document.form1.DCvsmg.disabled = true;
		document.form1.FormularLimite.disabled = false;


		objDA.style.display = 'none';
		objDA2.style.display='none';
		objDA3.style.display='none';
		objDA4.style.display='none';
		objDA5.style.display='';


		objForm.CIid1.required = false;
		objForm.CIid2.required = false;
		objForm.CIid3.required = false;
		objForm.CIid4.required = false;
		objForm.CIid5.required = true;
		objForm.CIid5.description = "Concepto";

		objForm.monto1.required = false;
		objForm.monto2.required = false;
		objForm.monto3.required = false;

		document.form1.CIcodigo1.value="";
		document.form1.CIdescripcion1.value="";
		document.form1.CIid1.value="";
		document.form1.CIcodigo2.value="";
		document.form1.CIdescripcion2.value="";
		document.form1.CIid2.value="";
		document.form1.CIcodigo3.value="";
		document.form1.CIdescripcion3.value="";
		document.form1.CIid3.value="";
		document.form1.CIdescripcion4.value="";
		document.form1.CIid4.value="";
	}



<!---	Pintar las veces de Salario minimo--->
	function pintarVecesSalario2(){

		var objDA = document.getElementById('comboInci1');
		var objDA2 = document.getElementById('comboInci2');
		var objDA3 = document.getElementById('comboInci3');
		var objDA4 = document.getElementById('comboInci4');
		var objDA5 = document.getElementById('comboInci5');

		document.form1.monto1.value="";
		document.form1.monto2.value="";
		document.form1.monto3.value="";

		document.form1.CIimporte[0].disabled = true;
		document.form1.CIimporte[1].disabled = true;
		document.form1.CIimporte[2].disabled = true;
		document.form1.CIimporte[3].disabled = false;
		document.form1.CIimporte[3].checked = true;
		document.form1.CIimporte[4].disabled = false;


		document.form1.monto1.disabled = true;
		document.form1.monto2.disabled = true;
		document.form1.monto3.disabled = true;
		document.form1.DCvsmg.disabled = false;
		document.form1.FormularLimite.disabled = true;

		objDA.style.display = 'none';
		objDA2.style.display='none';
		objDA3.style.display='none';
		objDA4.style.display='';
		objDA5.style.display='none';

		objForm.CIid1.required = false;
		objForm.CIid2.required = false;
		objForm.CIid3.required = false;
		objForm.CIid4.required = true;
		objForm.CIid4.description = "Concepto";
		objForm.CIid5.required = false;

		objForm.monto1.required = false;
		objForm.monto2.required = false;
		objForm.monto3.required = false;

		document.form1.CIcodigo1.value="";
		document.form1.CIdescripcion1.value="";
		document.form1.CIid1.value="";
		document.form1.CIcodigo2.value="";
		document.form1.CIdescripcion2.value="";
		document.form1.CIid2.value="";
		document.form1.CIcodigo3.value="";
		document.form1.CIdescripcion3.value="";
		document.form1.CIid3.value="";
		document.form1.CIdescripcion5.value="";
		document.form1.CIid5.value="";

	}


	function deshabilitarValidacion(){
		objForm.CIcodigo.required = false;
		objForm.CIcodigo.validate = false;
		objForm.CIdescripcion.required = false;
		objForm.CItipoAjuste.required = false;
		objForm.CIdiasAjuste.required = false;

		objForm.CIperiodo.required = false;


		objForm.monto1.required = false;
		objForm.monto2.required = false;
		objForm.monto3.required = false;

		objForm.CIid1.required = false;
		objForm.CIid2.required = false;
		objForm.CIid3.required = false;
		objForm.CIid4.required = false;


	}

	function fm_2(campo,ndec){
		var s = "";
		if (campo.name){
			s=campo.value
		}
		else{
			s=campo
		}

		if( s=='' && ndec>0 ){
			s='0'
		}

	   var nc=""
	   var s1=""
	   var s2=""

		if (s != '') {
			str = new String("")
			str_temp = new String(s)
			t1 = str_temp.length
			cero_izq = false

			if (t1 > 0) {
				for(i=0;i<t1;i++) {
					c = str_temp.charAt(i)
					str += c
				}
			}

			t1 = str.length
			p1 = str.indexOf(".")
			p2 = str.lastIndexOf(".")

			if ((p1 == p2) && t1 > 0){

				if (p1>0){
					str+="00000000"
				}
				else{
					str+=".0000000"
				}

				p1 = str.indexOf(".")
				s1 = str.substring(0,p1)
				s2 = str.substring(p1+1,p1+1+ndec)
				t1 = s1.length
				n = 0

				for(i=t1-1;i>=0;i--) {
					c=s1.charAt(i)
					if (c == ".") { flag=0;nc="."+nc;n=0 }

					if (c>="0" && c<="9") {
					if (n < 2) {
					   nc = c+nc;
					   n++;
					}
					else {
						n=0
						nc=c+nc
						if (i > 0){
							nc = nc
						 }
					}
				}
			}
			if (nc != "" && ndec > 0)
				nc+="."+s2
			}
			else {ok=1}
		}

		if(campo.name) {
			if(ndec>0) {
				campo.value=nc
			}
			else {
				campo.value=qf(nc)
			}
		}
		else {
			return nc
		}
	}

	function snumber_2(obj,e,d){
		str= new String("")
		str= obj.value
		var tam=obj.size
		var t=Key(e)
		var ok=false

		if(tam>d) {tam=tam-d}
		if(tam>1) {tam=tam-1}

		if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;

		// acepta guiones
		//if(t==109 || t==189)  return true;

		if(t>=16 && t<=20) return false;
		if(t>=33 && t<=40) return false;
		if(t>=112 && t<=123) return false;
		if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
		if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)

		if(t>=48 && t<=57)  ok=true
		if(t>=96 && t<=105) ok=true
		//if(d>=0) {if(t==188) ok=true} //LA COMA

		if(d>0)
		{
		if(t==110) ok=true
		if(t==190) ok=true
		}

		if(!ok){
			str=fm_2(str,d)
			obj.value=str
		}

		return true
	}

</script>

<cfoutput>
<form name="form1" method="post" action="TiposIncidencia-sql.cfm" onsubmit="javascript: return validaForm(this);">
 		<input type="hidden" name="CItipoAux" value="0" >
        <input type="hidden" name="metodoaux" value="">
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td align="left" class="fileLabel" width="30%">#LB_CODIGO#:</td>
			<td colspan="5"> <input name="CIcodigo" type="text" id="CIcodigo" size="5" maxlength="5" <cfif deshabilitar >readonly="readonly"</cfif>  value="<cfif modo NEQ "ALTA">#rs.CIcodigo#</cfif>" onfocus="this.select();"></td>
		</tr>
		<tr>
			<td align="left" class="fileLabel">#LB_DESCRIPCION#:</td>
			<td colspan="5"> <input name="CIdescripcion" type="text" id="CIdescripcion" size="50" maxlength="80"  <cfif deshabilitar >readonly="readonly"</cfif> value="<cfif modo NEQ "ALTA">#rs.CIdescripcion#</cfif>" onfocus="this.select();"></td>
		</tr>
		<tr>
           <td align="left" class="fileLabel"><cf_translate key="LB_Factor">Factor</cf_translate>:</td>
			<td>
			<input name="CIfactor" type="text" id="CIfactor" size="15" maxlength="15" <cfif deshabilitar >readonly="readonly"</cfif> onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,5);"  onkeyup="if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#rs.CIfactor#<cfelse>1.00000</cfif>">
			</td>
			<td align="right" class="fileLabel" width="17%">#LB_METODO#:</td>
			<td width="17%" >
				<select name="CItipo" id="CItipo" <cfif deshabilitar >disabled="disabled"</cfif> <cfif  modo eq 'CAMBIO'> onchange="javascript: activarPagosNoProcesados(this);devuelveMetodo(); </cfif>">
					<option value="0" <cfif modo NEQ "ALTA" and rs.CItipo EQ 0>selected</cfif>><cf_translate  key="CItipo0">Horas</cf_translate></option>
					<option value="1" <cfif modo NEQ "ALTA" and rs.CItipo EQ 1>selected</cfif>><cf_translate  key="CItipo1">D&iacute;as</cf_translate></option>
					<option value="2" <cfif modo NEQ "ALTA" and rs.CItipo EQ 2>selected</cfif>><cf_translate  key="CItipo2">Importe</cf_translate></option>
					<option value="3" <cfif modo NEQ "ALTA" and rs.CItipo EQ 3>selected</cfif>><cf_translate  key="CItipo3">C&aacute;lculo</cf_translate></option>
				</select>
			</td>
			<td  width="3%" align="center">
				<input name="CInegativo" type="checkbox" <cfif deshabilitar >disabled="disabled"</cfif> id="CInegativo2" value="-1" <cfif modo NEQ "ALTA" and rs.CInegativo EQ -1>checked</cfif>>
			</td>
			<td width="40%"><cf_translate key="CHK_Negativoo">&nbsp;Negativo</cf_translate></td>
            <!--- </table> --->
		</tr>
		<tr>
			<td align="left" class="fileLabel" colspan="">#MSG_ConceptoSAT#:</td>
			<td width="40%" colspan="5">
		        <cfquery name="rsConceptoSAT" datasource="#session.DSN#">
		            select RHCSATid,RHCSATcodigo,RHCSATdescripcion from dbo.RHCFDIConceptoSAT
		            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		            and RHCSATtipo = 'P'
		            order by RHCSATcodigo
		        </cfquery>
		        <select name="ConceptoSAT" id="ConceptoSAT">
		            <option value=0>-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">seleccionar</cf_translate> -</option>
		            <cfloop query="rsConceptoSAT">
		                <option value="#rsConceptoSAT.RHCSATid#" <cfif modo NEQ "ALTA" and rsConceptoSAT.RHCSATid eq rs.RHCSATid>selected</cfif> >#rsConceptoSAT.RHCSATcodigo# #rsConceptoSAT.RHCSATdescripcion#</option>
		            </cfloop>
		        </select>
			</td>
		</tr>

      	<tr>
			<td width="13%" align="left" class="fileLabel" nowrap><cf_translate key="LB_RangoMinimo">Rango M&iacute;nimo</cf_translate>:</td>
			<td colspan=""><input name="CIcantmin" type="text" id="CIcantmin2" size="15" <cfif deshabilitar >readonly="readonly"</cfif> maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#rs.CIcantmin#<cfelse>1.00</cfif>"></td>
			<td align="right" class="fileLabel" nowrap><cf_translate key="LB_RangoMaximo">&nbsp;Rango M&aacute;ximo</cf_translate>:</td>
			<td colspan="3"><input name="CIcantmax" type="text" id="CIcantmax4" size="15" <cfif deshabilitar >readonly="readonly"</cfif> maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#rs.CIcantmax#<cfelse>1.00</cfif>"></td>
      	</tr>
		<tr>
			<td align="left" class="fileLabel" nowrap ><cf_translate key="LB_ObjetoDeGasto">Objeto de Gasto</cf_translate>:</td>
			<td colspan="5">
				<!---<input name="CIcuentac" type="text"  value="<cfif modo NEQ "ALTA">#trim(rs.CIcuentac)#</cfif>" size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm_2(this,0);" onFocus="javascript:this.select();"  >--->
				<input name="CIcuentac" type="text"  value="<cfif modo NEQ "ALTA">#trim(rs.CIcuentac)#</cfif>" <cfif deshabilitar >readonly="readonly"</cfif> size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onfocus="javascript:this.select();"  >			</td>
	  	</tr>
	  	<tr>
			<td align="left" class="fileLabel" nowrap ><cf_translate key="LB_CuentaContable">Cuenta Contable</cf_translate>:</td>
			<td colspan="5">
				<cfif modo NEQ "ALTA" and isdefined("rsCuenta") and rsCuenta.RecordCount NEQ 0>
					<cf_cuentas query="#rsCuenta#" descwidth="15">
				<cfelse>
					<cf_cuentas descwidth="15">
				</cfif>			</td>
		</tr>
      	<tr>
			<td align="right" class="fileLabel" nowrap><cf_translate key="LB_TipoDeExencion">Tipo de Exenci&oacute;n</cf_translate>:</td>
			<td colspan="5">
				<select name="CItipoexencion" id="CItipoexencion" onchange="javascript: chgExencion(this.value);">
				  <option value="0" <cfif modo NEQ "ALTA" and rs.CItipoexencion EQ 0> selected</cfif>><cf_translate  key="CMB_NoAplica">(No Aplica)</cf_translate></option>
				  <option value="1" <cfif modo NEQ "ALTA" and rs.CItipoexencion EQ 1> selected</cfif>><cf_translate  key="CMB_CantidadDeDias">Cantidad de d&iacute;as</cf_translate></option>
				  <option value="2" <cfif modo NEQ "ALTA" and rs.CItipoexencion EQ 2> selected</cfif>><cf_translate  key="CMB_Monto">Monto</cf_translate></option>
				</select>
			</td>
      	</tr>
      	<tr id="trexencion" style="display: none;">
			<td align="right" class="fileLabel" nowrap><cf_translate key="LB_ValorExencion">Valor Exenci&oacute;n</cf_translate>:</td>
			<td colspan="3">
				<div id="exencion1" style="display: none; ">
				<input name="CIexencion1" type="text" id="CIexencion1" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSNumberFormat(rs.CIexencion, '9')#<cfelse>0</cfif>">
				</div>
				<div id="exencion2" style="display: none; ">
				<input name="CIexencion2" type="text" id="CIexencion2" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSNumberFormat(rs.CIexencion, ',9.00')#<cfelse>0.00</cfif>">
				</div>
			</td>
      	</tr>
	  	<cfif rsEmpresa.RecordCount NEQ 0 OR (LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1)>

			<tr>
				<td align="right" width="25%" class="fileLabel"><cf_translate  key="LB_Clave">Clave</cf_translate>:&nbsp;</td>
				<td><input name="CIclave" type="text" size="6" maxlength="4" value="<cfif modo NEQ 'ALTA'>#rs.CIclave#</cfif>" /></td>
			</tr>
			<tr>
				<td align="right" width="25%" class="fileLabel"><cf_translate  key="LB_CodigoExterno">C&oacute;digo Externo</cf_translate>:&nbsp;</td>
				<td><input name="CIcodigoext" type="text" size="6" maxlength="10" value="<cfif modo NEQ 'ALTA'>#TRIM(rs.CIcodigoext)#</cfif>" /></td>
			</tr>
		</cfif>
		<tr>
			<td class="fileLabel" align="right">Exenci&oacute;n SDI Bimestral:</td>
			<td>
				<select name="CIexencionSDI" id="CIexencionSDI">
					<option value="0" <cfif modo neq 'alta' and rs.CIexencionSDI eq 0>selected</cfif>>-- Seleccione una opci&oacute;n --</option>
					<option value="1" <cfif modo neq 'alta' and rs.CIexencionSDI eq 1>selected</cfif>>Comedor de la Empresa</option>
					<option value="2" <cfif modo neq 'alta' and rs.CIexencionSDI eq 2>selected</cfif>>Uso gratuito casa habitaci&oacute;n</option>
				</select>
			</td>
		</tr>
     <tr>
		<td colspan="4">
		<cf_tabs>
			<cf_tab text="<strong>Conceptos de pago</strong>" selected="#form.tab eq 0#">
				<table width="100%" border="0">
					<tr>
						<!--- <td>&nbsp;</td> --->
						<td colspan="4">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td><input alt="0" name="CInorealizado" type="checkbox" id="CInorealizado" value="0" <cfif modo NEQ "ALTA" and rs.CInorealizado EQ 1>checked</cfif> onclick="javascript: (this,document.form1); checkMe(this.checked,document.form1);"></td>
									<td nowrap><cf_translate key="CHK_PagosNoProcesados">Pagos No Procesados (Si el tipo de unidad es Importe)</cf_translate></td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<!--- <td align="right">&nbsp;</td> --->
						<td colspan="4">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td><input alt="0" name="CIredondeo" type="checkbox" id="CIredondeo" value="0" <cfif modo NEQ "ALTA" and rs.CIredondeo EQ 1>checked</cfif> onclick="javascript: checkRedondeo(this,document.form1); checkMe(this.checked,document.form1);"></td>
									<td nowrap><cf_translate key="CHK_ConceptoParaRedondeo">Concepto para Redondeo (Si el tipo de unidad es Importe)</cf_translate></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<!--- <td align="right">&nbsp;</td> --->
						<td colspan="4">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CInopryrenta eq 1>checked</cfif> name="CInopryrenta" value="checkbox"></td>
									<td nowrap><cf_translate key="CHK_NoConsiderarParaProyeccionDeRentaCalculoNomina">No considerar para proyecci&oacute;n de Renta en el c&aacute;lculo de n&oacute;mina</cf_translate></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<!--- <td>&nbsp;</td> --->
						<td colspan="4">
							<table border="0" width="100%" cellpadding="0" cellspacing="0">
								<cfif #UsaSBC#	EQ 1>
                                    <tr>
										<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIafectaSBC eq 1>checked</cfif> name="CIafectaSBC" value="checkbox"></td>
										<td nowrap><cf_translate key="CHK_AfectaSBC">Afecta SBC</cf_translate></td>
                                        <td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIafectaISN eq 1>checked</cfif> name="CIafectaISN" value="checkbox"></td>
                                        <td nowrap><cf_translate key="CHK_AfectaSBC">Afecta ISN</cf_translate></td>
									</tr>
                                </cfif>
								<tr>
								  <td width="3%"><input alt="1" name="CInorenta" type="checkbox" id="CInorenta" value="0" <cfif modo NEQ "ALTA" and rs.CInorenta EQ 1>checked</cfif> onclick="javascript: checkMe(this.checked,document.form1);"></td>
									<td width="53%" nowrap><cf_translate key="CHK_NoAplicaRenta">No Aplica Renta</cf_translate></td>
								  <td width="8%"> <input alt="2" name="CInocargas" type="checkbox" id="CInocargas" value="0" <cfif modo NEQ "ALTA" and rs.CInocargas EQ 1>checked</cfif> onclick="javascript: checkMe(this.checked,document.form1);"></td>
									<td width="36%" nowrap><cf_translate key="CHK_NoAplicaCargas">No Aplica Cargas</cf_translate> </td>
								</tr>
								<tr>
									<td> <input alt="3" name="CInodeducciones" type="checkbox" id="CInodeducciones" value="0" <cfif modo NEQ "ALTA" and rs.CInodeducciones EQ 1>checked</cfif> onclick="javascript: checkMe(this.checked,document.form1);"></td>
									<td nowrap><cf_translate key="CHK_NoAplicaDeducciones">No Aplica Deducciones</cf_translate></td>
									<td> <input alt="3" name="CIvacaciones" type="checkbox" id="CIvacaciones" value="0" <cfif modo NEQ "ALTA" and rs.CIvacaciones EQ 1>checked</cfif>></td>
									<td nowrap><cf_translate key="CHK_AfectaVacaciones">Afecta Vacaciones</cf_translate></td>
								</tr>
								<tr>
									<td> <input alt="3" name="CIafectasalprom" type="checkbox" id="CIafectasalprom" value="1" <cfif modo NEQ "ALTA" and rs.CIafectasalprom EQ 1>checked<cfelseif modo eq 'ALTA'>checked</cfif>></td>
									<td nowrap><cf_translate key="CHK_AfectaSalarioPromedio">Afecta Salario Promedio</cf_translate></td>
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CInocargasley eq 1>checked</cfif> name="CInocargasley" value="checkbox"></td>
									<td nowrap><cf_translate key="CHK_NoAplicaCargasDeLey">No aplica cargas de ley</cf_translate></td>
								</tr>
								<tr>
								  <td width="3%"><input alt="1" name="CInoanticipo" type="checkbox" id="CInoanticipo" value="0" <cfif modo NEQ "ALTA" and rs.CInoanticipo EQ 1>checked</cfif>></td>
									 <td nowrap><cf_translate key="CHK_CInoanticipo">Aplica Anticipo</cf_translate></td>
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIafectacomision eq 1>checked</cfif> name="CIafectacomision" value="checkbox"></td>
									<td nowrap><cf_translate key="CHK_AfectaComision">Afecta Comisi&oacute;n</cf_translate></td>
								</tr>
								<tr>
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CInomostrar eq 1>checked</cfif> name="CInomostrar" value="1"></td>
									<td nowrap><cf_translate key="CHK_NoMostrarEnListas">No mostrar en listas</cf_translate></td>
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIautogestion eq 1>checked</cfif> name="CIautogestion" value="1"></td>
									<td nowrap><cf_translate key="CHK_VisibleAutogetion">Visible desde autogesti&oacute;n</cf_translate></td>
								</tr>
								<tr> <!---SML. Inicio Para Saber si el concepto es para fondo de ahorro--->
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIfondoahorro eq 1>checked</cfif> name="CIfondoahorro" value="1"></td>
									<td nowrap><cf_translate key="CHK_FondoAhorro">Fondo de Ahorro</cf_translate></td>
                                    <!---SML. Final Para Saber si el concepto es para fondo de ahorro--->
                                    <!---SML. Incio Para saber si la incidencia es de tipo Especie--->
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIespecie eq 1>checked</cfif> name="CIespecie" value="1"></td>
									<td nowrap><cf_translate key="CHK_Especie">Especie</cf_translate></td>
                                    <!---SML. Final Para saber si la incidencia es de tipo Especie--->
								</tr>
								<!--- OPARRALES 2018-07-08 Check para excluir Pago en efectivo del timbrado --->
								<tr>
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CItimbrar eq 1>checked</cfif> name="CItimbrar" value="1"></td>
									<td nowrap><cf_translate key="CHK_Timbrar">Excluir del CFDI</cf_translate></td>
									<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIExcluyePagoLiquido eq 1>checked</cfif> name="CIExcluyePagoLiquido" value="1"></td>
									<td nowrap><cf_translate key="CHK_Timbrar">Excluye del Pago Liquido</cf_translate></td>
								</tr>
								<cfif isdefined("rsVerificaParametro1000") and rsVerificaParametro1000.RecordCount NEQ 0 and rsVerificaParametro1000.Pvalor EQ 1>
									<tr id="LBL_CIafectacostoHE" style="display:<cfif modo neq 'ALTA' and rs.CItipo NEQ 2>none</cfif>;">
										<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIafectacostoHE eq 1>checked</cfif> name="CIafectacostoHE" value="1"></td>
										<td nowrap><cf_translate key="CHK_AfectaCalculoDeHoraExtraordinaria">Afecta C&aacute;lculo de Hora Extraordinaria</cf_translate></td>
									</tr>
								</cfif>
								<tr>
									<td colspan="4">
										<fieldset><legend><cf_translate key="LB_Boleta_de_Liquidacion" >Boleta de Liquidaci&oacute;n</cf_translate></legend>
										<table width="100%" border="0">
											<tr>
											  <td><input name="CISumarizarLiq" type="checkbox" tabindex="1"  <cfif  modo neq 'ALTA' and rs.CISumarizarLiq EQ '1'> checked </cfif>>
											  <cf_translate  key="CHK_No_sumarizar_y_mostrar_en_detalle_de_liquidacion">No sumarizar y mostrar en detalle de la liquidaci&oacute;n</cf_translate></td>
											</tr>
											<tr>
											  <td><input name="CIMostrarLiq" type="checkbox" tabindex="1"  <cfif  modo neq 'ALTA' and rs.CIMostrarLiq EQ '1'> checked </cfif>>
											  <cf_translate  key="CHK_Mostrar_en_area_otros_rubros_especiales">Mostrar en &aacute;rea otros rubros especiales</cf_translate></td>
											</tr>
										</table>
										</fieldset>
									</td>
								</tr>
								<tr  id="LBL_Acciones_Personal" style="display:<cfif modo neq 'ALTA' and rs.CItipo NEQ 2>none</cfif>;" >
									<td colspan="4">
										<fieldset><legend><cf_translate key="LB_Acciones_de_personal" >Acciones de Personal</cf_translate></legend>
										<table width="100%" border="0">
											<tr bgcolor="##CCCCCC">
												<td  align="center">
													<b><cf_translate  key="LB_Ayuda">Parametrizaci&oacute;n aplicable para c&aacute;lculos especiales de tipo incidencia</cf_translate></b>
												</td>
											</tr>

											<tr>
											  <td><input   onclick="javascript: validarCampos(this);" name="CImodFechaReg" type="checkbox" tabindex="1"  <cfif  modo neq 'ALTA' and rs.CImodFechaReg EQ '1'> checked </cfif>>
												  <cf_translate  key="CHK_Generar_Fecha_Registro">Generar fecha registro</cf_translate>&nbsp;
												  <input 	name="CIdiasAjuste"
															type="text"
															id="CIdiasAjuste"
															size="2" maxlength="2"
															onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"
															onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
															style="text-align: right;" value="<cfif modo NEQ "ALTA">#rs.CIdiasAjuste#</cfif>">

													<cf_translate  key="CHK_dias">d&iacute;a (s)</cf_translate>
													<select name="CItipoAjuste" id="CItipoAjuste">
														<option value=""></option>
														<option value="-1" <cfif modo NEQ "ALTA" and rs.CItipoAjuste EQ -1>selected</cfif>><cf_translate  key="CItipoAjuste1">Antes</cf_translate></option>
														<option value="1"  <cfif modo NEQ "ALTA" and rs.CItipoAjuste EQ 1 >selected</cfif>><cf_translate  key="CItipoAjuste2">Despu&eacute;s</cf_translate></option>
													</select>
												 </td>
											</tr>
											<tr>
											  <td><input name="CImodNominaSP" type="checkbox" tabindex="1"  <cfif  modo neq 'ALTA' and rs.CImodNominaSP EQ '1'> checked </cfif>>
											  <cf_translate  key="CHK_Generar_para_nominas_especiales">Generar para n&oacute;minas especiales</cf_translate></td>
											</tr>
										</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</cf_tab>
          	 <cfif  modo eq 'CAMBIO'>
			<cf_tab text="<strong> Límites </strong>" selected="#form.tab eq 0#" >
			  <cfinclude template="TipoIncidencia-limites.cfm">
			</cf_tab>
            </cfif>
		</cf_tabs>
		</td>
	  </tr>
		<tr>
        	<td colspan="4" align="center">

				<script language="JavaScript" type="text/javascript">
					// Funciones para Manejo de Botones
					botonActual = "";

					function setBtn(obj) {
						botonActual = obj.name;
					}
					function btnSelected(name, f) {
						if (f != null) {
							return (f["botonSel"].value == name)
						}
						else {
							return (botonActual == name)
						}
					}
				</script>

				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">




				<cfif modo eq 'CAMBIO'>
					<input type="submit" name="Cambio" value="<cfoutput>#BTN_Modificar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; ">

					<cfif not deshabilitar >
						<input type="submit" name="Baja" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name;if ( confirm('¿Est&aacute;? seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					</cfif>
					<input type="submit" name="Nuevo" value="<cfoutput>#BTN_Nuevo#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
					<input type="button" name="Retenciones" value="<cfoutput>#BTN_Retenciones#</cfoutput>" onclick="javascrpt:location.href='Retenciones.cfm?CIid=#form.CIid#';">
				<cfelse>
					<input type="submit" name="Alta" value="<cfoutput>#BTN_Agregar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; limpiaLimites()">
				</cfif>

				  <!--- <div id="divFormular" style="display='none'"> --->
				  <!--- SE HACE ASI Y NO CON DIVS PORQUE SI SE DEJA CON DIVS EL USUARIO PODRIA PONERLO EN
						  METODO CALCULO SOLO PARA DARLE FORMULAR Y NO ES ESE REALMENTE SU VALOR--->
				  <cfif modo NEQ "ALTA" and rs.CItipo EQ 3>
					<input type="submit" value="<cfoutput>#BTN_formular#</cfoutput>"  id="formular" name="formular" onclick="form1.action='TiposIncidencia-formular.cfm';">
				  </cfif>
				  <!--- </div> --->			</td>
		</tr>
	</table>
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rs.ts_rversion#" returnvariable="ts"></cfinvoke>
	</cfif>
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="CIid" value="#rs.CIid#">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">

<!--- para mantener la navegacion --->
<cfif isdefined("Form.FCIcodigo") and Len(Trim(Form.FCIcodigo)) NEQ 0>
	<input type="hidden" name="FCIcodigo" value="#form.FCIcodigo#" >
</cfif>

<cfif isdefined("Form.FCIdescripcion") and Len(Trim(Form.FCIdescripcion)) NEQ 0>
	<input type="hidden" name="FCIdescripcion" value="#form.FCIdescripcion#" >
</cfif>

<cfif isdefined("Form.fMetodo") and Len(Trim(Form.fMetodo)) gt 0>
	<input type="hidden" name="fMetodo" value="#form.fMetodo#" >
</cfif>

</form>

</cfoutput>


<!--- VARIABLES DE TRADUCCION --->
<script language="JavaScript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");



	function _Field_isExiste(){
		var existe = new Boolean;
		existe = false;
		<cfoutput query="rsCodigos">
			if (
				'#CIcodigo#'.toUpperCase( )==this.value.toUpperCase( )
				<cfif modo NEQ "ALTA">&&'#rs.CIcodigo#'.toUpperCase( )!=this.value.toUpperCase( )</cfif>
				)
					existe = true;
		</cfoutput>
		if (existe){this.error="El campo "+this.description+"<cfoutput>#MSG_ContieneUnValorQueYaExisteDebeDigitarUnoDiferente#</cfoutput>";}
	}
	_addValidator("isExiste", _Field_isExiste);

	objForm.CIcodigo.required = true;
	objForm.CIcodigo.description = "<cfoutput>#MSG_CodigoDeTipoDeIncidencia#</cfoutput>";
	objForm.CIcodigo.validateExiste();
	objForm.CIcodigo.validate=true;
	objForm.CIdescripcion.required = true;
	objForm.CIdescripcion.description = "<cfoutput>#MSG_DescripcionDeIncidencia#</cfoutput>";
	objForm.CIfactor.required = true;
	objForm.CIfactor.description = "<cfoutput>#MSG_Factor#</cfoutput>";
	objForm.CIcantmin.required = true;
	objForm.CIcantmin.description = "<cfoutput>#MSG_RangoMinimo#</cfoutput>";
	objForm.CIcantmax.required = true;
	objForm.CIcantmax.description = "<cfoutput>#MSG_RangoMaximo#</cfoutput>";

	<cfif  modo eq 'CAMBIO'> activarPagosNoProcesados(objForm.CItipo.obj);</cfif>

	<cfif modo NEQ "ALTA">
		fm(objForm.obj.CIfactor, 5);
		fm(objForm.obj.CIcantmin, 2);
		fm(objForm.obj.CIcantmax, 2);
	</cfif>
	function validarCampos(obj){
		if (obj.checked ) {
			objForm.CIdiasAjuste.required = true;
			objForm.CIdiasAjuste.description = "<cfoutput>#MSG_Dias#</cfoutput>";
			objForm.CItipoAjuste.required = true;
			objForm.CItipoAjuste.description = "<cfoutput>#MSG_TipoAjuste#</cfoutput>";
		}
		else{
			objForm.CItipoAjuste.required = false;
			objForm.CIdiasAjuste.required = false;
			document.form1.CItipoAjuste.value="";
			document.form1.CIdiasAjuste.value="";
		}
	}



//	objForm.CIcodigo.obj.focus();
	chgExencion(document.form1.CItipoexencion.value);
</script>
