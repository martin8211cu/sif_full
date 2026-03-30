	<cf_templateheader title="Tesorería">
		<br>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Concepto de Gastos'>
	
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="3">
				<cfif isdefined("session.modulo") and session.modulo EQ "CG">
					<cfinclude template="../../portlets/pNavegacionCG.cfm">
				<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
					<cfinclude template="../../portlets/pNavegacionAD.cfm">
				</cfif>				
				</td>
              </tr>
              <tr> 
                <td valign="top"> 
                  <cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
                    <cfinvokeargument name="tabla" value="GEconceptoGasto a
															inner join GEtipoGasto b
															  on b.GETid = a.GETid"/>
     				<cfinvokeargument name="columnas" value="a.GECid, a.GECconcepto, a.GECdescripcion, a.GECcomplemento"/>
                    <cfinvokeargument name="desplegar" value="GECconcepto, GECdescripcion,GECcomplemento"/>
                    <cfinvokeargument name="etiquetas" value="Código, Descripción Gasto,Complemento"/>
                    <cfinvokeargument name="formatos" value="S,S,S"/>
                    <cfinvokeargument name="filtro" value="b.Ecodigo = #Session.Ecodigo#"/>
                    <cfinvokeargument name="align" value="left,center,left"/>
                    <cfinvokeargument name="ajustar" value="S"/>
    				<cfinvokeargument name="keys" value="GECid"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
                    <cfinvokeargument name="irA" value="ConceptoGasto.cfm"/>
                  </cfinvoke>
                </td>				
                <td valign="top">
                   <cfinclude template="ConceptoGastoform.cfm">
                  &nbsp;</td>
              </tr>
            </table>
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>