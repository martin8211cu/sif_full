<cfinclude template="funcionesReglas.cfm">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 	type="integer" 	  mandatory="yes">
</cf_dbtemp>

<!--- Valida que el consecutivo no este repetido dentro del mismo archivo --->
<cfquery name="rsCheck" datasource="#Session.Dsn#">
	select PCRid, count(1) as total
	from #table_name# a			
	group by PCRid
	having count(1) > 1
</cfquery>
	
<cfif isdefined("rsCheck") and rsCheck.recordcount gt 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('Existen Consecutivos repetidos en el archivo de importación',1)
	</cfquery>	
</cfif>

<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
    select 'El Campo es Valida, unicamente acepta valores de S y N',2
     from #table_name#
    where PCRvalida not in ('S','N')
</cfquery>

<cfquery name="nextSec" datasource="#Session.DSN#">
	select coalesce(count(1), 0) + 1 as cant
	from PCReglasEImportacion
	where <cf_dbfunction name="to_date00" args="PCREIfecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
</cfquery>
	
<cfquery name="errores" datasource="#Session.DSN#">
	select count(1)as cantidad
	from #ERRORES_TEMP#
</cfquery>

<cfif errores.cantidad gt 0>
	<cfquery name="ERR" datasource="#Session.DSN#">
		select *
		from #ERRORES_TEMP#
	</cfquery>
<cfelse>
<cftransaction>	
	<!--- Insertar el encabezado de Importación de Reglas --->
	<cfquery name="insEnc" datasource="#Session.DSN#">
		insert into PCReglasEImportacion (Ecodigo, PCREIdescripcion, PCREIfecha, Usucodigo, Ulocalizacion, PCREestado, BMUsucodigo)
		values (
			#Session.Ecodigo#,
			'Importación de Reglas ' #_Cat# <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#"> #_Cat# ' (#nextSec.cant#)', 
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
			#Session.Usucodigo#,
			'00',
			0,
			#Session.Usucodigo#
		)
		<cf_dbidentity1 datasource="#Session.DSN#">
	</cfquery>
	<cf_dbidentity2 name="insEnc" datasource="#Session.DSN#">

	<!--- Insertar el detalle de la Importación de Reglas --->
	<cfquery name="insDet" datasource="#Session.DSN#">
		insert into PCReglasDImportacion (PCREIid, PCRid, Ecodigo, Cmayor, Oformato, PCRref, PCRdescripcion, PCRregla, PCRvalida, PCRdesde, PCRhasta, Usucodigo, Ulocalizacion, PCRaplicada, BMUsucodigo, PCRGcodigo)
		select #insEnc.identity#,
			   a.PCRid,
			   #Session.Ecodigo#,
			   right('0000' #_Cat# rtrim(a.Cmayor), 4),
			   a.Oformato,
			   a.PCRref,
			   a.PCRdescripcion,
			   a.PCRregla,
			   upper(a.PCRvalida),
			   a.PCRdesde,
			   a.PCRhasta,
			   #Session.Usucodigo#,
			   '00',
			   0,
			   #Session.Usucodigo#,
               a.PCRGcodigo
		from #table_name# a
	</cfquery>
	
	<!--- Actualizar las máscaras de la cuenta de mayor y el formato de la regla --->
	<cfquery name="rsReglas" datasource="#Session.DSN#">
		select a.PCREIid, a.PCRid, a.PCRregla, b.Cmayor, c.CPVformatoF as Cmascara, c.PCEMid
		from PCReglasDImportacion a
			inner join CtasMayor b
				on b.Cmayor = a.Cmayor
				and b.Ecodigo = a.Ecodigo
			left outer join CPVigencia c
				on c.Cmayor = b.Cmayor
				and c.Ecodigo = b.Ecodigo
				and c.PCEMid = b.PCEMid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between c.CPVdesde and c.CPVhasta
		where a.PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insEnc.identity#">
	</cfquery>
	
	<cfloop query="rsReglas">
		<cfquery name="updCmascara" datasource="#Session.DSN#">
			update PCReglasDImportacion set
				Cmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReglas.Cmascara#">
				<cfif Len(Trim(rsReglas.PCEMid))>
					, PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReglas.PCEMid#">
				</cfif>
				<cfif Len(Trim(rsReglas.Cmascara))>
					, PCRregla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#agregarGuiones(rsReglas.Cmascara, rsReglas.PCRregla, rsReglas.Cmayor)#">
				</cfif>
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insEnc.identity#">
			and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReglas.PCRid#">
		</cfquery>
	</cfloop>
</cftransaction>
</cfif>