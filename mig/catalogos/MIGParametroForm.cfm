
<cfif not isdefined ('form.MIGParid') and isdefined ('url.MIGParid') and trim(url.MIGParid) >
	<cfset form.MIGParid=url.MIGParid>
</cfif>
<cfif not isdefined("Form.modo") and not isdefined ('URL.Nuevo') and not isdefined ('form.Nuevo')>
	<cfset form.modo=url.modo>
</cfif>
<cfif not isdefined ('url.Tab')>
	<cfset url.Tab=1>
<cfelse>
	<cfset url.Tab=url.Tab>
	<cfset modo='CAMBIO'>
</cfif>
   <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_DatosGenerales"
    Default="General"
    returnvariable="LB_generales"/>

    <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_Calif"
    Default="Calificaci&oacute;n"
    returnvariable="LB_SD"/>

	<cf_tabs width="100%">
    	<cf_tab text="#LB_generales#" selected="#url.Tab NEQ 2#">
    		<cf_web_portlet_start border="true" titulo="#LB_generales#" >
    			<cfinclude template="MIGParametroTab1.cfm">
    		<cf_web_portlet_end>
   		</cf_tab>
   	<cfif modo NEQ 'ALTA'>
    	<cf_tab text="#LB_SD#" selected="#url.Tab EQ 2#">
				<cf_web_portlet_start border="true" titulo="#LB_SD#">
				  <cfinclude template="MIGParametroTab2.cfm">
				<cf_web_portlet_end>
    	</cf_tab>
		</cfif>

	</cf_tabs>

        </td>
      </tr>
    </table>




