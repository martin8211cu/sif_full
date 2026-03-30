
 <!--- 
	Revisar que la marca este dentro del rango de alguna Excepcion, si se cumple entonces
		hay que agregar una inconsistencia mas para el empleado
  --->			
  
<cfquery name="rsControlM" datasource="#Session.DSN#">
	Select RHCMfcapturada
		, RHCMhoraentradac
		, RHCMhorasalidac
		, RHJid
	from RHControlMarcas
	where RHCMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">				  
</cfquery>

<cfif isdefined('rsControlM') and rsControlM.recordCount GT 0>
	<cfset numDiaMarca = DayOfWeek(rsControlM.RHCMfcapturada)>
	<!--- Para cuando la hora de salida de la marca esta dentro del rango de la excepcion --->
	<cfquery name="rsExcepcionesMayor" datasource="#Session.DSN#">
		Select 	convert(varchar,<cfqueryparam cfsqltype="cf_sql_time" value="#rsControlM.RHCMhoraentradac#">,108) as hEntrada, 
				convert(varchar,<cfqueryparam cfsqltype="cf_sql_time" value="#rsControlM.RHCMhorasalidac#">,108) as hSalida, 
				convert(varchar,RHEJhorainicio,108) as RHEJhorainicio, 
				(
					(
						datediff(mi,convert(varchar,RHEJhorainicio,108),convert(varchar,<cfqueryparam cfsqltype="cf_sql_time" value="#rsControlM.RHCMhorasalidac#">,108))
					) / 60.0
				) as cantHorasMayor, 
				ej.CIid
		from RHExcepcionesJornada ej
			inner join CIncidentes ci
				on ci.CIid = ej.CIid 
					and ci.CInegativo = 1
		where RHJid=<cfqueryparam cfsqltype="cf_sql_n umeric" value="#rsControlM.RHJid#">
			<cfif numDiaMarca EQ 1>
				and RHEJdomingo = 1
			<cfelseif numDiaMarca EQ 2>
				and RHEJlunes = 1
			<cfelseif numDiaMarca EQ 3>
				and RHEJmartes = 1
			<cfelseif numDiaMarca EQ 4>
				and RHEJmiercoles = 1
			<cfelseif numDiaMarca EQ 5>
				and RHEJjueves = 1
			<cfelseif numDiaMarca EQ 6>
				and RHEJviernes = 1
			<cfelseif numDiaMarca EQ 7>
				and RHEJsabado = 1
			</cfif>			
			and	<cfqueryparam cfsqltype="cf_sql_time" value="#rsControlM.RHCMhorasalidac#"> > RHEJhorainicio
	</cfquery>
</cfif>

<cfif isdefined('rsExcepcionesMayor') and rsExcepcionesMayor.recordCount GT 0 and rsExcepcionesMayor.cantHorasMayor GT 0>
	<!--- Para las horas positivas --->
	<cfquery name="rsDetIncid" datasource="#Session.DSN#">
		select  RHCMhorasadicautor
			, ( 	select coalesce(sum(b.RHDMhorasautor),0) 
				from RHDetalleIncidencias b, CIncidentes ci
				where cm.RHCMid = b.RHCMid
				and ci.CIid=b.CIid
				and ci.CInegativo = 1
			) as sumaHoras
			
		from RHControlMarcas cm
		where cm.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and cm.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#"> 
	</cfquery>
	

	<cfif isdefined('rsDetIncid') and rsDetIncid.recordCount GT 0>
		<cfif rsDetIncid.RHCMhorasadicautor GT 0 and ((rsDetIncid.RHCMhorasadicautor - rsDetIncid.sumaHoras) GT 0)>
			<cfif ((rsDetIncid.RHCMhorasadicautor - rsDetIncid.sumaHoras) GT rsExcepcionesMayor.cantHorasMayor)>
				<cfset cantHorasAutor = rsExcepcionesMayor.cantHorasMayor>
			<cfelse>	<!--- Las horas autorizadas para incidencias es menor a las solicitadas
								Por tal motivo se van a autorizar solamente lo que falta para completar
								el total de horas autorizadas, aunque las solicitadas sean mas que las que se
								van a permitir autorizar --->
				<cfset cantHorasAutor = rsDetIncid.RHCMhorasadicautor - rsDetIncid.sumaHoras>
			</cfif>

			<cfif cantHorasAutor GT 0>
				<cfquery datasource="#Session.DSN#">
					insert RHDetalleIncidencias 
					(RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, RHDMusuario, RHDMfecha, BMUsucodigo, BMfecha, BMfmod)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExcepcionesMayor.CIid#">
						, <cfqueryparam cfsqltype="cf_sql_float" value="#cantHorasAutor#">
						, <cfqueryparam cfsqltype="cf_sql_float" value="#cantHorasAutor#">
						, null
						, null
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						, getDate()
						, getDate())							
				</cfquery>				
			</cfif>
		</cfif>
	</cfif>
</cfif>
