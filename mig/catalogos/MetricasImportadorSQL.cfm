<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpMetV1" returnvariable="ErroresImpMetV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpMetV1# (Error)
	select 'La M&egrave;trica ' #_Cat# rtrim(MIGMcodigo) #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGMcodigo
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
	
<!---Valida que los valores ingresados por el importador  no vayan en blanco.--->
	<cfif trim(rsImportador.MIGMcodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetV1# (Error)
			values ('El C&oacute;digo de la M&eacute;trica no puede ir en blanco')
		</cfquery>
	<cfelseif trim(rsImportador.MIGMcodigo) GT 0>
		<cfset LvarCodigoM=rsImportador.MIGMcodigo>
		<cfset LvarCod=mid(LvarCodigoM,1,1)>
		<cfif LvarCod GTE 0 and LvarCod LTE 9 or LvarCod EQ '-' or LvarCod EQ '+' or LvarCod EQ '/' or LvarCod EQ '*'>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpMetV1# (Error)
				values ('El formato del código esta incorrecto. El código solo puede recibir valores alfanuméricos.')
			</cfquery>
		</cfif>
	</cfif>
	<cfif trim(rsImportador.MIGMnombre) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetV1# (Error)
			values ('La decrici&oacute;n de la M&eacute;trica no puede ir en blanco')
		</cfquery>
	</cfif>	
	<cfif trim(rsImportador.MIGRcodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetV1# (Error)
			values ('El C&oacute;digo del Responsable no puede ir en blanco')
		</cfquery>
	</cfif>
	
	<cfif trim(rsImportador.MIGMsequencia) LT 0>	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetV1# (Error)
			values ('La Secuencia de la M&eacute;trica debe ser un valor de tipo Num&eacute;rico.')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.MIGMperiodicidad) NEQ 'D' and trim(rsImportador.MIGMperiodicidad) NEQ 'W' and trim(rsImportador.MIGMperiodicidad) NEQ 'M' and trim(rsImportador.MIGMperiodicidad) NEQ 'T' and trim(rsImportador.MIGMperiodicidad) NEQ 'S' and trim(rsImportador.MIGMperiodicidad) NEQ 'A'> 
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetV1# (Error)
			values ('Verificar la Periodicidad ya que esta incorrecta: Posibles valores:(D,W,M,T,S,A)')
		</cfquery>
	</cfif>
<!---Valida Existencia de los valores ingresados por el importador.--->	
	<cfquery name="rsResponsables" datasource="#session.dsn#">
		select MIGReid, MIGRcodigo,MIGRenombre
		from MIGResponsables
		where MIGRcodigo = '#rsImportador.MIGRcodigo#'
		and Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfif rsResponsables.MIGReid EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpMetV1# (Error)
			values ('El Responsable #rsImportador.MIGRcodigo# no existe')
		</cfquery>
	</cfif>
	
	<cfif trim(rsImportador.Ucodigo) NEQ "">
		<cfquery name="rsUnidades" datasource="#session.dsn#">
			select Ecodigo, Ucodigo, Udescripcion
			from Unidades
			where Ucodigo = '#rsImportador.Ucodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsUnidades.Ucodigo EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpMetV1# (Error)
				values ('La Unidad #rsImportador.Ucodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>		

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select MIGMid,MIGMcodigo,MIGMnombre
		from MIGMetricas
		where MIGMcodigo = '#rsImportador.MIGMcodigo#'
		and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset myMIGMid= rsSQL.MIGMid>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpMetV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpMetV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGMid EQ "">
			<cfinvoke component="mig.Componentes.Metricas" method="Alta" returnvariable="MIGMid">
				<cfinvokeargument name="MIGMcodigo" 	value="#trim(rsImportador.MIGMcodigo)#"/>
				<cfinvokeargument name="MIGMnombre" 	value="#rsImportador.MIGMnombre#"/>
				<cfinvokeargument name="MIGReid" 		value="#rsResponsables.MIGReid#"/>
			<cfif trim(rsImportador.Ucodigo) NEQ "">
				<cfinvokeargument name="Ucodigo" 				value="#rsUnidades.Ucodigo#"/>
			<cfelse>
				<cfinvokeargument name="Ucodigo" 				value="-1"/>
			</cfif>
			<cfif rsImportador.MIGMdescripcion NEQ "">
				<cfinvokeargument name="MIGMdescripcion" 		value="#rsImportador.MIGMdescripcion#"/>
			<cfelse>
				<cfinvokeargument name="MIGMdescripcion" 		value=""/>
			</cfif>
			<cfif rsImportador.MIGMnpresentacion NEQ "">
				<cfinvokeargument name="MIGMnpresentacion" 		value="#rsImportador.MIGMnpresentacion#"/>
			<cfelse>
				<cfinvokeargument name="MIGMnpresentacion" 		value=""/>
			</cfif>
			<cfif rsImportador.MIGMsequencia NEQ "" >
				<cfinvokeargument name="MIGMsequencia" 			value="#rsImportador.MIGMsequencia#"/>
			<cfelse>
				<cfinvokeargument name="MIGMsequencia" 			value="0"/>
			</cfif>
			<cfif trim(rsImportador.MIGMperiodicidad) NEQ "">
				<cfinvokeargument name="MIGMperiodicidad" 			value="#trim(rsImportador.MIGMperiodicidad)#"/>
			<cfelse>
				<cfinvokeargument name="MIGMperiodicidad" 			value="M"/>
			</cfif>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Metricas" method="Cambio" >
				<cfinvokeargument name="MIGMnombre" 			value="#rsImportador.MIGMnombre#"/>
				<cfinvokeargument name="MIGMid" 				value="#myMIGMid#"/>
				<cfinvokeargument name="MIGReid" 				value="#rsResponsables.MIGReid#"/>
			<cfif rsImportador.Ucodigo NEQ "">
				<cfinvokeargument name="Ucodigo" 				value="#rsImportador.Ucodigo#"/>
			</cfif>
			<cfif rsImportador.MIGMdescripcion NEQ "">
				<cfinvokeargument name="MIGMdescripcion" 		value="#rsImportador.MIGMdescripcion#"/>
			</cfif>
			<cfif rsImportador.MIGMnpresentacion NEQ "">
				<cfinvokeargument name="MIGMnpresentacion" 		value="#rsImportador.MIGMnpresentacion#"/>
			</cfif>
			<cfif rsImportador.MIGMsequencia NEQ "" >
				<cfinvokeargument name="MIGMsequencia" 			value="#rsImportador.MIGMsequencia#"/>
			</cfif>
			<cfif rsImportador.MIGMperiodicidad NEQ "" >
				<cfinvokeargument name="MIGMperiodicidad" 			value="#trim(rsImportador.MIGMperiodicidad)#"/>
			<cfelse>
				<cfinvokeargument name="MIGMperiodicidad" 			value="M"/>
			</cfif>
			</cfinvoke>
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

