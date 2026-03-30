<cffunction name="getMeses" access="public" output="false"  returntype="query">
	<cfquery name="rs" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as LOCEcodigo, b.VSdesc as LOCEetiqueta
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		and a.Iid = b.Iid
		order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
	</cfquery>
	<cfreturn rs>
</cffunction>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cfoutput>

<style type="text/css">
select {  background-color: ##FAFAFA; font-size:12px; }
</style>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="3">&nbsp;</td></tr>

	<tr>
		<!---
		<td class="textoAyuda" width="25%" valign="top">
			Para crear una nueva <strong>empresa</strong> por favor complete el siguiente formulario.<br><br>
			Debe asegurarse de que el <strong>cache</strong> escogido sea el correcto ya que una vez guardados los datos de la empresa, el cache <strong>NO</strong> puede ser modificado.<br><br>
			Después de haber llenado el formulario, haga click en <font color="##0000FF">Siguiente >></font> para continuar.<br><br>
			Si desea trabajar con una empresa diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Empresa</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		</td>
		--->
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">
			<form name="form1" action="wizGeneral02.cfm" enctype="multipart/form-data" method="post">

				<!--- año actual --->
				<cfset ano = DatePart('yyyy', Now()) >
				<cfset desde = ano - 1>
				<cfset hasta = ano + 2>
				
				<!--- meses --->
				<cfset rsMes = getMeses() >

				<table border="0" width="95%" cellpadding="4" cellspacing="0" align="center">
					<tr>
					<td align="center">
						<fieldset><legend><b><font size="2">Per&iacute;odo y Mes Contables</font></b></legend>
						<table border="0" width="100%" cellpadding="4" cellspacing="0">
						<tr>
							<td class="etiquetaCampoSIF" width="1%" nowrap>Per&iacute;odo:</td>
							<td align="left" nowrap width="1%">
								<select name="periodo">
									<cfloop index="i" from="#desde#" to="#hasta#">
										<option value="#i#" <cfif isdefined("form.periodo")><cfif form.periodo eq i >selected</cfif><cfelseif ano eq i>selected</cfif>  >#i#</option>
									</cfloop>
								</select>  
							</td>
							<td class="etiquetaCampoSIF" align="right" width="5%" nowrap>Mes:</td>
							<td align="left" nowrap>
								<select name="mes">
									<cfloop query="rsMes">
										<option value="#rsMes.LOCEcodigo#" <cfif isdefined("form.mes") and form.mes eq rsMes.LOCEcodigo>selected</cfif>>#rsMes.LOCEetiqueta#</option>
									</cfloop>
								</select>
							</td>
						  </tr>
							<tr>
							<td colspan="4" class="ayuda">
								<div align="left">
								    <p>La operaci&oacute;n del Sistema Financiero Integral se basa en un modelo de cierre mensual contable, para efecto del registro de las p&oacute;lizas contables y la generaci&oacute;n de estados financieros mensuales. Indique el <strong>per&iacute;odo</strong> (a&ntilde;o fiscal) y el <strong>mes</strong> (mes fiscal) en que se iniciar&aacute; con la operaci&oacute;n del sistema. Una vez definido este per&iacute;odo y mes se generar&aacute;n saldos iniciales en cero para todas las cuentas de arranque y se sugiere abrir la operaci&oacute;n con una p&oacute;liza de apertura de la empresa, donde se indiquen los movimientos por cuenta contable seg&uacute;n su naturaleza.</p>
							  </div></td>
						  </tr>
						</table>
					  </fieldset>
					  </td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					<td align="center">
						<fieldset><legend><b><font size="2">Per&iacute;odo y Mes Auxiliares</font></b></legend>
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
						<tr>
						<td width="1%" class="etiquetaCampoSIF" align="right" nowrap>Per&iacute;odo:</td>
						<td width="1%" align="left" nowrap>
							<select name="periodoAux">
								<cfloop index="i" from="#desde#" to="#hasta#">
									<option value="#i#"  <cfif isdefined("form.periodoAux")><cfif form.periodoAux eq i >selected</cfif><cfelseif ano eq i>selected</cfif> >#i#</option>
								</cfloop>
							</select>  
						</td>
						<td width="5%" class="etiquetaCampoSIF" align="right" nowrap>Mes:</td>
						<td align="left" nowrap>
								<select name="mesAux">
									<cfloop  query="rsMes">
										<option value="#rsMes.LOCEcodigo#" <cfif isdefined("form.mesAux") and form.mesAux eq rsMes.LOCEcodigo>selected</cfif>>#rsMes.LOCEetiqueta#</option>
									</cfloop>
								</select>
						  </td>
						  </tr>
							<tr>
							<td colspan="4" class="ayuda">
							  <div align="left">
							      <p>Al igual que el m&oacute;dulo de contabilidad, los auxiliares contables manejan su propio per&iacute;odo y mes de operaci&oacute;n. El <strong>per&iacute;odo</strong> y <strong>mes</strong> de auxiliares (el cual es el mismo para todos los sistemas perif&eacute;ricos a la contabilidad), nunca podr&aacute; ser menor al per&iacute;odo y mes de la contabilidad. Indique estos par&aacute;metros de arranque de los auxiliares. </p>
							  </div></td>
						  </tr>
						</table>
					  </fieldset>
					  </td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					<td align="center">
						<fieldset><legend><b><font size="2">Mes Fiscal</font></b></legend>
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
						<tr>
						<td width="1%" class="etiquetaCampoSIF" align="right" nowrap>Mes:</td>
						<td width="50%" align="left" nowrap>
								<select name="mesFiscal">
									<cfloop  query="rsMes">
										<option value="#rsMes.LOCEcodigo#" <cfif isdefined("form.mesFiscal") and form.mesFiscal eq rsMes.LOCEcodigo>selected</cfif>>#rsMes.LOCEetiqueta#</option>
									</cfloop>
								</select>
						</td>
						</tr>
						<tr>
							<td colspan="2" class="ayuda"> <div align="left">
							    <p>Como parte de la legislaci&oacute;n tributaria y fiscal de cada pa&iacute;s, es necesario definir el &uacute;ltimo <strong>mes</strong> contable sobre el cual se realizar&aacute; el cierre anual de operaci&oacute;n de la compa&ntilde;&iacute;a. Indique el mes donde se realizar&aacute; el corte anual. </p>
							</div></td>
						</tr>
						</table>
						</fieldset>
					  </td>
					</tr>
					<tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center"><input name="Siguiente" type="submit" value="Siguiente >>"></td></tr>
				</table>
			</form>
		</td>
			
		<td width="1%" valign="top">
			<cfset thisForm = 1>
			<cfinclude template="frame-Progreso.cfm">
		</td>
	</tr>
</table>
</cfoutput>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function _MenorPeriodoMes(){
		var mensaje = 'El período y mes auxiliares deben ser mayores ó iguales al período y mes de la contabilidad.';
		if ( objForm.periodo.getValue() == objForm.periodoAux.getValue() ){
			if ( objForm.mes.getValue() > objForm.mesAux.getValue()  ){
				this.error=mensaje;
			}
		}
		else if( objForm.periodo.getValue() > objForm.periodoAux.getValue() ) {
			this.error=mensaje;
		}	
	}
	
	_addValidator("isMenorPeriodoMes", _MenorPeriodoMes);
	
	objForm.periodo.required = true;
	objForm.periodo.description = "Periodo";
	
	objForm.mes.required = true;
	objForm.mes.description = "Mes";
	
	objForm.periodoAux.required = true;
	objForm.periodoAux.description = "Periodo Auxiliar";
	objForm.periodoAux.validateMenorPeriodoMes();
	
	objForm.mesAux.required = true;
	objForm.mesAux.description = "Mes Auxiliar";
	
	objForm.mesFiscal.required = true;
	objForm.mesFiscal.description = "Mes Fiscal";

	function habilitarValidacion() {
		objForm.periodo.required = true;
		objForm.mes.required = true;
		objForm.periodoAux.required = true;
		objForm.mesAux.required = true;
		objForm.mesFiscal.required = true;
	}

	function deshabilitarValidacion() {
		objForm.periodo.required = false;
		objForm.mes.required = false;
		objForm.periodoAux.required = false;
		objForm.mesAux.required = false;
		objForm.mesFiscal.required = false;
	}
</script>
