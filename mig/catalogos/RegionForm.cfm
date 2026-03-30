
<cfif not isdefined ('form.MIGRid') and isdefined ('url.MIGRid') and trim(url.MIGRid) >
	<cfset form.MIGRid=url.MIGRid>
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
    Default="Regi&oacute;n"
    returnvariable="LB_A"/>
    
    <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_Cuentas"
    Default="&Aacute;rea"
    returnvariable="LB_R"/>
    
<!---	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>--->


	<cf_tabs width="100%">
    	<cf_tab text="#LB_A#" selected="#url.Tab NEQ 2#">
    		<cf_web_portlet_start border="true" titulo="#LB_A#" >
    			<cfinclude template="RegionTab1.cfm">
    		<cf_web_portlet_end>   
   		</cf_tab>
   	<cfif modo NEQ 'ALTA'>
    	<cf_tab text="#LB_R#" selected="#url.Tab EQ 2#">
			<cf_web_portlet_start border="true" titulo="#LB_R#">
			  <cfinclude template="RegionTab2.cfm">
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
		
		


