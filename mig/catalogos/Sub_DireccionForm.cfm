<cfif not isdefined ('form.MIGSDid') and isdefined ('url.MIGSDid') and trim(url.MIGSDid) >
	<cfset form.MIGSDid=url.MIGSDid>
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
    Default="Sub_Direcci&oacute;n"
    returnvariable="LB_generales"/>
    
    <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_Cuentas"
    Default="Gerencia"
    returnvariable="LB_SD"/>
    
<!---	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>--->
	<cf_tabs width="100%">
    	<cf_tab text="#LB_generales#" selected="#url.Tab NEQ 2#">
    		<cf_web_portlet_start border="true" titulo="#LB_generales#" >
    			<cfinclude template="Sub_DireccionTab1.cfm">
    		<cf_web_portlet_end>   
   		</cf_tab>
   	<cfif modo NEQ 'ALTA'>
    	<cf_tab text="#LB_SD#" selected="#url.Tab EQ 2#">
			<cf_web_portlet_start border="true" titulo="#LB_SD#">
			  <cfinclude template="Sub_DireccionTab2.cfm">
			<cf_web_portlet_end>   
    	</cf_tab>
	</cfif>
	</cf_tabs>
   
        </td>
      </tr>
    </table>
		


