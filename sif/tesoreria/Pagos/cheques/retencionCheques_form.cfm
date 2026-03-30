<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 09 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Retención de cheques
----------->

<cfset titulo = 'Retención de Cheques'>
<cfset tipoCheque = '= 1'>
<cfoutput>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<form action="retencionCheques_sql.cfm" method="post" name="form1" id="form1" style="margin:none;">
		<cfset LvarDatosChequesDet = true>
		<cfinclude template="datosCheques.cfm">
		<table border="0" width="50%" align="center">
			<tr>
				<td align="right" >
					<strong>Retener hasta:</strong>
				</td>
				<td>
					<cf_sifcalendario form="form1" name="fechaRet" tabindex="1"
						value="#LSDateFormat(rsForm.TESCFDfechaRetencion,'dd/mm/yyyy')#"
						onChange="funcfechaRet(this);">
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>
				<td colspan="4" class="formButtons" align="center">
					<input name="Retener" 	type="submit" value="Retener" tabindex="1"
						onClick="return fnProcessRetener();"
					>
					<input name="Lista_Cheques" type="button" id="btnSelFac" value="Lista Cheques" tabindex="1"
						onClick="location.href='retencionCheques.cfm';"
					>
				</td>
			</tr>
		</table>
		<cfinclude template="datosChequesDet.cfm">
	</form>
	<cf_web_portlet_end>
</cfoutput>
<cf_qforms form="form1" objForm="objForm">
<script language="javascript">
	objForm.fechaRet.required = true;
	objForm.fechaRet.description = "Fecha de Retención";

	function fnProcessRetener(){
		var now = today();
		var fecharet = document.form1.fechaRet.value;
		if (toFecha(fecharet) < now){
			alert('La fecha de Retención debe ser posterior al día de hoy.');
			return false;
		}else if (confirm('¿Desea RETENER el cheque # <cfoutput>#rsform.TESCFDnumFormulario#</cfoutput>?')){
			return true;
		}else
			return false;
	}
	
	function funcfechaRet(fecharet){
		var now = today();
		if (toFecha(fecharet.value) < now){
			alert('La fecha debe ser posterior al día de hoy.');
			return false;
		}
	}
	document.form1.fechaRet.focus();
</script>
