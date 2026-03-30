<!---======== Tabla temporal de ErroresImpAEV1  ========--->
<cf_dbtemp name="ErroresImpAEV1" returnvariable="ErroresImpAEV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpAEV1# (Error)
	select 'La Estrategia ' #_Cat# MIGEstcodigo #_Cat# ' est&aacute; repetida en el Archivo.'
	from #table_name#
	group by MIGEstcodigo
	having count(1) > 1
</cfquery>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name#
</cfquery>

<cfset session.Importador.SubTipo = "2">
<!---Init tabla de errores--->
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
	
	<cfif not  len(trim(rsImportador.MIGEstcodigo))>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAEV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco.')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGEstid,MIGEstcodigo,MIGEstdescripcion
			from MIGEstrategia
			where upper(rtrim(ltrim(MIGEstcodigo))) = '#ucase(trim(rsImportador.MIGEstcodigo))#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('Ya existe un registro con el c&oacute;digo: #trim(rsImportador.MIGEstcodigo)#.')
			</cfquery>
		</cfif>
		<cfset myMIGEstid = rsSQL.MIGEstid>
	</cfif>
	
	<cfif not len(trim(rsImportador.MIGEstdescripcion))>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAEV1# (Error)
			values ('La descripci&oacute;n no puede ir en blanco.')
		</cfquery>
	</cfif>

	<!---No contenido de espacios en blanco en la descripcion--->
	<!---<cfif len(trim(rsImportador.MIGEstdescripcion))>
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@"', rsImportador.MIGEstdescripcion) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('La descripci&oacute;n no contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>--->
	
	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGEstcodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGEstcodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('El c&oacute;digo no puede iniciar con numeros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGEstcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('El c&oacute;digo no contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfquery name="rsErroresImpAEV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpAEV1#
	</cfquery>
<!---Si hay ErroresImpAEV1 no hace la inserción--->
	<cfif rsErroresImpAEV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpAEV1#
		</cfquery>
		<cfreturn>
	<!---Hace lo inserción en caso de que no hayan ErroresImpAEV1.--->
	<cfelse>
		<!---<cfif myMIGEstid EQ "">--->
			<cfinvoke component="mig.Componentes.Estrategia" method="Alta" returnvariable="MIGEstid">
				<cfinvokeargument name="MIGEstcodigo" 	value="#trim(rsImportador.MIGEstcodigo)#"/>
				<cfinvokeargument name="MIGEstdescripcion" 	value="#rsImportador.MIGEstdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<!---<cfelse>
			
			<cfinvoke component="mig.Componentes.Estrategia" method="Cambio" >
				<cfinvokeargument name="MIGEstdescripcion" 	value="#rsImportador.MIGEstdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGAEid" 		value="#myMIGEstid#"/>
			</cfinvoke>
		</cfif>--->
	</cfif>
</cfloop>

<cfset session.Importador.SubTipo = 3>

