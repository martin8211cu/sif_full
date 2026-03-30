<cfif isdefined("LvarInfo")>
	<cfset LvarAction     = 'SaldoCuenta-sql_INFO.cfm'>
<cfelse>
	<cfset LvarAction     = 'SaldoCuenta-sql.cfm'>
</cfif>
<cfif not isdefined("form.ADMIN")>
	<cfset form.ADMIN = 'N'>
</cfif>

<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cfinclude template="Funciones.cfm">
					
<cfset formato 	= #get_val(10).Pvalor#>
<cfset periodo	= #get_val(30).Pvalor#>
<cfset mes		= #get_val(40).Pvalor#>
<cfset cantniv 	= ArrayLen(listtoarray(formato,'-'))>
<cfset cantniv 	= 6 >
<cfset Unidades = 1 >

<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select 
		m.Cmayor, 
		<cf_dbfunction name="concat" args="m.Cmayor,' - ',m.Cdescripcion"> as Cuenta,
		coalesce(( 
			select max(PCNid)
			from PCNivelMascara nm
			where nm.PCEMid = m.PCEMid
			), 1) as Nivel
	from CtasMayor m
	where m.Ecodigo = #Session.Ecodigo#
	order by m.Cmayor
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Integraci&oacute;n de Cuenta de Mayor" 
returnvariable="LB_Titulo" xmlfile="SaldoCuenta.xml"/>
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

<cf_templateheader title="#LB_Titulo#"> 
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<form name="form1" method="post" action="<cfoutput>#LvarAction#</cfoutput>" onsubmit="return sinbotones()">
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
				<tr>
					<td align="right"  width="10%"> 
						<strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate></strong>:&nbsp; 
					</td>
					<td width="30%">
						<select name="Cmayor" tabindex="1" onchange="GeneraNivelesDetalle();">
							<option value="-1">{<cf_translate key=LB_Seleccione>Seleccione</cf_translate>}</option>
							<cfoutput query="rsCuentas">
								<option value="#rsCuentas.Cmayor#">#rsCuentas.Cuenta#</option>
							</cfoutput>
						</select>
					</td>	
					<td align="left" width="10%">
						<strong><cf_translate key=LB_NivelDetalle>Nivel Detalle</cf_translate>:</strong>
					</td>
				  	<td colspan="3" width="30%"> 
						<select name="nivel" tabindex="1">
						</select>
				 	</td>
				</tr>
				<tr>
					<td  nowrap>
						<div align="right"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></strong>:&nbsp;</div></td>
								<td >
									<select name="periodo" tabindex="1">
										<option value="<cfoutput>#periodo-5#</cfoutput>"><cfoutput>#periodo-5#</cfoutput></option>
										<option value="<cfoutput>#periodo-4#</cfoutput>"><cfoutput>#periodo-4#</cfoutput></option>
										<option value="<cfoutput>#periodo-3#</cfoutput>"><cfoutput>#periodo-3#</cfoutput></option>
										<option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
										<option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
										<option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
									</select>								</td>
								<td align="left" ><strong><cf_translate key = LB_NivelCorte>Nivel Corte</cf_translate>:</strong></td>
								<td ><select name="CorteNivel" id="CorteNivel" tabindex="1">
                                </select></td>
							</tr>
							<tr>	
								<td align="right" ><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong>:</td>
								<td  colspan="1"><select name="mes" size="1" tabindex="1"><cfoutput>
                                  <option value="1" <cfif mes EQ 1>selected</cfif>>#CMB_Enero#</option>
                                  <option value="2" <cfif mes EQ 2>selected</cfif>>#CMB_Febrero#</option>
                                  <option value="3" <cfif mes EQ 3>selected</cfif>>#CMB_Marzo#</option>
                                  <option value="4" <cfif mes EQ 4>selected</cfif>>#CMB_Abril#</option>
                                  <option value="5" <cfif mes EQ 5>selected</cfif>>#CMB_Mayo#</option>
                                  <option value="6" <cfif mes EQ 6>selected</cfif>>#CMB_Junio#</option>
                                  <option value="7" <cfif mes EQ 7>selected</cfif>>#CMB_Julio#</option>
                                  <option value="8" <cfif mes EQ 8>selected</cfif>>#CMB_Agosto#</option>
                                  <option value="9" <cfif mes EQ 9>selected</cfif>>#CMB_Setiembre#</option>
                                  <option value="10" <cfif mes EQ 10>selected</cfif>>#CMB_Octubre#</option>
                                  <option value="11" <cfif mes EQ 11>selected</cfif>>#CMB_Noviembre#</option>
                                  <option value="12" <cfif mes EQ 12>selected</cfif>>#CMB_Diciembre#</option>
                                </select></cfoutput></td>
								<td align="left" width="10%"><strong><cf_translate key=LB_Unidades>Unidades</cf_translate>:</strong></td>
								<td colspan="2" width="30%"><select name="Unidades" size="1" tabindex="1">
                                  <option value="1" <cfif Unidades EQ 1>selected</cfif>><cf_translate key=LB_Moneda>Moneda</cf_translate></option>
                                  <option value="1000" <cfif Unidades EQ 2>selected</cfif>><cf_translate key=LB_Miles>Miles</cf_translate></option>
                                  <option value="1000000" <cfif Unidades EQ 3>selected</cfif>><cf_translate key=LB_Millones>Millones</cf_translate></option>
                                </select></td>
							</tr>
							<tr> 
								<td>&nbsp;</td>
								<td colspan="1" nowrap>
									<input name="chkCero" id="chkCero" type="checkbox" value="1"> <label for="chkCero"><cf_translate key=LB_ImprimeCuentasEnCero>Imprimir cuentas Saldo Cero</cf_translate></label>
								</td>
								<td colspan="3">(**) <cf_translate key=LB_NivelCorte0>Nivel Corte 0 especifica que no se procesa un corte</cf_translate></td>
							</tr>
							<tr> 
								<td>&nbsp;</td>
								<td colspan="1" nowrap>
									<input name="chkMonCon" id="chkMonCon" type="checkbox" value="1"> <label for="chkMonCon"><cf_translate key=LB_MonedaConvertida>Moneda Convertida</cf_translate></label>
								</td>
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr> 
							  <td colspan="4"align="center"> 
									<cf_botones values="Consultar,Exportar" names="Consultar,Exportar" tabindex="1">
								</td>
							</tr>
							
						</table>
			<input type="hidden" name="ADMIN" value= "<cfoutput>#form.ADMIN#"</cfoutput>>
		</form> 
	<cf_web_portlet_end>	
<cf_templatefooter>

<script  language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	function GeneraNivelesDetalle () {
		var cuenta = document.form1.Cmayor.value;
		var niveles = 0
		if (cuenta == "-1") {
			niveles = 0;
		}
		else
		{
			niveles = funcNivelesDetalle(cuenta);
		}
		   funcNivelesPinta(niveles);
	}
	
	
	
	
	function funcNivelesDetalle(Cuenta){
		<cfoutput query="rsCuentas">
			if (Cuenta == '#rsCuentas.Cmayor#') {
				return #rsCuentas.Nivel#;
			};
		</cfoutput>
	}

	function funcNivelesPinta(fNiveles){

		var valor = new Number(0);
		var hasta = new Number(fNiveles); 
			document.form1.nivel.length = 0;
			document.form1.CorteNivel.length = 0;
		while ( valor <= hasta ){
			document.form1.nivel.length = valor+1;
			document.form1.nivel.options[valor].value = valor;
			document.form1.nivel.options[valor].text  = valor;
			if ((valor < hasta) || (valor == 0)) {
				document.form1.CorteNivel.length = valor+1;
				document.form1.CorteNivel.options[valor].value = valor;
				document.form1.CorteNivel.options[valor].text  = valor;
			}

			valor++;
		}
	}
	GeneraNivelesDetalle();
</script> 
	