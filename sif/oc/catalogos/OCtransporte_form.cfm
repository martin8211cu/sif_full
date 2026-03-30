<cfset modo = 'ALTA'>

<cfif isdefined("form.OCTid") and len(trim(form.OCTid))>
	<cfquery datasource="#session.dsn#" name="rsForm">
		select OCTid, 
			OCTtipo,
			OCTtransporte,
			OCTestado, 		OCTnumCierre,
			OCTvehiculo,
			OCTruta,
			OCTfechaPartida,
			OCTfechaLlegada,
			OCTPfechaBOLdefault,
			OCTPnumeroBOLdefault
		  from OCtransporte 
		 where OCTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
		 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	<cfset modo = 'CAMBIO'>
</cfif>
	
<cfoutput>

<form name="form1" id="form1" method="post" action="OCtransporte_sql.cfm">
	<table  width="100%" summary="Tabla de entrada">
		<tr>
			<td colspan="4" class="subTitulo">
				Transportes
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Tipo de transporte</strong>
			</td>
			<td valign="top">
				<cfif modo  EQ "CAMBIO">
					<strong>
					<cfif rsForm.OCTtipo  EQ "B">
						Barco
					<cfelseif rsForm.OCTtipo EQ "A">
						Avion
					<cfelseif rsForm.OCTtipo EQ "T">
						Terrestre
					<cfelseif rsForm.OCTtipo EQ "F">
						Ferrocarril		
					</cfif>
					</strong>
					<input type="hidden" name="OCTtipo" value="#rsForm.OCTtipo#">
				<cfelse>
					<select name="OCTtipo" tabindex="1" >
						<option value="B">Barco</option>
						<option value="A">Avion</option>
						<option value="T">Terrestre</option>
						<option value="F">Ferrocarril</option>
					</select>
				</cfif>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Transporte</strong>
			</td>
			<td valign="top">
				<input type="text" name="OCTtransporte" id="OCTtransporte"  
					value="<cfif isdefined("rsForm.OCTtransporte") and len(trim(rsForm.OCTtransporte))>#HTMLEditFormat(rsForm.OCTtransporte)#</cfif>" 
					 size="20" maxlength="20"
					onfocus="this.select()"   
					tabindex="2"					
				>
			</td>
			<td valign="top">
				<strong>Veh&iacute;culo</strong>
			</td>
			<td valign="top">
				<input type="text" name="OCTvehiculo" id="OCTvehiculo"  
					value="<cfif isdefined("rsForm.OCTvehiculo") and len(trim(rsForm.OCTvehiculo))>#HTMLEditFormat(rsForm.OCTvehiculo)#</cfif>" 
					 size="20" maxlength="20"
					onfocus="this.select()"   
					tabindex="3"					
				>
			</td>
		 </tr>
		 <tr>		
			<td valign="top">
				<strong>Fecha de Partida</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsForm.OCTfechaPartida") and len(trim(rsForm.OCTfechaPartida))>
					<cf_sifcalendario	tabindex="4" name="OCTfechaPartida" 
							value="#DateFormat(rsForm.OCTfechaPartida,'dd/mm/yyyy')#"
							form="form1" >
				<cfelse>
					<cf_sifcalendario	tabindex="4" name="OCTfechaPartida" 
							value="#DateFormat(Now(),'dd/mm/yyyy')#"
							form="form1" >
				</cfif>	
			</td>
			<td valign="top">
				<strong>Fecha de llegada</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsForm.OCTfechaLlegada") and len(trim(rsForm.OCTfechaLlegada))>
					<cf_sifcalendario	tabindex="5" name="OCTfechaLlegada" 
							value="#DateFormat(rsForm.OCTfechaLlegada,'dd/mm/yyyy')#"
							form="form1" >
				<cfelse>
					<cf_sifcalendario	tabindex="5" name="OCTfechaLlegada" 
							value=""
							form="form1" >
				</cfif>	
			</td>			
		</tr>

		<tr>
		  <td><strong>Bill of lading (Default)</strong></td>
		  <td>
			<input 
				type="text" 
				name="OCTPnumeroBOLdefault"
				id="OCTPnumeroBOLdefault"
				value="<cfif isdefined("rsForm.OCTPnumeroBOLdefault") and len(trim(rsForm.OCTPnumeroBOLdefault))>#HTMLEditFormat(rsForm.OCTPnumeroBOLdefault)#</cfif>" 
				size="20" 
				maxlength="20"  
				autocomplete="off"
				alt="OCTPnumeroBOLdefault"
				tabindex="6"
				title="Bill of lading (Default)">
		  </td>
		  <td><strong>Date Bill of lading (Default)</strong></td>
		  <td>
			<cfif isdefined("rsForm.OCTPfechaBOLdefault") and len(trim(rsForm.OCTPfechaBOLdefault))>
					<cf_sifcalendario	tabindex="6" name="OCTPfechaBOLdefault" 
							value="#DateFormat(rsForm.OCTPfechaBOLdefault,'dd/mm/yyyy')#"
							form="form1" >
				<cfelse>
					<cf_sifcalendario	tabindex="6" name="OCTPfechaBOLdefault" 
							value=""
							form="form1" >
				</cfif>	
		  </td>		  
		</tr>		
		
		<tr>
			<td valign="top">
				<strong>Ruta</strong>
			</td>
			<td valign="top" colspan="3">
				<input type="text" name="OCTruta" id="OCTruta"  tabindex="6"
					value="<cfif isdefined("rsForm.OCTruta") and len(trim(rsForm.OCTruta))>#HTMLEditFormat(rsForm.OCTruta)#</cfif>" 
					size="40" maxlength="40"
					onfocus="this.select()"  
				>
			</td>
		</tr>
		
		<tr>
			<td valign="top">
				<strong>Estado</strong>
			</td>
			<td valign="top" colspan="3">
				<select name="OCTestado" tabindex="1" >
				<cfif modo EQ "ALTA">
					<option value="A" selected>Abierto</option>
				<cfelseif rsForm.OCTestado EQ "A">
					<option value="A" selected>Abierto</option>
					<cfif rsForm.OCTnumCierre EQ 0>
						<option value="C">Cerrado</option>
					</cfif>
				<cfelseif rsForm.OCTestado EQ "C">
					<cfif rsForm.OCTnumCierre GT 0>
						<option value="C" selected>Cerrado con el proceso de Cierre de Transporte</option>
					<cfelseif rsForm.OCTnumCierre EQ 0>
						<option value="C" selected>Cerrado</option>
						<option value="A">Abierto</option>
					<cfelseif rsForm.OCTnumCierre EQ -1>
						<option value="C" selected>Cerrado para Tránsito sin Órdenes Comerciales</option>
						<option value="T">Tránsito sin Órdenes Comerciales</option>
					</cfif>
				<cfelseif rsForm.OCTestado EQ "T">
					<option value="T">Tránsito sin Órdenes Comerciales</option>
					<option value="C">Cerrado</option>
				<cfelse>
					<cf_errorCode	code = "50434"
									msg  = "Estado desconocido '@errorDat_1@'"
									errorDat_1="#rsForm.OCTestado#"
					>
				</cfif>
				</select>
			</td>
		</tr>
		
		
		<tr>
			<td colspan="4" class="formButtons">
			<cfif modo  EQ "CAMBIO">
				<cf_botones  tabindex="7" regresar='OCtransporte.cfm' modo='CAMBIO'>
			<cfelse>
				<cf_botones  tabindex="7" regresar='OCtransporte.cfm' modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
	<cfif modo  EQ "CAMBIO">
		<input type="hidden" name="OCTid" value="#HTMLEditFormat(rsForm.OCTid)#">
	</cfif>
	
</form>
<!--- *******************************************************************************--->
<cfif modo  EQ "CAMBIO">
	<cf_navegacion name="s" default="">
	<cf_web_portlet_start titulo="Productos">
		<table width="100%" align="center">
			<tr>
				<td  colspan="3" valign="top">
					<cfinclude template="OCTransporteProducto_form.cfm">
				</td>
			</tr>
			 <tr>
				<td width="48%" valign="top">
					<strong>PRODUCTOS ORIGEN</strong>
				</td>
				<td width="4%">&nbsp; </td>
				<td width="48%" valign="top">
					<strong>PRODUCTOS DESTINO</strong>
				</td>
			</tr>
			 <tr>
				<td width="48%" valign="top">
					<cfinclude template="OCTransporteProducto_listO.cfm">
				</td>
				<td width="4%">&nbsp; </td>
				<td width="48%" valign="top">
					<cfinclude template="OCTransporteProducto_listD.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
</cfif> 

<cf_qforms form="form1" objForm="LobjQForm">
	<cf_qformsRequiredField args="OCTtipo, Tipo de transporte">
	<cf_qformsRequiredField args="OCTtransporte, Transporte">
	<cf_qformsRequiredField args="OCTfechaPartida, Fecha partida">
</cf_qforms> 
</cfoutput>

<script type="text/javascript">
	function eliminar(OCid,Aid){
		if ( confirm('¿Desea eliminar esta línea?')){
			document.form2.OCid.value = OCid;
			document.form2.Aid.value = Aid;
			document.form2.BorrarLinea.value = 'S';
			document.form2.submit();
		} 
	}
	
	
</script>



