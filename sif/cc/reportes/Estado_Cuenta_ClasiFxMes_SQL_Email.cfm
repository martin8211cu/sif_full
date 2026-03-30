<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.

	Creado por Gustavo Fonseca H.
		Fecha: 23-11-2005
		Motivo: Separar el sql de la pantalla.
	Modificado por Gustavo Fonseca H.
		Fecha: 7-2-2006.
		Motivo: Se agrega el campo Control a la tabla temporal con el fin de utilizarlo para ordenar los 
		registros y que asi siempre salga de primero el saldo inicial.

	Modificado por Mauricio Esquivel.
		Fecha: 3-8-2008.
		Motivo: Se cambia el proceso por un ciclo para evitar el uso de tabla temporal de socios #socios# 
		porque aparentemente no usa los índices correctamente en Sybase 15 segun reporte en RPSA.
		
		Se sacan las funcionaes a otro CFM para que puedan usarse las mismas funciones en otros posibles componentes, 
		por ejemplo, en el que reconstruye el estado de cuenta entre dos fechas.  La única función que debe de cambiarse 
		en ese caso es la que obtiene el saldo inicial del socio.
		

--->

<cfif not isdefined("SaldoCero")>
	<cfset SaldoCero = -1>
</cfif>

<cfinclude template="Estado_Cuenta_funciones.cfm">


<cffunction name="Generar" access="private" returntype="numeric">
	<cfargument name="periodo" 				default="2008" 				required="yes" 	type="numeric">
	<cfargument name="mes" 					default="01" 				required="yes" 	type="numeric">
	<cfargument name="SNnumero"   			default="              " 	required="no" 	type="string">
	<cfargument name="SNnumerob2" 			default="zzzzzzzzzzzzzz" 	required="no" 	type="string">
	<cfargument name="SNcodigo" 			default="" 					required="no" 	type="string">
	<cfargument name="SNcodigob2" 			default="" 					required="no" 	type="string">
	<cfargument name="DEidCobrador" 		default= "-1" 				required="no" 	type="numeric">
	<cfargument name="SNCEid" 				default= "-1" 				required="no" 	type="numeric">
	<cfargument name="SNCEid_Orden" 		default= "-1" 				required="no" 	type="numeric">
	<cfargument name="SNCDvalor1" 			default= "" 				required="no" 	type="string">
	<cfargument name="SNCDvalor2" 			default= "" 				required="no" 	type="string">
	<cfargument name="SaldoCero" 			default= "-1" 				required="no" 	type="numeric">
	<cfargument name="chk_cod_Direccion" 	default= "-1" 				required="no" 	type="numeric">
	<cfargument name="ordenado" 			default= "-1" 				required="no" 	type="numeric">
	<cfargument name="TipoReporte" 			default= "0" 				required="no" 	type="numeric">
	<cfargument name="Formato" 				default= "-1" 				required="no" 	type="numeric">
	<cfargument name="Cobrador" 			default= "Todos"			required="no" 	type="string">
	<cfargument name="Orientacion" 			default= "0"				required="no" 	type="numeric">
	<cfargument name="id_direccion" 									required="no" 	type="numeric">

	<cfsetting requesttimeout="3600">

	<cfset fechainicio = createdate(arguments.periodo,arguments.mes,1)>
	<cfset fechafinal  = dateadd('s', -1, dateadd('m', 1, fechainicio) )>
	<cfset periodo     = Arguments.periodo>
	<cfset mes         = Arguments.mes>
	<cfset periodosig  = periodo>
	<cfset messig      = mes + 1>
	<cfif messig GT 12>
		<cfset messig = 1>
		<cfset periodosig = periodo +1>
	</cfif>

	<cfset LvarTransNeteo = fnObtenerTransaccionesNeteo()>
	<cfif isdefined("arguments.id_direccion")>
		<cfset fnSeleccionarSocios(Arguments.SNnumero, Arguments.SNnumerob2, Arguments.chk_cod_Direccion, Arguments.DEidCobrador, Arguments.SNCEid, Arguments.SNCDvalor1, Arguments.SNCDvalor2, "RSsocios", Arguments.id_direccion)>
	<cfelse>
		<cfset fnSeleccionarSocios(Arguments.SNnumero, Arguments.SNnumerob2, Arguments.chk_cod_Direccion, Arguments.DEidCobrador, Arguments.SNCEid, Arguments.SNCDvalor1, Arguments.SNCDvalor2, "rsSocios", -1)>
	</cfif>

	<!--- 
		Proceso:
			1. Saldos Iniciales del Socio y Direccion
			2. Incluir Documentos construidos entre las fechas del Estado de Cuenta
			3. Recibos de Dinero ( Cobros o Pagos de Socios )
			4. Notas de Credito del socio aplicadas a documentos de otros socios
			5. Notas de Credito de Otros socios aplicadas a documentos del socio en proceso
			6. Documentos Aplicados en Proceso de Neteo de Documentos ( contra CxP y CxC )
			7. Pagos hechos en Tesorería sobre documentos del socio
			8. Si es por Direccion, incluir las notas de credito de una direccion aplicadas a otra direccion
	--->
	<cfloop query="rsSocios">
		<cfset fnSaldosInicialesMes (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		<cfset fnIncluirDocumentos (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		<cfset fnIncluirRecibos (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		<cfset fnIncluirNCaOtrosSocios (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		<cfset fnIncluirNCdeOtrosSocios (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		<cfif isdefined("LvarTransNeteo") and  len(trim(LvarTransNeteo)) GT 0>
			<cfset fnIncluirNeteos (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		</cfif>
		<cfset fnIncluirPagosTes (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		<cfif arguments.chk_cod_Direccion neq -1>
			<cfset fnIncluirNCdireccion (session.Ecodigo, rsSocios.SNcodigo, rsSocios.SNid, FechaInicio, FechaFinal, rsSocios.SNnumero, periodo, mes, rsSocios.id_direccion, rsSocios.SNDcodigo, rsSocios.Mcodigo, arguments.chk_cod_Direccion)>
		</cfif>
	</cfloop>
	<cfif arguments.chk_cod_Direccion neq -1>
		<cfquery datasource="#session.DSN#">
			update #movimientos#
				set TRgroup = TTransaccion,
					Ordenamiento = coalesce(( 
							select min(dc2.SNCDvalor)
							from SNClasificacionSND cs2
									inner join SNClasificacionD dc2
									 on dc2.SNCDid = cs2.SNCDid 
									and dc2.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNCEid_Orden#">
							where cs2.SNid = #movimientos#.SNid)
						, ' **** N/A ****')
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.DSN#">
			update #movimientos#
				set TRgroup = TTransaccion,
					Ordenamiento = coalesce(( 
							select min(dc2.SNCDvalor)
							from SNClasificacionSN cs2
								inner join SNClasificacionD dc2
								 on dc2.SNCDid = cs2.SNCDid 
								and dc2.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNCEid_Orden#">
							where cs2.SNid = #movimientos#.SNid)
						, ' **** N/A ****')
		</cfquery>
	</cfif>
	
	<cfif arguments.chk_cod_Direccion neq -1>
		<!--- --- Subreporte --- --->
		<cfquery name="Request.rsReporte2" datasource="#session.DSN#">
			select 
				m.IDdireccion as id_direccion,	
				m.Moneda as Moneda,
				mo.Mnombre,
				TRgroup as tipo,
				t.CCTdescripcion as CCTdescripcion,
				sum(m.Total) as Total
			from #movimientos# m
				inner join Monedas mo
					on mo.Ecodigo = m.Ecodigo
					and mo.Mcodigo = m.Moneda
				inner join CCTransacciones t
					on t.CCTcodigo = m.TTransaccion
					and t.Ecodigo = m.Ecodigo
			where m.TTransaccion is not null
			  and m.TTransaccion <> ' '
			  and m.Fecha between 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechainicio#"> 
				and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechafinal#">
			group by 
				m.IDdireccion,	
				m.Moneda,
				mo.Mnombre,
				TRgroup,
				t.CCTdescripcion

			order by 
				m.IDdireccion,
				m.Moneda,
				TRgroup
		</cfquery>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select 
				m.Ordenamiento as Ordenamiento, 
				sn.SNnumero as Socio,
				m.IDdireccion as IDdireccion,
				m.IDdireccion as id_direccion,
				mo.Mnombre as Mnombre, 
				m.Moneda as moneda,
				TRgroup as tipo,
				m.Documento as documento,
				m.Fecha as Fecha,
				m.FechaVencimiento as FechaVencimiento,
				m.OrdenCompra as DEordenCompra,
				m.Control,
				m.Reclamo as DEnumReclamo,
				m.Oficodigo as Oficodigo,

				case when m.Documento <> ' Saldo Inicial ' and m.Total >= 0 then m.Total else 0.00 end as Debitos,
				case when m.Documento <> ' Saldo Inicial ' and m.Total <  0 then -m.Total else 0.00 end as Creditos,

				m.Total as Total,  

				coalesce(si.SIsaldoinicial, 0.00) as Saldo,

				coalesce(si.SIsinvencer, 0.00) as SinVencer, 
				coalesce(si.SIcorriente, 0.00) as Corriente,  
				coalesce(si.SIp1, 0.00) as P1,
				coalesce(si.SIp2, 0.00) as P2,
				coalesce(si.SIp3, 0.00) as P3,
				coalesce(si.SIp4, 0.00) as P4,
				coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus,
				coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad,
			
				case when ltrim(rtrim(snd.SNDcodigo)) = '' or snd.SNDcodigo is null then sn.SNnumero else snd.SNDcodigo end as SNnumero,
				sn.SNidentificacion as SNidentificacion,
				sn.SNmontoLimiteCC as SNmontoLimiteCC,
				sn.SNtelefono as SNtelefono,
				coalesce(snd.SNDemail, sn.SNemail) as SNemail,
				case when ltrim(rtrim(snd.SNnombre)) = '' or snd.SNnombre is null then sn.SNnombre else snd.SNnombre end as SNnombre,
				di.direccion1 as direccion1,
				di.direccion2 as direccion2,
				di.codPostal as codPostal,
				coalesce(( 
						select min(<cf_dbfunction name='concat' args="de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2" delimiters='+'>)
						from SNDirecciones snd
						inner join DatosEmpleado de
						   on snd.DEidCobrador = de.DEid
						where snd.id_direccion = m.IDdireccion)
						,'No ha sido asignado')
						as Cobrador
			from #movimientos# m

				inner join SNegocios sn
					on sn.SNid = m.SNid
					
				inner join SNDirecciones snd
						inner join DireccionesSIF di
							on di.id_direccion = snd.id_direccion

				   on snd.SNid = m.SNid
				  and snd.id_direccion = m.IDdireccion

				inner join Monedas mo
					on mo.Mcodigo = m.Moneda
					
				left outer join SNSaldosIniciales si
					 on si.SNid = m.SNid
 					 and si.Mcodigo = m.Moneda
					 and si.id_direccion = m.IDdireccion
					 and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
					 and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">

			order by 
				sn.SNnumero, 
				sn.SNnombre, 
				m.IDdireccion,
				m.Moneda,
				m.Ordenamiento,
				m.Control,				 
				<cfif isdefined("arguments.ordenado") and arguments.ordenado neq -1>
				m.Reclamo,
				</cfif> 
				m.Fecha, 
				m.TTransaccion, 
				m.Documento	

		</cfquery>
	<cfelse>
		<!--- --- Subreporte --- --->
		<cfquery name="Request.rsReporte2" datasource="#session.DSN#">
			select 
				s.id_direccion,	
				m.Moneda as Moneda,
				mo.Mnombre,
				TRgroup as tipo,
				t.CCTdescripcion as CCTdescripcion,
				sum(m.Total) as Total
			from #movimientos# m
				inner join Monedas mo
					on mo.Ecodigo = m.Ecodigo
					and mo.Mcodigo = m.Moneda
				inner join SNegocios s
					on s.Ecodigo = m.Ecodigo
					and s.SNcodigo = m.Socio
				inner join CCTransacciones t
					on t.CCTcodigo = m.TTransaccion
					and t.Ecodigo = m.Ecodigo
					
			where m.TTransaccion is not null
			  and m.TTransaccion <> ' '
			  and m.Fecha between 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechainicio#"> 
				and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechafinal#">
			group by 
				s.id_direccion,	
				m.Moneda,
				mo.Mnombre,
				TRgroup,
				t.CCTdescripcion

			order by 
				s.id_direccion,
				m.Moneda,
				TRgroup
		</cfquery>
		<cfset LvarPtoControl_12 = gettickcount()>

		<cfquery name="rsReporte" datasource="#session.DSN#">
			select 
				  m.Ordenamiento as Ordenamiento 
				, m.SNnumero as Socio
				, sn.id_direccion as IDdireccion
				, sn.id_direccion as id_direccion
				, mo.Mnombre as Mnombre
				, m.Moneda as moneda
				, TRgroup as tipo
				, m.Documento as documento
				, m.Fecha as Fecha
				, m.FechaVencimiento as FechaVencimiento
				, m.OrdenCompra as DEordenCompra
				, m.Control
				, m.Reclamo as DEnumReclamo
				, m.Oficodigo as Oficodigo
				, case when  m.Documento <> ' Saldo Inicial ' and m.Total >= 0 then m.Total else 0.00 end as Debitos
				, case when  m.Documento <> ' Saldo Inicial ' and m.Total <  0 then -m.Total else 0.00 end as Creditos
				, m.Total as Total
	
				,coalesce((
					select sum(si.SIsinvencer)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as SinVencer
	
				, coalesce((
					select sum(si.SIcorriente)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				),  0.00) as Corriente
	
				, coalesce((
					select sum(si.SIp1)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as P1
	
				, coalesce((
					select sum(si.SIp2)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as P2
	
				, coalesce((
					select sum(si.SIp3)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as P3
	
				, coalesce((
					select sum(si.SIp4)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as P4
	
				, coalesce((
					select sum(si.SIp5 + si.SIp5p)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as P5plus
	
				, coalesce((
					select sum(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as Morosidad
	
				, coalesce((
					select sum(si.SIsaldoinicial)
					from SNSaldosIniciales si
					where si.SNid       = m.SNid
						and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodosig#">
						and si.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#messig#">
						and si.Mcodigo  = m.Moneda
				), 0.00) as Saldo
				
				, sn.SNnumero as SNnumero
				,  sn.SNidentificacion as SNidentificacion
				,  sn.SNmontoLimiteCC as SNmontoLimiteCC
				,  sn.SNtelefono as SNtelefono
				,  sn.SNemail as SNemail
				,  sn.SNnombre as SNnombre
				,  di.direccion1 as direccion1
				,  di.direccion2 as direccion2
				,  di.codPostal as codPostal
				,  coalesce(( 
					select min(<cf_dbfunction name='concat' args="de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2" delimiters='+'>)
					from DatosEmpleado de
					where de.DEid = sn.DEidCobrador), ' No ha sido Asignado') as Cobrador
	
			from #movimientos# m
				inner join SNegocios sn
					on sn.SNid = m.SNid
				inner join DireccionesSIF di
					on di.id_direccion = sn.id_direccion
				inner join Monedas mo
					on mo.Mcodigo = m.Moneda
					and mo.Ecodigo = m.Ecodigo

			order by 
				sn.SNnumero, 
				sn.SNnombre,
				sn.id_direccion,
				m.Moneda,
				m.Ordenamiento,
				
				m.Control,
				<cfif isdefined("arguments.ordenado") and arguments.ordenado neq -1>
				m.Reclamo,
				</cfif> 
				m.Fecha, 
				m.TTransaccion, 
				m.Documento	
		</cfquery>
	</cfif>
		
	<cfif arguments.TipoReporte eq 1>
		<!--- Busca el nombre de la Empresa --->
		<cfquery name="rsEmpresa" datasource="#session.DSN#">
			select Edescripcion
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfquery name="rsSNCEdescripcion" datasource="#session.DSN#">
			select SNCEdescripcion
			from  SNClasificacionE
			where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNCEid#">
		</cfquery>

		<cfquery name="rsSNCDdescripcion1" datasource="#session.DSN#">
			select SNCDdescripcion
			from  SNClasificacionD
            where SNCEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNCEid#">
			  and SNCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SNCDvalor1#">
		</cfquery>

		<cfquery name="rsSNCDdescripcion2" datasource="#session.DSN#">
			select SNCDdescripcion
			from  SNClasificacionD
            where SNCEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNCEid#">
			  and SNCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SNCDvalor2#">
		</cfquery>

		<cfif isdefined('arguments.SNcodigo') and len(trim(arguments.SNcodigo)) GT 0>
			<cfquery name="rsSNnombre1" datasource="#session.DSN#">
				select SNnombre
					from  SNegocios
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfif>

		<cfif isdefined('arguments.SNcodigob2') and len(trim(arguments.SNcodigob2)) GT 0>
			<cfquery name="rsSNnombre2" datasource="#session.DSN#">
				select SNnombre 
				from  SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigob2#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		</cfif>

		<cfquery name="rsSNCEdescripcion_orden" datasource="#session.DSN#">
			select SNCEdescripcion
				from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNCEid_orden#">
		</cfquery>

		<cfif isdefined("arguments.Formato") and len(trim(arguments.Formato)) and arguments.Formato EQ 1>
			<cfset formatos = "flashpaper">
		<cfelseif isdefined("arguments.Formato") and len(trim(arguments.Formato)) and arguments.Formato EQ 2>
			<cfset formatos = "pdf">
		<cfelseif isdefined("arguments.Formato") and len(trim(arguments.Formato)) and arguments.Formato EQ 3>
			<cfset formatos = "excel">
		</cfif>
		
		<!--- Invocación del reporte --->
		<cfif arguments.TipoReporte EQ 1>
		    <cfset nombreReporteJR = "">
			<cfif arguments.Orientacion eq 1>
				<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasFVertical.cfr">
				<cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasFVertical">
			<cfelse>
				<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasFHorizontal.cfr">
				<cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasFHorizontal">
			</cfif>
		</cfif>	

		<cfset LvarLeyendaCxC = ''>
        <cfquery name="rsLeyendaCxC" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #session.Ecodigo#
            and Pcodigo = 921
            and Mcodigo = 'CC'
        </cfquery>
        <cfif rsLeyendaCxC.recordcount gt 0>
            <cfset LvarLeyendaCxC = rsLeyendaCxC.Pvalor>
        </cfif>
        
       <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
			select Pvalor as valParam
			from Parametros
			where Pcodigo = 20007
			and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
		<cfset typeRep = 1>
		<cfif formatos EQ "pdf">
			<cfset typeRep = 2>
		</cfif>

		<cfif isdefined("tempfile") and Len(trim(tempfile))>
			<cfif rsReporte.recordcount LT 1>
				<cfreturn -1>
			</cfif>
			<!--- Para enviar los correos --->	
			<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
			    <cf_js_reports_service_tag queryReport = "#rsReporte#" 
					isLink = False 
					typeReport = #typeRep#
					fileName = "cc.reportes.#nombreReporteJR#"/>
			<cfelse>
			<cfreport format="#formatos#" template="#LvarReporte#" query="rsReporte" filename="#tempfile#" overwrite="yes">	
				<cfif isdefined("rsSNCEdescripcion") and rsSNCEdescripcion.recordcount eq 1>
					<cfreportparam name="SNCEdescripcion" value="#rsSNCEdescripcion.SNCEdescripcion#">
				</cfif> 
				<cfif isdefined("rsSNCDdescripcion1") and rsSNCDdescripcion1.recordcount eq 1>
					<cfreportparam name="SNCDdescripcion1" value="#rsSNCDdescripcion1.SNCDdescripcion#">
				</cfif>
				<cfif isdefined("rsSNCDdescripcion2") and rsSNCDdescripcion2.recordcount eq 1>
					<cfreportparam name="SNCDdescripcion2" value="#rsSNCDdescripcion2.SNCDdescripcion#">
				</cfif>
				<cfreportparam name="Cobrador" value="#arguments.Cobrador#">
				<cfif isdefined("rsSNnombre1") and rsSNnombre1.recordcount eq 1>
					<cfreportparam name="SNnombre" value="#rsSNnombre1.SNnombre#">
				<cfelse>
					<cfreportparam name="SNnombre" value="'N/A'">
				</cfif>
				<cfif isdefined("rsSNnombre2") and rsSNnombre2.recordcount eq 1>
					<cfreportparam name="SNnombreb2" value="#rsSNnombre2.SNnombre#">
				<cfelse>
					<cfreportparam name="SNnombreb2" value="'N/A'">
				</cfif>
				<cfif isdefined("mes") and len(trim(mes))>
					<cfreportparam name="mes" value="#mes#">
				</cfif>
				<cfif isdefined("periodo") and len(trim(periodo))>
					<cfreportparam name="periodo" value="#periodo#">
				</cfif>
				<cfreportparam name="FechaDes" value="#LSdateformat(fechainicio, "DD/MM/YYYY")#">
				<cfreportparam name="FechaHas" value="#LSdateformat(fechafinal, "DD/MM/YYYY")#">
				<cfif isdefined("rsSNCEdescripcion_orden") and rsSNCEdescripcion_orden.recordcount eq 1>
					<cfreportparam name="SNCEdescripcion_orden" value="#rsSNCEdescripcion_orden.SNCEdescripcion#">
				</cfif>
				<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
					<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
				</cfif>
				<cfif isdefined("P1")>
					<cfreportparam name="P1" value="#P1#">
				</cfif>		
				<cfif isdefined("P2")>
					<cfreportparam name="P2" value="#P2#">
				</cfif>		
				<cfif isdefined("P3")>
					<cfreportparam name="P3" value="#P3#">
				</cfif>
				<cfif isdefined("P4")>
					<cfreportparam name="P4" value="#P4#">
				</cfif>
				<cfif arguments.chk_cod_Direccion neq -1>
					<cfreportparam name="Tipo" value="1">
					<cfreportparam name="Titulo" value="Estado de Cuenta por Dirección del Socio">
				<cfelse>
					<cfreportparam name="Tipo" value="0">
					<cfreportparam name="Titulo" value="Estado de Cuenta de Socio">
				</cfif>
                
                <cfif isdefined("LvarLeyendaCxC") and len(trim(LvarLeyendaCxC))>
                    <cfreportparam name="LeyendaCxC" value="#LvarLeyendaCxC#">
                </cfif>
			</cfreport>	
			</cfif>
		<cfelse>
		    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
			    <cf_js_reports_service_tag queryReport = "#rsReporte#" 
					isLink = False 
					typeReport = #typeRep#
					fileName = "cc.reportes.#nombreReporteJR#"/>
			<cfelse>
			<cfreport format="#formatos#" template="#LvarReporte#" query="rsReporte">	
				<cfif isdefined("rsSNCEdescripcion") and rsSNCEdescripcion.recordcount eq 1>
					<cfreportparam name="SNCEdescripcion" value="#rsSNCEdescripcion.SNCEdescripcion#">
				</cfif> 
				<cfif isdefined("rsSNCDdescripcion1") and rsSNCDdescripcion1.recordcount eq 1>
					<cfreportparam name="SNCDdescripcion1" value="#rsSNCDdescripcion1.SNCDdescripcion#">
				</cfif>
				<cfif isdefined("rsSNCDdescripcion2") and rsSNCDdescripcion2.recordcount eq 1>
					<cfreportparam name="SNCDdescripcion2" value="#rsSNCDdescripcion2.SNCDdescripcion#">
				</cfif>
				<cfif isdefined("arguments.Cobrador") and len(trim(arguments.Cobrador)) eq 0>
					<cfset arguments.cobrador = 'Todos'>
				</cfif>
				<cfreportparam name="Cobrador" value="#arguments.Cobrador#">
				<cfif isdefined("rsSNnombre1") and rsSNnombre1.recordcount eq 1>
					<cfreportparam name="SNnombre" value="#rsSNnombre1.SNnombre#">
				<cfelse>
					<cfreportparam name="SNnombre" value="'N/A'">
				</cfif>
				<cfif isdefined("rsSNnombre2") and rsSNnombre2.recordcount eq 1>
					<cfreportparam name="SNnombreb2" value="#rsSNnombre2.SNnombre#">
				<cfelse>
					<cfreportparam name="SNnombreb2" value="'N/A'">
				</cfif>
				<cfif isdefined("mes") and len(trim(mes))>
					<cfreportparam name="mes" value="#mes#">
				</cfif>
				<cfif isdefined("periodo") and len(trim(periodo))>
					<cfreportparam name="periodo" value="#periodo#">
				</cfif>
				<cfreportparam name="FechaDes" value="#LSdateformat(fechainicio, "DD/MM/YYYY")#">
				<cfreportparam name="FechaHas" value="#LSdateformat(fechafinal, "DD/MM/YYYY")#">
				<cfif isdefined("rsSNCEdescripcion_orden") and rsSNCEdescripcion_orden.recordcount eq 1>
					<cfreportparam name="SNCEdescripcion_orden" value="#rsSNCEdescripcion_orden.SNCEdescripcion#">
				</cfif>
				<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
					<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
				</cfif>
				<cfif isdefined("P1")>
					<cfreportparam name="P1" value="#P1#">
				</cfif>		
				<cfif isdefined("P2")>
					<cfreportparam name="P2" value="#P2#">
				</cfif>		
				<cfif isdefined("P3")>
					<cfreportparam name="P3" value="#P3#">
				</cfif>
				<cfif isdefined("P4")>
					<cfreportparam name="P4" value="#P4#">
				</cfif>
				<cfif arguments.chk_cod_Direccion neq -1>
					<cfreportparam name="Tipo" value="1">
					<cfreportparam name="Titulo" value="Estado de Cuenta por Dirección del Socio">
				<cfelse>
					<cfreportparam name="Tipo" value="0">
					<cfreportparam name="Titulo" value="Estado de Cuenta de Socio">
				</cfif>
                
                <cfif isdefined("LvarLeyendaCxC") and len(trim(LvarLeyendaCxC))>
                    <cfreportparam name="LeyendaCxC" value="#LvarLeyendaCxC#">
                </cfif>
			</cfreport>
			</cfif>	
		</cfif>
	</cfif>
	<cfreturn 1>	
</cffunction>
