<!--- Consultas --->
<!--- Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a, RCalculoNomina b, TiposNomina c 
	where b.Tcodigo = c.Tcodigo 
		and a.Mcodigo = c.Mcodigo 
		and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>
<cfquery name="rsSE" datasource="#Session.DSN#">
	select SEcalculado
	from SalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<!---================== TRADUCCION =================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Si_realiza_la_modificacion_se_recalculara_la_nomina_Esta_Seguro_que_desea_Modificar"
	Default="Si realiza la modificación, se recalculará la nómina!.\n\n¿Esta Seguro que desea Modificar?"	
	returnvariable="MSG_RecalculoPorModificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Si_realiza_alguna_modificacion_se_recalculara_la_nomina_Esta_seguro_que_desea_Eliminar_los_Registros_Seleccionados"
	Default="Si realiza alguna modificación, se recalculará la nómina!.\n\n¿Está seguro que desea Eliminar los Registros Seleccionados?"	
	returnvariable="MSG_RecalculoPorEliminacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Esta_seguro_que_desea_Eliminar_los_Registros_Seleccionados"
	Default="¿Está seguro que desea Eliminar los Registros Seleccionados?"	
	returnvariable="MSG_EliminaRegistros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Seleccione_el_Registro_que_desea_eliminar"
	Default="¡Seleccione el Registro que desea eliminar!"	
	returnvariable="MSG_EliminaRegistros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroQueDeseaRestaurarEsteEmpleadoEnLaRelacionDeCalculoNotaSiRestauraTodosLosRegistrosEliminadosEnEstaPantallaSeranRestaurados"
	Default="¿Está seguro que desea Restaurar este Empleado en la Relación de Cálculo?\n\nNota: Si Restaura todos los Registros Eliminados en esta pantalla, serán Restaurados."	
	returnvariable="MSG_RestaurarEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar_Incidencia"
	Default="Agregar Incidencia"
	returnvariable="BTN_Agregar_Incidencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar_Deducccion"
	Default="Agregar Deduccci&oacute;n"
	returnvariable="BTN_Agregar_Deducccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Restaurar"
	Default="Restaurar"
	returnvariable="BTN_Restaurar"/>

<cfinvoke Key="BTN_Regresar" Default="Regresar" XmlFile="/rh/generales.xml" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate"/>

<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;
	//Cuando SEcalulado está en 1=Listo, Modificar cualquier dato implica que este estqado cambiará
	//a 0, lo que implica que está relación por completo ya no podrá ser aplicada. A menos que Recalcule.
	//confirmado se consulta para pedir confirmación al usuario antes de hacer cualquier modificación,
	//cuando el SEcalulado esté en 1.
	var confirmado=(<cfoutput>#rsSE.SEcalculado#</cfoutput>!=1)
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		if (name == null) {
		name = 'popUpWin'
		}
		popUpWin = open(URLStr, name, 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	<cfoutput>
	function btnAgregarIncidencia(paramAdic) {
		//Confirma
		if (confirmado || confirm("#MSG_RecalculoPorModificacion#")) {
			var params = "?Tcodigo=#Form.Tcodigo#&frame=IN&RCNid=#Form.RCNid#&DEid=#Form.DEid#";
			if (paramAdic!=null) params += paramAdic;
			popUpWindow("ResultadoModifyEsp-form.cfm"+params,250,200,650,350, 'wDeduccion');
		}
		return false;
	}
	function btnAgregarDeduccion(paramAdic) {
		//Confirma
		if (confirmado || confirm("#MSG_RecalculoPorModificacion#")) {
			var params = "?Tcodigo=#Form.Tcodigo#&frame=DE&RCNid=#Form.RCNid#&DEid=#Form.DEid#";
			if (paramAdic!=null) params += paramAdic;
			popUpWindow("ResultadoModifyEsp-form.cfm"+params,250,200,650,500);
		}
		return false;
	}
	
	function btnModificarIncidencia(ICid) {
		var param = "&ICid="+ICid;
		//Confirma
		if (confirmado || confirm("#MSG_RecalculoPorModificacion#"))
			btnAgregarIncidencia(param);
	}
	function btnModificarDeduccion(Did) {
		var param = "&Did="+Did;
		//Confirma
		if (confirmado || confirm("#MSG_RecalculoPorModificacion#"))
			btnAgregarIncidencia(param);
	}
	function btnEliminarChecked() {
		var form = document.form1;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (result) {
			//Confirma
			if (!confirmado){			
				if (!confirm('#MSG_RecalculoPorEliminacion#'))
					result = false;
			}
			else if (!confirm('#MSG_EliminaRegistros#'))
				result = false;
		}
		else
			alert('#MSG_EliminaRegistros#');
		return result;
	}
	function btnRestaurar() {
		if (confirm("#MSG_RestaurarEmpleado#"))
			return true;
		return false;
	}
	</cfoutput>
</script>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<cf_templatecss>
<table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
  <!--- Los include se hacen fuera de tr y td para mantener el alineamiento de las columnas --->
  <tr>
	<td nowrap colspan="9" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>">
		<div align="center"><cf_translate key="LB_InformacionResumida">Informaci&oacute;nResumida</cf_translate></div>
	</td>
  </tr>
  <cfinclude template="frame-SalarioEmpleado.cfm"><!--- Información Resumida --->
</table>
<br>
<form action="PTU-ResultadoCalculoTab5-sql.cfm" method="post" name="form1">
  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
    <tr> 
      <td nowrap colspan="9" bgcolor="#EEEEEE">
	  	<div align="center"><strong><font color="#666666"><cf_translate key="LB_Informacion_Detallada">Informaci&oacute;n Detallada</cf_translate></font></strong></div>
	</td>
    </tr>
    <cfinclude template="frame-PagosEmpleado.cfm"></td>
    <!--- Salarios --->
    <tr valign="top"> 
      <td nowrap colspan="9">&nbsp;</td>
    </tr>
    <cfinclude template="frame-IncidenciasCalculo.cfm"></td>
    <!--- Incidencias --->
    <tr valign="top"> 
      <td nowrap colspan="9">&nbsp;</td>
    </tr>
    <cfinclude template="frame-CargasCalculo.cfm"></td>
    <!--- Cargas --->
    <tr valign="top"> 
      <td nowrap colspan="9">&nbsp;</td>
    </tr>
    <cfinclude template="frame-DeduccionesCalculo.cfm"></td>
    <tr valign="top"> 
      <td nowrap colspan="9">&nbsp;</td>
    </tr>
	<cfif rsSE.SEcalculado neq 1>
    <!--- Deducciones --->
    <tr valign="top"> 
      <td nowrap colspan="9"><div align="center"><font color="#FF0000">&iexcl; 
          <cf_translate key="MSG_DatosModificadosIncorrectos">
			  Los datos fueron modificados, los valores presentados pueden contener 
			  datos incorrectos, para ver los valores correctos presione el bot&oacute;n  'Restaurar' ! 
		  </cf_translate>          
		</font></div></td>
    </tr>
	</cfif>
    <cfoutput> 
      <tr valign="top"> 
        <td nowrap colspan="9" align="center">  
          <input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"> 
  		  <input type="submit" name="btnRegresar" value="#BTN_Regresar#"  onclick="javascript:document.form1.action='PTU.cfm';"><!--- PTU-ResultadoCalculoTab5-lista.cfm --->
        </td>
      </tr>
      <tr valign="top"> 
        <td nowrap colspan="8" align="center">
        	<input name="RHPTUEid" type="hidden" value="#form.RHPTUEid#" />
            <input name="tab" type="hidden" value="5" />
			<input type="hidden" name="RCNid" value="#Form.RCNid#">
			<input type="hidden" name="DEid" value="#Form.DEid#">
			<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
        </td>
      </tr>
    </cfoutput> 
  </table>
</form>