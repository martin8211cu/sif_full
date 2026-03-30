<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ErroresImpProdV1" returnvariable="ErroresImpProdV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">



<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #ErroresImpProdV1# (Error)
	select 'El producto ' #_Cat# MIGProcodigo #_Cat# ' esta repetido en el Archivo.'
	from #table_name# 
	group by MIGProcodigo
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
	<cfif trim(rsImportador.MIGProcodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpProdV1# (Error)
			values ('El C&oacute;digo del Producto no puede ir en blanco')
		</cfquery>
	</cfif>
	<cfif trim(rsImportador.MIGPronombre) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpProdV1# (Error)
			values ('El nombre del Producto no puede ir en blanco')
		</cfquery>
	</cfif>	
	<cfif trim(rsImportador.MIGProLincodigo) EQ "">	
		<cfquery name="ERR" datasource="#session.DSN#">
			Insert into #ErroresImpProdV1# (Error)
			values ('La primera Línea de Negocio no puede ir en blanco')
		</cfquery>
	</cfif>

	<!---No contenido de espacios en blanco en el codigo--->
	<cfif len(trim(rsImportador.MIGProcodigo))>
		
		<!---No inicio de codigo con numeros--->
		<cfif FindOneOf('0123456789', Mid(rsImportador.MIGProcodigo, 1, 1) ) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('El c&oacute;digo no puede iniciar con n&uacute;meros.')
			</cfquery>
		</cfif>
		
		<!---No caracteres especiales--->
		<cfif FindOneOf('$%&-+*!|##@" ', rsImportador.MIGProcodigo) GT 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('El c&oacute;digo no puede contener caracteres especiales.')
			</cfquery>
		</cfif>
	</cfif>

<!---Valida que El TIPO sea S o P--->

	<cfif trim(rsImportador.MIGProesproducto) NEQ "">
		<cfquery name="rsValidaesProducto" datasource="#session.dsn#">
			select upper(rtrim(MIGProesproducto)) as esprod from #table_name# 
		</cfquery>
		<cfset LvarEsProdcto=rsValidaesProducto.esprod>
		<cfif LvarEsProdcto NEQ 'P' and LvarEsProdcto NEQ 'S'>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('Favor verificar el tipo. Tipo= Servicio:S Producto: P')
			</cfquery>
		</cfif>
	</cfif>
<!--- Valida que El Producto sea Existente=1 Nuevo=0--->	
	<cfif trim(rsImportador.MIGProesnuevo) NEQ "">
		<cfif trim(rsImportador.MIGProesnuevo) NEQ 0 and trim(rsImportador.MIGProesnuevo) NEQ 1>
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('Favor verificar el Producto. Existen=1 Nuevo=0')
			</cfquery>
		</cfif>
	</cfif>
	
<!---Valida Existencia de los valores ingresados por el importador.--->	
	<cfif trim(rsImportador.MIGProLincodigo) NEQ "">	
		<cfquery name="rsLines1" datasource="#session.dsn#">
			select MIGProLinid,MIGProLincodigo
			from MIGProLineas
			where MIGProLincodigo = '#rsImportador.MIGProLincodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsLines1.MIGProLinid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('La Primera Línea de Negocio #rsImportador.MIGProLincodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif trim(rsImportador.MIGProLincodigo2) NEQ "">	
		<cfquery name="rsLines2" datasource="#session.dsn#">
			select MIGProLinid,MIGProLincodigo
			from MIGProLineas
			where MIGProLincodigo = '#rsImportador.MIGProLincodigo2#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsLines2.MIGProLinid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('La Segunda Línea de Negocio #rsImportador.MIGProLincodigo2# no existe')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif trim(rsImportador.MIGProLincodigo3) NEQ "">	
		<cfquery name="rsLines3" datasource="#session.dsn#">
			select MIGProLinid,MIGProLincodigo
			from MIGProLineas
			where MIGProLincodigo = '#rsImportador.MIGProLincodigo3#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsLines3.MIGProLinid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('La Tercera Línea de Negocio #rsImportador.MIGProLincodigo3# no existe')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif trim(rsImportador.MIGProLincodigo4) NEQ "">	
		<cfquery name="rsLines4" datasource="#session.dsn#">
			select MIGProLinid,MIGProLincodigo
			from MIGProLineas
			where MIGProLincodigo = '#rsImportador.MIGProLincodigo4#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsLines4.MIGProLinid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('La Cuarta Línea de Negocio #rsImportador.MIGProLincodigo4# no existe')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif rsImportador.MIGProSegcodigo NEQ "">
		<cfquery name="rsSegmentos" datasource="#session.dsn#">
			select MIGProSegid,MIGProSegcodigo
			from MIGProSegmentos
			where MIGProSegcodigo = '#rsImportador.MIGProSegcodigo#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsSegmentos.MIGProSegid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('El segmento #rsImportador.MIGProSegcodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif rsImportador.MIGProSegcodigo2 NEQ "">
		<cfquery name="rsSegmentos2" datasource="#session.dsn#">
			select MIGProSegid,MIGProSegcodigo
			from MIGProSegmentos
			where MIGProSegcodigo = '#rsImportador.MIGProSegcodigo2#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsSegmentos2.MIGProSegid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('El segmento #rsImportador.MIGProSegcodigo2# no existe')
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif rsImportador.MIGProSegcodigo3 NEQ "">
		<cfquery name="rsSegmentos3" datasource="#session.dsn#">
			select MIGProSegid,MIGProSegcodigo
			from MIGProSegmentos
			where MIGProSegcodigo = '#rsImportador.MIGProSegcodigo3#'
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsSegmentos3.MIGProSegid EQ "">	
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #ErroresImpProdV1# (Error)
				values ('El segmento #rsImportador.MIGProSegcodigo3# no existe')
			</cfquery>
		</cfif>
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
				Insert into #ErroresImpProdV1# (Error)
				values ('La Unidad #rsImportador.Ucodigo# no existe')
			</cfquery>
		</cfif>
	</cfif>		

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select MIGProid,MIGProcodigo
		from MIGProductos
		where MIGProcodigo = '#rsImportador.MIGProcodigo#'
		and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset myMIGProid= rsSQL.MIGProid>

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #ErroresImpProdV1#
	</cfquery>
<!---Si hay errores no hace la inserción--->
	<cfif rsErrores.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #ErroresImpProdV1#
		</cfquery>
		<cfreturn>
<!---Hace lo inserción en caso de que no hayan errores.--->
	<cfelse>
		<cfif myMIGProid EQ "">
			<cfinvoke component="mig.Componentes.Productos" method="Alta" returnvariable="MIGProid">
			<cfinvokeargument name="MIGProcodigo" 				value="#rsImportador.MIGProcodigo#"/>
			<cfinvokeargument name="Dactiva" 					value="#rsImportador.Dactiva#"/>
			<cfinvokeargument name="MIGPronombre" 				value="#rsImportador.MIGPronombre#"/>
		<cfif trim(rsImportador.MIGProSegcodigo) NEQ "">	
			<cfinvokeargument name="MIGProSegid" 				value="#rsSegmentos.MIGProSegid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProSegcodigo2) NEQ "">	
			<cfinvokeargument name="MIGProSegid2" 				value="#rsSegmentos2.MIGProSegid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid2" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProSegcodigo3) NEQ "">	
			<cfinvokeargument name="MIGProSegid3" 				value="#rsSegmentos3.MIGProSegid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid3" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.Ucodigo) NEQ "">	
			<cfinvokeargument name="id_unidad_medida" 			value="#rsImportador.Ucodigo#"/>
		<cfelse>
			<cfinvokeargument name="id_unidad_medida" 				value="null"/>
		</cfif>
			<cfinvokeargument name="MIGProLinid" 				value="#rsLines1.MIGProLinid#"/>
		<cfif trim(rsImportador.MIGProLincodigo2) NEQ "">	
			<cfinvokeargument name="MIGProLinid2" 				value="#rsLines2.MIGProLinid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid2" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProLincodigo3) NEQ "">		
			<cfinvokeargument name="MIGProLinid3" 				value="#rsLines3.MIGProLinid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid3" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProLincodigo4) NEQ "">		
			<cfinvokeargument name="MIGProLinid4" 				value="#rsLines4.MIGProLinid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid4" 				value="null"/>
		</cfif>
		<cfif ltrim(rsImportador.MIGProLincodigo5) NEQ "">	
			<cfinvokeargument name="MIGProlinea5"				value="#rsImportador.MIGProLincodigo5#"/>
		<cfelse>
			<cfinvokeargument name="MIGProlinea5"				value=" "/>
		</cfif>
		<cfif ltrim(rsImportador.MIGProplanta) NEQ "" >			
			<cfinvokeargument name="MIGProplanta"				value="#rsImportador.MIGProplanta#"/>
		<cfelse>
			<cfinvokeargument name="MIGProplanta"				value=""/>
		</cfif>
		<cfif trim(rsImportador.MIGProesproducto) NEQ "">
			<cfinvokeargument name="MIGProesproducto"			value="#LvarEsProdcto#"/>
		<cfelse>
			<cfinvokeargument name="MIGProesproducto"			value="P"/>
		</cfif>
		<cfif Ltrim(rsImportador.MIGProesproducto) NEQ "">
			<cfinvokeargument name="MIGProesnuevo"				value="#rsImportador.MIGProesnuevo#"/>
		<cfelse>
			<cfinvokeargument name="MIGProesnuevo"			value="1"/>
		</cfif>
		</cfinvoke>
		
		<cfelse>
			<cfinvoke component="mig.Componentes.Productos" method="Cambio" >
			<cfinvokeargument name="MIGProid" 				value="#myMIGProid#"/>
			<cfinvokeargument name="MIGProcodigo" 				value="#rsImportador.MIGProcodigo#"/>
			<cfinvokeargument name="Dactiva" 					value="#rsImportador.Dactiva#"/>
			<cfinvokeargument name="MIGPronombre" 				value="#rsImportador.MIGPronombre#"/>
		<cfif trim(rsImportador.MIGProSegcodigo) NEQ "">	
			<cfinvokeargument name="MIGProSegid" 				value="#rsSegmentos.MIGProSegid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProSegcodigo2) NEQ "">	
			<cfinvokeargument name="MIGProSegid2" 				value="#rsSegmentos2.MIGProSegid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid2" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProSegcodigo3) NEQ "">	
			<cfinvokeargument name="MIGProSegid3" 				value="#rsSegmentos3.MIGProSegid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid3" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.Ucodigo) NEQ "">	
			<cfinvokeargument name="id_unidad_medida" 			value="#rsImportador.Ucodigo#"/>
		<cfelse>
			<cfinvokeargument name="id_unidad_medida" 				value="null"/>
		</cfif>
			<cfinvokeargument name="MIGProLinid" 				value="#rsLines1.MIGProLinid#"/>
		<cfif trim(rsImportador.MIGProLincodigo2) NEQ "">	
			<cfinvokeargument name="MIGProLinid2" 				value="#rsLines2.MIGProLinid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid2" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProLincodigo3) NEQ "">		
			<cfinvokeargument name="MIGProLinid3" 				value="#rsLines3.MIGProLinid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid3" 				value="null"/>
		</cfif>
		<cfif trim(rsImportador.MIGProLincodigo4) NEQ "">		
			<cfinvokeargument name="MIGProLinid4" 				value="#rsLines4.MIGProLinid#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid4" 				value="null"/>
		</cfif>
		<cfif ltrim(rsImportador.MIGProLincodigo5) NEQ "">	
			<cfinvokeargument name="MIGProlinea5"				value="#rsImportador.MIGProLincodigo5#"/>
		<cfelse>
			<cfinvokeargument name="MIGProlinea5"				value=" "/>
		</cfif>
		<cfif ltrim(rsImportador.MIGProplanta) NEQ "" >			
			<cfinvokeargument name="MIGProplanta"				value="#rsImportador.MIGProplanta#"/>
		<cfelse>
			<cfinvokeargument name="MIGProplanta"				value=""/>
		</cfif>
		<cfif trim(rsImportador.MIGProesproducto) NEQ "">
			<cfinvokeargument name="MIGProesproducto"			value="#LvarEsProdcto#"/>
		<cfelse>
			<cfinvokeargument name="MIGProesproducto"			value="P"/>
		</cfif>
		<cfif Ltrim(rsImportador.MIGProesproducto) NEQ "">
			<cfinvokeargument name="MIGProesnuevo"				value="#rsImportador.MIGProesnuevo#"/>
		<cfelse>
			<cfinvokeargument name="MIGProesnuevo"			value="1"/>
		</cfif>
		</cfinvoke>
		</cfif>
	</cfif>
</cfloop>		

<cfset session.Importador.SubTipo = 3>

