<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//función que valida antes de Aplicar
	function funcAplicar() {
		if (confirm('¿Está seguro que desea Aplicar esta Relación de Cálculo Especial de Nómina?'))
			return true;
		return false;
	}
</script>
<form action="ResultadoCalculoEsp-aplicarSql.cfm" method="post" name="form1">
	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td nowrap class="fileLabel" colspan="2">
				Seleccione la Cuenta Cliente a Debitar para el pago de la Nómina!
			</td>
		</tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<!--- Cuenta Cliente --->
		<tr>
			<td nowrap class="fileLabel" align="right" width="20%">
				Cuenta Cliente:&nbsp;
			</td>
			<td nowrap width="80%">
				<cf_sifCuentaCliente tabindex="1" vMcodigo="#rsRelacionCalculo.Mcodigo#">
			</td>
		</tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr><td nowrap colspan="2" align="center">
			<input type="submit" name="butAplicar" id="butAplicar" value="Aplicar" onClick="javascript: return funcAplicar();">
		</td></tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
	</table>
	<input type="hidden" name="RCNid" value="<cfoutput>#Form.RCNid#</cfoutput>">
</form>
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
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
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	//Validaciones del Encabezado
	objForm.CBcc.required = true;
	objForm.CBcc.description = "Cuenta Cliente";
	objForm.CBcc.validateAlfaNumerico();
	objForm.CBcc.validate = true;
	objForm.CBcc.obj.focus();
</script>
