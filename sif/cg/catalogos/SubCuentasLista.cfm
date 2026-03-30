
	<cf_templateheader title="Contabilidad General">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Lista de Cuentas de Mayor">
	 
	 <table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td>
					<cfif isdefined("session.modulo") and session.modulo EQ "CG">
						<cfinclude template="../../portlets/pNavegacionCG.cfm">
					<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
						<cfinclude template="../../portlets/pNavegacionAD.cfm">
					</cfif>
				</td>
              </tr>
			  <tr>
				  <td>&nbsp;
				  	
				  </td>
			  </tr>
			  <tr>
			  	<td class="etiquetaCampo">
					&nbsp;Seleccione la cuenta de Mayor a la que quiere agregar la subcuenta:
				</td>
			  </tr>
			  <tr>
				  <td>&nbsp;
				  	
				  </td>
			  </tr>
              <tr> 
                <td valign="top">
					<cfset filtro = "">
					<cfset navegacion = "">
					<cfinclude template="SubCuentasFiltro.cfm">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="CtasMayor" 
						columnas="	Cmayor, 
									Cdescripcion, 
									Ctipo,
									case 
										when Ctipo = 'A' then 'Activo' 
										when Ctipo = 'P' then 'Pasivo' 
										when Ctipo = 'C' then 'Capital'
										when Ctipo = 'I' then 'Ingreso' 
										when Ctipo = 'G' then 'Gasto' 
										when Ctipo = 'O' then 'Orden'  
									else ''
										end as 	Tipo,
									Cmascara as formato,
									PCEMid as tipoMascara,
									'ALTA' as modo2" 
						desplegar="Cmayor, Cdescripcion, Tipo"
						etiquetas="Cuenta, Descripción, Tipo"
						formatos=""
						filtro="Ecodigo=#session.Ecodigo# #filtro# order by Cmayor"
						align="left, left, left"
						checkboxes="N"
						keys="Cmayor"
						ira="CuentasContables.cfm"
						navegacion="#navegacion#">
					</cfinvoke>
				</td>
			</tr>
		</table>
		
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>