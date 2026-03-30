<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>
<cfif isdefined('url.FATid') and not isdefined('form.FATid')>
	<cfparam name="form.FATid" default="#url.FATid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.FATid') and len(trim(form.FATid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		Select FATid, SNcodigo, FATcodigo, FATtipo, FATtipo as tc_tipo, FATtiptarjeta, FATdescripcion, FATporccom, CFcuentaComision,
		 CFcuentaCobro, ts_rversion,FATcomplemento
    	from FATarjetas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    	and FATid= <cfqueryparam cfsqltype="cf_sql_numeric " value="#form.FATid#">
		order by SNcodigo
	</cfquery>

<!--- QUERY PARA SOCIOS DE NEGOCIOS--->
	<cfif isdefined('data') and data.SNcodigo NEQ ''>
		<cfquery name="rsSocNeg" datasource="#Session.DSN#" >
			Select SNidentificacion, SNnumero, SNnombre, SNcodigo
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#data.SNcodigo#" >		  
			order by SNnombre
		</cfquery>
	</cfif>	




<!--- QUERY PARA el tag de CCuentas--->
	<cfif len(trim(data.CFcuentaComision))>
		<cfquery name="rsCuentasCom" datasource="#Session.DSN#" >
			Select Ccuenta, CFcuenta, CFformato, CFdescripcion, Cmayor		
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuentaComision#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>			


<!--- QUERY PARA el tag de CCuentas  Para la cuenta de Cobro--->
	<cfif len(trim(data.CFcuentaCobro))>
		<cfquery name="rsCuentasCob" datasource="#Session.DSN#" >
			Select Ccuenta, CFcuenta, CFformato, CFdescripcion, Cmayor		
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuentaCobro#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>		
</cfif> 
 
<cfoutput>
<form name="form1" method="post" action="tarjetas_cred-sql.cfm">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="FATid" value="#data.FATid#">
	</cfif>
	<table width="100%" cellpadding="3" cellspacing="0" align="center">
		
		<cfif isdefined('form.FATcodigo_F') and len(trim(form.FATcodigo_F))>
			<input type="hidden" name="FATcodigo_F" value="#form.FATcodigo_F#">	
		</cfif>
		
		<cfif isdefined('form.FATdescripcion_F') and len(trim(form.FATdescripcion_F))>
			<input type="hidden" name="FATdescripcion_F" value="#form.FATdescripcion_F#">	
		</cfif>			
		
	
		<tr>
			<td align="left" nowrap><strong>C&oacute;digo</strong></td>
			<td><input type="text" name="FATcodigo" size="30" maxlength="15" value="<cfif modo neq 'ALTA'>#data.FATcodigo#</cfif>"></td>
		</tr>
		<tr>
           <td align="left" nowrap><strong>Tipo</strong></td>
           <td colspan="1">
		   		<cfif modo NEQ "ALTA" and len(trim(data.FATtipo))>
					<cf_sifpv_tipostarjetas tc_tipo="tc_tipo" idquery="#data.tc_tipo#"> 
        		<cfelse>
        			<cf_sifpv_tipostarjetas>
      			</cfif>
			</td>
        </tr>
		<tr>
			<td align="left"><strong>Clasificaci&oacute;n</strong></td>
		    <td>
				<select name="FATtiptarjeta">
					<option value="">-Seleccionar-</option>
					<option value="C" <cfif modo neq 'ALTA' and data.FATtiptarjeta EQ "C"> selected</cfif>>Cr&eacute;dito</option>
					<option value="D" <cfif modo neq 'ALTA' and data.FATtiptarjeta EQ "D"> selected</cfif>>D&eacute;bito</option>
					<option value="O" <cfif modo neq 'ALTA' and data.FATtiptarjeta EQ "O"> selected</cfif>>Oferta</option>
				</select>
			 </td>
		</tr>		
		<tr><td align="left"><strong>Descripci&oacute;n</strong></td>
			<td><input type="text" name="FATdescripcion" size="50" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FATdescripcion#</cfif>"></td>
		</tr>
		<tr>
			<td width="50%" align="left" nowrap><strong>Socio de Negocio</strong></td>
			<td width="50%">
			    <cfif modo NEQ "ALTA" and isdefined('data') and data.SNcodigo NEQ '' and isdefined('rsSocNeg')>
			        <cf_sifsociosnegocios2 idquery="#rsSocNeg.SNcodigo#"> 
				<cfelse>
					 <cf_sifsociosnegocios2 form="form1" SNcodigo="SNcodigo" SNumero="SNumero" SNdescripcion="SNdescripcion">
				</cfif> 	
		    </td>
		</tr>
		<tr>
			<td align="left" nowrap><strong>Porcentaje de Comisi&oacute;n</strong></td>
			<td><input type="text" name="FATporccom" size="10" maxlength="6" value="<cfif modo neq 'ALTA'>#data.FATporccom#<cfelse>0.00</cfif>"
            	onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
                onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                alt="Porcentaje de Comision"></td>
            
            
           <!--- <input id="CPDCCFporc" name="CPDCCFporc" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'><cfoutput>#data.CPDCCFporc#</cfoutput></cfif>" 
                            onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
                            onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                            alt="Porcentaje">--->
		</tr>
		<tr>
           <td align="left" nowrap><strong>Cuenta de Comisi&oacute;n</strong></td>
           <td colspan="1">
				 <cfif modo NEQ "ALTA" and len(trim(data.CFcuentaComision))>
        			<cf_cuentas query="#rsCuentasCom#" Ccuenta="c1" CFcuenta="CFcuentaCom" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1">
        		<cfelse>
        			<cf_cuentas Ccuenta="c1" CFcuenta="CFcuentaCom" Cmayor="Cmayor1" Cformato="Cformato1" Cdescripcion="Cdescripcion1" frame="iframe1">
      			</cfif>				
		  </td>
			
        </tr>
       <tr>
			<td align="left" nowrap><strong>Complemento</strong></td>
			<td><input type="text" name="FATcomplemento" size="30" maxlength="9" value="<cfif modo neq 'ALTA'>#data.FATcomplemento#</cfif>"></td>
		</tr>
		<tr>
           <td align="left" nowrap><strong>Cuenta de Cobro</strong></td>
           <td colspan="1">
				 <cfif modo NEQ "ALTA" and len(trim(data.CFcuentaCobro))>
        			<cf_cuentas query="#rsCuentasCob#" Ccuenta="c2" CFcuenta="CFcuentaCobro" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe2">
        		<cfelse>
        			<cf_cuentas Ccuenta="c2" CFcuenta="CFcuentaCobro" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe2">
      			</cfif>
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
 	objForm.FATcodigo.description = "Código";
	objForm.FATtiptarjeta.description = "Tipo";
	objForm.FATdescripcion.description = "Descripción";
	
	function habilitarValidacion(){
		objForm.FATcodigo.required = true;
		objForm.FATtiptarjeta.required = true;
		objForm.FATdescripcion.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.FATcodigo.required = false;
		objForm.FATtiptarjeta.required = false;
		objForm.FATdescripcion.required = false;
	}
	
	habilitarValidacion();
		//-->
	</script>
</cfoutput>
