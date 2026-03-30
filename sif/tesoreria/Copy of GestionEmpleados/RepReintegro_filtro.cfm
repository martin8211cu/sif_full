<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select 
			CCHid,
			CCHdescripcion,
			CCHcodigo
	from CCHica
	where Ecodigo=#session.Ecodigo#
	and CCHestado='ACTIVA'
</cfquery>

<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="50%" valign="top">
		<form name="form1" method="post" action="RepReintegros.cfm" style="margin: '0' ">
			<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td nowrap align="right"><strong>Fecha:</strong></td>
					<td colspan="2">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td nowrap valign="middle">
									<cfif isdefined ('form.TESSPfechaPago_I')>
										<cf_sifcalendario form="form1" value="#form.TESSPfechaPago_I#" name="TESSPfechaPago_I" tabindex="1">											  					  	
									<cfelse>
										<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_I" tabindex="1">
									</cfif>
								</td>
								<td nowrap align="right" valign="middle">
									<strong>&nbsp;Hasta:</strong>
								</td>
								<td nowrap valign="middle">
									<cfif isdefined ('form.TESSPfechaPago_F')>
										<cf_sifcalendario form="form1" value="#form.TESSPfechaPago_F#" name="TESSPfechaPago_F" tabindex="1">									 						
									<cfelse>
										<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_F" tabindex="1">
									</cfif>
								</td>						
							</tr>
						</table>
					</td>
				</tr>		
				<tr>
					<td nowrap align="right"><strong><cfoutput>Num.Transaccion:</cfoutput></strong></td>
					<td nowrap>
						<input type="text" name="numTran" />
					</td>							
				<tr>
					<td align="right">
						<strong>Caja:</strong>
					</td>
					<td>
						<cf_conlisCajas>
					</td>
				</tr>
				<tr>
					<td colspan="8" align="center">
							 <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" />				   
					</td>
				</tr>
			</table>
			</form>
	<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0 or isdefined ('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F)) gt 0 or isdefined ('form.TESSPfechaPago_I') and len(trim(TESSPfechaPago_I)) gt 0 or isdefined ('form.numTran') and len(trim(form.numTran))>
			<cfquery name="rsReintegro" datasource="#session.dsn#">
					select a.CCHcod,CCHTid,
							 a.CCHTdescripcion,
							 a.CCHTmonto,
							 a.BMfecha,
							 (select CCHdescripcion from CCHica where CCHid=a.CCHid) as transac
				from CCHTransaccionesProceso a
				where Ecodigo=#session.Ecodigo#
				and CCHTtipo ='REINTEGRO'
					<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
						and a.CCHid=#form.CCHid#
					</cfif>
					<cfif isdefined ('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F)) gt 0>
						and a.BMfecha <=#LSParseDateTime(form.TESSPfechaPago_F)#
					</cfif>
					<cfif isdefined ('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I)) gt 0>
						and a.BMfecha >=#LSParseDateTime(form.TESSPfechaPago_I)#
					</cfif>
					<cfif isdefined ('form.numTran') and len(trim(form.numTran)) gt 0>
						and cod =#form.CCHcod#
					</cfif>
			</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#rsReintegro#"
		Cortes=""
		desplegar="CCHcod,CCHTdescripcion,transac,BMfecha,CCHTmonto"
		etiquetas="Num.Transacción, Descripción, Caja Chica, Fecha, Monto"
		formatos="S,S,S,D,M"
		align="left,left,left,left,left"
		ira="RepReintegros.cfm"
		form_method="post"
		showEmptyListMsg="yes"
		keys="CCHTid"	
		MaxRows="18"
		navegacion=""
		filtro_nuevo="#isdefined("form.btnFiltrar")#"
	/>		

	</cfif>
