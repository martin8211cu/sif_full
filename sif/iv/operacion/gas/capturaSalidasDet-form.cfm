
<cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
	<cfset form.Ocodigo=url.Ocodigo>
</cfif>
<cfif isdefined('url.pista') and not isdefined('form.pista')>
	<cfset form.pista=url.pista>
</cfif>
<cfif isdefined('url.turno') and not isdefined('form.turno')>
	<cfset form.turno=url.turno>
</cfif>
<cfif isdefined('url.SPfecha') and not isdefined('form.SPfecha')>
	<cfset form.SPfecha=url.SPfecha>
</cfif>
<cfif isdefined('url.ID_salprod') and not isdefined('form.ID_salprod')>
	<cfset form.ID_salprod=url.ID_salprod>
</cfif>

<cfif isdefined('form.Ocodigo') and form.Ocodigo NEQ '' and isdefined('form.pista') and form.pista NEQ '' and isdefined('form.turno') and form.turno NEQ ''>
	<cfif isdefined('url.imprimir')>
		<!--- Consulta para el pintado del encabezado solo cuando se ejecuta la opcion de impresion --->
		<cfquery name="rsform" datasource="#session.DSN#">
			Select esp.ID_salprod,esp.SPestado,SPfecha,o.Ocodigo, Oficodigo, Odescripcion,tof.Turno_id,Tdescripcion,HI_turno,HF_turno,p.Pista_id,Descripcion_pista,esp.ts_rversion
			from Oficinas o
				inner join Turnoxofi tof
					on o.Ocodigo=tof.Ocodigo
						and o.Ecodigo=tof.Ecodigo
			
				inner join Turnos tu
					on tof.Turno_id=tu.Turno_id
						and tof.Ecodigo=tu.Ecodigo
			
				inner join Pistas p
					on o.Ocodigo=p.Ocodigo
						and o.Ecodigo=p.Ecodigo
			
				left outer join ESalidaProd esp
					on o.Ecodigo=esp.Ecodigo
						and o.Ocodigo=esp.Ocodigo
						and p.Pista_id=esp.Pista_id
						and tu.Turno_id=esp.Turno_id
						<cfif isdefined('form.ID_salprod') and form.ID_salprod NEQ ''>
							and esp.ID_salprod=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_salprod#">
						</cfif>					
						<cfif isdefined("form.fSPfecha") and len(form.fSPfecha)>
							and esp.SPfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fSPfecha#">
						<cfelse>
							and esp.SPfecha <= <cf_dbfunction name="now">
						</cfif> 
			where o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and o.Ocodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">		
				and p.Pista_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pista#">					
				and tof.Turno_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.turno#">					
				and Testado=1
				and Pestado=1
		</cfquery>
	</cfif>
	
	<cfquery name="rsArtClas" datasource="#session.DSN#">
		select  dsp.ID_dsalprod, alm.Aid as idAlmacen,alm.Almcodigo,(coalesce(Unidades_vendidas,0) + coalesce(Unidades_despachadas,0) ) as totalClas
			, coalesce(Lectura_control,0) as Lectura_control,coalesce(Unidades_vendidas,0) as Unidades_vendidas,coalesce(Unidades_despachadas,0) as Unidades_despachadas
			, coalesce(Unidades_calibracion,0) as Unidades_calibracion,axp.Aid,Adescripcion, c.Ccodigo,Cdescripcion,
			Precio, Ingreso, Descuento, DSPimpuesto

		from Artxpista axp
			inner join Pistas p
				on p.Ecodigo=axp.Ecodigo
					and p.Pista_id=axp.Pista_id
			inner join Articulos a
				on axp.Ecodigo=a.Ecodigo
					and axp.Aid=a.Aid
			inner join Clasificaciones c
				on c.Ecodigo=a.Ecodigo
					and c.Ccodigo=a.Ccodigo
			inner join Almacen alm
				on axp.Ecodigo=alm.Ecodigo
					and axp.Alm_Aid=alm.Aid					
			left outer join ESalidaProd sp
				on sp.Ecodigo=axp.Ecodigo
					and sp.Pista_id=p.Pista_id
					and sp.Ocodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					and sp.Turno_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.turno#">
					<cfif isdefined("form.fSPfecha") and len(form.fSPfecha)>
						and sp.SPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedatetime(form.fSPfecha)#">
					</cfif>								
					<cfif isdefined('form.ID_salprod') and form.ID_salprod NEQ ''>
						and sp.ID_salprod=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_salprod#">
					</cfif>							
			left outer join DSalidaProd dsp
				on dsp.Ecodigo=sp.Ecodigo
					and dsp.ID_salprod=sp.ID_salprod
					and dsp.Aid=a.Aid
					and dsp.Alm_ai=alm.Aid							
		where axp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and axp.Pista_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pista#">
			and axp.Estado=1

		order by Cdescripcion,Adescripcion
	</cfquery>
</cfif>

<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
.style2 {
	font-size: 24px;
	font-weight: bold;
}
.style3 {
	font-size: 9px;
	font-family: Arial, Helvetica, sans-serif;
}
-->
</style>

<script language="javascript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}
	function closePopUp(){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
			popUpWin=null;
		}
	}
	function cargaSubTotVentas(valor,num){
		eval("document.form_Salidas.totalClasVentas_" + num + ".value = " + valor);
		fm(document.form_Salidas['totalClasVentas_' + num],2 )
	}
	function cargaSubTotConsig(valor,num){
		eval("document.form_Salidas.totalClasConsig_" + num + ".value = " + valor);	
		fm(document.form_Salidas['totalClasConsig_' + num],2 )
	}
	function cargaSubTotCalibr(valor,num){
		eval("document.form_Salidas.totalClasCalibr_" + num + ".value = " + valor);	
		fm(document.form_Salidas['totalClasCalibr_' + num],2 )
	}	
	function cargaSubTotal(valor,num){
		eval("document.form_Salidas.totalClasTotal_" + num + ".value = " + valor);	
		fm(document.form_Salidas['totalClasTotal_' + num],2 )
	}		
//*********************
	function cargaTotBruto(valor,num){
		eval("document.form_Salidas.totalClasBruto_" + num + ".value = " + valor);
		fm(document.form_Salidas['totalClasBruto_' + num],2 )
	}
	function cargaTotDescuento(valor,num){
		eval("document.form_Salidas.totalClasDesc_" + num + ".value = " + valor);
		fm(document.form_Salidas['totalClasDesc_' + num],2 )
	}
	function cargaTotImpuesto(valor,num){
		eval("document.form_Salidas.DSPimpuestoTotal_" + num + ".value = " + valor);
		fm(document.form_Salidas['DSPimpuestoTotal_' + num],2 )
	}
	function cargaSubTotalMontos(valor,num){
		eval("document.form_Salidas.totalClasTotalMon_" + num + ".value = " + valor);	
		fm(document.form_Salidas['totalClasTotalMon_' + num],2 )
	}		
	function calculaPrecio(valor,num,opc){
		//	opc 1	-	evento en el Monto/Bruto
		//	opc 2	-	evento en Utilidades/Ventas
		var unidVend = 0;
		var Pbruto = 0;
		if(valor != ''){
			valor = qf(valor);
			if(ESNUMERO(valor)){
				unidVend = qf(document.form_Salidas['Unidades_vendidas_' + num].value);
				Pbruto = qf(document.form_Salidas['bruto_' + num].value);				
				if(unidVend > 0){
					if(opc == 1){
						eval("document.form_Salidas.precio_" + num + ".value = " + valor + " / unidVend");
					}else{
						if(opc == 2){
							eval("document.form_Salidas.precio_" + num + ".value = Pbruto / " + valor);					
						}
					}
					
					fm(document.form_Salidas['precio_'+num],2);
				}else{
					eval("document.form_Salidas.precio_" + num + ".value = '0.00'");					
				}
			}else{
				document.form_Salidas['precio_'+num].value = '0.00';
			}
		}else{
			document.form_Salidas['precio_'+num].value = '0.00';		
		}
	}
	function calculaTotal(valor, num, opc, codClas, numClas){
		//	opc 1	-	evento en el Monto/Bruto
		//	opc 2	-	evento en el Monto/Desc
		//	opc 3	-	evento en el Monto/Impuesto
		var valorTMP = document.form_Salidas['corte_'+codClas].value;
		var arr = valorTMP.split(',');
		var subTotal = 0;		
		
		if(valor != ''){
			valor = qf(valor);
			if(ESNUMERO(valor)){
				valor = parseFloat(qf(valor));
				if(opc == 1){
					document.form_Salidas['totalMonto_'+num].value = valor + parseFloat(qf(document.form_Salidas['DSPimpuesto_'+num].value)) - parseFloat(qf(document.form_Salidas['desc_'+num].value));			
				}else{
					if(opc == 2){
						document.form_Salidas['totalMonto_'+num].value = parseFloat(qf(document.form_Salidas['bruto_'+num].value)) + parseFloat(qf(document.form_Salidas['DSPimpuesto_'+num].value)) - valor ;
					}
					else{
						if(opc == 3){
							document.form_Salidas['totalMonto_'+num].value = parseFloat(qf(document.form_Salidas['bruto_'+num].value)) + valor - parseFloat(qf(document.form_Salidas['desc_'+num].value)) ;
						}
					}
				}
				document.form_Salidas['precio_'+num].value = fm(document.form_Salidas['precio_'+num].value,2);
				document.form_Salidas['totalMonto_'+num].value = fm(document.form_Salidas['totalMonto_'+num].value,2)
			}else{
				document.form_Salidas['totalMonto_'+num].value = '0.00';
				document.form_Salidas['totalMonto_'+num].value = fm(document.form_Salidas['totalMonto_'+num].value,2)
			}
		}else{
			document.form_Salidas['totalMonto_'+num].value = '0.00';
			document.form_Salidas['totalMonto_'+num].value = fm(document.form_Salidas['totalMonto_'+num].value,2)
		}			

		for(var i=0;i<arr.length;i++){
			if(document.form_Salidas['totalMonto_'+arr[i]].value != ''){
				if(ESNUMERO(qf(document.form_Salidas['totalMonto_'+arr[i]].value)))
					subTotal = subTotal + parseFloat(qf(document.form_Salidas['totalMonto_'+arr[i]].value));							
			}
		}
		document.form_Salidas['totalClasTotalMon_'+numClas].value = subTotal;
		document.form_Salidas['totalClasTotalMon_'+numClas].value = fm(document.form_Salidas['totalClasTotalMon_'+numClas].value,2)
	}
	function sumaTotClas(codClas, opc, numClas){
		/* Suma de totales por corte de clasificaciones
			opc
				1 = Unidades ventas
				2 = Unidades Consig
				3 = Unidades Calibr
				4 = Monto Bruto
				5 = Monto Desc
				6 = Monto Impuesto
		*/
		var valor = document.form_Salidas['corte_'+codClas].value;
		var arr = valor.split(',');
		var subTotal = 0;
		
		switch ( opc ) {
			case 1 :{
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['Unidades_vendidas_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['Unidades_vendidas_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['Unidades_vendidas_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalClasVentas_'+numClas].value = subTotal;
						fm(document.form_Salidas['totalClasVentas_'+numClas],2);
						break;
					}
			case 2 :{
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['Unidades_despachadas_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['Unidades_despachadas_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['Unidades_despachadas_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalClasConsig_'+numClas].value = subTotal;
						fm(document.form_Salidas['totalClasConsig_'+numClas],2);
						break;
					}
			case 3 :{
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['Unidades_calibracion_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['Unidades_calibracion_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['Unidades_calibracion_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalClasCalibr_'+numClas].value = subTotal;
						fm(document.form_Salidas['totalClasCalibr_'+numClas],2);
						break;
					}
			case 4 :{
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['bruto_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['bruto_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['bruto_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalClasBruto_'+numClas].value = subTotal;
						fm(document.form_Salidas['totalClasBruto_'+numClas],2);
						break;
					}
			case 5 :{
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['desc_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['desc_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['desc_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalClasDesc_'+numClas].value = subTotal;				
						fm(document.form_Salidas['totalClasDesc_'+numClas],2);
						break;
					}										
			case 6 :{
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['DSPimpuesto_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['DSPimpuesto_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['DSPimpuesto_'+arr[i]].value));							
							}
						}
						document.form_Salidas['DSPimpuestoTotal_'+numClas].value = subTotal;
						fm(document.form_Salidas['DSPimpuestoTotal_'+numClas],2);
						break;
					}										

		} 
	}
	function cargaSubTotalesXclas(regs,clas){
		document.form_Salidas['corte_'+clas].value = regs;
	}
	function calcuTotal(num, codClas, numClas){
		var valor = document.form_Salidas['corte_'+codClas].value;
		var arr = valor.split(',');
		var subTotal = 0;
			
		var uniVend = new Number();
		var uniDesp = new Number();

		if(document.form_Salidas['Unidades_vendidas_'+num].value != '')
			uniVend = parseFloat(qf(document.form_Salidas['Unidades_vendidas_'+num].value));
		else
			uniVend = 0;
			
		if(document.form_Salidas['Unidades_despachadas_'+num].value != '')
			uniDesp = parseFloat(qf(document.form_Salidas['Unidades_despachadas_'+num].value));
		else
			uniDesp = 0;

		var total = new Number();
			total = uniVend	+ uniDesp;
		
		document.form_Salidas['totalUni_'+num].value = total;
		fm(document.form_Salidas['totalUni_'+num],2);
		for(var i=0;i<arr.length;i++){
			if(document.form_Salidas['totalUni_'+arr[i]].value != ''){
				if(ESNUMERO(qf(document.form_Salidas['totalUni_'+arr[i]].value)))
					subTotal = subTotal + parseFloat(qf(document.form_Salidas['totalUni_'+arr[i]].value));							
			}
		} 
		document.form_Salidas['totalClasTotal_'+numClas].value = subTotal;
		fm(document.form_Salidas['totalClasTotal_'+numClas],2);
		
	} 	
	function doConlisVentasVendedores(par){
		if(par != ''){
			popUpWindow("/cfmx/sif/iv/operacion/gas/ventasXvendedores.cfm?ID_dsalprod=" + par,250,200,650,400);
		}else{
			alert("Primero debe guardar una cantidad de unidades de salida mayor que cero antes de acceder esta opcion");			
		}
		
	}
</script>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<form name="form_Salidas" method="post" action="capturaSalidas-sql.cfm" onSubmit="javascript: return valida();">				
	<cfif isdefined('url.imprimir')>
		<cfoutput>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
			  <tr>
				<td colspan="6"><span class="style2">Detalle de Salidas </span></td>
			  </tr>
			  <tr bgcolor="##CCCCCC">
				<td width="3%">&nbsp;</td>
				<td width="3%">&nbsp;</td>
				<td width="15%">&nbsp;</td>
				<td width="25%">&nbsp;</td>
				<td width="18%">&nbsp;</td>
				<td width="36%">&nbsp;</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td colspan="5"><strong>Salidas en Estaciones de Servicio </strong></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="right"><strong>Estaci&oacute;n:</strong></td>
				<td><cfif isdefined('rsform') and rsform.recordCount GT 0>#rsform.Odescripcion#</cfif></td>
				<td align="right"><strong>Turno:</strong></td>
				<td nowrap>
					<cfif isdefined('rsform') and rsform.recordCount GT 0>
						#rsform.Tdescripcion#&nbsp;&nbsp;(#TimeFormat(rsform.HI_turno, "hh:mm:sstt")#--#TimeFormat(rsform.HF_turno, "hh:mm:sstt")#)
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="right"><strong>Fecha:</strong></td>
				<td>
					<cfif isdefined('rsForm.SPfecha') and rsForm.SPfecha NEQ ''>
						#DateFormat(rsform.SPfecha, "dd/mmm/yyyy")#
					<cfelse>
						#DateFormat(Now(), "dd/mmm/yyyy")#
					</cfif>				
				</td>
				<td align="right"><strong>Pista:</strong></td>
				<td nowrap>
					<cfif isdefined('rsform') and rsform.recordCount GT 0>
						#rsform.Descripcion_pista#	
					</cfif>
				</td>
			  </tr>	 
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>		   
			</table>
		</cfoutput>			
	</cfif>

    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
      <td width="50" rowspan="2" valign="middle" bgcolor="#000000"><span class="style1">Producto</span></td>
      <td colspan="6" align="center" bgcolor="#ACACAC"><strong>Unidades</strong></td>
      <td colspan="5" align="center" bgcolor="#EEEEEE"><strong>Monto</strong></td>
    </tr>
    <tr>
      <td width="7%" align="right" bgcolor="#ACACAC"><strong>Control</strong></td>
      <td width="8%" align="right" bgcolor="#ACACAC"><strong>Ventas</strong></td>
      <td width="9%" align="right" bgcolor="#ACACAC"><strong>Manejo</strong></td>
      <td width="10%" align="right" bgcolor="#ACACAC"><strong>Calibr.</strong></td>
      <td width="9%" align="right" bgcolor="#ACACAC"><cfif not isdefined('url.imprimir')><strong>Vendedor</strong><cfelse>&nbsp;</cfif></td>
      <td width="9%" align="right" bgcolor="#ACACAC"><strong>Total</strong></td>
      <td width="10%" align="right" bgcolor="#EEEEEE"><strong>Precio</strong></td>
      <td width="8%" align="right" bgcolor="#EEEEEE"><strong>Bruto</strong></td>
    </tr>

	<cfif isdefined('rsArtClas') and rsArtClas.recordCount GT 0>
		<cfset LvarListaNon = -1>
		<cfset clas = ''>		
		<cfset numRow = 1>
		<cfset numRegs = ''>		
		<cfset totVentas = 0>
		<cfset totConsig = 0>			
		<cfset totCalibr = 0>			
		<cfset totUnidades = 0>

		<cfset totBruto = 0 >
		<cfset totDescuento = 0 >
		<cfset totDSPimpuesto = 0 >
		<cfset totalMontos = 0>

		<cfoutput query="rsArtClas">
			<cfset LvarListaNon = (CurrentRow MOD 2)>			
			<cfif clas NEQ rsArtClas.Ccodigo>
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				  	<td colspan="2"><strong>#rsArtClas.Cdescripcion#</strong></td>
				  	<td  align="right">				  				  
						<cfif isdefined('numRegs') and numRegs NEQ ''>
							<script language="javascript" type="text/javascript">
								cargaSubTotalesXclas('#numRegs#',#clas#);	
							</script>
						</cfif>
						<input type="hidden" name="corte_#rsArtClas.Ccodigo#" value="">
						<cfset numRegs = ''>
						<input 
								type="text" 
								readonly="true"   tabindex="-1"
								name="totalClasVentas_#CurrentRow#" 
								size="8"  
								maxlength="8" 
								style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
								onBlur="javascript:fm(this,2);"  
								onFocus="javascript:this.value=qf(this); this.select();"  
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								value="0.00">				  
					</td>				  
				  	<td  align="right">
					  <input 
							type="text" 
							readonly="true"   tabindex="-1"
							name="totalClasConsig_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00">				  
					</td>
				  	<td  align="right">
						<input 
								type="text" 
								readonly="true"   tabindex="-1"
								name="totalClasCalibr_#CurrentRow#" 
								size="8" 
								maxlength="8" 
								style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
								onBlur="javascript:fm(this,2);"  
								onFocus="javascript:this.value=qf(this); this.select();"  
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								value="0.00">				  
					</td>
				  	<td align="right">&nbsp;</td>
				  	<td align="right">
					  <input
							type="text" 
							readonly="true"   tabindex="-1"
							name="totalClasTotal_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00">				  
					</td>
				  	<td>&nbsp;</td>

<!--- AQUI SON LOS CALCULOS --->
				  	<td align="right">
					  <input 
							type="text" 
							readonly="true"   tabindex="-1"
							name="totalClasBruto_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00">				  
							
						<input type="hidden" name="totalClasDesc_#CurrentRow#" value="0">
						<input type="hidden" name="DSPimpuestoTotal_#CurrentRow#" value="0">
						<input type="hidden" name="totalClasTotalMon_#CurrentRow#" value="0">	
					</td>
				</tr>
				
<!--- Y HASTA AQUI SON LOS CALCULOS --->				
							
				<script language="javascript" type="text/javascript">
						cargaSubTotVentas(#totVentas#,#numRow#);
						cargaSubTotConsig(#totConsig#,#numRow#);					
						cargaSubTotCalibr(#totCalibr#,#numRow#);					
						cargaSubTotal(#totUnidades#,#numRow#);
						cargaTotBruto(#totBruto#,#numRow#);
						cargaTotDescuento(#totDescuento#,#numRow#);
						cargaTotImpuesto(#totDSPimpuesto#,#numRow#);
						cargaSubTotalMontos(#totalMontos#, #numRow#);
				</script>
				<cfset totVentas = 0>
				<cfset totConsig = 0>			
				<cfset totCalibr = 0>			
				<cfset totUnidades = 0>
				<cfset totBruto = 0 >
				<cfset totDescuento = 0 >
				<cfset totDSPimpuesto = 0 >
				<cfset totalMontos = 0 >

				<cfset numRow = CurrentRow>				
				<cfset clas = rsArtClas.Ccodigo>
			</cfif>

			<cfif numRegs NEQ ''>
				<cfset numRegs = numRegs & ",#CurrentRow#">			
			<cfelse>
				<cfset numRegs = "#CurrentRow#">	
			</cfif>
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
			  	<td>
					#rsArtClas.Adescripcion# <span class="style3">(#trim(rsArtClas.Almcodigo)#)</span>				  <input type="hidden" name="articulo_#CurrentRow#" value="#rsArtClas.Aid#">
					<input type="hidden" name="almacen_#CurrentRow#" value="#rsArtClas.idAlmacen#">			  
				</td>
			  	<td align="right">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsArtClas.Lectura_control, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="Lectura_control_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="#LSCurrencyFormat(rsArtClas.Lectura_control, 'none')#">				  
				  </cfif>					
				</td>
				<cfif rsArtClas.Unidades_vendidas NEQ '' and rsArtClas.Unidades_vendidas GT 0>			
					<cfset totVentas = totVentas + rsArtClas.Unidades_vendidas>
				</cfif>
				<td  align="right">
					<cfif isdefined('url.imprimir')>
						#LSCurrencyFormat(rsArtClas.Unidades_vendidas, 'none')#
					<cfelse>
						<input 
							type="text" 
							name="Unidades_vendidas_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calcuTotal(#CurrentRow#,'#rsArtClas.Ccodigo#',#numRow#); sumaTotClas('#rsArtClas.Ccodigo#',1,#numRow#); calculaPrecio(this.value,#CurrentRow#,2);}"
							value="#LSCurrencyFormat(rsArtClas.Unidades_vendidas, 'none')#">
					</cfif>
				</td>
				  <cfif rsArtClas.Unidades_despachadas NEQ '' and rsArtClas.Unidades_despachadas GT 0>
					<cfset totConsig = totConsig + rsArtClas.Unidades_despachadas>
				  </cfif>
			  	<td align="right">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsArtClas.Unidades_despachadas, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="Unidades_despachadas_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calcuTotal(#CurrentRow#,'#rsArtClas.Ccodigo#',#numRow#); sumaTotClas('#rsArtClas.Ccodigo#',2,#numRow#);}"
							value="#LSCurrencyFormat(rsArtClas.Unidades_despachadas, 'none')#">			  
				  </cfif>
				</td>
				<cfif rsArtClas.Unidades_calibracion NEQ '' and rsArtClas.Unidades_calibracion GT 0>
					<cfset totCalibr = totCalibr + rsArtClas.Unidades_calibracion>
				</cfif>
			  	<td align="right">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsArtClas.Unidades_calibracion, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="Unidades_calibracion_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} sumaTotClas('#rsArtClas.Ccodigo#',3,#numRow#);}"
							value="#LSCurrencyFormat(rsArtClas.Unidades_calibracion, 'none')#">
				  </cfif>						
				</td>
			  	<td align="center">
				  <cfif not isdefined('url.imprimir')>
					  <a href="##" tabindex="-1">
							<img id="VendImagen" src="/cfmx/sif/imagenes/Description.gif" alt="Cantidad de unidades vendidas por Vendedor" name="VendImagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisVentasVendedores('#rsArtClas.ID_dsalprod#');">
					  </a>				  
				  <cfelse>
					&nbsp;			  
				  </cfif>							
			  	</td>
				<cfif rsArtClas.totalClas NEQ '' and rsArtClas.totalClas GT 0>
					<cfset totUnidades = totUnidades + rsArtClas.totalClas>
				</cfif>			  
			  	<td align="right">
				  <cfif isdefined('url.imprimir')>
				    #LSCurrencyFormat(rsArtClas.totalClas, 'none')#
			        <cfelse>
					  <input 
							type="text" 
							class="cajasinbordeb"
							readonly="true"   tabindex="-1"
							name="totalUni_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="#LSCurrencyFormat(rsArtClas.totalClas, 'none')#">		
				  </cfif>							
				</td>
			  	<td align="right">
				  <input 
						type="text" 
						class="cajasinbordeb"
						readonly="true"   tabindex="-1"
						name="precio_#CurrentRow#" 
						size="8" 
						maxlength="8" 
						style="text-align: right;" 
						onBlur="javascript:fm(this,2);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						value="#LSCurrencyFormat(rsArtClas.precio, 'none')#">
			  	</td>						  

			  	<cfset LvarTotalLinea = 0 >
			  	<td align="right">
				  <cfif rsArtClas.Ingreso NEQ '' and rsArtClas.Ingreso GT 0>			
					<cfset totBruto = totBruto + rsArtClas.Ingreso>
					<cfset totalMontos = totalMontos + rsArtClas.Ingreso >
					<cfset LvarTotalLinea = LvarTotalLinea + rsArtClas.Ingreso >
				  </cfif>
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsArtClas.Ingreso, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="bruto_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2); calculaPrecio(this.value,#CurrentRow#,1);calculaTotal(this.value,#CurrentRow#,1,'#rsArtClas.Ccodigo#',#numRow#); sumaTotClas('#rsArtClas.Ccodigo#',4,#numRow#);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}} "
							value="#LSCurrencyFormat(rsArtClas.ingreso, 'none')#">				  
				  </cfif>		
				</td>
			
				<cfif rsArtClas.Descuento NEQ '' and rsArtClas.Descuento GT 0>			
					<cfset totDescuento = totDescuento + rsArtClas.Descuento >
					<cfset totalMontos = totalMontos - rsArtClas.Descuento >
					<cfset LvarTotalLinea = LvarTotalLinea - rsArtClas.Descuento >
				</cfif>
				<input type="hidden" name="desc_#CurrentRow#" value="#LSCurrencyFormat(rsArtClas.descuento, 'none')#">
				<cfif rsArtClas.DSPimpuesto NEQ '' and rsArtClas.DSPimpuesto GT 0>			
					<cfset totDSPimpuesto = totDSPimpuesto + rsArtClas.DSPimpuesto >
					<cfset totalMontos = totalMontos + rsArtClas.DSPimpuesto >
					<cfset LvarTotalLinea = LvarTotalLinea + rsArtClas.DSPimpuesto >
				</cfif>
				<input type="hidden" name="DSPimpuesto_#CurrentRow#" value="#LSCurrencyFormat(rsArtClas.DSPimpuesto, 'none')#">							
				<cfset total = rsArtClas.DSPimpuesto >
				<input type="hidden" name="totalMonto_#CurrentRow#" value="#LSCurrencyFormat(LvarTotalLinea, 'none')#">							  
			</tr>			

		</cfoutput>
		<cfif isdefined('numRegs') and numRegs NEQ ''>
			<script language="javascript" type="text/javascript">
				<cfoutput>
					cargaSubTotalesXclas('#numRegs#',#clas#);
					cargaSubTotVentas(#totVentas#,#numRow#);
					cargaSubTotConsig(#totConsig#,#numRow#);					
					cargaSubTotCalibr(#totCalibr#,#numRow#);					
					cargaSubTotal(#totUnidades#,#numRow#);
					
					cargaTotBruto(#totBruto#,#numRow#);
					cargaTotDescuento(#totDescuento#,#numRow#);
					cargaTotImpuesto(#totUnidades#,#numRow#);
					cargaSubTotalMontos(#totalMontos#, #numRow#);
				</cfoutput>
			</script>
		</cfif>		 		
		<cfif isdefined('rsArtClas') and rsArtClas.recordCount GT 0>
			<input type="hidden" name="cantReg" value="<cfoutput>#rsArtClas.recordCount#</cfoutput>">
		</cfif>
	</cfif>
  </table>
</form>  