<!----Temporal con los datos---->
<cf_dbtemp name="tbl_principal" returnvariable="tbl_principal">
	<cf_dbtempcol name="DEid"				type="numeric"		mandatory="no">
	<cf_dbtempcol name="constante" 			type="varchar(1)"  	mandatory="no">
	<cf_dbtempcol name="NumEmpresa" 		type="varchar(5)"  	mandatory="no">
	<cf_dbtempcol name="NumEmpleado" 		type="varchar(5)"  	mandatory="no">
	<cf_dbtempcol name="NumSegSoc" 			type="varchar(8)"  	mandatory="no">
	<cf_dbtempcol name="Identificacion" 	type="varchar(15)" 	mandatory="no">
	<cf_dbtempcol name="Apellido1y2"		type="varchar(15)"	mandatory="no">
	<cf_dbtempcol name="Nombre"				type="varchar(15)"	mandatory="no">
	<cf_dbtempcol name="Sexo"				type="varchar(1)"	mandatory="no">	
	<cf_dbtempcol name="Excepciones"		type="varchar(2)"	mandatory="no">
	<cf_dbtempcol name="Departamento"		type="varchar(2)"	mandatory="no">
	<cf_dbtempcol name="ClaveIR"			type="varchar(2)"	mandatory="no">
	<cf_dbtempcol name="CodAjuste"			type="varchar(1)"	mandatory="no">
	<cf_dbtempcol name="Siacap"				type="varchar(3)"	mandatory="no">
	<cf_dbtempcol name="CedulaNueva"		type="varchar(15)"	mandatory="no">
	<cf_dbtempcol name="CodPasaporte"		type="varchar(1)"	mandatory="no">
	<cf_dbtempcol name="Observaciones"		type="varchar(30)"	mandatory="no">
	<cf_dbtempcol name="salario"			type="float"		mandatory="no">
	<cf_dbtempcol name="renta"				type="float"		mandatory="no">
	<cf_dbtempcol name="DecimoTMes"			type="float"		mandatory="no">
	<cf_dbtempcol name="OtrosIngresos"		type="float"		mandatory="no">
	<cf_dbtempcol name="DiasEnfermedad"		type="int"			mandatory="no">
</cf_dbtemp>

<cfset meses = ''>
<cfset lista_meses = ('Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre') >
<cfset meses = listgetat(lista_meses, form.mes) >
<cfset vd_primerdiames=CreateDate(form.periodo, form.mes, 1)>
<cfset vd_ultimodiames=CreateDate(form.periodo, form.mes,DaysInMonth("#vd_primerdiames#"))>

<cfquery name="rsDatos" datasource="#session.DSN#">
	insert into #tbl_principal#(DEid,constante,NumEmpresa,NumEmpleado,NumSegSoc,Identificacion,Apellido1y2,Nombre,Sexo,
								Excepciones,Departamento,ClaveIR,CodAjuste,Siacap,CedulaNueva,CodPasaporte,Observaciones,
								salario,renta,DecimoTMes,OtrosIngresos,DiasEnfermedad)
	select 	c.DEid,
			'2' as constante,			
			min(<cf_dbfunction name="string_part" args="upper(d.Enumero),1,5">) as NumEmpresa,
			min(<cf_dbfunction name="string_part" args="upper(f.DEinfo3),1,5">) as NumEmpleado, 
			min(case  when  f.DESeguroSocial is null then 
				'9999999' 
			else 
				<cf_dbfunction name="string_part" args="upper(f.DESeguroSocial),1,7">
			end) as NumSegSoc,
			min(<cf_dbfunction name="string_part" args="upper(f.DEidentificacion),1,15">) as Identificacion,
			min(<cf_dbfunction name="concat" args="f.DEapellido1,' ',f.DEapellido2">) as Apellido1y2,
			min(<cf_dbfunction name="string_part" args="upper(f.DEnombre),1,14">) as Nombre,
			min(f.DEsexo) as Sexo,
			min(<cf_dbfunction name="string_part" args="upper(f.DEdato1),1,2">) as Excepciones,	
			min(<cf_dbfunction name="string_part" args="upper(f.DEdato2),1,2">) as Departamento,
			min(<cf_dbfunction name="string_part" args="upper(f.DEdato4),1,2">) as ClaveIR,		
			min(<cf_dbfunction name="string_part" args="upper(f.DEdato5),1,1">) as CodAjuste,		
			min(<cf_dbfunction name="string_part" args="upper(f.DEdato6),1,3">) as Siacap,		
			min(<cf_dbfunction name="string_part" args="upper(f.DEinfo2),1,15">) as CedulaNueva,	
			min(case when f.NTIcodigo ='P' then
				'P'
			else
				' '
			end) as CodPasaporte,			
			min(case when (
							(select datepart(mm,EVfantig) from EVacacionesEmpleado x where x.DEid =c.DEid )=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#"> 
								and 
							(select datepart(yy,EVfantig) from EVacacionesEmpleado x where x.DEid =c.DEid )=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#"> 
						) then
					'Ingreso Nuevo'
				else
					<cf_dbfunction name="string_part" args="upper(f.DEinfo1),1,30">
				end
			) as Observaciones,
			sum(
			(coalesce(c.SEsalariobruto +
				(select sum(ICmontores)
				from HIncidenciasCalculo y
				where y.RCNid = a.RCNid 
					and y.DEid = c.DEid
					and CIid in (select CIid
							from RHReportesNomina c
								inner join RHColumnasReporte b
									on b.RHRPTNid = c.RHRPTNid
									and b.RHCRPTcodigo = 'SAL'
								inner join RHConceptosColumna a
									on a.RHCRPTid = b.RHCRPTid
							where c.RHRPTNcodigo = 'SSP'
								and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							)
				)
			,0))
			) as salario,
			sum(c.SErenta) as Renta, 		
			sum(
			(select coalesce(sum(ICmontores),0)
			from HIncidenciasCalculo z
			where z.RCNid = a.RCNid
				and z.DEid = c.DEid
				and CIid in (select CIid
							from RHReportesNomina c
								inner join RHColumnasReporte b
									on b.RHRPTNid = c.RHRPTNid
									and b.RHCRPTcodigo = 'DTM'
								inner join RHConceptosColumna a
									on a.RHCRPTid = b.RHCRPTid
							where c.RHRPTNcodigo = 'SSP'
								and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							)
			)
			) as DecimoTMes,
			sum(
			(select coalesce(sum(ICmontores),0)
			from HIncidenciasCalculo z
			where z.RCNid = a.RCNid
				and z.DEid = c.DEid
				and CIid in (select CIid
							from RHReportesNomina c
								inner join RHColumnasReporte b
									on b.RHRPTNid = c.RHRPTNid
									and b.RHCRPTcodigo = 'OT'
								inner join RHConceptosColumna a
									on a.RHCRPTid = b.RHCRPTid
							where c.RHRPTNcodigo = 'SSP'
								and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							)
			)
			) as OtrosIngresos
			,0 as DiasEnfermedad	
	from HRCalculoNomina a
		inner join CalendarioPagos b
			on a.RCNid = b.CPid
			and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
			and b.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
		inner join HSalarioEmpleado c
			on a.RCNid = c.RCNid
		inner join DatosEmpleado f
			on c.DEid = f.DEid
		inner join Empresa d
			on a.Ecodigo = d.Ecodigo
			inner join Direcciones e
				on d.id_direccion = e.id_direccion
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	group by c.DEid
</cfquery>

<!----========== Actualizar los dias de enfermedad ==========------>
<cfquery name="t" datasource="#session.DSN#">
	update #tbl_principal#
	set DiasEnfermedad = 
	coalesce((select 	
				SUM(case when datepart(mm,RHSPEfdesde) != <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">  
					or datepart(mm,RHSPEfhasta) != <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#"> then	<!----HAY CORTE---->
						case when RHSPEdiassub >= datediff(dd,RHSPEfdesde,RHSPEfhasta) then	<!---- CANT.DIAS SUFICIENTE ---->
							datediff(dd,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> < RHSPEfdesde then
											RHSPEfdesde
										else
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">
										end
										,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#">
										else
											RHSPEfhasta
										end
									) +1
					else	<!---NO HAY DIAS SUFICIENTES---->
						case when datepart(mm,RHSPEfdesde) < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#"> then <!----SOBRA A LA IZQUIERDA---->
							case when datepart(mm,dateadd(dd,RHSPEdiassub,RHSPEfdesde)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#"> then
								case when (datediff(dd,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">,
													case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then 
													<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> else RHSPEfhasta end) + 1)
											<= 
											(RHSPEdiassub - (datediff(dd,RHSPEfdesde,dateadd(dd,-1,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">))+1) )  then
									datediff(dd,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">,
												case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then 
													<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> 
												else RHSPEfhasta 
											end)+1
								else
									case when RHSPEdiassub - (datediff(dd,RHSPEfdesde,dateadd(dd,-1,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">))+1) >0 then
										case when RHSPEdiassub > (datediff(dd,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">,
																			case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then 
																					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> 
																			else RHSPEfhasta end) + 1) then
											RHSPEdiassub - (datediff(dd,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">,
																		case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then 
																			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> 
																		else RHSPEfhasta end) + 1)
										else
											RHSPEdiassub - (datediff(dd,RHSPEfdesde,dateadd(dd,-1,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#">))+1)
										end							
									else
										0
									end										
								end
							else
								0
							end
						else <!--- SOBRAN A LA DERECHA ---->
							case when (datediff(dd,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> < RHSPEfdesde then 
														RHSPEfdesde 
													else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> end
											,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then 
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> 
											else RHSPEfhasta end) + 1) <= RHSPEdiassub then
								datediff(dd,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> < RHSPEfdesde then RHSPEfdesde else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> end
										,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> else RHSPEfhasta end) + 1
							else
								case when RHSPEdiassub > (datediff(dd,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> < RHSPEfdesde then RHSPEfdesde else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> end
														,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> else RHSPEfhasta end) + 1) then
									RHSPEdiassub - (datediff(dd,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> < RHSPEfdesde then RHSPEfdesde else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> end
														,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> else RHSPEfhasta end) + 1)
								else 
									case when RHSPEdiassub > 0 then
										RHSPEdiassub
									else
										0
									end 
								end 
							end 
						end	<!---- FIN DE SOBRAN IZQUIERDA---->
					end	<!----FIN DE CANT.DIAS SUFICIENTE---->
				else	<!----NO HAY CORTE---->			
					case when (datediff(dd,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> < RHSPEfdesde then RHSPEfdesde else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> end
									,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> else RHSPEfhasta end) +1) <= RHSPEdiassub  then
						datediff(dd,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> < RHSPEfdesde then RHSPEfdesde else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_primerdiames#"> end
									,case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> < RHSPEfhasta then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vd_ultimodiames#"> else RHSPEfhasta end) + 1
					else
						RHSPEdiassub
					end  
				end<!---- FIN DE SI HAY CORTE ---->	
				)
			from RHSaldoPagosExceso a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHSPEanulado = 0
				and  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#"> between datepart(mm,RHSPEfdesde) and datepart(mm,RHSPEfhasta) 
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#"> between datepart(yy,RHSPEfdesde) and datepart(yy,RHSPEfhasta) 
				and #tbl_principal#.DEid = a.DEid
			)			
		,0)
</cfquery>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	<cf_dbfunction name="string_part" args="upper(Apellido1y2),1,14"> as Apellido1y2
			<!---Los ultimos 2 caracteres pertenecen a los decimales por eso de multiplica por 100 (178.25 => 17825, 148.00 => 14800)----->
			,salario*100 as salario
			,renta*100 as renta
			,DecimoTMes*100 as DecimoTMes
			,OtrosIngresos*100 as OtrosIngresos
			,* 
	from #tbl_principal#
</cfquery>

<cfquery name="rsDatosUltimaLinea" datasource="#session.DSN#">
	select 	(select Enumero from Empresa where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">) as NumEmpresa,
			(select Pvalor from RHParametros where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and Pcodigo = 300) as NumeroPatronal,
			coalesce(sum(a.salario)*100,0) as salarios,
			coalesce(sum(a.renta)*100,0) as rentas,
			coalesce(sum(<cf_dbfunction name="to_number" args="a.Excepciones">),0) as excepciones,
			coalesce(sum(a.DecimoTMes)*100,0) as DecimoTMes,
			(select count(1) from #tbl_principal# where <cf_dbfunction name="length" args="CodAjuste"> > 0) as CodigosAjuste,
			coalesce(sum(a.OtrosIngresos)*100,0) as OtrosIngresos
	from #tbl_principal# a
</cfquery>

<cfif rsDatos.RecordCount NEQ 0>
	<cfset hilera = ''>
	<cfoutput query="rsDatos">
		<!----======== Arma la linea a insertar ========---->
		<cfset hilera = hilera & '#rsDatos.constante#'><!---Constante---->
		<cfset hilera = hilera & '#trim(rsDatos.NumEmpresa)#'& IIf(len(trim(rsDatos.NumEmpresa)) LT 5, DE(RepeatString(' ', 5-(len(trim(rsDatos.NumEmpresa))))), DE(''))><!---NumEmpresa--->
		<cfset hilera = hilera & '#trim(rsDatos.NumEmpleado)#'& IIf(len(trim(rsDatos.NumEmpleado)) LT 5, DE(RepeatString(' ', 5-(len(trim(rsDatos.NumEmpleado))))),DE(''))><!---NumEmpleado--->
		<cfset hilera = hilera & '#trim(rsDatos.NumSegSoc)#'& IIf(len(trim(rsDatos.NumSegSoc)) LT 7, DE(RepeatString(' ', 7-(len(trim(rsDatos.NumSegSoc))))), DE(''))><!---NumSeguroSocial--->
		<cfset hilera = hilera & '#trim(rsDatos.Identificacion)#'& IIf(len(trim(rsDatos.Identificacion)) LT 15, DE(RepeatString(' ', 15-(len(trim(rsDatos.Identificacion))))), DE(''))><!---Identificacion Empleado--->
		<cfset hilera = hilera & '#trim(rsDatos.Apellido1y2)#'& IIf(len(trim(rsDatos.Apellido1y2)) LT 14, DE(RepeatString(' ', 14-(len(trim(rsDatos.Apellido1y2))))), DE(''))><!---Apellido 1 y 2 del Empleado--->
		<cfset hilera = hilera & '#trim(rsDatos.Nombre)#'& IIf(len(trim(rsDatos.Nombre)) LT 14, DE(RepeatString(' ', 14-(len(trim(rsDatos.Nombre))))), DE(''))><!---Nombre del Empleado--->
		<cfset hilera = hilera & '#trim(rsDatos.Sexo)#'& RepeatString(' ', 1-(len(trim(rsDatos.Sexo))))><!---Sexo--->
		<cfset hilera = hilera & '#trim(rsDatos.Excepciones)#'& IIf(len(trim(rsDatos.Excepciones)) LT 2, DE(RepeatString(' ', 2-(len(trim(rsDatos.Excepciones))))), DE(''))><!---Excepciones--->
		<cfset hilera = hilera & '#trim(rsDatos.Departamento)#'& IIf(len(trim(rsDatos.Departamento)) LT 2, DE(RepeatString(' ', 2-(len(trim(rsDatos.Departamento))))), DE(''))><!---Departamento--->
		<cfset hilera = hilera & '#trim(rsDatos.DiasEnfermedad)#'& IIf(len(trim(rsDatos.DiasEnfermedad)) LT 2, DE(RepeatString(' ', 2-(len(trim(rsDatos.DiasEnfermedad))))), DE(''))><!---Dias enfermedad--->	
		<cfif len(trim(rsDatos.salario)) GTE 7><!---Salario--->
			<cfset hilera = hilera & '#trim(Mid(rsDatos.salario,1,7))#'>
		<cfelse>
			<cfset hilera = hilera & '#trim(rsDatos.salario)#' & IIf(len(trim(rsDatos.salario)) LT 7, DE(RepeatString(' ', 7-(len(trim(rsDatos.salario))))), DE(''))>
		</cfif>
		<cfif len(trim(rsDatos.renta)) GTE 7><!---Imp.Renta--->
			<cfset hilera = hilera & '#trim(Mid(rsDatos.renta,1,7))#'>
		<cfelse>
			<cfset hilera = hilera & '#trim(rsDatos.renta)#' & IIf(len(trim(rsDatos.renta)) LT 7, DE(RepeatString(' ', 7-(len(trim(rsDatos.renta))))), DE(''))>
		</cfif>
		<cfset hilera = hilera & '#trim(rsDatos.ClaveIR)#'& IIf(len(trim(rsDatos.ClaveIR)) LT 2, DE(RepeatString(' ', 2-(len(trim(rsDatos.ClaveIR))))), DE(''))><!---Clave I/R--->
		<cfset hilera = hilera & '#trim(rsDatos.CodAjuste)#'& RepeatString(' ', 1-(len(trim(rsDatos.CodAjuste)) ))><!---Codigo de ajuste--->
		<cfset hilera = hilera & ' '><!---Blanco--->
		<cfset hilera = hilera & '#trim(rsDatos.Siacap)#'& IIf(len(trim(rsDatos.Siacap)) LT 3, DE(RepeatString(' ', 3-(len(trim(rsDatos.Siacap))))), DE(''))><!---Siacap--->
		<cfset hilera = hilera & '#trim(rsDatos.CedulaNueva)#'& IIf(len(trim(rsDatos.CedulaNueva)) LT 15, DE(RepeatString(' ', 15-(len(trim(rsDatos.CedulaNueva))))), DE(''))><!---Cedula Nueva--->
		<cfset hilera = hilera & '#trim(rsDatos.CodPasaporte)#'& RepeatString(' ', 1-(len(trim(rsDatos.CodPasaporte)) ))><!---Codigo pasaporte--->
		<cfif len(trim(rsDatos.DecimoTMes)) GTE 7><!---Decimo tercer mes--->
			<cfset hilera = hilera & '#trim(Mid(rsDatos.DecimoTMes,1,7))#'>
		<cfelse>
			<cfset hilera = hilera & '#trim(rsDatos.DecimoTMes)#' & IIf(len(trim(rsDatos.DecimoTMes)) LT 7, DE(RepeatString(' ', 7-(len(trim(rsDatos.DecimoTMes))))), DE(''))>
		</cfif>
		<cfif len(trim(rsDatos.OtrosIngresos)) GTE 7><!---Otros ingresos--->
			<cfset hilera = hilera & '#trim(Mid(rsDatos.OtrosIngresos,1,7))#'>
		<cfelse>
			<cfset hilera = hilera & '#trim(rsDatos.OtrosIngresos)#' & IIf(len(trim(rsDatos.OtrosIngresos)) LT 7, DE(RepeatString(' ', 7-(len(trim(rsDatos.OtrosIngresos))))), DE(''))>
		</cfif>
		<cfset hilera = hilera & '#trim(rsDatos.Observaciones)#' & IIf(len(trim(rsDatos.Observaciones)) LT 30, DE(RepeatString(' ', 30-(len(trim(rsDatos.Observaciones))))), DE(''))><!---Observaciones--->
		<!----Reemplazar caracteres no validos----->
		<cfset hilera = REReplaceNoCase(Ucase(hilera),'Á','A',"all")>
		<cfset hilera = REReplaceNoCase(Ucase(hilera),'É','E',"all")>
		<cfset hilera = REReplaceNoCase(Ucase(hilera),'Í','I',"all")>
		<cfset hilera = REReplaceNoCase(Ucase(hilera),'Ó','O',"all")>
		<cfset hilera = REReplaceNoCase(Ucase(hilera),'Ú','U',"all")>
		<cfset hilera = REReplaceNoCase(Ucase(hilera),'Ñ','N',"all")>
		<cfset hilera = REReplaceNoCase(Ucase(hilera),'Ü','U',"all")>
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	</cfoutput>
	<!----================ Inserta ultima linea ================---->
	<cfset hilera = hilera & '0'><!---Constante--->
	<cfif len(trim(rsDatosUltimaLinea.NumEmpresa)) GTE 5><!---NumEmpresa--->
		<cfset hilera = hilera & '#mid(rsDatosUltimaLinea.NumEmpresa,1,5)#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsDatosUltimaLinea.NumEmpresa)#'& RepeatString(' ', 5-(len(trim(rsDatosUltimaLinea.NumEmpresa))))>
	</cfif>
	<cfset hilera = hilera & RepeatString('0',11)><!---Relleno 11 ceros--->
	<cfif len(trim(rsDatosUltimaLinea.salarios)) GTE 11><!---Salarios--->
		<cfset hilera = hilera & '#trim(Mid(rsDatosUltimaLinea.salarios,1,11))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsDatosUltimaLinea.salarios)#' & RepeatString(' ', 11-(len(trim(rsDatosUltimaLinea.salarios))))>
	</cfif>
	<cfset hilera = hilera & RepeatString('0',6)><!---Relleno 6 ceros--->
	<cfif len(trim(rsDatosUltimaLinea.rentas)) GTE 9><!---Renta--->
		<cfset hilera = hilera & '#trim(Mid(rsDatosUltimaLinea.rentas,1,9))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsDatosUltimaLinea.rentas)#' & RepeatString(' ', 9-(len(trim(rsDatosUltimaLinea.rentas))))>
	</cfif>
	<cfif len(trim(rsDatosUltimaLinea.rentas)) GTE 6><!---Excepciones--->
		<cfset hilera = hilera & '#trim(Mid(rsDatosUltimaLinea.rentas,1,6))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsDatosUltimaLinea.rentas)#' & RepeatString(' ', 6-(len(trim(rsDatosUltimaLinea.rentas))))>
	</cfif>
	<cfif len(trim(rsDatosUltimaLinea.DecimoTMes)) GTE 10><!---Decimo T. Mes--->
		<cfset hilera = hilera & '#trim(Mid(rsDatosUltimaLinea.DecimoTMes,1,10))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsDatosUltimaLinea.DecimoTMes)#' & RepeatString(' ', 10-(len(trim(rsDatosUltimaLinea.DecimoTMes))))>
	</cfif>
	<cfset hilera = hilera & RepeatString(' ',7)><!---Relleno 7 blancos--->
	<cfif len(trim(rsDatosUltimaLinea.CodigosAjuste)) GTE 3><!---Cod.Ajuste---->
		<cfset hilera = hilera & '#trim(Mid(rsDatosUltimaLinea.CodigosAjuste,1,3))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsDatosUltimaLinea.CodigosAjuste)#'& RepeatString(' ', 3-(len(trim(rsDatosUltimaLinea.CodigosAjuste))))>
	</cfif>	
	<cfif len(trim(rsDatosUltimaLinea.NumeroPatronal)) GTE 9><!----No.Patronal---->
		<cfset hilera = hilera & '#trim(Mid(rsDatosUltimaLinea.NumeroPatronal,1,9))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsDatosUltimaLinea.NumeroPatronal)#'& RepeatString(' ', 9-(len(trim(rsDatosUltimaLinea.NumeroPatronal))))>
	</cfif>		
	<cfset hilera = hilera & '#trim(meses)#'& IIf(len(trim(meses)) LT 11, DE(RepeatString(' ', 11-(len(trim(meses))))), DE(''))><!----Mes en letras---->
	<cfset hilera = hilera & '#form.periodo#'><!----Año en numeros---->

	<!----======== Guarda la linea en el archivo txt ========---->
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'SegSoc')>	
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=SeguroSocialDHC.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
</cfif>
