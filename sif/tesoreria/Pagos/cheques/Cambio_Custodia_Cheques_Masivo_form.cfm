<cfset arr 	   = ListToArray(form.chk, ',', false)>
<cfset LvarLen = ArrayLen(arr)>

		<cfset form.TESid                =  #ListGetAt(arr[1], 1 ,'|')#>         
		<cfset form.TESOPid              =  #ListGetAt(arr[1], 2 ,'|')#>      
        <cfset form.TESCFDnumFormulario  =  #ListGetAt(arr[1], 3 ,'|')#> 
        <cfset form.TESMPcodigo          =  #ListGetAt(arr[1], 4 ,'|')#> 
        <cfset form.CBid                 =  #ListGetAt(arr[1], 5 ,'|')#>     


<cfset entrega = ''>
<cfquery name="rsLugares" datasource="#session.DSN#">
	select TESid, TESCFLUid, TESCFLUdescripcion
	from TESCFlugares
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
</cfquery>
<cfquery name="rsEstados" datasource="#session.DSN#">
	select TESid, TESCFEid, TESCFEdescripcion, BMUsucodigo, ts_rversion, TESCFEimpreso, TESCFEentregado, TESCFEanulado
	from TESCFestados
	where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
		and TESCFEimpreso = 0 
		and TESCFEentregado = 0 
		and TESCFEanulado = 0
</cfquery>

<cfquery name="rsCustodiado" datasource="#session.DSN#">
	select EcodigoPago 
	from  TESordenPago
	where TESOPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
</cfquery>

<cfquery name="rsTesoreria" datasource="#session.dsn#">
	Select t.TESid
	  from TESempresas te, Tesoreria t
	 where te.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and t.EcodigoAdm	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and t.TESid 		= te.TESid
</cfquery>

<cfoutput>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#" width="100%">
	<form action="Cambio_Custodia_Cheques_Masivo_sql.cfm" method="post" name="form1" id="form1"
		  onsubmit="return fnProcessRegistrar();"
		  >
		<cfset LvarDatosChequesDet = true>
		<table width="85%" align="center" id="tablaA"> 	
			<tr>
				<td colspan="7">
					<fieldset>
						<legend><strong>Cambio&nbsp;Custodia&nbsp;de&nbsp;Cheques</strong></legend>
						<table align="center" width="50%">
							<tr>
								<td align="right" nowrap><strong>Fecha&nbsp;Movimiento:&nbsp;</strong></td>
								<td><cf_sifcalendario name="fechaMovimiento" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></td>
							</tr>
							<tr>
								<td align="right" nowrap><strong>Custodiado&nbsp;en:&nbsp;</strong></td>
								<td>
									<select name="TESCFLUid" tabindex="1">
										<option value="">(Escoja un valor)</option>
										<cfloop query="rsLugares">
											<option value="#TESCFLUid#" <cfif isdefined('form.TESCFLUdescripcion') and len(trim(form.TESCFLUdescripcion)) and form.TESCFLUdescripcion EQ rsLugares.TESCFLUdescripcion>selected</cfif>>#rsLugares.TESCFLUdescripcion#</option>
										</cfloop>
									</select>
									
								</td>
							</tr>
							<tr>
								<td align="right" nowrap><strong>Razón;</strong></td>
								<td>
									<select name="TESCFEid" tabindex="1">
										<option value="">(Escoja un valor)</option>
										<cfloop query="rsEstados">
											<option value="#TESCFEid#" <cfif isdefined('form.TESCFEdescripcion') and len(trim(form.TESCFEdescripcion)) and form.TESCFEdescripcion EQ rsEstados.TESCFEdescripcion>selected</cfif>>#rsEstados.TESCFEdescripcion#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							
							<tr>
								<td align="right" nowrap><strong>Custodiado&nbsp;por:&nbsp;</strong></td>
								<td><cf_sifusuario Ecodigo ="#session.Ecodigo#" tabindex="1"></td>
							</tr>
							<tr>
								<td align="right" nowrap valign="top"><strong>Observaciones:&nbsp;</strong></td>
								<td><textarea name="TESCFBobservacion" style="width:100% " tabindex="1"></textarea></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td colspan="3"  align="center">
								<!---	<cfif rsForm.TESCFDfechaRetencion GT Now()>
										<script>
											alert('El Cheque se encuentra RETENIDO.');
										</script>
									</cfif>--->
									<cfif rsTesoreria.recordCount GT 0>
										<cfset session.Tesoreria.TESid = rsTesoreria.TESid>
										<input name="Cambio" type="submit" value="Registrar Cambio Custodia" tabindex="1"											
										>
									</cfif>
									<input name="Lista_Cheques" type="button" id="btnSelFac" value="Lista Cheques" tabindex="1"
										onClick="location.href='Cambio_Custodia_Cheques_Masivo.cfm';"
									>
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
						</table>
					</fieldset>
				</td>               
                
		  </tr>           

            <tr> 
                <td><strong>Num. Cheque&nbsp;</strong></td><td><strong>Cuenta&nbsp;</strong></td><td><strong>Estado&nbsp;</strong></td><td><strong>Fecha Pago&nbsp;</strong></td><td><strong>Beneficiario&nbsp;</strong></td><td><strong>Monto</strong></td><td><strong>Detalle</strong></td>
            </tr> 
            <tr>
              <td colspan="7"><input type="hidden" name="campo" id="campo"/></td>
           </tr>           
            <cfset contador= 0>
   	      <cfloop index="i" from="1" to="#LvarLen#">                                         
			<cfset form.TESid                =  #ListGetAt(arr[i], 1 ,'|')#>         
		    <cfset form.TESOPid              =  #ListGetAt(arr[i], 2 ,'|')#>      
            <cfset form.TESCFDnumFormulario  =  #ListGetAt(arr[i], 3 ,'|')#> 
            <cfset form.TESMPcodigo          =  #ListGetAt(arr[i], 4 ,'|')#> 
            <cfset form.CBid                 =  #ListGetAt(arr[i], 5 ,'|')#>     
            <cfset contador = contador + 1>
              	<cfinclude template="datosChequesMasivo.cfm">
           <script language="javascript">
		      document.form1.campo.value = <cfoutput>#contador#</cfoutput>
		   </script>
          <tr id="tr_#form.TESOPid#" >                  
               <input type="hidden" name="TESid" id="TESid" value="#form.TESid#"/>
               <input type="hidden" name="TESOPid" id="TESOPid" value="#form.TESOPid#"/>
               <input type="hidden" name="TESCFDnumFormulario" value="#form.TESCFDnumFormulario#"/>
               <input type="hidden" name="TESMPcodigo" value="#form.TESMPcodigo#"/>
               <input type="hidden" name="CBid" value="#form.CBid#"/>
               
               
              <td>#rsform.TESCFDnumFormulario#</td>
              <td>#rsForm.ctaPago#</td>
              <td>#rsForm.Estado#</td>
              <td>#LSDateFormat(rsForm.TESOPfechaPago,'dd/mm/yyyy')#</td>
              <td>#rsForm.beneficiario#</td>
              <td>#LSCurrencyFormat(rsForm.TESOPtotalPago,'none')# #rsForm.monPago#</td>
              <td><a><img src="../../../imagenes/findsmall.gif" style="cursor:pointer" alt="Detalle de la OP" width="16" height="16" 
              onclick="javascript: window.open('../cheques/datosChequesMasivoDet.cfm?TESid=#form.TESid#&TESOPid=#form.TESOPid#&TESCFDnumFormulario=#form.TESCFDnumFormulario#&TESMPcodigo=#form.TESMPcodigo#&CBid=#form.CBid#&tipoCheque=#tipoCheque#', 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=300,height=400');"/></a></td>
              <td><img src="../../../imagenes/Borrar01_S.gif" style="cursor:pointer" alt="Eliminar OP" width="16" height="16" 
              onclick="javascript: funcOcultar('tr_#form.TESOPid#');"/></a></td></td>                        
         </tr>                       
        </cfloop>     
        
	  </table>
	</form>   
  <!---<cfinclude template="datosChequesDet.cfm">--->
	<cf_web_portlet_end>
</cfoutput>
<script language="JavaScript" src="../../js/fechas.js"></script>
<cf_qforms form="form1" objForm="objForm">
<script language="javascript">
	objForm.fechaMovimiento.required = true;
	objForm.fechaMovimiento.description = "Fecha Movimiento";
	objForm.TESCFLUid.required = true;
	objForm.TESCFLUid.description = "Custodiado en";
	objForm.TESCFEid.required = true;
	objForm.TESCFEid.description = "Razón";
	objForm.Usulogin.required = true;
	objForm.Usulogin.description = "Custodiado por";
	objForm.TESCFBobservacion.required = true;
	objForm.TESCFBobservacion.description = "Observaciones";

	function fnProcessRegistrar()
	{
		var DiaActual = new Date();
       
	   	var dia  = DiaActual.getDate();		
		var mes  = DiaActual.getMonth();
		mes++;		
		if(mes < 10)
		mes =   "0" + mes;		
		var year  = DiaActual.getFullYear();
		
        var FechaHoy =   dia+"/"+mes+"/"+year;
		
		var Entrega = document.form1.fechaMovimiento.value;       
		 
		if (Entrega > FechaHoy)
		{
			alert('La fecha del Movimiento debe ser anterior o igual al día de hoy.');
			return false;
		}
		else if (confirm('¿Registrar la nueva CUSTODIA<!---<cfoutput>#rsform.TESCFDnumFormulario#</cfoutput>--->?'))
		{
			return true;
		}
		else
			return false;
	}
	
	function funcLimpiar()
	{
		document.form1.reset();
	}
	function funcOcultar(Elemento)
	{
	document.getElementById(Elemento).parentNode.removeChild(document.getElementById(Elemento));	  
    var nodos= document.form1.campo.value;
	  document.form1.campo.value = nodos - 1; 
	  	if (document.form1.campo.value == 0)
		   {
			  location.href='../cheques/Cambio_Custodia_Cheques_Masivo.cfm';  
			}
	  
	}

	
	
	document.form1.fechaMovimiento.focus();
	
</script>
