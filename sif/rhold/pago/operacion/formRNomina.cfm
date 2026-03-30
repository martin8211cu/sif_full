<!--- 
	form Encabezado/Detalle Registro de Nomina
	Recibe del SQL los siguientes valores:
		-modo, dmodo, ERNid, DRNlinea
	Envía al SQL los siguientes valores:
		-Tcodigo, CBcc, Mcodigo, ERNfdeposito, ERNfinicio, ERNffin, ERNdescripcion
		-NTIcodigo, DRIdentificacion, CBcc, Mcodigo, DRNnombre, DRNapellido1, DRNapellido2, DRNtipopago, DRNperiodo, 
		DRNnumdias, DRNotrasdeduc, DRNliquido, DRNpuesto, DRNocupacion, DRNotrospatrono, DRNinclexcl ,DRNfinclexcl
--->
<cfif not isDefined("Form.Nuevo") and not isDefined("Form.ERNid")>
	<cflocation url="listaRNomina.cfm">
</cfif>
<!--- Asigna modos Encabezado y Detalle --->
<cfif isdefined("Form.ERNid") and Len(Trim(Form.ERNid)) gt 0>
	<cfset Form.modo='CAMBIO'>
</cfif>
<cfif isdefined("Form.DRNlinea") and Len(Trim(Form.DRNlinea)) gt 0>
	<cfset Form.dmodo='CAMBIO'>
</cfif>
<cfif not isdefined("Form.modo")>
	<cfset modo='ALTA'>
<cfelseif Form.modo EQ "CAMBIO">
	<cfset modo="CAMBIO">
	<cfif not isdefined("Form.dmodo")>
		<cfset dmodo='ALTA'>
	<cfelseif Form.dmodo EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo='ALTA'>
	</cfif>
<cfelse>
	<cfset modo='ALTA'>
</cfif>
<!--- Manejo de la navegación --->
<cfset navegacion = "">
<cfset filtro = "">
<!--- Consultas --->
<!---- Tipos de Nómina --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select Tcodigo, Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

	<cfquery name="rsCuentasCliente" datasource="#Session.DSN#">
		select 	convert(varchar,CBid) as CBid, 
				convert(varchar,Bid) as Bid, 
				Ocodigo, 
				convert(varchar,Mcodigo) as Mcodigo, 
				CBcodigo, 
				CBdescripcion, 
				CBcc, 
				convert(varchar,CBTcodigo) as CBTcodigo
		from CuentasBancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	        and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		order by CBcc, CBdescripcion
	</cfquery>

<!--- Consultas en modo Cambio --->
<cfif modo neq 'AlTA'>
	<!--- Encabezado de Registro de Nómina --->
	<cfquery name="rsERNomina" datasource="#Session.DSN#">
		select 	Tcodigo, convert(varchar,CBcc) as CBcc, 
				convert(varchar,a.Mcodigo) as Mcodigo, Msimbolo, Miso4217,
						convert(varchar,ERNfdeposito,103) as ERNfdeposito, 
						convert(varchar,ERNfinicio,103) as ERNfinicio, 
						convert(varchar,ERNffin,103) as ERNffin, 
						ERNdescripcion, a.ts_rversion,
						(select isnull (sum (DRNliquido), 0)
						FROM DRNomina c WHERE c.ERNid = a.ERNid) as Importe
		from ERNomina a, Monedas b
		where a.Mcodigo = b.Mcodigo
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
			and ERNestado = 1
	</cfquery>
	<!--- Integridad: Protege integridad de datos en caso de pantalla cargada con cache. --->
	<cfif rsERNomina.RecordCount lte 0>
		<cflocation url="listaRNomina.cfm">
	</cfif>
	<!--- Tipos de Identificación --->
	<cfquery name="rsNTipoIdentificacion" datasource="#Session.DSN#">
		select NTIcodigo, NTIdescripcion, NTIcaracteres, NTImascara
		from NTipoIdentificacion
	</cfquery>
	<cfif dmodo neq 'AlTA'>
		<!--- Detalle de Registro de Nómina --->
		<cfquery name="rsDRNomina" datasource="#Session.DSN#">
			select 	DRNomina.NTIcodigo, DRNomina.DRIdentificacion, convert(varchar,DRNomina.CBcc) as CBcc, 
							convert(varchar,DRNomina.Mcodigo) as Mcodigo, DRNomina.DRNnombre, DRNomina.DRNapellido1, 
							DRNomina.DRNapellido2, DRNomina.DRNtipopago, convert(varchar,DRNomina.DRNperiodo,103) as DRNperiodo, 
							DRNomina.DRNnumdias, DRNomina.DRNotrasdeduc, DRNomina.DRNliquido, 
							DRNomina.DRNotrospatrono, DRNomina.DRNinclexcl, convert(varchar,DRNomina.DRNfinclexcl,103) as DRNfinclexcl,
							RHPuestos.RHPcodigo as DRNpuesto, RHPuestos.RHPdescpuesto as DRNdescpuesto, 
							RHOcupaciones.RHOcodigo as DRNocupacion, RHOcupaciones.RHOdescripcion as DRNdescocupacion, DRNomina.ts_rversion
			from ERNomina, DRNomina, RHPuestos, RHOcupaciones
			where ERNomina.ERNid = DRNomina.ERNid
			and ERNomina.Ecodigo *= RHPuestos.Ecodigo
			and DRNomina.DRNpuesto *= RHPuestos.RHPcodigo
			and DRNomina.DRNocupacion *= RHOcupaciones.RHOcodigo
			and DRNomina.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
			and DRNomina.DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRNlinea#">
		</cfquery>
	</cfif>
</cfif>
<script language="JavaScript" type="text/javascript" src="../../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="../../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript" src="../../../js/calendar.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	//Conlis de Deduciones
	<cfif isDefined("dmodo") and dmodo neq 'AlTA'>
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	function doConlisDeducciones(val) {
		//Este conlis de llamarse dependiendo de val si val es 0 debe llamar al conlis de Deducciones 
		//en modo Otras Deducciones si es 1 en modo Otros Pagos Patrono.
		var params ="";
		<cfoutput>
		params+="?DDpagopor="+val;
		params+="&DRNlinea="+#Form.DRNlinea#;
		params+="&formName=form";
		params+="&deducciones="+(val==0?"DRNotrasdeduc":"DRNotrospatrono");
		popUpWindow("formDDeducPagos.cfm"+params,250,200,650,400);
	  	</cfoutput>
	}
	</cfif>	
	//Acciones de los Botones
	function setBtn(objBoton) {
		var result = true;
		switch (objBoton.alt) {
		case '0' :
			document.form.Accion.value='Alta';
			break;
		case '1' :
			document.form.Accion.value='Cambio';
			break;
		case '2' :
			if (confirm('¿Desea Eliminar el Registro completo de la Nómina y todos sus Detalles?'))
				document.form.Accion.value='Baja';
			else
				result = false;
			break;
		case '3' :
			document.form.Accion.value='Nuevo';
			break;
<cfif modo neq 'ALTA'>
		case '4' :
			document.form.Accion.value='AltaDetalle';
			break;
		case '5' :
			document.form.Accion.value='CambioDetalle';
			break;
		case '6' :
			if (confirm('¿Desea Eliminar el Detalle?'))
				document.form.Accion.value='BajaDetalle';
			else
				result = false;
			break;
		case '7' :
			document.form.Accion.value='NuevoDetalle';
			break;
		case '8' :
			if (confirm('¿Confirma que desea pasar a verificación?'))
				document.form.Accion.value='Listo';
			else
				result = false;
			break;			
</cfif>
		}
		//Para que no valide en Baja ni Baja Detalle
		if (document.form.Accion.value=='Baja' || document.form.Accion.value=='BajaDetalle' || document.form.Accion.value=='Listo')
			fnNoValidar();
		//Resultado de la función
		return result;
	}
	<cfif modo neq 'ALTA'>
		function fnIncluir(Obj) {
			//objForm = new qForm("form");
			if (Obj.name=="incluir") {
					document.form.excluir.checked = false;
					document.form.DRNinclexcl.value = "1";
			}
			else {
					document.form.incluir.checked = false;
					document.form.DRNinclexcl.value = "2";
			}
			if (document.form.incluir.checked == false && document.form.excluir.checked == false)	{
				document.form.DRNinclexcl.value = "";
				objForm.DRNfinclexcl.required = false;
			}
			else	{
				objForm.DRNfinclexcl.required = true;
			}
		}
		function fnfinalizar(f) {
			f.DRNliquido.value=qf(f.DRNliquido.value);
			f.DRNotrasdeduc.value=qf(f.DRNotrasdeduc.value);
			f.DRNotrospatrono.value=qf(f.DRNotrospatrono.value);
			f.DRIdentificacion.value = eval('f.DRIdentificacion'+f.NTIcodigo.value+'.value');
			//Análisis de ModificarE
			//Tcodigo,CBcc,Mcodigo,ERNfdeposito,ERNfinicio,ERNffin,ERNdescripcion
			if (
				f.Tcodigo.value == f.hid_Tcodigo.value &&
				f.CBcc.value == f.hid_CBcc.value &&
				f.Mcodigo.value == f.hid_Mcodigo.value &&
				f.ERNfdeposito.value == f.hid_ERNfdeposito.value &&
				f.ERNfinicio.value == f.hid_ERNfinicio.value &&
				f.ERNffin.value == f.hid_ERNffin.value &&
				f.ERNdescripcion.value == f.hid_ERNdescripcion.value
				)
				f.ModificarE.value="false";
			else
				f.ModificarE.value="true";
		}
		function cambiarMascara(Obj) {
		<cfoutput query="rsNTipoIdentificacion">
			var div_#NTIcodigo# = document.getElementById("div_#NTIcodigo#");
			if ('#NTIcodigo#'==Obj.value) {
				div_#NTIcodigo#.style.display = '';
				objForm.DRIdentificacion#NTIcodigo#.required = true;
			}
			else {		
				div_#NTIcodigo#.style.display = 'none';
				objForm.DRIdentificacion#NTIcodigo#.required = false;
			}
		</cfoutput>	
		}
	</cfif>
	function fnNoValidar() {
		objForm.Tcodigo.required = false;
		objForm.CBcc.required = false;
		objForm.Mcodigo.required = false;
		objForm.ERNfdeposito.required = false;
		objForm.ERNfinicio.required = false;
		objForm.ERNffin.required = false;
		objForm.ERNdescripcion.required = false;
		<cfif modo neq 'ALTA'>
			objForm.NTIcodigo.required = false;
			<cfoutput query="rsNTipoIdentificacion">
				objForm.DRIdentificacion#NTIcodigo#.required = false;
			</cfoutput>
			objForm.DRNCBcc.required = false;
			objForm.DRNMcodigo.required = false;
			objForm.DRNnombre.required = false;
			objForm.DRNapellido1.required = false;
			objForm.DRNapellido2.required = false;
			objForm.DRNtipopago.required = false;
			objForm.DRNperiodo.required = false;
			objForm.DRNnumdias.required = false;
			objForm.DRNotrasdeduc.required = false;
			objForm.DRNliquido.required = false;
			objForm.DRNpuesto.required = false;
			objForm.DRNocupacion.required = false;
			objForm.DRNotrospatrono.required = false;
		</cfif>
	}
	function initPage(f) {
	<cfif modo neq 'ALTA'>
		cambiarMascara(f.NTIcodigo);
	</cfif>
	}
</script>

<!--- 
    <tr> 
      <td nowrap colspan="4" align="right"><cfif modo neq 'Alta'><cfoutput><b>Número :</b>&nbsp;#Form.ERNid#&nbsp;<b>Importe :</b>&nbsp;#rsERNomina.Msimbolo# #LSCurrencyFormat(rsERNomina.Total,'none')# (#rsERNomina.Miso4217#)</cfoutput><cfelse>&nbsp;</cfif></td>
    </tr>
--->
<form action="SQLRNomina.cfm" method="post" name="form" <cfif modo neq 'AlTA'>onSubmit="javascript: fnfinalizar(document.form);"</cfif>>
	<table border="0" cellspacing="0" cellpadding="0" align="center" style="margin-left: 10px; margin-right: 10px;">
    <tr valign="top"> 
      <td nowrap colspan="4" align="center" bgcolor="#E2E2E2" class="subTitulo">ENCABEZADO 
        DEL REGISTRO DE LA NOMINA</td>
    </tr>
    <tr> 
      <td nowrap class="fileLabel">Tipo N&oacute;mina:</td>
      <td nowrap class="fileLabel">Cuenta Cliente:</td>
      <td nowrap class="fileLabel">Moneda:</td>
      <td nowrap class="fileLabel">Fecha Dep&oacute;sito:</td>
      </tr>
    <tr> 
      <td nowrap> 
        <!--- Tipo de Nómina --->
        <select name="Tcodigo" tabindex="1" >
          <cfoutput query="rsTiposNomina"> 
            <cfif modo neq 'AlTA' and rsERNomina.Tcodigo eq Tcodigo>
              <option value="#Tcodigo#" selected>#Tdescripcion#</option>
              <cfelse>
              <option value="#Tcodigo#">#Tdescripcion#</option>
            </cfif>
          </cfoutput>
		</select>
        <input type="hidden" name="hid_Tcodigo" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.Tcodigo#</cfoutput></cfif>"></td>
      <td nowrap> 
        <!--- Cuenta Cliente --->
        <select name="CBcc" tabindex="1" >
          <cfoutput query="rsCuentasCliente"> 
            <cfif modo neq 'AlTA' and rsERNomina.CBcc eq CBcc>
              <option value="#CBcc#" selected>#CBdescripcion#</option>
              <cfelse>
              <option value="#CBcc#">#CBdescripcion#</option>
            </cfif>
          </cfoutput>
				</select>
        <input type="hidden" name="hid_CBcc" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.CBcc#</cfoutput></cfif>"> </td>
      <td nowrap> 
        <!--- Moneda --->
        <input type="hidden" name="hid_Mcodigo" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.Mcodigo#</cfoutput></cfif>">
        <cfif modo neq 'AlTA'>
					<cfoutput>
						<cf_sifmonedas query="#rsERNomina#" form="form" tabindex="1" >
					</cfoutput>					
				<cfelse>
					<cf_sifmonedas form="form" tabindex="1">
				</cfif>
		  </td>
      <td nowrap>
				<!--- Fecha de depósito --->
        <input type="hidden" name="hid_ERNfdeposito" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.ERNfdeposito#</cfoutput></cfif>"> 
        <cfif modo neq 'AlTA'>
					<cfoutput> 
						<cf_sifcalendario name="ERNfdeposito" form="form" query="#rsERNomina#" tabindex="1" >
					</cfoutput>
				<cfelse>
					<cf_sifcalendario name="ERNfdeposito" form="form" tabindex="1">
				</cfif>
      </td>
    </tr>
    <tr>
      <td nowrap class="fileLabel">Fecha Inicio Pago:</td>
      <td nowrap class="fileLabel">Fecha Final Pago:</td> 
      <td nowrap colspan="2" class="fileLabel">Descripci&oacute;n:</td>
    </tr>
    <tr>
      <td nowrap>
				<!--- Fecha Inicio Pago --->
        <input type="hidden" name="hid_ERNfinicio" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.ERNfinicio#</cfoutput></cfif>"> 
        <cfif modo neq 'AlTA'>
					<cfoutput> 
						<cf_sifcalendario name="ERNfinicio" form="form" value="#rsERNomina.ERNfinicio#" tabindex="1" >
					</cfoutput>
				<cfelse>
					<cf_sifcalendario name="ERNfinicio" form="form" tabindex="1">
				</cfif>
      </td>
      <td nowrap>
				<!--- Fecha Final Pago--->
        <input type="hidden" name="hid_ERNffin" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.ERNffin#</cfoutput></cfif>"> 
        <cfif modo neq 'AlTA'>
					<cfoutput> 
						<cf_sifcalendario name="ERNffin" form="form" value="#rsERNomina.ERNffin#" tabindex="1" >
					</cfoutput>
				<cfelse>
					<cf_sifcalendario name="ERNffin" form="form" tabindex="1">
				</cfif>
      </td>
	  		<td colspan="2" nowrap>
					<!--- Descripción --->
					<input type="text" name="ERNdescripcion" size="70" maxlength="100" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.ERNdescripcion#</cfoutput></cfif>" tabindex="1" >
        <input type="hidden" name="hid_ERNdescripcion" value="<cfif modo neq 'AlTA'><cfoutput>#rsERNomina.ERNdescripcion#</cfoutput></cfif>"> </td>
      </tr>
		<tr> 
      <td nowrap colspan="5">&nbsp;
		<cfif modo neq 'ALTA'>
		  <cfset ts = "">
          <cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
            <cfinvokeargument name="arTimeStamp" value="#rsERNomina.ts_rversion#"/>
          </cfinvoke>
		  <input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
		</cfif>
	  </td>
    </tr>
		<cfif modo neq 'ALTA'>
			<tr> 
				<td nowrap colspan="4" align="center" bgcolor="#E2E2E2" class="subTitulo">DETALLE 
					DEL REGISTRO DE LA NOMINA</td>
			</tr>
			<tr>
				<td nowrap class="fileLabel">Tipo de ID:</td>
				<td nowrap class="fileLabel">Identificaci&oacute;n:</td>
				<td nowrap class="fileLabel">Cuenta Cliente:</td>
			  	<td nowrap class="fileLabel">Moneda de la Cuenta:</td>
		  </tr>
			<tr>
				<td nowrap>
					<!--- Tipo de Identificación --->
					<select name="NTIcodigo" tabindex="2" onChange="javascript: cambiarMascara(this);">
						<cfoutput query="rsNTipoIdentificacion"> 
							<cfif dmodo neq 'AlTA' and rsDRNomina.NTIcodigo eq NTIcodigo>
								<option value="#NTIcodigo#" selected>#NTIdescripcion#</option>
							<cfelse>
								<option value="#NTIcodigo#">#NTIdescripcion#</option>
							</cfif>
						</cfoutput> 
					</select>
				</td>
				<td nowrap>
					<!--- Identificación --->
					<cfif dmodo neq 'AlTA'>
						<cfoutput query="rsNTipoIdentificacion">
							<div id="div_#NTIcodigo#" style="display:none;">
								<cfif rsDRNomina.NTIcodigo eq NTIcodigo>
									<cf_sifmaskstring form="form" name="DRIdentificacion#NTIcodigo#" tabindex="2" formato="#NTImascara#" size="30" maxlength="60" value="#rsDRNomina.DRIdentificacion#">
								<cfelse>
									<cf_sifmaskstring form="form" name="DRIdentificacion#NTIcodigo#" tabindex="2" formato="#NTImascara#" size="30" maxlength="60">
								</cfif>
							</div>
						</cfoutput>
					<cfelse>
						<cfoutput query="rsNTipoIdentificacion">
							<div id="div_#NTIcodigo#" style="display:none;">
								<cf_sifmaskstring form="form" name="DRIdentificacion#NTIcodigo#" tabindex="2" formato="#NTImascara#" size="30" maxlength="60">
							</div>
						</cfoutput>
					</cfif>
					<input name="DRIdentificacion" type="hidden" value="#rsDRNomina.DRIdentificacion#">
				</td>
				<td nowrap>
					<!--- Cuenta Cliente --->
					<input type="text" name="DRNCBcc" size="30" maxlength="25" value="<cfif dmodo neq 'AlTA'><cfoutput>#rsDRNomina.CBcc#</cfoutput></cfif>" tabindex="2" >
				</td>
		    <td nowrap>
					<!--- Moneda --->
					<cfif dmodo neq 'AlTA'>
						<cfoutput>
							<cf_sifmonedas frame="frmonedasd" Mcodigo="DRNMcodigo" Mnombre="DRNMnombre" TC="TC2" query="#rsDRNomina#" form="form" tabindex="2">
						</cfoutput>
					<cfelse>
						<cf_sifmonedas frame="frmonedasd" Mcodigo="DRNMcodigo" Mnombre="DRNMnombre" TC="TC2" form="form" tabindex="2">
					</cfif>
				</td>
		  </tr>
			<tr>
				<td nowrap class="fileLabel">Primer Apellido:</td>
				<td nowrap class="fileLabel">Segundo Apellido:</td>
				<td nowrap class="fileLabel">Nombre:</td>
				<td nowrap class="fileLabel">Puesto:</td>
			</tr>
			<tr>
				<td nowrap>
					<!--- Primer Apellido --->
					<input type="text" name="DRNapellido1" size="30" maxlength="60" value="<cfif dmodo neq 'AlTA'><cfoutput>#rsDRNomina.DRNapellido1#</cfoutput></cfif>" tabindex="2" >
				</td>
				<td nowrap>
					<!--- Segundo Apellido --->
					<input type="text" name="DRNapellido2" size="30" maxlength="60" value="<cfif dmodo neq 'AlTA'><cfoutput>#rsDRNomina.DRNapellido2#</cfoutput></cfif>" tabindex="2" >
				</td>
				<td nowrap>
					<!--- Nombre --->
					<input type="text" name="DRNnombre" size="30" maxlength="60" value="<cfif dmodo neq 'AlTA'><cfoutput>#rsDRNomina.DRNnombre#</cfoutput></cfif>" tabindex="2" >
				</td>
			  <td nowrap>
					<!--- Puesto --->
					<cfif dmodo neq 'ALTA'>
						<cfoutput>
							<cf_rhpuesto form="form" query="#rsDRNomina#" name="DRNpuesto" desc="DRNdescpuesto" tabindex="2">
						</cfoutput>
					<cfelse>
						<cf_rhpuesto form="form" name="DRNpuesto" desc="DRNdescpuesto" tabindex="2">
					</cfif>
				</td>
			</tr>
			<tr>
				<td nowrap class="fileLabel">Tipo de pago:</td>
				<td nowrap class="fileLabel">Periodo de pago:</td>
				<td nowrap class="fileLabel">N&uacute;mero de d&iacute;as que paga:</td>
		    <td nowrap class="fileLabel">Ocupaci&oacute;n:</td>
	    </tr>
			<tr>
				<td nowrap>
					<!--- Tipo de pago --->
					<input type="text" name="DRNtipopago" size="3" maxlength="2" value="<cfif dmodo neq 'AlTA'><cfoutput>#rsDRNomina.DRNtipopago#</cfoutput></cfif>" tabindex="2" >
				</td>
				<td nowrap>
					<!--- Periodo de pago --->
					<cfif dmodo neq 'AlTA'>
						<cfoutput>
							<cf_sifcalendario name="DRNperiodo" form="form" value="#rsDRNomina.DRNperiodo#" tabindex="2">
						</cfoutput>
					<cfelse>
						<cf_sifcalendario name="DRNperiodo" form="form" tabindex="2">
					</cfif>
				</td>
				<td nowrap>
					<!--- Número de días que paga --->
					<input type="text" name="DRNnumdias" size="3" maxlength="3" value="<cfif dmodo neq 'AlTA'><cfoutput>#rsDRNomina.DRNnumdias#</cfoutput></cfif>" tabindex="2" >
				</td>
				<td nowrap>
					<!--- Ocupacion --->
					<cfif dmodo neq 'ALTA'>
						<cfoutput>
							<cf_rhocupacion form="form" query="#rsDRNomina#" name="DRNocupacion" desc="DRNdescocupacion" tabindex="2">
						</cfoutput>
					<cfelse>
						<cf_rhocupacion form="form" name="DRNocupacion" desc="DRNdescocupacion" tabindex="2">
					</cfif>
				</td>
		    </tr>
			<tr>
				<td nowrap colspan="3">
					<fieldset><legend>Incluir o Excluir en el Expediente:</legend>
					<table border="0" cellspacing="0" cellpadding="0" align="center" style="margin-left: 10px; margin-right: 10px;">
            <tr> 
              <td nowrap valign="middle" align="right" width="5%"><input name="incluir" type="checkbox" onClick="javascript: fnIncluir(this);" <cfif dmodo NEQ 'ALTA' and rsDRNomina.DRNinclexcl eq 1>checked</cfif> tabindex="2"></td>
              <td nowrap valign="middle">&nbsp;Incluir Empleado.</td>
              <td nowrap valign="middle" align="right" width="5%"><input name="excluir" type="checkbox" onClick="javascript: fnIncluir(this);" <cfif dmodo NEQ 'ALTA' and rsDRNomina.DRNinclexcl eq 2>checked</cfif> tabindex="2"></td>
              <td nowrap valign="middle">&nbsp;Excluir Empleado.</td>
              <td nowrap valign="middle" align="right">Fecha:&nbsp;</td>
              <td nowrap valign="middle">
                <!--- Fecha Inclusión/exclusión --->
                <cfif dmodo neq 'AlTA'>
                  <cfoutput> <cf_sifcalendario name="DRNfinclexcl" form="form" value="#rsDRNomina.DRNfinclexcl#" tabindex="2"> 
                  </cfoutput> 
                  <cfelse>
                  <cf_sifcalendario name="DRNfinclexcl" form="form" tabindex="2"> 
                </cfif>
							</td>
              <input name="DRNinclexcl" type="hidden" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#rsDRNomina.DRNinclexcl#</cfoutput></cfif>">
            </tr>
            <tr> 
              <td nowrap class="fileLabel" valign="middle" colspan="6"> *Esto
                aplica para alimentar el Expediente. </td>
            </tr>
          </table>
					</fieldset>
				</td>
		    <td nowrap class="fileLabel">
					<table border="0" cellspacing="0" cellpadding="0" align="center" style="margin-left: 10px; margin-right: 10px;">
						<tr>
							<td nowrap class="fileLabel" align="right">Salario Bruto:&nbsp;</td>
							<td nowrap class="fileLabel"><input name="DRNliquido" type="text" size="20" maxlength="18" style="text-align: right"  onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsDRNomina.DRNliquido,'none')#</cfoutput><cfelse>0.00</cfif>" tabindex="2" ></td>
						</tr>
						<tr>
							<td nowrap class="fileLabel" align="right">Deducciones:&nbsp;</td>
							<td nowrap>
								<input name="DRNotrasdeduc" type="text" size="20" maxlength="18" style="text-align: right"  onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"  readonly tabindex="2" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsDRNomina.DRNotrasdeduc,'none')#</cfoutput><cfelse>0.00</cfif>">
								<cfif dmodo NEQ 'ALTA'>
								<a href="javascript:doConlisDeducciones(0);" tabindex="-1"> 
									<img src="../../../imagenes/Description.gif" width="18" height="14" border="0"> 
								</a> 
								</cfif>
							</td>
						</tr>						
						<tr>
							<td nowrap class="fileLabel" align="right">Cargas Patrono:&nbsp;</td>
							<td nowrap>
								<input name="DRNotrospatrono" type="text" size="20" maxlength="18" style="text-align: right"  onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"  readonly tabindex="2" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsDRNomina.DRNotrospatrono,'none')#</cfoutput><cfelse>0.00</cfif>">
								<cfif dmodo NEQ 'ALTA'>
								<a href="javascript:doConlisDeducciones(1);" tabindex="-1"> 
									<img src="../../../imagenes/Description.gif" width="18" height="14" border="0"> 
								</a> 
								</cfif>
							</td>
						</tr>
					</table>
				</td>
			<tr>
			<tr> 
				<td nowrap colspan="4">&nbsp;
					<cfif dmodo neq 'ALTA'>
					  <cfset ts = "">
					  <cfinvoke 
							component="sif.Componentes.DButils"
							method="toTimeStamp"
							returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsDRNomina.ts_rversion#"/>
					  </cfinvoke>
					  <input type="hidden" name="DRNtimestamp" value="<cfoutput>#ts#</cfoutput>">
					</cfif>
				</td>
			</tr>
		</cfif>
		<tr> 
			<td nowrap align="center" colspan="4"> <input name="txtEnterSI" tabindex="-1" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"> 
				<cfoutput> 
					<cfif modo eq 'ALTA'>
						<input type="submit" alt="0" name='ALTA' value="#Request.Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
						<input type="reset" name="Limpiar" value="#Request.Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#" tabindex="3">
					<cfelse>
						<cfif dmodo eq 'ALTA'>
							<input type="submit" alt="4" name='DALTA' value="#Request.Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
							<input type="reset" name="DLimpiar" value="#Request.Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#" tabindex="3">
						<cfelse>
							<input type="submit" alt="5" name="DCambio" value="#Request.Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
							<input type="submit" alt="6" name="DBaja" value="#Request.Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
							<input type="submit" alt="7" name="DNuevo" value="#Request.Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
						</cfif>
						<!---<input type="submit" alt="1" name="Cambio" value="#Request.Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">--->
						<input type="submit" alt="2" name="Baja" value="Eliminar Nómina" onClick="javascript: return setBtn(this);" tabindex="3">
						<!---<input type="submit" alt="3" name="Nuevo" value="#Request.Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">--->
						<input type="submit" alt="8" name="Listo" value="Pasar a Verificación" onClick="javascript: return setBtn(this);" tabindex="3">
					</cfif>
				</cfoutput> 
				<cfif modo neq 'AlTA'>
					<cfoutput>
						<input name="ERNid" type="hidden" value="#Form.ERNid#">
						<input name="ModificarE" type="hidden" value="false"><!--- Guarda false mientras en encabezado no cambie --->
						<cfif dmodo neq 'AlTA'>
							<input name="DRNlinea" type="hidden" value="#Form.DRNlinea#">
						</cfif>
					</cfoutput>
				</cfif>
				<input type="hidden" name="Accion" value='ALTA'>
			</td>
		</tr>
  </table>
</form>
<cfif modo neq 'ALTA'>
<table width="80%%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-left: 10px; margin-right: 10px;">
	<tr> 
		<td nowrap colspan="3" align="center" bgcolor="#E2E2E2" class="subTitulo">
			LISTA DEL DETALLE DEL REGISTRO DE LA NOMINA
		</td>
	</tr>
	<tr> 
		<td nowrap colspan="3">
			<cfset irA = "RNomina.cfm">
			<cfinclude template="listaDNomina.cfm">
		</td>
	</tr>
</table>
</cfif>
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");
	//Inicializa algunos detalles de la pantalla
	initPage(document.form);
	//Funciones adicionales de validación
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseInt(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
	}}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	_addValidator("isRango", _Field_isRango);
	//Validaciones del Encabezado
	objForm.Tcodigo.required = true;
	objForm.Tcodigo.description = "Tipo Nómina";
	objForm.CBcc.required = true;
	objForm.CBcc.description = "Cuenta Cliente";
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	objForm.ERNfdeposito.required = true;
	objForm.ERNfdeposito.description = "Fecha Depósito";
	objForm.ERNfinicio.required = true;
	objForm.ERNfinicio.description = "Fecha Inicio Pago";
	objForm.ERNffin.required = true;
	objForm.ERNffin.description = "Fecha Final Pago";
	objForm.ERNdescripcion.required = true;
	objForm.ERNdescripcion.description = "Descripción";
	objForm.ERNdescripcion.validateAlfaNumerico();
	objForm.ERNdescripcion.validate = true;
	//Validaciones del Detalle
	<cfif modo eq 'ALTA'>
		objForm.Tcodigo.obj.focus();
	<cfelse>
		objForm.NTIcodigo.required = true;
		objForm.NTIcodigo.description = "Tipo de Identificación";
		<cfoutput query="rsNTipoIdentificacion">
			objForm.DRIdentificacion#NTIcodigo#.description = "Identificación";
		</cfoutput>
		objForm.DRNCBcc.required = true;
		objForm.DRNCBcc.description = "Cuenta Cliente";
		objForm.DRNCBcc.validateNumeric("El valor para " + objForm.DRNCBcc.description + " debe ser numérico.");
		objForm.DRNCBcc.validate = true;
		objForm.DRNMcodigo.required = true;
		objForm.DRNMcodigo.description = "Moneda";
		objForm.DRNnombre.required = true;
		objForm.DRNnombre.description = "Nombre";
		objForm.DRNnombre.validateAlfaNumerico();
		objForm.DRNnombre.validate = true;
		objForm.DRNapellido1.required = true;
		objForm.DRNapellido1.description = "Primer Apellido";
		objForm.DRNapellido1.validateAlfaNumerico();
		objForm.DRNapellido1.validate = true;
		objForm.DRNapellido2.required = true;
		objForm.DRNapellido2.description = "Segundo Apellido";
		objForm.DRNapellido2.validateAlfaNumerico();
		objForm.DRNapellido2.validate = true;
		objForm.DRNtipopago.required = true;
		objForm.DRNtipopago.description = "Tipo de pago";
		objForm.DRNtipopago.validateAlfaNumerico();
		objForm.DRNtipopago.validate = true;
		objForm.DRNperiodo.required = true;
		objForm.DRNperiodo.validateAlfaNumerico();
		objForm.DRNperiodo.validate = true;
		objForm.DRNperiodo.description = "Periodo de pago";
		objForm.DRNnumdias.required = true;
		objForm.DRNnumdias.description = "Número de días que paga";
		objForm.DRNnumdias.validateNumeric("El valor para " + objForm.DRNnumdias.description + " debe ser numérico.");
		objForm.DRNnumdias.validate = true;
		objForm.DRNotrasdeduc.required = true;
		objForm.DRNotrasdeduc.description = "Otras Deducciones";
		objForm.DRNliquido.required = true;
		objForm.DRNliquido.description = "Salario";
		objForm.DRNliquido.validateRango('0','999999999');
		objForm.DRNliquido.validate = true;
		//objForm.DRNpuesto.required = true;
		objForm.DRNpuesto.description = "Puesto";
		objForm.DRNpuesto.validateAlfaNumerico();
		objForm.DRNpuesto.validate = true;
		objForm.DRNocupacion.required = true;
		objForm.DRNocupacion.description = "Ocupación";
		objForm.DRNocupacion.validateAlfaNumerico();
		objForm.DRNocupacion.validate = true;
		objForm.DRNotrospatrono.required = true;
		objForm.DRNotrospatrono.description = "Otros Pagos Patrono";
		//Si se marcan incluir o excluir
		objForm.DRNfinclexcl.description = "Fecha Inclusión/Exclusión";
		objForm.NTIcodigo.obj.focus();
	</cfif>
</script>