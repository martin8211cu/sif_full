<cfoutput>
<input type="hidden" name="hcr" id="hcr" value="<cfif (lcase(mododet) eq 'cambio')>#rsDPD.cantidadrestante#<cfelse>0</cfif>">
<input type="hidden" name="mcr" id="mcr" value="<cfif (lcase(mododet) eq 'cambio')>#rsDPD.montorestante#<cfelse>0</cfif>">
<table width="100%"  border="0" cellspacing="2" cellpadding="2">
    <tr>
        <!--- Item a desalmacenar --->
		<td width="1%" nowrap><strong>Item:&nbsp;</strong></td>
		<td>
			<table> 
			  <tr>
				<td><input <cfif (lcase(mododet) eq 'cambio')>disabled</cfif> readonly size="30" maxlength="255" tabindex="2" type="text" name="DPDdescripcion" value="<cfif (lcase(mododet) eq 'cambio')>#rsDPD.DPDdescripcion#</cfif>"></td>
				<td>
					<cfif (lcase(mododet) neq 'cambio')><a href="##" onClick="javascript:VerLineasTracking();"><img border="0" src="../../imagenes/Description.gif"></a></cfif>
					<input type="hidden" name="ETIiditem" value="<cfif (lcase(mododet) eq 'cambio')>#rsDPD.DDlinea#</cfif>">
				</td>
			  </tr>
			</table>
			<input type="hidden" name="DOlinea" value="<cfif (lcase(mododet) eq 'cambio') and len(rsDPD.DOlinea)>#rsDPD.DOlinea#<cfelseif (lcase(mododet) eq 'cambio') and len(rsDPD.DOlinea) eq 0>-1</cfif>">
		</td>
		<td nowrap><strong>Cantidad&nbsp;:&nbsp;</strong></td>				
		<td>
			<table>
			  <tr>
				<!--- Cantidad a desalmacenar --->
				<td>
                	<cfset Lvarvalue = '0.0000'>
	                <cfif (lcase(mododet) eq 'cambio')>
	                    <cfset Lvarvalue='#NumberFormat(rsDPD.DPDcantidad,'_.____')#'>
                    </cfif>
                
					<input name="DPDcantidad"
						tabindex="2"
						onblur="javascript: actualizarMonto();"
						type="text"
						size="20"
						maxlength="18"
						style="text-align: right"
						onFocus="javascript: this.value = qf(this); this.select();"
						onBlur="javascript: fm(this,4);"
						onKeyUp="javascript: if(snumber(this,event,4))	{ if ( Key(event)=='13' ) { this.blur(); } } "
						value="#Lvarvalue#">
				</td>
				<!--- Cantidad restante en el tracking --->
				<td id="cantidadrestante">&nbsp;(<cfif (lcase(mododet) eq 'cambio' and len(trim(rsDPD.cantidadrestante)))>#rsDPD.cantidadrestante#<cfelse>0</cfif>)</td>
				<!--- Unidad --->
				<td id="unidad">&nbsp;<cfif (lcase(mododet) eq 'cambio') and len(rsDPD.Udescripcion)>(#rsDPD.Udescripcion#)<cfelse></cfif></td>
			  </tr>
			</table>
		</td>
		<!--- Reclamos --->
		<td nowrap><strong>Reclamos&nbsp;:&nbsp;</strong></td>
		<td>
			<!--- Precio Unitario --->
			<input type="hidden" readonly="" size="15" style="border:0; text-align:right" name="DPDcostoudescoc" value="<cfif (lcase(mododet) eq 'cambio')>#rsDPD.DPDcostoudescoc#<cfelse>0.0000</cfif>">
			<!--- Cantidad y Observaciones a reclamar--->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<input name="DPDcantreclamo" 
						tabindex="2" 
						type="text" 
						size="20"
						maxlength="18"
						style="text-align: right"  
						onFocus="javascript: this.value = qf(this); this.select();" 
						onBlur="javascript: fm(this,2);" 
						onKeyUp="javascript: if(snumber(this,event,2))	{ if ( Key(event)=='13' ) { this.blur(); } } " 
						<cfif (lcase(mododet) eq 'cambio')>
						value="#LSCurrencyFormat(rsDPD.DPDcantreclamo,'none')#"
						<cfelse>
						value="0.00"
						</cfif>
						>
				</td>
				<td>
					<cfif (lcase(mododet) eq 'cambio')>
						<cf_sifinfo name="DPDobsreclamo" titulo="#JSStringFormat('Observaciones del Reclamo')#" height="290" value="#JSStringFormat(rsDPD.DPDobsreclamo)#">
					<cfelse>
						<cf_sifinfo name="DPDobsreclamo" titulo="#JSStringFormat('Observaciones del Reclamo')#" height="290">
					</cfif>
				</td>
			  </tr>
			</table>
		</td>
		<!--- Monto fob de la línea y restante --->
		<td nowrap><strong>Monto&nbsp;:&nbsp;</strong></td>
		<td>
			<table>
			  <tr>
				<td>
					<input name='DPDmontofobreal' tabindex="2"
						<cfif (lcase(mododet) eq 'cambio')>disabled</cfif>
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' value="<cfif (lcase(mododet) eq 'cambio')>#LSCurrencyFormat(rsDPD.DPDmontofobreal,'none')#<cfelse>0.00</cfif>">				
				</td>
				<td id="montorestante">&nbsp;(<cfif (lcase(mododet) eq 'cambio')>#LSCurrencyFormat(rsDPD.montorestante,'none')#<cfelse>0.00</cfif>)</td>
			  </tr>
			</table>
		</td>
	</tr>
	<tr>
		<!--- Código aduanal a asociar al ítem --->
		<td width="1%" nowrap><strong>C&oacute;digo Aduanal&nbsp;:&nbsp;</strong></td>
		<td nowrap>		  
		  <cfif mododet eq 'cambio' and len(trim(rsDPD.CAid))>
		  	<cfquery name="rsCodAduanal" datasource="#session.DSN#">
				select CAcodigo,CAdescripcion 
				from CodigoAduanal
				where CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDPD.CAid#">
			</cfquery>
		  </cfif>
		  <input type="hidden"  name="CAid" value="<cfif mododet eq 'cambio' and len(trim(rsDPD.CAid))>#rsDPD.CAid#</cfif>">
		  <input name="CAcodigo" type="text" value="<cfif isDefined("rsCodAduanal") and len(trim(rsCodAduanal.CAcodigo))>#rsCodAduanal.CAcodigo#</cfif>"  id="CAcodigo" size="15" maxlength="20" tabindex="-1" onBlur="javascript:traerCodAduanal(this.value,1);cambiarImpuesto(document.form1.CAid.value,document.form1.DPDpaisori.value)">
		  <input name="CAdescripcion" type="text" id="CAdescripcion" value="<cfif isDefined("rsCodAduanal") and len(trim(rsCodAduanal.CAdescripcion))>#rsCodAduanal.CAdescripcion#</cfif>" size="40" readonly disabled>
		  <a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCodAduanal();"> </a></td>

			<!----
			<select name="CAid" id="CAid" tabindex="2" onChange="javascript:cambiarImpuesto(document.form1.CAid.value,document.form1.DPDpaisori.value);">
			<cfloop query="rsCodigoAduanal">
				<option value="#CAid#" <cfif (lcase(mododet) eq 'cambio' and rsDPD.CAid eq CAid)>selected</cfif>>
					#HTMLEditFormat(CAdescripcion)#
				</option>
			</cfloop>
			</select>
			----->
		</td>
		<!--- País --->
		<td nowrap><strong>Pa&iacute;s&nbsp;:&nbsp;</strong></td>
		<td>
			<!---<select name="DPDpaisori" tabindex="2" onChange="javascript:cambiarImpuesto(document.form1.CAid.value,document.form1.DPDpaisori.value);">
				<cfloop query="rsPais">
					<option value="#Ppais#" <cfif (lcase(mododet) eq 'cambio' and rsDPD.DPDpaisori eq Ppais)>selected</cfif>>
						#HTMLEditFormat(Pnombre)#
					</option>
				</cfloop>
			</select>--->
            
            <!--- Asiganacion de las variables en caso de ser modo cambio --->
                    <cfset ArrayDatosOrigen=ArrayNew(1)>
					<cfif (lcase(mododet) eq 'cambio')>
                    	<cfquery name="rsPaisOri" datasource="#session.dsn#">
                        	select po.Ppais as DPDpaisori, po.Pnombre as PDnombreOri
                            from Pais as po
                            where po.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDPD.DPDpaisori#">
                        </cfquery>
						<cfset ArrayAppend(ArrayDatosOrigen,rsPaisOri.DPDpaisori)>
						<cfset ArrayAppend(ArrayDatosOrigen,rsPaisOri.PDnombreOri)>
					</cfif>
					<cf_conlis 
                                    title		   				="Pais de Origen"
                                    campos 				= "DPDpaisori,PDnombreOri" 
                                    ValuesArray		="#ArrayDatosOrigen#" 
                                    desplegables 	= "N,S" 
                                    modificables 		= "N,S"
                                    size 					= "0,0"
                                    tabla					="Pais as po" 
                                    columnas			="po.Ppais as DPDpaisori, po.Pnombre as PDnombreOri"
                                    filtrar_por				="po.Ppais,po.Pnombre"
                                    desplegar			="DPDpaisori, PDnombreOri"
                                    etiquetas			="Abreviatura, Nombre"
                                    formatos				="V,V"
                                    align						="left,left"
                                    tabindex				= "7"
                                    form						= "form1"
                                    asignar				="DPDpaisori, PDnombreOri"
                                    asignarformatos	="S,S">  
		</td>
		<!--- Impuesto del ítem --->
		<td width="1%" nowrap><strong>Impuesto&nbsp;:&nbsp;</strong></td>
		<td>
        	<cfif (lcase(mododet) eq 'cambio') and isdefined('rsDPD') and rsDPD.RecordCount gt 0 and rsDPD.Icodigo neq '' >
                <cfset Icodigo = #rsDPD.Icodigo#>
				<cfset Idescripcion =#rsDPD.Idescripcion#>
            <cfelse>
                <cfset Icodigo = ''> 
                <cfset Idescripcion =''>               
            </cfif>
            <cf_conlis
            Campos="Icodigo,Idescripcion"
            tabindex="6"
            Desplegables="S,S"
            Modificables="S,N"
            values="#Icodigo#,#Idescripcion#"
            Size="15,35"
            Title="Lista de Impuestos"
            Tabla="Impuestos c"
            Columnas="Icodigo,Idescripcion"
            Filtro="Ecodigo = #Session.Ecodigo# order by Idescripcion"
            Desplegar="Icodigo,Idescripcion"
            Etiquetas="C&oacute;digo,Descripci&oacute;n"
            filtrar_por="Icodigo,Idescripcion"
            Formatos="S,S"
            form="form1"
            Align="left,left"
            Asignar="Icodigo,Idescripcion"
            Asignarformatos="S,S"
            />
			<!---input type="hidden" name="Icodigo" value="<cfif (lcase(mododet) eq 'cambio')>#rsDPD.Icodigo#</cfif>"
			<input type="hidden" name="Idescripcion" value="<cfif (lcase(mododet) eq 'cambio')>#HTMLEditFormat(rsDPD.Idescripcion)#</cfif>">--->
			<iframe id="frImpuesto" name="frImpuesto" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="no" src="about:blank" class="DocsFrame"></iframe>
		</td>
		<!--- Peso del ítem --->
		<td nowrap><strong>Peso (kg)&nbsp;:&nbsp;</strong></td>				
		<td>
			<input name='DPDpeso' tabindex="2"
				type='text'
				size='20'
				maxlength='18'
				style='text-align: right'
				onFocus='this.value=qf(this); this.select();'
				onBlur='javascript: fm(this,2);'
				onKeyUp='if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' value="<cfif (lcase(mododet) eq 'cambio')>#LSCurrencyFormat(rsDPD.DPDpeso,'none')#<cfelse>0.00</cfif>">
		</td>
    </tr>
</table>
<!--- Montos declarados de la línea --->
<fieldset>
	<legend>Montos Declarados</legend>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<!--- Costos declarados --->
				<td width="1%" nowrap><strong>Costos&nbsp;:&nbsp;</strong></td>
				<td>
					<input name='DPcostodec' tabindex="2"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' 
						value="<cfif (lcase(mododet) eq 'cambio')>#LSCurrencyFormat(rsDPD.DPcostodec,'none')#<cfelse>0.00</cfif>">
				</td>
				<!--- Seguros declarados --->
				<td width="1%" nowrap><strong>Seguros&nbsp;:&nbsp;</strong></td>
				<td>
					<input name='DPsegurodec' tabindex="2"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' 
						value="<cfif (lcase(mododet) eq 'cambio')>#LSCurrencyFormat(rsDPD.DPsegurodec,'none')#<cfelse>0.00</cfif>">
				</td>
				<!--- Fletes declarados --->
				<td width="1%" nowrap><strong>Fletes&nbsp;:&nbsp;</strong></td>
				<td>
					<input name='DPfletedec' tabindex="2"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' 
						value="<cfif (lcase(mododet) eq 'cambio')>#LSCurrencyFormat(rsDPD.DPfletedec,'none')#<cfelse>0.00</cfif>">
				</td>
				<!--- Tipo de seguro de la línea --->
				<td width="1%" nowrap><strong>Tipo de Seguro&nbsp;:&nbsp;</strong></td>
				<td>
					<select name="DCMSid" tabindex="2" onChange="javascript:cambiarTS();">
						<option value="">--Ninguno--</option>
						<cfloop query="rsCMSeguros">
							<option value="#CMSid#" <cfif ((lcase(mododet) eq 'cambio') and rsDPD.CMSid eq CMSid) or ((lcase(mododet) neq 'cambio') and rsEPD.CMSid eq CMSid)>selected</cfif>>#CMSdescripcion#</option>
						</cfloop>
					</select>
				</td>
			  </tr>
			</table>
		</td>
		<!--- Seguro propio de la línea --->
		<td width="1%">
			<table width="1%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
			  <tr>
				<td width="1%" nowrap><strong>&nbsp;Seguro Propio&nbsp;:&nbsp;</strong></td>
				<td nowrap>
					&nbsp;<input name="DPseguropropio" type="text" readonly="true" tabindex="2" value="<cfif (lcase(mododet) eq 'cambio')>#LSCurrencyFormat(rsDPD.DPseguropropio,'none')#<cfelse>0.00</cfif>">
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	</table>
</fieldset>
</cfoutput>
<!---  Iframe para el conlis de tipos de Solicitud ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<script language='javascript' type='text/JavaScript' >
	<!--//
	//Función para actualizar el monto total de acuerdo con el precio unitario y la cantidad
	function actualizarMonto(){
		f = document.form1;
		cantidad = f.DPDcantidad;
		crestante = f.hcr;
		mrestante = f.mcr;
		mfobreal = f.DPDmontofobreal;
		mcostou = f.DPDcostoudescoc;
		if (parseInt(cantidad.value)==parseInt(crestante.value))
			mfobreal.value = fm(parseFloat(mrestante.value),2);
		else if (parseInt(crestante.value) > 0)			
			mfobreal.value = fm(parseFloat(mcostou.value) * parseInt(cantidad.value),2);
		else
			mfobreal.value = "0.00";
	}
	<cfif (lcase(mododet) neq 'cambio')>
	/*Función para ver las líneas disponibles de un tracking*/
	function VerLineasTracking(){
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		window.open("ConlisLineasTracking.cfm?ETidtracking="+document.form1.ETidtracking_move.value, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	//Función para cambiar la cantidad restante
	function cambiarUnidad(unidad){
		var var_c = document.getElementById("unidad");
		var_c.innerHTML = '&nbsp;(' + unidad +')';
	}
	//Función para cambiar la cantidad restante
	function cambiarCantidadRestante(cantidadrestante){
		var var_c = document.getElementById("cantidadrestante");
		var_c.innerHTML = '&nbsp;(' + cantidadrestante +')';
		document.form1.hcr.value = cantidadrestante;
	}
	//Función para cambiar la cantidad restante
	function cambiarMontoRestante(montorestante){
		var var_c = document.getElementById("montorestante");
		var_c.innerHTML = '&nbsp;(' + fm(parseFloat(montorestante),2) +')';
		document.form1.mcr.value = montorestante;
	}
	</cfif>
	//Función para cambiar el impuesto de acuerdo con el Código Aduanal y el País
	function cambiarImpuesto(caid,pais){
		if (caid&&pais) {
			window.impuesto = document.form1.Icodigo;
			window.idescripcion = document.form1.Idescripcion;
			document.all['frImpuesto'].src = 'queryImpuestosCodigoAduanal.cfm?CAid='+caid+'&Pais='+pais;
		}
	}
	//Función para cambiar el Código Aduanal
	function cambiarCAid(caid){
		if (caid) {
			f = document.form1;
			c = f.CAid;
			for (i=1;i<c.length;i++){
				if (c.options[i].value==caid)
					c.options[i].selected = true;
				else
					c.options[i].selected = false;
			}
			cambiarImpuesto(document.form1.CAid.value,document.form1.DPDpaisori.value);
		}
	}
	//Función para cambiar el País
	function cambiarDPDpaisori(ppais){
		if (ppais) {
			f = document.form1;
			c = f.DPDpaisori;
			for (i=1;i<c.length;i++){
				if (c.options[i].value==ppais)
					c.options[i].selected = true;
				else
					c.options[i].selected = false;
			}
			cambiarImpuesto(document.form1.CAid.value,document.form1.DPDpaisori.value);
		}
	}
	<cfif (lcase(mododet) eq 'cambio')>
	function habilitarDeshabilitarInicial(){
		f = document.form1;
		a = f.CAid;
		b = f.DPDpaisori;
		c = f.DPDpeso;
		d = f.DPDcantidad;
		g = f.DPDmontofobreal;
		h = f.DPcostodec;
		i = f.DPfletedec;
		j = f.DPsegurodec;
		k = f.DPseguropropio;
		l = f.DPDcantreclamo;
		a.disabled = false;
		b.disabled = false;
		c.disabled = false;
		d.disabled = false;
		g.disabled = true;
		h.disabled = false;
		i.disabled = false;
		j.disabled = false;
		k.disabled = false;
		l.disabled = false;
	}
	habilitarDeshabilitarInicial();
	</cfif>
	
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisCodAduanal() {
		popUpWindow("../operacion/conlisCodigosAduanales.cfm?formulario=form1",250,150,550,400);		
	}
	
	function traerCodAduanal(value){
	  if (value!=''){		     
	   document.getElementById("fr").src = '../operacion/traerCodAduanal.cfm?formulario=form1&CAcodigo='+value;
	  }
	  else{
	   document.form1.CAid.value = '';
	   document.form1.CAcodigo.value = '';
	   document.form1.CAdescripcion.value = '';
	  }
	 }	
	 
	 function funcImpuesto(){
	 	cambiarImpuesto(document.form1.CAid.value,document.form1.DPDpaisori.value);
	 }
	//-->
</script>