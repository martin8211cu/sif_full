<!---======== Tabla temporal de ErroresImpAEV1  ========--->
<cf_dbtemp name="ErroresImpAEV1" returnvariable="ErroresImpAEV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpAEV1# (Error)
	select 'El Factor Critico ' #_Cat# MIGAEcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGAEcodigo
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
	<cfif trim(rsImportador.MIGAEcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAEV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco.')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGAEid,MIGAEcodigo,MIGAEdescripcion
				from MIGAccion
				 where MIGAEcodigo = '#rsImportador.MIGAEcodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGAEid = rsSQL.MIGAEid>
	</cfif>
	<cfif trim(rsImportador.MIGAEdescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpAEV1# (Error)
			values ('La descripci&oacute;n no puede ir en blanco.')
		</cfquery>
	</cfif>
	
	<!---Validar no caracteres especiales y no numeros en el primer caracter del codigo--->
    <!---<cfif len(trim(rsImportador.MIGAEdescripcion))>
		<cfif FindOneOf('$%&-+*!|##@"',rsImportador.MIGAEdescripcion) GT 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('La descripci&oacute;n no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>--->
	
	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGAEcodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGAEcodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpAEV1# (Error)
				values ('El c&oacute;digo no puede iniciar con numeros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGAEcodigo) GT 0 >
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
		<cfif myMIGAEid EQ "">
			<cfinvoke component="mig.Componentes.AccionEstrategica" method="Alta" returnvariable="MIGAEid">
				<cfinvokeargument name="MIGAEcodigo" 	value="#trim(rsImportador.MIGAEcodigo)#"/>
				<cfinvokeargument name="MIGAEdescripcion" 	value="#rsImportador.MIGAEdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.AccionEstrategica" method="Cambio" >
				<cfinvokeargument name="MIGAEdescripcion" 	value="#rsImportador.MIGAEdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGAEid" 		value="#myMIGAEid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

