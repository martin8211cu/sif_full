<cfcomponent>
<!---=FUNCIÓN QUE RETORNA UN LISTADO DE TODAS LAS CONFIGURACIONES GEOGRAFICAS PARA LOS DISTINTOS PAISES=--->
	<cffunction name="fnGetlistadoNiveles"  access="public" returntype="query">
		<cfargument name="Conexion"  type="string"  required="no">
        <cfargument name="Ppais"  	 type="string"  required="no">
        <cfargument name="Pnombre"   type="string"  required="no">

        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "asp">
		</cfif>

       <cfquery datasource="#Arguments.Conexion#" name="rslistadoNiveles">
            select p.Ppais, p.Pnombre, count(1) cantidad
            from NivelGeografico n
                inner join Pais p
                    on n.Ppais = p.Ppais
			where 1 = 1
           <cfif isdefined('Arguments.Ppais') and LEN(TRIM(Arguments.Ppais))>
              and upper(p.Ppais) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Trim(Arguments.Ppais))#%">
            </cfif>
            <cfif isdefined('Arguments.Pnombre') and LEN(TRIM(Arguments.Pnombre))>
              and upper(p.Pnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Trim(Arguments.Pnombre))#%">
            </cfif>
            group by p.Ppais, p.Pnombre
		</cfquery>
         <cfreturn rslistadoNiveles>
	</cffunction>
<!---=FUNCIÓN QUE RETORNA UN LISTADO DE TODAS LAS DISTRIBUCIONES GEOGRAFICAS=--->
	<cffunction name="fnGetListadoDist"  access="public" returntype="query">
		<cfargument name="Conexion"  	 type="string"   required="no">
        <cfargument name="DGid"  	 	 type="numeric"  required="no">
        <cfargument name="NGid"  	 	 type="numeric"  required="no">
        <cfargument name="DGcodigo"  	 type="string"   required="no">
        <cfargument name="DGDescripcion" type="string"   required="no">
		<cfargument name="Ppais" 		 type="string"   required="no">
        <cfargument name="DGidPadre" 	 type="numeric"  required="no">
		<cfargument name="OrderBy" 	 	 type="string"  required="no" default="1,6">

        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "asp">
		</cfif>

       <cfquery datasource="#Arguments.Conexion#" name="rslistadoDist">
            select p.DGDescripcion as DGDescripcionPadre, n.Ppais, n.NGidPadre, n.NGcodigo, n.CURP,  d.DGid, d.NGid, d.DGcodigo, d.DGDescripcion, d.DGidPadre, d.DGcodigoPostal, d.ts_rversion
            	from DistribucionGeografica d
                	inner join NivelGeografico n
                    	on d.NGid = n.NGid
                     left outer join DistribucionGeografica p
                     	on p.DGid = d.DGidPadre
              where 1 = 1
             <cfif isdefined('Arguments.DGid') and Arguments.DGid neq '-1'>
             	and d.DGid = #Arguments.DGid#
             </cfif>
             <cfif isdefined('Arguments.NGid') and Arguments.NGid neq '-1'>
             	and d.NGid = #Arguments.NGid#
             </cfif>
             <cfif isdefined('Arguments.DGcodigo') and len(trim(Arguments.DGcodigo)) gt 0>
             	and upper(d.DGcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.DGcodigo)#%">
             </cfif>
             <cfif isdefined('Arguments.DGDescripcion') and len(trim(Arguments.DGDescripcion)) gt 0>
             	and upper(d.DGDescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.DGDescripcion)#%">
             </cfif>
			 <cfif isdefined('Arguments.Ppais') and len(trim(Arguments.Ppais)) gt 0>
             	and n.Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
             </cfif>
			 <cfif isdefined('Arguments.DGidPadre') and len(trim(Arguments.DGidPadre)) gt 0>
             	and d.DGidPadre = #Arguments.DGidPadre#
             </cfif>
             order by #Arguments.OrderBy#
		</cfquery>
         <cfreturn rslistadoDist>
	</cffunction>
<!---====================FUNCIÓN PARA CREAR UNA NUEVA DISTRIBUCION GEOGRAFICA====================--->
    <cffunction name="fnAltaDistribucion"  access="public" returntype="numeric">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="NGid" 			type="numeric"  required="yes">
        <cfargument name="DGidPadre" 		type="numeric"  required="no">
        <cfargument name="DGcodigo" 		type="string"   required="yes">
        <cfargument name="DGDescripcion" 	type="string"   required="yes">
		<cfargument name="DGcodigoPostal" 	type="string"   required="yes">

		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
         <cfif NOT isdefined('Arguments.DGidPadre')>
         	<cfset Arguments.DGidPadre = "null">
         </cfif>
         <cfquery datasource="#Arguments.Conexion#" name="existe">
         	select count(1) cantidad
            	from DistribucionGeografica
             where NGid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NGid#">
			    <cfif Arguments.DGidPadre EQ "null">
             	  and DGidPadre is null
				<cfelse>
				  and DGidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGidPadre#">
				</cfif>
               and DGcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DGcodigo#">
         </cfquery>
         <cfif existe.cantidad>
         	<cfthrow message="El código de la Distribución Geográfica (#Arguments.DGcodigo#) ya existe.">
         </cfif>
         <cfquery datasource="#Arguments.Conexion#" name="rsDistribucion">
            insert into DistribucionGeografica (NGid, DGidPadre, DGcodigo, DGDescripcion, DGcodigoPostal, BMUsucodigo, BMfecha)
            values(
                	<cfqueryparam cfsqltype="cf_sql_numeric" 	    value="#Arguments.NGid#">,
                	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.DGidPadre#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.DGcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 	    value="#Arguments.DGDescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	    value="#Arguments.DGcodigoPostal#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	    value="#Arguments.BMUsucodigo#">,
                	<cf_dbfunction name="now">
                )
              <cf_dbidentity1>
         </cfquery>
         	<cf_dbidentity2 name="rsDistribucion">
            <cfreturn rsDistribucion.identity>
    </cffunction>
<!---====================FUNCIÓN PARA MODIFICAR DISTRIBUCION GEOGRAFICA====================--->
     <cffunction name="fnCambioDistribucion"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="DGid" 			type="numeric"  required="yes">
        <cfargument name="NGid" 			type="numeric"  required="yes">
        <cfargument name="DGidPadre" 		type="numeric"  required="no">
        <cfargument name="DGcodigo" 		type="string"   required="yes">
        <cfargument name="DGDescripcion" 	type="string"   required="yes">
        <cfargument name="ts_rversion" 		type="any"  	required="yes">
        <cfargument name="Action" 			type="string"  	required="yes">
		<cfargument name="DGcodigoPostal" 	type="string"  	required="yes">


		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.DGidPadre')>
         	<cfset Arguments.DGidPadre = "null">
         </cfif>
         <cf_dbtimestamp datasource="#Arguments.Conexion#" table="DistribucionGeografica" redirect="#Arguments.Action#?DGid=#Arguments.DGid#"
            timestamp="#Arguments.ts_rversion#"
			field1="DGid,numeric,#Arguments.DGid#">

         <cfquery datasource="#Arguments.Conexion#" name="existe">
         	select count(1) cantidad
            	from DistribucionGeografica
             where NGid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NGid#">
             <cfif Arguments.DGidPadre EQ "null">
             	and DGidPadre is null
             <cfelse>
               and DGidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGidPadre#">
             </cfif>
               and DGcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DGcodigo#">
               and DGid     <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#">
         </cfquery>
         <cfif existe.cantidad>
         	<cfthrow message="El código de la Distribución Geográfica (#Arguments.DGcodigo#) ya existe.">
         </cfif>

         <cfquery datasource="#Arguments.Conexion#">
           update DistribucionGeografica
           set NGid 	     = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.NGid#">,
           	   DGidPadre     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.DGidPadre#">,
               DGcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.DGcodigo#">,
               DGDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.DGDescripcion#">,
			   DGcodigoPostal= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.DGcodigoPostal#">,
               BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
               BMfecha       = <cf_dbfunction name="now">
            where DGid       = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.DGid#">
         </cfquery>
    </cffunction>
<!---====================FUNCIÓN PARA ELIMINAR UNA DISTRIBUCION GEOGRAFICA====================--->
     <cffunction name="fnBajaDistribucion"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="DGid" 			type="numeric"  required="yes">
        <cfargument name="ts_rversion" 		type="any"  	required="yes">
        <cfargument name="Action" 			type="string"  	required="yes">

		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>

        <cf_dbtimestamp datasource="#Arguments.Conexion#" table="DistribucionGeografica" redirect="#Arguments.Action#?DGid=#Arguments.DGid#"
            timestamp="#Arguments.ts_rversion#"
			field1="DGid,numeric,#Arguments.DGid#">

		<cfquery datasource="#Arguments.Conexion#" name="rsLigado">
         	select count(1) as ligado
            	from DistribucionGeografica
             where DGidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#">
         </cfquery>
         <cfif rsLigado.ligado gt 0>
         	<cfthrow message="No se puede eliminar la Distribución Geográfica ya que posee dependencia con otros niveles. Proceso Cancelado!!!">
         </cfif>

         <cfquery datasource="#Arguments.Conexion#">
           delete from DistribucionGeografica
            where DGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#">
         </cfquery>
    </cffunction>
<!---====================FUNCIÓN PARA CREAR UN NUEVO NIVEL GEOGRAFICO====================--->
  	<cffunction name="fnAltaNivel"  access="public" returntype="numeric">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="Ppais" 			type="string"   required="yes">
        <cfargument name="NGcodigo" 		type="string"   required="yes">
        <cfargument name="NGDescripcion" 	type="string"   required="yes">
        <cfargument name="NGidPadre" 		type="numeric"  required="no">
		<cfargument name="CURP" 			type="boolean"  required="no" default="0">

		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
         <cfif NOT isdefined('Arguments.NGidPadre')>
         	<cfset Arguments.NGidPadre = "null">
         </cfif>

		 <cfquery datasource="#Arguments.Conexion#" name="rsExiste">
            select count(1) cantidad
            from NivelGeografico
			where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
           	  and NGcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NGcodigo#">
		</cfquery>
		 <cfif rsExiste.cantidad gt 0>
         	<cfthrow message="El código de la Nivel Geográfico (#Arguments.NGcodigo#) ya existe.">
         </cfif>

         <cfquery datasource="#Arguments.Conexion#" name="rsNiveles">
            insert into NivelGeografico (Ppais,NGcodigo,NGDescripcion,NGidPadre,BMUsucodigo,BMfecha,CURP) values
             (
                <cfqueryparam cfsqltype="cf_sql_varchar" 	   value="#Arguments.Ppais#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" 	   value="#Arguments.NGcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" 	   value="#Arguments.NGDescripcion#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.NGidPadre#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	   value="#Arguments.BMUsucodigo#">,
                <cf_dbfunction name="now">,
				<cfqueryparam cfsqltype="cf_sql_bit" 	  	   value="#Arguments.CURP#">
              )
       		<cf_dbidentity1 datasource="#Arguments.Conexion#">
         </cfquery>
         	<cf_dbidentity2 name="rsNiveles" datasource="#Arguments.Conexion#">
          <cfreturn rsNiveles.identity>
    </cffunction>
<!---====================FUNCIÓN PARA MODIFICAR UN NIVEL GEOGRAFICO====================--->
  	<cffunction name="fnCambioNivel"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="NGid" 			type="numeric"  required="yes">
        <cfargument name="Ppais" 			type="string"   required="yes">
        <cfargument name="NGcodigo" 		type="string"   required="yes">
        <cfargument name="NGDescripcion" 	type="string"   required="yes">
        <cfargument name="NGidPadre" 		type="numeric"  required="no">
		<cfargument name="ts_rversion" 		type="any"  	required="yes">
        <cfargument name="Action" 			type="string"  	required="yes">
        <cfargument name="CURP" 			type="boolean"  required="no" default="0">

		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>

         <cfif NOT isdefined('Arguments.NGidPadre')>
         	<cfset Arguments.NGidPadre = "null">
         </cfif>

         <cf_dbtimestamp datasource="#Arguments.Conexion#" table="NivelGeografico" redirect="#Arguments.Action#?NGid=#Arguments.NGid#"
            timestamp="#Arguments.ts_rversion#"
			field1="NGid,numeric,#Arguments.NGid#">

		<cfquery datasource="#Arguments.Conexion#" name="rsExiste">
            select count(1) cantidad
            from NivelGeografico
			where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
           	  and NGcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NGcodigo#">
			  and NGid <> <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.NGid#">
		</cfquery>
		 <cfif rsExiste.cantidad gt 0>
         	<cfthrow message="El código de la Nivel Geográfico (#Arguments.NGcodigo#) ya existe.">
         </cfif>

         <cfquery datasource="#Arguments.Conexion#" name="rsNiveles">
            update NivelGeografico set
                Ppais 		  = <cfqueryparam cfsqltype="cf_sql_varchar"  		value="#Arguments.Ppais#">,
                NGcodigo 	  = <cfqueryparam cfsqltype="cf_sql_varchar" 	  	value="#Arguments.NGcodigo#">,
                NGDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 	  	value="#Arguments.NGDescripcion#">,
                NGidPadre 	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.NGidPadre#">,
                BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
                BMfecha 	  = <cf_dbfunction name="now">,
				CURP		  = <cfqueryparam cfsqltype="cf_sql_bit" 	  	   value="#Arguments.CURP#">
          where NGid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.NGid#">
         </cfquery>
    </cffunction>
<!---====================FUNCIÓN PARA MODIFICAR UN NIVEL GEOGRAFICO====================--->
  	<cffunction name="fnBajaNivel"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="NGid" 			type="numeric"  required="yes">
		<cfargument name="ts_rversion" 		type="any"  	required="yes">
        <cfargument name="Action" 			type="string"  	required="yes">

		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>

         <cf_dbtimestamp datasource="#Arguments.Conexion#" table="NivelGeografico" redirect="#Arguments.Action#?NGid=#Arguments.NGid#"
            timestamp="#Arguments.ts_rversion#"
			field1="NGid,numeric,#Arguments.NGid#">

		<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsDist">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
			<cfinvokeargument name="NGid" 		value="#Arguments.NGid#">
		</cfinvoke>
		<cfif rsDist.recordcount gt 0>
			<cfthrow message="El nivel a eliminar esta ligado con la Distribución Geográfica, no se puede eliminar el dato. Proceso Cancelado!!!">
		</cfif>
		<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsNivel">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
			<cfinvokeargument name="NGidPadre" 	value="#Arguments.NGid#">
		</cfinvoke>
		<cfif rsNivel.recordcount gt 0>
			<cfthrow message="El nivel a eliminar esta ligado con un nivel inferior, no se puede eliminar el dato. Proceso Cancelado!!!">
		</cfif>
         <cfquery datasource="#Arguments.Conexion#" name="rsNiveles">
            Delete from NivelGeografico
          		where NGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NGid#">
         </cfquery>
    </cffunction>
<!---====================FUNCIÓN PARA PINTAR EL CONLIST DE PAISES====================--->
   <cffunction name="ConlistPaises"  access="public" output="yes">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="formName"  		type="string"   required="no" default="form1">
        <cfargument name="Ppais" 			type="string"   required="no">
		<cfargument name="readonly" 		type="string"   required="no" default="no">
		<cfargument name="NoConfig" 		type="boolean"  required="no" default="false">

        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        <cfif isdefined('Arguments.Ppais') and LEN(TRIM(Arguments.Ppais))>
        	<cfquery datasource="#Arguments.Conexion#" name="rsPais">
                select Ppais, Pnombre
                  from Pais
                where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
			</cfquery>
            <cfset Arguments.valuesArray = ListToArray('#rsPais.Ppais#,#rsPais.Pnombre#')>
		<cfelse>
        	<cfset Arguments.valuesArray = ArrayNew(1)>
        </cfif>
		<cfset filtroNoConfig = "">
		<cfif Arguments.NoConfig>
			<cfset filtroNoConfig = "and (select count(1) from NivelGeografico ng where ng.Ppais = p.Ppais) = 0">
		</cfif>
            <cf_conlis
                campos="Ppais,Pnombre"
                desplegables="S,S"
                modificables="S,N"
                size="2,60"
                title="Lista de Paises"
                valuesArray="#Arguments.valuesArray#"
                tabla="Pais p"
                columnas="Ppais,Pnombre"
                filtro="1=1 #filtroNoConfig# order by Ppais"
                desplegar="Ppais,Pnombre"
                filtrar_por="Ppais,Pnombre"
                etiquetas="Código, País"
                formatos="S,S"
                align="left,left"
                asignar="Ppais,Pnombre"
                asignarformatos="S, S"
                showEmptyListMsg="true"
                EmptyListMsg="-- No se encontraron Países --"
                tabindex="1"
				readonly="#Arguments.readonly#"
                form="#Arguments.formName#"
                conexion = "#Arguments.Conexion#">
    </cffunction>
<!---====================FUNCIÓN PARA PINTAR EL CONLIST DE NIVELES====================--->
     <cffunction name="ConlistNivelesG"  access="public" output="yes">
    	<cfargument name="Conexion"  		 type="string"   required="no">
        <cfargument name="formName"  		 type="string"   required="no" default="form1">
        <cfargument name="sufijo"  		 	 type="string"   required="no" default="">
        <cfargument name="NGcodigoName"  	 type="string"   required="no" default="NGcodigo">
        <cfargument name="NGDescripcionName" type="string"   required="no" default="NGDescripcion">
        <cfargument name="SoloSinRef" 		 type="boolean"  required="no" default="false">
        <cfargument name="SoloEnArbol" 		 type="boolean"  required="no" default="false">
        <cfargument name="NGid" 		 	 type="numeric"  required="no">
        <cfargument name="Ppais" 		 	 type="string"   required="yes">
        <cfargument name="readOnly" 		 type="boolean"  required="no" default="false">
        <cfargument name="Fuction" 		 	 type="string"   required="yes" default="">
		<cfargument name="NGidExcepto" 		 type="numeric"  required="no">
        <cfargument name="isConfig" 		 type="boolean"  required="no" default="false">

        <cfset filtro = "1=1 ">
        <cfif Arguments.SoloSinRef>
        	<cfset conPadreSinHijos  = "((select count(1) from NivelGeografico where NGidPadre =  a.NGid) = 0 and NGidPadre is not null)">
            <cfset sinRaiz   = "(select count(1) from NivelGeografico where NGidPadre is not null">
			<cfif isdefined('Arguments.Ppais') and len(trim(Arguments.Ppais))>
				<cfset sinRaiz   = sinRaiz & " and Ppais = '#Arguments.Ppais#'">
			</cfif>
			<cfset sinRaiz   = sinRaiz & ") = 0">

            <cfset filtro = "("& conPadreSinHijos & ' or ' &sinRaiz&")">
        <cfelseif Arguments.SoloEnArbol>
        	<cfset conPadre = "NGidPadre is not null">
            <cfset conHijos = "(select count(1) from NivelGeografico where NGidPadre =  a.NGid) > 0">
            <cfset filtro   = "(" & conPadre & ' OR '& conHijos & ")">
        </cfif>
       <cfif isdefined('Arguments.NGidExcepto')>
			<cfset filtro = filtro & " and NGid <> #Arguments.NGidExcepto#">
		</cfif>
		<cfif isdefined('Arguments.Ppais') and len(trim(Arguments.Ppais))>
			<cfset filtro = filtro & " and Ppais = '#Arguments.Ppais#'">
		</cfif>
		<cfif isdefined('Arguments.isConfig') and Arguments.isConfig>
			<cfset filtro = filtro & " and 0=1">
		</cfif>

        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        <cfif isdefined('Arguments.NGid') and LEN(TRIM(Arguments.NGid))>
        	<cfquery datasource="#Arguments.Conexion#" name="rsNGid">
                select NGid, NGcodigo, NGDescripcion
                  from NivelGeografico
                where NGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NGid#">
			</cfquery>
            <cfset Arguments.valuesArray = ListToArray('#rsNGid.NGid#,#rsNGid.NGcodigo#,#rsNGid.NGDescripcion#')>
		<cfelse>
        	<cfset Arguments.valuesArray = ArrayNew(1)>
        </cfif>

             <cf_conlis
                campos="NGid#Arguments.sufijo#, NGcodigo#Arguments.sufijo#,NGDescripcion#Arguments.sufijo#"
                desplegables="N,S,S"
                modificables="N,S,N"
                size="0,10,40"
                title="Lista de Niveles Georgráficos"
                valuesArray="#Arguments.valuesArray#"
                tabla="NivelGeografico a"
                columnas="a.NGid as NGid#Arguments.sufijo#, a.NGcodigo as NGcodigo#Arguments.sufijo#,a.NGDescripcion as NGDescripcion#Arguments.sufijo#"
                filtro="(#filtro#) order by NGcodigo"
                desplegar="NGcodigo#Arguments.sufijo#,NGDescripcion#Arguments.sufijo#"
                filtrar_por="NGcodigo,NGDescripcion"
                etiquetas="Código, Descripción"
                formatos="S,S"
                align="left,left"
                asignar="NGid#Arguments.sufijo#, NGcodigo#Arguments.sufijo#,NGDescripcion#Arguments.sufijo#"
                asignarformatos="S, S, S"
                showEmptyListMsg="true"
                EmptyListMsg="-- No se encontraron Niveles Geograficos --"
                tabindex="1"
                form="#Arguments.formName#"
                conexion = "#Arguments.Conexion#"
                readOnly = "#Arguments.readOnly#"
                funcion  = "#Arguments.Fuction#"
                onchange = "#Arguments.Fuction#">
    </cffunction>
<!---====================FUNCIÓN PARA PINTAR EL CONLIST DE Distribuciones====================--->
   <cffunction name="ConlistDistribuciones"  access="public" output="yes">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="formName"  		type="string"   required="no" default="form1">
        <cfargument name="NGid" 			type="numeric"  required="yes">
        <cfargument name="DGidPadre" 		type="numeric"  required="no">
		<cfargument name="readOnly" 		type="boolean"  required="no" default="false">

        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

        <cfquery datasource="#Arguments.Conexion#" name="rsNivel">
            select NGDescripcion
              from NivelGeografico
            where NGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NGid#">
        </cfquery>

		<cfif isdefined('Arguments.DGidPadre')>
             <cfquery datasource="#Arguments.Conexion#" name="rsPadre">
                 select DGid,NGid,DGcodigo,DGDescripcion
                    from DistribucionGeografica
                 where DGid = #Arguments.DGidPadre#
             </cfquery>
             <cfset Arguments.valuesArray = ListToArray('#rsPadre.DGid#,#rsPadre.DGcodigo#,#rsPadre.DGDescripcion#')>
        <cfelse>
             <cfset Arguments.valuesArray = ArrayNew(1)>
        </cfif>

            <cf_conlis
                campos="DGidPadre,DGcodigoPadre,DGDescripcionPadre"
                desplegables="N,S,S"
                modificables="N,S,N"
                size="0,10,40"
                title="Lista de #rsNivel.NGDescripcion#"
                valuesArray="#Arguments.valuesArray#"
                tabla="DistribucionGeografica"
                columnas="DGcodigo,DGDescripcion,DGid as DGidPadre,DGcodigo as DGcodigoPadre,DGDescripcion as DGDescripcionPadre"
                filtro="NGid = #Arguments.NGid# order by DGcodigo"
                desplegar="DGcodigoPadre,DGDescripcion"
                filtrar_por="DGcodigo,DGDescripcion"
                etiquetas="Código, #rsNivel.NGDescripcion#"
                formatos="S,S"
                align="left,left"
                asignar="DGidPadre,DGcodigoPadre,DGDescripcionPadre"
                asignarformatos="S,S, S"
                showEmptyListMsg="true"
                EmptyListMsg="-- No se encontraron Países --"
                tabindex="1"
				readonly="#Arguments.readonly#"
                form="#Arguments.formName#"
                conexion = "#Arguments.Conexion#">
    </cffunction>
<!---====================FUNCIÓN OBTENER LOS NIVELES GEOGRAFICOS====================--->
	<cffunction name="fnGetNiveles" access="public" returntype="query">
    	<cfargument name="Conexion"		type="string"   required="no">
        <cfargument name="NGid"  		type="numeric"  required="no">
		<cfargument name="Ppais"  		type="string"  required="no">
		<cfargument name="NGidPadre"  	type="numeric"  required="no">
		<cfargument name="getRaiz"  	type="boolean"  required="no" default="false">
		<cfargument name="sinConfig"  	type="boolean"  required="no" default="false">

        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

		<cfquery datasource="#Arguments.Conexion#" name="rsNiveles">
			select NGid,Ppais,NGcodigo,NGDescripcion,NGidPadre,CURP,BMfecha,BMUsucodigo,ts_rversion,
				(select count(1) from NivelGeografico sng where sng.NGidPadre = ng.NGid) cantSubNiveles
			from NivelGeografico ng
			where 0=0
			<cfif isdefined('Arguments.NGid')>
				and NGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NGid#">
			</cfif>
			<cfif isdefined('Arguments.Ppais')>
				and Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
			</cfif>
			<cfif isdefined('Arguments.NGidPadre')>
				and NGidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.NGidPadre#">
			</cfif>
			<cfif isdefined('Arguments.getRaiz') and Arguments.getRaiz>
				and NGidPadre is null and (select count(1) from NivelGeografico sng where sng.NGidPadre = ng.NGid) > 0
			<cfelseif isdefined('Arguments.sinConfig') and Arguments.sinConfig>
				and NGidPadre is null and (select count(1) from NivelGeografico sng where sng.NGidPadre = ng.NGid) = 0
			</cfif>
		</cfquery>
     	<cfreturn rsNiveles>
    </cffunction>
<!---====================FUNCIÓN OBTENER LOS PAISES====================--->
<cffunction name="fnGetPaises" access="public" returntype="query">
    	<cfargument name="Conexion"		type="string"   required="no">
		<cfargument name="Ppais"  		type="string"  	required="no">
		<cfargument name="IsConfig"  	type="string"  	required="no" default="false">

        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

		<cfquery datasource="#Arguments.Conexion#" name="rsPaises">
			select distinct p.Ppais, p.Pnombre, p.ts_rversion, p.BMUsucodigo
			from Pais p
				<cfif isdefined('Arguments.IsConfig') and Arguments.IsConfig>
				inner join NivelGeografico ng
					on ng.Ppais = p.Ppais
				</cfif>
			where 0=0
			<cfif isdefined('Arguments.Ppais')>
				Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
			</cfif>
			<cfif isdefined('Arguments.IsConfig') and Arguments.IsConfig>
				and ng.NGidPadre is null and (select count(1) from NivelGeografico sng where sng.NGidPadre = ng.NGid) > 0
			</cfif>
			order by Ppais,Pnombre
		</cfquery>
     	<cfreturn rsPaises>
    </cffunction>

<!---====================FUNCIÓN OBTENER LOS PAISES====================--->
	<cffunction name="fnIsConfigCURP" access="public" returntype="boolean">
    	<cfargument name="Conexion"		type="string"   required="no">
		<cfargument name="Ppais"  		type="string"  	required="yes">

        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>

		<cfquery datasource="#Arguments.Conexion#" name="rsPaises">
			select count(1) isConfig
			from NivelGeografico
			where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
			  and CURP = 1
		</cfquery>
     	<cfreturn rsPaises.isConfig gt 0>
    </cffunction>
</cfcomponent>
