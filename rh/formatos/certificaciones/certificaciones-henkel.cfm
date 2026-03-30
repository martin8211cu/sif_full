<cf_dbtemp name="tbl_DatosPersonales" returnvariable="tbl_DatosPersonales" datasource="#session.dsn#">
	<cf_dbtempcol name="Ecodigo"						type="numeric"  		mandatory="no">
	<cf_dbtempcol name="DEid"							type="numeric"  		mandatory="no">
	<cf_dbtempcol name="Nombre"							type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="Apellido1"						type="varchar(80)"  	mandatory="no">
	<cf_dbtempcol name="Apellido2"						type="varchar(80)"  	mandatory="no">
	<cf_dbtempcol name="Edad"							type="integer" 			mandatory="no">
	<cf_dbtempcol name="EstadoCivil"					type="varchar(15)"  	mandatory="no">
	<cf_dbtempcol name="Nacionalidad"					type="varchar(15)"  	mandatory="no">
	<cf_dbtempcol name="Pais"							type="varchar(80)"  	mandatory="no">
	<cf_dbtempcol name="Sexo"							type="varchar(15)"  	mandatory="no">
	<cf_dbtempcol name="CodigoIGSS"						type="varchar(30)"  	mandatory="no">
	<cf_dbtempcol name="CodigoIRTRA"					type="varchar(30)"  	mandatory="no">
	<cf_dbtempcol name="CodigoNIT"						type="varchar(30)"  	mandatory="no">
	<cf_dbtempcol name="GrupoEtnico"					type="varchar(30)"  	mandatory="no">
	<cf_dbtempcol name="ApellidoCasada"					type="varchar(30)"  	mandatory="no">
	<cf_dbtempcol name="CodigoRegion"					type="varchar(10)"  	mandatory="no">
	<cf_dbtempcol name="DescRegion"						type="varchar(80)"  	mandatory="no">
	<cf_dbtempcol name="CodigoDpto"						type="varchar(10)"  	mandatory="no">    
	<cf_dbtempcol name="DescDpto"						type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="CodigoMunicipio"				type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="DescMunicipio"					type="varchar(100)"  	mandatory="no">        
	<cf_dbtempcol name="NumeroOrdenCedulaVecindad"		type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="NumeroRegistroCedulaVecindad"	type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="ExtedidaCedulaVecindad"			type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="GradoAcademico"					type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="info5"							type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="obs4"							type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="obs5"							type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="identificacion"					type="varchar(255)"  	mandatory="no">	
</cf_dbtemp>

<cf_dbtemp name="tbl_DatosLab1" returnvariable="tbl_DatosLab" datasource="#session.dsn#">
	<cf_dbtempcol name="DEid"					type="numeric"			mandatory="no">
	<cf_dbtempcol name="Ecodigo"				type="integer"  		mandatory="no">
	<cf_dbtempcol name="FechaInicioContrato"	type="varchar(15)"  	mandatory="no">
	<cf_dbtempcol name="FechaFinContrato"		type="varchar(15)"  	mandatory="no">
	<cf_dbtempcol name="DuracionContrato"		type="varchar(15)"  	mandatory="no">
	<cf_dbtempcol name="LTid"					type="numeric"  		mandatory="no">
	<cf_dbtempcol name="Departamento"			type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="CentroFuncional"		type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="Puesto"					type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="TipoJornada"			type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="HorarioTrabajo"			type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="TipoHorario"			type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="CompSalBase"			type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="SalarioBase"			type="money"		  	mandatory="no">
	<cf_dbtempcol name="CompBoni"				type="varchar(255)"  	mandatory="no">
	<cf_dbtempcol name="SalarioBoni"			type="money"  			mandatory="no">
	<cf_dbtempcol name="UltimoRCNid"			type="numeric"  		mandatory="no">
	<cf_dbtempcol name="FechaPrimerNomProm"		type="datetime"  		mandatory="no">
	<cf_dbtempcol name="FechaUltimaNomProm"		type="datetime"  		mandatory="no">
	<cf_dbtempcol name="CantSalariosProm"		type="integer"  		mandatory="no">
	<cf_dbtempcol name="PromedioOrdinario"		type="money"	  		mandatory="no">
	<cf_dbtempcol name="PromedioExtraordinario"	type="money"	  		mandatory="no">
	<cf_dbtempcol name="Comisiones6"			type="money"	  		mandatory="no">
	<cf_dbtempcol name="Extraordinario6"		type="money"	  		mandatory="no">
</cf_dbtemp>

<cfset pDEid = 0 >
<cfset pDEidentificacion = rsData.DEidentificacion >
<cfset pFecha 		 	 = rsData.fecha >
<cfset pFechaFormato 	 = LSDateFormat(pFecha, 'dd/mm/yyyy') >

<cfquery name="rs_idempleado" datasource="#session.DSN#">
	select DEid 
	from DatosEmpleado
	where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif len(trim(rs_idempleado.DEid)) >
	<cfset pDEid = rs_idempleado.DEid >
</cfif>

<!--- 1. Datos Personales--->
<!--------------------------------------------------------------------------------------------------
-- Incluir Todos los Datos de los Empleados (Situacion Persona)
-------------------------------------------------------------------------------------------------->

<cfset fecha_hoy = LSDateFormat(now(), 'dd/mm/yyyy')>
<!--- <cf_dbfunction name="datediff" args="DEfechanac,'#fecha_hoy#',yy" returnvariable="vEdad"> --->
 <cfset vEdad= "DateDiff('YYYY', DEfechanac, now())"> 
<cfquery datasource="#session.DSN#">
	insert into #tbl_DatosPersonales#( Ecodigo, 
										 DEid, 
										 Nombre,
										 Apellido1,
										 Apellido2,
										 Edad,
										 EstadoCivil,
										 Nacionalidad, 
										 Pais,
	 									 Sexo, 
										 CodigoIGSS, 
										 CodigoIRTRA,
										 CodigoNIT,
										 GrupoEtnico, 
										 ApellidoCasada,
										 CodigoRegion,
										 DescRegion,
	 									 CodigoDpto,
										 DescDpto,
										 CodigoMunicipio,
										 DescMunicipio,
										 NumeroOrdenCedulaVecindad,
	 									 NumeroRegistroCedulaVecindad,
										 ExtedidaCedulaVecindad,
										 GradoAcademico,
										 info5, 
										 obs4, 
										 obs5,
										 identificacion )
	select 	Ecodigo,
		   	DEid,
		   	coalesce(DEnombre,' ') as Nombre,
			coalesce(DEapellido1,' ') as Apellido1,
			coalesce(DEapellido2,' ') as Apellido2,
			#preservesinglequotes(vEdad)# as Edad,
			(case a.DEcivil when 0 then 'Soltero'
							when 1 then 'Casado'        
							when 2 then 'Divorciado'        
							when 3 then 'Viudo'                
							when 4 then 'Separado'                
							when 5 then 'Union Libre'                                
							else 'Extranjero'
							end )  as EstadoCivil,
			(case a.Ppais 
				when 'GT' then 'Guatemalteco'
				else 'Extranjero'
				end ) as Nacionalidad,
			coalesce(b.Pnombre,'No Indicado') as Pais,
			(case a.DEsexo when 'M' then 'Masculino'
						   else 'Femenino' end) as Sexo,
			coalesce(a.DEdato1,'') as CodigoIGSS,
			coalesce(a.DEdato2,'') as CodigoIRTRA,
			coalesce(a.DEdato3,'') as CodigoNIT,
			(case rtrim(ltrim(coalesce(a.DEdato4,'0'))) when '0' then 'Indígena'
														else 'No Indígena' end)  as GrupoEtnico,
			coalesce(a.DEdato5,' ') as ApellidoCasada,
			<cfif ListFind('sybase,sqlserver', Application.dsinfo[session.dsn].type)>
				case when charindex('.', a.DEinfo1) > 1 then substring( a.DEinfo1, 1, charindex('.',a.DEinfo1)-1) else null end  as CodigoRegion,
				case when charindex('.', a.DEinfo1) > 1 then substring( a.DEinfo1, charindex('.',a.DEinfo1)+1, char_length(a.DEinfo1) ) else null end  as DescRegion,
				case when charindex('.', a.DEinfo2) > 1 then substring( a.DEinfo2, 1, charindex('.',a.DEinfo2)-1) else null end  as CodigoDpto,
				case when charindex('.', a.DEinfo2) > 1 then substring( a.DEinfo2, charindex('.',a.DEinfo2)+1, char_length(a.DEinfo2) ) else null end  as DescDpto,
				case when charindex('.', a.DEinfo3) > 1 then substring( a.DEinfo3, 1, charindex('.',a.DEinfo3)-1) else null end  as CodigoMunicipio,
				case when charindex('.', a.DEinfo3) > 1 then substring( a.DEinfo3, charindex('.',a.DEinfo3)+1, char_length(a.DEinfo3) ) else null end  as DescMunicipio,
			<cfelseif ListFind('oracle', Application.dsinfo[session.dsn].type) >
				coalesce(substr(a.DEinfo1,0,instr(a.DEinfo1,'.',1)-1), '') as CodigoRegion,
				coalesce(substr(a.DEinfo1,instr(a.DEinfo1,'.',1)+1), '') as DescRegion,
				coalesce(substr(a.DEinfo2,0,instr(a.DEinfo2,'.',1)-1), '') as CodigoDpto,
				coalesce(substr(a.DEinfo2,instr(a.DEinfo2,'.',1)+1), '') as DescDpto,
				coalesce(substr(a.DEinfo3,0,instr(a.DEinfo3,'.',1)-1), '') as CodigoMunicipio,
				coalesce(substr(a.DEinfo3,instr(a.DEinfo3,'.',1)+1), '') as DescMunicipio,    
			<cfelse>
				null,
				null,
				null,
				null,
				null,
				null,
			</cfif>				
			coalesce(a.DEobs1, '') as NumeroOrdenCedulaVecindad,                
			coalesce(a.DEobs2, '') as NumeroRegistroCedulaVecindad,    
			coalesce(a.DEobs3, '') as ExtendidaCedulaVecindad,
			a.DEinfo4,
			a.DEinfo5, 
			a.DEobs4, 
			a.DEobs5,
			a.DEidentificacion

	from DatosEmpleado a 
	
	left outer join Pais b 
	on b.Ppais = a.Ppais
			
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pDEid#">
</cfquery>

<!--- Empleados Activos --->
<cfquery name="consulta" datasource="#session.DSN#">
	insert into #tbl_DatosLab#( DEid, 
								Ecodigo, 
								FechaInicioContrato, 
								FechaFinContrato,  
								DuracionContrato, 
								Departamento, 
								CentroFuncional, 
								Puesto, 
								TipoJornada,
								HorarioTrabajo, 
								TipoHorario )
	select distinct de.DEid, 
					de.Ecodigo, 
					<cf_dbfunction name="date_format" args="dle.DLfvigencia,dd/mm/yyyy"> as FechaInicioContrato,
                    ( case when dle.DLffin > <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(2050, 1,1)#"> then '#pFechaFormato#'
                           else <cf_dbfunction name="date_format" args="dle.DLffin,dd/mm/yyyy">
                      end ) as FechaFinContrato, 
                     ( case when dle.DLffin > <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(2050, 1,1)#"> then 'Indefinido'
							else <cf_dbfunction name="date_format" args="dle.DLffin,dd/mm/yyyy">
					   end ) as DuracionContrato,                       
                      coalesce(dpto.Ddescripcion, 'No determinado') as Departamento,
                      coalesce(cf.CFdescripcion, 'No determinado') as CentroFuncional,
                      coalesce(rhpu.RHPdescpuesto, 'No determinado') as Puesto,
                      ( case rhj.RHJcodigo when 'G2' then 'Discontinua'
                            			   else 'Continua' 
                        end) as TipoJornada,                       
                      ( case rhj.RHJcodigo 
                            when 'G2' then 'de Lunes a Viernes de 7 am a 4 pm  y Sábados de 7 am a 11 pm'
                            else ' de Lunes a Viernes de 7 am a 4 pm '
                        end) as HorarioTrabajo,                                                   
                      ( case rhj.RHJcodigo when 'G2' then 'Diurno'
                            			   else 'Diurno'
                        end) as TipoHorario   

	from DatosEmpleado de 

    inner join LineaTiempo lt
    	on de.Ecodigo = lt.Ecodigo
	  	and de.DEid=lt.DEid
		and lt.LTdesde = (select max(LTdesde) 
						from LineaTiempo a 
						where a.DEid = lt.DEid)

	inner join  RHPlazas rhp
		on lt.RHPid=rhp.RHPid
		
	inner join RHPuestos rhpu
	on rhp.RHPpuesto=rhpu.RHPcodigo
	and rhpu.Ecodigo = de.Ecodigo

	inner join CFuncional cf
	on cf.CFid=rhp.CFid
	and cf.Ecodigo = de.Ecodigo

	inner join Oficinas ofi
	on ofi.Ocodigo=cf.Ocodigo
	and ofi.Ecodigo = de.Ecodigo

	inner join Departamentos dpto
	on dpto.Dcodigo=cf.Dcodigo
	and dpto.Ecodigo =de.Ecodigo
	
	inner join RHJornadas rhj
	on lt.RHJid=rhj.RHJid

	inner join EVacacionesEmpleado eve
	on eve.DEid=de.DEid

	inner join DLaboralesEmpleado dle
	on dle.DEid=de.DEid
	and dle.DLlinea = (select max(DLlinea) from DLaboralesEmpleado a inner join RHTipoAccion b on b.RHTid = a.RHTid where a.DEid = de.DEid and b.RHTcomportam = 1) 

	inner join RHTipoAccion rht
	on dle.RHTid=rht.RHTid
	and rht.RHTcomportam = 1 	<!---Nombramiento--->

	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pDEid#">
</cfquery>

<!--- Actualiza la Información del Sistema con La Fecha de Contratación mas Reciente según la Fecha que se Recibe --->
<cfquery datasource="#session.DSN#">
	update #tbl_DatosLab# 
	set FechaInicioContrato = ( select case when max(dle.DLfvigencia) is not null then <cf_dbfunction name="date_format" args="max(dle.DLfvigencia),dd/mm/yyyy" > else '01/01/6100' end
							 	from DLaboralesEmpleado dle, RHTipoAccion rhta
							 	where dle.DEid = #tbl_DatosLab#.DEid
							 	  and dle.RHTid = rhta.RHTid
							 	  and rhta.RHTcomportam = 1  <!--- Accion de Nombramiento --->
							 	  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between dle.DLfvigencia and coalesce(dle.DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,1,1)#"> )
								  and dle.DLlinea = (select max(DLlinea) from DLaboralesEmpleado a inner join RHTipoAccion b on b.RHTid = a.RHTid where a.DEid = dle.DEid and b.RHTcomportam = 1) 

							 ),
		FechaFinContrato = ( select case when max(dle.DLffin) is not null then <cf_dbfunction name="date_format" args="max(dle.DLffin),dd/mm/yyyy" > else '01/01/6100' end
							 from DLaboralesEmpleado dle, RHTipoAccion rhta
							 where dle.DEid = #tbl_DatosLab#.DEid
							   and dle.RHTid = rhta.RHTid
							   and rhta.RHTcomportam = 1  <!--- Accion de Nombramiento --->
							   and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between dle.DLfvigencia and coalesce(dle.DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,1,1)#">)
							 ),
		DuracionContrato = 'a la fecha'
	where exists (	select 1
				 	from DLaboralesEmpleado dle, RHTipoAccion rhta
				 	Where dle.DEid = #tbl_DatosLab#.DEid
				 	 and dle.RHTid = rhta.RHTid
				 	 and rhta.RHTcomportam = 1  <!--- Accion de Nombramiento --->
				 	 and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between dle.DLfvigencia and coalesce(dle.DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,1,1)#">)
				)
</cfquery>


<!--- Actualiza la Tabla con la Máxima LineaTiempo que tenga el Empleado--->
<cfquery datasource="#session.DSN#">
	update #tbl_DatosLab#
	set LTid = ( select max(LTid) 
    			 from LineaTiempo lt
    			 where lt.DEid = #tbl_DatosLab#.DEid )
	where exists( select 1
              	  from LineaTiempo lt
              	  where lt.DEid = #tbl_DatosLab#.DEid )
</cfquery>        

<!--- Actualiza la Fecha Fin de Contratatación si la Linea de Tiempo es menor a la Fecha de la Certificación--->
<cfquery datasource="#session.DSN#">
	update #tbl_DatosLab# 
	set FechaFinContrato = ( select coalesce(<cf_dbfunction name="date_format" args="LThasta,dd/mm/yyyy" >, '01/01/6100')
							 from LineaTiempo lt
							 where #tbl_DatosLab#.LTid=lt.LTid
							   and #tbl_DatosLab#.DEid=lt.DEid
							   and lt.LThasta < <cf_dbfunction name="to_date" args="#tbl_DatosLab#.FechaFinContrato">
							   and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,1,1)#">),
		DuracionContrato = ( select coalesce(<cf_dbfunction name="date_format" args="LThasta,dd/mm/yyyy" >, '01/01/6100')
							 from LineaTiempo lt
							 where #tbl_DatosLab#.LTid=lt.LTid
							   and #tbl_DatosLab#.DEid=lt.DEid
							   and lt.LThasta < <cf_dbfunction name="to_date" args="#tbl_DatosLab#.FechaFinContrato">
							   and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,1,1)#">)
	where exists( select 1
              	  from LineaTiempo lt
                  where lt.LTid = #tbl_DatosLab#.LTid
                    and lt.DEid = #tbl_DatosLab#.DEid
                    and lt.LThasta < <cf_dbfunction name="to_date" args="#tbl_DatosLab#.FechaFinContrato">
                    and lt.LThasta < <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,1,1)#">)
</cfquery>				

<!---Modificar Duración Contrato para aquellos nombramientos que se saben que son hasta nueva orden--->
<cfquery datasource="#session.DSN#">
	update #tbl_DatosLab#
	set FechaFinContrato = '#pFechaFormato#',
		DuracionContrato = 'Indefinido'
	where <cf_dbfunction name="to_date" args="FechaFinContrato"> > <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(2050,1,1)#">
</cfquery>

<!--- Actualizo la Ultima Informacion del empleado según su Linea del Tiempo --->
<cfquery datasource="#session.DSN#">
	update #tbl_DatosLab#
	set Departamento= ( select coalesce(dpto.Ddescripcion,'No determinado')
						from Departamentos dpto 

						inner join CFuncional cf
						on dpto.Dcodigo = cf.Dcodigo
						and dpto.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						
						inner join RHPlazas rhp
						on rhp.CFid = cf.CFid
						
						inner join LineaTiempo lt
						on lt.RHPid = rhp.RHPid
						
						where lt.LTid = #tbl_DatosLab#.LTid ),

			CentroFuncional = ( select coalesce(cf.CFdescripcion,'No determinado') 
						   		from CFuncional cf 
								
								inner join RHPlazas rhp
						   		on rhp.CFid=cf.CFid
						   
						   		inner join LineaTiempo lt
						   		on lt.RHPid=rhp.RHPid
						   
						   where lt.LTid = #tbl_DatosLab#.LTid ),

			Puesto = ( select coalesce(rhpp.RHPdescpuesto,'No determinado')
					   from CFuncional cf 
					   
					   inner join RHPlazas rhp
					   on rhp.CFid = cf.CFid
					   
					   inner join RHPuestos rhpp
					   on rhp.RHPpuesto = rhpp.RHPcodigo
					   and rhpp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

					   inner join LineaTiempo lt
					   on lt.RHPid = rhp.RHPid
					   where lt.LTid = #tbl_DatosLab#.LTid ),

			TipoJornada=( select case rhj.RHJcodigo when 'G2' then 'Continua' else 'Discontinua' end
						  from RHJornadas rhj 
						  
						  inner join LineaTiempo lt
						  on lt.RHJid =rhj.RHJid
						  
						  where lt.LTid = #tbl_DatosLab#.LTid ),

			HorarioTrabajo = ( select case rhj.RHJcodigo when 'G2' then 'de Lunes a Viernes de 7 am a 4 pm  y Sábados de 7 am a 11 pm' else 'de Lunes a Viernes de 7 am a 4 pm' end
								from RHJornadas rhj 
								
								inner join LineaTiempo lt
								on lt.RHJid =rhj.RHJid
								
								where #tbl_DatosLab#.LTid = lt.LTid),

			TipoHorario = ( select case rhj.RHJtipo when 0 then 'Diurno' when 1 then 'Mixta' else 'Nocturna' end
							from RHJornadas rhj 
							
							inner join LineaTiempo lt
							on lt.RHJid =rhj.RHJid
							
							where #tbl_DatosLab#.LTid = lt.LTid)
</cfquery>						
                            
<cfquery datasource="#session.DSN#">
	update #tbl_DatosLab#
	set CompSalBase = ( select cs.CSdescripcion
                   		from ComponentesSalariales cs, DLineaTiempo dlt, LineaTiempo lt
                        where cs.CSsalariobase = 1 
						  and cs.CSid = dlt.CSid
                          and dlt.LTid = lt.LTid
						  and lt.LTid = #tbl_DatosLab#.LTid  ),

    SalarioBase= ( select dlt.DLTmonto
                   from ComponentesSalariales cs, DLineaTiempo dlt, LineaTiempo lt 
				   where cs.CSsalariobase = 1
					 and cs.CSid = dlt.CSid
                     and dlt.LTid = lt.LTid
				     and lt.LTid = #tbl_DatosLab#.LTid ),
    CompBoni = ( select cs.CSdescripcion
                 from ComponentesSalariales cs, DLineaTiempo dlt, LineaTiempo lt
				 where cs.CScodigo in (	select CScodigo
										from ComponentesSalariales a, RHComponentesAgrupados b
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and a.CSsalariobase = 0
										  and a.CAid = b.RHCAid
										  and b.RHCAmComponenteExclu = 1 )
                   and cs.CSid=dlt.CSid
				   and dlt.LTid=lt.LTid
				   and lt.LTid = #tbl_DatosLab#.LTid ),
	SalarioBoni = ( select dlt.DLTmonto
                    from ComponentesSalariales cs, DLineaTiempo dlt, LineaTiempo lt 
					where lt.LTid = #tbl_DatosLab#.LTid
                      and cs.CScodigo in (	select CScodigo
											from ComponentesSalariales a, RHComponentesAgrupados b
											where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  and a.CSsalariobase = 0
											  and a.CAid = b.RHCAid
											  and b.RHCAmComponenteExclu = 1 )
                      and cs.CSid = dlt.CSid
                      and dlt.LTid=lt.LTid ),

	UltimoRCNid = ( select max(hrcn.RCNid)
                    from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp
                    where hse.DEid = #tbl_DatosLab#.DEid
                     and hrcn.RCNid = hse.RCNid
                     and hrcn.RCNid = cp.CPid
                     and cp.CPtipo = 0),

	FechaUltimaNomProm = ( select max(hrcn.RChasta)
                           from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp
                           where hse.DEid = #tbl_DatosLab#.DEid
                        	and hrcn.RCNid = hse.RCNid
                        	and hrcn.RCNid = cp.CPid
                        	and cp.CPtipo = 0)
</cfquery>						

<!--- Estimo cuantos Salarios voy a promediar--->
<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set CantSalariosProm = ( select case when count(1) > 6 then 6 else count(1) end  
                          	 from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp
                          	 where hse.DEid = #tbl_DatosLab#.DEid
                              and hrcn.RCNid = hse.RCNid
                              and hrcn.RCNid <= #tbl_DatosLab#.UltimoRCNid
                              and hrcn.RCNid = cp.CPid
                              and cp.CPtipo = 0)
</cfquery>							

<!--- Fecha de la PrimeraNomina --->
<cf_dbfunction name="dateadd" args="(#tbl_DatosLab#.CantSalariosProm*30), #tbl_DatosLab#.FechaUltimaNomProm" returnvariable="dif">
<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set FechaPrimerNomProm = (case when #tbl_DatosLab#.FechaUltimaNomProm is not null then #dif# else FechaPrimerNomProm end)
</cfquery>	

<!--- Sumo los Salarios y HOras Normales de esos Periodos y lo divido entre la Cantidad de Periodos a Usar --->
<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set PromedioOrdinario = ( select sum(hse.SEsalariobruto)
                              from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp
                              where hse.DEid = #tbl_DatosLab#.DEid
                               and hrcn.RCNid = hse.RCNid
                               and hrcn.RCNid = cp.CPid
                               and cp.CPtipo = 0
                               and hrcn.RCdesde between #tbl_DatosLab#.FechaPrimerNomProm and #tbl_DatosLab#.FechaUltimaNomProm )
</cfquery>													

<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set PromedioOrdinario = PromedioOrdinario + (	select coalesce(sum(hic.ICmontores), 0)
													from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp, HIncidenciasCalculo hic, CIncidentes ci
													where hse.DEid = #tbl_DatosLab#.DEid
													 and hrcn.RCNid = hse.RCNid
													 and hrcn.RCNid = cp.CPid
													 and cp.CPtipo = 0
													 and hse.DEid = hic.DEid
													 and hse.RCNid = hic.CIid
													 and hic.CIid = ci.CIid
													 and ( 
													 
													 ci.CIcodigo in ('1010','011','010','RVACA')
													 or ci.CIcodigo in ('1010','011','010','RVACA')
													 or ci.CIcodigo in ('1010','011','010','RVACA')
													 
													 
													 
													 
													 )
													 
													 
													 
													 
													 and hrcn.RCdesde between #tbl_DatosLab#.FechaPrimerNomProm and #tbl_DatosLab#.FechaUltimaNomProm )
</cfquery>													
													
<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set PromedioExtraordinario = ( select coalesce(sum(hic.ICmontores),0)
                            	   from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp, HIncidenciasCalculo hic, CIncidentes ci
                            	   where hse.DEid = #tbl_DatosLab#.DEid
									and hrcn.RCNid = hse.RCNid
									and hrcn.RCNid = cp.CPid
									and cp.CPtipo = 0
									and hse.DEid = hic.DEid
									and hse.RCNid = hic.RCNid
									and hic.CIid = ci.CIid
									and rtrim(ltrim(ci.CIcodigo)) in (	select CIcodigo
																		from CIncidentes
																		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		  and CItipo = 0
																		  and CIfactor != 1
																		  and CIcarreracp = 0 )
									and hrcn.RCdesde between #tbl_DatosLab#.FechaPrimerNomProm and #tbl_DatosLab#.FechaUltimaNomProm)
</cfquery>													


<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set Extraordinario6 = ( select coalesce(sum(hic.ICmontores),0)
                            	   from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp, HIncidenciasCalculo hic, CIncidentes ci
                            	   where hse.DEid = #tbl_DatosLab#.DEid
									and hrcn.RCNid = hse.RCNid
									and hrcn.RCNid = cp.CPid
									and cp.CPtipo = 0
									and hse.DEid = hic.DEid
									and hse.RCNid = hic.RCNid
									and hic.CIid = ci.CIid
									and rtrim(ltrim(ci.CIcodigo)) in ('AHE','003','0031','004')
									and hrcn.RCdesde between 
									<cf_dbfunction name="dateaddx" args="mm, -6, #tbl_DatosLab#.FechaUltimaNomProm">	 and #tbl_DatosLab#.FechaUltimaNomProm)
</cfquery>	

<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set Comisiones6 = ( select coalesce(sum(hic.ICmontores),0)
                            	   from HRCalculoNomina hrcn, HSalarioEmpleado hse, CalendarioPagos cp, HIncidenciasCalculo hic, CIncidentes ci
                            	   where hse.DEid = #tbl_DatosLab#.DEid
									and hrcn.RCNid = hse.RCNid
									and hrcn.RCNid = cp.CPid
									and hse.DEid = hic.DEid
									and hse.RCNid = hic.RCNid
									and hic.CIid = ci.CIid
									and rtrim(ltrim(ci.CIcodigo)) in ('2010')
									and hrcn.RCdesde between 
									<cf_dbfunction name="dateaddx" args="mm, -6, #tbl_DatosLab#.FechaUltimaNomProm">	 and #tbl_DatosLab#.FechaUltimaNomProm)
</cfquery>	


<cfquery datasource="#session.DSN#">
    update #tbl_DatosLab#
    set PromedioOrdinario=case when CantSalariosProm > 0 then PromedioOrdinario/CantSalariosProm else null end,
        PromedioExtraordinario=case when CantSalariosProm > 0 then PromedioExtraordinario/CantSalariosProm else null end
</cfquery>

<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fecha_hoy_letras">
	<cfinvokeargument name="Fecha" value="#lsdateformat(rsdata.fecha, 'dd/mm/yyyy')#">
</cfinvoke>	

<!--- este query solo devuelve un registro, pues son los calculos para un empleado --->
<cfquery name="rs_formatear" datasource="#session.DSN#">
	select FechaInicioContrato, FechaFinContrato
	from #tbl_DatosLab#
</cfquery>

<cfset FechaInicioContrato_letras = '' >
<cfset FechaFinContrato_letras = '#pFechaFormato#' >
<cfif LSIsDate(trim(rs_formatear.FechaInicioContrato)) >
	<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="FechaInicioContrato_letras">
		<cfinvokeargument name="Fecha" value="#rs_formatear.FechaInicioContrato#">
	</cfinvoke>	
</cfif>
<cfif LSIsDate(trim(rs_formatear.FechaFinContrato)) >
	<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="FechaFinContrato_letras">
		<cfinvokeargument name="Fecha" value="#rs_formatear.FechaFinContrato#">
	</cfinvoke>	
</cfif>

<cfquery name="mes" datasource="#session.DSN#">
	select Icodigo, b.VSvalor as v, VSdesc as m
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Idioma#">
	and b.VSvalor='#month(now())#'
	order by b.VSvalor
</cfquery>	

<cfset dia_hoy = day(now()) >
<cfset mes_hoy = mes.m >
<cfset periodo_hoy = year(now()) >

<!--- se deben formatear los montos y dejarlos con dos decimales --->
<cfquery name="rsQueryFormatos" datasource="#session.DSN#">
	select SalarioBase, SalarioBoni, PromedioOrdinario, PromedioExtraordinario,Comisiones6/6 as Comisiones6,Extraordinario6/6 as Extraordinario6, SalarioBase+SalarioBoni as total_salario, 
	SalarioBase+SalarioBoni+(Comisiones6/6)+(Extraordinario6/6) as TotalSalarioEC,
	SalarioBase+SalarioBoni+(Comisiones6/6) as TotalSalarioC,
	SalarioBase+SalarioBoni+(Extraordinario6/6) as TotalSalarioE
	from #tbl_DatosLab#
</cfquery>

<!--- datos del usuario que genera --->
<cfquery name="rs_usuario" datasource="#session.DSN#">
	select Pnombre as nombre, Papellido1 as apellido1, Papellido2 as apellido2
	from Usuario u, DatosPersonales dp
	where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	and dp.datos_personales = u.datos_personales
</cfquery>
<cfset usuario = trim(rs_usuario.nombre) & ' ' & trim(rs_usuario.apellido1) & ' ' & trim(rs_usuario.apellido2) >

<!--- Puesto del usuario que genera la solicitud (solo si es empleado) --->

<!--- usuario que genera es un empleado --->
<cfquery name="rs_empleado" datasource="asp">
	select llave as DEid
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	  and STabla = 'DatosEmpleado'
</cfquery>
<cfset v_DEid = 0 >
<cfif len(trim(rs_empleado.DEid)) >
	<cfset v_DEid = rs_empleado.DEid >
</cfif>

<!--- si el usuario que genera es un empleado, recupera su puesto --->
<cfquery name="rs_puesto_usuario" datasource="#session.DSN#">
	select lt.RHPcodigo, p.RHPdescpuesto as puesto_usuario_que_genera
	from LineaTiempo lt, RHPuestos p
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_DEid#">
	  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.Ecodigo=lt.Ecodigo
	  and p.RHPcodigo=lt.RHPcodigo
</cfquery>

<cfset v_SalarioBase 			= 0.00 >
<cfset v_SalarioBoni 			= 0.00 >
<cfset v_PromedioOrdinario 		= 0.00 >
<cfset v_PromedioExtraordinario = 0.00 >
<cfset v_total_salario = 0.00 >

<cfif len(trim(rsQueryFormatos.SalarioBase)) >
	<cfset v_SalarioBase = LSNumberFormat(rsQueryFormatos.SalarioBase, ',9.00') >
</cfif> 

<cfif len(trim(rsQueryFormatos.SalarioBoni)) >
	<cfset v_SalarioBoni = LSNumberFormat(rsQueryFormatos.SalarioBoni, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.PromedioOrdinario)) >
	<cfset v_PromedioOrdinario = LSNumberFormat(rsQueryFormatos.PromedioOrdinario, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.PromedioExtraordinario)) >
	<cfset v_PromedioExtraordinario = LSNumberFormat(rsQueryFormatos.PromedioExtraordinario, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.total_salario)) >
	<cfset v_total_salario = LSNumberFormat(rsQueryFormatos.total_salario, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.Extraordinario6)) >
	<cfset v_Extraordinario= LSNumberFormat(rsQueryFormatos.Extraordinario6, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.Comisiones6)) >
	<cfset v_Comisiones = LSNumberFormat(rsQueryFormatos.Comisiones6, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.Comisiones6)) >
	<cfset v_Comisiones = LSNumberFormat(rsQueryFormatos.Comisiones6, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.TotalSalarioEC)) >
	<cfset v_TotalSalarioEC = LSNumberFormat(rsQueryFormatos.TotalSalarioEC, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.TotalSalarioE)) >
	<cfset v_TotalSalarioE = LSNumberFormat(rsQueryFormatos.TotalSalarioE, ',9.00') >
</cfif> 
<cfif len(trim(rsQueryFormatos.TotalSalarioC)) >
	<cfset v_TotalSalarioC = LSNumberFormat(rsQueryFormatos.TotalSalarioC, ',9.00') >
</cfif> 


<cfquery name="rsQuery" datasource="#session.DSN#">
    select 	a.Ecodigo,
			a.DEid,
			Ucase(a.Nombre) as Nombre,
			Ucase(a.Apellido1) as Apellido1,
			Ucase(a.Apellido2) as Apellido2,
			a.Edad,
			a.EstadoCivil,
			Ucase(a.Nacionalidad) as Nacionalidad,
			Ucase(a.Pais) as Pais,
			Ucase(a.Sexo) as Sexo,
			a.CodigoIGSS,
			a.CodigoIRTRA,
			a.CodigoNIT,
			a.GrupoEtnico,
			Ucase(a.ApellidoCasada) ApellidoCasada,
			Ucase(a.CodigoRegion) as CodigoRegion,
			Ucase(a.DescRegion) as DescRegion,
			Ucase(a.CodigoDpto) as CodigoDpto,
			Ucase(a.DescDpto) as DescDpto,
			Ucase(a.CodigoMunicipio) as CodigoMunicipio,  	
			Ucase(a.DescMunicipio) as DescMunicipio,
			a.NumeroOrdenCedulaVecindad,
			a.NumeroRegistroCedulaVecindad,
			a.ExtedidaCedulaVecindad,
			b.FechaInicioContrato,
			b.FechaFinContrato,
			'#FechaInicioContrato_letras#' as FechaInicioContrato_letras,
			'#FechaFinContrato_letras#' as FechaFinContrato_letras,
			b.DuracionContrato,
			b.LTid,
			Ucase(b.Departamento) as Departamento,
			Ucase(b.CentroFuncional) as CentroFuncional,
			Ucase(b.Puesto) as Puesto,
			Ucase(b.TipoJornada) as TipoJornada,  	
			Ucase(b.HorarioTrabajo) as HorarioTrabajo,  	
			Ucase(b.TipoHorario) as TipoHorario,  	
			Ucase(b.CompSalBase) as CompSalBase,  	
			b.SalarioBase as SalarioBase,
			b.CompBoni,  	
			b.SalarioBoni,
			b.UltimoRCNid,  		
			<cf_dbfunction name="date_format" args="b.FechaPrimerNomProm,dd/mm/yyyy" > as FechaPrimerNomProm,
			<cf_dbfunction name="date_format" args="b.FechaUltimaNomProm,dd/mm/yyyy" > as FechaUltimaNomProm,			
			b.CantSalariosProm,
			b.PromedioOrdinario,
			b.PromedioExtraordinario,
			'#Ucase(fecha_hoy_letras)#' as fecha_letras,
			'#lsdateformat(rsdata.fecha, 'dd/mm/yyyy')#' as fecha,
			'#dia_hoy#' as dia_hoy,
			'#mes_hoy#' as mes_hoy,
			'#periodo_hoy#' as periodo_hoy,
			'#LSTimeFormat(now(),'HH:MM')#' as hora,
			a.GradoAcademico,
			a.info5, 
			a.obs4, 
			a.obs5,
			a.identificacion,
			'#v_SalarioBase#' as SalarioBaseFormato,
			'#v_SalarioBoni#' as SalarioBoniFormato,
			'#v_PromedioOrdinario#' as PromedioOrdinarioFormato,
			'#v_PromedioExtraordinario#' as PromedioExtraordinarioFormato,
			'#rs_puesto_usuario.puesto_usuario_que_genera#' as puesto_usuario_que_genera,
			'#v_total_salario#' as total_salarioFormato,
			'#usuario#' as usuario,
			(Extraordinario6/6) as Extraordinario,
			(Comisiones6/6)  as Comisiones ,
			'#v_Extraordinario#' as ExtraordinarioFormato, 
			'#v_Comisiones#' as ComisionesFormato ,
			'#v_TotalSalarioEC#' as TotalSalario1ExCom,
			'#v_TotalSalarioE#' as TotalSalario1Ex,
			'#v_TotalSalarioC#' as TotalSalario1Com   
			
	from #tbl_DatosLab# b, #tbl_DatosPersonales# a
	where b.DEid=a.DEid
</cfquery>
