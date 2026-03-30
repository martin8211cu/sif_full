<cfparam	name="Attributes.id"				type="string"	default="">						<!--- Id de Prepago de Tarjeta Prepago --->
<cfparam	name="Attributes.agente"			type="string"	default="">						<!--- Nombre del campo que contiene el Id de Agente por el cual se van a filtrar las tarjetas prepago --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.funcion" 			type="string"	default="cargaPrepago#Attributes.sufijo#">						<!--- funcion a invocar despues de seleccionar en el conlis --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexión --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">				<!--- se usa para indicar si se muestra en modo consulta --->
<cfparam 	name="Attributes.readOnlyAgente" 	type="boolean"	default="false">				<!--- se usa para indicar si el tag de Agente se muestra o no en modo consulta --->
<cfparam 	name="Attributes.pintaPidAgente" 	type="boolean"	default="true">					<!--- se usa para pintar o no el Pid del Agente, se usa conjuntamente con el parametro readOnlyAgente en true --->
<cfparam	name="Attributes.filtrarEstados"	type="string"	default="">						<!--- Se usa para filtrar los tipos de estados de las tarjetas prepago, se envían los códigos que se desean mostrar --->


<cfset ExistePrepago = (isdefined("Attributes.id") and Len(Trim(Attributes.id)))>

<cfif Attributes.readOnly and not ExistePrepago>
	<cfthrow message="Error: para utilizar el atributo de readOnly se requiere enviar el atributo id">
</cfif>

<cfoutput>
	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td align="right"><strong>Prepago:</strong></td>
		<td>
			<cfset agenteLlave="">
			<cfset vROnly="false">			
			<cfif isdefined("Attributes.agente") and len(trim(Attributes.agente)) and Attributes.agente neq "-1">
				<input type="hidden" name="agenteId" value="#Attributes.agente#">
				<cfset agenteLlave="agenteId">
				<cfset vROnly="true">
			</cfif>
			
			<cf_prepago
				id="#Attributes.id#"
				form="#Attributes.form#"		
				agente="#agenteLlave#"		
				sufijo="#Attributes.sufijo#"				
				funcion="#Attributes.funcion#"								
				Ecodigo="#Attributes.Ecodigo#"				
				Conexion="#Attributes.Conexion#"
				filtrarEstados="#Attributes.filtrarEstados#"				
				readOnly="#Attributes.readOnly#">	
		</td>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Agente</strong>:</td>
		<td>
			<cfif Attributes.readOnlyAgente>
 				<input type="hidden" name="Pquien#Attributes.sufijo#" value="">
				<input type="hidden" name="AGidp#Attributes.sufijo#" value="">
				
				<cfif Attributes.pintaPidAgente>
					<input type="text" name="Pid#Attributes.sufijo#" value="" size="20" maxlength="20" class="cajasinbordeb" readonly="true">
					&nbsp;				
				</cfif>
				<input type="text" name="NombreAgente#Attributes.sufijo#" size="40" maxlength="140" value="" class="cajasinbordeb" readonly="true">
			<cfelse>
				<cf_agenteId
					id_agente="#Attributes.agente#"
					form="#Attributes.form#"				
					sufijo="#Attributes.sufijo#"				
					funcion="#Attributes.funcion#"								
					Ecodigo="#Attributes.Ecodigo#"	
					readOnly = "#vROnly#"
					Conexion="#Attributes.Conexion#">				
			</cfif>
		</td>
		<td align="right" nowrap><strong>Fecha 1er Uso:</strong></td>
		<td>		  
			<input 
				type="text" 
				class="cajasinbordeb"
				readonly="true"   tabindex="-1"
				name="fechaUso#Attributes.sufijo#" 
				size="20" 
				maxlength="20" 
				value="">	
		</td>
		<td align="right" nowrap><strong>Vigencia (d&iacute;as):</strong></td>
		<td>			
			<input 
				type="text" 
				class="cajasinbordeb"
				readonly="true" tabindex="-1"
				name="diasVigencia#Attributes.sufijo#" 
				size="20" 
				maxlength="20" 
				value="">
		</td>
	  </tr>  
	  <tr>
		<td align="right"><strong>Paquete:</strong></td>
		<td nowrap>
		  <input 
				type="text" 
				class="cajasinbordeb"
				readonly="true"   tabindex="-1"
				name="codPaq#Attributes.sufijo#" 
				size="4" 
				maxlength="4" 
				value="">			
		  <input 
				type="text" 
				class="cajasinbordeb"
				readonly="true"   tabindex="-1"
				name="nombPaq#Attributes.sufijo#" 
				size="40" 
				maxlength="40" 
				value="">							
		</td>
		<td align="right"><strong>Estado:</strong></td>
		<td>
		  <input 
				type="text" 
				class="cajasinbordeb"
				readonly="true"   tabindex="-1"
				name="descEstado#Attributes.sufijo#" 
				size="10" 
				maxlength="10" 
				value="">
		</td>
		<td align="right"><strong>Liquidada:</strong></td>
		<td>
			<img id="checked#Attributes.sufijo#" src="/cfmx/saci/images/checked.gif" border="0">
			<img id="unchecked#Attributes.sufijo#" src="/cfmx/saci/images/unchecked.gif" border="0">			
		</td>
	  </tr>

	  <tr>
		<td align="right"><strong>Precio:</strong></td>
		<td nowrap="nowrap">			
			<span id="moneda#Attributes.sufijo#"></span>
			<input 
				type="text" 
				class="cajasinbordeb"
				readonly="true"   tabindex="-1"
				name="precio#Attributes.sufijo#" 
				size="20" 
				maxlength="20" 
				value="">
		</td>
		<td align="right"><strong>Tiempo Total:</strong></td>
		<td nowrap>		
			<input 
				type="text" 
				class="cajasinbordeb"
				readonly="true"   tabindex="-1"
				name="totOrig#Attributes.sufijo#" 
				size="20" 
				maxlength="20" 
				value="">
		</td>
		<td align="right" nowrap="nowrap"><strong>Tiempo Disponible</strong>:</td>
		<td nowrap>
			<input 
				type="text" 
				class="cajasinbordeb"
				readonly="true"   tabindex="-1"
				name="totSaldo#Attributes.sufijo#" 
				size="20" 
				maxlength="20" 
				value="">		
		</td>
	  </tr>
	</table>	

	<script language="javascript" type="text/javascript">
	
		function cargaPrepago#Attributes.sufijo#(){
			document.#Attributes.form#.codPaq#Attributes.sufijo#.value = document.#Attributes.form#.PQcodigo#Attributes.sufijo#.value;
			var PQnombreDesc = document.#Attributes.form#.PQnombre#Attributes.sufijo#.value;
			if(PQnombreDesc != '')
				document.#Attributes.form#.nombPaq#Attributes.sufijo#.value = '- ' + PQnombreDesc;
			else
				document.#Attributes.form#.nombPaq#Attributes.sufijo#.value = '';
			document.#Attributes.form#.descEstado#Attributes.sufijo#.value = document.#Attributes.form#.descTJestado#Attributes.sufijo#.value;			
			document.#Attributes.form#.fechaUso#Attributes.sufijo#.value = document.#Attributes.form#.TJuso#Attributes.sufijo#.value;
			document.#Attributes.form#.diasVigencia#Attributes.sufijo#.value = document.#Attributes.form#.TJvigencia#Attributes.sufijo#.value;
			document.all.moneda#Attributes.sufijo#.innerHTML = "<strong>"+document.#Attributes.form#.Moneda#Attributes.sufijo#.value+"</strong>";
			document.#Attributes.form#.precio#Attributes.sufijo#.value = fm(document.#Attributes.form#.TJprecio#Attributes.sufijo#.value,2);

			
			var totOrig = parseInt(document.#Attributes.form#.TJoriginal#Attributes.sufijo#.value);
			var strTotOrig = ""+parseInt((totOrig/3600))+":"+parseInt(((totOrig%3600)/60))+":"+((totOrig%3600)%60)+" seg.";

			if(totOrig != ''){
				lin = document.#Attributes.form#.totOrig#Attributes.sufijo#.value = strTotOrig;
			}else{
				if(PQnombreDesc != '')
					document.#Attributes.form#.totOrig#Attributes.sufijo#.value = '0:00:00 seg.';
				else
					lin = document.#Attributes.form#.totOrig#Attributes.sufijo#.value = '';
			}
			
			var totSaldo = parseInt(document.#Attributes.form#.TJdsaldo#Attributes.sufijo#.value);
			var strTotSaldo = ""+parseInt((totSaldo/3600))+":"+parseInt(((totSaldo%3600)/60))+":"+((totSaldo%3600)%60)+" seg.";
			
			if(totSaldo != ''){
				document.#Attributes.form#.totSaldo#Attributes.sufijo#.value = strTotSaldo;
			}else{
				if(PQnombreDesc != '')
					document.#Attributes.form#.totSaldo#Attributes.sufijo#.value = '0:00:00 seg.';
				else			
					document.#Attributes.form#.totSaldo#Attributes.sufijo#.value = '';
			}					

			//-------------------------------------	Cargando objetos del tag de agenteInf	-------------------------------------
			document.#Attributes.form#.Pquien#Attributes.sufijo#.value = document.#Attributes.form#.PquienPrep#Attributes.sufijo#.value;
			document.#Attributes.form#.NombreAgente#Attributes.sufijo#.value = document.#Attributes.form#.nom_razon#Attributes.sufijo#.value;
			<cfif Attributes.pintaPidAgente>
				document.#Attributes.form#.Pid#Attributes.sufijo#.value = document.#Attributes.form#.PidPrep#Attributes.sufijo#.value;
			</cfif>			
			document.#Attributes.form#.AGidp#Attributes.sufijo#.value = document.#Attributes.form#.AGidPrep#Attributes.sufijo#.value;
			//---------------------------------------------------------------------------------------------------------------
			var liquidada = document.#Attributes.form#.TJliquidada#Attributes.sufijo#.value;
			if(liquidada == 1){	//Liquidada
				apagaChecks(1);
			}else{//Liquidada
				if(liquidada == 0)	//NO Liquidada
					apagaChecks(2);
				if(liquidada == '')	//Apaga todo
					apagaChecks(3);
			}							
		}
		function apagaChecks(opc){
			switch(opc){
				case 1:{//prende check y apaga uncheck
					document.getElementById('checked#Attributes.sufijo#').style.display = '';
					document.getElementById('unchecked#Attributes.sufijo#').style.display = 'none';					
					break;
				}
				case 2:{//prende uncheck y apaga check
					document.getElementById('checked#Attributes.sufijo#').style.display = 'none';
					document.getElementById('unchecked#Attributes.sufijo#').style.display = '';					
					break;
				}				
				case 3:{//Apagar todo
					document.getElementById('checked#Attributes.sufijo#').style.display = 'none';
					document.getElementById('unchecked#Attributes.sufijo#').style.display = 'none';					
					break;
				}				
			}
		}
		apagaChecks(3);
 		<cfif ExistePrepago>
			cargaPrepago#Attributes.sufijo#();
		</cfif>
	</script>
</cfoutput>