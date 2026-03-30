
<cfif isdefined("form.MEDdonacion") and len(trim(form.MEDdonacion)) gt 0>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!---
<cfif ucase(modo) neq "ALTA">
	<cfquery name="rsMEDDonacion" datasource="#Session.DSN#">
		select a.MEDproyecto, a.MEEid, a.MEDfecha, a.MEDmoneda, a.MEDimporte, a.MEDforma_pago, a.MEDchbanco, 
		a.MEDchcuenta, a.MEDchnumero, a.MEDtctipo, a.MEDtcnumero, a.MEDtcvence, a.MEDdescripcion, a.MEDcompromiso, isnull(b.MEEnombre, 'Anónimo') MEEnombre
		from MEDDonacion a, MEEntidad b
		where MEDdonacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MEDdonacion#">
		and a.MEEid *= b.MEEid
	</cfquery>
</cfif>
--->

<cfquery name="proyectos" datasource="#session.dsn#">
	select MEDproyecto, MEDnombre
	from MEDProyecto 
	where Ecodigo = #session.Ecodigo#
	  and (MEDinicio is null or getdate() >= MEDinicio )
	  and (MEDfinal  is null or getdate() < dateadd(dd,1,MEDfinal) )
	order by MEDprioridad
</cfquery>

<cfquery datasource="asp" name="rsPais">
	select Ppais, Pnombre
	from Pais
	order by Pnombre
</cfquery>

<cfquery datasource="#session.DSN#" name="userdata">
	select Pdireccion, Pdireccion2, Pciudad, Pprovincia, PcodPostal, Ppais 
	from MEPersona
	where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">
</cfquery>

<cfquery datasource="#session.DSN#" name="tarjetas">
	select distinct
		convert(varchar,a.MEDtcid) as MEDtcid, a.MEDtctipo, a.MEDtcnumero, a.MEDtcvence, a.MEDtcnombre, 
		a.MEDtcdigito, a.MEDtcdireccion1, a.MEDtcdireccion2, 
		a.MEDtcciudad, a.MEDtcestado, a.MEDtcpais, a.MEDtczip
	from MEDTarjetas a
	where a.MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Registro de Donaciones
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/publico/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/publico/donacion.cfm">
	<cfinclude template="pNavegacion.cfm">

	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
	<!--
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}
	function show_if(n,v,fp){
		MM_findObj(n).style.display=(fp==v)?'inline':'none';
	}
	function det_forma_pago(fp){
		//var fp = document.form1.MEDforma_pago.value;
		show_if('trcheque',  'C',fp);
		show_if('trtarjeta', 'T',fp);
		show_if('trespecie', 'S',fp);

		objForm.MEDchbanco.required = ('C'==fp);
		objForm.MEDchcuenta.required = ('C'==fp);
		objForm.MEDchnumero.required = ('C'==fp);
		
		objForm.MEDtctipo.required = ('T'==fp);
		objForm.MEDtcnumero.required = ('T'==fp);
		objForm.MEDtcvence.required = ('T'==fp);
		
		objForm.MEDdescripcion.required = ('S'==fp);
		
		if (fp == 'E'){
			document.getElementById("trTitulo").style.display = 'none';
		}
		else{
			document.getElementById("trTitulo").style.display = 'inline';
		}
		
	}
	
	function doConlisEntidad(ContName,METEid,MEEid) {
		var width = 600;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('conlis_donadores.cfm?form=form1&id=MEEid&desc=MEEnombre','ListaEntidades','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
			
	function Procesar(p1) {
		document.fLista.MEDdonacion.value = p1;
		document.fLista.submit();
	}
	-->
</script>

	<table width="100%"  border="0" cellspacing="0" cellpadding="2" >
		<tr>
			<td width="1%">&nbsp;</td>
			<td align="center">
				<cf_web_portlet titulo="" border="true" skin="info1" >
					<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td width="80%">
								<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
									<tr><td align="center"><b>Donaciones por Internet</b></td></tr>
									<tr>
										<td><p>Si desea contribuir con nuestro esfuerzo de anunciar la Buena Nueva, puede hacer una donación a nuestra Iglesia. Sólo tiene que llenar el siguiente formulario.</p></td>  
									</tr>
									<tr>
										<td><p>Esta información es totalmente confidencial y la misma está protegida para máxima seguridad. Ningún usuario del Internet puede leer esta información, la misma ha sido codificada exclusivamente para nuestra Iglesia.</p></td>
									</tr>
								</table>
							</td>
							<td width="20%" align="center" valign="middle"><img border="0" src="images/Verisign-Secure-White98x102.gif" ></td>
						</tr>
					</table>
				</cf_web_portlet>
			</td>
			<td colspan="2" valign="middle" align="center"></td>
		</tr>

		<tr>
			<td width="1%">&nbsp;</td>
			<td valign="top" colspan="3">
				<cfoutput>
				<form name="fLista" action="donacion_confirmar.cfm" style="border-style:none " method="post">
					<input type="hidden" name="MEDdonacion" id="MEDdonacion" value="">
				</form>

				<form action="donacion_confirmar.cfm" method="post" name="form1" style="margin:0" onSubmit="javascript:return finalizar();" >
					<cfif isdefined("session.MEEid") and len(trim(session.MEEid)) gt 0><input type="hidden" name="MEEid" value="#session.MEEid#"></cfif>
					<input type="hidden" name="MEDfecha" value="#LSDateFormat(Now(),'yyyymmdd')#">
		
					<cfif ucase(modo) neq "ALTA">
						<input type="hidden" name="MEDdonacion" id="MEDdonacion" value="#form.MEDdonacion#">
					</cfif>

					<table width="100%"  border="0" cellspacing="0" cellpadding="3" style="border-top-width:1px; border-top-style:solid; border-top-color:##999999; border-left-width:1px; border-left-style:solid; border-left-color:##999999; border-right-width:1px; border-right-style:solid; border-right-color:##999999; border-bottom-width:1px; border-bottom-style:solid; border-bottom-color:##999999;">

						<tr><td colspan="4" class="tituloListas" align="center">Donación</td></tr>

						<tr>
							<td width="1%">&nbsp;</td>
							<td nowrap align="right"><b>Concepto/Proyecto:&nbsp;</b></td>
							<td nowrap valign="top">
								<select name="MEDproyecto">
									<cfloop query="proyectos">
										<option value="#MEDproyecto#" <cfif isdefined("form.MEDproyecto") and form.MEDproyecto eq proyectos.MEDproyecto> selected </cfif>>#proyectos.MEDnombre#</option>
									</cfloop>
								</select>
							</td>
						</tr>

						<tr>
							<td>&nbsp;</td>
							<td nowrap align="right"><b>Monto:&nbsp;</b></td>
							<td nowrap>
								<input name="MEDimporte" type="text"  
									style="text-align: right;"
									value="<cfif isdefined("form.MEDimporte") and len(trim(form.MEDimporte)) gt 0 >#trim(form.MEDimporte)#<cfelse>0.00</cfif>"
									size="20" maxlength="18"  onfocus="this.value=qf(this); this.select();" 
									onblur="javascript: fm(this,2);" 
									onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
								
								<select name="MEDmoneda">
									<option value="USD" <cfif isdefined("form.MEDmoneda") and form.MEDmoneda eq 'USD'>selected</cfif> >USD</option>
									<option value="CRC" <cfif isdefined("form.MEDmoneda") and form.MEDmoneda eq 'CRC'>selected</cfif> >CRC</option>
								</select>
							</td>
						</tr>
		
						<tr>
							<td>&nbsp;</td>
							<td align="right"><b>Fecha:</b>&nbsp;</td>
							<td><b>#LSDateFormat(Now(),'dd/mm/yyyy')#</b></td>
						</tr>

						<tr>
							<td>&nbsp;</td>
							<td align="right" valign="top"><b>Observaciones:</b>&nbsp;</td>
							<td><textarea name="MEDdescripcion" cols="35" rows="3"><cfif isdefined("form.MEDdescripcion")>#form.MEDdescripcion#</cfif></textarea></td>
						</tr>

						<!---
						<tr>
							<td nowrap valign="baseline"></td>
							<td nowrap valign="top"></td>
							<td nowrap ><input name="anonimo" type="checkbox">Registrar donaci&oacute;n de forma an&oacute;nima.</td>

						</tr>
						--->
						
						<tr><td colspan="2" align="center">&nbsp;</td></tr>
						<tr id="trTitulo"><td colspan="4" class="tituloListas" align="center">Forma de Pago</td></tr>

						<cfif not isdefined("form.btnOtra") and tarjetas.RecordCount gt 0 >	
							<cfif tarjetas.RecordCount gt 0>
								<tr>
									<td colspan="3">
										<table width="100%" cellpadding="0" cellspacing="0" >
											<cfparam name="form.tarjeta" default="#tarjetas.MEDtcid#">
											<cfloop query="tarjetas">
												<tr>
													<td valign="top" width="%"><input type="radio" value="#tarjetas.MEDtcid#" name="tarjeta" <cfif tarjetas.MEDtcid eq form.tarjeta >checked</cfif>></td>
													<td>
														<table border="0" width="100%" cellpadding="0" cellspacing="0">
															<tr>
																<td><b>Tipo de Tarjeta</b></td>
																<td width="1%">&nbsp;</td>
																<td><cfif tarjetas.MEDtctipo eq 'VISA' >VISA<cfelseif tarjetas.MEDtctipo eq 'AMEX' >AMEX<cfelseif trim(tarjetas.MEDtctipo) eq 'MC'>MASTERCARD</cfif></td>
																<td align="right"><a href="javascript:Editar(#MEDtcid#)">Editar</a> | <a href="javascript:Eliminar(#MEDtcid#)">Eliminar</a> </td>
															</tr>
															<tr>
																<td nowrap width="1%"><b>N&uacute;mero</b></td>
																<td width="1%">&nbsp;</td>
																<td colspan="2">#repeatstring('X', max(8,len(trim(tarjetas.MEDtcnumero))-4))##right(trim(tarjetas.MEDtcnumero), 4)#</td>
															</tr>
															<tr>
																<td nowrap width="1%"><b>Nombre como aparece en la tarjeta</b></td>
																<td width="1%">&nbsp;</td>
																<td colspan="2">#tarjetas.MEDtcnombre#</td>
															</tr>
															<tr>
																<td nowrap width="1%"><b>Vencimiento</b></td>
																<td width="1%">&nbsp;</td>
																<td colspan="2">#tarjetas.MEDtcvence#</td>
															</tr>
															<tr>
																<td nowrap width="1%"><b>Código Postal</b></td>
																<td width="1%">&nbsp;</td>
																<td colspan="2">#tarjetas.MEDtczip#</td>
															</tr>
															<tr>
																<td nowrap width="1%"></td>
																<td width="1%">&nbsp;</td>
															</tr>
															<tr>
																<td nowrap width="1%"></td>
																<td width="1%">&nbsp;</td>
															</tr>
														</table>
													</td>
												</tr>
												<tr><td colspan="2"><hr size="1%"></td></tr>
											</cfloop>
										</table>
									</td>
								</tr>
							</cfif>
						<cfelse>
							<tr>
								<td colspan="4" nowrap>
									<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	
										<tr>
											<td align="right"><b>Tipo de Tarjeta:&nbsp;</b></td>
											<td>
												<select name="MEDtctipo">
													<option value="VISA">Tarjeta de Crédito VISA</option>
													<option value="AMEX">Tarjeta de Crédito American Express</option>
													<option value="MC">Tarjeta de Crédito MasterCard</option>
												</select>
											</td>
										</tr>
										
										<tr>
											<td align="right"><b>No. Tarjeta:&nbsp;</b></td>
											<td>
												<input name="MEDtcnumero" type="text" size="25" maxlength="20" value="">
											</td>
										</tr>
										
										<tr>
											<td nowrap align="right"><b>Nombre como aparece en la Tarjeta:&nbsp;</b></td>
											<td valign="top">
												<input name="MEDtcnombre" type="text" size="35" maxlength="60"	>
											</td>
										</tr>
	
										<tr>
											<td nowrap align="right"><b>Vencimiento:&nbsp;</b></td>
											<td>
												<select name="mm">
													<option value="01">01 - Enero</option> 
													<option value="02">02 - Febrero</option> 
													<option value="03">03 - Marzo</option> 
													<option value="04">04 - Abril</option> 
													<option value="05">05 - Mayo</option> 
													<option value="06">06 - Junio</option> 
													<option value="07">07 - Julio</option> 
													<option value="08">08 - Agosto</option> 
													<option value="09">09 - Setiembre</option> 
													<option value="10">10 - Octubre</option> 
													<option value="11">11 - Noviembre</option> 
													<option value="12">12 - Diciembre</option> 
												</select>
												<select name="yy" >
													<cfset ano = DatePart('yyyy', Now())>
													<cfloop from="#ano#" to="#ano+20#" step="1" index="i">
														<option value="#i#">#i#</option>
													</cfloop>
												</select>
											</td>
										</tr>
	
										<tr>
											<td nowrap align="right"><b>Dígito Verificador:&nbsp;</b></td>
											<td><input name="MEDtcdigito" type="text" size="8" maxlength="5"></td>
										</tr>
	
										<tr>
											<td nowrap align="right"><b>Dirección 1:&nbsp;</b></td>
											<td ><input name="MEDtcdireccion1" size="70" maxlength="255" value="#userdata.Pdireccion#" ></td>
										</tr>
							
										<tr>
											<td nowrap align="right"><b>Dirección 2:&nbsp;</b></td>
											<td ><input name="MEDtcdireccion2" size="70" maxlength="255"  value="#userdata.Pdireccion2#"  ></td>
										</tr>
	
										<tr>
											<td align="right"><b>Ciudad:&nbsp;</b></td>
											<td valign="top"><input name="MEDtcciudad" type="text" size="30" maxlength="30" value="#userdata.Pciudad#" ></td>
										</tr>
	
										<tr>
											<td align="right"><b>Estado:&nbsp;</b></td>
											<td valign="top"><input name="MEDtcestado" type="text" size="30" maxlength="30" value="#userdata.Pprovincia#" ></td>
										</tr>
	
										<tr>
											<td align="right"><b>Código Postal:&nbsp;</b></td>
											<td valign="top"><input name="MEDtczip" type="text" size="30" maxlength="60" value="#userdata.Pcodpostal#"></td>
										</tr>
	
										<tr>
											<td align="right"><b>País:&nbsp;</b></td>
											<td valign="top">
												<select name="MEDtcpais">
													<cfloop query="rsPais">
														<option value="#rsPais.Ppais#" <cfif userdata.Ppais eq  rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
													</cfloop>
												</select>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</cfif>

						<tr><td colspan="4">&nbsp;</td></tr>		
						<tr>
							<td colspan="3" align="center">
								<CFIF not isdefined("btnOtra") and tarjetas.RecordCount gt 0 ><input type="submit" name="btnOtra" value="Pagar con Otra Tarjeta" onClick="deshabilitarValidacion(); document.form1.action='';"></CFIF>
								<input type="submit" name="Alta" value="Siguiente">
							</td>
						</tr>

						<tr><td colspan="4">&nbsp;</td></tr>		
	
					</table>
					<input type="hidden" name="tarjeta_id" id="tarjeta_id" value="">
				</form>
			</cfoutput>	
		</td>
		<td valign="top"><!--- <img border="0" src="images/Verisign-Secure-White98x102.gif" > ---></td>
		<td width="1%">&nbsp;</td>
	</tr>
</table>

<script language="javascript1.4" type="text/javascript">
	<!--

	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	var min = 0; max = 0;
	//Funciones adicionales de validación
	
	/*
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isFecha", _Field_isFecha);
	*/
	//descripciones		
	objForm.MEDproyecto.description = "Proyecto";
	objForm.MEDimporte.description = "Monto";

	<cfif isdefined("form.btnOtra") or tarjetas.RecordCount eq 0>
		objForm.MEDtctipo.description = "Tipo de Tarjeta";
		objForm.MEDtcnumero.description = "Número de Tarjeta";
		objForm.MEDtcnombre.description = "Nombre en la Tarjeta";
		objForm.MEDtcdigito.description = "Dígito Verificador";
		objForm.MEDtcdireccion1.description = "Dirección 1";
		objForm.MEDtcdireccion2.description = "Dirección 2";	
		objForm.MEDtcciudad.description = "Ciudad";
		objForm.MEDtcestado.description = "Estado";
		objForm.MEDtczip.description = "Código Postal";
		objForm.MEDtcpais.description = "País";
	</cfif>
	
	//requeridos
	objForm.MEDproyecto.required = true;
	objForm.MEDimporte.required = true;
	
	<cfif isdefined("form.btnOtra")  or tarjetas.RecordCount eq 0>
		objForm.MEDtctipo.required = true;
		objForm.MEDtcnumero.required = true;
		objForm.MEDtcnombre.required = true;
		objForm.MEDtcdigito.required = true;
		objForm.MEDtcdireccion1.required = true;
		//objForm.MEDtcdireccion2.required = true;	
		objForm.MEDtcciudad.required = true;
		objForm.MEDtczip.required = true;
		//objForm.MEDtcestado.required = true;
		objForm.MEDtcpais.required = true;
	
	</cfif>

		//validaciones de tipos
		//objForm.MEDfecha.validateFecha();
		min = 1; max = 999999999; 
		objForm.MEDimporte.validateRange(min,max,'El campo ' + objForm.MEDimporte.description + ' contiene un valor fuera del rango permitido ('+min+' - '+max+').');


	//Function Finalizar
	function finalizar(){
		objForm.MEDimporte.obj.value = qf(objForm.MEDimporte.obj);
		return true;
	}

	function deshabilitarValidacion(){
		//requeridos
		objForm.MEDproyecto.required = false;
		objForm.MEDimporte.required = false;
		
			objForm._allowSubmitOnError = true;
			objForm._showAlerts = false;

		<cfif isdefined("form.btnOtra") >
			objForm.MEDtctipo.required = false;
			objForm.MEDtcnumero.required = false;
			objForm.MEDtcnombre.required = false;
			objForm.MEDtcdigito.required = false;
			objForm.MEDtcdireccion1.required = false;
			objForm.MEDtcciudad.required = false;
			objForm.MEDtczip.required = false;
			objForm.MEDtcpais.required = false;
			
		</cfif>
		
	}
	
	function Editar(numeroid) {
		var f = document.form1;
		f.tarjeta_id.value=numeroid;
		f.action='tarjeta_edit.cfm';
		deshabilitarValidacion();
		f.submit();
	}
	
	function Eliminar(numeroid) {
		var f = document.form1;
		f.tarjeta_id.value=numeroid;
		f.action='tarjeta_delete.cfm';
		deshabilitarValidacion();
		f.submit();
	}
	
	//det_forma_pago(objForm.MEDforma_pago.getValue());
	-->
</script>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
