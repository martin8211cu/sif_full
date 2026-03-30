<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>
<cfset LvarEsContratosMultiples = LvarOBJ_PrecioU.EsContratosMultiples()>

<!--- Consultas --->
<!--- 1. Form --->
<cfif dmodo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsFormDetalle">
		select 
        		DCtipoitem, 
                Aid, 
                Cid, 
                ACcodigo, 
                ACid, 
                #LvarOBJ_PrecioU.enSQL_AS("DCpreciou")#, 
                Mcodigo, 
                DCtc, 
                DCgarantia, 
                DCdescripcion, 
                DCdescalterna, 
                DCcantcontrato, 
                DCcantsurtida, 
               (select a.Ucodigo from Articulos a where a.Aid=dc.Aid and a.Ecodigo = dc.Ecodigo)as Ucodigo,
                ts_rversion, 
                Icodigo, 
                DCdiasEntrega
		from DContratosCM dc
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and ECid = <cfqueryparam value="#Form.ECid#" cfsqltype="cf_sql_numeric">
			and DClinea = <cfqueryparam value="#Form.DClinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsArticulos">
		select Aid, Acodigo, Adescripcion 
		from Articulos
		where Aid =	<cfif len(trim(rsFormDetalle.Aid))><cfqueryparam value="#rsFormDetalle.Aid#" cfsqltype="cf_sql_numeric"><cfelse>-1</cfif>
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsConceptos">
		select Cid, Ccodigo, Cdescripcion 
		from Conceptos
		where Cid =	<cfif len(trim(rsFormDetalle.Cid))><cfqueryparam value="#rsFormDetalle.Cid#" cfsqltype="cf_sql_numeric"><cfelse>-1</cfif>
	</cfquery>

	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.Mcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>


<!--- Combo Categorias --->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion 
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Combo Clasificacion --->
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by ACcodigo, ACdescripcion	
</cfquery>

<!------ Combo Impuestos ------------->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo,Idescripcion
	from Impuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!------ Combo de Unidades ------------->
<cfquery name="rsUnidades" datasource="#Session.DSN#">
	select rtrim(Ucodigo) as Ucodigo, Udescripcion, Utipo
	from Unidades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Ucodigo
</cfquery>

<script language="JavaScript" type="text/JavaScript">
	function esBlanco( valor ){
		for ( var i=0; i<valor.length; i++){
			if (valor.charAt(i) != ' '){
				return false;
			}
		}
		return true
	}

	function borraServicio(){
		document.form1.Cid.value          = '';
		document.form1.Cdescripcion.value = '';
	}

	function cambiar_tipo( tipo, origen ) {
		// limpia los campos dinamicos, todos. Solo cuando los llama del combo
		if ( origen == 'c' ){
			document.form1.Aid.value          = '';
			document.form1.Cid.value          = '';
			document.form1.Ccodigo.value          = '';
			document.form1.Cdescripcion.value = '';	
		}	
	
		// muestra la opcion seleccionada
		var valor = new String(tipo).toUpperCase()
		var div_a    = document.getElementById("divA");
		var div_ae2  = document.getElementById("divAe");
		var div_f3   = document.getElementById("divF3");
		var div_fe   = document.getElementById("divFe");
		var div_s    = document.getElementById("divS");
		var div_se   = document.getElementById("divSe");
		
		switch ( valor ) {
		   case 'A' :
			   div_a.style.display  = '' ;
			   div_ae2.style.display  = '' ;
			   div_f3.style.display = 'none' ;
			   div_fe.style.display = 'none' ;
			   div_s.style.display  = 'none' ;
			   div_se.style.display = 'none' ;
			   document.form1.Cid.value = '';
			   document.form1.Ccodigo.value = '';
			   document.form1.Cdescripcion.value = '';

			   break;
		   case 'F' :
			   div_a.style.display  = 'none' ;
			   div_ae2.style.display  = 'none' ;
			   div_f3.style.display = '' ;
			   div_fe.style.display = '' ;		   
			   div_s.style.display  = 'none' ;
			   div_se.style.display = 'none' ;
			   document.form1.Aid.value = '';
			   document.form1.Acodigo.value = '';
			   document.form1.Adescripcion.value = '';
			   document.form1.Cid.value = '';
			   document.form1.Ccodigo.value = '';
			   document.form1.Cdescripcion.value = '';

			   break;
		   case 'S' :
			   div_a.style.display  = 'none' ;
			   div_ae2.style.display  = 'none' ;
			   div_f3.style.display = 'none' ;
			   div_fe.style.display = 'none' ;
			   div_s.style.display  = '' ;
			   div_se.style.display = '' ;
			   document.form1.Aid.value = '';
			   document.form1.Acodigo.value = '';
			   document.form1.Adescripcion.value = '';
	
			   break;
		   default :
			   div_a.style.display  = '';
			   div_ae2.style.display  = '';
			   div_f3.style.display = 'none';
			   div_fe.style.display = 'none';
			   div_s.style.display  = 'none';
			   div_se.style.display = 'none';
		}
		return;
	}

	function cambiar_categoria( valor, selected ) {
		if ( valor!= "" ) {
			// clasificacion
			document.form1.ACid.length = 0;
			i = 0;
			<cfoutput query="rsClasificacion">
				if ( #Trim(rsClasificacion.ACcodigo)# == valor ){
					document.form1.ACid.length = i+1;
					document.form1.ACid.options[i].value = '#rsClasificacion.ACid#';
					document.form1.ACid.options[i].text  = '#rsClasificacion.ACdescripcion#';
					if ( selected == #Trim(rsClasificacion.ACid)# ){
						document.form1.ACid.options[i].selected=true;
					}
					i++;
				};
			</cfoutput>
		}
		return;
	}
</script>

	<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >

		<tr><td>
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<!--- Linea que pinta el tipo de Compra, servicios/articulos/activos, compra directa --->
				<tr>
					<td align="right" width="14%" ><strong>Tipo:</strong>&nbsp;</td>
					<td nowrap>
						<select tabindex="1" name="DCtipoitem" onChange="javascript:cambiar_tipo(this.value, 'c');" <cfif dmodo neq 'ALTA'>disabled</cfif>>
							<option value="A" <cfif dmodo neq 'ALTA'  and len(trim(rsFormDetalle.Aid))>selected</cfif>>Art&iacute;culo</option>
							<option value="S" <cfif dmodo neq 'ALTA'  and len(trim(rsFormDetalle.Cid))>selected</cfif> >Servicio</option>
							<!--- <option value="F" <cfif dmodo neq 'ALTA'  and len(trim(rsFormDetalle.ACcodigo))>selected</cfif> >Activo Fijo</option> --->
						</select>
					</td>

					<td align="right"  width="15%" valign="middle" >
						<div id="divAe" style="display: none ;" ><strong>Art&iacute;culo:&nbsp;</strong></div>
						<div id="divFe" style="display: none ;" ><strong>Clasificaci&oacute;n/</strong><strong>Categor&iacute;a:&nbsp;</strong></div>
						<div id="divSe" style="display: none ;" ><strong>Servicio:&nbsp;</strong></div>
					</td>
					<td nowrap  width="30%">
						<div id="divS" style="display: none ;" >
							<cfif dmodo eq 'ALTA'>
								<cf_sifconceptos name="Ccodigo" tabindex="1" >
							<cfelse>
								<cf_sifconceptos name="Ccodigo" query="#rsConceptos#"  tabindex="1" >
							</cfif>
						</div>						

						<div id="divA" style="display: none ;" >
							<cfif dmodo neq 'ALTA'>
								<cf_sifarticulos name="Acodigo" query="#rsArticulos#"  tabindex="1" >
							<cfelse>
								<cf_sifarticulos name="Acodigo" tabindex="1" >
							</cfif>
						</div>
						
						<div id="divF3" style="display: none ;" >
							<select tabindex="1" name="ACcodigo" onChange="javascript:cambiar_categoria(this.value, '');" >
								<cfloop query="rsCategorias">
									<cfif dmodo EQ 'ALTA'>
										<option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
									<cfelse>
										<option value="#rsCategorias.ACcodigo#" <cfif rsFormDetalle.ACcodigo eq rsCategorias.ACcodigo >selected</cfif> >#rsCategorias.ACdescripcion#</option>
									</cfif>
								</cfloop>
							</select>
							<select tabindex="1" name="ACid" ></select>
						</div>
					</td>	

					<td align="right"  width="8%"><strong>Garant&iacute;a:</strong>&nbsp;</td>
					<td  width="10%">
						<input tabindex="1" type="text" name="DCgarantia" value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsFormDetalle.DCgarantia, 'none')#<cfelse>0</cfif>"  size="20" maxlength="20" style="text-align: right;" onblur="javascript:fm(this,0);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
						d&iacute;as
					</td>
				</tr>

				<tr>
					<td align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
					<td>
						<cfif dmodo NEQ "ALTA">
							 <cf_sifmonedas tabindex="1" query="#rsMoneda#" valueTC="#rsFormDetalle.DCtc#" onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"> 
						 <cfelse>
							 <cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
						</cfif> 
					</td>
					<td align="right" nowrap><strong>Tipo de Cambio:</strong>&nbsp;</td>
					<td>
						<input tabindex="1" type="text" name="DCtc" style="text-align:right"size="18" maxlength="10" 
									onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
									onFocus="javascript:this.select();" 
									onChange="javascript: fm(this,4);"
									value="<cfif dmodo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsFormDetalle.DCtc,',9.0000')#</cfoutput></cfif>"> 
					</td>
					
					<cfif LvarEsContratosMultiples>
						<!--- DCpreciou = Precio Unico, o Monto del Contrato sin Impuesto, con 2 decimales --->
						<td align="right" nowrap><strong>Subtotal:</strong>&nbsp;</td>
					<cfelse>
					 	<!--- DCpreciou = Precio Unitario, con numero de decimales de Parámetros --->
						<td align="right" nowrap><strong>Precio:</strong>&nbsp;</td>
					</cfif>
					<td>
						<cfparam name="rsFormDetalle.DCpreciou" default="0">
						<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
						#LvarOBJ_PrecioU.inputNumber("DCpreciou", rsFormDetalle.DCpreciou, "1", false, "", "", "", "")#
                     </td>
				</tr>
				
				<tr>
				  <td align="right"><strong>Descripci&oacute;n:</strong></td>
				  <td ><input tabindex="1" name="DCdescripcion" size="40" maxlength="255" value="<cfif dmodo NEQ 'ALTA'>#rsFormDetalle.DCdescripcion#</cfif>" onFocus="javascript: this.select();"></td>
				  <td align="right"><strong>Desc. Alterna:</strong></td>
				  <td align="left" nowrap><input tabindex="1" name="DCdescalterna" size="48" maxlength="255" type="text" value="<cfif dmodo NEQ "ALTA">#rsFormDetalle.DCdescalterna#</cfif>" ></td>
				  <td align="right" nowrap><strong>Impuesto:</strong></td>
				  <td align="left" nowrap><select name="Limpuestos" id="Limpuestos" >
                    <option value="">- No especificado -</option>
                    
                    <cfloop query="rsImpuestos">
                      <option value="#rsImpuestos.Icodigo#" <cfif dmodo NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsFormDetalle.Icodigo>selected</cfif>>#HTMLEditFormat(rsImpuestos.Idescripcion)#</option>
                    </cfloop>
                  </select></td>
			 	</tr>
                <tr>
                    <td align="right"><strong>Unidad:</strong></td>
                    <td >
                         <select name="Ucodigo">
                            <cfloop query="rsUnidades">
                              <option value="#rsUnidades.Ucodigo#"<cfif dmodo NEQ 'ALTA' and trim(rsUnidades.Ucodigo) EQ trim(rsFormDetalle.Ucodigo)> selected</cfif>>#rsUnidades.Ucodigo# - #rsUnidades.Udescripcion#</option>
                            </cfloop>
                        </select> 
                    </td>
					<cfif LvarEsContratosMultiples >
                        <td align="right"><strong>Cantidad:</strong></td>
                        <td align="left" nowrap><input tabindex="1" type="text" name="DCcantcontrato" value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsFormDetalle.DCcantcontrato, 'none')#<cfelse>0.00</cfif>"  size="20" maxlength="20" style="text-align: right;" onblur="javascript:fm(this,2); funcValidaCantidad()"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
                        <td align="right" nowrap><strong>Cantidad Surtida: </strong>&nbsp;</td>
                        <td align="left" nowrap><input tabindex="1" readonly=""  disabled type="text" name="DCcantsurtida" value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsFormDetalle.DCcantsurtida, 'none')#<cfelse>0.00</cfif>"  size="20" maxlength="20" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"  >					</td>								
                    </cfif>
				</tr>
                <tr>
					<td align="right"><strong>D&iacute;as de Entrega:</strong></td>
                    <cfset lvarValue = 0>
                    <cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.DCdiasEntrega)) gt 0>
                    	<cfset lvarValue = rsFormDetalle.DCdiasEntrega>
                    </cfif>
                    <td><cf_monto name="DCdiasEntrega"  value="#lvarValue#" decimales="0" negativos="false"></td>
              	</tr>
				<cfset dts = "">	
				<cfif dmodo neq "ALTA">
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="dts">
						<cfinvokeargument name="arTimeStamp" value="#rsFormDetalle.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="dtimestamp" value="#dts#">
					<input type="hidden" name="DClinea" value="#form.DClinea#">
				</cfif>
			</table>
		</td></tr>		
	</table>
	</cfoutput>
	<iframe name="clasificacion" id="clasificacion" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" ></iframe>
	<script language="JavaScript1.2">	
		var id_clasificacion = ''
		<cfoutput>
			<cfif modo neq 'ALTA' >
				<cfif dmodo neq 'ALTA'>
					id_clasificacion = #rsFormDetalle.ACid#
				</cfif>	
				
				cambiar_tipo( document.form1.DCtipoitem.value, 'i' );
				cambiar_categoria( document.form1.ACcodigo.value, id_clasificacion );
			</cfif>
		</cfoutput>
		
		<!--- Se comenta debido a que al seleccionar el articulo y servicio , unicamente  para los casos multicontrato 
				se cargaban las descripciones y descripciones alternas y se requeria independientemente del parametro--->
		function funcAcodigo(){
			unidad();
			<!---<cfif LvarEsContratosMultiples>--->
				document.form1.DCdescalterna.value = document.form1.Adescripcion.value;
				document.form1.DCdescripcion.value = document.form1.Adescripcion.value;
			<!---</cfif>	--->
		}
		
		function funcCcodigo(){
			<!---<cfif LvarEsContratosMultiples>--->
				document.form1.DCdescalterna.value = document.form1.Cdescripcion.value;
				document.form1.DCdescripcion.value = document.form1.Cdescripcion.value;
				unidadFS();
			<!---</cfif>--->
		}
		
		function asignaTC() {	
			if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
				formatCurrency(document.form1.TC,2);
				document.form1.DCtc.disabled = true;			
			}
			else{
				document.form1.DCtc.disabled = false;
			}	
			var estado = document.form1.DCtc.disabled;
			document.form1.DCtc.disabled = false;
			document.form1.DCtc.value = fm(document.form1.TC.value,2);
			document.form1.DCtc.disabled = estado;
		}
		
		function unidad(){
			document.getElementById("clasificacion").src = "UnidadArticulos.cfm?Aid="+document.form1.Aid.value;
		}
		
		function unidadFS(){
			document.form1.Ucodigo.disabled = false;
			// clasificacion
			document.form1.Ucodigo.length = 0;
			i = 0;
			<cfoutput query="rsUnidades">
				if ( #Trim(rsUnidades.Utipo)# == 1 || #Trim(rsUnidades.Utipo)# == 2){
					document.form1.Ucodigo.length = i+1;
					document.form1.Ucodigo.options[i].value = '#rsUnidades.Ucodigo#';
					document.form1.Ucodigo.options[i].text  = '#trim(rsUnidades.Ucodigo)# - #rsUnidades.Udescripcion#';
					i++;
				};
			</cfoutput>
		}

		asignaTC();
		function funcValidaCantidad(){			
			if(parseFloat(qf(document.form1.DCcantcontrato.value)) < parseFloat(qf(document.form1.DCcantsurtida.value))){
				alert("La cantidad del contrato " + document.form1.DCcantcontrato.value + " no puede ser menor a la cantidad surtida " +  document.form1.DCcantsurtida.value);
				document.form1.DCcantcontrato.value = 0;
			}
		}
		
	</script>