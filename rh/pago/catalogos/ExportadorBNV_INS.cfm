<!----=================================================================
EXISTEN 3 MODOS DE EJECUTAR EL REPORTE DE RIESGOS DEL INS Y SE DETALLAN SEGUN SU NACIMIENTO:
+ UNICA POLIZA. La Aplicacion supone que hay una única Poliza para la Empresa y genera un único Reporte con todos los Empleados Activos.
+ POLIZA SEGUN PUESTO. Se define Datos Variables de tipo Póliza en Adm de Puestos y cada puesto se asocia a su póliza respectiva, Se usa el Exportardor Riesgo Trabajo Multiples Pólizas.
+ POLIZA POR EMPLEADO. Se usa el DatoVariable4 para almacenar la póliza de Riesgo de Cada Empleado y se define un Parámetro en el Tab de Legislación de Parámetros Generales 
                       "Tomar el numero de poliza de DatosEmpleado" (Parametro 330) se utiliza el Exportador General y se activa una casilla con un "distinct de las posibles pólizas definidas"

Se incluye un Identificador del Tipo de Exportador:
TipoExportador='PN' Exportador Poliza Normal 
TipoExportador='PE' Exportador Poliza EmpleadoNormal 
TipoExportador='PP' Exportador Poliza Puesto

Este archivo tiene 
1. La información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Esta información corresponde a todas aquellas nóminas que corresponden a un mismo mes, esto quiere decir que la fecha fin de la nómina este el mes que estoy solicitando.
3. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas, 4 o 5 semanas, 2 quincenas o 1 mes
4. El formato del archivo debe ser el siguiente:
5. En la primera línea del archivo se deben colocar los siguientes datos referentes a información sobre el Patrono/Empresa: (Longitud de la línea: 46)
  
		Linea 1
				Póliza			Numérico	    7		Número de póliza Diferente de blancos.Diferente de cero.
				Tipo			Alfanumérico	1		Tipo de planilla	M = mensual ó A = adicional
				Año				Numérico		4		Año de la planilla	
				Mes				Numérico		2		Mes de la Planilla	
				espacio			Alfanumérico	1		Espacio en blanco
				N° de Identif.	Alfanumérico	15		Cédula del patrono   (un total de 10 dígitos) y finalizarse con 5 espacios en blanco.
				N° de Telefono	Alfanumérico	8		Telefono del patrono. 
				N° de Fax   	Alfanumérico	8		Fax del patrono.
	    Linea 2
				Direccion 		Alfanumérico	200		Dirección del patrono

  		Linea 3
				espacio			Alfanumérico	1		Espacio en blanco

	  	Linea 4	
				Identificacion	Alfanumérico	15		Cédula del trabajador Diferente de blancos.No existan registros duplicados. 
																		Cédula Física Nacional
																				El formato para las cédulas de persona física nacional, siempre tendrá un cero (0) adelante, código de
																				provincia, tomo, asiento y finalizará con 5 espacios en blanco.
																					0X XXXX XXXX
																					Número de Asiento
																					Número de Tomo
																					Código de Província
																											Ejemplos
																											a. 1-605-396 					0106050396
																											b .5-292-040 					0502920040
																											c .3-1487-080 					0314870080
																											d. 4-063-1256 					0400631256			
																		Cédula Física Residente
																				El formato para una persona física residente, siempre tendrá un uno (1) adelante, código del país y finalizará
																				con 3 espacios en blanco. En caso de contener letras deberán reemplazarse por ceros (0).
																					1XXX XXXXXXXX
																					Número
																					Código de Nacionalidad
																											Ejemplos		
																											a. 201 RE -12345678 			1201 00123456
																											b. 304 RE 123 					1304 00000123
																											c. 523-876543 					1523 00876543			
																		Indocumentado
																				El formato para una persona indocumentada, siempre tendrá un cinco (5) adelante, código de nacionalidad
																				(deberá utilizar un código válido de nacionalidad, (Ver Anexo 5), fecha de nacimiento completa de 8 dígitos,
																				iniciales de ambos apellidos y el nombre; y finalizará con 1 espacio en blanco.
																					5 XX XXXXXXXX XXX
																					Iniciales
																					Fecha de Nacimiento
																					Código de Nacionalidad
																											Ejemplos
																											Nacionalidad: ARGENTINA (Código = AU)
																											Fecha de Nacimiento: 1-2-1904 = (01/02/1904)
																											Nombre: Lupita Tipez Mones
																														Formato: 			5 AU01021904 MTL									
																		Permiso de Trabajo
																				El formato para esta codificación tendrá un ocho (8) adelante, los 2 últimos dígitos del año del permiso, el
																				número consecutivo y finalizará con 3 espacios en blanco.
																				8XX XXXXXXXXX
																					Número de Consecutivo
																					Año del Permiso
																											Ejemplos
																											a .1995-56789 					895000056789
																		Número de Pasaporte
																				El formato para la Persona Física No Nacional Con Pasaporte tendrá un nueve (9) adelante, el número de
																				pasaporte justificado a la izquierda con ceros y finalizará con 3 espacios en blanco.
																				9XXXXXXXXX
																											Ejemplos		
																											a. 5678924 						900005678924
																											b. 456 							900000000456				
				No. Asegurado	Alfanumérico	25		Número Asegurado C.C.S.S Según especificaciones que rigen para la C.C.S.S
				Nombre			Alfanumérico	15		Nombre del trabajador	
				Apellido1		Alfanumérico	15		1er Apellido 	
				Apellido2		Alfanumérico	15		2do Apellido	
				Salario			Numérico		3		Salario Mensual Diferente de cero si el campo días es mayor que cero.Salarios redondeados los céntimos.(léase 13 caracteres tomando en cuenta el punto decimal)
				Días Laborados	Numérico		3		Días Laborados De 000 a 030 días
				Horas			Numérico		4		Horas laboradas De 0000 a 0360 horas
				Jornada			Numerico		2		Tipo de Jornada (01 Tiempo Completo, 02 Medio Tiempo 03 Ocasional Trabajadores  04 Por Destajo)
				Condición Lab.  Numerico		2		
														00 		Sin cambios Trabajador Normal
														01 		Nuevo Ingreso El trabajador inició o fue contratado en este mes
														02 		Salio en el mes El trabajador dejó de laborar en este mes
														03 		Incapacitado CCSS El trabajador estuvo incapacitado al menos un día en este mes por la CCSS
														04 		Incapacitado INS El trabajador estuvo incapacitado al menos un día en  este mes por el INS
														05 		Ingresó y Salió El trabajador ingreso y salió en el mismo mes 
														06 		Disfruto Licencia El trabajador disfrutó al menos un día de licencia sin goce de salario en este mes

				Ocupación		Alfanumérico	5		Ocupación Código según lista de puestos del INS
=================================================================--->

<!----TRADUCCION---->
<cfinvoke returnvariable="MSG_NoSeHaDefinidoElNumeroDePolizaDelIns" Key="MSG_NoSeHaDefinidoElNumeroDePolizaDelIns" Default="No se ha definido el numero de poliza del INS" component="sif.Componentes.Translate" method="Translate" />
<!----PARAMETROS---->

<cf_dbtemp name="reportetmp21" returnvariable="reporte" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid" 		type="numeric"  	mandatory="no">
	<cf_dbtempcol name="RCNid" 		type="numeric"  	mandatory="no">
	<cf_dbtempcol name="RHJid" 		type="numeric"  	mandatory="no">
	<cf_dbtempcol name="poliza"		type="varchar(7)" 	mandatory="no">
	<cf_dbtempcol name="tipoP"		type="char(1)" 		mandatory="no">
	<cf_dbtempcol name="tipoC"		type="char(1)" 		mandatory="no">
	<cf_dbtempcol name="Pais"		type="char(2)" 		mandatory="no">
	<cf_dbtempcol name="cedula"		type="varchar(14)" 	mandatory="no">
	<cf_dbtempcol name="numseguro"	type="varchar(25)" 	mandatory="no">
	<cf_dbtempcol name="nombre"		type="char(15)" 	mandatory="no">
	<cf_dbtempcol name="apellido1"	type="char(15)" 	mandatory="no">
	<cf_dbtempcol name="apellido2"	type="char(15)" 	mandatory="no">
	<cf_dbtempcol name="salario"	type="money"		mandatory="no">
	<cf_dbtempcol name="salario2"	type="varchar(13)"	mandatory="no">
	<cf_dbtempcol name="dias"		type="int" 			mandatory="no">
	<cf_dbtempcol name="horas"		type="int" 			mandatory="no">
	<cf_dbtempcol name="ocupacion"	type="char(10)" 	mandatory="no">
	<cf_dbtempcol name="puesto"		type="char(10)" 	mandatory="no">
	<cf_dbtempcol name="jornada"	type="char(2)" 		mandatory="no">
	<cf_dbtempcol name="condicion"	type="char(2)" 		mandatory="no">
	<cf_dbtempcol name="FactorHoras"	type="numeric" 	mandatory="no">		
	<cf_dbtempcol name="TipoFrecuencia"	type="numeric" 	mandatory="no">			
	<cf_dbtempkey cols="DEid">
</cf_dbtemp> 

<cf_dbtemp name="report" returnvariable="reporte1" datasource="#session.DSN#">
	<cf_dbtempcol name="ordenado" 	type="int"  		mandatory="no">
	<cf_dbtempcol name="salida"		type="varchar(200)" mandatory="no">
	<cf_dbtempcol name="apellido1"		type="varchar(100)" mandatory="no">
	<cf_dbtempcol name="apellido2"		type="varchar(100)" mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="reportetemp" returnvariable="reporteTmp" datasource="#session.DSN#">
	<cf_dbtempcol name="ordenado" 	type="int"  		mandatory="no">
	<cf_dbtempcol name="salida"		type="varchar(200)" mandatory="no">
</cf_dbtemp>



<!--- INFORMACION DE LA EMPRESA --->
		<cfquery name="rsDatosEmpresa" datasource="#session.DSN#">
			select 	coalesce(d.Pvalor,'') as Poliza, 
					coalesce(a.Etelefono1,'') as Etelefono1,  
					coalesce(a.Efax,'') as Efax, 
					coalesce(a.Eidentificacion,'') as Eidentificacion, 
					coalesce(c.direccion1,'') as direccion1
			from Empresa a, Empresas b, Direcciones c, RHParametros d
			where a.Ecodigo = b.EcodigoSDC
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.id_direccion = c.id_direccion
				and d.Pcodigo = 420 
				and d.Ecodigo = b.Ecodigo
		</cfquery>
	

<!--- INFORMACION DEL MES --->
		<cfquery name="rsFDesde" datasource="#session.DSN#">
			select  min(CPdesde) as f1
		   from  CalendarioPagos 
			where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
				and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfquery name="rsFhasta" datasource="#session.DSN#">
			select  max(CPhasta) as f2
			   from  CalendarioPagos 
			where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
				and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfquery name="Parametro311" datasource="#session.DSN#"> <!---Verifica si es Poliza por Empresa o por Puesto--->
			select  upper(Pvalor) as Pvalor
			   from  RHParametros
			where Pcodigo=311
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>		

		<cfset TipoExportador='PN'> <!--- Exportador Poliza Normal (defecto)--->
		 
        <cfif isdefined("url.Poliza") and len(trim(url.Poliza))>
            <cfquery name="NumPoliza" datasource="#session.DSN#"> <!---Verifica si es Poliza por Empresa o por Puesto--->
                select  <cf_dbfunction name="to_number" args="RHDDVvaloracion"> as Poliza
                   from  RHDDatosVariables
                where RHDDVlinea = #url.Poliza#
            </cfquery>
            <cfif NumPoliza.recordcount GT 0> <!--- Viene el Número de Póliza --->
                    <cfset TipoExportador='PP'> <!--- Exportador Poliza Puesto --->
                    <cfset vNumPoliza 		= #NumPoliza.Poliza#>
            <cfelse>
                    <cfset vNumPoliza 		= #rsDatosEmpresa.Poliza#>
            </cfif>
        <cfelseif trim(Parametro311.Pvalor) EQ 'S'>
        	<cfif isdefined("url.NumPoliza") and len(trim(url.NumPoliza))>
					<cfset TipoExportador='PE'> <!--- Exportador Empleado --->
                    <cfset vNumPoliza 		= #url.NumPoliza#>
            <cfelse>
                    <cfset vNumPoliza = #rsDatosEmpresa.Poliza#> <!--- Use Número PolizaEmpresa General --->
            </cfif>	
		<cfelse>
        	<cfset vNumPoliza = #rsDatosEmpresa.Poliza#> <!--- Use Número PolizaEmpresa General --->
        </cfif>     
		<cfif len(trim(rsDatosEmpresa.Poliza)) EQ 0>
			<cf_throw message="#MSG_NoSeHaDefinidoElNumeroDePolizaDelIns#" errorcode="6005">
			<cfabort>
		</cfif>


<!--- GENERACION DE LA INFORMACION DEL ENCABEZADO --->
<!---		<cf_dbfunction name="string_part" args="rtrim(rsDatosEmpresa.Poliza)|1|7" 	returnvariable="LvarReferencia"  delimiters="|">
				<cf_dbfunction name="length"      args="#LvarReferencia#"  		returnvariable="LvarReferenciaL" delimiters="|" >
						<cf_dbfunction name="sRepeat"     args="' '|20-coalesce(#LvarReferenciaL#,0)" 	returnvariable="LvarReferenciaS" delimiters="|">
--->						
				<cfset vs_salida1 =
								RepeatString('0',7-len(mid(trim('#vNumPoliza#'),1,7))) &  						<!--- Espacios Relleno --->
								mid('#vNumPoliza#',1,7)&  														<!--- Numero Poliza --->
							   'M'&  																			<!--- Constante --->
								url.CPperiodo & 																<!--- Año reporte --->
								RepeatString('0',2-len(trim(url.CPmes)))&  										<!--- Ceros Relleno Para el Mes--->	
								trim(url.CPmes)&																<!--- Mes Reporte --->	
								' '&																			<!--- Espacio Constante --->	
								trim(mid(rsDatosEmpresa.Eidentificacion,1,15))& 	           					<!--- Cedula Jurídica Empresa (10 Digitos) --->	
								RepeatString(' ',15-len(mid(trim(rsDatosEmpresa.Eidentificacion),1,15)))&		<!--- Se Rellena con Espacios --->	
								RepeatString('0',8-len(mid(trim(rsDatosEmpresa.Etelefono1),1,8)))&				<!--- Se Rellena con Ceros el Telefono --->	
								trim(mid(rsDatosEmpresa.Etelefono1,1,8))&										<!--- Telefono 1 --->	
								RepeatString('0',8-len(mid(trim(rsDatosEmpresa.Efax),1,8)))&					<!--- Se Rellena con Ceros el Telefono 2 --->	
								trim(mid(rsDatosEmpresa.Efax,1,8))
								>															<!--- Telefono 2 --->	
								
<!----SE INSERTA LA PRIMERA LINEA ---->
				<cfquery datasource="#session.DSN#">
						insert into #reporte1# (ordenado, salida)
						select 	1,
								'#vs_salida1#'
						from dual		
				</cfquery>
				
				<cfset vs_salida2 = 
								trim(mid(rsDatosEmpresa.direccion1,1,200)) &  										<!--- Direccion --->
								RepeatString(' ',200-len(trim(mid(rsDatosEmpresa.direccion1,1,200)))) 				<!--- Espacios Relleno --->
								>

<!----- SE INSERTA LA SEGUNDA LINEA ----->
				<cfquery datasource="#session.DSN#">
						insert into #reporte1# (ordenado, salida)
						select 	2,
								'#vs_salida2#'
						from dual		
				</cfquery>
<!---- INSERTA LA TERCERA LINEA ----->
				<cfquery datasource="#session.DSN#">
						insert into #reporte1# (ordenado, salida)
						select 	3, 
								' '																					<!--- Espacio En Blanco --->
						from dual
				</cfquery>

		<cf_dbfunction name="OP_concat" returnvariable="CAT">
		<!---- Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado ----->
		<cfquery datasource="#session.DSN#" name="y">
				insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, 
								apellido2, numseguro, poliza, tipoP, dias, horas, 
								ocupacion, salario, puesto, condicion, jornada,Pais)
				select 	distinct e.NTIcodigo as TipoIdentificacion, 
						h.DEid  as DEid,
						<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,14"> as DEidentificacion,
						<cf_dbfunction name="string_part"   args="e.DEnombre,1,15"> as DEnombre,
						<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15"> as DEapellido1,
						<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15"> as DEapellido2,
						case when e.DESeguroSocial is not null then 
							<cf_dbfunction name="string_part"   args="e.DESeguroSocial,1,25">
						else
							case when e.DEdato3 is not null then
								<cf_dbfunction name="string_part"   args="e.DEdato3,1,25">
							else
								<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,25">
							end		
						end as SeguroSocial, 
   					   '0000000' as Poliza,
						'M' as TipoPoliza,       
						0 as Dias,
						0 as Horas,
						'' as Ocupacion,
						sum(h.SEsalariobruto) as Salarios,
						null as Puesto, 
						'00' as Condicion, 
						'00' as Jornada,
						<cf_dbfunction name="string_part"   args="e.Ppais,1,2"> as Pais
				from 	CalendarioPagos c, 
						HSalarioEmpleado h, 
						DatosEmpleado e
				where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
					and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
					and c.CPid = h.RCNid 
					and h.DEid = e.DEid 
					and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				group by  	e.NTIcodigo, h.DEid, 
							<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,14">,
							e.DEnombre, 
							e.DEapellido1,
							e.DEapellido2, 
							case when e.DESeguroSocial is not null then 
							<cf_dbfunction name="string_part"   args="e.DESeguroSocial,1,25">
							else
								case when e.DEdato3 is not null then
									<cf_dbfunction name="string_part"   args="e.DEdato3,1,25">
								else
									<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,25">
								end		
							end ,
							<cf_dbfunction name="string_part"   args="e.Ppais,1,2">
		</cfquery>
			
<!---- Inserta a los Empleados que estuvieron durante el Mes, en algún momento (LineaTiempo) y no recibieron Salarfio ----->	
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (tipoC, DEid, cedula,nombre,apellido1, 
								apellido2, numseguro, poliza, tipoP, dias, horas, 
								ocupacion, salario, puesto, condicion, jornada, Pais)
				select 	distinct e.NTIcodigo as TipoIdentificacion, 
						e.DEid  as DEid,
						<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,14"> as DEidentificacion,
						<cf_dbfunction name="string_part"   args="e.DEnombre,1,15"> as DEnombre,
						<cf_dbfunction name="string_part"   args="e.DEapellido1,1,15"> as DEapellido1,
						<cf_dbfunction name="string_part"   args="e.DEapellido2,1,15"> as DEapellido2,
						case when e.DESeguroSocial is not null then 
							<cf_dbfunction name="string_part"   args="e.DESeguroSocial,1,25">
						else
							case when e.DEdato3 is not null then
								<cf_dbfunction name="string_part"   args="e.DEdato3,1,25">
							else
								<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,25">
							end		
						end as SeguroSocial, 
						'0000000' as Poliza,
						'M' as TipoPoliza,       
						0 as Dias,
						0 as Horas,
						''as Ocupacion,
						0 as Salarios,
						null as Puesto, 
						'00' as Condicion, 
						'00' as Jornada,
						<cf_dbfunction name="string_part"   args="e.Ppais,1,2"> as Pais
				from LineaTiempo lt, 
					 DatosEmpleado e
				where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
					and lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> 
					and e.DEid = lt.DEid
					and e.Ecodigo = lt.Ecodigo
					and not exists(	select 1 
									from #reporte# r 
									where r.DEid = e.DEid)
				group by  	e.NTIcodigo, e.DEid, 
							<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,14">,
							e.DEnombre, 
							e.DEapellido1,
							e.DEapellido2, 
							case when e.DESeguroSocial is not null then 
							<cf_dbfunction name="string_part"   args="e.DESeguroSocial,1,25">
							else
								case when e.DEdato3 is not null then
									<cf_dbfunction name="string_part"   args="e.DEdato3,1,25">
								else
									<cf_dbfunction name="string_part"   args="e.DEidentificacion,1,25">
								end		
							end,
							<cf_dbfunction name="string_part"   args="e.Ppais,1,2">
		</cfquery>

	
		<!--- actualizo el Código de Puesto Actual--->
		
		<cfquery datasource="#session.DSN#">
			update #reporte# 
			set puesto = (select RHPcodigo 
							from LineaTiempo b 
							where b.DEid = #reporte#.DEid 
								and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and b.LThasta = (select max(lt.LThasta)
													from LineaTiempo lt
													where lt.DEid = #reporte#.DEid
													and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												)
						)
			where puesto is null
		</cfquery>		
		
		<!--- Se actualiza la Poliza según el Tipo de Exportador usado--->
		<cfif TipoExportador EQ 'PN'>
			<cfquery datasource="#session.DSN#" >
				update #reporte# set
					poliza = <cf_dbfunction name="string_part" args="'#vNumPoliza#',1,7">
			</cfquery>
		<cfelse>
				<cfif TipoExportador EQ 'PP'>
					<cf_dbfunction name="to_number" args="RHDDVvaloracion" returnvariable="LvarValorac">
						<cf_dbfunction name="to_char" args="#LvarValorac#" 	returnvariable="LvarValoracion">
							<cf_dbfunction name="string_part"    args="rtrim(#LvarValoracion#)|1|7" returnvariable="LvarValoracionL" delimiters="|" >
				
					<cfquery datasource="#session.DSN#" >
						update #reporte# set
							poliza = (Select coalesce(#preservesinglequotes(LvarValoracionL)#,'000000')
										from RHPuestos c
										     inner join  RHDDatosVariables b
										     on c.RHDDVlinea = b.RHDDVlinea
										Where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and #reporte#.puesto=c.RHPcodigo)
					</cfquery>				
				<cfelse>
					<cfquery datasource="#session.DSN#" >
						update #reporte# set
							poliza = (Select coalesce(<cf_dbfunction name="string_part" args="a.DEdato4,1,7">,'000000')
										from DatosEmpleado a
										Where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and #reporte#.DEid=a.DEid)
					</cfquery>				
				</cfif>
				<!--- Eliminar todos los Datos que no pertenecen a la Póliza que se esta generando--->
				<cfquery datasource="#session.DSN#" name="x">
					delete from #reporte#
					where ltrim(rtrim(#reporte#.poliza)) <> <cf_dbfunction name="string_part" args="'#vNumPoliza#',1,7">
				</cfquery>			
		</cfif>			

	<cfquery datasource="#session.DSN#" name="Residentes">
		Select upper(cedula) as cedula
		from #reporte#
		Where tipoC='R'
		or (tipoC='G' and Pais<>'CR')
	</cfquery>
	
	<cfloop query ="Residentes">
		<cfset Vcedula="#Residentes.cedula#">
		<cfset VcedulaNew =REReplace("#Vcedula#","[A-Z)]","0","ALL")>
		
		<cfquery datasource="#session.DSN#">
			update #reporte#
			set cedula='#VcedulaNew#'
			Where cedula='#Vcedula#'
		</cfquery>
	</cfloop>
		

<!---- Actualiza el Puesto del Empleado en el MES ----->		
	<cfquery datasource="#session.DSN#">
		update #reporte# 
		set puesto = (
						select min(RHPcodigo)
						from LineaTiempo b 
						where b.DEid = #reporte#.DEid 
						and b.LThasta = (
											select max(lt.LThasta)
											from LineaTiempo lt
											where lt.DEid = #reporte#.DEid
											and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
											and lt.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> 
										 )
						)
	</cfquery>
	
	

	
	
<!---- Actualiza el Código de Ocupacion en base a la homologacion de Puestos ----->	
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set ocupacion = (select min(RHPEcodigo)
							from 	RHPuestos r, 
									RHPuestosExternos o
							where 	r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and r.RHPcodigo = #reporte#.puesto
									and o.RHPEid = r.RHPEid
								)
	</cfquery>

<!---- Actualiza el Código de Ocupacion en base a la homologacion de Puestos ----->	
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set ocupacion = '00000'
		where ocupacion is null or ocupacion = ''
	</cfquery>
	

	

<cfquery datasource="#session.DSN#">
	update #reporte#
		set dias =  (select  sum(coalesce(a.PEcantdias,0)) 
					from  HPagosEmpleado a, CalendarioPagos c
					where a.DEid = #reporte#.DEid
						and a.PEtiporeg = 0
						and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and c.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
						and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
						and c.CPid = a.RCNid
					),
		   RHJid =  (select  coalesce(max(a.RHJid),0) 
					from  HPagosEmpleado a, CalendarioPagos c
					where a.DEid = #reporte#.DEid
						and a.PEtiporeg = 0
						and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and c.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
						and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
						and c.CPid = a.RCNid
					),
	   TipoFrecuencia =  (	select  max(d.Ttipopago) 
							from  HPagosEmpleado a, 
								  CalendarioPagos c,
								  TiposNomina d
							where a.DEid = #reporte#.DEid
								and a.PEtiporeg = 0
								and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and c.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
								and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
								and c.CPid = a.RCNid
								and c.Tcodigo=d.Tcodigo
								and c.Ecodigo=d.Ecodigo
						  )					
</cfquery>

<!---- Modificación SOLO para el caso de Semanales
		si la periodicidad es semanal y la cantidad de días mayor a 26, entonces la cantidad de días será siempre 26----->
<cfquery datasource="#session.DSN#">
	update #reporte#
		set dias = 26
	where  TipoFrecuencia = 0
	and dias > 26
</cfquery>
<>
<!--- LZ 1-4-2009, Si la Cantidad días Nómina Laborados es Mayor a 31 días (3 Bisemanas) La Cantidad de días no puede superar ese número --->
<cfquery datasource="#session.DSN#">
	update #reporte# set dias = 31 where dias > 31
</cfquery>


<!--- LZ establece segun la Maxima Jornada de la Nómina, la cantidad de dias que trabaja realmente según las horas diarias --->
<!--- Establezco un Facto de Pago de Día en base a la cantidad de horas normales por jornada y la cantidad de horas indicadas que tiene la jornda --->
<cfquery datasource="#session.DSN#">
	update #reporte#
		set FactorHoras = (Select case when a.RHJtipo=0 then
										(8 / RHJhoradiaria) <!---Jornada Diurna --->
								  	  when a.RHJtipo=1 then
										(7 / RHJhoradiaria) <!---Jornada Mixta  --->
								 else
										(6 / RHJhoradiaria) <!---Jornada Diurna --->
								 end
								 from RHJornadas a
								 Where a.RHJid=#reporte#.RHJid)
</cfquery>

<!--- Según el Factor de Día y la cantidad de días asignado, se establece la cantidad de días laborados--->
<cfquery datasource="#session.DSN#">
	update #reporte#
		set dias = floor(dias / FactorHoras)
</cfquery>


<!---
LZ. 10-12-2008 Se comenta condicion, pues correo de  que indica: 
De: Mauricio Madriz/INS [mailto:mmadriz@ins-cr.com]
Enviado el: Miércoles, 10 de Diciembre de 2008 11:15 a.m.
Para: Silvia Gonzalez
Asunto: RE: CONSULTA COOPELESCA REPORTE RIESGOS DEL TRABAJO
Si perdon talvez no me explique bien, tiene que poner los dias que laboro realmente en el mes y poner el salario total que gana, 
porque por vacaciones no se hace ningun cambio por rebajo o cualquier otra cosa.
and RHTcomportam in (4, 5)    


LZ. 10-12-2008 Con base en los Argumentos del Correo indicado en el Comentario anterior 
	unicamente se rebajan días cuando el funcionario no devengue Salario por incapacidades o Permisos SIN SUELDO
	Ademas se deben determinar las Incapacidades según la información de HPagosEmpleado si son Retroactivas 
	y contra RHSaldoPagosExceso si son No Retroactivas
--->

<!---- Resta los días que estuvo Ausente---->

<!---LZ. REBAJO DE DIAS POR INCAPACIDAD RETROACTIVOS --->
		<cfquery datasource="#session.DSN#">
			update #reporte#
				set dias = dias -  coalesce( 
											(select  sum(PEcantdias)
											from HPagosEmpleado a, 
												 DatosEmpleado b, 
												 RHTipoAccion c,
												 CalendarioPagos d
											where 	a.DEid = #reporte#.DEid
													and a.DEid = b.DEid
													and a.RCNid = d.CPid													
													and a.RHTid = c.RHTid
													and d.CPmes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
													and d.CPperiodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPPeriodo#">
													and RHTcomportam = 5
													and a.PEtiporeg=0  <!--- LZ 27-02-2009 Solo debe contemplar los Ordinarios no los Retroactivos --->
											
											) 
										,0)
		</cfquery>	

		
<!---LZ. REBAJO DE DIAS POR INCAPACIDAD NO RETROACTIVOS --->
		<cfset x1 = "'#LSDateFormat(rsFDesde.f1,'dd-mm-yyyy')#'" >
		<cfset y1 = "'#LSDateFormat(rsFhasta.f2,'dd-mm-yyyy')#'" >
		
		<cf_dbfunction name="datediff" args="#preservesinglequotes(x1)#, DLfvigencia"	returnvariable="difd3">
		<cf_dbfunction name="datediff" args="#preservesinglequotes(y1)#, DLffin" 		returnvariable="difd4">
		
				<cfquery datasource="#session.DSN#">
					update #reporte#
						set dias = dias -  coalesce( 
													(select  sum(	<cf_dbfunction name="datediff" args="DLfvigencia, DLffin">
																	+1
																	- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> > DLfvigencia then 
																				abs(#preservesinglequotes(difd3)#) else 0 end
																	- case when <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> < DLffin then 
																			    abs(#preservesinglequotes(difd4)#) else 0 end 
																)
													from DLaboralesEmpleado a, 
														 DatosEmpleado b, 
														 RHTipoAccion c,
														 RHSaldoPagosExceso d
													where 	a.DEid = #reporte#.DEid
															and a.DEid = b.DEid
															and a.RHTid = c.RHTid
															and d.DLlinea= a.DLlinea
															and d.RHSPEanulado=0   <!--- Acciones no Anuladas--->
															and  (	a.DLfvigencia 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
																	or a.DLffin 	between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
																	or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between a.DLfvigencia and a.DLffin
																	or <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">	between a.DLfvigencia and a.DLffin
																)
													and RHTcomportam = 5  
													) 
												,0)
				</cfquery>


<!---LZ. REBAJO DE DIAS POR PERMISOS SIN GOCE--->
				<cfquery datasource="#session.DSN#">
					update #reporte#
						set dias = dias -  coalesce( 
													(select  sum(<cf_dbfunction name="datediff" args="PEdesde, PEhasta">+1)
													from HPagosEmpleado a, 
														 DatosEmpleado b, 
														 RHTipoAccion c,
														 CalendarioPagos d
													where 	a.DEid = #reporte#.DEid
															and a.DEid = b.DEid
															and a.RCNid = d.CPid													
															and a.RHTid = c.RHTid
															and d.CPmes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
															and d.CPperiodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPPeriodo#">
															AND RHTpaga=0
															and RHTcomportam = 5
															and a.PEtiporeg=0  <!--- LZ 27-02-2009 Solo debe contemplar los Ordinarios no los Retroactivos --->
													
													) 
												,0)
				</cfquery>
		
<cfquery datasource="#session.DSN#">
	update #reporte#
		set dias = case when  dias < 0 then 0 else dias end
</cfquery>

<!---- SOBRE LOS DIAS REALES LABORADOS, SE CALCULAS LAS HORAS LABORADAS--->
<cfquery name="r" datasource="#session.DSN#">
	update #reporte#
		set horas =  dias * (Select coalesce(RHJhoradiaria,8)
							 from RHJornadas jo
							 Where jo.RHJid  = #reporte#.RHJid
							 and jo.Ecodigo= #session.Ecodigo#
					)
</cfquery>

<!---- Modificación SÓLO para el caso de Semanales
 si la periodicidad es semanal y la cantidad de horas mayor a 208, entonces la cantidad de horas será siempre 208---->
		<cfquery datasource="#session.DSN#">
			update #reporte#
				set horas = 208
			where DEid in (	select DEid from DLaboralesEmpleado a, TiposNomina b
							where a.Tcodigo = b.Tcodigo
								and b.Ttipopago = 0
							)
				and horas > 208
		</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte#
		set horas = case when  horas < 0 then 
						0 
					else 
						horas 
					end
	</cfquery>

<!---- Actualizar el monto de salario tomando en cuenta las incidencias aplicadas ---->
	<cfquery datasource="#session.DSN#">
		update #reporte#
			set salario = salario + coalesce((select sum(ic.ICmontores)
												from HIncidenciasCalculo ic, 
													CalendarioPagos c,
													CIncidentes ci
												where ic.DEid = #reporte#.DEid
												  and c.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
												  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
												  and ic.RCNid = c.CPid
												  and ci.CIid = ic.CIid
												  and ci.CInocargasley = 0)
									, 0.00)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte#
		set salario = salario + coalesce((select sum(ic.ICmontores)
										from IncidenciasCalculo ic, 
											CalendarioPagos c,
											CIncidentes ci
										where ic.DEid = #reporte#.DEid
										  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPperiodo#">
										  and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPmes#">
										  and ic.RCNid = c.CPid
										  and ci.CIid = ic.CIid
										  and ci.CInocargasley = 0	)
								, 0.00)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set salario = round(salario,0)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set dias = 1 
		where salario < 100 
			and salario > 0
	</cfquery>

	
<!---actualiza incapacidades CCSS--->
	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '03'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh
						where #reporte#.DEid =  sp.DEid 
							and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  (	(sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between sp.DLfvigencia and sp.DLffin) 
									or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin)
								 )
							and  sp.RHTid = rh.RHTid 
							and  sp.Ecodigo = rh.Ecodigo 
							and  sp.DLestado = 0
							and  rh.RHTcomportam = 5 
							and rh.RHTdatoinforme in ('MAT', 'SEM')
					)
	</cfquery>	
	
<!----actualiza incapacidades INS---->

	<cfquery datasource="#session.DSN#">
		update #reporte# 
			set condicion = '04'
		where exists(	select 1 
						from DLaboralesEmpleado sp, RHTipoAccion rh
						where #reporte#.DEid =  sp.DEid 
							and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  (	(sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
									or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
								   	or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  between sp.DLfvigencia and sp.DLffin) 
								   	or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin)
								  )
							and  sp.RHTid = rh.RHTid 
							and  sp.Ecodigo = rh.Ecodigo 
							and  sp.DLestado = 0
							and  rh.RHTcomportam = 5 
							and rh.RHTdatoinforme = 'INS'
					)
	</cfquery>


	
<!----NOMBRADOS Y CESADOS EN EL MISMO MES. ---->
<cfquery datasource="#session.DSN#">
	update #reporte# 
		set condicion = '05'
	where exists(	select 1 
					from DLaboralesEmpleado sp, RHTipoAccion rh
					where #reporte#.DEid =  sp.DEid 
						and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
								or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
							   or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between sp.DLfvigencia and sp.DLffin) 
							   or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin))
						and  sp.RHTid = rh.RHTid 
						and  sp.Ecodigo = rh.Ecodigo 
						and  sp.DLestado = 0 
						and  rh.RHTcomportam = 1
						and exists (Select 1 
									from DLaboralesEmpleado  dle, RHTipoAccion rht
									Where sp.DEid=dle.DEid
									and dle.RHTid=rht.RHTid
									and rht.RHTcomportam= 2 <!--- CESE  --->
									and dle.DLfvigencia > sp.DLfvigencia)
				)
</cfquery>


<!----/*actualiza Permisos */---->
<cfquery datasource="#session.DSN#">
	update #reporte# 
		set condicion = '06'
	where exists(	select 1 
					from DLaboralesEmpleado sp, RHTipoAccion rh
					where #reporte#.DEid =  sp.DEid 
						and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
								or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">) 
							   	or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> between sp.DLfvigencia and sp.DLffin) 
							   	or (<cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#"> between sp.DLfvigencia and sp.DLffin))
						and  sp.RHTid = rh.RHTid 
						and  sp.Ecodigo = rh.Ecodigo 
						and  sp.DLestado = 0 
						and  rh.RHTcomportam = 4						
				)
</cfquery>


<!----/*actualiza ingreso*/----->
<cfquery datasource="#session.DSN#">
	update #reporte# 
		set condicion = '01'
	where exists(	select 1 
					from DLaboralesEmpleado sp, RHTipoAccion rh
					where #reporte#.DEid =  sp.DEid 
						and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
						and  sp.RHTid = rh.RHTid 
						and  sp.Ecodigo = rh.Ecodigo 
						and sp.DLestado = 0 
						and  rh.RHTcomportam = 1
						and not exists (Select 1 
									from DLaboralesEmpleado  dle, RHTipoAccion rht
									Where sp.DEid=dle.DEid
									and dle.RHTid=rht.RHTid
									and rht.RHTcomportam= 2 <!--- CESE  --->
									and dle.DLfvigencia > sp.DLfvigencia)							
				)
</cfquery>

<!----/*actualiza egresos*/---->
<cfquery datasource="#session.DSN#">
	update #reporte# 
		set condicion = '02'
	where exists(	select 1 
					from DLaboralesEmpleado sp, RHTipoAccion rh 
					where #reporte#.DEid =  sp.DEid
					and  sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFhasta.f2#">
					and  sp.RHTid = rh.RHTid 
					and  sp.Ecodigo = rh.Ecodigo 
					and  sp.DLestado = 0 
					and  rh.RHTcomportam = 2
					and  exists (Select 1 
								from DLaboralesEmpleado  dle, RHTipoAccion rht
								Where sp.DEid=dle.DEid
								and dle.RHTid=rht.RHTid
								and rht.RHTcomportam= 1 <!--- NOMBRAMIENTO  --->
								and dle.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">)						
				)
</cfquery>

<!-----/*actualiza jornadas completas*/----->
		<cfquery datasource="#session.DSN#">
			update #reporte# 
				set jornada = '01'
			where RHJid in (Select RHJid
							from RHJornadas a
							Where RHJhoradiaria >= 8
						)
		</cfquery>	
		
<!-----/*actualiza jornadas incompletas*/----->
		<cfquery datasource="#session.DSN#">
			update #reporte# 
				set jornada = '01'
			where RHJid in (Select RHJid
							from RHJornadas a
							Where RHJhoradiaria < 8
						)
		</cfquery>	
		
<!-----/*actualiza jornadas destajo*/----->
		<cfquery datasource="#session.DSN#">
			update #reporte# 
				set jornada = '04'
			where RHJid in (Select RHJid
							from RHJornadas a
							Where RHJornadahora =1
						)
		</cfquery>	


<!----/* se borra a los funcionarios que fueron cesados antes de este mes pero que ses pago algo en este periodo */---->
<cfquery datasource="#session.DSN#">
	delete #reporte# 
	where not exists (select 1 
					from LineaTiempo lt 
					where lt.DEid = #reporte#.DEid 
						and lt.LThasta >=<cfqueryparam cfsqltype="cf_sql_date" value="#rsFDesde.f1#">)
</cfquery>

<!--- **************************---> 
<!--- quita todas las tildes    --->
<!--- **************************--->
<!--- mayúsculas---> 
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'Á','A'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'Á','A'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'Á','A'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'É','E'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'É','E'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'É','E'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'Í','I'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'Í','I'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'Í','I'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'Ó','O'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'Ó','O'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'Ó','O'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'Ú','U'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'Ú','U'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'Ú','U'">
</cfquery>
<!--- minúsculas --->
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'á','a'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'á','a'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'á','a'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'é','e'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'é','e'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'é','e'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'í','i'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'í','i'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'í','i'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'ó','o'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'ó','o'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'ó','o'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'ú','u'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'ú','u'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'ú','u'">
</cfquery>
<!--- ñ's --->
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'Ñ','N'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'Ñ','N'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'Ñ','N'">
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #reporte# set 
	apellido1 	= <cf_dbfunction name="string_replace"   args="apellido1,'ñ','n'">,
	apellido2 	= <cf_dbfunction name="string_replace"   args="apellido2,'ñ','n'">,
	nombre 	= <cf_dbfunction name="string_replace"   args="nombre,'ñ','n'">
</cfquery>


<!----- inserta la cuarta linea  --->
<cfset vs_salida3 =
				RepeatString(' ',7-len(mid(trim('#vNumPoliza#'),1,7))) &  				<!--- Espacios Relleno --->
				mid('#vNumPoliza#',1,7)&  												<!--- Numero Poliza --->
			   'M'&  																			<!--- Constante --->
				url.CPperiodo & 																<!--- Año reporte --->
				RepeatString('0',2-len(trim(url.CPmes)))&  										<!--- Ceros Relleno Para el Mes--->	
				trim(url.CPmes)&																<!--- Mes Reporte --->	
				' '&																			<!--- Espacio Constante --->	
				trim(mid(rsDatosEmpresa.Eidentificacion,1,10))& 	           					<!--- Cedula Jurídica Empresa (10 Digitos) --->	
				RepeatString(' ',10-len(mid(trim(rsDatosEmpresa.Eidentificacion),1,10)))&		<!--- Se Rellena con Espacios --->	
				RepeatString('0',8-len(mid(trim(rsDatosEmpresa.Etelefono1),1,8)))&				<!--- Se Rellena con Ceros el Telefono --->	
				trim(mid(rsDatosEmpresa.Etelefono1,1,8))&										<!--- Telefono 1 --->	
				RepeatString('0',8-len(mid(trim(rsDatosEmpresa.Etelefono1),1,8)))&				<!--- Se Rellena con Ceros el Telefono 2 --->	
				trim(mid(rsDatosEmpresa.Efax,1,8))
>



<cf_dbfunction name="string_part" args="rtrim(numseguro)|1|25" 	returnvariable="Lvarnumseguro"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarnumseguro#"  		returnvariable="LvarnumseguroL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|25-coalesce(#LvarnumseguroL#,0)" 	returnvariable="LvarnumseguroS" delimiters="|">
				
				
<cf_dbfunction name="string_part" args="rtrim(nombre)|1|15" 	returnvariable="Lvarnombre"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarnombre#"  		returnvariable="LvarnombreL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|15-coalesce(#LvarnombreL#,0)" 	returnvariable="LvarnombreS" delimiters="|">
				
<cf_dbfunction name="string_part" args="rtrim(apellido1)|1|15" 	returnvariable="Lvarapellido1"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarapellido1#"  		returnvariable="Lvarapellido1L" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|15-coalesce(#Lvarapellido1L#,0)" 	returnvariable="Lvarapellido1S" delimiters="|">
				
<cf_dbfunction name="string_part" args="rtrim(apellido2)|1|15" 	returnvariable="Lvarapellido2"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarapellido2#"  		returnvariable="Lvarapellido2L" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|15-coalesce(#Lvarapellido2L#,0)" 	returnvariable="Lvarapellido2S" delimiters="|">

<cf_dbfunction name="to_char" args="coalesce(salario,0)" 	returnvariable="Lvarsalario">
		<cf_dbfunction name="string_part" args="#Lvarsalario#|1|10" 	returnvariable="Lvarsalario2"  delimiters="|">
			<cf_dbfunction name="length"      args="#Lvarsalario2#"  		returnvariable="Lvarsalario2L" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|10-coalesce(#Lvarsalario2L#,0)" 	returnvariable="Lvarsalario2S" delimiters="|">
						<cf_dbfunction name="sReplace"     args="#Lvarsalario2#|'.'|','" 	returnvariable="Lvarsalario2F" delimiters="|">
													
<!---
<cf_dbfunction name="to_char" args="coalesce(salario,0)" 	returnvariable="Lvarsalario">
<!--- <cf_dbfunction name="concat"	args="#Lvarsalario#,'.00'" 	returnvariable="Lvarsalario"> --->
		<cf_dbfunction name="string_part" args="#Lvarsalario#|1|13" 	returnvariable="Lvarsalario2"  delimiters="|">
			<cf_dbfunction name="length"      args="#Lvarsalario2#"  		returnvariable="Lvarsalario2L" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|13-coalesce(#Lvarsalario2L#,0)" 	returnvariable="Lvarsalario2S" delimiters="|">
						<cf_dbfunction name="sReplace"     args="#Lvarsalario2#|'.'|','" 	returnvariable="Lvarsalario2F" delimiters="|">
--->						
						
						

<cf_dbfunction name="to_char" args="dias" 	returnvariable="Lvardias">
		<cf_dbfunction name="string_part" args="#Lvardias#|1|3" 	returnvariable="Lvardias2"  delimiters="|">
			<cf_dbfunction name="length"      args="#Lvardias2#"  		returnvariable="Lvardias2L" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|3-coalesce(#Lvardias2L#,0)" 	returnvariable="Lvardias2S" delimiters="|">
				
<cf_dbfunction name="to_char" args="horas" 	returnvariable="Lvarhoras">
		<cf_dbfunction name="string_part" args="#Lvarhoras#|1|4" 	returnvariable="Lvarhoras2"  delimiters="|">
			<cf_dbfunction name="length"      args="#Lvarhoras2#"  		returnvariable="Lvarhoras2L" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|4-coalesce(#Lvarhoras2L#,0)" 	returnvariable="Lvarhoras2S" delimiters="|">

<cf_dbfunction name="string_part" args="jornada|1|2" 	returnvariable="Lvarjornada"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarjornada#"  		returnvariable="LvarjornadaL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|2-coalesce(#LvarjornadaL#,0)" 	returnvariable="LvarjornadaS" delimiters="|">

<cf_dbfunction name="string_part" args="condicion|1|2" 	returnvariable="Lvarcondicion"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarcondicion#"  		returnvariable="LvarcondicionL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|2-coalesce(#LvarcondicionL#,0)" 	returnvariable="LvarcondicionS" delimiters="|">

<cf_dbfunction name="string_part" args="ocupacion|1|5" 	returnvariable="Lvarocupacion"  delimiters="|">
		<cf_dbfunction name="length"      args="#Lvarocupacion#"  		returnvariable="LvarocupacionL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|5-coalesce(#LvarocupacionL#,0)" 	returnvariable="LvarocupacionS" delimiters="|">
				
<!---Formato Residencia --->
		<cf_dbfunction name="string_part" args="rtrim(cedula)|1|11" 	returnvariable="LvarcedulaR"  delimiters="|">
				<cf_dbfunction name="length"      args="#LvarcedulaR#"  		returnvariable="LvarcedulaRL" delimiters="|" >
						<cf_dbfunction name="sRepeat"     args="' '|11-coalesce(#LvarcedulaRL#,0)" 	returnvariable="LvarcedulaRS" delimiters="|">
<!---Formato Indocumentado --->
		<cf_dbfunction name="string_part" args="rtrim(cedula)|1|13" 	returnvariable="LvarcedulaI"  delimiters="|">
				<cf_dbfunction name="length"      args="#LvarcedulaI#"  		returnvariable="LvarcedulaIL" delimiters="|" >
						<cf_dbfunction name="sRepeat"     args="' '|13-coalesce(#LvarcedulaIL#,0)" 	returnvariable="LvarcedulaIS" delimiters="|">
<!---Formato Permiso trabajo --->
		<cf_dbfunction name="string_part" args="rtrim(cedula)|1|11" 	returnvariable="LvarcedulaT"  delimiters="|">
				<cf_dbfunction name="length"      args="#LvarcedulaT#"  		returnvariable="LvarcedulaTL" delimiters="|" >
						<cf_dbfunction name="sRepeat"     args="' '|13-coalesce(#LvarcedulaTL#,0)" 	returnvariable="LvarcedulaTS" delimiters="|">
<!---Formato Pasaporte --->
		<cf_dbfunction name="string_part" args="rtrim(cedula)|1|11" 	returnvariable="LvarcedulaP"  delimiters="|">
				<cf_dbfunction name="length"      args="#LvarcedulaP#"  		returnvariable="LvarcedulaPL" delimiters="|" >
						<cf_dbfunction name="sRepeat"     args="'0'|11-coalesce(#LvarcedulaPL#,0)" 	returnvariable="LvarcedulaPS" delimiters="|">
<!---Formato Nacional --->
		<cf_dbfunction name="string_part" args="rtrim(cedula)|1|9" 	returnvariable="LvarcedulaC"  delimiters="|">
				<cf_dbfunction name="length"      args="#LvarcedulaC#"  		returnvariable="LvarcedulaCL" delimiters="|" >
						<cf_dbfunction name="sRepeat"     args="'0'|9-coalesce(#LvarcedulaCL#,0)" 	returnvariable="LvarcedulaCS" delimiters="|">

<cfquery datasource="#session.DSN#">
		insert into #reporte1# (ordenado, salida, apellido1,apellido2)
		select 	4, 	
				case when rtrim(tipoC) = 'R' then
						'1' #CAT# #preservesinglequotes(LvarcedulaR)# #CAT# #preservesinglequotes(LvarcedulaRS)# #CAT# '   ' <!--- Los Primeros 11 Caracteres, Relleno en Blancos, 3Espacios al Final ---> 
					when rtrim(tipoC) = 'I' then
						'5' #CAT# #preservesinglequotes(LvarcedulaI)# #CAT# #preservesinglequotes(LvarcedulaIS)# #CAT# ' ' 	<!--- Los Primeros 13 Caracteres, Relleno en Blancos, 1 Espacios al Final ---> 				
					when rtrim(tipoC) = 'T' then
						'8' #CAT# #preservesinglequotes(LvarcedulaT)# #CAT# #preservesinglequotes(LvarcedulaTS)# #CAT# '   '	<!--- Los Primeros 11 Caracteres, Relleno en Blancos, 3Espacios al Final ---> 				
					when rtrim(tipoC) = 'P' then
						'9' #CAT# #preservesinglequotes(LvarcedulaPS)# #CAT# #preservesinglequotes(LvarcedulaP)# #CAT# '   '	<!--- Los Primeros 11 Caracteres, Relleno en Blancos, 3Espacios al Final ---> 				
					when rtrim(tipoC) = 'C' then
						'0' #CAT# #preservesinglequotes(LvarcedulaCS)# #CAT# #preservesinglequotes(LvarcedulaC)# #CAT# '     '	<!--- Los Primeros 9 Caracteres, Relleno en Blancos, 5 Espacios al Final ---> 				
					when rtrim(tipoC) = 'G' and rtrim(Pais)='CR' then
						'0' #CAT# #preservesinglequotes(LvarcedulaCS)# #CAT# #preservesinglequotes(LvarcedulaC)# #CAT# '     '  <!--- Los Primeros 9 Caracteres, Relleno en Blancos, 5 Espacios al Final --->
					else
						'1' #CAT# #preservesinglequotes(LvarcedulaR)# #CAT# #preservesinglequotes(LvarcedulaRS)# #CAT# '   '  <!--- Los Primeros 11 Caracteres, Relleno en Blancos, 3Espacios al Final ---> 
					end  
				#CAT#
				rtrim(#preservesinglequotes(Lvarnumseguro)#) #CAT# #preservesinglequotes(LvarnumseguroS)# #CAT#
				rtrim(#preservesinglequotes(Lvarnombre)#)   #CAT# #preservesinglequotes(LvarnombreS)# #CAT#
				rtrim(#preservesinglequotes(Lvarapellido1)#) #CAT# #preservesinglequotes(Lvarapellido1S)# #CAT# 
				rtrim(#preservesinglequotes(Lvarapellido2)#) #CAT# #preservesinglequotes(Lvarapellido2S)# #CAT#
				#preservesinglequotes(Lvarsalario2S)# #CAT# rtrim(#preservesinglequotes(Lvarsalario2F)#)   #CAT# '.00' #CAT#
				#preservesinglequotes(Lvardias2S)# #CAT# #preservesinglequotes(Lvardias2)# #CAT#
				#preservesinglequotes(Lvarhoras2S)# #CAT# #preservesinglequotes(Lvarhoras2)# #CAT#
				#preservesinglequotes(LvarjornadaS)# #CAT# #preservesinglequotes(Lvarjornada)# #CAT#
				#preservesinglequotes(LvarcondicionS)# #CAT# #preservesinglequotes(Lvarcondicion)# #CAT#
				#preservesinglequotes(LvarocupacionS)# #CAT# #preservesinglequotes(Lvarocupacion)#
				as salida,
				apellido1,
				apellido2			
		from #reporte#
		where salario > 0
			and (	
					(	dias > 0 
					 	or 	(
								dias = 0 
								and condicion in ('03','04','05')
							)
					)
				)	
		order by apellido1, apellido2
	</cfquery>
	
<cfquery name="ERR" datasource="#session.DSN#">
	select salida from #reporte1# 
	order by ordenado,apellido1, apellido2
</cfquery>
		
