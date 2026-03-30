<!--- NOTAS:
		1. El query situacion_actual esta definido en registro-movimientos-form.cfm
		2. El orden para tomar los datos es el siguiente:
			2.1 Si el movimiento tiene definidos valores, desplegar estos.
			2.2 Si el movimiento no tiene valores, traer lo de la situacion actual.
		3. data_tipo esta definido en registro-movimientos-form.cfm	
--->

<!--- Configuracion del Tipo de Movimiento 
	  1. Los datos los toma del query data, definido en registro-movimientos-form.cfm	
--->
<cfset configura = structnew() >
<cfset configura.tabla = data_tipo.modtabla is 1 >
<cfset configura.categoria = data_tipo.modcategoria is 1 >
<cfset configura.estado = data_tipo.modestadoplaza is 1 >
<cfset configura.cf = data_tipo.modcfuncional is 1 >
<cfset configura.cc = data_tipo.modcentrocostos is 1 >
<cfset configura.componentes = data_tipo.modcomponentes is 1 >
<cfset configura.indicador = data_tipo.modindicador is 1 >
<cfset configura.puesto = data_tipo.modpuesto is 1 >

<cfoutput>
<script type="text/javascript" language="javascript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>

<!--- tabla --->
<cfset vRHTTid = IIf(data.RHTTid is 0, DE(situacion_actual.RHTTid), DE(data.RHTTid) ) >
<cfset vRHTTid = IIf( len(vRHTTid) gt 0, DE(vRHTTid), DE(0) ) >
<cfquery name="tabla" datasource="#session.DSN#">
	select RHTTid, RHTTcodigo, RHTTdescripcion
	from RHTTablaSalarial
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHTTid#" >
</cfquery>
<!--- puesto --->
<cfset vRHMPPid = IIf(data.RHMPPid is 0, DE(situacion_actual.RHMPPid), DE(data.RHMPPid) ) >
<cfset vRHMPPid = IIf( len(vRHMPPid) gt 0, DE(vRHMPPid), DE(0) ) >
<cfquery name="dataMP" datasource="#session.DSN#">
	select RHMPPcodigo, RHMPPdescripcion
	from RHMaestroPuestoP
	where RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHMPPid#">
</cfquery>

<!--- categoria --->
<cfset vRHCid = IIf( data.RHCid is 0, DE(situacion_actual.RHCid), DE(data.RHCid) ) >
<cfset vRHCid = IIf( len(vRHCid) gt 0, DE(vRHCid), DE('') ) >
<cfquery name="dataC" datasource="#session.DSN#">
	select RHCcodigo, RHCdescripcion
	from RHCategoria
	where
		<cfif isdefined('vRHCid') and len(trim(vRHCid))>
		 RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHCid#">
		<cfelse>
		 1 = 0
		</cfif>
</cfquery>


<cfquery name="datosTPC" datasource="#session.DSN#">
	select 	'#vRHTTid#' as RHTTid1, 
			'#vRHCid#' as RHCid1, 
			'#vRHMPPid#' as RHMPPid1,
			'#tabla.RHTTcodigo#' as RHTTcodigo1,
			'#tabla.RHTTdescripcion#' as RHTTdescripcion1,
			'#dataMP.RHMPPcodigo#' as RHMPPcodigo1,
			'#dataMP.RHMPPdescripcion#' as RHMPPdescripcion1,
			'#dataC.RHCcodigo#' as RHCcodigo1,
			'#dataC.RHCdescripcion#' as RHCdescripcion1
	from dual
</cfquery>
<table width="99%" cellpadding="0" border="0" cellspacing="0" style="padding-left:5px;">
	<cf_rhcategoriapuesto incluyeTabla="false" 
						  tablaReadonly="#configura.tabla is 0#" 
						  categoriaReadonly=#configura.categoria is 0# 
						  puestoReadonly=#configura.puesto is 0#
						  query="#datosTPC#"
                          index="1">
	
	<!--- CENTRO FUNCIONAL --->
	<cfset vCFid = IIf(data.CFidnuevo is 0, DE(situacion_actual.CFidautorizado), DE(data.CFidnuevo) ) >
	<cfquery name="cf" datasource="#session.DSN#">
		select CFid as CFidnuevo, CFcodigo as CFcodigonuevo, CFdescripcion as CFdescnuevo
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCFid#" null="#len(trim(vCFid)) is 0#">
	</cfquery>
	<tr>
		<td height="25"  nowrap="nowrap"><strong>Centro Funcional&nbsp;</strong></td>
		<td height="25">
			<cfif configura.cf >
				<cf_rhcfuncional size="25" query="#cf#" name="CFcodigonuevo" desc="CFdescnuevo" id="CFidnuevo">
				<input type="hidden" name="CFidnuevobd" value="#vCFid#">
			<cfelse>
				#trim(cf.CFcodigonuevo)# - #cf.CFdescnuevo#
				<input type="hidden" name="CFidnuevo" value="#vCFid#">
			</cfif>
		</td>
	</tr>

	<!--- ESTADO DE LA PLAZA--->
	<cfset vEstadoPlaza = IIf( len(trim(data.RHMPestadoplaza)) is 0, DE(situacion_actual.RHMPestadoplaza), DE(data.RHMPestadoplaza) ) >
	<cfset vEstadoPlazaDesc = IIf( len(trim(data.RHMPestadoplaza)) is 0, DE(situacion_actual.estadodesc), DE(data.estadodesc) ) >
	<tr>
		<td height="25"  nowrap="nowrap"><strong>Estado Plaza&nbsp;</strong></td>
		<td height="25" >
			<cfif configura.estado >
				<select name="RHMPestadoplaza" >
					<option value="A" <cfif vEstadoPlaza eq 'A' >selected</cfif> >Activo</option>
					<option value="I" <cfif vEstadoPlaza eq 'I' >selected</cfif> >Inactivo</option>
					<option value="C" <cfif vEstadoPlaza eq 'C' >selected</cfif> >Congelado</option>
				</select>
			<cfelse>
				#vEstadoPlazaDesc#
				<input type="hidden" name="RHMPestadoplaza" value="#vEstadoPlaza#">
			</cfif>
		</td>
	</tr>

	<!--- NEGOCIADO --->
	<cfset vNegociado = IIf( len(trim(data.RHMPnegociado)) is 0, DE(situacion_actual.RHMPnegociado), DE(data.RHMPnegociado) ) >
	<cfset vNegociadoDesc = IIf( len(trim(data.RHMPnegociado)) is 0, DE(situacion_actual.negociadodesc), DE(data.negociadodesc) ) >
	<!--- <tr>
		<td height="25"  nowrap="nowrap"><strong>Negociado&nbsp;</strong></td>
		<td height="25" >
			<cfif configura.indicador >
				<select name="RHMPnegociado" >
					<option value="N" <cfif vNegociado eq 'N'>selected</cfif> >Negociado</option>
					<option value="T" <cfif vNegociado eq 'T'>selected</cfif> >Tabla Salarial</option>
				</select>
			<cfelse>
				#vNegociadoDesc#
				<input type="hidden" name="RHMPnegociado" value="#vNegociado#">
			</cfif>
		</td>
	</tr> --->

	<!---
	<tr>
		<td height="25"  nowrap="nowrap"><strong>Monto:&nbsp;</strong></td>
		<td height="25" >
			<!--- **NO ESTOY SEGURO DE ESTO --->
			<!--- no me puedo dar cuenta si el monto del movimiento, es en realidad nulo, 
				  pues tiene un default de 0. Entonces se me ocurre ver si los montos son diferentes y 
				  el monto del movimiento diferente de cero y en base a eso me doy cuenta...
				  No se si esto estara correcto
			--->
			<cfif data.RHMPmonto neq situacion_actual.RHLTPmonto and data.RHMPmonto neq 0 >
				<cfset vRHMPmonto = data.RHMPmonto >
			<cfelse>
				<cfset vRHMPmonto = situacion_actual.RHLTPmonto >
			</cfif>
			<cfset vRHMPmonto = IIf( len(trim(data.RHMPmonto)) is 0, DE(situacion_actual.RHLTPmonto), DE(data.RHMPmonto) ) >
			<input type="text" name="RHMPmonto" value="<cfif len(trim(vRHMPmonto))>#LSNumberFormat(vRHMPmonto, ',9.00')#<cfelse>0.00</cfif>" tabindex="1" size="16" maxlength="16" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
		</td>
	</tr>
	--->
</table>

</cfoutput>
