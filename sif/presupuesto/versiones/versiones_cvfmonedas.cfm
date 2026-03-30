<cfquery name="rsVinculada" datasource="#Session.dsn#">
	select count(1) as Cantidad
	from CVPresupuesto c, CPCtaVinculada v
	where c.Ecodigo 	= #session.ecodigo#
	  and c.CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
	  and c.CVPcuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
	  and v.Ecodigo		= c.Ecodigo
	  and v.CPPid		= #qry_cv.CPPid#
	  and v.CPformato	= c.CPformato
</cfquery>
<cfset LvarVinculada = rsVinculada.cantidad GT 0>
<cfif LvarVinculada>
	<cfparam name="form.CPCano" default="-1">
	<cfparam name="form.CPCmes" default="-1">
	<cfparam name="session.PRES_Formulacion.CVPcuenta" default="-1">
	<cfparam name="session.PRES_Formulacion.Ocodigo" default="-1">
	<cfif session.PRES_Formulacion.CVPcuenta NEQ form.CVPcuenta OR session.PRES_Formulacion.Ocodigo NEQ form.Ocodigo>
		<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version) --->
		<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
		<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
		<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_Formulacion")>
		<cfset LobjAjuste.AjustaFormulacion(form.cvid, form.CVPcuenta, form.Ocodigo)>
	</cfif>
</cfif>

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr><td >&nbsp;</td></tr>
	<cfif pantalla EQ 4>
	<tr><td class="subTitulo" align="center">Solicitud de Montos por Mes de una Moneda</td></tr>
	<cfelse>
	<tr><td class="subTitulo" align="center">Solicitud de Montos por Moneda de un Mes de Presupuesto</td></tr>
	</cfif>
	<tr><td >&nbsp;</td></tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfinclude template="versiones_cvfmonedas_filtro.cfm">
					</td>
				</tr>
			<cfif pantalla EQ 4>
				<tr>
					<td width="50%" valign="top">
						<br><cfinclude template="versiones_cvfmonedas_solicitar.cfm">
					</td>
				</tr>
			<cfelse>
				<tr>
					<td width="50%" valign="top">
						<br><cfinclude template="versiones_cvfmonedas_lista.cfm">
					</td>
				</tr>
				<tr>
					<td width="20%" valign="top" align="center">

						<cfif LvarVinculada>
							<font color="#FF0000">La Cuenta es Vinculada, no se puede modificar</font>
						<cfelse>
						<br><cfinclude template="versiones_cvfmonedas_form.cfm">
						</cfif>
					</td>
				</tr>
				<cfif form.Ocodigo NEQ -1 AND qry_cv.CVtipo EQ "2">
				<tr>
					<td align="center" colspan="2">
					<BR>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select c.CPcuenta
						  from CPresupuestoControl cn, CVPresupuesto c
						 where c.Ecodigo 	= #session.ecodigo#
						   and c.CVid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
						   and c.CVPcuenta 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
						   and c.CPcuenta	is not null
						   and cn.Ecodigo 	= c.Ecodigo
						   and cn.CPPid		= #qry_cv.CPPid#
						   and cn.CPCano	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCano#">
						   and cn.CPCmes	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCmes#">
						   and cn.CPcuenta	= c.CPcuenta
						   and cn.Ocodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ocodigo#">
					</cfquery>
					<cfif rsSQL.CPcuenta NEQ "">
						<cfset LvarSinDetalles = true>
						<cfset form.CPcuenta = rsSQL.CPcuenta>
						<cfset session.CPPid = qry_cv.CPPid>
						<cfset session.Ocodigo = form.ocodigo>
						<cfinclude template="/sif/presupuesto/consultas/ConsPresupuestoControl.cfm">
					<cfelse>
						La Cuenta es nueva o no está Control de Presupuesto para la Oficina y Mes indicados<BR>
					</cfif>
					<BR>
					</td>
				</tr>
				</cfif>
			</cfif>
				<tr>
					<td colspan="2" align="center">
						<cfif pantalla EQ 4>
							<cfif LvarVinculada>
								<font color="#FF0000"><strong>La Cuenta es Vinculada, no se puede modificar</strong></font>
								<BR><BR>
								<cf_botones values="Regresar" incluyeForm="true">
							<cfelseif isdefined('qry_cv') and qry_cv.CVaprobada EQ 1>
								<cf_botones values="Regresar" incluyeForm="true">
							<cfelse>
								<cf_botones values="Cambiar, Regresar" incluyeForm="true">
							</cfif>							
						<cfelse>
							<cf_botones values="Regresar" incluyeForm="true">
						</cfif>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</td>
	</tr>
</table>

<script language="javascript" type="text/javascript">
	<!--//
		function funcRegresar(){
			var cvid = <cfoutput>#form.CVid#</cfoutput>;
			var cmayor = <cfoutput>'#trim(form.Cmayor)#'</cfoutput>;
			var cvpcuenta = <cfoutput>#form.CVPcuenta#</cfoutput>;
			var ocodigo = <cfoutput>#form.Ocodigo#</cfoutput>;
			location.href="versionesComun.cfm?cvid="+cvid+"&cmayor="+cmayor+"&cvpcuenta="+cvpcuenta+"&ocodigo="+ocodigo;
			return false;
		}
		function funcRegresarMoneda()
		{
			return funcRegresar();
		}
	//-->
</script>
