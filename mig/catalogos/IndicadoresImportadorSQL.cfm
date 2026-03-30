<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpINDV1" returnvariable="ErroresImpINDV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpINDV1# (Error)
	select 'El Indicador ' #_Cat# MIGMcodigo #_Cat# ' esta repetido en el Archivo.'
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
			Insert into #ErroresImpINDV1# (Error)
			values ('El C&oacute;digo del Indicador no puede ir en blanco')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.MIGMnombre) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpINDV1# (Error)
			values ('El nombre del Indicador no puede ir en blanco')
		</cfquery>
	</cfif>
	<!--- Valida Estado Activo=1 Inactivo=0--->	
	<cfif trim(rsImportador.Dactiva) NEQ "">
		<cfif trim(rsImportador.Dactiva) NEQ 0 and trim(rsImportador.Dactiva) NEQ 1>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('Favor verificar Estado. Activo=1 Inactivo=0')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif trim(rsImportador.MIGMperiodicidad) NEQ "">
		<cfif trim(rsImportador.MIGMperiodicidad) NEQ "W" and trim(rsImportador.MIGMperiodicidad) NEQ "M" and trim(rsImportador.MIGMperiodicidad) NEQ "T" and trim(rsImportador.MIGMperiodicidad) NEQ "S" and trim(rsImportador.MIGMperiodicidad) NEQ "A">
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('Favor Verificar el valor de la periodicidad. Posibles Valores:W,M,T,S,A')
			</cfquery>
		</cfif>
	</cfif>	
	
	<cfif trim(rsImportador.MIGMtendenciapositiva) NEQ "">
		<cfif trim(rsImportador.MIGMtendenciapositiva) NEQ "+" and trim(rsImportador.MIGMtendenciapositiva) NEQ "-" and trim(rsImportador.MIGMtendenciapositiva) NEQ "p">
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('Favor Verificar el valor de la tendencia. Posibles Valores:+,-,p')
			</cfquery>
		</cfif>
	</cfif>	
	
	<cfif trim(rsImportador.MIGMsequencia) NEQ "">
		<cfif trim(rsImportador.MIGMsequencia) lt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('La secuencia solo acepta valores num&egrave;ricos')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif trim(rsImportador.MIGMtipotolerancia) NEQ "">
		<cfif trim(rsImportador.MIGMtipotolerancia) NEQ "A" and trim(rsImportador.MIGMtipotolerancia) NEQ "P">
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('Favor verifique el valor de la tolerancia. Posibles valores: A, P')
			</cfquery>
		</cfif>
	</cfif>	
	
	<cfif trim(rsImportador.MIGMtoleranciainferior) NEQ "">
		<cfif trim(rsImportador.MIGMtoleranciainferior) lt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('La Tolernacia Inferior solo acepta valores num&egrave;ricos')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif trim(rsImportador.MIGMtoleranciasuperior) NEQ "">
		<cfif trim(rsImportador.MIGMtoleranciasuperior) lt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('La Tolernacia Superior solo acepta valores num&egrave;ricos')
			</cfquery>
		</cfif>
	</cfif>				
	

<!---Valida que El TIPO sea S o P--->
<!---
	<cfif trim(rsImportador.MIGProesproducto) NEQ "">
		<cfquery name="rsValidaesProducto" datasource="#session.dsn#">
			select upper(rtrim(MIGProesproducto)) as esprod from #table_name# 
		</cfquery>
		<cfset LvarEsProdcto=rsValidaesProducto.esprod>
		<cfif LvarEsProdcto NEQ 'P' and LvarEsProdcto NEQ 'S'>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('Favor verificar el tipo. Tipo= Servicio:S Producto: P')
			</cfquery>
		</cfif>
	</cfif>
<!--- Valida que El Indicador sea Existente=1 Nuevo=0--->	
	<cfif trim(rsImportador.MIGProesnuevo) NEQ "">
		<cfif trim(rsImportador.MIGProesnuevo) NEQ 0 and trim(rsImportador.MIGProesnuevo) NEQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('Favor verificar El Indicador. Existen=1 Nuevo=0')
			</cfquery>
		</cfif>
	</cfif>
--->
	
<!---Valida Existencia de los valores ingresados por el importador.--->	
	<cfif trim(rsImportador.MIGRcodigo) NEQ "">	
		<cfquery name="rsReponsable" datasource="#session.dsn#">
			select MIGReid,MIGRcodigo,MIGRcodigo
			from MIGResponsables
			where MIGRcodigo = '#rsImportador.MIGRcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsReponsable.MIGReid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('El Responsable #rsImportador.MIGRcodigo# no existe')
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpINDV1# (Error)
			values ('El Responsable no puede quedar en blanco ')
		</cfquery>		
	</cfif>
	
	<cfif trim(rsImportador.MIGRcodigoFM) NEQ "">	
		<cfquery name="rsReponsableFM" datasource="#session.dsn#">
			select MIGReid,MIGRcodigo,MIGRcodigo
			from MIGResponsables
			where MIGRcodigo = '#rsImportador.MIGRcodigoFM#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsReponsableFM.MIGReid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('El Responsable Fija Meta #rsImportador.MIGRcodigoFM# no existe')
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpINDV1# (Error)
			values ('El Responsable Fija Meta no puede quedar en blanco ')
		</cfquery>	
	</cfif>
	
	<cfif trim(rsImportador.MIGRcodigoD) NEQ "">	
		<cfquery name="rsReponsableD" datasource="#session.dsn#">
			select MIGReid,MIGRcodigo,MIGRcodigo
			from MIGResponsables
			where MIGRcodigo = '#rsImportador.MIGRcodigoD#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsReponsableD.MIGReid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('El Dueño #rsImportador.MIGRcodigoD# no existe')
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpINDV1# (Error)
			values ('El Dueño no puede quedar en blanco ')
		</cfquery>	
	</cfif>	
	
	<cfif rsImportador.Ucodigo NEQ "">
		<cfquery name="rsUnidades" datasource="#session.dsn#">
			select Ecodigo, Ucodigo, Udescripcion
			from Unidades
			where Ucodigo = '#rsImportador.Ucodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsUnidades.Ucodigo EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('La Unidad #rsImportador.Ucodigo# no existe')
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpINDV1# (Error)
			values ('Las Unidades no pueden quedar en blanco ')
		</cfquery>	
	</cfif>		
	<cfif trim(rsImportador.MIGPercodigo) NEQ "">	
		<cfquery name="rsPerspectivas" datasource="#session.dsn#">
			select MIGPerid, MIGPercodigo
			from MIGPerspectiva
			where MIGPercodigo = '#rsImportador.MIGPercodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsPerspectivas.MIGPerid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpINDV1# (Error)
				values ('La Perspectiva #rsImportador.MIGPercodigo# no existe')
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpINDV1# (Error)
			values ('La perspectiva no puede quedar en blanco ')
		</cfquery>	
	</cfif>			

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select MIGMid,MIGMcodigo
		from MIGMetricas
		where MIGMcodigo = '#rsImportador.MIGMcodigo#'
		and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset myMIGMid= rsSQL.MIGMid>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpINDV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpINDV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGMid EQ "">
			<cfinvoke component="mig.Componentes.Indicadores" method="Alta" returnvariable="MIGMid">
				<cfinvokeargument name="MIGMcodigo" 				value="#rsImportador.MIGMcodigo#"/>
				<cfinvokeargument name="MIGMnombre" 				value="#rsImportador.MIGMnombre#"/>
				<cfinvokeargument name="MIGReid" 					value="#rsReponsable.MIGReid#"/>
				<cfinvokeargument name="MIGReidduenno" 				value="#rsReponsableD.MIGReid#"/>
				<cfinvokeargument name="MIGPerid" 					value="#rsPerspectivas.MIGPerid#"/>
				<cfinvokeargument name="Ucodigo" 					value="#rsUnidades.Ucodigo#"/>
			<cfif isdefined ('rsImportador.MIGMnpresentacion') and ltrim(rsImportador.MIGMnpresentacion) NEQ "">
				<cfinvokeargument name="MIGMnpresentacion" 		value="#rsImportador.MIGMnpresentacion#"/>
			<cfelse>
				<cfinvokeargument name="MIGMnpresentacion" 		value=""/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMdescripcion') and ltrim(rsImportador.MIGMdescripcion) NEQ "">
				<cfinvokeargument name="MIGMdescripcion" 			value="#rsImportador.MIGMdescripcion#"/>
			<cfelse>
				<cfinvokeargument name="MIGMdescripcion" 			value="#rsImportador.MIGMdescripcion#"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMsequencia') and ltrim(rsImportador.MIGMsequencia) NEQ "">
				<cfinvokeargument name="MIGMsequencia" 			value="#rsImportador.MIGMsequencia#"/>
			<cfelse>
				<cfinvokeargument name="MIGMsequencia" 			value="1"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMperiodicidad') and ltrim(rsImportador.MIGMperiodicidad) NEQ "">
				<cfinvokeargument name="MIGMperiodicidad" 		value="#rsImportador.MIGMperiodicidad#"/>
			<cfelse>
				<cfinvokeargument name="MIGMperiodicidad" 		value="M"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMtoleranciainferior') and ltrim(rsImportador.MIGMtoleranciainferior) NEQ "">
				<cfinvokeargument name="MIGMtoleranciainferior"	value="#rsImportador.MIGMtoleranciainferior#"/>
			<cfelse>
				<cfinvokeargument name="MIGMtoleranciainferior"	value="1"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMtipotolerancia') and ltrim(rsImportador.MIGMtipotolerancia) NEQ "">
				<cfinvokeargument name="MIGMtipotolerancia"		value="#rsImportador.MIGMtipotolerancia#"/>
			<cfelse>
				<cfinvokeargument name="MIGMtipotolerancia"		value="P"/>	
			</cfif>
			<cfif isdefined ('rsImportador.MIGMtoleranciasuperior') and ltrim(rsImportador.MIGMtoleranciasuperior) NEQ "">
				<cfinvokeargument name="MIGMtoleranciasuperior"	value="#rsImportador.MIGMtoleranciasuperior#"/>
			<cfelse>
				<cfinvokeargument name="MIGMtoleranciasuperior"	value="1"/>
			</cfif>
				<cfinvokeargument name="MIGReidFija"				value="#rsReponsableFM.MIGReid#"/>
			<cfif isdefined ('rsImportador.MIGMtendenciapositiva') and ltrim(rsImportador.MIGMtendenciapositiva) NEQ "">
				<cfinvokeargument name="MIGMtendenciapositiva"	value="#rsImportador.MIGMtendenciapositiva#"/>
			<cfelse>
				<cfinvokeargument name="MIGMtendenciapositiva"	value="+"/>
			</cfif>
			<cfif isdefined ('rsImportador.Dactiva') and ltrim(rsImportador.Dactiva) NEQ "">
				<cfinvokeargument name="Dactiva" 					value="#rsImportador.Dactiva#"/>
			<cfelse>
				<cfinvokeargument name="Dactiva" 					value="1"/>
			</cfif>
				<cfinvokeargument name="CodFuente" 					value="2"/>
			</cfinvoke>
		<cfelse>
			<cfinvoke component="mig.Componentes.Indicadores" method="Cambio" >
				<cfinvokeargument name="MIGMid" 					value="#myMIGMid#"/>
				<cfinvokeargument name="MIGMnombre" 				value="#rsImportador.MIGMnombre#"/>
				<cfinvokeargument name="MIGReid" 					value="#rsReponsable.MIGReid#"/>
				<cfinvokeargument name="MIGReidduenno" 				value="#rsReponsableD.MIGReid#"/>
				<cfinvokeargument name="MIGPerid" 					value="#rsPerspectivas.MIGPerid#"/>
				<cfinvokeargument name="Ucodigo" 					value="#rsUnidades.Ucodigo#"/>
			<cfif isdefined ('rsImportador.MIGMnpresentacion') and ltrim(rsImportador.MIGMnpresentacion) NEQ "">
				<cfinvokeargument name="MIGMnpresentacion" 		value="#rsImportador.MIGMnpresentacion#"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMdescripcion') and ltrim(rsImportador.MIGMdescripcion) NEQ "">
				<cfinvokeargument name="MIGMdescripcion" 			value="#rsImportador.MIGMdescripcion#"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMsequencia') and ltrim(rsImportador.MIGMsequencia) NEQ "">
				<cfinvokeargument name="MIGMsequencia" 			value="#rsImportador.MIGMsequencia#"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMperiodicidad') and ltrim(rsImportador.MIGMperiodicidad) NEQ "">
				<cfinvokeargument name="MIGMperiodicidad" 		value="#rsImportador.MIGMperiodicidad#"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMtoleranciainferior') and ltrim(rsImportador.MIGMtoleranciainferior) NEQ "">
				<cfinvokeargument name="MIGMtoleranciainferior"	value="#rsImportador.MIGMtoleranciainferior#"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMtipotolerancia') and ltrim(rsImportador.MIGMtipotolerancia) NEQ "">
				<cfinvokeargument name="MIGMtipotolerancia"		value="#rsImportador.MIGMtipotolerancia#"/>
			</cfif>
			<cfif isdefined ('rsImportador.MIGMtoleranciasuperior') and ltrim(rsImportador.MIGMtoleranciasuperior) NEQ "">
				<cfinvokeargument name="MIGMtoleranciasuperior"	value="#rsImportador.MIGMtoleranciasuperior#"/>
			</cfif>
				<cfinvokeargument name="MIGReidFija"				value="#rsReponsableFM.MIGReid#"/>
			<cfif isdefined ('rsImportador.MIGMtendenciapositiva') and ltrim(rsImportador.MIGMtendenciapositiva) NEQ "">
				<cfinvokeargument name="MIGMtendenciapositiva"	value="#rsImportador.MIGMtendenciapositiva#"/>
			</cfif>
			<cfif isdefined ('rsImportador.Dactiva') and ltrim(rsImportador.Dactiva) NEQ "">
				<cfinvokeargument name="Dactiva" 					value="#rsImportador.Dactiva#"/>
			</cfif>
				<cfinvokeargument name="CodFuente" 					value="2"/>
			</cfinvoke>	
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

