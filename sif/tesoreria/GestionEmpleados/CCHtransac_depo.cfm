<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoDepositar" default = "Monto a Depositar" returnvariable="LB_MontoDepositar" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoDepositado" default = "Monto Depositado" returnvariable="LB_MontoDepositado" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Deposito" default = "Dep&oacute;sito" returnvariable="LB_Deposito" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaBancaria" default = "Cuenta Bancaria" returnvariable="LB_CuentaBancaria" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoDeposito" default = "Monto Dep&oacute;sito" returnvariable="LB_MontoDeposito" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Aplicar" default = "Aplicar" returnvariable="BTN_Aplicar" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Transaccion" default = "Transacci&oacute;n" returnvariable="LB_Transaccion" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Bancos" default = "Bancos" returnvariable="LB_Bancos" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoCambio" default = "Tipo de Cambio" returnvariable="LB_TipoCambio" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_FactorConv" default = "Factor de conv" returnvariable="LB_FactorConv" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoDeposito" default = "Monto Dep&oacute;sito" returnvariable="LB_MontoDeposito" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Ingresar" default = "Ingresar" returnvariable="BTN_Ingresar" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Regresar" default = "Regresar" returnvariable="BTN_Regresar" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Nuevo" default = "Nuevo" returnvariable="BTN_Nuevo" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Modificar" default = "Modificar" returnvariable="BTN_Modificar" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Eliminar" default = "Eliminar" returnvariable="BTN_Eliminar" xmlfile = "CCHtransac_depo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DeseaEliminarElRegistro" default = "Desea Eliminar el Registro" returnvariable="MSG_DeseaEliminarElRegistro" xmlfile = "CCHtransac_depo.xml">




<cfif isdefined ('url.CCHTid') and not isdefined('form.CCHTid')>
	<cfset form.CCHTid=#url.CCHTid#>
</cfif>

<cfif isdefined ('url.CCHid') and not isdefined('form.CCHid')>
	<cfset form.CCHid=#url.CCHid#>
</cfif> 

<cfif isdefined ('url.CCHDid') and not isdefined('form.CCHDid')>
	<cfset form.CCHDid=#url.CCHDid#>
</cfif> 

<cfif isdefined ('url.mensajeDep')>
	<script language="javascript">
 		alert("El numero de referencia ya existe por lo tanto no se puede repetir");
	</script>
</cfif>

<cfquery name="rsMoneda" datasource="#session.dsn#">
	select Mcodigo from CCHica where CCHid= (select min(CCHid) from CCHTransaccionesProceso where CCHTid=#form.CCHTid#)
	and Ecodigo=#session.Ecodigo#
</cfquery>

<cfquery name="rsMonedaLocalE" datasource="#Session.DSN#">
	select Miso4217 from Monedas where Mcodigo= #rsMoneda.Mcodigo#		
</cfquery>

			
		
<cfif isdefined ('form.CCHDid')>
	<cfset modo='CAMBIO'>
<cfelse>	
	<cfset modo='ALTA'>
		<cfquery name="rsDepo" datasource="#session.dsn#">
			select
			CCHTid,
			CCHid,
			CCHTtipo,
			BMfecha          
		from CCHTransaccionesProceso ct
		where CCHTid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CCHTid#">
		</cfquery>
	</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="rsDepo" datasource="#session.dsn#">
			select
			ct.CCHid,
			ct.BMfecha,
			a.CCHDid,
			a.CCHTid,          
			a.CCHDreferencia,  
			a.CCHDlinea,       
			a.Ecodigo,  
			a.CBid,  
			a.BTid,              
			a.CCHDfecha,      
			a.CCHDtipoCambio,  
			a.CCHDtotalOri,  
			a.CCHDtotal,
			a.CBid as Cuenta,                     
			a.Mcodigo,
			ct.CCHTtipo,
			(select Miso4217 from Monedas where Mcodigo=a.Mcodigo) as Miso4217,
			ct.CCHTtipo
		from CCHdepositos a 
			inner join CCHTransaccionesProceso ct
			on ct.CCHTid=a.CCHTid
		where a.CCHDid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CCHDid#">
	</cfquery>
	
	<cfquery name="selectEncabezado" datasource="#session.dsn#">
			select Mcodigo from CCHica	where CCHid=#rsDepo.CCHid#
</cfquery>
</cfif>

<cfquery name="rsDepoL" datasource="#session.dsn#">
	select
		a.CCHDid,
		a.CCHTid,          
		a.CCHDreferencia,  
		a.CCHDlinea,       
		a.Ecodigo,                  
		a.CCHDfecha,      
		a.CCHDtipoCambio,  
		a.CCHDtotalOri,  
		a.CCHDtotal,
		a.CBid,                     
		a.Mcodigo,
		(select CBcodigo from CuentasBancos where CBid=a.CBid and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">) as Cuenta,
		(select Miso4217 from Monedas where Mcodigo=a.Mcodigo) as Miso4217,
		ct.CCHTtipo
	from CCHdepositos a 
		inner join CCHTransaccionesProceso ct
		on ct.CCHTid=a.CCHTid
	where a.CCHTid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CCHTid#">
</cfquery>

<cfquery name="rsDepoT" datasource="#session.dsn#">
	select sum(CCHDtotalOri) as total 
	from CCHdepositos a 
	where a.CCHTid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.CCHTid#">
</cfquery>

		<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select 
				<cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo 
			from 
				Empresas
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<cfquery name="rsTot" datasource="#session.dsn#">
	select CCHTmonto from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
</cfquery>

<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<table width="55%"  align="left">
		<tr>
			<cfoutput>
			<td valign="top"><strong><font  color="666666" style="background-color:CCCCCC">#LB_MontoDepositar#:#rsTot.CCHTmonto##rsMonedaLocalE.Miso4217#</font></strong>
			<strong><font  color="666666" style="background-color:CCCCCC">#LB_MontoDepositado#:#rsDepoT.total##rsMonedaLocalE.Miso4217#</font></strong></td>
			</cfoutput>
		</tr>
		<tr>
			<td  valign="top">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsDepoL#"
				desplegar="CCHDreferencia,CCHDfecha,Cuenta, Miso4217,CCHDtotalOri"
				etiquetas="#LB_Deposito#, #LB_Fecha#, #LB_CuentaBancaria#, #LB_MontoDeposito#, #LB_Monto#"
				formatos="S,D,S,S,M"
				align="left,left,left,left,left"
				ira="CCHtransac.cfm?CCHTtipo=#form.CCHTtipo#&CCHTestado='POR CONFIRMAR'&CCHTid=#form.CCHTid#"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="CCHDid,CCHTid,CCHTtipo"
				incluyeForm="yes"
				formName="formDepo"
				PageIndex="1"
				MaxRows="7"	
				navegacion="&CCHTid=#form.CCHTid#"/>
			</td>
		</tr>		
		<tr>
  <form action="CCHtransac_sql.cfm" method="post" name="formDep" style="border:0px;" id="formDep" onSubmit="return validarDep(this);" >
			<cfoutput>
			<td>
				<input type="submit" value="#BTN_Aplicar#" name="Confirmar" onClick="javascript: inhabilitarValidacion(); "  />
			</td>
			</cfoutput>
		</tr>
	</table>

 
	<cfoutput>	
		<cfif isdefined ('form.CCHTid')>
			<input type="hidden" value="#form.CCHTid#"  name="CCHTid" />
			<input type="hidden" value="#rsDepo.CCHid#"  name="CCHid" />
			<input type="hidden" value="#rsDepo.BMfecha#"  name="BMfecha" />
			<input type="hidden" value="#rsDepo.CCHTtipo#"  name="CCHTtipo" />
			<cfif isdefined ('rsDepo.CCHDid')>
			<input type="hidden" value="#rsDepo.CCHDid#"  name="CCHDid" />
			</cfif>
			<input type="hidden" value="#rsTot.CCHTmonto#" name="montoT" />
		</cfif>
	</cfoutput>	
	<table width="45%" align="center">	
		<cfoutput>
			<!---Depósito--->
			<tr>
				<td  align="right" valign="top" width="45%">
					<strong>#LB_Deposito#: </strong>
				</td>
				<td >
					<cfif modo eq 'ALTA'>
					<input type="text" align="right" name="referencia" id="referencia" maxlength="30"  />
					<cfelse>
					<input type="text" align="right" name="referencia" id="referencia" maxlength="30" value="#rsDepo.CCHDreferencia#"/>
					</cfif>
				</td>
			</tr>
			<!---Fecha --->	
			<tr>	
				<td  align="right">
					<strong>#LB_Fecha#:</strong>
				</td>
				<td>
					<cfif modo eq 'ALTA'>
						<cfset fechadep = LSDateFormat(Now(),'dd/mm/yyyy')>
					<cfelse>
						<cfset fechadep = LSDateFormat(#rsDepo.CCHDfecha#,'dd/mm/yyyy')>
					</cfif>
					<cf_sifcalendario form="formDep" value="#fechadep#" name="fechadep" tabindex="1">
				</td>
			</tr>
		</cfoutput>
			<!---Transaccion --->	
			<cfquery name="rsBTid" datasource="#session.dsn#">
				select BTcodigo,BTid,substring(rtrim(BTdescripcion),1,21) as BTdescripcion from BTransacciones 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
				and BTtipo='D' and BTcodigo  not in('PA','XC','XT','TF')
			</cfquery>
			<tr>	
				<td  align="right">
					<strong>#LB_Transaccion#:</strong>
				</td>
				<td>
					<select name="BTid">  
						<cfif rsBTid.RecordCount>
							<cfoutput query="rsBTid" group="BTcodigo">
								<option value="#rsBTid.BTid#" <cfif modo neq "ALTA" and rsBTid.BTid  eq rsDepo.BTid>selected="selected"</cfif>>#rsBTid.BTdescripcion#</option>
							</cfoutput>
						</cfif>
					</select>
				</td>
			</tr>
		<cfoutput>
		<!---cuentabancaria--->	
		<tr>
			<td nowrap="nowrap"  align="right">
				<strong>#LB_CuentaBancaria#:</strong>
			</td>
			<td>	
					<cfquery name="rsGE" datasource="#session.DSN#">
						select a.CBid, a.Bid,a.CBcodigo, a.CBdescripcion,b.Bdescripcion,a.Mcodigo, m.Miso4217
						from CuentasBancos a 
							inner join Monedas m
							on m.Mcodigo = a.Mcodigo
							inner join Bancos b  
							on a.Bid= b.Bid 
						where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 	
                        	and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
						order by b.Bdescripcion
					</cfquery>	
			</cfoutput>
			
			<select name="CBid" onchange="CambiaMoneda()">
				<option value="" selected> - <cfoutput>#LB_Bancos#</cfoutput> - </option>
				<cfif rsGE.RecordCount>
					<cfoutput query="rsGE" group="Bdescripcion">
						<optgroup label="#rsGE.Bdescripcion#">
							<cfoutput>
								<option value="#rsGE.CBid#|#rsGE.Mcodigo#"  <cfif modo neq "ALTA" and rsGE.CBid EQ rsDepo.CBid> selected</cfif> > #rsGE.Miso4217# - #rsGE.CBcodigo#</option>									
							</cfoutput>
						</optgroup>
					</cfoutput>
				</cfif>
				</select>		
			</td>
		</tr>
		<cfoutput>

		<!---monto--->
	<tr>
		<td valign="top"  align="right"><strong>#LB_Monto#: </strong></td>
			<td>
				<cfset valor_dep = 0 >
					<cfif modo neq 'ALTA'>
						<cfset valor_dep = LSNumberFormat(abs(rsDepo.CCHDtotal),"0.00") >
					</cfif>
				<cf_inputNumber name="montodep" value="#valor_dep#" size="20" enteros="13" decimales="2" onChange="CambiaMonto()" onFocus="this.value=qf(this); this.select();" >
					<input name="LvarMo" id="LvarMo"
						class="ListaPar"
						style="text-align:left; border:none; padding-left:0px; background-color:inherit;"
						size="4"
						readonly="yes"
						tabindex="-1"
						border="0"
						value="<cfif modo neq 'ALTA'>#rsDepo.Miso4217#</cfif>"
					>


			</td>
	</tr>


	<!--- <input type="text" id="xx" name="xx" value="#rsGE.Miso4217#" /> --->
<!---Tipo de cambio--->
		<tr>	
			<td nowrap="nowrap"  align="right"><strong>#LB_TipoCambio#:</strong></td>
				<td>
				 	<input type="text" name="tipoCambio" 
					id="tipoCambio"
					maxlength="10" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.CCHDtipoCambio,",0.0")#</cfif>"
					style="text-align:right;" 
					onfocus="this.value=qf(this); this.select();" 
					tabindex="1" 
					onchange=" CambiaTipo()"
					<cfif modo neq "Alta">
						<cfif #rsDepo.Mcodigo# eq #selectEncabezado.Mcodigo# and #rsDepo.Mcodigo# eq #rsMonedaLocal.Mcodigo# 
						or  #selectEncabezado.Mcodigo# eq #rsMonedaLocal.Mcodigo# and #rsDepo.Mcodigo# neq #rsMonedaLocal.Mcodigo# 
						or #selectEncabezado.Mcodigo# neq #rsMonedaLocal.Mcodigo# and #rsDepo.Mcodigo# eq #rsMonedaLocal.Mcodigo#
						or #selectEncabezado.Mcodigo# eq #rsDepo.Mcodigo#>		
					disabled="disabled"
					<cfelseif  #selectEncabezado.Mcodigo# neq #rsDepo.Mcodigo#>
					</cfif>
					</cfif>/>
				</td>
		</tr>

		
<!---Factor de conversion--->
		<tr>			
				<td nowrap="nowrap"  align="right"><strong>#LB_FactorConv#:</strong></td>
				<td >
				 	<input type="text" name="factor" 
					id="factor"
					maxlength="10" 
					onchange="CambiaFactor()" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.CCHDtipoCambio,",0.0")#</cfif>"
					 style="text-align:right;" 
					onfocus="this.value=qf(this); this.select();" 
					tabindex="1" 
					<cfif modo neq "Alta">
					<cfif #rsDepo.Mcodigo# eq #selectEncabezado.Mcodigo# and #rsDepo.Mcodigo# eq #rsMonedaLocal.Mcodigo# 
						or  #selectEncabezado.Mcodigo# eq #rsMonedaLocal.Mcodigo# and #rsDepo.Mcodigo# neq #rsMonedaLocal.Mcodigo# 
						or #selectEncabezado.Mcodigo# neq #rsMonedaLocal.Mcodigo# and #rsDepo.Mcodigo# eq #rsMonedaLocal.Mcodigo#
						or #selectEncabezado.Mcodigo# eq #rsDepo.Mcodigo#>
					disabled="disabled"
					<cfelseif  #selectEncabezado.Mcodigo# neq #rsDepo.Mcodigo#>
					</cfif>
					</cfif> />
				</td>
		</tr>	
<!---Monto en moneda liquidante--->
		<tr>			
				<td nowrap="nowrap"  align="right"><strong>#LB_MontoDeposito#:</strong></td>
				<td >
				 	<input type="text" name="totalD" 
					id="liqui"
					maxlength="10" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.CCHDtotalOri,",0.0")#</cfif>"
					style="text-align:right;" 
					onfocus="this.value=qf(this); this.select();" 
					tabindex="1" 
					disabled="disabled" />
				</td>
		</tr>	
		<tr >
			<td align="center" nowrap="nowrap" colspan="4">
				<cfif modo eq 'ALTA'>
				<input type="submit" name="Ingresar" value="#BTN_Ingresar#" onClick="javascript: habilitarValidacion(); " />
				<input type="submit" name="RegresarD" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
				<cfelse>
				<input type="submit" name="NuevoD" value="#BTN_Nuevo#" onClick="javascript: inhabilitarValidacion(); " />
				<input type="submit" name="ModificarD" value="#BTN_Modificar#" onClick="javascript: habilitarValidacion(); " />
				<input type="submit" name="EliminarD" value="#BTN_Eliminar#" onClick="return confirm('¿Desea eliminar el registro de Depósito?');"/>
				<input type="submit" name="RegresarD" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); " />
				</cfif>				
			</td>
		</tr>
		</cfoutput>
		</table>
	</form>
	
<iframe name="monedax" id="monedax" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>


<cf_qforms form="formDep">


<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
		objForm.fechadep.required = false;	
		objForm.CBid.required = false;			
		objForm.referencia.required = false;	
		objForm.montodep.required = false;	
		objForm.tipoCambio.required=false;
		objForm.factor.required=false;
		objForm.totalD.required=false;
		
	}

	function habilitarValidacion() {
		objForm.fechadep.required = true;	
		objForm.CBid.required = true;			
		objForm.referencia.required = true;	
		objForm.montodep.required = true;	
		objForm.tipoCambio.required=true;
		objForm.factor.required=true;
		objForm.totalD.required=true;	
		
		objForm.fechadep.description = "Fecha de Depósito";
		objForm.CBid.description = "Cuenta Bancaria";		
		objForm.referencia.description = "Referencia";
		objForm.montodep.description = "Monto del Depósito";
		objForm.tipoCambio.description = "Tipo de Cambio";
		objForm.factor.description = "Factor de Conversión";
		objForm.totalD.description = "Monto total del Depósito";	
		
	}
</script>


<script language="javascript">

function funcBajaAnt(){
return confirm("#MSG_DeseaEliminarElRegistro#?")
return true;
}

function CambiaMoneda(m){
		moneda = document.formDep.CBid.value.split('|')[1];
		id_caja=document.formDep.CCHid.value;
		fecha=document.formDep.BMfecha.value;
		document.getElementById('monedax').src = 'CambiaMonedaCCH.cfm?Mcodigo='+moneda+'&id_caja='+id_caja+'&Fecha='+fecha+'';
	}

function CambiaTipo(m){
		tipo=document.formDep.tipoCambio.value;
		moneda = document.formDep.CBid.value.split('|')[1];
		id_caja=document.formDep.CCHid.value;
		fecha=document.formDep.BMfecha.value;
		document.getElementById('monedax').src = 'CambiaMonedaCCH.cfm?Mcodigo='+moneda+'&id_caja='+id_caja+'&Fecha='+fecha+'&tipo='+tipo+'';
	}
	
function CambiaMonto(m){
		tipo=document.formDep.tipoCambio.value;
		monto=document.formDep.montodep.value;
		moneda = document.formDep.CBid.value.split('|')[1];
		id_caja=document.formDep.CCHid.value;
		fecha=document.formDep.BMfecha.value;
		document.getElementById('monedax').src = 'CambiaMonedaCCH.cfm?Mcodigo='+moneda+'&id_caja='+id_caja+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'';
}
	
function CambiaFactor(m){
		tipo=document.formDep.tipoCambio.value;
		monto=document.formDep.montodep.value;
		moneda = document.formDep.CBid.value.split('|')[1];
		id_caja=document.formDep.CCHid.value;
		fecha=document.formDep.BMfecha.value;
		factor=document.formDep.factor.value;
		document.getElementById('monedax').src = 'CambiaMonedaCCH.cfm?Mcodigo='+moneda+'&id_caja='+id_caja+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&factor='+factor+'';
}

function validarDep(){
//	if (document.formDep.totalD.value <= 0){
	//	alert ('El monto del depósito debe ser mayor que cero');
		//return false;
	//
	document.formDep.totalD.disabled=false;
	document.formDep.tipoCambio.disabled=false;
	document.formDep.montodep.value = qf(formulario.montodep);
	document.formDep.totalD.value = qf(formulario.liqui);

	if(formulario.tipoCambio.disabled)
	document.formDep.tipoCambio.disabled =false;
	document.formDep.factor.disabled=false;
	document.formDep.totalD.disabled=false;
	return true;

}
function irA(){
document.formDep.submit('Confirmar')
}
</script>
