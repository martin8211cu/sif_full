<!---
	Importador de Aumentos
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
	Este archivo procesa los datos de entrada y genera el registro (s) de relación de aumentos correspondiente a los mismos.
 --->
 
<!--- DEFINICIONES INICIALES --->
<cf_dbfunction name="OP_concat" returnvariable="concat">
<cfscript>
	bcheck1 = false;
	bcheck2 = false;
	bcheck3 = false;
	bcheck4 = false;
	bcheck5 = false;
	bcheck6 = false;
	bcheck7 = false;
</cfscript>

<!--- VALIDACIONES --->
<!--- Check1. Validar Existencia del Empleado --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	select count(1) as check1
	from #table_name# a
	where not exists(
		select 1
		from DatosEmpleado b, LineaTiempo c
		where rtrim(ltrim(b.DEidentificacion)) = rtrim(ltrim(a.DEidentificacion))
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.DEid = c.DEid
		and a.FechaRige between c.LTdesde and c.LThasta
	)
</cfquery>

<cfset bcheck1 = rsCheck1.check1 LT 1>
<cfif bcheck1>
	<!--- Check2. Validar que no existan Empleados repetidos en el archivo --->
	<cfquery name="rsCheck2" datasource="#session.dsn#">
		select count(1) as check2
		from #table_name#
		group by DEidentificacion
		having count(1) > 1
	</cfquery>
	<cfset bcheck2 = rsCheck2.check2 LT 1>
	<cfif bcheck2>
		<!--- Check3. valida la existencia de los Componentes Salariales --->
		<cfquery name="rsCheck3a" datasource="#session.dsn#">
			select count(1) as check3a
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp1))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			) and a.Comp1 is not null
		</cfquery>
		<cfquery name="rsCheck3b" datasource="#session.dsn#">
			select count(1) as check3b
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp2))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			) and a.Comp2 is not null
		</cfquery>
		<cfquery name="rsCheck3c" datasource="#session.dsn#">
			select count(1) as check3c
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp3))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			) and a.Comp3 is not null
		</cfquery>
		<cfquery name="rsCheck3d" datasource="#session.dsn#">
			select count(1) as check3d
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp4))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			) and a.Comp4 is not null
		</cfquery>
		<cfquery name="rsCheck3e" datasource="#session.dsn#">
			select count(1) as check3e
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp5))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			) and a.Comp5 is not null
		</cfquery>
		<cfset bcheck3a = rsCheck3a.check3a LT 1>
		<cfset bcheck3b = rsCheck3b.check3b LT 1>
		<cfset bcheck3c = rsCheck3c.check3c LT 1>
		<cfset bcheck3d = rsCheck3d.check3d LT 1>
		<cfset bcheck3e = rsCheck3e.check3e LT 1>
		
		<cfif bcheck3a and bcheck3b and bcheck3c and bcheck3d and bcheck3e>
			<!--- Check4. Validar que no existan montos negativos en los datos a importar --->
			<cfquery name="rsCheck4" datasource="#session.dsn#">
				select count(1) as check4
				from #table_name#
				where Monto1 < 0.00 or Monto2 < 0.00 or Monto3 < 0.00 or Monto4 < 0.00 or Monto5 < 0.00 
			</cfquery>
			<cfset bcheck4 = rsCheck4.check4 LT 1>
			<cfif bcheck4>
				<!--- Check5. Validar que el tipo de accion exista --->
				<cfquery name="rsCheck5" datasource="#session.dsn#">
					select count(1) as check5
					from #table_name# a
					where not exists (
						select 1 
						from RHTipoAccion rh 
						where rh.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHTcomportam=6 
						and  rtrim(ltrim(RHTcodigo)) = rtrim(ltrim(a.TipoAccion))
					)
				</cfquery>
				<cfset bcheck5 = rsCheck5.check5 LT 1> 
				<cfif bcheck5>
				<!--- Check6. Validar que existan componentes repetidos --->
					<cfquery name="rsCheck6" datasource="#session.dsn#">
						select count(1) as check6
						from #table_name# 
						where  rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp2))	   
							or rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp3))	   
							or rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp4))	   
							or rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp5))
							or rtrim(ltrim(Comp2)) = rtrim(ltrim(Comp3))	   
							or rtrim(ltrim(Comp2)) = rtrim(ltrim(Comp4))	   
							or rtrim(ltrim(Comp2)) = rtrim(ltrim(Comp5))	   
							or rtrim(ltrim(Comp3)) = rtrim(ltrim(Comp4))	   
							or rtrim(ltrim(Comp3)) = rtrim(ltrim(Comp5))	   
							or rtrim(ltrim(Comp5)) = rtrim(ltrim(Comp4)) 
					</cfquery>
					<cfset bcheck6 = rsCheck6.check6 LT 1>
					<cfif bcheck6>		
							<cfquery datasource="#session.dsn#" name="ComponentesPorEmpleado">
							select distinct de.DEidentificacion, cs.CScodigo
							from #table_name# a
								inner join DatosEmpleado de
									on rtrim(ltrim(de.DEidentificacion)) = rtrim(ltrim(a.DEidentificacion))
								inner join LineaTiempo lt
									on de.DEid=lt.DEid
									and de.Ecodigo=lt.Ecodigo
								inner join RHTipoAccion rh
									on lt.RHTid=rh.RHTid
								inner join DLineaTiempo dlt
									on lt.LTid=dlt.LTid     
								inner join ComponentesSalariales cs
									on lt.Ecodigo=cs.Ecodigo
									and dlt.CSid=cs.CSid    
							where lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.FechaRige between lt.LTdesde and coalesce(lt.LThasta,<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">)
							</cfquery>
							<!---<cfdump var="#ComponentesPorEmpleado#">--->
							<cfquery datasource="#session.dsn#" name="empleados">
							select DEidentificacion, Comp1, Comp2, Comp3, Comp4, Comp5 from #table_name#
							</cfquery>
								<!---<cfdump var="#empleados#">--->
							<cfset EmpleadosConProblemas = ArrayNew(1)>
							
							<cfloop query="empleados"><!--- loop de los empleados--->
								<cfset ProcesaEmpleado = empleados.DEidentificacion>
								<cfquery dbtype="query" name="ComponentesQueDebeTener">
									select distinct CScodigo from ComponentesPorEmpleado where DEidentificacion = '#ProcesaEmpleado#'
								</cfquery>
								<cfquery dbtype="query" name="ComponentesQueEstoyIngresando">
									select Comp1, Comp2, Comp3, Comp4, Comp5 from empleados where DEidentificacion = '#ProcesaEmpleado#'
								</cfquery>
								<!--- -------------------------valida todos los componentes que debe tener------------------>
								<cfset mensaje1="">	
								<cfloop query="ComponentesQueDebeTener"><!--- loop de todos los componentes que el empleado debe tener--->
										<cfset ok = false> <!---no existe--->
										<cfloop from="1" to="5" index="z"><!--- loop de los componentes que estoy ingresando--->
												<cfset CodigoComponente=Evaluate("ComponentesQueEstoyIngresando.Comp#z#")>
												<cfif trim(ComponentesQueDebeTener.CScodigo) eq trim(CodigoComponente) and len(trim(CodigoComponente)) GT 0>
														<cfset ok=true><!--- si existe--->
												</cfif>
										</cfloop>	
										<cfif ok eq false and len(trim(ComponentesQueDebeTener.CScodigo)) GT 0 >
											<cfset mensaje1 = listAppend(mensaje1, "<b>"&ComponentesQueDebeTener.CScodigo&"</b> ","¸")> 
										</cfif>	
								</cfloop><!--- loop de los componentes--->	
								
								<!--- -------------------------valida todos los componentes que SE ESTAN INGRESANDO tener------------------>
								<cfset mensaje2="">
								<cfloop from="1" to="5" index="z"><!--- loop de los componentes que estoy ingresando--->	
									<cfset CodigoComponente=Evaluate("ComponentesQueEstoyIngresando.Comp#z#")>
									<cfset ok = false> <!---no existe--->
										<cfloop query="ComponentesQueDebeTener"><!--- loop de todos los componentes que el empleado debe tener--->
												<cfif trim(ComponentesQueDebeTener.CScodigo) eq trim(CodigoComponente) and len(trim(CodigoComponente)) GT 0>
														<cfset ok=true><!--- si existe--->
												</cfif>
										</cfloop>	
									<cfif ok eq false and len(trim(CodigoComponente)) GT 0 >
										<cfset mensaje2 = listAppend(mensaje2, "<b>"&CodigoComponente&"</b> ","¸")> 
									</cfif>	
								</cfloop><!--- loop de los componentes--->	
								
								<cfset mensajeFinal="">
								<cfif len(trim(mensaje1)) GT 0>
									<cfset mensajeFinal=mensajeFinal & " debe tener los Componentes :"&mensaje1>
								</cfif>
								<cfif len(trim(mensaje2)) GT 0>
									<cfif len(trim(mensajeFinal)) GT 0>
										<cfset mensajeFinal=mensajeFinal & " y ">
									</cfif>
									<cfset mensajeFinal=mensajeFinal & " No puede tener los Componentes :"&mensaje2>
								</cfif>
								
								<cfif len(trim(mensajeFinal)) GT 0>
									<cfset ArrayAppend(EmpleadosConProblemas, "El Empleado: <b>"& ProcesaEmpleado & "</b> "&mensajeFinal) >
								</cfif>
							</cfloop>
					</cfif> <!---Check6---> 
				</cfif> <!---Check5 --->
			</cfif><!--- Check4 --->
		</cfif><!--- Check3 --->
	</cfif><!--- Check2 --->
</cfif><!--- Check1 --->

<!--- ERRORES --->
<cfif not bcheck1>
	<cfquery name="ERR" datasource="#session.dsn#">
		select distinct 'Empleado no Existe o no esta Nombrado' as Error, DEidentificacion as Empleado
		from #table_name# a
		where not exists(
			select 1
			from DatosEmpleado b, LineaTiempo c
			where rtrim(ltrim(b.DEidentificacion)) = rtrim(ltrim(a.DEidentificacion))
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and b.DEid = c.DEid
			and a.FechaRige between c.LTdesde and c.LThasta
		)
	</cfquery>
<cfelseif not bcheck2>
	<cfquery name="ERR" datasource="#session.dsn#">
		select 'Empleado con mas de un Aumento Salarial. Identificación: <b>' #concat# DEidentificacion #concat# ' </b> ' as MSG,
				'FATAL' as LVL
		from #table_name#
		group by DEidentificacion
		having count(1) > 1	
	</cfquery>
<cfelseif not bcheck3a or not bcheck3b or not bcheck3c or not bcheck3d or not bcheck3e>
	<cfif not bcheck3a> 
		<cfquery name="ERR" datasource="#session.dsn#">
			select 'Códigos de Componentes Salariales Inválidos.  Identificación: <b>' #concat# a.DEidentificacion #concat#'</b>. Codigo Componente 1: <b>' #concat# a.Comp1 #concat# '</b>' as MSG,
					'FATAL' as LVL
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp1))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			) and a.Comp1 is not null
		</cfquery>
	</cfif>
	<cfif not bcheck3b> 
		<cfquery name="ERR" datasource="#session.dsn#">
			select 'Códigos de Componentes Salariales Inválidos.  Identificación: <b>' #concat# a.DEidentificacion #concat#'</b>. Codigo Componente 2: <b>' #concat# a.Comp2 #concat# '</b>' as MSG,
					'FATAL' as LVL
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp2))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			)and a.Comp2 is not null
		</cfquery>
	</cfif>
	<cfif not bcheck3c> 
		<cfquery name="ERR" datasource="#session.dsn#">
			select 'Códigos de Componentes Salariales Inválidos.  Identificación: <b>' #concat# a.DEidentificacion #concat#'</b>. Codigo Componente 3: <b>' #concat# a.Comp3 #concat# '</b>' as MSG,
					'FATAL' as LVL
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp3))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			)and a.Comp3 is not null
		</cfquery>
	</cfif>
	<cfif not bcheck3d> 
		<cfquery name="ERR" datasource="#session.dsn#">
			select 'Códigos de Componentes Salariales Inválidos.  Identificación: <b>' #concat# a.DEidentificacion #concat#'</b>. Codigo Componente 4: <b>' #concat# a.Comp4 #concat# '</b>' as MSG,
					'FATAL' as LVL
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp4))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			)and a.Comp4 is not null
		</cfquery>
	</cfif>
	<cfif not bcheck3e> 
		<cfquery name="ERR" datasource="#session.dsn#">
			select 'Códigos de Componentes Salariales Inválidos.  Identificación: <b>' #concat# a.DEidentificacion #concat#'</b>. Codigo Componente 5: <b>' #concat# a.Comp5 #concat# '</b>' as MSG,
					'FATAL' as LVL
			from #table_name# a
			where not exists(
					select 1
					from ComponentesSalariales b
					where rtrim(ltrim(b.CScodigo)) = rtrim(ltrim(a.Comp5))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			)and a.Comp5 is not null
		</cfquery>
	</cfif>
<cfelseif not bcheck4>
	<cfquery name="ERR" datasource="#session.dsn#">
		select 'Aumento NO puede ser negativo. Identificación: <b>' #concat# DEidentificacion 
			#concat# '</b>. '#concat#Comp1#concat#': <b>' #concat# <cf_dbfunction name='to_char' args='Monto1'> 
			#concat# '</b>  '#concat#Comp2#concat#': <b>' #concat# <cf_dbfunction name='to_char' args='Monto2'> 
			#concat# '</b>  '#concat#Comp3#concat#': <b>' #concat# <cf_dbfunction name='to_char' args='Monto3'> 
			#concat# '</b>  '#concat#Comp4#concat#': <b>' #concat# <cf_dbfunction name='to_char' args='Monto4'>
			#concat# '</b>  '#concat#Comp5#concat#': <b>' #concat# <cf_dbfunction name='to_char' args='Monto5'> #concat#'</b>'
			as MSG,
				'FATAL' as LVL
		from #table_name#
		where Monto1 < 0.00 or Monto2 < 0.00 or Monto3 < 0.00 or Monto4 < 0.00 or Monto5 < 0.00
	</cfquery>

<cfelseif not bcheck5>
	<cfquery name="ERR" datasource="#session.dsn#">
		select distinct 'El código <b>'#concat# a.TipoAccion #concat# '</b> de la acción a utilizar No es de tipo CAMBIO o No existe en el Sistema. ' as MSG, 
				'FATAL' as LVL
		from #table_name# a
					where not exists (
						select 1 
						from RHTipoAccion rh 
						where rh.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and rh.RHTcomportam=6
						and  rtrim(ltrim(rh.RHTcodigo)) = rtrim(ltrim(a.TipoAccion))
					)
	</cfquery>


<cfelseif not bcheck6>

	<cfquery name="ERR" datasource="#session.dsn#">
		select 	distinct ' El registro para el empleado cédula <b>'#concat# DEidentificacion #concat#'</b> posee códigos de Componentes Salariales Repetidos' as MSG, 
				'FATAL' as LVL
				from #table_name# 
				where  rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp2))	   
					or rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp3))	   
					or rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp4))	   
					or rtrim(ltrim(Comp1)) = rtrim(ltrim(Comp5))
					or rtrim(ltrim(Comp2)) = rtrim(ltrim(Comp3))	   
					or rtrim(ltrim(Comp2)) = rtrim(ltrim(Comp4))	   
					or rtrim(ltrim(Comp2)) = rtrim(ltrim(Comp5))	   
					or rtrim(ltrim(Comp3)) = rtrim(ltrim(Comp4))	   
					or rtrim(ltrim(Comp3)) = rtrim(ltrim(Comp5))	   
					or rtrim(ltrim(Comp5)) = rtrim(ltrim(Comp4)) 
	</cfquery>

<cfelseif arrayLen(EmpleadosConProblemas) GT 0>
		<cfset miquery="">
		<cfset tam=arrayLen(EmpleadosConProblemas)>
		<cfif tam GT 100>
			<cfset tam=100>
		</cfif>	
		<cfloop from="1" to="#tam#" index="miRow">			
			<cfif miRow gt 1>
			<cfset miquery=miquery &" union " >
			</cfif>
			<cfset miquery=miquery & "select '"&EmpleadosConProblemas[miRow]& "' as MSG, 'FATAL' as LVL from dual ">
		</cfloop>
	<cfquery name="ERR" datasource="#session.dsn#">
		#preservesinglequotes(miquery)#
	</cfquery>
</cfif>
<cfif not isdefined("ERR")>
<!--- IMPORTACION --->
	
	<!--- query para procesar los datos a insertar --->
	<!--- esto porque se requiere cortes por fecha --->
	<cfquery name="rsdatosaumento" datasource="#session.DSN#">
		select *
		from #table_name#
	</cfquery>

	<cftransaction>
	<cfoutput query="rsdatosaumento">
		<cfquery name="rs_aumento" datasource="#session.dsn#">
		insert into RHAcciones (DEid,RHTid,Ecodigo,Tcodigo,RVid,RHJid,Dcodigo,Ocodigo,RHPid,RHPcodigo,
		DLfvigencia,DLffin,DLsalario,DLobs,Usucodigo,Ulocalizacion,BMUsucodigo,RHAtipo, RHAporc, RHAporcsal)
		select 
		de.DEid,
		(select rh.RHTid 
			from RHTipoAccion rh 
			where rtrim(ltrim(rh.RHTcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsdatosaumento.TipoAccion)#"> 
			and rh.Ecodigo=de.Ecodigo 
			and  rh.RHTcomportam = 6 ),
		de.Ecodigo,dl.Tcodigo, dl.RVid,dl.RHJid,dl.Dcodigo,dl.Ocodigo,dl.RHPid,dl.RHPcodigo,
		<cfqueryparam cfsqltype="cf_sql_date" value="#rsdatosaumento.FechaRige#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">,
		dl.LTsalario,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsdatosaumento.Observaciones#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
		1,
		dl.LTporcplaza,
		dl.LTporcsal
		
		from DatosEmpleado de
			inner join LineaTiempo dl
				on de.DEid=dl.DEid
				and de.Ecodigo=dl.Ecodigo
		where rtrim(ltrim(de.DEidentificacion)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsdatosaumento.DEidentificacion)#">
		and de.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">

		and <cfqueryparam cfsqltype="cf_sql_date" value="#rsdatosaumento.FechaRige#"> between dl.LTdesde and coalesce(dl.LThasta,<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#"> )
			<cf_dbidentity1>
		</cfquery>
		
		<cf_dbidentity2 name="rs_aumento">
		<cfloop from="1" to="5" index="i">
			<cfset varMonto=Evaluate("rsdatosaumento.Monto#i#")>
			<cfset varComp=Evaluate("rsdatosaumento.Comp#i#")>
			<cfif len(trim(varMonto)) GT 0 and len(trim(varComp)) GT 0>
				<cfquery datasource="#session.dsn#">
				insert into RHDAcciones(RHAlinea,CSid,RHDAunidad,RHDAmontobase,RHDAmontores,Usucodigo,Ulocalizacion,BMUsucodigo)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_aumento.identity#">, 
							cs.CSid, 
							1, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#varMonto#"> as monto1, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#varMonto#"> as monto2, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					from ComponentesSalariales cs
					where ltrim(rtrim(cs.CScodigo)) =  <cfqueryparam cfsqltype="cf_sql_char" value="#trim(varComp)#">
					and cs.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
				</cfquery>
			</cfif>	
		</cfloop>
	</cfoutput>
	
	</cftransaction>
</cfif>