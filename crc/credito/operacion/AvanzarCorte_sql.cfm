<!--- 
Creado por Jose Gutierrez 
	17/04/2018
 --->
<cfset returnTo="AvanzarCorte.cfm">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Avanzar Corte')>


<cfset LvarPagina = "AvanzarCorte.cfm">

<cfoutput>
	<cfif isDefined('form.avanzar')>  

 	<cfif #form.avanzar# eq 1>
		
		<!---se buscan los cortes con el campo cerrado = 0 ordenados descendentemente.
		 se toma el la fecha fin del primer registro y se buscan en los siguientes
		 que tenga igual fecha para que sean parte del proceso a cerrar --->
		<cfquery name="qCortesACerrar" datasource="#session.dsn#">
		 	select top 10 id, Codigo, FechaFin
		 	from  CRCCortes c
		 	where ((Tipo <> 'TM' and Cerrado = 0) or (Tipo = 'TM' and status = 1))
		 	order by FechaFin asc 
		</cfquery>
		
		<cfif qCortesACerrar.recordCount neq 0>
		 	 
			<cfset loc.fechaFin = qCortesACerrar.FechaFin>
		 	<cfset loc.fechaFin = dateAdd('d', 1, loc.fechaFin)>

		 	<!-- si la fecha de cierre de corte, se pasa del la fecha fin de saldo vencido para un
		 	    corte con status 1, signfica que se pasa una fecha por alto y que hay ponerla de primera
		 	    para avanzar el corte -->
		 	<cfquery name="qCortesFueraRango" datasource="#session.dsn#">
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
									init(Ecodigo=session.Ecodigo, conexion="#session.dsn#")>
 
			<cfset CRCProcesoCorte.procesarCorte(fechaCorte=loc.fechaFin)>
			Proceso de cierre de corte realizado : Fecha Inicio mas  un dia <cfoutput>#loc.fechaFin#</cfoutput>
		<cfelse>

			<!--- se  buscan los cortes con status 1(fecha fin) y 2(fecha fin SV).
			       se busca el que tena la fecha mas pequeña --->  
			<cfquery name="qFechaSiguiente" datasource="#session.dsn#">
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
										init(Ecodigo=session.Ecodigo, conexion="#session.dsn#")> 
				<cfset CRCProcesoCorte.procesarCorte(fechaCorte=loc.fecha)>	
				 
				Proceso usando fecha fin de saldo vencido para colocar estatus 2 a 3 <cfoutput>#loc.fecha#</cfoutput>

			</cfif>	 

		</cfif>

	<cfelseif #form.avanzar# eq 2>	

		<cfset CRCProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte").
								init(Ecodigo=session.Ecodigo, conexion="#session.dsn#")> 
		<cfset CRCProcesoCorte.procesarCorte()>


	</cfif>
		<!--- volver a recalcular el corte. Se buscan cortes con status 1, monto a pagar calculado
		 y se usa su fecha fin menos unos, para que no cierre nuevos cortes 
		<cfquery name="qCortesARecaulcuar" datasource="#session.dsn#">
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
								init(Ecodigo=session.Ecodigo, conexion="#session.dsn#")>

		<cfset CRCProcesoCorte.procesarCorte(fechaCorte=loc.fechaFin)>


	<cfelseif #form.avanzar# eq 2> 

		
								
	</cfif>
	--->

</cfif>

</cfoutput>
<!---VALIDADOR--->

<cfoutput>
	<form action="#returnTo#" method="post" name="sql">
		<cfif isdefined("Form.Nuevo")>
			<input name="Nuevo" type="hidden" value="Nuevo">
		</cfif>
		<cfif isdefined("Form.Regresar")>
			<input name="Regresar" type="hidden" value="Regresar">
		</cfif>
		
	</form>

	<HTML>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
		<body>
			<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		</body>
	</HTML>

</cfoutput>




