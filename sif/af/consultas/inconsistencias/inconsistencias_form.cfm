<cf_htmlReportsHeaders 
	irA="inconsistencias.cfm"
	FileName="Inconsistencias.xls"
	title="Reporte de Inconsistencias">
<cfif not isdefined('form.btnDownload')>
	<cf_templatecss>
</cfif>    
<cfflush interval="64">
<cfsetting requesttimeout="3600">
<cfquery name="rsSQL" datasource="#session.dsn#">
	select
		 a.ACid 
		 ,(select ACdescripcion from AClasificacion where Ecodigo=#session.Ecodigo# and ACid=a.ACid and ACcodigo=a.ACcodigo) as clase
		,a.Aplaca as placa
		,a.Adescripcion as descripcion
		,s.CFid as CF
		,(select CFdescripcion from CFuncional where CFid=s.CFid) as centro
		,s.AFSsaldovutiladq as saldovu
		,a.Afechaaltaadq as fechaadq
		,s.AFSvaladq as valadq
		,s.AFSvalmej as valmej
		,s.AFSvalrev as valrev
		,s.AFSdepacumadq as depadq
		,s.AFSdepacummej as depmej
		,s.AFSdepacumrev as deprev
		,a.Avalrescate as vr
		,a.Avutil as vu
		,a.Aid
		,a.ACcodigo as codigo
		,a.Astatus as estado
		<cfif isdefined ('form.ACcodigo') and LEN(TRIM(form.ACcodigo)) gt 0 or isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde)) gt 0 or isdefined ('form.codigohasta') and len(trim(form.codigohasta)) gt 0>		
		,clas.ACvutil as VidaUC
	    </cfif>
		,s.Aid, s.AFSdepreciable
		
				<!---Inconsistencia--->
				<!---Depreciacion---> 
				
				<cfif isdefined('form.adq')>
				<!---Adquisicion--->		
					, case when
						(
							s.AFSvaladq = 0
						) 
						then '1'
					end  as I1
				</cfif>	
				<cfif isdefined ('form.dep')>
					, case when
						(
							s.AFSdepreciable = 1  
							and s.AFSsaldovutiladq > 0
							and (
								select count(1) from TransaccionesActivos tr where tr.Ecodigo = s.Ecodigo and  tr.TAperiodo = s.AFSperiodo and tr.TAmes = s.AFSmes and tr.IDtrans = 4 and tr.Aid = s.Aid
								) = 0
						)
						then '2'
					end as I2
				</cfif>
				<cfif isdefined ('form.val')>
				<!---Revaluación--->				
					, case when
						(
							s.AFSvalrev > 0
							and (
								select count(1) from AClasificacion cl where cl.Ecodigo = s.Ecodigo and cl.ACid = s.ACid and cl.ACcodigo = s.ACcodigo and cl.ACrevalua = 'N'
								) > 0
				
						)
						then '3'
					end as I3
				</cfif>
				<cfif isdefined ('form.mej')>
				<!---Mejoras--->			
					, case when s.AFSvaladq < s.AFSdepacumadq
						then '4'
					end as I4
					, case when s.AFSvalmej < s.AFSdepacummej
						then '5'
					end as I5
					, case when s.AFSvalrev < s.AFSdepacumrev
						then '6'
					end as I6
				</cfif>
				<!---PlacasRepetidas--->
				<cfif isdefined('form.rep') >
					, case when 
				   (( select count(1) from Activos ad where ad.Aplaca = a.Aplaca and ad.Ecodigo = a.Ecodigo )) > 1
						then '7'
					end as I7
				</cfif>
				<!---ActivosenTránsito--->
				<cfif isdefined('form.tran') >
				, case when 
				(( select count(1) from CRDocumentoResponsabilidad dr where dr.CRDRplaca = a.Aplaca and dr.Ecodigo = a.Ecodigo ))	> 0
					then '8'
					end as I8
				</cfif>
				<!---Vudiferentecategoria/clase--->
				<cfif (isdefined ('form.vu') and isdefined ('form.ACcodigo') and LEN(TRIM(form.ACcodigo)) gt 0) or (isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde))  gt 0 and isdefined ('form.vu'))or (isdefined ('form.codigohasta') and len(trim(form.codigohasta)) gt 0 and isdefined ('form.vu'))>
				, case when 
					(a.Avutil - clas.ACvutil) != 0
					then '9'
					end as I9
				</cfif>
				
				<!---Fechas inconsistentes--->
				<cfif isdefined('form.finc') >
				, case when 
				((select count(1) from AFResponsables r1 where r1.Aid=a.Aid and r1.AFRfini > r1.AFRffin))>0
					then 'I10'
					end as I10
				</cfif>
				
				<!---Fechas traslapadas--->
				<cfif isdefined('form.vales') >
				, case when 
				((select count(1)
					from AFResponsables r1
								inner join AFResponsables r2
								on r1.Aid = r2.Aid and r1.AFRid<>r2.AFRid
								and (r1.AFRfini between r2.AFRfini AND r2.AFRffin 
								OR r1.AFRffin between r2.AFRfini AND r2.AFRfini)
					where r1.Aid=a.Aid
					and (
					r1.AFRfini between r2.AFRfini AND r2.AFRffin 
							OR 
					r1.AFRffin between r2.AFRfini AND r2.AFRfini)))>0
					then 'I11'
					end as I11
				</cfif>
				<!---Activos sin documento de Responsabilidad(Vale)--->
				<cfif isdefined('form.sinvale') >
				,case when (select count(1) 
				   			 from AFResponsables I12
				 			where I12.Aid = a.Aid 
				   			  and <cf_dbfunction name="now"> between I12.AFRfini and I12.AFRffin
							) = 0 then 'I12' end as I12
				</cfif>
			from AFSaldos s
				inner join Activos a
				on a.Aid = s.Aid
				and a.Ecodigo=s.Ecodigo
				
			<!---Filtro de Clasificaciones/clases--->		
				<cfif isdefined ('form.ACcodigo') and LEN(TRIM(form.ACcodigo)) gt 0 or isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde)) gt 0 or isdefined ('form.codigohasta') and len(trim(form.codigohasta)) gt 0>				
					inner join AClasificacion clas
					on clas.ACcodigo=a.ACcodigo
					and clas.Ecodigo=a.Ecodigo
					and clas.ACid = a.ACid
					
					<cfif isdefined('form.ACcodigo') and LEN(TRIM(form.ACcodigo)) gt 0 and len(trim(form.ACidF)) eq 0  and len(trim(form.ACidI)) eq 0>
					and a.ACcodigo=#form.ACcodigo#
					</cfif>
					
					<cfif isdefined('form.ACidI') and LEN(TRIM(form.ACidI)) gt 0 and len(trim(form.ACidF)) eq 0>
					and a.ACcodigo=#form.ACcodigo#
					and clas.ACid >= #form.ACidI#
					</cfif>
					
					<cfif isdefined('form.ACidI') and LEN(TRIM(form.ACidI)) gt 0 and isdefined ('form.ACidF') and len(trim(form.ACidF)) gt 0>				
    					and a.ACcodigo=#form.ACcodigo#
						and clas.ACid between  #form.ACidI# and #form.ACidF#
					</cfif>
				</cfif>
				
				<cfif isdefined("form.oficinaIni") and Len(Trim(form.oficinaIni)) gt 0 or isdefined("form.oficinaFin") and Len(Trim(form.oficinaFin)) gt 0>
				inner join Oficinas d
						on d.Ecodigo = s.Ecodigo
						and d.Ocodigo = s.Ocodigo
				<cfif isdefined("form.oficinaIni") and Len(Trim(form.oficinaIni)) gt 0>
					and  d.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oficinaIni#">
				</cfif>
				<cfif isdefined("form.oficinaFin") and Len(Trim(form.oficinaFin)) gt 0>
					and  d.Oficodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oficinaFin#">
				</cfif>
				</cfif>	
			where s.Ecodigo = #session.ecodigo# 
			  and s.AFSperiodo =#form.periodo#
			  and s.AFSmes = #form.mes#
			  and a.Astatus != 60
			 <!--- filtros--->
			 
				<cfif isdefined ('form.ACinicio') and len(trim(form.ACinicio)) gt 0 and not isdefined ('form.AChasta')>
					and a.ACcodigo >= #form.codigodesde#
				</cfif>
				<cfif isdefined ('form.ACinicio')  and len(trim(form.ACinicio)) gt 0 and  isdefined ('form.AChasta')  and len(trim(form.AChasta)) gt 0>
				<!---<cf_dump var="1">--->
					and a.ACcodigo between  #form.codigodesde# and #form.codigohasta#
				</cfif>
			  <!---comprobar que no tiene todos los montos en cero--->
			  and 
				(
					s.AFSsaldovutiladq > 0
					or 
					s.AFSvaladq > 0
					or
					s.AFSdepacumadq > 0
					or
					s.AFSvalmej > 0
					or
					s.AFSdepacumadq > 0
					or
					s.AFSvalrev > 0
					or
					s.AFSdepacumrev > 0
				)
				<!---Inconsistencia--->
				<!---Depreciacion---> 
			  and ( 1=2
				<cfif isdefined ('form.dep')>
					or	(
							s.AFSdepreciable = 1  
							and s.AFSsaldovutiladq > 0
							and (
								select count(1) from TransaccionesActivos tr where tr.Ecodigo = s.Ecodigo and  tr.TAperiodo = s.AFSperiodo and tr.TAmes = s.AFSmes and tr.IDtrans = 4 and tr.Aid = s.Aid
								) = 0
						)
				</cfif>
				<cfif isdefined ('form.val')>
				<!---Revaluación--->				
					or
						(
							s.AFSvalrev > 0
							and (
								select count(1) from AClasificacion cl where cl.Ecodigo = s.Ecodigo and cl.ACid = s.ACid and cl.ACcodigo = s.ACcodigo and cl.ACrevalua = 'N'
								) > 0
				
						)
				</cfif>
				<cfif isdefined ('form.mej')>
				<!---Mejoras--->			
					or
						(
							s.AFSvaladq < s.AFSdepacumadq
							or 
							s.AFSvalmej < s.AFSdepacummej
							or
							s.AFSvalrev < s.AFSdepacumrev
						)				
				</cfif>
				<cfif isdefined('form.adq')>
				<!---Adquisicion--->		
					or
						(
							s.AFSvaladq = 0
						) 
				</cfif>							
				<!---Placas repetidas--->
				<cfif isdefined('form.rep') >
				or 
			    ( (( select count(1) from Activos ad where ad.Aplaca = a.Aplaca and ad.Ecodigo = a.Ecodigo ))    > 1)
				</cfif>
				<!---ActivosenTránsito--->
				<cfif isdefined('form.tran') >
				or(
				(( select count(1) from CRDocumentoResponsabilidad dr where dr.CRDRplaca = a.Aplaca and dr.Ecodigo = a.Ecodigo ))	> 0
				)
				</cfif>
				<!---Vudiferentecategoria/clase--->
				<cfif (isdefined ('form.vu') and isdefined ('form.ACcodigo') and LEN(TRIM(form.ACcodigo)) gt 0) or (isdefined('form.codigodesde') and LEN(TRIM(form.codigodesde))  gt 0 and isdefined ('form.vu'))or (isdefined ('form.codigohasta') and len(trim(form.codigohasta)) gt 0 and isdefined ('form.vu'))>
				or(
					(a.Avutil - clas.ACvutil) != 0
				)
				</cfif>
				
				<!---Fechas inconsistentes--->
				<cfif isdefined('form.finc') >
				or
				((select count(1) from AFResponsables r1 where r1.Aid=a.Aid and r1.AFRfini > r1.AFRffin))>0

				</cfif>
				
		<!---Fechas traslapadas--->
				<cfif isdefined('form.vales') >
				or
				((select count(1)
					from AFResponsables r1
								inner join AFResponsables r2
								on r1.Aid = r2.Aid and r1.AFRid<>r2.AFRid
								and (r1.AFRfini between r2.AFRfini AND r2.AFRffin 
								OR r1.AFRffin between r2.AFRfini AND r2.AFRfini)
					where r1.Aid=a.Aid
					and (
						r1.AFRfini between r2.AFRfini AND r2.AFRffin 
	        			    OR 
						r1.AFRffin between r2.AFRfini AND r2.AFRfini)))>0					
				</cfif>
		<!---Activos sin documento de Responsabilidad(Vale)--->
			<cfif isdefined('form.sinvale') >
				or
				(select count(1) 
				   from AFResponsables I12
				 where I12.Aid = a.Aid 
				   and <cf_dbfunction name="now"> between I12.AFRfini and I12.AFRffin
				) = 0
			</cfif>
				)
</cfquery>
<!---PINTADO DEL REPORTE--->
<cfquery name="rsEmp" datasource="#session.dsn#">select Edescripcion from Empresas where Ecodigo=#session.Ecodigo#</cfquery>
<table align="center">
	<cfoutput>
	<tr><td nowrap="nowrap" align="center" colspan="15"><strong>#rsEmp.Edescripcion#</strong></td></tr>
	<tr><td nowrap="nowrap" align="center" colspan="15"><strong>Reporte de Inconsistencias</strong></td></tr>
	<tr><td nowrap="nowrap" align="center" colspan="15"><strong>Período: #form.periodo# &nbsp; Mes: #form.mes#</strong></td></tr>
	<tr><td nowrap="nowrap" align="center" colspan="15"><strong>Fecha:	#LSDateFormat(Now(),"DD/MM/YYYY")#</strong></td></tr>
	</cfoutput>
</table>
<!---Titulos--->
<table cellpadding="2" cellspacing="0" border="1">
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td>Clase&nbsp;</td>	
		<td>Placa&nbsp;</td>	
		<td>Descripci&oacute;n&nbsp; </td>	
		<td>Fecha Adquisición&nbsp;</td>
		<td align="right">Monto Adq.&nbsp;</td>
		<td align="right">Monto Mej.&nbsp;</td>
		<td align="right">Monto Reval&nbsp;</td>
		<td align="right">Monto Deprec. Compra&nbsp;</td>
		<td align="right">Monto Deprec. Mejoras&nbsp;</td>
		<td align="right">Monto Deprec. Reval&nbsp;</td>
		<td align="right">Valor Rescate&nbsp;</td>
		<td align="right">Vida Util Activo&nbsp;</td>
		<td align="right">Saldo Vida Util&nbsp;</td>
		<td>I1&nbsp;</td>
		<td>I2&nbsp;</td>
		<td>I3&nbsp;</td>
		<td>I4&nbsp;</td>
		<td>I5&nbsp;</td>
		<td>I6&nbsp;</td>
		<td>I7&nbsp;</td>
		<td>I8&nbsp;</td>
		<td>I9&nbsp;</td>
		<td>I10&nbsp;</td>
		<td>I11&nbsp;</td>
		<td>I12&nbsp;</td>
	</tr>
<cfloop query="rsSQL">
	<!---Datos--->
	<tr  class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		<cfoutput>
		<td nowrap="nowrap">#clase#</td>	
		<td><a href="javascript: doConlis(#rsSQL.Aid#);">#placa#</a></td>	
		<td nowrap="nowrap" align="left">#descripcion#&nbsp;</td>	
		<td align="right">#LSDateFormat(fechaadq,"DD/MM/YYYY")#&nbsp;</td>
		<td align="right">#numberformat(valadq, ",9.00")#&nbsp;</td>
		<td align="right">#numberformat(valmej, ",9.00")#&nbsp;</td>
		<td align="right">#numberformat(valrev, ",9.00")#&nbsp;</td>
		<td align="right">#numberformat(depadq, ",9.00")#&nbsp;</td>
		<td align="right">#numberformat(depmej, ",9.00")#&nbsp;</td>
		<td align="right">#numberformat(deprev, ",9.00")#&nbsp;</td>
		<td align="right">#numberformat(vr, ",9.00")#&nbsp;</td>
		<td align="right">#numberformat(vu, ",9")#&nbsp;</td>
		<td align="right">#numberformat(saldovu, ",9")#&nbsp;</td>
		</cfoutput>
		<td><cfif isdefined ('rsSQL.I1')  and len(trim(rsSQL.I1))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I2')  and len(trim(rsSQL.I2))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I3')  and len(trim(rsSQL.I3))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I4')  and len(trim(rsSQL.I4))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I5')  and len(trim(rsSQL.I5))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I6')  and len(trim(rsSQL.I6))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I7')  and len(trim(rsSQL.I7))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I8')  and len(trim(rsSQL.I8))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I9')  and len(trim(rsSQL.I9))  gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I10') and len(trim(rsSQL.I10)) gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I11') and len(trim(rsSQL.I11)) gt 0>X<cfelse>_</cfif></td>
		<td><cfif isdefined ('rsSQL.I12') and len(trim(rsSQL.I12)) gt 0>X<cfelse>_</cfif></td>
	</tr>
</cfloop>
	<tr><td align="center" colspan="25">***Ultima Linea***</td></tr>
</table>
<table align="left">
	<tr><td colspan="25"><strong>Detalle de Inconsistencias</strong></td></tr>
	<tr><td colspan="25"><strong>I1:</strong> Adquisicion es CERO</td></tr>
	<tr><td colspan="25"><strong>I2:</strong> Falta Depreciacion</td></tr>
	<tr><td colspan="25"><strong>I3:</strong> No se permite Revaluar</td></tr>
	<tr><td colspan="25"><strong>I4:</strong> DepreciaciónAdq>Adquisición</td></tr>
	<tr><td colspan="25"><strong>I5:</strong> DepreciaciónMej>Mejora</td></tr>
	<tr><td colspan="25"><strong>I6:</strong> DepreciacionRev>Revaluacion</td></tr>
	<tr><td colspan="25"><strong>I7:</strong> Placas Repetidas</td></tr>
	<tr><td colspan="25"><strong>I8:</strong> Vales por Mejora de Activos Fijos</td></tr>
	<tr><td colspan="25"><strong>I9:</strong> Vida &uacute;til del activo diferente a la de categoria-clase</td></tr>
	<tr><td colspan="25"><strong>I10:</strong> Fechas inconsistentes</td></tr>
	<tr><td colspan="25"><strong>I11:</strong> Vales repetidos</td></tr>
	<tr><td colspan="25"><strong>I12:</strong> Activos sin Documento de Responsabilidad Activo a la Fecha de Hoy</td></tr>
</table>

<script language="javascript1.1" type="text/javascript">
var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}

function doConlis(Aid,Inconsistencias){
	<cfoutput>
	popUpWindow("/cfmx/sif/af/consultas/inconsistencias/inconsistencias_info.cfm?periodo=+#form.periodo#+ &mes=+#form.mes#+ &AID="+Aid+"&TIPOS="+Inconsistencias,150,150,800,500);
	</cfoutput>
}

function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}

function funcfiltro(){
	document.detAFVR.action='inconsistencias_form.cfm';
	document.detAFVR.submit();
}
</script>
