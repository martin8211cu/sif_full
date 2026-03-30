<cfif isdefined("url.FAM01COD") and not isdefined("form.FAM01COD")>
	<cfset form.FAM01COD = url.FAM01COD >
</cfif>
<cfif isdefined("url.CDCcodigo") and not isdefined("form.CDCcodigo")>
	<cfset form.CDCcodigo = url.CDCcodigo >
</cfif>
<cfif isdefined("url.FAX01DOC") and not isdefined("form.FAX01DOC")>
	<cfset form.FAX01DOC = url.FAX01DOC >
</cfif>



<script type="text/javascript" language="javascript">
	function funcValidaciones(){ 
		if (document.form.FAM01COD.value == ""){
			alert("Debe seleccionar la caja");
			return false;
		}
		document.form.submit();
		return true;
	}
	function funcAnulacion(prn_FAX01NTR,prs_FAM01COD){ //Funcion que carga en inputs ocultos los valores de la caja y el dcto a anular
		document.form.FAX01NTR.value = prn_FAX01NTR;
		document.form.FAM01COD.value = prs_FAM01COD;
	}
</script>

<cf_templateheader title="Punto de Venta">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Anulaci&oacute;n de Adelantos de Cliente">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<tr><td>&nbsp;</td></tr>

				<tr><td align="center"><font size="2"><strong>Anulaci&oacute;n de Adelantos</strong></font></td></tr>
				<cfif isdefined("form.FAM01COD") and len(trim(form.FAM01COD))>
					<cfquery name="caja" datasource="#session.DSN#">
						select FAM01COD, FAM01CODD, FAM01DES
						from FAM001
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and FAM01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM01COD#">
						order by FAM01CODD
					</cfquery>
					<tr><td align="center">Caja: <cfoutput>#trim(caja.FAM01CODD)# - #caja.FAM01DES#</cfoutput></td></tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				
				<form name="form" method="post" action="" style="margin:0;" onSubmit="javascript: return funcValidaciones();">
				<input type="hidden" name="FAX01NTR" value="">
				<tr>
					<td>
						<cfquery name="caja" datasource="#session.DSN#">
							select FAM01COD, FAM01CODD, FAM01DES 
							from FAM001
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by FAM01CODD
						</cfquery>
						
						<table width="99%" cellpadding="0" cellspacing="0" align="center">
						<tr><td>
						<cf_web_portlet_start border="true" titulo="Seleccionar Caja" skin="info1">
						<table width="99%" align="center" cellpadding="4" cellspacing="0" >
							<tr>
								<td width="1%"><strong>Caja:</strong>&nbsp;</td>
								<td>
									<select name="FAM01COD" onChange="javascript: funcValidaciones();">
										<option value="">-seleccionar-</option>
										<cfoutput query="caja">
											<option value="#caja.FAM01COD#" <cfif isdefined("form.FAM01COD") and form.FAM01COD eq caja.FAM01COD >SELECTED</cfif> >#trim(caja.FAM01CODD)# - #caja.FAM01DES#</option>
										</cfoutput>
									</select>
								</td>												
								<td align="right"><strong>Cliente:&nbsp;</strong></td>
								<td>
									<cfif isdefined('form.CDCcodigo') and len(trim(form.CDCcodigo))>
										<cf_sifClienteDetCorp CDCcodigo="CDCcodigo" form='form' idquery="#form.CDCcodigo#">
									<cfelse>
										<cf_sifClienteDetCorp CDCcodigo="CDCcodigo" form='form' >
									</cfif>			
								</td>
								<td align="right"><strong>No.Recibo:&nbsp;</strong></td>
								<td>
									<input type="text" name="FAX01DOC" value="<cfif isdefined("form.FAX01DOC") and len(trim(form.FAX01DOC))><cfoutput>#form.FAX01DOC#</cfoutput></cfif>" size="10" maxlength="20">
								</td>
								<td align="center"><input type="submit" name="Consultar" value="Consultar"></td>
							</tr>
						</table>
						<cf_web_portlet_end>
						</td></tr>
						</table> 						
					</td>
				</tr>
				
				<cfif isdefined("form.FAM01COD") and len(trim(form.FAM01COD))>
					<tr>
						<td>							
							<cfquery name="data" datasource="#session.DSN#">
								select 	a.FAX01NTR as Id_Dcto,
										c.FAM01COD as Id_Caja,
										c.FAM01CODD as CodigoCaja,
										a.FAX01DOC as Documento,
										a.FAX01FEC as FechaAdelanto, 
										a.FAX01TOT as MontoAdelanto, 
										(select min(f.CDCidentificacion) 
											from ClientesDetallistasCorp f 
										where f.CDCcodigo = a.CDCcodigo) as IdentificacionCliente,
										(select min(f.CDCnombre) 
											from ClientesDetallistasCorp f 
										where f.CDCcodigo = a.CDCcodigo) as NombreCliente,
										(select min(o.Oficodigo) 
											from Oficinas o where o.Ecodigo = c.Ecodigo 
											  and o.Ocodigo = c.Ocodigo) as CodigoOficina,
										(select min(e.Miso4217) 
											from Monedas e 
										where e.Mcodigo = a.Mcodigo) as MonedaAdelanto
								from FAM001 c
										inner join FAX001 a
										 on a.FAM01COD = c.FAM01COD
										 and a.Ecodigo = c.Ecodigo
								where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and c.FAM01COD =<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">
								  <cfif isdefined("form.FAX01DOC") and len(trim(form.FAX01DOC))>
								  	and a.FAX01DOC = <cfqueryparam cfsqltype="char" value="#form.FAX01DOC#">
								  </cfif>								
								  <cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
								  	and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
								  </cfif>
								  and a.FAX01STA = 'T'
								  and a.FAX01TPG = 0
								  and ((a.FAX01TIP ='9'  and 0.00 =(select sum(b.FAX14MAP) 
											 	from FAX014 b 
											 	where a.FAX01NTR = b.FAX01NTR 
											  		and a.Ecodigo = b.Ecodigo 
											  		and b.FAX14CLA = '2')) 
									or (a.FAX01TIP ='3' ))
										
								order by a.FAX01DOC	
							</cfquery>	
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="2%">&nbsp;</td>
									<td class="tituloListas" width="10%">Caja&nbsp;</td>
									<td class="tituloListas" width="20%">Documento&nbsp;</td>
									<td class="tituloListas" width="7%">Fecha&nbsp;</td>
									<td class="tituloListas" width="15%" align="right">Monto&nbsp;</td>
									<td class="tituloListas" width="35%">Cliente&nbsp;</td>
									<td class="tituloListas" width="15%">Oficina&nbsp;</td>
									<td class="tituloListas" width="5%">Moneda&nbsp;</td>
								</tr>
								<cfif data.recordcount gt 0 >
									<cfoutput query="data">
										<tr title="Anular Transacci&oacute;n" style="cursor:pointer;" onMouseOver="javascript:this.className='listaParSel'" onMouseOut="this.className='<cfif data.currentrow mod 2 >listaPar<cfelse>listaNon</cfif>'" class="<cfif data.currentrow mod 2 >listaPar<cfelse>listaNon</cfif>">
											<td width="2%" valign="top"><input type="radio" name="opt" value="" onClick="javascript: funcAnulacion('#data.Id_Dcto#','#data.Id_Caja#')"></td>
											<td width="10%" valign="top">#data.CodigoCaja#&nbsp;</td>
											<td width="20%" valign="top">#data.Documento#&nbsp;</td>
											<td width="7%" valign="top">#LSDateFormat(data.FechaAdelanto,'dd/mm/yyyy')#&nbsp;</td>
											<td width="15%" align="right" valign="top">#LSNumberFormat(data.MontoAdelanto,',9.00')#&nbsp;</td>
											<td width="35%" valign="top">#data.IdentificacionCliente# - #data.NombreCliente#&nbsp;</td>
											<td width="15%" valign="top">#data.CodigoOficina#&nbsp;</td>
											<td width="5%" valign="top">#data.MonedaAdelanto#&nbsp;</td>
										</tr>
									</cfoutput>
								<cfelse>
									<tr><td colspan="8" align="center">--- No se encontraron anulaciones de adelanto para los filtros seleccionados ---</td></tr>	
								</cfif>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="8"><table width="100%" cellpadding="0" cellspacing="0"><tr>
										<td width="16%" align="right"><strong>Motivo de anulaci&oacute;n:&nbsp;</strong></td>
										<td colspan="5"><input type="text" name="FAX01OBS" value="" size="100" maxlength="255"></td>
										<td width="14%" align="left"><input type="submit" name="btn_anular" value="Anular" onClick="javascript: funcAnular();"></td>
									</tr></table></td>
								</tr>
							</table>
						</td>
					</tr>					
				</cfif>
				<tr><td>&nbsp;</td></tr>
			</form>
            
			</table>		
		<cf_web_portlet_end>
<cf_templatefooter>

<cf_qforms form="form">
    <cf_qformsrequiredfield args="FAX01OBS,Motivo de anulación">
</cf_qforms>

<script type="text/javascript" language="javascript">
	function funcAnular(){ //Funcion para realizar el submit al SQL que anula el dcto
		if (confirm("Esta seguro que desea anular el adelanto?")){
			document.form.action = "anulacion-sql.cfm";
		}
	}
</script>

