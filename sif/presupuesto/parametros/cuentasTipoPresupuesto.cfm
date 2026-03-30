<cf_templateheader title="Cuentas seg&uacute;n Presupuesto">
		       
		<cfif isdefined("form.tab")>
			<cfset form.tab = form.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8', form.tab) )>
			<cfset form.tab = 1 >
		</cfif>
        
        <!--- Verifica si el parametro Genera Contabilidad Presupuestaria (1140) esta activo --->
        <cfquery name="rsPresupuestoCostos" datasource="#Session.DSN#" >
			select coalesce(Pcodigo, 0) as PCodigo, Pvalor
            from Parametros 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="1140">
		</cfquery> 

		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->	
		</script>
		
		<cf_web_portlet_start border="true" titulo="Cuentas seg&uacute;n tipo de Presupuesto" >
		<cfinclude template="../../portlets/pNavegacion.cfm">
        <table border="0">
            <tr>
                <td colspan="2">&nbsp;</td>
                <td colspan="2">
                    <strong>Período del Presupuesto</strong>:&nbsp;
                </td>
            </tr>
    
            <tr>
                <td colspan="2">&nbsp;</td>
                <td colspan="2">
                    <cf_cboCPPid IncluirTodos="false" createform="frmCPPid" session="true" CPPestado="0,1" CPPid="CPPid" onChange="document.frmCPPid.submit();">
                </td>
            </tr>
        </table>
        
        <table>
			<tr>
            	<td>
               		<cf_tabs width="99%">
                   		<cf_tab text="Ingresos Presupuestales" selected="#form.tab eq 1#">
                            <cf_web_portlet_start border="true" titulo="Presupuesto de Ingresos Presupuestales" >
								<cfinclude template="cuentasTipoPre-Ingresos.cfm"> 
							<cf_web_portlet_end>
						</cf_tab>
                        
                        <cf_tab text="Egresos Presupuestales" selected="#form.tab eq 2#">
                            <cf_web_portlet_start border="true" titulo="Presupuesto de Egresos o Gastos Presupuestales" >
								<cfinclude template="cuentasTipoPre-Egresos.cfm"> 
							<cf_web_portlet_end>
						</cf_tab> 
                        
                        <cfif #rsPresupuestoCostos.PCodigo# NEQ 0 and #rsPresupuestoCostos.PValor# EQ 'S'>
                            <cf_tab text="Presupuesto de Costos" selected="#form.tab eq 3#">
								<cf_web_portlet_start border="true" titulo="Cuentas para Presupuesto de Costos" >
                                	<cfinclude template="cuentasTipoPre-Costos.cfm"> 
								<cf_web_portlet_end>
							</cf_tab>
                        </cfif>							

						<cf_tab text="Exclusiones al Presupuesto"	id="4" selected="#form.tab is '4'#">
							<cf_web_portlet_start border="true" titulo="Cuentas que se Excluyen de Control de Presupuesto" >
								<cfinclude template="cuentasTipoPre-Exclusiones.cfm"> 
							<cf_web_portlet_end>
						</cf_tab>
					</cf_tabs> 
                </td>					
			</tr>
		</table>
		<cf_templatefooter>