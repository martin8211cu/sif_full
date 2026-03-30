<!---
		Recibe en el encabezado el numero de lineas a insertar y en el detalle, las lineas.
		verifica que la cantidad de lineas del detalle sea igual a lo que dice el encabezado.
		ademas que los codigo de unidades enviadas esten definidas para la empresa que las envia.
---->

<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInputED" datasource="sifinterfaces">
		select IE310.ID, IE310.CANTIDAD_DOCUMENTOS,
ID310.CLAVE_ITEM, ID310.UNIDAD_MEDIDA, ID310.DESCRIPCION
			from IE310 
		  	inner join ID310
				on ID310.ID = IE310.ID			
		 where IE310.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<cfif rsInputED.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 310 ">
	</cfif>	
</cftransaction>

<!--- valida que la cantidad de documentos del encabezado sea igual a las lineas del detalle--->
	<cfquery name="readCantED" datasource="sifinterfaces">
		select a.CANTIDAD_DOCUMENTOS as cantidadE,
		(select count(1) from ID310	as b where b.ID = a.ID) as cantidaD
		from IE310 as a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readCantED.cantidadE NEQ readCantED.cantidaD>
		<cfthrow message="Error en Interfaz 310. La cantidad de documentos no coincide con la cantidad especificada en el encabezado. Proceso Cancelado!.">
	</cfif>	
	
	<!-----Recorrer lineas del detalle------->
   <cfquery name="rsUmedida" datasource="sifinterfaces">
	  select CLAVE_ITEM, UNIDAD_MEDIDA, DESCRIPCION
		from ID310			
		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
   <!------Valida si el codigo enviado existe en los codigos de las UNidades para la empresa -------->
	<cfloop query="rsUmedida">
    	<cfquery name="rsEUmedida" datasource="sifinterfaces">
	        select Ucodigo from  <cf_dbdatabase table="Unidades" datasource="minisif"> 
			  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsUmedida.UNIDAD_MEDIDA#"> 
	    </cfquery>
		<cfif rsEUmedida.recordcount eq 0>
		  <cfthrow message="La Unidad de medida '#rsUmedida.UNIDAD_MEDIDA#' no existe para esta empresa!.">
		</cfif>
	</cfloop>
	<cftransaction>
	<!------Inserto cada linea del detalle en la tabla en minisif--------->
	 <cfloop query="rsUmedida">
	    <cfquery name="rsExistencia" datasource="sifinterfaces">
		   select COItemClave from  <cf_dbdatabase table="COItemsSigepro" datasource="minisif"> 
		   where COItemClave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUmedida.CLAVE_ITEM#">
		</cfquery>
		<cfif rsExistencia.recordcount gt 0>
		 <!---  Si ya existiera la linea, actualizo la informacion ---->
			 <cfquery name="rsUpdate" datasource="siinterfaces">
				 Update <cf_dbdatabase table="COItemsSigepro" datasource="minisif">  set COItemDescripcion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUmedida.DESCRIPCION#">
				 and COItemUnidad= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUmedida.UNIDAD_MEDIDA#"> 
				 where COItemClave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUmedida.CLAVE_ITEM#">		 
			 </cfquery>
		 <cfelse>
		  <!---  Si no existe la linea, se crea  ---->
			  <cfquery name="rsInsert" datasource="sifinterfaces">
				insert into  <cf_dbdatabase table="COItemsSigepro" datasource="minisif"> 
				(			 
				  COItemClave,
				  COItemUnidad,
				  COItemDescripcion,
				  Ecodigo	
				)
				values
				(
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUmedida.CLAVE_ITEM#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUmedida.UNIDAD_MEDIDA#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUmedida.DESCRIPCION#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 			
				)			 
			</cfquery>
		</cfif>
	 </cfloop>	
	</cftransaction>
	