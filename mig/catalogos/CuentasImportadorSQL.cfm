<!---======== Tabla temporal de ErroresImpCuenV1  ========--->
<cf_dbtemp name="ErroresImpCuenV1" returnvariable="ErroresImpCuenV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpCuenV1# (Error)
	select 'El Cuentas ' #_Cat# MIGCuecodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGCuecodigo
	having count(1) > 1
</cfquery>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
</cfquery>
<cfset session.Importador.SubTipo = "2">
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
				#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush interval="64">
	</cfif>
	<cfif trim(rsImportador.MIGCuecodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpCuenV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.MIGCuedescripcion) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpCuenV1# (Error)
			values ('La descripci&oacute;n no puede ir en blanco')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.MIGCuetipo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpCuenV1# (Error)
			values ('El tipo de cuenta no puede ir en blanco')
		</cfquery>
	</cfif>
<!---
	<cfif trim(rsImportador.MIGCuesubtipo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpCuenV1# (Error)
			values ('El Subtipo de cuenta no puede ir en blanco')
		</cfquery>
	</cfif>
--->
	<cfif trim(rsImportador.Dactiva) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpCuenV1# (Error)
			values ('El estado no puede ir en blanco')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.Dactiva) NEQ 0 and trim(rsImportador.Dactiva) NEQ 1>	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpCuenV1# (Error)
			values ('Verifique el estado:(Inactivo:0 Activo:1)')
		</cfquery>
	</cfif>

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGCuecodigo))>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGCuecodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpCuenV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfif trim(rsImportador.MIGCuetipo) NEQ "I" and trim(rsImportador.MIGCuetipo) NEQ "G" and trim(rsImportador.MIGCuetipo) NEQ "C" and trim(rsImportador.MIGCuetipo) NEQ "N" and trim(rsImportador.MIGCuetipo) NEQ "A" and trim(rsImportador.MIGCuetipo) NEQ "T" and trim(rsImportador.MIGCuetipo) NEQ "P">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpCuenV1# (Error)
			values ('Verifique el Tipo de Cuenta: (I,G,C,N)')
		</cfquery>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGCueid,MIGCuecodigo,MIGCuedescripcion
			from MIGCuentas
			 where MIGCuecodigo = '#rsImportador.MIGCuecodigo#'
			   and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset myMIGCueid = rsSQL.MIGCueid>
	
	<cfquery name="rsErroresImpCuenV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpCuenV1#
	</cfquery>
<!---Si hay ErroresImpCuenV1 no hace la inserción--->
	<cfif rsErroresImpCuenV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpCuenV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan ErroresImpCuenV1.--->
	<cfelse>
		<cfif myMIGCueid EQ "">
			<cfinvoke component="mig.Componentes.Cuentas" method="Alta" returnvariable="MIGCueid">
				<cfinvokeargument name="MIGCuecodigo" 	value="#trim(rsImportador.MIGCuecodigo)#"/>
				<cfinvokeargument name="MIGCuedescripcion" 	value="#rsImportador.MIGCuedescripcion#"/>
				<cfinvokeargument name="MIGCuetipo" 	value="#trim(rsImportador.MIGCuetipo)#"/>
				<cfinvokeargument name="MIGCuesubtipo" 	value="#rsImportador.MIGCuesubtipo#"/>
				<cfinvokeargument name="Dactiva" 		value="#rsImportador.Dactiva#"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Cuentas" method="Cambio" >
				<cfinvokeargument name="MIGCuedescripcion" 	value="#rsImportador.MIGCuedescripcion#"/>
				<cfinvokeargument name="MIGCuetipo" 	value="#trim(rsImportador.MIGCuetipo)#"/>
				<cfinvokeargument name="MIGCuesubtipo" 	value="#rsImportador.MIGCuesubtipo#"/>
				<cfinvokeargument name="Dactiva" 		value="#rsImportador.Dactiva#"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
				<cfinvokeargument name="MIGCueid" 		value="#myMIGCueid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

