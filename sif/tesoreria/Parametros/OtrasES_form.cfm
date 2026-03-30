<script>
function desplegar(valor)
{
	if (valor == 0)
	{
	
		document.getElementById('spetqfecha').style.display = "";
		document.getElementById('spetqfecha1').style.display = "none";
		document.getElementById('spetqfecha2').style.display = "none";
		document.getElementById('spetqfecha3').style.display = "none";
	
		document.getElementById('sptiempoetq').style.display = "none";
		document.getElementById('sptiempo').style.display = "none";		
		document.getElementById('spdias').style.display = "none";		
		document.getElementById('spsemanas').style.display = "none";	
		document.getElementById('spmeses').style.display = "none";
		document.getElementById('spanos').style.display = "none";

		document.getElementById('tesorecursividadn').value = "";
	}
	else
	{
		document.getElementById('spetqfecha').style.display = "none";
		document.getElementById('spetqfecha1').style.display = "";	
		document.getElementById('spetqfecha2').style.display = "";
		document.getElementById('spetqfecha3').style.display = "";
	
		document.getElementById('sptiempoetq').style.display = "";
		document.getElementById('sptiempo').style.display = "";
		document.getElementById('spdias').style.display = "none";		
		document.getElementById('spsemanas').style.display = "none";	
		document.getElementById('spmeses').style.display = "none";
		document.getElementById('spanos').style.display = "none";		
		
		if (document.getElementById('tesorecursividadn').value == "")
			document.getElementById('tesorecursividadn').value = "1";
		if (valor == 1)
			document.getElementById('spdias').style.display = "";
		if (valor == 2)
			document.getElementById('spsemanas').style.display = "";	
		if (valor == 3)
			document.getElementById('spmeses').style.display = "";
		if (valor == 4)
			document.getElementById('spanos').style.display = "";
		
	}
}
</script>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("TESOid")>
	<cfparam name="form.TESOid" default="#TESOid#">	
<cfelse>
	<cfparam name="form.TESOid" default="">	
</cfif>


<cfif isdefined('form.TESOid') and len(trim(form.TESOid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo 
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>

<cfif modo NEQ 'ALTA'>

	<cfquery datasource="#session.dsn#" name="data">
		select A.*, B.Mnombre
		from  TESotrasEntradasSalidas A, Monedas B
		where A.Mcodigo = B.Mcodigo
		  and A.TESOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOid#">
		  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and A.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Tesoreria.TESid#">
	</cfquery>
	
	<!---
	<cfquery datasource="#session.dsn#" name="rsEmpresas">
		Select e.Ecodigo,e.Edescripcion,esdc.CEcodigo,te.TESid
		from Empresas e
			inner join Empresa esdc
				on esdc.Ecodigo=e.EcodigoSDC
			
			left outer join TESempresas te
				on te.Ecodigo=e.Ecodigo
		
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>--->
	
</cfif>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario)	{
			if (!btnSelected('Nuevo',document.form1)){
				var error_input;
				var error_msg = '';
				// Validando tabla: TESotrasEntradasSalidas - Flujos de Efectivo
		
				// Columna: TESOdescripcion Descripcion de la entrada y salida varchar(40)
				if (formulario.tesodescripcion.value == "") {
					error_msg += "\n - La descripcion no puede quedar en blanco.";
					error_input = formulario.tesodescripcion;
				}
	
				// Columna: TESOmonto Monto money
				if (formulario.tesomonto.value == "0.00" || formulario.tesomonto.value == "") {
					error_msg += "\n - El monto no puede quedar en cero.";
					error_input = formulario.tesomonto;
				}
				
				// Columna: TESOtipoCambio Tipo de Cambio Actual money
				if (formulario.tesotipoCambio.value == "0.0000" || formulario.tesotipoCambio.value == "") {
					error_msg += "\n - El tipo de cambio no puede quedar en cero.";
					error_input = formulario.tesotipoCambio;
				}				
						
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					error_input.focus();
					return false;
				}
			}

			return true;
		}
	//-->
	</script>
	
	<form action="OtrasES_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
		<table summary="Tabla de entrada">
		<tr>
			  <td valign="top" align="right"><strong>Tipo:</strong></td>
			  <td valign="top" colspan="3">
				<select name="tesoTipo" id="tesotipo" tabindex="1">
				<cfif modo NEQ 'ALTA'>
					<cfif data.TESOtipo eq "E">
						<option value="E" selected>Entrada</option>
						<option value="S">Salida</option>			
					<cfelse>
						<option value="E">Entrada</option>
						<option value="S" selected>Salida</option>
					</cfif>
				<cfelse>
					<option value="E">Entrada</option>
					<option value="S">Salida</option>
				</cfif>
				</select> 					
			  </td>
		</tr>
		<tr>
			  <td valign="top" align="right"><strong>Descripcion:</strong></td>
			  <td valign="top" colspan="4">
			
				<input name="tesodescripcion" id="tesodescripcion" type="text" tabindex="1"
					value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TESOdescripcion)#</cfif>" 
					maxlength="40"
					size="40"
					onfocus="this.select()"  
					>
			
			</td>
		</tr>
		<tr>
			  <td valign="top" align="right"><strong>Moneda:</strong></td>
			  <td valign="top" colspan="3">
			
					<cfif MODO EQ "ALTA">
						<cf_sifmonedas CrearMoneda="no" tabindex="1">
					<cfelse>
						<input type="text" name="tesoMnombre" 
							value="<cfoutput>#data.Mnombre#</cfoutput>"  size="30" maxlength="30" readonly="readonly" tabindex="-1">
						<input type="hidden" name="Mcodigo" value="<cfoutput>#data.Mcodigo#</cfoutput>">
					</cfif>
		
			  </td>
		</tr>
		<tr>
			  <td valign="top" align="right"><strong>Monto:</strong></td>
			  <td valign="top" colspan="3">
			
				<input name="tesomonto" id="tesomonto" type="text" tabindex="1" 
					value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TESOmonto)#<cfelse>0.00</cfif>" 
					maxlength="17"
					size="17" 					
					style="text-align: right;"
					onblur="javascript:fm(this,2);"
					onfocus="javascript:this.value=qf(this); this.select();"  
					onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					>
			
			</td>
		</tr>						
		<tr>
			  <td nowrap valign="top" align="right"><strong>Tipo de Cambio:</strong></td>
			  <td valign="top" colspan="32">
			
				<input name="tesotipoCambio" id="tesotipoCambio" type="text" tabindex="1" 
					value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TESOtipoCambio)#<cfelse>1.0000</cfif>" 
					maxlength="10"
					size="10"
					style="text-align: right;" 
					onblur="javascript:fm(this,4);"  
					onfocus="javascript:this.value=qf(this); this.select();"  
					onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
					>
			</td>
		</tr>						
		<tr>
			  <td valign="top" align="right"><strong>Frecuencia:</strong></td>
			  <td valign="top" colspan="3">
			
				<select name="tesorecursividad" id="tesorecursividad" onChange="javascript:desplegar(this.value)" tabindex="1">
				<cfif modo NEQ 'ALTA'>
					<cfif data.TESOrecursividad eq 0>
						<option value="0" selected>Una sola vez</option>
						<option value="1">Cada n días</option>
						<option value="2">Cada n semanas</option>
						<option value="3">Cada n meses</option>
						<option value="4">Cada n años</option>
					</cfif>
					<cfif data.TESOrecursividad eq 1>
						<option value="0">Una sola vez</option>
						<option value="1" selected>Cada n días</option>
						<option value="2">Cada n semanas</option>
						<option value="3">Cada n meses</option>
						<option value="4">Cada n años</option>					
					</cfif>
					<cfif data.TESOrecursividad eq 2>
						<option value="0">Una sola vez</option>
						<option value="1">Cada n días</option>
						<option value="2" selected>Cada n semanas</option>
						<option value="3">Cada n meses</option>
						<option value="4">Cada n años</option>					
					</cfif>
					<cfif data.TESOrecursividad eq 3>
						<option value="0">Una sola vez</option>
						<option value="1">Cada n días</option>
						<option value="2">Cada n semanas</option>
						<option value="3" selected>Cada n meses</option>
						<option value="4">Cada n años</option>					
					</cfif>
					<cfif data.TESOrecursividad eq 4>
						<option value="0">Una sola vez</option>
						<option value="1">Cada n días</option>
						<option value="2">Cada n semanas</option>
						<option value="3">Cada n meses</option>
						<option value="4" selected>Cada n años</option>
					</cfif>
				<cfelse>
						<option value="0">Una sola vez</option>
						<option value="1">Cada n días</option>
						<option value="2">Cada n semanas</option>
						<option value="3">Cada n meses</option>
						<option value="4">Cada n años</option>
				</cfif>
				</select> 
			
			</td>
		</tr>
		<tr>
			  <td valign="top" align="right">
				<cfif modo NEQ 'ALTA'>
					<cfif isdefined("data.TESOrecursividad") and data.TESOrecursividad eq 0>
						<cfset LvarStyleUnaFecha = "">
						<cfset LvarStyleDosFechas = "display:none;">
					<cfelse>
						<cfset LvarStyleUnaFecha = "display:none;">
						<cfset LvarStyleDosFechas = "">
					</cfif>
				<cfelse>
					<cfset LvarStyleUnaFecha = "">
					<cfset LvarStyleDosFechas = "display:none;">
				</cfif>
						
					<span id="spetqfecha" style="#LvarStyleUnaFecha#">
						<strong>Fecha:</strong>
					</span>
					<span id="spetqfecha1" style="#LvarStyleDosFechas#">
						<strong>Fecha de Inicio:</strong>
					</span>
			  </td>
			  <td valign="top" nowrap>			
					<cfif modo NEQ 'ALTA'>
						<cfset valor="#data.TESOfechaDesde#">
					<cfelse>
						<cfset valor="#LSDateFormat(Now(),'DD/MM/YYYY')#">
					</cfif>
					<cf_sifcalendario name="TESOfechaDesde" value="#LSDateFormat(valor,'DD/MM/YYYY')#" tabindex="1">
				</td><td id="spetqfecha2" nowrap style="#LvarStyleDosFechas#">
					<strong>Hasta:</strong>
				</td><td id="spetqfecha3" nowrap style="#LvarStyleDosFechas#">
					<cfif modo NEQ 'ALTA'>
						<cfset valor="#data.TESOfechaHasta#">
					<cfelse>
						<cfset valor="#LSDateFormat(Now(),'DD/MM/YYYY')#">
					</cfif>
					<cf_sifcalendario name="TESOfechaHasta" value="#LSDateFormat(valor,'DD/MM/YYYY')#" tabindex="1">
			  </td>
		</tr>		

		<tr>
			<td valign="top" align="right">
				<span id="sptiempoetq" style="display:none ">
					<strong>Cada:</strong>
				</span>				
			</td>
			<td valign="top" colspan="3">
				<cfif isdefined("data.TESOrecursividad") and data.TESOrecursividad neq 0>
								
					<span id="sptiempo" style="display:none">
					<input type="text" name="tesorecursividadn" id="tesorecursividadn" tabindex="1"
						value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TESOrecursividadN)#</cfif>"
						maxlength="10"
						size="10"
						style="text-align: right;">		
					</span>
					<span id="spdias" style="display:none">días</span>
					<span id="spsemanas" style="display:none">semanas</span>
					<span id="spmeses" style="display:none">meses</span>
					<span id="spanos" style="display:none">años</span>				
					
					<script>desplegar('#data.TESOrecursividad#');</script>
					
				<cfelse>
					<span id="sptiempo" style="display:none">
					<input type="text" name="tesorecursividadn" id="tesorecursividadn" tabindex="1"
						value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TESOrecursividadN)#</cfif>"
						maxlength="10"
						size="10"
						style="text-align: right;">		
					</span>
					<span id="spdias" style="display:none">días</span>
					<span id="spsemanas" style="display:none">semanas</span>
					<span id="spmeses" style="display:none">meses</span>
					<span id="spanos" style="display:none">años</span>
				</cfif>
			</td>
		</tr>
		<tr>
			  <td valign="top" align="right"> 
			  	<cfif modo NEQ 'ALTA'>
					<input type="checkbox" name="chk_activo" id="chk_activo" <cfif data.TESOactivo EQ 1>checked</cfif> tabindex="1">
				<cfelse>
					<input type="checkbox" name="chk_activo" id="chk_activo" checked tabindex="1">
				</cfif></td>
			  <td valign="top" colspan="3"><label for="chk_activo" style="font-style:normal; font-variant:normal; ">Activo</label></td>
		</tr>
		<tr>
			<td colspan="4" class="formButtons">
			<cfif modo NEQ 'ALTA'>
				<cf_botones modo='CAMBIO' tabindex="1">
			<cfelse>
				<cf_botones modo='ALTA' tabindex="1">
			</cfif>
		</td></tr>
		</table>
		<cfif modo NEQ 'ALTA'>
			<input type="hidden" name="TESOid" value="#HTMLEditFormat(data.TESOid)#">
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
			
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">		
		</cfif>
	</form>
</cfoutput>
<script type="text/javascript">
	<cfif modo NEQ 'ALTA'>
		document.form1.tesoTipo.focus();
	<cfelse>
	document.frmTES.TESid.focus();
	</cfif>
</script>