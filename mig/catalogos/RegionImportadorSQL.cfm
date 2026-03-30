<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpRegV1" returnvariable="ErroresImpRegV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpRegV1# (Error)
	select 'La Regi&oacute;n ' #_Cat# MIGRcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGRcodigo
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
			Insert into #ErroresImpRegV1# (Error)
			values ('El c&oacute;digo de Pa&iacute;s no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsPais" datasource="#session.dsn#">
			select MIGPaid, MIGPacodigo, MIGPadescripcion
			from MIGPais
			where MIGPacodigo = '#rsImportador.MIGPacodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsPais.MIGPaid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpRegV1# (Error)
				values ('El Pa&iacute;s #rsImportador.MIGPacodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>	
	
	<cfif trim(rsImportador.MIGRcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpRegV1# (Error)
			values ('El c&oacute;digo de la Regi&oacute;n no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGRid,MIGPaid,MIGRcodigo,MIGRdescripcion
			from MIGRegion
			where MIGRcodigo = '#rsImportador.MIGRcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGRid= rsSQL.MIGRid>
	</cfif>

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGRcodigo))>

		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGRcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpRegV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpRegV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpRegV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGRid EQ "">
			<cfinvoke component="mig.Componentes.Region" method="Alta" returnvariable="MIGRid">
				<cfinvokeargument name="MIGRcodigo" 	value="#trim(rsImportador.MIGRcodigo)#"/>
				<cfinvokeargument name="MIGRdescripcion" 	value="#rsImportador.MIGRdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGPaid" 		value="#rsPais.MIGPaid#"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Region" method="Cambio" >
				<cfinvokeargument name="MIGRdescripcion" 	value="#rsImportador.MIGRdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGRid" 		value="#myMIGRid#"/>
				<cfinvokeargument name="MIGPaid" 		value="#rsPais.MIGPaid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

