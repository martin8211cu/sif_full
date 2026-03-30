<!---
------------------------------------------------------------
Codigo del Importador: CRAFTRASLADO
Nombre del Importador: Traslados de Responsables
------------------------------------------------------------
Campos que recibe: 
		1-Aplaca(Activo a trasladar)		  varchar	 20	
		2-DEidentificacion(nuevo Responsable) varchar	 60	
		3-CRTDcodigo(Codigo Tipo Documento)	  varchar	 10	
		4-Fecha(Fecha)					      datetime   12
------------------------------------------------------------
Paso 1: Tabla Temporal de Errores 
Paso 2: Se valida que no venga placas repetidas en el Excel
Paso 3: Se valida que las placas existan en la Empresa
Paso 4: Valida que el nuevo Empleado Exista
Paso 5: Valida que el Tipo de Documento Exista en la empresa
paso 6: Valida que el Activo no Exista ya dentro de la lista de traslados
Paso 7: Valida que el Usuario que realiza la importacion tenga permisos sobre el centro de Custodia del Activo
Paso 8: Valida que el Activo Tenga un responsable Vigente
Paso 9: Valida que el Activo NO Tenga más de un responsable Vigente
Paso 10: Si hay Error lo envia a pantalla para la revision del usuario
Paso 11: Inserta la trasanccion de traslado y la deja pendiente de aplicar.
-------------------------------------------------------------
--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---Paso 1--->
<cf_dbtemp name="ErrCRAFTRASLADO_v1" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Dato"    type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="Mensaje"  type="varchar(255)" mandatory="yes">
</cf_dbtemp>
<!---Paso 2--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select Aplaca, 'La Placa ' #_Cat# Aplaca #_Cat# ' se encuentra ' #_Cat# <cf_dbfunction name="to_char" args="count(1)" isnumber="false"> #_Cat# ' veces en el Archivo'
		from #table_name#
	group by Aplaca
	having count(1) > 1
</cfquery>
<!---Paso 3--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select tm.Aplaca , 'La placa '#_Cat# tm.Aplaca #_Cat# ' corresponde a un Activo Retirado de la empresa #session.enombre#'
		from #table_name# tm
	where exists (select 1 from Activos where Aplaca = tm.Aplaca and Ecodigo =#session.Ecodigo# and Astatus = 60)
	group by tm.Aplaca
</cfquery>
<!---Paso 4--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select tm.DEidentificacion, 'La identificación ' #_Cat# DEidentificacion #_Cat# ' no corresponde a un Empleado de la empresa #session.enombre#'
		from #table_name# tm
	where not exists (select 1 from DatosEmpleado de where de.DEidentificacion = tm.DEidentificacion and de.Ecodigo = #session.Ecodigo#)
	group by tm.DEidentificacion
</cfquery>
<!---Paso 5--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select tm.CRTDcodigo, 'El codigo tipo Documento ' #_Cat# CRTDcodigo #_Cat# ' no corresponde a un tipo Documento de la empresa #session.enombre#'
		from #table_name# tm
	where not exists (select 1 from CRTipoDocumento crt where crt.CRTDcodigo = tm.CRTDcodigo and crt.Ecodigo = #session.Ecodigo#)
	and CRTDcodigo is not null
	group by tm.CRTDcodigo
</cfquery>
<!---Paso 6--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select tm.Aplaca, 'El Activo ' #_Cat# Aplaca #_Cat# ' ya se encuentra en un proceso de Traslado de Responsable'
		from #table_name# tm
	where exists (select 1 
	               from AFTResponsables aftr 
	                 inner join AFResponsables afr 
					    on  aftr.AFRid = afr.AFRid
					 inner join Activos ac 
					 	on ac.Aid = afr.Aid 
					   and ac.Astatus <> 60
					where ac.Aplaca = tm.Aplaca 
					  and ac.Ecodigo = #session.Ecodigo#)
	group by tm.Aplaca
</cfquery>
<!---Paso 7--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select tm.Aplaca, 'No tienen permisos sobre el Centro de Custodia ' #_Cat# rtrim(crc.CRCCcodigo) #_Cat# ' - ' #_Cat#  rtrim(crc.CRCCdescripcion) #_Cat# ' para realizar el traslado'
	from #table_name# tm
		inner join Activos ac
			on ac.Aplaca = tm.Aplaca
			and ac.Ecodigo = #Session.Ecodigo# 
			and ac.Astatus <> 60
		 inner join AFResponsables afr
		 	on afr.Aid = ac.Aid
			and  <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin
	 	 inner join CRCentroCustodia crc
		 	on crc.CRCCid = afr.CRCCid
	where (select count(1) from CRCCUsuarios crcu where crcu.CRCCid = crc.CRCCid and crcu.Usucodigo = #Session.Usucodigo# ) = 0
</cfquery>
<!---Paso 8--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select tm.Aplaca, 'El Activo no tienen un documento de Responsabilidad vijente a la fecha'
		from #table_name# tm
			inner join Activos ac
				on ac.Aplaca = tm.Aplaca
			   and ac.Ecodigo = #Session.Ecodigo# 
			   and ac.Astatus <> 60
	where (select count(1) from AFResponsables afr where afr.Aid = ac.Aid and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin) = 0
		group by tm.Aplaca
</cfquery>
<!---Paso 9--->
<cfquery datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Dato, Mensaje)
	select tm.Aplaca, 'El Activo tiene más un documento de Responsabilidad vigente a la fecha'
		from #table_name# tm
			inner join Activos ac
				on ac.Aplaca = tm.Aplaca
			   and ac.Ecodigo = #Session.Ecodigo# 
			   and ac.Astatus <> 60
	where (select count(1) from AFResponsables afr where afr.Aid = ac.Aid and  <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin) > 1
		group by tm.Aplaca
</cfquery>
<!---Paso 10--->
<cfquery name="errores" datasource="#session.DSN#">
	select count(1) cantidad from #ERRORES_TEMP#
</cfquery>
<cfif errores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Dato Dato_Incorrecto, Mensaje from #ERRORES_TEMP#
	</cfquery>
<cfelse>
<!---Paso 11--->
	<cftransaction>
		<cfquery datasource="#session.DSN#" name="a">
			insert into AFTResponsables (AFRid, DEid, CRCCid, AFTRfini, AFTRestado, AFTRtipo, CRTDid, Usucodigo, Ulocalizacion, BMUsucodigo)		
				select
					afr.AFRid, 
					de.DEid, 
					afr.CRCCid,
					tmp.Fecha, 
					30,<!---Registro desde Control De Responsables--->
					1, <!---Traslado de Responsable--->
					crt.CRTDid,
					#session.Usucodigo#, 
					'00',
					#session.Usucodigo#
				from #table_name# tmp
					inner join Activos ac
						on ac.Aplaca = tmp.Aplaca
						and ac.Ecodigo = #session.Ecodigo#
					inner join AFResponsables afr
						on afr.Aid = ac.Aid
						and  <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin 
					inner join DatosEmpleado de
						on de.DEidentificacion = tmp.DEidentificacion 
						and de.Ecodigo = ac.Ecodigo
					left outer join CRTipoDocumento crt 
						on crt.CRTDcodigo = tmp.CRTDcodigo
						and crt.Ecodigo = ac.Ecodigo
		</cfquery>
	</cftransaction>
</cfif>