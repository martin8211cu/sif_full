<!--- 
	Modificado por: Ana Villaviencio
	Fecha: 13 de febrero del 2006
	Motivo: corregir error cuando el empleado no tiene registro dentro de la tabla de EVacacionesEmpleado, se hace la consulta
			para la insercion del registro de vacaciones y el registro en Bregimen.
			Se corrigió para q mantuviera los filtros.
 --->

<cfquery name="rsDatos" datasource="#session.DSN#">
	select EVfvacas,
		   EVfanual, 
		   EVdiaanual, 
		   EVmesanual, 
		   EVfantig, 
		   EVmes,  
		   EVdia

	from EVacacionesEmpleado 

	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfquery name="rsDatosEmp" datasource="#session.DSN#">
	select ti.NTIdescripcion,
		   de.DEidentificacion, 
		   {fn concat( {fn concat({fn concat({fn concat(de.DEnombre, ' ')}, de.DEapellido1)},'')}, de.DEapellido2)} as NombreEmp
	from DatosEmpleado de

	inner join NTipoIdentificacion ti
	   on de.NTIcodigo = ti.NTIcodigo

	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

			<form name="form1" action="CambioFAnualidad-sql.cfm" method="post">
				<cfoutput>
					<cfif isdefined('rsDatos') and rsDatos.RecordCount>
					
					<input name="EVfanualant" type="hidden" value="#LSDateFormat(rsDatos.EVfanual,'dd/mm/yyyy')#">
					<input name="EVdiaanualant" type="hidden" value="#rsDatos.EVdiaanual#">
					<input name="EVmesanualant" type="hidden" value="#rsDatos.EVmesanual#">
					<input name="EVfantigant" type="hidden" value="#rsDatos.EVfantig#">
					<input name="EVdiaant" type="hidden" value="#rsDatos.EVdia#">
					<input name="EVmesant" type="hidden" value="#rsDatos.EVmes#">
					<input name="EVfvacasant" type="hidden" value="#LSDateFormat(rsDatos.EVfvacas,'dd/mm/yyyy')#">
					
				<cfelse>
					<input name="InsertEV" type="hidden" value="0">
				</cfif>
				<input name="Filtro_DEidentificacion" type="hidden" value="#form.Filtro_DEidentificacion#">
				<input name="Filtro_Empleado" type="hidden" value="#form.Filtro_Empleado#">
				<input name="HFiltro_DEidentificacion" type="hidden" value="<cfif isdefined('form.HFiltro_DEidentificacion')>#form.HFiltro_DEidentificacion#</cfif>">
				<input name="HFiltro_Empleado" type="hidden" value="<cfif isdefined('form.HFiltro_Empleado')>#form.HFiltro_Empleado#"</cfif>>
				<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
				</cfoutput>
		
			<cfoutput>
			<table width="50%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr><td colspan="5">&nbsp;</td></tr>
				 <tr> 
					<td width="10%" align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_Empleado" xmlfile="/rh/generales.xml">Empleado</cf_translate>:</strong></td>
					<td colspan="5" nowrap> 
						#rsDatosEmp.NombreEmp# &nbsp;&nbsp;<b>#vIdentificacion#:</b> #rsDatosEmp.DEidentificacion#
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong>#vFechaAnualidad#:&nbsp;</strong></td>
					<td>
						<cfif isdefined('form.EVfanual') and LEN(TRIM(form.EVfanual))>
							<cfset Fanual = LSDateFormat(form.EVfanual,'dd/mm/yyyy')>
						<cfelseif LEN(TRIM(rsDatos.EVfanual))>
							<cfset Fanual = LSDateFormat(rsDatos.EVfanual,'dd/mm/yyyy')>
						<cfelse>
							<cfset Fanual = LSDateFormat(Now(),'dd/mm/yyyy')>
						</cfif>
						<cf_sifcalendario name='EVfanual' value="#Fanual#">
					</td>
					<td>&nbsp;</td>
					<td align="right" nowrap><strong>#vFechaVacaciones#:&nbsp;</strong></td>
					<td>
						<cfif isdefined('form.EVFvacas') and  LEN(TRIM(form.EVfvacas))>
							<cfset Fvacas = LSDateFormat(form.EVfvacas,'dd/mm/yyyy')>
						<cfelseif LEN(TRIM(rsDatos.EVfvacas))>
							<cfset Fvacas = LSDateFormat(rsDatos.EVfvacas,'dd/mm/yyyy')>
						<cfelse>
							<cfset Fvacas = LSDateFormat(Now(),'dd/mm/yyyy')>
						</cfif>
						<cf_sifcalendario name='EVfvacas' value="#Fvacas#"></td>
				</tr>
				<tr>
					<td colspan="5" align="center">
						<cfif not isdefined('form.Aceptar')>
							<cfset regresa = 'CambioFAnualidad.cfm?Pagina=#form.Pagina#&DEid=#form.DEid#&Filtro_DEidentificacion=#form.Filtro_DEidentificacion#&Filtro_Empleado=#form.Filtro_Empleado#&HFiltro_DEidentificacion=#form.HFiltro_DEidentificacion#&HFiltro_Empleado=#form.HFiltro_Empleado#'>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Aceptar"
							Default="Aceptar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Aceptar"/>
														
							<cf_botones exclude="BAJA,ALTA,NUEVO,CAMBIO" names="Aceptar" values="#BTN_Aceptar#" Regresar="#regresa#">
						<cfelse>
							&nbsp;
						</cfif>
					</td>
				</tr>
			</table>
			</cfoutput>
			<cfif isdefined('form.Aceptar')>
				<cfoutput>
				<table width="90%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td width="45%">
							<table width="100%" cellpadding="0" cellspacing="0" border="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
								<tr><td align="center" class="#Session.Preferences.Skin#_thcenter" colspan="2"><strong>Situación Actual</strong></td></tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td align="right"><strong>#vFechaAnualidad#:</strong></td>
									<td>&nbsp;<cfif LEN(TRIM(form.EVfanualant))>#form.EVfanualant#<cfelse><cf_translate key="MSG_No_Hay_Fecha_Asignada">No hay Fecha asignada</cf_translate></cfif></td>
								</tr>
								<tr>
									<td align="right"><strong>#vFechaVacaciones#:</strong></td>
									<td>&nbsp;<cfif LEN(TRIM(form.EVfvacasant))>#form.EVfvacasant#<cfelse><cf_translate key="MSG_No_Hay_Fecha_Asignada">No hay Fecha asignada</cf_translate></cfif></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						</td>
						<td width="45%">
							<table width="100%" cellpadding="0" cellspacing="0" border="0"  class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
								<tr><td align="center" class="#Session.Preferences.Skin#_thcenter" colspan="2"><strong>Situación Propuesta</strong></td></tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td align="right"><strong>#vFechaAnualidad#:</strong></td>
									<td>&nbsp;#form.EVfanual#</td>
								</tr>
								<tr>
									<td align="right"><strong>#vFechaVacaciones#:</strong></td>
									<td>&nbsp;#form.EVfvacas#</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="2">
						<cfset regresa = 'CambioFAnualidad.cfm?Pagina=#form.Pagina#&DEid=#form.DEid#&Filtro_DEidentificacion=#form.Filtro_DEidentificacion#&Filtro_Empleado=#form.Filtro_Empleado#&HFiltro_DEidentificacion=#form.HFiltro_DEidentificacion#&HFiltro_Empleado=#form.HFiltro_Empleado#'>
						<cf_botones modo="CAMBIO"  exclude="BAJA,ALTA,NUEVO" Regresar="#regresa#"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				</cfoutput> 
			</cfif>
			<input name="DEid" type="hidden" value="<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))><cfoutput>#form.DEid#</cfoutput></cfif>">
			</form>
<script language="javascript1.2">
	function funcCambio(){
		if(confirm('¿<cfoutput>#vMensaje#</cfoutput>?')){
			return true;
		}else{return false;}
	}
</script>