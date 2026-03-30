<!---======== Tabla temporal de ErroresImpSegV1  ========--->
<cf_dbtemp name="ErroresImpSegV1" returnvariable="ErroresImpSegV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpSegV1# (Error)
	select 'La Perspectiva ' #_Cat# MIGProSegcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGProSegcodigo
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
	<cfif trim(rsImportador.MIGProSegcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpSegV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGProSegid,MIGProSegcodigo,MIGProSegdescripcion
				from MIGProSegmentos
				 where MIGProSegcodigo = '#rsImportador.MIGProSegcodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGProSegid = rsSQL.MIGProSegid>
	</cfif>
	
	<cfif trim(rsImportador.MIGProSegdescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpSegV1# (Error)
			values ('La descripci&oacute;n  no puede ir en blanco')
		</cfquery>
	</cfif>		

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGProSegcodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGProSegcodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpSegV1# (Error)
				values ('El c&oacute;digo no puede iniciar con n&uacute;meros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGProSegcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpSegV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>


	<cfquery name="rsErroresImpSegV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpSegV1#
	</cfquery>
<!---Si hay ErroresImpSegV1 no hace la inserción--->
	<cfif rsErroresImpSegV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpSegV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan ErroresImpSegV1.--->
	<cfelse>
		<cfif myMIGProSegid EQ "">
			<cfinvoke component="mig.Componentes.Segmento" method="Alta" returnvariable="MIGProSegmentos">
				<cfinvokeargument name="MIGProSegcodigo" 	value="#trim(rsImportador.MIGProSegcodigo)#"/>
				<cfinvokeargument name="MIGProSegdescripcion" 	value="#rsImportador.MIGProSegdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Segmento" method="Cambio" >
				<cfinvokeargument name="MIGProSegdescripcion" 	value="#rsImportador.MIGProSegdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGProSegid" 		value="#myMIGProSegid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

