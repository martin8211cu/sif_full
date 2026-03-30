<cf_htmlReportsHeaders 
	irA="CFReporte.cfm"
	FileName="CentroFuncionales.xls"
	title="Reporte Centro Funcional">	
	<cfif not isdefined('form.btnDownload')>
                <cf_templatecss>
    </cfif>
<cfquery name="rsReporte" datasource="#session.dsn#">
	select 
			bt.CFid,
			bt.AFBDperiodo,
			bt.AFBDmes,
			cf.CFcodigo,
			cf.Ecodigo,
			cf.Dcodigo,
			cf.Ocodigo,
			cf.CFdescripcion,
			cf.CFidresp,
			cf.CFcuentac,
			cf.CFcuentaaf,
			cf.CFcuentainversion,
			cf.CFcuentainventario,
			cf.CFcuentaingreso,
			cf.CFcuentagastoretaf,
			cf.CFcuentaingresoretaf,
			o.Odescripcion,
			d.Ddescripcion
	from AFBDepartamentos bt
		inner join CFuncional cf
			inner join Oficinas o
				on o.Ecodigo=cf.Ecodigo
				and o.Ocodigo=cf.Ocodigo
			<cfif isdefined('form.OficinaIni') and len(trim(#form.OficinaIni#)) gt 0 and not isdefined('form.OficinaFin')and len(trim(#form.OficinaFin#)) eq 0 >
				and Oficodigo >= '#form.OficinaIni#'			
			</cfif>
			<cfif isdefined('form.OficinaFin') and len(trim(#form.OficinaFin#)) gt 0 and not isdefined('form.OficinaIni') and len(trim(#form.OficinaIni#)) eq 0>
				and Oficodigo <= '#form.OficinaFin#'			
			</cfif>
			<cfif isdefined('form.OficinaIni') and len(trim(#form.OficinaIni#)) gt 0 and  isdefined('form.OficinaFin')and len(trim(#form.OficinaFin#)) gt 0 >
				and Oficodigo between '#form.OficinaIni#' and '#form.OficinaFin#'
			</cfif>
			inner join Departamentos d
				on d.Ecodigo=cf.Ecodigo
				and d.Dcodigo=cf.Dcodigo
			<cfif isdefined('form.DepaIni') and len(trim(#form.DepaIni#)) gt 0 and not isdefined('form.DepaFin')and len(trim(#form.DepaFin#)) eq 0 >
				and Deptocodigo >= '#form.DepaIni#'			
			</cfif>
			<cfif isdefined('form.DepaFin') and len(trim(#form.DepaFin#)) gt 0 and not isdefined('form.DepaIni') and len(trim(#form.DepaIni#)) eq 0>
				and Deptocodigo <= '#form.DepaFin#'			
			</cfif>
			<cfif isdefined('form.DepaIni') and len(trim(#form.DepaIni#)) gt 0 and  isdefined('form.DepaFin')and len(trim(#form.DepaFin#)) gt 0 >
				and Deptocodigo between '#form.DepaIni#' and '#form.DepaFin#'
			</cfif>
		on cf.CFid=bt.CFid
	<cfif isdefined('form.CFcodigorespIni') and len(trim(#form.CFcodigorespIni#)) gt 0 and not isdefined('form.CFcodigorespIni')and len(trim(#form.CFcodigorespIni#)) eq 0 >
		and cf.CFcodigo >= '#form.CFcodigorespIni#'			
	</cfif>
	<cfif isdefined('form.CFcodigorespFin') and len(trim(#form.CFcodigorespFin#)) gt 0 and not isdefined('form.CFcodigorespIni') and len(trim(#form.CFcodigorespFin#)) eq 0>
		and cf.CFcodigo <= '#form.CFcodigorespFin#'			
	</cfif>
	<cfif isdefined('form.CFcodigorespIni') and len(trim(#form.CFcodigorespIni#)) gt 0 and  isdefined('form.CFcodigorespFin')and len(trim(#form.CFcodigorespFin#)) gt 0 >
		and cf.CFcodigo between '#form.CFcodigorespIni#' and '#form.CFcodigorespFin#'
	</cfif>
	where bt.Ecodigo=#session.Ecodigo#
	<!---concatena año-mes del filtro(200801) para ver cuales centros Funcioales estaba vigentes a esa fecha en la bitacora--->
	and   (<cfqueryparam cfsqltype="cf_sql_integer"value="#form.Periodo#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">)
		between bt.AFBDpermesdesde and AFBDpermeshasta 
</cfquery>

<cfif rsReporte.CFidresp NEQ ''>
	<cfquery name="rsResponsable" datasource="#session.dsn#">
		select CFcodigo, CFdescripcion from CFuncional
		where CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.CFidresp#">
	</cfquery>
</cfif>
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #session.Ecodigo#
</cfquery>
<cfif isdefined ('form.btnExportar')>
	<cf_exportQueryToFile query="#rsReporte#" separador="#chr(9)#" filename="Reporte_De_CentroFuncional_#session.Usucodigo#_#LSDateFormat(Now(),'ddmmyyyy')#_#LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="false">
<cfelse>
	<cfflush interval="64">
	<style type="text/css">
	<!--
	.style2 {font-size: 12px}
	-->
	</style>
	
	
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
					Reporte Centros Funcionales
				</td>
				<td align="right" style="width:1%">
					<strong>Usuario: #session.usulogin#</strong>
				</td>
			</tr>
			<tr bgcolor="BBBBBB" nowrap="nowrap"  align="center">
				<td colspan="5" align="center" style="font-size:18px">
					
				</td>
			</tr>
			<tr bgcolor="BBBBBB" nowrap="nowrap"  align="center">
				<td colspan="5" align="center" style="font-size:18px">&nbsp;
					
				</td>
			</tr>
		</cfoutput>
		</table>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">	
		<cfoutput query="rsReporte" group="CFcodigo">
			<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
				<td width="11%"  align="left" nowrap="nowrap">Código</td>
				<td width="15%"  align="left" nowrap="nowrap" >Desc.CFuncional</td>
				<td width="18%"  align="left" nowrap="nowrap" >Oficina</td>
				<td width="18%"  align="left" nowrap="nowrap" >Depto</td>
				<td width="18%"  align="left" nowrap="nowrap" >Centro Responsable</td>
			<cfif isdefined ('form.gast')> 
				<td width="15%"  align="left" nowrap="nowrap" >Cuenta Gasto</td>
			</cfif>
			</tr>
			<tr>
				<td height="26" align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcodigo#</span></td>
				<td align="left" style="font-size:9px;"><span class="style2">#rsReporte.CFdescripcion#</span></td>
				<td align="left" style="font-size:9px;"><span class="style2">#rsReporte.Odescripcion#</span></td>
				<td align="left" style="font-size:9px;"><span class="style2">#rsReporte.Ddescripcion#</span></td>
				<td align="left" style="font-size:9px"><span class="style2">#rsResponsable.CFdescripcion#</span></td>
			<cfif  isdefined ('form.gast')>
				<td align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcuentac#</span></td>
			</cfif>
			</tr>
		<cfif  isdefined ('form.inven') or isdefined ('form.inver') or isdefined ('form.act') or isdefined ('form.ingr') or isdefined ('form.Otrosingr') or isdefined ('form.Otrosgast')>
				<cfif isdefined ('form.inven')> 
					<tr>	
						<td><span class="style2"></span></td>
						<td colspan="2" width="15%"  align="left" nowrap="nowrap" ><span class="style2">Cuenta Inventario</span></td>
						<td colspan="2" align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcuentainventario#</span></td>
					</tr>
				</cfif>
				<cfif isdefined ('form.inver')> 
					<tr>				
						<td><span class="style2"></span></td>
						<td colspan="2" width="15%"  align="left" nowrap="nowrap" ><span class="style2">Cuenta Inversión</span></td>
						<td colspan="2" align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcuentainversion#</span></td>
					</tr>
				</cfif>
				<cfif isdefined ('form.act')> 
					<tr>				
						<td><span class="style2"></span></td>
						<td colspan="2" width="15%"  align="left" nowrap="nowrap" ><span class="style2">Cuenta Activo</span></td>
						<td colspan="2" align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcuentaaf#</span></td>
					</tr>
				</cfif>
				<cfif isdefined ('form.ingr')> 
					<tr>				
						<td><span class="style2"></span></td>
						<td colspan="2" width="15%"  align="left" nowrap="nowrap" ><span class="style2">Cuenta Ingreso</span></td>
						<td colspan="2" align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcuentaingreso#</span></td>
					</tr>
				</cfif>
				<cfif isdefined ('form.Otrosingr')> 
					<tr>				
						<td><span class="style2"></span></td>
						<td colspan="2" width="15%"  align="left" nowrap="nowrap" ><span class="style2">Cuenta Otros Ingr.</span></td>
						<td colspan="2" align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcuentaingresoretaf#</span></td>
					</tr>
				</cfif>
				<cfif isdefined ('form.Otrosgast')> 
					<tr>				
						<td><span class="style2"></span></td>
						<td colspan="2" width="15%"  align="left" nowrap="nowrap" ><span class="style2">Cuenta Otros Gasto</span></td>
						<td colspan="2" align="left" nowrap="nowrap"><span class="style2">#rsReporte.CFcuentagastoretaf#</span></td>
					</tr>
				</cfif>
		</cfif>
	</cfoutput>
				<tr><td align="center" nowrap="nowrap" colspan="5"><p>&nbsp;</p>
				  <p>***Fin de Linea***</p></td></tr>
	</table>
</cfif>
