
<!-- Establecimiento del modo -->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined('Form.NuevoL')>
		<cfset modo="ALTA">
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("Form.DMlinea")>
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.DMlinea")>
		<cfset dmodo="ALTA">
	<cfelseif form.dmodo EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo="ALTA">
	</cfif>
</cfif>

<!-- Consultas -->

<!-- 1. Form -->
<cfquery datasource="#Session.DSN#" name="rsForm">
	select em.EMid, em.BTid, em.CBid, em.EMtipocambio, em.EMdocumento, em.EMreferencia, em.EMfecha, 
	       em.EMdescripcion, em.EMtotal, cb.CBdescripcion, cb.Bid, cb.Mcodigo, Mnombre, em.Ocodigo, em.ts_rversion
	
	from EMovimientos em

		inner join CuentasBancos cb
			on em.CBid=cb.CBid
			and  em.Ecodigo=cb.Ecodigo
						
			inner join  Monedas m
				on cb.Mcodigo=m.Mcodigo

	where em.Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	  and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  	
	  <cfif isdefined("Form.EMid") and Form.EMid NEQ "" >
		  and EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
	  </cfif>
</cfquery>

<!-- 2. Combo Tipos de Transaccion -->
<cfquery datasource="#Session.DSN#" name="rsTipos">
	select BTid, BTdescripcion 
	from BTransacciones
	where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	order by BTdescripcion
</cfquery>

<!-- 3. Combo Bancos -->
<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid, Bdescripcion 
	from Bancos 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
	order by upper(Bdescripcion)
</cfquery>

<!--- 4. Documentos existentes --->
<cfquery datasource="#Session.DSN#" name="rsDocumentos">
	select rtrim(EMdocumento) as EMdocumento
	from EMovimientos 
	where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 	
	<cfif isdefined("Form.EMid") and Form.EMid NEQ "" >
	    and EMdocumento not in  ( select EMdocumento 
						       from EMovimientos
						       where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
								 and EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric"> )
	</cfif>							 
</cfquery>

<!--- 5. Moneda --->
<cfquery datasource="#Session.DSN#" name="rsEmoneda">
	select Mcodigo
	from Empresas
	where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 	
</cfquery>

<!--- 6. Oficinas --->
<cfquery datasource="#Session.DSN#" name="rsOficinas">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 	
</cfquery>

<!-- Seccion del detalle -->

<!--- Form de Detalle --->
<!--- 1.form --->
<cfquery datasource="#Session.DSN#" name="rsDForm">	
	select a.EMid, a.DMlinea, a.Ecodigo, a.Ccuenta, a.Dcodigo, a.DMmonto, a.DMdescripcion, Cformato, Cdescripcion, a.ts_rversion, a.CFid
	from DMovimientos a
		inner join CContables b
		 	on a.Ecodigo=b.Ecodigo	
			and  a.Ccuenta=b.Ccuenta	
	where a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	
	<cfif isdefined("Form.DMlinea") and Form.DMlinea NEQ "" >	
	    and a.EMid    = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric"> 
		and a.DMlinea = <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric"> 
	</cfif>	
</cfquery>

<!--- 2. Cuebntas Contables --->
<cfquery datasource="#Session.DSN#" name="rsCuenta">
	select Ccuenta, Cdescripcion
	from CContables 
	where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	  and Cmovimiento='S' 
	  and Mcodigo=6
	  and Ccuenta not in (
					select b.Ccuenta from EMovimientos a
						inner join  CuentasBancos b
							on a.CBid = b.CBid 
							and a.Ecodigo = b.Ecodigo
                            and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit" >
					)
	order by Cdescripcion			
</cfquery>

<!--- 3. Departamentos --->	
<cfquery datasource="#Session.DSN#" name="rsDepartamentos">
	select Dcodigo, Ddescripcion
	from Departamentos 
	where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Ddescripcion
</cfquery>	

<cfquery datasource="#Session.DSN#" name="rsFormLineas">

	select count(*) as lineas from DMovimientos
	<cfif isdefined("Form.EMid") and Form.EMid NEQ "" >
		where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
	</cfif>

</cfquery>	

<!----4. Parámetro Indica cuenta manuales ----->
<cfquery name="rsIndicador" datasource="#session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >	
		and Pcodigo = 2 
</cfquery>

<script language="JavaScript" type="text/JavaScript">

	// ==================================================================================================
	// 								Usadas para conlis de fecha
	// ==================================================================================================
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}
	
	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	// ==================================================================================================
	// ==================================================================================================	
	
	// ==================================================================================================
	//											Validaciones
	// ==================================================================================================	
	var boton = "";
	function setBtn(obj){
		document.movimiento.botonSel.value = obj.name;
	}
	
	function cuenta(obj){
	// RESULTADO
	// Limpia los campos asociados al banco: Cuenta Bancaria, Moneda, Tipo de Cambio 
		form = obj.form.name;
		document[form].CBdescripcion.value = "";
		document[form].CBid.value          = "";
		document[form].DMcodigo.value      = "";
		document[form].Mcodigo.value       = "";		
		document[form].EMtipocambio.value  = "";
		document[form].EMtipocambio.disabled  = false;
	}
	
	function activar(obj){
	// RESULTADO
	// Limpia los campos asociados al banco: Cuenta Bancaria, Moneda, Tipo de Cambio 
		form = obj.form.name;
		document[form].EMtipocambio.disabled = false
		document[form].EMtotal.disabled      = false
	}
	
	
	// ==================================================================================================
	// ==================================================================================================	
	
	
	// ===========================================================================================
	//								Conlis de Cuentas
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis( id, desc, mcodigo, mnombre, tipocambio, oficina ) {
		var w = 650;
		var h = 400;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("ConlisCuentas.cfm?forma=movimiento&id=" + id + "&desc=" + desc + "&mcodigo=" + mcodigo + '&tipo=' + tipocambio +
		                                  "&mnombre=" + mnombre + "&Bid=" + document.movimiento.Bid.value + "&oficina=" + oficina + 
										  "&fecha=" + document.movimiento.EMfecha.value,l,t,w,h);
	}
	// ===========================================================================================

</script>
<script language="JavaScript" type="text/JavaScript">

function prueba(obj){
// RESULTADO
// Valida la existencia del codigo de documento, pues no debe ser repetido
	if ( (obj.value != "") ){
		<cfloop query="rsDocumentos">
			if ( '<cfoutput>#rsDocumentos.EMdocumento#</cfoutput>' == obj.value) {
				alert('El código de Documento ya existe.')
				obj.value = "";
				obj.focus();
				return false;
			}
		</cfloop>
	}	
}

</script>
<script language="JavaScript" type="text/JavaScript">
function MM_validateForm() { //v4.0
	var boton = document.movimiento.botonSel.value;

	var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;


	if ( ( boton != 'btnBorrarE' ) && ( boton != 'btnBorrarD' )  && ( boton != 'btnAplicar' ) && (boton != 'btnNuevoD') ) {
		for (i=0; i<(args.length-2); i+=3) { 
			test=args[i+2]; 
			val=MM_findObj(args[i]);
			if (val) { 
				if (val.alt!="") 
					nm=val.alt; 
				else 
					nm=val.name; 
				
				if ((val=val.value)!="") {
					if (test.indexOf('isEmail')!=-1) { 
						p=val.indexOf('@');
						if (p<1 || p==(val.length-1)) 
							errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
					} 
					else if (test!='R') { 
						num = parseFloat(val);
						if (isNaN(val)) 
							errors+='- '+nm+' debe ser numérico.\n';
					
						if (test.indexOf('inRange') != -1) { 
							p=test.indexOf(':');
							min=test.substring(8,p); 
							max=test.substring(p+1);
							if (num<min || max<num) 
								errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
						} 
					} 
				} 
				else if (test.charAt(0) == 'R') 					
					errors += '- '+nm+' es requerido.\n'; 					
			}
		} 
		
		if ( parseFloat(document.movimiento.EMtipocambio.value) == 0 ){
			errors += '- El Tipo de Cambio debe ser diferente de cero.\n';
		}
		if ( parseFloat(document.movimiento.DMmonto.value) == 0 ){
			errors += '- El monto del movimiento debe ser diferente de cero.\n';
		}


		if (errors) {
			
			if ( document.forms['movimiento'].EMcodigo.value == document.forms['movimiento'].Mcodigo.value ) {
				document.forms['movimiento'].EMtipocambio.disabled = true;
			}
			
			document.forms['movimiento'].EMtotal.disabled = true;
			alert('Se presentaron los siguientes errores:\n\n'+errors);
		}	
		document.MM_returnValue = (errors == '');
	}
	else{
		if ( boton == 'btnBorrarD'){
			if ( confirm('Va a eliminar este detalle de Movimiento. Desea continuar?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}

		if ( boton == 'btnBorrarE'){
			if ( confirm('Va a eliminar este Movimiento y todas sus lineas de detalle. Desea continuar?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}

		if ( boton == 'btnAplicar'){
			if ( confirm('Desea aplicar este documento?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}
		
		if ( boton == 'btnNuevoD'){
			document.MM_returnValue = true;
		}
	}	
}

function QuitaComa(){
	if (document.movimiento.DMmonto.value != '')
	{
		document.movimiento.DMmonto.value = qf(document.movimiento.DMmonto.value);
	}
}

	function valida_tc(){
	// RESULTADO
	// Valida el input tipo de cambio para el documento:
	// 1. Si la moneda de la cuenta es igual a la monedas de la empresa, el input de tipo de cambio es uno y no se puede modificar
	// 2. De otra forma puede ser modficable
	
		if ( document.movimiento.Mcodigo.value == document.movimiento.EMcodigo.value ){
			document.movimiento.EMtipocambio.disabled = true;
		}
		else{
			document.movimiento.EMtipocambio.disabled = false;
		}
		return
	}

	function tcambio(obj){
		if ( onblurdatetime(obj) ){
			document.all['ifTipoCambio'].src="/cfmx/sif/mb/operacion/Mtipocambio.cfm?Mcodigo=" + document.movimiento.Mcodigo.value +
																			  "&eMcodigo=" + document.movimiento.EMcodigo.value+
																			  "&fecha=" + obj.value;
		}
		return;	
	}
// ============================================================================		
// Llama a la pantalla del reporte
function ImprimeReporte(){ 

		<cfoutput>
		var PARAM  = "../Reportes/RPRegistroMovBancarios.cfm?EMid=#form.EMid#"; 
		open(PARAM,'','left=100,top=100,scrollbars=yes,resizable=yes,width=800,height=600');
			return false;

		</cfoutput>
	}
// ============================================================================		
function funcIndicador(){
	var _divTagCuenta = document.getElementById("tagCuenta");
	var _divTagEtiqueta = document.getElementById("tagEtiqueta");
	if (document.movimiento.Indicador.value =='S'){
		_divTagCuenta.style.display = '';
		_divTagEtiqueta.style.display = '';
	}
	else{
		_divTagCuenta.style.display = 'none';
		_divTagEtiqueta.style.display = 'none';
		document.movimiento.Ccuenta.value = 0;
	}
}
// ============================================================================		
</script>


<form action   = "SQLMovimientos.cfm" 
      method   = "post" 
      name     = "movimiento" 
      onSubmit = " <cfif modo EQ 'ALTA'>
						MM_validateForm('CBdescripcion','','R','EMtipocambio','','R','EMdocumento','','R','EMfecha','','R','EMdescripcion','','R', 'EMreferencia','','R','CFid','','R' );
				   <cfelseif modo NEQ 'ALTA' and rsIndicador.Pvalor EQ 'S'>
						MM_validateForm('CBdescripcion','','R','EMtipocambio','','R','EMdocumento','','R','EMfecha','','R','EMdescripcion','','R','Ccuenta','','R','DMmonto','','R','DMdescripcion','','R','CFid','','R');	 			
	  			   <cfelseif modo NEQ 'ALTA' and rsIndicador.Pvalor EQ 'N'>
						MM_validateForm('CBdescripcion','','R','EMtipocambio','','R','EMdocumento','','R','EMfecha','','R','EMdescripcion','','R','CFid','','R','DMmonto','','R','DMdescripcion','','R','CFid','','R');	  			
				   <cfelse>
				   		MM_validateForm('CBdescripcion','','R','EMtipocambio','','R','EMdocumento','','R','EMfecha','','R','EMdescripcion','','R','Ccuenta','','R','DMmonto','','R','DMdescripcion','','R','CFid','','R');
                   </cfif> 
				   return document.MM_returnValue">
				   
	<input type="hidden" name="Indicador" value="<cfif rsIndicador.Pvalor EQ 'S'>S<cfelse>N</cfif>">
		
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td class="tituloAlterno" colspan="8">Encabezado del Movimiento</td>
		<!---  Transaccion / Banco --->
		<tr>
			<td valign="baseline" align="right">Transacci&oacute;n&nbsp;</td>	
			<td valign="baseline">
              <select name="BTid">
                <cfoutput query="rsTipos">
                  <cfif modo EQ 'ALTA'>
                    <option value="#rsTipos.BTid#">#rsTipos.BTdescripcion#</option>
                    <cfelse>
                    <option value="#rsTipos.BTid#" <cfif #rsForm.BTid# EQ #rsTipos.BTid#>selected</cfif> >#rsTipos.BTdescripcion#</option>
                  </cfif>
                </cfoutput>
              </select>				
              <cfif modo NEQ 'ALTA'>
					<input type="hidden" name="bdBTid" value="<cfoutput>#rsForm.BTid#</cfoutput>">
			  </cfif>	
		  </td>
			<td>&nbsp;</td>
			<td valign="baseline" align="right">Banco:&nbsp;</td>	
			<td valign="baseline" >
				<select name="Bid" onChange="javascript:cuenta(this);">
					<cfoutput query="rsBancos">
						<cfif modo EQ 'ALTA'>
							<option value="#rsBancos.Bid#">#rsBancos.Bdescripcion#</option>
						<cfelse>
							<option value="#rsBancos.Bid#" <cfif #rsForm.Bid# EQ #rsBancos.Bid#>selected</cfif> >
							#rsBancos.Bdescripcion#</option>
						</cfif>
					</cfoutput>						
				</select>
			</td>

			<td align="right">Oficina:&nbsp;</td>
			<td>
				<select name="Ocodigo">
					<cfoutput query="rsOficinas">
						<cfif modo neq 'ALTA' and #Ocodigo# eq #rsForm.Ocodigo# >	
							<option value="#Ocodigo#" selected >#Odescripcion#</option>
						<cfelse>	
							<option value="#Ocodigo#" >#Odescripcion#</option>
						</cfif>	
					</cfoutput>
				</select>
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="bdOcodigo" value="<cfoutput>#rsForm.Ocodigo#</cfoutput>">
				</cfif>	
			</td>
		</tr>
		<!--- Cuenta Bancaria / Moneda / Tipo de Cambio --->
		<tr>
			<td valign="baseline" align="right" nowrap>Cuenta Bancaria:&nbsp;</td>
			<td nowrap>
<input name="CBdescripcion" disabled type="text" 
				value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.CBdescripcion#</cfoutput></cfif>" onFocus="this.select();" 
				size="40" maxlength="80" alt="La Cuenta Bancaria" >				
<a href="#">
			<img src="../../imagenes/Description.gif" alt="Lista de Cuentas Bancarias" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis('CBid','CBdescripcion', 'Mcodigo', 'DMcodigo', 'EMtipocambio', 'Ocodigo');">
		</a> 
				<input type="hidden" name="CBid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.CBid#</cfoutput></cfif>">
				
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="bdCBid" value="<cfoutput>#rsForm.CBid#</cfoutput>">
				</cfif>	
		  </td>

			<td>
				<input name="DMcodigo" readonly type="text"   value="<cfoutput>#rsForm.Mnombre#</cfoutput>" size="10" style=" border: medium none; background-color:#FFFFFF; "> 
				<input name="Mcodigo"  type="hidden" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Mcodigo#</cfoutput></cfif>" > 
				<cfoutput query="rsEmoneda"><input name="EMcodigo"  type="hidden" value="#rsEmoneda.Mcodigo#" ></cfoutput>
			</td>
			<td valign="baseline" align="right">Documento:&nbsp;</td>		
			<td> 
				<input type="text" name="EMdocumento" size="20" maxlength="20" 
				value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.EMdocumento)#</cfoutput></cfif>" 
				onBlur="javascript: prueba(this);" onfocus="this.select();" alt="El Documento" >
				<input type="hidden" name="EMid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EMid#</cfoutput></cfif>" >
				<cfif modo NEQ 'ALTA'>
				  <input type="hidden" name="bdEMdocumento" value="<cfoutput>#rsForm.EMdocumento#</cfoutput>">
				</cfif> 
			</td>

			<td align="right" nowrap>Tipo de Cambio:&nbsp;</td>
			<td>
				<input type="text" name="EMtipocambio" 
				value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EMtipocambio#</cfoutput></cfif>"  
				size="12" maxlength="12" style="text-align: right;" onblur="javascript:fm(this,4); "  
				onfocus="javascript:this.value=qf(this); this.select();"  
				onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" alt="El Tipo de Cambio" >
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="bdEMtipocambio" value="<cfoutput>#rsForm.EMtipocambio#</cfoutput>">
				</cfif>	
			</td>
		</tr>		
		<tr>
			<td valign="baseline" align="right">Descripci&oacute;n:&nbsp;</td>
			<td> 
				<input type="text" name="EMdescripcion" size="40" maxlength="120" 
				value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EMdescripcion#</cfoutput></cfif>" onfocus="this.select();" 
				alt="La Descripci&oacute;n del encabezado" >
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="bdEMdescripcion" value="<cfoutput>#rsForm.EMdescripcion#</cfoutput>">
				</cfif>
			</td>
  			<td>&nbsp;</td>
			<td valign="baseline" align="right">Referencia:&nbsp;</td>
			<td> 
				<input type="text" name="EMreferencia" size="25" maxlength="25" 
				value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.EMreferencia)#</cfoutput></cfif>" onfocus="this.select();" 
				alt="La Referencia" >
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="bdEMreferencia" value="<cfoutput>#rsForm.EMreferencia#</cfoutput>">
				</cfif>
			</td>
			<td align="right">Fecha:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'><cfset fecha =  LSDateFormat(rsForm.EMfecha,'dd/mm/yyyy')><cfelse><cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')></cfif> 
				<cf_sifcalendario form="movimiento" name="EMfecha" value="#fecha#">
				
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="bdEMfecha" value="<cfoutput>#rsForm.EMfecha#</cfoutput>" >
				</cfif>
			</td>
				<!---	
				<td>
					<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/sif/imagenes/DATE_D.gif',1)"> 
						<input name="EMfecha" type="text" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsForm.EMfecha#</cfoutput><cfelse><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="10" maxlength="10"  onblur="javascript:tcambio(this);" onfocus="javascript:this.select();"  alt="El campo Fecha">
						<img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.movimiento.EMfecha');">
					</a>
				
					<cfif modo NEQ 'ALTA'>
						<input type="hidden" name="bdEMfecha" value="<cfoutput>#rsForm.EMfecha#</cfoutput>" >
					</cfif>
				</td>
				--->
		</tr>
		<tr>
			<td colspan="6" align="right">Total:&nbsp;</td>
			<td>
				<input type"text" name="EMtotal" 
				value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EMtotal#</cfoutput><cfelse>0.00</cfif>" disabled size="18" 
				maxlength="18" style="text-align: right;" onblur="javascript:fm(this,2); "  
				onfocus="javascript:this.value=qf(this); this.select();"  
				onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
		</tr>
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
		<tr><td colspan="7"><br><br></td></tr>
		<!-- ============================================================================================================ -->
		<!-- Seccion del detalle -->
		<!-- Solo se pinta si estamos en el modo cambio del encabezado -->
		<!-- ============================================================================================================ -->
		
		<cfif modo NEQ 'ALTA'>
			<tr><td class="tituloAlterno" colspan="8">Detalle del Movimiento</td>
			<tr>
				<td colspan="8">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td valign="baseline" align="right" >Descripci&oacute;n:&nbsp;</td>
							<td> 
								<input type="text" name="DMdescripcion" size="80" maxlength="120" 
								value="<cfif dmodo NEQ 'ALTA'><cfoutput>#rsDForm.DMdescripcion#</cfoutput></cfif>" 
								onfocus="this.select();" alt="La Descripci&oacute;n del detalle" >
							</td>
<!----
							<td valign="baseline" align="right">Departamentos:&nbsp;</td>
							<td>
								<select name="Dcodigo">
									<cfoutput query="rsDepartamentos">
										<cfif dmodo EQ 'ALTA'>
											<option value="#rsDepartamentos.Dcodigo#">#rsDepartamentos.Ddescripcion#</option>
										<cfelse>
											<option value="#rsDepartamentos.Dcodigo#" 
											<cfif #rsDForm.Dcodigo# EQ #rsDepartamentos.Dcodigo#>selected</cfif> >
											#rsDepartamentos.Ddescripcion#</option>
										</cfif>
									</cfoutput>						
								</select>
							</td>
----->							
							<td valign="baseline" align="right">Centro Funcional:&nbsp;</td>						
							<td>
								<cfif modo neq 'ALTA' and len(trim(rsDForm.CFid))>
									<cfquery name="rsCFcodigo" datasource="#session.DSN#">
										select CFid,CFcodigo, CFdescripcion from CFuncional 
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDForm.CFid#">
									</cfquery>
									<cf_rhcfuncional form="movimiento" size="30" 
									titulo="Seleccione el Centro Funcional" query="#rsCFcodigo#">
								<cfelse>
									<cf_rhcfuncional form="movimiento" size="30" 
									titulo="Seleccione el Centro Funcional" excluir="-1" >
								</cfif>	
							</td>
						</tr>
						<tr>
							<td valign="baseline" align="right">
								<div id="tagEtiqueta" style="display:none">
									Cuenta Contable:&nbsp;
								</div>	
							</td>						
							<td>
								<div id="tagCuenta" style="display:none">
									<cfif dmodo NEQ 'ALTA' >
										<cf_cuentas Conexion="#session.DSN#" Conlis="S" frame="frame" auxiliares="N" movimiento="S" 
										form="movimiento" ccuenta="Ccuenta" Cdescripcion="Cdescripcion" cformato="Cformato" query="#rsDForm#">
									<cfelse>
										<cf_cuentas Conexion="#session.DSN#" Conlis="S" frame="frame" auxiliares="N" movimiento="S" 
										form="movimiento" ccuenta="Ccuenta" Cdescripcion="Cdescripcion" cformato="Cformato">
									</cfif>
								</div>
							</td>
							<script type="text/javascript" language="javascript1.2">
								funcIndicador();
							</script>
						</tr>
						<tr>
							<td align="right">Total:&nbsp;</td>
							<td>
								<input type="text" name="DMmonto" 
								value="<cfif dmodo NEQ 'ALTA'><cfoutput>#rsDForm.DMmonto#</cfoutput><cfelse>0.00</cfif>"
								size="22" maxlength="18" style="text-align: right;" onblur="javascript:fm(this,2); "
								onChange="javascript:fm(this,2); "  
								onfocus="javascript:this.value=qf(this); this.select();"  
								onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
								<cfif dmodo NEQ 'ALTA'>
									<input type="hidden" name="bdDMmonto" value="<cfoutput>#rsDForm.DMmonto#</cfoutput>" >
								</cfif>
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" name="DMlinea" 
								value="<cfif dmodo NEQ 'ALTA'><cfoutput>#rsDForm.DMlinea#</cfoutput></cfif>">
							</td>
						</tr>
						<cfset dts = "">	
						<cfif dmodo neq "ALTA">
							<cfinvoke 
								component="sif.Componentes.DButils"
								method="toTimeStamp"
								returnvariable="dts">
								<cfinvokeargument name="arTimeStamp" value="#rsDForm.ts_rversion#"/>
							</cfinvoke>
						</cfif>
						<tr>
							<td>
							<input type="hidden" name="dtimestamp" 
								value="<cfif dmodo NEQ 'ALTA'><cfoutput>#dts#</cfoutput></cfif>">
							</td>
						</tr>
					</table>
				</td>
			</tr>	
		</cfif>	

		<!-- ============================================================================================================ -->
		<!-- ============================================================================================================ -->		

		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		

		<!-- Caso 1: Alta de Encabezados -->
		<cfif modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: setBtn(this); activar(this);" >
					<input type="reset"  name="btnLimpiar"  value="Limpiar" >
					
				</td>	
			</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->		
		<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnAgregarD"  value="Agregar" onClick="javascript: setBtn(this); activar(this); QuitaComa();" >
					<cfoutput query="rsFormLineas">
						<cfif #rsFormLineas.lineas# GT 0 >
							<input type="submit" name="btnAplicar"  value="Aplicar" onClick="javascript: setBtn(this);" >
						</cfif>
					</cfoutput>
					<input type="submit" name="btnBorrarE"   value="Borrar Movimiento" onClick="javascript: setBtn(this); " >
					<input type="reset"  name="btnLimpiar"   value="Limpiar" >
				</td>	
			</tr>
		</cfif>
		<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
		<cfif modo NEQ 'ALTA' and dmodo NEQ 'ALTA' >
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnCambiarD" value="Cambiar"             onClick="javascript: setBtn(this); activar(this); QuitaComa();" >
					<input type="submit" name="btnBorrarD"  value="Borrar L&iacute;nea" onClick="javascript: setBtn(this); " >
					<input type="submit" name="btnBorrarE"  value="Borrar Movimiento"   onClick="javascript: setBtn(this); " >
					<input type="submit" name="btnNuevoD"   value="Nueva L&iacute;nea"  onClick="javascript: setBtn(this); activar(this);" >
					<input type="reset"  name="btnLimpiar"  value="Limpiar" >
					<!--- <input type="button"  name="btnImprimir"  value="Imprimir" onClick="javascript: ImprimeReporte()"> --->
				</td>	
			</tr>
		</cfif>

		<!-- ============================================================================================================ -->
		<!-- ============================================================================================================ -->		
		<tr><td>&nbsp;</td></tr>
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
	</table>

	<!--- Valida el tipo de cambio--->
	<script language="JavaScript1.2" type="text/javascript">
		valida_tc();
	</script>

</form>
<iframe name="ifTipoCambio" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>

<cfif modo NEQ 'ALTA'>
	<script language="JavaScript1.2">
		document.movimiento.Ccuenta.alt = "La Cuenta Contable";
		fm(document.movimiento.EMtipocambio , 4);
		fm(document.movimiento.EMtotal , 2);
	</script>
</cfif>

