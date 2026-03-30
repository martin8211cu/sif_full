<!--- 	
	Creado por: Alejandro Bolaños
	Fecha : 18/Jun/2012
	Marca : 
	Funcion:	Realiza el Control de Eventos, generando los numeros de eventos para las operaciones configuradas en el módulo de 
				control de eventos. Para las operaciones que tienen relacionados uno o mas documentos con numero de evento asignado y que
				forman parte de algun evento genera la relacion entre los numeros de evento relacionados y el nuevo numero de evento generado.
				Para las operaciones que no generan nuevo numero de evento, utiliza el Origen Contable Sin Control de Evento OSCE, para generar 
				un numero de evento unico.
--->
<!--- El proceso de control de Evento realiza los siguientes Pasos --->
<!--- Se invoca el componente con el metodo GeneraEvento
		VALIDA EVENTO
		1.- Se busca el Origen Contable / Transaccion [/Complemento] en la tabla de Detalles de Evento DEvento donde el valor 
		GeneraEvento = 1. La llave Origen Contable / Transaccion [/Complemento] solo puede existir en un solo Evento, cuando esta ha sido 
		tomada como operacion que Genera nuevo Numero de Evento
		2.- Si el Control de Eventos esta deshabilitado regresa el valor 1 
		3.- Si la operacion enviada genera evento para alguno de los eventos configrados en el sistema, regresa el valor 2
		4.- Si la operacion enviada No genera evento para ninguno de los eventos configurados en el sistema, regresa el valor 3
		GENERA EVENTO
		1.- Se busca el Origen Contable / Transaccion [/Complemento] en la tabla de Detalles de Evento DEvento donde el valor 
		GeneraEvento = 1. La llave Origen Contable / Transaccion [/Complemento] solo puede existir en un solo Evento, cuando esta ha sido 
		tomada como operacion que Genera nuevo Numero de Evento
		2.- Si se encuentra algun evento donde la operacion enviada Genera un evento, se procede al proceso de Generacion de Evento. 
		3.- En caso de que la operacion enviada NO genere un evento en ninguno de los Eventos configurados, 
		se procede a generar un Consecutivo usando el Origen Contable OSCE
		4.- Se registra el Evento generado en la tabla EventosControl, indicando el origen, Transaccion y Documento que generó dicho Evento
		5.- Se regresan los valores del Evento generado 
		RELACION EVENTO
		1.- Busca el eveto para el documento de referencia enviado
		2.- Si existe un numero de evento relacionado al documento de referencia se procede a relacionar los Numeros de Evento
		3.- Se registra la relacion entre el Evento de la operacion procesada y el numero de Evento relacionado al documento Referencia, 
		esto se hace registrando un detalle en la tabla EventosControlDetalle para el Evento relacionado al documento Referencia.
		4.- Se regresan los valores del Evento relacionado
		--->
        
<!--- Para llamar el Componente ControlEventos se hace de la siguiente forma --->
<!--- 
1.-El primer paso es obtener la validacion para el proceso genera evento
<cfinvoke component="sif.Componentes.CG_ControlEvento" 
	method="ValidaEvento" 
	Origen="Origen Segun la operacion aplicada"
	Transaccion="Si aplica se envia la transaccion"
	Complemento="Si aplica se envia el Complemento"
	Conexion="datasourse de sistema que aplique para la empresa en la que se este trabajando"
	Ecodigo="Ecodigo de la empresa en la que se este trabajando"
	returnvariable="varValidaEvento"
/> 	
Este proceso puede regresar alguno de estos valores 0-Control de Eventos Deshabilitado 1-Operacion SI Genera Evento 2-Operacion NO Genera Evento		
2.-Si el resultado de la Validacion de Evento es 1, 2 ó 3 se ejecuta el proceso Genera Evento
<cfinvoke component="sif.Componentes.CG_ControlEvento" 
	method="GeneraEvento" 
	Origen="Origen Segun la operacion aplicada"
	Transaccion="Si aplica se envia la transaccion"
	Complemento="Si aplica se envia el Complemento"
	Documento="Documento que genera el evento"
	SocioCodigo="Si aplica se envia el Socio de negocios para la operacion Aplicada"
	Conexion="datasourse de sistema que aplique para la empresa en la que se este trabajando"
	Ecodigo="Ecodigo de la empresa en la que se este trabajando"
	returnvariable="arNumeroEvento"
/> 
Este proceso regresa un array con los valores generados por el evento Evento|OperacionID|NumeroEvento|ID_NEvento|ID_NEventoLinea
3.-
	3.1.-Si el resultado de la Validacion de Evento es 1
	
		3.1.1.-Se registra el Numero de Evento generado por el proceso GeneraEvento para la operacion en todos los asientos de la poliza

	3.2.- Si el resultado de la Validacion de Evento es 2
	
		3.2.1 Si la operacion aplicada tiene Documentos Relacionados, como en el caso de los pagos de Facturas de CxP, se ejecuta 
				el proceso de RelacionaEvento, para cada uno de los documentos relacionados
				<cfinvoke component="sif.Componentes.CG_ControlEvento" 
					method="RelacionaEvento" 
					IDNEvento="ID del Numero de Evento Generado por la Operacion Principal"
					Origen="Origen del Documento Relacionado a la operacion"
					Transaccion="Transaccion del Documento Relacionado a la operacion"
					Complemento="Si aplica Complemento del Documento Relacionado a la operacion"
					Documento="Documento Relacionado a la operacion"
					SocioCodigo="Socio del Documento Relacionado a la operacion"
					Conexion="datasourse de sistema que aplique para la empresa en la que se este trabajando"
					Ecodigo="Ecodigo de la empresa en la que se este trabajando"
					returnvariable="arRelacionEvento"
				/> 			
				El proceso de RelacionaEvento Regresa El Numero de Evento creado para el documento relacionado a la operacion en un array 
				que contiene la siguiente Info  ID_NEventoLineaRef|ID_NEventoRef|NumeroEventoRef
				
		3.2.2 Si la operacion aplicada No tiene Documentos relaionados como en el caso de una operacion que no haya sido
				registrada en ningun evento, Se registra el Numero de Evento OSCE generado por el proceso GeneraEvento en todos los 
				asientos de la poliza		
--->

<cfcomponent output="no">

<!---	<cfthrow message = "LGS Origen ;;-) #Origen#" >   --->


	<!--- Esta Funcion Valida si la operacion aplicada Genera o No Genera Evento --->
	<cffunction name="ValidaEvento" access="public" output="no" returntype="numeric">
		<cfargument name="Origen"			type="string" 	required="yes"	default="OSCE">
		<cfargument name="Transaccion" 		type="string" 	required="no" default="">
        <cfargument name="Complemento" 		type="string" 	required="no" default="">
        <!---Valores de Sesion--->
        <cfargument name="Conexion"			type="string"	required="no" default="">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no" default="-1">
		
		<!--- Busca parametro Control Eventos --->
        <cfquery datasource="#Arguments.Conexion#" name="PEvento">
			select Pvalor from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 1350
		</cfquery>
        
        <cfif not isdefined("PEvento.Pvalor") OR (isdefined("PEvento.Pvalor") and PEvento.Pvalor EQ 'N')>
        	<!--- Valor 0 indica que el Control de Eventos esta desactivado --->
            <cfreturn 0>
        </cfif>
        
        <!--- Valida que se hayan enviado los valores necesarios para generar el evento --->
        <cfif Arguments.Origen EQ "">
        	<cfthrow message="Debe indicarse un Origen Contable valido para generar el evento">
        </cfif>
        
        <!--- Verifica si el Origen y Transacciones enviados estan configurados dentro de algun Evento --->
        <cfquery datasource="#Arguments.Conexion#" name="GEvento">
        	select a.ID_Evento, b.EVcodigo, b.EVformato, a.OperacionCodigo, b.EVtipoConsecutivo,
            b.AgregaOperacion, a.GeneraEvento, b.EVComplemento,a.ComplementoActivo
            from DEvento a
            inner join EEvento b on a.Ecodigo = b.Ecodigo and a.ID_Evento = b.ID_Evento
            where a.Oorigen like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Origen#">
           	and a.Transaccion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Transaccion#">
           	and coalesce(a.Complemento,'') like 
            case a.ComplementoActivo
            	when 0 then coalesce(a.Complemento,'')
                when 1 then 
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Complemento#">
            end 
            and a.GeneraEvento = 1
        </cfquery>
        <!--- 0 = CONTROL EVENTO DESHABILITADO, 1 =  SI GENERA EVENTO, 2 = NO GENERA EVENTO Y 3 = EVENTO UNICO --->
        <cfif GEvento.recordcount GT 0 and GEvento.ID_Evento NEQ "" and GEvento.ID_Evento GT 0>
        	<cfif GEvento.EVComplemento EQ 1>
            	<!--- El valor 1 indica que la operacion Enviada genera evento Unico--->
                <cfreturn 3>
            <cfelse>	
				<!--- El valor 1 indica que la operacion Enviada SI genera evento --->
                <cfreturn 1>
            </cfif>
        <cfelse>
        	<!--- El valor 2 indica que la operacion Enviada NO genera evento --->
        	<cfreturn 2>
        </cfif>
    </cffunction>
    
    <!--- Esta Funcion Genera el Numero de Evento --->
	<cffunction name="CG_GeneraEvento" access="public" output="no" returntype="array">
		<cfargument name="Origen"			type="string" 	required="yes"	default="OSCE">
		<cfargument name="Transaccion" 		type="string" 	required="no" default="">
        <cfargument name="Complemento" 		type="string" 	required="no" default="">
		<cfargument name="Documento" 		type="string" 	required="yes" default="">
		<cfargument name="SocioCodigo" 		type="numeric" 	required="no" default="0">
        <!---Valores de Sesion--->
        <cfargument name="Conexion"			type="string"	required="no" default="">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no" default="-1">
		
		<!--- Busca parametro Control Eventos --->
        <cfquery datasource="#Arguments.Conexion#" name="PEvento">
			select Pvalor from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 1350
		</cfquery>
        
        <cfif not isdefined("PEvento.Pvalor") OR (isdefined("PEvento.Pvalor")  and PEvento.Pvalor EQ 'N')>
        	<cfreturn "Control de Eventos Desactivado">
        </cfif>
        <!--- Valida que se hayan enviado los valores necesarios para generar el evento --->
        <cfif Arguments.Origen EQ "">
        	<cfthrow message="Debe indicarse un Origen Contable valido para generar el evento">
        </cfif>
        
        <cfif Arguments.Documento EQ "">
        	<cfthrow message="Debe indicarse el Documento que genera el evento">
        </cfif>
                
        <!--- Verifica si el Origen y Transacciones enviados estan configurados dentro de algun Evento --->
        <cfquery datasource="#Arguments.Conexion#" name="GEvento">
        	select a.ID_Evento, b.EVcodigo, b.EVformato, a.OperacionCodigo, b.EVtipoConsecutivo,
            	b.AgregaOperacion, a.GeneraEvento, b.EVComplemento, a.ComplementoActivo
            from DEvento a
            inner join EEvento b on a.Ecodigo = b.Ecodigo and a.ID_Evento = b.ID_Evento
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            and  a.Oorigen like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Origen#">
			and a.Transaccion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Transaccion#">
			and coalesce(a.Complemento,'') like 
            case a.ComplementoActivo
            	when 0 then coalesce(a.Complemento,'')
                when 1 then 
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Complemento#">
            end 
            and a.GeneraEvento = 1 
        </cfquery>

        <cfset varEncabezado = true>
        <!--- Busca los valores default para reemplazar comodines --->
        <cfquery datasource="#Arguments.Conexion#" name="Periodo">
            select Pvalor from Parametros
            where Ecodigo = #Arguments.Ecodigo#
              and Pcodigo = 50
        </cfquery>

        <cfquery datasource="#Arguments.Conexion#" name="Mes">
            select Pvalor from Parametros
            where Ecodigo = #Arguments.Ecodigo#
              and Pcodigo = 60
        </cfquery>
        
        <cfif not isdefined("Periodo") or Periodo.Pvalor EQ "">
            <cfthrow message="No se encuentra el valor para el Periodo Contable">
        </cfif>
        <cfif not isdefined("Mes") or Mes.Pvalor EQ "">
            <cfthrow message="No se encuentra el valor para el Mes Contable">
        </cfif>
                   
        <cfset RPeriodo = Periodo.Pvalor>
        <cfset RMes = Mes.Pvalor>
 
        <cfif GEvento.recordcount GT 0 and GEvento.ID_Evento NEQ "" and GEvento.ID_Evento GT 0>
            
            <cfif GEvento.EVComplemento EQ 1>
				<!---Busca si existe un Numero de Evento generado para el Periodo-Mes para el Complemento--->
                <cfquery name="rsTipoCons" datasource="#Arguments.Conexion#">
                    select EVtipoConsecutivo
                    from EEvento
                    where 
                    Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                    and ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEvento.ID_Evento#">
                </cfquery>
                <cfset varTipoNumeracion = rsTipoCons.EVtipoConsecutivo>
                <cfquery datasource="#Arguments.Conexion#" name="rsEventoPeriodo">
                	select ID_NEvento, NumeroEvento, Evento, Consecutivo
                    from EventosControl
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                    and ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEvento.ID_Evento#">
                    and Oorigen like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Origen#">
                    and coalesce(Complemento,'') like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Complemento#">
                    <cfif varTipoNumeracion EQ 1 OR varTipoNumeracion EQ 2>
                    	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#RPeriodo#">
                    </cfif>
                    <cfif varTipoNumeracion EQ 1>
                    	and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#RMes#">
                    </cfif>
                </cfquery>
                <cfif isdefined("rsEventoPeriodo") AND rsEventoPeriodo.recordcount EQ 1>
                	<cfset Consecutivo = rsEventoPeriodo.Consecutivo>
                	<cfset varIDNEvento = rsEventoPeriodo.ID_NEvento>
                    <cfset varEncabezado = false>
                <cfelse>
                	<!---Inserta El consecutivo si no existe --->
                    <cfquery name="rsVerificaCons" datasource="#Arguments.Conexion#">
                    	Select 1
                        from NEvento
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEvento.ID_Evento#">
                        and Periodo = 
                        	<cfif varTipoNumeracion EQ 1 OR varTipoNumeracion EQ 2>
                            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#RPeriodo#">
                            <cfelse>
                            	0
                            </cfif>
                        and Mes = 
                        	<cfif varTipoNumeracion EQ 1>
                        		<cfqueryparam cfsqltype="cf_sql_numeric" value="#RMes#">
                            <cfelse>
                            	0
                            </cfif>
                    </cfquery>
                    <cfif rsVerificaCons.recordcount EQ 0>
                        <cfquery datasource="#Arguments.Conexion#">
                            insert into NEvento (ID_Evento, Ecodigo, Periodo, Mes, Consecutivo,BMUsucodigo)
                            values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEvento.ID_Evento#">
                            , <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                            , <cfif varTipoNumeracion EQ 1 OR varTipoNumeracion EQ 2>
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#RPeriodo#">
                              <cfelse>
                                    0
                              </cfif>
                            , <cfif varTipoNumeracion EQ 1>
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#RMes#">
                              <cfelse>
                                    0
                              </cfif>
                            , 1
                            , <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)
                        </cfquery>                    	
                    	<cfset Consecutivo = 1>
                    <cfelse>
                		<!--- Obtiene el Consecutivo para el nuevo Evento --->
		                <cfset Consecutivo = GeneraConsecutivo(#GEvento.ID_Evento#,#RPeriodo#,#RMes#, #Arguments.Conexion#, #Arguments.Ecodigo#)>
                    </cfif>
				</cfif>
				
                <!--- Aqui se obtiene el Numero de Evento --->
                <cfset varComodin = FormatoEvento(#Arguments.Conexion#, #RPeriodo#, #RMes#, #Consecutivo#, #Arguments.Origen#, #Arguments.Transaccion#, #Arguments.Complemento#)>
                <cfset varComodines = varComodin[1]>
                <cfset varReemplazos = varComodin[2]>
                <cfset varTiposDato = varComodin[3]>
                <cfset varFormatos = varComodin[4]>
                
                <cfset EventoCadena = FormatoCadena(GEvento.EVformato,varComodines,varReemplazos,varTiposDato,varFormatos)>
                
                <!--- Ahora se obtiene el ID de la operacion--->
                <cfset IDOperacion = #GEvento.OperacionCodigo#>
                <cfif GEvento.AgregaOperacion EQ 1>
                    <cfset NEventoCadena = EventoCadena & '-' & IDOperacion>
                <cfelse>
                    <cfset NEventoCadena = EventoCadena>
                </cfif>
                <cfset varIDEvento = #GEvento.ID_Evento#>
                <cfset varOperacionCodigo = #GEvento.OperacionCodigo#>
			<cfelse>
				<!--- Obtiene el Consecutivo para el nuevo Evento --->
                <cfset Consecutivo = GeneraConsecutivo(#GEvento.ID_Evento#,#RPeriodo#,#RMes#, #Arguments.Conexion#, #Arguments.Ecodigo#)>
                
                <cfset varComodin = FormatoEvento(#Arguments.Conexion#, #RPeriodo#, #RMes#, #Consecutivo#, #Arguments.Origen#, #Arguments.Transaccion#, #Arguments.Complemento#)>
                <cfset varComodines = varComodin[1]>
                <cfset varReemplazos = varComodin[2]>
                <cfset varTiposDato = varComodin[3]>
                <cfset varFormatos = varComodin[4]>
                
                <!--- Aqui se obtiene el Numero de Evento --->
                <cfset EventoCadena = FormatoCadena(GEvento.EVformato,varComodines,varReemplazos,varTiposDato,varFormatos)>
                <!--- Ahora se obtiene el ID de la operacion--->
                <cfset IDOperacion = GEvento.OperacionCodigo>
                <cfif GEvento.AgregaOperacion EQ 1>
                    <cfset NEventoCadena = EventoCadena & '-' & IDOperacion>
                <cfelse>
                    <cfset NEventoCadena = EventoCadena>
                </cfif>
                <cfset varIDEvento = GEvento.ID_Evento>
                <cfset varOperacionCodigo = GEvento.OperacionCodigo>
            </cfif>
        <cfelse>
        	<!--- Verifica si se encuentra parametrizado el Evento Generico --->
            <cfquery name="rsEVGEN" datasource="#Arguments.Conexion#">
            	select ID_Evento, EVformato
                from EEvento
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and EVgenerico = 1
            </cfquery>
            <cfif isdefined("rsEVGEN") and rsEVGEN.recordcount GT 0>
				<!--- Obtiene el Consecutivo para Evento OSCE y Genera el Numero de Evento--->
				<cfset Consecutivo = GeneraConsecutivo(#rsEVGEN.ID_Evento#,#RPeriodo#,#RMes#, #Arguments.Conexion#, #Arguments.Ecodigo#)>
                
				<cfset varComodin = FormatoEvento(#Arguments.Conexion#, #RPeriodo#, #RMes#, #Consecutivo#, #Arguments.Origen#, #Arguments.Transaccion#, #Arguments.Complemento#)> 
                <cfset varComodines = varComodin[1]>
                <cfset varReemplazos = varComodin[2]>
                <cfset varTiposDato = varComodin[3]>
                <cfset varFormatos = varComodin[4]>
				
                <!--- Aqui se obtiene el Numero de Evento --->
                <cfset EventoCadena = FormatoCadena(rsEVGEN.EVformato,varComodines,varReemplazos,varTiposDato,varFormatos)>
                <cfset IDOperacion = '0'>
                <cfset NEventoCadena = EventoCadena>
                <cfset varIDEvento = rsEVGEN.ID_Evento>
                <cfset varOperacionCodigo = '0'>
			<cfelse>
            	<cfthrow message="No se encuentra configurado el Evento Gen&eacute;rico">
                <!--- Obtiene el Consecutivo para Evento OSCE y Genera el Numero de Evento
                <cfset Consecutivo = GeneraConsecutivo(0,0, 0, #Arguments.Conexion#, #Arguments.Ecodigo#)>
                <cfset EventoCadena = 'OSCE-' & Consecutivo>
                <cfset IDOperacion = '0'>
                <cfset NEventoCadena = EventoCadena>
                <cfset varIDEvento = 0>
                <cfset varOperacionCodigo = '0'>--->
            </cfif>
        </cfif>
        <!---Registra Evento en Control de Eventos --->
        <cfif varEncabezado>
        <!---ERBG Corrección Service Call 182562 Inicia--->  
        	<cfset vs_Complemento = "#arguments.Complemento#">
            <cfquery name="rsCountEventosControl" datasource="#Arguments.Conexion#">
            	select count(*) from EventosControl
                where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and		Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Origen#">
                and 	Transaccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Transaccion#">
                and 	Documento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Documento#">
                and		Complemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Complemento#">
            </cfquery>
            <cfif isdefined("rsCountEventosControl") and rsCountEventosControl.recordcount GT 0>
        		<cfset vs_Complemento = "#rsCountEventosControl.recordcount#">
            </cfif>
        <!---ERBG Corrección Service Call 182562 Fin--->  
            <cfquery datasource="#Arguments.Conexion#" name="insertEnc">
                insert into EventosControl 
                        (ID_Evento, Ecodigo, NumeroEvento, Evento, Consecutivo, 
                        OperacionCodigo, Oorigen, Documento, Transaccion, Complemento,
                        SNcodigo, Periodo, Mes, BMUsucodigo)
                values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDEvento#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#NEventoCadena#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#EventoCadena#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Consecutivo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOperacionCodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Origen#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Documento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Transaccion#">,
                   		<!---ERBG <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Complemento#">,--->
                   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_Complemento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SocioCodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#RPeriodo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#RMes#">,
                        <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)
                <cf_dbidentity1 datasource="#Arguments.Conexion#">                     
            </cfquery>
            <cf_dbidentity2 datasource="#Arguments.Conexion#" name="insertEnc">
        	<cfset varIDNEvento = insertEnc.identity>
        </cfif>

       	<cfquery datasource="#Arguments.Conexion#" name="insertDet">
        	insert into EventosControlDetalle
            		(ID_NEvento, Ecodigo, ID_NEventoRef, NumeroEventoRef,
                     EventoRef, OperacionCodigoRef, OorigenRef, DocumentoRef, TransaccionRef,                     
                     ComplementoRef, SNcodigoRef,BMUsucodigo,  NumeroEvento, Evento, OperacionCodigo,
                     Periodo, Mes)
            values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDNEvento#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDNEvento#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#NEventoCadena#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#EventoCadena#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOperacionCodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Origen#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Documento#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Transaccion#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Complemento#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SocioCodigo#">,
                    <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#NEventoCadena#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#EventoCadena#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOperacionCodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#RPeriodo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#RMes#">)
       		<cf_dbidentity1 datasource="#Arguments.Conexion#">                     
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="insertDet">
        <cfset varIDNEventoLinea = insertDet.identity>
        <cfset varEVComplemento = 0>
		<cfif isdefined("GEvento") and len(GEvento.EVComplemento) GT 0>
        	<cfset varEVComplemento = GEvento.EVComplemento>
        </cfif>
        
        <!---Se regresa un array que contiene Evento|OperacionID|NumeroEvento|ID_NEvento, IDNEventoLinea --->
        <cfset arResultado = ArrayNew(1)>
        <cfset temp = ArraySet(arResultado,1,6,"Valor")>
        <cfif temp>
			<cfset arResultado[1] =  EventoCadena>
            <cfset arResultado[2] =  varOperacionCodigo>
            <cfset arResultado[3] =  NEventoCadena>
            <cfset arResultado[4] =  varIDNEvento>
            <cfset arResultado[5] =  varIDNEventoLinea>
            <cfset arResultado[6] =  varEVComplemento>
		<cfelse>
        	<cfthrow message="Error al crear Array de Resultados">
        </cfif>
        <cfreturn arResultado>
	</cffunction>
    
    <!--- Esta Funcion Genera la relacion entre el Numero de Evento del documento relaionado y el Numero de Evento Principal --->
	<cffunction name="CG_RelacionaEvento" access="public" output="no" returntype="array">
    	<cfargument name="IDNEvento"		type="numeric" required="yes">	
		<cfargument name="Origen"			type="string" 	required="yes"	default="OSCE">
		<cfargument name="Transaccion" 		type="string" 	required="no" default="">
        <cfargument name="Complemento" 		type="string" 	required="no" default="">
		<cfargument name="Documento" 		type="string" 	required="yes" default="">
		<cfargument name="SocioCodigo" 		type="numeric" 	required="no" default="0">
        <!---Valores de Sesion--->
        <cfargument name="Conexion"			type="string"	required="no" default="">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no" default="-1">
        <cfargument name="EVComplemento" 	type="boolean" 	required="no" default="0"> <!---Para los eventos especiales solo se considera Origen/Complemento--->
		
        <!--- Busca parametro Control Eventos --->
        <cfquery datasource="#Arguments.Conexion#" name="PEvento">
			select Pvalor from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 1350
		</cfquery>
        
        <cfif not isdefined("PEvento.Pvalor") OR (isdefined("PEvento.Pvalor")  and PEvento.Pvalor EQ 'N')>
            <cfreturn "Control de Eventos Desactivado">
        </cfif>
        
        <!--- Valida que se hayan enviado los valores necesarios para generar el evento --->
        <cfif Arguments.Origen EQ "">
        	<cfthrow message="Debe indicarse un Origen Contable valido para generar el evento">
        </cfif>
        
        <cfif Arguments.Documento EQ "">
        	<cfthrow message="Debe indicarse el Documento que genera el evento">
        </cfif>
                
        <!--- Busca el Numero de Evento generado por el Documento relacionado --->
        <cfquery datasource="#Arguments.Conexion#" name="GEvento">
        	select a.ID_NEvento, a.ID_Evento, a.NumeroEvento, a.Evento, 
            a.OperacionCodigo, a.Oorigen, a.Documento, a.Transaccion, a.SNcodigo, a.Complemento
            from EventosControl a
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            and  Oorigen like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Origen#">
            <cfif EVComplemento EQ 0 OR EVComplemento EQ 2>
            	and Transaccion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Transaccion#">
            </cfif>    
            <cfif EVComplemento EQ 0>
            	and a.Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">
            </cfif>
           	and coalesce(Complemento,'') like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Complemento#">
            and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SocioCodigo#">
        </cfquery>

        <cfset varOperacionCodigo = "">
        <cfset EventoRelacion = false>
        <cfif GEvento.recordcount GT 0 and GEvento.ID_NEvento NEQ "" and GEvento.ID_NEvento GT 0>
			<!---Si se encontro numero de evento par el documento rlacionado se procede a crear la relacion --->
            
			<!--- Busca los valores del evento a relacionar --->
            <cfquery name="rsEventoR" datasource="#Arguments.Conexion#">
            	select ID_NEvento, ID_Evento, NumeroEvento, Evento, OperacionCodigo, 
                Oorigen, Documento, Transaccion, Complemento, SNcodigo
                from EventosControl
                where ID_NEvento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDNEvento#">
            </cfquery>
			<cfif rsEventoR.recordcount LTE 0>
	            <cfthrow message="Error al obtener el evento a relacionar">
            </cfif>

            
            <!--- Busca el OperacionID para la operacion Relacionada, en el evento del documento relacionado--->
            <cfquery name="rsOperacionCodigo" datasource="#Arguments.Conexion#">
            	select a.OperacionCodigo
                from DEvento a
                where ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEvento.ID_Evento#">
                and Oorigen like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Oorigen#">
                and Transaccion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Transaccion#">
                and coalesce(a.Complemento,'') like 
                case a.ComplementoActivo
                    when 0 then coalesce(a.Complemento,'')
                    when 1 then 
                        coalesce(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Complemento#">,'')
                end 
            </cfquery>

            <cfif isdefined("rsOperacionCodigo") and rsOperacionCodigo.recordcount EQ 1 and rsOperacionCodigo.OperacionCodigo NEQ "">
            	<cfset varOperacionCodigo = rsOperacionCodigo.OperacionCodigo>
                <cfset EventoRelacion = true>
            </cfif>
            
            <cfif EventoRelacion>
				<!--- Periodo y Mes Contable --->
                <cfquery datasource="#Arguments.Conexion#" name="Periodo">
                    select Pvalor from Parametros
                    where Ecodigo = #Arguments.Ecodigo#
                      and Pcodigo = 50
                </cfquery>
        
                <cfquery datasource="#Arguments.Conexion#" name="Mes">
                    select Pvalor from Parametros
                    where Ecodigo = #Arguments.Ecodigo#
                      and Pcodigo = 60
                </cfquery>
                
                <cfif not isdefined("Periodo.Pvalor") or Periodo.Pvalor EQ "">
                    <cfthrow message="No se encuentra el valor para el Periodo Contable">
                </cfif>
                <cfif not isdefined("Mes.Pvalor") or Mes.Pvalor EQ "">
                    <cfthrow message="No se encuentra el valor para el Mes Contable">
                </cfif>
                           
                <cfset RPeriodo = Periodo.Pvalor>
                <cfset RMes = Mes.Pvalor>
                
                
                <!--- Aqui se obtiene el Numero de Evento --->
                <cfset EventoCadena = GEvento.Evento>
                <cfset NEventoCadena = EventoCadena & '-' & varOperacionCodigo>
                <cfset varIDNEvento = GEvento.ID_NEvento>
                <cfset varIDNEventoLinea = 0>
				<cfset varOperacionCodigo = varOperacionCodigo>
            <cfelse>
            	<!--- Aqui se obtiene el Numero de Evento --->
                <cfset EventoCadena = "">
                <cfset NEventoCadena = "">
                <cfset varIDNEvento = 0>
                <cfset varIDNEventoLinea = 0>
                <cfset varOperacionCodigo = "">
                <cfset varIDNEventoLinea = 0>
            </cfif>
        <cfelse>
			<cfset EventoCadena = "">
            <cfset NEventoCadena = "">
            <cfset varIDNEvento = 0>
            <cfset varIDNEventoLinea = 0>
            <cfset varOperacionCodigo = "">
        </cfif>
        <cfif EventoRelacion>
            <cfquery datasource="#Arguments.Conexion#" name="insertDet">
                insert into EventosControlDetalle
                        (ID_NEvento, Ecodigo, ID_NEventoRef, NumeroEventoRef, EventoRef, 
                         OperacionCodigoRef, OorigenRef, DocumentoRef, TransaccionRef, 
                         ComplementoRef, SNcodigoRef, NumeroEvento, Evento, OperacionCodigo, 
                         Periodo, Mes, BMUsucodigo)
                values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDNEvento#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEventoR.ID_NEvento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.NumeroEvento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Evento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.OperacionCodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Oorigen#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Documento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Transaccion#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.Complemento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEventoR.SNcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#NEventoCadena#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#EventoCadena#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOperacionCodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#RPeriodo#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#RMes#">,
                        <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)
                <cf_dbidentity1 datasource="#Arguments.Conexion#">                     
            </cfquery>
            <cf_dbidentity2 datasource="#Arguments.Conexion#" name="insertDet">
            <cfset varIDNEventoLinea = insertDet.identity>
        </cfif>	
        
        <!---Se regresa un array que contiene Relaciona|Evento|OperacionID|NumeroEvento|ID_NEvento --->
        <cfset arResultado = ArrayNew(1)>
        <cfset temp = ArraySet(arResultado,1,6,"Valor")>
        <cfif temp>
			<cfset arResultado[1] =  #EventoRelacion#>
			<cfset arResultado[2] =  #EventoCadena#>
            <cfset arResultado[3] =  #varOperacionCodigo#>
            <cfset arResultado[4] =  #NEventoCadena#>
            <cfset arResultado[5] =  #varIDNEvento#>
            <cfset arResultado[6] =  #varIDNEventoLinea#>
		<cfelse>
        	<cfthrow message="Error al crear Array de Resultados">
        </cfif>
        <cfreturn arResultado>
	</cffunction>
    
    <!--- Esta funcion genera el consecutivo para los eventos--->
    <cffunction access="private" name="GeneraConsecutivo" returntype="numeric">
        <cfargument name="Evento"		type="numeric" 	required="yes">
        <cfargument name="Periodo"		type="numeric" 	required="no">
        <cfargument name="Mes"	 		type="numeric" 	required="no">
        <!---Valores de Sesion--->
        <cfargument name="Conexion"			type="string"	required="no" default="">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no" default="-1">
        
        <!---Si el Evento enviado es 0, se refiere al Origen OSCE --->
        <!---Si el Evento es Diferente de 0 genera el nuevo consecutivo, dependiendo del tipo de Consecutivo configurado para el Evento --->    	
        
        <cfset LvPeriodo = #Arguments.Periodo#>
        <cfset LvMes = #Arguments.Mes#>
            
		<cfif Arguments.Evento EQ 0>
        	<cfset TipoNumeracion = 3>
        <cfelse>
			<cfset TipoNumeracion = 1>
            <cfquery name="rsTipoConsecutivo" datasource="#Arguments.Conexion#">
                select EVtipoConsecutivo
                from EEvento
                where 
                Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Evento#">
            </cfquery>
            <cfset TipoNumeracion = rsTipoConsecutivo.EVtipoConsecutivo>
        </cfif>
        
        <cfif TipoNumeracion EQ 3>
			<!--- Perpetua --->
            <cfset LvPeriodo = 0>
            <cfset LvMes = 0>
        </cfif> 
        <cfif TipoNumeracion EQ 2>
			<!--- Anual --->
            <cfset LvMes = 0>
        </cfif> 
        
        <!---Verifica si existe Consecutivo para el Periodo/Mes --->
        <cfquery name="rsVerificaC" datasource="#Arguments.Conexion#">
        	select count(1) as VerificaC
            from NEvento
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            and ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Evento#">
            and Periodo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvPeriodo#">
            and Mes       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvMes#">
        </cfquery>
        
        <cfif rsVerificaC.VerificaC GT 0>
            <cfquery datasource="#Arguments.Conexion#">
                update NEvento
                set Consecutivo = Consecutivo + 1
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Evento#">
                and Periodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvPeriodo#">
                and Mes       = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvMes#">
            </cfquery>
        <cfelse>
            <cftry>
                <cfquery datasource="#Arguments.Conexion#">
                    insert into NEvento (ID_Evento, Ecodigo, Periodo, Mes, Consecutivo,BMUsucodigo)
                    values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Evento#">
                    , <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                    , <cfqueryparam cfsqltype="cf_sql_integer" value="#LvPeriodo#">
                    , <cfqueryparam cfsqltype="cf_sql_integer" value="#LvMes#">
                    , 1
                    , <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">)
                </cfquery>
            <cfcatch>
                <cfthrow message="No se logro Crear Consecutivo para el Evento en el Periodo/Mes">
            </cfcatch>
            </cftry>
        </cfif>

        <cfquery name="rsConsecutivo" datasource="#Arguments.Conexion#">
            select Consecutivo
            from NEvento
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            and ID_Evento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Evento#">
            and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvPeriodo#">
            and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvMes#">
        </cfquery>
        
        <cfreturn rsConsecutivo.Consecutivo>
    </cffunction>
    
    <!---Esta funcion Genera la cadena formateada para el Evento--->
    <cffunction name="FormatoCadena" returntype="string" access="private" output="no">
        <cfargument name = "Cadena" type="string" required="yes">
        <cfargument name = "Comodines" type="string" required="yes">
        <cfargument name="Reemplazos" type="string" required="yes">
        <cfargument name="TiposDato" type="string" required="yes">
        <cfargument name="Formatos" type="string" required="yes">
        <!---<cfargument name="TiposReemplazo" type="string" required="yes">--->
                  
        <cfset arComodines=ListtoArray(Arguments.Comodines,",")>
        <cfset arReemplazos=ListtoArray(Arguments.Reemplazos,",")>    
        <cfset arTiposDato=ListtoArray(Arguments.TiposDato,",")>
        <cfset arFormatos=ListtoArray(Arguments.Formatos,",")>
        <!---<cfset arTiposReemplazo=ListtoArray(Arguments.TiposReemplazo,",")>--->
        
        <!--- Valida que se haya enviados los valores correctamente --->
        <cfset ValidaLargo = ArrayLen(arComodines)>
        <cfif  ArrayLen(arReemplazos) LT VAlidaLargo>
        	 <cfthrow message="Error, No se enviaron todos los reemplazos necesarios para los comodines">
        </cfif>
        <cfif  ArrayLen(arTiposDato) LT VAlidaLargo>
        	 <cfthrow message="Error, No se enviaron todos los tipos de dato necesarios para los comodines">
        </cfif>
        <cfif  ArrayLen(arFormatos) LT VAlidaLargo>
        	<cfthrow message="Error, No se enviaron todos los formtos necesarios para los comodines">
        </cfif>
        <cfset CadNEvento = Arguments.Cadena>
        <cfloop from="1" to="#ArrayLen(arComodines)#" index="contador">
            <cfset Comodin= arComodines[contador]>
            <cfset Reemplazo = arReemplazos[contador]>
			<cfif arFormatos[contador] EQ 'S'>
                <cfif arTiposDato[contador] EQ 'I'>
                    <cfset lcadComodin=len(Comodin)>
                    <cfset lcadReemplazo=len(Reemplazo)>
                    <cfset numCeros = lcadComodin-lcadReemplazo>
                    <cfset Ceros="">
                    <cfloop from="1" to="#numCeros#" step="1" index="var">
                        <cfset Ceros= Ceros &"0">        
                    </cfloop>
                    <cfset  Reemplazo = Ceros & Reemplazo>   
                <cfelseif arTiposDato[contador] EQ 'S'>
                    <cfset Remplazo = left(Reemplazo,lcadComodin)>
                </cfif>	
            </cfif>
            <cfset CadNEvento =   replace(CadNEvento,Comodin,Reemplazo,"all")> 	            
        </cfloop> 
        <cfreturn CadNEvento> 
    </cffunction>  
    
    <!---Esta funcion Genera el array de comodines--->
    <cffunction name="FormatoEvento" returntype="array" access="private" output="no">
        <cfargument name="Conexion"			type="string"	required="no" default="">
        <cfargument name="Periodo" type="numeric" required="yes">
        <cfargument name="Mes" type="numeric" required="yes">
        <cfargument name="Consecutivo" type="numeric" required="yes">
        <cfargument name="Origen" type="string" required="yes">
        <cfargument name="Transaccion" type="string" required="yes">
        <cfargument name="Complemento" type="string" required="yes">
        
        <cfif Arguments.Complemento EQ "" or len(trim(Arguments.Complemento)) EQ 0>
        	<cfset Arguments.Complemento = "N/A">
        </cfif>
        
        <!--- Se leen los comodines configurados --->
        <cfquery name="rsComodin" datasource="#Arguments.Conexion#">
            select ECcomodin, 
            ECReferencia,
            case ECReferencia
            when 1 then 'Periodo'
            when 2 then 'Mes'
            when 3 then 'Consecutivo'
            when 4 then 'Origen' 
            when 5 then 'Transaccion'
            when 6 then 'Complemento'
            when 7 then ECReferenciaOtro
            end 
            as Reemplazo,
            ECtipoDato,
            ECformato                
            from ComodinEvento
            where ECactivo = 1
        </cfquery>
        
        <cfset CadComodines = "">
        <cfset CadReemplazos = "">
        <cfset CadTiposDato = "">
        <cfset CadFormatos = "">
         <cfset CadTiposReemplazo = "">
         
        <cfloop query="rsComodin">
            <cfif CadComodines EQ "">
            	<cfset CadComodines = rsComodin.ECcomodin>
            <cfelse>
            	<cfset CadComodines = CadComodines & "," & rsComodin.ECcomodin>
            </cfif>
            <cfswitch expression="#rsComodin.ECReferencia#">
                <cfcase value="1">
                    <cfset LvarReemplazo = Arguments.Periodo>
                </cfcase>
                <cfcase value="2">
                    <cfset LvarReemplazo = Arguments.Mes>
                </cfcase>
                <cfcase value="3">
                    <cfset LvarReemplazo = Arguments.Consecutivo>
                </cfcase>
                <cfcase value="4">
                    <cfset LvarReemplazo = Arguments.Origen>
                </cfcase>
                <cfcase value="5">
                    <cfset LvarReemplazo = Arguments.Transaccion>
                </cfcase>
                <cfcase value="6">
                    <cfset LvarReemplazo = Arguments.Complemento>
                </cfcase>
                <cfcase value="7">
                    <cfset LvarReemplazo = rsComodin.Reemplazo>
                </cfcase>
                <cfdefaultcase>
                    <cfset LvarReemplazo = "">
                </cfdefaultcase>
            </cfswitch>
            <cfif CadReemplazos EQ "">
            	<cfset CadReemplazos = LvarReemplazo>
            <cfelse>
				<cfset CadReemplazos = CadReemplazos & "," & LvarReemplazo>
            </cfif>
            <cfif CadTiposDato EQ "">
            	<cfset CadTiposDato = rsComodin.ECtipoDato>
            <cfelse>
            	<cfset CadTiposDato = CadTiposDato & "," & rsComodin.ECtipoDato>
            </cfif>	
            <cfif CadFormatos EQ "">
            	<cfset CadFormatos = rsComodin.ECformato>
            <cfelse>
            	<cfset CadFormatos = CadFormatos & "," & rsComodin.ECformato>
            </cfif>
            <cfif CadTiposReemplazo EQ "">
            	<cfset CadTiposReemplazo = "A">
            <cfelse>
            	<cfset CadTiposReemplazo = CadTiposReemplazo & "," & "A">
            </cfif>
        </cfloop>
        
        <cfset arComodin = ArrayNew(1)>
        <cfset temp = ArraySet(arComodin,1,5,"Valor")>
        <cfif temp>
			<cfset arComodin[1] =  CadComodines>
			<cfset arComodin[2] =  CadReemplazos>
            <cfset arComodin[3] =  CadTiposDato>
            <cfset arComodin[4] =  CadFormatos>
            <cfset arComodin[5] =  CadTiposReemplazo>
		<cfelse>
        	<cfthrow message="Error al crear Array de Comodines">
        </cfif>
        <cfreturn arComodin>
    </cffunction>
</cfcomponent>
