<cfif isdefined("url.RHMPid") and not isdefined("form.RHMPid")>
	<cfparam name="form.RHMPid" default="#url.RHMPid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.RHMPid") and len(trim(form.RHMPid))>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfif modo eq 'ALTA'>
	<!--- Tipo de Movimiento --->
	<cfquery name="tipo" datasource="#session.DSN#">
		select tm.RHTMid, 
			   tm.RHTMcodigo, 
			   tm.RHTMdescripcion, 
			   tm.RHTMcomportamiento, 
			   tm.modfechahasta
		from RHTipoMovimiento tm
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ( not exists ( 	select 1 
							from RHUsuariosTipoMovCF utm
							where utm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and utm.RHTMid=tm.RHTMid  )
			  or  exists( select 1 
						  from RHUsuariosTipoMovCF utm
						  where utm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						    and utm.RHTMid= tm.RHTMid
						    and utm.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">  ) )
	</cfquery>
	
	<!--- Rol de Crear Plaza --->
	<cfset tiene_rol = false >
	<cfquery name="creaPlaza" datasource="#session.DSN#">
		select 1
		from UsuarioRol
		where SRcodigo='CREAPLAZA'
		and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
	</cfquery>
	<cfif creaPlaza.recordcount gt 0 >
		<cfset tiene_rol = true >
	</cfif>	
	
	<cfoutput>
	 <form method="post" name="form1" style="margin:0;" onsubmit="javascript: return validar(this);" action="registro-movimientos-sql.cfm">
	<input type="hidden" name="RHPPidnuevo" value="" />
 	<table width="98%" cellpadding="1" cellspacing="0" border="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right" width="45%"><strong>Tipo de Movimiento:</strong>&nbsp;</td>
			<td>
				<select tabindex="1" name="RHTMid" onchange="javascript:cambia_tipo(this);" >
					<option value="">- seleccionar -</option>
					<cfloop query="tipo">
						<cfif tipo.RHTMcomportamiento eq 10 and tiene_rol >
							<option value="#tipo.RHTMid#">#trim(tipo.RHTMcodigo)# - #tipo.RHTMdescripcion#</option>
						<cfelseif tipo.RHTMcomportamiento neq 10  >
							<option value="#tipo.RHTMid#">#trim(tipo.RHTMcodigo)# - #tipo.RHTMdescripcion#</option>
						</cfif>
					</cfloop>	
				</select>
			</td>
		</tr>

		<!----=======================--->
		<tr>
			<td align="right"><strong>Puesto de RH:</strong>&nbsp;</td>
			<td>
				<cf_rhpuesto name="RHPcodigo" desc="RHdescpuesto" empresa="#session.Ecodigo#" size="30" form="form1" tabindex="1">							
			</td>
		</tr>
		<!----=======================--->		
		<tr id="pp_existe" style="display:none;" >
			<td align="right"><strong>Plaza Presupuestaria:</strong>&nbsp;</td>
			<cfquery name="plaza" datasource="#session.DSN#">
				select RHPPid, RHPPcodigo, RHPPdescripcion
				from RHPlazaPresupuestaria
				where RHPPid = <cfif isdefined("url.RHPPid") and len(trim(url.RHPPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHPPid#"><cfelse>0</cfif>
			</cfquery>
			<cfif isdefined("url.RHPPid") and len(trim(url.RHPPid)) >
				<cfset idplaza = url.RHPPid >
			<cfelse>
				<cfset idplaza = 0 >
			</cfif>
			<td><cf_rhplazapresupuestaria idquery="#idplaza#" tabindex="1"></td>
		</tr>

		<tr id="pp_noexiste_cod" style="display:none;" >
			<td align="right"><strong>C&oacute;digo Plaza Presupuestaria:</strong>&nbsp;</td>
			<td><input tabindex="1" type="text" name="RHPPcodigoNuevo" id="RHPPcodigoNuevo" maxlength="15" size="10" onfocus="this.select()" ></td>
		</tr>

		<tr id="pp_noexiste_desc" style="display:none;" >
			<td align="right"><strong>Descripci&oacute;n Plaza Presupuestaria:</strong>&nbsp;</td>
			<td><input tabindex="1" type="text" name="RHPPdescripcionNuevo" id="RHPPdescripcionNuevo" maxlength="255" size="30" value=""></td>
		</tr>

		<cfset fecha = LSDateFormat(now(), 'dd/mm/yyyy') >
		<tr>
			<td align="right"><strong>Fecha Desde:&nbsp;</strong></td>
			<td><cf_sifcalendario name="RHMPfdesde" value="#fecha#" tabindex='1' onChange="no_error();"></td>
		</tr>

		<tr id="usa_fecha" style="display:none;" >
			<td align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
			<td><cf_sifcalendario name="RHMPfhasta" value="" tabindex="1" onChange="no_error();"></td>
		</tr>
		<tr>
			<cfset valor_monto = 0 >
			<td align="right"><strong>Porcentaje Asignado:</strong></td>
			<td><cf_inputNumber name="RHTMporcentaje" value="#valor_monto#" size="5" enteros="3" onChange="verificaMonto(this.value)" tabindex="1">%</td>
		</tr>
		<tr id="msgerror" style="display:none;">
			<td colspan="2" align="center"><font color="##FF0000">* La Plaza Presupuestaria no tiene un corte en la Línea del Tiempo Vigente. <br />Por favor verifique las fechas Desde y Hasta del Movimiento</font></td>
		</tr>

		<tr><td>&nbsp;</td></tr>

		<tr><td colspan="2" align="center"><input type="submit" name="Agregar" value="Guardar" tabindex="1" /></td></tr>

		<tr><td>&nbsp;</td></tr>
	</table>
	</form> 
	</cfoutput>

	<script language="javascript1.2" type="text/javascript">
		var pts = new Object();
	
		<cfoutput query="tipo">
			pts['#RHTMid#'] = new Array();
			pts['#RHTMid#'][0] = #tipo.RHTMcomportamiento#;
			pts['#RHTMid#'][1] = #tipo.modfechahasta#;
		</cfoutput>
	
	
		function cambia_tipo( obj ){
			var f = document.form1;
			
			if ( obj.value != '' ){
				
				// limpia la fecha hasta
				if ( pts[obj.value][1] == 0 ) {
					document.form1.RHMPfhasta.value = '';
				}
				
				if ( pts[obj.value][0] == 10 ) {
					document.getElementById('pp_existe').style.display = 'none';
					document.getElementById('pp_noexiste_cod').style.display = '';
					document.getElementById('pp_noexiste_desc').style.display = '';
				}
				else{
					document.getElementById('pp_existe').style.display = '';
					document.getElementById('pp_noexiste_cod').style.display = 'none';
					document.getElementById('pp_noexiste_desc').style.display = 'none';
				}
	
				if ( pts[obj.value][1] == 0 ){
					document.getElementById('usa_fecha').style.display = 'none';
				}
				else{
					document.getElementById('usa_fecha').style.display = '';
				}
			}
			else{
				document.getElementById('pp_existe').style.display = 'none';
				document.getElementById('pp_noexiste_cod').style.display = 'none';
				document.getElementById('pp_noexiste_desc').style.display = 'none';
				document.getElementById('usa_fecha').style.display = 'none';
			}
		}
		
		function validar(f){
			var mensaje = 'Se presentaron los siguientes errores:\n';
			var mensaje2 = '';
			if ( f.RHTMid.value == '' ){
				alert( mensaje + ' - El campo Tipo de Movimiento es requerido.\n');
				return false;
			}
			
			if ( pts[f.RHTMid.value][0] == 10 ){
				if ( f.RHPPcodigoNuevo.value == '' ) {
					mensaje2 +=  ' - El campo Código de Plaza Presupuestaria es requerido.\n';
				}
				if ( f.RHPPdescripcionNuevo.value == '' ) {
					mensaje2 += ' - El campo Descripción de Plaza Presupuestaria es requerido.\n';
				}
			}
			else{
				if ( f.RHPPid.value == '' ) {
					mensaje2 += ' - El campo Plaza Presupuestaria es requerido.\n';
				}
			}
			
			if ( f.RHMPfdesde.value == '' ) {
				mensaje2 += ' - El campo Fecha Desde es requerido.\n';
			}
			
			if (f.RHTMporcentaje.value==''){
				mensaje2 +=' - El campo Porcentaje es requerido.\n';
			}
			
			if (f.RHTMporcentaje.value==0){
				mensaje2 +=' - El campo Porcentaje debe de ser mayor que cero.\n';
			}
			
			if (f.RHTMporcentaje.value>100){
				mensaje2 +=' - El campo Porcentaje debe de ser menor que 100.\n';
			}
			/* Plaza de RH */
			if ( f.RHPcodigo.value == '' ) {
				mensaje2 += ' - El campo Plaza de RH es requerido.\n';
			}
			
			if ( pts[f.RHTMid.value][1] == 1 ){
				if ( f.RHMPfhasta.value == '' ) {
					mensaje2 += ' - El campo Fecha Hasta es requerido.\n';
				}
			}

			if (mensaje2 != ''){
				alert(mensaje + mensaje2);
				return false;
			}
			
			document.form1.RHPPdescripcion.disabled = false;

			return true;
		}

		<cfif isdefined("url.errorfecha")>
			function error(){
				document.getElementById('msgerror').style.display = '';
				<cfoutput>
				document.form1.RHTMid.value = '#url.RHTMid#';
				document.form1.RHMPfdesde.value = '#url.RHMPfdesde#';
				document.getElementById('pp_existe').style.display = '';				
				<cfif isdefined("url.RHMPfhasta") and len(trim(url.RHMPfhasta))>
					document.getElementById('usa_fecha').style.display = '';
					document.form1.RHMPfhasta.value = '#url.RHMPfhasta#';
				</cfif>
				
				</cfoutput>
			}
			error();
			
			function no_error(){
				document.getElementById('msgerror').style.display='none';
			}
		<cfelse>
			function no_error(){};
		</cfif>

			function verificaMonto(a){
				if (a> 100){
					alert ('El porcentaje no puede ser mayor de 100');
					document.form1.RHTMporcentaje.value=0;
							}
				if (a.value==0){
				alert('El campo Porcentaje debe de ser mayor que cero');
				document.form1.RHTMporcentaje.value=100;
								}
			}
	</script>

<cfelse>
	
	<cfquery name="data" datasource="#session.DSN#">
		select RHMPid, 
			   coalesce(RHPPid, 0) as RHPPid, 
			   RHPPcodigo, 
			   RHPPdescripcion, 
			   RHTMid, 
			   RHMPfdesde, 
			   RHMPfhasta,
			   coalesce(RHMPPid, 0) as RHMPPid, 
			   coalesce(RHCid, 0) as RHCid, 
			   coalesce(RHTTid, 0) as RHTTid, 
			   RHMPnegociado, 
			   case RHMPnegociado when 'N' then 'Negociado' when 'T' then 'Tabla Salarial' end as negociadodesc,
			   coalesce(RHMPmonto, 0) as RHMPmonto, 
			   RHMPestadoplaza,
			   case RHMPestadoplaza when 'A' then 'Activo' when 'I' then 'Inactivo' when 'C' then 'Congelado' end as estadodesc,
			   coalesce(CFidant, 0) as CFidant, 
			   coalesce(CFidnuevo, 0) as CFidnuevo, 
			   coalesce(CFidcostoant, 0) as CFidcostoant, 
			   coalesce(CFidcostonuevo, 0) as CFidcostonuevo,
			   CPcuenta,
			   ts_rversion,
			   RHPcodigo,
			   RHTMporcentaje			   
		from RHMovPlaza
		where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPid#">
	</cfquery>
	
	<cfquery name="data_tipo" datasource="#session.DSN#">
		select 	RHTMcodigo, 
				RHTMdescripcion, 
				RHTMcomportamiento, 
				modfechahasta,
			    modtabla, 
				modcategoria, 
				modestadoplaza, 
				modcfuncional, 
				modcentrocostos, 
				modcomponentes, 
				modindicador, 
				modpuesto

		from RHTipoMovimiento
		where RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHTMid#">
	</cfquery>
	
	<!--- Query con la plza presupuestaria. Si aun no tiene plaza, toma los datos del movimiento --->
	<cfif data_tipo.RHTMcomportamiento neq 10 and data.RHPPid neq 0 >
		<cfquery name="plaza" datasource="#session.DSN#">
			select RHPPcodigo, RHPPdescripcion 
			from RHPlazaPresupuestaria
			where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
		</cfquery>
	<cfelse>
		<cfset plaza = querynew('RHPPcodigo,RHPPdescripcion') >
		<cfset QueryAddRow(plaza, 1) >
		<cfset QuerySetCell(plaza, 'RHPPcodigo', data.RHPPcodigo) >
		<cfset QuerySetCell(plaza, 'RHPPdescripcion', data.RHPPdescripcion) >
	</cfif>

	<cfoutput>

	<form name="form1" style="margin:0;" method="post" action="registro-movimientos-sql.cfm" onsubmit="return validar();" >
	<input type="hidden" name="borrar" value="0" />
	<table width="95%" align="center" cellpadding="2" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="1%" nowrap="nowrap"><strong>N&uacute;mero de Movimiento:&nbsp;</strong></td>
			<td>#data.RHMPid#</td>
		</tr>

		<tr>
			<td width="1%" nowrap="nowrap"><strong>Tipo de Movimiento:&nbsp;</strong></td>
			<td>#trim(data_tipo.RHTMcodigo)# - #data_tipo.RHTMdescripcion#</td>
		</tr>

		<cfif data_tipo.RHTMcomportamiento eq 10 >
			<tr>
				<td align="right" nowrap="nowrap"><strong>C&oacute;digo Plaza Presupuestaria:</strong>&nbsp;</td>
				<td>
					<input tabindex="1" type="text" name="RHPPcodigo" id="RHPPcodigo" maxlength="15" size="10" onfocus="this.select()" value="#trim(data.RHPPcodigo)#" >
					<input tabindex="1" type="text" name="RHPPdescripcion" id="RHPPdescripcion" maxlength="255" size="30" value="#trim(data.RHPPdescripcion)#">
				</td>
			</tr>
			<!--- Cuenta de Presupuesto  --->
			<cfset vCPcuenta = IIF( len(trim(data.CPcuenta)), DE(data.CPcuenta), DE(0) ) >
			<cfquery name="cuenta" datasource="#session.DSN#">
				select CPcuenta, CPformato, CPdescripcion
				from CPresupuesto 
				where CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCPcuenta#">
			</cfquery>
			<tr>
				<td height="25"  nowrap="nowrap"><strong>Cuenta Presupuestaria:&nbsp;</strong></td>
				<td height="25" >
					<cf_CuentaPresupuesto form="form1" idvalue="#cuenta.CPcuenta#" value="#cuenta.CPformato#">
				</td>
			</tr>
		<cfelse>
			<cfset desde = LSDateFormat(data.RHMPfdesde,'dd/mm/yyyy') >
			<cfset hasta = '' >
			<tr>
				<td width="1%" nowrap="nowrap"><strong>Plaza Presupuestaria:&nbsp;</strong></td>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0">
						<td width="40%">#trim(plaza.RHPPcodigo)# - #plaza.RHPPdescripcion#</td>					
						<td width="1%" nowrap="nowrap"><strong>Fecha Rige:&nbsp;</strong></td>
						<td >#desde#</td>
						<cfif data_tipo.modfechahasta eq 1 >
							<cfif len(trim(data.RHMPfhasta))>
								<cfset hasta = LSDateFormat(data.RHMPfhasta, 'dd/mm/yyyy') >
							</cfif>
							<td width="1%" nowrap="nowrap" align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
							<td width="25%">#hasta#</td>
						</cfif>
					</table>
				</td>
			</tr>
			
			<!--- Cuenta de Presupuesto  --->
			<cfset vCPcuenta = IIF( len(trim(data.CPcuenta)), DE(data.CPcuenta), DE(0) ) >
			<cfquery name="cuenta" datasource="#session.DSN#">
				select CPcuenta, CPformato, CPdescripcion
				from CPresupuesto 
				where CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCPcuenta#">
			</cfquery>
			<tr>
				<td height="25"  nowrap="nowrap"><strong>Cuenta Presupuestaria:&nbsp;</strong></td>
				<td height="25" >
					<cf_CuentaPresupuesto form="form1" idvalue="#cuenta.CPcuenta#" value="#cuenta.CPformato#">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td valign="middle"><a href="javascript:consulta(#data.RHPPid#, '#desde#', '#hasta#' );"><strong>Consultar empleados afectados por el movimiento&nbsp;</strong></a></td>
							<td valign="middle"><a href="javascript:consulta(#data.RHPPid#, '#desde#', '#hasta#' );"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" /></a></td>
						</tr>
						 
					</table>
				</td>
			</tr>
			
		</cfif>
		<!-----============== Puesto de RH ===============----->
		<tr>
			<td><strong>Puesto de RH:</strong>&nbsp;</td>
			<td>
				<cfif isdefined("data.RHPcodigo") and len(trim(data.RHPcodigo))>
					<cfquery name="rsPuestoRH" datasource="#session.DSN#">
						select RHPcodigo, RHPdescpuesto,coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext
						from RHPuestos
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.RHPcodigo#">
					</cfquery>
					
					<cf_rhpuesto name="RHPcodigo" desc="RHPdescpuesto" empresa="#session.Ecodigo#" size="30" form="form1" query="#rsPuestoRH#">			
				<cfelse>
					<cf_rhpuesto name="RHPcodigo" desc="RHPdescpuesto" empresa="#session.Ecodigo#" size="30" form="form1">
				</cfif>												
			</td>
		</tr>
		<!-----=========================================----->			
		<tr>
			<td><strong>Porcentaje Asignado:</strong></td>
			<td>
				<cfif isdefined('data.RHTMporcentaje') and len(trim(data.RHTMporcentaje)) gt 0>
				<cfset valor_monto = data.RHTMporcentaje >
				<cf_inputNumber name="RHTMporcentaje" value="#valor_monto#" size="5" enteros="3" onChange="verificaMonto(this.value)" tabindex="1">
				</cfif>%
			</td>
		</tr>
	</table>
	</cfoutput>	
	
	<!--- sutuacion actual | situacion propuesta--->
	<!--- Query de situacion actual, se usa en rm-situacion-actual.cfm y rm-situacion-propuesta.cfm --->
	<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="situacionActual" returnvariable="situacion_actual" > 
		<cfinvokeargument name="RHPPid" 	value="#data.RHPPid#" > 
		<cfinvokeargument name="RHMPfdesde"	value="#LSDateFormat(data.RHMPfdesde,'dd/mm/yyyy')#" > 
	</cfinvoke>
	
	<!--- Query Componentes Actuales --->
	<cfquery name="rsComponentesActual" datasource="#session.DSN#">
		select ltc.CSid, cs.CScodigo, cs.CSdescripcion, ltc.Monto, cs.CSusatabla, ltc.ts_rversion, #data.RHMPid# as RHMPid, ltc.Cantidad, 0 as MontoBase
		from RHCLTPlaza ltc

		inner join RHLineaTiempoPlaza ltp
		on ltp.RHLTPid=ltc.RHLTPid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#data.RHMPfdesde#"> between ltp.RHLTPfdesde and ltp.RHLTPfhasta
		and ltp.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
	
		inner join ComponentesSalariales cs
		on cs.CSid=ltc.CSid

		where ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by cs.CSorden, cs.CScodigo, cs.CSdescripcion
	</cfquery>
	
	<!--- Componentes Propuestos (componentes que no estan en los actuales ) --->
	<cfquery name="rsComponentesPropuestos" datasource="#session.DSN#">
		select ltc.RHCMPid, 
			   ltc.CSid, 
			   cs.CScodigo, 
			   cs.CSdescripcion, 
			   ltc.Monto as MontoRes, 
			   0 as MontoBase,
			   cs.CSusatabla, 
			   ltc.RHMPid, 
			   ltc.Cantidad,
			   ltc.ts_rversion,
			   coalesce(cs.CIid, -1) as CIid,
			   cs.CSusatabla,
			   cs.CSsalariobase,
			   coalesce(c.RHMCcomportamiento, 1) as RHMCcomportamiento,
			   c.RHMCvalor as valor
		from RHCMovPlaza ltc
		
		inner join RHMovPlaza ltp
		on ltp.RHMPid=ltc.RHMPid
		and ltp.RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPid#">
	
		inner join ComponentesSalariales cs
		on cs.CSid=ltc.CSid
		
		 left outer join RHMetodosCalculo c
		 on c.Ecodigo = cs.Ecodigo
		 and c.CSid = cs.CSid
		 and <cfqueryparam cfsqltype="cf_sql_date" value="#data.RHMPfdesde#"> between c.RHMCfecharige and c.RHMCfechahasta
		 and c.RHMCestadometodo = 1

		where ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ltc.RHMPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPid#">
		order by cs.CSorden, cs.CScodigo, cs.CSdescripcion
	</cfquery>
	
	<!--- Componentes Propuestos (componentes que no estan en los actuales ) --->
	<cfquery name="hayComponentes" datasource="#session.DSN#" maxrows="1">
		select 1 from RHCMovPlaza where RHMPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPid#">
	</cfquery>
	
	<!--- Monto total de componentes para un movimiento de plazas --->
	<cfquery name="CTotal" datasource="#session.DSN#">
		select coalesce(sum(Monto), 0) as monto
		from RHCMovPlaza
		where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPid#">
	</cfquery>

	<!--- Monto total de componentes para un movimiento de plazas --->
	<cfquery name="LTPTotal" datasource="#session.DSN#">
		select coalesce(sum(ltcp.Monto), 0) as monto
		from RHCLTPlaza ltcp
		
		inner join RHLineaTiempoPlaza ltp
		on ltp.RHLTPid = ltcp.RHLTPid
		and RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#data.RHMPfdesde#"> between ltp.RHLTPfdesde and ltp.RHLTPfhasta
		
		where ltcp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	
	<cfoutput>
	<input type="hidden" name="RHMPid" value="#data.RHMPid#" />
	<input type="hidden" name="RHTMid" value="#data.RHTMid#" />
	<input type="hidden" name="RHMPfdesde" value="#LSDateFormat(data.RHMPfdesde, 'dd/mm/yyyy')#" />
	<input type="hidden" name="RHMPfhasta" value="#LSDateFormat(data.RHMPfhasta, 'dd/mm/yyyy')#" />
	<input type="hidden" name="RHPPid" value="#data.RHPPid#" />
	<input type="hidden" name="CSid_Borrar" value="" />
	<input type="hidden" name="componentes" value="#data_tipo.modcomponentes#" />

	</cfoutput>
	
	<table width="95%" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="50%" valign="top"><cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Situacion Actual" tituloalign="center"><cfinclude template="rm-situacion-actual.cfm"><cf_web_portlet_end></td>
			<td width="50%" valign="top"><cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Situacion Propuesta" tituloalign="center"><cfinclude template="rm-situacion-propuesta.cfm"><cf_web_portlet_end></td>
		</tr>
		<tr>
			<td width="50%" valign="top"><cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Componentes Actuales" tituloalign="center"><cfinclude template="rm-componentes-actual.cfm"><cf_web_portlet_end></td>
			<td width="50%" valign="top"><cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Componentes Propuestos" tituloalign="center"><cfinclude template="rm-componentes-propuestos.cfm"><cf_web_portlet_end></td>
		</tr>		
		<tr><td colspan="2" align="center">
			<input type="submit" name="Guardar" value="Guardar" onclick="javascript: document.form1.borrar.value=0;" />
			<input type="submit" name="Aplicar" value="Aplicar" onclick="javascript: document.form1.borrar.value=0; return confirm('Desea aplicar el movimiento?')" />
			<input type="submit" name="Eliminar" value="Eliminar" onclick="javascript: if ( confirm('Desea eliminar el movimiento?')){ document.form1.borrar.value=1; return true; } return false;" />
			<input type="button" name="Nuevo" value="Nuevo" onclick="javascript: location.href='registro-movimientos.cfm';" />
			<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href='movimientos.cfm';">
		</td></tr>
	</table>	
	</form>
	
	<script type="text/javascript" language="javascript1.2">
		
		function validar(){
			var msj   = '';
			
			if( document.form1.borrar.value == '1'){ return true }
			
			<cfif configura.tabla >
				if ( document.form1.RHTTid.value == '' || document.form1.RHTTid.value == 0){
					msj += ' - El campo Tabla Salarial es requerido.\n'
				}
			</cfif>

			<cfif configura.categoria >
				if ( document.form1.RHCid.value == '' || document.form1.RHCid.value == 0){
					msj += ' - El campo Categoría es requerido.\n'
				}
			</cfif>

			<cfif configura.puesto >
				if ( document.form1.RHMPPid.value == '' || document.form1.RHMPPid.value == 0){
					msj += ' - El campo Puesto es requerido.\n'
				}
			</cfif>

			<cfif configura.cf >
				if ( document.form1.CFidnuevo.value == '' || document.form1.CFidnuevo.value == 0){
					msj += ' - El campo Centro Funcional es requerido.\n'
				}
			</cfif>

			if ( document.form1.CPcuenta.value == '' ) {
				msj += ' - El campo Cuenta Presupuestaria es requerido.\n';
			}
			
			if (document.form1.RHTMporcentaje.value==''){
				msj +=' - El campo Porcentaje es requerido.\n';
			}
			
			if (document.form1.RHTMporcentaje.value==0){
				msj +=' - El campo Porcentaje debe de ser mayor que cero.\n';
			}
			
			if (document.form1.RHTMporcentaje.value>100){
				msj +=' - El campo Porcentaje debe de ser menor que 100.\n';
			}
			/* Plaza de RH */
			if ( document.form1.RHPcodigo.value == '' ) {
				msj += ' - El campo Plaza de RH es requerido.\n';
			}

			if ( msj != '' ){
				alert('Se presentaron los siguientes errores:\n' + msj)
				return false;
			}
		
			return true;
		}
		

		function consulta(plaza, desde, hasta){
			var id = window.open('/cfmx/rh/admplazas/operacion/rm-consultaEmpleados.cfm?RHPPid='+plaza+'&fdesde='+desde+'&fhasta='+hasta, 'empleados', 'toolbar=no,location=no,directories=no,status=no,menubar=no,width=800,height=500,scrollbars=yes,resizable=no,copyhistory=yes,screenX=100,screenY=75');
		}
		
			function verificaMonto(a){
				if (a> 100){
					alert ('El porcentaje no puede ser mayor de 100');
					document.form1.RHTMporcentaje.value=0;
							}
				if (a.value==0){
				alert('El campo Porcentaje debe de ser mayor que cero');
				document.form1.RHTMporcentaje.value=100;
								}
			}
	</script>
</cfif>
