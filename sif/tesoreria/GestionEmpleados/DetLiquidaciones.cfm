
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
    
	<cfif rsLiq.GELtipoPago EQ 'CCH'>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Devoluciones"
		 Default="Devoluciones"
		returnvariable="LB_Devoluciones"/>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DepositosBcos"
			 Default="Dep&oacute;sitos"
			returnvariable="LB_DepositosBcos"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DepositosEfectivo"
			 Default="Efectivo"
			returnvariable="LB_DepositosEfectivo"/>
	</cfif> 
<!---	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>--->
<cfset tipo=#LvarSAporEmpleadoSQL#>
	<cf_tabs width="100%">
    	<cf_tab text="#LB_Anticipos#" selected="#form.tab eq 1#">
    		<cf_web_portlet_start border="true" titulo="Anticipos a Liquidar" >
    			<cfinclude template="Tab1_Anticipos.cfm">
    		<cf_web_portlet_end>   
   		</cf_tab>
   
    	<cf_tab text="#LB_Gastos#" selected="#form.tab eq 2#">
			<cf_web_portlet_start border="true" titulo="Documentos de Gastos a Liquidar">
			  <cfinclude template="LiquidacionAnticiposDet_lista.cfm">
			<cf_web_portlet_end>   
    	</cf_tab>
   
		<cfif rsLiq.GELtipoPago EQ 'CCH'>
			<cf_tab text="#LB_Devoluciones#" selected="#form.tab eq 4#">
				<cf_web_portlet_start border="true" titulo="#LB_Devoluciones#">
					<cfinclude template="Tab3_Devoluciones.cfm">
				<cf_web_portlet_end>   
			</cf_tab>
		<cfelse>
			<cf_tab text="#LB_DepositosBcos#" selected="#form.tab eq 3#">
				<cf_web_portlet_start border="true" titulo="Devoluciones por Depósitos Bancarios">
					<cfinclude template="Tab3_Depositos_form.cfm">
				<cf_web_portlet_end>   
			</cf_tab>
	
			<cf_tab text="#LB_DepositosEfectivo#" selected="#form.tab eq 4#">
				<cf_web_portlet_start border="true" titulo="Devoluciones por Depósitos en Efectivo">
<!---
					<cfinclude template="Tab3_Devoluciones.cfm">
--->
					<div align="center">
					<BR><BR><BR>
					Esta funcionalidad no ha sido implementada todavía<BR><BR>
					Sírvase a realizar un Depósito en una Cuenta de la Empresa y 
					entregar la boleta de depósito para su liquidación
					<BR><BR><BR>
					</div>	
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
		location.href = "#Det";
	</script>
</cfif>
 


