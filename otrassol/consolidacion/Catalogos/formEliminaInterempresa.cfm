<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 16-4-2010.
 --->

<cfinclude template="../../../sif/cg/consultas/Funciones.cfm">

<!----Empresas de la corporacion(Todas las empresas de la corporacion (session.CEcodigo) exepto la en la que se esta)---->
<cfset gpoElimina="#get_val(1330).Pvalor#">

<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Ecodigo 
	from Empresas
	where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina#) and
		  Ecodigo <> #session.Ecodigo#
	order by Ecodigo
</cfquery>	

<cfoutput>
	<cfset modo='ALTA'>  
	<cfif isdefined("form.Ecodigo") and len(trim(form.Ecodigo))>
        <cfset modo = 'CAMBIO'>
    </cfif>
    <cfif modo NEQ 'ALTA'>	
		<cfquery name="rsdata" datasource="#session.DSN#">
            select CEcodigo,EcodigoEmp,Ccuenta,Ccuenta2,CFCuentaContable,CFCuentaComplemento,CFdescripcion,ts_rversion
            from Cons_CtaConEliminaInter1
            where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#form.CEcodigo#">
                and EcodigoEmp = <cfqueryparam cfsqltype="cf_sql_integer" value = "#form.EcodigoEmp#">
                and CFCuentaContable = <cfqueryparam cfsqltype="cf_sql_char" value= "#form.Cuenta#">
        </cfquery>
    </cfif>
    
	<form name="form1" method="post" action="SQLEliminaInterEmpresa.cfm" onSubmit="javascript: return funcValidar()">
		<input type="hidden" tabindex="-1" name="EcodigoEmp2" value="<cfif modo NEQ 'ALTA'>#rsdata.EcodigoEmp#</cfif>">
        <input type="hidden" tabindex="-1" name="Cformato_CcuentacxcAux" 
        	value="<cfif modo NEQ 'ALTA'>#rsdata.CFCuentaContable#</cfif>">
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
		<table width="100%" border="0">
			<tr>               
				<td align="right" nowrap><strong>Cuenta por Eliminar:&nbsp;</strong> </td>	
				<td>
                	<cfif IsDefined ("url.errorCta") and url.errorCta is 1 or url.errorCta is 2>
<!---						<cfquery name="rsCuenta" datasource="#session.DSN#">
							select b.Ccuenta, b.Cdescripcion
							from CContables b
							where b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Cuenta#">
						</cfquery>	
						<cf_cuentas 
                            Intercompany='yes' 
                            Conexion="#Session.DSN#" 
                            Conlis="S" 
                            auxiliares="N" 
                            movimiento="S" 
                            form="form1" 
                            ccuenta="Ccuentacxc"                             
                            CFcuenta="CFcuentacxc" 
                            query="#rsCuenta#" 
                            tabindex="2"
                            FirstColWidth="35"
                            onchangeIntercompany="*">
--->					<cfelseif modo NEQ 'ALTA'>
                            <cfquery name="rsCuenta" datasource="#session.DSN#">
                                select a.CFCuentaContable,a.CFCuentaComplemento,
                                (select MIN(b.Ccuenta) from CContables b 
                                  where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value= "#form.EcodigoEmp#">) as Ccuenta
                                from Cons_CtaConEliminaInter1 a
                                where a.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CEcodigo#">
                                    and a.EcodigoEmp =  <cfqueryparam cfsqltype="cf_sql_integer" value= "#form.EcodigoEmp#" >
                                    and a.CFCuentaContable = <cfqueryparam cfsqltype="cf_sql_char" value= "#form.Cuenta#" >
                            </cfquery>	
                            <cf_cuentas 
                                Intercompany='yes' 
                                Conexion="#Session.DSN#" 
                                Conlis="S" auxiliares="N" 
                                movimiento="S" 
                                form="form1" 
                                ccuenta="Ccuentacxc" 
                                CFcuenta="CFcuentacxc" 
                                query="#rsCuenta#" 
                                tabindex="2"
                                FirstColWidth="35">
                                
					<cfelse>
						<cf_cuentas Intercompany='yes' Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxc" CFcuenta="CFcuentacxc" tabindex="2" FirstColWidth="35"> 
					</cfif>
				</td>                	
			</tr>
<!---				<cfif IsDefined ("url.errorCta") and url.errorCta is 1 or url.errorCta is 2>
                    <tr>
                    	<td></td>
                        <cfquery name="rsEmpresa" datasource="#session.DSN#">
							select Edescripcion from Empresas where Ecodigo = #session.Ecodigo#
						</cfquery>	
                        <cfquery name="rsFormCta" datasource="#session.DSN#">
							select Cformato from CContables where Ccuenta = #form.Cuenta# and Ecodigo = #form.EcodigoEmp#
						</cfquery>
                        <cfset MensError ="">	
                        <cfif url.errorCta is 1>
                        	<cfset MensError = "La cuenta de eliminaci&oacute;n #rsFormCta.Cformato# no existe para la empresa de consolidaci&oacute;n #rsEmpresa.Edescripcion#." >
                        <cfelseif url.errorCta is 2>
                        	<cfset MensError = "La cuenta de eliminaci&oacute;n #rsFormCta.Cformato# no pudo ser creada la empresa de consolidaci&oacute;n #rsEmpresa.Edescripcion#.">
                        </cfif>
                      	<td colspan="4" style="color:red;font-weight:bold;"> #MensError# </td>
                    </tr>                    
                </cfif> 
--->            
			<tr>
                <td align="right" nowrap><strong>Cuenta Destino:&nbsp;</strong> </td>
                <td>
                    <cfif modo NEQ 'ALTA'>
                        <cfquery name="rsCuenta" datasource="#session.DSN#">
                            select a.Ccuenta,a.CFCuentaComplemento,a.CFCuentaContable,a.CFCuentaComplemento
                            from Cons_CtaConEliminaInter1 a
							where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CEcodigo#">
                                and a.EcodigoEmp = <cfqueryparam cfsqltype="cf_sql_integer" value= "#form.EcodigoEmp#" >
                                and a.CFCuentaComplemento = <cfqueryparam cfsqltype="cf_sql_char" value= "#form.Cuenta2#" >
						</cfquery>	
                        <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxp" CFcuenta="CFcuentacxp" query="#rsCuenta#" tabindex="3" FirstColWidth="35">
                        
                    <cfelse>
                        <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxp" CFcuenta="CFcuentacxp" tabindex="3" FirstColWidth="35"> 
                    </cfif>
                </td>	
            </tr>	
            <tr>
             	<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong> </td>
                <td>
				<input name="CFdescripcion" tabindex="3" type="text" value="<cfif modo NEQ "ALTA" AND isdefined("form.Cuenta")>#HTMLEditFormat(rsdata.CFdescripcion)#</cfif>" size="50" maxlength="50" onfocus="javascript:this.select();">
                </td>
            </tr>	
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
            if (document.form1.Cformato_Ccuentacxc.value == ''){
                alert("Debe seleccionar una cuenta por eliminar");
                return false
				}
				
			if (document.form1.Cformato_Ccuentacxp.value == ''){
                alert("Debe seleccionar una cuenta compensación");
                return false
            }
			
            return true
        }	
    </script>
    
    
	<script type="text/javascript">
    <!--
	re_comodin = /x/i;
	document.form1.Cformato_Ccuentacxc.onblur =
		function () {
			if (!document.form1.Cformato_Ccuentacxc.value.match(re_comodin))
			{
				TraeCuentasTagCcuentacxc(document.form1.Cmayor_Ccuentacxc, document.form1.Cformato_Ccuentacxc);
			}
			else
			{
				document.form1.Cdescripcion_Ccuentacxc.value = "CUENTA COMODIN";
			}
		}
	document.form1.Cformato_Ccuentacxp.onblur =
		function () {
			if (!document.form1.Cformato_Ccuentacxp.value.match(re_comodin))
			{
				TraeCuentasTagCcuentacxc(document.form1.Cmayor_Ccuentacxp, document.form1.Cformato_Ccuentacxp);
			}
			else
			{
				document.form1.Cdescripcion_Ccuentacxp.value = "CUENTA COMODIN";
			}
		}
		
		
	document.form1.Cformato_Ccuentacxc.onkeyup =
		function () {
			if (!document.form1.Cformato_Ccuentacxc.value.match(re_comodin))
				conlis_keyup_Ccuentacxc(event);
		}
		
	document.form1.Cformato_Ccuentacxc.onkeypress =
		function () {
			if (event.keyCode!= 88 && event.keyCode!= 120)	
			{
				return KeyPressCuentaFinanciera(event, document.form1.Ccuentacxc, document.form1.CFcuentacxc, document.form1.Cdescripcion_Ccuentacxc);
			}
			return true;				
		}
		
	document.form1.Cformato_Ccuentacxp.onkeypress =
		function () {
			if (event.keyCode!= 88 && event.keyCode!= 120)
			{
				return KeyPressCuentaFinanciera(event, document.form1.Ccuentacxp, document.form1.CFcuentacxp, document.form1.Cdescripcion_Ccuentacxp);
			}
			return true;
		}
/*alert(document.form1.Cformato_Ccuentacxp.onkeypress);
*/    

	<cfif modo NEQ "ALTA">
		document.form1.Cformato_Ccuentacxc.value = '#Trim(rsData.CFCuentaContable)#'.substr(5);
		document.form1.Cformato_Ccuentacxp.value = '#Trim(rsData.CFCuentaComplemento)#'.substr(5);
		document.form1.Cmayor_Ccuentacxc.value = '#rsData.CFCuentaContable#'.substring(0,4);
		document.form1.Cmayor_Ccuentacxp.value = '#rsData.CFCuentaComplemento#'.substring(0,4);
		if (!document.form1.Cformato_Ccuentacxc.value.match(re_comodin))
		{
			TraeCuentasTagCcuentacxc(document.form1.Cmayor_Ccuentacxc, document.form1.Cformato_Ccuentacxc);
		}
		else
		{
			document.form1.Cdescripcion_Ccuentacxc.value = "CUENTA COMODIN";
		}
		if (!document.form1.Cformato_Ccuentacxp.value.match(re_comodin))
		{
			TraeCuentasTagCcuentacxc(document.form1.Cmayor_Ccuentacxp, document.form1.Cformato_Ccuentacxp);
		}
		else
		{
			document.form1.Cdescripcion_Ccuentacxp.value = "CUENTA COMODIN";
		}

	</cfif>
	for (var i=document.form1.Ecodigo_Ccuentacxc.length-1; i>=0; i--) {
		switch (document.form1.Ecodigo_Ccuentacxc.options[i].value) {
		<cfloop query="rsEmpresas">
		case '#Trim(rsEmpresas.Ecodigo)#':
		</cfloop>
		break;
		default: 
			document.form1.Ecodigo_Ccuentacxc.remove(i);
		}
	}
	//-->
    </script>
    
</cfoutput>
			


