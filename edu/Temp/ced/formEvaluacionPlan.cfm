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
<cfif isdefined("Form.EPCcodigo")>
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.EPCcodigo")>
		<cfset dmodo="ALTA">
	<cfelseif #Form.dmodo# EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->

<!--- 1. Form --->
<cfquery datasource="#session.DSN#" name="rsForm">

	select convert(varchar, EPcodigo) as EPcodigo, CEcodigo, EPnombre
	from EvaluacionPlan
	<cfif isdefined("form.EPcodigo") and form.EPcodigo NEQ "" >
		where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
	</cfif>

</cfquery>


<!--- Seccion del detalle --->

<!--- 1. Form --->
<cfquery datasource="#session.DSN#" name="rsFormDetalle">

	select convert(varchar, epc.EPCcodigo) as EPCcodigo, epc.EPcodigo, epc.EVTcodigo, epc.ECcodigo, epc.EPCnombre, epc.EPCporcentaje, epc.EPCdia, epc.EPCsemana
	from EvaluacionPlanConcepto epc

	<cfif isdefined("Form.EPcodigo") and Form.EPcodigo NEQ "" and isdefined("Form.EPCcodigo") and Form.EPCcodigo NEQ "" >
		where epc.EPcodigo = <cfqueryparam value="#form.EPcodigo#"  cfsqltype="cf_sql_numeric">
		and epc.EPCcodigo  = <cfqueryparam value="#form.EPCcodigo#" cfsqltype="cf_sql_numeric">
	</cfif>

</cfquery>

<!--- 2. Conceptos de  Evaluacion--->
<cfquery datasource="#session.DSN#" name="rsConceptos">
	select convert(varchar, ECcodigo) as ECcodigo, ECnombre 
	from EvaluacionConcepto
	where CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
	order by ECorden

</cfquery>

<!--- 3. Cantidad de lineas de detalle--->
<cfquery datasource="#session.DSN#" name="rsFormLineas">
	select count(*) as lineas from EvaluacionPlanConcepto
	<cfif isdefined("Form.EPcodigo") and Form.EPcodigo NEQ "" >
		where EPcodigo = <cfqueryparam value="#Form.EPcodigo#" cfsqltype="cf_sql_numeric">
	</cfif>
</cfquery>

<!--- 4. Porcentaje de lineas de detalle --->
<cfif modo eq "CAMBIO">
	<cfquery datasource="#session.DSN#" name="rsPorcentaje">
		select isnull(sum(EPCporcentaje), 0) as EPCporcentaje from EvaluacionPlanConcepto
		where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
		
		<cfif dmodo neq "ALTA">
		    and EPCcodigo <> <cfqueryparam value="#form.EPCcodigo#" cfsqltype="cf_sql_numeric">
		</cfif>
		
	</cfquery>
</cfif>

<!--- 5. Porcentaje de lineas de detalle, para el encabezado. Deberia usar la misma consulta 4, pues es igual --->
<cfif modo neq "ALTA">
	<cfquery datasource="#session.DSN#" name="rsEPorcentaje">
		select isnull(sum(EPCporcentaje), 0) as EPCporcentaje from EvaluacionPlanConcepto
		where EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>



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

function MM_validateForm() { //v4.0
	var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;

	if (!bntSelected("btnBorrarE") && !btnSelected("btnBorrarD")) {
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

		// meter VALIDACIONES propias AQUI!!!
		if (btnSelected("btnCambiarD") || btnSelected("btnAgregarD")){

			<cfif isdefined("rsPorcentaje")>
				var pct1 = parseInt(document.form1.EPCporcentaje.value) + parseInt(<cfoutput>#rsPorcentaje.EPCporcentaje#</cfoutput>)
			</cfif>
			
			if ( pct1 > 100 ){
				errors += '-  La suma total de porcentajes no debe se mayor que 100.\n' ; 	
			}	

		}
		
		if (errors) {
			alert('Se presentaron los siguientes errores:\n\n'+errors);
		}	
		document.MM_returnValue = (errors == '');
	}
	else{
		if (btnSelected("btnBorrarD")){
			if ( confirm('Va a eliminar este detalle de Plan de Evaluación. Desea continuar?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}

		if (btnSelected("btnBorrarE")){
			if ( confirm('Va a eliminar este Plan de Evaluación y todas sus lineas de detalle. \nDesea continuar?') ){
				document.MM_returnValue = true;
			}
			else{
				document.MM_returnValue = false;
			}
		}
		
	}	
}

function porcentaje( obj ){

	if ( obj.value != '' ){
		var us_pct1 = parseInt(obj.value)
	
		// Caso 1: El porcentaje introducido por el usuario debe estar en el rango 0 - 100
		if ( us_pct1 > 100 || us_pct1 < 0 ){
			alert('El porcentaje debe ser entre 0 y 100');
			obj.value = '';			
			return false;
		}
	
		// Caso 2: Para el modo cambio, el porcentaje dado por el usuario mas la suma de 
		//         del porcentaje de los detalles para ese plan, no debe sobrepasar 100 
		<cfif modo neq 'ALTA'>
			
			// suma del porcentaje de los detalles para el plan x	
			var bd_pct  = parseInt(<cfoutput>#rsPorcentaje.EPCporcentaje#</cfoutput>)
			
			if ( bd_pct + us_pct1 > 100 ){
				alert('La suma de porcentajes no debe se mayor que 100. \n Para ingresar un nuevo detalle, debe modificar los demas detalles para que su suma no sea 100');
				obj.value = '';
				return false;
			}
		</cfif>
	}
	return true;
}

function valida_porcentaje(){
	if ( porcentaje( document.form1.EPCporcentaje ) ){
		return true
	}
	else{
		return false
	}
}



</script>

<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>

<form action   = "SQLEvaluacionPlan.cfm" 
      method   = "post" 
      name     = "form1"
      onSubmit = " <cfif modo EQ 'ALTA' >
 				       	MM_validateForm('EPnombre','','R');  
				   <cfelse>
 				       	MM_validateForm('EPnombre','','R','ECcodigo','','R','EPCnombre','','R','EPCporcentaje','','R');  
                   </cfif> 
				   return document.MM_returnValue" 
>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">

		<tr><td class="tituloAlterno" colspan="4" >Encabezado de Plan de Estudio</td></tr>
		<tr>
			<td align="right">Nombre:&nbsp;</td>
			<td>
				<input type="text" name="EPnombre" size="50" maxlength="50" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EPnombre#</cfoutput></cfif>" alt="El valor para el Nombre" onfocus="javascript:this.select();" >
			</td>
			<td align="right" nowrap>Porcentaje Total:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA' >
					<cfset valor = #rsEPorcentaje.EPCporcentaje#>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<input type="text" name="EPporcentaje" size="50" maxlength="50" value="<cfoutput>#valor#</cfoutput>%" readonly="readonly" style=" border: medium none; color:<cfif #valor# LT 100>#FF0000;<cfelse>#000000;</cfif> background-color:#FFFFFF;" >
			</td>
		</tr>	

		<tr><td><input type="hidden" name="EPcodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EPcodigo#</cfoutput></cfif>"></td></tr>
	  
		<tr><td><br><br></td></tr>

		<!-- ============================================================================================================ -->
		<!-- Seccion del detalle -->
		<!-- Solo se pinta si estamos en el modo cambio del encabezado -->
		<!-- ============================================================================================================ -->		

		<cfif modo NEQ 'ALTA'>
		<tr><td class="tituloAlterno" colspan="4">Detalle de Plan de Evaluaci&oacute;n</td></tr>

		<tr><td colspan="4" align="center"> 
			<table width="90%" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td align="right" nowrap>Concepto de Evaluci&oacute;n:&nbsp;</td>
				<td>
					<select name="ECcodigo">
						<cfoutput query="rsConceptos">					
							<cfif modo EQ 'ALTA'>
								<option value="#rsConceptos.ECcodigo#">#rsConceptos.ECnombre#</option>
							<cfelseif modo NEQ 'ALTA'>
								<option value="#rsConceptos.ECcodigo#" <cfif #rsFormDetalle.ECcodigo# EQ #rsConceptos.ECcodigo#>selected</cfif>  >#rsConceptos.ECnombre#</option>
							</cfif>
						</cfoutput>						
					</select>
				</td>

				<td align="right" nowrap>Nombre:&nbsp;</td>
				<td nowrap>
					<input type="text" name="EPCnombre" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#rsFormDetalle.EPCnombre#</cfoutput></cfif>"  size="50" maxlength="50" alt="El valor para el Nombre" onfocus="javascript:this.select();" >
				</td>

				<td align="right" nowrap>Porcentaje:&nbsp;</td>
				<td nowrap>
					<input type="text" name="EPCporcentaje" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#rsFormDetalle.EPCporcentaje#</cfoutput><cfelse>0</cfif>"  size="3" maxlength="3" style="text-align: right;" onblur="javascript:fm(this,-1); porcentaje(this); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El valor para el Porcentaje" >%
				</td>
			</tr>
			
			<tr>
				<td colspan="2">
					<input type="hidden" name="EPCcodigo" value="<cfoutput>#rsFormDetalle.EPCcodigo#</cfoutput>">
				</td>
			</tr>

		</table>
		</td></tr>
		</cfif>

		<!-- ============================================================================================================ -->
		<!-- ============================================================================================================ -->		

		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		

		<!-- Caso 1: Alta de Encabezados -->
		<cfif modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="4">
					<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"  value="Cancelar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
		<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
		<tr><td colspan="4">&nbsp;</td></tr>						
			<tr>
				<td align="center" valign="baseline" colspan="4">
					<input type="submit" name="btnAgregarD"  value="Agregar" onClick="javascript: setBtn(this); ">
					<input type="submit" name="btnBorrarE"   value="Borrar Plan" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"   value="Cancelar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
		<cfif modo NEQ 'ALTA' and dmodo NEQ 'ALTA' >
		<tr><td colspan="4">&nbsp;</td></tr>						
			<tr>
				<td align="center" valign="baseline" colspan="4">
					<input type="submit" name="btnCambiarD" value="Cambiar" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnBorrarD"  value="Borrar Detalle de Plan" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnBorrarE"  value="Borrar Plan" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnNuevoD"   value="Nuevo Detalle de Plan" onClick="javascript: setBtn(this);" >					
					<input type="reset"  name="btnLimpiar"  value="Cancelar" >				
				</td>	
			</tr>
		</cfif>

		<!-- ============================================================================================================ -->
		<!-- ============================================================================================================ -->		

	</table>

</form>

<cfif modo neq 'ALTA'>
	<script language="JavaScript1.2" type="text/javascript">
		document.form1.ECcodigo.alt = 'El valor para el Concepto de Evaluación'
	</script>
</cfif>