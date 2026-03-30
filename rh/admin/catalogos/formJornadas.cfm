<cfset modo="ALTA">
<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
	<cfset modo = "CAMBIO">
</cfif>
<!----=============== TRADUCCION ==================--->
<cfinvoke key="MSG_ElCodigoDeJornadaYaExiste" default="El Código de Jornada ya existe" returnvariable="MSG_ElCodigoDeJornadaYaExiste" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Datos_para_control_de_marca" default="Datos para Control de Marca" returnvariable="LB_Datos_para_control_de_marca" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Regenerar" default="Regenerar" returnvariable="BTN_Regenerar" component="sif.Componentes.Translate"method="Translate"/>
<cfinvoke key="MSG_Descripcion" default="Descripción" xmlfile="/rh/generales.xml" returnvariable="MSG_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Codigo" default="Código" xmlfile="/rh/generales.xml" returnvariable="MSG_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_HorasDiarias" default="Horas Diarias" returnvariable="MSG_HorasDiarias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ElCampoCantidadMininaMinutosParaConsiderarExtraDebeEstarEnElRango" default="El campo Cantidad mínima minutos para considerar fracción extra debe estar en el rango" returnvariable="MSG_RangoCantidadMinima" component="sif.Componentes.Translate" method="Translate"/>

<cfset vbModifica = true><!----Variable para indicar si se pueden modificar(activar) los inputs o no--->

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select RHJid, RHJcodigo, Ecodigo, RHJdescripcion, RHJsun, RHJmon, RHJtue, RHJwed, RHJthu, RHJfri, RHJsat, RHJmarcar,
			RHJhoraini, RHJhorafin, RHJhoradiaria, RHJhorainicom, RHJhorafincom, RHJhorasemanal, RHJdiassemanal, RHJornadahora,
			RHJornadahora, ts_rversion, RHJtipo,RHJjsemanal,RHJdiaini,RHJfraccionesExtras,RHJminutosExtras,RHJincAusencia,
			RHJincHJornada,RHJincExtraA,RHJincExtraB,RHJincFeriados,RHJhorasJornada,RHJhorasExtraA,RHJhorasExtraB,RHJrebajaocio,
			RHJpagaseptimo,RHJpagaq250,RHJtipoPago,RHJJornadaIMSS<!--- ,CIid,CSid --->
		from RHJornadas
		where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!--- <cfif len(trim(rsForm.CIid)) GT 0>
		<cfquery name="rsCIseptimo" datasource="#session.DSN#"><!----Comportamiento antes de entrada ---->
			select CIid, CIcodigo, CIdescripcion
			from CIncidentes
			where CIid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.CIid#">
		</cfquery>
	</cfif>
	<cfif len(trim(rsForm.CSid)) GT 0>
		<cfquery name="rsCSq250" datasource="#session.DSN#"><!----Comportamiento antes de entrada ---->
			select CSid, CScodigo, CSdescripcion
			from ComponentesSalariales
			where CSid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.CSid#">
		</cfquery>
	</cfif> --->
	<cfquery name="rsCompHA" datasource="#session.DSN#"><!----Comportamiento antes de entrada ---->
		select RHCJid, RHCJperiodot
		from RHComportamientoJornada
		where RHJid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			and RHCJcomportamiento = 'H'
			and RHCJmomento = 'A'
	</cfquery>
	<cfquery name="rsCompRD" datasource="#session.DSN#"><!----Comportamiento despues de entrada ---->
		select RHCJid, RHCJperiodot
		from RHComportamientoJornada
		where RHJid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			and RHCJcomportamiento = 'R'
			and RHCJmomento = 'D'
	</cfquery>
	<cfquery name="rsCompRA" datasource="#session.DSN#"><!----Comportamiento antes de salida ---->
		select RHCJid, RHCJperiodot
		from RHComportamientoJornada
		where RHJid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			and RHCJcomportamiento = 'R'
			and RHCJmomento = 'A'
	</cfquery>
	<cfquery name="rsCompHD" datasource="#session.DSN#"><!----Comportamiento despues de salida ---->
		select RHCJid, RHCJperiodot
		from RHComportamientoJornada
		where RHJid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			and RHCJcomportamiento = 'H'
			and RHCJmomento = 'D'
	</cfquery>
	<!----Verificar si la jornada ya fue utilizada en alguna planilla ----->
	<cfquery name="rsVerificaPlanilla" datasource="#session.DSN#">
		select 1
		from RHJornadas
		where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and exists (select 1
						from HPagosEmpleado
						where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">)
	</cfquery>
	<cfif rsVerificaPlanilla.RecordCount NEQ 0>
		<cfset vbModifica = false>
	</cfif>
</cfif>
<!--- Registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(RHJcodigo) as RHJcodigo
	from RHJornadas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and RHJid <>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
	</cfif>
</cfquery>
<!---Combo de incidencias negativas ---->
<cfquery name="rsIncidenciasNegativas" datasource="#session.DSN#">
	select CIid, {fn concat(rtrim(CIcodigo),{fn concat(' - ',CIdescripcion)})} as Descripcion
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CItipo = 0 			<!---Incidencia tipo hora---->
		and CInegativo = -1 	<!---Incidencias negativas ---->
		and CIcarreracp = 0
</cfquery>
<!---Combo de incidencias positivas ---->
<cfquery name="rsIncidenciasPositivas" datasource="#session.DSN#">
	select CIid, {fn concat(rtrim(CIcodigo),{fn concat(' - ',CIdescripcion)})} as Descripcion
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CItipo = 0 			<!---Incidencia tipo hora---->
		and CInegativo = 1 		<!---Incidencias positivas ---->
		and CIcarreracp = 0
</cfquery>
<!---Combo de incidencias para feriados---->
<cfquery name="rsIncidenciasFeriados" datasource="#session.DSN#">
	select CIid, {fn concat(rtrim(CIcodigo),{fn concat(' - ',CIdescripcion)})} as Descripcion
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CItipo != 2 		<!---Incidencia de tipo diferente al de importe (Horas,Dias y Calculo)---->
		and CInegativo = 1 		<!---Incidencias positivas ---->
		and CIcarreracp = 0
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	function codigos(obj){
		if (obj.value != "") {
			var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
			var dato    = trim(obj.value) + "|" + empresa;
			var temp    = new String();
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#Trim(rsCodigos.RHJcodigo)#</cfoutput>' + "|" + empresa
				if (dato == temp){
					<cfoutput>alert('#MSG_ElCodigoDeJornadaYaExiste#.')</cfoutput>;
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}
		return true;
	}

	function validar(f){
		f.obj.RHJcodigo.disabled = false;
		//Habilitar los campos con disabled
		document.form1.RHJdiaini.disabled = false;
		document.form1.horaini.disabled = false;
		document.form1.minutoini.disabled = false;
		document.form1.horafin.disabled = false;
		document.form1.minutofin.disabled = false;
		document.form1.horainicom.disabled = false;
		document.form1.minutoinicom.disabled = false;
		document.form1.horafincom.disabled = false;
		document.form1.minutofincom.disabled = false;
		document.form1.RHJfraccionesExtras.disabled = false;
		document.form1.RHJtipo.disabled = false;
		document.form1.RHJsun.disabled = false;
		document.form1.RHJmon.disabled = false;
		document.form1.RHJtue.disabled = false;
		document.form1.RHJwed.disabled = false;
		document.form1.RHJthu.disabled = false;
		document.form1.RHJfri.disabled = false;
		document.form1.RHJsat.disabled = false;
		document.form1.RHJornadahora.disabled = false;
		document.form1.RHJmarcar.disabled = false;
		document.form1.RHJrebajaocio.disabled = false;
		//Habilitar los campos con disabled
		return true;
	}
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="form1" method="post" action="SQLJornadas.cfm" onsubmit="return validar(this);">
  <cfoutput>
	<input type="hidden" name="tab" value="1">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHJid" value="#rsForm.RHJid#" >
	</cfif>
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
    	<tr>
			<td width="50%" valign="top"><!---=================== TD Datos principales jornada ===================---->
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="23%" align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
					<td width="32%">
						<input name="RHJcodigo" <cfif not vbModifica>readonly=""</cfif> type="text" value="<cfif modo neq 'ALTA'>#HTMLEditFormat(trim(rsForm.RHJcodigo))#</cfif>" tabindex="1" size="6" maxlength="5" onblur="javascript:codigos(this);" onfocus="javascript:this.select();">
					</td>
				</tr>
				<tr>
					<td align="right"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
					<td><input name="RHJdescripcion" type="text" tabindex="2" value="<cfif modo neq 'ALTA'>#HTMLeditFormat(rsForm.RHJdescripcion)#</cfif>" size="50" maxlength="60" onfocus="javascript:this.select();" <cfif not vbModifica>readonly=""</cfif>></td>
				</tr>
				<tr>
					<td align="right" nowrap><cf_translate key="LB_TipoDeJornada">Tipo de Jornada</cf_translate>:&nbsp;</td>
					<td>
						<cfquery name="rsJornadas" datasource="#session.dsn#">
							select * from CSATTipoJornada
						</cfquery>
						<select name="RHJtipo" tabindex="3" <cfif not vbModifica>disabled</cfif>>
						<cfloop query="rsJornadas">
							<option value="#CSATcodigo#" <cfif isdefined("rsForm") and rsForm.RHJtipo EQ LSParseNumber(#CSATcodigo#)>selected</cfif>>-- #CSATdescripcion# --</option>
						</cfloop>
						<!--- <option value="0" <cfif isdefined("rsForm") and rsForm.RHJtipo EQ 0>selected</cfif>>-- <cf_translate key="CMB_JDiurna">Diurna</cf_translate> --</option>
						<option value="1" <cfif isdefined("rsForm") and rsForm.RHJtipo EQ 1>selected</cfif>>-- <cf_translate key="CMB_JMixta">Mixta</cf_translate> --</option>
						<option value="2" <cfif isdefined("rsForm") and rsForm.RHJtipo EQ 2>selected</cfif>>-- <cf_translate key="CMB_JNocturna">Nocturna</cf_translate> --</option>
						<option value="3" <cfif isdefined("rsForm") and rsForm.RHJtipo EQ 3>selected</cfif>>-- <cf_translate key="CMB_JParcial">Parcial</cf_translate> --</option>
						<option value="4" <cfif isdefined("rsForm") and rsForm.RHJtipo EQ 4>selected</cfif>>-- <cf_translate key="CMB_JVespertina">Vespertina</cf_translate> --</option> --->
						</select>
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap align="right"><cf_translate key="LB_DiasLab">D&iacute;as Laborales</cf_translate>:&nbsp;</td>
					<td colspan="3">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td><input type="checkbox" name="RHJmon" tabindex="4" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHJmon EQ 1>checked</cfif>  <cfif not vbModifica>disabled</cfif>>&nbsp;<cf_translate key="CHK_Lunes" XmlFile="/rh/generales.xml">Lunes</cf_translate></td>
								<td><input type="checkbox" name="RHJthu" tabindex="7" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHJthu EQ 1>checked</cfif>  <cfif not vbModifica>disabled</cfif>>&nbsp;<cf_translate key="CHK_Jueves" XmlFile="/rh/generales.xml">Jueves</cf_translate></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="RHJtue" tabindex="5" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHJtue EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>>&nbsp;<cf_translate key="CHK_Martes" XmlFile="/rh/generales.xml">Martes</cf_translate></td>
								<td><input type="checkbox" name="RHJfri" tabindex="8" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHJfri EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>>&nbsp;<cf_translate key="CHK_Viernes" XmlFile="/rh/generales.xml">Viernes</cf_translate></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="RHJwed" tabindex="6" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHJwed EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>>&nbsp;<cf_translate key="CHK_Miercoles" XmlFile="/rh/generales.xml">Mi&eacute;rcoles</cf_translate></td>
								<td><input type="checkbox" name="RHJsat" tabindex="9" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHJsat EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>>&nbsp;<cf_translate key="CHK_Sabado" XmlFile="/rh/generales.xml">S&aacute;bado</cf_translate></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="RHJsun" tabindex="10" value="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHJsun EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>>&nbsp;<cf_translate key="CHK_Domingo" XmlFile="/rh/generales.xml">Domingo</cf_translate></td>
								<td></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="4">
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td width="28%" align="right" nowrap>(*)&nbsp;<cf_translate key="LB_HorasDiarias">Horas Diarias</cf_translate>:&nbsp;</td>
							<td width="17%" valign="top">
								<input name="RHJhoradiaria" type="text" onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								tabindex="11" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.RHJhoradiaria,'none')#<cfelse>0.00</cfif>"  <cfif not vbModifica>readonly=""</cfif>
								size="5" maxlength="5" style="text-align:right" onblur="javascript:fm(this,2); setHEA(); setHEB();" onfocus="javascript:this.select();">
							</td>
							<td width="28%" align="right" ><cf_translate key="LB_DiasSemana">D&iacute;as Semana</cf_translate>:&nbsp;</td>
							<td>
								<input name="RHJdiassemanal" type="text" tabindex="12" size="5" maxlength="5" style="text-align:right"
								onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
								value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsForm.RHJdiassemanal,'9')#<cfelse>0</cfif>"
								onchange="javascript:fm(this,0);"  <cfif not vbModifica>readonly=""</cfif>
								onfocus="javascript:this.select();" >
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><cf_translate key="LB_HorasSem">(**)&nbsp;Horas Semana</cf_translate>:&nbsp;</td>
							<td>
								<input name="RHJhorasemanal" type="text" tabindex="13"
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"  size="5" maxlength="5" style="text-align:right"
								value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsForm.RHJhorasemanal,',9.00')#<cfelse>0.00</cfif>"
								onblur="javascript:fm(this,2);" onfocus="javascript:this.select();" <cfif not vbModifica>readonly=""</cfif>>
							</td>
							<td align="right" nowrap><cf_translate key="LB_TipoDePago">Tipo de Pago</cf_translate>:&nbsp;</td>
							<td>
								<select name="RHJtipoPago">
									<option id="0" value="0" <cfif modo neq 'ALTA' and rsForm.RHJtipoPago EQ 0>selected</cfif>><cf_translate key="LB_PorDia">Por d&iacute;a</cf_translate></option>
									<option id="1" value="1" <cfif modo neq 'ALTA' and rsForm.RHJtipoPago EQ 1>selected</cfif>><cf_translate key="LB_PorHora">Por hora</cf_translate></option>
								</select>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</td>
				</tr>

			</table>
		</td><!---- Fin de datos principales ----->
		<td width="1%">&nbsp;</td>
		<td width="49%" valign="top">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td><strong><cf_translate key="LB_Comportamiento_del_tiempo_extraordinario">Comportamiento del Tiempo Extraordinario</cf_translate></strong></td>
				</tr>
				<tr><!----=================== Comportamiento jornada =======================--->
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="75%" align="right">
									<cf_translate key="LB_PagoDeTiempoExtraordinarioEnFraccionesDe">Pago de tiempo extraordinario en fracciones de:</cf_translate>&nbsp;
								</td>
								<td width="25%">
									<select name="RHJfraccionesExtras" tabindex="26" <cfif not vbModifica>disabled</cfif>>
										<option value="60" <cfif modo NEQ "ALTA" and rsForm.RHJfraccionesExtras EQ 60>selected</cfif>>60 min</option>
										<option value="30" <cfif modo NEQ "ALTA" and rsForm.RHJfraccionesExtras EQ 30>selected</cfif>>30 min</option>
										<option value="15" <cfif modo NEQ "ALTA" and rsForm.RHJfraccionesExtras EQ 15>selected</cfif>>15 min</option>
									</select>
								</td>
							</tr>
							<tr>
								<td align="right">
									<cf_translate key="LB_CantidadMinimaMinutosParaConsiderarFraccionExtra">Cantidad m&iacute;nima minutos para considerar fracci&oacute;n extra:</cf_translate>&nbsp;
								</td>
								<td>
									<input type="text" name="RHJminutosExtras" value="<cfif modo NEQ "ALTA">#LSNumberFormat(rsForm.RHJminutosExtras,',9.00')#</cfif>" onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" <cfif not vbModifica>readonly=""</cfif>
									<cfif vbModifica>onBlur="javascript:fm(this,2); funcVerificaCantMinina(this.value);"</cfif> onfocus="javascript:this.select();" size="5" maxlength="5" style="text-align:right" tabindex="27">
								</td>
							</tr>
							<tr>
								<td align="right"><cf_translate key="LB_JornadaIMSS">Jornada IMSS:</cf_translate>&nbsp;</td>
								<td>
									<select name="RHJJornadaIMSS" id="RHJJornadaIMSS">
										<option value="0" <cfif modo NEQ "ALTA" and rsForm.RHJJornadaIMSS EQ 0>selected</cfif>>Jornada normal</option>
										<option value="1" <cfif modo NEQ "ALTA" and rsForm.RHJJornadaIMSS EQ 1>selected</cfif>>1 D&iacute;a</option>
										<option value="2" <cfif modo NEQ "ALTA" and rsForm.RHJJornadaIMSS EQ 2>selected</cfif>>2 D&iacute;as</option>
										<option value="3" <cfif modo NEQ "ALTA" and rsForm.RHJJornadaIMSS EQ 3>selected</cfif>>3 D&iacute;as</option>
										<option value="4" <cfif modo NEQ "ALTA" and rsForm.RHJJornadaIMSS EQ 4>selected</cfif>>4 D&iacute;as</option>
										<option value="5" <cfif modo NEQ "ALTA" and rsForm.RHJJornadaIMSS EQ 5>selected</cfif>>5 D&iacute;as</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr><!----=================== Fin de comportamiento jornada =======================--->
				<tr><td><hr></td></tr>
				<tr><td><strong><cf_translate key="LB_Tolerancias_en_la_marca_minutos">Tolerancia en la marca (minutos)</cf_translate></strong></td></tr>
				<tr><!---================== Tolerancia en la marca =====================----->
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td align="right" width="43%"><cf_translate key="LB_Antes_de_entrada">Antes de entrada</cf_translate>:&nbsp;</td>
								<td width="57%">
									<input type="hidden" name="RHCJid_HA" value="<cfif modo NEQ "ALTA">#rsCompHA.RHCJid#</cfif>">
									<input type="text" name="HA" value="<cfif modo NEQ "ALTA">#rsCompHA.RHCJperiodot#</cfif>" size="5" maxlength="5" tabindex="28"
									onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
									onblur="javascript:fm(this,0);" onfocus="javascript:this.select();"  style="text-align:right">
								</td>
							</tr>
							<tr>
								<td align="right" width="43%"><cf_translate key="LB_Despues_de_entrada">Despu&eacute;s de entrada</cf_translate>:&nbsp;</td>
								<td width="57%">
									<input type="hidden" name="RHCJid_RD" value="<cfif modo NEQ "ALTA">#rsCompRD.RHCJid#</cfif>">
									<input type="text" name="RD" value="<cfif modo NEQ "ALTA">#rsCompRD.RHCJperiodot#</cfif>" size="5" maxlength="5" tabindex="28"
									onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
									onblur="javascript:fm(this,0);" onfocus="javascript:this.select();"  style="text-align:right">
								</td>
							</tr>
							<tr>
								<td align="right" width="43%"><cf_translate key="LB_Antes_de_salida">Antes de salida</cf_translate>:&nbsp;</td>
								<td width="57%">
									<input type="hidden" name="RHCJid_RA" value="<cfif modo NEQ "ALTA">#rsCompRA.RHCJid#</cfif>">
									<input type="text" name="RA" value="<cfif modo NEQ "ALTA">#rsCompRA.RHCJperiodot#</cfif>" size="5" maxlength="5" tabindex="28"
									onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
									onblur="javascript:fm(this,0);" onfocus="javascript:this.select();"  style="text-align:right">
								</td>
							</tr>
							<tr>
								<td align="right" width="43%"><cf_translate key="LB_Despues_de_salida">Despu&eacute;s de salida</cf_translate>:&nbsp;</td>
								<td width="57%">
									<input type="hidden" name="RHCJid_HD" value="<cfif modo NEQ "ALTA">#rsCompHD.RHCJid#</cfif>">
									<input type="text" name="HD" value="<cfif modo NEQ "ALTA">#rsCompHD.RHCJperiodot#</cfif>" size="5" maxlength="5" tabindex="28"
									onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
									onblur="javascript:fm(this,0);" onfocus="javascript:this.select();"  style="text-align:right">
								</td>
							</tr>
						</table>
					</td>
				</tr><!----======================= Fin de tolerancia en la marca ====================--->
			</table>
		</td>
	</tr>
	<tr><!----=============== Datos de control de marca =====================---->
		<td width="50%" valign="top">
			<fieldset style="text-indent:inherit"><legend style="color:##000000"><strong>#LB_Datos_para_control_de_marca#</strong></legend>
			<table width="100%" cellpadding="3" cellspacing="0">
				<tr>
					<td width="47%" nowrap>
						<input name="RHJornadahora" type="checkbox" id="RHJornadahora" tabindex="14" <cfif not vbModifica>disabled</cfif>
						value="1" <cfif modo NEQ "ALTA" and rsForm.RHJornadahora EQ 1>checked</cfif>>
						<cf_translate key="CHK_PagoPorHorasLaboradas">Pago por horas laboradas</cf_translate>
					</td>
					<td width="53%">
						<input name="RHJmarcar" type="checkbox" id="RHJmarcar" tabindex="14" value="1" <cfif modo NEQ "ALTA" and rsForm.RHJmarcar EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>
						onclick="javascript: funcHabilita(this);">
						<cf_translate key="CHK_RegistrarMarcas">Registrar Marcas</cf_translate>
					</td>
				</tr>
				<tr>
					<td nowrap>
						<input type="radio" name="RHJjsemanal" tabindex="15" onclick="javascript: habilitaDiaInicial();" value="0"
						<cfif modo NEQ 'ALTA' and rsForm.RHJjsemanal EQ 0>checked</cfif> <cfif not vbModifica>disabled</cfif>>
						<cf_translate key="LB_Verifica_marca_x_dia">Verifica marca x d&iacute;a</cf_translate></td>
					<td nowrap>
						<input type="radio" name="RHJjsemanal" tabindex="16" onclick="javascript: habilitaDiaInicial();" value="1"
						<cfif modo NEQ 'ALTA' and rsForm.RHJjsemanal EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>>
						<cf_translate key="LB_Verifica_marca_x_semana">Verifica marca x semana</cf_translate>
					</td>
				</tr>
				<tr>
					<td align="right" ><cf_translate key="LB_Dia_inicial">D&iacute;a Inicial:</cf_translate></td>
					<td width="53%">
						<select name="RHJdiaini" id="RHJdiaini" tabindex="17" <cfif not vbModifica>disabled</cfif>>
							<option value="2" <cfif isdefined("rsForm") and rsForm.RHJdiaini EQ 2>selected</cfif>><cf_translate key="CHK_Lunes" XmlFile="/rh/generales.xml">Lunes</cf_translate></option>
							<option value="3" <cfif isdefined("rsForm") and rsForm.RHJdiaini EQ 3>selected</cfif>><cf_translate key="CHK_Martes" XmlFile="/rh/generales.xml">Martes</cf_translate></option>
							<option value="4" <cfif isdefined("rsForm") and rsForm.RHJdiaini EQ 4>selected</cfif>><cf_translate key="CHK_Miercoles" XmlFile="/rh/generales.xml">Miércoles</cf_translate></option>
							<option value="5" <cfif isdefined("rsForm") and rsForm.RHJdiaini EQ 5>selected</cfif>><cf_translate key="CHK_Jueves" XmlFile="/rh/generales.xml">Jueves</cf_translate></option>
							<option value="6" <cfif isdefined("rsForm") and rsForm.RHJdiaini EQ 6>selected</cfif>><cf_translate key="CHK_Viernes" XmlFile="/rh/generales.xml">Viernes</cf_translate></option>
							<option value="7" <cfif isdefined("rsForm") and rsForm.RHJdiaini EQ 7>selected</cfif>><cf_translate key="CHK_Sabado" XmlFile="/rh/generales.xml">Sábado</cf_translate></option>
							<option value="1" <cfif isdefined("rsForm") and rsForm.RHJdiaini EQ 1>selected</cfif>><cf_translate key="CHK_Domingo" XmlFile="/rh/generales.xml">Domingo</cf_translate></option>
						</select>
					</td>
				</tr>
			</table>
			</fieldset>
		</td>
		<td width="1%" valign="top">&nbsp;</td>
		<td width="49%" valign="top" rowspan="2">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td><hr></td></tr>
				<tr><td><strong><cf_translate key="LB_Comportamiento_para_pago_jornada_pago_por_hora">Comportamiento para pago (jornadas pago por hora)</cf_translate></strong></td></tr>
				<tr>
					<td>
						<table width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td colspan="2">&nbsp;</td>
								<td><cf_translate key="LB_Hasta_Hora">Hasta<br>Hora</cf_translate></td>
							</tr>
							<tr>
								<td align="right" nowrap><cf_translate key="LB_Rebajo_por_ausencia">Rebajo por ausencia</cf_translate>:&nbsp;</td>
								<td>
									<select name="RHJincAusencia" tabindex="29">
										<cfloop query="rsIncidenciasNegativas">
										  <option value="#rsIncidenciasNegativas.CIid#" <cfif modo NEQ "ALTA" and rsForm.RHJincAusencia EQ rsIncidenciasNegativas.CIid>selected</cfif>>#rsIncidenciasNegativas.Descripcion#</option>
										</cfloop>
									  </select>
								</td>
							</tr>
							<tr>
								<td align="right" nowrap><cf_translate key="LB_Incidencia_Horas_Jornada">Incidencia horas jornada</cf_translate>:&nbsp;</td>
								<td>
									<select name="RHJincHJornada" tabindex="30" >
										<cfloop query="rsIncidenciasPositivas">
										  <option value="#rsIncidenciasPositivas.CIid#" <cfif modo NEQ "ALTA" and rsForm.RHJincHJornada EQ rsIncidenciasPositivas.CIid>selected</cfif>>#rsIncidenciasPositivas.Descripcion#</option>
										</cfloop>
									  </select>
								</td>
								<td>
									<!---Se solicitó que siempre se guarde 0 en este valor---->
									<input type="hidden" name="RHJhorasJornada" value="0.00"
									size="5" maxlength="5" tabindex="31">
								</td>
							</tr>
							<tr>
								<td align="right" nowrap><cf_translate key="LB_Incidencia_Pago_Extra_A">Incidencia pago extra A</cf_translate>:&nbsp;</td>
								<td>
									<select name="RHJincExtraA" tabindex="32">
										<cfloop query="rsIncidenciasPositivas">
										  <option value="#rsIncidenciasPositivas.CIid#" <cfif modo NEQ "ALTA" and rsForm.RHJincExtraA EQ rsIncidenciasPositivas.CIid>selected</cfif>>#rsIncidenciasPositivas.Descripcion#</option>
										</cfloop>
								  	</select>
								</td>
								<td>
									<input type="text" name="RHJhorasExtraA" value="<cfif modo NEQ 'ALTA'>#LSNumberFormat(rsForm.RHJhorasExtraA,',9.00')#</cfif>"
									size="5" maxlength="5" tabindex="33"
									onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
									onblur="javascript:if (validateHEA(this)) fm(this,2);" onfocus="javascript:this.select();"  style="text-align:right">
								</td>
							</tr>
							<tr>
								<td align="right" nowrap><cf_translate key="LB_Incidencia_Pago_Extra_B">Incidencia pago extra B</cf_translate>:&nbsp;</td>
								<td>
									<select name="RHJincExtraB" tabindex="34">
										<cfloop query="rsIncidenciasPositivas">
										  <option value="#rsIncidenciasPositivas.CIid#" <cfif modo NEQ "ALTA" and rsForm.RHJincExtraB EQ rsIncidenciasPositivas.CIid>selected</cfif>>#rsIncidenciasPositivas.Descripcion#</option>
										</cfloop>
								  	</select>
								</td>
								<td>
									<input type="text" name="RHJhorasExtraB" value="<cfif modo NEQ 'ALTA'>#LSNumberFormat(rsForm.RHJhorasExtraB,',9.00')#</cfif>"
									size="5" maxlength="5" tabindex="35"
									onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
									onblur="javascript:if (validateHEB(this)) fm(this,2);" onfocus="javascript:this.select();"  style="text-align:right">
								</td>
							</tr>
							<tr>
								<td align="right" nowrap><cf_translate key="LB_Incidencia_Para_Feriados">Incidencia para feriados</cf_translate>:&nbsp;</td>
								<td>
									<select name="RHJincFeriados" tabindex="36">
										<cfloop query="rsIncidenciasFeriados">
										  <option value="#rsIncidenciasFeriados.CIid#" <cfif modo NEQ "ALTA" and rsForm.RHJincFeriados EQ rsIncidenciasFeriados.CIid>selected</cfif>>#rsIncidenciasFeriados.Descripcion#</option>
										</cfloop>
								  	</select>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="3" align="center">
									<!----<cfif vbModifica>
										<input type="submit" name="btnRegenerar" value="#BTN_Regenerar#" onClick="if ( confirm('Desea regenerar los horarios?') ){return true;} return false;" tabindex="37">
									</cfif>---->
									<!--- <cfinclude template="/rh/portlets/pBotones.cfm"> --->
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr><!----==================== Fin de datos de control de marcas =======================---->
	<tr><!---======================= Jornada ===================---->
		<td width="50%" valign="top">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td colspan="2"><cf_translate key="LB_Jornada">Jornada:</cf_translate></td>
					<td colspan="2"><cf_translate key="LB_TiempoOcioso">Tiempo Ocioso :</cf_translate></td>
				</tr>
				<tr>
				  <td align="right"><cf_translate key="LB_De">De:</cf_translate>&nbsp;</td>
				  <td valign="top">
						<cfif modo NEQ 'ALTA'>
						<!--- Para cargar la hora inicial de la jornada --->
						<cfset horai = Hour(rsForm.RHJhoraini) >
						<cfset minutoi = Minute(rsForm.RHJhoraini) >

						<cfif InputBaseN(horai,10) LT 10>
						<cfset horai = "0" & horai >
						<cfelse>
						<cfif InputBaseN(horai,10) GT 12 >
						<cfset horai = ToString(InputBaseN(horai,10) - 12) >
						</cfif>
						</cfif>
						<cfset horai = horai & " " & LCase(LSTimeFormat(rsForm.RHJhoraini,'tt'))>

						<cfif InputBaseN(minutoi,10) LT 10>
						<cfset minutoi = "0" & minutoi & " min.">
						</cfif>
						<!---  ---------------------------------------- --->
						<cfset horaf = Hour(rsForm.RHJhorafin) >
						<cfset minutof = Minute(rsForm.RHJhorafin) >

						<cfif InputBaseN(horaf,10) LT 10>
						<cfset horaf = "0" & horaf >
						<cfelse>
						<cfif InputBaseN(horaf,10) GT 12 >
						<cfset horaf = ToString(InputBaseN(horaf,10) - 12) >
						</cfif>
						</cfif>
						<cfset horaf = horaf & " " & LCase(LSTimeFormat(rsForm.RHJhorafin,'tt'))>

						<cfif InputBaseN(minutof,10) LT 10>
						<cfset minutof = "0" & minutof & " min.">
						</cfif>
						</cfif>
						<!--- Hora de inicio de jornada laboral --->
						<select name='horaini' tabindex="18" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# am" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horai EQ valor) > selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 pm' <cfif modo NEQ 'ALTA' and (horai EQ '12 pm') >selected</cfif>>12 pm</option>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# pm" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horai EQ valor) >selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 am' <cfif modo NEQ 'ALTA' and (horai EQ '12 am') >selected</cfif>>12 am</option>
						</select>
						<select name='minutoini' tabindex="19" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="0" to="59">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# min." >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutoi EQ i) > selected</cfif>>#valor#</option>
							</cfloop>
						</select>
				    </td>
					<td align="right"><cf_translate key="LB_De">De:</cf_translate>&nbsp;</td>
					<td>
						<cfset horaicom = "">
						<cfset minutoicom = "">
						<cfif modo NEQ 'ALTA' and Len(Trim(rsForm.RHJhorainicom)) GT 0 >
							<!--- Para cargar la hora inicial de la jornada --->
							<cfset horaicom = Hour(rsForm.RHJhorainicom) >
							<cfset minutoicom = Minute(rsForm.RHJhorainicom) >
							<cfif InputBaseN(horaicom,10) LT 10>
								<cfset horaicom = "0" & horaicom >
							<cfelse>
								<cfif InputBaseN(horaicom,10) GT 12 >
									<cfset horaicom = ToString(InputBaseN(horaicom,10) - 12) >
								</cfif>
							</cfif>
							<cfset horaicom = horaicom & " " & LCase(LSTimeFormat(rsForm.RHJhorainicom,'tt'))>
							<cfif InputBaseN(minutoicom,10) LT 10><cfset minutoicom = "0" & minutoicom & " min."></cfif>
						</cfif>
						<cfset horafcom = "">
						<cfset minutofcom = "">
						<cfif modo NEQ 'ALTA' and Len(Trim(rsForm.RHJhorafincom)) GT 0 >
							<cfset horafcom = Hour(rsForm.RHJhorafincom) >
							<cfset minutofcom = Minute(rsForm.RHJhorafincom) >

							<cfif InputBaseN(horafcom,10) LT 10>
								<cfset horafcom = "0" & horafcom >
							<cfelse>
								<cfif InputBaseN(horafcom,10) GT 12 >
									<cfset horafcom = ToString(InputBaseN(horafcom,10) - 12) >
								</cfif>
							</cfif>
							<cfset horafcom = horafcom & " " & LCase(LSTimeFormat(rsForm.RHJhorafincom,'tt'))>
							<cfif InputBaseN(minutofcom,10) LT 10><cfset minutofcom = "0" & minutofcom & " min."></cfif>
						</cfif>
						<!--- Hora de inicio de almuerzo --->
						<select name='horainicom' tabindex="22" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# am" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaicom EQ valor) >selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 pm' <cfif modo NEQ 'ALTA' and (horaicom EQ '12 pm') >selected</cfif>>12 pm</option>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# pm" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaicom EQ valor) >selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 am' <cfif modo NEQ 'ALTA' and (horaicom EQ '12 am') >selected</cfif>>12 am</option>
						</select>
						<select name='minutoinicom' tabindex="23" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="0" to="59">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# min." >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutoicom EQ i) >selected</cfif>>#valor#</option>
							</cfloop>
						</select>
						&nbsp;
					</td>
				</tr>
				<tr>
					<td align="right"><cf_translate key="LB_A">A:</cf_translate>&nbsp;</td>
					<td valign="top">
						<!--- Hora de salida de jornada laboral --->
						<select name='horafin' tabindex="20" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# am" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaf EQ valor) >selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 pm' <cfif modo NEQ 'ALTA' and (horaf EQ '12 pm') >selected</cfif>>12 pm</option>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# pm" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horaf EQ valor) > selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 am' <cfif modo NEQ 'ALTA' and (horaf EQ '12 am') >selected</cfif>>12 am</option>
						</select>
						<select name='minutofin' tabindex="21" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="0" to="59">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# min." >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutof EQ i) >selected</cfif>>#valor#</option>
							</cfloop>
						</select>
					</td>
					<td align="right"><cf_translate key="LB_A">A:</cf_translate>&nbsp;</td>
					<td>
						<!--- Hora de término de almuerzo --->
						<select name='horafincom' tabindex="24" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# am" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horafcom EQ valor) >selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 pm' <cfif modo NEQ 'ALTA' and (horafcom EQ '12 pm') >selected</cfif>>12 pm</option>
							<cfloop index="i" from="1" to="11">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# pm" >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (horafcom EQ valor) >selected</cfif>>#valor#</option>
							</cfloop>
							<option value='12 am' <cfif modo NEQ 'ALTA' and (horafcom EQ '12 am') >selected</cfif>>12 am</option>
						</select>
						<select name='minutofincom' tabindex="25" <cfif not vbModifica>disabled</cfif>>
							<cfloop index="i" from="0" to="59">
								<cfset valor = "">
								<!--- si es un número de 0 a 9, se añade un 0 a la izquierda por ej. '1' --> '01' --->
								<cfif i LT 10 ><cfset valor = "0" ></cfif>
								<cfset valor = valor & "#i# min." >
								<option value='#valor#' <cfif modo NEQ 'ALTA' and (minutofcom EQ i) >selected</cfif>>#valor#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="4">
						<input type="checkbox" name="RHJrebajaocio" <cfif modo NEQ 'ALTA' and rsForm.RHJrebajaocio EQ 1>checked</cfif> <cfif not vbModifica>disabled</cfif>>
						<cf_translate key="LB_RebajarTiempoOciosoAlasHorasDeJornadaLaboral">Rebajar tiempo de ocio a las horas de la jornada laboral</cf_translate>
					</td>
				</tr>
			</table>
		</td>
	</tr><!----======= Fin de jornada ==============---->
	<tr><td>&nbsp;</td></tr>
	<tr><!----=============== Texto Indicaciones ====================---->
		<td width="50%">
			<fieldset style="text-indent:inherit">
			<table>
				<tr>
					<td>
						<p><strong>(*)</strong><cf_translate key="AYUDA_CuandoLaJornadaSeConsideraMensualElSalarioHora">
							Cuando la jornada de trabajo se considere mensual, el salario por hora se obtiene utilizando las horas
							diarias est&aacute;ndar por d&iacute;a laborado.
						</cf_translate></p>
					</td>
				</tr>
				<tr>
					<td>
						<p><strong>(**)</strong>
						<cf_translate key="MSG_CuandoSePagaPorSemanaLaboralProyectandoElSalarioMensualDelFuncionarioALasSemanasEnElAño">
							Cuando se paga por semana laboral, proyectando el salario mensual del funcionario a las semanas en el año, se deben registrar los datos de Horas y D&iacute;as por Semana Laboral. Cuando este es el caso, las Horas Diarias no forman parte del c&aacute;lculo.
						</cf_translate></p>
					</td>
				</tr>
			</table>
			</fieldset>
		</td>
		<!----=============== Datos Séptimo y Q250 ====================---->
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo"
				returnvariable="Lvar_PagaSeptimo">
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250"
				returnvariable="Lvar_PagaQ250">
		<td width="1%">&nbsp;</td>
		<td width="49%" valign="top" align="center">
			<cfif Lvar_PagaSeptimo or Lvar_PagaQ250>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td><hr></td></tr>
				<tr>
					<td colspan="2"><strong><cf_translate key="LB_Otros_Comportamientos">Otros Comportamientos</cf_translate></strong></td>
				</tr>
			</table>
			</cfif>
			<cfif Lvar_PagaSeptimo>
				<table width="100%" cellpadding="2" cellspacing="2">
					<tr>
						<td width="30%" align="right">&nbsp;</td>
						<td width="70%" valign="middle">
							<table width="1%" cellpadding="0" cellspacing="0"><tr><td>
							<input tabindex="37" type="checkbox" name="RHJpagaseptimo" id="RHJpagaseptimo" <cfif isdefined("rsForm.RHJpagaseptimo") and rsForm.RHJpagaseptimo EQ 1>checked</cfif> onclick="javascript: habilitaSeptimo();">
							</td><td nowrap><cf_translate key="LB_Paga_Septimo">Paga S&eacute;ptimo</cf_translate></td></tr></table>

						</td>
					</tr>
					<!--- <tr>
						<td align="right"><cf_translate key="LB_Concepto_Incidente">Concepto Incidente</cf_translate>:</td>
						<td>
							<cfif isdefined("rsForm.CIid") and len(trim(rsForm.CIid)) and rsCIseptimo.recordcount GT 0>
								<cf_rhCIncidentes query="#rsCIseptimo#"  tabindex="37">
							<cfelse>
								<cf_rhCIncidentes  tabindex="37">
							</cfif>
						</td>
					</tr> --->
				</table>
			</cfif>
			<cfif Lvar_PagaQ250>
				<table width="100%" cellpadding="2" cellspacing="2">
					<tr>
						<td width="30%" align="right">&nbsp;</td>
						<td width="70%" valign="middle">
							<table width="1%" cellpadding="0" cellspacing="0"><tr><td>
							<input  tabindex="37" type="checkbox" name="RHJpagaq250" id="RHJpagaq250" <cfif isdefined("rsForm.RHJpagaq250") and rsForm.RHJpagaq250 EQ 1>checked</cfif> onclick="javascript: habilitaQ250();">
							</td><td nowrap><cf_translate key="LB_Paga_Bonificacion_De_Ley">Paga Bonificaci&oacute;n de Ley</cf_translate></td></tr></table>
					</tr>
					<!--- <tr>
						<td align="right"><cf_translate key="LB_Concepto_Incidente">Componentes Salariales</cf_translate>:</td>
						<td>
							<cfset Lvar_CSvalues=ArrayNew(1)>
							<cfif isdefined("rsForm.CSid") and len(trim(rsForm.CSid)) and rsCSq250.recordcount GT 0>
									<cfset ArrayAppend(Lvar_CSvalues,rsCSq250.CSid)>
									<cfset ArrayAppend(Lvar_CSvalues,rsCSq250.CScodigo)>
									<cfset ArrayAppend(Lvar_CSvalues,rsCSq250.CSdescripcion)>
							</cfif>
							<cf_conlis
								campos="CSid, CScodigo, CSdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								valuesArray="#Lvar_CSvalues#"
								title="Lista de Componentes Salariales"
								tabla="ComponentesSalariales"
								columnas="CSid, CScodigo, CSdescripcion"
								filtro="Ecodigo = #Session.Ecodigo#"
								desplegar="CScodigo, CSdescripcion"
								filtrar_por="CScodigo, CSdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="CSid, CScodigo, CSdescripcion"
								asignarFormatos="I, S, S"
							    tabindex="37">
						</td>
					</tr> --->
				</table>
			</cfif>
			<br>
			<cfset tabindex="38">
			<cfinclude template="/rh/portlets/pBotones.cfm">
		</td>
	</tr>
  </table>

  <cfset ts = "">
	<cfif modo neq "ALTA">
		<cfinvoke
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
  </cfoutput>
</form>

<script type="text/javascript" language="javascript1.2">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.RHJcodigo.required = true;
		objForm.RHJcodigo.description="#MSG_Codigo#";
		objForm.RHJdescripcion.required = true;
		objForm.RHJdescripcion.description="#MSG_Descripcion#";
		objForm.RHJhoradiaria.required = true;
		objForm.RHJhoradiaria.description="#MSG_HorasDiarias#";
	</cfoutput>
	function deshabilitarValidacion(){
		objForm.RHJcodigo.required = false;
		objForm.RHJdescripcion.required = false;
		objForm.RHJhoradiaria.required = false;
	}

	function habilitaDiaInicial()
	{
		if (document.form1.RHJjsemanal[1].checked)
			document.form1.RHJdiaini.disabled = false;
		else
			document.form1.RHJdiaini.disabled = true;
	}
	habilitaDiaInicial();

	//Funcion para verificar que la cantidad de dias digitados este entre 1 y el numero seleccionado del combo de pago de tiempo extraordinario
	function funcVerificaCantMinina(prn_valorObjeto){
		<cfoutput>
		if (parseInt(prn_valorObjeto) <= 0 || prn_valorObjeto > parseInt(document.form1.RHJfraccionesExtras.value)){
			alert("#MSG_RangoCantidadMinima#"+' 1 - '+ parseInt(document.form1.RHJfraccionesExtras.value));
			document.form1.RHJminutosExtras.value = '';
		}
		</cfoutput>
	}

	function setHEA(){
		var v1 = 0.00;
		var v2 = 0.00;
		if (document.form1.RHJhorasExtraA.value!='')
			v1 = parseFloat(qf(document.form1.RHJhorasExtraA.value));
		if (document.form1.RHJhoradiaria.value!='')
			v2 = parseFloat(qf(document.form1.RHJhoradiaria.value));
		if(v1<v2){
			document.form1.RHJhorasExtraA.value=fm(v2,2);
		}
		return true;
	}

	function setHEB(){
		var v1 = 0.00;
		var v2 = 0.00;
		if (document.form1.RHJhorasExtraB.value!='')
			v1 = parseFloat(qf(document.form1.RHJhorasExtraB.value));
		if (document.form1.RHJhoradiaria.value!='')
			v2 = parseFloat(qf(document.form1.RHJhoradiaria.value));
		if (document.form1.RHJhorasExtraA.value!='')
			v2 = parseFloat(qf(document.form1.RHJhorasExtraA.value));
		if(v1<v2){
			document.form1.RHJhorasExtraB.value=fm(v2,2);
		}
		return true;
	}

	function validateHEA(){
		var v1 = 0.00;
		var v2 = 0.00;
		if (document.form1.RHJhorasExtraA.value!='')
			v1 = parseFloat(qf(document.form1.RHJhorasExtraA.value));
		if (document.form1.RHJhoradiaria.value!='')
			v2 = parseFloat(qf(document.form1.RHJhoradiaria.value));
		if(v1<v2){
			document.form1.RHJhorasExtraA.value=v2;
		}
		setHEB();
		return true;
	}

	function validateHEB(){
		var v1 = 0.00;
		var v2 = 0.00;
		if (document.form1.RHJhorasExtraB.value!='')
			v1 = parseFloat(qf(document.form1.RHJhorasExtraB.value));
		if (document.form1.RHJhorasExtraA.value!='')
			v2 = parseFloat(qf(document.form1.RHJhorasExtraA.value));
		if(v1<=v2){
			document.form1.RHJhorasExtraB.value=v2;
		}
		return true;
	}

	function funcHabilita(pro_ObjCheck){
		if (pro_ObjCheck.checked){
			document.form1.RHJjsemanal[0].disabled = false;
			document.form1.RHJjsemanal[1].disabled = false;
			document.form1.RHJjsemanal[0].checked = true;
		}
		else{
			document.form1.RHJjsemanal[0].disabled = true;
			document.form1.RHJjsemanal[1].disabled = true;
			document.form1.RHJdiaini.disabled = true;
			document.form1.RHJjsemanal[0].checked = false;
			document.form1.RHJjsemanal[1].checked = false;
		}
	}
	<cfif modo NEQ "ALTA" and rsForm.RHJmarcar EQ 0>
		document.form1.RHJjsemanal[0].disabled = true;
		document.form1.RHJjsemanal[1].disabled = true;
		document.form1.RHJjsemanal[0].checked = false;
		document.form1.RHJjsemanal[1].checked = false;
	</cfif>
</script>