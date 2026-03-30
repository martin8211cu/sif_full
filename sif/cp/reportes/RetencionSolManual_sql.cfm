<cf_htmlReportsHeaders 
	irA="RetencionSolManual.cfm"
	FileName="Reporte-Retencion-Manual.xls"
	title="Reporte Retención Manual">
	<cfif not isdefined("form.btnDownload")>  
	<cf_templatecss>
	</cfif>

<cfset LvarColSpan = 9>
<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select 
		Edescripcion,ts_rversion,
		Ecodigo
	from Empresas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery datasource="#session.DSN#" name="rsDatos">
	Select 
		<cf_dbfunction name="date_part" args="yyyy,b.TESDPfechaPago"> as LvarPeriodo,
		
       case <cf_dbfunction name="date_part" args="mm,b.TESDPfechaPago">
	      when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end as LvarMes,
		d.TESAPnumero as Acuerdo,
		d.TASAPfecha as FechaAcuerdo, 
		a.TESSPid, 
		a.TESSPnumero as SolicitudPago,
		a.TESBid as IDBeneficiario,
		c.TESBeneficiario as Beneficiario, 
		TESSPfechaPagar as FechaPago, 
		b.TESDPdescripcion as Descripcion, 
		b.TESDPmontoSolicitadoOri as Monto
	from TESsolicitudPago a
	inner join TESdetallePago  b
		on a.TESSPid = b.TESSPid
	inner join TESbeneficiario c 
		on a.TESBid = c.TESBid
	left outer join TESacuerdoPago d
		on a.TESAPid = d.TESAPid 
	where TESSPtipoDocumento  in (0, 5)
		and b.TESDPmoduloOri = 'TESP'
		and a.TESSPestado = 12
		and b.TESDPmontoSolicitadoOri < 0
	<cfif isdefined("form.Periodofin") and len(trim(form.Periodofin)) and (#form.Periodofin# neq 0) and not isdefined ("form.Periodoini")>
			and <cf_dbfunction name="date_part" args="yyyy,b.TESDPfechaPago"> <= #form.Periodofin#
			
	<cfelseif isdefined("form.Periodoini") and len(trim(form.Periodoini))and #form.Periodoini# neq 0  and not isdefined ("form.Periodofin")>
			and <cf_dbfunction name="date_part" args="yyyy,b.TESDPfechaPago"> >= #form.Periodoini#
			
	<cfelseif isdefined("form.Periodoini") and len(trim(form.Periodoini)) and #form.Periodoini# neq 0 and isdefined("form.Periodofin") and len(trim(form.Periodofin)) and #form.Periodofin# neq 0>
		  and <cf_dbfunction name="date_part" args="yyyy,b.TESDPfechaPago"> between #form.Periodoini# and #form.Periodofin#	
	</cfif> 
	
	<cfif isdefined("form.Mesfin") and len(trim(form.Mesfin)) and (#form.Mesfin# neq 0) and not isdefined ("form.Mesini")>
			and <cf_dbfunction name="date_part" args="mm,b.TESDPfechaPago"> <= #form.Mesfin#
			
	<cfelseif isdefined("form.Mesini") and len(trim(form.Mesini)) and (#form.Mesini# neq 0) and not isdefined ("form.Mesfin")>
			and <cf_dbfunction name="date_part" args="mm,b.TESDPfechaPago"> >= #form.Mesini#
			
	<cfelseif isdefined("form.Mesini") and len(trim(form.Mesini)) and (#form.Mesini# neq 0) and isdefined("form.Mesfin") and len(trim(form.Mesfin)) and (#form.Mesfin# neq 0)>
		  and <cf_dbfunction name="date_part" args="mm,b.TESDPfechaPago"> between #form.Mesini# and #form.Mesfin#	
	</cfif> 
</cfquery>

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
	
		<tr align="center">
			<td style="font-size:18px" colspan="#LvarColSpan#" class="tituloListas">
			<strong>Retención de Solicitud Manual</strong>
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
	</cfoutput>
	<cfoutput>
		<tr>
			<td colspan="#LvarColSpan#" class="tituloAlterno"></td>
		</tr>			
		<tr class="tituloListas">
			<td nowrap="nowrap" width="10%"><strong><font size="2">Acuerdo</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Fecha Acuerdo</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Solicitud de Pago</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Beneficiario</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Fecha Pago</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Descripción</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Monto</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Período</font></strong>&nbsp;</td>
			<td nowrap="nowrap" width="10%"><strong><font size="2">Mes</font></strong>&nbsp;</td>
		</tr>
		<cfloop query="rsDatos">
		<tr class="<cfif rsDatos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap="nowrap" width="10%">&nbsp;<font size="2">#Acuerdo#</font></td>
			<td nowrap="nowrap" width="10%">&nbsp;<font size="2">#FechaAcuerdo#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#SolicitudPago#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Beneficiario#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#FechaPago#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Descripcion#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Monto#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LvarPeriodo#</font></td>
			<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LvarMes#</font></td>
		 </tr>	
		</cfloop>
	</cfoutput>
		<tr><td align="center" nowrap="nowrap" colspan="9">***Fin de Linea***</td></tr>
</table>
