
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

<cfif isdefined("url.id") and Len("url.id") gt 0>
	<cfset form.id = url.id >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.id") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="rsPromocion" datasource="#Session.DSN#">
		SELECT id,codigo,Descripcion,Monto,FechaDesde,FechaHasta,Porciento, 
				aplicaVales,aplicaTC,aplicaTM
		FROM CRCPromocionCredito
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
</cfif>

<!--- <SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT> --->


<script language="JavaScript">

	function deshabilitarValidacion(){
		objForm.Codigo.required = false;
		objForm.Descripcion.required = false;
		objForm.FechaDesde.required = false;
		objForm.FechaHasta.required = false;
		objForm.Monto.required = false;
	}

</script>
<cfoutput>


<!---Redireccion ConfiguracionParametros_sql.cfm --->
<form method="post" name="form1" action="PromocionCredito_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right">#LB_Codigo#:&nbsp;</td>
			<td>
				<input type="text" name="Codigo" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsPromocion.Codigo#</cfif>"
				size="10" maxlength="10" onfocus="javascript:this.select();" required <cfif isdefined("rsPromocion.Codigo") and #rsPromocion.Codigo# neq ""> readonly </cfif>>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Descripcion#:&nbsp;</td>
			<td>
				<input type="text" name="Descripcion" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsPromocion.Descripcion#</cfif>"
				size="30" maxlength="250" onfocus="javascript:this.select();" required>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_FechaDesde#:&nbsp;</td>
			<td>
				<cfset fechaDesde = "">
				<cfif modo NEQ 'ALTA'><cfset fechaDesde = rsPromocion.FechaDesde></cfif>
				<cf_sifcalendario form="form1" value="#fechaDesde#" name="FechaDesde" tabindex="1" obligatorio="1">
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_FechaHasta#:&nbsp;</td>
			<td>
				<cfset fechaHasta = "">
				<cfif modo NEQ 'ALTA'><cfset fechaHasta = rsPromocion.FechaHasta></cfif>
				<cf_sifcalendario form="form1" value="#fechaHasta#" name="FechaHasta" tabindex="1" obligatorio="1">
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Monto#:&nbsp;</td>
			<td>
				<input type="text" name="Monto" id="Monto" tabindex="1" class="decimalInput" onchange="validarInput()" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(rsPromocion.Monto,'0.00')#</cfif>"
				size="10" maxlength="18" onfocus="javascript:this.select();" required>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Porciento#:&nbsp;</td>
			<td>
				<input type="checkbox" id="Porciento" name="Porciento" onclick="validaMonto()"
					<cfif modo eq 'CAMBIO' and rsPromocion.Porciento eq 1> checked </cfif>>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Aplica para:&nbsp;</td>
			<td>
	  			<input tabindex="1" name="aplicaVales" <cfif modo neq "CAMBIO" or (isdefined("rsPromocion") and rsPromocion.aplicaVales eq 1)>checked=""</cfif> type="checkbox">
					<strong>Distribuidor</strong> &nbsp;
				<input tabindex="1" name="aplicaTC" <cfif modo neq "CAMBIO" or (isdefined("rsPromocion") and rsPromocion.aplicaTC eq 1)>checked=""</cfif> type="checkbox">
		    		<strong>Tarjetahabiente</strong>&nbsp;
				<input tabindex="1" name="aplicaTM" <cfif modo neq "CAMBIO" or (isdefined("rsPromocion") and rsPromocion.aplicaTM eq 1)>checked=""</cfif> type="checkbox">
					<strong>Mayorista</strong>
			</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap>
				<div align="center">
					<script language="JavaScript" type="text/javascript">
						// Funciones para Manejo de Botones
						botonActual = "";

						function setBtn(obj) {
							botonActual = obj.name;
						}
						function btnSelected(name, f) {
							if (f != null) {
								return (f["botonSel"].value == name)
							} else {
								return (botonActual == name)
							}
						}
					</script>

					<input tabindex="-1" type="hidden" name="botonSel" value="">
					<input tabindex="-1" name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
					<cf_botones modo="#modo#">	
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="id" value="<cfif modo NEQ "ALTA">#rsPromocion.id#</cfif>">
			<input tabindex="-1" type="hidden" name="Pagina"
			value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
			<cfif modo NEQ "ALTA">
				<td colspan="2" align="right" nowrap>
					<div align="center">
					</div>
				</td>
			</cfif>
		</tr>
	</table>
</form>
</cfoutput>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Descripcion" Default="Descripci�n" XmlFile="/crc/generales.xml" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Titulo" Default="Titulo" XmlFile="/crc/generales.xml" returnvariable="MSG_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Orden" Default="Orden" XmlFile="/crc/generales.xml" returnvariable="MSG_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DescuentoInicial" Default="% Descuento Inicial" XmlFile="/crc/generales.xml" returnvariable="MSG_DescuentoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_PenalizacionInicial" Default="% Penalizacion por Dia" XmlFile="/crc/generales.xml" returnvariable="MSG_PenalizacionInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Monto" Default="Monto" XmlFile="/crc/generales.xml" returnvariable="MSG_Monto"/>

<!---
<cf_qforms>
	<cf_qformsRequiredField name="Orden" description="#MSG_Orden#">
	<cf_qformsRequiredField name="Descripcion" description="#MSG_Descripcion#">
	<cf_qformsRequiredField name="Titulo" description="#MSG_Titulo#">
	<cf_qformsRequiredField name="Monto" description="#MSG_Monto#">
	<cf_qformsRequiredField name="Porcentaje_Descuento_Inicial" description="#MSG_DescuentoInicial#">
	<cf_qformsRequiredField name="Porcentaje_Penalizacion_Dia" description="#MSG_PenalizacionInicial#">
</cf_qforms> --->

<script type="text/javascript">
	function soloNumeros(e)
	{
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 0))
		return true;
		return /\d/.test(String.fromCharCode(keynum));
	}

	$('.decimalInput').keypress(function(eve) {
  		if ((eve.which != 8 && eve.which != 0) && (eve.which != 46 || $(this).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(this).caret().start == 0) ) {
	    	eve.preventDefault();
	  	}
	});

	// this part is when left part of number is deleted and leaves a . in the leftmost position. For example, 33.25, then 33 is deleted
 	$('.decimalInput').keyup(function(eve) {
  		if($(this).val().indexOf('.') == 0) {
  			$(this).val($(this).val().substring(1));
  		}
 	});
	
	function funcAlta() {
		console.log('exec');
		var fechaDesde = document.getElementsByName('FechaDesde')[0].value.split('/');
		var fechaHasta = document.getElementsByName('FechaHasta')[0].value.split('/');
		
		var FechaIni = new Date(fechaDesde[2],fechaDesde[1] - 1,fechaDesde[0]);
		var FechaFin = new Date(fechaHasta[2],fechaHasta[1] - 1,fechaHasta[0]);
		
		
		if(FechaIni > FechaFin){
			alert("La fecha de INICIO es posterior a la fecha FINAL");
			return false;
		}
		return true; // return false to cancel form action
	};
	
	function funcCambio() {
		console.log('exec');
		var fechaDesde = document.getElementsByName('FechaDesde')[0].value.split('/');
		var fechaHasta = document.getElementsByName('FechaHasta')[0].value.split('/');
		
		var FechaIni = new Date(fechaDesde[2],fechaDesde[1] - 1,fechaDesde[0]);
		var FechaFin = new Date(fechaHasta[2],fechaHasta[1] - 1,fechaHasta[0]);
		
		
		if(FechaIni > FechaFin){
			alert("ALERTA:<br/>La FECHA DE INICIO debe ser previa a la FECHA DE FINAL");
			return false;
		}
		return true; // return false to cancel form action
	};

	function validaMonto(){
		var mnt = document.getElementById("Monto").value;
		mnt = parseFloat(mnt);

		if(mnt > 100){
			alert("El monto no puede ser mayor a 100");
			document.getElementById("Monto").value = 100.00;
		}
	}
	function validarInput(){
		if (document.getElementById('Porciento').checked){
			validaMonto();
		}
	}
	
</script>


