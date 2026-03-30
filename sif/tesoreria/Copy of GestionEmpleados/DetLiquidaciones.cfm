
<cfquery name="rsLiq" datasource="#session.dsn#">
	select GELtipoP  from GEliquidacion where GELid=#form.GELid#
</cfquery>

 <cfif not isdefined("form.tab") and isdefined("url.tab") and not isdefined("form.tab")>
	 <cfset form.tab = url.tab >
  </cfif>
 <cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
	 <cfset form.tab = 1 >
  </cfif>
        
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_DatosGenerales"
    Default="Anticipos"
    returnvariable="LB_Anticipos"/>
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Cuentas"
    Default="Gastos Empleado"
    returnvariable="LB_Gastos"/>
    
	<cfif rsLiq.GELtipoP eq 0>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Depositos"
		 Default="Devoluciones"
		returnvariable="LB_Depositos"/>
	<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Depositos"
		 Default="Dep&oacute;sitos"
		returnvariable="LB_Depositos"/>
		 
	</cfif> 
<!---	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>--->
<cfset tipo=#LvarSAporEmpleadoSQL#>
	<cf_tabs width="100%">
    	<cf_tab text="#LB_Anticipos#" selected="#form.tab eq 1#">
    		<cf_web_portlet_start border="true" titulo="#LB_Anticipos#" >
    			<cfinclude template="Tab1_Anticipos.cfm">
    		<cf_web_portlet_end>   
   		</cf_tab>
   
    	<cf_tab text="#LB_Gastos#" selected="#form.tab eq 2#">
			<cf_web_portlet_start border="true" titulo="#LB_Gastos#">
			  <cfinclude template="LiquidacionAnticiposDet_lista.cfm">
			<cf_web_portlet_end>   
    	</cf_tab>
   
    	<cf_tab text="#LB_Depositos#" selected="#form.tab eq 3#">
			<cf_web_portlet_start border="true" titulo="#LB_Depositos#">
				<cfif rsLiq.GELtipoP eq 0>
					<cfinclude template="Tab3_Devoluciones.cfm">
				<cfelse>
				<cfinclude template="Tab3_Depositos_form.cfm">
					
				</cfif>
			<cf_web_portlet_end>   
    	</cf_tab>
	</cf_tabs>
   
<!---<cf_web_portlet_end>--->
        </td>
      </tr>
    </table>
<cfif isdefined("url.Det") or isdefined("form.Det")>
	<a name="Det"></a>
	<script language="javascript">
		location.href = "#Det";
	</script>
</cfif>
 


