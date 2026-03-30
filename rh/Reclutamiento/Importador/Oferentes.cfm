<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<!--- Check1. verifica el tipo de identificación --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El c&oacute;digo de identificaci&oacute;n&nbsp;(<b>',a.NTIcodigo, '</b>)&nbsp;no existe en el cat&aacute;logo'" >, 1	
	from #table_name# a
	where not exists (	select 1 from NTipoIdentificacion b
					where ltrim(rtrim(b.NTIcodigo ))		  = ltrim(rtrim(a.NTIcodigo))
					and b.Ecodigo = #Session.Ecodigo#
					)	
</cfquery>
<!--- Check2. verfica que el oferente no exista en el catalogo --->
<cfquery name="rsCheck2" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El Oferente esta duplicado en el archivo . Tipo Iden.&nbsp;(<b>',a.NTIcodigo,'</b>)&nbsp; Identificaci&oacute;n &nbsp;(<b>',a.RHOidentificacion,'</b>)' " >, 2	
		from #table_name# a
		group by a.NTIcodigo,a.RHOidentificacion
		having count(1) > 1	
</cfquery>


<cfquery name="rsCheck3" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select distinct
	<cf_dbfunction name="concat" args="'El Oferente ya existe el catálogo. Tipo Iden.&nbsp;(<b>',a.NTIcodigo,'</b>)&nbsp; Identificaci&oacute;n &nbsp;(<b>',a.RHOidentificacion,'</b>)'" >, 2
	from #table_name# a
	where exists (	select 1 from DatosOferentes b
					where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ltrim(rtrim(b.NTIcodigo))	      = ltrim(rtrim(a.NTIcodigo)) 
					and ltrim(rtrim(b.RHOidentificacion)) = ltrim(rtrim(a.RHOidentificacion))
					)	
</cfquery>
<!--- Check2. verfica el correo --->
<cfquery name="rsCheck2" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'Correo electrónico esta duplicado en el archivo .(<b>',a.RHOemail,'</b>)' " >, 2	
		from #table_name# a
		group by RHOemail
		having count(1) > 1	
</cfquery>

<cfquery name="rsCheck3" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select distinct
	<cf_dbfunction name="concat" args="'El correo electrónico &nbsp;(<b>',a.RHOemail,'</b>)&nbsp; se encuentra asociado a otro oferente'" >, 2
	from #table_name# a
	where exists (	select 1 from DatosOferentes b
					where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ltrim(rtrim(b.RHOemail))      = ltrim(rtrim(a.RHOemail)) 
					)	
</cfquery>
<!--- Check3. verfica el código de sexo --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El c&oacute;digo de sexo no es v&aacute;lido&nbsp;:(<b>',a.RHOsexo,'</b>)'" >, 3	
	from #table_name# a
	where a.RHOsexo not in ('F','M')
</cfquery>
<!--- Check4. verfica el código de pais --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El c&oacute;digo de pa&iacute;s&nbsp;(<b>',a.Ppais, '</b>)&nbsp;no existe en el cat&aacute;logo'" >, 4	
	from #table_name# a
	where not exists (	select 1 from Pais  b
		where ltrim(rtrim(b.Ppais ))  = ltrim(rtrim(a.Ppais))
		)	
</cfquery>
<!--- Check5. verfica el código de moneda --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El c&oacute;digo de moneda&nbsp;(<b>',a.RHOMonedaPrt, '</b>)&nbsp;no existe en el cat&aacute;logo'" >, 5	
	from #table_name# a
	where not exists (	select 1 from Monedas  b
		where ltrim(rtrim(b.Miso4217 ))  = ltrim(rtrim(a.RHOMonedaPrt))
		)	
</cfquery>

<!--- Check6. verfica el idioma --->
<cf_dbfunction name="to_char" args="a.RHOIdioma1" returnvariable="vRHOIdioma1">
<cf_dbfunction name="to_char" args="a.RHOIdioma2" returnvariable="vRHOIdioma2">
<cf_dbfunction name="to_char" args="a.RHOIdioma3" returnvariable="vRHOIdioma3">
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El primer idioma no es v&aacute;lido&nbsp;:(<b>'|#vRHOIdioma1#|'</b>) para el oferente &nbsp;(<b>'|a.RHOidentificacion|'</b>)'"  delimiters ="|">, 6	
	from #table_name# a
	where a.RHOIdioma1 not in (1,2,3,4,5,6,7,8)
</cfquery>
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El segundo idioma no es v&aacute;lido&nbsp;:(<b>'|#vRHOIdioma2#|'</b>) para el oferente &nbsp;(<b>'|a.RHOidentificacion|'</b>)'"  delimiters ="|">, 6	
	from #table_name# a
	where a.RHOIdioma2 not in (1,2,3,4,5,6,7,8)
</cfquery>
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El tercer idioma no es v&aacute;lido&nbsp;:(<b>'|#vRHOIdioma3#|'</b>) para el oferente &nbsp;(<b>'|a.RHOidentificacion|'</b>)'"  delimiters ="|">, 6	
	from #table_name# a
	where a.RHOIdioma3 not in (1,2,3,4,5,6,7,8)
</cfquery>
<!--- Check7. salario --->

<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'La Aspiración salarial inferior es mayor a la superior para el oferente &nbsp;(<b>'|a.RHOidentificacion|'</b>)'"  delimiters ="|">, 7	
	from #table_name# a
	where a.RHOPrenteInf > a.RHOPrenteSup
</cfquery>




<cfquery name="ERR" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum,Mensaje
</cfquery>
<cfif (ERR.recordcount) EQ 0>
	<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
			insert into DatosOferentes 
				(Ecodigo, NTIcodigo, RHOidentificacion, 
				RHOnombre, RHOapellido1, RHOapellido2, 
				RHOtelefono1,RHOtelefono2,RHOemail,
				RHOcivil, RHOfechanac, RHOsexo,
				Ppais,BMUsucodigo,RHOPrenteInf,	RHOPrenteSup,RHOPosViajar,
				RHOPosTralado,RHOIdioma1,RHOIdioma2,RHOIdioma3,
				RHOMonedaPrt,RHAprobado)
			select 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				NTIcodigo,
				RHOidentificacion,
				RHOnombre,
				RHOapellido1,
				RHOapellido2,
				RHOtelefono1,
				RHOtelefono2,
				RHOemail,
				RHOcivil,
				RHOfechanac,
				RHOsexo,
				Ppais,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				RHOPrenteInf,
				RHOPrenteSup,
				RHOPosViajar,
				RHOPosTralado,
				RHOIdioma1,
				RHOIdioma2,
				RHOIdioma3,
				RHOMonedaPrt,0
			from	#table_name#
	</cfquery>
	
	<cfquery name="insertados" datasource="#Session.DSN#">
		select a.RHOid, b.RHOdireccion, b.Ppais
		from DatosOferentes a , #table_name# b
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.NTIcodigo	        = a.NTIcodigo 
		and b.RHOidentificacion = a.RHOidentificacion
	</cfquery>
	<cfset llave = -1>
	<cfset llavedir = -1>
	<cfset Ppais = "">
	<cfset direccion = "">
	<cfloop query="insertados">
		<cfset llave = insertados.RHOid>
		<cfset direccion = insertados.RHOdireccion>
		<cfset Ppais = insertados.Ppais>

		<cfquery datasource="asp" name="inserted">
			insert INTO Direcciones ( direccion1, BMUsucodigo, BMfechamod,Ppais)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#direccion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ppais#">)
			<cf_dbidentity1 verificar_transaccion="false" datasource="asp">
		</cfquery>
		<cf_dbidentity2 verificar_transaccion="false" datasource="asp" name="inserted"> 

		<cfset llavedir = inserted.identity>
		<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
			update DatosOferentes set id_direccion = #llavedir#
			where RHOid = #llave#
		</cfquery>
	</cfloop>
</cfif>
