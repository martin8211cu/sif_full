<cf_navegacion name="Formato"			default="">
<cf_navegacion name="Cmayor"			default="">
<cf_navegacion name="F_Cformato"		session default="">
<cf_navegacion name="F_Cdescripcion"	session default="">


	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templateheader title="Cuentas Presupuestarias">
		
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
						<cfset filtro = " and Upper(CPdescripcion) like upper('%" & form.F_Cdescripcion & "%')">
					</cfif>
					
					<cfif isdefined('form.F_Cformato') and Len(Trim(form.F_Cformato))>
						<cfset filtro = filtro & " and CPformato like ('%" & form.F_Cformato & "%')">
					</cfif>					
					
                    <cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
						<cfset Pagenum_lista = Form.Pagina>
					</cfif>
 					<cfif not isdefined("Form.Cmayor")>
						<cflocation addtoken="no" url="CuentasMayor.cfm">
					</cfif>
					<cf_dbfunction name="concat" args="CPdescripcionF, ' (',CPdescripcion,')'" returnvariable="LvarDescripcion">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="CPresupuesto" 
						columnas="CPcuenta, 
							CPpadre, 
							CPformato, 
							case when CPdescripcionF is null OR CPdescripcionF = CPdescripcion 
								then 
									CPdescripcion
								else 
									#LvarDescripcion#
								end as CPdescripcion,
							Cmayor, 
							CPmovimiento as Movimiento,
							'#Form.formato#' as formato" 
						desplegar="CPformato, CPdescripcion, Movimiento"
						etiquetas="Cuenta, Descripción, Ultimo Nivel<BR>(Acepta Movimientos)"
						align="left, left, center"
						ajustar="N,S,S"
						formatos=""
						filtro="Ecodigo=#session.Ecodigo# and Cmayor='#Form.Cmayor#'  #filtro#  order by CPformato"
						checkboxes="N"
						keys="CPcuenta"
						showEmptyListMsg="true"
						maxRows="20"
						debug="N"
						navegacion="#navegacion#"
						ira="#GetFileFromPath(GetTemplatePath())#"
						>
                  </cfinvoke>
				</td>
			  	<td align="center" valign="top">
					<cfinclude template="CuentasPresupuesto-form.cfm">
			  	</td>
              </tr>
			</table>
            	
           <cf_web_portlet_end>

	<cf_templatefooter>
