<!---VARIABLES--->
	<cfset btnNameArriba = "">
	<cfset btnValuesArriba= "">
	<cfset btnNameAbajo = "">
	<cfset btnValuesAbajo= "">
	<cfparam name="ID_liquidacion" default="">

<!---DEFINICIONES--->
	<cfif isdefined('form.TESDepo_id')>
		<cfset modo = 'CAMBIO'>
	<cfelse>
		<cfset modo = 'ALTA'>
	</cfif>

	<cfif isdefined ('url.mensajeDep')>
		<script language="javascript">
			alert("El numero de referencia ya existe por lo tanto no se puede repetir");
		</script>
	</cfif>

<!---SELECTS--->
	<cfif modo eq 'CAMBIO'>
		<cfquery name="rsDepo" datasource="#session.dsn#">
			select ID_liquidacion,
				Ecodigo,
				BMUsucodigo,
				TESDepo_CuentaBanco,
				TESDepo_id,
				TESDepo_referencia,
				TESDepo_monto,
				TESDepo_fecha,
				TESDepo_tipoCambio,
				Mcodigo
			from GASTOE_Deposito
			where TESDepo_id=<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.TESDepo_id#">
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#" name="listaDep">
		select a.TESDepo_id,a.TESDepo_referencia,a.TESDepo_monto,a.ID_liquidacion,a.CBid,b.CBdescripcion  
		from GASTOE_Deposito a
		inner join CuentasBancos b 
		on a.CBid= b.CBid	
		where ID_liquidacion=#form.ID_liquidacion#
        	and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
	</cfquery>

<!---LISTA--->
<table width="50%" cellpadding="2" cellspacing="2">
	<tr>
		<td width="50%" valign="top">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#listaDep#"
				desplegar="TESDepo_referencia,TESDepo_monto,CBdescripcion"
				etiquetas="Referencia, Monto, Cuenta Bancaria"
				formatos="S,M,S"
				align="left,left,left"
				ira="LiquidacionAnticipos.cfm?tab=3"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="TESDepo_id"
				incluyeForm="yes"
				formName="formDepo"
				PageIndex="1"
				MaxRows="5"	/>
		</td>
	</tr>
</table>
	
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<form action="Tag3_Depositos_sql.cfm" method="post" name="formDep" style="border:0px;" onSubmit="return validarDep(this);" id="formDep">
<cfoutput> 
	<table width="70%" align="left">	
	<!---cuentabancaria--->	
	<!---<input type="hidden" name="TESDepo_id" id="TESDepo_id" value="<cfif modo NEQ "ALTA">#rsDepo.TESDepo_CuentaBanco#</cfif>"/>--->
	
	<input type="hidden" name="ID_liquidacion" id="ID_liquidacion" value="<cfif isdefined ("form.ID_liquidacion")>#form.ID_liquidacion#</cfif>"/>
	<tr>
	<td width="200"><strong>Cuenta Bancaria:</strong></td>
	<td>	
			<cfquery name="rsGE" datasource="#session.DSN#">
					select a.CBid, a.Bid,a.CBcodigo, a.CBdescripcion,b.Bdescripcion from CuentasBancos a 
					join Bancos b  
					on a.Bid= b.Bid 
					where a.Ecodigo= #session.Ecodigo#
                    	and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
					order by b.Bdescripcion
			</cfquery>	
	</cfoutput>
		
	<select name="CBid" >
	<option value="1" selected> - Bancos - </option>
			<cfif rsGE.RecordCount>
				<cfoutput query="rsGE" group="Bdescripcion"><!---me imprime el encabezado pero siempre lo recorre--->
					<optgroup label="#rsGE.Bdescripcion#">
					<!---<option value="b, "selected>(Todos los grupos de bancos)</option>--->
						<cfoutput><!---me imprime lo q contiene cada parte del encabeado,value es lo que le voy a mandar al sql y lo demas es lo que quiero q me imprima--->
							<option value="#rsGE.CBid#" <cfif modo neq "ALTA" and rsGE.CBid EQ rsDepo.TESDepo_CuentaBanco> selected</cfif>> #rsGE.CBdescripcion# - #rsGE.CBcodigo#</option>
						</cfoutput>
					</optgroup>
				</cfoutput>
			</cfif>
	</select>	
	</td>
	</tr>
	<cfoutput>
<!---referencia--->
	<tr>
		<td><strong>Referencia: </strong></td>
		<td>
			<input type="text" align="right" name="referencia" id="referencia" maxlength="30" value="<cfif modo NEQ "ALTA">    #rsDepo.TESDepo_referencia#</cfif>" />
		</td>
	</tr>
		
<!---monto--->
	<tr>
		<td valign="top"><strong>Monto: </strong></td>
			<td>
				<cfset valor_dep = 0 >
					<cfif modo neq 'ALTA'>
						<cfset valor_dep = LSNumberFormat(abs(rsDepo.TESDepo_monto),"0.00") >
					</cfif>
				<cf_inputNumber name="montodep" value="#valor_dep#" size="15" enteros="13" decimales="2">
			</td>
	</tr>
	
<!---Fecha --->
	<tr>
		<td valign="top" ><strong>Fecha:</strong></td>
			<td colspan="2" valign="top">
				<cfset fechadep = LSDateFormat(Now(),'dd/mm/yyyy')>
					<cfif modo NEQ 'ALTA'>
						<cfset fechadep = LSDateFormat(rsDepo.TESDepo_fecha,'dd/mm/yyyy') >
					</cfif>
				<cf_sifcalendario form="formDep" value="#fechadep#" name="fechadep" tabindex="1">
			</td>
	</tr>
<!--- Moneda Local --->
		<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select <cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo 
			from Empresas
			where Ecodigo = #Session.Ecodigo#	
		</cfquery>
	<tr>
		<td	valign="top" ><strong>Moneda:&nbsp;</strong></td>	
			<td valign="top">
				<cfif  modo NEQ 'ALTA'>
						<cfquery name="rsMoneda" datasource="#session.DSN#">
								select Mcodigo, Mnombre
								from Monedas
								where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
								and Ecodigo= #session.Ecodigo#
						</cfquery>
						<cfset LvarMnombreSP = rsMoneda.Mnombre>
							<cfif rsDepo.TESDepo_monto GT 0>
								<cf_sifmonedas onChange="asignaTCD();" valueTC="#rsDepo.TESDepo_tipoCambio#" 	
								form="formDep" Mcodigo="McodigoD" query="#rsMoneda#" 
								FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="S">
							<cfelse>
								<cf_sifmonedas onChange="asignaTCD();" valueTC="#rsDepo.TESDepo_tipoCambio#" 
								form="formDep" Mcodigo="McodigoD" query="#rsMoneda#" 
								FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
							</cfif>
				<cfelse>
						<cf_sifmonedas onChange="asignaTCD();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" form="formDep" Mcodigo="McodigoD"  tabindex="1">
				</cfif>					
			</td>
	  </tr>
	
<!---Tipo de cambio--->
		<tr>	
			<td valign="top" width="400"><strong>Tipo de Cambio:&nbsp;</strong></td>
				<td valign="top">
				 	<input type="text" name="tipoCambio" 
					id="tipoCambio"
					maxlength="10" disabled="S"
					value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsDepo.TESDepo_tipoCambio,",0.0")#</cfif>"
					style="text-align:right;" 
					onfocus="this.value=qf(this); this.select();" 
					tabindex="1" />
				</td>
		</tr>	
<!---botones--->
	<table align="right">
		<tr>
			<td>
				<cfif modo EQ "ALTA">
					<cfset btnNameArriba 			= "AltaDep,">
					<cfset btnValuesArriba			= "Agregar,">
					<cfset btnNameArriba 			= btnNameArriba & "Limpiar">
					<cfset btnValuesArriba			= btnValuesArriba &"Limpiar">
					<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">	
					<cfset btnExcluirArriba			=btnExcluirAbajo>
					<cf_botones modo="#modo#" includevalues="#btnValuesArriba#" include="#btnNameArriba#" exclude="#btnExcluirArriba#" >
				<cfelse>
					<input type="hidden" name="TESDepo_id" value="#HTMLEditFormat(rsDepo.TESDepo_id)#" />
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
	</table>
</table>
</cfoutput>	
</form>






<script type="text/javascript">
<!--
function validarDep(formulario)	{
if (!btnSelected('Nuevo',document.formDep) && !btnSelected('BajaDep',document.formDep)){
var error_input = null;;
var error_msg = '';
if (formulario.CBid.value == "") 
{
if (formulario.CBID.value==1){
error_msg += "\n - La cuenta bancaria no puede quedar en blanco.";
if (error_input == null) error_input = formulario.CBid;
}}
if (formulario.fechadep.value == "") 
{
error_msg += "\n - La fecha  no puede quedar en blanco.";
if (error_input == null) error_input = formulario.fechadep;
}
if (formulario.McodigoD.value == "") 
{
error_msg += "\n - La moneda no puede quedar en blanco.";
if (error_input == null) error_input = formulario.McodigoD;
}
if (formulario.referencia.value == "") 
{
error_msg += "\n - La referencia quedar en blanco.";
if (error_input == null) error_input = referencia.fechadep;
}
if (formulario.montodep.value == "") 
{
error_msg += "\n - El monto no puede quedar en blanco.";
if (error_input == null) error_input = montodep.fechadep;
}
if (formulario.tipoCambio.value == "") 
{
error_msg += "\n - El tipo de cambio  no puede quedar en blanco.";
if (error_input == null) error_input = formulario.tipoCambio;
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

if(formulario.tipoCambio.disabled)
formulario.tipoCambio.disabled =false;
return true;
}

//-->



/* aqu asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
function asignaTCD() {	
if (document.formDep.McodigoD.value == "#rsMonedaLocal.Mcodigo#") {		
formatCurrency(document.formDep.TC,2);
document.formDep.tipoCambio.disabled = true;			
}
else
document.formDep.tipoCambio.disabled = false;							
var estado = document.formDep.tipoCambio.disabled;
document.formDep.tipoCambio.disabled = false;
document.formDep.tipoCambio.value = fm(document.formDep.TC.value,2);
document.formDep.tipoCambio.disabled = estado;
}



//-->
</script>


