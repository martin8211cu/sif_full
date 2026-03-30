 <cf_htmlreportsheaders
	  title="Retiro de Activos Fijos"  
	  irA="agtProceso_registro.cfm" 
	  filename="Retiro-de-ActivosF#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" 
	  back="no"
	  Download="yes"
	  close="yes"
	  method="url"
	  >

<cfset LvarColSpan = 9>
<cfset cantidad = 0>

<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select 
		Edescripcion,ts_rversion,
		Ecodigo
	from Empresas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery datasource="#session.DSN#" name="rsDatos">
	select 
		AGTPid as LAGTPid, 
		ADTPlinea as LADTPlinea, 
		TAmontolocadq as LTAmontolocadq, 
		TAmontolocmej as LTAmontolocmej, 
		TAmontolocrev as LTAmontolocrev, 
		b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, 
		rtrim(b.Adescripcion) as LAdescripcion, 
		TAmontolocadq + TAmontolocmej + TAmontolocrev as LTAmontoloctot
	from ADTProceso a
	inner join Activos b 
		on a.Aid = b.Aid and 
		a.Ecodigo = b.Ecodigo
	where	a.Ecodigo = #session.Ecodigo# 
	and a.AGTPid = #url.AGTPid#
</cfquery>

 <cfquery name="rsADQ" dbtype="query">
	select sum(LTAmontolocadq) as total_adq from rsDatos
 </cfquery>
 
 <cfquery name="rsMEJ" dbtype="query">
	select sum(LTAmontolocmej) as total_mej from rsDatos
 </cfquery>

 <cfquery name="rsREV" dbtype="query">
	select sum(LTAmontolocrev) as total_rev from rsDatos
 </cfquery>
 
 <cfquery name="rsTOT" dbtype="query">
	select sum(LTAmontoloctot) as total_tot from rsDatos
 </cfquery>


	<cffunction name="fnCantActivos" access="private" output="yes">
		<cfset cantidad = cantidad + 1>
	</cffunction>

<table width="100%" cellpadding="0" cellspacing="1" border="0">	
	<cfoutput>
		<tr>
			<td width="14%">
			  <cfinvoke
				 component="sif.Componentes.DButils"
				 method="toTimeStamp"
				 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> </cfinvoke>
				<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" alt="logo" width="190" height="110" border="0" class="iconoEmpresa"/>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
			<cfloop query="rsDatos">
				<cfset fnCantActivos()>
		   </cfloop>

		<tr align="center">
			<td style="font-size:18px" colspan="#LvarColSpan#" class="tituloListas">
			<strong>Retiro de Activos Fijos</strong>
			</td>
		</tr>
	  <tr align="center">
			<td align="center" colspan="#LvarColSpan#" class="tituloListas">
				 <strong>Cantidad de Activos a Retirar:(#cantidad#)</strong>
			</td>
	  </tr>
		<tr align="center">
			<td align="right" style="width:1%" colspan="#LvarColSpan#" class="tituloListas">
				<strong>Usuario:#session.usulogin#</strong>
			</td>
		</tr>
	
		<tr align="center">
			<td align="right" colspan="#LvarColSpan#" class="tituloListas">
				<strong>Fecha:#Fecha#</strong>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</cfoutput>
	<cfoutput>
		<tr>
			<td colspan="#LvarColSpan#" class="tituloAlterno"></td>
		</tr>			
		<tr class="tituloListas">
			<td nowrap="nowrap" width="10%"><strong><font size="4">Placa</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="4">Descripci&oacute;n</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="4">ADQ</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="4">MEJ</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="4">REV</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="4">TOT</font></strong>&nbsp;</td>
		</tr>
		<cfloop query="rsDatos">
		<tr class="<cfif rsDatos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap="nowrap" width="10%">&nbsp;<font size="2">#LAplaca#</font></td>
			<td nowrap="nowrap" width="10%">&nbsp;<font size="2">#LAdescripcion#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LSNumberFormat(LTAmontolocadq,",0.00")#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LSNumberFormat(LTAmontolocmej,",0.00")#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LSNumberFormat(LTAmontolocrev,",0.00")#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LSNumberFormat(LTAmontoloctot,",0.00")#</font></td>
		 </tr>	
		</cfloop>
		<tr class="<cfif rsDatos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap="nowrap" width="10%">&nbsp;<font size="2"></font></td>
			<td nowrap="nowrap" width="10%">&nbsp;<font size="2"></font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2"><strong>#LSNumberFormat(rsADQ.total_adq,",0.00")#</strong></font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2"><strong>#LSNumberFormat(rsMEJ.total_mej,",0.00")#</strong></font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2"><strong>#LSNumberFormat(rsREV.total_rev,",0.00")#</strong></font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2"><strong>#LSNumberFormat(rsTOT.total_tot,",0.00")#</strong></font></td>
		 </tr>	
	</cfoutput>
		<tr><td align="center" nowrap="nowrap" colspan="9">***Fin de Linea***</td></tr>
</table>
