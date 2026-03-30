<!---<cfdump var="#form#"><cfabort>--->

<cf_templatecss>

<!--- Obtiene el comprador según el usucodigo de usuario --->
<cfquery name="rsComprador" datasource="#Session.DSN#">
  select CMCid 
  from CMCompradores 
  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
</cfquery>
<cfset CMCid = -1 >
<cfif rsComprador.RecordCount EQ 1>
	<cfset CMCid = rsComprador.CMCid >
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<!--- Retenciones --->
<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion 
	from Retenciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Rdescripcion
</cfquery>

<!--- Impuestos --->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion 
	from Impuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Idescripcion                                 
</cfquery>

<cfif modo eq 'ALTA'>
	<cfquery name="rsNumeroOrden" datasource="#session.DSN#">
		select a.CMTOcodigo, coalesce(max(EOnumero),0) as consecutivo
		from CMTipoOrden a
		left outer join EOrdenCM b
		on a.CMTOcodigo=b.CMTOcodigo
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		group by a.CMTOcodigo
	</cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<!--- Consulta del encabezado de la Orden ---> 
	<cfquery name="rsOrden" datasource="#Session.DSN#">
		select 	EOnumero, SNcodigo, CMTOcodigo, CMCid, Mcodigo, 
				Rcodigo, EOfecha, Observaciones, EOtc, 
				EOrefcot, Impuesto, EOdesc, EOtotal, 
				Usucodigo, EOplazo, ts_rversion 
		from EOrdenCM
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	
	<!--- Nombre del Socio --->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNcodigo, SNidentificacion, SNnombre from SNegocios 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOrden.SNcodigo#">
	</cfquery>

	<!--- Almacenes --->
	<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
		select Aid, Bdescripcion 
		from Almacen 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Bdescripcion                                                                   
	</cfquery>
</cfif>

<!--- Tipos de Orden --->
<cfquery name="rsTipoOrden" datasource="#session.DSN#">
	select CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsOrden.CMTOcodigo)#">
	</cfif>
</cfquery>

<script language="JavaScript1.2" type="text/javascript">

	// crea objeto js con los tipos de orden y sus respectivos valores maximos
	<cfif modo eq 'ALTA'>
		var o = new Object();
		<cfoutput query="rsNumeroOrden">
			o['#trim(rsNumeroOrden.CMTOcodigo)#']= #rsNumeroOrden.consecutivo#;
		</cfoutput>
	
		function tipo(obj){
			document.form1.EOnumero.value = o[obj.value]+1;
		}
	</cfif>

	function Lista() {
		location.href = 'listaOrdenCM.cfm';
	}
</script>

	<cfoutput>
	<table width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr> 
			<td align="right">
				<input type="hidden" name="CMCid" value="#CMCid#">
				<!---<input type="hidden" name="EOnumero" value="<cfif modo NEQ 'ALTA'>#rsOrden.EOnumero#</cfif>">--->
				<input type="hidden" name="EOidorden" value="<cfif modo NEQ 'ALTA'>#form.EOidorden#</cfif>">
				<strong>No. de Orden:&nbsp;</strong>
			</td>
			
			<td width="1%"><input type="text" name="EOnumero" size="10" style="border: 0px none; background-color: ##FFFFFF;"  maxlength="10" readonly="" value="<cfif modo NEQ 'ALTA'>#rsOrden.EOnumero#</cfif>" ></td>

			<td align="right"><strong>Proveedor:&nbsp;</strong></td>

			<td>
				<cfif modo NEQ "ALTA">
					#rsNombreSocio.SNnombre#
					<input type="hidden" name="SNcodigo" value="#rsOrden.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2 SNtiposocio="P">
				</cfif>
			</td>
			
			<td align="right"><strong>Tipo de Orden:&nbsp;</strong></td>
			<td>
				<cfif modo eq 'ALTA'>
					<select name="CMTOcodigo" onChange="javascript:tipo(this);">
						<cfloop query="rsTipoOrden">
							<option value="#trim(rsTipoOrden.CMTOcodigo)#" <cfif modo neq 'ALTA' and trim(rsTipoOrden.CMTOcodigo) eq trim(rsOrden.CMTOcodigo)>selected</cfif> >#rsTipoOrden.CMTOdescripcion#</option>
						</cfloop>
					</select>
				<cfelse>
					<input type="hidden" name="CMTOcodigo" value="#rsOrden.CMTOcodigo#">
					#rsTipoOrden.CMTOcodigo# - #rsTipoOrden.CMTOdescripcion#
				</cfif>
			</td>

		</tr>

		<tr> 
			<td align="right"><strong>Fecha:&nbsp;</strong></td>
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifcalendario name="EOfecha" value="#LSDateFormat(rsOrden.EOfecha,'dd/mm/yyyy')#" tabindex="1"> 
				<cfelse>
					<cf_sifcalendario name="EOfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</cfif> 
			</td>

			<td align="right"><strong>Moneda:&nbsp;</strong></td>
		
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifmonedas query="#rsOrden#" valueTC="#rsOrden.EOtc#" onChange="asignaTC();" FechaSugTC="#LSDateFormat(rsOrden.EOfecha,'DD/MM/YYYY')#" tabindex="1"> 
				<cfelse>
					<cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1"> 
				</cfif>
			</td>

			<td align="right"><strong>Tipo Cambio:&nbsp;</strong></td>
			<td>
				<input 	type="text" name="EOtc" style="text-align:right"size="18" maxlength="18" 
						onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
						onFocus="javascript:this.select();" 
						onchange="javascript: fm(this,4);"
						value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse>#LSNumberFormat(rsOrden.EOtc,',9.0000')#</cfif>"
						tabindex="1" >
			</td>
		</tr>

		<tr> 
			<td align="right"><strong>Observaciones:&nbsp;</strong></td>
			<td><input type="text" name="Observaciones" size="50" maxlength="255" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsOrden.Observaciones#</cfif>"></td>
			<td align="right"><strong>Plazo:&nbsp;</strong></td>
			<td>
				<input 	type="text" name="EOplazo" tabindex="1" style="text-align:right" 
						onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
						onFocus="javascript:this.select();" 
						onChange="javascript:fm(this,0);" 
						value="<cfif modo EQ 'CAMBIO'>#rsOrden.EOplazo#</cfif>" size="5" maxlength="5">
			</td>
			
			<td align="right"><strong>Descuento:&nbsp;</strong></td>
			<td>
				<input 	name="EOdesc" type="text" size="18" tabindex="1" maxlength="18" style="text-align:right" 
						onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						onFocus="javascript:this.select();" 
						onchange="javascript: fm(this,2);" 
						value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse>#LSCurrencyFormat(rsOrden.EOdesc,'none')#</cfif>"></td>
		</tr>

		<tr> 
			<td align="right"><strong>Retenci&oacute;n:&nbsp;</strong></td>
			<td>
				<select name="Rcodigo" tabindex="1">
					<option value="-1" >-- Sin Retención --</option>
					<cfloop query="rsRetenciones"> 
						<option value="#rsRetenciones.Rcodigo#" <cfif modo NEQ "ALTA" and rsRetenciones.Rcodigo EQ rsOrden.Rcodigo>selected</cfif>>#rsRetenciones.Rdescripcion#</option>
					</cfloop>
				</select>
			</td>
			<td align="right"><strong>Impuesto:&nbsp;</strong></td>
			<td>
				<input 	type="text" name="Impuesto" style="text-align:right" 
						onChange="javascript: fm(this,2);" readonly tabindex="1" 
						value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsOrden.Impuesto,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18" >
			</td>
			<td align="right"><strong>Total:&nbsp;</strong></td>
			<td>
				<input 	name="EOtotal" type="text" style="text-align:right" 
						onChange="javascript: fm(this,2);" readonly tabindex="1" 
						value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsOrden.EOtotal,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18">
			</td>
		</tr>
		<tr><td colspan="6">&nbsp;</td></tr>
	</table>
	</cfoutput>

  <cfset tsE = "">	
  <cfif modo neq "ALTA">
		<cfinvoke 
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="tsE">
			<cfinvokeargument name="arTimeStamp" value="#rsOrden.ts_rversion#"/>
		</cfinvoke>
  </cfif>
  <input type="hidden" name="timestampE" value="<cfif modo NEQ 'ALTA'><cfoutput>#tsE#</cfoutput></cfif>">

<script language="JavaScript1.2">
	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {	
		var f = document.form1;
		if (f.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			formatCurrency(f.TC,2);
			f.EOtc.disabled = true;			
		}
		else
			f.EOtc.disabled = false;							

		var estado = f.EOtc.disabled;
		f.EOtc.disabled = false;
		f.EOtc.value = f.TC.value;
		f.EOtc.disabled = estado;
	}

	// Inicializa el Tipo de cambio
	function validatcLOAD()	{
	  var f = document.form1;                      		  
	  <cfif modo EQ "ALTA">
			if (f.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")	{
				f.EOtc.value = "1.0000";                                
				f.EOtc.disabled = true;
			}  
			else {
				f.Mcodigo.value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>";
				f.EOtc.value = "1.0000";
				f.EOtc.disabled = true;                    
			} 
	   <cfelse>
			if (f.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")
				f.EOtc.disabled = true;
			else
				f.EOtc.disabled = false;
	   </cfif>   
	}   
</script>

<script language="JavaScript1.2" type="text/javascript">
	var f = document.form1;
	validatcLOAD();
	<cfif modo NEQ "ALTA">
		asignaTC();
	<cfelse>
		var estado = f.EOtc.disabled;
		f.EOtc.disabled = false;
		f.EOtc.value = f.TC.value;
		f.EOtc.disabled = estado;
		tipo(document.form1.CMTOcodigo);
	</cfif>
</script>