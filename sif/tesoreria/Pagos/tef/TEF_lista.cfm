<!--- 
	Creado por: Oscar Bonilla
		Fecha: 4-NOV-2009
		Motivo: Emisión de Transferencias de Fondos
				Impresión de Instrucciones de Pago y
				Generación de Transferencias Electrónicas
--->

<cf_navegacion name="CBidPago_F">

<cfif not (isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1')>
	<cf_navegacion name="EcodigoPago_F">
	<cf_navegacion name="Miso4217Pago_F">
</cfif>
<cf_navegacion name="TESOPfechaPago_F">
<!--- <cf_navegacion name="Beneficiario_F"> --->

<table width="100%" border="0" cellspacing="6">
  <tr>
	<td width="50%" valign="top">
		<form name="formFiltro" method="post" action="<cfoutput>#GvarTEF.TEF#</cfoutput>.cfm" style="margin: '0' ">
			<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td nowrap align="right">
					<strong>Trabajar con Tesorería:</strong>&nbsp;
				</td>
				<td>
					<cf_cboTESid onchange="this.form.submit();" tabindex="1">
				</td>
				<td width="23%" align="right"><strong>Empresa Pago:</strong></td>
				<td width="23%">
					<cf_cboTESEcodigo name="EcodigoPago_F" tabindex="1">
				</td>
				<td width="23%" align="right" nowrap>
					<strong>Moneda Pago:</strong>
				</td>
				<td width="23%">
					<cfquery name="rsMonedas" datasource="#session.DSN#">
						select distinct Miso4217, (select min(Mnombre) from Monedas m2 where m.Miso4217=m2.Miso4217) as Mnombre
						from Monedas m 
							inner join TESempresas e
								 on e.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
								and e.Ecodigo = m.Ecodigo
					</cfquery>
					
					<select name="Miso4217Pago_F" tabindex="1">
						<option value="">(Todas las monedas)</option>
						<cfoutput query="rsMonedas">
							<option value="#Miso4217#" <cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F EQ Miso4217>selected</cfif>>#Mnombre#</option>
						</cfoutput>
					</select>
				</td>
				<td width="23%" rowspan="2" align="center" valign="middle">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2">
				</td>
			  </tr>
			  <tr>
				<td align="right" nowrap>
					<strong>Cuenta Pago:</strong>
				</td>					
				<td>
					<cf_cboTESCBid name="CBidPago_F" Ccompuesto="yes" all="yes" onChange="javascript: cambioCB(this);" tabindex="1">
				</td>										


				<td width="9%" nowrap align="right" valign="middle">
					<strong>Fecha del Lote:</strong>
				</td>
				<td width="15%" nowrap valign="middle">
					<cfset fechadoc = ''>
					<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
						<cfset fechadoc = LSDateFormat(form.TESOPfechaPago_F,'dd/mm/yyyy') >
					</cfif>
					<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESOPfechaPago_F" tabindex="1">												
				</td>


			  </tr>
			</table>
			<cfoutput>
			<input type="checkbox" name="chkRe#GvarTEF.Accion2#" tabindex="2"
				<cfif isdefined("form.chkRe#GvarTEF.Accion2#")>checked</cfif>
				onclick="this.form.submit();"
				> Listar Ordenes a Re#GvarTEF.Accion2#
			</cfoutput>
		</form>
		<cfquery datasource="#session.dsn#" name="lista">
			Select	TESTLid,
					case TESTLestado
						when 0 then '<strong>En preparacion</strong>'
						when 1 then '<strong>En #GvarTEF.Accion#</strong>'
						when 2 then '<strong>No Emitido</strong>'
						when 3 then '<strong>Emitido</strong>'
					end as Estado,
					fl.CBid,
					TESTLfecha,
					Edescripcion as empPago,
					CBcodigo,
					m.Mcodigo,
					Mnombre,
					TESMPdescripcion
			from TEStransferenciasL fl
				inner join TEScuentasBancos tcb
					inner join CuentasBancos cb
					inner join Monedas m
						 on m.Mcodigo 	= cb.Mcodigo
						and m.Ecodigo  	= cb.Ecodigo
					inner join Empresas e
						on e.Ecodigo	= cb.Ecodigo
					 on cb.CBid=tcb.CBid
					 on tcb.TESid	= fl.TESid
					and tcb.CBid	= fl.CBid
					and tcb.TESCBactiva = 1
				inner join TESmedioPago mp
					 on mp.TESid		= fl.TESid
					and mp.CBid			= fl.CBid
					and mp.TESMPcodigo 	= fl.TESMPcodigo
			where fl.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
              and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
			  and fl.TESTMPtipo = #GvarTEF.TESTMPtipo#				
				<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
					and fl.TESTLfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
				</cfif>

				<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
					and fl.CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
				<cfelse>
					<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
						and e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
					</cfif>						
					<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
						and m.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
					</cfif>							
				</cfif>					
				<cfif isdefined("form.chkRe#GvarTEF.Accion2#")>
					and fl.TESTLestado = 3
				<cfelse>
					and fl.TESTLestado <= 2
				</cfif>
		</cfquery>
		
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="TESTLid,Estado,TESTLfecha,empPago,CBcodigo,Mnombre,TESMPdescripcion"
			etiquetas="Num.Lote, Estado, Fecha Lote, Empresa Pago, Cuenta Pago, Moneda Pago, Medio Pago"
			formatos="S,S,D,S,S,S,S"
			align="right,center,center,left,left,left,left"
			ira="#GvarTEF.TEF#.cfm"
			form_method="post"
			showEmptyListMsg="yes"
			keys="TESTLid"
			navegacion="#navegacion#"
		/>		
	</td>
  </tr>
<cfif NOT isdefined("form.chkRe#GvarTEF.Accion2#")>
	<tr>		  
		<td>		
			  <input name="btnNuevo" type="button" tabindex="2"
		<cfoutput>
			  	value="Agregar Nuevo Lote de Transferencias #GvarTEF.TEF#" 
				onClick="location.href='#GvarTEF.TEF#.cfm?btnNuevo=1'">
		</cfoutput>
		</td>
	</tr>		  
</cfif>
</table>
