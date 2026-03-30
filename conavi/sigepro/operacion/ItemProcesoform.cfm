<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>


<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif not isdefined("Form.GETtipo") and isdefined("url.GETtipo")>
	<cfset Form.GETtipo=url.GETtipo>
</cfif>

<cfif isdefined("url.proceso") and len(trim(url.proceso)) gt 0>
    <cfset LvarProceso =  url.proceso> 
<cfelseif isdefined("Form.proceso") and len(trim( Form.proceso)) gt 0>
    <cfset LvarProceso =  Form.proceso>
</cfif>

<cfif isdefined("url.linea") and len(trim(url.linea)) gt 0>
    <cfset LvarLinea =  url.linea> 
<cfelseif isdefined("Form.linea") and len(trim( Form.linea)) gt 0>
    <cfset LvarLinea =  Form.linea>
</cfif>

<cfif isdefined("url.solicitud") and len(trim(url.solicitud)) gt 0>
    <cfset LvarSolicitud =  url.solicitud> 
<cfelseif isdefined("Form.solicitud") and len(trim( Form.solicitud)) gt 0>
    <cfset LvarSolicitud =  Form.solicitud>
</cfif>
 


	<cfquery name="rsEncabezado" datasource="#session.dsn#">  
		  select 
		  cmpc.CMPnumero,
		  cmpc.CMPdescripcion,
		  dcm.DSdescripcion,
		  dcm.ESnumero,
		  ecm.Mcodigo,
		  dcm.ESidsolicitud,
		  dcm.DSlinea,
		  cf.CFdescripcion,
		  dcm.DStotallinest  
			from CMLineasProceso cm
				 inner join DSolicitudCompraCM dcm
			         on cm.ESidsolicitud = dcm.ESidsolicitud
			         and cm.DSlinea = dcm.DSlinea
			     inner join  CFuncional cf 
                     on dcm.CFid = cf.CFid
				 inner join ESolicitudCompraCM ecm
				     on ecm.ESidsolicitud = dcm.ESidsolicitud
				inner join CMProcesoCompra cmpc
				     on cmpc.CMPid = cm.CMPid	 	 
		   where cm.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarProceso#"> 
		   and  dcm.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLinea#"> 
		   and dcm.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSolicitud #"> 
		   and dcm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	<cfquery name="rsDatosItemsProceso" datasource="#session.dsn#">
	select coalesce(sum(COItemPCantidad * COItemPPrecio),0) as SaldosCM,COItemPId, CMPid, COItemId, DSlinea, COItemPCantidad, COItemPPrecio, COItemPFecha from COItemsProceso where 
      Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	 and  CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarProceso#"> 
	 and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLinea#">	 
	</cfquery>
	<cfif rsDatosItemsProceso.recordcount gt 0>
	    <cfset LvarSaldoDisponible = rsEncabezado.DStotallinest - rsDatosItemsProceso.SaldosCM>
	<cfelse>
	    <cfset LvarSaldoDisponible = rsEncabezado.DStotallinest>	
	</cfif>	
			
	<cfquery name="rsMoneda" datasource="#session.dsn#"> 
	   select Mnombre, Msimbolo from Monedas where Mcodigo =  #rsEncabezado.Mcodigo# and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	<cfquery name="rsItems" datasource="#session.dsn#"> 
	   select COItemId, COItemClave, COItemUnidad, COItemDescripcion  from COItemsSigepro where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
		

<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >
<cfquery datasource="#Session.DSN#" name="rsItemProceso">
 	select 
		cip.COItemPId,
		cip.COItemId,
		cip.COItemPCantidad, 
		cip.COItemPPrecio,
		cis.COItemDescripcion,
		cis.COItemClave,
		u.Ucodigo,
		u.Udescripcion
	from COItemsProceso cip 
	    inner join  COItemsSigepro cis 
		   on cip.COItemId = cis.COItemId
		inner join Unidades u 
		   on cis.COItemUnidad = u.Ucodigo  
	where cis.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and   cip.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and   u.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.COItemPId") and form.COItemPId NEQ "">
		and COItemPId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COItemPId#">
	</cfif>
</cfquery> 
    <cfset IdItem = #rsItemProceso.COItemId#>	
	<cfset ClaveItem = #rsItemProceso.COItemClave#> 
	<cfset descripcionItem = #rsItemProceso.COItemDescripcion#>
	<cfset CodigoUnidad = #rsItemProceso.Ucodigo#>
	<cfset descripcionUnidad = #rsItemProceso.Udescripcion#>
<cfelse>
    <cfset IdItem = "">
	<cfset ClaveItem = ""> 
   	<cfset descripcionItem = "">
	<cfset CodigoUnidad = "">
	<cfset descripcionUnidad = "">
</cfif>
<table align="center" border="0">
 <tr>
	<td>
	  <table align="left" cellpadding="0" cellspacing="0" width="100%" border="0">
			<tr>
			  <td align="left"><strong>Proceso:</strong></td>
			  <td nowrap="nowrap" align="left"><cfoutput>#rsEncabezado.CMPdescripcion# - #rsEncabezado.CMPnumero#</cfoutput></td>
			</tr>
			<tr>
			  <td align="left"><strong>Línea de la Solicitud:</strong></td>
			  <td align="left"><cfoutput>#rsEncabezado.ESnumero# - #rsEncabezado.DSdescripcion#</td>
			</tr>
			<tr>
			<td align="left"><strong>Moneda:</strong></td>
			<td align="left"><cfoutput>#rsMoneda.Msimbolo# - #rsMoneda.Mnombre#</cfoutput></td>		
			</tr>
			<tr>
				<td align="left"><strong>Total:</strong>
				</td>
				<td align="left">
				    <cfoutput>#NumberFormat(rsEncabezado.DStotallinest,'9,99.99')#</cfoutput>
				</td>
			</tr>
			<tr>
			   <td> 
			     <strong>Disponible:</strong> </td></cfoutput>
			   
			   <td> &nbsp;<input type="text" size="15"  disabled="disabled" value="<cfoutput>#NumberFormat(LvarSaldoDisponible,'9,99.99')#</cfoutput>"></td>
			</tr>
	</table>	
	</td>
</tr>
<tr>
	<td>	
		<table align="center">
			<form method="post" name="form1" action="ItemProcesoSQL.cfm" onSubmit="return validar(this);">	
				<tr> 
						<td nowrap align="left"><strong>Item: </strong></td>
				  <td>    
					<cfset LvarEmptyListMsg = "Debe asignar Items para esta empresa">
					<cf_conlis
								Campos="COItemClave, COItemDescripcion, COItemUnidad,Udescripcion"
								Desplegables="S,S,S,S"
								Modificables="N,N,N,N"
								Size="10,25,5,15"
								values="#ClaveItem#,#descripcionItem#,#CodigoUnidad#,#descripcionUnidad#"
								tabindex="1"							
								Title="Lista de Items"
								Tabla="COItemsSigepro a inner join Unidades u on a.COItemUnidad = u.Ucodigo"
								Columnas="a.COItemClave, a.COItemDescripcion, a.COItemUnidad, u.Udescripcion"
								Filtro=" a.Ecodigo 	= #session.Ecodigo#" 						 
								Desplegar="COItemClave, COItemDescripcion,COItemUnidad,Udescripcion"
								Etiquetas="Clave,Descripci&oacute;n,Unidad, Descripcion"
								filtrar_por="a.COItemClave,a.COItemDescripcion, a.COItemUnidad,u.Udescripcion"
								Formatos="S,S,S,S"
								Align="left,left,left,left"
								form="form1"
								Asignar="COItemClave, COItemDescripcion, COItemUnidad,Udescripcion"
								Asignarformatos="S,S,S"
								Funcion=""
								showEmptyListMsg="true"
								EmptyListMsg="#LvarEmptyListMsg#"
								/>			
				  </td>
				</tr>		
				<tr valign="baseline"> 
					<td nowrap align="left"><strong>Cantidad:</strong></td>
					<td>	
					   <cfif modo EQ "CAMBIO" and len(trim(#rsItemProceso.COItemPCantidad#)) gt 0 >
					       <cf_inputNumber name="IPCcantidad"  enteros="10" decimales="0" negativos="false"  size="15"comas="no" value="#rsItemProceso.COItemPCantidad#" onchange="Disponible('#LvarSaldoDisponible#','#rsItemProceso.COItemPCantidad#','#rsItemProceso.COItemPPrecio#','#modo#')">	
						<cfelse>			 
		                   <cf_inputNumber name="IPCcantidad"  enteros="10" decimales="0" negativos="false"  size="15"comas="no" value="0" onchange="Disponible('#LvarSaldoDisponible#','0','0','#modo#')">			
					   </cfif>
					</td>
				</tr>
				<tr valign="baseline"> 
					<td nowrap align="left"><strong>Precio:</strong>
					</td>
					<td>
					  <cfif modo EQ "CAMBIO" and len(trim(#rsItemProceso.COItemPPrecio#)) gt 0  >
				    	   <cf_inputNumber name="IPCprecio"  enteros="10" decimales="2" negativos="false" disabled="true" size="15" comas="yes" value="#rsItemProceso.COItemPPrecio#" onchange="Disponible('#LvarSaldoDisponible#','#rsItemProceso.COItemPCantidad#','#rsItemProceso.COItemPPrecio#','#modo#')">
					  <cfelse>
<!---					       <cf_inputNumber name="IPCprecio"  enteros="10" decimales="2" negativos="false" disabled="true" size="15" comas="yes" value="0" onchange="Disponible('#LvarSaldoDisponible#','0','0','#modo#')">   --->
                           <cf_monto name="IPCprecio" id="IPCprecio" tabindex="-1" decimales="2" negativos="false" onchange="Disponible('#LvarSaldoDisponible#','0','0','#modo#')">
					  </cfif>
						 
					</td>
				</tr>	 
					 <input type="hidden" name="IPCproceso" id="IPCproceso" value="<cfoutput>#LvarProceso#</cfoutput>" />
					 <input type="hidden" name="IPCsolicitud" id="IPCsolicitud" value="<cfoutput>#LvarSolicitud#</cfoutput>" />
					 <input type="hidden" name="IPClinea" id="IPClinea" value="<cfoutput>#LvarLinea#</cfoutput>"  />
					 
					 
				 <cfif modo NEQ "ALTA" and len(trim(#rsItemProceso.COItemPId#)) gt 0  >		     		
           			 <input type="hidden" name="ItemPId" id="ItemPId" value="<cfoutput>#rsItemProceso.COItemPId#</cfoutput>"  />
				 </cfif>	
				 <cfif modo NEQ "ALTA" and len(trim(#rsItemProceso.COItemId#)) gt 0  >
		     		 <input type="hidden" name="ItemId" id="ItemId" value="<cfoutput>#rsItemProceso.COItemId#</cfoutput>"  /> 
				</cfif>
					 
				<tr>
				 <td>
				    <strong>Monto Total:</strong>
				 </td>
				 <td>
				    <cf_inputNumber name="IPCmonto"  enteros="10" comas="yes" decimales="2" readonly="yes" values="0" negativos="false" size="15">
				 </td>
				</tr>
				<tr> 
					<td colspan="2" align="center" nowrap>
						<input type="hidden" name="botonSel" value="" tabindex="-1">
						
						<cfif modo EQ "ALTA">
							<input type="submit" name="Alta" value="Agregar" id="Alta"  tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
							<input type="reset" name="Limpiar" value="Limpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
						<cfelse>
							<input type="submit" name="Cambio" value="Modificar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name;">
							<input type="submit" name="Baja" value="Eliminar" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
							<input type="submit" name="Nuevo" value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
						</cfif>			</td>
				</tr>
		   </form>
		  </table>
       </td>
	  </tr>
</table>	   
<cfoutput>
<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
	
</script>

<!---ValidacionesFormulario--->

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) ){
		var error_input;
		var error_msg = '';
		
		if (formulario.COItemClave.value == ""  ) {
			error_msg += "\n - El ítem no puede quedar en blanco.";
			error_input = formulario.COItemClave;
		}	
		if (formulario.IPCcantidad.value == "" || formulario.IPCcantidad.value == 0) {
			error_msg += "\n - La cantidad no puede quedar en blanco.";
			error_input = formulario.IPCcantidad;
		}	
		if (formulario.IPCprecio.value == "" || formulario.IPCprecio.value == 0) {
			error_msg += "\n - El precio no puede quedar en blanco.";
			error_input = formulario.IPCprecio;
		}		
       document.form1.IPCprecio.value = qf(form1.IPCprecio.value);
				
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
  function Disponible(total,precio,cantidad,modo)
  {
  
   <cfif modo EQ "CAMBIO">
  		montoActual = <cfoutput>#rsItemProceso.COItemPCantidad * rsItemProceso.COItemPPrecio#</cfoutput>;
	</cfif>				  
     var LvarPrecio = qf(document.getElementById('IPCprecio').value);
	 var LvarCantidad = document.getElementById('IPCcantidad').value;
	 var LvarTotal = LvarPrecio * LvarCantidad;
	 document.form1.IPCmonto.value = fm(LvarTotal,2);
  if(LvarTotal > total <cfif modo EQ "CAMBIO"> + montoActual</cfif>)
	{
	  alert("El total sobrepasa el monto disponible");	  
	  <cfif modo EQ "CAMBIO">
	  
		  window.parent.document.form1.IPCprecio.value = <cfoutput>#rsItemProceso.COItemPPrecio#</cfoutput>;
		  window.parent.document.form1.IPCcantidad.value = <cfoutput>#rsItemProceso.COItemPCantidad#</cfoutput>;
		  window.parent.document.form1.IPCmonto.value = <cfoutput>#rsItemProceso.COItemPCantidad * rsItemProceso.COItemPPrecio#</cfoutput>;
      <cfelse>
	      window.parent.document.form1.IPCprecio.value = 0;
		  window.parent.document.form1.IPCcantidad.value = 0;
		  window.parent.document.form1.IPCmonto.value = 0;
	  </cfif> 
	  
      document.getElementById('Alta').disabled=true;
	  return false;
	}
	else{
		alta = document.getElementById('Alta')
		if(alta)
			alta.disabled=false;
	}
  }
  function SetTotal()
  {
     var LvarPrecio = qf(document.getElementById('IPCprecio').value);
	 var LvarCantidad = document.getElementById('IPCcantidad').value;
	 var LvarTotal = LvarPrecio * LvarCantidad;
	 document.form1.IPCmonto.value = fm(LvarTotal,2);
   }	  
  SetTotal();
</script>
</cfoutput>
		