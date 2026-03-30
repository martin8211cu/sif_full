<cf_navegacion name="Cmayor"			default="">
<cf_navegacion name="Formato"			default="">
<cf_navegacion name="F_Cformato"		session default="">
<cf_navegacion name="F_Cdescripcion"	session default="">


	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templateheader title="Cuentas Financieras">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cuentas Financieras'>

			<cfset regresar = "javascript:CuentasM();">
			<cfif isdefined("session.modulo") and session.modulo EQ "CG">
				<cfinclude template="../../portlets/pNavegacionCG.cfm">
			<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
				<cfinclude template="../../portlets/pNavegacionAD.cfm">
			</cfif>
			<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
                <td width="55%" align="center" valign="top"> 
					<cfset filtro = "">				
					<cfset LvarFiltroNoBalance = true>
					<cfinclude template="filtroCuentasContables.cfm">
					
					<cfif isdefined('form.F_Cdescripcion') and Len(Trim(form.F_Cdescripcion))>
						<cfset filtro = " and Upper(CFdescripcion) like upper('%" & form.F_Cdescripcion & "%')">
					</cfif>
					
					<cfif isdefined('form.F_Cformato') and Len(Trim(form.F_Cformato))>
						<cfset filtro = filtro & " and CFformato like ('%" & form.F_Cformato & "%')">
					</cfif>					
					
                    <cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
						<cfset Pagenum_lista = Form.Pagina>
					</cfif>
 					<cfif not isdefined("Form.Cmayor")>
						<cflocation addtoken="no" url="CuentasMayor.cfm">
					</cfif>
					<cf_dbfunction name="concat" args="CFdescripcionF, ' (',CFdescripcion,')'" returnvariable="LvarDescripcion">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="CFinanciera" 
						columnas="CFcuenta, 
							CFpadre, 
							CFformato, 
							case when CFdescripcionF is null OR CFdescripcionF = CFdescripcion 
							
								then CFdescripcion 
								
							else 
								
								#LvarDescripcion#
							end as CFdescripcion,
							Cmayor, 
							CFmovimiento as Movimiento,
							'#Form.formato#' as formato,
							'#Form.F_Cdescripcion#' as F_Cdescripcion,
							'#Form.F_Cformato#' as F_Cformato
							" 
						desplegar="CFformato, CFdescripcion, Movimiento"
						etiquetas="Cuenta, Descripción, Ultimo Nivel<BR>(Acepta Movimientos)"
						align="left, left, center"
						ajustar="N,S,S"
						formatos=""
						filtro="Ecodigo=#session.Ecodigo# and Cmayor='#Form.Cmayor#'  #filtro#  order by CFformato"
						checkboxes="N"
						keys="CFcuenta"
						showEmptyListMsg="true"
						maxRows="20"
						navegacion="#navegacion#"
						ira="#GetFileFromPath(GetTemplatePath())#">
                  </cfinvoke>
				</td>
			  	<td align="center" valign="top">
					<cfinclude template="CuentasFinancieras-form.cfm">
			  	</td>
              </tr>
			</table>
            	
           <cf_web_portlet_end>

	<cf_templatefooter>