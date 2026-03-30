<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="integer" 		mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="CGIC_Cat" returnvariable="catalogo" datasource="#session.dsn#">
	<cf_dbtempcol name="CGICMid"     type="numeric"      mandatory="no">
	<cf_dbtempcol name="CodigoMapeo" type="char(10)"     mandatory="no">
	<cf_dbtempcol name="CGICCcuenta" type="char(40)"     mandatory="no">
	<cf_dbtempcol name="CGICCnombre" type="varchar(100)" mandatory="no">
	<cf_dbtempcol name="CGICinfo1"   type="varchar(20)"  mandatory="no">
	<cf_dbtempcol name="CGICinfo2"   type="varchar(20)"  mandatory="no">
	<cf_dbtempcol name="CGICinfo3"   type="varchar(20)"  mandatory="no">
</cf_dbtemp>


<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select count(1) as Cantidad
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.Cantidad EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1)
	</cfquery>
</cfif>
<cfquery datasource="#session.dsn#">
	insert into #catalogo# (CGICMid,	CodigoMapeo, CGICCcuenta, CGICCnombre, CGICinfo1, CGICinfo2, CGICinfo3)
	select 
		coalesce((select min(m.CGICMid) from CGIC_Mapeo m where m.CGICMcodigo = a.CodigoMapeo), -1), 
		a.CodigoMapeo,
		a.Cuenta, 
		a.Nombre, 
		a.Info1, 
		a.Info2, 
		a.Info3
	from #table_name# a
</cfquery>

<cfquery name="rsCheck2" datasource="#session.dsn#">
	select CGICMid, CGICCcuenta, count(1) as Cantidad
	from #catalogo#
	where CGICMid is not null
	  and CGICMid > 0
	group by CGICMid, CGICCcuenta
	having count(1) > 1
</cfquery>

<cfif isdefined("rsCheck2") and  rsCheck2.recordcount GT 0>
	<cfloop query="rsCheck2">
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje, ErrorNum)
			values ('La cuenta: #rsCheck2.CGICCcuenta# esta duplicada #rsCheck2.Cantidad# veces en el archivo.', 2)
		</cfquery>
	</cfloop>
</cfif>

<cfquery name="rsCheck2" datasource="#session.dsn#">
	select CodigoMapeo, CGICCcuenta
	from #catalogo#
	where CGICMid is null
	  or CGICMid < 0
</cfquery>

<cfif isdefined("rsCheck2") and  rsCheck2.recordcount GT 0>
	<cfloop query="rsCheck2">
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje, ErrorNum)
			values ('El Mapeo #rsCheck2.CodigoMapeo# NO esta definido. Verifique la cuenta #rsCheck2.CGICCcuenta# de este codigo de mapeo.', 3)
		</cfquery>
	</cfloop>
</cfif>

<cfquery name="rsCheck2" datasource="#session.dsn#">
	select CGICMid, CodigoMapeo, CGICCcuenta, count(1) as Cantidad
	from #catalogo# c
	where CGICMid is not null
	  and CGICMid > 0
	  and exists(
	  		select 1
			from CGIC_Catalogo cc
			where cc.CGICMid = c.CGICMid
			  and cc.CGICCcuenta = c.CGICCcuenta
			  )
	group by CGICMid, CodigoMapeo, CGICCcuenta
</cfquery>

<cfif isdefined("rsCheck2") and  rsCheck2.recordcount GT 0>
	<cfloop query="rsCheck2">
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje, ErrorNum)
			values ('La cuenta #rsCheck2.CGICCcuenta# del Codigo: #rsCheck2.CodigoMapeo# ya esta definida en la tabla de Mapeo.', 4)
		</cfquery>
	</cfloop>
</cfif>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum
</cfquery>	

<cfif (err.recordcount) EQ 0>
	<cfquery datasource="#session.dsn#">
		insert into CGIC_Catalogo (CGICMid,	CGICCcuenta, CGICCnombre, CGICinfo1, CGICinfo2, CGICinfo3)
		select                CGICMid,	CGICCcuenta, CGICCnombre, CGICinfo1, CGICinfo2,CGICinfo3
		from #catalogo# a
		where CGICMid is not null
		  and CGICMid > 0
	</cfquery>
<cfelse>
	<table>
	<tr><td>&nbsp;</td></tr>
	<cfloop query="err">
		<tr><td>#Mensaje#</td></tr>
	</cfloop>
	</table>
</cfif>


