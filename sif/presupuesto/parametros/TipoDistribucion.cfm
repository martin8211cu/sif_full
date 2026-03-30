<cf_templateheader title="	Control de Presupuesto - Cat&aacute;logos - Costos por Centro Funcional">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Costos por Centro Funcional'>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="3" valign="top">
                    <cfinclude template="../../portlets/pNavegacionAD.cfm">
                </td>
            </tr>
            <tr>
	      		<td align="center" class="tituloListas">Lista de Distribuciones de Costos:</td>
                <td align="center"><strong>Distribuciones de Costos por Centro Funcional:</strong></td>
    		</tr>
            <tr>
                <td valign="top" width="46%">
                	<cfset navegacion = ''>                   
                    <cfif isdefined('form.CPDCid') and len(trim(form.CPDCid))>
                       <cfset navegacion = "CPDCid=#form.CPDCid#">
                    </cfif>
                    
                    <cfquery name="rsCostosCF" datasource="#Session.DSN#">
                        select 	CPDCid, CPDCcodigo, CPDCdescripcion, CPDCporcTotal
                        from    CPDistribucionCostos   
                        where   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
                    </cfquery>
                    
                    <cfinvoke 
                        component="sif.Componentes.pListas"
                        method="pListaQuery"
                        returnvariable="pListaRet">
                        <cfinvokeargument name="query" value="#rsCostosCF#"/>
                        <cfinvokeargument name="desplegar" value="CPDCcodigo, CPDCdescripcion"/>
                        <cfinvokeargument name="etiquetas" value="Codigo, Descripci&oacute;n"/>
                        <cfinvokeargument name="formatos" value="S,C"/>
                        <cfinvokeargument name="align" value="left,left"/>
                        <cfinvokeargument name="ajustar" value="N,N,N"/>
                        <cfinvokeargument name="irA" value="TipoDistribucion.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg" value="true"/>
                        <cfinvokeargument name="keys" value="CPDCid"/>
                        <cfinvokeargument name="navegacion" value="#navegacion#"/>
                        <cfinvokeargument name="PageIndex" value="1"/>
                        <cfinvokeargument name="MaxRows" value="0"/>
                     </cfinvoke>
                </td>
                <td valign="top" width="53%" align="center">
                    <cfinclude template="TipoDistribucionForm.cfm">
                </td>
        	</tr>
                    <cfinclude template="TipoCentroFuncional.cfm">          		
        </table>
	<cf_web_portlet_end>
<cf_templatefooter>

			


