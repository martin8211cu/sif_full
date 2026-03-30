<!---======== Tabla temporal de ErroresImpFCV1  ========--->
<cf_dbtemp name="ErroresImpFCV1" returnvariable="ErroresImpFCV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpFCV1# (Error)
	select 'El Factor Critico ' #_Cat# MIGFCcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGFCcodigo
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
	<cfif trim(rsImportador.MIGFCcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpFCV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco.')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGFCid, MIGFCcodigo,MIGFCdescripcion
				from MIGFCritico
				 where MIGFCcodigo = '#rsImportador.MIGFCcodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGFCid = rsSQL.MIGFCid>
	</cfif>
	<cfif trim(rsImportador.MIGFCdescripcion) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpFCV1# (Error)
			values ('La descripci&oacute;n no puede ir en blanco.')
		</cfquery>
	</cfif>
	<!---Validar no caracteres especiales y no numeros en el primer caracter del codigo--->
	<!---<cfif len(trim(rsImportador.MIGFCdescripcion))>
		<cfif FindOneOf('$%&-+*!|##@"',rsImportador.MIGFCdescripcion) GT 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpFCV1# (Error)
				values ('La descripci&oacute;n no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>--->
	
	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGFCcodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGFCcodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpFCV1# (Error)
				values ('El c&oacute;digo no puede iniciar con numeros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGFCcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpFCV1# (Error)
				values ('El c&oacute;digo no contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>	

	<cfquery name="rsErroresImpFCV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpFCV1#
	</cfquery>
<!---Si hay ErroresImpFCV1 no hace la inserción--->
	<cfif rsErroresImpFCV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpFCV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan ErroresImpFCV1.--->
	<cfelse>
		<cfif myMIGFCid EQ "">
			<cfinvoke component="mig.Componentes.FactorCritico" method="Alta" returnvariable="MIGFCid">
				<cfinvokeargument name="MIGFCcodigo" 	value="#trim(rsImportador.MIGFCcodigo)#"/>
				<cfinvokeargument name="MIGFCdescripcion" 	value="#rsImportador.MIGFCdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.FactorCritico" method="Cambio" >
				<cfinvokeargument name="MIGFCdescripcion" 	value="#rsImportador.MIGFCdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="MIGFCid" 		value="#myMIGFCid#"/>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

