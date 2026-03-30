<cfif isdefined ('URL.modo')>
	<cfset form.modo=URL.modo>
</cfif>

<cfif isdefined ('URL.MIGMid')>
	<cfset form.MIGMid=URL.MIGMid>
</cfif>

<cfif isdefined ('URL.esMetric')>
	<cfset form.esMetric=URL.esMetric>
</cfif>

<cfinvoke key="MSG_DebeEscogerPrimeroUnaEntrada" default="Debe escoger primero una Entrada"	 returnvariable="MSG_DebeEscogerPrimeroUnaEntrada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeDigitarPrimeroElComodin" default="Debe digitar primero el comodin"	 returnvariable="MSG_DebeDigitarPrimeroElComodin" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_LeFaltaAgregarVariables" default="Le hace falta agregar mas variables se encontro el comodin "	 returnvariable="MSG_LeFaltaAgregarVariables" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_EnElCalculo" default="en el Cálculo"	 returnvariable="MSG_EnElCalculo" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN DE VARIABLES DE TRADUCCION --->


<cfif form.modo EQ "CAMBIO">
<cfquery datasource="#Session.DSN#" name="rsMetricas">
	select 	MIGMcalculo,MIGMcodigo,MIGMnombre,MIGMescorporativo
	from MIGMetricas
	where MIGMid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGMid#">
</cfquery>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsListaMetricas">
  select
	MIGMid,
	MIGMcodigo,
	MIGMnombre,
	MIGRecodigo,
	MIGMdescripcion,
	MIGMnpresentacion,
	MIGMsequencia,
	Ucodigo,
	MIGMcalculo
  from MIGMetricas
 where Dactiva = 1
 and Ecodigo = #session.Ecodigo#
<!--- and #rsMetricas.periocidad#--->
 order by MIGMcodigo,MIGMdescripcion
</cfquery>

<cfif isdefined('url.Regresa') and not isdefined('form.Regresa')>
	<cfset form.Regresa = url.Regresa >
<cfelseif not isdefined('form.Regresa')>
	<cfset form.Regresa = 'Metricas.cfm'>
	<cfset form.RegresaInd = 'Indicadores.cfm'>
</cfif>

<!---Incluye a este archivo para realizar la validacion en cuanto a sintaxis del calculo de la forma establecido para la Metrica ou Indicador --->
<cfinclude template="calculometrica.cfm">
<cftransaction>
	<cftry>
		<cfscript>
			metricas_text = get_metricas();
			current_formulas =  #rsMetricas.MIGMcalculo#;
			if (IsDefined("form.formulas")) {
				current_formulas = form.formulas;
			}
			if (Len (current_formulas) EQ 0) {
				current_formulas = "";
			}
			values = calculate ( metricas_text & ";" & current_formulas);
		</cfscript>

		<!---<cfoutput>#metricas_text & ";" & current_formulas#</cfoutput>--->

		<cfcatch type="anyx"><cfoutput>*** #cfcatch.message# #cfcatch.detail#***</cfoutput></cfcatch>
	</cftry>
</cftransaction>

<cf_templateheader title="Indicadores y M&eacute;tricas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Formular'>

 <style type="text/css">
   r1 {
        font-family: Arial, Helvetica, sans-serif; color: blue; font-size:10pt;
      }
	r2  {
        font-family: Arial, Helvetica, sans-serif; color: blue; font-size:11pt;
      }
	 r3{
	 	color:#3399CC;
	  }
 </style>


<cfif isdefined('rsMetricas.MIGMcodigo') and len(trim(rsMetricas.MIGMcodigo))>
	<table cellpadding="0" cellspacing="" border="0" width="100%">
		<tr><td align="center" style=" height:20; background-color:F3F3F3; color:666666"><cfoutput><strong>#rsMetricas.MIGMcodigo# - #rsMetricas.MIGMnombre#</strong></cfoutput></td></tr>
	</table>
</cfif>

<form name="form1"  method="post" style="margin:0"  >
<input name="esMetric" type="hidden" value="<cfoutput>#form.esMetric#</cfoutput>" />
<cfif isdefined('form.Regresa')><input name="Regresa" type="hidden" value="#form.Regresa#" /></cfif>
<table width="100%" border="0" cellpadding="0" cellspacing="0">

<tr align="left" valign="top">
		<td align="right">
			<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
				<tr>
					<td  valign="middle" onclick="javascript: return funcAyudaPantalla();" style=" cursor:pointer">
						<img src="/cfmx/rh/imagenes/question.gif" border="0" align="top" hspace="2"><!---<font size="+1">--->&nbsp;<cf_translate key="LB_Ayuda">Ayuda</cf_translate></font>
					</td>
					<td>|</td>
					<td valign="middle" onclick="javascript: return funcRegresar();" style=" cursor:pointer">
						<img src="/cfmx/rh/imagenes/home.gif" border="0" align="top" hspace="2"><!---<font size="+1">---><cf_translate key="LB_Regresar">Regresar</cf_translate></font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td>&nbsp;</td>
</tr>
<tr align="left" valign="top">
	<!--- AREA 2 CALCULO--->
	<td>
		<fieldset>
			<legend><r2><cf_translate key="LB_Calculos">C&aacute;lculos</cf_translate></r2></legend>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr >
					<td <!---bgcolor="##A0BAD3"---> bgcolor="silver" >
						<cfinclude template="frame-botones2.cfm">
						<input type="hidden" name="Boton" value="">
						<cfif form.modo EQ "CAMBIO">
					    <input type="hidden" name="MIGMid" value="<cfoutput>#form.MIGMid#</cfoutput>">
						</cfif>

					</td>
				</tr>

				<tr align="left" valign="top">
					<td>
					<cfoutput><textarea name="formulas" cols="80" rows="30" id="formulas"
					style="font-family:sans-serif;font-size:14px;height:400px;border:solid 1px;width:100%"
					><cfif form.modo EQ "CAMBIO">#current_formulas#</cfif></textarea></cfoutput>
				</tr>

			</table>
		</fieldset>
	</td>
	<td width="22%">
	<fieldset>
		<legend><r1><cf_translate key="LB_AyudaEntradas">Ayuda inclusión entradas</cf_translate></r1></legend>
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
			<legend><r1><cf_translate key="LB_Entradas">Entradas</cf_translate></r1></legend>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr align="left" valign="top" >

					<!--- <td valign="top"  style=" cursor:pointer"
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
					document.form1.formulas.value = document.form1.formulas.value.replace('>>',form1.presets.value);"> --->

<td valign="top"  style=" cursor:pointer"onclick="javascript: if (form1.presets.value == '')
					{
					alert('<cfoutput>#MSG_DebeEscogerPrimeroUnaEntrada#</cfoutput>');
					return;
					}

					if (document.form1.formulas.value.search('>>') == -1)
					{
					alert('<cfoutput>#MSG_DebeDigitarPrimeroElComodin#</cfoutput> \>>\ <cfoutput>#MSG_EnElCalculo#</cfoutput>');
					return;
					}
					document.form1.formulas.value = document.form1.formulas.value.replace('>>',form1.presets.value);">


						<img src="/cfmx/rh/imagenes/rev.gif" border="0" align="top" hspace="2">
						<!---<font size="+2">---><cf_translate key="LB_CopiarEntrada">Copiar Entrada </cf_translate></font>
					</td>
				</tr>
				<tr align="left" valign="top">
					<td>

					<cfquery datasource="#Session.DSN#" name="rsListaMetricas">
					  select
						MIGMid,
						MIGMcodigo,
						MIGMnombre,
						MIGRecodigo,
						MIGMdescripcion,
						MIGMnpresentacion,
						MIGMsequencia,
						Ucodigo,
						MIGMcalculo,
						Ecodigo
					  from MIGMetricas
					 where Dactiva = 1
					 <cfif not isdefined('rsMetricas.MIGMescorporativo') or not len(trim(rsMetricas.MIGMescorporativo)) or rsMetricas.MIGMescorporativo EQ 0>
					 and Ecodigo = #session.Ecodigo#
					 </cfif>
					 and CEcodigo = #session.CEcodigo#
					 order by MIGMnombre
					</cfquery>

					<cfoutput>
						<select name="presets" size="15" style="height:225px; font-size:10px;overflow:auto;border:solid 1px;width:100%"  onchange="dispDesc(value)">
							<cfloop query="rsListaMetricas">
							<option value="#rsListaMetricas.MIGMcodigo#" title="Empresa=#rsListaMetricas.Ecodigo#  codigo=#rsListaMetricas.MIGMcodigo# ">
							#rsListaMetricas.MIGMnombre#
							</option>
							</cfloop>
						</select>
					</cfoutput>

					</td>
				</tr>


			</table>
		</fieldset>

		<fieldset>
			<legend><r1><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></r1></legend>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr align="left" valign="top">
					<td>
						<div id="preset_description">&nbsp;</div>
					</td>
				</tr>
			</table>
		</fieldset>

				<!--- AREA 4 SALIDA--->
					<tr align="left" valign="top">
						<td colspan="2">
							<fieldset>
								<legend><cf_translate key="LB_Salidas">Salidas</cf_translate></legend>
								<div id=scroll style="OVERFLOW: auto; HEIGHT: 80px">
								<table width="100%"  height="10%" border="0" cellpadding="0" cellspacing="0">
									<tr align="left" valign="top">
										<td>
											<cfparam name="calc_error" default="">
											<cfif Len(calc_error) GT 0>
												<font color="red"><cfoutput>#calc_error#</cfoutput></font><br>
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

<script type="text/javascript">

function  funcGuardar(){
	document.form1.Boton.value = "GUARDAFORMULA";
	document.form1.action = "MetricasSQL.cfm";
	document.form1.submit();
}

function  funcRegresar(){
    <cfif isdefined ('URL.esMetric') and URL.esMetric eq 'M'>
	document.form1.action = "Metricas.cfm" + "?modo=<cfoutput>#form.modo#</cfoutput>";
	<cfelse>
	document.form1.action = "Indicadores.cfm" + "?modo=<cfoutput>#form.modo#</cfoutput>";
	</cfif>
	document.form1.submit();
}


function  funcAyudaPantalla(){
		var PARAM  = "AyudaFormular.cfm"
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=1000,height=600')
	}

function  funcValidar(){
	document.form1.Boton.value = "VALIDAR";
	document.form1.action = "";
	document.form1.submit();

}
<cfoutput>
function funcRestablecer(){
	<cfif form.modo EQ "CAMBIO">
		document.form1.formulas.value = "#trim(rsMetricas.MIGMcalculo)#";
		funcValidar();
	</cfif>
}
</cfoutput>


preset_info = new Object();

function dispDesc(c) {

	var info = preset_info[c.toLowerCase()];
	var elctl = document.all?document.all.preset_description:document.getElementById("preset_description");
	elctl.innerHTML = "<b>" + c + "</b><br>" + preset_info[c.toLowerCase()];
	elctl.style.display = info ? "inline" : "none";
}

 <cfloop query="rsListaMetricas">
<cfoutput>
	preset_info["# LCase( JSStringFormat (rsListaMetricas.MIGMcodigo) ) #"] = "#JSStringFormat (rsListaMetricas.MIGMdescripcion) #";
</cfoutput>
</cfloop>

</script>

</form>

	<cf_web_portlet_end>
<cf_templatefooter>

