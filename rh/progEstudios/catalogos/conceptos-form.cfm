<cfif isdefined('form.RHECBid') and len(trim(form.RHECBid)) gt 0>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetEC" returnvariable="rsConceptoE">
        <cfinvokeargument name="RHECBid" 		value="#form.RHECBid#">
    </cfinvoke>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined('form.RHDCBid') and len(trim(form.RHDCBid)) gt 0>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetDC" returnvariable="rsConceptoD">
        <cfinvokeargument name="RHECBid" 		value="#form.RHECBid#">
        <cfinvokeargument name="RHDCBid" 		value="#form.RHDCBid#">
    </cfinvoke>
	<cfset modoD = "CAMBIO">
</cfif>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<form name="formE" method="post" action="conceptos-sql.cfm">
    <tr><td align="center" class="tituloAlterno">Encabezado de Conceptos de Becas</td></tr>
	<tr>
    	<td align="center">
			<table width="90%" border="0" cellpadding="3" cellspacing="0">
                <tr>
                    <td nowrap><strong>#LB_Codigo#</strong></td>
                    <td nowrap><strong>#LB_Descripcion#</strong></td>
                    <td nowrap><strong>#LB_Fecha#</strong></td>
                    <td nowrap><strong>#LB_Multiple#</strong></td>
                    <td nowrap><strong>Beneficio</strong></td>
                    <td nowrap><strong>Reporte</strong></td>
                </tr>
				<tr>
					<td nowrap><input type="text" name="RHECBcodigo" id="RHECBcodigo" size="10" maxlength="10" value="<cfif modo NEQ 'ALTA'>#trim(rsConceptoE.RHECBcodigo)#</cfif>"></td>
                    <td nowrap><input type="text" name="RHECBdescripcion" id="RHECBdescripcion" size="80" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsConceptoE.RHECBdescripcion#</cfif>"></td>
					<cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
					<cfif modo NEQ 'ALTA'>
                    	<cfset fecha = LSDateFormat(rsConceptoE.RHECBfecha,'DD/MM/YYYY')>
                    </cfif>
                    <td nowrap><cf_sifcalendario form="formE" name="RHECBfecha" value="#fecha#"></td>	
				    <td align="center" nowrap><input type="checkbox" name="RHECBesMultiple" id="RHECBesMultiple" <cfif modo NEQ 'ALTA' and rsConceptoE.RHECBesMultiple eq 1>checked</cfif>></td>
					<td align="center" nowrap><input type="checkbox" name="RHECBbeneficio"  id="RHECBbeneficio" <cfif modo neq 'ALTA' and rsConceptoE.RHECBbeneficio eq 1 >checked</cfif>></td>
                	<td>
                        <select name="RHECBreporte" id="RHECBreporte">
                            <option value="" <cfif modo NEQ 'ALTA' and len(trim(rsConceptoE.RHECBreporte)) eq 0>selected<cfelseif modo EQ 'ALTA'>selected</cfif>></option>
                            <option value="1" <cfif modo NEQ 'ALTA' and rsConceptoE.RHECBreporte eq 1>selected</cfif>>Becas</option>
                            <option value="2" <cfif modo NEQ 'ALTA' and rsConceptoE.RHECBreporte eq 2>selected</cfif>>Beneficios</option>
                            <option value="3" <cfif modo NEQ 'ALTA' and rsConceptoE.RHECBreporte eq 3>selected</cfif>>Ambos</option>
                        </select>
                    </td>
                </tr>
                <tr>
                	<td colspan="4">
                    	<cf_botones modo="#modo#" sufijo="E">
                   		<cfset ts = "">
						<cfif modo NEQ 'ALTA'>
                            <input name="RHECBid" type="hidden" value="#form.RHECBid#">
                            <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsConceptoE.ts_rversion#" returnvariable="ts"></cfinvoke>
                        </cfif>
                        <input type="hidden" name="ts_rversion" value="#ts#">				
                   </td>
                </tr>	
			</table>
		</td>
    </tr>
	</form>
<cfif modo NEQ 'ALTA'>
    <tr><td>&nbsp;</td></tr>
    <tr><td align="center" class="tituloAlterno">Detalle de Conceptos de Becas</td></tr>
    <tr>
        <td align="center">
            <table width="90%" border="0" cellpadding="2" cellspacing="0">
            	<form name="formD" method="post" action="conceptos-sql.cfm">	  
                <tr>
                    <td nowrap><strong>#LB_Codigo#</strong></td>
                    <td nowrap><strong>#LB_Descripcion#</strong></td>
                    <td nowrap><strong>#LB_Fecha#</strong></td>
                    <td nowrap><strong>#LB_Tipo#</strong></td>
                    <td id="tdNegativosL" nowrap><strong>#LB_Negativos#</strong></td>
            	</tr>
                <tr>
                    <td nowrap><input type="text" name="RHDCBcodigo" id="RHDCBcodigo" size="11" maxlength="10" value="<cfif modoD NEQ 'ALTA'>#rsConceptoD.RHDCBcodigo#</cfif>"></td>
                    <td nowrap><input type="text" name="RHDCBdescripcion" id="RHDCBdescripcion" size="80" maxlength="80" value="<cfif modoD NEQ 'ALTA'>#rsConceptoD.RHDCBdescripcion#</cfif>"></td>
                    <cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
					<cfif modoD NEQ 'ALTA'>
                    	<cfset fecha = LSDateFormat(rsConceptoD.RHDCBfecha,'DD/MM/YYYY')>
                    </cfif>
                    <td nowrap><cf_sifcalendario form="formD" name="RHDCBfecha" value="#fecha#"></td>
                    <td nowrap>
						<select name="RHDCBtipo" onchange="fnValidaTipo(this.value)">
                        	<option value="0" <cfif modoD NEQ 'ALTA' and rsConceptoD.RHDCBtipo eq 0>selected</cfif>>- Sin Tipo -</option>
                            <option value="1" <cfif modoD NEQ 'ALTA' and rsConceptoD.RHDCBtipo eq 1>selected</cfif>>Texto</option>
                        	<option value="2" <cfif modoD NEQ 'ALTA' and rsConceptoD.RHDCBtipo eq 2>selected</cfif>>Monto</option>
                            <option value="3" <cfif modoD NEQ 'ALTA' and rsConceptoD.RHDCBtipo eq 3>selected</cfif>>Num&eacute;rico</option>
                            <option value="4" <cfif modoD NEQ 'ALTA' and rsConceptoD.RHDCBtipo eq 4>selected</cfif>>Fecha</option>
                        </select>
                    </td>
                	<td  id="tdNegativosI" align="center" nowrap><input type="checkbox" name="RHDCBnegativos" id="RHDCBnegativos" <cfif modoD NEQ 'ALTA' and rsConceptoD.RHDCBnegativos eq 1>checked</cfif>/></td>
                </tr>
                 <tr>
                    <td  colspan="5" nowrap>
                    	<cf_botones modo="#modoD#" sufijo="D">
                   		<cfset ts = "">
						<cfif modoD NEQ 'ALTA'>
                            <input name="RHDCBid" type="hidden" value="#rsConceptoD.RHDCBid#">
                            <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsConceptoD.ts_rversion#" returnvariable="ts"></cfinvoke>
                        </cfif>
                        <input type="hidden" name="ts_rversion" value="#ts#">	
                        <input name="RHECBid" type="hidden" value="#form.RHECBid#">
                    </td>
                </tr>
                </form>
        	</table> 
		</td>
    </tr>
    <tr>
    <td align="center" nowrap>
        <table width="90%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
                <cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                    <cfinvokeargument name="tabla" value="RHDConceptosBeca"/>
                    <cfinvokeargument name="columnas" value="RHECBid, RHDCBid, RHDCBcodigo, RHDCBdescripcion, RHDCBfecha"/>
                    <cfinvokeargument name="desplegar" value="RHDCBcodigo, RHDCBdescripcion, RHDCBfecha"/>
                    <cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Fecha#"/>
                    <cfinvokeargument name="formatos" value="S,S,D"/>
                    <cfinvokeargument name="formName" value="lista"/>
                    <cfinvokeargument name="filtro" value="RHECBid = #form.RHECBid# order by RHDCBcodigo, RHDCBdescripcion"/>
                    <cfinvokeargument name="align" value="left, left, left"/>
                    <cfinvokeargument name="ajustar" value="S"/>
                    <cfinvokeargument name="checkboxes" value="N"/>
                    <cfinvokeargument name="keys" value="RHDCBid"/>
                    <cfinvokeargument name="irA" value="conceptos.cfm"/>
                </cfinvoke>
           </td></tr>
        </table>
	</tr>
</cfif>
</table>
<script language="javascript1.2" type="text/javascript">
	
	function trim(cad){  
    	return cad.replace(/^\s+|\s+$/g,"");  
	}
	
	function funcAltaE(){
		return fnValidarE();
	}
	
	function funcCambioE(){
		return fnValidarE();
	}
	
	function fnValidarE(){
		Lcod = trim(document.getElementById('RHECBcodigo').value).length;
		Ldesc = trim(document.getElementById('RHECBdescripcion').value).length;
		Lfecha = trim(document.getElementById('RHECBfecha').value).length;
		errores = "";
		if(Lcod == 0)
			errores = errores + " -El código del encabezado es requerido.\n";
		if(Ldesc == 0)
			errores = errores + " -La descripción del encabezado es requerido.\n";
		if(Lfecha == 0)
			errores = errores + " -La fecha del encabezado es requerido.\n";
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		return true;
	}
	
	function funcAltaD(){
		return fnValidarD();
	}
	
	function funcCambioD(){
		return fnValidarD();
	}
	
	function fnValidarD(){
		Lcod = trim(document.getElementById('RHDCBcodigo').value).length;
		LdescA = trim(document.getElementById('RHDCBdescripcion').value).length;
		Lfecha = trim(document.getElementById('RHDCBfecha').value).length;
		errores = "";
		if(Lcod == 0)
			errores = errores + " -El código del detalle es requerido.\n";
		if(LdescA == 0)
			errores = errores + " -La descripción del detalle es requerido.\n";
		if(Lfecha == 0)
			errores = errores + " -La fecha del detalle es requerido.\n";
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		return true;
	}
	
	function fnValidaTipo(v){
		objL = document.getElementById('tdNegativosL');
		objI = document.getElementById('tdNegativosI');
		switch(parseInt(v)){
			case 0:
				objL.style.display = "none";
				objI.style.display = "none";
				document.formD.RHDCBnegativos.checked = false;
			break;
			case 1:
				objL.style.display = "none";
				objI.style.display = "none";
				document.formD.RHDCBnegativos.checked = false;
			break;
			case 2:
				objL.style.display = "";
				objI.style.display = "";
			break;
			case 3:
				objL.style.display = "";
				objI.style.display = "";
			break;
			case 4:
				objL.style.display = "none";
				objI.style.display = "none";
				document.formD.RHDCBnegativos.checked = false;
			break;
			case 5:
				objL.style.display = "none";
				objI.style.display = "none";
				document.formD.RHDCBnegativos.checked = false;
			break;
		}
	}
	<cfif isdefined('form.RHDCBtipo')>
	fnValidaTipo(document.formD.RHDCBtipo.value);
	</cfif>
</script>
</cfoutput>