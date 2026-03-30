<cfset modoFD = 'ALTA'>
<cfif isdefined('form.FAM01COD') and len(trim(form.FAM01COD)) and  isdefined('form.CCTCOD') and len(trim(form.CCTCOD)) and  isdefined('form.FaxOrigen') and len(trim(form.FaxOrigen))>
	<cfset modoFD = 'CAMBIO'>
</cfif>
<cfif modoFD eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAM01COD, FMT01COD, CCTcodigo,FAX01ORIGEN, ts_rversion
		from FAM001D
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01COD#">
		and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTCOD#">
		and  FAX01ORIGEN = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FaxOrigen#">
	</cfquery>
</cfif>	

<!--- QUERY PARA EL TAG DE TRANSACCIONES--->
<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, substring(CCTdescripcion, 1, 25)as CCTdescripcion, CCTtipo
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 1      
</cfquery>
	
<!--- QUERY PARA EL TAG DE FORMATOS DE IMPRESION--->
<cfquery name="rsFormatos" datasource="#session.dsn#">
	select FMT01COD, FMT01DES as FMT01DES, FMT01TIP
	from FMT001
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and FMT01TIP = 14
</cfquery>	
<!--- QUERY PARA ORIGENES DE INTERFAZ--->
<cfquery name="rsOriInter" datasource="#session.dsn#">
	select Ecodigo,FAX01ORIGEN,OIDescripcion 
	   from OrigenesInterfazPV
	  where Ecodigo = #session.Ecodigo#
</cfquery>
<script language="javascript" type="text/javascript">
	
	function funcAgregar(){
		objForm.CCTcodigo.required = true;
		objForm.FMT01COD.required = true;
		objForm.FAX01ORIGEN.required = true;
	}
</script>	
	
<cfoutput>
<table width="100%" cellpadding="3" cellspacing="0">
	<tr>	
		<td align="right" nowrap><strong>Tipo de Transacci&oacute;n</strong></td>
       	<td>
			<select name="CCTcodigo">
        	<option value="">-seleccionar-</option>
            <cfif isdefined('rsTransacciones') and rsTransacciones.recordCount GT 0>
            	<cfloop query="rsTransacciones">
                	<option value="#rsTransacciones.CCTcodigo#" <cfif modoFD neq 'ALTA' and trim(rsTransacciones.CCTcodigo) eq trim(data.CCTcodigo)>selected</cfif> >#rsTransacciones.CCTcodigo#-#rsTransacciones.CCTdescripcion#</option>
                </cfloop>
            </cfif>
           	</select>
		</td>
	</tr>
	<tr>	
		<td align="right" nowrap><strong>Formatos de Impresi&oacute;n</strong></td>
		<td><select name="FMT01COD">
		  <option value="">-seleccionar-</option>
		  <cfif isdefined('rsFormatos') and rsFormatos.recordCount GT 0>
			<cfloop query="rsFormatos">
				<option value="#rsFormatos.FMT01COD#" <cfif modoFD neq 'ALTA' and trim(rsFormatos.FMT01COD) eq trim(data.FMT01COD)>selected</cfif> >#FMT01COD#-#rsFormatos.FMT01DES#</option>
			</cfloop>
		  </cfif>
		</select></td>
	</tr>
	<!---Origenes de Intefaz--->
	<tr>	
		<td align="right" nowrap><strong>Origen: </strong></td>
		<td>
			<select name="FAX01ORIGEN">
		  		<option value="">-seleccionar-</option>
		  			<cfif isdefined('rsOriInter') and rsOriInter.recordCount GT 0>
						<cfloop query="rsOriInter">
							<option value="#rsOriInter.FAX01ORIGEN#" <cfif modoFD neq 'ALTA' and trim(rsOriInter.FAX01ORIGEN) eq trim(data.FAX01ORIGEN)>selected</cfif> >#rsOriInter.FAX01ORIGEN#-#rsOriInter.OIDescripcion#</option>
						</cfloop>
		 			 </cfif>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<cfif modoFD neq 'ALTA'>
				<cf_botones modo='#modoFD#' exclude="Cambio,Baja,Nuevo" include="Eliminar, NuevoFD" includevalues="Eliminar, Nuevo">
			<cfelse>
				<cf_botones modo='#modoFD#' exclude="Alta,Limpiar" include="Agregar">
			</cfif>
		</td>
	</tr>
</table>

<cfif modoFD neq 'ALTA'>
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#data.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</cfif>

<!--- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
	objForm.FMT01COD.description = "Formatos de Impresión";
	objForm.CCTcodigo.description = "Tipo de Transacción";
	objForm.FAX01ORIGEN.description = "Origen";

	
	function validaMon(){
		return true;
	}	
	
/*	function habilitarValidacion(){
		objForm.FMT01COD.required = true;
	}
	function deshabilitarValidacion(){
		
			objForm.FMT01COD.required = false;

	}*/
	//habilitarValidacion();
	//-->
</script>
</cfoutput>
