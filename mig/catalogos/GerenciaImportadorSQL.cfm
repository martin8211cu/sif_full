<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpGereV1" returnvariable="ErroresImpGereV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpGereV1# (Error)
	select 'La Gerencia ' #_Cat# MIGGcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGGcodigo
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
	<cfif trim(rsImportador.MIGSDcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpGereV1# (Error)
			values ('El C&oacute;digo de la Sub_Direcci&oacute;n no puede ir en blanco')
		</cfquery>
	<cfelse>
		<cfquery name="rsSub_Dir" datasource="#session.dsn#">
			select MIGSDid,MIGSDcodigo,MIGSDdescripcion
			from MIGSDireccion
			where MIGSDcodigo = '#rsImportador.MIGSDcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsSub_Dir.MIGSDid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpGereV1# (Error)
				values ('La Sub_Direcci&oacute;n #rsImportador.MIGSDcodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>	
	<cfif trim(rsImportador.MIGGcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpGereV1# (Error)
			values ('El C&oacute;digo de la Gerencia no puede ir en blanco.')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select MIGSDid,MIGGid, MIGGcodigo,MIGGdescripcion
			from MIGGerencia
			where MIGGcodigo = '#rsImportador.MIGGcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGGid= rsSQL.MIGGid>
	</cfif>
	<cfif trim(rsImportador.MIGGdescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpGereV1# (Error)
			values ('La descripci&oacute;n de la Gerencia no puede ir en blanco.')
		</cfquery>
	</cfif>

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGGcodigo))>

		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGGcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpGereV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpGereV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpGereV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGGid EQ "">
			<cfinvoke component="mig.Componentes.Gerencia" method="Alta" returnvariable="LvarMIGGid">
				<cfinvokeargument name="MIGGcodigo" 	value="#trim(rsImportador.MIGGcodigo)#"/>
				<cfinvokeargument name="MIGGdescripcion" 	value="#rsImportador.MIGGdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGSDid" 		value="#rsSub_Dir.MIGSDid#"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Gerencia" method="Cambio" >
				<cfinvokeargument name="MIGGdescripcion" 	value="#rsImportador.MIGGdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGGid" 		value="#myMIGGid#"/>
				<cfinvokeargument name="MIGSDid" 		value="#rsSub_Dir.MIGSDid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

