<!--- valida que siempre exista el codigo de encabezado, que por fuerza debe existir --->
<cfif isdefined("form.FMT01COD") and Len(Trim("form.FMT01COD")) eq 0 >
	<cflocation addtoken="no" url="listaFormatos.cfm">
</cfif>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- ===============================================================================================  	--->
<!--- 												CONSULTAS 											--->
<!--- ===============================================================================================  	--->
<cfquery name="rsFormato" datasource="#Session.DSN#">
	select FMT01DES from FMT001 where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
</cfquery>

<!--- Form--->
<cfquery name="rsForm" datasource="#session.DSN#">
	select FMT01COD, FMT10LIN, FMT10PAR, FMT10TIP, FMT10LON, FMT10DEF, ts_rversion
	from FMT010
	where FMT01COD=<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
	<cfif isdefined("form.FMT10LIN") and #Len(Trim("form.FMT10LIN"))# gt 0>
		  and FMT10LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT10LIN#">
	</cfif>	
</cfquery>

<!--- Linea --->
<cfquery name="rsLinea" datasource="#session.DSN#">
 	select max(FMT10LIN)  as FMT10LIN
	from FMT010 a
        inner join FMT001 b
        on a.FMT01COD=b.FMT01COD 
        and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where a.FMT01COD=<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01COD#">
</cfquery>
<cfset FMT10LIN = 1 >
<cfif rsLinea.RecordCount gt 0 and len(trim(rsLinea.FMT10LIN))>
	<cfset FMT10LIN = rsLinea.FMT10LIN + 1 >
</cfif>
<!--- ===============================================================================================  	--->

<!--- ===============================================================================================  	--->
<!--- 												JS 											        --->
<!--- ===============================================================================================  	--->
<script language="JavaScript1.2" type="text/javascript">

	var boton = "";
	function setBtn(obj){
		boton = obj.name;
	}

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

	function formato(){
		document.form1.FMT10LON.value = qf(document.form1.FMT10LON);
	}
	
	function valida(){
		var msg = 'Se presentaron los siguientes errores: \n';
		var error = false;
		if (document.form1.FMT01COD.value == ''){ msg+= " - " + document.form1.FMT01COD.alt + " es requerido. \n"; error=true; }
		if (document.form1.FMT10LIN.value == ''){ msg+= " - " + document.form1.FMT10LIN.alt + " es requerido. \n"; error=true;}
		if (document.form1.FMT10PAR.value == ''){ msg+= " - " + document.form1.FMT10PAR.alt + " es requerido. \n"; error=true;}
		if (document.form1.FMT10TIP.value == ''){ msg+= " - " + document.form1.FMT10TIP.alt + " es requerido. \n"; error=true;}
		if (document.form1.FMT10LON.value == ''){ msg+= " - " + document.form1.FMT10LON.alt + " es requerido. \n"; error=true;}
		if (document.form1.FMT10DEF.value == ''){ msg+= " - " + document.form1.FMT10DEF.alt + " es requerido. \n"; error=true;}
		
		if (error){
			alert(msg);
		}
		return !error
	}

	function validar(){
		switch ( boton ) {
		   case 'btnEliminar' :
				if ( confirm('Va a eliminar este registro . Desea continuar?') ){
					document.form1.FMT10LIN.disabled = false;
					return true;
				}
			    break;
		   case 'btnAgregar' :
				if ( valida() ){
					document.form1.FMT10LIN.disabled = false;
					formato();
					return true;
				}
				return false;
			    break;
	
		   case 'btnModificar' :
				if ( valida() ){
					document.form1.FMT10LIN.disabled = false;
					formato();
					return true;
				}
				return false;
			    break;
		}
		
		return false;
	}

	function nuevo(){
		document.form1.FMT01COD.disabled = false;
		document.form1.FMT10LIN.value    = "";
		document.form1.action            = "FMTParametros.cfm";
		document.form1.submit();
	}
	
	function regresar(){
		document.form1.FMT01COD.disabled = false;
		document.form1.FMT01COD.value    = '<cfoutput>#form.FMT01COD#</cfoutput>';
		document.form1.FMT10LIN.value    = "";
		document.form1.action            = "EFormatosImpresion.cfm";
		document.form1.submit();
	}

</script>
<!--- =============================================================================================== --->

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}

	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<form name="form1" method="post" onSubmit="return validar();" action="SQLFMTParametros.cfm" >
	<table width="100%" border="0" cellpadding="0" cellspacing="0">

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr>
			<td align="right" nowrap>Formato:&nbsp;</td>
		  	<td >
				<cfoutput>#trim(form.FMT01COD)# - #rsFormato.FMT01DES#</cfoutput>
				<input type="hidden" name="FMT01COD" value="<cfoutput>#trim(form.FMT01COD)#</cfoutput>" >
			</td>
		</tr>

		<!--- Linea --->
		<tr>
			<td align="right" nowrap>L&iacute;nea:&nbsp;</td>				
			<td ><input type="text" name="FMT10LIN" size="12" disabled value="<cfoutput><cfif modo neq 'ALTA' >#form.FMT10LIN#<cfelse>#FMT10LIN#</cfif></cfoutput>" style="text-align: right;" ></td>
		</tr>			

		<tr>
			<td align="right" nowrap>Nombre:&nbsp;</td>
			<td  nowrap>
				<input type="text" size="30" maxlength="30" name="FMT10PAR" value="<cfoutput><cfif modo neq 'ALTA'>#Trim(rsForm.FMT10PAR)#</cfif></cfoutput>" onFocus="javascript:this.select();" alt="El Nombre del Parámetro">
			</td>											
		</tr>

		<tr>
			<td align="right" nowrap>Tipo de Dato:&nbsp;</td>
			<td  nowrap>
				<select name="FMT10TIP">
					<option value="0" <cfif modo neq 'ALTA' and rsForm.FMT10TIP eq 0 >selected</cfif> >Texto</option>
					<option value="1" <cfif modo neq 'ALTA' and rsForm.FMT10TIP eq 1 >selected</cfif> >Num&eacute;rico</option>
					<option value="2" <cfif modo neq 'ALTA' and rsForm.FMT10TIP eq 2 >selected</cfif> >Fecha</option>
				</select>
			</td>											
		</tr>

		<tr>
			<td align="right" nowrap>Longitud:&nbsp;</td>
			<td><input type="text" name="FMT10LON" maxlength="5" size="7" value="<cfif modo neq 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.FMT10LON,'none')#</cfoutput><cfelse>0.00</cfif>" style="text-align: right;" onblur="fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Longitud" ></td>
		</tr>
		<tr>
			<td align="right" nowrap>Valor default:&nbsp;</td>
			<td><input type="text" name="FMT10DEF" maxlength="30" size="30" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FMT10DEF#</cfoutput></cfif>" onfocus="javascript:this.select();" alt="El Valor default" ></td>
		</tr>

		<tr><td >&nbsp;</td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="2">
				<cfif modo EQ "ALTA">
							<input type="submit" name="btnAgregar" value="Agregar" onclick="javascript:setBtn( this );" >
				<cfelse>	
							<input type="submit" name="btnModificar" value="Modificar" onclick="javascript:setBtn( this );" >
							<input type="submit" name="btnEliminar"  value="Eliminar"  onclick="javascript:setBtn( this );">
							<input type="button" name="btnNuevo"     value="Nuevo"     onClick="javascript:nuevo();"  >
				</cfif>
				<input type="button" name="btnRegresar"  value="Regresar"  onClick="javascript:regresar();"  >
				<input type="reset" name="Limpiar" value="Limpiar" >
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">				
		</tr>
		
		<tr><td >
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
		</td></tr>

	</table> 
	<!--- tabla principal --->
</form>
