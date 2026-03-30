<cfoutput>
<cfif isdefined("form.CVlinea") and len(form.CVlinea) gt 0>
	<cfset modo="CAMBIO_P">
<cfelse>
	<cfif not isdefined("Form.modo")>
        <cfset modo="ALTA_P">
    <cfelseif form.modo EQ "CAMBIO_P">
        <cfset modo="CAMBIO_P">
    <cfelse>
        <cfset modo="ALTA_P">
    </cfif>
</cfif>

<cfif (MODO neq "ALTA_P")>
    <cfquery name="rsDetalle" datasource="#session.DSN#">
        select  d.CVlinea, d.CVid, d.CVfechaini, d.CVfechafin, ts_rversion
        from DCalendarioVentas d
        where d.Ecodigo= #session.Ecodigo#
        and d.CVid = #form.CVid#
        and d.CVlinea = #form.CVlinea#
    </cfquery>
</cfif>
<form  name="form2" action="CalendariosVenta-sql.cfm" method="post" onsubmit="javascript: Rangos();">
    <table width="90%" border="0" cellpadding="1" cellspacing="2%"> 
        <tr>
        	<td align="center" colspan="4"><strong>Periodos del Calendario:</strong></td>
        </tr>
        	<input type="hidden" name="CVlinea" value="<cfif MODO neq "ALTA_P"><cfoutput>#rsDetalle.CVlinea#</cfoutput></cfif>">
            <input type="hidden" name="CVid" value="#form.CVid#">
        <tr><td colspan="4">&nbsp;</td></tr>
        
        <tr>
            <td>&nbsp;</td>
            <td nowrap align="center" width="28%"><strong style="position: relative; left: -4px;">Fecha Inicial:</strong></td>
            <td nowrap align="center" width="28%"><strong style="position: relative; left: -9px;">Fecha Final:</strong></td>	
            <td>&nbsp;</td>
        </tr>
        
        <tr>
            <td>&nbsp;</td>
            <td nowrap align="center" width="28%"><cfset LvarCVfechaini = "">
				<cfif (MODO neq "ALTA_P")>
 	               <cfset LvarCVfechaini = rsDetalle.CVfechaini>
                </cfif>
                <cf_sifcalendario name="fechaini" value="#DateFormat(LvarCVfechaini,'DD/MM/YYYY')#" tabindex="1" form="form2">
            </td>
            <td nowrap align="center" width="28%">
				<cfset LvarCVfechafin = "">
                <cfif (MODO neq "ALTA_P")>
                	<cfset LvarCVfechafin = rsDetalle.CVfechafin>
                </cfif>
                <cf_sifcalendario name="fechafin" value="#DateFormat(LvarCVfechafin,'DD/MM/YYYY')#" tabindex="1" form="form2">
            </td>
            <td>&nbsp;</td>	
        </tr>
   		
        <tr>
            <td nowrap align="center" colspan="4">
			
                <div id="Cambio" style="visibility:hidden">
              		<cf_botones modo="CAMBIO" sufijo="Per">    
                </div> 
            
                <div id="Alta" style="position: relative; top: -24px;">
                    <cf_botones modo="ALTA" sufijo="Per" functions="return Rangos();">
                </div>
            
            </td>
        </tr>
       
        <tr>
            <td valign="top" colspan="4"> 
                <table  width="90%" cellspacing="0" align="center" border="0">
                    <tr>
                    	<td align="center" class="tituloListas" colspan="5">Lista de Periodos</td>
                    </tr>
                    	<cfquery name="rsLista2" datasource="#session.DSN#">
                            select  d.CVlinea, d.CVid, d.CVfechaini, d.CVfechafin, e.CVCodigo, d.ts_rversion
                            from DCalendarioVentas d
                            inner join ECalendarioVentas e
                                on e.CVid = d.CVid 
                                and e.Ecodigo= d.Ecodigo
                            where d.Ecodigo= #session.Ecodigo#
                            and d.CVid = #form.CVid#
                        </cfquery>
                    <tr>
                        <td colspan="5">
                            <hr style="margin-top: 1px; margin-bottom: 1px;"/>
                        </td>
                    </tr>
                    <tr class="tituloListas"><td>&nbsp;</td><td><strong>Calendario</strong></td><td align="right"><strong>Fecha Inicial</strong></td><td align="right"><strong>Fecha Final</strong></td><td>&nbsp;</td></tr>	
                    <cfif rsLista2.recordcount gt 0>
                        <cfloop query="rsLista2">
                        	<cfset fechaini = DateFormat(rsLista2.CVfechaini,'DD/MM/YYYY')>
                            <cfset fechafin = DateFormat(rsLista2.CVfechafin,'DD/MM/YYYY')>
                            <tr style="cursor:pointer"  class="<cfif rsLista2.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" >
                                <td>&nbsp;</td>
                                <td onClick="javascript:asignar('#rsLista2.CVlinea#','#rsLista2.CVid#','#fechaini#','#fechafin#');" >#rsLista2.CVCodigo#</td>
                                <td align="right" onClick="javascript:asignar('#rsLista2.CVlinea#','#rsLista2.CVid#','#fechaini#','#fechafin#');">#DateFormat(rsLista2.CVfechaini,'DD/MM/YYYY')#</td>
                                <td align="right" onClick="javascript:asignar('#rsLista2.CVlinea#','#rsLista2.CVid#','#fechaini#','#fechafin#');">#DateFormat(rsLista2.CVfechafin,'DD/MM/YYYY')#</td>
                                <td>&nbsp;</td>
                            </tr>
                        </cfloop>
                    <cfelse>
                        <tr>
                            <td class="listaCorte" align="center" colspan="5">--- No se encontraron Registros ---</td>
                        </tr>
                    </cfif>
                </table>
            </td>
        </tr>
    </table> 	
</form>
			
<cf_qforms form="form2">
	<cf_qformsRequiredField name="fechaini" description="Fecha Inicial">
	<cf_qformsRequiredField name="fechafin" description="Fecha Final">
</cf_qforms>
<script language="javascript1.2" type="text/javascript">
	function asignar(CVlinea, CVid, CVfechaini, CVfechafin){
		document.getElementById("Cambio").style.visibility = 'visible';	
		document.getElementById("Alta").style.visibility = 'hidden';	
		document.form2.CVlinea.value = CVlinea;
		document.form2.CVid.value = CVid;
		document.form2.fechaini.value = CVfechaini;
		document.form2.fechafin.value = CVfechafin;
	}
</script>
</cfoutput>