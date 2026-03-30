<cfif isdefined('url.FAM12COD') and not isdefined('form.FAM12COD') and isdefined('url.FAX01ORIGEN') and not isdefined('form.FAX01ORIGEN')>
	<cfparam name="form.FAM12COD" default="#url.FAM12COD#">
	<cfparam name="form.FAX01ORIGEN" default="#url.FAX01ORIGEN#">
</cfif>

<cfset modo = 'ALTA'>
<cfif  isdefined('url.FAM12COD') and len(trim(url.FAM12COD)) and not isdefined('form.FAM12COD') and isdefined('url.FAX01ORIGEN') and len(trim(url.FAX01ORIGEN)) and not isdefined('form.FAX01ORIGEN')>
	<cfset form.FAM12COD = url.FAM12COD>
	<cfset form.FAX01ORIGEN = url.FAX01ORIGEN>
</cfif>
<cfif  isdefined('form.FAM12COD') and len(trim(form.FAM12COD)) and isdefined('form.FAX01ORIGEN') and len(trim(form.FAX01ORIGEN))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select a.FAM12COD, a.FAX01ORIGEN, c.OIDescripcion, b.FAM12CODD, b.FAM12DES, a.FAX09DIN, a.FAX09DFI, a.FAX09NXT, a.FAX09SER, b.FAM12DES, a.ts_rversion
		  from FAX009 as a
			inner join FAM012 as b
				on a.FAM12COD = b.FAM12COD
			inner join OrigenesInterfazPV c
				on a.FAX01ORIGEN = c.FAX01ORIGEN
                and a.Ecodigo = c.Ecodigo
		where a.Ecodigo   = #session.Ecodigo#
		and a.FAM12COD    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">
		and a.FAX01ORIGEN = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">
	</cfquery>
</cfif>	
	<cfquery name="rsOrigenes" datasource="#session.DSN#">
		select FAX01ORIGEN, OIDescripcion from OrigenesInterfazPV where Ecodigo = #session.Ecodigo#
	</cfquery>	    
	
<cfoutput>
<form name="form1" method="post" action="sec_doc_imp-sql.cfm">
	<table width="100%" cellpadding="3" cellspacing="0">
      <cfif isdefined('form.FAM12COD_F') and len(trim(form.FAM12COD_F))>
        <input type="hidden" name="FAM12COD_F" value="#form.FAM12COD_F#">
      </cfif>
      
	  <tr>
		<!--- cf_sifimpresoras lista de Impresoras--->
		<td width="50%" align="right"><strong>Impresora&nbsp;</strong></td>
		<td width="50%">
			<cfif modo NEQ "ALTA">
				<cf_sifimpresoras idquery="#data.FAM12COD#" modificable='false'> 
			<cfelse>
				<cf_sifimpresoras>
			</cfif> </td>
		</tr>
	   
	  <tr>
        <td align="right" ><strong>Documento Inicial</strong></td>
        <td width="29%" align="left">
			<input tabindex="1" type="text" name="FAX09DIN" style="text-align:right"size="25" maxlength="40" 
			onKeyUp="if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}; sugiere(this.value);"
			onFocus="javascript:this.select();" 
			value="<cfif modo neq 'ALTA'>#trim(data.FAX09DIN)#</cfif>">
		</td>
	
      </tr>
	  
	  <tr>
	    <td align="right" ><strong>Documento Final</strong></td>
	  	<td width="29%" align="left">
			<input tabindex="1" type="text" name="FAX09DFI" style="text-align:right"size="25" maxlength="40" 
			onKeyUp="if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}"
			onFocus="javascript:this.select();" 
			value="<cfif modo neq 'ALTA'>#trim(data.FAX09DFI)#</cfif>">
	   </td>
	  </tr>
	   
	 <tr>
        <td align="right" ><strong>Documento Siguiente</strong></td>
        <td width="29%" align="left">
			<input tabindex="1" type="text" name="FAX09NXT" style="text-align:right"size="25" maxlength="40" 
			onKeyUp="if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}"
			onFocus="javascript:this.select();" 
			value="<cfif modo neq 'ALTA'>#trim(data.FAX09NXT)#</cfif>">
		</td>
	 </tr>
	 
	  <tr>
        <td align="right" ><strong>Serie</strong></td>
        <td width="29%" align="left"><input type="text" name="FAX09SER" size="25" maxlength="40" value="<cfif modo neq 'ALTA'>#trim(data.FAX09SER)#</cfif>"></td>
      </tr>
	   <tr>
        <td align="right" ><strong>Origen</strong></td>
        <td width="29%" align="left">
		<cfif modo neq 'ALTA'>
			<input name="FAX01ORIGEN" type="hidden" value="#data.FAX01ORIGEN#" />
			#data.FAX01ORIGEN# - #data.OIDescripcion#
		<cfelse>
				<select name="FAX01ORIGEN" id="FAX01ORIGEN">
					<option value="">-seleccionar-</option>
					    <cfif isdefined('rsOrigenes') and rsOrigenes.recordCount GT 0>
						     <cfloop query="rsOrigenes">
							<option value="#rsOrigenes.FAX01ORIGEN#" <cfif modo neq 'ALTA' and trim(rsOrigenes.FAX01ORIGEN) eq trim(data.FAX01ORIGEN)>selected</cfif> >#rsOrigenes.FAX01ORIGEN#--#rsOrigenes.OIDescripcion#</option>
						</cfloop>
					</cfif>
	            </select>
		</cfif>
		</td>
      </tr>
	  	  	  	  
      <tr>
        <td colspan="4" align="right">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4" align="center">
			<cf_botones modo='#modo#'>
        </td>
      </tr>
    </table>
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	
</form>
<cf_qforms>
	<script language="javascript">
		function sugiere(caract){
			if(caract != ''){
				document.form1.FAX09NXT.value = caract;
			}
		}
			
		objForm.FAM12COD.required = true;
		objForm.FAM12COD.description = "Impresora";
		
		objForm.FAX09DIN.required = true;
		objForm.FAX09DIN.description = "Inicial";
		
		objForm.FAX09DFI.required = true;
		objForm.FAX09DFI.description = "Final";
		
		objForm.FAX09NXT.required = true;
		objForm.FAX09NXT.description = "Siguiente";
		
		objForm.FAX01ORIGEN.required = true;
		objForm.FAX01ORIGEN.description = "Origen";
function funcAlta()
{
	return validaDocumento();
}
function validaDocumento()
{	
	if (parseInt(document.form1.FAX09DIN.value) > parseInt(document.form1.FAX09DFI.value))
	{
		alert('El documento Inicial no puede ser mayor al documento Final');
		return false;
	}
	else if (parseInt(document.form1.FAX09NXT.value) < parseInt(document.form1.FAX09DIN.value) ||  parseInt(document.form1.FAX09NXT.value) > parseInt(document.form1.FAX09DFI.value)) 
	{
		alert('El documento Siguiente no puede ser menor que el documento Inicial ni mayor que el documento Final');
		return false;
	}
	else
	{
		return true;
	}
}
		function funcCambio(){
			if (validaDocumento())
			{
			var mensaje = "";
				<cfif modo neq 'ALTA'>
					mensaje = "<cfoutput>VALORES ACTUALES \n\n Impresora: (#data.FAM12CODD#) #data.FAM12DES#\nDocumento Inicial: #data.FAX09DIN#\nDocumento Final: #data.FAX09DFI#\nDocumento Siguente: #data.FAX09NXT#\nSerie: #data.FAX09SER#\n\nVALORES MODIFICADOS\n\nImpresora: (" + document.form1.FAM12CODD.value + ") " + document.form1.FAM12DES.value + "\nDocumento Inicial: " + document.form1.FAX09DIN.value + "\nDocumento Final: " + document.form1.FAX09DFI.value + "\nDocumento Siguente:  " + document.form1.FAX09NXT.value + "\nSerie: " + document.form1.FAX09SER.value +"\nOrigen: " + document.form1.FAX01ORIGEN.value + "\n\n</cfoutput>";
				</cfif>
			if(confirm(mensaje + 'Desea realmente actualizar esta secuencia ?'))
				return true;
			else
				return false;
			}else return false;
		}		
		
		function deshabilitarValidacion(){
			objForm.FAM12COD.required = false;
			objForm.FAX09DIN.required = false;
			objForm.FAX09DFI.required = false;
			objForm.FAX09NXT.required = false;
			objForm.FAX01ORIGEN.required = false;
		}
			
		function habilitarValidacion(){
			objForm.FAM12COD.required = true;
			objForm.FAX09DIN.required = true;
			objForm.FAX09DFI.required = true;
			objForm.FAX09NXT.required = true;
			objForm.FAX01ORIGEN.required = true;
		}
	</script>
</cfoutput>