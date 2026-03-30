<cfset modo="ALTA">
<cfif isdefined('form.NPPId') and len(trim(form.NPPId)) >
	<cfset modo="CAMBIO">
</cfif>

<!--- Seleccion de los datos del articulo---->
<cfquery name="rsArticulo" datasource="#Session.DSN#">
	select Acodigo, Adescripcion, AFMid
	from Articulos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
</cfquery>

<!---- Seleccion de las marcas ---->
<cfquery name="rsMarcas" datasource="#session.DSN#">
	select AFMid, AFMcodigo, AFMdescripcion 
	from AFMarcas 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and AFMuso in ('I','A')
</cfquery>

<cfif modo NEQ 'ALTA'>
	<!---- Seleccion de los datos de la tabla NumParteProveedor ---->
	<cfquery name="rsNumeros" datasource="#Session.DSN#">
		select NPPid,Aid,AFMid,Ecodigo,SNcodigo,NumeroParte,Vdesde,
			  	Vhasta,BMUsucodigo,fechaalta,ts_rversion
		from NumParteProveedor
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			and NPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NPPid#">
	</cfquery>
</cfif>


<!---<script language="JavaScript" src="../../js/utilesMonto.js"></script>----->
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form action="SQLNumerosParte.cfm" method="post" name="form1" onSubmit="javascript: return valida()">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="Pagina3" type="hidden" tabindex="-1" value="#form.Pagina3#">		
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
	<input type="hidden" name="filtro_Acodigo" value="<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>#form.filtro_Acodigo#</cfif>">
	<input type="hidden" name="filtro_Acodalterno" value="<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>#form.filtro_Acodalterno#</cfif>">
	<input type="hidden" name="filtro_Adescripcion" value="<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>#form.filtro_Adescripcion#</cfif>">		
	<input type="hidden" name="Aid" value="#form.Aid#">

	<table width="100%" cellpadding="1" cellspacing="1" border="0" align="center">		
		<tr>
			<td nowrap colspan="8" align="center">
				<strong>Art&iacute;culo:&nbsp;#rsArticulo.Acodigo# - #rsArticulo.Adescripcion#</strong>
			</td>
		</tr>
		<tr><td colspan="8">&nbsp;</td></tr>

		<tr>		
			<td width="11%" align="right" nowrap><strong>N° Parte:</strong>&nbsp;</td>
			<td>
				<table width="100%">
			  		<tr>
						<td width="13%" nowrap>
							<input tabindex="1" name="NumeroParte" type="text"  value="<cfif modo NEQ 'ALTA'>#rsNumeros.NumeroParte#<cfelse></cfif>" style="text-align:left;" size="18" maxlength="20">
							<input name="NumeroParte2" type="hidden" value="<cfif modo NEQ 'ALTA'>#rsNumeros.NumeroParte#<cfelse>''</cfif>">
						</td>
						<td width="14%" align="right" nowrap><strong>Valido desde:</strong>&nbsp;</td>
						<td width="10%" nowrap>
							<cfif modo NEQ 'ALTA'>
								<cf_sifcalendario  tabindex="1" conexion="#session.DSN#" form="form1" name="Vdesde" value="#LSDateFormat(rsNumeros.Vdesde,'dd/mm/yyyy')#">
							<cfelse>
								<cf_sifcalendario  tabindex="1" conexion="#session.DSN#" form="form1" name="Vdesde" value="">
							</cfif>
						</td>
						<td width="11%" align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
						<td width="10%" nowrap>
							<cfif modo NEQ 'ALTA'>
								<cf_sifcalendario tabindex="1" conexion="#session.DSN#" form="form1" name="Vhasta" value="#LSDateFormat(rsNumeros.Vhasta,'dd/mm/yyyy')#">
							<cfelse>
								<cf_sifcalendario tabindex="1" conexion="#session.DSN#" form="form1" name="Vhasta" value="">
							</cfif>
						</td>
			
						<td width="7%" align="right" nowrap><strong>Marca:</strong>&nbsp;</td>
						<td width="35%" nowrap>
							<select name="AFMid" tabindex="1">
								<option value="">Ninguna</option>
								<cfloop query="rsMarcas">					
									<option value="#rsMarcas.AFMid#"  <cfif modo neq 'ALTA' and rsMarcas.AFMid eq rsNumeros.AFMid >selected<cfelseif modo EQ 'ALTA' and rsMarcas.AFMid eq rsArticulo.AFMid>selected</cfif> >#rsMarcas.AFMcodigo# - #rsMarcas.AFMdescripcion#</option>
								</cfloop>						
							</select>
						</td>						
					</tr>
				</table>
			</td>	
		</tr>
		
		<tr>
			<td width="11%" align="right" nowrap><strong>Socio Negocio:</strong>&nbsp;</td>
			<td width="89%">
				<cfif modo neq 'ALTA'>
					<cf_sifsociosnegocios2 idquery="#rsNumeros.SNcodigo#" tabindex="1">
				<cfelse>
					<cf_sifsociosnegocios2 tabindex="1">
				</cfif>
			</td>
		</tr>
		<tr><td colspan="2" >&nbsp;</td></tr>
		<tr align="center">
			<td colspan="6">
				<cf_Botones modo="#modo#" include="Regresar" includevalues="Regresar" tabindex="1">
			</td>
		</tr>
    	
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsNumeros.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="NPPid" value="<cfif modo NEQ 'ALTA'>#rsNumeros.NPPid#</cfif>">
    	</cfif>
	</table>
</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");	
	
	objForm.Vdesde.required = true;
	objForm.Vdesde.description="Válido desde";				

	objForm.Vhasta.required = true;
	objForm.Vhasta.description="Válido hasta";
	
	objForm.NumeroParte.required = true;
	objForm.NumeroParte.description="Número parte";	
	
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description="Socio de negocio";			
	
	function deshabilitarValidacion(){
		objForm.Vdesde.required = false;
		objForm.Vhasta.required = false;
		objForm.NumeroParte.required = false;
		objForm.SNcodigo.required = false;
	}

	function valida(){
		<cfif modo NEQ 'ALTA'>
			var vfDesde = convFecha(document.form1.Vdesde.value);
			var vfHasta = convFecha(document.form1.Vhasta.value);
			if(vfDesde > vfHasta){
				alert('La fecha desde no puede ser mayor a la fecha hasta');						
				return false;
			}
		</cfif>
	}
	
	function funcRegresar(){
		deshabilitarValidacion();
	}	
	
	objForm.NumeroParte.focus();
</script>