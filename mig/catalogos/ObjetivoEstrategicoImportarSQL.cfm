<!---======== Tabla temporal de ErroresImpAEV1  ========--->
<cf_dbtemp name="ErroresImpAEV1" returnvariable="ErroresImpAEV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpAEV1# (Error)
	select 'El Objetivo Estrat&eacute;gico ' #_Cat# MIGOEcodigo #_Cat# ' est&aacute; repetido en el Archivo.'
	from #table_name#
	group by MIGOEcodigo
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
	
	<cfif not  len(trim(rsImportador.MIGOEcodigo))>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAEV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco.')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGOEid,MIGOEcodigo,MIGOEdescripcion
			from MIGOEstrategico
			where upper(rtrim(ltrim(MIGOEcodigo))) = '#ucase(trim(rsImportador.MIGOEcodigo))#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('Ya existe un registro con el c&oacute;digo: #trim(rsImportador.MIGOEcodigo)#.')
			</cfquery>
		</cfif>
		<cfset myMIGOEid = rsSQL.MIGOEid>
	</cfif>
	
	<cfif not len(trim(rsImportador.MIGOEdescripcion))>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAEV1# (Error)
			values ('La descripci&oacute;n no puede ir en blanco.')
		</cfquery>
	</cfif>

	<!---No contenido de espacios en blanco en la descripcion--->
	<!---<cfif len(trim(rsImportador.MIGOEdescripcion))>
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@"', rsImportador.MIGOEdescripcion) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('La descripci&oacute;n no contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>--->
	
	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGOEcodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGOEcodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('El c&oacute;digo no puede iniciar con numeros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGOEcodigo) GT 0 >
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
		<!---<cfif myMIGOEid EQ "">--->
			<cftransaction>
				<cfinvoke component="mig.Componentes.ObjetivoEstrategico" method="Alta" returnvariable="MIGOEid">
					<cfinvokeargument name="MIGOEcodigo" 	value="#rsImportador.MIGOEcodigo#"/>
					<cfinvokeargument name="MIGOEdescripcion" 	value="#rsImportador.MIGOEdescripcion#"/>
					<cfinvokeargument name="Dactiva" 		value="1"/>
					<cfinvokeargument name="CodFuente" 		value="2"/>
				</cfinvoke>	
			</cftransaction>
		<!---<cfelse>
			
			<cfinvoke component="mig.Componentes.Estrategia" method="Cambio" >
				<cfinvokeargument name="MIGOEdescripcion" 	value="#rsImportador.MIGOEdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGAEid" 		value="#myMIGOEid#"/>
			</cfinvoke>
		</cfif>--->
	</cfif>
</cfloop>

<cfset session.Importador.SubTipo = 3>

