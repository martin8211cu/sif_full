<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="integer" 		mandatory="yes">
</cf_dbtemp>

<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select 1
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.recordcount EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1)
	</cfquery>
<cfelse>
	<!--- VALIDA QUE LA DESCRIPCION Y EL CODIGO SEAN DIFERENTE A VACIO --->
	<cfquery name="rsCheck2" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where (CGCDescripcion = ''
		   or CGCcodigo = '')
	</cfquery>
	<cfif isdefined("rsCheck2") and  rsCheck2.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo de importaci&oacute;n tiene la Descripcion o el código con valores vacios ',3)
		</cfquery>
	</cfif>	
	<!--- VALIDA QUE EL TIPO SEA IGUAL A 1 o 2 --->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where CGCTipo <> 1 and CGCTipo <> 2
	</cfquery>
	<cfif isdefined("rsCheck3") and  rsCheck3.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo de importaci&oacute;n tiene el Tipo con valores diferentes a 1 y 2 ',3)
		</cfquery>
	</cfif>
	<!--- VALIDA QUE EL MODO SEA IGUAL A 1 o 2 --->
	<cfquery name="rsCheck4" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where CGCModo <> 1 and CGCModo <> 2
	</cfquery>
	<cfif isdefined("rsCheck4") and  rsCheck4.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo de importaci&oacute;n tiene el Modo con valores diferentes a 1 y 2 ',3)
		</cfquery>
	</cfif>	
	<!--- VALIDA QUE EL CODIGO DE CATALOGO SEA DIFERENTE A VACIO --->
	<cfquery name="rsCheck5" datasource="#Session.Dsn#">
		select 1
		from #table_name#
		where CodigoCat = ''
	</cfquery>
	<cfif isdefined("rsCheck5") and  rsCheck5.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('El archivo de importaci&oacute;n tiene el Codigo con valores vacios ',3)
		</cfquery>
	</cfif>		
	<!--- VALIDA QUE EL CODIGO CORRESPONDA --->
	<cfquery name="rsCheck6" datasource="#Session.Dsn#">
		select *
		from #table_name# a
				inner join PCClasificacionE b 
					on a.CodigoCat = b.PCCEcodigo
		where <cf_dbfunction name="length"	args="rtrim(a.CodigoCat)"> > 0
		  and a.CGCModo = 2 
		  and b.CEcodigo = #session.CEcodigo#
	</cfquery>
	<cfif isdefined("rsCheck6") and rsCheck6.recordcount eq 0>
		<cfquery name="rsCheck7" datasource="#Session.Dsn#">
			select *
			from #table_name# a
					inner join PCECatalogo b 
							on a.CodigoCat = b.PCEcodigo
			where <cf_dbfunction name="length"	args="rtrim(a.CodigoCat)"> > 0
			  and a.CGCModo = 1 
			  and b.CEcodigo = #session.CEcodigo#
		</cfquery>
		<cfif isdefined("rsCheck7") and rsCheck7.recordcount eq 0>
			<cfquery name="INS_Error" datasource="#session.DSN#">
				insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
				values('El archivo de importaci&oacute;n tiene el Codigo de Catalogo/Clasificacion con valores vacios o no corresponde ',3)
			</cfquery>
		<cfelse>
			<cfset CGCidv = rsCheck7.PCEcatid>
		</cfif>
	<cfelse>
		<cfset CGCidv = rsCheck6.PCCEclaid>
	</cfif>
	<!--- VALIDA QUE NO EXISTAN LINEAS REPETIDAS EN EL ARCHIVO POR CODIGO CONDUCTOR --->
	<cfquery name="rsCheck8" datasource="#Session.Dsn#">
		select CGCcodigo, count(1) as total
		from #table_name# a			
		group by CGCcodigo
		having count(1) > 1
	</cfquery>
	<cfif isdefined("rsCheck8") and rsCheck8.recordcount gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('Existen conductores repetidos en el archivo de importación',3)
		</cfquery>	
	</cfif>
	<!--- VALIDA QUE NO EXISTA UN CONDUCTOR EN LA BASE DE DATOS CON EL MISMO CODIGO DE UNO QUE SE VA A IMPORTAR--->
	<cfquery name="rsCheck9" datasource="#Session.Dsn#">
	Select count(1) as total
	from #table_name# a	
	where exists (Select 1
				  from CGConductores b
				  where a.CGCcodigo = b.CGCcodigo
				    and b.Ecodigo = #session.ecodigo#)
	</cfquery>
	<cfif isdefined("rsCheck9") and rsCheck9.total gt 0>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			values('Se estan importando conductores que ya existen en el catálogo',3)
		</cfquery>		
	</cfif>
</cfif>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum
</cfquery>

<cfif (err.recordcount) EQ 0>
	<cfquery name="RSregistros" datasource="#session.dsn#">
		insert into CGConductores ( 
			Ecodigo,
			CGCcodigo,
			CGCdescripcion,
			CGCtipo,
			CGCmodo,
			CGCidc
		)
		select #session.Ecodigo#, 
				x.CGCcodigo,
				x.CGCDescripcion, 
				x.CGCTipo, 
				x.CGCModo,
				case when (x.CGCModo = 1) then c.PCEcatid
					else b.PCCEclaid
				end
		from #table_name# x
			left join PCClasificacionE b
				on x.CodigoCat = b.PCCEcodigo
				and b.CEcodigo = #session.CEcodigo#
			left join PCECatalogo c
				on x.CodigoCat = c.PCEcodigo
				and c.CEcodigo = #session.CEcodigo#
		  where not exists (
		  		select 1
				from CGConductores CGC
				where rtrim(ltrim(CGC.CGCdescripcion)) = rtrim(ltrim(x.CGCDescripcion))
				)
	</cfquery>
</cfif>