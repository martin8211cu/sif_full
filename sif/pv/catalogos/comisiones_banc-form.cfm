<cfset modoCB = 'ALTA'>
<cfif isdefined('form.FAM19LIN') and len(trim(form.FAM19LIN)) and  isdefined('form.Bid') and len(trim(form.Bid))>
	<cfset modoCB = 'CAMBIO'>
</cfif>

<cfif modoCB eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAM19LIN, Bid, FAM19INF, FAM19SUP, FAM19MON, FAM19PRI, ts_rversion 
		from FAM019 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM19LIN = <cfqueryparam cfsqltype="cf_sql_integer " value="#form.FAM19LIN#">
		and Bid = <cfqueryparam cfsqltype="cf_sql_integer " value="#form.Bid#">
	</cfquery>

<!--- QUERY PARA ID de BANCOS--->
	<cfquery name="rsBancos" datasource="#Session.DSN#" >
		Select Bid, FAM18DES
		from FAM018
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Bid#" >		  
			order by FAM18DES
	</cfquery>
</cfif> 

<cfoutput>
<form name="formCB" method="post" action="comisiones_banc-sql.cfm">
	<cfif isdefined('form.Bid') and len(trim(form.Bid))>
		<input type="hidden" name="Bid" value="#form.Bid#">
	</cfif>
	<cfif isdefined("Form.Bid_F") and Len(Trim(Form.Bid_F)) NEQ 0>
		<input type="hidden" name="Bid_F" value="#form.Bid_F#">
	</cfif>	
	<cfif isdefined("Form.FAM18DES_F") and Len(Trim(Form.FAM18DES_F)) NEQ 0>
		<input type="hidden" name="FAM18DES_F" value="#form.FAM18DES_F#">
	</cfif>
	<table width="100%" cellpadding="3" cellspacing="0">
		<!--- OTROS CAMPOS--->
		 <cfif modoCB NEQ "ALTA">
			<input type="hidden" name = "FAM19LIN" value="#data.FAM19LIN#">
		</cfif>
		<tr>
		  <td width="25%" align="right"><strong>Rango Inferior</strong></td>
			<td width="23%" align="right"><input type="text" name="FAM19INF" size="15" maxlength="8" value="<cfif modoCB neq 'ALTA'>#data.FAM19INF#</cfif>"></td>
			<td width="28%" align="right"><strong>Rango Superior</strong></td>
			<td width="24%"><input type="text" name="FAM19SUP" size="15" maxlength="8" value="<cfif modoCB neq 'ALTA'>#data.FAM19SUP#</cfif>"></td>
		</tr>
		<tr>
		  <td align="right"><strong>Monto</strong></td>
			<td align="right"><input type="text" name="FAM19MON" size="15" maxlength="8" value="<cfif modoCB neq 'ALTA'>#data.FAM19MON#</cfif>"></td>
			<td align="right"><strong>% Rango Inferior</strong></td>
			<td><input type="text" name="FAM19PRI" size="15" maxlength="8" value="<cfif modoCB neq 'ALTA'>#data.FAM19PRI#</cfif>"></td>
		</tr>
		<tr>
			<td colspan="4" align="center">
				<cf_botones formName='formCB' modo='#modoCB#' sufijo='D'>
			</td>
		</tr>
	</table>
	<cfif modoCB neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>


<!-- MANEJA LOS ERRORES--->

<cf_qforms form="formCB" objForm="objFormCB">
<script language="javascript">
<!--//
	objFormCB.FAM19INF.description = "Rango Inferior";
	objFormCB.FAM19SUP.description = "Rango Superior";
	objFormCB.FAM19PRI.description = "% Rango Inferior";
	objFormCB.FAM19MON.description = "Monto";
	
	function habilitarValidacion(){
		objFormCB.FAM19INF.required = true;
		objFormCB.FAM19SUP.required = true;
		objFormCB.FAM19MON.required = true;
		objFormCB.FAM19PRI.required = true;
	}
	
	function deshabilitarValidacion(){
		objFormCB.FAM19INF.required = false;
		objFormCB.FAM19SUP.required = false;
		objFormCB.FAM19MON.required = false;
		objFormCB.FAM19PRI.required = false;
	}
//-->
</script>
</cfoutput>
