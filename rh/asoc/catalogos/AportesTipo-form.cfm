<!--- Asignación el valor a la variable modo --->
<cfset modo="ALTA">
<cfif isdefined("Form.ACATid") and len(trim("Form.ACATid")) NEQ 0 and Form.ACATid gt 0>
    <cfset modo="CAMBIO">
</cfif>

<!--- Consultas --->
<cfset valuesarray = ArrayNew(1)>
<cfquery name="rsCodigos" datasource="#Session.DSN#">
	SELECT ACATcodigo
	FROM ACAportesTipo
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery> 

<cfif modo neq "ALTA">

	<cfquery name="rsDatos" datasource="#Session.DSN#">
		select 
			ACATid,				Ecodigo,				DClinea,
			TDid,				ACATcodigo,				ACATdescripcion,
			ACATtipo,			ACATtasa,				ACATorigen,	
			ACATpermiteRetiro
		from ACAportesTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATid#">
	</cfquery>
	
	<!--- Obtiene el Detalle de la Carga --->
	<cfif isdefined("rsDatos.DClinea") and len(trim(rsDatos.DClinea)) GT 0>
		<cfquery name="rsdatatemp" datasource="#session.dsn#">
			select DClinea as c1, DCcodigo as c2, DCdescripcion as c3
			from DCargas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DClinea#" null="#Len(rsDatos.DClinea) Is 0#">
		</cfquery>
	
		<cfif rsdatatemp.recordcount gt 0>			
			<cfset ArrayAppend(valuesarray,rsdatatemp.c1)>
			<cfset ArrayAppend(valuesarray,rsdatatemp.c2)>
			<cfset ArrayAppend(valuesarray,rsdatatemp.c3)>
		</cfif>
	</cfif>
	
	<!--- Obtiene el Tipo de Deducción --->
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
	
	<!--- Consulta si esta  Asociado a un Aporte  --->
	<cfquery name="rsAporteAsociado" datasource="#Session.DSN#">
		select count(*) as valor 
		from ACAportesAsociado
		where ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATid#">
	</cfquery>
	
</cfif>

<cfoutput>
<cfif isdefined("rsDatos.ACATcodigo")><cfset desc = "- " & rsDatos.ACATcodigo><cfelse><cfset desc=""></cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
  <tr>
    <td align="center">#Evaluate('LB_'&modo)# #LB_nav__SPdescripcionSingle# #desc#</td>
  </tr>
</table>
<form name="form1" method="post" action="AportesTipo-sql.cfm" style="margin:0; ">				
	<table width="90%" align="center" cellpadding="2" cellspacing="0" >
		<tr>
			<td nowrap="true" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td nowrap="true">#LB_Codigo#:&nbsp;</td>
			<td>
				<input name="ACATcodigo" type="text" size="10" maxlength="10" value="<cfif modo NEQ "ALTA">#rsDatos.ACATcodigo#</cfif>" <cfif modo neq 'ALTA'>disabled</cfif>>
			</td>	
		</tr>
		<tr>
			<td nowrap="true">#LB_Descripcion#:&nbsp;</td>
			<td>
				<input name="ACATdescripcion" type="text" size="60" maxlength="80" value="<cfif modo NEQ "ALTA">#rsDatos.ACATdescripcion#</cfif>">
			</td>	
		</tr>
		<tr>
			<td colspan="2">
				<table width="90%" border="0" align="left" cellpadding="2" cellspacing="0" >
					<tr>
						<td>
							<fieldset>
								<legend >&nbsp;<strong>Cargas / Deducciones</strong>&nbsp;</legend>
								<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
								
									<tr>
										<td nowrap="nowrap" align="right">
											<input name="radRep" id="radRep0" type="radio" value="1" tabindex="1" onclick="javascript: habilitarCargas();"  <cfif modo EQ "ALTA">checked<cfelseif isdefined("rsDatos.TDid") and len(trim(rsDatos.TDid)) GT 0>unchecked<cfelse>checked</cfif> >      
										</td>
										<td nowrap="nowrap">#LB_TipoCarga#</td>
										<td nowrap="nowrap" align="right">
											<input name="radRep" id="radRep1" type="radio" value="2" tabindex="1" onclick="javascript: habilitarDevoluccion();" <cfif modo NEQ "ALTA" and isdefined("rsDatos.TDid") and len(trim(rsDatos.TDid)) GT 0>checked<cfelse>unchecked</cfif> >
										</td>
										<td nowrap="nowrap" >#LB_TipoDeduccion#</td>
									</tr>
									<tr>
										<td nowrap="nowrap" colspan="4">
											<table width="80%" border="0" align="center" cellpadding="2" cellspacing="0" >
												<tr id="idCargas">
													<td>#LB_TipoCarga#:&nbsp;</td>
													<td>
														<cf_conlis title="Cargas"
															valuesarray="#valuesarray#"
															campos="DClinea, DCcodigo, DCdescripcion"
															desplegables="N,S,S"
															modificables="N,S,N"
															columnas="DClinea, DCcodigo, DCdescripcion"
															size="10,7,35"	
															tabla="DCargas"
															filtro="Ecodigo=#Session.Ecodigo# order by 2"
															desplegar="DCcodigo, DCdescripcion"
															etiquetas="Codigo, Descripcion"
															formatos="S,S"
															align="left,left"
															asignar="DClinea, DCcodigo, DCdescripcion"
															asignarformatos="S,S,S"
														/>
													</td>	
												</tr>
												<tr id="idDeduccion">
													<td>#LB_TipoDeduccion#:&nbsp;</td>
													<td>
														<cfif modo neq 'ALTA'>
															<cf_rhtipodeduccion query="#rsTipoDeduccion#" size="40" readOnly="false">
														<cfelse>
															<cf_rhtipodeduccion size="40">
														</cfif>
													</td>	
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td nowrap="nowrap" colspan="4">&nbsp;</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</table>				
			</td>
		</tr>
		<tr>
			<td nowrap="true">#LB_TipoAporte#:&nbsp;</td>
			<td>
				<select name="ACATtipo" tabindex="1">
					<option value="V" <cfif modo NEQ "ALTA" and rsDatos.ACATtipo eq 'V'>selected</cfif>> <cf_translate key="CMB_Voluntario">Voluntario</cf_translate></option>
					<option value="O" <cfif modo NEQ "ALTA" and rsDatos.ACATtipo eq 'O'>selected</cfif>> <cf_translate key="CMB_Obligatorio">Obligatorio</cf_translate></option>
				</select>
			</td>	
		</tr>
		<tr>
			<td nowrap="true">#LB_TipoTasa#:&nbsp;</td>
			<td>
				<cfif modo EQ "ALTA"><cfset Tasa = ""><cfelse><cfset Tasa = rsDatos.ACATtasa></cfif>
				<cf_inputNumber name="ACATtasa" value="#Tasa#"enteros="3" decimales="3">&nbsp;<strong>%</strong>
			</td>
		</tr>
		<tr>
			<td nowrap="true">#LB_TipoOrigen#:&nbsp;</td>
			<td>
				<select name="ACATorigen" tabindex="1">
					<option value="O" <cfif modo NEQ "ALTA" and rsDatos.ACATorigen eq 'O'>selected</cfif>> <cf_translate key="CMB_Obrero">Obrero</cf_translate></option>
					<option value="P" <cfif modo NEQ "ALTA" and rsDatos.ACATorigen eq 'P'>selected</cfif>> <cf_translate key="CMB_Patronal">Patronal</cf_translate></option>
				</select>
			</td>	
		</tr>
		<tr>
			<td nowrap="true" align="right">
				<input name="ACATpermiteRetiro" type="checkbox" <cfif modo NEQ "ALTA" and rsDatos.ACATpermiteRetiro EQ 1>checked</cfif> >
			</td>
			<td nowrap="true">#LB_PermiteRetiro#</td>
		</tr>
		<tr>
			<td nowrap="true" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo NEQ "ALTA" and rsAporteAsociado.valor GT 0>
					<strong>--- El Registro NO puede modificarse por encontrarse Asociado a un Aporte. --- </strong>
				<cfelse>
					<cf_botones modo="#modo#">
				</cfif>
			</td>
		</tr>
		<tr>
			<td nowrap="true" colspan="2">&nbsp;</td>
		</tr>
		<input type="hidden" name="ACATid" value="<cfif modo neq "ALTA">#rsDatos.ACATid#</cfif>">				
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
				'#trim(ACATcodigo)#'.toUpperCase( )==this.value.toUpperCase( )
				<cfif modo NEQ "ALTA">&&'#trim(rsDatos.ACATcodigo)#'.toUpperCase( )!=this.value.toUpperCase( )</cfif>
				)
					existe = true;
		</cfoutput>
		if (existe){this.error="El campo "+this.description+" <cfoutput>#MSG_ContieneUnValorQueYaExisteDebeDigitarUnoDiferente#</cfoutput>";}
	}

</script>
<cf_qforms>
	<cf_qformsrequiredfield name="ACATcodigo" description="#MSG_Codigo#" validate="ExisteCod">
	<cf_qformsrequiredfield name="ACATdescripcion" description="#MSG_Descripcion#">
	<cf_qformsrequiredfield name="ACATtasa" description="#LB_TipoTasa#">
</cf_qforms>

<script language="javascript" type="text/javascript">



	//Funcion para validar un rango
	function _Field_isRango(low, high){
		var low = _param(arguments[0], 0, "number");
    	var high = _param(arguments[1], 9999999, "number");
      	var iValue = parseInt(qf(this.value));
      	if(isNaN(iValue))iValue=0;
      	if((low>iValue)||(high<iValue)){
      		this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
		}
	}

	// Sentencia que agrega la funcion _Field_isRango al API
	_addValidator("isRango", _Field_isRango);

	// Forma de invocacion de la función de validar rango
	objForm.ACATtasa.validateRango('0','99');
	
	function habilitarCargas(){
		document.getElementById("idCargas").style.display = "";	
		document.getElementById("idDeduccion").style.display = "none";
	}
	
	function habilitarDevoluccion(){
		document.getElementById("idCargas").style.display = "none";
		document.getElementById("idDeduccion").style.display = "";
	}
	
	<cfif modo EQ "ALTA">
		habilitarCargas();
	<cfelseif isdefined("rsDatos.TDid") and len(trim(rsDatos.TDid)) GT 0>
		habilitarDevoluccion();
	<cfelse>
		habilitarCargas();
	</cfif>

</script>