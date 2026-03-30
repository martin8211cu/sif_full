	<cfquery name="rsMoneda" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rsCausas" datasource="#session.dsn#">
		select c.QPCid, c.QPCcodigo, c.QPCdescripcion, m.Miso4217 as Moneda, c.QPCmonto as Monto
        from QPCausa c
        	inner join Monedas m
            on m.Mcodigo = c.Mcodigo
		where c.Ecodigo = #session.Ecodigo#
        order by c.QPCcodigo
	</cfquery>
	
<cfif isdefined("form.QPvtaConvid") and len(trim(form.QPvtaConvid))>
	<cfquery name="rsDato" datasource="#session.dsn#">
		select 
			a.QPvtaConvid, 
			a.QPvtaConvCod,           
			a.QPvtaConvDesc,         
			a.Ecodigo,                       
			a.QPvtaConvFecIni,       
			a.QPvtaConvFecFin,      
			a.QPvtaConvFrecuencia,       
			a.BMusucodigo,    
			a.BMFecha,           
			a.QPvtaConvFact,
			a.QPvtaConvCont,
            a.QPvtaConvTipo
		from QPventaConvenio a   
			where a.Ecodigo = #session.Ecodigo# 
			and  a.QPvtaConvid=#form.QPvtaConvid#
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<form action="QPassConvenio_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); " onSubmit="return validar(this);"> 
       <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
			<tr>
                 <td align="right"><strong>C&oacute;digo:</strong></td>
                 <td align="left">
					<input type="text" name="QPvtaConvCod" maxlength="20" size="20" id="QPvtaConvCod" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPvtaConvCod)#</cfif>"/>
				</td>
				<td align="right"><strong>Nombre:</strong></td>
				<td>
					<input type="text" name="QPvtaConvDesc" maxlength="101" size="30" id="QPvtaConvDesc" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPvtaConvDesc)#</cfif>"/>
				</td>
			</tr>
			<tr>
				<td align="right" nowrap="nowrap"><strong>Periodicidad: </strong></td>
				<td>
					<select name="QPvtaConvFrecuencia" tabindex="1">
						<option value="1" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvFrecuencia eq 1>selected="selected"</cfif>>1</option>
						<option value="2" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvFrecuencia eq 2>selected="selected"</cfif>>2</option>
						<option value="3" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvFrecuencia eq 3>selected="selected"</cfif>>3</option>
						<option value="4" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvFrecuencia eq 4>selected="selected"</cfif>>4</option>
						<option value="6" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvFrecuencia eq 6>selected="selected"</cfif>>6</option>
						<option value="12" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvFrecuencia eq 12>selected="selected"</cfif>>12</option>
					</select>
				</td>				
				<td align="right" nowrap="nowrap"><strong>Tipo: </strong></td>
				<td>
					<select name="QPvtaConvTipo" tabindex="1">
						<option value="1" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvTipo eq 1>selected="selected"</cfif>>PostPago</option>
						<option value="2" <cfif modo NEQ 'ALTA' and rsDato.QPvtaConvTipo eq 2>selected="selected"</cfif>>PrePago</option>
					</select>
				</td>				
			</tr>

			
           	<tr>
                <td align="right"><strong>Vigencia Desde:</strong></td>
                <td>
                   <cfset QPvtaConvFecIni = ''>
						<cfif modo NEQ 'ALTA'>
							<cfset QPvtaConvFecIni  = DateFormat(#rsDato.QPvtaConvFecIni#,'DD/MM/YYYY') >
						</cfif>
					<cf_sifcalendario form="form1" value="#QPvtaConvFecIni#" name="QPvtaConvFecIni" tabindex="1">
                </td>
                <td align="right"><strong>Hasta:</strong></td>
                <td>
                    <cfset QPvtaConvFecFin = ''>
						<cfif modo NEQ 'ALTA'>
							<cfset QPvtaConvFecFin  = DateFormat(#rsDato.QPvtaConvFecFin#,'DD/MM/YYYY') >
						</cfif>
					<cf_sifcalendario form="form1" value="#QPvtaConvFecFin#" name="QPvtaConvFecFin" tabindex="1">
                </td>
         	</tr>	

			<tr>
			<td colspan="4" align="center">
				<cfset control = 0>
				<fieldset style="width:85%">
				<legend>Causas Incluidas en el Convenio</legend>
	            <table cellspacing="2">
				<cfset LvarCausa = "">
                <cfloop query="rsCausas">
                    <cfif isdefined ('form.QPvtaConvid') and len(trim(form.QPvtaConvid))>
                        <cfquery name="rsDoc" datasource="#session.dsn#">
                            select count(1) as cantidad 
                            from QPCausaxConvenio a
                            where a.Ecodigo = #session.Ecodigo#
                            and a.QPCid= #rsCausas.QPCid#
                            and a.QPvtaConvid = #form.QPvtaConvid#
                        </cfquery>
                    </cfif>
                    <cfif control eq 0>
                    	<tr>
                    </cfif>
                        <td>
                            <input type="checkbox" name="QPCid" tabindex="1" value="#rsCausas.QPCid#" <cfif modo NEQ "ALTA" and #rsDoc.cantidad# gt 0>checked</cfif>>
                        </td>
                        <td>#rsCausas.QPCcodigo#&nbsp;&nbsp;&nbsp;</td>
                        <td>#rsCausas.QPCdescripcion#&nbsp;&nbsp;&nbsp;</td>
                        <td align="right">#numberformat(Monto, "999,999,999.00")#</td>
                        <td align="right">#Moneda#</td>
                    <cfif control eq 1>
                    	</tr>
                        <cfset control = 0>
					<cfelse>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <cfset control = 1>
                    </cfif>
                </cfloop>
				<cfif control eq 1>
                    </tr>
				</cfif>
				</table>
                </fieldset>
            </td>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr valign="baseline"> 
				<td colspan="4" align="center" nowrap>
					<cfif isdefined("form.QPvtaConvid")> 
						<cf_botones modo="#modo#" tabindex="1" include="Regresar">
					<cfelse>
						<cf_botones modo="#modo#" tabindex="1" include="Regresar">
					</cfif> 
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>
				<td align="center" colspan="4"><strong>Contrato</strong></td>
				<!---
				<td align="right">
					<div align="right">
						<img style="cursor:pointer;" src="/cfmx/sif/imagenes/Help02_T.gif" onclick="javascrip:popUpWindowimgAyuda();" />
					</div>
				</td>
				--->				
			</tr>
			<tr class="fileLabel">
				<td colspan="4" align="center">
					<cfif modo eq "ALTA">
						<strong>
						<cfset miHTML = "">
					<cfelse>
						<cfset miHTML = rsDato.QPvtaConvCont>
						</strong>
					</cfif>
					<strong>
						<cf_sifeditorhtml name="QPvtaConvCont" indice="1" value="#miHTML#" height="400" toolbarset="Default">
					</strong>
				</td>
			</tr>
			
			<tr>
				<td colspan="4">
					<cfset ts = "">
					<cfif modo NEQ "ALTA">
						<input type="hidden" name="QPvtaConvid" value="#rsDato.QPvtaConvid#">
					</cfif>
				</td>
			</tr>
		</table>
	</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.QPvtaConvCod.description = "Cdigo del Convenio";
		objForm.QPvtaConvDesc.description = "Descripcin";
		objForm.QPvtaConvFrecuencia.description = "Periodicidad";
		objForm.QPvtaConvFecIni.description = "Fecha de Vigencia Desde";
		objForm.QPvtaConvFecFin.description = "Fecha de Vigencia Hasta";
		
	function deshabilitarValidacion(){
		objForm.QPvtaConvCod.required = false;
		objForm.QPvtaConvDesc.required = false;
		objForm.QPvtaConvFrecuencia.required = false;
		objForm.QPvtaConvFecIni.required = false;
		objForm.QPvtaConvFecFin.required = false;
	}		
	
	function habilitarValidacion() 
	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Regresar',document.form1) ){
		objForm.QPvtaConvCod.required = true;
		objForm.QPvtaConvDesc.required = true;
		objForm.QPvtaConvFrecuencia.required = true;
		objForm.QPvtaConvFecIni.required = true;
		objForm.QPvtaConvFecFin.required = true;
		}
	}
	
	function funcRegresar()
	{
		deshabilitarValidacion();
		document.form1.action = 'QPassConvenio.cfm';
		return true;
	}
	
	function fnFechaYYYYMMDD (LvarFecha)
	{
		return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
	}
	
	function validar(form1){
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1)){
			var error_input;
			var error_msg = '';
	
		if (fnFechaYYYYMMDD(document.form1.QPvtaConvFecIni.value) > fnFechaYYYYMMDD(document.form1.QPvtaConvFecFin.value))
		{
			alert ("La Fecha de Vigencia Desde debe ser menor a la Fecha Hasta");
			return false;
		}

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}    

	var popUpWinimgAyuda=0;
	function popUpWindowimgAyuda(URLStr){
		URLStr += '/cfmx/sif/QPass/QPassConvenio.cfm';
		ww = 650;
		wh = 550;
		wl = 250;
		wt = 200;
	
		if(popUpWinimgAyuda){
			if(!popUpWinimgAyuda.closed) popUpWinimgAyuda.close();
		}
	
		popUpWinimgAyuda = open('/cfmx/sif/QPass/catalogos/Convenio_ayuda.cfm', 'popUpWinimgAyuda', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');			
	}

</script>
</cfoutput>
