<cfif isdefined("form.cpcmes") and len(form.cpcmes)>
	<cfset escenariomes = getCVTCEscenarioMes(form.cvtid,form.cpcano,form.cpcmes,form.mcodigo)>
</cfif>
<cfquery name="MonedaEmpresa" datasource="#session.dsn#">
	Select m.Mcodigo, m.Mnombre
	from Empresas e
		inner join Monedas m
			on e.Mcodigo = m.Mcodigo
	where e.Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="monedas" datasource="#session.dsn#">
	Select Mcodigo, Mnombre
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	  and Mcodigo <> #MonedaEmpresa.Mcodigo#
  	order by Mnombre
</cfquery>
<cfquery name="meses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as mes, b.VSdesc as descripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfset anos = QueryNew("ano")>
<cfoutput>
<script language="JavaScript" type="text/JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="form2" method="post" action="#GCurrentPage#" onSubmit="javascript: __endform();">
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="3" class="AreaFiltro" height="25" valign="middle" align="center"><strong><cfif isdefined("escenariomes.cpcmes")>Modificaci&oacute;n de Tipo de Cambio<cfelse>Nuevo Tipo de Cambio</cfif></strong></td>
		</tr>
		<tr>
			<td align="left" width="40%">
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<tr>
						<td width="1%" nowrap><div align="right"><strong>Escenario&nbsp;:&nbsp;</strong></div></td>
						<td>#escenario.CVTdescripcion#</td>
					</tr>
					<tr>
						<td width="1%" nowrap><div align="right"><strong>Moneda&nbsp;:&nbsp;</strong></div></td>
						<td>
									<select name="Mcodigo" accesskey="1" tabindex="1" <cfif isdefined("escenariomes.cpcmes")>disabled</cfif>>
										<cfloop query="monedas">
										<option value="#monedas.Mcodigo#" 
											<cfif (isDefined("escenariomes.Mcodigo") AND monedas.Mcodigo EQ escenariomes.Mcodigo
											or not isDefined("escenariomes.Mcodigo") and monedas.Mcodigo EQ FORM.FMcodigo)>selected</cfif>>
											#monedas.Mnombre#
										</option>
										</cfloop>
									</select>
								</td>
					</tr>
					<tr>
						<td width="1%" nowrap><div align="right"><strong>A&ntilde;o&nbsp;:&nbsp;</strong></div></td>
						<td>
							<input type="text" name="CPCano" <cfif isdefined("escenariomes.cpcmes")>disabled</cfif>
									value="<cfif isDefined("escenariomes.CPCano")>#trim(escenariomes.CPCano)#<cfelseif NOT isDefined("escenariomes.CPCano")>#trim(form.fano)#</cfif>"
									size="4" maxlength="4">
						</td>
					</tr>
					<tr></tr>
						<td width="1%" nowrap><div align="right"><strong>Mes&nbsp;:&nbsp;</strong></div></td>
						<td>
							<select name="CPCmes" accesskey="3" tabindex="3" <cfif isdefined("escenariomes.cpcmes")>disabled</cfif>>
								<cfloop query="meses">
									<option value="#meses.mes#" <cfif (isDefined("escenariomes.CPCmes") AND meses.mes EQ escenariomes.CPCmes)>selected</cfif>>#meses.descripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td width="1%" nowrap><div align="right"><strong>TC.Compra&nbsp;:&nbsp;</strong></div></td>
						<td>
									<input name='CPTipoCambioCompra' 
										type='text' 
										style='text-align: right'  
										onFocus='this.value=qf(this); this.select();' 
										onBlur='javascript: fm(this,2);' 
										onKeyUp='if(snumber(this,event,2)){ if(Key(event)==13) {this.blur();}}'
										size='20' 
										maxlength='18'
									  accesskey="4" tabindex="4"
										value="<cfif isdefined('escenariomes.CPTipoCambioCompra')>#LSCurrencyFormat(escenariomes.CPTipoCambioCompra,'none')#<cfelse>0.00</cfif>">
								</td>
					</tr>
					<tr>
						<td width="1%" nowrap><div align="right"><strong>TC.Venta&nbsp;:&nbsp;</strong></div></td>
						<td>
									<input name='CPTipoCambioVenta' 
										type='text' 
										style='text-align: right'  
										onFocus='this.value=qf(this); this.select();' 
										onBlur='javascript: fm(this,2);' 
										onKeyUp='if(snumber(this,event,2)){ if(Key(event)==13) {this.blur();}}'
										size='20' 
										maxlength='18'
										accesskey="5" tabindex="5"
										value="<cfif isdefined('escenariomes.CPTipoCambioVenta')>#LSCurrencyFormat(escenariomes.CPTipoCambioVenta,'none')#<cfelse>0.00</cfif>">
								</td>
					</tr>
				</table>
			</td>
			<td width="45%" >&nbsp;
			<cfif isdefined("escenariomes.cpcmes")>
				<table width="100%" border="1" cellspacing="0" cellpadding="2">
					<tr>
						<td align="center">
							<table width="80%" border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td align="center" colspan="2"><strong>Proyectar Tipos Cambio a Futuro</strong></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td>
										<select name="tipoProyeccion">
											<option value="1">Aumentar Monto</option>
											<option value="2">Aumentar Porcentaje</option>
										</select>
									</td>
									<td nowrap>
										<input type="text" name="montoProyeccion"  size="6" maxlength="6"> por mes
									</td>
								</tr>
								<tr>
									<td>
										Para los próximos
									</td>
									<td nowrap>
										<input type="text" name="mesesProyeccion" size="2" maxlength="2"> meses
									</td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;
										
									</td>
								</tr>
								<tr>
									<td colspan="2" align="center">
									<input type="submit" name="btnProyectar" value="Proyectar"
										 onClick="
										 	if (document.form2.montoProyeccion.value == '')
												alert('Debe digitar el Monto o el Porcentaje a aumentar');
											else if (document.form2.mesesProyeccion.value == '')
												alert('Debe digitar el número de meses a Proyectar');
											else
												return true;
											return false;
										 		"
									>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			</cfif>
			<td width="1%">&nbsp;
			
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				<input name="CVTid" type="hidden" value="<cfif isDefined("escenario.CVTid")>#escenario.CVTid#</cfif>">
				<input name="ts" type="hidden" value="<cfif isDefined("escenariomes.ts")>#escenariomes.ts#</cfif>">
				<input name="btnMeses" type="hidden" value="1">
				<input name="PAGENUM" type="hidden" value="<cfif isDefined("form.PAGENUM")>#form.PAGENUM#</cfif>">
				<cf_botones form="form2" modocambio = "#isdefined("escenariomes.cpcmes")#" sufijo="Mes" include="Regresar" tabindex="6">
			</td>
		</tr>
	</table>
</form>
<script language='JavaScript' type='text/JavaScript' src='/cfmx/sif/js/qForms/qforms.js'></script>
<script language='javascript' type='text/JavaScript' >
<!--//
	qFormAPI.setLibraryPath('/cfmx/sif/js/qForms/');
	qFormAPI.include('*');
	qFormAPI.errorColor = '##FFFFCC';
	objForm2 = new qForm('form2');
	function __isAno(){
		if (!objForm2.allowsubmitonerror){
			if (this.value.length != 4 && this.value.length != 0)
			{
				this.error = "El año debe ser de 4 dígitos";
			}
		}
	}
	function __isPositiveFloat(){
		if (!objForm2.allowsubmitonerror){
			// check to make sure the current value is greater then zero
			if(parseFloat(this.value) < 0.01 ){
				// here's the error message to display
				this.error = "El campo " + this.description + " debe";
				this.error += " contenter un número mayor a 0.00.";
			}
		}
	}

	function fnAgregaHiddenTR(LprmTR)
	{
	  var LvarTD    = document.createElement("TD");
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = "TEXT";
	  LvarInp.name = "hdnCtas";
	  LvarInp.value = i;
	  LprmTR.appendChild(LvarTD);
	}
	_addValidator("isPositiveFloat", __isPositiveFloat);
	_addValidator("isAno", __isAno);
	objForm2.Mcodigo.description="#JSStringFormat('Descripción')#";
	objForm2.CPCano.description="#JSStringFormat('Año')#";
	objForm2.CPCmes.description="#JSStringFormat('Mes')#";
	objForm2.CPTipoCambioCompra.description="#JSStringFormat('TC.Compra')#";
	objForm2.CPTipoCambioVenta.description="#JSStringFormat('TC.Venta')#";
	objForm2.Mcodigo.required=true;
	objForm2.CPCano.required=true;
	objForm2.CPCano.validateAno();
	objForm2.CPCmes.required=true;
	objForm2.CPTipoCambioCompra.required=true;
	objForm2.CPTipoCambioCompra.validatePositiveFloat();
	objForm2.CPTipoCambioVenta.required=true;
	objForm2.CPTipoCambioVenta.validatePositiveFloat();
	<cfif isdefined("form.cpcmes")>
		objForm2.CPTipoCambioCompra.obj.focus();
	<cfelse>
		objForm2.Mcodigo.obj.focus();
	</cfif>
	function funcRegresarMes()
	{
		deshabilitarValidacionMes();
		document.location = "index.cfm";
		return false;
	}
	function funcNuevoMes(){deshabilitarValidacionMes();}
	function funcBajaMes(){deshabilitarValidacionMes();}
	function deshabilitarValidacionMes(){objForm2.optional('Mcodigo,CPCano,CPCmes,CPTipoCambioCompra,CPTipoCambioVenta');objForm2.allowsubmitonerror=true;}
	function __endform(){
		objForm2.CPTipoCambioCompra.obj.value=qf(objForm2.CPTipoCambioCompra.getValue());
		objForm2.CPTipoCambioVenta.obj.value=qf(objForm2.CPTipoCambioVenta.getValue());
		objForm2.Mcodigo.obj.disabled=false;
		objForm2.CPCano.obj.disabled=false;
		objForm2.CPCmes.obj.disabled=false;
	}
//-->
</script>
</cfoutput>