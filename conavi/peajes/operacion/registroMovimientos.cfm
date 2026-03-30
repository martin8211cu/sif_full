<cfif modo eq 'ALTA' and isdefined('form.BTNEliminar') and isdefined('form.chk') and len(trim(form.chk))>
	<cfset lista = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(lista)#" index="item">
		<cftransaction>
			<cfinvoke component="conavi.Componentes.registroMovimientos"
				method="BAJA_PDTVehiculosConPet"
				PETid="#lista[item]#"
				Ecodigo="#form.Ecodigo#"
				returnvariable="LvarIdM"
			/>
			<cfinvoke component="conavi.Componentes.registroMovimientos"
				method="BAJA_PDTCerradoConPETid"
				PETid="#lista[item]#"
				returnvariable="LvarId"
			/>
			<cfinvoke component="conavi.Componentes.registroMovimientos"
				method="BAJA_PDTDepositoConPETid"
				PETid="#lista[item]#"
				returnvariable="LvarId"
			>
			<cfinvoke component="conavi.Componentes.registroMovimientos"
				method="BAJA"
				PETid="#lista[item]#"
				Ecodigo="#form.Ecodigo#"
				returnvariable="LvarId"
			/>
		</cftransaction>
	</cfloop>
		<cflocation url="listaRegistroMovimientos.cfm">
</cfif>
<cfparam name="modo" default="ALTA">
<cfparam name="url.tab" default="1">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<!---<cfdump var="#form#">--->
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Registro de Movimientos" skin="#Session.Preferences.Skin#">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">		        
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfinclude template="registroMovimientos_form.cfm">
					</td>
				<tr>
				<tr>
					<td>
						<cfif modo neq 'ALTA'>
							<cfparam name="form.tab" default="1">
							<cf_tabs width="100%">
								<cf_tab text="Detalles de veh&iacute;culos" selected="#url.tab eq 1#">
									<cfif url.tab eq 1>
										<cfinclude template="registroMovimientos_frameDetallesVehiculo.cfm">
									</cfif>
								</cf_tab>
								<cf_tab text="Horarios de Cierre" selected="#url.tab eq 2#">
									<cfif url.tab eq 2>
										<cfinclude template="registroMovimientos_frameDetallesCierre.cfm">
									</cfif>
								</cf_tab>
								<cf_tab text="Dep&oacute;sitos" selected="#url.tab eq 3#">
									<cfif url.tab eq 3>
										<cfinclude template="registroMovimientos_frameDetallesDeposito.cfm">
									</cfif>
								</cf_tab>
							</cf_tabs>
							<script language="javascript1.2" type="text/javascript">
								function tab_set_current(n) {
									location.href = "registroMovimientos.cfm?modo=CAMBIO&PETid=<cfoutput>#form.PETid#</cfoutput>&tab="+n;
								}
							</script>
						</cfif>
					</td>
				</tr>
			</table>
		</td> 
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>