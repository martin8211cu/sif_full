<cfset fecfin=''>
<cfsetting requesttimeout="3600">
<cfquery name="rsSQL" datasource="#session.dsn#">
	select a.Aplaca as placa
		<!---Inconsistencia--->
				<!---Depreciacion---> 			
				<!---Adquisicion--->		
					, case when
						(
							s.AFSvaladq = 0
						) 
						then '1'
					end  as I1
			
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
			
				<!---RevaluaciÃ³n--->				
					, case when
						(
							s.AFSvalrev > 0
							and (
								select count(1) from AClasificacion cl where cl.Ecodigo = s.Ecodigo and cl.ACid = s.ACid and cl.ACcodigo = s.ACcodigo and cl.ACrevalua = 'N'
								) > 0
				
						)
						then '3'
					end as I3
			
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
			
				<!---PlacasRepetidas--->
			
					, case when 
				   (( select count(1) from Activos ad where ad.Aplaca = a.Aplaca and ad.Ecodigo = a.Ecodigo )) > 1
						then '7'
					end as I7
			
				<!---ActivosenTrÃ¡nsito--->
			
				, case when 
				(( select count(1) from CRDocumentoResponsabilidad dr where dr.CRDRplaca = a.Aplaca and dr.Ecodigo = a.Ecodigo ))	> 0
					then '8'
					end as I8
				
				<!---Vudiferentecategoria/clase--->

				, case when 
					(a.Avutil - clas.ACvutil) != 0
					then '9'
					end as I9
				<!---Fechas inconsistentes--->
				, case when 
				((select count(1) from AFResponsables r1 where r1.Aid=a.Aid and r1.AFRfini > r1.AFRffin))>0
					then 'I10'
					end as I10

				<!---Fechas traslapadas--->
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


			from AFSaldos s
				inner join Activos a
				on a.Aid = s.Aid
				and a.Aid=#url.Aid#
				
					<!---inner join TransaccionesActivos t 
					on t.Aid=s.Aid
					and t.Ecodigo=s.Ecodigo
					and t.Aid=#url.Aid#		
					and t.TAperiodo=#url.periodo#
					and t.TAmes=	#url.mes#	--->
				
				inner join AClasificacion clas
					on clas.ACcodigo=a.ACcodigo
					and clas.Ecodigo=a.Ecodigo
					and clas.ACid = a.ACid
			where s.Ecodigo = #session.ecodigo#
			  and s.AFSperiodo =#url.periodo#
			  and s.AFSmes = #url.mes#
			  and a.Astatus!=60
			  and a.Aid=#url.Aid#
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
				
					or	(
							s.AFSdepreciable = 1  
							and s.AFSsaldovutiladq > 0
							and (
								select count(1) from TransaccionesActivos tr where tr.Ecodigo = s.Ecodigo and  tr.TAperiodo = s.AFSperiodo and tr.TAmes = s.AFSmes and tr.IDtrans = 4 and tr.Aid = s.Aid
								) = 0
						)
				
				<!---RevaluaciÃ³n--->				
					or
						(
							s.AFSvalrev > 0
							and (
								select count(1) from AClasificacion cl where cl.Ecodigo = s.Ecodigo and cl.ACid = s.ACid and cl.ACcodigo = s.ACcodigo and cl.ACrevalua = 'N'
								) > 0				
						)
			
				<!---Mejoras--->			
					or
						(
							s.AFSvaladq < s.AFSdepacumadq
							or 
							s.AFSvalmej < s.AFSdepacummej
							or
							s.AFSvalrev < s.AFSdepacumrev
						)				
				
				<!---Adquisicion--->		
					or
						(
							s.AFSvaladq = 0
						) 
				<!---Placas repetidas--->
				
				or 
			    ( (( select count(1) from Activos ad where ad.Aplaca = a.Aplaca and ad.Ecodigo = a.Ecodigo ))    > 1)
				
				<!---ActivosenTrÃ¡nsito--->
				
				or(
				(( select count(1) from CRDocumentoResponsabilidad dr where dr.CRDRplaca = a.Aplaca and dr.Ecodigo = a.Ecodigo ))	> 0
				)
				<!---Vudiferentecategoria/clase--->
				or(
					(a.Avutil - clas.ACvutil) != 0
				)
									
			    <!---Fechas inconsistentes--->
			   or
				((select count(1) from AFResponsables r1 where r1.Aid=a.Aid and r1.AFRfini > r1.AFRffin))>0
				
           		<!---Fechas traslapadas--->
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
				)		
				
</cfquery>
<cfset LvarInc = "">

<cfoutput>
<cf_web_portlet_start border="true" titulo="Reporte de Inconsistencias" skin="info1">
<!---Encabezado--->
<table align="left" width="100%" >
	<tr><td align="center"><strong>Lista de Inconsistencias</strong></td></tr>
<tr>
</table>
<p>&nbsp;</p>
<table align="left" width="100%">
<!---Adquisicion es CERO
<cfloop query="rsSQL">--->
	<cfif  isdefined ('rsSQL.I1') and len(trim(#rsSQL.I1#)) gt 0>
		<tr >
			<td><strong>- Adquisici&oacute;n es Cero</strong></td>
		</tr>
	</cfif>

<!--- Falta Depreciacion--->
	<cfif isdefined ('rsSQL.I2') and len(trim(#rsSQL.I2#)) gt 0>
		<tr >
			<td ><strong>- Falta Depreciacion</strong></td>
		</tr>
	</cfif>	

<!---No se permite Revaluar--->
	<cfif isdefined ('rsSQL.I3') and len(trim(#rsSQL.I3#)) gt 0>
		<tr>
			<td><strong>- Categoria Clase no revaluables con saldos acumulados en revaluaci&oacute;n</strong></td>
		</tr>
	</cfif>

<!---DepreciaciÃ³nAdq>AdquisiciÃ³n--->
	<cfif  isdefined ('rsSQL.I4') and len(trim(#rsSQL.I4#)) gt 0>
		<tr>
			<td ><strong>- Depreciaci&oacute;nAdq>Adquisici&oacute;n</strong></td>
		</tr>
	</cfif>	
<!---DepreciaciÃ³nMej>Mejora--->
	<cfif isdefined ('rsSQL.I5') and len(trim(#rsSQL.I6#)) gt 0>
		<tr >
			<td ><strong>- Depreciaci&oacute;nMej>Mejora</strong></td>
		</tr>
	</cfif>	

<!---DepreciacionRev>Revaluacion--->
	<cfif isdefined ('rsSQL.I6') and len(trim(#rsSQL.I6#)) gt 0>
		<tr >
			<td ><strong>- Depreciaci&oacute;nRev>Revaluacion</strong></td>
		</tr>
	</cfif>	

<!---Placas Repetidas--->
		<cfif isdefined ('rsSQL.I7') and len(trim(#rsSQL.I7#)) gt 0>
		<tr >
			<td ><strong>- Placas Repetidas</strong></td>
		</tr>
		</cfif>

<!---Activos en TrÃ¡nsito--->
		<cfif isdefined ('rsSQL.I8') and len(trim(#rsSQL.I8#)) gt 0>
		<tr>
			<td ><strong>- Activos en TrÃ¡nsito</strong></td>
		</tr>
		</cfif>

<!---Vu diferente categoria/clase--->
		<cfif isdefined ('rsSQL.I9') and len(trim(#rsSQL.I9#)) gt 0>
		<tr >
			<td ><strong>- Vida &Uacute;til del Activo diferente a Vida &Uacute;til Categor&iacute;a-Clase </strong></td>
		</tr>
		</cfif>

<!---Fechas inconsistentes--->
		<cfif isdefined ('rsSQL.I10') and len(trim(#rsSQL.I10#)) gt 0>
		<tr >
			<td ><strong>- La fecha es inconsistente </strong></td>
		</tr>
		</cfif>

<!---Vu diferente categoria/clase--->
		<cfif isdefined ('rsSQL.I11') and len(trim(#rsSQL.I11#)) gt 0>
		<tr >
			<td ><strong>- El activo tiene varios vales </strong></td>
		</tr>
		</cfif>
</table>
<cfset LvarInc = htmleditformat(mid(LvarInc,3,1000))>
</cfoutput>
<cf_web_portlet_end>
<cf_web_portlet_start border="true" titulo="Consulta" skin="info1">
<cfset varURL=1>
<cfinclude template="/sif/af/consultas/activosPlaca/activosPlaca_sql.cfm">
<cf_web_portlet_end>
