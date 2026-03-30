<cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
	<cfset form.Ocodigo=url.Ocodigo>
</cfif>
<cfif isdefined('url.EMAfecha') and not isdefined('form.EMAfecha')>
	<cfset form.EMAfecha=url.EMAfecha>
</cfif>
<cfif isdefined('url.EMAid') and not isdefined('form.EMAid')>
	<cfset form.EMAid=url.EMAid>
</cfif>

<cfif isdefined('form.EMAid') and form.EMAid NEQ ''>
	<cfif isdefined('url.imprimir')>
		<!--- Consulta para el pintado del encabezado solo cuando se ejecuta la opcion de impresion --->
		<cfquery name="rsform" datasource="#session.DSN#">
			Select ea.EMAid
				, ea.EMAfecha
				, ea.Ocodigo
				, o.Odescripcion
				, ea.EMAestado
				, case ea.EMAestado
					when 0 then 'En Proceso'
					when 10 then 'Aplicado'
				end EMAestadoDesc
				,ea.ts_rversion
			from EMAlmacen ea
				inner join Oficinas o
					on o.Ecodigo=ea.Ecodigo
						and o.Ocodigo=ea.Ocodigo
			
			where ea.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ea.EMAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMAid#">
		</cfquery>
	</cfif>

	<cfquery name="rsMovDep" datasource="#session.DSN#">
		Select 
			a.Aid
			, a.Adescripcion
			, a.Ucodigo
			, c.Ccodigo
			, c.Cdescripcion
			, coalesce(da.DMAinvIni,0) as DMAinvIni
			, coalesce(da.DMAcompra,0) as DMAcompra	
			, coalesce(da.DMAprecio,0) as DMAprecio
			, coalesce(da.DMAinvFin,0) as DMAinvFin
			, coalesce(da.DMAdevol,0) as DMAdevol
			, coalesce(da.DMAinvFisico,0) as DMAinvFisico
			, da.DMAdoc
			, da.DMAid
			, da.Aid as idAlmOri	
			
		from EMAlmacen ea
			inner join Oficinas o
				on o.Ecodigo=ea.Ecodigo
					and o.Ocodigo=ea.Ocodigo
		
			inner join DMAlmacen da
				on da.Ecodigo=o.Ecodigo
					and da.EMAid=ea.EMAid
		
			inner join Articulos a
				on a.Ecodigo=da.Ecodigo
					and a.Aid=da.Art_Aid
		
			inner join Clasificaciones c
				on c.Ecodigo=a.Ecodigo
					and c.Ccodigo = a.Ccodigo		
					
		where ea.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ea.EMAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMAid#">
		Order by Cdescripcion,Adescripcion,Ucodigo
	</cfquery>
	<cfif isdefined('rsMovDep') and rsMovDep.recordCount GT 0>
		<cfquery name="rsSalidas" datasource="#session.DSN#">
			Select sum(coalesce(ALMPcantidad,0)) as sumaCant, DMAid
			from ALMPistas
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DMAid in (#ValueList(rsMovDep.DMAid)#) 
			group by DMAid		
		</cfquery>
	</cfif>
</cfif>

<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
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
	function cargaSubTotalesXclas(regs,clas){
		document.form_Salidas['corte_'+clas].value = regs;
	}
	function cargaRegsXclas(regs){
		document.form_Salidas['corte_'+clas].value = regs;
	}	
	function cargaSubTotInvInicial(valor,num){
		eval("document.form_Salidas.subTotalInvInicial_" + num + ".value = " + valor);
		fm(document.form_Salidas['subTotalInvInicial_' + num],2 )
	}	
	function cargaSubTotCompra(valor,num){
		eval("document.form_Salidas.subTotalCompras_" + num + ".value = " + valor);	
		fm(document.form_Salidas['subTotalCompras_' + num],2 )
	}	
	function cargaSubTotInvFinal(valor,num){
		eval("document.form_Salidas.subTotalInvFinal_" + num + ".value = " + valor);	
		fm(document.form_Salidas['subTotalInvFinal_' + num],2 )
	}	
	function cargaSubTotDevol(valor,num){
		eval("document.form_Salidas.subTotalDevol_" + num + ".value = " + valor);
		fm(document.form_Salidas['subTotalDevol_' + num],2 )
	}	
	function cargaSubTotInvFisico(valor,num){
		eval("document.form_Salidas.subTotalInvFisico_" + num + ".value = " + valor);
		fm(document.form_Salidas['subTotalInvFisico_' + num],2 )
	}		
		
	function sumaTotClas(codClas, opc, numClas){
		var valor = document.form_Salidas['corte_'+codClas].value;
		var arr = valor.split(',');
		var subTotal = 0;
		
		switch ( opc ) {
			case 1 :{//Inventario Inicial
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['DMAinvIni_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['DMAinvIni_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['DMAinvIni_'+arr[i]].value));							
							}
						}
						document.form_Salidas['subTotalInvInicial_'+numClas].value = subTotal;
						fm(document.form_Salidas['subTotalInvInicial_'+numClas],2);
						break;
					}
			case 2 :{//Compras
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['DMAcompra_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['DMAcompra_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['DMAcompra_'+arr[i]].value));							
							}
						}
						document.form_Salidas['subTotalCompras_'+numClas].value = subTotal;
						fm(document.form_Salidas['subTotalCompras_'+numClas],2);
						break;
					}
			case 3 :{//Inventario Final
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['DMAinvFin_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['DMAinvFin_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['DMAinvFin_'+arr[i]].value));							
							}
						}
						document.form_Salidas['subTotalInvFinal_'+numClas].value = subTotal;
						fm(document.form_Salidas['subTotalInvFinal_'+numClas],2);
						break;
					}
			case 4 :{// Devoluciones
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['DMAdevol_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['DMAdevol_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['DMAdevol_'+arr[i]].value));							
							}
						}
						document.form_Salidas['subTotalDevol_'+numClas].value = subTotal;
						fm(document.form_Salidas['subTotalDevol_'+numClas],2);
						break;
					}
			case 5 :{// Inventario Fisico
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['DMAinvFisico_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['DMAinvFisico_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['DMAinvFisico_'+arr[i]].value));							
							}
						}
						document.form_Salidas['subTotalInvFisico_'+numClas].value = subTotal;				
						fm(document.form_Salidas['subTotalInvFisico_'+numClas],2);
						break;
					}																				
		} 
	}

	function calcuTotales(opc){
		var arr = document.form_Salidas['regsClas'].value.split(',');
		var subTotal = 0;
		
		switch ( opc ) {
			case 1 :{//Inventario Inicial
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['subTotalInvInicial_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['subTotalInvInicial_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['subTotalInvInicial_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalInvInicial'].value = subTotal;
						fm(document.form_Salidas['totalInvInicial'],2);
						break;
					}
			case 2 :{//Compras
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['subTotalCompras_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['subTotalCompras_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['subTotalCompras_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalCompras'].value = subTotal;
						fm(document.form_Salidas['totalCompras'],2);
						break;
					}	
			case 3 :{//Inventario Final
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['subTotalInvFinal_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['subTotalInvFinal_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['subTotalInvFinal_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalInvFinal'].value = subTotal;
						fm(document.form_Salidas['totalInvFinal'],2);
						break;
					}	
			case 4 :{//Devoluciones
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['subTotalDevol_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['subTotalDevol_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['subTotalDevol_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalDevol'].value = subTotal;
						fm(document.form_Salidas['totalDevol'],2);
						break;
					}													
			case 5 :{//Inventario Fisico
			 			for(var i=0;i<arr.length;i++){
							if(document.form_Salidas['subTotalInvFisico_'+arr[i]].value != ''){
								if(ESNUMERO(qf(document.form_Salidas['subTotalInvFisico_'+arr[i]].value)))
									subTotal = subTotal + parseFloat(qf(document.form_Salidas['subTotalInvFisico_'+arr[i]].value));							
							}
						}
						document.form_Salidas['totalInvFisico'].value = subTotal;
						fm(document.form_Salidas['totalInvFisico'],2);
						break;
					}					
		} 		
	} 	
	
	function calcuTotalesTodos(){
		var cantColns = 5;
		for(var i=0;i<=cantColns;i++)
			calcuTotales(i);		
	}
	
	function doConlisSalidas(par,par2){
		 popUpWindow("/cfmx/sif/iv/operacion/gas/salidas.cfm?DMAid=" + par + "&EMAid=" + par2,250,200,650,400);
	}
</script>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
	<cfif isdefined("url.imprimir")>
		<form name="form_Salidas" method="post" action="movAlmacen-sql.cfm" onSubmit="javascript: return valida();">				
	</cfif>
	 <cfif isdefined('url.imprimir')>
		<cfoutput>
			<table width="100%"  border="0" class="areaFiltro">
              <tr>
                <td colspan="5" class="tituloListas">Movimientos de Mercancía del Dep&oacute;sito en Estaciones de Servicio </td>
              </tr>
              <tr>
                <td colspan="5">&nbsp;</td>
              </tr>
              <tr>
                <td width="10%" align="right"><strong>Estaci&oacute;n:</strong></td>
                <td width="35%"> #rsform.Odescripcion#
                  <input type="hidden" name="Ocodigo" value="#rsForm.Ocodigo#" />                </td>
                <td width="8%" align="right"><strong>Fecha:</strong></td>
                <td width="21%"><cfif isdefined("form.fEMAfecha") and len(form.fEMAfecha)>
                    <input type="hidden" name="fEMAfecha" value="#DateFormat(form.fEMAfecha, 'dd/mm/yyyy')#" />
                  </cfif>
                    <cfif isdefined('rsForm.EMAfecha') and rsForm.EMAfecha NEQ ''>
                      #DateFormat(rsform.EMAfecha, "dd/mmm/yyyy")#
                      <input type="hidden" name="EMAfecha" value="#DateFormat(rsForm.EMAfecha, 'dd/mm/yyyy')#" />
          			<cfelse>
                      #DateFormat(Now(), "dd/mmm/yyyy")#
                      <input type="hidden" name="EMAfecha" value="#DateFormat(Now(), 'dd/mm/yyyy')#" />
                    </cfif>                </td>
                <td width="21%" rowspan="2" align="center" valign="middle" nowrap="nowrap">&nbsp;&nbsp;&nbsp;&nbsp;</td>
              </tr>
              <tr>
                <td colspan="5">&nbsp;</td>
              </tr>			  
            </table>
	   </cfoutput>			
	</cfif> 
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="50" valign="middle" bgcolor="#000000"><span class="style1">Producto</span></td>
      <td width="7%" align="right" bgcolor="#ACACAC"><strong>Unidad</strong></td>
      <td width="7%" align="right" bgcolor="#ACACAC"><strong>Precio </strong></td>
      <td width="8%" align="right" bgcolor="#ACACAC"><strong>Inv. Inicial</strong></td>
      <td width="9%" align="right" bgcolor="#ACACAC"><strong>Compras</strong></td>
      <td width="10%" align="center" bgcolor="#ACACAC"><cfif not isdefined('url.imprimir')><strong>Salidas</strong><cfelse>&nbsp;</cfif></td>
      <td width="9%" align="right" bgcolor="#ACACAC"><strong>Inv. Final</strong></td>
      <td width="9%" align="right" bgcolor="#ACACAC"><strong>Devoluciones</strong></td>
      <td width="10%" align="right" bgcolor="#ACACAC"><strong>Inv. Físico </strong></td>
      <td width="8%" align="right" bgcolor="#ACACAC"><strong>Referencia </strong></td>
      </tr>

	<cfif isdefined('rsMovDep') and rsMovDep.recordCount GT 0>
		<cfset LvarListaNon = -1>
		<cfset clas = ''>		
		<cfset numRow = 1>
		<cfset numRegs = ''>
		<cfset numRegsClas = ''>		
		<cfset totInvInicial = 0>		
		<cfset totCompra = 0>	
		<cfset totInvFinal = 0>
		<cfset totDevol = 0 >
		<cfset totInvFisico = 0 >
		
		<cfoutput query="rsMovDep">
			<cfset LvarListaNon = (CurrentRow MOD 2)>			

			<cfif clas NEQ rsMovDep.Ccodigo>
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				  <td colspan="3"><strong>#rsMovDep.Cdescripcion#</strong></td>
				  <td  align="right">				  				  
					<cfif isdefined('numRegs') and numRegs NEQ ''>
						<script language="javascript" type="text/javascript">
							cargaSubTotalesXclas('#numRegs#',#clas#);	
						</script>
					</cfif>
				  	<input type="hidden" name="corte_#rsMovDep.Ccodigo#" value="">
					<cfset numRegs = ''>
                    <input 
							type="text" 
							readonly="true"   tabindex="-1"
							name="subTotalInvInicial_#CurrentRow#" 
							size="8"  
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00">				  </td>				  
				  <td  align="right">
					  <input 
							type="text" 
							readonly="true"   tabindex="-1"
							name="subTotalCompras_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00">				  </td>
				  <td  align="right">&nbsp;				  </td>
				  <td align="right">
                    <input 
							type="text" 
							readonly="true"   tabindex="-1"
							name="subTotalInvFinal_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00">				  </td>
				  <td align="right">
					  <input
							type="text" 
							readonly="true"   tabindex="-1"
							name="subTotalDevol_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00">				  </td>
				  <td align="right"><input 
							type="text" 
							readonly="true"   tabindex="-1"
							name="subTotalInvFisico_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
							onblur="javascript:fm(this,2);"  
							onfocus="javascript:this.value=qf(this); this.select();"  
							onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="0.00" /></td>
				  <td align="right">&nbsp;</td>
			    </tr>
<!--- Y HASTA AQUI SON LOS CALCULOS --->				
							
				<script language="javascript" type="text/javascript">
					cargaSubTotInvInicial(#totInvInicial#,#numRow#);
					cargaSubTotCompra(#totCompra#,#numRow#);
					cargaSubTotInvFinal(#totInvFinal#,#numRow#);
					cargaSubTotDevol(#totDevol#,#numRow#);
					cargaSubTotInvFisico(#totInvFisico#,#numRow#);						
				</script> 
				<cfset totInvInicial = 0>		
				<cfset totCompra = 0>			
				<cfset totInvFinal = 0>
				<cfset totDevol = 0 >
				<cfset totInvFisico = 0 >				
 
				<cfset numRow = CurrentRow>				
				<cfset clas = rsMovDep.Ccodigo>
				<cfif numRegsClas NEQ ''>
					<cfset numRegsClas = numRegsClas & ",#CurrentRow#">
				<cfelse>
					<cfset numRegsClas = "#CurrentRow#">
				</cfif>					
			</cfif>

			<cfif numRegs NEQ ''>
				<cfset numRegs = numRegs & ",#CurrentRow#">
			<cfelse>
				<cfset numRegs = "#CurrentRow#">	
			</cfif>		
			
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
			  <td>
			  	#rsMovDep.Adescripcion#
				<input type="hidden" name="almacenOri_#CurrentRow#" value="#rsMovDep.idAlmOri#">
				<input type="hidden" name="articulo_#CurrentRow#" value="#rsMovDep.Aid#">				
				<input type="hidden" name="articuloDescr_#CurrentRow#" value="#HTMLEditFormat(rsMovDep.Adescripcion)#">


<!--- 				<input type="hidden" name="almacen_#CurrentRow#" value="#rsMovDep.idAlmacen#"> --->			  
			  </td>
			  <td align="center">#rsMovDep.Ucodigo#</td>
			  <td align="right">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsMovDep.DMAprecio, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="DMAprecio_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							value="#LSCurrencyFormat(rsMovDep.DMAprecio, 'none')#">				  
				  </cfif>			  
			  </td>
			  <td  align="right">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsMovDep.DMAinvIni, 'none')#
				  <cfelse>
					<input 
							type="text" 
							name="DMAinvIni_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
 							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} sumaTotClas('#rsMovDep.Ccodigo#',1,#numRow#); calcuTotales(1);}"
							value="#LSCurrencyFormat(rsMovDep.DMAinvIni, 'none')#">
				  </cfif>			  
			  </td>
			  <cfif rsMovDep.DMAinvIni NEQ '' and rsMovDep.DMAinvIni GT 0>			
				<cfset totInvInicial = totInvInicial + rsMovDep.DMAinvIni>
			  </cfif> 
			  
			  <td align="right">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsMovDep.DMAcompra, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="DMAcompra_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} sumaTotClas('#rsMovDep.Ccodigo#',2,#numRow#); calcuTotales(2);}"
							value="#LSCurrencyFormat(rsMovDep.DMAcompra, 'none')#">			  
				  </cfif>			  
			  </td>
 			  <cfif rsMovDep.DMAcompra NEQ '' and rsMovDep.DMAcompra GT 0>
				<cfset totCompra = totCompra + rsMovDep.DMAcompra>
			  </cfif>
			  <td align="center">
				  <cfif not isdefined('url.imprimir')>
					<cfquery name="rsSalidaDet" dbtype="query">
						Select sumaCant
						from rsSalidas
						where DMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMovDep.DMAid#">
					</cfquery>					  
 					<cfif isdefined('rsSalidaDet') and rsSalidaDet.recordCount GT 0>
						<a href="##" tabindex="-1">
							<img id="VendImagen" src="/cfmx/sif/imagenes/Description.gif" alt="Salida de Mercanc&iacute;a al Almacen de las Pistas" name="VendImagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisSalidas('#rsMovDep.DMAid#','#form.EMAid#');">
						</a>
						<input type="hidden" name="idDetSuma_#CurrentRow#" value="#rsSalidaDet.sumaCant#">
					<cfelse>
						<a href="##" tabindex="-1">
							<img id="VendImagen" src="/cfmx/sif/imagenes/BajoMinimo.gif" alt="No hay Salidas de Mercanc&iacute;a" name="VendImagen" border="0" align="absmiddle" onClick="javascript:doConlisSalidas('#rsMovDep.DMAid#','#form.EMAid#');">
						</a>					
						<input type="hidden" name="idDetSuma_#CurrentRow#" value="0">
					</cfif>
 				  <cfelse>
					&nbsp;		  
				  </cfif>			  
			  </td>
			  <td align="center">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsMovDep.DMAinvFin, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="DMAinvFin_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} sumaTotClas('#rsMovDep.Ccodigo#',3,#numRow#); calcuTotales(3);}"
							value="#LSCurrencyFormat(rsMovDep.DMAinvFin, 'none')#">
				  </cfif>			  
			  </td>
 			  <cfif rsMovDep.DMAinvFin NEQ '' and rsMovDep.DMAinvFin GT 0>
				<cfset totInvFinal = totInvFinal + rsMovDep.DMAinvFin>
			  </cfif>		  
			  
			  <td align="right">
				  <cfif isdefined('url.imprimir')>
				    #LSCurrencyFormat(rsMovDep.DMAdevol, 'none')#
			        <cfelse>
					  <input 
							type="text" 
							name="DMAdevol_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} sumaTotClas('#rsMovDep.Ccodigo#',4,#numRow#); calcuTotales(4);}"							
							value="#LSCurrencyFormat(rsMovDep.DMAdevol, 'none')#">	
				  </cfif>			  
			  </td>
 			  <cfif rsMovDep.DMAdevol NEQ '' and rsMovDep.DMAdevol GT 0>
				<cfset totDevol = totDevol + rsMovDep.DMAdevol>
			  </cfif>
			  			  
			  <td align="right">
				  <cfif isdefined('url.imprimir')>
				  	#LSCurrencyFormat(rsMovDep.DMAinvFisico, 'none')#
				  <cfelse>
					  <input 
							type="text" 
							name="DMAinvFisico_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;" 
							onBlur="javascript:fm(this,2);"  
							onFocus="javascript:this.value=qf(this); this.select();"  
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} sumaTotClas('#rsMovDep.Ccodigo#',5,#numRow#); calcuTotales(5);}"
							value="#LSCurrencyFormat(rsMovDep.DMAinvFisico, 'none')#">								
				  </cfif>			  
			  </td>
 			  <cfif rsMovDep.DMAinvFisico NEQ '' and rsMovDep.DMAinvFisico GT 0>
				<cfset totInvFisico = totInvFisico + rsMovDep.DMAinvFisico>
			  </cfif>			  

			  <td align="right">
				  <cfif isdefined('url.imprimir')>
				  	#rsMovDep.DMAdoc#
				  <cfelse>
					  <input 
							type="text" 
							name="DMAdoc_#CurrentRow#" 
							size="8" 
							maxlength="8" 
							style="text-align: right;"  
							onFocus="javascript: this.select();"  
							value="<cfif rsMovDep.DMAdoc NEQ 'x'>#rsMovDep.DMAdoc#</cfif>">
				  </cfif>			  
			  </td>
		    </tr>	
	</cfoutput>			
		<tr>
		  <td width="7%" align="right">&nbsp;</td>
		  <td width="7%" align="right">&nbsp;</td>
		  <td width="8%" align="right">&nbsp;</td>
		  <td width="9%" align="right">
			<input 
					type="text" 
					readonly="true"   tabindex="-1"
					name="totalInvInicial" 
					size="8"  
					maxlength="8" 
					style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
					onBlur="javascript:fm(this,2);"  
					onFocus="javascript:this.value=qf(this); this.select();"  
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					value="0.00">		  </td>
		  <td width="10%" align="right">
			<input 
					type="text" 
					readonly="true"   tabindex="-1"
					name="totalCompras" 
					size="8"  
					maxlength="8" 
					style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
					onBlur="javascript:fm(this,2);"  
					onFocus="javascript:this.value=qf(this); this.select();"  
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					value="0.00">		  </td>
		  <td width="9%" align="right">&nbsp;</td>
		  <td width="9%" align="right">
			<input 
					type="text" 
					readonly="true"   tabindex="-1"
					name="totalInvFinal" 
					size="8"  
					maxlength="8" 
					style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
					onBlur="javascript:fm(this,2);"  
					onFocus="javascript:this.value=qf(this); this.select();"  
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					value="0.00">		  </td>
		  <td width="10%" align="right">
			<input 
					type="text" 
					readonly="true"   tabindex="-1"
					name="totalDevol" 
					size="8"  
					maxlength="8" 
					style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
					onBlur="javascript:fm(this,2);"  
					onFocus="javascript:this.value=qf(this); this.select();"  
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					value="0.00">		  </td>
		  <td width="8%" align="right">
			<input 
					type="text" 
					readonly="true"   tabindex="-1"
					name="totalInvFisico" 
					size="8"  
					maxlength="8" 
					style="text-align: right; border: 0px none; font-weight: bold; font-size:11px;" 
					onBlur="javascript:fm(this,2);"  
					onFocus="javascript:this.value=qf(this); this.select();"  
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					value="0.00">		  </td>
		  <td width="9%" align="right">&nbsp;</td>
		  </tr>					
		
		<input type="hidden" name="cantReg" value="<cfif isdefined('rsMovDep') and rsMovDep.recordCount GT 0><cfoutput>#rsMovDep.recordCount#</cfoutput><cfelse>0</cfif>">
		<input type="hidden" name="regsClas" value="<cfif isdefined('numRegsClas') and numRegsClas NEQ ''><cfoutput>#numRegsClas#</cfoutput></cfif>">					
		
		<cfif isdefined('numRegs') and numRegs NEQ ''>
			<script language="javascript" type="text/javascript">
				<cfoutput>
					cargaSubTotalesXclas('#numRegs#',#clas#);
					cargaSubTotInvInicial(#totInvInicial#,#numRow#);
					cargaSubTotCompra(#totCompra#,#numRow#);
					cargaSubTotInvFinal(#totInvFinal#,#numRow#);
					cargaSubTotDevol(#totDevol#,#numRow#);
					cargaSubTotInvFisico(#totInvFisico#,#numRow#);					
					calcuTotalesTodos();
				</cfoutput>
			</script>
		</cfif>	 	 
	</cfif>
  </table>
<cfif isdefined('url.imprimir')>
	</form>
	
	<table width="100%" border="0" align="center">
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center"><strong>---	Fin del Reporte	---</strong></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	</table>
</cfif>
  