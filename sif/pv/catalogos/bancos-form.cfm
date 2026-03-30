<cfinclude template="../../Utiles/sifConcat.cfm">

<!--- Manda por url el valor que posee el codigo de banco que se seleccionó--->
<cfif isdefined('url.Bid') and not isdefined('form.Bid')>
	<cfparam name="form.Bid" default="#url.Bid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif  isdefined('url.Bid') and len(trim(url.Bid)) and not isdefined('form.Bid')>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif  isdefined('form.Bid') and len(trim(form.Bid))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfset LvarSNcodigo = 0>
<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select Bid, CFcuenta, SNcodigo, CCTcodigo, FAM18DES, CFcuentaComision,
			 CFcuentaImp, Icodigo, fechaalta,
			 id_direccionFact,id_direccionEnvio,ts_rversion
		from FAM018
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
	</cfquery>
	<cfset LvarSNcodigo = data.SNcodigo> 
	<!--- QUERY PARA el tag de Cuenta Contable--->
	
	<cfif isdefined('data') and len(trim(data.CFcuenta))>
		<cfquery name="rsCuentas" datasource="#Session.DSN#" >
			Select  Ccuenta, CFcuenta, CFformato, CFdescripcion
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuenta#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
	
	<!--- QUERY PARA el tag de cuentas de Comison--->
	<cfif isdefined('data') and len(trim(data.CFcuentaComision))>
		<cfquery name="rsCuentasCom" datasource="#Session.DSN#" >
			Select  Ccuenta, CFcuenta, CFformato, CFdescripcion
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuentaComision#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif> 
	
	<!--- QUERY PARA el tag de cuentas de Impuesto--->
	<cfif isdefined('data') and len(trim(data.CFcuentaImp))>
		<cfquery name="rsCuentasImp" datasource="#Session.DSN#" >
			Select  Ccuenta, CFcuenta, CFformato, CFdescripcion
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuentaImp#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif> 
		
	<!--- QUERY PARA el tag de Socios de Negocios--->
	<cfif isdefined('data') and len(trim(data.SNcodigo))>
		<cfquery name="rsSocNeg" datasource="#Session.DSN#" >
			Select SNidentificacion, SNnombre, SNcodigo, SNnumero
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.SNcodigo#" >		  
				order by SNnombre
		</cfquery>	
	</cfif>
	
	<!--- QUERY PARA el tag de Bancos--->
	<cfif isdefined('Form.Bid') and len(trim(Form.Bid))>
		<cfquery name="rsBancos" datasource="#Session.DSN#">
			select Bid, Bdescripcion
			from Bancos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Bid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Bid#">
		</cfquery>
	</cfif>
</cfif>

<!--- QUERY PARA el tag de TRANSACCIONES--->
<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, substring(CCTdescripcion, 1, 25)as CCTdescripcion, CCTtipo
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 1      
</cfquery>

<!--- QUERY PARA el tag de Impuestos--->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion 
	from Impuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Idescripcion                                 
</cfquery>

<cfoutput>
<form name="form1" method="post" action="bancos-sql.cfm">
	<cfif isdefined('form.Bid_F') and len(trim(form.Bid_F))>
		<input type="hidden" name="Bid_F" value="#form.Bid_F#">	
	</cfif>
	<cfif isdefined('form.FAM18DES_F') and len(trim(form.FAM18DES_F))>
		<input type="hidden" name="FAM18DES_F" value="#form.FAM18DES_F#">	
	</cfif>	
	<table width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td align="right"><strong>Banco:</strong></td>
			<td>
				<cfif modo NEQ "ALTA">
			        <cf_pvmbancos modificable="false" idquery="#rsBancos.Bid#" PBid="#rsBancos.Bid#"> 
				<cfelse>
					 <cf_pvmbancos>
				</cfif> 
			</td>
		</tr>
		<tr>	
			<td align="right" nowrap><strong>Tipo de Transacci&oacute;n:</strong></td>
            <td>
				<select name="CCTcodigo">
				  <option value="">-seleccionar-</option>
				  <cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
					<cfloop query="rsTransacciones">
						<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigo)>selected</cfif> >#CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
					</cfloop>
				  </cfif>
				</select>
			</td>
		</tr>
		<tr>			
			<td align="right" width="23%"><strong>Descripci&oacute;n:</strong></td>			
			<td width="77%"><input type="text" name="FAM18DES" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM18DES#</cfif>"></td>
		</tr>		
		<tr>
			<td align="right" nowrap><strong>Socio de Negocios:</strong></td>
			<td>
			    <cfif modo NEQ "ALTA" and isdefined('rsSocNeg')>
			        <cf_sifsociosnegocios2 idquery="#rsSocNeg.SNcodigo#"> 
				<cfelse>
					<cf_sifsociosnegocios2 form="form1" SNcodigo="SNcodigo" SNumero="SNumero" SNdescripcion="SNdescripcion">
				
				</cfif>			
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Impuesto:</strong></td>
			<td colspan="3">
				<select name="Icodigo" tabindex="17">
					<option value="">-seleccionar-</option>
					<cfloop query="rsImpuestos"> 
						<option value="#rsImpuestos.Icodigo#" 
						<cfif modo NEQ 'ALTA' and rsImpuestos.Icodigo EQ data.Icodigo>selected</cfif>>
							#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion#
						</option>
					</cfloop> 
			</select>
			</td>
		</tr>
		<!--- <tr>	
			<td align="left" nowrap><strong>Cuenta Contable</strong></td>			
			<td>
			    		
				 <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta))>
			        <cf_cuentas query="#rsCuentas#" Ccuenta="c1" CFcuenta="CFcuenta" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1"> 
	
				<cfelse>
					<cf_cuentas Ccuenta="c1" CFcuenta="CFcuenta" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1">
				</cfif>
				
			</td>
		</tr>	 --->
		<tr>	
			<td align="right" nowrap><strong>Cuenta de Comisi&oacute;n:</strong></td>			
			<td>
			   <cfif modo NEQ "ALTA" and len(trim(data.CFcuentaComision))>
        			<cf_cuentas query="#rsCuentasCom#" Ccuenta="c2" CFcuenta="CFcuentaComision" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe2">
        		<cfelse>
        			<cf_cuentas Ccuenta="c2" CFcuenta="CFcuentaComision" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe2">
   			  </cfif>
			</td>
		</tr>
		<!--- <tr>	
			<td align="left" nowrap><strong>Cuenta de Impuesto</strong></td>			
			<td>
			   <cfif modo NEQ "ALTA" and len(trim(data.CFcuentaImp))>
        			<cf_cuentas query="#rsCuentasImp#" Ccuenta="c3" CFcuenta="CFcuentaImp" Cmayor="Cmayor3" Cformato="Cformato3" Cdescripcion="Cdescripcion3" frame="iframe3">
        		<cfelse>
        			<cf_cuentas Ccuenta="c3" CFcuenta="CFcuentaImp" Cmayor="Cmayor3" Cformato="Cformato3" Cdescripcion="Cdescripcion3" frame="iframe3">
      			</cfif>
			</td>
		</tr>		 --->
		
		<tr>
			<td colspan="2">
				<fieldset><legend><strong>Direcciones</strong></legend>
					<table width="100%"  border="0" cellspacing="0" cellpadding="1">
					  <tr>
						<td align="right" nowrap width="10%"><strong>Facturaci&oacute;n:</strong></td>
						<td width="1%">
							<cfset valuesArray = ArrayNew(1)>
							<cfif modo neq 'ALTA' and len(trim(data.id_direccionFact))>
								<cfquery name="rsDireccion" datasource="#session.DSN#">
									select 	b.id_direccion, Ppais #_Cat#' '#_Cat# rtrim(b.direccion1)#_Cat# case when rtrim(b.direccion2) is not null then ' - ' #_Cat# rtrim(b.direccion2) else null end  as direccion1, a.SNDlimiteFactura, a.SNcodigo 
								
									from SNDirecciones a, DireccionesSIF b
								
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									  and a.id_direccion = b.id_direccion
									  and a.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_direccionFact#">
									order by a.SNcodigo, direccion1	
								</cfquery>
								<cfset ArrayAppend(valuesArray, rsDireccion.id_direccion )>
								<cfset ArrayAppend(valuesArray, rsDireccion.direccion1)>
							<cfelse>
								<cfset ArrayAppend(valuesArray, '')>
								<cfset ArrayAppend(valuesArray, '')>

							</cfif>
						
							<cf_conlis
								campos="id_direccionFact, direccion1"
								desplegables="N,S"
								modificables="N,N"
								size="0,60"
								title="Lista de Direcciones"
								valuesArray="#valuesArray#"
								tabla="SNDirecciones a, DireccionesSIF b"
								columnas="b.id_direccion as id_direccionFact, Ppais #_Cat#' '#_Cat# rtrim(b.direccion1)#_Cat# case when rtrim(b.direccion2) is not null then ' - ' #_Cat# rtrim(b.direccion2) else null end  as direccion1, a.SNDlimiteFactura, a.SNcodigo "
								filtro="	a.Ecodigo = #Session.Ecodigo#
											and a.SNcodigo = $SNcodigo,integer$
											and a.id_direccion = b.id_direccion
											and a.SNDfacturacion = 1
											order by a.SNcodigo, direccion1	"
								desplegar="direccion1"
								etiquetas="Descripción"
								formatos="S"
								align="left"
								asignar="id_direccionFact, direccion1"
								asignarformatos="S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Direcciones --"
								tabindex="1">
						</td>
						<td><img src="../../imagenes/Borrar01_S.gif" alt="Borrar direcci&oacute;n" title="Limpiar direcci&oacute;n" onclick="javascript:document.form1.id_direccionFact.value=''; document.form1.direccion1.value='';" /></td>
					  </tr>
					  <tr>
						<td align="right" width="10%"><strong>Env&iacute;o:</strong></td>
						<td>
							<cfset valuesArray = ArrayNew(1)>
							<cfif modo neq 'ALTA' and len(trim(data.id_direccionEnvio))>
								<cfquery name="rsDireccion" datasource="#session.DSN#">
									select 	b.id_direccion, Ppais #_Cat#' '#_Cat# rtrim(b.direccion1)#_Cat# case when rtrim(b.direccion2) is not null then ' - ' #_Cat# rtrim(b.direccion2) else null end  as direccion1, a.SNDlimiteFactura, a.SNcodigo 
								
									from SNDirecciones a, DireccionesSIF b
								
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									  and a.id_direccion = b.id_direccion
									  and a.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_direccionEnvio#">
									order by a.SNcodigo, direccion1	
								</cfquery>
								<cfset ArrayAppend(valuesArray, rsDireccion.id_direccion )>
								<cfset ArrayAppend(valuesArray, rsDireccion.direccion1)>
							<cfelse>
								<cfset ArrayAppend(valuesArray, '')>
								<cfset ArrayAppend(valuesArray, '')>
							</cfif>
						
							<cf_conlis
								campos="id_direccionEnvio, direccion2"
								desplegables="N,S"
								modificables="N,N"
								size="0,60"
								title="Lista de Direcciones"
								valuesArray="#valuesArray#"
								tabla="SNDirecciones a, DireccionesSIF b"
								columnas="b.id_direccion as id_direccionEnvio, Ppais #_Cat#' '#_Cat# rtrim(b.direccion1)#_Cat# case when rtrim(b.direccion2) is not null then ' - ' #_Cat# rtrim(b.direccion2) else null end  as direccion2, a.SNDlimiteFactura, a.SNcodigo "
								filtro="	a.Ecodigo = #Session.Ecodigo#
											and a.SNcodigo = $SNcodigo,integer$
											and a.id_direccion = b.id_direccion
											and a.SNDenvio = 1
											order by a.SNcodigo, direccion2	"
								desplegar="direccion2"
								etiquetas="Descripción"
								formatos="S"
								align="left"
								asignar="id_direccionEnvio, direccion2"
								asignarformatos="S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Direcciones --"
								tabindex="1">
						</td>
						<td><img src="../../imagenes/Borrar01_S.gif" alt="Borrar direcci&oacute;n" title="Limpiar direcci&oacute;n" onclick="javascript:document.form1.id_direccionEnvio.value=''; document.form1.direccion2.value='';" /></td>
					  </tr>
					</table>
				</fieldset>
			</td>
		</tr>		
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>

	</table>
	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
	</cfif>
	
</form>

<cfif modo eq 'CAMBIO'>
	<fieldset><legend><strong>Comisiones Bancarias</strong></legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="comisiones_banc.cfm">
				</td>								
			</tr>
		</table>
	</fieldset>			
</cfif>

</cfoutput>
<!--- Maneja los errores--->


<cf_qforms>
<script language="javascript">
    function funcBaja() {
		if(!confirm('¿Desea eliminar el registro del '+document.form1.Bdescripcion.value+'?')){
			return false;
		}
		deshabilitarValidacion();		
		return true;
	}
	
	objForm.Bid.required = true;
	objForm.Bid.description = "Banco";
	
	objForm.FAM18DES.required = true;
	objForm.FAM18DES.description = "Descripción";
	
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description = "Socio de Negocios";
	
 	objForm.CCTcodigo.required = true;
	objForm.CCTcodigo.description = "Tipo de Transacción";
		
	function funcSNnumero(parFact,parEnvio){
		CargaDir1(parFact,parEnvio);
	}
	

	function CargaDir1(param, param2){
		<cfif modo neq 'ALTA' and LvarSNcodigo GT -1>
			var socio = '<cfoutput>#trim(LvarSNcodigo)#</cfoutput>'
		<cfelse>
			var socio = '';
		</cfif>
		if ( socio == document.form1.SNcodigo.value ){
			return;
		}
		
		document.form1.id_direccionFact.value = '';
		document.form1.direccion1.value = '';
		document.form1.id_direccionEnvio.value = '';
		document.form1.direccion2.value = '';
	}

	function deshabilitarValidacion(){
		objForm.Bid.required = false;
		objForm.FAM18DES.required = false;
		objForm.SNcodigo.required = false;
		objForm.CCTcodigo.required = false;
	}
	
	function habilitarValidacion(){
		objForm.Bid.required = true;
		objForm.FAM18DES.required = true;
		objForm.SNcodigo.required = true;
		objForm.CCTcodigo.required = true;
	}
	
</script>

<!---
	function CargaDir1(param, param2){
		var form = document.form1;
		var combo = form.id_direccionFact;
		var combo2 = form.id_direccionEnvio;
		var valor = form.SNcodigo.value;

		combo.lenght = 0;
		combo2.lenght = 0;
		var cont = 1;
		
		combo.length++;
		combo.options[0].value = '';
		combo.options[0].text = '-Ninguna-';	
		<cfoutput>
		<cfloop query="rsDirXsocio">
			var tmp = '#rsDirXsocio.SNcodigo#';
			if ( valor != '' && tmp != '' && valor == tmp ) {
				combo.length++;
				combo.options[cont].value = '#trim(rsDirXsocio.id_direccion)#';
				combo.options[cont].text = '#JSStringFormat(rsDirXsocio.direccion1)#';	

				if(param != '' && param == '#trim(rsDirXsocio.id_direccion)#'){
					combo.options[cont].selected = true;
				}

				cont++;
			}
		</cfloop>
		</cfoutput>

		var cont = 1;
		combo2.length++;
		combo2.options[0].value = '';
		combo2.options[0].text = '-Ninguna-';	
		<cfoutput>
		<cfloop query="rsDirXsocio">
			var tmp = '#rsDirXsocio.SNcodigo#';
			if ( valor != '' && tmp != '' && valor == tmp ) {
				combo2.length++;
				combo2.options[cont].value = '#trim(rsDirXsocio.id_direccion)#';
				combo2.options[cont].text = '#JSStringFormat(rsDirXsocio.direccion1)#';	

				if(param2 != '' && param2 == '#trim(rsDirXsocio.id_direccion)#'){
					combo2.options[cont].selected = true;
				}

				cont++;
			}
		</cfloop>
		</cfoutput>

	}

--->
