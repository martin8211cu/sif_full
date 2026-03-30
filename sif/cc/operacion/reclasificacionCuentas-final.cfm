<!--- ====================================================================================================================== --->
<!--- ====================================================================================================================== --->
<!--- PANTALLA INDICANDO FIN DEL PROCESO --->
<cf_templateheader template="#session.sitio.template#" title="Reclasificaci&oacute;n de Cuentas">

<cfquery name="socio" datasource="#session.DSN#">
	select SNnumero, SNnombre
	from SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
</cfquery>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo, 
			case when coalesce(a.CCTvencim,0) < 0 then substring(a.CCTdescripcion,1,10) #_Cat# ' (contado)' else substring(a.CCTdescripcion,1,20) end as CCTdescripcion,
			case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end as CCTorden,
			a.CCTtipo
	 from CCTransacciones a
	 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	   and a.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="D"><!--- 'D' --->
	   and coalesce(a.CCTpago,0) != 1
	   and NOT upper(a.CCTdescripcion) like '%TESORER_A%'
	   and CCTtranneteo = 0
	order by case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end, CCTcodigo
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select a.Ecodigo, 
		  a.SNcodigo, 
		  a.Cuenta_Anterior, 
		   ( select min(cc1.Cformato)
			 from CContables cc1
			 where cc1.Ecodigo=a.Ecodigo
				 and cc1.Ccuenta=a.Cuenta_Anterior ) as cuentaantformato,
		   ( select min(cc2.Cformato)
			 from CContables cc2
			 where cc2.Ecodigo=a.Ecodigo
				 and cc2.Ccuenta=a.Cuenta_Nueva ) as cuentanuevaformato,
		  a.Cuenta_Nueva, count(1) as total
	from RCBitacora a
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RCBestado=0
	and a.SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
	group by a.Ecodigo,a.SNcodigo, a.Cuenta_Anterior, a.Cuenta_Nueva
</cfquery>

<cfoutput>
<table width="100%" align="center" cellpadding="3" cellspacing="0" >
	<tr><td align="center" class="menutitulo"><strong>Proceso de Reclasificaci&oacute;n de Cuentas</strong></td></tr>
	<tr><td align="center" class="menutitulo"><strong>Socio de Negocios:&nbsp;</strong>#socio.SNnumero#-#socio.SNnombre#</td></tr>
	
	<cfif isdefined("url.filtrar_por") and url.filtrar_por eq 'T'>
		<tr>
			<td>
				<table width="60%" cellpadding="2" cellspacing="0" border="0" align="center">
					<cfset vDireccion = 'Todas' >
					<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion))>
						<cfquery datasource="#session.dsn#" name="direcciones">
							select c.direccion1 #_Cat# ' / ' #_Cat# c.direccion2 as texto_direccion
							from DireccionesSIF c
							where c.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_direccion#"> 
						</cfquery>
						<cfset vDireccion = direcciones.texto_direccion >
					</cfif>
					<tr>
						<td width="50%" align="center"><strong>Direcci&oacute;n:&nbsp;</strong>#vDireccion#</td>
						<cfif isdefined("url.antiguedad") and len(trim(url.antiguedad))>
							<td width="50%" align="center"><strong>Antiguedad:&nbsp;</strong>#url.antiguedad#</td>
						<cfelse>
							<td width="50%" align="center"><strong>Antiguedad:&nbsp;</strong>Todas</td>
						</cfif>
					</tr>
					
					<cfset vOficina = 'Todas' >
					<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
						<cfquery datasource="#session.dsn#" name="oficina">
							select Ocodigo, Odescripcion
							from Oficinas o
							where o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
							and o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
						<cfset vOficina = oficina.Odescripcion >
					</cfif>
					<cfset vTransaccion = 'Todas' >	
					<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
						<cfquery name="transaccion" datasource="#session.DSN#">
							select CCTdescripcion
							from CCTransacciones
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
						</cfquery>
						<cfset vTransaccion = transaccion.CCTdescripcion >	
					</cfif>
					<tr>
						<td align="center"><strong>Oficina:&nbsp;</strong>#vOficina#</td>
						<td align="center"><strong>Transacci&oacute;n:&nbsp;</strong>#vTransaccion#</td>
					</tr>		
				</table>
			</td>
		</tr>
	<cfelseif isdefined("url.filtrar_por") and url.filtrar_por eq 'D' >
		<tr><td align="center"><strong>Documento:&nbsp;</strong>#url.Ddocumento#</td></tr>		
	</cfif>
</table>
</cfoutput>
<br>
<table width="100%" align="center" cellpadding="2" cellspacing="0" >
	<tr ><td colspan="4" align="center">El proceso de Reclasificaci&oacute;n  de Cuentas se ejecuto existosamente.</td></tr>
	<tr ><td colspan="4" align="center">&nbsp;</td></tr>

	<tr>
	<td colspan="5" align="center">
	<input type="button" class="btnAnterior" name="btnAnterior" value="Terminar" onclick="javascript:location.href='ReclasificacionCuenta.cfm';" />
	</td>
	</tr>
</table>
<cf_templatefooter template="#session.sitio.template#">