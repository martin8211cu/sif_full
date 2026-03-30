<cfparam name="session.Ecodigo" type="numeric">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="BTN_Validar" default="Validar" returnvariable="BTN_Validar" component="sif.Componentes.Translate" method="Translate"/>		    
<cfinvoke key="BTN_Guardar" default="Guardar" returnvariable="BTN_Guardar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_RestablecerCalculos" default="Restablecer c&aacute;lculos" returnvariable="BTN_RestablecerCalculos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Ayuda" default="Ayuda" returnvariable="BTN_Ayuda" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="BTN_Copy" default="Copiar Entrada a >>" returnvariable="BTN_Copy" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_DebeEscogerPrimeroUnaEntrada" default="Debe escoger primero una Entrada"	 returnvariable="MSG_DebeEscogerPrimeroUnaEntrada" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="MSG_DebeDigitarPrimeroElComodin" default="Debe digitar primero el comodin"	 returnvariable="MSG_DebeDigitarPrimeroElComodin" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_EnElCalculo" default="en el Cálculo"	 returnvariable="MSG_EnElCalculo" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN DE VARIABLES DE TRADUCCION --->

<!--- llamado desde variables dinamicas --->
<cfif isdefined('url.EsVarDin') and url.EsVarDin>
	<cfif isdefined('form.RHDVDid') and form.RHDVDid neq '-1'>
		<cfquery name="Encabezado_Tipo_Incidencia" datasource="#session.dsn#">
			select RHDVDcodigo as CIcodigo, RHDVDdescripcion as CIdescripcion
			from RHDVariablesDinamicas
			where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDVDid#">
		</cfquery>
	<cfelse>
		<cfif isdefined('form.RHDVDcodigo')>
			<cfset Encabezado_Tipo_Incidencia.CIcodigo = form.RHDVDcodigo>
		</cfif>
		<cfif isdefined('form.RHDVDdescripcion')>
			<cfset Encabezado_Tipo_Incidencia.CIdescripcion = form.RHDVDdescripcion>
		</cfif>
	</cfif>
	<cfquery name="RegistroActual" datasource="#session.dsn#">
		select RHFVDcantidad as CIcantidad,	RHFVDspcantidad as CIspcantidad, RHFVDtipo as CItipo, RHFVDcalculo as CIcalculo,
			RHFVDdia as CIdia, RHFVDmes as CImes, RHFVDrango as CIrango, RHFVDsprango as CIsprango, RHFVDmescompleto as CImescompleto
		from RHFVariablesDinamicas
		where RHDVDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDVDid#">
	</cfquery>
    
    
<!--- llamado desde Formulacion de Limites --->    
<cfelseif isdefined('url.EsForLim') and url.EsForLim>
   
	<cfif isdefined('form.CIid') and form.CIid neq '-1'>
	    <cfquery name="RegistroActual" datasource="#session.dsn#">
            select CItipo, CIcantidad, CIrango, CIdia, CImes, CIcalculo, CIsprango, CIspcantidad, CImescompleto
            from CIncidentesDLimite
            where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
        </cfquery>

        <cfquery name="Encabezado_Tipo_Incidencia" datasource="#session.dsn#">
            select CIcodigo, CIdescripcion
            from CIncidentes
            where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
        </cfquery>

    <cfelse>
        <cfif isdefined('form.RHDVDcodigo')>
            <cfset Encabezado_Tipo_Incidencia.CIcodigo = form.CIcodigo5>
        </cfif>
        <cfif isdefined('form.RHDVDdescripcion')>
            <cfset Encabezado_Tipo_Incidencia.CIdescripcion = form.CIdescripcion5>
        </cfif>
    </cfif>

<!--- llamado desde Conceptos de pago tipo calculo --->    
<cfelse>
	<cfquery name="RegistroActual" datasource="#session.dsn#">
		select CItipo, CIcantidad, CIrango, CIdia, CImes, CIcalculo, CIsprango, CIspcantidad, CImescompleto
		from CIncidentesD
		where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>
	
	<cfquery name="Encabezado_Tipo_Incidencia" datasource="#session.dsn#">
		select CIcodigo, CIdescripcion
		from CIncidentes
		where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>
</cfif>

<cfquery name="jornadas" datasource="#session.dsn#">
	select RHJid, RHJcodigo, {fn concat(RHJdescripcion ,{fn concat('(' ,{fn concat(<cf_dbfunction name="to_char" args="RHJhoradiaria"> ,' h)' )} )} )} as RHJdescripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="meses" datasource="sifcontrol">
	select <cf_dbfunction args="a.VSvalor" name="to_number"> as VSvalor, a.VSdesc
	from VSidioma a , Idiomas b
	where a.Iid = b.Iid
	and b.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.idioma#">
    and a.VSgrupo = 1
	order by 1
</cfquery>
<cfif IsDefined("form.CItipo") AND IsDefined("form.CIcantidad") AND IsDefined("form.CIrango") AND IsDefined("form.CIdia") AND IsDefined("form.CImes")>
	<cfset CItipo = form.CItipo>
	<cfset CIcantidad = form.CIcantidad>
	<cfif IsDefined("form.rango") and form.rango EQ '0'>
		<cfset CIrango = form.CIrango>
	<cfelse>
		<cfset CIrango = "">
	</cfif>
	<cfset CIdia = form.CIdia>
	<cfset CImes = form.CImes>
    
<cfelseif RegistroActual.RecordCount EQ 1>
	<cfset CItipo = RegistroActual.CItipo>
	<cfset CIcantidad = RegistroActual.CIcantidad>
	<cfset CIrango = RegistroActual.CIrango>
	<cfif Len(RegistroActual.CIdia) GT 0 AND Len(RegistroActual.CImes) GT 0>
		<cfset CIdia = RegistroActual.CIdia>
		<cfset CImes = RegistroActual.CImes>
	<cfelse>
		<cfset CIdia = "">
		<cfset CImes = "">
	</cfif>
	
	<cfif Len(RegistroActual.CIsprango) GT 0 AND Len(RegistroActual.CIspcantidad) GT 0>
		<cfset CIsprango 	= RegistroActual.CIsprango>
		<cfset CIspcantidad = RegistroActual.CIspcantidad>
	<cfelse>
		<cfset CIsprango 	= "">
		<cfset CIspcantidad = 0>
	</cfif>
 <cfelse>
	<cfset CItipo = "m">
	<cfset CIcantidad = -1>
	<cfset CIrango = "">
	<cfset CIdia = "">
	<cfset CImes = "">
</cfif>

<cfif isdefined('url.Regresar') and not isdefined('form.Regresar')>
	<cfset form.Regresar = url.Regresar >
<cfelseif not isdefined('form.Regresar')>
	<cfset form.Regresar = 'TiposIncidencia.cfm'>
</cfif>

<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>

<cftransaction>
	<cftry>
		<cfset current_formulas = RegistroActual.CIcalculo>
		<cfset presets_text = RH_Calculadora.get_presets(DateAdd('d',  7, Now()), DateAdd('d', 14, Now()), 
			CIcantidad, CIrango, CItipo, -1, 1, session.Ecodigo, 10 , 0, CIdia, CImes, '', true)>
			
		<cfset presets = RH_Calculadora.calculate( presets_text )>
		<cfif IsDefined("form.formulas")>
			<cfset current_formulas = form.formulas>
		</cfif>
		<cfif Len(current_formulas) EQ 0>
			<cfset current_formulas = "importe=0;cantidad=0;resultado=0;">
		</cfif>
		<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas)>
		<cfif IsDefined("values")>
			<cfset RH_Calculadora.validate_result( values )>
		</cfif>
		<cfcatch type="anyx"><cfoutput>*** #cfcatch.message# #cfcatch.detail#***</cfoutput></cfcatch>
	</cftry>
</cftransaction>
<cfoutput>
<cfscript>
	preset_descr = #RH_Calculadora.getPreset_descr()#;
</cfscript>
<form name="form1" method="post" style="margin:0" onsubmit="return validar();" >
<cfif isdefined('form.Regresar')><input name="Regresar" type="hidden" value="#form.Regresar#" /></cfif>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr align="left" valign="top">
		<td align="right">
			<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
				<tr>
					<td  valign="middle" onclick="javascript: return funcAyudaPantalla();" style=" cursor:pointer">
						<img src="/cfmx/rh/imagenes/question.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Ayuda">Ayuda</cf_translate></font>
					</td>
					<td>|</td>
					<td valign="middle" onclick="javascript: return funcRegresar();" style=" cursor:pointer">
						<img src="/cfmx/rh/imagenes/home.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Regresar">Regresar</cf_translate></font>
					</td>
				</tr>
			</table>			
		</td>
	</tr>
	<tr align="left" valign="top">
		<td>
			<fieldset>
			<legend style="color:##666666"><strong><cfif isdefined('url.EsVarDin')>Variable<cfelse><cf_translate key="LB_ConceptoDePago">Concepto de pago</cf_translate></cfif></strong>:#Encabezado_Tipo_Incidencia.CIcodigo# - #Encabezado_Tipo_Incidencia.CIdescripcion#</legend>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr align="left" valign="top">
						<!--- AREA 1 PARAMETROS GENERALES--->
						<td colspan="2">
							<fieldset>
								<legend ><cf_translate key="LB_PeriodoUtilizadoParaElCalculo">Periodo utilizado para el c&aacute;lculo</cf_translate></legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr align="left" valign="top">
										<td>
											<input type="checkbox" name="LIMITAR" id="LIMITAR" value=""  onclick="verambito();">
											<label for="LIMITAR"><cf_translate key="LB_LimitarAmbitoDeTiempoDelCalculo">Limitar ambito de tiempo del c&aacute;lculo</cf_translate>
											</label>
										</td>
											
									<!--- ljimenez hace un combo que permite elegir si es meses o periodos TEC--->
										<td align="right" nowrap>
											<cf_translate key="LB_CantidadDe">Cantidad de </cf_translate>
											<select id="mesesoperiodos" name="mesesoperiodos">
												<option value="">-<cf_translate key="CMB_Ninguna">Ninguna</cf_translate>-</option>
												<option value='0' <cfif #RegistroActual.CIsprango# eq 0 >selected</cfif> ><cf_translate key="CMB_Periodos">Periodos</cf_translate></option>
												<option value='1' <cfif #RegistroActual.CIsprango# eq 1 >selected</cfif> ><cf_translate key="CMB_Meses">Meses</cf_translate> </option>
											</select>
										<cf_translate key="LB_ParaCalculoDeSalarioPromedioDiario">para c&aacute;lculo de salario promedio diario</cf_translate>:&nbsp;</td>
										<td>
										
										
										<input name="SPDPeriodos" type="text" style="text-align: right;"  
										   onfocus="javascript:this.value=qf(this); this.select();" 
										   onblur="javascript:fm(this,-1);"  
										   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
										   value="<cfif RegistroActual.CIspcantidad GT 0 ><cfoutput>#RegistroActual.CIspcantidad#</cfoutput><cfelse>0</cfif>" 
										   size="5" maxlength="3" >
										</td>	
									</tr>
									<tr>
										<td></td>
										<td>
											 <input type="checkbox"	name="MesCompleto" <cfif RegistroActual.CImescompleto EQ 1 >checked</cfif>/>
											 <cf_translate key="LB_Calcularsobremesescompletos">Calcular sobre meses completos</cf_translate>
										</td>
									</tr>	
									<tr align="left" valign="top" id="TR_1"  style="display: none;">
										<td>
											&nbsp;&nbsp;&nbsp;&nbsp;
											<cfset rango_tipo = "">
											<label for="CIcantidad"><cf_translate key="LB_Retroceder">Retroceder</cf_translate>:</label>
											
											<input 	name="CIcantidad" 
													id="CIcantidad" 
													onfocus="select()" 
													style="text-align:right" 
													type="text" 
													value="#CIcantidad#" 
													size="7" 
													maxlength="7">
											
											<select name="CItipo" onchange="this.form.rango_tipo.value = this.options[this.selectedIndex].text">
												<option value="d" <cfif CItipo EQ 'd'> selected <cfset rango_tipo="D&iacute;as"> </cfif> ><cf_translate key="CMB_Dias">D&iacute;as</cf_translate></option>
												<option value="w" <cfif CItipo EQ 'w'> selected <cfset rango_tipo="Semanas"> </cfif> ><cf_translate key="CMB_Semanas">Semanas</cf_translate></option>
												<option value="m" <cfif CItipo EQ 'm'> selected <cfset rango_tipo="Meses"> </cfif> ><cf_translate key="CMB_Meses">Meses</cf_translate></option>
												<option value="y" <cfif CItipo EQ 'y'> selected <cfset rango_tipo="A&ntilde;os"> </cfif> ><cf_translate key="CMB_Annos">A&ntilde;os</cf_translate></option>
											</select>
										</td>
										</tr>
									<tr align="left" valign="top" id="TR_2"  style="display: none;">
										<td>	
											&nbsp;&nbsp;&nbsp;&nbsp;
											<input 	name="AjustarDiaMes" 
												id="AjustarDiaMes" 
												type="checkbox" 
												onchange="AjustarDiaMesChange(form)" 
												onclick="AjustarDiaMesChange(form)"
                                                <cfif CIdia GT 0 and CImes GT 0>checked</cfif>
                                                >

											<label for="AjustarDiaMes"><cf_translate key="CHK_LuegoAvanzarALaSiguienteFecha">Luego avanzar a la siguiente fecha</cf_translate></label>
											<select name="CIdia" id="CIdia" onchange="CIdiaChange(form)"><option value=""></option>
												<cfloop from="1" to="31" index="numero">
													<option value="#numero#" <cfif numero EQ CIdia>selected</cfif>>#numero#</option>
												</cfloop>
											</select>
											
											<select name="CImes" id="CImes" onchange="CIdiaChange(form)"><option value=""></option>
												<cfloop query="meses">
													<option value="#meses.VSvalor#" <cfif meses.VSvalor EQ CImes>selected</cfif>>#meses.VSdesc#</option>
												</cfloop>
											</select>										
										</td>
									</tr>	
									<tr align="left" valign="top" id="TR_3"  style="display: none;">
										<td>&nbsp;&nbsp;&nbsp;&nbsp;
											<cf_translate key="LB_RangoDeTiempoAConsidera">Rango de tiempo a considerar</cf_translate>
										</td>
									</tr>				
									<tr align="left" valign="top" id="TR_5"  style="display: none;">		
										<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input 	type="radio" 
													name="rango" 
													id="rango1" 
													value="1" <cfif CIrango EQ 0 or Len(CIrango) EQ 0>checked</cfif> />
											<label for="rango1"><cf_translate key="RAD_SumarMontosHastaLaFechaDeVigencia">Sumar montos hasta la fecha de vigencia</cf_translate>.</label>			
										</td>
									</tr>															
									<tr align="left" valign="top" id="TR_4"  style="display: none;">	
										<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input 	type="radio" 
													name="rango" 
													id="rango0" 
													value="0" <cfif CIrango NEQ 0 And Len(CIrango) NEQ 0>checked</cfif>  />
											
											<label for="rango0"><cf_translate key="RAD_SumarMontosPara">Sumar montos para</cf_translate></label>
											
											<input 	name="CIrango" 
													onfocus="select()" 
													style="text-align:right" 
													type="text" 
													value="#CIrango#" 
													size="7" maxlength="7" 
													onchange="this.form.rango0.checked=true" 
													onclick="this.form.rango0.checked=true"> 

											<input 	type="text" 
													readonly="readonly" 
													name="rango_tipo" 
													id="rango_tipo" 
													value="# rango_tipo #" 
													style="border:none" 
													onfocus="this.form.CIrango.focus()" />
										</td>
									</tr>	

								</table>
							</fieldset>
						</td>
					</tr>
					<tr align="left" valign="top">
						<!--- AREA 2 CALCULO--->
						<td>
							<fieldset>
								<legend><cf_translate key="LB_Calculos">C&aacute;lculos</cf_translate></legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr >
										<td bgcolor="##A0BAD3" >
											<cfinclude template="frame-botones2.cfm">
										</td>
									</tr>									
									
									<tr align="left" valign="top">
										<!--- onChange="form1.save.disabled = true; <cfif RegistroActual.RecordCount EQ 1>form1.resetcalc.disabled = false;</cfif>"
										onKeyPress="form1.save.disabled = true; <cfif RegistroActual.RecordCount EQ 1>form1.resetcalc.disabled = false;</cfif>" --->

										
										<td>
										<textarea name="formulas" cols="80" rows="30" id="formulas"
										style="font-family:sans-serif;font-size:14px;height:290px;border:solid 1px;width:100%"
										>#current_formulas#</textarea>
									</tr>
									<cfif RegistroActual.RecordCount EQ 1>
										<tr align="left" valign="top">	
											<td>
												<textarea 	name="CIcalculo" 
															id="CIcalculo" 
															style="display:none" >#RegistroActual.CIcalculo#</textarea>
											</td>
										</tr>
									</cfif>																		
								</table>		
							</fieldset>
						</td>
						<td width="22%">
							<fieldset>
								<legend><cf_translate key="LB_AyudaEntradas">Ayuda inclusión entradas</cf_translate></legend> 
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr align="left" valign="top">
										<td>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td style="font-size:9px">
														<img src="/cfmx/rh/imagenes/number1_16.gif" border="0" align="top" >
														<cf_translate key="LB_ColocarElComodinDondeSeVaInsertarLaEntrada">Colocar el comodin (>>) <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;donde se va insertar la entrada</cf_translate>.
													</td>
												</tr>
												<tr>
													<td style="font-size:9px">
														<img src="/cfmx/rh/imagenes/number2_16.gif" border="0" align="top">
														<cf_translate key="LB_SeleccionarLaEntradaDeLaLista">Seleccionar la entrada de la lista</cf_translate>.
													</td>
												</tr>
												<tr>
													<td style="font-size:9px">
														<img src="/cfmx/rh/imagenes/number3_16.gif" border="0" align="top" >
														<cf_translate key="LB_PresionarElBotonCopiarEntrada">Presionar el boton copiar entrada</cf_translate>.
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>		
							</fieldset>							
							<fieldset>
								<legend><cf_translate key="LB_Entradas">Entradas</cf_translate></legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr align="left" valign="top" >
										
										
										
										
										<td valign="top"  style=" cursor:pointer"
										onclick="javascript: if (form1.presets.value == '')
										{
										alert('<cfoutput>#MSG_DebeEscogerPrimeroUnaEntrada#</cfoutput>');
										return;
										}
										
										if (document.form1.formulas.value.search('>>') == -1)
										{
										alert('<cfoutput>#MSG_DebeDigitarPrimeroElComodin#</cfoutput> \'>>\' <cfoutput>#MSG_EnElCalculo#</cfoutput>');
										return;
										}
										document.form1.formulas.value = document.form1.formulas.value.replace('>>',form1.presets.value);">
											<img src="/cfmx/rh/imagenes/rev.gif" border="0" align="top" hspace="2">
											<font size="+2"><cf_translate key="LB_CopiarEntrada">Copiar Entrada </cf_translate></font>
										</td>
									</tr>	
									<tr align="left" valign="top">	
										<td>
											<cfif isDefined("presets")>
												<select name="presets" size="15" style="height:108px; font-size:10px;overflow:auto;border:solid 1px;width:100%" onchange="dispDesc(value)">
													<cfloop collection="#presets.getKeyMap()#" item="key">
														<option value="#LCase( key )#">#key#</option>
													</cfloop>
													<!--- OPARRALES 2019-04-01 Variables para complementar los calculos de incidencias --->
													<option value="ProporcionFaltasHoras">    	[ <cf_translate key="LB_ProporcionFaltasHoras">Proporcion de Faltas Horas</cf_translate> ] </option>
													<option value="DiasFaltaXPeriodo">			[ <cf_translate key="LB_DiasFaltaXPeriodo">Dias Falta por Periodo</cf_translate> ] </option>
													<option value="DiasIncapacidadXPeriodo">    [ <cf_translate key="LB_DiasIncapacidadXPeriodo">Dias Incapacidad por Periodo</cf_translate> ] </option>
													<option value="Dias_PIngreso">				[ <cf_translate key="LB_Dias_PIngreso">Dias para Ingreso</cf_translate> ] </option>
													<option value="Dias_PDiasSL">				[ <cf_translate key="LB_Dias_PDiasSL">Dias sin laborar despues de Liquidacion/Finiquito</cf_translate> ] </option>
													<!--- FIN OPARRALES 2019-04-01 --->
													<option value="deid">    [ <cf_translate key="LB_EmpleadoParaPruebas">Empleado para pruebas</cf_translate> ] </option>
													<option value="rhjid">   [ <cf_translate key="LB_JornadaParaPruebas">Jornada para pruebas</cf_translate> ] </option>
													<option value="rhtid">   [ <cf_translate key="LB_TipoDeAccionParaPruebas">Tipo de acci&oacute;n para pruebas</cf_translate> ] </option>
													<option value="rhalinea">[ <cf_translate key="LB_AccionParaPruebas">Acci&oacute;n para pruebas</cf_translate> ] </option>
												</select>
											<cfelse><cf_translate key="LB_SinVariables">Sin variables</cf_translate>
												<br>
											</cfif>										
										</td>
									</tr>
								</table>		
							</fieldset>
							<fieldset>
								<legend><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr align="left" valign="top">
										<td>
											<div id="preset_description">&nbsp;</div>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td style="font-size:10px">
													<div  id="capture_fecha1_accion" style="display:none">
														Este dato se utilizar&aacute; &uacute;nicamente
														para validar los c&aacute;lculos, y no se almacenar&aacute; junto
														con ellos<cfset fecha = LSDateFormat(DateAdd("d", 7, Now()), "DD/MM/YYYY")>
														<cf_sifcalendario form="form1" value="#fecha#" name="Fecha1_Accion">
													</div>
													</td>
												</tr>
												<tr>
													<td style="font-size:10px">
													<div  id="capture_fecha2_accion" style="display:none">Este dato se utilizar&aacute; &uacute;nicamente
														para validar los c&aacute;lculos, y no se almacenar&aacute; junto
														con ellos<cfset fecha = LSDateFormat(DateAdd("d", 21, Now()), "DD/MM/YYYY")>
														<cf_sifcalendario form="form1" value="#fecha#" name="Fecha2_Accion">
													</div>
													</td>
												</tr>
												<tr>
													<td style="font-size:10px">
													<div id="capture_deid" style="display:none ">
														Empleado para pruebas.<br>Este dato se utilizar&aacute; &uacute;nicamente
														para validar los c&aacute;lculos, y no se almacenar&aacute; junto con ellos<br>
														<cf_rhempleado>
													</div>			
													</td>
												</tr>
												<tr>
													<td style="font-size:10px">
													<div id="capture_rhjid" style="display:none ">
														Jornada para pruebas.<br>Este dato se utilizar&aacute; &uacute;nicamente
														para validar los c&aacute;lculos, y no se almacenar&aacute; junto
														con ellos<br>
														<select name="select">
															<cfloop query="jornadas">
																<option value="#jornadas.RHJid#">#jornadas.RHJcodigo# - #jornadas.RHJdescripcion#</option>
															</cfloop>
														</select>
													</div>
													</td>
												</tr>
												<tr>
													<td style="font-size:10px">
													<div  id="capture_rhtid" style="display:none">
														<cf_translate key="AYUDA_ValorExencion">Valor Exenci&oacute;n
														Tipo de acci&oacute;n para pruebas.<br>Este dato se utilizar&aacute; &uacute;nicamente
														para validar los c&aacute;lculos, y no se almacenar&aacute; junto
														con ellos WPOEIRLKS</cf_translate><br>
														<input type="text" name="textfield7">
													</div>
													</td>
												</tr>
												<tr>
													<td style="font-size:10px">
													<div id="capture_rhalinea" style="display:none">
														<cf_translate key="AYUDA_AccionParaPruebas">Acci&oacute;n para pruebas.<br>Este dato se utilizar&aacute; &uacute;nicamente
														para validar los c&aacute;lculos, y no se almacenar&aacute; junto
														con ellos</cf_translate><br>
														<input type="text" name="textfield8">
													</div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>		
							</fieldset>							
							
							
						</td>						
					</tr>
					<!--- AREA 4 SALIDA--->
					<tr align="left" valign="top">
						<td colspan="2">
							<input type="checkbox" name="show1" id="show1" value="" onclick="mostrar(res_init,checked)">
							<label for="show1"><cf_translate key="LB_MostrarValoresDeEntrada">Mostrar valores de entrada</cf_translate>
							</label>
							<input type="checkbox" name="show2" id="show2" value="" checked onclick="mostrar(res_interm,checked)">
							<label for="show2"><cf_translate key="LB_MostrarValoresIntermedios">Mostrar valores intermedios</cf_translate>
							</label>
							<fieldset>
								<legend><cf_translate key="LB_Salidas">Salidas</cf_translate></legend>
								<div id=scroll style="OVERFLOW: auto; HEIGHT: 80px">
								<table width="100%"  height="10%" border="0" cellpadding="0" cellspacing="0">
									<tr align="left" valign="top">
										<td>
											<cfset res_init   = "">
											<cfset res_interm = "">
                                            <cfset calc_error = RH_Calculadora.getCalc_error()>
											<cfif Len(calc_error) GT 0>
												<font color="red"><cfoutput>#calc_error#</cfoutput></font><br>
											<cfelseif isDefined("values")>
												<table border="0" cellpadding="2" cellspacing="0" width="100%">
												<cfset identif = 0>
												<cfloop collection="#values.getKeyMap()#" item="key">
													<cfset identif = identif + 1>
													<cfif ( CompareNoCase(key,"cantidad") EQ 0 ) OR ( CompareNoCase(key,"importe") EQ 0 ) OR ( CompareNoCase(key,"resultado") EQ 0 )>
														<cfset style="font-weight:bold;background-color:lavender">
													<cfelseif ( not presets.isDefined(key) ) OR ( presets.get(key) NEQ values.get(key) ) >
														<cfset css_class="res_interm">
														<cfset style="">
														<cfset res_interm = ListAppend(res_interm, identif)>
													<cfelse>
														<cfset style="display:none;font-weight:bold;background-color:gainsboro">
														<cfset res_init = ListAppend(res_init, identif)>
													</cfif>
													<tr id="tr_res_#identif#" style="#style#">
														<td style="font-size:10px">#key#</td><td align="right" style="font-size:10px">#values.get(key)#</td>
													</tr>
												</cfloop>
												</table>
											<cfelse>	
												<cf_translate key="LB_SinVariables">Sin variables</cf_translate>
											</cfif>
										</td>
									</tr>
								</table>
								</div>
							</fieldset>
						</td>
						
					</tr>					
				</table>
			</fieldset>
		</td>
	</tr>
</table>
<cfif isdefined('url.EsVarDin') and url.EsVarDin>
	<input type="hidden" name="RHEVDid" value="#form.RHEVDid#">
	<cfif isdefined('form.RHDVDid') and len(trim(form.RHDVDid))>
		<input type="hidden" name="RHDVDid" value="#form.RHDVDid#">
	</cfif>
<cfelse>
	<input type="hidden" name="CIid" value="#form.CIid#">
</cfif>
<input type="hidden" name="Boton" value="">
</cfoutput>
</form>

<script type="text/javascript">
<!-- 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeTieneQueIndicarElRetroceso"
	Default="se tiene que indicar el retroceso"	
	returnvariable="MSG_SeTieneQueIndicarElRetroceso"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeTieneQueIndicarElTipo"
	Default="se tiene que indicar el tipo"	
	returnvariable="MSG_SeTieneQueIndicarElTipo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeTieneQueIndicarEldía"
	Default="se tiene que indicar el día"	
	returnvariable="MSG_SeTieneQueIndicarEldía"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeTieneQueIndicarElmes"
	Default="se tiene que indicar el mes"	
	returnvariable="MSG_SeTieneQueIndicarElmes"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeTieneQueIndicarHastaQueLapsoSeSumanLosMontos"
	Default="se tiene que indicar hasta que lapso se suman los montos"	
	returnvariable="MSG_SeTieneQueIndicarHastaQueLapsoSeSumanLosMontos"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PorFavorReviseLosSiguienteDatos"
	Default="Por favor revise los siguiente datos"	
	returnvariable="MSG_PorFavorReviseLosSiguienteDatos"/>		

function validar() {
	var error_msg = '';
	if (document.form1.LIMITAR.checked) {
		if (document.form1.CIcantidad.value == ""){
			error_msg += "\n - <cfoutput>#MSG_SeTieneQueIndicarElRetroceso#</cfoutput>.";
		}

		if (document.form1.CItipo.value == ""){
			error_msg += "\n - <cfoutput>#MSG_SeTieneQueIndicarElTipo#</cfoutput>.";
		}

		if (document.form1.AjustarDiaMes.checked) {
			if (document.form1.CIdia.value == ""){
				error_msg += "\n - <cfoutput>#MSG_SeTieneQueIndicarEldía#</cfoutput>.";
			}
			if (document.form1.CIdia.value == ""){
				error_msg += "\n - <cfoutput>#MSG_SeTieneQueIndicarElmes#</cfoutput>.";
			}
		}
		
		if (document.form1.rango0.checked && document.form1.rango0.value == '0') {
			if (document.form1.CIrango.value == ""){
				error_msg += "\n - <cfoutput>#MSG_SeTieneQueIndicarHastaQueLapsoSeSumanLosMontos#</cfoutput>.";
			}
		}
		if (error_msg.length != "") {
			alert("<cfoutput>#MSG_PorFavorReviseLosSiguienteDatos#</cfoutput>:"+error_msg);
			return false;
		}
		return true;		
	}
	else{
	return true;
	}
}

function  funcRestablecer(){
	document.form1.formulas.value = document.form1.CIcalculo.value;
}


function  funcAyudaPantalla(){
		var PARAM  = "AyudaFormular.cfm"
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=1000,height=600')
	}

function  funcRegresar(){
	<cfif isdefined('url.EsVarDin') and url.EsVarDin>
		document.form1.action = "VariablesDinamicas.cfm";
	<cfelse>
		document.form1.action = "<cfoutput>#form.Regresar#</cfoutput>" + "?CIid=<cfoutput>#form.CIid#</cfoutput>";
	</cfif>
	document.form1.submit();
}


function  funcGuardar(){
	<cfif isdefined('url.EsVarDin') and url.EsVarDin>
		document.form1.Boton.value = "GUARDAR_F";
		document.form1.action = "VariablesDinamicas-sql.cfm";
	<cfelseif isdefined('url.EsForLim') and url.EsForLim>	
		document.form1.Boton.value = "GUARDAR_FL";
		document.form1.action = "TipoIncidencia-limites-formular-sql.cfm";
	<cfelse>
		document.form1.Boton.value = "GUARDAR";
		document.form1.action = "TiposIncidenciaD-sql.cfm";
	</cfif>
	document.form1.submit();
}

function  funcValidar(){
	document.form1.Boton.value = "VALIDAR";
	document.form1.action = "";
	document.form1.submit();
}


function verambito() {
	var TR_1 = document.getElementById("TR_1");
	var TR_2 = document.getElementById("TR_2");
	var TR_3 = document.getElementById("TR_3");
	var TR_4 = document.getElementById("TR_4");
	var TR_5 = document.getElementById("TR_5");
	if (document.form1.LIMITAR.checked) {
		TR_1.style.display ="";
		TR_2.style.display ="";
		TR_3.style.display ="";
		TR_4.style.display ="";
		TR_5.style.display ="";
		document.form1.CIcantidad.value = "12";
		document.form1.CItipo.value = "m";
	}
	else{
		TR_1.style.display ="none";
		TR_2.style.display ="none";
		TR_3.style.display ="none";
		TR_4.style.display ="none";
		TR_5.style.display ="none";
		document.form1.CIcantidad.value = "-1";
		document.form1.CItipo.value = "m";
		
	}
}

function mostrarcamposocultos() {
	var TR_1 = document.getElementById("TR_1");
	var TR_2 = document.getElementById("TR_2");
	var TR_3 = document.getElementById("TR_3");
	var TR_4 = document.getElementById("TR_4");
	var TR_5 = document.getElementById("TR_5");
	
	if (document.form1.CIcantidad.value == "-1"){
		document.form1.LIMITAR.checked = false;		
		TR_1.style.display = 'none';
		TR_2.style.display = 'none';
		TR_3.style.display = 'none';
		TR_4.style.display = 'none';
		TR_5.style.display = 'none';
	}
	else{
		TR_1.style.display = '';
		TR_2.style.display = '';
		TR_3.style.display = '';
		TR_4.style.display = '';
		TR_5.style.display = '';
		document.form1.LIMITAR.checked = true;		

	}

}
 mostrarcamposocultos();


preset_info = new Object();


function CIdiaChange(f) {
	f.AjustarDiaMes.checked = (f.CIdia.value.length != 0) && (f.CImes.value.length != 0);
}




function AjustarDiaMesChange(f) {
	if (f.AjustarDiaMes.checked) {
		if (f.CIdia.value.length == 0)
			f.CIdia.selectedIndex = 1;
		if (f.CImes.value.length == 0)
			f.CImes.selectedIndex = 1;
	} else {
		if (f.CIdia.value.length != 0)
			f.CIdia.selectedIndex = 0;
		if (f.CImes.value.length != 0)
			f.CImes.selectedIndex = 0;
	}
}

function mostrar(items,disp) {
	for (x in items) {
		 var ctl = document.all?document.all["tr_res_" + items[x]]:document.getElementById("tr_res_" + items[x]);
		if (ctl && ctl.style) {
			ctl.style.display = disp ? "" : "none";
		}
	} 
}

function dispDesc1(c, name) {
	var ctl = document.all?document.all["capture_" + name]:document.getElementById("capture_" + name);
	if (ctl && ctl.style) {
		ctl.style.display = (c == name) ? "block" : "none";
	}
}

function dispDesc(c) {
	
	 var info = preset_info[c.toLowerCase()];
	var elctl = document.all?document.all.preset_description:document.getElementById("preset_description");
	elctl.innerHTML = "<b>" + c + "</b><br>" + preset_info[c.toLowerCase()];
	elctl.style.display = info ? "inline" : "none"; 
	dispDesc1 ( c, "fecha1_accion" );
	dispDesc1 ( c, "fecha2_accion" );
	dispDesc1 ( c, "deid" );
	dispDesc1 ( c, "rhjid" );
	dispDesc1 ( c, "rhtid" );
	dispDesc1 ( c, "rhalinea" );
	dispDesc1 ( c, "ProporcionFaltasHoras");
	dispDesc1 ( c, "DiasFaltaXPeriodo");
	dispDesc1 ( c, "DiasIncapacidadXPeriodo");
	
}

var hlpWin = null;

function helpWindow() {
	if (hlpWin != null && !hlpWin.closed) {
		hlpWin.close();
	}
	hlpWin = window.open("CalculoSyntax.html","_blank","toolbar=false,resizable=yes,width=650,height=400,scrollbars=yes");
}
<cfoutput>
	res_init="#res_init#".split(",");
	res_interm="#res_interm#".split(",");
</cfoutput>

<cfloop collection="#preset_descr#" item="item">
<cfoutput>
	preset_info["# LCase( JSStringFormat (item) ) #"] = "#JSStringFormat (preset_descr[item]) #";
</cfoutput>
</cfloop>

//-->
</script>

