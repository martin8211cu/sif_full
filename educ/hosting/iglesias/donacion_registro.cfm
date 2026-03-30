<cfif isdefined("form.MEDdonacion") and len(trim(form.MEDdonacion)) gt 0>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif ucase(modo) neq "ALTA">
	<cfquery name="rsMEDDonacion" datasource="#Session.DSN#">
		select a.MEDproyecto, a.MEpersona as MEEid, a.MEDfecha, a.MEDmoneda, a.MEDimporte, a.MEDforma_pago, a.MEDchbanco, 
		a.MEDchcuenta, a.MEDchnumero, a.MEDtctipo, a.MEDtcnumero, a.MEDtcvence, a.MEDdescripcion, a.MEDcompromiso, isnull(b.Pnombre, 'Anónimo') + ' ' + isnull(b.Papellido1, '') as MEEnombre
		from MEDDonacion a, MEPersona b
		where MEDdonacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MEDdonacion#">
		and a.MEpersona *= b.MEpersona
	</cfquery>
</cfif>

<cfquery name="proyectos" datasource="#session.dsn#">
	select MEDproyecto, MEDnombre
	from MEDProyecto 
	where Ecodigo = #session.Ecodigo#
	  and (MEDinicio is null or getdate() >= MEDinicio )
	  and (MEDfinal  is null or getdate() < dateadd(dd,1,MEDfinal) )
	order by MEDprioridad
</cfquery>

<cfquery name="donaciones" datasource="#session.dsn#" maxrows="10">
	select a.MEDdonacion, a.MEDfecha, a.MEDimporte, a.MEDmoneda, coalesce(c.Pnombre, 'Anónimo') +  ' ' + coalesce(c.Papellido1, '')  as MEEnombre,
		a.MEDforma_pago, a.MEDdescripcion, b.MEDnombre
	from MEDDonacion a, MEDProyecto b, MEPersona c
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  <!--- and METSid != #session.METSid# --->
	  and a.MEDproyecto = b.MEDproyecto
	  and (a.MEDforma_pago = 'S' or a.MEDimporte != 0)
	  and c.MEpersona =* a.MEpersona
	order by MEDfecha desc
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Donaciones : Registro
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">
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
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr><td valign="top">
	<strong>Registrar donaci&oacute;n</strong>
	<cfoutput>
	<form name="fLista" action="donacion_registro.cfm" style="border-style:none " method="post">
		<input type="hidden" name="MEDdonacion" id="MEDdonacion" value="">
	</form>
	<form action="donacion_apply.cfm" method="post" name="form1" style="margin:0" onSubmit="javascript:return finalizar();" onReset="det_forma_pago('E');">
		<cfif ucase(modo) neq "ALTA">
		<input type="hidden" name="MEDdonacion" id="MEDdonacion" value="#form.MEDdonacion#">
		</cfif>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td nowrap>Fecha</td>
			<td nowrap>Donante</td>
			</tr>
		  <tr>
			<td>
			<cfif ucase(modo) neq "ALTA">
				<cf_sifcalendario name="MEDfecha" value="#LSDateFormat(rsMEDDonacion.MEDfecha,'dd/mm/yyyy')#">
			<cfelse>
				<cf_sifcalendario name="MEDfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
			</cfif>
			</td>
			<td><input readonly="true" type="text" name="MEEnombre" <cfif ucase(modo) neq "ALTA">value="#rsMEDDonacion.MEEnombre#"<cfelse>value="Anónimo"</cfif>>
				<input type="hidden" name="MEEid" <cfif ucase(modo) neq "ALTA">value="#rsMEDDonacion.MEEid#"</cfif>>
				<a href="javascript:doConlisEntidad()">
				<img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Seleccionar donante" border="0" width="16" height="14" onClick="doConlisEntidad()"></a></td>
			</tr>
		  <tr>
			<td nowrap>Para</td>
			<td nowrap><select name="MEDproyecto">
			  <cfloop query="proyectos">
			  <option value="#MEDproyecto#" <cfif ucase(modo) neq "ALTA" and rsMEDDonacion.MEDproyecto eq MEDproyecto> selected </cfif>>#MEDnombre#</option>
			  </cfloop>
			</select></td>
			</tr>
		  <tr>
			<td nowrap>Recibimos en</td>
			<td nowrap>
			Importe    </td>
			</tr>
		  <tr>
			<td nowrap><select name="MEDforma_pago" onChange="det_forma_pago(this.value)" onclick="det_forma_pago(this.value)">
			  <option value="E" selected <cfif ucase(modo) neq "ALTA" and rsMEDDonacion.MEDforma_pago eq "E"> selected </cfif>>Efectivo</option>
			  <option value="C" <cfif ucase(modo) neq "ALTA" and rsMEDDonacion.MEDforma_pago eq "C"> selected </cfif>>Cheque</option>
			  <option value="T" <cfif ucase(modo) neq "ALTA" and rsMEDDonacion.MEDforma_pago eq "T"> selected </cfif>>Tarjeta de cr&eacute;dito</option>
			  <option value="S" <cfif ucase(modo) neq "ALTA" and rsMEDDonacion.MEDforma_pago eq "S"> selected </cfif>>Especie</option>
			</select></td>
			<td nowrap>
			<input name="MEDimporte" 
				type="text" 
				<cfif ucase(modo) neq "ALTA">
				value="#LSCurrencyFormat(rsMEDDonacion.MEDimporte,'none')#"
				<cfelse>
				value="0.00"
				</cfif>
				size="20"
				maxlength="18" 
				style="text-align: right"  
				onfocus="this.value=qf(this); this.select();" 
				onblur="javascript: fm(this,2);" 
				onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
			<select name="MEDmoneda">
				<option value="USD">USD</option>
				<option value="CRC" selected>CRC</option>
			</select>
			</td>
			</tr>
		  <tr id='trcheque' style="display:none;">
			<td colspan="2" nowrap>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td colspan="2">Banco</td>
				  </tr>
				<tr>
				  <td colspan="2"><input name="MEDchbanco" type="text" size="30" maxlength="60"
				onChange="value=value.toUpperCase()"
				onKeyPress="event.keyCode= String.fromCharCode(event.keyCode).toUpperCase().charCodeAt(0)"
				<cfif ucase(modo) neq "ALTA">
				value="#rsMEDDonacion.MEDchbanco#"
				</cfif>
				></td>
				  </tr>
				<tr>
				  <td >Cuenta No. </td>
				  <td >Cheque No. </td>
				</tr>
				<tr>
				  <td><input name="MEDchcuenta" type="text" size="20" maxlength="60"
						<cfif ucase(modo) neq "ALTA">
						value="#rsMEDDonacion.MEDchcuenta#"
						</cfif>>
				  </td>
				  <td><input name="MEDchnumero" type="text" size="20" maxlength="60"
						<cfif ucase(modo) neq "ALTA">
						value="#rsMEDDonacion.MEDchnumero#"
						</cfif>>
				  </td>
				</tr>
			  </table></td>
			</tr>
		  <tr id='trtarjeta' style="display:none;">
			<td colspan="2" nowrap>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td colspan="2" nowrap><input type="radio" name="MEDtctipo" id="radio" value="AMEX" <cfif modo neq "ALTA" and rsMEDDonacion.MEDtctipo eq "AMEX"> checked </cfif>>
						<img src="images/card/AMEX.gif" alt="American Express" width="35" height="36" onClick="document.form1.MEDtctipo_AMEX.checked=1" >&nbsp;
						<input type="radio" name="MEDtctipo" id="radio2" value="MC"  <cfif modo neq "ALTA" and rsMEDDonacion.MEDtctipo eq "MC"> checked </cfif>>
						<img src="images/card/MC.gif" alt="Master Card" width="45" height="29" onClick="document.form1.MEDtctipo_MC.checked=1" >&nbsp;
						<input type="radio" name="MEDtctipo" id="radio3" value="VISA"  <cfif (modo neq "ALTA" and rsMEDDonacion.MEDtctipo eq "VISA") or modo eq "ALTA"> checked </cfif>>
						<img src="images/card/VISA.gif" alt="Visa" width="38" height="24" onClick="document.form1.MEDtctipo_VISA.checked=1" >&nbsp; </td>
					  </tr>
					<tr>
					  <td>No. Tarjeta </td>
					  <td>Vencimiento</td>
					</tr>
					<tr>
					  <td><input name="MEDtcnumero" type="text" size="25" maxlength="20"
							<cfif ucase(modo) neq "ALTA">
							value="#rsMEDDonacion.MEDtcnumero#"
							</cfif>>
					  </td>
					  <td><input name="MEDtcvence" type="text" size="8" maxlength="4"
							<cfif ucase(modo) neq "ALTA">
							value="#rsMEDDonacion.MEDtcvence#"
							</cfif>>
					  </td>
					</tr>
				  </table></td>
			</tr>
		  <tr id='trespecie' style="display:none;">
			<td colspan="2">Descripci&oacute;n de la donaci&oacute;n en especie<br>      <textarea name="MEDdescripcion" cols="" rows="3" style="font-family:Arial,Helvetica,sans-serif;width:100%"><cfif modo neq "ALTA">#rsMEDDonacion.MEDdescripcion#</cfif></textarea></td>
		  </tr>
		  <tr>
			<td colspan="2">
				<cfinclude template="/sif/portlets/pBotones.cfm">
			</td>
		  </tr>
		</table>
	
	</form>
	</cfoutput>	
	</td>
  </tr>
  <tr>
	<td valign="top">


		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td colspan="5"><strong>&Uacute;ltimas 10 Donaciones</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td valign="top"><strong>Fecha</strong></td>
			<td valign="top" align="right" ><strong>Importe</strong></td>
			<td valign="top"><strong>Moneda</strong></td>
			<td valign="top"><strong>Donante</strong></td>
			<td valign="top"><strong>Proyecto</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  <cfif donaciones.RecordCount gt 0>
		  <cfoutput query="donaciones">
			  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left" width="18" height="18" nowrap>
				<cfif ucase(modo) neq 'ALTA' and donaciones.MEDdonacion eq form.MEDdonacion>
					<img src="/cfmx/sif/imagenes/addressGo.gif" width="18" height="18">
				</cfif>
				</td>
				<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="center" nowrap onclick="javascript: Procesar(#MEDdonacion#);"><a href="javascript:Procesar(#MEDdonacion#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSDateFormat(donaciones.MEDfecha,'dd/mm/yyy')#</a></td>
				<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="right" nowrap onclick="javascript: Procesar(#MEDdonacion#);"><a href="javascript:Procesar(#MEDdonacion#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSCurrencyFormat(donaciones.MEDimporte,'none')#</a></td>
				<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDdonacion#);"><a href="javascript:Procesar(#MEDdonacion#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#donaciones.MEDmoneda#</a></td>
				<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDdonacion#);"><a href="javascript:Procesar(#MEDdonacion#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#donaciones.MEEnombre#</a></td>
				<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDdonacion#);"><a href="javascript:Procesar(#MEDdonacion#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#donaciones.MEDnombre#</a></td>
				<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left" width="1%">&nbsp;</td>
			  </tr>
		  </cfoutput>
		  <cfelse>
		  <tr>
			<td>&nbsp;</td>
			<td colspan="5"><strong>No hay registros</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  </cfif>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		</table>


	</td>
  </tr>
</table>
<script language="javascript1.4" type="text/javascript">
	<!--

	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	var min = 0; max = 0;
	//Funciones adicionales de validación
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isFecha", _Field_isFecha);
	//descripciones		
	objForm.MEDfecha.description = "Fecha";
	objForm.MEEid.description = "Donante";
	objForm.MEDproyecto.description = "Proyecto";
	objForm.MEDforma_pago.description = "Forma de pago";
	objForm.MEDimporte.description = "Importe";
	
	objForm.MEDchbanco.description = "Banco del cheque";
	objForm.MEDchcuenta.description = "Cuenta del cheque";
	objForm.MEDchnumero.description = "Número de cheque";
	
	objForm.MEDtctipo.description = "Tipo de tarjeta";
	objForm.MEDtcnumero.description = "Número de tarjeta";
	objForm.MEDtcvence.description = "Fecha de vencimiento de la tarjeta";
	
	objForm.MEDdescripcion.description = "Descripcion de las especies";
	
	//requeridos
	objForm.MEDfecha.required = true;
	//objForm.MEEid.required = true;
	objForm.MEDproyecto.required = true;
	objForm.MEDforma_pago.required = true;
	objForm.MEDimporte.required = true;
	
	objForm.MEDchbanco.required = true;
	objForm.MEDchcuenta.required = true;
	objForm.MEDchnumero.required = true;
	
	objForm.MEDtctipo.required = true;
	objForm.MEDtcnumero.required = true;
	objForm.MEDtcvence.required = true;
	
	objForm.MEDdescripcion.required = true;
	
	//validaciones de tipos
	objForm.MEDfecha.validateFecha();
	min = 1; max = 999999999; objForm.MEDimporte.validateRange(min,max,'El campo ' + objForm.MEDimporte.description + ' contiene un valor fuera del rango permitido ('+min+' - '+max+').');

	//Function Finalizar
	function finalizar(){
		objForm.MEDimporte.obj.value = qf(objForm.MEDimporte.obj);
		return true;
	}
	
	function deshabilitarValidacion(){
	objForm.MEDfecha.required = false;
	objForm.MEEid.required = false;
	objForm.MEDproyecto.required = false;
	objForm.MEDforma_pago.required = false;
	objForm.MEDimporte.required = false;
	
	objForm.MEDchbanco.required = false;
	objForm.MEDchcuenta.required = false;
	objForm.MEDchnumero.required = false;
	
	objForm.MEDtctipo.required = false;
	objForm.MEDtcnumero.required = false;
	objForm.MEDtcvence.required = false;
	
	objForm.MEDdescripcion.required = false;
	}
	
	det_forma_pago(objForm.MEDforma_pago.getValue());
	-->
</script>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
