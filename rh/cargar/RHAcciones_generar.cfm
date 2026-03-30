<!---
	******************************************
	* CARGA INICIAL DE ACCIONES DE PERSONAL
	* FECHA DE CREACIÓN:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de generaración final
	* Este archivo requiere es para
	* realizar la copia final de la
	* atabla temporal a la tabla real.
	******************************************
--->

<!--- Notas: --->
<!--- El campo CSid almacena el código del Componente Salarial que se le quiere asignar. --->
<cfsetting requesttimeout="3600">

<!--- ---------------------------------------------------------------------- --->
<!--- Inserta los registros de la tabla CDRHHAcciones en la tabla RHAcciones --->
<!--- ---------------------------------------------------------------------- --->
<cfquery datasource="#Gvar.Conexion#">
	insert into RHAcciones (
		DEid,			RHTid,			Ecodigo,		Tcodigo,
		RVid, 			RHJid, 			RHPid, 			RHPcodigo,
		DLfvigencia, 	DLffin, 		DLsalario, 		DLobs,
		Usucodigo, 		Ulocalizacion,	RHAporc, 		RHAporcsal,
		RHAidtramite, 	IEid,			TEid )

	select
		h.DEid,
		g.RHTid,
		#Gvar.Ecodigo#,
		#Gvar.table_name#.CDRHHtipoNomina,
		b.RVid,
		c.RHJid,
		d.RHPid,
		#Gvar.table_name#.CDRHHpuesto,
		#Gvar.table_name#.CDRHHfechaIni,
		#Gvar.table_name#.CDRHHfechaFin,
		<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHsalario" datasource="#Gvar.Conexion#"> as salario,
		#Gvar.table_name#.CDRHHdescripcion,
		#session.Usucodigo#,
		'00',
		#Gvar.table_name#.CDRHHporcePlaza,
		#Gvar.table_name#.CDRHHporceSalario,
		null,
		null,
		null

	from 	#Gvar.table_name#,
			RegimenVacaciones b,
			RHJornadas c,
			RHPlazas d,
			RHTipoAccion g,
			DatosEmpleado h

	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.CDRHHcedula = h.DEidentificacion
		and #Gvar.table_name#.CDRHHregimen = b.RVcodigo
		and h.Ecodigo = b.Ecodigo
		and #Gvar.table_name#.CDRHHjornada = c.RHJcodigo
		and h.Ecodigo = c.Ecodigo
		and #Gvar.table_name#.CDRHHplaza = d.RHPcodigo
		and h.Ecodigo = #Gvar.Ecodigo#
		and h.Ecodigo = g.Ecodigo
		and h.Ecodigo = d.Ecodigo
		and #Gvar.table_name#.CDRHHtipoAccion = g.RHTcodigo
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<cfquery datasource="#Gvar.Conexion#" name="x1">
	select
		h.DEid,
		g.RHTid,
		#Gvar.Ecodigo#,
		#Gvar.table_name#.CDRHHtipoNomina,
		b.RVid,
		c.RHJid,
		d.RHPid,
		#Gvar.table_name#.CDRHHpuesto,
		#Gvar.table_name#.CDRHHfechaIni,
		#Gvar.table_name#.CDRHHfechaFin,
		<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHsalario" datasource="#Gvar.Conexion#"> as salario,
		#Gvar.table_name#.CDRHHdescripcion,
		0,
		'00',
		#Gvar.table_name#.CDRHHporcePlaza,
		#Gvar.table_name#.CDRHHporceSalario,
		null,
		null,
		null

	from 	#Gvar.table_name#,
			RegimenVacaciones b,
			RHJornadas c,
			RHPlazas d,
			RHTipoAccion g,
			DatosEmpleado h

	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.CDRHHcedula = h.DEidentificacion
		and #Gvar.table_name#.CDRHHregimen = b.RVcodigo
		and h.Ecodigo = b.Ecodigo
		and #Gvar.table_name#.CDRHHjornada = c.RHJcodigo
		and h.Ecodigo = c.Ecodigo
		and #Gvar.table_name#.CDRHHplaza = d.RHPcodigo
		and h.Ecodigo = #Gvar.Ecodigo#
		and h.Ecodigo = g.Ecodigo
		and h.Ecodigo = d.Ecodigo
		and #Gvar.table_name#.CDRHHtipoAccion = g.RHTcodigo
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#

</cfquery>
<!--- Tabla puente para insertar datos en RHDAcciones   --->
<cfquery datasource="#Gvar.Conexion#">
	delete from RHAccionesD
</cfquery>
<!--- ----------------------------------------------------------------------------- --->
<!--- Hay que actualizar en la tabla CDRHHAcciones los ID's' de acciones importadas --->
<!--- ----------------------------------------------------------------------------- --->
<cfquery name="rs" datasource="#Gvar.Conexion#">
	update #Gvar.table_name#
	set CDRHHLinea =  ( select  max(a.RHAlinea)
						from RHAcciones a, DatosEmpleado b, RHTipoAccion c
						where 	a.DLfvigencia 	= #Gvar.table_name#.CDRHHfechaIni

						  and  b.DEid 				= a.DEid
						  and b.Ecodigo 			= a.Ecodigo
						   and b.Ecodigo 			= #Gvar.Ecodigo#
						   and b.DEidentificacion 	= #Gvar.table_name#.CDRHHcedula
							and c.RHTid 				= a.RHTid
								and c.Ecodigo 			= a.Ecodigo
								and c.Ecodigo 			= #Gvar.Ecodigo#
								and c.RHTcodigo 		= #Gvar.table_name#.CDRHHtipoAccion
					  )
	where #Gvar.table_name#.CDPcontrolv = 1
  		and #Gvar.table_name#.CDPcontrolg = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>


<!--- ---------------------------------------------------------- --->
<!--- Valida que no pudo obtener una de las acciones que insertó --->
<!--- ---------------------------------------------------------- --->
<cfquery name="rsAcciones"datasource="#Gvar.Conexion#">
	select 1
	from #Gvar.table_name#
	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.CDRHHLinea is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<cfif rsAcciones.recordcount GT 0 >
		<cfthrow type="Any" message="Error, no se pudo actualizar el id de acci&oacute;n para las acciones insertadas. Inserto #x1.recordcount#. Sin linea #rsAcciones.recordcount#" >
</cfif>

<!--- ---------------------------------------------------------------- --->
<!--- Proceso para Llenar la tabla decomponentes salariales de trabajo --->
<!--- ---------------------------------------------------------------- --->
<cfquery name="rsValidar" datasource="#Gvar.Conexion#">
	select 1
	from #Gvar.table_name#
	where #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from ComponentesSalariales b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and (	#Gvar.table_name#.CDRHHCS1 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS2 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS3 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS4 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS5 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS6 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS7 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS8 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS9 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS10 = b.CScodigo ) )
</cfquery>

<cfif rsValidar.recordcount EQ 0 >

	<cfquery datasource="#Gvar.Conexion#" name="x">
		insert into RHAccionesD (
			CSid,
			CSmonto,
			BMUsucodigo,
			CDRHHLinea )

		select 	#Gvar.table_name#.CDRHHCS1,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto1" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS1 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS2,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto2" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS2 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS3,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto3" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS3 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS4,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto4" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS4 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS5,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto5" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS5 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS6,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto6" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS6 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS7,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto7" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS7 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS8,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto8" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS8 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS9,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto9" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS9 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		union
		select 	#Gvar.table_name#.CDRHHCS10,
				coalesce(<cf_dbfunction name="to_float" args="#Gvar.table_name#.CDRHHCSMonto10" datasource="#Gvar.Conexion#">,0),
				#session.usucodigo#,
				#Gvar.table_name#.CDRHHLinea
		from #Gvar.table_name#
		where CDPcontrolv = 1
			and CDPcontrolg = 0
			and #Gvar.table_name#.CDRHHCS10 is not null
			and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
	</cfquery>


<cfelse >
       <cfthrow type="Any" message="Error, Hay Componentes Salariales no v&aacute;lidos." >
</cfif>

<!--- ------------------------------------------ --->
<!--- Insertar detalle de acciones (componentes) --->
<!--- ------------------------------------------ --->
<cfquery datasource="#Gvar.Conexion#">
	insert into RHDAcciones(
		Usucodigo,				Ulocalizacion,			RHAlinea,
		CSid,					RHDAtabla,				RHDAunidad,
		RHDAmontobase, 			RHDAmontores )

	select
		#session.usucodigo#,	'00',					a.CDRHHLinea,
		b.CSid,					null,					1,
		<cf_dbfunction name="to_float" args="a.CSmonto" datasource="#Gvar.Conexion#">,
		<cf_dbfunction name="to_float" args="a.CSmonto" datasource="#Gvar.Conexion#">

	from RHAccionesD a,
		ComponentesSalariales b

	where a.CSid = b.CScodigo
		and b.Ecodigo = #Gvar.Ecodigo#

</cfquery>

<!--- ------------------------------------------ --->
<!--- Actualiza  Oficina y departamento para la accion  --->
<!--- ------------------------------------------ --->
<cfquery datasource="#gvar.conexion#">
	update RHAcciones
	set Ocodigo = ( select min(Ocodigo)
					from CFuncional cf, #Gvar.table_name# a
					where rtrim(ltrim(cf.CFcodigo)) = rtrim(ltrim(a.CDRHHcentroCosto))
					and a.CDRHHcedula = (	select DEidentificacion
											from DatosEmpleado
											where DEid = RHAcciones.DEid )
					and cf.Ecodigo= RHAcciones.Ecodigo
					and a.Ecodigo =	cf.Ecodigo
				  ),
	    Dcodigo = ( select min(Dcodigo)
					from CFuncional cf, #Gvar.table_name# a
					where rtrim(ltrim(cf.CFcodigo)) = rtrim(ltrim(a.CDRHHcentroCosto))
					and a.CDRHHcedula = (	select DEidentificacion
											from DatosEmpleado
											where DEid = RHAcciones.DEid )

					and cf.Ecodigo= RHAcciones.Ecodigo
					and a.Ecodigo =	cf.Ecodigo
				  )

     	where Ecodigo = #Gvar.Ecodigo#
</cfquery>
<cfquery name="verifCP" datasource="#gvar.conexion#">
	select 1
	from RHCategoriasPuesto
	where Ecodigo = #Gvar.Ecodigo#
</cfquery>
<cfif verifCP.REcordCount>
	<cfquery datasource="#gvar.conexion#">
		update RHAcciones
		set RHCPlinea = (select RHCPlinea
						from RHPuestos b
						inner join RHCategoriasPuesto c
							on c.RHMPPid = b.RHMPPid
							and c.Ecodigo = b.Ecodigo
							and c.RHTTid = RHAcciones.RHTid
						where b.Ecodigo = RHAcciones.Ecodigo
						  and b.RHPcodigo = RHAcciones.RHPcodigo)
		where Ecodigo = #Gvar.Ecodigo#
	</cfquery>
</cfif>