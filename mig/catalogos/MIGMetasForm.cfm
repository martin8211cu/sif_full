<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset form.modo=url.modo>
</cfif>
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif not isdefined("Form.modo") and not isdefined ('URL.Nuevo') and not isdefined ('form.Nuevo')>
	<cfset form.modo=url.modo>
</cfif>
<cfif not isdefined ('URL.modo') and not isdefined ('form.modo')>
	<cfset form.modo="ALTA">
</cfif>

<cfset LvarMIGMid="">
<cfset LvarIniciales=false>

<cfif not isdefined ('form.MIGMetaid') and isdefined ('url.MIGMetaid') and trim(url.MIGMetaid) >
	<cfset form.MIGMetaid=url.MIGMetaid>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>
<cfset LvarReadOnly=false>
<cfset funcion='ajaxFunction_ComboUnidades'>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsMIGMetas">
		select
				MIGMetaid,
				MIGMid,
				Pfecha,
				Meta,
				Metaadicional,
				Dactiva,
				Peso
		from MIGMetas
		where MIGMetaid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGMetaid#">
	</cfquery>
<cfset LvarMIGMid=rsMIGMetas.MIGMid>
<cfset LvarIniciales=true>
<cfset LvarReadOnly=true>
<cfset funcion=''>
</cfif>

<cfoutput>
	<form method="post" name="form1" action="MIGMetasSQL.cfm" onSubmit="return validar(this);">
		<cfif modo EQ 'CAMBIO'>
			<input name="MIGMetaid" id="MIGMetaid" type="hidden" value="#rsMIGMetas.MIGMetaid#">
		</cfif>
		<input name="modo" id="modo" type="hidden" value="#form.modo#" />
	<table align="center">
		<tr>
			<td align="right">Indicador:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Indicadores"
						tabla="MIGMetricas a"
						columnas="MIGMid, MIGMcodigo,MIGMnombre"
						campos = "MIGMid, MIGMcodigo,MIGMnombre"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="Ecodigo=#session.Ecodigo# and MIGMesmetrica='I' order by MIGMcodigo"
						desplegar="MIGMcodigo,MIGMnombre"
						etiquetas="C&oacute;digo,Nombre"
						formatos="S,S"
						form="form1"
						readonly="#LvarReadOnly#"
						align="left,left"
						traerInicial="#LvarIniciales#"
						size="0,20,60"
						traerFiltro="MIGMid=#LvarMIGMid#"
						filtrar_por="MIGMcodigo,MIGMnombre"
						tabindex="1"
						funcion="#funcion#"
						fparams="MIGMid"
						/>
			</td>
		</tr>
		<tr>
			<cfif modo EQ 'CAMBIO'>
				<cfquery name="rsUnidades" datasource="#session.dsn#">
					select a.Ucodigo,b.Udescripcion
					from MIGMetricas a
						inner join Unidades b
							on rtrim(a.Ucodigo)=rtrim(b.Ucodigo)
							and a.Ecodigo=b.Ecodigo
					where a.MIGMid=#rsMIGMetas.MIGMid#
					and a.Ecodigo=#session.Ecodigo#
				</cfquery>
			</cfif>
			<cfoutput>

			<td align="right">
				Unidad Indicador:
			</td>
			<td align="left">
			<div id="contenedor_Concepto">
				<cfif modo EQ 'CAMBIO'>
					#rsUnidades.Ucodigo#-#rsUnidades.Udescripcion#
				<cfelse>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</cfif>
			</div>
			</td>
			</cfoutput>
		</tr>
		<tr>
			<td align="right">Fecha:&nbsp;</td>
		  <td colspan="2" valign="top"><cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy')>
				<cfif modo NEQ 'ALTA'>
					<cfset fechadoc = LSDateFormat(rsMIGMetas.Pfecha,'dd/mm/yyyy') >
				</cfif>
				<cf_sifcalendario form="form1" value="#fechadoc#" name="Pfecha" tabindex="1">
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Meta:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>
					<cf_inputNumber name="Meta"  value="#rsMIGMetas.Meta#" enteros="15" decimales="4" negativos="true" comas="no">
				<cfelse>
					<cf_inputNumber name="Meta"  value="" enteros="15" decimales="4" negativos="true" comas="no">
				</cfif>
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Meta Adicional:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>
					<cf_inputNumber name="Metaadicional" value="#rsMIGMetas.Metaadicional#" enteros="15" decimales="4" negativos="true" comas="no">
				<cfelse>
					<cf_inputNumber name="Metaadicional"  value="" enteros="15" decimales="4" negativos="true" comas="no">
				</cfif>
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Peso:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>
					<cf_inputNumber name="Peso"  value="#rsMIGMetas.Peso#" enteros="15" decimales="4" negativos="false" comas="no">
				<cfelse>
					<cf_inputNumber name="Peso"  value="" enteros="15" decimales="4" negativos="false" comas="no">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td align="right" nowrap="nowrap">Estado:</td>
			<td align="left" nowrap="nowrap" colspan="2">
				<select name="Dactiva" id="Dactiva">
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="0"<cfif modo EQ 'CAMBIO'and rsMIGMetas.Dactiva EQ 0>selected="selected"</cfif>>Inactiva </option>
					<option value="1"<cfif modo EQ 'CAMBIO'and rsMIGMetas.Dactiva EQ 1>selected="selected"</cfif>>Activa</option>
				</select>
			</td>
		</tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr>
			<td colspan="6" align="center" nowrap><cf_botones modo="#modo#" include="Lista" tabindex="1"></td>
		</tr>

	</table>
	</form>
</cfoutput>







<!---ValidacionesFormulario--->

<script type="text/javascript">
function ajaxFunction_ComboUnidades(){
			var ajaxRequest;  // The variable that makes Ajax possible!
			var vMIGMid ='';
			var vmodoD ='';
			vMIGMid = document.form1.MIGMid.value;
			vmodoD = document.form1.modo.value;
		try{
		// Opera 8.0+, Firefox, Safari
			ajaxRequest = new XMLHttpRequest();
		}
		catch (e){
		// Internet Explorer Browsers
			try{
				ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
			}
			catch (e) {
				try{
					ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
				}
				catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}
		}

		ajaxRequest.open("GET", '/cfmx/mig/catalogos/MIGMetasComboUnidades.cfm?MIGMid='+vMIGMid+'&modoD='+vmodoD, false);
		ajaxRequest.send(null);
		<!---alert(ajaxRequest.responseText);--->
		document.getElementById("contenedor_Concepto").innerHTML = ajaxRequest.responseText;
		<!---appendChild(ComboConcepto.cfm)--->
	}
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Lista',document.form1) && !btnSelected('Importar',document.form1)){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		if (formulario.MIGMid.value == "") {
			error_msg += "\n - La Métrica no puede quedar en blanco.";
			error_input = formulario.MIGMid;
		}
	</cfif>
		if (formulario.Pfecha.value == "") {
			error_msg += "\n - La fecha no puede quedar en blanco.";
			error_input = formulario.Pfecha;
		}

		Codigo = document.form1.Meta.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - La Meta no puede quedar en blanco.";
			error_input = formulario.Meta;
		}
		if (formulario.Dactiva.value == "") {
			error_msg += "\n - El Estado de la información no puede quedar en blanco.";
			error_input = formulario.Dactiva;
		}

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>




