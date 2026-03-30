<!--- 
	Creado por: Ana Villavicencio
	Fecha: 22 de julio del 2005
	Motivo: Nueva opción en Contabilidad General.
			Proceso para la Revaluación de Cuentas de Mayor.
			Forma para la captura de los datos.
			Se pide dos rangos de mes y periodo para aplicar la revaluación.
			Se tiene la opción de aplicación de asientos automática.
 --->
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Revaluar" 		default="Revaluar"			returnvariable="BTN_Revaluar"			component="sif.Componentes.Translate" method="Translate" xmlfile="formRevaluacion.xml"/>

<cfif isdefined("Form.Cambio")>
  <cfset modo="CAMBIO">
  <cfelse>
  <cfif not isdefined("Form.modo")>
    <cfset modo="ALTA">
    <cfelseif #Form.modo# EQ "CAMBIO">
    <cfset modo="CAMBIO">
    <cfelse>
    <cfset modo="ALTA">
  </cfif>
</cfif>

<cfset periodo=get_val(50).Pvalor>
<cfset mes=get_val(60).Pvalor>

<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script> 

<form method="post" name="form1" action="SQLRevaluacion.cfm" onSubmit="javascript: return validar(this);">
	<cfoutput >
	<input name="periodoAux" type="hidden" value="#periodo#">
	<input name="mesAux" type="hidden" value="#mes#">
	</cfoutput>
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="40%" align="center">
				<table width="40%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="10%" align="right" nowrap><strong><cf_translate key=LB_MesIni>Mes Inicial</cf_translate>:</strong>&nbsp;</td>
						<td width="10%" > <cfoutput>
							<select name="mesI" size="1">
							  <option value="1" >#CMB_Enero#</option>
							  <option value="2" >#CMB_Febrero#</option>
							  <option value="3" >#CMB_Marzo#</option>
							  <option value="4" >#CMB_Abril#</option>
							  <option value="5" >#CMB_Mayo#</option>
							  <option value="6" >#CMB_Junio#</option>
							  <option value="7" >#CMB_Julio#</option>
							  <option value="8" >#CMB_Agosto#</option>
							  <option value="9" >#CMB_Setiembre#</option>
							  <option value="10" >#CMB_Octubre#</option>
							  <option value="11">#CMB_Noviembre#</option>
							  <option value="12" >#CMB_Diciembre#</option>
							</select></cfoutput>					  
						</td>
						<td width="10%" align="right" nowrap><strong><cf_translate key=LB_PeriodoIni>Periodo Inicial</cf_translate>:</strong>&nbsp;</td>
						<td width="10%" >
							<select name="periodoI">
							  <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
							  <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
					  		</select>					  
						</td>
					</tr>
					
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td width="10%" align="right"><strong><cf_translate key=LB_MesFin>Mes Final</cf_translate>:</strong>&nbsp;</td>
						<td width="10%" > <cfoutput>
							<select name="mesF" size="1" disabled>
							  <option value="1" >#CMB_Enero#</option>
							  <option value="2" >#CMB_Febrero#</option>
							  <option value="3" >#CMB_Marzo#</option>
							  <option value="4" >#CMB_Abril#</option>
							  <option value="5" >#CMB_Mayo#</option>
							  <option value="6" >#CMB_Junio#</option>
							  <option value="7" >#CMB_Julio#</option>
							  <option value="8" >#CMB_Agosto#</option>
							  <option value="9" >#CMB_Setiembre#</option>
							  <option value="10" >#CMB_Octubre#</option>
							  <option value="11">#CMB_Noviembre#</option>
							  <option value="12" >#CMB_Diciembre#</option>
							</select> </cfoutput>
						</td>
						<td width="10%" align="right"><strong><cf_translate key=LB_PeriodoFin>Periodo Final</cf_translate>:</strong>&nbsp;</td>
						<td width="10%" >
							<select name="periodoF" disabled>
							  <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
							  <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
							</select>						
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td align="right"><input name="automatico" type="checkbox" onClick="javascript: deshabilita();">&nbsp;</td>
						<td align="left" colspan="3"><strong><cf_translate key=LB_Aplicar>Aplicar Autom&aacute;ticamente</cf_translate></strong></td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr><td colspan="4" align="center"><cfoutput><input name="Revaluar" type="submit" value="#BTN_Revaluar#"></cfoutput></td></tr>
			  	</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>

</form>
 
<script language="JavaScript" type="text/javascript">
	function validar(obj){
			var pAux= Number(obj.periodoAux.value);
				mAux= Number(obj.mesAux.value);
				pF= Number(obj.periodoF.value);
				pI= Number(obj.periodoI.value);
				mF= Number(obj.mesF.value);
				mI= Number(obj.mesI.value);
		if (confirm('Está seguro de efectuar la Revaluación de Cuentas de Mayor?')){
			if (document.form1.automatico.checked){
				if (pAux < pF){
					alert('El PERIODO FINAL no puede ser mayor que el PERIODO DE AUXILIARES.');
					return false;
				}
				if (pAux == pF){
					if (mAux < mF){
						alert('El MES FINAL no puede ser mayor que el MES DE AUXILIARES.');
						return false;
					}
				}
				if (pF < pI){
					alert('El PERIODO INICIAL no puede ser mayor que el PERIODO FINAL.');
					return false;
				} 
				if (pF == pI){
					if (mF < mI){
						alert('El MES INICIAL no puede ser mayor que el MES FINAL.');
						return false;
					}
				}
			}else{
				if (pAux < pI){
					alert('El PERIODO no puede ser mayor que el PERIODO DE AUXILIARES.');
					return false;
				}
				if (pAux == pI){
					if (mAux < mI){
						alert('El MES no puede ser mayor que el MES DE AUXILIARES.');
						return false;
					}
				}
			}
		}else{return false;}
	}
	
	function deshabilita(){
 		if (document.form1.automatico.checked){
			document.form1.periodoF.disabled = false;
			document.form1.mesF.disabled = false;
		}else{
			document.form1.periodoF.disabled = true;
			document.form1.mesF.disabled = true;
		}
	}
</script>