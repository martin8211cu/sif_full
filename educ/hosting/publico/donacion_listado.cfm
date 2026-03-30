<!--- Entidad --->
<cfquery name="rsEntidad" datasource="#session.DSN#">
	select convert(varchar, MEpersona) as MEpersona, Pnombre || ' ' || Papellido1 || ' ' || Papellido2 as Pnombre
	from MEPersona
		where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#" >
</cfquery>

<cfset maxrows = 10 >
<cfif isdefined("form.Filtrar")>
	<cfset maxrows = -1 >
</cfif>

<cfquery name="donaciones" datasource="#session.dsn#" maxrows="#maxrows#" >
	select a.MEDdonacion, a.MEDfecha, a.MEDimporte, a.MEDmoneda,
		a.MEDforma_pago, a.MEDdescripcion, b.MEDnombre
	from MEDDonacion a, MEDProyecto b, MEPersona c
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#" >
		<cfif isdefined("form.Filtrar")	>
			<cfif isdefined("form.fMEDfecha") and len(trim(form.fMEDfecha)) gt 0 >
				and a.MEDfecha = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(form.fMEDfecha, 'yyyymmdd')#" >
			</cfif>
			<cfif isdefined("form.fMEDmoneda") and len(trim(form.fMEDmoneda)) gt 0 >
				and a.MEDmoneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fMEDmoneda#" >
			</cfif>
			<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0 >
				and a.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#" >
			</cfif>
		</cfif>
	  and a.MEDproyecto = b.MEDproyecto
	  and (a.MEDforma_pago = 'S' or a.MEDimporte != 0)
	  and c.MEpersona =* a.MEpersona
	order by MEDfecha desc
</cfquery>

<cfquery name="proyectos" datasource="#session.dsn#">
	select MEDproyecto, MEDnombre
	from MEDProyecto 
	where Ecodigo = #session.Ecodigo#
	  <!--- and METSid != #session.METSid# --->
	  and (MEDinicio is null or getdate() >= MEDinicio )
	  and (MEDfinal  is null or getdate() < dateadd(dd,1,MEDfinal) )
	order by MEDprioridad
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Listado de Donaciones
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/publico/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/publico/donacion.cfm">

	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	
	<form style="margin:0;" name="filtro" action="" method="post">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td>
		<cfinclude template="pNavegacion.cfm"><BR>
	</td></tr>


	<tr><td>
		<table width="100%" cellpadding="5" class="areaFiltro" align="center">
			<tr><td align="center">
				<table border="0" width="100%" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td width="1%" align="right">Fecha:&nbsp;</td>
						<td width="1%">
							<cfset fecha = '' >
							<cfif isdefined("form.fMEDfecha") and len(trim(form.fMEDfecha)) gt 0>
								<cfset fecha = form.fMEDfecha >
							<cfelseif not isdefined("form.fMEDfecha") >
								<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy') >
							</cfif>

							<cf_sifcalendario form="filtro" name="fMEDfecha" value="#fecha#">
						</td>
						<td width="1%">&nbsp;&nbsp;Moneda:&nbsp;</td>
						<td>
							<select name="fMEDmoneda">
								<option value="">Todos</option>
								<option value="CRC" <cfif isdefined("form.fMEDmoneda") and form.fMEDmoneda eq 'CRC'>selected</cfif> >CRC</option>
								<option value="USD" <cfif isdefined("form.fMEDmoneda") and form.fMEDmoneda eq 'USD'>selected</cfif> >USD</option>
							</select>
						</td>
						<td align="right">&nbsp;&nbsp;Proyecto:&nbsp;</td>
						<td>
							<cfoutput>
								<select name="fMEDproyecto">
									<option value="">Todos</option>
									<cfloop query="proyectos">
										<option value="#MEDproyecto#" <cfif isdefined("form.fMEDproyecto") and form.fMEDproyecto eq MEDproyecto> selected </cfif>>#MEDnombre#</option>
									 </cfloop>
								</select></cfoutput>						
						</td>
						<td>
							<input type="submit" name="Filtrar" value="Filtrar">
						</td>
						<td>
							<input type="button" name="Limpiar" value="Limpiar" onClick="document.filtro.fMEDfecha.value='';document.filtro.fMEDmoneda.value='';document.filtro.fMEDproyecto.value='';">
						</td>
					</tr>
				</table>	
			</td></tr>
		</table>
		</td></tr>
	</form>
	
	<tr><td>
	<table width="100%" cellpadding="5">
		<tr>
			<td align="center">
				<table width="100%"  border="0" cellspacing="0" cellpadding="3" align="center">
				  <tr>
					<td colspan="6"><cfoutput><b>Listado de Donaciones de:&nbsp;#rsEntidad.Pnombre#</br></cfoutput></td>
				  </tr>
				  <tr>
					<td valign="top" class="tituloListas"><strong>Fecha</strong></td>
					<td valign="top" align="right" class="tituloListas"><strong>Importe</strong></td>
					<td valign="top" class="tituloListas"><strong>Moneda</strong></td>
					<!---<td valign="top"><strong>Donante</strong></td>--->
					<td valign="top" class="tituloListas"><strong>Proyecto</strong></td>
					<td class="tituloListas">&nbsp;</td>
				  </tr>
				  <cfif donaciones.RecordCount gt 0>
				  <cfoutput query="donaciones" >
					  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
						<td align="left" nowrap >#LSDateFormat(donaciones.MEDfecha,'dd/mm/yyyy')#</td>
						<td align="right" nowrap >#LSCurrencyFormat(donaciones.MEDimporte,'none')#</td>
						<td align="left" nowrap >#donaciones.MEDmoneda#</td>
						<td align="left" nowrap >#donaciones.MEDnombre#</td>
						<td align="left" width="1%">&nbsp;</td>
					  </tr>
				  </cfoutput>
				  <cfelse>
				  <tr>
					<td colspan="5" align="center"><strong>No hay registros</strong></td>
					<td>&nbsp;</td>
				  </tr>
				  </cfif>
				  <tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<!---<td>&nbsp;</td>--->
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				</table>
			</td>
		</tr>
	</table>
</td></tr>

</td>
</tr>
</table>


</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
