
	<cf_templateheader title="Contabilidad General">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Subclases 
            de Cuenta'>
	
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td colspan="2" valign="top">
								<cfinclude template="../../portlets/pNavegacionCG.cfm"></td>
              </tr>
              <tr> 
                <td width="49%" valign="top"> <cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
                    <cfset Pagenum_lista = Form.Pagina >
                  </cfif> <cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="SubClaseCuentas" 
						columnas="convert(varchar,SCid) as SCid, case SCtipo when 'A' then 'Activo' when 'P' then 'Pasivo' when 'C' then 'Capital' when 'I' then 'Ingreso' when 'G' then 'Gasto' when 'O' then 'Orden' end as SCtipo, SCdescripcion" 
						desplegar="SCtipo, SCdescripcion"
						etiquetas="Tipo, Descripción"
						formatos=""
						filtro="Ecodigo=#session.Ecodigo# order by SCtipo"
						align="left, left"
						checkboxes="N"
						keys="SCid"
						ira="SubClaseCuentas.cfm">
                  </cfinvoke> </td>
                <td width="50%" valign="top"><cfinclude template="formSubClaseCuentas.cfm"></td>
              </tr>
              <tr><td colspan="2">&nbsp;</td></tr>
            </table>
            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>