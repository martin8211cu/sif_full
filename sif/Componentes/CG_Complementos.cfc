
<!--- 
********************* componente  de Cuentas Contables de SIF  **********************************
** Hecho por: Gustavo Gutiérrez A                                                              **
** Fecha: 13 Junio de 2003                                                                     **
** la funcionalidad del componente es enviarle cierto información de lo que se esta haciendo   **
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
	** funcion que trae la cuentas según parámetros enviados   **
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
								msg  = "Los siguentes par�metros son requeridos por el componente de complementos finacieros @errorDat_1@"
								errorDat_1="#sinenviar#"
				>
		</cfif>
		<!--- 
		********************************************************
		** Buscar Tabla de cuenta mayor según Origen		  **
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
        ** verifica que la  Tabla de cuenta mayor según Origen **
        ** venga como argumento                                **
        *********************************************************
        --->
        <cfif Len(Trim(rsTablaMayor.OPconst)) is 0 And Not StructKeyExists(Arguments, rsTablaMayor.OPtablaMayor)>
			<cf_errorCode	code = "51048"
							msg  = "El origen @errorDat_1@ no esta definido en la parametrizaci�n de origenes contables"
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
        <!--- ABG Application Hosting Juli0-2009
				Cuando se usa una de las tablas que no pertenecen a SIF, y que estan marcadas como OPcatalogoPlan = 1
				el componente toma por default que el valor enviado para ese argumento es la cuenta de mayor, pero, deberia
				realizarse el mismo proceso del cfelse, buscar la cuenta de Mayor parametrizada para ese parametro desde la 
				ventada de Complementos Financieros en Administracion del sistema SIF. Se elimina la condicion --->
		<!---<cfelseif (rsCatalogoPlan.RecordCount NEQ 0)>
        	<cfset CuentaMayor = Arguments[rsTablaMayor.OPtablaMayor]>--->
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
<!---        <cfabort showerror="Argumento: #rsTablaMayor.OPtablaMayor# ODchar: #Arguments['#rsTablaMayor.OPtablaMayor#']# Cuenta de Mayor: #rsCuentaMayor.Cmayor# "> --->
			<!--- ABG Application Hosting Juli0-2009
			Se cambia GT por LTE, si no encuentra Cuenta de Mayor regresa mensaje de error indicando que el parametro enviado
			para el argumento no tiene definida la cuenta de Mayor a Usar --->
            <cfif rsCuentaMayor.recordcount LTE 0>
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
            <!---ABG: Para Extraer la porcion de la cadena del complemento que corresponde al nivel---> 
			<!---ABG: Longitud del nivel--->
            <cfquery name="rsLNivel" datasource="#Arguments.Conexion#">
                select isnull(pd.PCNlongitud,0) as PCNlongitud
                from CtasMayor c 
                inner join PCEMascaras pc 
                    inner join PCNivelMascara pd
                    on pc.PCEMid = pd.PCEMid 
                on c.PCEMid = pc.PCEMid 
                and PCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaNiveles.OPnivel#">
                and c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaMayor#">
                and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
            <cfset varNLongitud = rsLNivel.PCNlongitud>
            <!---ABG: Longitud Antes del nivel--->
            <cfquery name="rsANivel" datasource="#Arguments.Conexion#">
                select isnull(sum(pd.PCNlongitud),0) as Longitud
                from CtasMayor c 
                inner join PCEMascaras pc 
                    inner join PCNivelMascara pd
                    on pc.PCEMid = pd.PCEMid 
                on c.PCEMid = pc.PCEMid 
                and PCNid < <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaNiveles.OPnivel#">
                and c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaMayor#">
                and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                inner join OrigenNivelProv op 
                on pd.PCNid = op.OPnivel and c.Cmayor = op.Cmayor and op.Ecodigo = c.Ecodigo
                and op.Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Oorigen#">
                and op.OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentaNiveles.OPtabla#">
            </cfquery>
            <cfset varALongitud = rsANivel.Longitud + 1>

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
<!--- ABG Application Hosting Juli0-2009
Error detectado: Cuando en la parametrizacion de los origenes contables, se utiliza una tabla que no pertenece
a los catalogos de SIF, al intentar armar la cuenta, el componente usa como valor para el nivel donde se haya especificado
dicho parametro, el valor que se pasa como argumento, cuando lo correcto seria ir a buscar el complemento a la tabla OrigenDatos
y dicho complemento usarlo para armar la cuenta
Correccion: Se elimina el cfelseif, la logica es, si el valor OPconst es nulo quiere decir que se tiene que ir a buscar el complemento del 
argumento que se paso como parametro para este componente, no pegar el mismo valor que se paso para el argumento #Arguments[rsCuentaNiveles.OPtabla]# --->
            <!---<cfelseif (rsCatalogoPlan.RecordCount NEQ 0)>
                <cfset QueryAddRow(Cuenta,1)>
                <cfset QuerySetCell(Cuenta, "nivel", #rsCuentaNiveles.OPnivel#,Cuenta.RecordCount)>
				<cfset QuerySetCell(Cuenta, "valor", #Arguments[rsCuentaNiveles.OPtabla]#,Cuenta.RecordCount)>--->
            <cfelse><!--- Len(OPconst) --->
                <cfquery name="rsTraeNiveles" datasource="#Arguments.Conexion#">
                    select substring(isnull(ODcomplemento,''),#varALongitud#,#varNLongitud#) as ODcomplemento <!---ABG: de acuerdo a los valores obtenidos para la longitud segun el plan contable se extrae el complemento --->
                    ,ODchar
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
                <cfif rsTraeNiveles.recordcount EQ 0 or (rsTraeNiveles.recordcount GT 0 and len(trim(rsTraeNiveles.ODcomplemento)) EQ 0)>

                   	<!--- Obtiene el rutatag del valor--->
                    <cfquery name="rsrutatag" datasource="sifcontrol">
                    	select rutatag
                        from OrigenTablaProv
                        where OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentaNiveles.OPtabla#">
                    </cfquery>
                    
                    <cfif compareNocase('rhcfuncional', rsrutatag.rutatag) eq 0>
                        <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select CFcodigo as Codigo
                            from CFuncional
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>
                    <cfelseif compareNocase('sifalmacen', rsrutatag.rutatag) eq 0>
                    	 <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select Almcodigo as Codigo
                            from Almacen
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>    
                    <cfelseif compareNocase('sifarticulos', rsrutatag.rutatag) eq 0>
                    	<cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select Acodigo as Codigo
                            from Articulos
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>    
                    <cfelseif compareNocase('sifmonedas', rsrutatag.rutatag) eq 0>
                    	<cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select Miso4217 as Codigo
                            from Monedas
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>  
                    <cfelseif compareNocase('sifsociosnegocios2', rsrutatag.rutatag) eq 0>
                        <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select SNnumero as Codigo
                            from SNegocios
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery> 
                    <cfelseif compareNocase('sifactivo', rsrutatag.rutatag) eq 0>
                        <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select ACcodigo as Codigo
                            from Activos
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery> 
                    <cfelseif compareNocase('sifoficinas', rsrutatag.rutatag) eq 0>
                        <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select Oficodigo as Codigo
                            from Oficinas
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>
                    <cfelseif compareNocase('sifconceptos', rsrutatag.rutatag) eq 0>
                        <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select Ccodigo as Codigo
                            from Conceptos 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>
                    <cfelseif compareNocase('siftransaccionescc', rsrutatag.rutatag) eq 0>
                        <cfset varCodigo = "#Arguments['#rsCuentaNiveles.OPtabla#']#">
                    <cfelseif compareNocase('siftransaccionescp', rsrutatag.rutatag) eq 0>
                        <cfset varCodigo = "#Arguments['#rsCuentaNiveles.OPtabla#']#">
                    <cfelseif compareNocase('sifbancos', rsrutatag.rutatag) eq 0>
                        <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select Bdescripcion as Codigo
                            from Bancos 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>
                    <cfelseif compareNocase('siftransaccionesmb', rsrutatag.rutatag) eq 0>
                        <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select BTcodigo as Codigo
                            from BTransacciones 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>
                    <cfelseif compareNocase('sifclasificacionconcepto', rsrutatag.rutatag) eq 0>
                         <cfquery name="rsComplemento" datasource="#Arguments.Conexion#">
                            select CCcodigo as Codigo
                            from CConceptos 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                            and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments['#rsCuentaNiveles.OPtabla#']#">
                        </cfquery>
                    <cfelse>
                        <cfset varCodigo = "#Arguments['#rsCuentaNiveles.OPtabla#']#">
                    </cfif>
                    <cfif isdefined("rsComplemento")>
	                    <cfset varCodigo = rsComplemento.Codigo>
                    </cfif>

                    <cf_errorCode	code = "51707"
                    				msg  = "El valor del complemento contable @errorDat_1@ se encuentra vacio o <br> no esta definido para el origen: @errorDat_2@, empresa: @errorDat_3@, @errorDat_4@: @errorDat_5@ <BR> para la cuenta mayor @errorDat_6@"
                    				errorDat_1="#rsCuentaNiveles.OPtabla#"
                    				errorDat_2="#Arguments.Oorigen#"
                    				errorDat_3="#Arguments.Ecodigo#"
                    				errorDat_4="#rsCuentaNiveles.OPtabla#"
                    				errorDat_5="#varCodigo#"
									<!---errorDat_5="#Arguments['#rsCuentaNiveles.OPtabla#']#"--->
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
        ** Validación  de la mascara  para que los valores sean **
        ** del mismo tamaño de la mascaras por nivel            **
        **********************************************************
        --->	
        <cfquery name="rsMascara" datasource="#Arguments.Conexion#">
            select Cmascara  from CtasMayor 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
            and  Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#CuentaMayor#"> 
        </cfquery>
        <cfset arreglo   = listtoarray(rsMascara.Cmascara,"-")>
		<cfset errormascaratx = "Cuenta #CuentaMayor# Origen #Arguments.Oorigen#. La longitud del complemento no coincide con la mascara "> <!--- ABG: Para Mejorar el Mensaje de Error --->
		<cfset errormascara = false> 
        <cfset CFormato = "">
        <cfloop query="Cuenta">
            <cfif len(trim(Cuenta.valor)) NEQ  len(trim(arreglo[Cuenta.nivel+1]))>
				<cfset errormascaratx = errormascaratx &'<br> Nivel :' & Cuenta.nivel & ' Valor : ' & #Cuenta.valor# & ' Mascara: ' & #arreglo[Cuenta.nivel+1]# >
                <cfset errormascara = true> 
            </cfif> 
            <cfset CFormato = CFormato & Cuenta.valor >
            <cfif Cuenta.currentRow  neq   Cuenta.RecordCount>
                <cfset CFormato = CFormato & '-'>
            </cfif>
        </cfloop>
        <cfif errormascara>
                <cf_errorCode	code = "51046"
                				msg  = "Se presentaron los siguientes errores: @errorDat_1@"
                				errorDat_1="#errormascaratx#"
                >
        </cfif>
        <!--- 
        *********************************************************
        ** se envia el formato generado al componente          **
        ** PC_GeneraCuentaFinanciera para que verifique        **
        ** si la cuenta es valida o la puede crear             **
        *********************************************************
        --->	
		
        <cfquery name="rsCFCuenta" datasource="#Arguments.Conexion#">
            select CFcuenta, Ccuenta,CPcuenta,CFformato   from CFinanciera 
            where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
            and  CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#CFormato#">
        </cfquery>
        <cfif rsCFCuenta.recordcount gt 0>
			<!--- 
            *********************************************************
            ** si todo marcha bien envia  el CFcuenta              **
            ** correspondiente al formato dado                     **
            *********************************************************
            --->					
            <cfreturn rsCFCuenta>
        <cfelse>
			<!--- ABG: Modificacion para acelerar el proceso, si la cuenta ya existe
            regresa el CFcuenta, sino ejecuta la validacion y generacion de cuentas 
            para crear la nueva cuenta--->
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
                <cfthrow message="Cuenta #CuentaMayor# Origen #Arguments.Oorigen#. #Lvar_MsgError#"> <!--- ABG: Para Mejorar el Mensaje de Error --->
			<cfelseif isdefined('Lvar_MsgError') AND (Lvar_MsgError EQ "NEW" OR Lvar_MsgError EQ "OLD")>
                <cfquery name="rsCFCuenta" datasource="#Arguments.Conexion#">
                    select CFcuenta, Ccuenta,CPcuenta,CFformato   
                    from CFinanciera 
                    where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
                    and  CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#CFormato#">
                </cfquery>
                <cfif rsCFCuenta.recordcount gt 0>
                    <!--- 
                    *********************************************************
                    ** Si la cuenta se creo de forma correcta envia el     **
                    ** CFcuenta correspondiente al formato creado          **
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
        </cfif>
        <cfquery name="rsCFCuenta" datasource="#Arguments.Conexion#">
            select '9999-999' as CFformato
        </cfquery>
        <cfreturn rsCFCuenta>
	</cffunction>	

	<cffunction name="init">
		<cfreturn This>
	</cffunction>
</cfcomponent>
