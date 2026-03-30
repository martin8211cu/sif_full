<!---======== Tabla temporal de ErroresImpRespV1  ========--->
<cf_dbtemp name="ErroresImpRespV1" returnvariable="ErroresImpRespV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">

<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpRespV1# (Error)
	select 'El Responsable ' #_Cat# MIGRcodigo #_Cat# ' esta repetido en el Archivo.'
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
	<cfif trim(rsImportador.MIGRcodigo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpRespV1# (Error)
			values ('El C&oacute;digo no puede ir en blanco.')
		</cfquery>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select MIGReid,MIGRcodigo,MIGRenombre
				from MIGResponsables
				 where MIGRcodigo = '#rsImportador.MIGRcodigo#'
				   and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset myMIGReid = rsSQL.MIGReid>
	</cfif>
	<cfif trim(rsImportador.MIGRenombre) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpRespV1# (Error)
			values ('El nombre no puede ir en blanco.')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.MIGRecorreo) EQ "">
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpRespV1# (Error)
			values ('El correo no puede ir en blanco.')
		</cfquery>
	</cfif>
	
	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGRcodigo))>

		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGRcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpRespV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>	

	<cfquery name="rsErroresImpRespV1" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpRespV1#
	</cfquery>
<!---Si hay ErroresImpRespV1 no hace la inserción--->
	<cfif rsErroresImpRespV1.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpRespV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan ErroresImpRespV1.--->
	<cfelse>
		<cfif myMIGReid EQ "">
			<cfinvoke component="mig.Componentes.Responsable" method="Alta" returnvariable="MIGReid">
				<cfinvokeargument name="MIGRcodigo" 	value="#trim(rsImportador.MIGRcodigo)#"/>
				<cfinvokeargument name="MIGRenombre" 	value="#rsImportador.MIGRenombre#"/>
				<cfinvokeargument name="Dactivas" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			<cfif isdefined ('rsImportador.MIGRecorreo') and trim(rsImportador.MIGRecorreo) NEQ "">
				<cfinvokeargument name="MIGRecorreo" 	value="#rsImportador.MIGRecorreo#"/>
			<cfelse>
				<cfinvokeargument name="MIGRecorreo" 	value=""/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGRecorreoadicional') and trim(rsImportador.MIGRecorreoadicional) NEQ "">
				<cfinvokeargument name="MIGRecorreoadicional" 	value="#rsImportador.MIGRecorreoadicional#"/>
			<cfelse>
				<cfinvokeargument name="MIGRecorreoadicional" 	value=""/>
			</cfif>
			
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Responsable" method="Cambio" >
				<cfinvokeargument name="MIGRenombre" 	value="#rsImportador.MIGRenombre#"/>
				<cfinvokeargument name="Dactivas" 		value="1"/>
				<cfinvokeargument name="MIGReid" 		value="#myMIGReid#"/>
			<cfif isdefined ('rsImportador.MIGRecorreo') and trim(rsImportador.MIGRecorreo) NEQ "">
				<cfinvokeargument name="MIGRecorreo" 	value="#rsImportador.MIGRecorreo#"/>
			<cfelse>
				<cfinvokeargument name="MIGRecorreo" 	value=""/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGRecorreoadicional') and trim(rsImportador.MIGRecorreoadicional) NEQ "">
				<cfinvokeargument name="MIGRecorreoadicional" 	value="#rsImportador.MIGRecorreoadicional#"/>
			<cfelse>
				<cfinvokeargument name="MIGRecorreoadicional" 	value=""/>
			</cfif>
			</cfinvoke>			
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

