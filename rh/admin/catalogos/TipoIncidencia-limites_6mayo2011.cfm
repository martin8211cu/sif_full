<cfoutput>

<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr> 
		<td width="3%" ><input  name="CIlimitesConcepto" type="checkbox" id="CIlimitesConcepto" onChange="funcLC(this.checked)" <cfif modo NEQ "ALTA" and rs.CIlimitaconcepto EQ 1>checked</cfif>></td>
	  <td width="15%" nowrap  class="fileLabel"><cf_translate key="CHK_limitesConcepto">Limites de Monto</cf_translate></td>
	</tr>
<!---Tipo de límite--->
   <tr>
      <td width="3%"><input name="CIperiodo" type="radio" id="CIperiodo" value="0" <cfif modo NEQ "ALTA" and rs.CItipolimite EQ 0>checked</cfif> ></td>
     <td width="12%" nowrap><cf_translate key="radio_periodo">Para Per&iacute;odo</cf_translate></td>
	</tr>
   
   <tr>
      <td width="3%"><input name="CIperiodo" type="radio" id="CIperiodo" value="1"  <cfif modo NEQ "ALTA" and rs.CItipolimite EQ 1>checked</cfif> ></td>
     <td width="12%" nowrap><cf_translate key="radio_nomina">Para N&oacute;mina</cf_translate></td>
  </tr>
  
<!---Montos--->
	<tr><td>&nbsp;</td></tr>
	<tr ><td colspan="2" class="fileLabel"><cf_translate key="limitado_por">Limitado por :</cf_translate></td><td class="fileLabel"><cf_translate key="cantidad">Cantidad :</cf_translate></td> <td class="fileLabel"><cf_translate key="concepto">Concepto :</cf_translate></td></tr>
	<tr>        
		<td width="3%"><input name="CIimporte" type="radio" id="CIimporte" value="0"  onchange="funcImporte(this.value)"<cfif modo NEQ "ALTA" and rs.CItipometodo EQ 0>checked</cfif>></td>
		<td width="8%" nowrap><cf_translate key="importe">Horas</cf_translate></td>
		<td width="10%"><input type="text" name="monto1" id="monto1" maxlength="10" size="10" <cfif modo NEQ "ALTA" and rs.CItipometodo EQ 0> value="#LSNumberFormat(rs.CImontolimite,'99.99')#"</cfif>></td>	  
		  
		<cfif isdefined('rs.CIidexceso') and len(trim(rs.CIidexceso)) gt 0 and (modo NEQ "ALTA") and rs.CItipometodo EQ 0 >	  
			<cfquery name="rsD" datasource="#session.dsn#">
				select CIid as CIid1, CIcodigo as CIcodigo1,CIdescripcion as CIdescripcion1 from CIncidentes 
					where CIid=#rs.CIidexceso#	
			</cfquery>
			<td width="7%"  style="display:none" id="comboInci1" ><cf_rhCIncidentes IncluirTipo="0"  index="1"  query="#rsD#" Omitir="#form.CIid#"  > </td>
		<cfelse>
		<cfif isdefined("form.CIid")> 
			<td width="7%"  style="display:none" id="comboInci1" ><cf_rhCIncidentes IncluirTipo="0"  index="1" Omitir="#form.CIid#" > </td>
			<cfelse>
			   <td width="7%"  style="display:none" id="comboInci1" ><cf_rhCIncidentes IncluirTipo="0"  index="1" Omitir="" > </td>
			</cfif>
		</cfif>
	</tr>
	  	  
	<tr>	  
		<td width="3%"><input name="CIimporte" type="radio" id="CIimporte" value="1"  onchange="funcImporte(this.value)" <cfif modo NEQ "ALTA" and rs.CItipometodo EQ 1>checked</cfif> ></td>
		<td width="8%" nowrap><cf_translate key="dias">D&Iacute;as</cf_translate></td>
		<td width="10%"><input type="text" name="monto2" id="monto2" maxlength="10" size="10" <cfif modo NEQ "ALTA" and rs.CItipometodo EQ 1> value="#LSNumberFormat(rs.CImontolimite,'99.99')#"</cfif> ></td>
	
		<cfif isdefined('rs.CIidexceso') and len(trim(rs.CIidexceso)) gt 0 and (modo NEQ "ALTA") and rs.CItipometodo EQ 1 >
			<cfquery name="rsD1" datasource="#session.dsn#">
				select  CIid as CIid2 ,CIcodigo as CIcodigo2,CIdescripcion as CIdescripcion2 from CIncidentes
					where CIid=#rs.CIidexceso#
			</cfquery>
			<td width="7%"  style="display:none" id="comboInci2"><cf_rhCIncidentes IncluirTipo="1" index="2"  query="#rsD1#" Omitir="#form.CIid#" ></td>
		<cfelse>	 
			<cfif isdefined("form.CIid")> 
				<td width="7%"  style="display:none" id="comboInci2"><cf_rhCIncidentes IncluirTipo="1"  index="2" Omitir="#form.CIid#" ></td>
			<cfelse> 
				<td width="7%"  style="display:none" id="comboInci2"><cf_rhCIncidentes IncluirTipo="1"  index="2" Omitir="" ></td>  
			</cfif>   
		</cfif> 
	</tr>
	<tr>  
		<td width="3%"><input name="CIimporte" type="radio" id="CIimporte" value="2" onChange="funcImporte(this.value)" <cfif modo NEQ "ALTA" and rs.CItipometodo EQ 2>checked</cfif> ></td>
		<td width="8%" nowrap><cf_translate key="horas">Importe</cf_translate></td>
		<td width="10%"><input type="text" name="monto3" id="monto3" maxlength="10" size="10" <cfif modo NEQ "ALTA" and rs.CItipometodo EQ 2> value="#LSNumberFormat(rs.CImontolimite,'99.99')#"</cfif> ></td>
		
		<cfif isdefined('rs.CIidexceso') and len(trim(rs.CIidexceso)) gt 0 and  (modo NEQ "ALTA") and rs.CItipometodo EQ 2 >
			<cfquery name="rsD1" datasource="#session.dsn#">
				select  CIid as CIid3 ,CIcodigo as CIcodigo3,CIdescripcion as CIdescripcion3 from CIncidentes
					where CIid=#rs.CIidexceso# 
			</cfquery>
			<td width="7%"  style="display:none" id="comboInci3"><cf_rhCIncidentes IncluirTipoC="2"  index="3"  query="#rsD1#" ></td>
		<cfelse>	 
			<cfif isdefined("form.CIid")> 
			<td width="7%"  style="display:none" id="comboInci3"><cf_rhCIncidentes IncluirTipo="2"  index="3" Omitir="#form.CIid#" ></td>
			<cfelse>
			<td width="7%"  style="display:none" id="comboInci3"><cf_rhCIncidentes IncluirTipo="2"  index="3" Omitir=""  ></td>
			</cfif>   
		</cfif> 
	</tr>
	
	<tr>   
		<td width="3%"><input type="radio" name="CIimporte" id="CIimporte" value="4" onChange="funcImporte(this.value)" <cfif modo NEQ "ALTA" and rs.CItipometodo EQ 4>checked</cfif> ></td>
		<td width="8%"> <cf_translate key="veces_salario_minimo">Veces de Salario M&iacute;nimo:</cf_translate> </td>		
		<td width "10%">		
			<select name="DCvsmg">
			<option value="0">1X </option>
			<cfloop from="2" to ="30" index="i">
				<option value="#i#"#"X"# <cfif modo NEQ "ALTA">			
				<cfif rs.recordcount GT 0 and #i# EQ trim(rs.CImontolimite) and (modo NEQ "ALTA") and rs.CItipometodo EQ 4 >selected</cfif>
				</cfif>> #i##"X"# </option>
			</cfloop>
			</select>
		</td >   
		<input type="hidden" name="metodoaux" value="">  
		<cfif isdefined('rs.CIidexceso') and len(trim(rs.CIidexceso)) gt 0 and  (modo NEQ "ALTA") and rs.CItipometodo EQ 4 >
			<cfquery name="rsD1" datasource="#session.dsn#">
				select  CIid as CIid4 ,CIcodigo as CIcodigo4,CIdescripcion as CIdescripcion4 from CIncidentes
				where CIid=#rs.CIidexceso#
			</cfquery>		  
			<td width="7%"  style="display:none" id="comboInci4"><cf_rhCIncidentes IncluirTipoC="metodoaux"  index="4"  query="#rsD1#" Omitir="#form.CIid#" ></td>
		<cfelse>	
			<cfparam name="form.CIid" default=""> 		 		  
			<td width="7%"  style="display:none" id="comboInci4"><cf_rhCIncidentes IncluirTipoC="metodoaux" index="4" Omitir="#form.CIid#" ></td>		  
		</cfif>   
	</tr>
</table>
	
</cfoutput>
 
 
<script language="javascript" type="text/javascript">
	
<!--- Cuando se selecciona o Deselecciona los limites de Montos--->	
	function funcLC(Lvar){ 
	<!---Se selecciono los limites de montos --->
		if (Lvar==true){	
			var objDA = document.getElementById('comboInci1');	
			var objDA2 = document.getElementById('comboInci2');		
			var objDA3 = document.getElementById('comboInci3');	
			var objDA4 = document.getElementById('comboInci4');	
			//cuando carga me inserta el metodo
			devuelveMetodo();			
		
			//Habilitar los campos de limites de monto
			document.form1.CIperiodo[0].disabled = false;								
			document.form1.CIperiodo[1].disabled = false;
			
			//Poner requerido el limite del monto																			
			objForm.CIperiodo.required = true;
			objForm.CIperiodo.description = "Limite de monto";						
			
	    	 <!--- Se selecciono el metodo Horas--->
			if (document.form1.CItipo.value== 0 ){			
				if (document.form1.CIimporte[0].checked == true	)
					{	
						 pintarHoras();																																																																									
						
					}else if (document.form1.CIimporte[3].checked == true	)
						{						
						pintarVecesSalario();
						document.form1.CIimporte[0].disabled = false;							
					  	}else{					
						 pintarHoras();												
					  	}						  																																															
			}
			
			<!--- Se selecciono el metodo Días--->
				if (document.form1.CItipo.value== 1) {								
					if (document.form1.CIimporte[1].checked == true)
					{																								
						pintarDias();
					}else if (document.form1.CIimporte[3].checked == true) {																
								pintarVecesSalario();		
								document.form1.CIimporte[1].disabled = false;										
						  }	else{
						  	pintarDias();
						  }																    			
				}			
			
			 <!--- Se selecciono el metodo de Importe--->
				if (document.form1.CItipo.value== 2){																	
			   		 if (document.form1.CIimporte[2].checked == true)
					 {		
					 	pintarImporte();																		    											
					 } else if (document.form1.CIimporte[3].checked == true) {													
								pintarVecesSalario();	
								document.form1.CIimporte[2].disabled = false;												
							} else {
								pintarImporte();	
							}																																
			}
			
		<!---	 Se selecciono el metodo de Calculo--->
			if (document.form1.CItipo.value== 3){							
				pintarVecesSalario();					
			}
												   						
		}
				
		else{
			<!---se Deselecciona el check limites de Montos--->
			
			var objDA = document.getElementById('comboInci1');	
			var objDA2 = document.getElementById('comboInci2');		
			var objDA3 = document.getElementById('comboInci3');	
			var objDA4 = document.getElementById('comboInci4');	
			//se dehabilitan los campos
			document.form1.CIperiodo[0].disabled = true;		
			document.form1.CIperiodo[1].disabled = true;
			//campo de limites de montos , el requerido es igual a false
			objForm.CIperiodo.required = false;	
			
			//se deshabilitan los campos del limitado por
			document.form1.CIimporte[0].disabled = true;
			document.form1.CIimporte[1].disabled = true;
			document.form1.CIimporte[2].disabled = true;
			document.form1.CIimporte[3].disabled = true;	
					
			document.form1.monto1.disabled = true;
			document.form1.monto2.disabled = true;
			document.form1.monto3.disabled = true;
			document.form1.DCvsmg.disabled = true;	
		
			//El requerido de los campos de concepto se pone en falso
			objForm.CIid1.required = false;
			objForm.CIid2.required = false;
			objForm.CIid3.required = false;
			objForm.CIid4.required = false;
					
			objForm.monto1.required = false;
			objForm.monto2.required = false;
			objForm.monto3.required = false;	
			
			objDA.style.display = 'none';	
			objDA2.style.display='none';
			objDA3.style.display='none';
			objDA4.style.display='none';		
			}
	}
		
				
	function funcImporte(LvarI){

		if(LvarI==0){
				devuelveMetodo();	
		        limpiarCantidad();
		        objForm.CIid1.required = true;
				objForm.CIid1.description = "Concepto";						
				objForm.CIid2.required = false;
				objForm.CIid3.required = false;
				objForm.CIid4.required = false;
				
				objForm.monto1.required = true;
				objForm.monto1.description = "Cantidad";		
				objForm.monto2.required = false;
				objForm.monto3.required = false;
				
				document.form1.monto1.disabled = false;							
				document.form1.monto2.disabled = true;
				document.form1.monto3.disabled = true;
				document.form1.DCvsmg.disabled = true;					
				var objDA = document.getElementById('comboInci1');	
				var objDA2 = document.getElementById('comboInci2');		
				var objDA3 = document.getElementById('comboInci3');	
				var objDA4 = document.getElementById('comboInci4');		
			    objDA.style.display = '';				
				objDA2.style.display='none';
				objDA3.style.display='none';
				objDA4.style.display='none';	
					
				document.form1.CIcodigo2.value="";	
				document.form1.CIdescripcion2.value="";	
				document.form1.CIid2.value="";	
				document.form1.CIcodigo3.value="";	
				document.form1.CIdescripcion3.value="";	
				document.form1.CIid3.value="";	
				document.form1.CIcodigo4.value="";	
				document.form1.CIdescripcion4.value="";	
				document.form1.CIid4.value="";	
				document.form1.DCvsmg.options[0].selected=true;				
								 																													
		}
		if(LvarI==1){
				devuelveMetodo();			        
		        limpiarCantidad();	
				
				objForm.CIid1.required = false;
				objForm.CIid2.required = true;
				objForm.CIid2.description = "Concepto";						
				objForm.CIid3.required = false;
				objForm.CIid4.required = false;				
				objForm.monto1.required = false;
				objForm.monto2.required = true;
				objForm.monto2.description = "Cantidad";		
				objForm.monto3.required = false;
						        
		        document.form1.monto1.disabled = true;												
		        document.form1.monto2.disabled = false;
				document.form1.monto3.disabled = true;				
				document.form1.DCvsmg.disabled = true;
				
				var objDA = document.getElementById('comboInci1');	
				var objDA2 = document.getElementById('comboInci2');		
				var objDA3 = document.getElementById('comboInci3');	
				var objDA4 = document.getElementById('comboInci4');	
			    objDA.style.display = 'none';	
				objDA2.style.display='';
				objDA2.disabled=true;
				objDA3.style.display='none';
				objDA4.style.display='none';	
											
				document.form1.CIcodigo1.value="";	
				document.form1.CIdescripcion1.value="";	
				document.form1.CIid1.value="";	
				document.form1.CIcodigo3.value="";	
				document.form1.CIdescripcion3.value="";	
				document.form1.CIid3.value="";	
				document.form1.CIcodigo4.value="";	
				document.form1.CIdescripcion4.value="";	
				document.form1.CIid4.value="";		
				document.form1.DCvsmg.options[0].selected=true;			
			   
																        		
		}
		if(LvarI==2){
		       devuelveMetodo();	
		        limpiarCantidad();
				
				objForm.CIid1.required = false;
				objForm.CIid2.required = false;
				objForm.CIid3.required = true;
				objForm.CIid3.description = "Concepto";										
				objForm.CIid4.required = false;
		       
				objForm.monto1.required = false;
				objForm.monto2.required = false;
				objForm.monto3.required = true;
				objForm.monto3.description = "Cantidad";	
				
				document.form1.monto1.disabled = true;
		        document.form1.monto2.disabled = true;
				document.form1.monto3.disabled = false;				
				document.form1.DCvsmg.disabled = true;				
				var objDA = document.getElementById('comboInci1');	
				var objDA2 = document.getElementById('comboInci2');		
				var objDA3 = document.getElementById('comboInci3');	
				var objDA4 = document.getElementById('comboInci4');	
			    objDA.style.display = 'none';	
				objDA2.style.display='none';
				objDA3.style.display='';
				objDA4.style.display='none';	
				
				document.form1.CIcodigo1.value="";	
				document.form1.CIdescripcion1.value="";	
				document.form1.CIid1.value="";	
				document.form1.CIcodigo2.value="";	
				document.form1.CIdescripcion2.value="";	
				document.form1.CIid2.value="";	
				document.form1.CIcodigo4.value="";	
				document.form1.CIdescripcion4.value="";	
				document.form1.CIid4.value="";	
				document.form1.DCvsmg.options[0].selected=true;	
																																								
		}
		if(LvarI==4){	
				devuelveMetodo();						
		        limpiarCantidad();
				objForm.monto1.required = false;
				objForm.monto2.required = false;
				objForm.monto3.required = false;
				
				objForm.CIid1.required = false;
				objForm.CIid2.required = false;
				objForm.CIid3.required = false;
				objForm.CIid4.required = true;
				objForm.CIid4.description = "Concepto";
								
		        document.form1.monto1.disabled = true;
				document.form1.monto2.disabled = true;
				document.form1.monto3.disabled = true;
				document.form1.DCvsmg.disabled = false;			
				var objDA = document.getElementById('comboInci1');	
				var objDA2 = document.getElementById('comboInci2');		
				var objDA3 = document.getElementById('comboInci3');	
				var objDA4 = document.getElementById('comboInci4');	
			    objDA.style.display = 'none';	
				objDA2.style.display='none';
				objDA3.style.display='none';
				objDA4.style.display='';	
			
				document.form1.CIcodigo1.value="";	
				document.form1.CIdescripcion1.value="";	
				document.form1.CIid1.value="";	
				document.form1.CIcodigo2.value="";	
				document.form1.CIdescripcion2.value="";	
				document.form1.CIid2.value="";	
				document.form1.CIcodigo3.value="";	
				document.form1.CIdescripcion3.value="";	
				document.form1.CIid3.value="";	
				document.form1.CIcodigo4.value="";	
				document.form1.CIdescripcion4.value="";		
				document.form1.CIid4.value="";								
		   }
	}
	
	function limpiarCantidad(){	   
		 document.form1.monto1.value="";
		 document.form1.monto2.value="";
		 document.form1.monto3.value="";	 	               
	}
	
	function devuelveMetodo(){
	if (document.form1.CItipo.value== 0) {			   
		document.form1.metodoaux.value=0;
	}
	if (document.form1.CItipo.value== 1) {		
		document.form1.metodoaux.value=1;
	}
	if (document.form1.CItipo.value== 2) {		
		document.form1.metodoaux.value=2;
	}
	if (document.form1.CItipo.value== 3) {			
		document.form1.metodoaux.value=2;
	}	
	}
	
	
	function pintarHoras(){

	var objDA = document.getElementById('comboInci1');	
	var objDA2 = document.getElementById('comboInci2');		
	var objDA3 = document.getElementById('comboInci3');	
	var objDA4 = document.getElementById('comboInci4');			
	
	document.form1.CIimporte[0].disabled = false;	
	document.form1.CIimporte[0].checked = true;	
	document.form1.CIimporte[1].disabled = true;
	document.form1.CIimporte[2].disabled = true;
	document.form1.CIimporte[3].disabled = false;
																															
	document.form1.monto1.disabled = false;
	document.form1.monto2.disabled = true;
	document.form1.monto3.disabled = true;
	document.form1.DCvsmg.disabled = true;	
	
	objDA.style.display = '';	
	objDA2.style.display='none';
	objDA3.style.display='none';
	objDA4.style.display='none';	
					
	objForm.CIid1.required = true;
	objForm.CIid1.description = "Concepto";			
	objForm.CIid2.required = false;										
	objForm.CIid3.required = false;													
	objForm.CIid4.required = false;	
								
	objForm.monto1.required = true;
	objForm.monto1.description = "Cantidad";				
	objForm.monto2.required = false;					
	objForm.monto3.required = false;	
	
	} 
	
	function pintarDias(){
	
	var objDA = document.getElementById('comboInci1');	
	var objDA2 = document.getElementById('comboInci2');		
	var objDA3 = document.getElementById('comboInci3');	
	var objDA4 = document.getElementById('comboInci4');	
	
	document.form1.CIimporte[0].disabled = true;
	document.form1.CIimporte[1].disabled = false;	
	document.form1.CIimporte[1].checked = true;															
	document.form1.CIimporte[2].disabled = true;				
	document.form1.CIimporte[3].disabled = false;	
		
	document.form1.monto1.disabled = true;
	document.form1.monto2.disabled = false;
	document.form1.monto3.disabled = true;
	document.form1.DCvsmg.disabled = true;	
	
	objDA.style.display = 'none';	
	objDA2.style.display='';
	objDA3.style.display='none';
	objDA4.style.display='none';
													
	objForm.CIid1.required = false;
	objForm.CIid2.required = true;
	objForm.CIid2.description = "Concepto";						
	objForm.CIid3.required = false;
	objForm.CIid4.required = false;	
				
	objForm.monto1.required = false;
	objForm.monto2.required = true;
	objForm.monto2.description = "Cantidad";		
	objForm.monto3.required = false;
	
	}
	
	function pintarImporte(){
	
	var objDA = document.getElementById('comboInci1');	
	var objDA2 = document.getElementById('comboInci2');		
	var objDA3 = document.getElementById('comboInci3');	
	var objDA4 = document.getElementById('comboInci4');	
	
	document.form1.CIimporte[0].disabled = true;
	document.form1.CIimporte[1].disabled = true;				
	document.form1.CIimporte[2].disabled = false;	
	
	document.form1.CIimporte[2].checked = true;										
	document.form1.CIimporte[3].disabled = false;							
	document.form1.monto1.disabled = true;
	document.form1.monto2.disabled = true;
	document.form1.monto3.disabled = false;
	document.form1.DCvsmg.disabled = true;	
	
	objDA.style.display = 'none';	
	objDA2.style.display='none';
	objDA3.style.display='';
	objDA4.style.display='none';	
	document.form1.monto1.value="";
	document.form1.monto2.value="";		
	
	objForm.CIid1.required = false;
	objForm.CIid2.required = false;										
	objForm.CIid3.required = true;
	objForm.CIid3.description = "Concepto";						
	objForm.CIid4.required = false;	
				
	objForm.monto1.required = false;
	objForm.monto2.required = false;					
	objForm.monto3.required = true;	
	objForm.monto3.description = "Cantidad";
	
	}
	
	function pintarVecesSalario(){
	
	var objDA = document.getElementById('comboInci1');	
	var objDA2 = document.getElementById('comboInci2');		
	var objDA3 = document.getElementById('comboInci3');	
	var objDA4 = document.getElementById('comboInci4');	
	
	document.form1.CIimporte[0].disabled = true;						
	document.form1.CIimporte[1].disabled = true;
	document.form1.CIimporte[2].disabled = true;
	document.form1.CIimporte[3].disabled = false;
	document.form1.CIimporte[3].checked = true;
																															
	document.form1.monto1.disabled = true;
	document.form1.monto2.disabled = true;
	document.form1.monto3.disabled = true;
	document.form1.DCvsmg.disabled = false;	
	
	objDA.style.display = 'none';	
	objDA2.style.display='none';
	objDA3.style.display='none';
	objDA4.style.display='';		
										
	objForm.CIid1.required = false;
	objForm.CIid2.required = false;										
	objForm.CIid3.required = false;													
	objForm.CIid4.required = true;	
	objForm.CIid4.description = "Concepto";			
				
	objForm.monto1.required = false;
	objForm.monto2.required = false;					
	objForm.monto3.required = false;									
	objForm.monto3.description = "Cantidad";	
	
	}
	
</script>
