<!---
	Inclusión de los ajustes de inventario provenientes de sistemas externos.
	
	--------------------------------------
	----------- VALIDACIONES  ------------
	--------------------------------------
	1.Validar que la empresa existe
	2.Validar que el almacen existe
	3.Validar que documento y Descripcion no sean blancos
	4.Validar que documento no exista ya dentro de un ajuste
	5.Validar que la fecha sea valida
	6.Aplicar solo es "S" o "N"
	7.El articulo debe existir
	8.La cantidad debe ser mayor que cero
	9.El costo debe ser mayor que cero
	10.Tipo solo puede ser 0 = ENTRADA y 1 = SALIDA

	--------------------------------------
	---- DATOS DE ENTRADA (XML_IE ):    --
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<ID></ID>
			<Empresa></Empresa>
			<Cod_Almacen></Cod_Almacen>
			<Descripción></Descripción>
			<FechaAjuste></FechaAjuste>
			<Documento></Documento>
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
			<Costo></Costo>
			<TipoMovimiento></TipoMovimiento>
		</row>
	</resultset>
--->

<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Encabezado y Detalles de las tablas IE714 y ID714. --->
<cfquery name="rsInterfaz714" datasource="sifinterfaces">
    SELECT 
             e.ID
            ,e.EAaplicar
            ,e.Cod_Almacen		as Almcodigo		 
            ,e.Empresa			as Ecodigo
            ,e.Descripcion		as EAdescripcion
            ,e.FechaAjuste		as EAfecha
            ,e.Documento		as EAdocumento
            ,d.CodigoArticulo	as Acodigo
            ,d.Cantidad			as DAcantidad
            ,d.Costo			as DAcosto
            ,coalesce(d.CFformato,'0')        as CFformato
            ,case when d.TipoMovimiento	= 'E' then 0 
	              when d.TipoMovimiento	= 'S' then 1
                  else -1
             end as DAtipo
    FROM IE714 e
        INNER JOIN ID714 d
            ON d.ID = e.ID
    WHERE e.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
    
<!--- Valida que vengan datos en el qry--->
<cfif #rsInterfaz714.recordcount# eq 0>
	<cfthrow message="Error en Interfaz 714. No existen datos de Entrada o no tiene detalles definidos. Proceso Cancelado!.">
</cfif>

<!---Validacion de que la empresa exista--->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	SELECT count(1)
	FROM Empresas
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInterfaz714.Ecodigo#">
</cfquery>
<cfif rsEmpresa.recordcount eq 0>
	<cfthrow message="Error en Interfaz 714. La empresa no esta en la base de datos. Proceso Cancelado!." >
</cfif>

<!---Validacion de Almacenes--->
<cfquery name="rsAlmacen" datasource="#session.dsn#">
    SELECT Aid 
    FROM Almacen
    WHERE Almcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInterfaz714.Almcodigo#">
        AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInterfaz714.Ecodigo#">
</cfquery>
<cfif #rsAlmacen.recordcount# eq 0>
    <cfthrow message="Error en Interfaz 714. El almacen no esta en la base de datos. Proceso Cancelado!." >
</cfif>

<!---Validacion de la Cuenta Financiera--->
<cfif rsInterfaz714.CFformato neq '0'>
    <cfquery name="rsCFinanciera" datasource="#session.dsn#">
        SELECT CFformato, coalesce(Ccuenta,0) as Ccuenta
        FROM CFinanciera
        WHERE CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsInterfaz714.CFformato#">
            AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInterfaz714.Ecodigo#">
    </cfquery>
    <cfif rsCFinanciera.recordcount eq 0>
        <cfthrow message="Error en Interfaz 714. La Cuenta Financiera no esta en la base de datos. Proceso Cancelado!." >
    </cfif>
    <cfif rsCFinanciera.Ccuenta eq 0>
    	<cfthrow message="Error en Interfaz 714. La Cuenta Financiera no posee Ccuentas. Proceso Cancelado!." >
    </cfif>
</cfif>

<!---El articulo debe existir--->
<cfquery name="rsArticulo" datasource="#session.dsn#">
    SELECT Aid 
    FROM Articulos
    WHERE Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsInterfaz714.Acodigo#">
        AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInterfaz714.Ecodigo#">
</cfquery>
<cfif #rsArticulo.recordcount# eq 0>
    <cfthrow message="Error en Interfaz 714. El articulo no existe en la base de datos. Proceso Cancelado!." >
</cfif>

 
<!---Llamado a las a la validacion del resto de los datos--->
<cfset LvarResultadoValidar = "">  
<cfset Procesar = false>  
<cfset LvarResultadoValidar = validaDatos(rsInterfaz714)>
<cfif #LvarResultadoValidar# eq "OK">
    <!---Metodo para insertar en EAjustes y DAjustes--->
	<cfset Procesar = ProcesarConsulta(rsInterfaz714)>
	<cfif Procesar eq false>
        <cfthrow message="#Procesar#">
    </cfif>
</cfif>    
   
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!---
	Metodo: validaDatos
	Proceso: Validacion de las siguiente lista de datos
		1.Validar que la empresa existe
		2.Validar que el almacen existe
		3.Validar que documento y Descripcion no sean blancos
		4.Validar que documento no exista ya dentro de un ajuste
		5.Validar que la fecha sea valida
		6.Aplicar solo es "S" o "N"
		7.El articulo debe existir
		8.La cantidad debe ser mayor que cero
		9.El costo debe ser mayor que cero
		10.Tipo solo puede ser 0 = ENTRADA y 1 = SALIDA
--->
    
<cffunction access="private" name="validaDatos" hint="Funcion que valida los datos" returntype="string">
	<cfargument name="query" required="yes" type="query">

<cfset result = "">

   <!---3.Validacion de que el documento y la descripcion no esten en Blanco--->
      <cfif #query.EAdocumento# eq " ">
    	<cfthrow message="Error en Interfaz 714. El documento esta en blanco. Proceso Cancelado!." >
    </cfif>
    
   <cfif #query.EAdescripcion# eq " ">
   		<cfthrow message="Error en Interfaz 714. La descripcion esta en blanco. Proceso Cancelado!." >
	</cfif>
    
   <!---4.Validar que documento no exista ya dentro de un ajuste--->
   <cfquery name="rsDocumento" datasource="#session.dsn#">
   		SELECT count(1) as Total
        FROM EAjustes
        WHERE EAdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#query.EAdocumento#">
        	AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#query.Ecodigo#">
   </cfquery>
   <cfif #rsDocumento.Total# gt 0>
   		<cfthrow message="Error en Interfaz 714. El documento ya se encuentra en ajuste. Proceso Cancelado!." >
   <cfelse>	
   		<cfset result		= "OK">
   </cfif>
   
   <!---5.Validador de la fecha ingresada--->
    <cfset LvarFecha = #query.EAfecha#>
		<!---Validador de la fecha--->
        <cftry>
            <!--- 1234-67-90 --->
            <cfset DtCorrecta = CreateDate( mid(LvarFecha,1,4), mid(LvarFecha,6,2), mid(LvarFecha,9,2) )>
        <cfcatch type="any">
            <cfthrow message="Error en formato de fecha. Formato esperado: YYYY-MM-DD">
        </cfcatch>
        </cftry>
        
   <!---6.Aplicar solo es "S" o "N"--->
   <cfif query.EAaplicar eq "S" or query.EAaplicar eq "N">
   		<cfset result	= "OK">
   <cfelse>	 
       <cfthrow message="Error en Interfaz 714. La especificacion para aplicar el ajuste debe ser S o N no <cfoutput>#query.EAaplicar #</cfoutput>!. Proceso Cancelado!." >
   </cfif>
   
   <!---8.9.10 Validaciones de los Cantidad, Costo y Tipo--->
   <cfset result	= validaCantidadCostoTipo(query)>
   <cfreturn "#result#">
</cffunction>

	<!---
		Metodo: validaCantidadCostoTipo
		Proceso: Validacion de los datos Cantidad, Costo y Tipo sean los requeridos
	--->
<cffunction access="private" name="validaCantidadCostoTipo" hint="Funcion que valida los datos" returntype="string">
	<cfargument name="query" required="yes" type="query">
	<cfset result = ""> 
	<cfloop query="rsInterfaz714">
	   <!---La cantidad GT cero--->
	   <cfif rsInterfaz714.DAcantidad lte 0>
            <cfthrow message="Error en Interfaz 714. La cantidad debe ser superior a cero. Proceso Cancelado!." >
       <cfelse>
       		<!---La Costo GT cero--->
            <cfif rsInterfaz714.DAcosto lte 0>
            	<cfthrow message="Error en Interfaz 714. El costo debe ser superior a cero. Proceso Cancelado!." >
            <cfelse>
            	<!---tipos solo 0 o 1--->
            	<cfif rsInterfaz714.DAtipo eq -1>
                    <cfthrow message="Error en Interfaz 714. El tipo solo puede ser E = ENTRADA y S = SALIDA. Proceso Cancelado!." >
                </cfif>	
            </cfif>
       </cfif>
	</cfloop>
    <cfset result = "OK">
    <cfreturn "#result#">
</cffunction>

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

    <!---
		Metodo: ProcesarConsulta
		Proceso: metodo que realiza las inserciones las tablas EAjuste y DAjuste 
		Valida si requiere aplicar el ajuste o no
	--->
<cffunction access="private"
			name="ProcesarConsulta"
            hint="Realiza la inserción en las tablas EAjuste"
            returntype="boolean">
            <cfargument name="query" required="yes" type="query">
            <cfargument default="false" hint="Debug" name="Debug" required="false" type="boolean">
			<cfargument default="false" hint="RollBack" name="RollBack" required="false" type="boolean">
	
	<!---Creacion de una transaccion para realizar la insercion de las tablas--->
    <cftransaction>
	<!---Insercion del detalle del ajuste--->
    <cfquery name="insertEA" datasource="#session.dsn#">
		INSERT INTO EAjustes ( EAdescripcion, Aid, EAdocumento, EAfecha, EAusuario)
		VALUES ( 
			<cfqueryparam value="#query.EAdescripcion#" 		 		cfsqltype="cf_sql_vachar">,
			<cfqueryparam value="#rsAlmacen.Aid#" 			 			cfsqltype="cf_sql_numeric">,
			<cfqueryparam value="#query.EAdocumento#"   			 	cfsqltype="cf_sql_char">, 
			<cfqueryparam value="#LSParsedateTime(query.EAfecha)#" 		cfsqltype="cf_sql_timestamp">,
			<cfqueryparam value="#session.usuario#"    					cfsqltype="cf_sql_varchar">
		)
		<cf_dbidentity1 datasource="#session.dsn#">
	</cfquery>
	<cf_dbidentity2 name="insertEA" datasource="#session.dsn#" returnvariable="LvarEAid">
	<!---Insercion del detalle del ajuste--->
    <cfquery name="inserDA" datasource="#session.dsn#">
		INSERT INTO DAjustes ( EAid, Aid, DAcantidad, DAcosto, DAtipo,CFformato )
		VALUES ( 
			<cfqueryparam value="#LvarEAid#" 		cfsqltype="cf_sql_numeric">,
			<cfqueryparam value="#rsArticulo.Aid#" 	cfsqltype="cf_sql_numeric">,
			<cfqueryparam value="#Replace(query.DAcantidad,',','','all')#" cfsqltype="cf_sql_float">,
			<cfqueryparam value="#Replace(query.DAcosto,',','','all')#" cfsqltype="cf_sql_float">,
			<cfqueryparam value="#query.DAtipo#" 	cfsqltype="cf_sql_numeric">,
            <cfqueryparam value="#rsInterfaz714.CFformato#" cfsqltype="cf_sql_char" null="#rsInterfaz714.CFformato eq '0'#">
		)
	</cfquery>
    </cftransaction>
    <!---Si se especifica que requiere aplicar el ajuste se invoca el componente de ajuste--->
    <cfset Resultado = true>
	<cfif #query.EAaplicar# eq "S">
        <cfinvoke Component="sif.Componentes.IN_AjusteInventario"
                    method="IN_AjusteInventario"
                    EAid="#LvarEAid#"
                    Ecodigo="#query.Ecodigo#"
                    Debug = "#Arguments.Debug#"
                    RollBack = "#Arguments.RollBack#" returnvariable="Resultado"/>
    </cfif>
    <cfreturn "#Resultado#">
</cffunction>            

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

