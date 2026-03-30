<cfif isdefined('url.FAM24TIP') and not isdefined('form.FAM24TIP')>
	<cfparam name="form.FAM24TIP" default="#url.FAM24TIP#">
</cfif>

<cfif isdefined('url.FAM24VAL') and not isdefined('form.FAM24VAL')>
	<cfparam name="form.FAM24VAL" default="#url.FAM24VAL#">
</cfif>

<cfif isdefined('url.Mcodigo') and not isdefined('form.Mcodigo')>
	<cfparam name="form.Mcodigo" default="#url.Mcodigo#">
</cfif>


<cfset modo = 'ALTA'>
<cfif isdefined('form.FAM24TIP') and len(trim(form.FAM24TIP))
 	and isdefined('form.FAM24VAL') and len(trim(form.FAM24VAL))
	and isdefined ('form.Mcodigo') and len (trim(form.Mcodigo))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAM24TIP, FAM24VAL, Mcodigo, FAM24DES, ts_rversion
		from FAM024
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  FAM24TIP = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM24TIP#">
		and  FAM24VAL = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM24VAL#">
		and  Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>

<!--- query de lista  monedas --->
	<cfquery name="rsMonedas" datasource="#Session.DSN#" >
		Select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mcodigo#" >		  
			order by Mnombre
	</cfquery>
</cfif> 

<cfoutput>
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<form name="form1" method="post" action="den_monedas-sql.cfm" onSubmit="javascript: return validaMon();">
	<table width="100%" cellpadding="3" cellspacing="0">
		<cfif isdefined('form.Mcodigo_F') and len(trim(form.Mcodigo_F))>
        	<input type="hidden" name="Mcodigo_F" value="#form.Mcodigo_F#">
      	</cfif>
		<cfif isdefined('form.FAM24DES_F') and len(trim(form.FAM24DES_F))>
        	<input type="hidden" name="FAM24DES_F" value="#form.FAM24DES_F#">
      	</cfif>
				
		<tr>
			<td width="50%" align="right">
				<strong>Moneda</strong>
			</td>
			<td width="50%">
			    <cfif modo NEQ "ALTA">
			        <cf_sifmonedas query="#rsMonedas#" habilita="N"> 
				<cfelse>
					 <cf_sifmonedas>
				</cfif> 		
		    </td>
		</tr>
		<tr>
			<td align="right"><strong>Tipo</strong></td>
			<td>
				<select name="FAM24TIP"  <cfif modo NEQ "ALTA">disabled</cfif>>
					<option value="">Seleccionar</option>
              		<option value="B" <cfif modo NEQ 'ALTA' and data.FAM24TIP EQ 'B'> selected</cfif>>Billetes</option>
					<option value="M" <cfif modo NEQ 'ALTA' and data.FAM24TIP EQ 'M'> selected</cfif>>Monedas</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Valor</strong></td>
        	<td>
				<input tabindex="1" type="text" name="FAM24VAL" style="text-align:right"size="18" maxlength="10" 
				onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
				onFocus="javascript:this.select();" 
				<cfif modo NEQ 'ALTA'> 
					readonly="true"
				</cfif>
				onChange="javascript: fm(this,2);"
				value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#data.FAM24VAL#</cfoutput></cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n</strong></td>
        	<td>
				<input type="text" name="FAM24DES" size="30" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FAM24DES#</cfif>">
			</td>
		</tr>
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
<script language="javascript" type="text/javascript">
	<!--//
	objForm.FAM24TIP.description = "Tipo";
	objForm.FAM24VAL.description = "Valor";
	objForm.Mcodigo.description = "Código de Moneda";
	objForm.FAM24DES.description = "Descripción";

	function validaMon(){
		document.form1.Mcodigo.disabled = false;
		document.form1.FAM24TIP.disabled = false;
		<cfif modo EQ "ALTA">
		document.form1.FAM24VAL.value = qf(document.form1.FAM24VAL.value);
		</cfif>
		return true;
	}	
	
	function habilitarValidacion(){
		objForm.FAM24TIP.required = true;
		objForm.FAM24VAL.required = true;
		objForm.Mcodigo.required = true;
		objForm.FAM24DES.requires = true;
	}
	function deshabilitarValidacion(){
		objForm.FAM24TIP.required = false;
		objForm.FAM24VAL.required = false;
		objForm.Mcodigo.required = false;
		objForm.FAM24DES.requires = false;
		
	}
	habilitarValidacion();
	//-->
</script>
</cfoutput>
