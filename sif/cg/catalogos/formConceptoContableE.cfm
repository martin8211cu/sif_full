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
<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif not isdefined("Form.Cconcepto") and isdefined("url.Cconcepto")>
	<cfset Form.Cconcepto=url.Cconcepto>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>


<script language="JavaScript" type="text/JavaScript">
var isIE = document.all?true:false;
var isNS = document.layers?true:false;

<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>

<cfquery datasource="#Session.DSN#" name="rsConceptoContableE">
 	select Ecodigo,Cconcepto,Cdescripcion,Ctiponumeracion,NoGeneraNap,BMUsucodigo,ts_rversion,TipoSAT
     from ConceptoContableE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.Cconcepto") and form.Cconcepto NEQ "">
		and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">
	</cfif>
</cfquery>

<form method="post" name="form1" onSubmit="if (document.form1.botonSel.value !='Baja' && document.form1.botonSel.value !='Nuevo' ){ MM_validateForm('Cdescripcion','','R');return document.MM_returnValue }else{ return true; }" action="SQLConceptoContableE.cfm">
	<table align="center">
		</tr>
		<tr valign="baseline">
			<td nowrap align="left">Concepto</td>
			<td>
			<cfif modo NEQ 'ALTA'>
				<cfoutput>
				#rsConceptoContableE.Cconcepto#
				</cfoutput>
			<cfelse>
				<input type="text" name="Cconcepto" value="" size="32" tabindex="1" onfocus="javascript: this.select();" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" maxlength="10" alt="El campo de Concepto">
			</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="left">Descripci&oacute;n:&nbsp;</td>
			<td><input type="text" name="Cdescripcion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsConceptoContableE.Cdescripcion#</cfoutput></cfif>" size="32" tabindex="1" onfocus="javascript: this.select();" alt="El campo Descripción"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="left">Tipo Numeraci&oacute;n:&nbsp;</td>
			<td>
			 	<select name="CTipoNumeracion" tabindex="1">
				 	<option value="0" <cfif modo EQ 'ALTA'>selected<cfelse><cfif modo NEQ 'ALTA' and rsConceptoContableE.Ctiponumeracion eq "0" >selected</cfif></cfif>>Mensual</option>
					<option value="1" <cfif modo NEQ 'ALTA' and rsConceptoContableE.Ctiponumeracion eq "1" >selected</cfif>>Anual</option>
					<option value="2" <cfif modo NEQ 'ALTA' and rsConceptoContableE.Ctiponumeracion eq "2" >selected</cfif>>Perpetua</option>
                </select>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="left">Tipo SAT:&nbsp;</td>
			<td>
			 	<select name="TipoSAT" tabindex="1">
				 	<option value=""  <cfif modo EQ 'ALTA'>selected<cfelse><cfif modo NEQ 'ALTA' and rsConceptoContableE.TipoSAT eq "" >selected</cfif></cfif>>-- Seleccione Uno --</option>
				 	<option value="I" <cfif modo NEQ 'ALTA' and rsConceptoContableE.TipoSAT eq "I" >selected</cfif>>Ingreso</option>
					<option value="E" <cfif modo NEQ 'ALTA' and rsConceptoContableE.TipoSAT eq "E" >selected</cfif>>Egreso</option>
					<option value="D" <cfif modo NEQ 'ALTA' and rsConceptoContableE.TipoSAT eq "D" >selected</cfif>>Diario</option>
                </select>
			</td>
		</tr>
        <tr valign="baseline">
			<td nowrap align="left">
            	<cfsavecontent variable="helpimg">
	                <img src="/sif/imagenes/Help01_T.gif" width="25" height="23" border="0"/>
                </cfsavecontent>
            	<strong>No Presupuestario</strong></td>
			<td>
            	<input type="checkbox" name="NoGeneraNap" id="NoGeneraNap" value="1" <cfif isdefined('rsConceptoContableE.NoGeneraNap') and rsConceptoContableE.NoGeneraNap EQ 1>checked="checked"</cfif>/>
            	<cf_notas link="#helpimg#" titulo="No Presupuestario" msg="Al marcar esta opción, ningún asiento perteneciente a este concepto generará movimientos presupuestarios, aun cuando contenga cuentas de ingreso y gasto.">
            </td>
       </tr>
		<tr>
			<td colspan="2" align="center" nowrap>
				<input name="botonSel"	 type="hidden"  value="" tabindex="-1">
				<input name="txtEnterSI" type="text" size="1" tabindex="-1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" 	value="Agregar" class="btnGuardar"  tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset"  name="Limpiar" value="Limpiar" class="btnLimpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>
					<input type="submit" name="Cambio" 		value="Modificar" class="btnGuardar" 	tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; <!---if (window.habilitarValidacion) habilitarValidacion(); --->">
					<input type="submit" name="Baja" 		value="Eliminar"  class="btnEliminar"	tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" 		value="Nuevo" 	  class="btnNuevo"		tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
					<input type="button" name="btnPermiso" 	value="Permisos"  class="btnNormal"		tabindex="1" onClick="javascript: verPermisos(this.form);">
				</cfif>
			</td>
		</tr>
	</table>

	<input type="hidden" name="Cconcepto" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsConceptoContableE.Cconcepto#</cfoutput></cfif>">

	<cfset ts = "">
	<cfif modo neq "ALTA">
		<cfinvoke
			component="sif.Componentes.DButils"
		 	method="toTimeStamp"
		 	returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsConceptoContableE.ts_rversion#"/>
		</cfinvoke>
	</cfif>

	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
</form>

<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
	<cfif modo NEQ "ALTA">
		<cfoutput>
		function verPermisos(f) {
			location.href =  "ConceptoContablePermiso.cfm?Cconcepto=#Form.Cconcepto#";
		}
		</cfoutput>
	</cfif>
</script>