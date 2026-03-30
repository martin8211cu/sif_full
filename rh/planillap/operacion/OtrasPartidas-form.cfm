<cfif isdefined("Form.RHEid") and Len(Trim(Form.RHEid)) and isdefined("Form.RHPOPid") and Len(Trim(Form.RHPOPid)) 
	and isdefined("Form.Mes") and Len(Trim(Form.Mes)) and isdefined("Form.Periodo") and Len(Trim(Form.Periodo))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfset va_valoresCambio = ArrayNew(1)>

<cfif modo EQ "CAMBIO">
	<!----Datos de Otras Partidas--->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 	otp.RHEid,
				otp.RHOPid,
				otp.RHPOPid,
				otp.ts_rversion,
				opp.CPformato,
				opp.CPdescripcion	
		from RHOtrasPartidas otp
		 	inner join RHPOtrasPartidas opp
				on otp.RHPOPid = opp.RHPOPid
				and otp.Ecodigo = opp.Ecodigo
		
		where otp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and otp.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and otp.RHOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOPid#">
	</cfquery>
	<cfset ArrayAppend(va_valoresCambio, rsDatos.RHPOPid)>						
	<cfset ArrayAppend(va_valoresCambio, rsDatos.CPformato)>
	<cfset ArrayAppend(va_valoresCambio, rsDatos.CPdescripcion)>
	
</cfif>

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	//Funcion para limpiar campo de porcentaje o monto y mostrar el correpondiente segun el option button seleccionado
	function funcCambiaText(){
		var tdIncMonto  = document.getElementById("tdIncMonto");
		var tdIncPorc   = document.getElementById("tdIncPorc");
		if (document.formOtrasPartidas.opt_incremento[0].checked){			
			document.formOtrasPartidas.MontoIncremento.value = 0;
			tdIncPorc.style.display = '';
			tdIncMonto.style.display = 'none';			
		}
		else{
			document.formOtrasPartidas.PorcIncremento.value = 0;
			tdIncPorc.style.display = 'none';
			tdIncMonto.style.display = '';
		}
	}
	//Funcion para validar que el periodo hasta sea mayor que el periodo desde
	function funcValidaPeriodos(){
		if(document.formOtrasPartidas.PeriodoHasta.value != '' && document.formOtrasPartidas.Periodo.value != '')
		var vn_periododesde = new Date(document.formOtrasPartidas.Periodo.value,document.formOtrasPartidas.Mes.value-1,1)
		var vn_periodohasta = new Date(document.formOtrasPartidas.PeriodoHasta.value,document.formOtrasPartidas.MesHasta.value-1,1)
		if (vn_periododesde > vn_periodohasta){
			alert("El período desde debe ser menor al período hasta");
			return false;
		}
		return true;
	}
</script>

<cfoutput>
<form action="OtrasPartidas-sql.cfm" method="post" name="formOtrasPartidas">
	<input name="RHPOPdistribucionCFA" id="RHPOPdistribucionCFA" type="hidden" value="0" />
    <input name="RHPOPdistribucionCFB" id="RHPOPdistribucionCFB" type="hidden" value="1" />
	<table width="100%" border="0" cellspacing="2" cellpadding="2">
		<tr>
		  <td width="29%" align="right" nowrap><strong>Cuenta:</strong>&nbsp;</td>
		  <td nowrap width="10%">
          
			<cf_conlis 
				campos="RHPOPid,CPformato,CPdescripcion,RHPOPdistribucionCF"
				asignar="RHPOPid,CPformato,CPdescripcion,RHPOPdistribucionCF"
				valuesArray="#va_valoresCambio#"
				size="0,20,30"
				desplegables="N,S,S,N"
				modificables="N,S,N,N"						
				title="Lista de Cuentas de Otras Partidas"
				tabla="RHPOtrasPartidas"
				columnas="RHPOPid,CPformato,CPdescripcion,RHPOPdistribucionCF"
				filtro="Ecodigo = #Session.Ecodigo#	and (RHPOPdistribucionCF = $RHPOPdistribucionCFA,bit$ or RHPOPdistribucionCF = 	$RHPOPdistribucionCFB,bit$)								
						Order by CPformato"
				filtrar_por="CPformato,CPdescripcion"
				desplegar="CPformato,CPdescripcion"
				etiquetas="Formato,Descripci&oacute;n"
				formatos="S,S"
				align="left,left"								
				asignarFormatos="S,S,S,S"
				form="formOtrasPartidas"
				width = "700"
				height="500"
				top="100"
				left="200"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No se encontraron registros --- "				
			/>
            </div>
		  </td>
          <td><input name="Importar" id="Importar" type="checkbox" onclick="fnOcultar(this.checked)" />Importar</td>
	    </tr>
		<tr id="SinImportar">
        	<td colspan="3">
            	<table border="0" width="100%"><tr>
                  <td align="right" nowrap><strong>Per&iacute;odo desde:</strong>&nbsp;</td>
                  <td width="26%" nowrap>
                    <cfif modo neq 'ALTA'>#rsDatos.Periodo#
                        <input type="hidden" name="Periodo" id="Periodo" value="#rsDatos.Periodo#">
                    <cfelse>
                        <input type="text" name="Periodo" id="Periodo" value="<cfif modo neq "ALTA">#rsDatos.Periodo#</cfif>" size="7" maxlength="5"  
                        onBlur="javascript:fm(this,0); funcValidaPeriodos();"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
                    </cfif>				
                  </td>
                  <td width="9%" align="right" nowrap><strong>Mes desde:</strong>&nbsp;</td>
                  <td width="36%" nowrap>
                    <cfif modo neq 'ALTA'>
                        <cfset meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
                        #listgetat(meses, rsDatos.Mes)#
                        <input type="hidden" name="Mes" id="Mes" value="#rsDatos.Mes#" >
                    <cfelse>
                        <select id="Mes" name="Mes" onchange="javascript: funcValidaPeriodos();">
                            <option value="1" <cfif modo neq "ALTA" and rsDatos.Mes EQ 1>selected="selected"</cfif>>Enero</option>
                            <option value="2" <cfif modo neq "ALTA" and rsDatos.Mes EQ 2>selected="selected"</cfif>>Febrero</option>
                            <option value="3" <cfif modo neq "ALTA" and rsDatos.Mes EQ 3>selected="selected"</cfif>>Marzo</option>
                            <option value="4" <cfif modo neq "ALTA" and rsDatos.Mes EQ 4>selected="selected"</cfif>>Abril</option>
                            <option value="5" <cfif modo neq "ALTA" and rsDatos.Mes EQ 5>selected="selected"</cfif>>Mayo</option>
                            <option value="6" <cfif modo neq "ALTA" and rsDatos.Mes EQ 6>selected="selected"</cfif>>Junio</option>
                            <option value="7" <cfif modo neq "ALTA" and rsDatos.Mes EQ 7>selected="selected"</cfif>>Julio</option>
                            <option value="8" <cfif modo neq "ALTA" and rsDatos.Mes EQ 8>selected="selected"</cfif>>Agosto</option>
                            <option value="9" <cfif modo neq "ALTA" and rsDatos.Mes EQ 9>selected="selected"</cfif>>Setiembre</option>
                            <option value="10" <cfif modo neq "ALTA" and rsDatos.Mes EQ 10>selected="selected"</cfif>>Octubre</option>
                            <option value="11" <cfif modo neq "ALTA" and rsDatos.Mes EQ 11>selected="selected"</cfif>>Noviembre</option>
                            <option value="12" <cfif modo neq "ALTA" and rsDatos.Mes EQ 12>selected="selected"</cfif>>Diciembre</option>
                        </select>
                    </cfif>			
                  </td>
                </tr>
                <cfif modo EQ 'ALTA'>
                <tr>
                  <td align="right" nowrap><strong>Per&iacute;odo hasta:</strong>&nbsp;</td>
                  <td nowrap>
                    <cfif modo neq 'ALTA'>#rsDatos.Periodo#
                        <input type="hidden" name="PeriodoHasta" id="PeriodoHasta" value="#rsDatos.Periodo#" >
                    <cfelse>
                        <input type="text" name="PeriodoHasta" id="PeriodoHasta" value="<cfif modo neq "ALTA">#rsDatos.Periodo#</cfif>" size="7" maxlength="5"  
                        onBlur="javascript:fm(this,0); funcValidaPeriodos();"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
                    </cfif>				
                  </td>
                  <td align="right" nowrap><strong>Mes hasta:</strong>&nbsp;</td>
                  <td nowrap>
                    <cfif modo neq 'ALTA'>
                        <cfset mesesHasta = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
                        #listgetat(mesesHasta, rsDatos.Mes)#
                        <input type="hidden" name="MesHasta" id="MesHasta" value="#rsDatos.Mes#" >
                    <cfelse>
                        <select id="MesHasta" name="MesHasta" onchange="javascript: funcValidaPeriodos();">
                            <option value="1" <cfif modo neq "ALTA" and rsDatos.Mes EQ 1>selected="selected"</cfif>>Enero</option>
                            <option value="2" <cfif modo neq "ALTA" and rsDatos.Mes EQ 2>selected="selected"</cfif>>Febrero</option>
                            <option value="3" <cfif modo neq "ALTA" and rsDatos.Mes EQ 3>selected="selected"</cfif>>Marzo</option>
                            <option value="4" <cfif modo neq "ALTA" and rsDatos.Mes EQ 4>selected="selected"</cfif>>Abril</option>
                            <option value="5" <cfif modo neq "ALTA" and rsDatos.Mes EQ 5>selected="selected"</cfif>>Mayo</option>
                            <option value="6" <cfif modo neq "ALTA" and rsDatos.Mes EQ 6>selected="selected"</cfif>>Junio</option>
                            <option value="7" <cfif modo neq "ALTA" and rsDatos.Mes EQ 7>selected="selected"</cfif>>Julio</option>
                            <option value="8" <cfif modo neq "ALTA" and rsDatos.Mes EQ 8>selected="selected"</cfif>>Agosto</option>
                            <option value="9" <cfif modo neq "ALTA" and rsDatos.Mes EQ 9>selected="selected"</cfif>>Setiembre</option>
                            <option value="10" <cfif modo neq "ALTA" and rsDatos.Mes EQ 10>selected="selected"</cfif>>Octubre</option>
                            <option value="11" <cfif modo neq "ALTA" and rsDatos.Mes EQ 11>selected="selected"</cfif>>Noviembre</option>
                            <option value="12" <cfif modo neq "ALTA" and rsDatos.Mes EQ 12>selected="selected"</cfif>>Diciembre</option>
                        </select>
                    </cfif>			
                  </td>
                </tr>
                </cfif>
                <tr>
                  <td align="right" nowrap><strong>Monto:</strong>&nbsp;</td>
                  <td nowrap colspan="3">
                    <input type="text" style="text-align:right" name="Monto" id="Monto" value="<cfif modo neq "ALTA">#LSNumberFormat(rsDatos.Monto, ',9.00')#</cfif>" size="30" maxlength="30"  
                        onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
                  </td>
                </tr>
                <tr>
                    <td align="right" nowrap><strong>Criterio de incremento:</strong>&nbsp;</td>
                    <td colspan="3">
                        <input type="radio" value="POR" id="porcentaje" name="opt_incremento" onclick="javascript: funcCambiaText();" checked="checked"/><label for="porcentaje">Porcentaje</label>
                        <input type="radio" value="MTO" id="monto" name="opt_incremento" onclick="javascript: funcCambiaText();"/><label for="monto">Monto</label>
                    </td>
                </tr>		
                <tr>
                  <td align="right" nowrap><strong>Valor de incremento:</strong>&nbsp;</td>
                  <td id="tdIncMonto" nowrap colspan="3" style="display:none"><!----Incremento por Monto---->
                    <input type="text" style="text-align:right" name="MontoIncremento" id="MontoIncremento" value="0" size="30" maxlength="30"  
                        onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
                  </td>
                  <td  id="tdIncPorc" nowrap colspan="3"><!----Incremento por porcentaje----->
                    <input type="text" style="text-align:right" name="PorcIncremento" id="PorcIncremento" value="0" size="30" maxlength="30"  
                        onBlur="javascript:fm(this,2); if(parseFloat(this.value)>100){alert('El porcentaje de aumento debe ser entre 0 y 100');this.value = 0;}"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
                  </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" align="center">
                        <cfif modo EQ "ALTA">
                            <input type="submit" name="Alta" value="Agregar" onClick="javascript:return funcHabilitarValidacion();" >
                            <input type="reset" name="Limpiar" value="Limpiar">
                        <cfelse>
                            <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
                                <cfinvokeargument name="arTimeStamp" value="#rsDatos.ts_rversion#"/>
                            </cfinvoke>
                            <input type="hidden" name="ts_rversion" value="#ts#">
                            <input type="submit" name="Cambio" value="Modificar">
                            <input type="submit" name="Baja" value="Eliminar" onClick="javascript: funcDeshabilitarValidacion(); if( confirm('¿Desea Eliminar el Registro?') ){deshabilitarValidacion(); return true;} return false;">
                            <input type="submit" name="Nuevo" value="Nuevo"  onClick="javascript:funcDeshabilitarValidacion();" >
                        </cfif>
                    </td>
                </tr>
              </table>
           </td>
        </tr>
        <tr id="ConImportar" align="center" style="display:none">
        	<td><cf_sifFormatoArchivoImpr EIcodigo="IMPPARTIDAS"></td>
        	<td valign="top" align="left" colspan="2">
				<cf_sifimportar EIcodigo="IMPPARTIDAS" mode="in" form="formOtrasPartidas" height="150">
                    <cf_sifimportarparam name="RHEid" 	value="#form.RHEid#">
                    <cf_sifimportarparam name="RHPOPid" value="$RHPOPid$,Cuenta">
                </cf_sifimportar>
            </td>
        </tr>
		<tr>
		  <td colspan="3" align="center">&nbsp;</td>
	    </tr>
	</table>

</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formOtrasPartidas");
		
	objForm.RHPOPid.description="Cuenta de partidas presupuestarias";
	objForm.Periodo.description="Período desde";
	objForm.Mes.description="Mes desde";
	<cfif modo EQ 'ALTA'>
		objForm.PeriodoHasta.description="Período hasta";
		objForm.MesHasta.description="Mes hasta";
	</cfif>
	objForm.Monto.description="Monto";
		
	function funcHabilitarValidacion(){
		objForm.RHPOPid.required = true;
		objForm.Periodo.required = true;	
		objForm.Mes.required = true;	
		<cfif modo EQ 'ALTA'>
			objForm.MesHasta.required = true;	
			objForm.PeriodoHasta.required = true;	
		</cfif>
		objForm.Monto.required = true;
		if (funcValidaPeriodos){
			return true;
		}
		else{
			return false;
		}
	}
	
	function funcDeshabilitarValidacion(){
		objForm.RHPOPid.required = false;
		objForm.Periodo.required = false;
		objForm.Mes.required = false;	
		objForm.Monto.required = false;	
		<cfif modo EQ 'ALTA'>
			objForm.MesHasta.required = false;	
			objForm.PeriodoHasta.required = false;
		</cfif>	
	}
	
	function fnOcultar(v){
		if(v){
			document.getElementById("ConImportar").style.display = "";
			document.getElementById("SinImportar").style.display = "none";
			document.formOtrasPartidas.RHPOPdistribucionCFA.value = "1";
			document.formOtrasPartidas.RHPOPdistribucionCFB.value = "1";
			if(document.formOtrasPartidas.RHPOPdistribucionCF.value != 1 ){
				document.formOtrasPartidas.RHPOPid.value = "";
				document.formOtrasPartidas.CPformato.value = "";
				document.formOtrasPartidas.CPdescripcion.value = "";
			}
		}else{
			document.getElementById("ConImportar").style.display = "none";
			document.getElementById("SinImportar").style.display = "";
			document.formOtrasPartidas.RHPOPdistribucionCFA.value = "0";
			document.formOtrasPartidas.RHPOPdistribucionCFB.value = "1";
		}
	}
	
</script>
