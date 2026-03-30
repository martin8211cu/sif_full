<!---======== Tabla temporal de ErroresImpPersV1  ========--->
<cf_dbtemp name="ErroresImpPersV1" returnvariable="ErroresImpPersV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpPersV1# (Error)
	select 'La Perspectiva ' #_Cat# MIGPercodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGPercodigo
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
	<cfif trim(rsImportador.MIGPercodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpPersV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco.')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGPerid,MIGPercodigo,MIGPerdescripcion
				from MIGPerspectiva
				 where MIGPercodigo = '#rsImportador.MIGPercodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGPerid = rsSQL.MIGPerid>
	</cfif>
	<cfif trim(rsImportador.MIGPerdescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpPersV1# (Error)
			values ('La descripci&oacute;n no puede ir en blanco.')
		</cfquery>
	</cfif>	

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGPercodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGPercodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpPersV1# (Error)
				values ('El c&oacute;digo no puede iniciar con n&uacute;meros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGPercodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpPersV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="rsErroresImpPersV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpPersV1#
	</cfquery>
<!---Si hay ErroresImpPersV1 no hace la inserción--->
	<cfif rsErroresImpPersV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpPersV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan ErroresImpPersV1.--->
	<cfelse>
		<cfif myMIGPerid EQ "">
			<cfinvoke component="mig.Componentes.Perspectivas" method="Alta" returnvariable="MIGPerid">
				<cfinvokeargument name="MIGPercodigo" 	value="#trim(rsImportador.MIGPercodigo)#"/>
				<cfinvokeargument name="MIGPerdescripcion" 	value="#rsImportador.MIGPerdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Perspectivas" method="Cambio" >
				<cfinvokeargument name="MIGPerdescripcion" 	value="#rsImportador.MIGPerdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGPerid" 		value="#myMIGPerid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

