<cfset modo = 'ALTA'>
<cfif isdefined('form.FAM09MAQ') and len(trim(form.FAM09MAQ))
 	and isdefined('form.CCTcodigo') and len(trim(form.CCTcodigo))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAM09MAQ, FAM12COD, CCTcodigo, ts_rversion
		from FAM014
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">
		and FAM12COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">
	</cfquery>
</cfif> 

<!--- QUERY PARA EL COMBO DE MAQUINAS--->
<cfquery name="maquinas" datasource="#session.DSN#">
	select FAM09MAQ, FAM09DES
	from FAM009
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by FAM09DES
</cfquery>


<!--- QUERY PARA EL COMBO DE IMPRESORAS--->
<cfquery name="impresoras" datasource="#session.DSN#">
	select FAM12COD, FAM12CODD, FAM12DES
	from FAM012
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by FAM12DES
</cfquery>


<!---  QUERY DE TRANSACCIONES--->

<cfquery name="transacciones" datasource="#session.DSN#">
	select CCTcodigo, CCTdescripcion
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CCTdescripcion
</cfquery>


<!-- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="form1" method="post" action="maq_imp-sql.cfm">
	<!---<cfif modo neq 'ALTA'>
		<input type="hidden" name="FAM09MAQ" value="#data.FAM09MAQ#">
	</cfif>--->
	<table width="100%" cellpadding="3" cellspacing="0">
		<tr>
		    <!-- dibuja el combo de maquinas --->
			<!--- cf_sifimpresoras lista de Impresoras--->
			<td width="50%" align="right">Maquina:&nbsp;</td>
			<td width="50%">
				<cfif modo NEQ "ALTA">
					<cf_sifmaquinas form="form1" idquery="#data.FAM09MAQ#"> 
				<cfelse>
					<cf_sifmaquinas form="form1">
				</cfif> 		
		    </td>
		</tr>
			
			
			<!---<td align="right">Maquinas:&nbsp;</td>
			<td>
				<select name="FAM09MAQ">
				  <option value="">-seleccionar-</option>
					<cfloop query="maquinas">
						<option value="#maquinas.FAM09MAQ#" <cfif modo neq 'ALTA' and maquinas.FAM09MAQ eq data.FAM09MAQ>selected</cfif> >#maquinas.FAM09DES#</option>
					</cfloop>
				</select>
			</td>
		</tr>--->
		
		<!-- dibuja el combo de impresoras  AQUI PUEDO PONER EL TAG  --->
		 <!--- cf_sifimpresoras lista de Impresoras--->
			<td width="50%" align="right">Impresora:&nbsp;</td>
			<td width="50%">
				<cfif modo NEQ "ALTA">
					<cf_sifimpresoras form="form1" idquery="#data.FAM12COD#"> 
				<cfelse>
					<cf_sifimpresoras form="form1">
				</cfif> 		
		    </td>
		</tr>
		 
		<tr>
		    <!-- dibuja el combo de Transacciones--->
			<td align="right">Transacciones:&nbsp;</td>
			<td>
				<select name="CCTcodigo">
				  <option value="">-seleccionar-</option>
					<cfloop query="transacciones">
						<option value="#transacciones.CCTcodigo#" <cfif modo neq 'ALTA' and transacciones.CCTcodigo eq data.CCTcodigo>selected</cfif> >#transacciones.CCTdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>


		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
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

<!-- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript">
	<!--//
	objForm.FAM09MAQ.description = "Maquinas";
	objForm.FAM12COD.description = "Impresoras";
	objForm.CCTcodigo.description = "Transacción";
	
	function habilitarValidacion(){
		objForm.FAM09MAQ.required = false;
		objForm.FAM12COD.required = false;
		objForm.CCTcodigo.required = false;
	}
	
	function deshabilitarValidacion(){
	objForm.FAM09MAQ.required = false;
	objForm.FAM12COD.required = false;
	objForm.CCTcodigo.required = false;
	}
	
	habilitarValidacion();
	//-->
</script>
</cfoutput>