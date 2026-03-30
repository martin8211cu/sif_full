<!--- 
	Modificado por: Rodolfo Jimnez Jara
	Fecha de modificacin: 15 de Junio del 2005
	Motivo: Agregar Parmetros para la demo.
	
 --->	

<cfquery datasource="#session.DSNnuevo#">
	if not exists (select 1 from Oficinas 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin
		insert INTO Oficinas (Ecodigo, Ocodigo, LPid, id_zona, Oficodigo, Odescripcion, id_direccion, telefono, responsable, pais, 
		BMUsucodigo, Onumpatronal, Oadscrita, Onumpatinactivo, ZEid, CFcuenta)
		select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			   Ocodigo, 
			   LPid, 
			   id_zona, 
			   Oficodigo, 
			   Odescripcion, 
			   id_direccion, 
			   telefono, 
			   responsable, 
			   pais, 
			   BMUsucodigo, 
			   Onumpatronal, 
			   Oadscrita, 
			   Onumpatinactivo, 
			   ZEid, 
			   CFcuenta
		from Oficinas 
		where Ecodigo = #vn_Ecodigo#
	end
</cfquery>
<cfquery datasource="#session.DSNnuevo#">
	if not exists (select 1 from Departamentos 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin
		insert INTO Departamentos 
		(Ecodigo, Dcodigo, Deptocodigo, Ddescripcion, BMUsucodigo)
		select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, 
		   Dcodigo, 
		   Deptocodigo, 
		   Ddescripcion, 
		   BMUsucodigo
		from Departamentos 
			where Ecodigo = #vn_Ecodigo#
			  <!---and Dcodigo in (161,80)<!----(26,80)---->---->
	end
</cfquery>

<cfquery datasource="#session.DSNnuevo#">
	if not exists (select 1 from Bancos 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin
		insert INTO Bancos
			(Ecodigo, Bdescripcion, Bdireccion, Btelefon, Bfax, Bemail, Iaba, EIid, BMUsucodigo)
			select 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
			Bdescripcion, 
			Bdireccion, 
			Btelefon, 
			Bfax, 
			Bemail, 
			Iaba, 
			EIid, 
			BMUsucodigo
		from Bancos 
		where Ecodigo = #vn_Ecodigo# 
			<!---and Bdescripcion like '%Banco Nacional%'--->
	end
</cfquery>
<cfquery datasource="#session.DSNnuevo#">
	if not exists (select 1 from RHJornadas 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin
		insert into RHJornadas 
		(Ecodigo, 
		  RHJcodigo, 
		  RHJdescripcion, 
		  RHJsun, 
		  RHJmon, 
		  RHJtue, 
		  RHJwed, 
		  RHJthu, 
		  RHJfri, 
		  RHJsat, 
		  RHJhoraini, 
		  RHJhorafin, 
		  RHJhorainicom, 
		  RHJhorafincom, 
		  RHJhoradiaria, 
		  RHJmarcar, 
		  BMUsucodigo, 
		  RHJhorasemanal, 
		  RHJdiassemanal, 
		  RHJornadahora, 
		  RHJtipo)
		select 
		   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
		   RHJcodigo, 
		   RHJdescripcion, 
		   RHJsun, 
		   RHJmon, 
		   RHJtue, 
		   RHJwed, 
		   RHJthu, 
		   RHJfri, 
		   RHJsat, 
		   RHJhoraini, 
		   RHJhorafin, 
		   RHJhorainicom, 
		   RHJhorafincom, 
		   RHJhoradiaria, 
		   RHJmarcar, 
		   BMUsucodigo, 
		   RHJhorasemanal, 
		   RHJdiassemanal, 
		   RHJornadahora, 
		   RHJtipo
		from RHJornadas
		where Ecodigo = #vn_Ecodigo# 
		 <!---and RHJcodigo = 'JD'---->
	end
</cfquery>

<cfquery datasource="#session.DSNnuevo#">
	if not exists (select 1 from RegimenVacaciones 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin
		insert into RegimenVacaciones
		(Ecodigo, RVcodigo, Descripcion, RVfecha, Usucodigo, Ulocalizacion, BMUsucodigo)
		select 
		   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
		   RVcodigo, 
		   Descripcion, 
		   RVfecha, 
		   Usucodigo, 
		   Ulocalizacion, 
		   BMUsucodigo
		from RegimenVacaciones 
		where Ecodigo = #vn_Ecodigo#
			 <!--- and RVcodigo = 'GEN'--->
	end
</cfquery>
<cfquery datasource="#session.DSNnuevo#">
	if not exists (select 1 from RHFeriados 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin
		insert  into RHFeriados 
		(Ecodigo, RHFfecha, RHFdescripcion, RHFregional, BMUsucodigo)
		select  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
		  RHFfecha, 
		  RHFdescripcion, 
		  RHFregional, 
		  BMUsucodigo
		from RHFeriados 
		where Ecodigo = #vn_Ecodigo# 
		order by RHFfecha
	end
</cfquery>

<cfquery datasource="#session.DSNnuevo#">
	if not exists (select 1 from RHNiveles 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin
		insert into RHNiveles 
			(Ecodigo, RHNcodigo, RHNdescripcion, BMusuario, BMfecha, BMusumod, BMfechamod, RHNhabcono, RHNequivalencia, BMUsucodigo)
		select 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, 
			RHNcodigo, 
			RHNdescripcion, 
			BMusuario, 
			BMfecha, 
			BMusumod, 
			BMfechamod, 
			RHNhabcono, 
			RHNequivalencia, 
			BMUsucodigo
		from RHNiveles 
		where Ecodigo = #vn_Ecodigo#
	end
</cfquery>

<!---Insertado de CATALOGOS GENERALES, tabla RHECatalogosGenerales (TODOS los catalogos generales)---->  
<cfquery name="RHECatalogosGenerales" datasource="#session.DSNnuevo#">
	if not exists (select 1 from RHECatalogosGenerales 
	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
	begin  
		insert into RHECatalogosGenerales(Ecodigo, RHECGcodigo, RHECGdescripcion, 
										  BMusuario, BMfecha, BMusumod, 
										  BMfechamod, BMUsucodigo)
		select  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
				RHECGcodigo, 
				RHECGdescripcion, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		from RHECatalogosGenerales
		where Ecodigo = #vn_Ecodigo# 
	end
</cfquery>
 
<!---Traer los detalles de catalogos Generales---->
<cfquery name="rsRHDCatalogosGenerales" datasource="#session.DSNnuevo#">
	 select b.RHECGcodigo,a.RHDCGcodigo,a.RHDCGdescripcion, 
	 		a.RHDCGvalor, a.BMusuario,a.BMusumod,
			a.BMUsucodigo
	 from RHDCatalogosGenerales a
	  inner join RHECatalogosGenerales b
	   on a.RHECGid = b.RHECGid
	   and a.Ecodigo = b.Ecodigo
	 where a.Ecodigo = #vn_Ecodigo#   
</cfquery>
 
<cfloop query="rsRHDCatalogosGenerales">
	
	<cfquery name="rs" datasource="#session.DSNnuevo#"><!---para c/u encontrar el RHECGid (identity) que pertenece a ese RHECGcodigo---->
	  select RHECGid from RHECatalogosGenerales
	  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
	   and RHECGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHDCatalogosGenerales.RHECGcodigo#">
	</cfquery>
	
	<cfquery name="rsExiste" datasource="#session.DSNnuevo#"><!---Existe ya el detalle---->
		select 1
		from RHDCatalogosGenerales 		
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#"> 
			and RHDCGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRHDCatalogosGenerales.RHDCGcodigo#">
	</cfquery>
	
	<cfif rsExiste.RecordCount EQ 0>
		<cfquery name="RHDCatalogosGenerales" datasource="#session.DSNnuevo#">
		  insert into RHDCatalogosGenerales (RHECGid, Ecodigo, RHDCGcodigo, 
		  									 RHDCGdescripcion, RHDCGvalor, BMusuario, 
											 BMfecha, BMusumod, BMfechamod, 
											 BMUsucodigo)
		  values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RHECGid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsRHDCatalogosGenerales.RHDCGcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRHDCatalogosGenerales.RHDCGdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRHDCatalogosGenerales.RHDCGvalor#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
		   ) 
		</cfquery>
	</cfif>
</cfloop>

<!---Inserta la configuraciÃ³n del reporte de puestos---->
<cfquery name="rsExisteConfig" datasource="#session.DSNnuevo#">
	select 1 from RHConfigReportePuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>
<cfif isdefined("rsExisteConfig") and rsExisteConfig.RecordCount EQ 0>
	<cfquery datasource="#session.DSNnuevo#">
		insert into RHConfigReportePuestos (Ecodigo, CRPohabilidad, CRPoconocim, 
											CRPomision, CRPoobj, CRPoespecif, 
											CRPoencab, CRPoubicacion, BMusuario, 
											BMfecha, BMusumod, BMfechamod, 
											CRPeini, CRPehabilidad, CRPeconocim, 
											CRPemision, CRPeobjetivo, CRPeespecif, 
											CRPeencab, CRPeubicacion, CRPihabilidad, 
											CRPiconocimi, CRPimision, CRPiobj, 
											CRPiespecif, CRPiencab, CRPiubicacion, 
											BMUsucodigo, CRPepie, CRPipie)
		select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
				CRPohabilidad, 
				CRPoconocim, 
				CRPomision, 
				CRPoobj, 
				CRPoespecif, 
				CRPoencab, 
				CRPoubicacion,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				CRPeini, 
				CRPehabilidad, 
				CRPeconocim, 
				CRPemision, 
				CRPeobjetivo, 
				CRPeespecif, 
				CRPeencab, 
				CRPeubicacion, 
				CRPihabilidad, 
				CRPiconocimi, 
				CRPimision, 
				CRPiobj, 
				CRPiespecif, 
				CRPiencab, 
				CRPiubicacion,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">,
				CRPepie, 
				CRPipie
		from RHConfigReportePuestos
		where Ecodigo = #vn_Ecodigo#
	</cfquery>
</cfif>

