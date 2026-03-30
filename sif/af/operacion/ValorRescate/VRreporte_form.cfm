<cfif not isdefined('form.btnDownload')>
                <cf_templatecss>
</cfif>
<cf_htmlReportsHeaders 
	irA="ValorRescate.cfm?AFTRid=#form.AFTRid#"
	FileName="Valor Rescate.xls"
	title="Reporte Cambio Activo Fijo">

<cfquery name="rsReporte" datasource="#session.dsn#">

	select 
		a.AFTRid,
		a.AFTRdescripcion,
			(
				select c.Aplaca 
				from Activos c
				where c.Aid = b.Aid
			) as Placa,
		b.Avalrescate,
		b.AFTDvalrescate,
		b.Adescripcion,
		b.Afechainidep,
		b.AFTDfechainidep,
		b.AFTDdescripcion,
		case 
			when a.AFTRtipo = 1 then 'Cambio Valor de Rescate'
			when a.AFTRtipo = 2 then 'Cambio Descripción'
			when a.AFTRtipo = 3 then 'Todos'
			when a.AFTRtipo = 3 then 'Fecha Inicio Depreciación'
			
		end
		 as AFTRtipo,
		 a.AFTRtipo as tipo
	from AFTRelacionCambio a
		inner join AFTRelacionCambioD b
		on a.AFTRtipo = #form.AFTRtipo#
		and b.AFTRid = a.AFTRid
	where a.AFTRid = #form.AFTRid#
	and b.Ecodigo = #session.Ecodigo#
	and AFTRaplicado = 0
	order by a.AFTRid
</cfquery> 

<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #session.Ecodigo#
</cfquery>


<cfset LvarTipo=rsReporte.tipo>

<cfflush interval="64">

	<table width="100%" cellpadding="2" cellspacing="0" border="0">	
	<cfoutput>
		<tr align="center" bgcolor="BBBBBB">
			<td align="left" style="width:1%">&nbsp;
				
			</td>
			<td  style="font-size:24px" colspan="3">
				#rsEmpresa.Edescripcion#
			</td>
			<td align="left" style="width:1%">&nbsp;
				
			</td>
		</tr>
		<tr align="center" bgcolor="BBBBBB">
			<td align="left" style="width:1%">
				<strong>#dateFormat(now(),'dd/mm/yyyy')#</strong>
			</td>
			<td align="center"  style="font-size:20px" colspan="3">
				Reporte Cambio Activo Fijo
			</td>
			<td align="right" style="width:1%">
				<strong>Usuario: #session.usulogin#</strong>
			</td>
		</tr>
		<tr bgcolor="BBBBBB" nowrap="nowrap"  align="center">
			<td colspan="5" align="center" style="font-size:18px">
				#rsReporte.AFTRdescripcion#, Tipo:&nbsp;#rsReporte.AFTRtipo#
			</td>
		</tr>
		<tr bgcolor="BBBBBB" nowrap="nowrap"  align="center">
			<td colspan="5" align="center" style="font-size:18px">&nbsp;
				
			</td>
		</tr>
	</cfoutput>
	</table>
	<table width="100%" cellpadding="2" cellspacing="0" border="0">	
	<cfoutput query="rsReporte" group="AFTRid">
		<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
			<td width="11%"  align="left" nowrap="nowrap">Placa</td>
			<td width="15%"  align="left" nowrap="nowrap" >Descripción</td>
			<td width="18%"  align="left" nowrap="nowrap" >Fecha Inicio Deprecioción</td>
			<cfif LvarTipo eq 2 or LvarTipo eq 3> 
				<td width="15%"  align="left" nowrap="nowrap" > Nueva Descripción</td>
			</cfif>
			<cfif LvarTipo eq 1 or LvarTipo eq 3>
				<td width="17%"  align="right" nowrap="nowrap">Val. Res. Ant.</td>
				<td width="24%"  align="right" nowrap="nowrap">Val. Res. N.</td>
			</cfif>
			<cfif LvarTipo eq 4>
				<td width="17%"  align="right" nowrap="nowrap">Fecha Ant.</td>
				<td width="24%"  align="right" nowrap="nowrap">Fecha Nueva.</td>
			</cfif>
		</tr>
		
		<cfoutput>
			<tr  class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td height="26" align="left" style="font-size:9px">#rsReporte.Placa#</td>
				<td align="left" style="font-size:9px;">#rsReporte.Adescripcion#</td>
				<td align="left" style="font-size:9px;">#LSDateFormat(rsReporte.Afechainidep,"DD/MM/YYYY")#</td>
				<cfif LvarTipo eq 2 or LvarTipo eq 3>
					<td  align="left" style="font-size:9px" >#rsReporte.AFTDdescripcion#</td>
				</cfif>
				<cfif LvarTipo eq 1 or LvarTipo eq 3>
					<td align="right" style="font-size:9px; ">#numberformat(rsReporte.Avalrescate, ',_.__')#</td>
					<td align="right" style="font-size:9px">#numberformat(rsReporte.AFTDvalrescate, ',_.__')#</td>	
				</cfif>
				<cfif LvarTipo eq 4>
					<td align="right" style="font-size:9px; ">#LSDateFormat(rsReporte.Afechainidep,"DD/MM/YYYY")#</td>
					<td align="right" style="font-size:9px">#LSDateFormat(rsReporte.AFTDfechainidep,"DD/MM/YYYY")#</td>
				</cfif>
			</tr>
		</cfoutput>
	</cfoutput>
			<tr><td align="center" nowrap="nowrap" colspan="5"><p>&nbsp;</p>
			  <p>***Fin de Linea***</p></td></tr>
</table>