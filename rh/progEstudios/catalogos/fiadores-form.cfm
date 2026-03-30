<cfif isdefined('form.RHFid')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetFiadores" returnvariable="rsFiador">
        <cfinvokeargument name="RHFid" 		value="#form.RHFid#">
    </cfinvoke>
	<cfset modo = "CAMBIO">
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
        	<td valign="top">
            	<cfinvoke 
                 component="rh.Componentes.pListas"
                 method="pListaRH"
                 returnvariable="pListaRet">
                    <cfinvokeargument name="tabla" value="RHFiadores"/>
                    <cfinvokeargument name="columnas" value="RHFid, RHFcedula, RHFapellido1, RHFapellido2, RHFnombre"/>
                    <cfinvokeargument name="desplegar" value="RHFcedula, RHFapellido1, RHFapellido2, RHFnombre"/>
                    <cfinvokeargument name="etiquetas" value="Cédula, 1° Apellido, 2° Apellido, Nombre"/>
                    <cfinvokeargument name="formatos" value="S,S,S,S"/>
                    <cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo#"/>
                    <cfinvokeargument name="align" value="left, left, left, left"/>
                    <cfinvokeargument name="ajustar" value="S"/>
                    <cfinvokeargument name="checkboxes" value="N"/>				
                    <cfinvokeargument name="irA" value="fiadores.cfm"/>
                    <cfinvokeargument name="showEmptyListMsg" value="true"/>
                    <cfinvokeargument name="keys" value="RHFid"/>
                </cfinvoke>
            </td>
            <td><table width="100%" border="0" cellspacing="1" cellpadding="1">
            	<form name="form1" method="post" action="fiadores-sql.cfm">
                <tr>
                    <td align="right">Cédula:</td>
                    <td><input type="text" name="RHFcedula" size="15" maxlength="15" value="<cfif modo NEQ 'ALTA'>#trim(rsFiador.RHFcedula)#</cfif>"></td>
                </tr>
                <tr>
                    <td align="right" nowrap>Nombre:</td>
                    <td><input type="text" name="RHFnombre" size="60" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsFiador.RHFnombre#</cfif>"></td>
                </tr>
                <tr>
                    <td align="right" nowrap>1° Apellido:</td>
                    <td><input type="text" name="RHFapellido1" size="60" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsFiador.RHFapellido1#</cfif>"></td>
                </tr>
                <tr>
                    <td align="right" nowrap>2° Apellido:</td>
                    <td><input type="text" name="RHFapellido2" size="60" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsFiador.RHFapellido2#</cfif>"></td>
                </tr>
                <tr>
                    <td align="right" nowrap>Estado Civil:</td>
                    <td>
                        <select name="RHFestadoCivil">
                            <option value="0" <cfif modo NEQ 'ALTA' and rsFiador.RHFestadoCivil eq 0>selected</cfif>>Soltero(a)</option>
                            <option value="1" <cfif modo NEQ 'ALTA' and rsFiador.RHFestadoCivil eq 1>selected</cfif>>Casado(a)</option>
                            <option value="2" <cfif modo NEQ 'ALTA' and rsFiador.RHFestadoCivil eq 2>selected</cfif>>Divorciado(a)</option>
                            <option value="3" <cfif modo NEQ 'ALTA' and rsFiador.RHFestadoCivil eq 3>selected</cfif>>Viudo(a)</option>
                            <option value="4" <cfif modo NEQ 'ALTA' and rsFiador.RHFestadoCivil eq 4>selected</cfif>>Unión Libre</option>
                            <option value="5" <cfif modo NEQ 'ALTA' and rsFiador.RHFestadoCivil eq 5>selected</cfif>>Separado(a)</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap>Provincia:</td>
                    <td><input type="text" name="RHFprovincia" size="60" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsFiador.RHFprovincia#</cfif>"></td>
                </tr>
                <tr>
                    <td align="right" nowrap>Cant&oacute;n:</td>
                    <td><input type="text" name="RHFcanton" size="60" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsFiador.RHFcanton#</cfif>"></td>
                </tr>
                <tr>
                    <td align="right" nowrap>Empresa donde Labora:</td>
                    <td><input type="text" name="RHFempresaLabora" size="60" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsFiador.RHFempresaLabora#</cfif>"></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <cf_botones modo="#modo#">
                        <cfset ts = "">	
                        <cfif modo neq "ALTA">
                            <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
                                <cfinvokeargument name="arTimeStamp" value="#rsFiador.ts_rversion#"/>
                            </cfinvoke>
                            <input type="hidden" name="RHFid" value="#form.RHFid#">
                        </cfif>
                        <input type="hidden" name="ts_rversion" value="#ts#">
                    </td>
                </tr>
                </form>
            </table></td>
        </tr>
	</table>
</cfoutput>


<script language="javascript1.2" type="text/javascript">

	function funcAlta(){
		return fnValidarE();
	}
	function funcCambio(){
		return fnValidarE();
	}
	
	function fnValidarE(){
		Lced = trim(document.form1.RHFcedula.value).length;
		Lnom = trim(document.form1.RHFnombre.value).length;
		L1ap = trim(document.form1.RHFapellido1.value).length;
		L2ap = trim(document.form1.RHFapellido2.value).length;
		Lest = trim(document.form1.RHFestadoCivil.value).length;
		Lpro = trim(document.form1.RHFprovincia.value).length;
		Lcan = trim(document.form1.RHFcanton.value).length;
		Lemp = trim(document.form1.RHFempresaLabora.value).length;

		errores = "";
		if(Lced == 0)
			errores = errores + " -La cédula es requerida.\n";
		if(Lnom == 0)
			errores = errores + " -El nombre es requerido.\n";
		if(L1ap == 0)
			errores = errores + " -El 1° apellido es requerido.\n";
		if(L2ap == 0)
			errores = errores + " -El 2° apellido es requerido.\n";
		if(Lest == 0)
			errores = errores + " -El estado civil es requerido.\n";
		if(Lpro == 0)
			errores = errores + " -La provincia es requerida.\n";
		if(Lcan == 0)
			errores = errores + " -El cantón es requerido.\n";
		if(Lemp == 0)
			errores = errores + " -La empresa donde labora es requerida.\n";
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		return true;
	}
	
	function trim(cad){  
    	return cad.replace(/^\s+|\s+$/g,"");  
	}
	
</script>