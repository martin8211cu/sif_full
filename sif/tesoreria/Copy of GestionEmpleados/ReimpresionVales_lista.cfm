<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="50%" valign="top">
		<form name="formFiltro" method="post" action="ReimpresionVales.cfm" style="margin: '0' ">
		<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
			<tr>
<!---FILTRO DE EMPLEADO--->
				<td nowrap align="right">
					<strong>Empleado:</strong></td>
				<td nowrap>	
					<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">					
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" idempleado="#form.DEid#">
					<cfelse>
						<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2">
					</cfif>					
				</td>			
<!---FILTRO DE FECHA--->				
				<td nowrap align="right"><strong>Fecha:</strong></td>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td nowrap valign="middle">
								<cfif isdefined ('form.TESSPfechaPago_I')>
									<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_I#" name="TESSPfechaPago_I" tabindex="1">											  					  	
								<cfelse>
									<cf_sifcalendario form="formFiltro" value="" name="TESSPfechaPago_I" tabindex="1">
								</cfif>
							</td>
							<td nowrap align="right" valign="middle">
								<strong>&nbsp;Hasta:</strong>
							</td>
							<td nowrap valign="middle">
								<cfif isdefined ('form.TESSPfechaPago_F')>
									<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_F#" name="TESSPfechaPago_F" tabindex="1">									 						
								<cfelse>
									<cf_sifcalendario form="formFiltro" value="" name="TESSPfechaPago_F" tabindex="1">
								</cfif>
							</td>						
						</tr>
					</table>
				</td>
			</tr>		
			<tr>
<!---FILTRO DE NU. ANTICIPO o LIQUIDACIÓN--->
				<td nowrap align="right"><strong><cfoutput>Num.Vale:</cfoutput></strong></td>
				<td nowrap>
					<input type="text" name="numVale" />
				</td>
				
				<td nowrap align="right"><strong><cfoutput>Estado:</cfoutput></strong></td>
				<td nowrap>
					<select name="estado">
						<option value="0">--</option>
						<option value="1">Aplicado</option>
						<option value="2">Cancelado</option>
						<option value="3">Por liquidar</option>
					</select>
				</td>								
			</tr>
<!---FILTRAR--->		
			<tr>
				<td ></td>
				<td >
				<div align="right">
						 <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" />				   
					 </div>
				</td>
			</tr>
</table>
</form>
<table width="100%">
<!---QUERY DE SELECCIÓN--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select 
		v.CCHVid,        
		v.CCHVnumero,
		v.CCHVestado,
		v.GEAid,            
		(select TESBeneficiario from TESbeneficiario where TESBid=(select TESBid from GEanticipo where GEAid=v.GEAid)) as name,
		v.GELid,                 
		v.CCHVusucodigoGenera,
		v.CCHVfecha,
		v.CCHVmontonOrig,
		v.CCHVmontoAplicado,
		v.CCHVusucodigoAplica,
		v.CCHVfechaAplica, 
		v.CCHTid
		from CCHVales v
		where Ecodigo=#session.Ecodigo#
		<cfif isdefined ('form.numVale') and len(trim(form.numVale)) gt 0>
			and CCHVnumero=#form.numVale#
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F))>
			and v.CCHVfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_F)#">
		</cfif>	
		<cfif isdefined('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I))>
			and v.CCHVfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESSPfechaPago_I)#">
		</cfif>
		<!---
		<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">	
			and v.TESBid=
			(select TESBid
					from TESbeneficiario 
					where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">)
		</cfif>	--->
		<cfif isdefined ('form.estado') and len(trim(form.estado))	gt 0 and form.estado neq 0>
			<cfif form.estado EQ 1>
				and CCHVestado='APLICADO'
			</cfif>
			<cfif form.estado EQ 2>
				and CCHVestado='CANCELADO'
			</cfif>
			<cfif form.estado EQ 3>
				and CCHVestado='POR LIQUIDAR'
			</cfif>
		</cfif>
</cfquery>

<tr>
	<td>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#rsSQL#"
			Cortes=""
			desplegar="CCHVnumero,CCHVestado,name,CCHVfecha,CCHVmontonOrig,CCHVmontoAplicado"
			etiquetas="Num.Vale,Estado,Empleado,Fecha, Monto </br> Original,Monto</br>Aplicado"
			formatos="S,S,S,D,M,M"
			align="left,left,left,left,right,right"
			ira="ReimpresionVales.cfm"
			form_method="post"
			showEmptyListMsg="yes"
			keys="CCHVid"	
			MaxRows="18"
			navegacion=""
			filtro_nuevo="#isdefined("form.btnFiltrar")#"
		/>		
	</td>
</tr>
</table>
