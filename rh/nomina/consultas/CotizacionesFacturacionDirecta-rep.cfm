<style type="text/css">
<!--
.encabezado {
    font-family: Arial, Helvetica, sans-serif;
    font-weight: bold;
	font-size:11px;
}
.encabezadotext {
    font-family: Arial, Helvetica, sans-serif;
    font-size:11px;
}
.LBColumna {
    font-family: Arial, Helvetica, sans-serif;
    font-weight: bold;
	font-size:11px;
	background-color:#E1E1E1;
	border-bottom: 1px solid #000000;
}
.LBColumnaText {
    font-family: Arial, Helvetica, sans-serif;
    font-size:11px;
}


-->
</style>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NOMBRE_DEL_PATRONO" Default="NOMBRE DEL PATRONO" returnvariable="LB_NOMBRE_DEL_PATRONO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FECHA_DE_EMISION" Default="FECHA DE EMISI&Oacute;N" returnvariable="LB_FECHA_DE_EMISION"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RUTA" Default="RUTA" returnvariable="LB_RUTA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CORR_PLANILLA" Default="CORR. PLANILLA" returnvariable="LB_CORR_PLANILLA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HOJA" Default="HOJA" returnvariable="LB_HOJA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NUMERO_PATRONAL" Default="N&Uacute;MERO PATRONAL" returnvariable="LB_NUMERO_PATRONAL"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DIRECCION_DEL_PATRONO" Default="DIRECCION DEL PATRONO" returnvariable="LB_DIRECCION_DEL_PATRONO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEPATAMENTO_Y_MINICIPIO" Default="DEPARTAMENTO Y MINICIPIO" returnvariable="LB_DEPATAMENTO_Y_MINICIPIO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TELEFONO_FAX" Default="TELEFONO(S) FAX" returnvariable="LB_TELEFONO_FAX"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NOMBRE_DEL_CENTRO_DE_TRABAJO" Default="NOMBRE DEL CENTRO DE TRABAJO" returnvariable="LB_NOMBRE_DEL_CENTRO_DE_TRABAJO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NIT" Default="NIT" returnvariable="LB_NIT"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_IVA" Default="IVA" returnvariable="LB_IVA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ACTIVIDAD_ECONOMICA" Default="ACTIVIDAD ECON&Oacute;MICA" returnvariable="LB_ACTIVIDAD_ECONOMICA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PERIODO_DE_PAGO" Default="PERIODO DE PAGO" returnvariable="LB_PERIODO_DE_PAGO"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DIRECCION_DEL_CENTRO_DE_TRABAJO" Default="DIRECCI&Oacute;N DEL CENTRO DE TRABAJO" returnvariable="LB_DIRECCION_DEL_CENTRO_DE_TRABAJO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEPATAMENTO_Y_MINICIPIO" Default="DEPARTAMENTO Y MINICIPIO" returnvariable="LB_DEPATAMENTO_Y_MINICIPIO"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CORRE" Default="CORRE" returnvariable="LB_CORRE"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TD" Default="T.D." returnvariable="LB_TD"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NOAFILICION" Default="NO. AFILICI&Oacute;N" returnvariable="LB_NOAFILICION"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NOMBRE_SEGUN_TARJETA_DE_AFILICION" Default="NOMBRE SEG&Uacute;N TARJETA DE AFILICI&Oacute;N." returnvariable="LB_NOMBRE_SEGUN_TARJETA_DE_AFILICION"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SALARIO_DEVENGADO" Default="SALARIO DEVENGADO" returnvariable="LB_SALARIO_DEVENGADO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HRS_JOR" Default="HRS JOR" returnvariable="LB_HRS_JOR"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DIA_REM" Default="DIA REM" returnvariable="LB_DIA_REM"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CO_OBS" Default="CO. OBS." returnvariable="LB_CO_OBS"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>


<cfoutput>		
	<cfset vs_params = ''>
	<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
		<cfset vs_params = vs_params & '&Periodo=#form.Periodo#'>
	</cfif>
	<cfif isdefined("form.Mes") and len(trim(form.Mes))>
		<cfset vs_params = vs_params & '&Mes=#form.Mes#'>
	</cfif>	
	<cfif isdefined("form.CPid") and len(trim(form.CPid))>
		<cfset vs_params = vs_params & '&CPid=#form.CPid#'>
	</cfif>	
	
	
	
	<!---Emcabezados de las columnas--->
	
	<cfsavecontent variable="ENCABEZADO_IMP">
	<tr class="LBColumna">
			<td class="LBColumna"><b>#LB_CORRE#</b></td>	
			<td class="LBColumna"><b>#LB_TD#</b></td>
			<td class="LBColumna"><b>#LB_NOAFILICION#</b></td>
			<td class="LBColumna"><b>#LB_NOMBRE_SEGUN_TARJETA_DE_AFILICION#</b></td>	
			<td class="LBColumna"><b>#LB_SALARIO_DEVENGADO#</b></td>	
			<td class="LBColumna"><b>#LB_HRS_JOR#</b></td>	
			<td class="LBColumna"><b>#LB_DIA_REM#</b></td>	
			<td class="LBColumna"><b>#LB_CO_OBS#</b></td>	
	</tr>
	</cfsavecontent>
	
	
	<cfset LvarFileName = "CotizacionesFacturacionDirecta#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
	<td align="center">
		<cf_htmlReportsHeaders 
		title= "#LB_CotizacionesFacturacionDirecta#"
		filename="#LvarFileName#"
		irA="CotizacionesFacturacionDirecta-filtro.cfm">
	</td>
	</tr>
	<tr>
			<td align="center">
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>
						<td align="center" colspan="8">
						
						</td>
					</tr>
					<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))> 
						<cfif rsDatosEmpleado.RecordCount NEQ 0>
							<cfset actual = ''>	
							
							<!---Acumuladores--->
							<cfset salarioPagina=0>
							<cfset salarioTotal=0>
							<cfset contPagina=1>
							<cfloop query="rsDatosEmpleado">
								<!---<tr><td colspan="8" align="center">#rsDatosEmpleado.CurrentRow# #rsDatosEmpleado.RecordCount#</td></tr>--->
								<!---Pinta total por pagina--->
								<cfif (rsDatosEmpleado.CurrentRow MOD 15 EQ 0 and rsDatosEmpleado.CurrentRow GT 1)>
									<tr>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="left" colspan="2">Total por pagina:</td>
										<td class="encabezado" align="right">#salarioPagina#</td>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="center">&nbsp;</td>
									</tr>
									<tr><td colspan="8" align="center">&nbsp;</td></tr>
									<tr><td colspan="8" align="center">&nbsp;</td></tr>
									<cfset salarioPagina= 0>
									<cfset contPagina= contPagina + 1>
								</cfif>
								
								<!---Pinta encabezado cada 15 registros--->
								<cfif (rsDatosEmpleado.CurrentRow MOD 15 EQ 0) OR (rsDatosEmpleado.CurrentRow EQ 1)>
									<tr>
									<td align="center"  colspan="8">
										<cf_EncReporte Titulo="#LB_CotizacionesFacturacionDirecta#">
									</td>
									</tr>
									<tr><td align="center" colspan="8">
										<table border="0" cellpadding="2" cellspacing="2" width="100%">
											<tr><td class="encabezado">#LB_NOMBRE_DEL_PATRONO#</td>
												<td class="encabezado">#LB_FECHA_DE_EMISION#</td>
												<td class="encabezado">#LB_RUTA#</td>
												<td class="encabezado">#LB_CORR_PLANILLA#</td>
												<td class="encabezado">#LB_HOJA#</td>
												<td class="encabezado">#LB_NUMERO_PATRONAL#</td><!---VERIFICAR--->
											</tr>
											<tr><td class="encabezadotext">#rsDatosEncabezado.nombreCEmpresa#</td>
												<td class="encabezadotext">#rsDatosEncabezado.FechaEmision#</td>
												<td class="encabezadotext">#rsDatosEncabezado.ruta#</td><!---VERIFICAR--->
												<td class="encabezadotext">#rsDatosEncabezado.CorrPlanilla#</td>
												<td class="encabezadotext">#contPagina#</td>
												<td class="encabezadotext">#rsDatosEncabezado.NoPatronal#</td>
											</tr>
											<tr><td class="encabezado">#LB_DIRECCION_DEL_PATRONO#</td>
												<td class="encabezado">#LB_DEPATAMENTO_Y_MINICIPIO#</td>
												<td class="encabezado">#LB_TELEFONO_FAX#</td>
											</tr>
											<tr><td class="encabezadotext">#rsDatosEncabezado.direccion1CEmpresa#</td>
												<td class="encabezadotext">#rsDatosEncabezado.estadoCEmpresa# #rsDatosEncabezado.ciudadCEmpresa# </td>
												<td class="encabezadotext">#rsDatosEncabezado.tel1CEmpresa#</td>
											</tr>
											<tr><td class="encabezado">#LB_NOMBRE_DEL_CENTRO_DE_TRABAJO#</td>
												<td class="encabezado">#LB_NIT#</td>
												<td class="encabezado">#LB_IVA#</td>
												<td class="encabezado">#LB_ACTIVIDAD_ECONOMICA#</td>
												<td class="encabezado">#LB_PERIODO_DE_PAGO#</td>
											</tr>
											<tr><td class="encabezadotext">#rsDatosEncabezado.nombreEmpresa#</td>
												<td class="encabezadotext">#rsDatosEncabezado.NIT#</td><!---VERIFICAR--->
												<td class="encabezadotext">#rsDatosEncabezado.IVA#</td><!---VERIFICAR--->
												<td class="encabezadotext">#rsDatosEncabezado.actividad#</td>
												<td class="encabezadotext">#rsDatosEncabezado.PeriodoPago#</td><!---VERIFICAR--->
											</tr>
											<tr><td class="encabezado">#LB_DIRECCION_DEL_CENTRO_DE_TRABAJO#</td>
												<td class="encabezado">#LB_DEPATAMENTO_Y_MINICIPIO#</td>
												<td class="encabezado">#LB_TELEFONO_FAX#</td>
											</tr>
											<tr><td class="encabezadotext">#rsDatosEncabezado.direccion1Empresa#</td>
												<td class="encabezadotext">#rsDatosEncabezado.estadoEmpresa# #rsDatosEncabezado.ciudadEmpresa#</td>
												<td class="encabezadotext">#rsDatosEncabezado.tel1CEmpresa#</td>
											</tr>
										</table>
									</td></tr>
									#ENCABEZADO_IMP#
								</cfif>
								
								<!---Pinta los detalles--->
								<tr>
									<td class="LBColumnaText" align="center">#rsDatosEmpleado.CurrentRow#</td>
									<td class="LBColumnaText" align="center"><!---#rsDatosEmpleado.TD#---></td><!---VERIFICAR--->
									<td class="LBColumnaText" align="left">#rsDatosEmpleado.NoSeguroSocial#</td>
									<td class="LBColumnaText" align="left">#rsDatosEmpleado.Nombre#</td>
									<td class="LBColumnaText" align="right">#rsDatosEmpleado.Actual#</td>
									<td class="LBColumnaText" align="center"><!---#rsDatosEmpleado.jonada#--->8</td><!---VERIFICAR--->
									<td class="LBColumnaText" align="center">31</td><!---VERIFICAR--->
									<td class="LBColumnaText" align="center">00</td><!---VERIFICAR--->
								</tr>
							
								<cfset salarioPagina= salarioPagina + rsDatosEmpleado.Actual>
								<cfset salarioTotal= salarioTotal + rsDatosEmpleado.Actual>
								
								<!---Pinta ultimo total por pagina--->
								<cfif rsDatosEmpleado.CurrentRow EQ  rsDatosEmpleado.RecordCount>
									<tr>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="left" colspan="2">Total por pagina:</td>
										<td class="encabezado" align="right">#salarioPagina#</td>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="center">&nbsp;</td>
										<td class="encabezado" align="center">&nbsp;</td>
									</tr>
								
								</cfif>
	
							</cfloop>							
							
							<!---Pinta el total general--->
							<tr><td colspan="8" align="center">&nbsp;</td></tr>
							<tr>
								<td class="encabezado" align="center">&nbsp;</td>
								<td class="encabezado" align="center">&nbsp;</td>
								<td class="encabezado" align="left" colspan="2">Total:</td>
								<td class="encabezado" align="right">#rsDatosEmpleado.Actual#</td>
								<td class="encabezado" align="center">&nbsp;</td>
								<td class="encabezado" align="center">&nbsp;</td>
								<td class="encabezado" align="center">&nbsp;</td>
							</tr>
							
							<tr><td colspan="8" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
						<cfelse>
							<tr><td colspan="8" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
						</cfif>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>

