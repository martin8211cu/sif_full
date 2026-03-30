<cfparam name="row" default="-1">

<cfif isdefined("url.Generar")>
	<cfsavecontent variable="rsReporte">

		<cfoutput>
			select 
			 p.Pid as Pid,
			 p.Pdescripcion as peaje,
			 <cf_dbfunction name="date_part" args="YYYY,pet.PETfecha"> as año,
			 <cf_dbfunction name="date_part" args="MM,pet.PETfecha"> as mes,
			 pt.PTid as PTid,
             pt.PTcodigo as turno,
			 pv.PVid as PVid,
			 pv.PVdescripcion as vehiculo
			 
			from PDTVehiculos pdtv
			
			inner join PETransacciones pet
			on pdtv.PETid= pet.PETid 
			
			inner join Peaje p
			on p.Pid= pet.Pid   
			
			inner join PTurnos pt
			on pt.PTid= pet.PTid
			
			inner join PVehiculos pv
			on pv.PVid = pdtv.PVid
			
			inner join PPrecio pr 
			on pr.Pid = p.Pid 
			and pr.PVid = pv.PVid 
			
			where pet.Ecodigo = #session.Ecodigo#

			<!--- Peajes Desde / Hasta --->
			 <cfif isdefined("url.Pidinicio") and len(trim(url.Pidinicio)) and isdefined("url.Pidfinal") and len(trim(url.Pidfinal))>
			 	<cfif url.Pidinicio gt url.Pidfinal >
				     and p.Pid between #url.Pidfinal#  and #url.Pidinicio#
				 <cfelse> 
					   and p.Pid between #url.Pidinicio#  and #url.Pidfinal#
				</cfif>
			</cfif>
			<!--- Periodo Desde / Hasta --->
			<cfif url.periodoInicial gt url.periodoFinal or (url.periodoInicial eq url.periodoFinal and url.mesInicial gt url.mesFinal)>
				and <cf_dbfunction name="date_part" args="YYYY,pet.PETfecha"> between #url.periodoFinal# and #url.periodoInicial#
				and <cf_dbfunction name="date_part" args="MM,pet.PETfecha"> between #url.mesFinal# and #url.mesInicial#
			<cfelse> 
				and <cf_dbfunction name="date_part" args="YYYY,pet.PETfecha"> between #url.periodoInicial# and #url.periodoFinal#
				and <cf_dbfunction name="date_part" args="MM,pet.PETfecha"> between #url.mesInicial# and #url.mesFinal#
			</cfif>			
			<!--- Turnos Desde / Hasta --->
			 <cfif isdefined("url.PTidinicio") and len(trim(url.PTidinicio)) and isdefined("url.PTidfinal") and len(trim(url.PTidfinal))>
			 	<cfif url.PTidinicio gt url.PTidfinal >
				     and pt.PTid between #url.PTidfinal#  and #url.PTidinicio#
				 <cfelse> 
					   and pt.PTid between #url.PTidinicio#  and #url.PTidfinal#
				</cfif>
			</cfif>
			<!--- Vehiculos Desde / Hasta --->
			 <cfif isdefined("url.PVidinicio") and len(trim(url.PVidinicio)) and isdefined("url.PVidfinal") and len(trim(url.PVidfinal))>
			 	<cfif url.PVidinicio gt url.PVidfinal >
				     and pv.PVid between #url.PVidfinal#  and #url.PVidinicio#
				 <cfelse> 
					   and pv.PVid between #url.PVidinicio#  and #url.PVidfinal#
				</cfif>
			</cfif>
			
			group by <cf_dbfunction name="date_part" args="YYYY,pet.PETfecha">,<cf_dbfunction name="date_part" args="MM,pet.PETfecha">,pt.PTid, pt.PTcodigo,p.Pid,p.Pdescripcion,pv.PVid,pv.PVdescripcion
			order by  p.Pid,<cf_dbfunction name="date_part" args="YYYY,pet.PETfecha">,<cf_dbfunction name="date_part" args="MM,pet.PETfecha">, pt.PTid, pt.PTcodigo,p.Pdescripcion,pv.PVid,pv.PVdescripcion

		</cfoutput>
	</cfsavecontent>

		
<cfset meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>		
<cfoutput>		
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="right">
			<table width="10%" align="right" border="0" height="25px">
				<tr><td>Usuario:</td><td>#session.Usulogin#</td></tr>
				<tr><td>Fecha:</td><td>#LSDateFormat(now(), 'dd/mm/yyyy')#</td></tr>
			</table>
		</td>
	</tr>
	<tr><td align="center" style="font-size:24px"><span class="titulox"><strong>#session.Enombre#</strong></span></td></tr>
	<tr><td align="center" style="font-size:18px"><strong>#LvarNombreReporte#</strong></td></tr>
	<tr>	</td>
	<cfif (isdefined("url.Pidinicio") and len(trim(url.Pidinicio)) gt 0)>
		<tr><td align="center"><strong>Peaje Desde : </strong>#url.Pdescripcioninicio# &nbsp;&nbsp;
	</cfif>
	<cfif (isdefined("url.Pidfinal") and len(trim(url.Pidfinal)) gt 0)>
		<strong> Hasta : </strong>#url.Pdescripcionfinal#</td></tr>
	</cfif>
	<cfif (isdefined("url.Fechadesde") and len(trim(url.Fechadesde)) gt 0)
		and (isdefined("url.Fechahasta") and len(trim(url.Fechahasta)) gt 0)>
			<tr><td align="center"><strong> Fecha Desde : </strong>#LSDateFormat(url.Fechadesde,'DD/MM/YYYY')#<strong>&nbsp;&nbsp;Hasta :</strong>#LSDateFormat(url.Fechahasta,'DD/MM/YYYY')#</td></tr>
	<cfelse>
		<tr><td align="center"><strong>Per&iacute;odo/Mes Inicial :</strong> #url.periodoInicial#/#ListGetAt(meses, url.mesInicial)#</td></tr>	
		<tr><td align="center"><strong>Per&iacute;odo/Mes Final:</strong> #url.periodoFinal#/#ListGetAt(meses, url.mesFinal)#</td></tr>	
	</cfif>
	<cfif (isdefined("url.PTidinicio") and len(trim(url.PTidinicio)) gt 0)>
		<tr><td align="center"><strong>Turno Desde : </strong>#url.PTcodigoinicio# &nbsp;&nbsp;
	</cfif>
	<cfif (isdefined("url.PTidfinal") and len(trim(url.PTidfinal)) gt 0)>
		<strong> Hasta : </strong>#url.PTcodigofinal#</td></tr>
	</cfif>
	<cfif (isdefined("url.PVidinicio") and len(trim(url.PVidinicio)) gt 0)>
		<tr><td align="center"><strong>Veh&iacute;culos Desde : </strong>#url.PVdescripcioninicio# &nbsp;&nbsp;
	</cfif>
	<cfif (isdefined("url.PVidfinal") and len(trim(url.PVidfinal)) gt 0)>
		<strong> Hasta : </strong>#url.PVdescripcionfinal#</td></tr>
	</cfif>
</table>
<br />
</cfoutput>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	
<cftry>
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#rsReporte#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfset registros = 0 >
	<cfset totalvehiculos = 0 >

	<cfoutput query="data" group="peaje"  maxrows="5000">
		<cfset registros = registros + 1 >
		<tr><td class="tituloListas" style="font-size:16px" colspan="20"><strong>PEAJE: </strong>#peaje#</td></tr>
		 <cfoutput group="año"> 
		 <tr><td class="tituloListas" colspan="20" style="font-size:16px" ><strong>A&Ntilde;O: </strong> #año#</td></tr>
		 <cfoutput group="mes"> 
		 <tr><td class="tituloListas" colspan="20" style="font-size:16px" ><strong>MES: </strong>#ListGetAt(meses, mes)#</td></tr>
		<cfoutput group="turno"> 
		 <tr><td class="tituloListas" colspan="20" style="font-size:16px"><strong>TURNO:</strong> #turno#</td></tr>
		 <tr style="padding:10px;">
		 <td style="padding:3px;font-size:15px" bgcolor="CCCCCC" nowrap="nowrap"></td>
		 <cfoutput group="vehiculo">
		<cfif isdefined("url.monto") and isdefined ("url.cantidad")>
		 	<td style="padding:3px;font-size:15px" colspan="2" bgcolor="CCCCCC" nowrap="nowrap" align="center"><strong>#vehiculo#</strong></td>
		<cfelse>
		 	<td style="padding:3px;font-size:15px" bgcolor="CCCCCC"  nowrap="nowrap" align="right"><strong>#vehiculo#</strong></td>
		</cfif>				  
		</cfoutput>
		<cfif isdefined("url.monto") and isdefined ("url.cantidad")> 
		  <td style="padding:3px;font-size:15px" bgcolor="CCCCCC" colspan="2" nowrap="nowrap" align="center"><strong>TOTAL</strong></td>
		  <cfelse>
		  <td style="padding:3px;font-size:15px" bgcolor="CCCCCC" nowrap="nowrap" align="right"><strong>TOTAL</strong></td>
		  </cfif>		  
		  <tr>
	   	  <td style="padding:3px;font-size:15px" bgcolor="CCCCCC" nowrap="nowrap">Carril</td>
	  
		  <cfoutput group="vehiculo" >
		  	<cfif isdefined("url.monto") and isdefined ("url.cantidad")>
				<td style="padding:3px;font-size:15px"  width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Cantidad</td>
				<td style="padding:3px;font-size:15px"  width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Monto</td>
			<cfelseif isdefined("url.cantidad")>
				<td style="padding:3px;font-size:15px" width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Cantidad</td>
			<cfelse> 
				<td style="padding:3px;font-size:15px" width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Monto</td>
			</cfif>
		  </cfoutput>
		 <cfif isdefined("url.monto") and isdefined ("url.cantidad")>
			<td style="padding:3px;font-size:15px" width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Cantidad</td>
			<td style="padding:3px;font-size:15px" width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Monto</td>
		<cfelseif isdefined("url.cantidad")>
			<td style="padding:3px;font-size:15px" width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Cantidad</td>
		<cfelse> 
			<td style="padding:3px;font-size:15px" width="2%" bgcolor="CCCCCC" nowrap="nowrap" align="right">Monto</td>
		</cfif>
	</tr>
		
		<cfquery name="CarrosPasaron" datasource="#session.DSN#">
		select   
			p.Pid as Pid, 
			p.Pdescripcion as peaje, 
			<cf_dbfunction name="date_part" args="YYYY,pet.PETfecha"> as año,
			<cf_dbfunction name="date_part" args="MM,pet.PETfecha"> as mes, 
			pt.PTid as PTid, 
			pt.PTcodigo as turno, 
			pdtv.PDTVcarril as carril, 
			pv.PVid as PVid, 
			pv.PVdescripcion as vehiculo, 
			sum (pdtv.PDTVcantidad) as cantidad, 
			sum (pdtv.PDTVcantidad * pr.PPrecio * Coalesce(htc.TCcompra,1)) Dinero
			 
			from PDTVehiculos pdtv
			
			inner join PETransacciones pet
			on pdtv.PETid= pet.PETid 
			
			inner join Peaje p
			on p.Pid= pet.Pid   
			
			inner join PTurnos pt
			on pt.PTid= pet.PTid
			
			inner join PVehiculos pv
			on pv.PVid = pdtv.PVid
            
            inner join PPrecio pr
                on pr.Pid = p.Pid
                and pr.PVid = pv.PVid
            
            inner join Monedas mon
                on mon.Mcodigo = pr.Mcodigo
                and mon.Ecodigo = p.Ecodigo
              
             left outer join Htipocambio htc
                on htc.Mcodigo = mon.Mcodigo
                and  <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah  
			
			where pet.Ecodigo = #session.Ecodigo#
			
			<cfif isdefined("url.PVidinicio") and len(trim(url.PVidinicio)) and isdefined("url.PVidfinal") and len(trim(url.PVidfinal))>
			 	<cfif url.PVidinicio gt url.PVidfinal >
				     and pv.PVid between #url.PVidfinal#  and #url.PVidinicio#
				 <cfelse> 
					   and pv.PVid between #url.PVidinicio#  and #url.PVidfinal#
				</cfif>
			</cfif>
			
			and pt.PTcodigo = '#turno#'
			and p.Pid = #Pid#
			and <cf_dbfunction name="date_part" args="YYYY,pet.PETfecha"> = #año#
			and <cf_dbfunction name="date_part" args="MM,pet.PETfecha"> = #mes#

		group by p.Pid, p.Pdescripcion,<cf_dbfunction name="date_part" args="YYYY,pet.PETfecha">,<cf_dbfunction name="date_part" args="MM,pet.PETfecha">, pt.PTid , pt.PTcodigo, pdtv.PDTVcarril , pv.PVid , pv.PVdescripcion
		order by  p.Pid,<cf_dbfunction name="date_part" args="YYYY,pet.PETfecha">,<cf_dbfunction name="date_part" args="MM,pet.PETfecha">,pt.PTid,pt.PTcodigo,pdtv.PDTVcarril,pv.PVid,pv.PVdescripcion
		</cfquery>
		<cfquery name="totalesCar" dbtype="query">
			select sum(cantidad) cantidad,
				   sum (Dinero) dinero,
                   PTid,
                   turno,
                   Pid,             
				   PVid
				   from CarrosPasaron
				   group by PTid,turno,Pid,PVid
		</cfquery>
		
		<cfset totalcarril=0>
		<cfset totalcarrilMonto=0>
		<cfset rowfin2 = 0>
		<cfset rowfin = 0>
		<cfloop query="CarrosPasaron">
		
			<cfif rowfin2 EQ 0>	
				<cfset rowfin = CarrosPasaron.carril>	
				<cfset rowfin2 = 1>
			<cfelseif rowfin EQ CarrosPasaron.carril>
			<cfelse>
				<cfset rowfin = CarrosPasaron.carril>
					<cfif isdefined ("url.cantidad") and isdefined ("url.monto")>
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
						#totalcarril# 
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">	
						¢#numberFormat(totalcarrilMonto,',9.00')#
					<cfelseif isdefined ("url.cantidad")>
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
						#totalcarril#
					<cfelse>
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
						¢#numberFormat(totalcarrilMonto,',9.00')#
					</cfif>
				
					  </td>
					<cfset totalcarril=0>
					<cfset totalcarrilMonto=0>
			</cfif>

			<cfif row  NEQ CarrosPasaron.carril>
				<cfset row = CarrosPasaron.carril>
					<cfif CarrosPasaron.currentrow NEQ 1>
						</tr>
					</cfif>	
				<tr>
				<td nowrap="nowrap" width="2%" style="padding:3px;font-size:9px">#CarrosPasaron.carril#</td>
			</cfif>
				<cfif isdefined ("url.cantidad") and isdefined ("url.monto")>
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
						#CarrosPasaron.cantidad# 
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">		
						¢#numberFormat(CarrosPasaron.Dinero,',9.00')#
					<cfelseif isdefined ("url.cantidad")>
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
						#CarrosPasaron.cantidad#
					<cfelse>
					<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
						¢#numberFormat(CarrosPasaron.Dinero,',9.00')#
					</cfif>
				</td>
			<cfset totalcarril = totalcarril+ CarrosPasaron.cantidad>
			<cfset totalcarrilMonto = totalcarrilMonto+ CarrosPasaron.Dinero>
		</cfloop>
		
		<cfif isdefined ("url.cantidad") and isdefined ("url.monto")>
		<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
			#totalcarril#
		<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">	
			¢#numberFormat(totalcarrilMonto,',9.00')#
		<cfelseif isdefined ("url.cantidad")>
		<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
			#totalcarril#
		<cfelse>
		<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
			¢#numberFormat(totalcarrilMonto,',9.00')#
		</cfif>
		</td>
		<cfset totalcarril=0>
		<cfset totalcarrilMonto=0>
		</tr>	
		 <tr><td style="padding:3px;font-size:15px" bgcolor="CCCCCC" nowrap="nowrap">Total</td>
		 <cfset totalFinal = 0>
		  <cfset totalFinalMonto = 0>
		 <cfloop query="totalesCar">
			<cfif isdefined ("url.cantidad") and isdefined ("url.monto")>
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
				#totalesCar.cantidad# 
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">	
				¢#numberFormat(totalesCar.dinero,',9.00')#
			<cfelseif isdefined ("url.cantidad")>
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
				#totalesCar.cantidad#
			<cfelse>
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
				¢#numberFormat(totalesCar.dinero,',9.00')#
			</cfif>
			</td>
			<cfset totalFinal = totalFinal + totalesCar.cantidad >
			<cfset totalFinalMonto = totalFinalMonto + totalesCar.dinero >
		 </cfloop>
			
			<cfif isdefined ("url.cantidad") and isdefined ("url.monto")>
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
				#totalFinal#
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">	
				¢#numberFormat(totalFinalMonto,',9.00')#
			<cfelseif isdefined ("url.cantidad")>
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
				#totalFinal#
			<cfelse>
			<td nowrap="nowrap" style="padding:3px;font-size:9px" align="right">
				¢#numberFormat(totalFinalMonto,',9.00')#
			</cfif>
			</td>
		 </tr>
		
		<tr><td>&nbsp;</td></tr>
		</cfoutput> <!---cierra el turno--->
		</cfoutput><!---cierra la mes--->
		</cfoutput><!---cierra la año--->
	</cfoutput><!---cierra el peaje--->
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	
	<cfif registros gt 0 >
	<cfelse>
		<tr><td colspan="30" align="center">--- No se encontraron registros ---</td></tr>
	</cfif>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="30" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	
</table>
</cfif>
