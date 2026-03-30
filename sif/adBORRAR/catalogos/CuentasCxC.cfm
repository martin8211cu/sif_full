<cfset LvarTitulo = 'Cuenta Dep&oacute;sitos en Tr&aacute;nsito'>
<cfset LvarFiltro = ' and CBid is null '>
<cfset LvarIrA = '/cfmx/sif/ad/catalogos/CuentasCxC.cfm'>
<cfif isdefined("LvarCuentaBancos")>
	<cfset LvarTitulo = 'Cuenta Bancos'>
    <cfset LvarFiltro = ' and CBid is not null '>
    <cfset LvarIrA = '/cfmx/sif/cc/catalogos/CuentaBancos.cfm'>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="#LvarTitulo#">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
 <cf_web_portlet_start titulo="#LvarTitulo#">
 	<cfset navegacion= "">
	<cfset maxRows = 15>
		 <table width="95%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top" width="50%"> 
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="pListaTran">
							<cfinvokeargument name="tabla" value="CuentasCxC a 
                            										inner join CFinanciera b 
                                                                    on a.CFcuenta = b.CFcuenta "/>
							<cfinvokeargument name="columnas" value="ID, CodigoCatalogoCxC, Descripcion_Cuenta, CFdescripcion"/>
							<cfinvokeargument name="desplegar" value="CodigoCatalogoCxC, Descripcion_Cuenta, CFdescripcion"/>
							<cfinvokeargument name="etiquetas" value="Codigo, Descripción, Cuenta"/>
							<cfinvokeargument name="formatos" value="S,S,S"/>
                            <cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="filtro" value="a.Ecodigo=#session.Ecodigo# #LvarFiltro# order by CodigoCatalogoCxC"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" value="ID"/>
							<cfinvokeargument name="irA" value="#LvarIrA#"/>
							<cfinvokeargument name="maxRows" value="#maxRows#"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke> 
						</td>
					<td><cfinclude template="CuentasCxC_form.cfm"></td>
				 </tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
 <cf_web_portlet_end>		
<cf_templatefooter>