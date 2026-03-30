<!--- FUNCIÓN QUE DEVUELVE LOS NOMBRE DE LOS MESES --->
<cffunction name="getMesNombre" access="public" output="false"  returntype="string">
<cfargument name="numMes" default="#Month(Now())#" hint="Número de Mes" type="numeric">
	<cfswitch expression="#Arguments.numMes#">
		<cfcase value="1"><cfset returnValue  = "Enero"></cfcase>
		<cfcase value="2"><cfset returnValue  = "Febrero"></cfcase>
		<cfcase value="3"><cfset returnValue  = "Marzo"></cfcase>
		<cfcase value="4"><cfset returnValue  = "Abril"></cfcase>
		<cfcase value="5"><cfset returnValue  = "Mayo"></cfcase>
		<cfcase value="6"><cfset returnValue  = "Junio"></cfcase>
		<cfcase value="7"><cfset returnValue  = "Julio"></cfcase>
		<cfcase value="8"><cfset returnValue  = "Agosto"></cfcase>
		<cfcase value="9"><cfset returnValue  = "Setiembre"></cfcase>
		<cfcase value="10"><cfset returnValue = "Octubre"></cfcase>
		<cfcase value="11"><cfset returnValue = "Noviembre"></cfcase>
		<cfcase value="12"><cfset returnValue = "Diciembre"></cfcase>
	</cfswitch>
	<cfreturn returnValue>
</cffunction>

<cfif isdefined("form.periodo") and isdefined("form.mes") and isdefined("form.periodoAux") and isdefined("form.mesAux") and isdefined("form.mesFiscal")
  and len(trim(form.periodo)) gt 0 and len(trim(form.mes)) gt 0 and len(trim(form.periodoAux)) gt 0 and len(trim(form.mesAux)) gt 0 and len(trim(form.mesFiscal)) gt 0>
<cfelse>
	<cflocation url="wizGeneral01.cfm">
</cfif>

<script language="javascript" type="text/javascript">
	// función para devolverse a la pantalla anterior
	function doAnterior() {
		document.form1.action = "wizGeneral02.cfm";
		return true;
	}
</script>

<cfoutput>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="3">&nbsp;</td></tr>

	<tr>
		<td>
			<!---Para crear una nueva <strong>empresa</strong> por favor complete el siguiente formulario.<br><br>
			Debe asegurarse de que el <strong>cache</strong> escogido sea el correcto ya que una vez guardados los datos de la empresa, el cache <strong>NO</strong> puede ser modificado.<br><br>
			Después de haber llenado el formulario, haga click en <font color="##0000FF">Siguiente >></font> para continuar.<br><br>
			Si desea trabajar con una empresa diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Empresa</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.--->
		</td>

		<td style="padding-left: 5px; padding-right: 5px;" valign="top">
			<form name="form1" action="wizGeneralSQL.cfm" method="post">
				<input type="hidden" value="#form.periodo#" name="periodo">
				<input type="hidden" value="#form.mes#" name="mes">
				<input type="hidden" value="#form.periodoAux#" name="periodoAux">
				<input type="hidden" value="#form.mesAux#" name="mesAux">
				<input type="hidden" value="#form.mesFiscal#" name="mesFiscal">
				<input type="hidden" value="#form.WTCid#" name="WTCid">
				<input type="hidden" value="#form.mascara#" name="mascara">

				<table border="0" width="95%" cellpadding="2" cellspacing="0" align="center">
					<tr><td align="center"><b><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Resumen de Configuraci&oacute;n</strong></b></td></tr>	
					<tr><td>&nbsp;</td></tr>
					<tr>
					<td align="center">
						<fieldset><legend align="center"><font size="2"><b> Per&iacute;odo y Mes Contables:&nbsp;</b></font></legend>
							<table border="0" width="100%" cellpadding="2" cellspacing="0">
								<tr>
									<td width="25%" class="etiquetaCampo" align="right" nowrap><font size="2">Per&iacute;odo:</font></td>
									<td width="25%" align="left" nowrap ><font size="2"><font size="2">#form.periodo#</font></td>
									<td width="25%" class="etiquetaCampo" align="right" nowrap><font size="2">Mes:</font></td>
									<td width="25%" align="left" nowrap><font size="2">#getMesNombre(form.mes)#</font>
									</td>
								</tr>
							</table>
							</fieldset>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					<td align="center">
						<fieldset><legend align="center"><font size="2"><b> Per&iacute;odo y Mes Auxiliares:&nbsp;</b></font></legend>
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td width="25%" class="etiquetaCampo" align="right" nowrap><font size="2"> Per&iacute;odo: </font></td>
								<td width="25%" align="left" nowrap><font size="2">#form.periodoAux#</font></td>
								<td width="25%" class="etiquetaCampo" align="right" nowrap><font size="2">Mes:</font></td>
								<td width="25%" align="left" nowrap><font size="2">#getMesNombre(form.mesAux)#</font></td>
							</tr>
						</table>
							</fieldset>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					<td align="center">
						<fieldset><legend align="center"><font size="2"><b> Mes Fiscal:&nbsp;</b></font></legend>
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
						<tr>
						<td width="25%" class="etiquetaCampo" align="right" nowrap><font size="2">Mes:</font></td>
						<td width="25%" align="left" nowrap><font size="2">#getMesNombre(form.mesFiscal)#</font></td>
						<td width="25%" class="etiquetaCampo" align="right" nowrap>&nbsp;</td>
						<td width="25%" align="left" nowrap>&nbsp;</td>
						</tr>
						</table>
						</fieldset>
						</td>
					</tr>

					<cfif isdefined("form.WTCid") and form.WTCid neq 0>
						<cfquery name="rsCatalogo" datasource="asp"	>
							select WECdescripcion, WTCmascara
							from WTContable
							where WTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.WTCid#">
						</cfquery>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">
								<fieldset><legend align="center"><font size="2"><b> Cat&aacute;logo Contable:&nbsp;</b></font></legend>
									<table border="0" width="100%" cellpadding="2" cellspacing="0">
										<tr>
											<td width="35%" class="etiquetaCampo" align="right" nowrap><font size="2">Cat&aacute;logo Contable:</font></td>
											<td width="65%" align="left" nowrap><font size="2">#rsCatalogo.WECdescripcion#</font></td>
										</tr>		
										<tr>
											<td width="35%" class="etiquetaCampo" align="right" nowrap><font size="2">M&aacute;scara:</font></td>
											<td width="65%" align="left" nowrap><font size="2">#rsCatalogo.WTCmascara#</font></td>
										</tr>
									</table>
							</fieldset>
							</td>
						</tr>
					</cfif>		

					<tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center">
					<input type="submit" name="anterior" id="anterior" value=" << Anterior " onclick="javascript: doAnterior();">					
					<input name="Siguiente" type="submit" value="Terminar" onClick="javascript: if (confirm('Desea guardar la configuración seleccionada?')){return true;}else{return false;}">
					</td></tr>
				</table>
			</form>
		</td>
			
		<td width="1%" valign="top">
			<cfset thisForm = 1>
			<cfinclude template="frame-Progreso.cfm">
		</td>
	</tr>
</table>
</cfoutput>
