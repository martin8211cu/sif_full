<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpDistV1" returnvariable="ErroresImpDistV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpDistV1# (Error)
	select 'El Distrito ' #_Cat# MIGDicodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGDicodigo
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
	<cfif trim(rsImportador.MIGArcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDistV1# (Error)
			values ('El c&oacute;digo del &Aacute;rea no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsArea" datasource="#session.dsn#">
			select MIGArid,MIGArcodigo,MIGArdescripcion
			from MIGArea
			where MIGArcodigo = '#rsImportador.MIGArcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsArea.MIGArid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDistV1# (Error)
				values ('El &Aacute;rea #rsImportador.MIGArcodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>	
	<cfif trim(rsImportador.MIGDicodigo) eq "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDistV1# (Error)
			values ('El c&oacute;digo del Distrito no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGDiid,MIGDicodigo,MIGDidescripcion,MIGArid
			from MIGDistrito
			where MIGDicodigo = '#rsImportador.MIGDicodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGDiid= rsSQL.MIGDiid>
	</cfif>
	<cfif trim(rsImportador.MIGDidescripcion) eq "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDistV1# (Error)
			values ('La descripci&oacute;n del Distrito no puede ir en blanco')
		</cfquery>
	</cfif>
	
		<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGDicodigo))>
	
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGDicodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDistV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>
		
		<cfquery name="rsErrores" datasource="#session.DSN#">
			select count(1) as cantidad
			from #ErroresImpDistV1#
		</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpDistV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif not len(trim(myMIGDiid))>
			<cfinvoke component="mig.Componentes.Distrito" method="Alta" returnvariable="MIGDiid">
				<cfinvokeargument name="MIGDicodigo" 	value="#trim(rsImportador.MIGDicodigo)#"/>
				<cfinvokeargument name="MIGDidescripcion" 	value="#rsImportador.MIGDidescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGArid" 		value="#rsArea.MIGArid#"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Distrito" method="Cambio">
				<cfinvokeargument name="MIGDidescripcion" 	value="#rsImportador.MIGDidescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGDiid" 		value="#myMIGDiid#"/>
				<cfinvokeargument name="MIGArid" 		value="#rsArea.MIGArid#"/>
			</cfinvoke>
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

