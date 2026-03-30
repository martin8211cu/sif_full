<cfif isdefined('form.btnConsultar')>
	<cfquery name="rsMovimientos" datasource="#session.DSN#">
		Select ea.EMAid
			, ea.EMAfecha
			, ea.Ocodigo
			, o.Odescripcion
			, ea.EMAestado
		from EMAlmacen ea
			inner join Oficinas o
				on o.Ecodigo=ea.Ecodigo
					and o.Ocodigo=ea.Ocodigo
		
		where ea.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined('form.EMAfecha') and form.EMAfecha NEQ ''>
				and ea.EMAfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EMAfecha)#">								
			</cfif>
			<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
				and ea.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">								
			</cfif>			
		order by EMAfecha,Odescripcion
	</cfquery>
</cfif>
<style type="text/css">
<!--
.style1 {color: #0000CC}
.style3 {color: #996600}
.style4 {color: #6699CC}
-->
</style>

<cf_templatecss>
<form name="form_fSalidas" method="post" action="">
  <table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		  <td width="10%" align="right">
			<strong>Estaci&oacute;n</strong>:</td>
		  <td width="35%">
		  	<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo" id="#form.f_Ocodigo#">
			<cfelse>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo">
			</cfif>
		  </td>
		  <td width="17%" rowspan="2" align="center" valign="middle">
		  	<input type="submit" align="middle" name="btnConsultar" value="Consultar">			
		  </td>
	</tr>
		<tr>
		  <td align="right"><strong>A partir de</strong>:</td>
		  <td>
			<cfif isdefined("form.EMAfecha") and len(trim(form.EMAfecha))>
				<cf_sifcalendario form="form_fSalidas" name="EMAfecha" value="#form.EMAfecha#">
			<cfelse>
				<cf_sifcalendario form="form_fSalidas" name="EMAfecha">
			</cfif>			  
		  </td>
	  </tr>
		<cfif isdefined('rsMovimientos') and rsMovimientos.recordCount GT 0>
		  <tr>
			  <td colspan="3">&nbsp;</td>
		  </tr>
		  <tr>
			  <td colspan="3"><hr></td>
		  </tr>
		</cfif>
  </table>
</form>
	
<cfset vFecha = "">	
<cfif isdefined('rsMovimientos') and rsMovimientos.recordCount GT 0>
	<table width="90%"  cellpadding="0" cellspacing="0" border="0">
	  <tr>
		<td colspan="3" align="center" class="tituloListas">Lista de Estaciones con Movimientos de  Mercanc&iacute;as<hr></td>
	  </tr>
		<cfoutput query="rsMovimientos">
			<cfset params="?1=1">
			<cfif isdefined('form.f_Ocodigo') and len(trim(form.f_Ocodigo))>
				<cfset params=params & "&Ocodigo=#form.f_Ocodigo#">
			</cfif>
			<cfif isdefined('form.EMAfecha') and len(trim(form.EMAfecha))>
				<cfset params=params & "&EMAfecha=#form.EMAfecha#">
			</cfif>
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<cfif vFecha NEQ rsMovimientos.EMAfecha>
				<cfset vFecha = rsMovimientos.EMAfecha>	
				<tr class="tituloListas">
					<td colspan="3">
						<strong>
							#DayofWeekAsString(DayOfWeek(rsMovimientos.EMAfecha))# #Day(rsMovimientos.EMAfecha)# de #MonthAsString(Month(rsMovimientos.EMAfecha))# del #Year(rsMovimientos.EMAfecha)# 						
						</strong>
					</td>
				</tr>	  
			</cfif>				
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">		
				<td width="8%">&nbsp;</td>
				<td colspan="2">
					<strong>
						<cfif rsMovimientos.EMAestado EQ 0>
							<a href="movAlmacen-Mant.cfm#params#&EMAid=#rsMovimientos.EMAid#">
								(#rsMovimientos.Ocodigo#)-#rsMovimientos.Odescripcion#, <span class="style3"> en proceso</span>			  
							</a>	
						<cfelseif rsMovimientos.EMAestado EQ 10>			
							<a href="movAlmacen-Mant.cfm#params#&EMAid=#rsMovimientos.EMAid#">
								(#rsMovimientos.Ocodigo#)-#rsMovimientos.Odescripcion#, <span class="style4">aplicada (solo consulta)</span>
							</a>	
						</cfif>
					</strong>
				</td>
			</tr>			
		</cfoutput>	  
	</table>
</cfif>