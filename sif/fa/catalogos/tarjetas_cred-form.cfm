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
		 CFcuentaCobro, ts_rversion,FATcomplemento,FATNOsumaComision,FATCFtarjeta,FATCtaCobrotarjeta,FATNOaplicaAnulacion,FATvisible,
         <!---Ajuste para importador ---->
         FATcxpsocio, FATaplicamontos, FATmontomin , FATmontomax, CFid, FATcompuesta ,
         BTid, CBid  
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
			<td width="19%" align="left" nowrap><strong>C&oacute;digo</strong></td>
			<td nowrap="nowrap" width="81%"><input type="text" name="FATcodigo" size="30" maxlength="15" value="<cfif modo neq 'ALTA'>#data.FATcodigo#</cfif>">
            <!--- &nbsp;     
            <input type="checkbox" name="FATcompuesta" onclick="javascript:setCompuesta(this.checked);"  <cfif modo neq 'ALTA' and #data.FATcompuesta# eq 1>checked="checked"</cfif>>
            &nbsp;<strong>Compuesta</strong>  &nbsp; --->  &nbsp;
             <input type="checkbox" name="FATvisible"  <cfif modo neq 'ALTA' and #data.FATvisible# eq 1>checked="checked"</cfif>>
            &nbsp;<strong>Visible</strong></td>
		</tr>
		<!--- <tr id="tr00">
           <td align="left" nowrap><strong>Tipo</strong></td>
           <td colspan="1">
		   		<cfif modo NEQ "ALTA" and len(trim(data.FATtipo))>
					<cf_sifpv_tipostarjetas tc_tipo="tc_tipo" idquery="#data.tc_tipo#"> 
        		<cfelse>
        			<cf_sifpv_tipostarjetas>
      			</cfif>
			</td>
        </tr> --->
		<tr id="tr0">
			<td align="left"><strong>Clasificaci&oacute;n</strong></td>
		    <td>
				<select name="FATtiptarjeta">
					<option value="">-Seleccionar-</option>
					<option value="C" <cfif modo neq 'ALTA' and data.FATtiptarjeta EQ "C"> selected</cfif>>Cr&eacute;dito</option>
					<option value="D" <cfif modo neq 'ALTA' and data.FATtiptarjeta EQ "D"> selected</cfif>>D&eacute;bito</option>
					<!--- <option value="O" <cfif modo neq 'ALTA' and data.FATtiptarjeta EQ "O"> selected</cfif>>Oferta</option> --->
				</select>
			 </td>
		</tr>		
		<tr><td align="left"><strong>Descripci&oacute;n</strong></td>
			<td><input type="text" name="FATdescripcion" size="50" maxlength="50" value="<cfif modo neq 'ALTA'>#data.FATdescripcion#</cfif>"></td>
		</tr> 
        <tr>
                <td align="left" ><strong>Porcentaje de Comisi&oacute;n</strong></td>
                <td><input type="text" name="FATporccom" id="FATporccom" size="10" maxlength="6" value="<cfif modo neq 'ALTA'>#data.FATporccom#<cfelse>0.00</cfif>"
                    onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
                    onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                    alt="Porcentaje de Comision" <cfif modo neq 'ALTA' and #data.FATcompuesta# eq 1> disabled </cfif> ></td>
        </tr>
        <!--- <tr id="tr1">
         <td colspan="5">
          <table width="100%" align="center" border="0"> 
            <tr>
            <td><strong>No suma comisi&oacute;n a CxC:</strong></td>
            <td><input type="checkbox" name="NosumaComision" <cfif modo NEQ "ALTA" and  data.FATNOsumaComision eq 1> checked </cfif>> </input></td>
             </tr>
            <tr>            
            <td><strong>Usa Centro Funcional de la tarjeta:</strong></td>
            <td><input type="checkbox" name="CFtarjeta" <cfif modo NEQ "ALTA" and  data.FATCFtarjeta eq 1> checked </cfif>> </input></td>
             </tr>
            <tr>
            <td><strong>Usa Cuenta de cobro de la tarjeta:</strong></td>
            <td><input type="checkbox" name="CtaCobrotarjeta" <cfif modo NEQ "ALTA" and  data.FATCtaCobrotarjeta eq 1> checked </cfif>> </input></td>
            </tr>
            <tr>
            <td><strong>Genera CxP a favor del socio:</strong></td>
            <td><input type="checkbox" name="GeneraCxP" <cfif modo NEQ "ALTA" and  data.FATcxpsocio eq 1> checked </cfif>> </input></td>
            </tr>
            <tr>
            <tr>
            <td><strong>No aplica en anulaci&oacute;n:</strong></td>
            <td><input type="checkbox" name="NoaplicaAnulacion" <cfif modo NEQ "ALTA" and  data.FATNOaplicaAnulacion eq 1> checked </cfif>> </input></td>
             </tr>
            <tr>
            <td><strong>Aplica montos máximos y mínimos</strong></td>
            <td><input type="checkbox" name="AplicaMontos" <cfif modo NEQ "ALTA" and  data.FATaplicamontos eq 1> checked </cfif>> </input></td>
            </tr>
            <tr>
            <td><strong>Monto máximo</strong></td>
            <td><input type="text"  name="MontoMax" value= "<cfif modo NEQ "ALTA">#LSCurrencyFormat(data.FATmontomax,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18" style="text-align:right" onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this.value); this.select();"></input></td>
            </tr>
            <tr>
            <td><strong>Monto mínimo</strong></td>
            <td><input type="text"  name="MontoMin" value= "<cfif modo NEQ "ALTA">#LSCurrencyFormat(data.FATmontomin,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18" style="text-align:right" onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this.value); this.select();"></input></td>
            </tr>
            <tr>
                <td width="21%" align="left" nowrap><strong>Socio de Negocio</strong></td>
                <td width="79%">
                    <cfif modo NEQ "ALTA" and isdefined('data') and data.SNcodigo NEQ '' and isdefined('rsSocNeg')>
                        <cf_sifsociosnegocios2 idquery="#rsSocNeg.SNcodigo#"> 
                    <cfelse>
                         <cf_sifsociosnegocios2 form="form1" SNcodigo="SNcodigo" SNumero="SNumero" SNdescripcion="SNdescripcion">
                    </cfif> 	
                </td>
            </tr> --->        
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
                <td width="21%" nowrap><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
                <td>
                    <cfif modo eq 'CAMBIO' and len(trim(#data.CFid#)) gt 0>
                        <cfquery name="rsCFuncional" datasource="#session.DSN#">
                            select CFid, CFcodigo, CFdescripcion
                            from CFuncional
                            where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                              and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">
                        </cfquery>
                        <cf_rhcfuncional query="#rsCFuncional#">
                    <cfelse>
                        <cf_rhcfuncional>
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
                        <cf_cuentas query="#rsCuentasCob#" Ccuenta="c2" CFcuenta="CFcuentaCobro" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe2" auxiliares="N">
                    <cfelse>
                        <cf_cuentas Ccuenta="c2" CFcuenta="CFcuentaCobro" Cmayor="Cmayor2" Cformato="Cformato2" Cdescripcion="Cdescripcion2" frame="iframe2" auxiliares="N">
                    </cfif>

                </td>
            </tr>
            <tr>
               <td align="left" nowrap><strong>Tipo de Transacci&oacute;n</strong></td>
               <td colspan="1">
                    <cfquery name="rsBTid" datasource="#Session.DSN#">
                        select BTdescripcion , BTid
                        from BTransacciones
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    </cfquery>
                     <select name="BTid" tabindex="5">
                        <option value="">-- Tipo transacciones --</option>
                        <cfloop query="rsBTid">
                        <cfoutput>
                            <option value="#rsBTid.BTid#" <cfif modo neq "ALTA" and data.BTid eq rsBTid.BTid>selected</cfif>>#rsBTid.BTdescripcion#</option>
                        </cfoutput>
                        </cfloop>
                    </select>

                </td>
            </tr>
            <tr>
               <td align="left" nowrap><strong>Cuenta Bancaria</strong></td>
               <td colspan="1">
                    
                    <cfif modo eq 'ALTA'>
                        <cf_conlis title="Lista de Cuentas Bancarias"
                            campos = "CBid, CBcodigo, CBdescripcion, Mcodigo"
                            desplegables = "N,S,S,N"
                            modificables = "N,S,N,N"
                            size = "0,0,40,0"
                            tabla="CuentasBancos cb
                                    inner join Monedas m
                                    on cb.Mcodigo = m.Mcodigo
                                    inner join Empresas e
                                    on e.Ecodigo = cb.Ecodigo"
                            columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo,
                                        m.Mnombre"
                            filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.CBestado = 1"
                            desplegar="CBcodigo, CBdescripcion"
                            etiquetas="Código, Descripción"
                            formatos="S,S"
                            align="left,left"
                            asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre"
                            asignarformatos="S,S,S,S,S,F"
                            showEmptyListMsg="true"
                            debug="false"
                            tabindex="6">
                    <cfelse>
                        <cfset valuesArray = ArrayNew(1)>

                        <cfquery name = "rsCuentas" datasource="#session.DSN#">
                            select a.CBid, b.CBcodigo, b.CBdescripcion, b.Mcodigo 
                            from FATarjetas a
                            inner join CuentasBancos b
                                on a.CBid = b.CBid
                                and a.Ecodigo = b.Ecodigo
                            where a.Ecodigo = #Session.Ecodigo# and a.CBid = #iif(data.CBid neq '',data.CBid,-1)#
                        </cfquery>

                        <cfset ArrayAppend(valuesArray, rsCuentas.CBid)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.CBcodigo)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.CBdescripcion)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.Mcodigo)>

                        <cf_conlis title="Lista de Cuentas Bancarias"
                            campos = "CBid, CBcodigo, CBdescripcion, Mcodigo"
                            desplegables = "N,S,S,N"
                            modificables = "N,S,N,N"
                            size = "0,0,40,0"
                            valuesArray="#valuesArray#"
                            tabla="CuentasBancos cb
                                    inner join Monedas m
                                    on cb.Mcodigo = m.Mcodigo
                                    inner join Empresas e
                                    on e.Ecodigo = cb.Ecodigo"
                            columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo,
                                        m.Mnombre"
                            filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.CBestado = 1"
                            desplegar="CBcodigo, CBdescripcion"
                            etiquetas="Código, Descripción"
                            formatos="S,S"
                            align="left,left"
                            asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre"
                            asignarformatos="S,S,S,S,S,F"
                            showEmptyListMsg="true"
                            debug="false"
                            tabindex="6">

                    </cfif>

                </td>
            </tr>
         </table>
        </td>
       </tr>     
        <!--- <tr id="tr2" align="center">
            <td colspan="5" align="center"><input type="submit" name="btnCompuesta" value="Tarjeta Compuesta"/></td>
            </tr> --->
             <tr id="tr3">
            <td>&nbsp;</td>
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
<!--- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript">
<!---//
 	objForm.FATcodigo.description = "Código";
	objForm.FATtiptarjeta.description = "Tipo";
	objForm.FATdescripcion.description = "Descripción";
	
	<cfif modo NEQ 'ALTA' and data.FATcompuesta eq 1>
      document.getElementById("tr00").style.display = 'none';
      document.getElementById("tr0").style.display = 'none';
	  document.getElementById("tr1").style.display = 'none';    	
   	  document.getElementById("tr2").style.display = '';
      document.getElementById("tr3").style.display = 'none';
	<cfelse>
	     document.getElementById("tr00").style.display = '';
      document.getElementById("tr0").style.display = '';
	  document.getElementById("tr1").style.display = '';	 
   	  document.getElementById("tr2").style.display = 'none';
      document.getElementById("tr3").style.display = ''; 
	</cfif>  
	function setCompuesta(value){		
	document.getElementById("tr1").style.display = ( value ? 'none' : '' );		
    document.getElementById("FATporccom").disabled = ( value ? 'true' : '' );			  	
	}	
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
		// --->
		
	
	</script>
</cfoutput>
