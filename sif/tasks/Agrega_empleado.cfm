<!---
Ljimenez la funcionalidad de este cfm es la inclucion de empleados nombrados en SOIN
a las tabla de empleados de exactus puntos a tomar en cuenta
- exactus maneja bases de datos diferentes para cada empresa por tamto debemos tener un DSN para c/u
- en la tabla de parametros PurdyParam
- el proceso o tarea se ejecuta para cada una de las empresas definidas en la tabla de parametros
- se incluyen valores defaul para algunos campos
- se genera un log de errores para los empleados que no se incluyeron
- el error se presenta por que no existe el centro de costo en la tabla Centro_Costo en exactus.
--->
<cfset start = Now()>
<cfoutput>
	<strong>Proceso Agregar Empleados a Exactus</strong><br>
	<strong>Iniciando proceso</strong> #TimeFormat(start,"HH:MM:SS")#<br>
</cfoutput>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_NOTC"
	Default="No existen datos para generar"
	returnvariable="MG_NOTC"/> 
		
<!---sesion remota ambiente de pruebas--->
<!--- <cfset purdymo="purdy"> --->

<cfset purdymo="minisif">
<cfset session.dsn="minisif">

<cfquery name="rsEmpresas" datasource="#purdymo#">
	select Ecodigo,Datasource
		from PurdyParam
</cfquery>

<cfif isdefined("rsEmpresas") and rsEmpresas.RecordCount neq 0>
	<cfloop query="rsEmpresas">
		<cfset purdy="#rsEmpresas.Datasource#">
		
		<cfset session.Ecodigo = rsEmpresas.Ecodigo>
		
		<cfoutput><strong>Verificando Empresa #rsEmpresas.Ecodigo#</strong><br></cfoutput> 
		
		<cfsetting requesttimeout="8600">
		
		<cfset nopago1 = CreateDate(6001, 01, 01)>
		
		<cfquery name="rsEmp_Exa" datasource="#purdy#">
			select identificacion,activo
				from Empleado
		</cfquery>
		
		<cfquery datasource="#purdymo#">
			delete from PurdyEmp
		</cfquery>
		
		<cfloop query="rsEmp_Exa">
			<cfquery datasource="#purdymo#">
				insert into PurdyEmp (DEidentificacion,Activo) values ('#rsEmp_Exa.identificacion#','#rsEmp_Exa.activo#')
			</cfquery>
		</cfloop>
		
		<cfquery name="rsParam" datasource="#purdymo#" >
			select *
			from PurdyParam
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfquery name="rsEmp" datasource="#purdymo#" >
			
			select distinct l.LTid,rtrim(b.DEidentificacion) as DEidentificacion, b.DEnombre, b.DEapellido1, b.DEapellido2, (b.DEnombre+' '+b.DEapellido1+ ' '+ b.DEapellido2) as nombre,
				b.DEsexo,b.DEdato5,b.DEidentificacion,
				l.LTdesde,l.LThasta,b.Tcodigo, l.Dcodigo, rtrim(c.Deptocodigo) as Deptocodigo,c.Ddescripcion,rtrim(l.RHPcodigo) as RHPcodigo,d.RHPdescpuesto, l.RHPid,e.RHPcodigo, e.RHPdescripcion,
				l.Tcodigo, e.CFid,  rtrim(f.CFcodigo) as CFcodigo, f.CFdescripcion, b.DEfechanac, 'Pendiente' as Ubicacion,  b.Ppais,  b.DEcivil,  b.DEcantdep,
				b.DESeguroSocial, b.DEdato3, b.DEdato3, l.LTsalario,h.Ttipopago, b.DEcuenta, b.CBcc, l.RHJid, rtrim(g.RHJcodigo) as RHJcodigo, g.RHJdescripcion,
				substring(b.DEtelefono1,1,20) as DEtelefono1, substring(b.DEtelefono2,1,20) as DEtelefono2, b.DEemail,
				l.CPid, a.RHTid, a.Ecodigo, a.RHTdesc, a.RHTcomportam, substring(b.DEdireccion,1,254) as DEdireccion, b.DEid, b.CBTcodigo,
				i.Exactus as Pais
			from LineaTiempo l
				inner join RHTipoAccion a on (l.RHTid = a.RHTid) and ( RHTcomportam = 1)
				inner join DatosEmpleado b on l.DEid = b.DEid and b.DEidentificacion  not in (select DEidentificacion from PurdyEmp)
				inner join Departamentos c on l.Dcodigo = c.Dcodigo and c.Ecodigo = l.Ecodigo
				inner join RHPuestos d on l.RHPcodigo = d.RHPcodigo and d.Ecodigo = l.Ecodigo
				inner join RHPlazas e on l.RHPid = e.RHPid and e.Ecodigo = l.Ecodigo
				inner join CFuncional f on f.CFid = e.CFid
				inner join RHJornadas g on g.RHJid = l.RHJid
				inner join TiposNomina h on l.Tcodigo = h.Tcodigo
				inner join PurdyEquivale i on i.Ecodigo = l.Ecodigo and i.Detalle = 'Pais' and b.Ppais = i.Soin
				
			where l.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and getdate() between l.LTdesde and l.LThasta
		
		</cfquery>
		<cfset fdesde = #LSDateFormat(rsEmp.LTdesde, "dd-mm-yyyy")# >
		<cfset nopago = #LSDateFormat(nopago1, "dd-mm-yyyy")# >
		
		<cfif isdefined("rsEmp") and rsEmp.RecordCount neq 0>
		<cfset registros = 0>
			<cfloop query="rsEmp"> 
				<cfset fdesde = #LSDateFormat(rsEmp.LTdesde, "dd-mm-yyyy")# >
				<cfset fnaci  = #LSDateFormat(rsEmp.DEfechanac, "dd-mm-yyyy")# >
		
				<cfset Paso = 1>
				
				<cfquery name="rsCC_Exa" datasource="#purdy#">
					select centro_costo
						from Centro_Costo
						where Centro_Costo = '#rsEmp.CFcodigo#'
				</cfquery>
				<cfif isdefined("rsCC_Exa") and rsCC_Exa.RecordCount neq 0>
				<cfelse>
					<cfset Paso = 2>
					<cfoutput>Empleado: #rsEmp.DEidentificacion# - #rsEmp.nombre# Centro Costo - #rsEmp.CFcodigo# <br></cfoutput>
				</cfif>
				
				<cfif Paso EQ 1>
					<cfset registros = registros + 1>
					
					<cfquery datasource="#purdy#">
						insert into empleado (
							empleado,
							nombre,
							sexo, 
							tipo_sangre,
							estado_empleado,
							activo,
							identificacion,
							fecha_ingreso,
							departamento,
							puesto,
							plaza,
							nomina,
							centro_costo,
							fecha_nacimiento,
							ubicacion,
							pais,
							estado_civil,
							dependientes,
							asegurado,
							vacs_pendientes,
							vacs_ult_calculo,
							salario_referencia,
							forma_pago,
							horario,
							fecha_no_pago,
							tipo_salario_aumen,
							primer_apellido,
							segundo_apellido,
							nombre_pila,
							e_mail,
							telefono1,
							telefono2,
							direccion_hab
						) values (
							'#rsEmp.DEidentificacion#',		<!---empleado--->
							'#rsEmp.nombre#',				<!---nombre--->	
							'#rsEmp.DEsexo#',				<!---sexo--->
							'#rsEmp.DEdato5#',				<!---tipo_sangre--->
							'#rsParam.Estado_Empleado#',	<!---estado_empleado--->
							'#rsParam.Activo#',	 			<!---activo--->
							'#rsEmp.DEidentificacion#',		<!---identificacion--->
							to_date('#fdesde#','DD-MM-YYYY'),	<!---fecha_ingreso--->
							'#rsParam.Departamento#',		<!---departamento--->	<!---Deptocodigo, --->
							'#rsParam.Puesto#',				<!---puesto--->			<!---RHPcodigo,--->
							'#rsParam.Plaza#',				<!---plaza--->			<!---RHPcodigo--->
							'#rsParam.Nomina#',				<!---nomina--->			<!---Ttipopago,--->	<!---CODIGO DE LA NOMINA--->
							'#rsEmp.CFcodigo#',				<!---centro_costo--->
							to_date('#fnaci#','DD-MM-YYYY'),<!---fecha_nacimiento--->
							<!---'#rsEmp.CFcodigo#',--->	<!---???--->	<!---ubicacion--->
							'#rsParam.Ubicacion#',			<!---???--->	<!---ubicacion--->
							<!---'#rsPais_Exa.Pais#',--->
							'#rsEmp.Pais#',					<!---pais--->
		
							case #rsEmp.DEcivil#			<!---estado_civil---> 
								when 0 then 'S'
								when 1 then 'C'
								when 2 then 'D'
								when 3 then 'V'
								when 4 then 'U'
								when 5 then 'O'
							end,				
							#rsEmp.DEcantdep#,						<!---dependientes--->
							'#rsEmp.DEdato3#',						<!---asegurado--->
							0,										<!---vacs_pendientes--->
							to_date('#fdesde#','DD-MM-YYYY'),		<!---vacs_ult_calculo--->
							#rsEmp.LTsalario#,						<!---salario_referencia--->
							'#rsParam.Forma_Pago#',					<!--- T/E --->
							'#rsParam.Horario#',					<!---CODIGO DE LA HORARIO --->
							to_date('#nopago#','DD-MM-YYYY'),		<!---fecha_no_pago--->
							'#rsParam.Tipo_Salario_Aumento#',		<!---tipo_salario_aumen--->
							'#rsEmp.DEapellido1#', 					<!---primer_apellido--->
							'#rsEmp.DEapellido2#',					<!---segundo_apellido--->
							'#rsEmp.DEnombre#',						<!---nombre_pila--->
							'#rsEmp.DEemail#',						<!---e_mail--->
							'#rsEmp.DEtelefono1#',					<!---telefono1--->
							'#rsEmp.DEtelefono2#',					<!---telefono2--->
							'#rsEmp.DEdireccion#'					<!---direccion_hab--->
							)									
					</cfquery>
					<cfelse>
						<cfoutput>El Empleado NO fue Incluido <br></cfoutput>
						<cfoutput><br></cfoutput>
					</cfif>
			</cfloop> 
			<cfoutput>Cantidad de registros APLICADOS: #registros# de un total de #rsEmp.RecordCount# <br></cfoutput>
		</cfif>		
	</cfloop>
<cfelse>
	<cfoutput>* * * No hay datos para aplicar * * * <br></cfoutput>
</cfif>
<cfset finish = Now()>
<cfoutput>
	<strong>Finalización del Proceso </strong> #TimeFormat(finish,"HH:MM:SS")#<br>
	<strong></strong>* * * Proceso Concluido * * *</strong> <br>
</cfoutput>













