<!---======== Tabla temporal de ErroresImpLinV1  ========--->
<cf_dbtemp name="ErroresImpLinV1" returnvariable="ErroresImpLinV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpLinV1# (Error)
	select 'La Perspectiva ' #_Cat# MIGProLincodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGProLincodigo
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
	<cfif trim(rsImportador.MIGProLincodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpLinV1# (Error)
			values ('El C&oacute;digo de la Linea no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGProLinid, MIGProLincodigo, MIGProLindescripcion
				from MIGProLineas
				 where MIGProLincodigo = '#rsImportador.MIGProLincodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGProLinid = rsSQL.MIGProLinid>
	</cfif>
	<cfif trim(rsImportador.MIGProLindescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpLinV1# (Error)
			values ('La descripci&oacute;n de la Linea no puede ir en blanco')
		</cfquery>
	</cfif>	

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGProLincodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGProLincodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpLinV1# (Error)
				values ('El c&oacute;digo no puede iniciar con n&uacute;meros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGProLincodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpLinV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="rsErroresImpLinV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpLinV1#
	</cfquery>
<!---Si hay ErroresImpLinV1 no hace la inserción--->
	<cfif rsErroresImpLinV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpLinV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan ErroresImpLinV1.--->
	<cfelse>
		<cfif myMIGProLinid EQ "">
			<cfinvoke component="mig.Componentes.Lineas" method="Alta" returnvariable="MIGProLineas">
				<cfinvokeargument name="MIGProLincodigo" 	value="#trim(rsImportador.MIGProLincodigo)#"/>
				<cfinvokeargument name="MIGProLindescripcion" 	value="#rsImportador.MIGProLindescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Lineas" method="Cambio" >
				<cfinvokeargument name="MIGProLindescripcion" 	value="#rsImportador.MIGProLindescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGProLinid" 		value="#myMIGProLinid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

