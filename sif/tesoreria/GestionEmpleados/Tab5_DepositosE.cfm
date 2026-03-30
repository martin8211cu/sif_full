<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Caja" Default="Caja" returnvariable="LB_Caja" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Comprobante" Default="Comprobante" returnvariable="LB_Comprobante" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default="Moneda" returnvariable="LB_Moneda" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CajaChica" Default="Caja Chica" returnvariable="LB_CajaChica" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CajaEspecialEfectivo" Default="Caja Especial Efectivo" returnvariable="LB_CajaEspecialEfectivo" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CajaExterna" Default="Caja Externa" returnvariable="LB_CajaExterna" 
xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RevisaDatos" Default="Por favor revise los siguiente datos" 
returnvariable="LB_RevisaDatos" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoCajaEfectivo" Default="Debe seleccionar una Caja de Efectivo" 
returnvariable="LB_CampoCajaEfectivo" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoReferencia" Default="La referencia no debe quedar en blanco" 
returnvariable="LB_CampoReferencia" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoMonto" Default="El monto solicitado no debe quedar en blanco" 
returnvariable="LB_CampoMonto" xmlfile = "Tab5_DepositosE.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoMontoMayor0" Default="El monto solicitado debe ser mayor que cero" 
returnvariable="LB_CampoMontoMayor0" xmlfile = "Tab5_DepositosE.xml"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoTipoCambio" Default="El tipo de cambio  no puede quedar en blanco" 
returnvariable="LB_CampoTipoCambio" xmlfile = "Tab5_DepositosE.xml"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoFactorConversion" Default="El factor de conversión  no puede quedar en blanco" 
returnvariable="LB_CampoFactorConversion" xmlfile = "Tab5_DepositosE.xml"/>    
       
<!---VARIABLES--->
	<cfset btnNameArriba = "">
	<cfset btnValuesArriba= "">
	<cfset btnNameAbajo = "">
	<cfset btnValuesAbajo= "">
	<cfparam name="GELid" default="">
	<cfif isdefined ('url.DepE') and not isdefined('form.GELDEid')>
		<cfset form.GELDEid=#url.DepE#>
	</cfif>
<!---DEFINICIONES--->
	<cfif isdefined('form.GELDEid')>
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
				a.CCHid,
				a.GELDEid,
				a.GELDreferencia,
				a.GELDtotalOri,
				a.GELDfecha,
				a.GELDtipoCambio,
				a.Mcodigo,
				a.GELDtotal,
				m.Miso4217
			from GEliquidacionDepsEfectivo a 
				inner join Monedas m
				on m.Mcodigo=a.Mcodigo
			where GELDEid=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.GELDEid#">
		</cfquery>
	

<!---Validaciones de campos--->
</cfif>

<cfquery name="selectEncabezado" datasource="#session.dsn#">
	select l.Mcodigo, m.Miso4217 
	  from GEliquidacion l
		inner join Monedas m on m.Mcodigo = l .Mcodigo
	 where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
</cfquery>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select 
		Mcodigo 
	from 
		Empresas
	where 
		Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery datasource="#session.dsn#" name="listaDep">
	select 
			a.GELDEid,
			a.GELDreferencia,
			a.GELDtotalOri,
			a.GELid,
			a.GELDfecha,
			m.Miso4217,
			a.CCHid,
			a.Mcodigo,
			b.CCHid,
			b.CCHcodigo,
			1 as Det  
		from GEliquidacionDepsEfectivo a, Monedas m,CCHica b 
		where 
			GELid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GELid#">
			and b.CCHtipo in (2,3)
            and a.Mcodigo= m.Mcodigo
			and a.CCHid=b.CCHid
	</cfquery>

<!---LISTA--->
<table width="55%"  align="left">
	<tr>
		<td  valign="top">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#listaDep#"
				desplegar="CCHcodigo,GELDreferencia,GELDfecha,Miso4217,GELDtotalOri"
				etiquetas="#LB_Caja#, #LB_Comprobante#, #LB_Fecha#, #LB_Moneda#, #LB_Monto#"
				formatos="S,S,D,S,M"
				align="left,right,center,right,left"
				ira="LiquidacionAnticipos#LvarSAporEmpleadoSQL#.cfm?tab=5&"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="GELDEid"
				incluyeForm="yes"
				formName="formDepElst"
				PageIndex="23"
				MaxRows="15"	
				navegacion="&GELid=#form.GELid#"/>
		</td>
	</tr>
	
</table>
	
<cfoutput>	
<form action="Tab3_Depositos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" method="post" name="formDepE" style="border:0px;" onSubmit="return validarDepE(this);" id="formDepE">
<input type="hidden" name="GELid" id="GELid" value="<cfif isdefined ("form.GELid")>#form.GELid#</cfif>"/>
<table width="45%" align="right">	
</cfoutput>
	
<!---cuentabancaria--->	
	<tr>
		<td nowrap="nowrap"  align="right"><strong><cf_translate key = LB_CajaEfectivo xmlfile = "Tab5_DepositosE.xml">Caja de Efectivo</cf_translate>:</strong></td>
		<td>	
			<cfquery name="rsGE" datasource="#session.DSN#">
					select a.CCHid, a.CCHcodigo, a.CCHdescripcion,a.Mcodigo, m.Miso4217,
						case 
							when a.CCHtipo = 1 then '#LB_CajaChica#'
							when a.CCHtipo = 2 then '#LB_CajaEspecialEfectivo#'
							when a.CCHtipo = 3 then '#LB_CajaExterna#'
						end as CCHtipo_caja,
						coalesce((
							select tc.TCventa
							from Htipocambio tc
							where tc.Ecodigo = #session.Ecodigo#
							  and tc.Mcodigo = a.Mcodigo
							  and tc.Hfecha  <= <cf_dbfunction name="today" >
							  and tc.Hfechah > <cf_dbfunction name="today" >
						),1) as TipoCambio
						
					  from CCHica a 
						inner join Monedas m
							on m.Mcodigo = a.Mcodigo
					  where a.Ecodigo= #session.Ecodigo# 
						and a.CCHtipo in (2,3)
					  order by a.CCHtipo,a.CCHdescripcion
			</cfquery>	
				
			<select name="CCHid" onchange="CambiaCajaE(this)">
				<option value="" selected> - <cf_translate key = LB_CajaEfectivo xmlfile = "Tab5_DepositosE.xml">Caja de Efectivo</cf_translate> - </option>
					<cfif rsGE.RecordCount>
						<cfoutput query="rsGE" group="CCHtipo_caja"><!---me imprime el encabezado pero siempre lo recorre--->
							<optgroup label="#rsGE.CCHtipo_caja#">
							<!---<option value="b, "selected>(Todos los grupos de bancos)</option>--->
								<cfoutput><!---me imprime lo q contiene cada parte del encabeado,value es lo que le voy a mandar al sql y lo demas es lo que quiero q me imprima--->
									<option value="#rsGE.CCHid#|#rsGE.Mcodigo#|#rsGE.Miso4217#|#rsGE.TipoCambio#|#rsGE.CCHtipo_caja#" <cfif modo neq "ALTA" and rsGE.CCHid EQ rsDepo.CCHid> selected</cfif>> #rsGE.Miso4217# - #rsGE.CCHcodigo#</option>									
								</cfoutput>
							</optgroup>
						</cfoutput>
				</cfif>
			</select>		
		</td>
	</tr>
<cfoutput>
<!---Depósito
<input type="text" align="right" name="referencia" id="referencia" maxlength="30" value="<cfif modo NEQ "ALTA">#rsDepo.GELDreferencia#</cfif>" />
--->
	<tr>
		<td width="28%" align="right" valign="top"><strong><cf_translate key = LB_Comprobante xmlfile = "Tab5_DepositosE.xml">Comprobante</cf_translate>: </strong></td>
		<td width="69%">
			<cfif modo NEQ "ALTA">
            	<cf_inputNumber name="referencia" enteros="10" decimales="0" codigoNumerico="true" value="#rsDepo.GELDreferencia#" />
            <cfelse>
				<cf_inputNumber name="referencia" enteros="10" decimales="0" codigoNumerico="true" value="" />
            </cfif>
			
		</td>
		<td width="3%"></td>
	</tr>
<!---Fecha --->	
	<tr>	
		<td  align="right"><strong><cf_translate key = LB_Fecha xmlfile = "Tab5_DepositosE.xml">Fecha</cf_translate>:</strong></td>
			<td>
				<cfset fechadep = LSDateFormat(Now(),'dd/mm/yyyy')>
					<cfif modo NEQ 'ALTA'>
						<cfset fechadep = LSDateFormat(rsDepo.GELDfecha,'dd/mm/yyyy') >
					</cfif>
				<cf_sifcalendario form="formDepE" value="#fechadep#" name="fechadep" tabindex="1">
			</td>
	</tr>
<!---monto--->
	<tr>
		<td valign="top"  align="right"><strong><cf_translate key = LB_Monto xmlfile = "Tab5_DepositosE.xml">Monto</cf_translate>: </strong></td>
			<td>
				<cfset valor_dep = 0 >
					<cfif modo neq 'ALTA'>
						<cfset valor_dep = LSNumberFormat(abs(rsDepo.GELDtotalOri),"0.00") >
					</cfif>
					<input	type		= "text"
						name		= "montoDepE" id="montoDepE"
						value		= "#valor_dep#"
						style		= "text-align:right;"
						onfocus		= "this.value=qf(this); this.select();"
						onkeypress	= "return _CFinputText_onKeyPress(this,event,13,2,false,true);"
						onkeyup		= "_CFinputText_onKeyUp(this,event,13,2,false,true);"
						onblur		= "fm(this,2,true,false,''); if (window.funcmontoDepE) window.funcmontoDepE();"
						onChange	= "CambiaMontoE();"
						size		= "20"
						maxlength	= "21"
					>
				 
					<input type="hidden" name="Mcodigo" id="Mcodigo" value="<cfif modo neq 'ALTA'>#rsDepo.Mcodigo#</cfif>">
					<input type="text" name="Miso4217" id="Miso4217"
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
	
<!---Tipo de cambio--->
		<tr>	
			<td nowrap="nowrap"  align="right"><strong><cf_translate key = LB_TipoCambio xmlfile = "Tab5_DepositosE.xml">Tipo de Cambio</cf_translate>:</strong></td>
				<td>
				 	<input type="text" name="tipoCambio" 
					id="tipoCambio"
					maxlength="10" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.GELDtipoCambio,",0.0000")#</cfif>"
					style="text-align:right;" 
					onfocus="this.value=qf(this); this.select(); GvarFocus='TC';"
					tabindex="1" 
					onchange="CambiaMontoE()"
					<cfif modo neq "Alta">
						<cfif #rsDepo.Mcodigo# eq #selectEncabezado.Mcodigo# or #rsDepo.Mcodigo# eq #rsMonedaLocal.Mcodigo#>
						disabled="disabled"
						</cfif>
					</cfif>/>
				</td>
		</tr>
<!---Factor de conversion--->
		<tr>			
				<td nowrap="nowrap"  align="right"><strong><cf_translate key = LB_FactorConversion xmlfile = "Tab5_DepositosE.xml">Factor de conv</cf_translate>:</strong></td>
				<td >
				 	<input type="text" name="factor" 
					id="factor"
					maxlength="10" 
					onchange="CambiaFactorE()" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.GELDtipoCambio/rsForm.GELtipoCambio,",0.0000")#</cfif>"
					style="text-align:right;"
					onfocus="this.value=qf(this); this.select(); GvarFocus='FC';"
					tabindex="1" 
					<cfif modo neq "Alta">
						<cfif #rsDepo.Mcodigo# eq #selectEncabezado.Mcodigo# or #rsDepo.Mcodigo# eq #rsMonedaLocal.Mcodigo#>
						disabled="disabled"
						</cfif>
					</cfif> />
				</td>
		</tr>	
<!---Monto en moneda liquidante--->
		<tr>			
				<td nowrap="nowrap"  align="right"><strong><cf_translate key = LB_MontoLiq xmlfile = "Tab5_DepositosE.xml">Monto LIQ</cf_translate>:</strong></td>
				<td >
				 	<input type="text" name="liqui" 
					id="liqui"
					maxlength="10" 
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.GELDtotal,",0.00")#</cfif>"
					style="text-align:right;" 
					onfocus="this.value=qf(this); this.select();" 
					tabindex="1" 
					readonly
					style="border:solid 1px ##CCCCCC;"
					/>
					#selectEncabezado.Miso4217#
				</td>
		</tr>	

		<tr >
			<td align="right" nowrap="nowrap" colspan="4">
				<cfif modo EQ "ALTA">
					<cfset btnNameArriba 			= "AltaDepE,">
					<cfset btnValuesArriba			= "Agregar,">
					<cfset btnNameArriba 			= btnNameArriba & "LimpiarE">
					<cfset btnValuesArriba			= btnValuesArriba &"Limpiar">
					<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">	
					<cfset btnExcluirArriba			=btnExcluirAbajo>
					<cf_botones modo="#modo#" includevalues="#btnValuesArriba#" include="#btnNameArriba#" exclude="#btnExcluirArriba#" >
				<cfelse>
					<input type="hidden" name="GELDEid" value="#HTMLEditFormat(rsDepo.GELDEid)#" />
					<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">
					<cfset btnNameAbajo				= btnNameAbajo&",CambioDepE">
					<cfset btnValuesAbajo			= btnValuesAbajo&",Modificar">
					<cfset btnNameAbajo				= btnNameAbajo&",BajaDepE">
					<cfset btnValuesAbajo			= btnValuesAbajo&",Eliminar">
					<cfset btnNameAbajo				= btnNameAbajo&",NuevoDepE">
					<cfset btnValuesAbajo			= btnValuesAbajo&",Nuevo">
					<cf_botones modo="#modo#" includevalues="#btnValuesAbajo#" include="#btnNameAbajo#" exclude="#btnExcluirAbajo#" >
				</cfif>
			</td>
		</tr>

</cfoutput>

</table>
</form>

<script language="javascript">
var GvarFocus = "1";
function funcCambioDepE()
{
	return true;
}

<cfoutput>
function CambiaCajaE(a)
{
	LvarValores = a.value.split('|');
	document.formDepE.Mcodigo.value		= LvarValores[1];
	document.formDepE.Miso4217.value	= LvarValores[2];
	if (LvarValores[1] == '#rsMonedaLocal.Mcodigo#')
	{
		document.formDepE.tipoCambio.readOnly 		= true;
		document.formDepE.tipoCambio.style.border 	= "solid 1px ##CCCCCC";
		document.formDepE.factor.style.border 		= "solid 1px ##CCCCCC";
		document.formDepE.tipoCambio.value			= '1';
	}
	else if (LvarValores[1] == '#rsForm.Mcodigo#')
	{
		document.formDepE.tipoCambio.readOnly 		= true;
		document.formDepE.tipoCambio.style.border 	= "solid 1px ##CCCCCC";
		document.formDepE.factor.style.border 		= "solid 1px ##CCCCCC";
		document.formDepE.tipoCambio.value			= '#rsForm.GELtipoCambio#';
	}
	else
	{
		document.formDepE.tipoCambio.readOnly 		= false;
		document.formDepE.tipoCambio.style.border 	= "inset 1px";
		document.formDepE.factor.style.border 		= "inset 1px";
		document.formDepE.tipoCambio.value			= LvarValores[3];
	}
	CambiaMontoE();
}

function CambiaMontoE(m)
{
	var LvarMonto	= qf(document.formDepE.montoDepE.value);
	var LvarTC		= qf(document.formDepE.tipoCambio.value);
	if (LvarMonto == "")
		LvarMonto = 0;
	else
		LvarMonto = parseFloat(LvarMonto);
	if (LvarTC == "" || LvarTC == 0)
		LvarTC = 1;
	else
		LvarTC = parseFloat(LvarTC);
	LvarMonto 	= LvarMonto * LvarTC;
	LvarFC		= LvarTC / #rsForm.GELtipoCambio#;
			
	document.formDepE.tipoCambio.value 	= fm(LvarTC,5);
	document.formDepE.factor.value 		= fm(LvarFC,5);
	document.formDepE.liqui.value 		= fm(LvarMonto,2);
}

function CambiaFactorE(m)
{
	var LvarFC		= qf(document.formDepE.factor.value);
	if (LvarFC == "" || LvarFC == 0)
		LvarFC = 1;
	else
		LvarFC = parseFloat(LvarFC);
	document.formDepE.tipoCambio.value = qf(LvarFC * #rsForm.GELtipoCambio#);
}
</cfoutput>
</script>

	
<!---VALIDACIONES--->	
<script type="text/javascript">
	function validarDepE(formulario)	{
	if (!btnSelected('Nuevo',document.formDepE) && !btnSelected('BajaDep',document.formDepE)){
	var error_input = null;;
	var error_msg = '';
				
				if (formulario.fechadep.value == "") 
				{
				error_msg += "\n - La fecha  no puede quedar en blanco.";
				error_input = formulario.fechadep;
				}
				
				if (formulario.CCHid.value == "") 
				{
				error_msg += "\n - <cfoutput>#LB_CampoCajaEfectivo#</cfoutput>.";
				error_input = formulario.CCHid;
				}
				if (formulario.referencia.value == "") 
				{
				error_msg += "\n - <cfoutput>#LB_CampoReferencia#</cfoutput>.";
				error_input = formulario.referencia;
				}
				if (formulario.montoDepE.value == "") 
				{
				error_msg += "\n - <cfoutput>#LB_CampoMonto#</cfoutput>.";
				error_input = formulario.montoDepE;
				}	
					else if (parseFloat(formulario.montoDepE.value) <= 0)
					{
					error_msg += "\n - <cfoutput>#LB_CampoMontoMayor0#</cfoutput>.";
			}
				if (formulario.tipoCambio.value == "") 
				{
				error_msg += "\n - <cfoutput>#LB_CampoTipoCambio#</cfoutput>.";
				error_input = formulario.tipoCambio;
				}
				else if (parseFloat(formulario.tipoCambio.value) <= 0)
					{
					error_msg += "\n - El Tipo de Cambio debe ser mayor que cero.";
			}
				if (formulario.factor.value == "") 
				{
				error_msg += "\n - <cfoutput>#LB_CampoFactorConversion#</cfoutput>.";
				error_input = formulario.factor;
				}
				else if (parseFloat(formulario.factor.value) <= 0)
					{
					error_msg += "\n - El Factor debe ser mayor que cero.";
			}
				
		if (error_msg.length != "") {
		alert("<cfoutput>#LB_RevisaDatos#</cfoutput>:"+error_msg);
		try 
		{
		error_input.focus();
		} 
		catch(e) 
		{}
		
		return false;
		}
		
		}
	formulario.montoDepE.value = qf(formulario.montoDepE);
	formulario.liqui.value = qf(formulario.liqui);
	formulario.liqui.disabled=false;

	if(formulario.tipoCambio.disabled)
	formulario.tipoCambio.disabled =false;
		formulario.factor.disabled=false;
		formulario.liqui.disabled=false;
	return true;

	}
</script>
