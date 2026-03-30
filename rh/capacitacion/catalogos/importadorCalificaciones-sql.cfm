<cfdump var="#url#">


<cf_dbfunction name="OP_concat" returnvariable="LvarCat">
<cf_dbtemp name="TempTrasAct_v1" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" 	mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 			mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(255)" 	mandatory="no">
</cf_dbtemp>

<!---Eliminar los espacios en blanco--->
<cfquery datasource="#Session.DSN#">
	update #table_name#
	 set DEidentif = rtrim(ltrim(DEidentif))
	where <cf_dbfunction name="length"  args="DEidentif"> <> <cf_dbfunction name="length"  args="rtrim(ltrim(DEidentif))">   
</cfquery>


<cfquery datasource="#Session.DSN#">
	update #table_name#
	 set Calif = rtrim(ltrim(Calif))
	where <cf_dbfunction name="length"  args="Calif"> <> <cf_dbfunction name="length"  args="rtrim(ltrim(Calif))">   
</cfquery>

<cfquery datasource="#Session.DSN#">
	update #table_name#
	 set Minimo = rtrim(ltrim(Minimo))
	where <cf_dbfunction name="length"  args="Minimo"> <> <cf_dbfunction name="length"  args="rtrim(ltrim(Minimo))">   
</cfquery>

<!---Validaciones--->
<!---1.Existencia del curso--->
<cfquery name="rsCheck1" datasource="#Session.Dsn#">
	select count(1) as cantidad 
	from #table_name# t
		inner join RHCursos c
		on c.RHCid=RHCid
		and c.Ecodigo=#session.Ecodigo#
</cfquery>
<cfif rsCheck1.cantidad eq 0>
	<cfquery name="rsError1" datasource="#session.dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		values('El id del curso #form.RHCid# no existe',1,#form.RHCid#)
	</cfquery>
</cfif>

<!---2.Validación del curso--->
<cfquery name="rsCheck2" datasource="#Session.Dsn#">
	select count(1) as cantidad 
	from #table_name# t
		inner join RHCursos c
		  on c.Ecodigo = #session.Ecodigo#
		  and c.RHCtipo != 'P' 
	where c.RHCid=#form.RHCid#
</cfquery>
<cfif rsCheck2.cantidad eq 0>
	<cfquery name="rsError2" datasource="#session.dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		values('El id del curso #form.RHCid# no existe',2,#form.RHCid#)
	</cfquery>
</cfif>

<!---3.Existencia del Empleado--->
<cfquery name="rsCheck3" datasource="#Session.Dsn#">
	select count(1) as cantidad 
	from #table_name# t
		inner join DatosEmpleado d
		  on d.DEidentificacion=t.DEidentif
		  and d.Ecodigo=#session.Ecodigo#
</cfquery>
<cfif rsCheck3.cantidad eq 0>
	<cfquery name="rsError3" datasource="#session.dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		select 'La identificacion no existe',3,t.DEidentif
		from #table_name# t
		where not exists(select 1 from DatosEmpleado d
									  where d.DEidentificacion=t.DEidentif
									  and d.Ecodigo=#session.Ecodigo#)
	</cfquery>
</cfif>

<!---4.Existencia del Empleado en el curso--->
<cfquery name="rsCheck4" datasource="#Session.Dsn#">
	select count(1) as cantidad 
	from #table_name# t
		inner join RHEmpleadoCurso c
		  on c.RHCid=#form.RHCid#
		  and c.RHEMestado = 0
		  and c.RHEStatusCurso = 1
		  and c.DEid=(select DEid from DatosEmpleado where DEidentificacion=t.DEidentif and Ecodigo=#session.Ecodigo#)
</cfquery>
<cfif rsCheck4.cantidad eq 0>
	<cfquery name="rsError4" datasource="#session.dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		select 'La relación entre el Empleado y el Curso no existe',3,t.DEidentif
		from #table_name# t
		where not exists(select 1 from DatosEmpleado d
									  where d.DEidentificacion=t.DEidentif
									  and d.Ecodigo=#session.Ecodigo#)
	</cfquery>
</cfif>

<!---4.Existencia de la nota minima--->
<cfquery name="rsCheck5" datasource="#Session.Dsn#">
	select Minimo
	from #table_name# 
</cfquery>
<cfloop query="rsCheck5">
	<cfif len(trim(rsCheck5.Minimo)) eq 0>
		<cfquery name="rsError5" datasource="#session.dsn#">
			insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
			values('La nota mínima no existe',5,null)
		</cfquery>
	</cfif>
</cfloop>

<cfquery name="err" datasource="#session.dsn#">
	select ErrorNum as Error, Mensaje, DatoIncorrecto 
	from #ERRORES_TEMP#
	order by Error
</cfquery>

<!---Realiza la actualización--->
<cfif (err.recordcount) EQ 0>
	<cfquery name="rs" datasource="#session.dsn#">
		select DEidentif,Calif,Minimo from #table_name#
	</cfquery>
	<cfloop query="rs">
		<cfquery name="insert" datasource="#Session.DSN#">
			update RHEmpleadoCurso
					set RHEMnotamin = #rs.Calif#,
					RHEMnota = #rs.Minimo#<!---,
					RHEMestado = <cfif isdefined("rs.Calif") and len(trim(rs.Calif))>
									<cfif rs.Calif GTE rs.Minimo>
										10
									<cfelseif rs.Calif LTE rs.Minimo>
									 	20
									<cfelse>
										0
									</cfif>
								<cfelse>
									0
								</cfif>					--->			
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  		and DEid = (select DEid from DatosEmpleado where DEidentificacion='#rs.DEidentif#' and Ecodigo=#session.Ecodigo#)
				and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">			
		</cfquery>
	</cfloop>
</cfif>