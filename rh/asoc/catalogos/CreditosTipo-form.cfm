<!--- Asignación el valor a la variable modo --->
<cfset modo="ALTA">
<cfif isdefined("Form.ACCTid") and len(trim("Form.ACCTid")) NEQ 0 and Form.ACCTid gt 0>
    <cfset modo="CAMBIO">
</cfif>

<!--- Consultas --->
<cfquery name="rsCodigos" datasource="#Session.DSN#">
	SELECT ACCTcodigo
	FROM ACCreditosTipo
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery> 

<cfif modo neq "ALTA">
	<cfquery name="rsDatos" datasource="#Session.DSN#">
		select 
			ACCTid,				Ecodigo,				TDid,
			ACCTcodigo,			ACCTdescripcion,		ACCTplazo,
			ACCTtasa,			ACCTtasaMora,			ACCTmodificable,	
			ACCTunico,			ACCTobservaciones,		ACCTdocumentoAsociado,	
			ACCTtipo
		from ACCreditosTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACCTid#">
	</cfquery>
	
	<cfif isdefined("rsDatos.TDid") and len(trim(rsDatos.TDid)) GT 0>
		<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
			select TDid, TDcodigo, TDdescripcion, TDfinanciada 
			from TDeduccion 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TDid#">
		</cfquery>
	<cfelse>
		<cfset rsTipoDeduccion = QueryNew("")>
	</cfif>
</cfif>

<!--- Pintado del Catálogo de Tipos de Crédito --->
<cfoutput>
<cfif isdefined("rsDatos.ACCTcodigo")><cfset desc = "- " & rsDatos.ACCTcodigo><cfelse><cfset desc=""></cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
  <tr>
    <td align="center">#Evaluate('LB_'&modo)# #LB_nav__SPdescripcionSingle# #desc#</td>
  </tr>
</table>
<form name="form1" method="post" action="CreditosTipo-sql.cfm" style="margin:0;">	 <!--- onSubmit="javascript: return validar();" ---> 			
	<table width="90%" align="center" cellpadding="2" cellspacing="0" >
		<!--- Línea No. 1 --->
		<tr>
			<td nowrap="nowrap" colspan="2">&nbsp;</td>
		</tr>
		<!--- Línae No. 2 --->
		<tr>
			<td nowrap="nowrap">#LB_Codigo#:&nbsp;</td>
			<td>
				<input name="ACCTcodigo" type="text" size="10" maxlength="10" value="<cfif modo NEQ "ALTA">#rsDatos.ACCTcodigo#</cfif>" <cfif modo neq 'ALTA'>disabled</cfif>>
			</td>	
		</tr>
		<!--- Línea No. 3 --->
		<tr>
			<td nowrap="nowrap">#LB_Descripcion#:&nbsp;</td>
			<td>
				<input name="ACCTdescripcion" type="text" size="60" maxlength="80" value="<cfif modo NEQ "ALTA">#rsDatos.ACCTdescripcion#</cfif>">
			</td>	
		</tr>
		<!--- Línea No. 4 ---> 
		<tr>
			<td nowrap="nowrap">#LB_TipoDeduccion#:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_rhtipodeduccion query="#rsTipoDeduccion#" size="60" readOnly="false">
				<cfelse>
					<cf_rhtipodeduccion size="60">
				</cfif>
			</td>	
		</tr>
		<!--- Línea No. 5 --->	
		<tr>
			<td nowrap="nowrap">#LB_Plazo#:&nbsp;</td>
			<td>
				<cfif modo EQ "ALTA"><cfset Plazo = ""><cfelse><cfset Plazo = rsDatos.ACCTplazo></cfif>
				<cf_inputNumber name="ACCTplazo" value="#Plazo#" enteros="2" decimales="0">&nbsp;meses
			</td>
		</tr>
		<!--- Línea No. 6 --->
		<tr>
			<td nowrap="nowrap">#LB_Tasa#:&nbsp;</td>
			<td>
				<cfif modo EQ "ALTA"><cfset Tasa = ""><cfelse><cfset Tasa = rsDatos.ACCTtasa></cfif>
				<cf_inputNumber name="ACCTtasa" value="#Tasa#" enteros="3" decimales="2">&nbsp;<strong>%</strong>
			</td>
		</tr>
		<!--- Línea No. 7 --->
		<tr>
			<td nowrap="nowrap">#LB_TasaMora#:&nbsp;</td>
			<td>
				<cfif modo EQ "ALTA"><cfset TasaMora = ""><cfelse><cfset TasaMora = rsDatos.ACCTtasaMora></cfif>
				<cf_inputNumber name="ACCTtasaMora" value="#TasaMora#" enteros="3" decimales="2">&nbsp;<strong>%</strong>
			</td>
		</tr>
		<!--- Línea No. 8 --->
		<tr>
			<td nowrap="nowrap">#LB_TipoCredito#:&nbsp;</td>
			<td>
				<select name="ACCTtipo" tabindex="1">
					<option value="P" <cfif modo NEQ "ALTA" and rsDatos.ACCTtipo eq 'P'>selected</cfif> > <cf_translate key="CMB_Personal">Personal</cf_translate></option>
					<option value="A" <cfif modo NEQ "ALTA" and rsDatos.ACCTtipo eq 'A'>selected</cfif> > <cf_translate key="CMB_Automovil">Autom&oacute;vil</cf_translate></option>
					<option value="V" <cfif modo NEQ "ALTA" and rsDatos.ACCTtipo eq 'V'>selected</cfif> > <cf_translate key="CMB_Vivienda">Vivienda</cf_translate></option>				
				</select>
			</td>	
		</tr>
		<!--- Línea No. 9 --->
		<tr>
			<td nowrap="nowrap" align="right">
				<input name="ACCTmodificable" id="ACCTmodificable" type="checkbox" <cfif modo NEQ "ALTA" and rsDatos.ACCTmodificable EQ 1>checked</cfif> >
			</td>
			<td nowrap="nowrap">
				<label for="ACCTmodificable" style="font-style:normal; font-variant:normal; font-weight:normal">
					#LB_PermiteModificarTasasPlazo#
				</label>
			</td>
		</tr>
		<!--- Línea No. 10 --->
		<tr>
			<td nowrap="nowrap" align="right">
				<input name="ACCTunico" type="checkbox" id="ACCTunico" <cfif modo NEQ "ALTA" and rsDatos.ACCTunico EQ 1>checked</cfif> >
			</td>
			<td nowrap="nowrap">
				<label for="ACCTunico" style="font-style:normal; font-variant:normal; font-weight:normal">
					#LB_PrestamoUnico#
				</label>
			</td>
		</tr>
		<!--- Línea No. 11 --->
		<tr>
			<td colspan="2">#LB_Observaciones#:&nbsp;</td>
		</tr>
		<!--- Línea No. 12 --->		
		<tr>
			<td colspan="2">
				<cfif modo eq "ALTA"><cfset miHTML = ""><cfelse><cfset miHTML = rsDatos.ACCTobservaciones></cfif>
				<cf_sifeditorhtml name="ACCTobservaciones" indice="1" value="#miHTML#" height="200">
			</td>
		</tr>
		<!--- Línea No. 13 --->
		<tr>
			<td colspan="2">#LB_DocumentoAsociado#:&nbsp;</td>
		</tr>
		<!--- Línea No. 14 --->		
		<tr>
			<td colspan="2">
				<cfif modo eq "ALTA"><cfset miHTML = ""><cfelse><cfset miHTML = rsDatos.ACCTdocumentoAsociado></cfif>
				<cf_sifeditorhtml name="ACCTdocumentoAsociado" indice="1" value="#miHTML#" height="200">
			</td>
		</tr>
		<!--- Línea No. 15 --->		
		<tr>
			<td nowrap="nowrap" colspan="2">&nbsp;</td>
		</tr>
		<!--- Línea No. 16 --->
		<tr>
			<td colspan="2" align="center">
				<cf_botones modo="#modo#">
			</td>
		</tr>
		<!--- Línea No. 17 --->
		<tr>
			<td nowrap="nowrap" colspan="2">&nbsp;</td>
		</tr>
		<input type="hidden" name="ACCTid" value="<cfif modo neq "ALTA">#rsDatos.ACCTid#</cfif>">		
	</table>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	//Funcion para validar que no se repitan los codigos
	function ExisteCod(){
		var existe = new Boolean;
		existe = false;
		<cfoutput query="rsCodigos">
			if (
				'#trim(ACCTcodigo)#'.toUpperCase( )==this.value.toUpperCase( )
				<cfif modo NEQ "ALTA">&&'#trim(rsDatos.ACCTcodigo)#'.toUpperCase( )!=this.value.toUpperCase( )</cfif>
				)
					existe = true;
		</cfoutput>
		if (existe){this.error="El campo "+this.description+" <cfoutput>#MSG_ContieneUnValorQueYaExisteDebeDigitarUnoDiferente#</cfoutput>";}
	}
</script>

<cf_qforms>
	<cf_qformsrequiredfield name="ACCTcodigo" description="#MSG_Codigo#" validate="ExisteCod">
	<cf_qformsrequiredfield name="ACCTdescripcion" description="#MSG_Descripcion#">
	<cf_qformsrequiredfield name="ACCTplazo" description="#LB_Plazo#">
	<cf_qformsrequiredfield name="ACCTtasa" description="#LB_Tasa#">
	<cf_qformsrequiredfield name="ACCTtasaMora" description="#LB_TasaMora#">
</cf_qforms>


<script language="javascript" type="text/javascript">
	//esta es la funcion
	function _Field_isRango(low, high){
		var low = _param(arguments[0], 0, "number");
    	var high = _param(arguments[1], 9999999, "number");
      	var iValue = parseInt(qf(this.value));
      	if(isNaN(iValue))iValue=0;
      	if((low>iValue)||(high<iValue)){
      		this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
		}
	}

	//esta sentencia agrega la funcion al api
	_addValidator("isRango", _Field_isRango);

	//esta es la invocacion de la función
	objForm.ACCTplazo.validateRango('1','99');
	objForm.ACCTtasa.validateRango('0','99');
	objForm.ACCTtasaMora.validateRango('0','99');
</script>
