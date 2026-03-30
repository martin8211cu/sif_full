
<!---FILTRO PARA ELIMINAR DE HPCRegla--->
<cfset LvarPCReglas ="PCReglas">
<cfif isdefined("Form.restaurar") and #Form.restaurar# eq 2 >
	<cfset LvarPCReglas ="HPCReglas">
</cfif>

<!---Cantidad de dias máximo realizar la eliminacion de las reglas--->
<cfset LvarDiasDelete = 60>

<!--- Chequeo de Errores --->
<cfif isdefined("Form.Alta") or isdefined("Form.Cambio") or isdefined("Form.bajarRule")>
	
    <cfquery name="getPCEMid" datasource="#Session.DSN#">
		select a.PCEMid
		from CtasMayor a
			inner join CPVigencia b
				on <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
				and b.Cmayor = a.Cmayor
				and b.Ecodigo = a.Ecodigo
				and b.PCEMid = a.PCEMid
		where a.Ecodigo = #Session.Ecodigo#
		and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
		and a.PCEMid is not null
	</cfquery>
	<cfif getPCEMid.recordCount EQ 0>
		<cf_errorCode	code = "50207" msg = "La cuenta mayor no existe o la cuenta mayor no posee máscara o cuenta mayor no se encuentra vigente">
	</cfif>

	<!--- Chequear que la regla no esté duplicada --->
	<cfquery name="chkExists" datasource="#Session.DSN#">
		select 1
		from PCReglas
		where Ecodigo = #Session.Ecodigo#
		and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
		<!--- and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#"> --->
		and OficodigoM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OficodigoM#">
		and PCRregla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CtaFinal#">
		and <cf_dbfunction name="now"> between PCRdesde and PCRhasta
		<cfif isdefined("Form.Cambio")>
		and PCRid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
		</cfif>
	</cfquery>
	<cfif chkExists.recordCount>
		<cf_errorCode	code = "50208" msg = "La regla ya existe en el sistema">
	</cfif>

	<!--- Si la regla es de nivel 2 --->
	<cfif isdefined("Form.PCRref") and Len(Trim(Form.PCRref))>
		<!--- Chequear que la regla a insertar o modificar tenga la misma oficina que la de su padre 
		***** No Aplica *****
		<cfquery name="chkOficina" datasource="#Session.DSN#">
			select 1
			from PCReglas
			where Ecodigo = #Session.Ecodigo#
			and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRref#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
		</cfquery>
		<cfif chkOficina.recordCount EQ 0>
			<cf_errorCode	code = "50209" msg = "La oficina debe ser igual a la oficina especificada en la regla de nivel 1">
		</cfif>
		 --->
		<!--- Chequear que el nivel de la regla a insertar o modificar no sea mayor a 2 --->
		<cfquery name="chkNivel" datasource="#Session.DSN#">
			select 1
			from PCReglas
			where Ecodigo = #Session.Ecodigo#
			and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRref#">
			and PCRref is null
		</cfquery>
		<!--- <cfif chkOficina.recordCount EQ 0>
			<cf_errorCode	code = "50210" msg = "La referencia de la regla debe ser una regla de nivel 1">
		</cfif> --->
	</cfif>
</cfif>

<cfif IsDefined("form.Alta")>
	<cfquery name="insRegla" datasource="#session.dsn#">
		insert into PCReglas (Ecodigo, Cmayor, PCEMid, OficodigoM, PCRref, PCRregla, PCRdescripcion, PCRvalida, PCRdesde, PCRhasta, Usucodigo, Ulocalizacion, BMUsucodigo, BMfechaalta, PCRGid)
		select 
			#Session.Ecodigo#,
			<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
				PCEMid,
			<cfif isDefined("Form.OficodigoM") and Len(Trim(Form.OficodigoM)) GT 0>
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.OficodigoM#">,
			<cfelse>
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
			</cfif>
			<cfif isdefined("Form.PCRref") and Len(Trim(Form.PCRref))>
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.PCRref#">,
			<cfelse>
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
			</cfif>
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.CtaFinal#">, 
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.PCRdescripcion#" null="#Len(Trim(Form.PCRdescripcion)) EQ 0#">, 
			<cfif isdefined("Form.PCRvalida")>
				1,
			<cfelse>
				0,
			</cfif>
			<cfif DateCompare(LSParseDateTime(form.PCRdesde), LSParseDateTime(form.PCRhasta)) LTE 0>
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRdesde)#">, 
			<cfelse>
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRhasta)#">, 
			</cfif>
			<cfif DateCompare(LSParseDateTime(form.PCRhasta), LSParseDateTime(form.PCRdesde)) GT 0>
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRhasta)#">, 
			<cfelse>
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRdesde)#">, 
			</cfif>
			#Session.Usucodigo#, 
			'#Session.Ulocalizacion#', 
			#Session.Usucodigo# ,
			<cf_dbfunction name="now">,
			#LvarGrp#
		from CtasMayor
		where Ecodigo = #Session.Ecodigo#
		and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
		and PCEMid is not null
	</cfquery>

<cfelseif IsDefined("form.Cambio")> 	
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PCReglas"
		redirect="AdminReglas.cfm"
		timestamp="#form.ts_rversion#"
		field1="PCRid"
		type1="numeric"
		value1="#form.PCRid#">
	
	<cfquery name="update" datasource="#session.DSN#">
		update PCReglas set 
			Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
			PCEMid = #getPCEMid.PCEMid#,
			OficodigoM = 
			<cfif isDefined("Form.OficodigoM") and Len(Trim(Form.OficodigoM)) GT 0>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OficodigoM#">,
			<cfelse>
				null,
			</cfif>			
			<cfif isDefined("Form.PCRref") and Len(Trim(Form.PCRref))>
				PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRref#">,
			<cfelse>
				PCRref = null,
			</cfif>
			PCRregla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CtaFinal#">, 
			PCRdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRdescripcion#" null="#Len(Trim(Form.PCRdescripcion)) EQ 0#">, 
			<cfif isdefined("form.PCRvalida")>
				PCRvalida = 1,
			<cfelse>
				PCRvalida = 0,
			</cfif>
			<cfif DateCompare(LSParseDateTime(form.PCRdesde), LSParseDateTime(form.PCRhasta)) LTE 0>
				PCRdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRdesde)#">, 
			<cfelse>
				PCRdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRhasta)#">, 
			</cfif>
			<cfif DateCompare(LSParseDateTime(form.PCRhasta), LSParseDateTime(form.PCRdesde)) GT 0>
				PCRhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRhasta)#">, 
			<cfelse>
				PCRhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.PCRdesde)#">, 
			</cfif>
			Usucodigo = #Session.Usucodigo#,
			BMUsucodigo = #Session.Usucodigo#
		where Ecodigo = #Session.Ecodigo#
		  and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
	</cfquery>
	
<cfelseif IsDefined("form.Baja")>
	<!--- Averiguar si la regla a borrar tiene reglas de nivel 2 --->
	<cfquery name="chkExists" datasource="#Session.DSN#">
		select count(1) as cantidad
		from PCReglas
		where Ecodigo = #Session.Ecodigo#
		  and PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
	</cfquery>
	<cfif chkExists.cantidad GT 0>
		<cf_errorCode	code = "50211" msg = "La regla no puede eliminarse porque contiene reglas de nivel 2">
	</cfif>
    
    <cfif #LvarPCReglas# eq "PCReglas"><!---RECICLAJE--->
    	<cfset insertRule = procesoReciclaje("#Form.PCRid#","PCReglas")>
    </cfif>
    
	<cfset resBaja = EliminaReglas("#Form.PCRid#")>

</cfif>

<cfset resBajaM ="">
<cfset insertRuleM ="">
<cfset LvarTabla ="">

<cfif isdefined("Form.bajaMasivo") or isdefined("Form.RestoreMasive")>
    <cfloop index="i" list="#Form.lstChecks#" delimiters=",">
		<cfset listaUno 	= #ListToArray(i,",")#>
        <cfset listaDos = Evaluate("Form.#listaUno[1]#")>

        <cfloop index="k" list="#listaDos#" delimiters=",">
        <cfset listaTres = #ListToArray(k,",")#>
        </cfloop>
        
        <cfif #LvarPCReglas# eq "PCReglas"><!---CASO DE RECICLAJE--->
        	<cfset insertRuleM = procesoReciclaje("#listaTres[1]#","PCReglas")>
        </cfif> 
        
		<cfif #LvarPCReglas# neq "PCReglas"><!---CASO RE RESTAURAR MASIVAMENTE--->
        	<cfif #Form.RestoreMasive# eq 1>
            	<cfset insertRuleM = procesoReciclaje("#listaTres[1]#","HPCReglas")>
            </cfif>
        </cfif>

        <cfset resBajaM = EliminaReglas("#listaTres[1]#")>
    </cfloop>
</cfif>
    

<cfset resBaja ="">
<cfset insertRule ="">
<cfif isdefined("Form.bajaRule") and #Form.bajaRule# eq 1>
	<cfif #LvarPCReglas# eq "PCReglas"><!---RECICLAJE--->
    	<cfset insertRule = procesoReciclaje("#Form.PCRid#","PCReglas")>
    </cfif>
	<cfset resBaja = EliminaReglas("#Form.PCRid#")>
</cfif>

<cfset insertRuleR ="">
<cfif isdefined("Form.RestoreRule") and #Form.RestoreRule# eq 1>
	<cfset insertRuleR = procesoReciclaje("#Form.PCRid#","HPCReglas")>
    <cfset resBaja = EliminaReglas("#Form.PCRid#")>
</cfif>



<cffunction		access="private" 
				name="EliminaReglas" 
                hint="Elimina las reglas ingresadas masivamente y inserta en la tabla de reciclaje de reglas"
                returntype="string">
	<cfargument name="PCRid" type="numeric" required="yes" hint="Regla a eliminar">
    
	<!---Identifica si es Padre o Hija--->
    <cfquery name="rsPadre" datasource="#Session.DSN#">
		SELECT COUNT(1) as cantidad
		FROM #LvarPCReglas#
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
          AND PCRref IS NOT NULL
	</cfquery>
	<cfif rsPadre.cantidad GT 0>
		<!---Si es hija se elimina individualmente--->
        <cfquery datasource="#session.DSN#">
            DELETE FROM #LvarPCReglas# 
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
		</cfquery>
    <cfelse>
    	<!---Si es Padre Busca a todos sus hijos--->    
    	<cfquery name="rsIdHijos" datasource="#session.dsn#">
			SELECT PCRid 
            FROM #LvarPCReglas# 
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            	AND PCRref= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
        </cfquery>
        
		<!---Los Elimina si los tiene--->
        <cfif #rsIdHijos.recordcount# GT 0>
        	<cfloop query="rsIdHijos">
                <cfquery datasource="#session.DSN#">
                    DELETE FROM #LvarPCReglas# 
                    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      	              AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIdHijos.PCRid#">
                </cfquery>
            </cfloop>
        </cfif>
        <!---Se elimina--->
        <cfquery datasource="#session.DSN#">
            DELETE FROM #LvarPCReglas# 
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            	AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
		</cfquery>
	</cfif>
</cffunction>


<!---Funcion que realiza el algoritmo de inserción en la tabla de reciclaje--->
<cffunction 	access="private" 
				name="procesoReciclaje" 
                hint="Funcion que realiza la inserción en la tabla historica de las reglas eliminidas">
	<cfargument name="PCRid" type="numeric" required="yes" hint="Regla a insertar">
    <cfargument name="Tabla" type="String" required="yes" 
    	hint="Tabla para realizar la restauración(HPCRreglas) o obtener los datos para inserción en reciclaje(PCReglas)">
  
    <cfset LvarPadre = "">
    <cfset LvarRegla = "">
	<cfset nuevoPadre = "">
     <cfset newFather = "">
	
	<!---revisión de hija o padre--->
    <cfquery name="rsHija" datasource="#session.DSN#">
        SELECT PCRref AS Padre
        FROM #Arguments.Tabla# 
        WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	        AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
    </cfquery>
    <cfset LvarPadre = #rsHija.Padre#>
    <cfset LvarRegla = #Arguments.PCRid#>
    
    
    <!---VALIDACION DE QUE ES HIJA--->
    <cfif #rsHija.Padre# NEQ "">
		
		<!---SI ES HIJA.. VERIFICAR Q TENGA PADRE EN LA TABLA--->
        <cfquery name="rsTienePadre" datasource="#session.DSN#">
            SELECT COUNT (1) as Cantidad
            FROM <cfif #Arguments.Tabla# eq "HPCReglas">PCReglas<cfelse>HPCReglas</cfif>  
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            	AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHija.Padre#">
        </cfquery>
        		
		<!---SI DEVUELVE GT 0... TIENE PADRE Y SE INSERTA SOLA--->
        <cfif rsTienePadre.Cantidad gt 0>
        
			<!---INSERTAR REGLA--->
            <cfset insertaReglaH = InsertarRegla("#Arguments.PCRid#","#Arguments.Tabla#")>
            <!---ACTUALIZA LA FECHA DEL PADRE A LA FECHA DE SU ULTIMO HIJO--->
            <cfif #Arguments.Tabla# eq "PCReglas">
                <cfquery name="rsUpdateFechaPadre" datasource="#session.DSN#">
                    UPDATE HPCReglas 
                    SET	HBMfechaalta = (select max(HBMfechaalta) FROM HPCReglas where PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPadre#">), 
						HPCRfechaVencimiento = (select max(HPCRfechaVencimiento) FROM HPCReglas where PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPadre#">) 
                    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
                        AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPadre#">
                </cfquery>
            </cfif>
		<cfelse><!---SINO... ES HIJA HUERFANA--->
        
			<cfif #Arguments.Tabla# neq "PCReglas"><!---CASO RESTAURACIÓN--->
            
            	<!---Inserta nuevo padre en PCReglas--->
            	<cfset insertarRPadre = InsertarRegla("#LvarPadre#","#Arguments.Tabla#")>
				<!---Selecciono Id Padre nuevo--->
                <cfquery name="rsIdNuevoPadreHU" datasource="#session.dsn#">
                    SELECT MAX(PCRid) as PadreNuevo FROM PCReglas
                </cfquery>
				<cfset nuevoPadreHU = #rsIdNuevoPadreHU.PadreNuevo#>
                <!---Inserta nuevo padre en HPCReglas--->
                <cfset insertPNHU = InsertarRegla("#nuevoPadreHU#","PCReglas")>
                <!---Selecciono Id Padre nuevo HPCReglas--->
                <cfquery name="rsIdNuevoPadreNR" datasource="#session.dsn#">
                    SELECT MAX(PCRid) as PadreNuevo FROM HPCReglas
                </cfquery>
				<cfset newPadreR = #rsIdNuevoPadreNR.PadreNuevo#>
                 <!---Actualiza hijos viejos a nuevo Padre--->
                  <cfquery name="rsActualizarHijos" datasource="#session.dsn#">
                     UPDATE HPCReglas 
                            SET  PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevoPadreHU#">
                        WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
                            AND PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPadre#">	
                  </cfquery>
                  <!---Elimina Padre Viejo--->
                  <cfset resBaja = EliminaReglas("#LvarPadre#")>
                  <!---Inserta Nueva hija--->
            	  <cfset insertRegla = InsertarRegla("#LvarRegla#","#Arguments.Tabla#")>
                  			              
            <cfelse><!---CASO RECICLAJE--->
            	<!---Inserta Padre--->
            	<cfset insertarHPadre = InsertarRegla("#LvarPadre#","#Arguments.Tabla#")>
            	<!---Inserta Hija--->
                <cfset insertRegla = InsertarRegla("#LvarRegla#","#Arguments.Tabla#")>
			</cfif>
		</cfif>
    <cfelse><!---SINO... ES PADRE--->
    
		<cfif #Arguments.Tabla# neq "PCReglas"><!---CASO RESTAURACIÓN--->
        
            <cfquery name="rsVerificaPViejo" datasource="#session.dsn#">
            	SELECT COUNT(1) as Cant FROM PCReglas WHERE PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
            </cfquery>
            <cfif #rsVerificaPViejo.Cant# gt 0><!---Si conserva Padre se mantiene--->
            	<cfset nuevoPadre = #Arguments.PCRid#>
            <cfelse><!---Sino... Se inserta--->
            	<cfset insertPadre = InsertarRegla("#Arguments.PCRid#","#Arguments.Tabla#")>  
            </cfif>
        <cfelse><!---CASO RECICLAJE--->
            <cfquery name="rsVerificaPadre" datasource="#session.dsn#">
            SELECT COUNT(1) AS Cant FROM HPCReglas WHERE PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
            </cfquery>
            <cfif #rsVerificaPadre.Cant# eq 0>
                <cfset insertPadreN = InsertarRegla("#Arguments.PCRid#","#Arguments.Tabla#")>    
            <cfelse>
            	<cfset parte = "d">
                <cfquery name="rsUpdateFechaPadre" datasource="#session.DSN#">
                    UPDATE HPCReglas 
                    SET	HBMfechaalta = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
                        HPCRfechaVencimiento = <cf_dbfunction name="dateadd" args="#LvarDiasDelete#, #now()#">
                    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
                     AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
                </cfquery>
            </cfif>
        </cfif>
        
		<cfif #Arguments.Tabla# neq "PCReglas" and nuevoPadre neq #Arguments.PCRid#><!---CASO RESTAURACION CON PADRE NUEVO--->
				<!---Seleccionar el ultimo padre agregado--->
            <cfquery name="rsIdNuevoPadre" datasource="#session.dsn#">
                SELECT MAX(PCRid) as PadreNuevo FROM PCReglas
            </cfquery>
            <cfset nuevoPadre = #rsIdNuevoPadre.PadreNuevo#>
            <!---Insercion de la referencia del nuevo padre en reciclaje--->
            <cfset insertPT = InsertarRegla("#nuevoPadre#","PCReglas")>
        </cfif>
        	<!---Busca a todos sus hijos--->  
        <cfquery name="rsIdHijos" datasource="#session.dsn#">
			SELECT PCRid 
            FROM <cfif #Arguments.Tabla# neq "PCReglas">HPCReglas<cfelse>PCReglas</cfif> 
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            	AND PCRref= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCRid#">
        </cfquery>
         
		<cfif #Arguments.Tabla# neq "PCReglas" and nuevoPadre neq #Arguments.PCRid#><!---EN CASO DE RESTAURAR--->
            <!---SE DEBE ACTUALIZAR LAS REFERENCIAS DE SUS HIJOS--->
            <cfloop query="rsIdHijos">
                <cfquery name="rsActualizaRedHijos" datasource="#session.dsn#">
                    UPDATE HPCReglas 
	                    SET  PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevoPadre#">
                    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
    	                AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIdHijos.PCRid#">	
                </cfquery>
			</cfloop>
        </cfif>
        <!---Restaura los hijos o los elimina--->
        <cfloop query="rsIdHijos">
			<cfset insertarSon = InsertarRegla("#rsIdHijos.PCRid#","#Arguments.Tabla#")>
		</cfloop>
        
        <cfif #Arguments.Tabla# neq "PCReglas" and nuevoPadre neq #Arguments.PCRid# ><cfset resBaja = EliminaReglas("#nuevoPadre#")></cfif>
        
    </cfif><!---END--->
</cffunction>

<!---Funcion que inserta reglas en la tabla de reciclaje posterior a su verificación--->
<cffunction access="private"
			name="InsertarRegla"
            hint="Función que realiza la inserción de cualquier regla">    
	<cfargument name="idRegla" type="numeric" required="yes" hint="Regla a insertar">
    <cfargument name="Tabla" type="String" required="yes" 
    	hint="Tabla para realizar la inserción en (HPCRreglas) o obtener los datos para inserción en reciclaje(PCReglas)">
    <cfset fechaInsercion = now()>
    <cftry>
        <cfquery name="rsInsertRule" datasource="#session.dsn#">
             INSERT INTO <cfif #Arguments.Tabla# eq "PCReglas">HPCReglas<cfelse>PCReglas</cfif>
                                (    Ecodigo
                                 <cfif #Arguments.Tabla# eq "PCReglas">,PCRid</cfif>
                                    ,Cmayor
                                    ,PCEMid 
                                    ,OficodigoM 
                                    ,PCRref 
                                    ,PCRregla 
                                    ,PCRdescripcion 
                                    ,PCRvalida
                                    ,PCRdesde 
                                    ,PCRhasta 
                                    ,Usucodigo 	
                                    ,Ulocalizacion 
                                    ,BMUsucodigo 
                                    ,BMfechaalta 
                                    ,PCRGid
                                     <cfif #Arguments.Tabla# eq "PCReglas">
                                    	,HUsucodigo
                                    	,HBMfechaalta 	
                                        ,HPCRfechaVencimiento  
                                     </cfif>) 
            SELECT 					
                     Ecodigo
                    <cfif #Arguments.Tabla# eq "PCReglas">,PCRid</cfif>
                    ,Cmayor
                    ,PCEMid 
                    ,OficodigoM 
                    ,PCRref 
                    ,PCRregla 
                    ,PCRdescripcion 
                    ,PCRvalida
                    ,PCRdesde 
                    ,PCRhasta 
                    ,Usucodigo 	
                    ,Ulocalizacion 
                    ,BMUsucodigo 
                    ,BMfechaalta 
                    ,PCRGid
                    <cfif #Arguments.Tabla# eq "PCReglas">
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                        ,<cfqueryparam cfsqltype="cf_sql_date" value="#fechaInsercion#">
                        ,<cf_dbfunction name="dateadd" args="#LvarDiasDelete#, #fechaInsercion#">
					</cfif> 
            
            FROM <cfif #Arguments.Tabla# neq "PCReglas">HPCReglas<cfelse>PCReglas</cfif>
            
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                AND PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idRegla#">
        </cfquery>
    <cfcatch type="any">
    </cfcatch>	
    </cftry>
</cffunction>

<cfset params= "">
<cfif isdefined("Form.PCRid") and Len(Trim(Form.PCRid)) and not isdefined("Form.Baja") and not isdefined("Form.Alta") and not isdefined("Form.bajaRule") and not isdefined("Form.bajaMasivo")>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PCRid=" & Form.PCRid>
</cfif>
<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
</cfif>
<cfif isdefined("Form.filtro_Cmayor")>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "filtro_Cmayor=" & Form.filtro_Cmayor>
</cfif>
<cfif isdefined("Form.filtro_OficodigoM") and Len(Trim(Form.filtro_OficodigoM))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "filtro_OficodigoM=" & Form.filtro_OficodigoM>
</cfif>
<cfif isdefined("Form.filtro_PCRregla") and Len(Trim(Form.filtro_PCRregla))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRregla=" & Form.filtro_PCRregla>
</cfif>
<cfif isdefined("Form.filtro_PCRvalida") and Len(Trim(Form.filtro_PCRvalida))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRvalida=" & Form.filtro_PCRvalida>
</cfif>
<cfif isdefined("Form.filtro_PCRdesde") and Len(Trim(Form.filtro_PCRdesde))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRdesde=" & Form.filtro_PCRdesde>
</cfif>
<cfif isdefined("Form.filtro_PCRhasta") and Len(Trim(Form.filtro_PCRhasta))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRhasta=" & Form.filtro_PCRhasta>
</cfif>
<cfif isdefined("Form.RetTipos") and Len(Trim(Form.RetTipos))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "RetTipos=" & Form.RetTipos>
</cfif>

<cfif #form.restaurar# eq 1>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "btnElegirGrp=1&cboGrupos=" & Form.LvarGrp>
    <cflocation url="AdminReglas.cfm#params#">
<cfelse>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "btnElegirGrp=1&cboGrupos=" & Form.LvarGrp>
	<cflocation url="RestaurarReglas.cfm#params#">
</cfif>

