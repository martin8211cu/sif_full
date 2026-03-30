<!--- 
	Archivo       : CCostosFact.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos para manejo de costos en un arreglo de los documentos
	                Factura.
--->
<cfcomponent>
	<!--- Inicializa el arreglo, esto solo ocurre cuando es creado el componente  --->
	<cfset This.ArregloCostos = ArrayNew(1)>

	<!--- //// Método de inclusión del costo --->
	<cffunction name="IncluirCosto">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="Producto" required="Yes" type="string">
		<cfargument name="Monto" required="Yes" type="numeric">
		<cfargument name="TipoCosto" required="Yes" type="string">
		<cfargument name="TipoFactura" required="Yes" type="string">

		<!--- Obtener la estructura que representa este costo en el arreglo, y sumar el monto  --->
		<cfset CostoStruct = ObtenerCosto(Arguments.Documento,Arguments.Producto)>
		<cfif Arguments.TipoCosto EQ "P">
			<cfif Arguments.TipoFactura EQ "V">
				<cfset CostoStruct.Monto = CostoStruct.Monto - Arguments.Monto>
			<cfelse>
				<cfset CostoStruct.Monto = CostoStruct.Monto + Arguments.Monto>
			</cfif>
		<cfelse>
			<cfif Arguments.TipoFactura EQ "V">
				<cfset CostoStruct.Monto = CostoStruct.Monto + Arguments.Monto>
			<cfelse>
				<cfset CostoStruct.Monto = CostoStruct.Monto - Arguments.Monto>
			</cfif>
		</cfif>		

	</cffunction>   <!--- **** Fin de la Función **** --->

	<!--- //// Método para limpiar el arreglo  --->
	<cffunction name="LimpiarArreglo">
		<!--- Método para limpiar el arreglo  --->
		<cfset ArrayClear(This.ArregloCostos)>
	</cffunction>

	<!--- Método para sumar los montos de los costos  --->
	<cffunction name="SumarCostos" returntype="numeric">
		<!--- Crea un campo para retornar la suma de los costos  --->
		<cfset var Suma = 0>
		
		<!--- Para cada item en el arreglo sumar el monto  --->
		<cfloop from="1" to="#ArrayLen(This.ArregloCostos)#" index="i">
			<cfset Suma = Suma + This.ArregloCostos[i].Monto>
		</cfloop>		
		
		<cfreturn Suma>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Método para obtener la posición del item dentro del arreglo  --->
	<cffunction name="ObtenerPosicion" access="private" returntype="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="Producto" required="Yes" type="string">

		<cfset var PosicionArreglo = 0>

		<!--- Si existe, obtiene la posición del item  --->
		<cfloop from="1" to="#ArrayLen(This.ArregloCostos)#" index="i">
			<cfif This.ArregloCostos[i].Documento EQ Arguments.Documento and
				  This.ArregloCostos[i].Producto EQ Arguments.Producto> 	
				  <cfset PosicionArreglo = i>
				  <cfbreak>
			</cfif>
		</cfloop> 

		<cfreturn PosicionArreglo>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Método obtener el costo  --->
	<cffunction name="ObtenerCosto" returntype="struct">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="Producto" required="Yes" type="string">

		<cfset var PosArr = 0>
		
		<!--- Obtiene la posición del costo en el arreglo  --->
		<cfset PosArr = ObtenerPosicion(Arguments.Documento,Arguments.Producto)>

		<!--- Si el costo es encontrado, lo retornamos  --->
		<cfif PosArr GT 0>
			<cfset CostoStruct = This.ArregloCostos[PosArr]>
		<cfelse>
			<cfset CostoStruct = StructNew()>
			<cfset CostoStruct.Documento = Arguments.Documento>
			<cfset CostoStruct.Producto = Arguments.Producto>
			<cfset CostoStruct.Monto = 0>
			<cfset ArrayAppend(This.ArregloCostos,CostoStruct)>
		</cfif>

        <cfreturn CostoStruct>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Método para consultar los costos mediante un "query"  --->
	<cffunction name="ListaCostos" returntype="query">
		<cfset var qCostos = "">
		
		<!--- Crea un query para retornar los datos  --->
		<cfset qCostos = QueryNew("Documento, Producto, Monto")>

		<!--- Si existe, obtiene la posición del item  --->
		<cfloop from="1" to="#ArrayLen(This.ArregloCostos)#" index="i">
			<cfset QueryAddRow(qCostos)>
			<cfset QuerySetCell(qCostos,"Documento",This.ArregloCostos[i].Documento)>
			<cfset QuerySetCell(qCostos,"Producto",This.ArregloCostos[i].Producto)>
			<cfset QuerySetCell(qCostos,"Monto",This.ArregloCostos[i].Monto)>		
		</cfloop> 

        <cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->

</cfcomponent>