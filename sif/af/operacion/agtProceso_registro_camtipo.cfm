<cfif isdefined("url.AGTPid") and len(trim(url.AGTPid))><cfset form.AGTPid = url.AGTPid></cfif>
<cfif isdefined("url.ADTPlinea") and len(trim(url.ADTPlinea))><cfset form.ADTPlinea = url.ADTPlinea></cfif>
<cfif isdefined("form.LADTPlinea") and len(trim(form.LADTPlinea))><cfset form.ADTPlinea = form.LADTPlinea></cfif>
<cfif isdefined("form.AGTPid") and len(trim(form.AGTPid))>
	<cfset modocambio = true>
<cfelse>
	<cfset modocambio = false>
</cfif>
<cfif isdefined("form.ADTPlinea") and len(trim(form.ADTPlinea))>
	<cfset mododetcambio = true>
	<cfset form.LADTPlinea = form.ADTPlinea>
<cfelse>
	<cfset mododetcambio = false>
</cfif>
<cfif isdefined('form.params')>
	<cfset params = form.params>
</cfif>

<cfif modocambio>
	<cfquery name="rsAGTProceso" datasource="#session.dsn#">
		select
			a.AGTPid,
			a.AGTPdescripcion,
			a.AFRmotivo,
			a.AGTPrazon,
			a.ts_rversion,
			a.AGTPfalta,
			<cf_dbfunction name="concat" args="c.Pnombre ,' ',c.Papellido1 ,' ' , c.Papellido2 "> as nombre
		from AGTProceso a
			inner join Usuario b on a.Usucodigo = b.Usucodigo
			inner join DatosPersonales c on b.datos_personales = c.datos_personales					
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.AGTPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsAGTProceso.ts_rversion#" returnvariable="ts"/>
	<cfif mododetcambio>
		<cfquery name="rsADTProceso" datasource="#session.dsn#">
			select ADTPlinea, c.Aid, c.Aplaca, c.Adescripcion, ADTPrazon, a.ts_rversion,
				AFSvaladq, 			AFSvalmej, 			AFSvalrev, 			AFSvaladq 		+ AFSvalmej 		+ AFSvalrev 		as AFSvaltot,
				AFSdepacumadq, 	AFSdepacummej, 	AFSdepacumrev, 	AFSdepacumadq + AFSdepacummej + AFSdepacumrev as AFSdepacumtot,
				AFSvaladq - AFSdepacumadq as AFSsaldoadq,
				AFSvalmej - AFSdepacummej as AFSsaldomej,
				AFSvalrev - AFSdepacumrev as AFSsaldorev,
				case when (AFSvaladq - AFSdepacumadq) > 0.00 then TAmontolocadq * 100 / (AFSvaladq - AFSdepacumadq) else 0.00 end as PRCmontolocadq,
				case when (AFSvalmej - AFSdepacummej) > 0.00 then TAmontolocmej * 100 / (AFSvalmej - AFSdepacummej) else 0.00 end as PRCmontolocmej,
				case when (AFSvalrev - AFSdepacumrev) > 0.00 then TAmontolocrev * 100 / (AFSvalrev - AFSdepacumrev) else 0.00 end as PRCmontolocrev,
				case when ((AFSvaladq 		+ AFSvalmej 		+ AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) > 0.00 then (TAmontolocadq + TAmontolocmej + TAmontolocrev) * 100 / ((AFSvaladq 		+ AFSvalmej 		+ AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) else 0.00 end as PRCmontoloctot,
				(AFSvaladq 		+ AFSvalmej 		+ AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev) as AFSsaldotot,				
				TAmontolocadq, 	TAmontolocmej, 	TAmontolocrev, 	TAmontolocadq + TAmontolocmej + TAmontolocrev as TAmontoloctot,
				TAvutil
			from ADTProceso a 
				inner join AGTProceso b on a.AGTPid = b.AGTPid and a.Ecodigo = b.Ecodigo
				inner join Activos c on a.Aid = c.Aid and a.Ecodigo = c.Ecodigo
				inner join AFSaldos d on a.Aid = d.Aid and a.Ecodigo = d.Ecodigo and d.AFSperiodo = b.AGTPperiodo and d.AFSmes = b.AGTPmes
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			and a.ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		</cfquery>
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsADTProceso.ts_rversion#" returnvariable="tsdet"/>
	</cfif>
</cfif>
<!---Incluye API de Qforms--->
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<cfif isdefined("params")>
	<input name="params" type="hidden" value="#params#">
</cfif>
  <tr>
    <td align="center">
			<table width="0%" align="center"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfif not modocambio>
							<fieldset><legend>Informaci&oacute;n requerida</legend>
								<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td> 
										
										<td>
											<input name="AGTPdescripcion" type="text" size="60" maxlength="80" <cfif modocambio>value="#rsAGTProceso.AGTPdescripcion#"</cfif>>
										</td>
									</tr>
								</table>
							</fieldset>
 							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<cfset Aplicar = "">
										<cf_botones modocambio="#modocambio#" form="fagtproceso" include="#Aplicar#"  regresar="agtProceso_#botonAccion[IDtrans][1]#.cfm?#params#">
									</td>
								</tr>
							</table>
						<cfelse>
							<fieldset><legend>Relaci&oacute;n de Cambio Tipo</legend>
								<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="12%"><strong>Descripci&oacute;n:&nbsp;&nbsp;</strong></td>
										<td width="34%" align="left">#rsAGTProceso.AGTPdescripcion#
											<input name="AGTPdescripcion" type="hidden" size="60" maxlength="80" tabindex="-1"
												value="#rsAGTProceso.AGTPdescripcion#">
										</td>
									<td width="13%" align="left"><strong>Creado por:</strong></td>
									<td width="41%" align="left">#rsAGTProceso.nombre#</td>
									</tr>
								</table>
							</fieldset>
								<cfinclude template="transfTipo2.cfm">
						</cfif>
					<td>
			</tr>
		</table>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
</cfoutput>

<!---funciones en javascript de los demás campos--->
<script language="javascript" type="text/javascript">
<!--//
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	qffagtproceso = new qForm("fagtproceso");

	function funcCambioDet() {
		if (qffagtproceso.TAmontolocmej.obj.value == 0.00) {
			alert('El monto debe ser mayor a cero');
			return false;
		}
	}
	function habilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = true;
	}
	function deshabilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = false;
	}
	function _qfinit(){	
		habilitarValidacion();
	}
	<cfif modocambio>
		<cfoutput>
		function funcAsociar(){
			//qffagtproceso.AGTPid.required = true;
		}
		</cfoutput>
	</cfif>
	function _forminit(){
		var form = document.fagtproceso;
		_qfinit()
		<cfif modocambio>
		qffagtproceso.AplacaINI.obj.focus();
		<cfelse>
		qffagtproceso.AGTPdescripcion.obj.focus();
		</cfif>
		<cfif mododetcambio>
			form.TAVutil.focus();
		</cfif>		
	}
	_forminit();
//-->
</script>




 