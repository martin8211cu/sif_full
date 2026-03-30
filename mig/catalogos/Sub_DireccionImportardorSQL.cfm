<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpSDirV1" returnvariable="ErroresImpSDirV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpSDirV1# (Error)
	select 'La Sub_Direcci&oacute;n ' #_Cat# MIGSDcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGSDcodigo
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
	<cfif trim(rsImportador.MIGDcodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpSDirV1# (Error)
			values ('El C&oacute;digo de la Dirección no puede ir en blanco')
		</cfquery>
	<cfelse>	
		<cfquery name="rsDireciones" datasource="#session.dsn#">
			select MIGDid, MIGDcodigo
			from MIGDireccion
			where Ecodigo=#session.Ecodigo# 
			and MIGDcodigo='#rsImportador.MIGDcodigo#'
		</cfquery>		
		<cfif rsDireciones.MIGDid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpSDirV1# (Error)
				values ('La Dirección #rsImportador.MIGDcodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>	
	<cfif trim(rsImportador.MIGSDcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpSDirV1# (Error)
			values ('El C&oacute;digo de la Sub_Direcci&oacute;n no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGSDid,MIGSDcodigo,MIGSDdescripcion
				  from MIGSDireccion
				 where MIGSDcodigo = '#rsImportador.MIGSDcodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGSDid = rsSQL.MIGSDid>
	</cfif>
	<cfif trim(rsImportador.MIGSDdescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpSDirV1# (Error)
			values ('La descripci&oacute;n de la Sub_Direcci&oacute;n no puede ir en blanco')
		</cfquery>
	</cfif>

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGSDcodigo))>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGSDcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpSDirV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpSDirV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpSDirV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGSDid EQ "">
			<cfinvoke component="mig.Componentes.Sub_Direccion" method="Alta" returnvariable="MIGSDid">
				<cfinvokeargument name="MIGSDcodigo" 	value="#trim(rsImportador.MIGSDcodigo)#"/>
				<cfinvokeargument name="MIGSDdescripcion" 	value="#rsImportador.MIGSDdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGDid" 		value="#rsDireciones.MIGDid#"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>	
		<cfelse>
			<cfinvoke component="mig.Componentes.Sub_Direccion" method="Cambio" >
				<cfinvokeargument name="MIGSDdescripcion" 	value="#rsImportador.MIGSDdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGSDid" 		value="#myMIGSDid#"/>
				<cfinvokeargument name="MIGDid" 		value="#rsDireciones.MIGDid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

