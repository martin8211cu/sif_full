<cfif isdefined('url.FAX01ORIGEN') and not isdefined('form.FAX01ORIGEN')>
	<cfparam name="form.FAX01ORIGEN" default="#url.FAX01ORIGEN#">
</cfif>
<cfset modo = 'ALTA'>

<cfif isdefined('form.FAX01ORIGEN') and len(trim(form.FAX01ORIGEN))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select 	FAX01ORIGEN, 
				CCTcodigoAP, 
				CCTcodigoDE, 
				CCTcodigoFC,
				CCTcodigoCR, 
				CCTcodigoRC				
		from TDocumentosXOrigen
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  FAX01ORIGEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX01ORIGEN#">
	</cfquery>	
	</cfif>
	<!--- QUERY PARA el tag de TRANSACCIONES--->
<cf_dbfunction name="spart" args="CCTdescripcion,1,25" returnvariable="LvarSubstring">
<cfquery name="rsTransacciones" datasource="#session.DSN#">
	select CCTcodigo, 
	#LvarSubstring# as CCTdescripcion, 
	CCTtipo
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CCTcodigo
</cfquery>
    <!--- QUERY PARA el tag de ORIGENES--->
<cfquery name="rsOrigenes" datasource="#session.DSN#">
	select FAX01ORIGEN, OIDescripcion 
	from OrigenesInterfazPV 
	where Ecodigo = <cfqueryparam cfsqltype = "cf_sql_integer" value="#session.Ecodigo#" >
</cfquery>

<!---<cfdump var="#rsTransacciones#">--->
<cfoutput>
<form name="form1" method="post" action="tiposDocumentosPorOrigen_sql.cfm" onSubmit="javascript: return validaMon();">
	<table width="100%" cellpadding="3" cellspacing="0">
	    <tr>
			<td align="right"><strong>Origen</strong></td>
        	<td>
				<select name="FAX01ORIGEN" id="FAX01ORIGEN">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsOrigenes') and rsOrigenes.recordCount GT 0>
						<cfloop query="rsOrigenes">
							<option value="#rsOrigenes.FAX01ORIGEN#" <cfif modo neq 'ALTA' and trim(rsOrigenes.FAX01ORIGEN) eq trim(data.FAX01ORIGEN)>selected</cfif> >#rsOrigenes.FAX01ORIGEN#--#rsOrigenes.OIDescripcion#</option>
						</cfloop>
					</cfif>
	            </select>
			</td>
		</tr>		
		<tr>
		  <td align="right"><strong>Fac Contado</strong></td>
        	<td>
				<select name="CCTcodigoFC" id="CCTcodigoFC">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'D'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoFC)>selected</cfif> >#rsTransacciones.CCTcodigo#-#rsTransacciones.CCTdescripcion# </option>
							</cfif>
						</cfloop>
					</cfif>
	            </select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Fac Cr&eacute;dito</strong></td>
        	<td>
				<select name="CCTcodigoCR" id="CCTcodigoCR">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'D'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoCR)>selected</cfif> >#rsTransacciones.CCTcodigo#-#rsTransacciones.CCTdescripcion# </option>
							</cfif>
						</cfloop>
					</cfif>
	            </select>
			</td>
		</tr>
		<tr>	
			<td align="right"><strong>Doc Apartado</strong></td>
        	<td>
				<select name="CCTcodigoAP" id="CCTcodigoAP">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'D'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoAP)>selected</cfif> >#rsTransacciones.CCTcodigo#-#rsTransacciones.CCTdescripcion# </option>
							</cfif>
						</cfloop>
					</cfif>
	            </select>
			</td>
		</tr>
		<tr>
		  <td align="right"><strong>Doc Devoluciones</strong></td>
        	<td>
				<select name="CCTcodigoDE" id="CCTcodigoDE">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'C'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoDE)>selected</cfif> >#rsTransacciones.CCTcodigo#-#rsTransacciones.CCTdescripcion# </option>
							</cfif>
						</cfloop>
					</cfif>
	            </select>
			</td>
		</tr>

		<tr>
			<td align="right"><strong>Recibo</strong></td>
        	<td>
				<select name="CCTcodigoRC" id="CCTcodigoRC">
					<option value="">-seleccionar-</option>
					<cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
						<cfloop query="rsTransacciones">
							<cfif rsTransacciones.CCTtipo eq 'C'>
								<option value="#rsTransacciones.CCTcodigo#" <cfif modo neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigoRC)>selected</cfif> >#rsTransacciones.CCTcodigo#-#rsTransacciones.CCTdescripcion# </option>
							</cfif>
						</cfloop>
					</cfif>
	            </select>
			</td>
		</tr>
				<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
					<!--<input type="hidden" name="FAX01ORIGEN" value="#data.FAX01ORIGEN#">-->				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
</form>

<!-- MANEJA LOS ERRORES  NOTA:QUE REVISEN ESTO EN LA BD! --->
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
	objForm.FAX01ORIGEN.description = "Origen";
	objForm.CCTcodigoFC.description = "Factura de Contado";	
	objForm.CCTcodigoCR.description = "Factura de Credito";	
	objForm.CCTcodigoAP.description = "Documento de Apartado";	
	objForm.CCTcodigoDE.description = "Documento de Devoluciones";	
	objForm.CCTcodigoRC.description = "Recibo";	


	function validaMon(){
		return true;
	}	
	
	function habilitarValidacion(){
		objForm.FAX01ORIGEN.required = true;
		objForm.CCTcodigoFC.required = true;
		objForm.CCTcodigoCR.required = true;
		objForm.CCTcodigoAP.required = true;
		objForm.CCTcodigoDE.required = true;
		objForm.CCTcodigoRC.required = true;		
	}
	function deshabilitarValidacion(){
		objForm.Descripcion.required = false;
		objForm.CFcuenta.required = false;
		objForm.TipoTrans.required = false;		
	}
	habilitarValidacion();
	//-->
</script>
</cfoutput>