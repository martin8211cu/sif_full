<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 16-4-2010.
 --->
<cfinclude template="../../../sif/cg/consultas/Funciones.cfm">

<!----Empresas de la corporacion(Todas las empresas de la corporacion (session.CEcodigo) exepto la en la que se esta)---->
<cfset gpoElimina="#get_val(1330).Pvalor#">

<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Ecodigo, Edescripcion 
	from Empresas
	where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina#) and
		  Ecodigo <> #session.Ecodigo#
	order by Ecodigo
</cfquery>			
<!---
<cfset gpoElimina = ObtenerDato(1330)>
<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select a.Ecodigo,a.Edescripcion
	from Empresas a 
	where a.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value = "#session.CEcodigo#">
		and a.Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
</cfquery>
--->
<cfoutput>
	<cfset modo='ALTA'>    
	<cfif isdefined("form.Ecodigo") and len(trim(form.Ecodigo))>
        <cfset modo = 'CAMBIO'>
    </cfif>
    <cfif modo NEQ 'ALTA'>	
		<cfquery name="rsdata" datasource="#session.DSN#">
            select CEcodigo, EcodigoEmp, Ccuenta, ts_rversion
            from Cons_CtaConEliminaIconoF
            where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value = "#form.CEcodigo#">
                and EcodigoEmp = <cfqueryparam cfsqltype="cf_sql_integer" value = "#form.EcodigoEmp#">
                and Ccuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value = "#form.Ccuenta#">
        </cfquery>
    </cfif>
	<form name="form1" method="post" action="SQLEliminaIconoF.cfm" onSubmit="javascritp: return funcValidar()">
		<input type="hidden" tabindex="-1" name="EcodigoEmp2" value="<cfif modo NEQ 'ALTA'>#rsdata.EcodigoEmp#</cfif>">
        <input type="hidden" tabindex="-1" name="CcuentaAux" value="<cfif modo NEQ 'ALTA'>#rsdata.Ccuenta#</cfif>">
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
		<table width="100%" border="0">
           <tr>
                <td align="right" nowrap><strong>Empresa Origen:&nbsp;</strong> </td>	
                <td>		
                    <select name="EcodigoEmp" id="EcodigoEmp" tabindex="1">
                        <cfloop query="rsEmpresas">
                            <option value="#rsEmpresas.Ecodigo#" <cfif modo NEQ 'ALTA' and rsEmpresas.Ecodigo EQ rsdata.EcodigoEmp>selected</cfif>>#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
                        </cfloop>
                    </select>
                    
                </td>	
            </tr>
            <tr>                
            <td align="right" nowrap><strong>Cuenta por Eliminar:&nbsp;</strong> </td>	
            <td>
				<cfif IsDefined ("url.errorCta") and url.errorCta is 1>
                	<input name="CFcuentacxc" type="text" value="#form.Cuenta#" size="50" maxlength="50" /> 
                <cfelseif modo NEQ 'ALTA'>
                    <cfquery name="rsCuenta" datasource="#session.DSN#">
                        select a.CEcodigo, a.EcodigoEmp, a.Ccuenta as CFcuentacxc
                        from Cons_CtaConEliminaIconoF a
                        where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
                            and a.EcodigoEmp = <cfqueryparam cfsqltype="cf_sql_integer" value= "#rsdata.EcodigoEmp#" >
                            and  a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdata.Ccuenta#">
                    </cfquery>
                    <input name="CFcuentacxc" type="text" value="#rsCuenta.CFcuentacxc#" size="50" maxlength="50" />                    	
                <cfelse>
                    <input name="CFcuentacxc" type="text" value="" size="50" maxlength="50" />
                </cfif>
                
            </td>                	
            </tr>
				<cfif #url.errorCta# NEQ 0>
                    <tr>
                        <td></td>
                        <td colspan="4" style="color:red;font-weight:bold;">
                      La cuenta de eliminaci&oacute;n #form.Cuenta# no existe en el cat&aacute;logo de cuentas.</td>
                    </tr>
                </cfif>         
            <tr>
            <td colspan="2" align="center">
                <cf_botones modo="#modo#" tabindex="3">
            </td>	
       </tr>
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
		</cfinvoke>
         <input type="hidden" name = "ts_rversion" value ="#ts#">		
	</cfif>
</form> 
<script language="JavaScript1.2" type="text/javascript">
	function funcValidar(){
		if (document.form1.CFcuentacxc.value == ''){
			alert("Debe seleccionar una cuenta por eliminar");
			return false
		}
		return true
	}	
</script>
</cfoutput>
			


