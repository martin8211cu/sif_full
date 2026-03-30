<cfif isDefined('form.avanzar')>  

 	<cfif #form.avanzar# eq 1>
		
		<!---se buscan los cortes con el campo cerrado = 0 ordenados descendentemente.
		 se toma el la fecha fin del primer registro y se buscan en los siguientes
		 que tenga igual fecha para que sean parte del proceso a cerrar --->
		<cfquery name="qCortesACerrar" datasource="minisif">
		 	select top 1 id, Codigo, FechaFin
		 	from  CRCCortes c
		 	where Cerrado = 0
		 	order by FechaFin asc 
		</cfquery>

		<cfif qCortesACerrar.recordCount neq 0>
		 	 
			<cfset loc.fechaFin = qCortesACerrar.FechaFin>
		 	<cfset loc.fechaFin = dateAdd('d', 1, loc.fechaFin)>

		 	<!-- si la fecha de cierre de corte, se pasa del la fecha fin de saldo vencido para un
		 	    corte con status 1, signfica que se pasa una fecha por alto y que hay ponerla de primera
		 	    para avanzar el corte -->
		 	<cfquery name="qCortesFueraRango" datasource="minisif">
			 	select top 1 id, FechaInicioSV
			 	from   CRCCortes c
			 	where  Cerrado = 1
			 	and    status  = 1
			 	and    <cfqueryparam value ="#loc.fechaFin#" cfsqltype="cf_sql_date"> > FechaFinSV 
			 	order by FechaFinSV asc
			</cfquery>

			<cfif qCortesFueraRango.recordCount gt 0>
				<cfset loc.fechaFin = qCortesFueraRango.FechaInicioSV>
		 		<cfset loc.fechaFin = dateAdd('d', 1, loc.fechaFin)>
			</cfif>

			<cfset CRCProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte").
									init(Ecodigo=1, conexion="minisif")>
 
			<cfset CRCProcesoCorte.procesarCorte(fechaCorte=loc.fechaFin)>
			Proceso de cierre de corte realizado : Fecha Inicio mas  un dia <cfoutput>#loc.fechaFin#</cfoutput>
		<cfelse>

			<!--- se  buscan los cortes con status 1(fecha fin) y 2(fecha fin SV).
			       se busca el que tena la fecha mas pequeña --->  
			<cfquery name="qFechaSiguiente" datasource="minisif">
			 	select  id, Codigo, FechaFin as fechaComparar, status, FechaInicio, FechaFin, FechaInicioSV, FechaFinSV
			 	from  CRCCortes c
			 	where status = 1
			 	union
			 	select  id, Codigo, FechaFinSV as fechaComparar, status, FechaInicio, FechaFin, FechaInicioSV, FechaFinSV
			 	from  CRCCortes c
			 	where status = 2
			 	order by fechaComparar asc
			</cfquery>
 		 	   

			<cfif qFechaSiguiente.recordCount gt 0>

				<cfset loc.FechaFinSV = qFechaSiguiente.fechaComparar>
			 	<cfset loc.fecha = dateAdd('d', 1, loc.FechaFinSV)>

				<cfif qFechaSiguiente.status eq '1' >
					<cfset loc.fecha = qFechaSiguiente.FechaInicioSV>
			 		<cfset loc.fecha = dateAdd('d', 1, loc.fecha)> 
				</cfif>
  		 

				<cfset CRCProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte").
										init(Ecodigo=1, conexion="minisif")> 
				<cfset CRCProcesoCorte.procesarCorte(fechaCorte=loc.fecha)>	
				 
				Proceso usando fecha fin de saldo vencido para colocar estatus 2 a 3 <cfoutput>#loc.fecha#</cfoutput>

			</cfif>	 

		</cfif>

	<cfelseif #form.avanzar# eq 2>	

		<cfset CRCProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte").
								init(Ecodigo=1, conexion="minisif")> 
		<cfset CRCProcesoCorte.procesarCorte()>


	</cfif>
		<!--- volver a recalcular el corte. Se buscan cortes con status 1, monto a pagar calculado
		 y se usa su fecha fin menos unos, para que no cierre nuevos cortes 
		<cfquery name="qCortesARecaulcuar" datasource="minisif">
		 	select top 1 id, Codigo, FechaFin
		 	from  CRCCortes c
		 	where Cerrado = 1
		 	and   status = 1
		 	order by FechaFin desc 
		</cfquery>

		<cfif qCortesARecaulcuar.recordCount eq 0>
		 	 No hay  cortes a recalcular
		</cfif>

		<cfset loc.fechaFin = qCortesACerrar.FechaFin>
	 	<cfset loc.fechaFin = dateAdd('d', -1, loc.fechaFin)>

		<cfset CRCProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte").
								init(Ecodigo=1, conexion="minisif")>

		<cfset CRCProcesoCorte.procesarCorte(fechaCorte=loc.fechaFin)>


	<cfelseif #form.avanzar# eq 2> 

		
								
	</cfif>
	--->


</cfif>

<form name="frmCorte" id="frmCorte" method="post">
	<table>
	<tr>
		<td valign="top">
			<table border="1">
				<tr>
					<td> Avanzar Corte </td>
					<td> <input type="radio" name="avanzar" checked="" value="1"  <cfif isDefined('form.avanzar') and  #form.avanzar# eq 1> checked  </cfif> > </td>
				</tr>
				<tr>
					<td> Ejecutar Corte por fecha Actual(Fecha de la PC) </td>
					<td> <input type="radio" name="avanzar" value="2"  <cfif isDefined('form.avanzar') and  #form.avanzar# eq 2> checked  </cfif> ></td>
				</tr>	
				<tr>
					<td> </td>
					<td> <input type="submit" value="Aplicar" > </td>
				</tr>	
			</table>		
	 
		</td>
		<td>
			
			<table border="1">
				<tr>
					<td colspan="4"> Cortes con saldo vencido calculado y monto a pagar Calculados </td> 
				</tr>	
				<tr>
					<td> id </td>
					<td> Codigo </td>
					<td> Fecha Inicio</td>
					<td> Fecha Fin</td>
					<td> Fecha Inicio SV</td>
					<td> Fecha Fin SV</td> 
					<td> Estado de Calculo</td>
					<td> Cerrado</td>
				</tr>

					<cfquery name="qCortesSVPM" datasource="minisif">
					 	select   id, Codigo, FechaInicio, FechaFin, status, FechaInicioSV, FechaFinSV,cerrado
					 	from  CRCCortes c 
					 	order by FechaFin asc 
					</cfquery>	

					<cfif qCortesSVPM.recordCount neq 0 >
						<cfloop query="qCortesSVPM" >
							<cfif #status# eq 3>
								<tr style="background-color:gray">
							</cfif>
							<cfif #status# eq 2>
								<tr style="background-color:orange">
							</cfif>
							<cfif #status# eq 1>
								<tr style="background-color:yellow">
							</cfif>
							<cfif #cerrado# eq 0>
								<tr >
							</cfif>

								<td><cfoutput>#id#</cfoutput></td>
								<td><cfoutput>#Codigo#</cfoutput></td>
								<td><cfoutput>#FechaInicio#</cfoutput></td>
								<td><cfoutput>#FechaFin#</cfoutput></td>
								<td><cfoutput>#FechaInicioSV#</cfoutput></td>
								<td><cfoutput>#FechaFinSV#</cfoutput></td>
								<td><cfoutput>#status#</cfoutput></td>
								<td><cfoutput>#cerrado#</cfoutput></td>
							</tr> 
						</cfloop> 
					</cfif>	 
			</table>  
		</td>
	</tr>
	</table>
</form>

 
