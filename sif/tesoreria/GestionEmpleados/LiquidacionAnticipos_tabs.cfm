
<cfquery name="rsLiq" datasource="#session.dsn#">
	select 	coalesce(l.CCHid,0) as CCHid, GELtipoP,
			case 
				when l.CCHid is null then 'TES'
				when (select CCHtipo from CCHica where CCHid = l.CCHid) = 2 then 'TES'
				else 'CCH'
			end as GELtipoPago
	  from GEliquidacion l
	 where GELid=#form.GELid#
</cfquery>

<cfif not isdefined("form.tab") and isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>

<cfif LvarSAporComision AND not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6', form.tab) )>
	<cfset form.tab = 6>
<cfelseif NOT LvarSAporComision AND not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
	<cfset form.tab = 1>
</cfif>
        
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Anticipos"
    Default="Anticipos"
    returnvariable="LB_Anticipos" xmlfile = "LiquidacionAnticipos_tabs.xml"/>
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_AnticiposLiquidar"
    Default="Anticipos a Liquidar"
    returnvariable="LB_AnticiposLiquidar" xmlfile = "LiquidacionAnticipos_tabs.xml"/>
    
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Gastos"
    Default="Documentos de Gastos"
    returnvariable="LB_Gastos"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_DocumentosGastosLiquidar"
    Default="Documentos de Gastos a Liquidar"
    returnvariable="LB_DocumentosGastosLiquidar"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
    
    
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Devoluciones"
		 Default="Devoluciones"
		returnvariable="LB_Devoluciones"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
        
       
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DepositosBcos"
		 Default="Dep&oacute;sitos Bancarios"
		returnvariable="LB_DepositosBcos"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
    
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DevolucionesDepositosBancarios"
		 Default="Devoluciones por D&eacute;positos Bancarios"
		returnvariable="LB_DevolucionesDepositosBancarios"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
        

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DepositosEfectivo"
		 Default="Depósitos en Efectivo"
		returnvariable="LB_DepositosEfectivo"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
        
   <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DevolucionesDepositosEfectivo"
		 Default="Devoluciones por D&eacute;positos en Efectivo"
		returnvariable="LB_DevolucionesDepositosEfectivo"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
        
        
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Comision"
		 Default="Datos Comision"
		returnvariable="LB_Comision"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>
    
    <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DatosComision"
		 Default="Datos de la Comision"
		returnvariable="LB_DatosComision"  xmlfile = "LiquidacionAnticipos_tabs.xml"/>  
        
        
<!---	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>--->
<cfset tipo=#LvarSAporEmpleadoSQL#>
	<cf_tabs width="100%">
    	<cf_tab text="#LB_Anticipos#" selected="#form.tab eq 1#">
    		<cf_web_portlet_start border="true" titulo="#LB_AnticiposLiquidar#" >
    			<cfinclude template="Tab1_Anticipos.cfm">
    		<cf_web_portlet_end>   
   		</cf_tab>
   
    	<cf_tab text="#LB_Gastos#" selected="#form.tab eq 2#">
			<cf_web_portlet_start border="true" titulo="#LB_DocumentosGastosLiquidar#">
			  <cfinclude template="Tab2_Gastos.cfm">
			<cf_web_portlet_end>   
    	</cf_tab>
   
		<cfif rsLiq.GELtipoPago EQ 'CCH'>
			<cf_tab text="#LB_Devoluciones#" selected="#form.tab eq 4#">
				<cf_web_portlet_start border="true" titulo="#LB_Devoluciones#">
					<cfinclude template="Tab4_Devoluciones.cfm">
				<cf_web_portlet_end>   
			</cf_tab>
		<cfelse>
        
			<cf_tab text="#LB_DepositosEfectivo#" selected="#form.tab eq 5#">
				<cf_web_portlet_start border="true" titulo="#LB_DevolucionesDepositosEfectivo#">
					<cfinclude template="Tab5_DepositosE.cfm">
				<cf_web_portlet_end>   
			</cf_tab>
                    
			<cf_tab text="#LB_DepositosBcos#" selected="#form.tab eq 3#">
				<cf_web_portlet_start border="true" titulo="#LB_DevolucionesDepositosBancarios#">
					<cfinclude template="Tab3_Depositos.cfm">
				<cf_web_portlet_end>   
			</cf_tab>
            
		</cfif>
	<cfif LvarSAporComision>
    	<cf_tab text="#LB_Comision#" selected="#form.tab eq 6#">
    		<cf_web_portlet_start border="true" titulo="#LB_DatosComision#" >
    			<cfinclude template="Tab6_Comision.cfm">
    		<cf_web_portlet_end>   
   		</cf_tab>
	</cfif>
	</cf_tabs>
   
<!---<cf_web_portlet_end>--->
        </td>
      </tr>
    </table>
<cfif isdefined("url.Det") or isdefined("form.Det")>
	<a name="Det"></a>
	<script language="javascript">
		location.href = "#Det#";
	</script>
</cfif>
 


