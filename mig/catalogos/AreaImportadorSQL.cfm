<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpAreaV1" returnvariable="ErroresImpAreaV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpAreaV1# (Error)
	select 'La &Aacute;rea ' #_Cat# MIGArcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGArcodigo
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
	<cfif trim(rsImportador.MIGRcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAreaV1# (Error)
			values ('El C&oacute;digo de la Regi&oacute;n no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsRegion" datasource="#session.dsn#">
			select MIGRid, MIGRcodigo, MIGRdescripcion
			from MIGRegion
			where MIGRcodigo = '#rsImportador.MIGRcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
	
		<cfif rsRegion.MIGRid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAreaV1# (Error)
				values ('La Regi&oacute;n #rsImportador.MIGRcodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>	
	<cfif trim(rsImportador.MIGArcodigo) eq "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAreaV1# (Error)
			values ('El C&oacute;digo del &Aacute;rea no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGArid,MIGRid,MIGArcodigo,MIGArdescripcion
			from MIGArea
			where MIGArcodigo = '#rsImportador.MIGArcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGArid= rsSQL.MIGArid>
	</cfif>
	<cfif trim(rsImportador.MIGArdescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAreaV1# (Error)
			values ('La descripci&oacute;n del &Aacute;rea no puede ir en blanco')
		</cfquery>
	</cfif> 

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGArcodigo))>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGArcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAreaV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpAreaV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpAreaV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGArid EQ "">
			<cfinvoke component="mig.Componentes.Area" method="Alta" returnvariable="MIGArid">
				<cfinvokeargument name="MIGArcodigo" 	value="#trim(rsImportador.MIGArcodigo)#"/>
				<cfinvokeargument name="MIGArdescripcion" 	value="#rsImportador.MIGArdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGRid" 		value="#rsRegion.MIGRid#"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Area" method="Cambio" >
				<cfinvokeargument name="MIGArdescripcion" 	value="#rsImportador.MIGArdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGArid" 		value="#myMIGArid#"/>
				<cfinvokeargument name="MIGRid" 		value="#rsRegion.MIGRid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

