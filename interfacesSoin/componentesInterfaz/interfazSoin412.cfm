<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
  
<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
<cfset Ecodigo = #datosXML.row.Ecodigo.xmltext#>
<cfset LvarCedula = #datosXML.row.Cedula.xmltext#>
<cfset LvarNombre = #datosXML.row.Nombre.xmltext#>
<cfset LvarApellido1 = #datosXML.row.Apellido1.xmltext#>
<cfset LvarApellido2= #datosXML.row.Apellido2.xmltext#>
<cfset LvarPuesto = #datosXML.row.Puesto.xmltext#>
<cfset LvarCFuncional = #datosXML.row.Cfuncional.xmltext#>

 <cfinvoke component="rh.Componentes.RH_Funciones" method="init" returnvariable="funciones">
 
<cf_dbtemp name="DEmpleado" returnvariable="DEmpleado">
	<cf_dbtempcol name="DEid" 				type="numeric"		mandatory="yes" >
	<cf_dbtempcol name="DEidentificacion" 	type="varchar(20)"	mandatory="yes" >
	<cf_dbtempcol name="DEnombre" 		 	type="varchar(30)"	mandatory="no" >
	<cf_dbtempcol name="DEapellido1" 		type="varchar(100)"	mandatory="no" >
	<cf_dbtempcol name="DEapellido2" 		type="varchar(100)"	mandatory="no" >
	<cf_dbtempcol name="DEfechanac"			type="datetime"		mandatory="no" >
	<cf_dbtempcol name="DEtelefono1"		type="varchar(50)"	mandatory="no" >
	<cf_dbtempcol name="DEdireccion"		type="varchar(255)"	mandatory="no" >
	<cf_dbtempcol name="DEsexo"				type="char(1)"		mandatory="no" >
	<cf_dbtempcol name="DEemail"			type="varchar(150)"	mandatory="no" >
	<cf_dbtempcol name="Estado"				type="char(1)"		mandatory="no" >
	<cf_dbtempcol name="CodPuesto"			type="char(10)"		mandatory="no" >
	<cf_dbtempcol name="DescPuesto"			type="varchar(60)"	mandatory="no" >
	<cf_dbtempcol name="RHPid"				type="numeric"		mandatory="no" >
	<cf_dbtempcol name="CodPlaza"			type="char(20)"		mandatory="no" >
	<cf_dbtempcol name="DescPlaza"			type="varchar(60)"	mandatory="no" >
	<cf_dbtempcol name="PorcPlaza"			type="numeric"		mandatory="no" >
	<cf_dbtempcol name="CFid"				type="numeric"		mandatory="no" >
	<cf_dbtempcol name="CFcodigo"			type="char(20)"		mandatory="no" >
	<cf_dbtempcol name="CFdescripcion"		type="varchar(60)"	mandatory="no" >
	<cf_dbtempcol name="CFidP"				type="numeric"		mandatory="no" >
	<cf_dbtempcol name="CFcodigoP"			type="char(20)"		mandatory="no" >
	<cf_dbtempcol name="CFdescripcionP"		type="varchar(60)"	mandatory="no" >
	<cf_dbtempcol name="Oficina"			type="char(10)"		mandatory="no" >
	<cf_dbtempcol name="OficDesc"			type="varchar(60)"	mandatory="no" >
	<cf_dbtempcol name="Depto"				type="char(10)"		mandatory="no" >
	<cf_dbtempcol name="DeptoDesc"			type="varchar(60)"	mandatory="no" >
	<cf_dbtempcol name="CodCategoria"		type="char(10)"		mandatory="no" >
	<cf_dbtempcol name="DescCategoria"		type="varchar(60)"	mandatory="no" >
	<cf_dbtempcol name="FechaDesde"			type="datetime"		mandatory="no" >
	<cf_dbtempcol name="FechaHasta"			type="datetime"	    mandatory="no" >
	<cf_dbtempcol name="IDJefe"				type="numeric"	    mandatory="no" >
	<cf_dbtempcol name="GradoAcademico"		type="varchar(60)"  mandatory="no" >
	<cf_dbtempcol name="AñoAnualidad"		type="numeric"	    mandatory="no" >
	<cf_dbtempcol name="FraccionAnualidad"	type="numeric"	    mandatory="no" >
	<cf_dbtempcol name="TipoPlaza"			type="numeric"	    mandatory="no" >
	<cf_dbtempcol name="RHCPlinea"			type="numeric"	    mandatory="no" >
</cf_dbtemp>

<cf_dbfunction name="sReplace" args="DEidentificacion,CHAR(9),''" returnvariable="Lvar_DEidentificacion">
<cf_dbfunction name="sReplace" args="DEnombre,CHAR(9),''" returnvariable="Lvar_DEnombre">
<cf_dbfunction name="sReplace" args="DEapellido1,CHAR(9),''" returnvariable="Lvar_DEapellido1">
<cf_dbfunction name="sReplace" args="DEapellido2,CHAR(9),''" returnvariable="Lvar_DEapellido2">
<cfquery name="Datosempleado" datasource="#session.DsN#">
	insert into #DEmpleado#(DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2,DEfechanac,DEtelefono1,DEdireccion,DEsexo,RHPid,FechaDesde,FechaHasta,Estado,PorcPlaza,TipoPlaza,DEemail,RHCPlinea)
	select a.DEid,
    ltrim(rtrim(#Lvar_DEidentificacion#)),
    ltrim(rtrim(#Lvar_DEnombre#)),
    ltrim(rtrim(#Lvar_DEapellido1#)),
    ltrim(rtrim(#Lvar_DEapellido2#)),
    DEfechanac,DEtelefono1,DEdireccion,DEsexo,RHPid,LTdesde,LThasta,
	case when RHPid is null then '0' else '1' end as Estado,LTporcplaza,1,DEemail,RHCPlinea
	from DatosEmpleado a
	left outer join LineaTiempo b
		on b.DEid = a.DEid
		and b.Ecodigo = a.Ecodigo
		and getdate() between LTdesde and LThasta
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
	<cfif LEN(TRIM(LvarCedula)) and LvarCedula NEQ -1>                       
		and a.DEidentificacion like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(LvarCedula)#%">
	</cfif>	
	<cfif len(trim(LvarNombre)) and LvarNombre NEQ -1>
		and Upper(rtrim(a.DEnombre)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(trim(LvarNombre))#%">	
	</cfif>  
	<cfif len(trim(LvarApellido1)) and LvarApellido1 NEQ -1>
		and Upper(rtrim(a.DEapellido1)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(trim(LvarApellido1))#%">	
	</cfif>  
	<cfif len(trim(LvarApellido2)) and LvarApellido2 NEQ -1>
		and Upper(rtrim(a.DEapellido2)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(trim(LvarApellido2))#%">	
	</cfif>    

</cfquery>

<cfquery name="Datosempleado" datasource="#session.DsN#">
 	insert into #DEmpleado#(DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2,DEfechanac,DEtelefono1,DEdireccion,DEsexo,RHPid,FechaDesde,FechaHasta,PorcPlaza,TipoPlaza,DEemail,RHCPlinea) 
	select a.DEid,ltrim(rtrim(Replace(DEidentificacion,char(9),''))),DEnombre,DEapellido1,DEapellido2,DEfechanac,DEtelefono1,DEdireccion,DEsexo,b.RHPid,LTdesde,LThasta,LTporcplaza,0,DEemail,b.RHCPlinea
	from #DEmpleado# a
	inner join LineaTiempoR b
		on b.DEid = a.DEid
		and getdate() between LTdesde and LThasta
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
	  and b.RHPid not in(select RHPid from #DEmpleado# de where de.DEid = a.DEid)
</cfquery>
<cfquery name="updateD" datasource="#session.DSN#">
	update #DEmpleado#
	set CodPuesto = (select a.RHPcodigo  
				 from RHPuestos a
				 inner join RHPlazas b
					on b.RHPpuesto = a.RHPcodigo
					and b.Ecodigo = a.Ecodigo
				 where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
				   and b.RHPid = #DEmpleado#.RHPid),
		DescPuesto = (select a.RHPdescpuesto 
				 from RHPuestos a
				 inner join RHPlazas b
					on b.RHPpuesto = a.RHPcodigo
					and b.Ecodigo = a.Ecodigo
				 where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
				   and b.RHPid = #DEmpleado#.RHPid),
		CodPlaza = (select RHPcodigo
					from RHPlazas
					where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and RHPid = #DEmpleado#.RHPid),
		DescPlaza = (select RHPdescripcion
					from RHPlazas
					where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and RHPid = #DEmpleado#.RHPid),
		CFid 	= (select CFid
					from RHPlazas
					where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and RHPid = #DEmpleado#.RHPid),
		CFcodigo = (select CFcodigo
					from RHPlazas a
					inner join CFuncional b
						on b.CFid = a.CFid
						and b.Ecodigo = a.Ecodigo
					where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and a.RHPid = #DEmpleado#.RHPid),
		CFdescripcion = (select CFdescripcion
					from RHPlazas a
					inner join CFuncional b
						on b.CFid = a.CFid
						and b.Ecodigo = a.Ecodigo
					where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and a.RHPid = #DEmpleado#.RHPid),
		CFidP 	= (select CFidresp
					from RHPlazas a
					inner join CFuncional b
						on b.CFid = a.CFid
						and b.Ecodigo = a.Ecodigo
					where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and a.RHPid = #DEmpleado#.RHPid)
</cfquery> 
<cfquery name="updateD" datasource="#session.DSN#">
	update #DEmpleado#
	set	CFcodigoP = (select CFcodigo
					from CFuncional b
					where b.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and b.CFid = #DEmpleado#.CFidP),
		CFdescripcionP = (select CFdescripcion
					from CFuncional b
					where b.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and b.CFid = #DEmpleado#.CFidP)
</cfquery>					  
<cfquery name="updateD" datasource="#session.DSN#">
	update #DEmpleado#
	set Oficina = (select Oficodigo
					from CFuncional a
					inner join Oficinas b
						on b.Ocodigo = a.Ocodigo
						and b.Ecodigo = a.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and a.CFid = #DEmpleado#.CFid),
		OficDesc = (select Odescripcion
					from CFuncional a
					inner join Oficinas b
						on b.Ocodigo = a.Ocodigo
						and b.Ecodigo = a.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and a.CFid = #DEmpleado#.CFid),
		Depto = (select Deptocodigo
					from CFuncional a
					inner join Departamentos b
						on b.Dcodigo = a.Dcodigo
						and b.Ecodigo = a.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and a.CFid = #DEmpleado#.CFid),
		DeptoDesc = (select Ddescripcion
					from CFuncional a
					inner join Departamentos b
						on b.Dcodigo = a.Dcodigo
						and b.Ecodigo = a.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					  and a.CFid = #DEmpleado#.CFid)
</cfquery>
<cfquery name="updateD" datasource="#session.DSN#">
	update #DEmpleado#
	set CodCategoria  = ( select c.RHCcodigo
						  from RHCategoriasPuesto b
						  inner join RHCategoria c
							on c.Ecodigo = b.Ecodigo
							and c.RHCid = b.RHCid
						  where b.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
						    and b.RHCPlinea =#DEmpleado#.RHCPlinea),
		DescCategoria = ( select c.RHCdescripcion
						  from RHCategoriasPuesto b
						  inner join RHCategoria c
							on c.Ecodigo = b.Ecodigo
							and c.RHCid = b.RHCid
						  where b.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
						    and b.RHCPlinea =#DEmpleado#.RHCPlinea)
</cfquery>
<cfquery name="updateD" datasource="#session.DSN#">
	update #DEmpleado#
	set AñoAnualidad  = ( select coalesce(EAtotal,0)
							from EAnualidad
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
							  and DEid= #DEmpleado#.DEid
							  and DAtipoConcepto = 2),
		FraccionAnualidad  = ( select coalesce(EAacum,0)
							from EAnualidad
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
							  and DEid= #DEmpleado#.DEid
							  and DAtipoConcepto = 2)
</cfquery>

<cfset LvarPuesto = #datosXML.row.Puesto.xmltext#>
<cfset LvarCFuncional = #datosXML.row.Cfuncional.xmltext#>

<cfquery name="consulta" datasource="#session.DSN#">
	select *
	from #DEmpleado#
	where 1=1
	<cfif LEN(TRIM(LvarPuesto)) and LvarPuesto NEQ -1>
		and DEid in (select DEid from #DEmpleado# where CodPuesto like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LvarPuesto#%">)
	</cfif>
	<cfif LEN(TRIM(LvarCFuncional)) and LvarCFuncional NEQ -1>
		and DEid in (select DEid from #DEmpleado# where CFcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LvarCFuncional#%">)
	</cfif>
</cfquery>
<cfset FechaInf = CreateDate(6100,01,01)>
<cfif consulta.recordCount gt 0 >
	<cfset LvarSalida = "<resulset>">
	<cfloop query="consulta">
		<cfquery name="rsIndef" datasource="#session.DSN#">
			select 1
			from #DEmpleado# 
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#consulta.DEid#">
			  and FechaHasta = <cfqueryparam cfsqltype="cf_sql_date" value="#FechaInf#">
		</cfquery>
		<cfif rsIndef.RecordCount GT 0><cfset Lvar_Indef = 'Indefinido'><cfelse><cfset Lvar_Indef = 'Definido'></cfif>
			<cfset Lvar_DEidJefe = ''>
			<cfset Lvar_NomJefe = ''>
			<cfset Lvar_Ap1Jefe = ''>
			<cfset Lvar_Ap2Jefe = ''>
			<cfif LEN(TRIM(consulta.CFid)) and consulta.CFid GT 0>
				<cfset Lvar_DEidJefe = funciones.DeterminaDEidResponsableCF(consulta.CFid)>
				<cfif LEN(TRIM(Lvar_DEidJefe))>
					<cfquery name="rsRepCF" datasource="#session.DSN#">
						select DEidentificacion,DEnombre,DEapellido1,DEapellido2
						from DatosEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_DEidJefe#">
					</cfquery>
				</cfif>
				<cfif isdefined('rsRepCF') and rsRepCF.RecordCount>
					<cfset Lvar_DEidJefe = rsRepCF.DEidentificacion>
					<cfset Lvar_NomJefe = rsRepCF.DEnombre>
					<cfset Lvar_Ap1Jefe = rsRepCF.DEApellido1>
					<cfset Lvar_Ap2Jefe = rsRepCF.DEApellido2>
				<cfelse>
					<cfset Lvar_DEidJefe = ''>
					<cfset Lvar_NomJefe = ''>
					<cfset Lvar_Ap1Jefe = ''>
					<cfset Lvar_Ap2Jefe = ''>
				</cfif>
			</cfif>
<!--- 		</cfif>
 --->		<cfset LvarSalida &= "<row>	
			<Ecodigo>#Ecodigo#</Ecodigo>
			<DEidentificacion>#rtrim(DEidentificacion)#</DEidentificacion>
			<Nombre>#DEnombre#</Nombre>
			<Apellido1>#DEapellido1#</Apellido1>
			<Apellido2>#DEapellido2#</Apellido2>
			<DEfechanac>#LSDateFormat(DEfechanac,'dd/mm/yyyy')#</DEfechanac>
			<Telefono>#DEtelefono1#</Telefono>
			<Direccion>#DEdireccion#</Direccion>
			<Sexo>#DEsexo#</Sexo>
			<Email>#DEemail#</Email>
			<Estado>#Estado#</Estado>		
			<RHPcodigo>#rtrim(CodPlaza)#</RHPcodigo>
			<RHPdescripcion>#DescPlaza#</RHPdescripcion>
			<CFcodigo>#rtrim(CFcodigo)#</CFcodigo>
			<CFdescripcion>#CFdescripcion#</CFdescripcion>
			<CFcodigoP>#rtrim(CFcodigoP)#</CFcodigoP>
			<CFdescripcionP>#CFdescripcionP#</CFdescripcionP>
			<DLporcplaza>#Porcplaza#</DLporcplaza>
			<Ocodigo>#rtrim(Oficina)#</Ocodigo>
			<Odescripcion>#Oficdesc#</Odescripcion>
			<Dcodigo>#rtrim(Depto)#</Dcodigo>
			<Ddescripcion>#Deptodesc#</Ddescripcion>
			<RHCcodigo>#rtrim(CodCategoria)#</RHCcodigo>
			<RHCdescripcion>#DescCategoria#</RHCdescripcion>
			<DLfvigencia>#LSDateFormat(Fechadesde,'dd/mm/yyyy')#</DLfvigencia>
			<DLffin>#LSDateFormat(Fechahasta,'dd/mm/yyyy')#</DLffin>
			<RHPcodPuesto>#rtrim(CodPuesto)#</RHPcodPuesto>
			<RHPdescpuesto>#descpuesto#</RHPdescpuesto>
			<CedulaJefe>#Lvar_DEidJefe#</CedulaJefe>
			<NomJefe>#Lvar_NomJefe#</NomJefe>
			<Ape1Jefe>#Lvar_Ap1Jefe#</Ape1Jefe>
			<Ape2Jefe>#Lvar_Ap2Jefe#</Ape2Jefe>
			<GradoAcad>Aun no se ha definido el GradoAcad</GradoAcad>			
			<AñoAnualidad>#AñoAnualidad#</AñoAnualidad>
			<FraccionAnualidad>#FraccionAnualidad#</FraccionAnualidad>
			<Nombramiento>#Lvar_Indef#</Nombramiento>
		</row> ">

	</cfloop>
	<cfset LvarSalida &= 
"</resulset>" >
<cfset GvarXML_OE = LvarSalida>
</cfif>