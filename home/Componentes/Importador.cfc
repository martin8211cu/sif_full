<cfcomponent hint="Componente para el manejo de los Importadores" >
	<cfinvoke component="sif.Componentes.Translate"
	    method="Translate"
	    Key="LB_Numero"
	    Default="Numero"
	    returnvariable="LB_Numero"/>     
	<cfinvoke component="sif.Componentes.Translate"
	    method="Translate"
	    Key="LB_Nombre"
	    Default="Nombre"
	    returnvariable="LB_Nombre"/>
	<cfinvoke component="sif.Componentes.Translate"
	    method="Translate"
	    Key="LB_Descripcion"
	    Default="Descripci&oacute;n"
	    returnvariable="LB_Descripcion"/>
	<cfinvoke component="sif.Componentes.Translate"
	    method="Translate"
	    Key="LB_Tipo"
	    Default="Tipo"
	    returnvariable="LB_Tipo"/>
	<cfinvoke component="sif.Componentes.Translate"
	    method="Translate"
	    Key="LB_Longitud"
	    Default="Longitud"
	    returnvariable="LB_Longitud"/>

	<cffunction name="eliminarDetalleHoja" returnFormat="json" output="false" access="remote" hint="Funcion que elimina un detalle de una hoja determinada">
		<cfargument name="EIid" type="numeric" required="yes" hint="Id interno de la tabla EImportador">
		<cfargument name="PIid" type="numeric" required="yes" hint="Id interno de la tabla PImportadores">
		<cfargument name="DInumero" type="numeric" required="yes" hint="Numero de la tabla DImportador">
		<cfargument name="DItiporeg" type="string" required="yes" hint="Tipo de registro de la tabla DImportador">

		<cfquery name="rsGetColumnasMayores" datasource="sifcontrol">
			select distinct a.PIid, a.DInumero, a.DItiporeg, a.EIid, a.DInumero-1 as DInumeroNuevo
			from DImportador a, DImportador b
			where 	a.PIid 		= <cfqueryparam value="#Arguments.PIid#" cfsqltype="cf_sql_numeric">
				and a.EIid 		= <cfqueryparam value="#Arguments.EIid#" cfsqltype="cf_sql_numeric">
				and a.DItiporeg = <cfqueryparam value="#Arguments.DItiporeg#" cfsqltype="cf_sql_varchar">
				and b.DInumero 	= <cfqueryparam value="#Arguments.DInumero#" cfsqltype="cf_sql_numeric">
				and a.DInumero 	> b.DInumero 
		</cfquery>

		<cfquery datasource="sifcontrol">
			delete 
			from DImportador
			where 	PIid 		= <cfqueryparam value="#Arguments.PIid#" cfsqltype="cf_sql_numeric">
				and EIid 		= <cfqueryparam value="#Arguments.EIid#" cfsqltype="cf_sql_numeric">
				and DInumero 	= <cfqueryparam value="#Arguments.DInumero#" cfsqltype="cf_sql_numeric">
				and DItiporeg 	= <cfqueryparam value="#Arguments.DItiporeg#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfloop query="rsGetColumnasMayores">
			<cfquery datasource="sifcontrol">
				update DImportador
				set DInumero 		= <cfqueryparam value="#rsGetColumnasMayores.DInumeroNuevo#" cfsqltype="cf_sql_numeric">
				where 	PIid 		= <cfqueryparam value="#rsGetColumnasMayores.PIid#" cfsqltype="cf_sql_numeric">
					and EIid 		= <cfqueryparam value="#rsGetColumnasMayores.EIid#" cfsqltype="cf_sql_numeric">
					and DInumero 	= <cfqueryparam value="#rsGetColumnasMayores.DInumero#" cfsqltype="cf_sql_numeric">
					and DItiporeg 	= <cfqueryparam value="#rsGetColumnasMayores.DItiporeg#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfloop>

		<cfreturn 200>
	</cffunction>

	<cffunction name="getDetalleHoja" returntype="Struct" returnformat="JSON" output="false" access="remote" hint="Funcion que retorna los datos de un detalle especifico">
		<cfargument name="EIid" type="numeric" required="yes" hint="Id interno de la tabla EImportador">
		<cfargument name="PIid" type="numeric" required="yes" hint="Id interno de la tabla PImportadores">
		<cfargument name="DInumero" type="numeric" required="yes" hint="Numero de Columna">
		<cfargument name="DItiporeg" type="string" required="yes" hint="Tipo de registro">

		<cfquery name="rsGetDetalleHoja" datasource="sifcontrol">
			select *
				from DImportador
				where 	PIid = <cfqueryparam value="#Arguments.PIid#" cfsqltype="cf_sql_numeric">
					and EIid = <cfqueryparam value="#Arguments.EIid#" cfsqltype="cf_sql_numeric">
					and DInumero = <cfqueryparam value="#Arguments.DInumero#" cfsqltype="cf_sql_numeric">
					and DItiporeg = <cfqueryparam value="#Arguments.DItiporeg#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset _resultado = structNew()>
		<cfset _resultado.Lista = arrayNew(1)>
		
		<cfloop query="rsGetDetalleHoja">
			<cfset ele 					    = structNew()>
			<cfset ele.EIID 				= rsGetDetalleHoja.EIid>
			<cfset ele.PIID 			    = rsGetDetalleHoja.PIid>
			<cfset ele.DINUMERO 		    = rsGetDetalleHoja.DInumero>
			<cfset ele.DITIPOREG 	    	= rsGetDetalleHoja.DItiporeg>
			<cfset ele.DINOMBRE 			= rsGetDetalleHoja.DInombre>
			<cfset ele.DIDESCRIPCION    	= rsGetDetalleHoja.DIdescripcion>
			<cfset ele.DITIPO 				= rsGetDetalleHoja.DItipo>
			<cfset ele.DILONGITUD 			= rsGetDetalleHoja.DIlongitud>
			<cfset arrayAppend(_resultado.Lista,ele)>
		</cfloop>
		<cfreturn _resultado>
	</cffunction>

	<cffunction name="modificarDetalleHoja" returnFormat="json" output="false" access="remote" hint="Funcion que actualiza los datos de un detalle, agregando los cambios realizados">
		<cfargument name="EIid" type="numeric" required="yes" hint="Id interno de la tabla EImportador">
		<cfargument name="PIid" type="numeric" required="yes" hint="Id interno de la tabla PImportadores">
		<cfargument name="DInumero" type="numeric" required="yes" hint="Numero de Columna">
		<cfargument name="DItiporeg" type="string" required="yes" hint="Tipo de registro">
		<cfargument name="DInombre" type="numeric" required="yes" hint="Id interno de la tabla EImportador">
		<cfargument name="DIdescripcion" type="numeric" required="yes" hint="Id interno de la tabla PImportadores">
		<cfargument name="DItipo" type="numeric" required="yes" hint="Numero de Columna">
		<cfargument name="DIlongitud" type="string" required="yes" hint="Tipo de registro">

		<cfquery datasource="sifcontrol">					
			update DImportador
				set DInombre      = <cfqueryparam value="#Arguments.DInombre#" cfsqltype="cf_sql_varchar">,
					DIdescripcion = <cfqueryparam value="#Arguments.DIdescripcion#" cfsqltype="cf_sql_varchar">,
					DItipo        = <cfqueryparam value="#Arguments.DItipo#" cfsqltype="cf_sql_varchar">, 
					DIlongitud    =	<cfqueryparam value="#Arguments.DIlongitud#" cfsqltype="cf_sql_integer">
				where 	PIid 		= <cfqueryparam value="#Arguments.PIid#" cfsqltype="cf_sql_numeric">
					and EIid 		= <cfqueryparam value="#Arguments.EIid#" cfsqltype="cf_sql_numeric">
					and DInumero	= <cfqueryparam value="#Arguments.DInumero#" cfsqltype="cf_sql_numeric">
					and DItiporeg 	= <cfqueryparam value="#Arguments.DItiporeg#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn 200>
	</cffunction>

	<cffunction name="guardarDatosHoja" returnFormat="json" output="false" access="remote" hint="Funcion que establece la cantidad de lineas de encabezado de una hoja determinada, asi como el nombre">
		<cfargument name="PIid" type="numeric" required="yes" hint="Id interno de la tabla PImportadores">
		<cfargument name="LineasEncabezado" type="numeric" required="yes" hint="Lineas de encabezado de la hoja">
		<cfargument name="PIdescripcion" type="numeric" required="yes" hint="Descripcion de la hoja">

		<cfquery datasource="sifcontrol">
			update PImportadores
				set PIEncabezado 	= <cfqueryparam value="#Arguments.LineasEncabezado#" cfsqltype="cf_sql_numeric">		
				set PIdescripcion 	= <cfqueryparam value="#Arguments.PIdescripcion#" cfsqltype="cf_sql_varchar">		
				where PIid 			= <cfqueryparam value="#Arguments.PIid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfreturn 200>
	</cffunction>

	<cffunction name="guardarLineasEncabezado" returnFormat="json" output="false" access="remote" hint="Funcion que establece la cantidad de lineas de encabezado de una hoja determinada">
		<cfargument name="PIid" type="numeric" required="yes" hint="Id interno de la tabla PImportadores">
		<cfargument name="LineasEncabezado" type="numeric" required="yes" hint="Lineas de encabezado de la hoja">
		<cfquery datasource="sifcontrol">
			update PImportadores
				set PIEncabezado 	= <cfqueryparam value="#Arguments.LineasEncabezado#" cfsqltype="cf_sql_numeric">		
				where PIid 			= <cfqueryparam value="#Arguments.PIid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfreturn 200>
	</cffunction>

	<cffunction name="guardarNombreHoja" returnFormat="json" output="false" access="remote" hint="Funcion que establece la descripcion de la hoja">
		<cfargument name="PIid" type="numeric" required="yes" hint="Id interno de la tabla PImportadores">
		<cfargument name="PIdescripcion" type="numeric" required="yes" hint="Descripcion de la hoja">
		<cfquery datasource="sifcontrol">
			update PImportadores
				set PIdescripcion 	= <cfqueryparam value="#Arguments.PIdescripcion#" cfsqltype="cf_sql_varchar">		
				where PIid 			= <cfqueryparam value="#Arguments.PIid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfreturn 200>
	</cffunction>

	<cffunction name="cargarDetallesHoja" output="true" access="remote" hint="Funcion que carga los detalles de una hoja determinada en un pListas">
		<cfargument name="PIid" type="numeric" required="yes" hint="Id interno de la tabla Canones">
		<cf_dbfunction name="OP_concat" returnvariable="_Cat" datasource="sifcontrol" >
		<cfsavecontent variable="columnasQuery" >	
			EIid, DInumero, PIid, DInombre, DIdescripcion,DItipo, DIlongitud,DItiporeg, CASE DItiporeg WHEN '-' THEN 'Tipo de registro DEFAULT' ELSE 'Tipo de registro ' 
			#_Cat#DItiporeg END as DItiporeg1,
			'<a href=''javascript:borrarDetalleHoja(' 
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="DInumero">
			#_Cat#
			','
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="EIid">
			#_Cat#
			','
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="PIid">
			#_Cat#
			',"'
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="DItiporeg">
			#_Cat#
			'")''><img src=''../imagenes/Borrar01_S.gif'' border=''0''></a>'
			as EIborrar, 
			'<a href=''javascript:editarDetalleHoja(' 
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="DInumero">
			#_Cat#
			','
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="EIid">
			#_Cat#
			','
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="PIid">
			#_Cat#
			',"'
			#_Cat#
			<cf_dbfunction name="to_char" datasource="sifcontrol" args="DItiporeg">
			#_Cat#
			'")''><img src=''../imagenes/edit_o.gif'' border=''0''></a>'
			as EIeditar
		</cfsavecontent>

		<cfinvoke component="sif.Componentes.pListas" 	method="pListaRH" >
			<cfinvokeargument name="tabla" 				value="DImportador"/>
			<cfinvokeargument name="columnas" 			value="#columnasQuery#"/>
			<cfinvokeargument name="desplegar" 			value="DInumero, DInombre, DIdescripcion, DItipo, DIlongitud, EIborrar, EIeditar"/>
			<cfinvokeargument name="etiquetas" 			value="#LB_Numero#,#LB_Nombre#,#LB_Descripcion#,#LB_Tipo#, #LB_Longitud#,&nbsp;,&nbsp;"/>
			<cfinvokeargument name="formatos" 			value="V,V,V,V,I,V,V"/>
			<cfinvokeargument name="filtro" 			value="PIid = #Arguments.PIid# order by DItiporeg, DInumero"/>
			<cfinvokeargument name="align" 				value="left,left,left,left,left,center,center"/>
			<cfinvokeargument name="ajustar" 			value="N"/>
			<cfinvokeargument name="checkboxes" 		value="N"/>
			<cfinvokeargument name="keys"		 		value="EIid,DItiporeg,DInumero"/>
			<cfinvokeargument name="mostrar_filtro" 	value="false"/>
			<cfinvokeargument name="filtrar_automatico" value="true"/>
			<cfinvokeargument name="usaAjax"	 		value="true"/>
			<cfinvokeargument name="Conexion"	 		value="sifcontrol"/>
			<cfinvokeargument name="irA" 				value="SQLImportador.cfm"/>
			<cfinvokeargument name="PageIndex" 		    value="#Arguments.PIid#"/>
			<cfinvokeargument name="formName" 		    value="formDetalles"/>
			<cfinvokeargument name="incluyeForm" 		value="false"/>
			<cfinvokeargument name="MaxRows" 			value="30"/>
			<cfinvokeargument name="MaxRowsQuery" 		value="200"/>
			<cfinvokeargument name="cortes" 			value="DItiporeg1"/>
			<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
			<cfinvokeargument name="Nuevo" 				value="Importador.cfm"/>
		</cfinvoke>
	</cffunction>
</cfcomponent>