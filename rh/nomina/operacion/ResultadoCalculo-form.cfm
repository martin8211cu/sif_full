
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Si_realiza_la_modificación_se_recalculará_la_nómina_Esta_Seguro_que_desea_Modificar" Default="Si realiza la modificación, se recalculará la nómina!.\n\nEsta Seguro que desea Modificar?" returnvariable="vModificarNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Si_realiza_alguna_modificacion_se_recalculara_la_nomina_Esta_seguro_que_desea_Eliminar_los_Registros_Seleccionados" Default="Si realiza alguna modificación, se recalculará; la nómina!.\n\n Está; seguro que desea Eliminar los Registros Seleccionados?" returnvariable="vEliminaRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Esta_seguro_que_desea_Eliminar_los_Registros_Seleccionados" Default="¿Está seguro que desea Eliminar los Registros Seleccionados?" returnvariable="vEliminaRegistrosSel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Seleccione_el_Registro_que_desea_eliminar" Default="¡Seleccione el Registro que desea eliminar!" returnvariable="vSeleccionRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Esta_seguro_que_desea_Restaurar_este_Empleado_en_la_Relacion_de_Calculo_Nota_Si_Restaura_todos_los_Registros_Eliminados_en_esta_pantalla_seran_Restaurados"  Default="Est&aacute; seguro que desea Restaurar este Empleado en la Relación de Cáculo?\n\nNota: Si Restaura todos los Registros Eliminados en esta pantalla, serán Restaurados."	 returnvariable="vRestaurarEmpleados"component="sif.Componentes.Translate" method="Translate"/>
<!---Boton Agregar Incidencia--->
<cfinvoke Key="BTN_AgregarIncidencia" Default="Agregar Incidencia" returnvariable="BTN_AgregarIncidencia" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton Agregar Deduccción--->
<cfinvoke Key="BTN_AgregarDeduccion" Default="Agregar Deducci&oacute;n" returnvariable="BTN_AgregarDeduccion" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton Eliminar ---->
<cfinvoke Key="BTN_Eliminar" Default="Eliminar" XmlFile="/rh/generales.xml" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton Restaurar ---->
<cfinvoke Key="BTN_Restaurar" Default="Restaurar" returnvariable="BTN_Restaurar"component="sif.Componentes.Translate" method="Translate"/>
<!---Boton regresar ---->
<cfinvoke Key="BTN_Regresar" Default="Regresar" XmlFile="/rh/generales.xml" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!--- Consultas --->
<!--- Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a, RCalculoNomina b, TiposNomina c 
	where b.Ecodigo = #session.Ecodigo#
	  and b.Ecodigo = a.Ecodigo
	  and b.Ecodigo = c.Ecodigo	  
	  and b.Tcodigo = c.Tcodigo 
	  and a.Mcodigo = c.Mcodigo 
	  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>
<cfquery name="rsSE" datasource="#Session.DSN#">
	select SEcalculado
	from SalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<!-----============= TRADUCCION =================---->

<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;
	//Cuando SEcalulado está en 1=Listo, Modificar cualquier dato implica que este estqado cambiará
	//a 0, lo que implica que está relacion por completo ya no podrá ser aplicada. A menos que Recalcule.
	//confirmado se consulta para pedir confirmacion al usuario antes de hacer cualquier modificacion,
	//cuando el SEcalulado esté en 1.
	var confirmado=(<cfoutput>#rsSE.SEcalculado#</cfoutput>!=1)
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height, name)
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
		if (confirmado || <cfoutput>confirm("#vModificarNomina#")</cfoutput>) {
			var params = "?Tcodigo=#Form.Tcodigo#&frame=IN&RCNid=#Form.RCNid#&DEid=#Form.DEid#";
			if (paramAdic!=null) params += paramAdic;
			//popUpWindow("ResultadoModify-form.cfm"+params,250,200,650,250);
			popUpWindow("ResultadoModify-form.cfm"+params,225,235,665,350);
		}
		return false;
	}
	function btnAgregarDeduccion(paramAdic) {
		//Confirma
		if (confirmado || <cfoutput>confirm("#vModificarNomina#")</cfoutput>) {
			var params = "?Tcodigo=#Form.Tcodigo#&frame=DE&RCNid=#Form.RCNid#&DEid=#Form.DEid#";
			if (paramAdic!=null) params += paramAdic;
			popUpWindow("ResultadoModify-form.cfm"+params,250,200,650,500, 'wDeduccion');
		}
		return false;
	}
	</cfoutput>
	function btnModificarIncidencia(ICid) {
		var param = "&ICid="+ICid;
		//Confirma
		if (confirmado || <cfoutput>confirm("#vModificarNomina#")</cfoutput>)
			btnAgregarIncidencia(param);
	}
	function btnModificarDeduccion(Did) {
		var param = "&Did="+Did;
		//Confirma
		if (confirmado || <cfoutput>confirm("#vModificarNomina#")</cfoutput>)
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
				if (!<cfoutput>confirm('#vEliminaRegistros#')</cfoutput>)
					result = false;
			}
			else if (!<cfoutput>confirm('#vEliminaRegistrosSel#')</cfoutput>)
				result = false;
		}
		else
			<cfoutput>alert('#vSeleccionRegistros#')</cfoutput>;
		return result;
	}
	function btnRestaurar() {
		if (<cfoutput>confirm("#vRestaurarEmpleados#")</cfoutput>)
			return true;
		return false;
	}
</script>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
  <!--- Los include se hacen fuera de tr y td para mantener el alineamiento de las columnas --->
  <tr>
	<td nowrap colspan="10" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>">
		<cf_translate key="LB_InformacionResumida">
			<div align="center">Informaci&oacute;nResumida</div>
		</cf_translate>
	</td>
  </tr>
  <cfinclude template="frame-SalarioEmpleado.cfm"><!--- Informacion Resumida --->
</table>
<br>
<form action="ResultadoCalculo-sql.cfm" method="post" name="form1">
  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
    <tr> 
      <td nowrap colspan="11" bgcolor="#EEEEEE"><div align="center"><strong><font color="#666666">
	  	<cf_translate key="LB_InformacionDetallada">Informaci&oacute;n Detallada</cf_translate>
	  </font></strong></div></td>
    </tr>
    <cfinclude template="frame-PagosEmpleado.cfm"></td>
    <!--- Salarios --->
    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>
    <cfinclude template="frame-IncidenciasCalculo.cfm"></td>
    <!--- Incidencias --->
    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>
    <cfinclude template="frame-CargasCalculo.cfm"></td>
    <!--- Cargas --->
    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>
    <cfinclude template="frame-DeduccionesCalculo.cfm"></td>
    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>
	<cfif rsSE.SEcalculado neq 1>
    <!--- Deducciones --->
    <tr valign="top"> 
      <td nowrap colspan="10"><div align="center"><font color="#FF0000">&iexcl; 
          <cf_translate key="LosDatosFueronModificadosLosValoresPresentadosPuedeContenerDatosIncorrectosParaVerLosValoresCorrectosPresioneElBotonRestaurar">
			  Los datos fueron modificados, los valores presentados pueden contener 
			  datos incorrectos, para ver los valores correctos presione el bot&oacute;n 
			  'Restaurar' ! 
		  </cf_translate>
		  </font></div></td>
    </tr>
	</cfif>
    <cfoutput> 
      <tr valign="top"> 
        <td nowrap colspan="10" align="center">  
          <input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"> 
          <input type="submit" name="AltaI" class="btnGuardar" value="#BTN_AgregarIncidencia#" onclick="javascript:return btnAgregarIncidencia();"> 
		  <cfif isdefined('rsRelacionCalculo') and not rsRelacionCalculo.CPnodeducciones>
          <input type="submit" name="AltaD" class="btnGuardar" value="#BTN_AgregarDeduccion#" onclick="javascript:return btnAgregarDeduccion();"> 
		  </cfif>
		   <cfquery name="rsParametro" datasource="#session.dsn#">
				select Pvalor from RHParametros where Pcodigo=2026 and Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfif rsSE.SEcalculado neq 1>
			<cfif rsParametro.Pvalor gt 0>
				 <input type="submit" name="butAjuste" value="Ajuste negativo">
			</cfif>
			</cfif>
          <input type="submit" name="Baja" 			class="btnEliminar" value="#BTN_Eliminar#" 	onclick="javascript:return btnEliminarChecked();"> 
		  <input type="submit" name="butRestaurar" 	class="btnNormal" 	value="#BTN_Restaurar#" onclick="javascript:return btnRestaurar();">
		  <input type="submit" name="btnRegresar" 	class="btnAnterior" value="#BTN_Regresar#"  onclick="javascript:document.form1.action='ResultadoCalculo-lista.cfm';">
        </td>
      </tr>
      <tr valign="top"> 
        <td nowrap colspan="10" align="center">
			<input type="hidden" name="RCNid" value="#Form.RCNid#">
			<input type="hidden" name="DEid" value="#Form.DEid#">
			<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
        </td>
      </tr>
    </cfoutput> 
  </table>
</form>