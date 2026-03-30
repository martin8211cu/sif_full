
<!--- 
********************* componente  de Cuentas Contables de SIF  **********************************
** Hecho por: Gustavo GutiÃ©rrez A                                                              **
** Fecha: 13 Junio de 2003                                                                     **
** la funcionalidad del componente es enviarle cierto informaciÃ³n de lo que se esta haciendo   **
** y el con esa informacion construye la Cuenta Contable                                       **
*************************************************************************************************
**                                                                                             **
** Modificado por danim, 16-Mar-2009                                                           **
** Para permitir valores constantes en la cuenta de mayor o las subcuentas, utilizando los     **
**   nuevos campos OrigenDocumentos.OPconst y OrigenNivelProv.OPconst                          **
**                                                                                             **
*************************************************************************************************

<cfinvoke returnvariable="Cuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta" 
	Oorigen		=""
	Ecodigo		="#Session.Ecodigo#"
	Conexion	="#Session.DSN#"
	Almacen 	=''
	Articulos 	=''	
	Oficinas 	=''	       
	CCTransacciones =''
	Conceptos 	=''
	Monedas 	=''
	SNegocios  	=''
>
</cfinvoke>	
--->
<cfcomponent>
	<!--- 
	*************************************************************
	** funcion que trae la cuentas segÃºn parÃ¡metros enviados   **
	*************************************************************
	--->
	<cffunction name="TraeCuenta" access="public" output="true" returntype="any">
		<cfargument name="Oorigen" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">
		<cfargument name="Conexion" type="string" required="true" default="#session.DSN#">
		<cfargument name="Lprm_TransaccionActiva" 	type="boolean" default="false">
		

		<cfset Cuenta = QueryNew("nivel,valor")>
		<!--- 
		***************************************************************
		** Proceso para validar que vengan todos los parametros		 **
		***************************************************************
		--->		
		<cfquery datasource="#Arguments.Conexion#" name="rsTablas">
			select OPtabla
			from OrigenProv 
			where Oorigen = <cfqueryparam cfsqltype="cf_sql_char"   value="#Arguments.Oorigen#">
			order by OPtabla
		</cfquery>		
		<cfset sinenviar = "">
		<cfloop query="rsTablas">
			<cfif  StructKeyExists(Arguments,rsTablas.OPtabla) eq false>
				<cfset sinenviar = sinenviar &'<br>' & rsTablas.OPtabla >
			</cfif>
		</cfloop> 
		
		<cfif len(trim(sinenviar)) >
				<cf_errorCode	code = "51041"
								msg  = "Los siguentes parámetros son requeridos por el componente de complementos finacieros @errorDat_1@"
								errorDat_1="#sinenviar#"
				>
		</cfif>
		<!--- 
		********************************************************
		** Buscar Tabla de cuenta mayor segÃºn Origen		  **
		********************************************************
		--->
		<cfquery name="rsTablaMayor" datasource="#Arguments.Conexion#">
			select OPtablaMayor, OPconst
			from OrigenDocumentos A
			where Oorigen = <cfqueryparam cfsqltype="cf_sql_char"   value="#Arguments.Oorigen#">
			and Ecodigo =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>	
		<cfif rsTablaMayor.recordcount EQ 0>
			<cf_errorCode	code = "51706"
							msg  = "La tabla de cuenta mayor @errorDat_1@ no esta definida en los parametros para el origen @errorDat_2@, empresa @errorDat_3@"
							errorDat_1="#rsTablaMayor.OPtablaMayor#"
							errorDat_2="#Arguments.Oorigen#"
							errorDat_3="#Arguments.Ecodigo#"
			>
        </cfif>
		<!--- 
        *********************************************************
        ** verifica que la  Tabla de cuenta mayor segÃºn Origen **
        ** venga como argumento                                **
        *********************************************************
        --->
        <cfif Len(Trim(rsTablaMayor.OPconst)) is 0 And Not StructKeyExists(Arguments, rsTablaMayor.OPtablaMayor)>
			<cf_errorCode	code = "51048"
							msg  = "El origen @errorDat_1@ no esta definido en la parametrización de origenes contables"
							errorDat_1="#Arguments.Oorigen#"
			>
        </cfif>
        
        <cfquery name="rsCatalogoPlan" datasource="sifcontrol">
        	select OPcatalogoPlan
            from OrigenTablaProv
            where OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTablaMayor.OPtablaMayor#">
              and OPcatalogoPlan = 1
        </cfquery>
        
        <cfif Len(Trim(rsTablaMayor.OPconst))>
        	<cfset CuentaMayor = rsTablaMayor.OPconst>
        <cfelseif (rsCatalogoPlan.RecordCount NEQ 0)>
        	<cfset CuentaMayor = Arguments[rsTablaMayor.OPtablaMayor]>
        <cfelse><!---Len(Trim(rsTablaMayor.OPconst))--->
			<cfset TablaMayor = rsTablaMayor.OPtablaMayor>
            <!--- 
            *********************************************************
            ** si existe la tabla como parametro utiliza el valor  **
            ** que viene en el argumento y busca la cuenta mayor   **
            *********************************************************
            --->				
            <cfquery name="rsCuentaMayor" datasource="#Arguments.Conexion#">
                select Cmayor
                from OrigenDatos
                where Oorigen = <cfqueryparam cfsqltype="cf_sql_char"   	value="#Arguments.Oorigen#">
                and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                and OPtabla   = <cfqueryparam cfsqltype="cf_sql_char"     	value="#rsTablaMayor.OPtablaMayor#">
                and ODchar    = <cfqueryparam cfsqltype="cf_sql_varchar"   	value="#Arguments['#rsTablaMayor.OPtablaMayor#']#">
            </cfquery>	
        
            <cfif rsCuentaMayor.recordcount gt 0>
                <cf_errorCode	code = "51044"
                				msg  = "El concepto finaciero @errorDat_1@ con el valor @errorDat_2@ <br> No tiene definida la cuenta mayor en el complemento finaciero "
                				errorDat_1="#rsTablaMayor.OPtablaMayor#"
                				errorDat_2="#Arguments['#rsTablaMayor.OPtablaMayor#']#"
                >
            </cfif>
            <cfset CuentaMayor = rsCuentaMayor.Cmayor>
        </cfif><!---Len(Trim(rsTablaMayor.OPconst))--->
        <cfset QueryAddRow(Cuenta,1)>
        <cfset QuerySetCell(Cuenta,"nivel","0",Cuenta.RecordCount)>
        <cfset QuerySetCell(Cuenta,"valor",#CuentaMayor#,Cuenta.RecordCount)> 
        <!--- 
        *********************************************************
        ** una vez localizada la cuenta mayor busca las tablas **
        ** asociadas a los diferentes niveles de la cuenta     **
        *********************************************************
        --->	
        <cfquery name="rsCuentaNiveles" datasource="#Arguments.Conexion#">
            select OPtabla, OPnivel, OPconst
            from   OrigenNivelProv
            where Oorigen = <cfqueryparam cfsqltype="cf_sql_char"   	value="#Arguments.Oorigen#">
            and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
            and Cmayor    = <cfqueryparam cfsqltype="cf_sql_char"   	value="#CuentaMayor#">
            order by OPnivel 
        </cfquery>

        <cfif rsCuentaNiveles.recordcount is 0>
            <cf_errorCode	code = "51043"
            				msg  = "Cuenta Mayor @errorDat_1@ no tiene parametrizado los niveles en origenes contables"
            				errorDat_1="#CuentaMayor#"
            >
        </cfif>
        <!--- 
        *********************************************************
        ** Carga cada uno de los niveles con el complemento    **
        ** asociado                                            **
        *********************************************************
        --->	
        <cfloop query="rsCuentaNiveles">
            <cfquery name="rsCatalogoPlan" datasource="sifcontrol">
                select OPcatalogoPlan
                from OrigenTablaProv
                where OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentaNiveles.OPtabla#">
                  and OPcatalogoPlan = 1
            </cfquery>

            <cfif Len(Trim(rsCuentaNiveles.OPconst))>
                <cfset QueryAddRow(Cuenta,1)>
                <cfset QuerySetCell(Cuenta, "nivel", #rsCuentaNiveles.OPnivel#,Cuenta.RecordCount)>
                <cfset QuerySetCell(Cuenta, "valor", #rsCuentaNiveles.OPconst#,Cuenta.RecordCount)> 
            <cfelseif (rsCatalogoPlan.RecordCount NEQ 0)>
                <cfset QueryAddRow(Cuenta,1)>
                <cfset QuerySetCell(Cuenta, "nivel", #rsCuentaNiveles.OPnivel#,Cuenta.RecordCount)>
                <cfset QuerySetCell(Cuenta, "valor", #Arguments[rsCuentaNiveles.OPtabla]#,Cuenta.RecordCount)> 
            <cfelse><!--- Len(OPconst) --->
                <cfquery name="rsTraeNiveles" datasource="#Arguments.Conexion#">
                    select ODcomplemento ,ODchar
                    from OrigenDatos
                    where Oorigen = <cfqueryparam cfsqltype="cf_sql_char"   	value="#Arguments.Oorigen#">
                    and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                    and OPtabla   = <cfqueryparam cfsqltype="cf_sql_char"     	value="#rsCuentaNiveles.OPtabla#">
                    and Cmayor   = <cfqueryparam cfsqltype="cf_sql_char"     	value="#CuentaMayor#">
                    <!--- <cfif Cant_Valores eq 1> --->
                        and ODchar    = <cfqueryparam cfsqltype="cf_sql_varchar"   	value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                    <!--- <cfelse>
                        and ODchar in (#PreserveSingleQuotes(listaValores)#)
                    </cfif> --->
                </cfquery>
                <cfif rsTraeNiveles.recordcount is 0>
                    <cf_errorCode	code = "51707"
                    				msg  = "El valor del complemento contable @errorDat_1@ se encuentra vacio o <br> no esta definido para el origen: @errorDat_2@, empresa: @errorDat_3@, @errorDat_4@: @errorDat_5@ <BR> para la cuenta mayor @errorDat_6@"
                    				errorDat_1="#rsCuentaNiveles.OPtabla#"
                    				errorDat_2="#Arguments.Oorigen#"
                    				errorDat_3="#Arguments.Ecodigo#"
                    				errorDat_4="#rsCuentaNiveles.OPtabla#"
                    				errorDat_5="#Arguments['#rsCuentaNiveles.OPtabla#']#"
                    				errorDat_6="#CuentaMayor#"
                    >
                </cfif>
                <cfset QueryAddRow(Cuenta,1)>
                <cfset QuerySetCell(Cuenta,"nivel",#rsCuentaNiveles.OPnivel#,Cuenta.RecordCount)>
                <cfset QuerySetCell(Cuenta,"valor",#rsTraeNiveles.ODcomplemento#,Cuenta.RecordCount)> 
             </cfif><!--- Len(OPconst) --->
        </cfloop>
        <!--- 
        **********************************************************
        ** ValidaciÃ³n  de la mascara  para que los valores sean **
        ** del mismo tamaÃ±o de la mascaras por nivel            **
        **********************************************************
        --->	
        <cfquery name="rsMascara" datasource="#Arguments.Conexion#">
            select Cmascara  from CtasMayor 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
            and  Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#CuentaMayor#">
        </cfquery>
        <cfset arreglo   = listtoarray(rsMascara.Cmascara,"-")>
        <cfset errormascara = "">
        <cfset CFormato = "">
        <cfloop query="Cuenta">
            <cfif len(trim(Cuenta.valor)) NEQ  len(trim(arreglo[Cuenta.nivel+1]))>
                <cfset errormascara = errormascara &'<br> Nivel :' & Cuenta.nivel & ' Valor : ' & #Cuenta.valor# & ' Mascara: ' & #arreglo[Cuenta.nivel+1]# >
            </cfif> 
            <cfset CFormato = CFormato & Cuenta.valor >
            <cfif Cuenta.currentRow  neq   Cuenta.RecordCount>
                <cfset CFormato = CFormato & '-'>
            </cfif>
        </cfloop>
        <cfif len(trim(errormascara)) >
                <cf_errorCode	code = "51046"
                				msg  = "Se presentaron los siguientes errores @errorDat_1@"
                				errorDat_1="#errormascara#"
                >
        </cfif>
        <!--- 
        *********************************************************
        ** se envia el formato generado al componente          **
        ** PC_GeneraCuentaFinanciera para que verifique        **
        ** si la cuenta es valida o la puede crear             **
        *********************************************************
        --->	
        <cfinvoke 
         component="sif.Componentes.PC_GeneraCuentaFinanciera"
         method="fnGeneraCuentaFinanciera"
         returnvariable="Lvar_MsgError">
            <cfinvokeargument name="Lprm_CFformato"	value="#CFormato#"/>
            <cfinvokeargument name="Lprm_fecha" value="#now()#"/>
            <cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
            <cfinvokeargument name="Lprm_NoCrear" value="false"/>
            <cfinvokeargument name="Lprm_CrearSinPlan" value="false"/>
            <cfinvokeargument name="Lprm_debug" value="false"/>
            <cfinvokeargument name="Lprm_Ecodigo" value="#Arguments.Ecodigo#"/>
            <cfinvokeargument name="Lprm_TransaccionActiva" value="#Arguments.Lprm_TransaccionActiva#"/>
            <cfinvokeargument name="Lprm_DSN" value="#Arguments.Conexion#">
        </cfinvoke>			
        <!--- 
        *********************************************************
        ** validacion del resultado del componente             **
        ** PC_GeneraCuentaFinanciera 						   **
        *********************************************************
        --->	
        <cfif isdefined('Lvar_MsgError') AND (Lvar_MsgError NEQ "" AND Lvar_MsgError NEQ "OLD" AND Lvar_MsgError NEQ "NEW")>
            <cfthrow message="#Lvar_MsgError#">
        <cfelseif isdefined('Lvar_MsgError') AND (Lvar_MsgError EQ "NEW" OR Lvar_MsgError EQ "OLD")>
            <cfquery name="rsCFCuenta" datasource="#Arguments.Conexion#">
                select CFcuenta, Ccuenta,CPcuenta,CFformato   from CFinanciera 
                where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
                and  CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#CFormato#">
            </cfquery>
            <cfif rsCFCuenta.recordcount gt 0>
                <!--- 
                *********************************************************
                ** si todo marcha bien envia  el CFcuenta              **
                ** correspondiente al formato creado    			   **
                *********************************************************
                --->					
                <cfreturn rsCFCuenta>
            <cfelse>
                <cf_errorCode	code = "51047"
                				msg  = "Error no se encontro el CFcuenta para el formato @errorDat_1@"
                				errorDat_1="#CFormato#"
                >
            </cfif>
        </cfif>			
	</cffunction>	

	<cffunction name="init">
		<cfreturn This>
	</cffunction>
</cfcomponent>

