<!--- 
	Archivo       : CCostosPMI.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos para manejo de costos en un arreglo.
--->
<cfcomponent>
	<!--- Inicializa el arreglo, esto solo ocurre cuando es creado el componente  --->
	<cfset This.ArregloCostos = ArrayNew(1)>

	<!--- //// Método de inclusión del costo --->
	<cffunction name="IncluirCosto">
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		<cfargument name="Alloc_Num" required="Yes" type="numeric">
		<cfargument name="Alloc_Item_Num" required="Yes" type="numeric">
		<cfargument name="Producto" required="Yes" type="string">
		<cfargument name="Monto" required="Yes" type="numeric">
		<cfargument name="TipoCosto" required="Yes" type="string">
		<cfargument name="TipoFactura" required="Yes" type="string">

		<!--- Obtener la estructura que representa este costo en el arreglo, y sumar el monto  --->
		<cfset CostoStruct = ObtenerCosto(Arguments.Trade_Num,Arguments.Order_Num,Arguments.Item_Num,Arguments.Alloc_Num,Arguments.Alloc_Item_Num,Arguments.Producto)>
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
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		<cfargument name="Alloc_Num" required="Yes" type="numeric">
		<cfargument name="Alloc_Item_Num" required="Yes" type="numeric">
		<cfargument name="Producto" required="Yes" type="string">

		<cfset var PosicionArreglo = 0>

		<!--- Si existe, obtiene la posición del item  --->
		<cfloop from="1" to="#ArrayLen(This.ArregloCostos)#" index="i">
			<cfif This.ArregloCostos[i].Trade_Num EQ Arguments.Trade_Num and
				  This.ArregloCostos[i].Order_Num EQ Arguments.Order_Num and		 
				  This.ArregloCostos[i].Item_Num EQ Arguments.Item_Num and 
				  This.ArregloCostos[i].Alloc_Num EQ Arguments.Alloc_Num and 
				  This.ArregloCostos[i].Alloc_Item_Num EQ Arguments.Alloc_Item_Num and 
				  This.ArregloCostos[i].Producto EQ Arguments.Producto> 	
				  <cfset PosicionArreglo = i>
				  <cfbreak>
			</cfif>
		</cfloop> 

		<cfreturn PosicionArreglo>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Método obtener el costo  --->
	<cffunction name="ObtenerCosto" returntype="struct">
		<cfargument name="Trade_Num" required="Yes" type="numeric">
		<cfargument name="Order_Num" required="Yes" type="numeric">
		<cfargument name="Item_Num" required="Yes" type="numeric">
		<cfargument name="Alloc_Num" required="Yes" type="numeric">
		<cfargument name="Alloc_Item_Num" required="Yes" type="numeric">
		<cfargument name="Producto" required="Yes" type="string">

		<cfset var PosArr = 0>
		
		<!--- Obtiene la posición del costo en el arreglo  --->
		<cfset PosArr = ObtenerPosicion(Arguments.Trade_Num,Arguments.Order_Num,Arguments.Item_Num,Arguments.Alloc_Num,Arguments.Alloc_Item_Num,Arguments.Producto)>

		<!--- Si el costo es encontrado, lo retornamos  --->
		<cfif PosArr GT 0>
			<cfset CostoStruct = This.ArregloCostos[PosArr]>
		<cfelse>
			<cfset CostoStruct = StructNew()>
			<cfset CostoStruct.Trade_Num = Arguments.Trade_Num>
			<cfset CostoStruct.Order_Num = Arguments.Order_Num>
			<cfset CostoStruct.Item_Num = Arguments.Item_Num>
			<cfset CostoStruct.Alloc_Num = Arguments.Alloc_Num>
			<cfset CostoStruct.Alloc_Item_Num = Arguments.Alloc_Item_Num>
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
		<cfset qCostos = QueryNew("Trade_Num, Order_Num, Item_Num, Alloc_Num, Alloc_Item_Num, Producto,Monto")>

		<!--- Si existe, obtiene la posición del item  --->
		<cfloop from="1" to="#ArrayLen(This.ArregloCostos)#" index="i">
			<cfset QueryAddRow(qCostos)>
			<cfset QuerySetCell(qCostos,"Trade_Num",This.ArregloCostos[i].Trade_Num)>
			<cfset QuerySetCell(qCostos,"Order_Num",This.ArregloCostos[i].Order_Num)>
			<cfset QuerySetCell(qCostos,"Item_Num",This.ArregloCostos[i].Item_Num)>
			<cfset QuerySetCell(qCostos,"Alloc_Num",This.ArregloCostos[i].Alloc_Num)>
			<cfset QuerySetCell(qCostos,"Alloc_Item_Num",This.ArregloCostos[i].Alloc_Item_Num)>
			<cfset QuerySetCell(qCostos,"Producto",This.ArregloCostos[i].Producto)>
			<cfset QuerySetCell(qCostos,"Monto",This.ArregloCostos[i].Monto)>
		</cfloop> 

        <cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->

</cfcomponent>