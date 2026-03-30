<cfset fnLeeDatos()>
<form method="post" name="form1" action="/cfmx/sif/ad/catalogos/CuentasCxC_sql.cfm">
	<cfif isdefined("LvarCuentaBancos")>
		<input name="LvarCuentaBancos" value="1" type="hidden"/>
	</cfif>
	<table width="100%" cellpadding="1" cellspacing="0" border="0">
  		<tr>
        	<td nowrap align="right">C&oacute;digo:&nbsp;</td><td>
				<cfif modo NEQ "ALTA">
					<cfoutput>#trim(htmlEditFormat(rsCuentasCxC.CodigoCatalogoCxC))#
                        <input name="CodigoCatalogoCxC" type="hidden" id="CodigoCatalogoCxC" tabindex="1" value="#trim(htmlEditFormat(rsCuentasCxC.CodigoCatalogoCxC))#" size="10" maxlength="10">
                	</cfoutput>
				<cfelse>
                    <input name="CodigoCatalogoCxC" type="text" id="CodigoCatalogoCxC" tabindex="1" value="" size="10" maxlength="10">
                </cfif>
            </td>
        </tr>
        <tr>
			<cfif isdefined("LvarCuentaBancos")>
                <td align="right" nowrap>Banco:&nbsp;</td>
                <td nowrap>
                    <select name="CBid" tabindex="1" id="CBid">
                        <cfoutput query="rsCuentaBanco">
                            <option value="#CBid#" <cfif modo NEQ "ALTA" and rsCuentasCxC.CBid EQ rsCuentaBanco.CBid>selected</cfif>>#CBcodigo#</option>
                        </cfoutput>
                    </select>
                </td>
            <cfelse>
                <td nowrap align="right">Cuenta:&nbsp;</td><td>
                    <cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsCuenta#" auxiliares="N" movimiento="N" frame="frame6" tabindex="1">
                    <input name="CBid" value="" type="hidden" />
                </td>
            </cfif>
        </tr>
        <tr> 
			<td nowrap align="right">Descripci&oacute;n:&nbsp;</td><td>
				<input name="DescripcionCuenta" type="text" id="DescripcionCuenta" tabindex="1" onfocus="javascript:this.select();" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#trim(htmlEditFormat(rsCuentasCxC.Descripcion_Cuenta))#</cfoutput></cfif>" 
				size="50" maxlength="50" >	
				<cfif modo neq "ALTA">
                    <input name="CFcuentaAnterior" id="CFcuentaAnterior" type="hidden" value="<cfoutput>#LvarCFcuenta#</cfoutput>"/>	
                </cfif>	
			</td>
        </tr>
	</table>
	<cf_botones modo="#modo#" tabindex="1">
</form>
<script language="JavaScript1.2">
	document.form1.CodigoCatalogoCxC.focus();
	
	function funcCambio(){
		if (valida() == false){
			return false;
		}
		return true;
	}
	function funcAgregar(){
		if (valida() == false){
			return false;
		}
		return true;
	}
	function valida() {
		if (document.form1.CodigoCatalogoCxC.value == '') {
			alert("Debe digitar un Codigo Valido");
			document.form1.CodigoCatalogoCxC.select();
			return false;
		}
		<cfif not isdefined("LvarCuentaBancos")>
			if (document.form1.Cmayor.value == '') {
				alert("Debe digitar una Cuenta Finaciera Valida");
				document.form1.Cmayor.select();
				return false;
			}	
			if (document.form1.Cformato.value == '') {
				alert("Debe digitar una Cuenta Finaciera Valida");
				document.form1.Cformato.select();
				return false;
			}	
		</cfif>
		if (document.form1.DescripcionCuenta.value == '') {
			alert("Debe digitar una Descripcion valida");
			document.form1.DescripcionCuenta.select();
			return false;
		}
		return true;
		}
</script> 
<cffunction name="fnLeeDatos" access="private" output="yes" returntype="any">
	<cfset modo = 'ALTA' >
    <cfset LvarCFcuenta = 0>
    <cfif isdefined("URl.ID") and len(trim("URL.ID")) NEQ 0 and URL.ID gt 0>
        <cfset Form.ID = url.ID>
    </cfif>
    <cfif isdefined("Form.ID") and len(trim("Form.ID")) NEQ 0 and Form.ID gt 0>
        <cfset modo="CAMBIO">
    </cfif>

	<cfif modo neq "ALTA">
         <cfquery name="rsCuentasCxC" datasource="#Session.DSN#">
            select CodigoCatalogoCxC, Descripcion_Cuenta, CFcuenta, CBid
                from CuentasCxC 
                    where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ID#">
        </cfquery>	
        <cfset LvarCFcuenta = rsCuentasCxC.CFcuenta>
    </cfif>

    <!--- Usado en el tag de cuentas --->
    <cfquery name="rsCuenta" datasource="#Session.DSN#">
        select 
            CFcuenta,
            Ccuenta, 
            CFdescripcion as Cdescripcion, 
            CFformato as Cfformato
        from CFinanciera
        where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuenta#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
    </cfquery>
    <cfquery name="rsCuentaBanco" datasource="#session.DSN#">
        select cb.CBcodigo, cb.CBid
        from CuentasBancos cb
        where cb.Ecodigo = #session.Ecodigo#
        <cfif modo eq "ALTA">
            and (select count(1)
                from CuentasCxC cc
                where cc.CBid = cb.CBid) = 0
        </cfif>
        order by cb.CBcodigo
    </cfquery>
</cffunction>
