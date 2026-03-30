<cfset modo = 'ALTA'>
<cfif isdefined('form.CCTcodigo') and len(trim(form.CCTcodigo))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select a.FAM09MAQ, a.FAM12COD, a.CCTcodigo, a.FAX01ORIGEN, b.OIDescripcion, a.ts_rversion
		from FAM014 a
			inner join OrigenesInterfazPV b
				on a.FAX01ORIGEN = b.FAX01ORIGEN
				and b.Ecodigo = a.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">
		and a.FAM12COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">
		and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
		and a.FAX01ORIGEN = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">
		
	</cfquery>	
</cfif> 
<!--- QUERY PARA OBTENER LA MAQUINA--->
<cfquery name="rsmaquinas" datasource="#session.DSN#">
		select FAM09MAQ, FAM09DES
		from FAM009
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM09MAQ=<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">
		order by FAM09DES
</cfquery>

<cfquery name="rsOriInter" datasource="#session.DSN#">
	select Ecodigo,FAX01ORIGEN,OIDescripcion 
	   from OrigenesInterfazPV
	   where Ecodigo = #session.Ecodigo#
	  </cfquery>

<cfif rsmaquinas.recordcount eq 0>
	<cf_errorCode	code = "50567" msg = "Error en la página. No se ha podido obtener la información de la máquina.">
</cfif>

<!--- QUERY PARA EL COMBO DE IMPRESORAS  CREO QUE YA NO LO NECESITO--->
<cfquery name="impresoras" datasource="#session.DSN#">
		select FAM12COD, FAM12CODD, FAM12DES
		from FAM012
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by FAM12DES
</cfquery>

<!--- FALTA QUERY DE TRANSACCIONES--->
<cfquery name="transacciones" datasource="#session.DSN#">
		select CCTcodigo, CCTdescripcion
		from CCTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by CCTdescripcion
</cfquery>

<!---pinta el formulario--->
<cfoutput>
<form name="form1" method="post" action="cajasProceso_Paso2-sql.cfm">	
<table width="100%" cellpadding="3" cellspacing="0">
	<tr>
		<td>
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="CCTcodigo_ANT" value="#data.CCTcodigo#">
				<input type="hidden" name="FAX01ORIGEN_ANT" value="#data.FAX01ORIGEN#">
				<input type="hidden" name="FAM12COD_ANT" value="#data.FAM12COD#">
			
		</cfif>
		<input type="hidden" id="FAM09MAQ" name="FAM09MAQ" value="#rsmaquinas.FAM09MAQ#">
		</td>
	</tr>
    <tr>
		<!--- cf_sifimpresoras lista de Impresoras--->
		<td width="50%" align="right">Impresora:&nbsp;</td>
		<td width="50%">
			<cfif modo NEQ "ALTA">
				<cf_sifimpresoras form="form1" idquery="#data.FAM12COD#" modificable = "false"> 
			<cfelse>
				<cf_sifimpresoras form="form1">
			</cfif> 		
		    </td>
		</tr>
		 			
        <tr>
		    <!-- dibuja el combo de Transacciones--->
			<td align="right"><strong>Transacciones:&nbsp;</strong></td>
			<td>
				<select name="CCTcodigo" tabindex="3">
				  <option value="">-seleccionar-</option>
					<cfloop query="transacciones">
						<option value="#transacciones.CCTcodigo#" <cfif modo neq 'ALTA' and transacciones.CCTcodigo eq data.CCTcodigo>selected</cfif> >#CCTcodigo#-#transacciones.CCTdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		 <tr>
		    <!-- dibuja el combo de Transacciones--->
			<td align="right"><strong>Origenes:&nbsp;</strong></td>
			<td>
			<!---<cfif modo NEQ "ALTA">
				#data.FAX01ORIGEN# - #data.OIDescripcion#
				<input type="hidden" name="FAX01ORIGEN" value="#data.FAX01ORIGEN#" />
			<cfelse>--->
				<select name="FAX01ORIGEN" tabindex="3">
				  <option value="">-seleccionar-</option>
					<cfloop query="rsOriInter">
						<option value="#rsOriInter.FAX01ORIGEN#" <cfif modo neq 'ALTA' and rsOriInter.FAX01ORIGEN eq data.FAX01ORIGEN>selected</cfif> >#FAX01ORIGEN#-#rsOriInter.OIDescripcion#</option>
					</cfloop>
				</select>
			<!---</cfif>--->
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" nowrap align="center">
				<cf_botones modo="#modo#">
			<table>
				<tr>
			    	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><cf_botones names="Anterior,Siguiente" values="<< Anterior, Siguiente >>"></td>
				</tr>
			</table>
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


<cf_qforms>
<script language="javascript">
	<!--//
	
	objForm.FAM12COD.description = "Impresoras";
	objForm.CCTcodigo.description = "Transacción";
	objForm.FAX01ORIGEN.description = "Origen";
	
	function habilitarValidacion(){
		objForm.FAM12COD.required = true;
		objForm.CCTcodigo.required = true;
		objForm.FAX01ORIGEN.required = true;
	}
	function deshabilitarValidacion(){
		objForm.FAM12COD.required = false;
		objForm.CCTcodigo.required = false;
		objForm.FAX01ORIGEN.required = false;
	}
	habilitarValidacion();
	//-->
</script>
</cfoutput>

