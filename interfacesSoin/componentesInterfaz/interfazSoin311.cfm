<!---
	Interfaz 311
	En este mensaje viajará los códigos de proyecto prioritarios que se formularán en la solución 				    SOIN-SIF
	Dirección de la Inforamción: Sistema Externo CONAVI - SIF
	Elaborado por: Jeffry Castro Bermúdez (jcastro@soin.co.cr)
	Fecha de Creación: 23/04/2010
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado, Detalles y Salida de Documento XXX de la BD Interfaces. --->

<cfset LvarPCEcodigo = 'ACTIVIDAD'>
<cftransaction>
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz311" datasource="sifinterfaces">
		select 	IE311.ID,  ID311.ID
		from 	IE311   
		inner join  ID311
			on ID311.ID = IE311.ID	
		where IE311.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz311.recordcount eq 0>
		<cfthrow message="Error en Interfaz 311. No existen datos de Entrada para el ID='#GvarID#'. Proceso Cancelado!.">
	</cfif>
</cftransaction>	
<!--- valida que la cantidad de documentos del encabezado sea igual a las lineas de detalle--->
<cfquery name="readCantED" datasource="sifinterfaces">
	select a.CANTIDAD_DOCUMENTOS as cantidadE,
	(select count(1) from ID311	as b where b.ID = a.ID) as cantidaD
	from IE311 as a	
	where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
<!--- Valida que vengan datos --->
<cfif readCantED.cantidadE NEQ readCantED.cantidaD>
	<cfthrow message="Error en Interfaz 311. La cantidad de documentos no coincide con la cantidad especificada en el encabezado. Proceso Cancelado!.">
</cfif>	

<!--- valida que ningun PCDvalor que envia la intefaz exista ya--->
<cfquery name="readExistP" datasource="sifinterfaces">
	select 	CODIGO_PROYECTO	
	from 	IE311   
		inner join  ID311 
			on ID311.ID = IE311.ID 	
		inner join <cf_dbdatabase table="OBtipoProyecto" datasource= "#session.dsn#"> as obtipoproyecto
			on obtipoproyecto.OBTPcodigo = ID311.TIPO_PROYECTO
		inner join <cf_dbdatabase table="PCECatalogo" datasource= "#session.dsn#"> as pcecatalogo
			on pcecatalogo.PCEcatid = obtipoproyecto.PCEcatidPry
	where 	CODIGO_PROYECTO  
			in (select PCDvalor from <cf_dbdatabase table="PCDCatalogo" datasource= "#session.dsn#"> 				        		where PCEcatid = pcecatalogo.PCEcatid
					<!---(select PCEcatid from <cf_dbdatabase table="PCECatalogo" datasource=					   					"#session.dsn#"> where CEcodigo = #session.CEcodigo# and PCEcodigo = '#LvarPCEcodigo#'
					)--->
				) 
	and IE311.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
<cfif readExistP.recordCount NEQ 0>
	   	<cfthrow message="El proyecto ya existe">
</cfif>
<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="getData311" datasource="sifinterfaces">
		select 	IE311.ID,IE311.CANTIDAD_DOCUMENTOS,ID311.ID,ID311.CODIGO_PROYECTO,ID311.PERIODO,
				ID311.DESCRIPCION,ID311.TIPO_PROYECTO,ID311.TIPO_OBRA,ID311.TIPO_PROYECTO,
				ID311.TIPO_OBRA, obtipoproyecto.OBTPnivelProyecto,obtipoproyecto.OBTPid,pcecatalogo.PCEcatid
		from 	IE311   
		inner join  ID311
			on ID311.ID = IE311.ID 	
		inner join <cf_dbdatabase table="OBtipoProyecto" datasource= "#session.dsn#"> as obtipoproyecto
			on obtipoproyecto.OBTPcodigo = ID311.TIPO_PROYECTO
			and obtipoproyecto.Ecodigo = #Session.Ecodigo#
		inner join <cf_dbdatabase table="PCECatalogo" datasource= "#session.dsn#"> as pcecatalogo
			on 	pcecatalogo.PCEcatid = obtipoproyecto.PCEcatidPry
			and pcecatalogo.CEcodigo = #Session.CEcodigo# 
		where IE311.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz311.recordcount eq 0>
		<cfthrow message="Error en Interfaz 311. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
	
	<cffunction name="idcatalogoobra" returntype="numeric">
		<cfargument name="tipoobra" type="string" required="yes">
		<cfquery datasource="#session.dsn#" name="rsido">
				select pceC.PCEcatid
				  from PCECatalogo pceC
				 where pceC.PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipoobra#">
				 and pceC.CEcodigo = #Session.CEcodigo# 								 
		</cfquery>
		<cfif rsido.recordcount EQ 0>
				<cfthrow message="No se puedo recuperar el id catalogo obra">
		</cfif>
		<cfreturn #rsido.PCEcatid#>
	</cffunction>
	
	<!---funcion para obtener formato cuenta--->
		<cffunction name="fnCFformatoPry" returntype="string">
		<cfargument name="tipoproyecto" 	type="string" required="yes">
		<cfargument name="codigoproyecto" 	type="numeric" required="yes">
		
			<cfquery datasource="#session.dsn#" name="rsOBTP">
				select Cmayor, OBTPnivelProyecto, OBTPnivelObra
				  from OBtipoProyecto tp
				 where tp.OBTPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipoproyecto#">
				 and tp.Ecodigo = #Session.Ecodigo#  				 
			</cfquery>
			<cfif rsOBTP.recordCount EQ 0>
				<cfthrow message="Codigo del Poyecto invalido">
			</cfif>
			<cfquery datasource="#session.dsn#" name="rsformatoCuenta">
				select Cmascara from CtasMayor where Ecodigo = #Session.Ecodigo#  and Cmayor = '#rsOBTP.Cmayor#' 
			</cfquery>
			<cfif rsformatoCuenta.recordcount EQ 0>
				<cfthrow message="No se puedo recuperar la mascara contable del proyecto">
			</cfif>
			<cfset Arrayniveles = ListToArray(rsformatoCuenta.Cmascara,'-')>
						
			<cfset LvarCFformatoPry = ''>
			<cfloop index="LvarNivel" from="1" to="#rsOBTP.OBTPnivelObra-1#">
				<cfif LvarNivel EQ rsOBTP.OBTPnivelProyecto>
					<cfset LvarCFformatoPry &= '-' & Arrayniveles[LvarNivel]>
					<cfset LvarCFformatoPry &= '-' & Arguments.codigoproyecto>
				<cfelseif LvarNivel EQ  1>
					<cfset LvarCFformatoPry &= rsOBTP.Cmayor>
				<cfelse>
					<cfset LvarCFformatoPry &= '-' & Arrayniveles[LvarNivel]>
				</cfif>
			</cfloop>
			
			<cfreturn LvarCFformatoPry>
		</cffunction>

<cftransaction>
	<cfloop query="getData311">
		<cfset formatoP = "#fnCFformatoPry(getData311.TIPO_PROYECTO,getData311.CODIGO_PROYECTO)#">
		<cfset idO = "#idcatalogoobra(getData311.TIPO_OBRA)#">		
		<!---<cfthrow message="Error en Interfaz 311. formatop = '#formatoP#'. Proceso Cancelado!.">	--->
		<cfinvoke component="sif.Componentes.CM_CatalogoObras" method="AltaDetCatalogoProyectoObra"			
			
			<!---datos necesarios para insertar catalogo--->
			PCEcatid="#getData311.PCEcatid#"
			PCEcatidref="#idO#"
			PCDactivo="1"<!---definir si esta activo o no???--->
			PCDvalor ="#getData311.CODIGO_PROYECTO#"
			PCDdescripcion="#getData311.DESCRIPCION#"
			
			<!---datos necesarios para insertar proyecto--->
			OBPcodigo = "#getData311.CODIGO_PROYECTO#"
			OBPdescripcion ="#getData311.DESCRIPCION#"
			OBTPid = "#getData311.OBTPid#"
			<!---PCEcatidObr = "#getData311.PCEcatid#"---> 
			PCEcatidObr = "#idO#"
			CFformatoPry = "#formatoP#" <!---Definir bien formato--->
			
			<!---datos necesarios para insertar obra--->
			<!---OBOdescripcion = "#getData311.DESCRIPCION#"--->
			OBOestado= "0" <!---0-Cerrado, 1-Abierto, 2-Cerrado, 3-Liquidado---->
			<!---OBOfechaInicio= ""
			OBOfechaFinal= ""
			OBOresponsable= ""--->
			CFformatoObr= "#formatoP#" <!---Definir bien formato--->
			<!---OBOfechaInclusion= ""--->
			OBOnumLiquidacion= "0"
			OBOtipoValorLiq= "P" <!---P-porcentaje, M-Monto--->
			OBOmontoLiq= "0.00"							
			<!---returnvariable name="cat"--->
		/>
	</cfloop>
</cftransaction>


<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>