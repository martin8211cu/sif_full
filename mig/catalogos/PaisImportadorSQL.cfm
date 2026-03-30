<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpPaisV1" returnvariable="ErroresImpPaisV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpPaisV1# (Error)
	select 'El Pa&iacute;s ' #_Cat# MIGPacodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGPacodigo
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
	<cfif trim(rsImportador.MIGPacodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpPaisV1# (Error)
			values ('El C&oacute;digo  no puede ir en blanco')
		</cfquery>	
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGPaid,MIGPacodigo,MIGPadescripcion
			from MIGPais
			where MIGPacodigo = '#rsImportador.MIGPacodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGPaid= rsSQL.MIGPaid>
	</cfif>
	<cfif trim(rsImportador.MIGPadescripcion) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpPaisV1# (Error)
			values ('La descripci&oacute;n  no puede ir en blanco')
		</cfquery>	
	</cfif>>
	
		<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGPacodigo))>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGPacodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpPaisV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpPaisV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpPaisV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGPaid EQ "">
			<cfinvoke component="mig.Componentes.Pais" method="Alta" returnvariable="MIGPaid">
				<cfinvokeargument name="MIGPacodigo" 	value="#trim(rsImportador.MIGPacodigo)#"/>
				<cfinvokeargument name="MIGPadescripcion" 	value="#rsImportador.MIGPadescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Pais" method="Cambio" >
				<cfinvokeargument name="MIGPadescripcion" 	value="#rsImportador.MIGPadescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGPaid" 		value="#myMIGPaid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

