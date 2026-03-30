<!---VARIABLES--->
	<cfset btnNameArriba = "">
	<cfset btnValuesArriba= "">
	<cfset btnNameAbajo = "">
	<cfset btnValuesAbajo= "">
	<cfparam name="GELid" default="">
	<cfif isdefined ('url.Dep') and not isdefined('form.GELDid')>
		<cfset form.GELDid=#url.Dep#>
	</cfif>
<!---DEFINICIONES--->
	<cfif isdefined('form.GELDid')>
		<cfset modo = 'CAMBIO'>
	<cfelse>
		<cfset modo = 'ALTA'>
	</cfif>

	<cfif isdefined ('url.mensajeDep')>
		<script language="javascript">
			alert("El numero de referencia ya existe por lo tanto no se puede repetir");
		</script>
	</cfif>
<!---<cfdump var="#form#">--->
<!---SELECTS--->
	<cfif modo eq 'CAMBIO'>
		<cfquery name="rsDepo" datasource="#session.dsn#">
			select GELid,
				a.Ecodigo,
				a.BMUsucodigo,
				a.CBid,
				a.GELDid,
				a.GELDreferencia,
				a.GELDtotalOri,
				a.GELDfecha,
				a.GELDtipoCambio,
				a.Mcodigo,
				a.GELDtotal,
				a.BTid,
				m.Miso4217
			from GEliquidacionDeps a 
				inner join Monedas m
				on m.Mcodigo=a.Mcodigo
			where GELDid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.GELDid#">
		</cfquery>
	

<!---Validaciones de campos--->
		<cfquery name="selectEncabezado" datasource="#session.dsn#">
			select * from GEliquidacion 
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		</cfquery>
		<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select 
				<cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo 
			from 
				Empresas
			where 
				Ecodigo = #session.Ecodigo#
		</cfquery>
		
	</cfif>

<cfquery datasource="#session.dsn#" name="listaDep">
	select 
			a.GELDid,
			a.GELDreferencia,
			a.GELDtotalOri,
			a.GELid,
			a.GELDfecha,
			m.Miso4217,
			a.CBid,
			a.Mcodigo,
			b.CBid,
			b.CBcodigo,
			1 as Det  
		from GEliquidacionDeps a, Monedas m,CuentasBancos b 
		where 
			GELid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GELid#">
			and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
            and a.Mcodigo= m.Mcodigo
			and a.CBid=b.CBid
	</cfquery>

<!---LISTA--->
<table width="55%"  align="left">
	<tr>
		<td  valign="top">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#listaDep#"
				desplegar="GELDreferencia,GELDfecha,CBcodigo,Miso4217,GELDtotalOri"
				etiquetas="Dep&oacute;sito, Fecha, Cuenta, Moneda, Monto"
				formatos="S,D,S,S,M"
				align="left,left,left,left,left"
				ira="LiquidacionAnticipos#LvarSAporEmpleadoSQL#.cfm?tab=3"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="GELDid"
				incluyeForm="yes"
				formName="formDepo"
				PageIndex="3"
				MaxRows="5"	
				navegacion="&GELid=#form.GELid#"/>
		</td>
	</tr>
	
</table>
	
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfoutput>	
<form action="Tab3_Depositos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" method="post" name="formDep" style="border:0px;" onSubmit="return validarDep(this);" id="formDep">
 
<table width="45%" align="right">	
	
<!---Depósito--->
	<tr>
		<td width="28%" align="right" valign="top"><strong>Dep&oacute;sito: </strong></td>
		<td width="69%">
			<input type="text" align="right" name="referencia" id="referencia" maxlength="30" value="<cfif modo NEQ "ALTA"> #rsDepo.GELDreferencia#</cfif>" />
		</td>
		<td width="3%"></td>
	</tr>
<!---Fecha --->	
	<tr>	
		<td  align="right"><strong>Fecha:</strong></td>
			<td>
				<cfset fechadep = LSDateFormat(Now(),'dd/mm/yyyy')>
					<cfif modo NEQ 'ALTA'>
						<cfset fechadep = LSDateFormat(rsDepo.GELDfecha,'dd/mm/yyyy') >
					</cfif>
				<cf_sifcalendario form="formDep" value="#fechadep#" name="fechadep" tabindex="1">
			</td>
	</tr>
</cfoutput>
<!---Transaccion --->	
	<cf_dbfunction name="spart" args="BTdescripcion,1,21" returnvariable="LvarSubstring">
	<cfquery name="rsBTid" datasource="#session.dsn#">
		select BTcodigo,BTid,rtrim(#LvarSubstring#) as BTdescripcion from BTransacciones 
		where Ecodigo=#session.ecodigo#
		and BTtipo='D' and BTcodigo  not in('PA','XC','XT','TF')
	</cfquery>
	<tr>	
		<td  align="right"><strong>Transacci&oacute;n:</strong></td>
			<td>
				<select name="BTid">  
					<cfif rsBTid.RecordCount>
						<cfoutput query="rsBTid" group="BTcodigo">
							<option value="#rsBTid.BTid#"<cfif modo neq "ALTA" and rsBTid.BTid  eq rsDepo.BTid>selected="selected"</cfif>>#rsBTid.BTdescripcion#</option>
						</cfoutput>
					</cfif>
				</select>
			</td>
	</tr>
<cfoutput>
	<!---cuentabancaria--->	
	<input type="hidden" name="GELid" id="GELid" value="<cfif isdefined ("form.GELid")>#form.GELid#</cfif>"/>
	<tr>
		<td nowrap="nowrap"  align="right"><strong>Cuenta Bancaria:</strong></td>
		<td>	
					<cfquery name="rsGE" datasource="#session.DSN#">
							select a.CBid, a.Bid,a.CBcodigo, a.CBdescripcion,b.Bdescripcion,a.Mcodigo, m.Miso4217
							  from CuentasBancos a 
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo
								inner join Bancos b  
									on a.Bid= b.Bid 
							 where a.Ecodigo= #session.Ecodigo# 
                             	and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
							 order by b.Bdescripcion
					</cfquery>	
			</cfoutput>
				
			<select name="CBid" onchange="CambiaMoneda()">
			<option value="" selected> - Bancos - </option>
					<cfif rsGE.RecordCount>
						<cfoutput query="rsGE" group="Bdescripcion"><!---me imprime el encabezado pero siempre lo recorre--->
							<optgroup label="#rsGE.Bdescripcion#">
							<!---<option value="b, "selected>(Todos los grupos de bancos)</option>--->
								<cfoutput><!---me imprime lo q contiene cada parte del encabeado,value es lo que le voy a mandar al sql y lo demas es lo que quiero q me imprima--->
									<option value="#rsGE.CBid#|#rsGE.Mcodigo#" <cfif modo neq "ALTA" and rsGE.CBid EQ rsDepo.CBid> selected</cfif>> #rsGE.Miso4217# - #rsGE.CBcodigo#</option>									
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
		<td valign="top"  align="right"><strong>Monto: </strong></td>
			<td>
				<cfset valor_dep = 0 >
					<cfif modo neq 'ALTA'>
						<cfset valor_dep = LSNumberFormat(abs(rsDepo.GELDtotalOri),"0.00") >
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
			<td nowrap="nowrap"  align="right"><strong>Tipo de Cambio:</strong></td>
				<td>
				 	<input type="text" name="tipoCambio" 
					id="tipoCambio"
					maxlength="10" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.GELDtipoCambio,",0.0")#</cfif>"
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
				<td nowrap="nowrap"  align="right"><strong>Factor de conv:</strong></td>
				<td >
				 	<input type="text" name="factor" 
					id="factor"
					maxlength="10" 
					onchange="CambiaFactor()" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.GELDtipoCambio,",0.0")#</cfif>"
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
				<td nowrap="nowrap"  align="right"><strong>Monto Liquidaci&oacute;n:</strong></td>
				<td >
				 	<input type="text" name="liqui" 
					id="liqui"
					maxlength="10" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.GELDtotal,",0.0")#</cfif>"
					style="text-align:right;" 
					onfocus="this.value=qf(this); this.select();" 
					tabindex="1" 
					disabled="disabled" />
				</td>
		</tr>	

<!---botones--->
	<!---<table align="center">--->
		<tr >
			<td align="right" nowrap="nowrap" colspan="4">
				<cfif modo EQ "ALTA">
					<cfset btnNameArriba 			= "AltaDep,">
					<cfset btnValuesArriba			= "Agregar,">
					<cfset btnNameArriba 			= btnNameArriba & "Limpiar">
					<cfset btnValuesArriba			= btnValuesArriba &"Limpiar">
					<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">	
					<cfset btnExcluirArriba			=btnExcluirAbajo>
					<cf_botones modo="#modo#" includevalues="#btnValuesArriba#" include="#btnNameArriba#" exclude="#btnExcluirArriba#" >
				<cfelse>
					<input type="hidden" name="GELDid" value="#HTMLEditFormat(rsDepo.GELDid)#" />
					<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">
					<cfset btnNameAbajo				= btnNameAbajo&",BajaDep">
					<cfset btnValuesAbajo			= btnValuesAbajo&",Eliminar">
					<cfset btnNameAbajo				= btnNameAbajo&",CambioDep">
					<cfset btnValuesAbajo			= btnValuesAbajo&",Modificar">
					<cfset btnNameAbajo				= btnNameAbajo&",NuevoDep">
					<cfset btnValuesAbajo			= btnValuesAbajo&",Nuevo">
					<cf_botones modo="#modo#" includevalues="#btnValuesAbajo#" include="#btnNameAbajo#" exclude="#btnExcluirAbajo#" >
				</cfif>
			</td>
		</tr>
	<!---	</table>--->
</cfoutput>

<iframe name="monedax" id="monedax" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>



</table>
</form>

<script language="javascript">

function CambiaMoneda(m){
		moneda = document.formDep.CBid.value.split('|')[1];
		id_liqui=document.formDep.GELid.value;
		fecha=document.formDep.fechadep.value;
		document.getElementById('monedax').src = 'CambiaMoneda.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'';
	}

function CambiaTipo(m){
		tipo=document.formDep.tipoCambio.value;
		moneda = document.formDep.CBid.value.split('|')[1];
		id_liqui=document.formDep.GELid.value;
		fecha=document.formDep.fechadep.value;
		document.getElementById('monedax').src = 'CambiaMoneda.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'';
	}
	
function CambiaMonto(m){
		tipo=document.formDep.tipoCambio.value;
		monto=document.formDep.montodep.value;
		moneda = document.formDep.CBid.value.split('|')[1];
		id_liqui=document.formDep.GELid.value;
		fecha=document.formDep.fechadep.value;
		document.getElementById('monedax').src = 'CambiaMoneda.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'';
}
	
function CambiaFactor(m){
		tipo=document.formDep.tipoCambio.value;
		monto=document.formDep.montodep.value;
		moneda = document.formDep.CBid.value.split('|')[1];
		id_liqui=document.formDep.GELid.value;
		fecha=document.formDep.fechadep.value;
		factor=document.formDep.factor.value;
		document.getElementById('monedax').src = 'CambiaMoneda.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&factor='+factor+'';
}
</script>

	
<!---VALIDACIONES--->	
	<script type="text/javascript">
	<!--
	function validarDep(formulario)	{
	if (!btnSelected('Nuevo',document.formDep) && !btnSelected('BajaDep',document.formDep)){
	var error_input = null;;
	var error_msg = '';
				
				if (formulario.fechadep.value == "") 
				{
				error_msg += "\n - La fecha  no puede quedar en blanco.";
				error_input = formulario.fechadep;
				}
				
				if (formulario.CBid.value == "") 
				{
				error_msg += "\n - Debe seleccionar un Banco.";
				error_input = formulario.CBid;
				}
				if (formulario.referencia.value == "") 
				{
				error_msg += "\n - La referencia quedar en blanco.";
				error_input = formulario.referencia;
				}
				if (formulario.montodep.value == "") 
				{
				error_msg += "\n - El monto no puede quedar en blanco.";
				error_input = formulario.montodep;
				}	
					else if (parseFloat(formulario.montodep.value) <= 0)
					{
					error_msg += "\n - El monto solicitado debe ser mayor que cero.";
			}
				if (formulario.tipoCambio.value == "") 
				{
				error_msg += "\n - El tipo de cambio  no puede quedar en blanco.";
				error_input = formulario.tipoCambio;
				}
				else if (parseFloat(formulario.tipoCambio.value) <= 0)
					{
					error_msg += "\n - El Tipo de Cambio debe ser mayor que cero.";
			}
				if (formulario.factor.value == "") 
				{
				error_msg += "\n - El factor de conversión  no puede quedar en blanco.";
				error_input = formulario.factor;
				}
				else if (parseFloat(formulario.factor.value) <= 0)
					{
					error_msg += "\n - El Factor debe ser mayor que cero.";
			}
				if (formulario.liqui.value == "") 
				{
				error_msg += "\n - OJO---------Esto es algo que falta revisar?????.";
				error_input = formulario.liqui;
				}
				
				// Validacion terminada


		if (error_msg.length != "") {
		alert("Por favor revise los siguiente datos:"+error_msg);
		try 
		{
		error_input.focus();
		} 
		catch(e) 
		{}
		
		return false;
		}
		
		}
	formulario.montodep.value = qf(formulario.montodep);
	formulario.liqui.value = qf(formulario.liqui);
	formulario.liqui.disabled=false;

	if(formulario.tipoCambio.disabled)
	formulario.tipoCambio.disabled =false;
		formulario.factor.disabled=false;
		formulario.liqui.disabled=false;
	return true;

	}
		
</script>


