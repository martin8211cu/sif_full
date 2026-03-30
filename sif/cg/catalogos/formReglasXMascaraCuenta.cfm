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
<cf_templatecss>

<cfif isdefined("Form.Cmayor") and Form.Cmayor NEQ "" and isdefined("Form.PCEMid") AND Form.PCEMid NEQ "" and isdefined("Form.PCRid") AND Form.PCRid NEQ "">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select PCRid, PCRref, Cmayor, 
			PCEMid, PCRregla, PCRvalida, 
			PCRdesde, 
			PCRhasta, OficodigoM ,ts_rversion
		from PCReglas	 
		where Ecodigo= #Session.Ecodigo#
			and Cmayor=<cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_varchar">
			and PCEMid=<cfqueryparam value="#Form.PCEMid#" cfsqltype="cf_sql_integer">	
			and PCRid= <cfqueryparam value="#Form.PCRid#" cfsqltype="cf_sql_numeric">	
	</cfquery>

	<!--- Reglas Padre --->		
	<cfquery name="rsReferencias" datasource="#Session.DSN#">
		select PCRid, PCRregla from PCReglas 
		where Ecodigo = #Session.Ecodigo#
		  and PCEMid=<cfqueryparam value="#Form.PCEMid#" cfsqltype="cf_sql_integer">
		  and Cmayor=<cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_varchar">
		  and (PCRref is null or PCRid = PCRref)
		  and PCRid != <cfqueryparam value="#rsForm.PCRid#" cfsqltype="cf_sql_numeric">
	</cfquery>
		
</cfif>

<cfif isdefined('form.Cmayor') and form.Cmayor NEQ "">
	<cfquery name="rsCPVigencia" datasource="#Session.DSN#">
		select PCEMid, CPVformatoF, CPVdesde, CPVhasta
		  from CPVigencia 
		 where CPVid   = <cfqueryparam value="#form.CPVid#" cfsqltype="cf_sql_numeric"> 
		   and Ecodigo = #Session.Ecodigo#
		   and Cmayor  = <cfqueryparam value="#form.Cmayor#" cfsqltype="cf_sql_varchar"> 
	</cfquery>
	<cfif rsCPVigencia.recordcount NEQ 1>
		<cf_errorCode	code = "50218" msg = "Problemas con la vigencia">
	</cfif>

	<cfquery name="rsCmayor" datasource="#Session.DSN#">
		select <cf_dbfunction name="sPart" args="Cdescripcion,1,30"> as Cdescripcion
		from CtasMayor 
		where Cmayor = <cfqueryparam value="#form.Cmayor#" cfsqltype="cf_sql_varchar"> 
			and Ecodigo=#Session.Ecodigo#
	</cfquery>

	<cfif isdefined('rsCPVigencia') and rsCPVigencia.recordCount GT 0 and rsCPVigencia.PCEMid NEQ "">
		<cfquery name="rsMascara" datasource="#Session.DSN#">
			select PCEMid,<cf_dbfunction name="sPart" args="PCEMdesc,1,30"> as PCEMdesc, PCEMformato
			from PCEMascaras 
			where CEcodigo= #Session.CEcodigo#
				and PCEMid=<cfqueryparam value="#rsCPVigencia.PCEMid#" cfsqltype="cf_sql_numeric">		
		</cfquery>
	</cfif>
</cfif>

<form method="post" name="formReglasXMascara" action="SQLReglasXMascaraCuenta.cfm" onSubmit="javascript:CompletarTodo()">
	<cfif modo NEQ 'ALTA' and isdefined('form.PCRid') and form.PCRid NEQ ''>
		<input name="PCRid" value="<cfoutput>#form.PCRid#</cfoutput>" type="hidden">
           <cfset ts = "">
          <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"></cfinvoke>
          <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">		
 	</cfif>
	<input name="modo" value="<cfoutput>#modo#</cfoutput>" type="hidden">
	
	<table width="100%" border="0" cellpadding="1" cellspacing="1">

	  <tr>
		<td class="tituloAlterno" align="center" colspan="3">
			<cfif modo NEQ 'ALTA'>
				Modificaci&oacute;n de Regla
			<cfelse>
				Nueva Regla
			</cfif>
		</td>
	  </tr>

	  <tr>
		<td colspan="3">&nbsp;</td>
	  </tr>	  		  
	
	  <tr>
		<td><strong>Cuenta de Mayor :</strong>&nbsp;</td>
		<td colspan="2">
			<input name="Cmayor" value="<cfoutput>#form.Cmayor#</cfoutput>" type="hidden">
			<cfif isdefined('rsCmayor') and rsCmayor.recordCount GT 0><cfoutput>#rsCmayor.Cdescripcion#</cfoutput></cfif>
		</td>
	  </tr>
	  <tr>
		<td><strong>M&aacute;scara :</strong></td>
		<td colspan="2">
			<input name="PCEMid" value="<cfif isdefined('rsMascara') and rsMascara.recordCount GT 0><cfoutput>#rsMascara.PCEMid#</cfoutput></cfif>" type="hidden">
			<cfif isdefined('rsMascara') and rsMascara.recordCount GT 0>
				<cfoutput>#rsMascara.PCEMdesc#</cfoutput>
			<cfelse>
				&nbsp;
			</cfif>
		</td>
	  </tr>	
	  	  
	  <tr>
		<td colspan="3">&nbsp;</td>
	  </tr>	  		  
	  	
	  <tr>
		<td>Fecha desde</td>
		<td>Fecha hasta</td>
	    <td>Regla v&aacute;lida</td>
	  </tr>
  
	  <tr>
		<td>
			<cfif MODO EQ "ALTA">
				<cf_sifcalendario form="formReglasXMascara" name="PCRdesde" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
			<cfelse>
				<cfoutput>
					<cf_sifcalendario form="formReglasXMascara" name="PCRdesde" value="#LSDateFormat(rsForm.PCRdesde,'DD/MM/YYYY')#">
				</cfoutput>
			</cfif>
		</td>
		<td>
			<cfif MODO EQ "ALTA">
				<cf_sifcalendario form="formReglasXMascara" name="PCRhasta" value="#LSDateFormat(DATEADD("YYYY",2099-YEAR(NOW()),NOW()),'DD/MM/YYYY')#">				
			<cfelse>
				<cfoutput>
					<cf_sifcalendario form="formReglasXMascara" name="PCRhasta" value="#LSDateFormat(rsForm.PCRhasta,'DD/MM/YYYY')#">
				</cfoutput>
			</cfif>
		</td>
	    <td><input name="PCRvalida" type="checkbox" id="PCRvalida" value="PCRvalida" <cfif modo NEQ "ALTA" and rsForm.PCRvalida EQ 1> checked</cfif>></td>
	  </tr> 
     	
	  <tr><td colspan="3">&nbsp;</td></tr>
	  <tr>
		<td colspan="3">Regla de Validaci&oacute;n</td>
	  </tr>
	  <tr>	  
		<td colspan="3">

			<!--- <cfif modo EQ 'ALTA'>  --->
			
				<cfif modo NEQ 'ALTA'>
					<cfset lvarCuenta = rsForm.PCRregla>
				<cfelse>
					<cfset lvarCuenta = "">
				</cfif>
				
					<cf_sifcajas 
						form="formReglasXMascara" 
						CMayor="#form.Cmayor#" 
						CaracterComp="_" 
						AlineamientoComp="DER" 
						Mascara="#rsCPVigencia.CPVformatoF#"
						Cuenta="#lvarCuenta#"
						modo = "#modo#">
				
				<input type="hidden" name="CPVid" value="<cfif isdefined("form.CPVid")><cfoutput>#form.CPVid#</cfoutput></cfif>">
		</td>
	  </tr>		
	  <tr><td colspan="3">&nbsp;</td></tr>	  
	  <tr>
		<td colspan="3">Oficina:</td>
	  </tr>
	  <tr>
		<td colspan="3">
		<input 	type="text" 
				name="OficodigoM" 
				maxlength="10" 
				size="13"
				onBlur="" 
				 tabindex="2"
				value="<cfif modo EQ "CAMBIO"><cfoutput>#rsForm.OficodigoM#</cfoutput></cfif>">		
		</td>
	  </tr>	  	  
	  
	  <cfif modo NEQ 'ALTA'>
		  <tr>
			<td colspan="3">Regla de Referencia</td>
		  </tr>

		  <tr>
			<td colspan="3">
			<select name="PCRref">
				<option value=""></option>
			<cfoutput query="rsReferencias">
				<option value="#PCRid#" <cfif Len(Trim(rsForm.PCRref)) GT 0 and rsForm.PCRref EQ rsReferencias.PCRid> selected </cfif> >#PCRregla#</option>		
			</cfoutput>
			</select></td>
		  </tr>	  		  
	  </cfif>
	  <tr><td colspan="3">&nbsp;</td></tr>	
	  <tr>
		<td colspan="3" align="center"><cfinclude template="../../portlets/pBotones.cfm">
		<cfif isdefined('form.Cmayor') and form.Cmayor NEQ ''>	  
			<input name="a_Cmayor" type="button" value="Cuenta Mayor" onClick="javascript: ACMAYOR();">
		</cfif>
		</td>
	  </tr>  
  	  	  			
  </table>
</form>

<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>

<script language="JavaScript" type="text/javascript">
	/*
	function Guiones(obj,largo){
		var totalcaracteres = obj.value.length;
		var guion = "";
		
		if (totalcaracteres < largo)
		{
			totalguiones = largo - totalcaracteres
			for(i=0;i<totalguiones;i++)
				guion=guion + "_"
			obj.value = obj.value + guion;
		}
	}*/
	
	function ACMAYOR(){
		document.formReglasXMascara.modo.value="CAMBIO";			
		document.formReglasXMascara.action="CuentasMayor.cfm";		
		document.formReglasXMascara.submit();
	}
//------------------------------------------------------------------------------------------
/* Esta funcion toma 2 fechas en formato dia/mes/año y compara la fecha1(primer parametro) con la fecha2(segundo parametro)
		de cinco formas diferentes, en donde el tercer parametro (opc) va a tener 5 valores diferentes 
		si opc = 1
			verifica si la fecha1 es = a la fecha2
		si opc = 2
			verifica si la fecha1 es > a la fecha2
		si opc = 3
			verifica si la fecha1 es < a la fecha2
		si opc = 4
			verifica si la fecha1 es >= a la fecha2
		si opc = 5
			verifica si la fecha1 es <= a la fecha2		*/
		
	function comparaFechas(fecha1,fecha2,opc){
		var res = false;
		var tempFecha1 = fecha1.split('/');
		var tempFecha2 = fecha2.split('/');		

		//Validando que las fechas sean correctas
		if(validaFecha(fecha1) && validaFecha(fecha2)){
			if(opc == 1 || opc == 2 || opc == 3 || opc == 4 || opc == 5){
				tempFecha1[1] = new Number(tempFecha1[1]);
				tempFecha2[1] = new Number(tempFecha2[1]);
				tempFecha1[1] = (tempFecha1[1] != 0 ) ? tempFecha1[1]-1 : 0 ;
				tempFecha2[1] = (tempFecha2[1] != 0 ) ? tempFecha2[1]-1 : 0 ;
				
				var vFecha1 = new Date(tempFecha1[2],tempFecha1[1],tempFecha1[0]);
				var vFecha2 = new Date(tempFecha2[2],tempFecha2[1],tempFecha2[0]);		

				var anio1 = vFecha1.getFullYear();
				var mes1 = vFecha1.getMonth();
				var dia1 = vFecha1.getDate();
				var anio2 = vFecha2.getFullYear();
				var mes2 = vFecha2.getMonth();
				var dia2 = vFecha2.getDate();
				
				switch(opc){
					case 1: {	//compara las fechas (fecha1 = fecha2)
						if(eval(anio1 == anio2) &&	eval(mes1 == mes2) &&  (dia1 == dia2)){
							res = true;
						}else{
							res = false;
						}
					}
					break;
					case 2: {	//compara las fechas (fecha1 > fecha2) -- if(vFecha1 > vFecha2){
						if(anio1 > anio2){
							res = true;
						}else{
							if(anio1 == anio2){
								if(mes1 > mes2){
									res = true;
								}else{
									if(mes1 == mes2){
										if(dia1 > dia2){
											res = true
										}else{
											res = false;
										}
									}else{
										res = false;
									}
								}
							}else{
								res = false;
							}
						}					
					}
					break;					
					case 3: {	//compara las fechas (fecha1 < fecha2)
						if(anio1 < anio2){
							res = true;
						}else{
							if(anio1 == anio2){
								if(mes1 < mes2){
									res = true;
								}else{
									if(mes1 == mes2){
										if(dia1 < dia2){
											res = true
										}else{
											res = false;
										}
									}else{
										res = false;
									}
								}
							}else{
								res = false;
							}
						}					
					}
					break;					
					case 4: {	//compara las fechas (fecha1 >= fecha2)
						if(anio1 >= anio2){
							if(mes1 >= mes2){
								if(dia1 >= dia2){
									res = true
								}else{
									res = false;
								}
							}else{
								res = false;							
							}
						}else{
							res = false;
						}					
					}
					break;
					case 5: {	//compara las fechas (fecha1 <= fecha2)
						if(anio1 <= anio2){
							if(mes1 <= mes2){
								if(dia1 <= dia2){
									res = true
								}else{
									res = false;
								}
							}else{
								res = false;							
							}
						}else{
							res = false;
						}					
					}
					break;										
				}
			}else{
				alert('el tercer parametro de comparaFechas es inválido (rango válido de 1 - 5)');
			}
		}
		return res;
	}	
//------------------------------------------------------------------------------------------	
	function validaFecha(f){
		if (f != "") {
			var partes = f.split ("/");
			var ano = 0, mes = 0; dia = 0;
			if (partes.length == 3) {
				ano = parseInt(partes[2], 10);
				mes = parseInt(partes[1], 10);
				dia = parseInt(partes[0], 10);
			} else if (partes.length == 2) {
				var hoy = new Date;
				ano = hoy.getFullYear();
				mes = parseInt(partes[1], 10);
				dia = parseInt(partes[0], 10); 
			} else {
				alert("La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)");
				return false;
			}
			if (ano < 100) {
				ano += (ano < 50 ? 2000 : 1900);
			} else if (ano >= 100 && ano < 1900) {
				alert("El año debe ser mayor o igual a 1900");
				return false;
			}
			var d = new Date(ano, mes - 1, dia);
			if (!(d.getFullYear() == ano) && (d.getMonth()    == mes-1) && (d.getDate()     == dia)){
				alert("La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)");
				return false;
			}
		}
		return true;	
	}	
//------------------------------------------------------------------------------------------
	function __isRangoFechas() {
//		alert('__isRangoFechas');
		if (btnSelected("Alta",this.obj.form)||btnSelected("Cambio",this.obj.form)) {
			if(!comparaFechas(this.obj.form.PCRdesde.value,this.obj.form.PCRhasta.value,5)){
				this.error = "Error, la fecha desde debe ser menor o igual que la fecha hasta";
				this.obj.form.PCRdesde.focus();					
			}
		}
	}
//------------------------------------------------------------------------------------------							
	function deshabilitarValidacion(){
		objForm.PCRdesde.required = false;
		objForm.PCRhasta.required = false;
		//objForm.PCRregla.required = false;		
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.PCRdesde.required = true;
		objForm.PCRhasta.required = true;
		//objForm.PCRregla.required = true;		
	}	
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isRangoFechas", __isRangoFechas);
	objForm = new qForm("formReglasXMascara");

	objForm.PCRdesde.required = true;
	objForm.PCRdesde.description = "Fecha desde";			
	objForm.PCRhasta.required = true;
	objForm.PCRhasta.description = "Fecha hasta";			
		
	//objForm.PCRregla.validateRangoFechas();	
//------------------------------------------------------------------------------------------	
</script>