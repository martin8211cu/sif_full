<!---
	-Realizar el pase de la información necesaria para los movimientos interalmacen.
	-Lógica de selección de información:
		Incluye los datos enviados en el almacén destino realizando las validaciones necesarias.

	
	--------------------------------------
	----------- VALIDACIONES  ------------
	--------------------------------------
	1.Validar que la empresa existe
	2.Validar que el almacen existe
	3.Validar que la fecha sea valida
	4.Validar que el almacenOri y AlmacenDestino no esten en blanco
	4.Validar que el almacenOri y AlmacenDestino sean validos y no sean el mismo
	6.Validar q el documento no este en Blanco
	7.Validar que el articulo sea valido
	8.Que la cantidad sea superior a cero
	
	--------------------------------------
	---- DATOS DE ENTRADA (XML_IE ):    --
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<ID></ID>
			<Empresa></Empresa>
			<CodAlmOrigen></CodAlmOrigen>
			<CodAlmDestino></CodAlmDestino>
			<DocumIntAlm></DocumIntAlm> EMdoc 
			<FechaMovim></FechaMovim>
			<EMaplicar></EMaplicar>
		</row>
	</resultset>
	
	--------------------------------------
	---- DATOS DE ENTRADA (XML_ID ):    --
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<CodigoArticulo></CodigoArticulo>
			<Cantidad></Cantidad>
		</row>
	</resultset>
--->

<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Encabezado y Detalles de las tablas IE716 y ID716 --->
<cfquery name="rsInterfaz716" datasource="sifinterfaces">
    SELECT 
             e.ID
            ,e.Empresa 			as Ecodigo
            ,e.CodAlmOrigen		as Almcodigo_Ori
            ,e.CodAlmDestino	as Almcodigo_Des
            ,e.DocumIntAlm		as EMdoc
            ,e.FechaMovim		as EMfecha
            ,e.EMaplicar
            ,d.CodigoArticulo	as Acodigo
            ,d.Cantidad			as DMcant
    FROM IE716 e
  	  INNER JOIN ID716 d
      	ON d.ID = e.ID
    WHERE e.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">  
</cfquery>

<!--- Valida que vengan datos en el qry--->
<cfif rsInterfaz716.recordcount eq 0>
	<cfthrow message="Error en Interfaz 716. No existen datos de Entrada o no tiene detalles definidos. Proceso Cancelado!.">
</cfif>


<!---Variables Globales--->
<cfset LvarAlmOri ="">				<!---	Almacen Origen	--->
<cfset LvarAlmDes ="">				<!---	Almacen Destino	--->
<cfset conexion = #session.dsn#>	<!---	Conexion		--->
<cfset aplicar	= "">				<!---	Aplicar			--->	
<cfset LvarEmpresa ="">				<!---	Empresa			--->
<cfset LvarArticulo ="">			<!---	Articulo		--->
<cfset LvarDocumento ="">			<!---	Documento		--->
<cfset LvarFecha ="">				<!---	Fecha			--->
<cfset LvarCantidad ="">			<!---	Cantidad		--->

<!---1.Validacion de que la empresa exista--->

<cfset LvarEmpresa = ValidaCamposBlanco(#rsInterfaz716.Ecodigo#,"Empresa")>				
<cfif #LvarEmpresa# eq "OK"> 
    <cfquery name="rsEmpresa" datasource="#conexion#">
        SELECT count(1)
        FROM Empresas
        WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInterfaz716.Ecodigo#">
    </cfquery>
</cfif>

<!---2.Validacion del articulo--->

<cfset LvarArticulo = ValidaCamposBlanco(#rsInterfaz716.Acodigo#,"Articulo")>				
<cfset LvarAid = "">
<cfif #LvarArticulo# eq "OK"> 
    <cfquery name="rsArticulo" datasource="#conexion#">
        SELECT Aid 
        FROM Articulos
        WHERE Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsInterfaz716.Acodigo#">
            AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInterfaz716.Ecodigo#">
    </cfquery>
        
	<cfif #rsArticulo.recordcount# eq 0>
    	<cfthrow message="Error en Interfaz 714. El articulo no existe en la base de datos. Proceso Cancelado!." > 
    <cfelse>
		<cfset LvarAid = #rsArticulo.Aid#>
    </cfif>
</cfif>

<!---3.Validacion de los almacenes--->
<cfset LvarAlmOri = ValidarAlmacen(#rsInterfaz716.Almcodigo_Ori#, rsInterfaz716.Ecodigo,"Origen")>
<cfset LvarAlmDes = ValidarAlmacen(#rsInterfaz716.Almcodigo_Des#, rsInterfaz716.Ecodigo,"Destino")>

<!---4.Comparacion de los almacenes--->
<cfif #LvarAlmOri# eq #LvarAlmDes#>
	<cfthrow message="Error en Interfaz 716. El almacen origen y el almacen destino no pueden ser el mismo. Proceso Cancelado!.">
</cfif>

<!---5.EMaplicar solo es "S" o "N"--->
<cfset aplicarME = ValidaCamposBlanco(#rsInterfaz716.EMaplicar#,"Aplicar")>				
<cfif #aplicarME# eq "OK"> 
	<cfif #rsInterfaz716.EMaplicar# eq "S" or  #rsInterfaz716.EMaplicar#  eq "N">
        <cfset aplicar	= #rsInterfaz716.EMaplicar#>
    <cfelse>	 
       <cfthrow message="Error en Interfaz 716. La especificacion para aplicar el movimiento interalmacen debe ser S o N no <cfoutput>#rsInterfaz716.EMaplicar#</cfoutput>!. Proceso Cancelado!." >
    </cfif>
</cfif>

<!---6.Validar q el documento no este en Blanco--->
<cfset LvarDocumento = ValidaCamposBlanco(#rsInterfaz716.EMdoc#,"Documento")>				

<!---7.Que la cantidad sea superior a cero--->
<cfset LvarCantidad = ValidaCamposBlanco(#rsInterfaz716.EMdoc#,"Cantidad")>				
<cfif #LvarCantidad# eq "OK"> 
	<cfif #rsInterfaz716.DMcant# lte 0> 
       <cfthrow message="Error en Interfaz 716. La cantidad debe ser superior a cero!. Proceso Cancelado!." >
    </cfif>
</cfif>

<!---
	LLamado al metodo de insercion en las tablas (EMinteralmacen y DMinteralmacen)
	y aplicacion del movimiento iteralmacen en caso de que asi se especifique
--->
<cfset Procesar = false>  
<cfset Procesar = ProcesarConsulta(rsInterfaz716) >
<cfif  Procesar eq false>
	<cfthrow message="#ProcesarConsulta#">
</cfif>

<!---**********************************--->
<!---Funcion para validar los almacenes--->
<!---**********************************--->
<cffunction access="private" 
			name="ValidarAlmacen" 
            hint="Valida que los almacenes ingresados no esten en blanco y sean validos" 
            returntype="string">
	<cfargument name="AlmCodigo" type="string" hint="Codigo del Almacen">
	<cfargument name="Ecodigo"	 type="string" hint="Codigo del la empresa">
    <cfargument name="Tipo"	 	 type="string" hint="Tipo">

	<cfset LvarAidAlm = "">   
	<cfset LvarAlmacen = "">
	<cfset LvarAlmacen = ValidaCamposBlanco(#Arguments.AlmCodigo#, "Almacen "&#Arguments.Tipo#)>		
	<cfif #LvarAlmacen# eq "OK">
    	<cfquery name="rsAlmacen" datasource="#conexion#">
            SELECT Aid 
            FROM Almacen
            WHERE Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AlmCodigo#">
                AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfif #rsAlmacen.recordcount# eq 0>
            <cfthrow message="Error en Interfaz 716. El almacen <cfoutput>#Arguments.Tipo#</cfoutput> no esta en la base de datos. Proceso Cancelado!." >
        <cfelse>
             <cfset LvarAidAlm = #rsAlmacen.Aid#>   
        </cfif>
    </cfif>
    <cfreturn "#LvarAidAlm#">        
</cffunction>


<!---*************************************--->
<!---Funcion para validar campos en blanco--->
<!---*************************************--->
<cffunction access="private" 
			name="ValidaCamposBlanco" 
            hint="Valida que los datos enviados no esten en blanco" 
            returntype="string">
	<cfargument name="Campo" 		 type="string" hint="Campo a Validar">
    <cfargument name="NombreCampo"	 type="string" hint="Nombre del Campo a Validar">

    <cfset LvarResultado ="">
	<cfif #Arguments.Campo# eq "">
    	<cfthrow message="Error en Interfaz 716. El campo <cfoutput>#Arguments.NombreCampo#</cfoutput> esta en blanco. Proceso Cancelado!." >
    <cfelse>
    	<cfset LvarResultado ="OK">
    </cfif>
    <cfreturn "#LvarResultado#">     
</cffunction>
     
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>


<!---*********************************--->
<!---Funcion para procesar la consulta--->
<!---*********************************--->
<!---
	Realiza la inserción en las tablas EMinteralmacen y DMinteralmacen, 
	valida la existencia del movimiento y aplica el movimiento"
--->
<cffunction access="private"
			name="ProcesarConsulta"
            hint="Realiza la inserción en las tablas EMinteralmacen y DMinteralmacen, valida la existencia del movimiento y aplica el movimiento"
            returntype="boolean">
            <cfargument name="query" required="yes" type="query">
            <cfargument default="false" hint="Debug" name="Debug" required="false" type="boolean">
			<cfargument default="false" hint="RollBack" name="RollBack" required="false" type="boolean">
	
	<!---Creacion de una transaccion para realizar la insercion de las tablas--->
    <cftransaction>
		<cfquery name="InsEMinteralmacen" datasource="#session.DSN#">
					INSERT INTO EMinteralmacen (Ecodigo, EMalm_Orig, EMalm_Dest, EMdoc, EMusu, EMresp, EMfecha)
					VALUES (
						<cfqueryparam value="#query.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmOri#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmDes#">, 
						<cfqueryparam value="#query.EMdoc#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						<cfqueryparam value="#query.EMfecha#" cfsqltype="cf_sql_timestamp">				
					)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
                <cf_dbidentity2 name="InsEMinteralmacen" datasource="#session.dsn#" returnvariable="LvarEMid">
			<cfquery name="InsDMinteralmacen" datasource="#session.DSN#">
					INSERT INTO DMinteralmacen (EMid, DMAid, DMcant)
					VALUES (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEMid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">, 
						<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(query.DMcant,',','', 'all')#">
					)
				</cfquery>
    </cftransaction>

    <!---Verificacion de la insercion correcta del movimiento--->
    <cfquery name="ExisteMovimiento" datasource="#conexion#">
		select 1 from DMinteralmacen 
		where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEMid#">	
	</cfquery>	
	
	<cfif isdefined("ExisteMovimiento") and not  ExisteMovimiento.RecordCount GE 1>
		<cfthrow message="Error en Interfaz 716. No hay lineas de documento para procesar. El proceso ha sido cancelado!">
	</cfif>
    
    <!---Si se especifica que requiere aplicar el movimiento se invoca el componente de ajuste--->
	<cfset Resultado = false>
	<cfif #query.EMaplicar# eq "S">
          	<cfinvoke component="sif.Componentes.IN_MovInterAlmacen" method="MovInterAlmacen">
                <cfinvokeargument name="Ecodigo" 	value="#query.Ecodigo#"/>
                <cfinvokeargument name="EMid" 		value="#LvarEMid#"/>				
                <cfinvokeargument name="usuario"	value="#Session.usuario#"/>	
                <cfinvokeargument name="debug" 		value="N"/>	
             </cfinvoke>	
    <cfset Resultado = true>
    <cfelse>
    	<cfset Resultado = true>
    </cfif>
    <cfreturn "#Resultado#">
</cffunction>            

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>


