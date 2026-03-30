
<cfif not isdefined ('form.MIGPaid') and isdefined ('url.MIGPaid') and trim(url.MIGPaid) >
	<cfset form.MIGPaid=url.MIGPaid>
</cfif>
<cfif not isdefined("Form.modo") and not isdefined ('URL.Nuevo') and not isdefined ('form.Nuevo')>
	<cfset form.modo=url.modo>
</cfif>
<cfif not isdefined ('url.Tab')>
	<cfset url.Tab=1>
<cfelse>
	<cfset url.Tab=url.Tab>
</cfif>


   <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_DatosGenerales"
    Default="Pa&iacute;s"
    returnvariable="LB_generales"/>
    
    <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_Cuentas"
    Default="Regi&oacute;n"
    returnvariable="LB_SD"/>
    
<!---	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>--->


	<cf_tabs width="100%">
    	<cf_tab text="#LB_generales#" selected="#url.Tab NEQ 2#">
    		<cf_web_portlet_start border="true" titulo="#LB_generales#" >
    			<cfinclude template="PaisTab1.cfm">
    		<cf_web_portlet_end>   
   		</cf_tab>
   	<cfif modo NEQ 'ALTA'>
    	<cf_tab text="#LB_SD#" selected="#url.Tab EQ 2#">
			<cf_web_portlet_start border="true" titulo="#LB_SD#">
			  <cfinclude template="PaisTab2.cfm">
			<cf_web_portlet_end>   
    	</cf_tab>
	</cfif>
	</cf_tabs>
   
        </td>
      </tr>
    </table>
<!---<cfif isdefined("url.Det") or isdefined("form.Det")>
	<a name="Det"></a>
	<script language="javascript">
		location.href = "#Det";
	</script>
</cfif>
 



 <cf_tab text="Datos Generales">
	<cf_web_portlet_start border="true" titulo="Datos Generales" >
		<cfinclude template="DireccionTab1.cfm">
	<cf_web_portlet_end>
</cf_tab>
--->
		
		


