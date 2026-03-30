<!---======== Tabla temporal de ErroresImpDirecV1  ========--->
<cf_dbtemp name="ErroresImpDirecV1" returnvariable="ErroresImpDirecV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpDirecV1# (Error)
	select 'La Direcci&oacute;n ' #_Cat# MIGDcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGDcodigo
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
			Insert into #ErroresImpDirecV1# (Error)
			values ('El C&oacute;digo  no puede ir en blanco')
		</cfquery>	
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGDid,MIGDcodigo, MIGDnombre
				  from MIGDireccion
				 where MIGDcodigo = '#rsImportador.MIGDcodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGDid = rsSQL.MIGDid>
	</cfif>
	<cfif trim(rsImportador.MIGDnombre) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpDirecV1# (Error)
			values ('La descripci&oacute;n  no puede ir en blanco')
		</cfquery>	
	</cfif>
	
	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGDcodigo))>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGDcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpDirecV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="rsErroresImpDirecV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpDirecV1#
	</cfquery>
<!---Si hay ErroresImpDirecV1 no hace la inserción--->
	<cfif rsErroresImpDirecV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpDirecV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan ErroresImpDirecV1.--->
	<cfelse>
		<cfif myMIGDid EQ "">
			<cfinvoke component="mig.Componentes.Direccion" method="Alta" returnvariable="MIGDid">
				<cfinvokeargument name="MIGDcodigo" 	value="#trim(rsImportador.MIGDcodigo)#"/>
				<cfinvokeargument name="MIGDnombre" 	value="#rsImportador.MIGDnombre#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Direccion" method="Cambio" >
				<cfinvokeargument name="MIGDnombre" 	value="#rsImportador.MIGDnombre#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGDid" 		value="#myMIGDid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

