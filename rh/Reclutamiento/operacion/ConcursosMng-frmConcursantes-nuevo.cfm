<script language="javascript" type="text/javascript">
	function showConcursante(v) {
		var a = document.getElementById("trInterno");
		var b = document.getElementById("trExterno");
		if (v.value == 'I') {
			if (a) a.style.display = "";
			if (b) b.style.display = "none";
			document.form1.RHOid2.value = "";
			document.form1.RHOidentificacion2.value = "";
			document.form1.NombreOferente2.value = "";
		} else if (v.value == 'E') {
			if (a) a.style.display = "none";
			if (b) b.style.display = "";
			document.form1.DEid1.value = "";
			document.form1.DEidentificacion1.value = "";
			document.form1.NombreEmp1.value = "";
		}
	}
</script>

<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="2">&nbsp;</td>
	    <td>&nbsp;</td>
	    <td width="2">&nbsp;</td>
      </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>
			<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td>&nbsp;<strong><cf_translate key="LB_NUEVOCONCURSANTE">NUEVO CONCURSANTE</cf_translate></strong></td>
					<td align="right" width="25" onMouseOver="javascript: this.style.cursor = 'pointer';">&nbsp;</td>
				  </tr>
				</table>
			</fieldset>
		</td>
	    <td>&nbsp;</td>
      </tr>
	  <tr>
		<td>&nbsp;</td>
		<td valign="top">
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<form name="form1" method="post" action="ConcursosMng-sql.cfm">
					<cfinclude template="ConcursosMng-hiddens.cfm">
					<input type="hidden" name="op" value="0">
				  <div id="divNuevo" style="overflow:auto; height: #tamVentanaConcursantes#; margin:0;" >
					<table width="99%" border="0" cellspacing="0" cellpadding="2">
					  <tr style="height: 25;">
						<td width="30%" align="right" nowrap>
							<strong><cf_translate key="LB_TipoDeConcursante">Tipo de Concursante</cf_translate>:</strong>
						</td>
						<td width="10%" align="right" nowrap>
							<input name="TipoConcursante" id="TipoConcursante" type="radio" value="I" onClick="javascript: showConcursante(this);" <cfif (isdefined("Form.TipoConcursante") and Form.TipoConcursante EQ 'I') or not isdefined("Form.TipoConcursante")>checked</cfif>></td>
						<td width="25%" nowrap><cf_translate key="LB_Interno">Interno</cf_translate></td>
						<td width="10%" align="right" nowrap>
							<input name="TipoConcursante" id="TipoConcursante" type="radio" value="E" onClick="javascript: showConcursante(this);" <cfif isdefined("Form.TipoConcursante") and Form.TipoConcursante EQ 'E'>checked</cfif>></td>
						<td width="25%" nowrap><cf_translate key="LB_Externo">Externo</cf_translate></td>
					  </tr>
					  <tr id="trInterno" style="display: none; height: 25;">
						<td colspan="5" align="center" nowrap>
							<cf_rhempleado size="35" index="1">
						</td>
					  </tr>
					  <tr id="trExterno" align="center" style="display: none; height: 25;">
						<td colspan="5" nowrap>
							<cf_rhoferente size="35" index="2">
						</td>
					  </tr>
					</table>
				  </div>
					<table width="99%" border="0" cellspacing="0" cellpadding="2">
					  <tr style="height: 25;">
						<td align="center" valign="middle" nowrap>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Agregar"
								Default="Agregar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Agregar"/>
							<input type="submit" name="btnAgregar" value="#BTN_Agregar#">
						</td>
					  </tr>
					</table>
				</form>
			</fieldset>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
      </tr>
	</table>
</cfoutput>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concursante"
	Default="LB_Concursante" 
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Concursante"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnConcursanteInterno"
	Default="Debe seleccionar un Concursante Interno" 
	returnvariable="MSG_DebeSeleccionarUnConcursanteInterno"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnConcursanteExterno"
	Default="Debe seleccionar un Concursante Externo" 
	returnvariable="MSG_DebeSeleccionarUnConcursanteExterno"/>

<script language="javascript" type="text/javascript">
	function fnX(){
		if (!objForm._allowSubmitOnError) {
			objForm.DEid1.description = "<cfoutput>#LB_Concursante#</cfoutput>";
			objForm.RHOid2.description = "<cfoutput>#LB_Concursante#</cfoutput>";
			if (objForm.TipoConcursante.getValue() == "I" && objForm.DEid1.getValue() == "")
				objForm.DEid1.throwError('<cfoutput>#MSG_DebeSeleccionarUnConcursanteInterno#</cfoutput>');
			if (objForm.TipoConcursante.getValue() == "E" && objForm.RHOid2.getValue() == "")
				objForm.RHOid2.throwError('<cfoutput>#MSG_DebeSeleccionarUnConcursanteExterno#</cfoutput>');
		}
	}

	 showConcursante(document.getElementById("TipoConcursante"));
</script>
<cf_qforms form="form1" onValidate="fnX"></cf_qforms>
