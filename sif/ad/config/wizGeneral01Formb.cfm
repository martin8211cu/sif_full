<!--- FUNCIÓN QUE DEVUELVE LOS NOMBRE DE LOS MESES --->
<cffunction name="getMesNombre" access="public" output="false"  returntype="string">
<cfargument name="numMes" default="#Month(Now())#" hint="Número de Mes" type="numeric">
	<cfswitch expression="#Arguments.numMes#">
		<cfcase value="1">
			<cfset returnValue = "Enero">
		</cfcase>
		<cfcase value="2">
			<cfset returnValue = "Febrero">
		</cfcase>
		<cfcase value="3">
			<cfset returnValue = "Marzo">
		</cfcase>
		<cfcase value="4">
			<cfset returnValue = "Abril">
		</cfcase>
		<cfcase value="5">
			<cfset returnValue = "Mayo">
		</cfcase>
		<cfcase value="6">
			<cfset returnValue = "Junio">
		</cfcase>
		<cfcase value="7">
			<cfset returnValue = "Julio">
		</cfcase>
		<cfcase value="8">
			<cfset returnValue = "Agosto">
		</cfcase>
		<cfcase value="9">
			<cfset returnValue = "Setiembre">
		</cfcase>
		<cfcase value="10">
			<cfset returnValue = "Octubre">
		</cfcase>
		<cfcase value="11">
			<cfset returnValue = "Noviembre">
		</cfcase>
		<cfcase value="12">
			<cfset returnValue = "Diciembre">
		</cfcase>
	</cfswitch>
	<cfreturn returnValue>
</cffunction>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<!--- año actual --->
<cfset ano = DatePart('yyyy', Now()) >
<cfset desde = ano - 1>
<cfset hasta = ano + 2>

<cfoutput>
<form name="form1" action="wizGeneral02.cfm" enctype="multipart/form-data" method="post">
<table width="90%" align="center"  border="0" cellspacing="2" cellpadding="2">
  <tr>
    <td>
		<fieldset><legend>Periodo y Mes Contables:</legend>
			<table border="0" width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top" width="40%">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td width="50%" class="etiquetaCampo" align="right" nowrap>Periodo:</td>
								<td width="50%" align="left" nowrap>
									<select name="periodo">
										<cfloop index="i" from="#desde#" to="#hasta#">
											<option value="#i#" <cfif isdefined("form.periodo")><cfif form.periodo eq i >selected</cfif><cfelseif ano eq i>selected</cfif>  >#i#</option>
										</cfloop>
									</select>  
								</td>
							</tr>
							<tr>
								<td class="etiquetaCampo" align="right" nowrap>Mes:</td>
								<td align="left" nowrap>
									<select name="mes">
										<cfloop index="i" from="1" to="12">
											<option value="#i#" <cfif isdefined("form.mes") and form.mes eq i>selected</cfif>>#getMesNombre(i)#</option>
										</cfloop>
									</select>
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" width="60%">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td class="textoAyuda" width="60%" rowspan="2">
									<blockquote>
									<p>La operaci&oacute;n del Sistema Financiero Integral se basa en un modelo de cierre mensual contable, para efecto del registro de las p&oacute;lizas contables y la generaci&oacute;n de estados financieros mensuales.
									Favor indique	el	<strong>periodo</strong> (a&ntilde;o fiscal) y el <strong>mes</strong> (mes fiscal) en que se iniciar&aacute; con la operaci&oacute;n del sistema. Una vez definido este periodo y mes se generar&aacute;n saldos iniciales en cero para todas las cuentas de arranque y se sugiere abrir la operaci&oacute;n con una p&oacute;liza de apertura de la empresa, donde se indiquen los movimientos por cuenta contable seg&uacute;n su naturaleza.</p>
									</blockquote>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</fieldset>
	</td>
    <td rowspan="6" valign="top">&nbsp;</td>
    <td rowspan="6" valign="top"><cfset thisForm=1><cfinclude template="frame-Progreso.cfm"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>
		<fieldset><legend>Periodo y Mes Auxiliares:</legend>
			<table border="0" width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top" width="40%">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td width="50%" class="etiquetaCampo" align="right" nowrap>Periodo:</td>
								<td width="50%" align="left" nowrap>
									<select name="periodoAux">
										<cfloop index="i" from="#desde#" to="#hasta#">
											<option value="#i#" <cfif isdefined("form.periodoAux")><cfif form.periodoAux eq i >selected</cfif><cfelseif ano eq i>selected</cfif>  >#i#</option>
										</cfloop>
									</select>  
								</td>
							</tr>
							<tr>
								<td class="etiquetaCampo" align="right" nowrap>Mes:</td>
								<td align="left" nowrap>
									<select name="mesAux">
										<cfloop index="i" from="1" to="12">
											<option value="#i#" <cfif isdefined("form.mesAux") and form.mesAux eq i>selected</cfif>>#getMesNombre(i)#</option>
										</cfloop>
									</select>
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" width="60%">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td class="textoAyuda" width="60%" rowspan="2">
									<blockquote>
									<p>Al igual que el m&oacute;dulo de contabilidad, los auxiliares contables manejan su propio periodo y mes de operaci&oacute;n. El <strong>periodo</strong> y <strong>mes</strong> de auxiliares (el cual es el mismo para todos los sistemas perif&eacute;ricos a la contabilidad), nunca podr&aacute; ser menor al periodo y mes de la contabilidad. Favor indique estos par&aacute;metros de arranque de los auxiliares. </p>
								  </blockquote>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</fieldset>
	</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>
		<fieldset><legend>Mes Fiscal:</legend>
			<table border="0" width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top" width="40%">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td width="50%" class="etiquetaCampo" align="right" nowrap>Mes:</td>
								<td width="50%" align="left" nowrap>
									<select name="mesFiscal">
										<cfloop index="i" from="1" to="12">
											<option value="#i#" <cfif isdefined("form.mesFiscal") and form.mesFiscal eq i>selected</cfif>>#getMesNombre(i)#</option>
										</cfloop>
									</select>
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" width="60%">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td class="textoAyuda" width="60%" rowspan="2">
									<blockquote>
									<p>Como parte de la legislaci&oacute;n tributaria y fiscal de cada pa&iacute;s, es necesario definir el &uacute;ltimo <strong>mes</strong> contable sobre el cual se realizar&aacute; el cierre anual de operaci&oacute;n de la compa&ntilde;&iacute;a. Favor indicar el mes donde se realizar&aacute; el corte anual, seg&uacute;n su pa&iacute;s. </p>
								  </blockquote>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</fieldset>
	</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td align="center"><input name="Siguiente" type="submit" value="Siguiente >>"></td>
    <td rowspan="8" valign="top">&nbsp;</td>
    <td rowspan="8" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function _MenorPeriodoMes(){
		if (objForm.periodo.getValue()+objForm.mes.getValue()<objForm.periodoAux.getValue()+objForm.mesAux.getValue())
			this.error="El periodo y mes auxiliares deben ser menor al periodo y mes de la contabilidad.";
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
