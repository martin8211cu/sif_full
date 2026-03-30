<cfcomponent>
 
<!---=FUNCIÓN QUE RETORNA UN LISTADO DE TODAS LAS UnidadES GEOGRAFICAS=--->
	<cffunction name="fnGetListadoUnidades"  access="public" returntype="query">
		<cfargument name="Conexion"  	 type="string"   required="no">
        <cfargument name="UGid"  	 	 type="numeric"  required="no">
        <cfargument name="AGid"  	 	 type="numeric"  required="no">
        <cfargument name="UGcodigo"  	 type="string"   required="no">
        <cfargument name="UGdescripcion" type="string"   required="no">
		<cfargument name="Ppais" 		 type="string"   required="no">
        <cfargument name="UGidpadre" 	 type="numeric"  required="no">
		<cfargument name="OrderBy" 	 	 type="string"  required="no" default="1,6">
		
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "asp">
		</cfif>
       <cf_translatedata name="get" conexion="#arguments.Conexion#" idioma="#arguments.idioma#" tabla="UnidadGeografica" col="p.UGdescripcion" returnvariable="LvarUGdescripcion">
       <cf_translatedata name="get" conexion="#arguments.Conexion#" idioma="#arguments.idioma#" tabla="UnidadGeografica" col="d.UGdescripcion" returnvariable="LvarUGdescripcio2">
       <cfquery datasource="#Arguments.Conexion#" name="rslistadoDist">
            select #LvarUGdescripcion# as UGdescripcionPadre, d.Ppais, n.AGidPadre, n.AGcodigo,   d.UGid, d.AGid, d.UGcodigo, #LvarUGdescripcio2# as UGdescripcion, d.UGidpadre, d.ts_rversion
            	from UnidadGeografica d
                	inner join AreaGeografica n
                    	on d.AGid = n.AGid
                     left outer join UnidadGeografica p
                     	on p.UGid = d.UGidpadre
              where 1 = 1
             <cfif isdefined('Arguments.UGid') and Arguments.UGid neq '-1'>
             	and d.UGid = #Arguments.UGid#
             </cfif> 
             <cfif isdefined('Arguments.AGid') and Arguments.AGid neq '-1'>
             	and d.AGid = #Arguments.AGid#
             </cfif> 
             <cfif isdefined('Arguments.UGcodigo') and len(trim(Arguments.UGcodigo)) gt 0>
             	and upper(d.UGcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.UGcodigo)#%">
             </cfif>
             <cfif isdefined('Arguments.UGdescripcion') and len(trim(Arguments.UGdescripcion)) gt 0>
             	and upper(#LvarUGdescripcio2#) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.UGdescripcion)#%">
             </cfif>
			 <cfif isdefined('Arguments.Ppais') and len(trim(Arguments.Ppais)) gt 0>
             	and d.Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
             </cfif>
			 <cfif isdefined('Arguments.UGidpadre') and len(trim(Arguments.UGidpadre)) gt 0>
             	and d.UGidpadre = #Arguments.UGidpadre#
             </cfif>
             order by #Arguments.OrderBy#
		</cfquery>
         <cfreturn rslistadoDist>
	</cffunction>
<!---====================FUNCIÓN PARA CREAR UNA NUEVA Unidad GEOGRAFICA====================--->
    <cffunction name="fnAltaUnidad"  access="public" returntype="numeric">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="AGid" 			type="numeric"  required="yes">
        <cfargument name="UGidpadre" 		type="numeric"  required="no">
        <cfargument name="UGcodigo" 		type="string"   required="yes">
        <cfargument name="UGdescripcion" 	type="string"   required="yes">
		<cfargument name="UGcodigoPostal" 	type="string"   required="no">
        <cfargument name="idioma" 	type="string"   required="yes">
            
		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        
        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
         <cfif NOT isdefined('Arguments.UGidpadre')>
         	<cfset Arguments.UGidpadre = "null">
         </cfif>
         <cfquery datasource="#Arguments.Conexion#" name="existe">
         	select count(1) cantidad 
            	from UnidadGeografica
             where AGid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
			    <cfif Arguments.UGidpadre EQ "null">
             	  and UGidpadre is null
				<cfelse>
				  and UGidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.UGidpadre#">
				</cfif>
               and UGcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.UGcodigo#">
         </cfquery>
         <cfif existe.cantidad>
         	<cf_errorcode code="50019" msg="El código del registro ya existe">
         </cfif>
         <cfset LvarNGPath = 'RAIZ'&'/'&trim(Arguments.UGcodigo)>
         <cfif len(trim(arguments.UGidpadre)) and ucase(arguments.UGidpadre) neq 'NULL'>
         	<cfquery datasource="#Arguments.Conexion#" name="rsPathPadre">
         		select UGpath from UnidadGeografica where UGid = #arguments.UGidpadre#
            </cfquery>
           <cfset LvarNGPath = trim(rsPathPadre.UGpath)&'/'&trim(Arguments.UGcodigo)>
         </cfif>
         <cfquery datasource="#Arguments.Conexion#" name="rsUnidad">
            insert into UnidadGeografica (AGid, UGidpadre, UGcodigo, UGdescripcion, BMUsucodigo,<cfif len(trim(LvarNGPath))>UGpath</cfif>) 
            values(
                	<cfqueryparam cfsqltype="cf_sql_numeric" 	    value="#Arguments.AGid#">,
                	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.UGidpadre#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.UGcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" 	    value="#Arguments.UGdescripcion#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	    value="#Arguments.BMUsucodigo#">
                    <cfif len(trim(LvarNGPath))>
	                   , <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarNGPath)#">
                    </cfif>
                )
              <cf_dbidentity1>
         </cfquery>  
         	<cf_dbidentity2 name="rsUnidad" datasource="#Arguments.Conexion#" >
            <cf_translatedata name="set" idioma="#arguments.idioma#" tabla="UnidadGeografica" col="UGdescripcion" valor="#Arguments.UGdescripcion#" conexion="asp" filtro="UGid = # rsUnidad.identity#">
            <cfreturn rsUnidad.identity>
    </cffunction>
<!---====================FUNCIÓN PARA MODIFICAR Unidad GEOGRAFICA====================--->
     <cffunction name="fnCambioUnidad"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="UGid" 			type="numeric"  required="yes">
        <cfargument name="AGid" 			type="numeric"  required="yes">
        <cfargument name="UGidpadre" 		type="numeric"  required="no">
        <cfargument name="UGcodigo" 		type="string"   required="yes">
        <cfargument name="UGdescripcion" 	type="string"   required="yes">
        <cfargument name="Action" 			type="string"  	required="yes">
        <cfargument name="idioma" 	type="string"   required="yes">
		
            
		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        
        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.UGidpadre')>
         	<cfset Arguments.UGidpadre = "null">
         </cfif>

         <cfquery datasource="#Arguments.Conexion#" name="existe">
         	select count(1) cantidad 
            	from UnidadGeografica
             where AGid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
             <cfif Arguments.UGidpadre EQ "null">
             	and UGidpadre is null
             <cfelse>
               and UGidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.UGidpadre#">
             </cfif>
               and UGcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.UGcodigo#">
               and UGid     <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.UGid#">
         </cfquery>
         <cfif existe.cantidad>
         	<cf_errorcode code="50019" msg="El código del registro ya existe">
         </cfif>
        
         <cfset LvarNGPath = 'RAIZ'&'/'&trim(Arguments.UGcodigo)>
         <cfif len(trim(arguments.UGidpadre))  and ucase(arguments.UGidpadre) neq 'NULL'> 
         	<cfquery datasource="#Arguments.Conexion#" name="rsPathPadre">
         		select UGpath from UnidadGeografica where UGid = #arguments.UGidpadre#
            </cfquery>
            <cfset LvarNGPath = trim(rsPathPadre.UGpath)&'/'&trim(Arguments.UGcodigo)>
         </cfif>
         <cfquery datasource="#Arguments.Conexion#" name="rsValidaCambioCodigo">
         	select UGpath,UGcodigo from UnidadGeografica 
            where UGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.UGid#">
            	and rtrim(ltrim(UGcodigo)) != <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.UGcodigo#">
         </cfquery >
         <cfif len(trim(rsValidaCambioCodigo.UGpath))> 
             <cfquery datasource="#Arguments.Conexion#">
                update UnidadGeografica
                set UGpath = <cf_dbfunction name="sReplace"	args="UGpath,'#trim(rsValidaCambioCodigo.UGpath)#','#LvarNGPath#'" datasource="#Arguments.Conexion#"> 
                where UGpath like '%#trim(rsValidaCambioCodigo.UGpath)#%'
             </cfquery> 
         </cfif>
         
         <cfquery datasource="#Arguments.Conexion#">
           update UnidadGeografica 
           set AGid 	     = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AGid#">, 
           	   UGidpadre     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.UGidpadre#">,
               UGcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.UGcodigo#">, 
               UGdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.UGdescripcion#">, 
               BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
            where UGid       = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.UGid#">
         </cfquery>  
         <cf_translatedata name="set" idioma="#arguments.idioma#" tabla="UnidadGeografica" col="UGdescripcion" valor="#Arguments.UGdescripcion#" conexion="asp" filtro="UGid = #Arguments.UGid#">
    </cffunction>
<!---====================FUNCIÓN PARA ELIMINAR UNA Unidad GEOGRAFICA====================--->
     <cffunction name="fnBajaUnidad"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="UGid" 			type="numeric"  required="yes">
        <cfargument name="Action" 			type="string"  	required="yes">
        
		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        
        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
        
		<cfquery datasource="#Arguments.Conexion#" name="rsLigado">
         	select count(1) as ligado 
            	from UnidadGeografica
             where UGidpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.UGid#">
         </cfquery>
         <cfif rsLigado.ligado gt 0>
            <cf_errorcode code="50581" msg="No se puede eliminar porque tiene datos asociados">
         </cfif>
		 
         <cfquery datasource="#Arguments.Conexion#">
           delete from UnidadGeografica 
            where UGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.UGid#">
         </cfquery>  
    </cffunction>
<!---====================FUNCIÓN PARA CREAR UN NUEVO Area GEOGRAFICO====================--->
  	<cffunction name="fnAltaArea"  access="public" returntype="numeric">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="AGcodigo" 		type="string"   required="yes">
        <cfargument name="AGdescripcion" 	type="string"   required="yes">
        <cfargument name="AGidPadre" 		type="numeric"  required="no">
        <cfargument name="AGesconsultable" 	type="boolean"  required="no" default="0">
        <cfargument name="idioma" 	type="string"   required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        
        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
         <cfif NOT isdefined('Arguments.AGidPadre')>
         	<cfset Arguments.AGidPadre = "null">
         </cfif>
		 
		 <cfquery datasource="#Arguments.Conexion#" name="rsExiste">
            select count(1) cantidad
            from AreaGeografica
			where AGcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGcodigo#">
		</cfquery>
		 <cfif rsExiste.cantidad gt 0>
         	<cf_errorcode code="50019" msg="El código del registro ya existe">
         </cfif>
		 
         <cfquery datasource="#Arguments.Conexion#" name="rsAreas">
            insert into AreaGeografica (AGcodigo,AGdescripcion,AGidPadre,BMUsucodigo,AGesconsultable) values
             (
                <cfqueryparam cfsqltype="cf_sql_varchar" 	   value="#Arguments.AGcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" 	   value="#Arguments.AGdescripcion#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.AGidPadre#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	   value="#Arguments.BMUsucodigo#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" 	   value="#iif(arguments.AGesconsultable,1,0)#">
              )
       		<cf_dbidentity1 datasource="#Arguments.Conexion#">
         </cfquery>  
         	<cf_dbidentity2 name="rsAreas" datasource="#Arguments.Conexion#">
            <cf_translatedata name="set" idioma="#arguments.idioma#" tabla="AreaGeografica" col="AGdescripcion" valor="#Arguments.AGdescripcion#" conexion="asp" filtro="AGid = #rsAreas.identity#">
          <cfreturn rsAreas.identity>
    </cffunction>   
<!---====================FUNCIÓN PARA MODIFICAR UN Area GEOGRAFICO====================--->
  	<cffunction name="fnCambioArea"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="AGid" 			type="numeric"  required="yes">
        <cfargument name="AGcodigo" 		type="string"   required="yes">
        <cfargument name="AGdescripcion" 	type="string"   required="yes">
        <cfargument name="AGidPadre" 		type="numeric"  required="no">
		<cfargument name="ts_rversion" 		type="any"  	required="yes">
        <cfargument name="Action" 			type="string"  	required="yes"> 
        <cfargument name="AGesconsultable" 	type="boolean"  required="no" default="0">
        <cfargument name="idioma" 	type="string"   required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        
        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
        
         <cfif NOT isdefined('Arguments.AGidPadre')>
         	<cfset Arguments.AGidPadre = "null">
         </cfif>
        
         <cf_dbtimestamp datasource="#Arguments.Conexion#" table="AreaGeografica" redirect="#Arguments.Action#?AGid=#Arguments.AGid#"
            timestamp="#Arguments.ts_rversion#"
			field1="AGid,numeric,#Arguments.AGid#">
        
		<cfquery datasource="#Arguments.Conexion#" name="rsExiste">
            select count(1) cantidad
            from AreaGeografica
			where AGcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGcodigo#">
			  and AGid <> <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AGid#">
		</cfquery>
		 <cfif rsExiste.cantidad gt 0>
         	<cf_errorcode code="50019" msg="El código del registro ya existe">
         </cfif>
		 
         <cfquery datasource="#Arguments.Conexion#" name="rsAreas">
            update AreaGeografica set 
                AGcodigo 	  = <cfqueryparam cfsqltype="cf_sql_varchar" 	  	value="#Arguments.AGcodigo#">,
                AGdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" 	  	value="#Arguments.AGdescripcion#">,
                AGidPadre 	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.AGidPadre#">,
                BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
                AGesconsultable = <cfqueryparam cfsqltype="cf_sql_integer" 	   value="#iif(arguments.AGesconsultable,1,0)#">
          where AGid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AGid#">
         </cfquery>  
         <cf_translatedata name="set" idioma="#arguments.idioma#" tabla="AreaGeografica" col="AGdescripcion" valor="#Arguments.AGdescripcion#" conexion="asp" filtro="AGid = #arguments.AGid#">
    </cffunction>   
<!---====================FUNCIÓN PARA MODIFICAR UN Area GEOGRAFICO====================--->
  	<cffunction name="fnBajaArea"  access="public">
    	<cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no">
        <cfargument name="AGid" 			type="numeric"  required="yes">
		<cfargument name="ts_rversion" 		type="any"  	required="yes">
        <cfargument name="Action" 			type="string"  	required="yes">
        <cfargument name="Idioma"           type="string"   required="yes" default="#session.dsn#">
        
		<cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        
        <cfif not isdefined('Arguments.BMUsucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
        
         <cf_dbtimestamp datasource="#Arguments.Conexion#" table="AreaGeografica" redirect="#Arguments.Action#?AGid=#Arguments.AGid#"
            timestamp="#Arguments.ts_rversion#"
			field1="AGid,numeric,#Arguments.AGid#">
        
		<cfinvoke component="asp.Geografica.componentes.AreaGeografica" method="fnGetListadoUnidades" returnvariable="rsDist">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
			<cfinvokeargument name="AGid" 		value="#Arguments.AGid#">
            <cfinvokeargument name="idioma"       value="#Arguments.idioma#">
		</cfinvoke>
		<cfif rsDist.recordcount gt 0>
            <cf_errorcode code="50581" msg="No se puede eliminar porque tiene datos asociados">
		</cfif>
		<cfinvoke component="asp.Geografica.componentes.AreaGeografica" method="fnGetAreas" returnvariable="rsArea">
			<cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
			<cfinvokeargument name="AGidPadre" 	value="#Arguments.AGid#">
             <cfinvokeargument name="idioma"       value="#Arguments.idioma#">
		</cfinvoke>
		<cfif rsArea.recordcount gt 0>
			<cf_errorcode code="50581" msg="No se puede eliminar porque tiene datos asociados">
		</cfif>
         <cfquery datasource="#Arguments.Conexion#" name="rsAreas">
            Delete from AreaGeografica 
          		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
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
			<cfset filtroNoConfig = "and (select count(1) from AreaGeografica ng where ng.Ppais = p.Ppais) = 0">
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
<!---====================FUNCIÓN PARA PINTAR EL CONLIST DE Areas====================---> 		
     <cffunction name="ConlistAreasG"  access="public" output="yes">
    	<cfargument name="Conexion"  		 type="string"   required="no"> 
        <cfargument name="formName"  		 type="string"   required="no" default="form1"> 
        <cfargument name="sufijo"  		 	 type="string"   required="no" default=""> 
        <cfargument name="AGcodigoName"  	 type="string"   required="no" default="AGcodigo"> 
        <cfargument name="AGdescripcionName" type="string"   required="no" default="AGdescripcion"> 
        <cfargument name="SoloSinRef" 		 type="boolean"  required="no" default="false"> 
        <cfargument name="SoloEnArbol" 		 type="boolean"  required="no" default="false"> 
        <cfargument name="AGid" 		 	 type="numeric"  required="no">
        <cfargument name="readOnly" 		 type="boolean"  required="no" default="false"> 
        <cfargument name="Fuction" 		 	 type="string"   required="yes" default=""> 
		<cfargument name="AGidExcepto" 		 type="numeric"  required="no">
        <cfargument name="isConfig" 		 type="boolean"  required="no" default="false">
        <cfargument name="idioma" 		 	type="string"  required="yes">
		
        <cfset filtro = "1=1 ">
        <cfif Arguments.SoloSinRef>
        	<cfset conPadreSinHijos  = "((select count(1) from AreaGeografica where AGidPadre =  a.AGid) = 0 and AGidPadre is not null)">
            <cfset sinRaiz   = "(select count(1) from AreaGeografica where AGidPadre is not null">
			<cfif isdefined('Arguments.Ppais') and len(trim(Arguments.Ppais))>
				<cfset sinRaiz   = sinRaiz & " and Ppais = '#Arguments.Ppais#'">
			</cfif>
			<cfset sinRaiz   = sinRaiz & ") = 0">
			
            <cfset filtro = "("& conPadreSinHijos & ' or ' &sinRaiz&")">
        <cfelseif Arguments.SoloEnArbol>
        	<cfset conPadre = "AGidPadre is not null">
            <cfset conHijos = "(select count(1) from AreaGeografica where AGidPadre =  a.AGid) > 0">
            <cfset filtro   = "(" & conPadre & ' OR '& conHijos & ")">
        </cfif>
       <cfif isdefined('Arguments.AGidExcepto')>
			<cfset filtro = filtro & " and AGid <> #Arguments.AGidExcepto#">
		</cfif> 
		<cfif isdefined('Arguments.isConfig') and Arguments.isConfig>
			<cfset filtro = filtro & " and 0=1">
		</cfif>
		
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        <cfif isdefined('Arguments.AGid') and LEN(TRIM(Arguments.AGid))>
        	<cf_translatedata name="get" tabla="AreaGeografica" col="AGdescripcion" conexion="asp" returnvariable="LvarAGdescripcion">
        	<cfquery datasource="#Arguments.Conexion#" name="rsAGid">
                select AGid, AGcodigo, #LvarAGdescripcion# as AGdescripcion
                  from AreaGeografica
                where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
			</cfquery>
            <cfset Arguments.valuesArray = ListToArray('#rsAGid.AGid#,#rsAGid.AGcodigo#,#rsAGid.AGdescripcion#')>
		<cfelse>
        	<cfset Arguments.valuesArray = ArrayNew(1)>
        </cfif>
     		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListaDeAreasGeograficos" 
            default="Lista de Areas Geográficos"
            returnvariable="LB_ListaDeAreasGeograficos" xmlFile="/asp/Geografica/Catalogos/AreaGeografica.xml"/>
            
            <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Codigo" 
            default="Código"
            returnvariable="LB_Codigo" xmlFile="/rh/generales.xml"/>
            
            <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" 
            default="Descripción"
            returnvariable="LB_Descripcion" xmlFile="/rh/generales.xml"/>
            <cf_translatedata name="get" tabla="AreaGeografica" col="a.AGdescripcion" returnvariable="LvarAGdescripcion" conexion="asp">
 
             <cf_conlis
                campos="AGid#Arguments.sufijo#, AGcodigo#Arguments.sufijo#,AGdescripcion#Arguments.sufijo#"
                desplegables="N,S,S"
                modificables="N,S,N"
                size="0,10,40"
                title="#LB_ListaDeAreasGeograficos#"
                valuesArray="#Arguments.valuesArray#"
                tabla="AreaGeografica a"
                columnas="a.AGid as AGid#Arguments.sufijo#, a.AGcodigo as AGcodigo#Arguments.sufijo#,#LvarAGdescripcion# as AGdescripcion#Arguments.sufijo#"
                filtro="(#filtro#) order by AGcodigo"
                desplegar="AGcodigo#Arguments.sufijo#,AGdescripcion#Arguments.sufijo#"
                filtrar_por="AGcodigo,#LvarAGdescripcion#"
                filtrar_por_delimiters="|"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"
                asignar="AGid#Arguments.sufijo#, AGcodigo#Arguments.sufijo#,AGdescripcion#Arguments.sufijo#"
                asignarformatos="S, S, S"
                showEmptyListMsg="true"
                tabindex="1"
                form="#Arguments.formName#"
                conexion = "#Arguments.Conexion#"
                readOnly = "#Arguments.readOnly#"
                funcion  = "#Arguments.Fuction#"
                onchange = "#Arguments.Fuction#">				     
    </cffunction>
<!---====================FUNCIÓN PARA PINTAR EL CONLIST DE Unidades====================---> 
   <cffunction name="ConlistUnidades"  access="public" output="yes">
    	<cfargument name="Conexion"  		type="string"   required="no"> 
        <cfargument name="formName"  		type="string"   required="no" default="form1"> 
        <cfargument name="UGid" 		type="numeric"  required="no">
        <cfargument name="AGid" 		type="numeric"  required="no">
		<cfargument name="readOnly" 		type="boolean"  required="no" default="false"> 
        <cfargument name="idioma" 		 	type="string"  required="yes">
         
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
        <cfset filtroArea='1=1'>
        <!---- si viene definida el área, se pinta los padre de niveles superiores segun la estructura de areas geograficas--->
        <cfif isdefined("arguments.AGid") and arguments.AGid>
        	  <cfquery datasource="#Arguments.Conexion#" name="rsPadreArea">
                 select AGidPadre
                 from AreaGeografica
                 where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
             </cfquery>
             <cfif len(trim(rsPadreArea.AGidPadre))>
             	<cfset filtroArea=' AGid in ('&valuelist(rsPadreArea.AGidPadre)&')'>
             </cfif>
        </cfif>   
		<cfif isdefined('Arguments.UGid') and Arguments.UGid>
            <cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="UGdescripcion" returnvariable="LvarUGdescripcion">
             <cfquery datasource="#Arguments.Conexion#" name="rsPadre">
                 select UGid,AGid,UGcodigo,#LvarUGdescripcion# as UGdescripcion
                    from UnidadGeografica
                 where UGid = #Arguments.UGid#
             </cfquery>
             <cfset Arguments.valuesArray = ListToArray('#rsPadre.UGid#,#rsPadre.UGcodigo#,#rsPadre.UGdescripcion#')>
        <cfelse>
             <cfset Arguments.valuesArray = ArrayNew(1)>
        </cfif>
 
      		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListaDeUnidades" 
            default="Lista de Unidades"
            returnvariable="LB_ListaDeUnidades" xmlFile="/asp/Geografica/Catalogos/AreaGeografica.xml"/>
            
            <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Codigo" 
            default="Código"
            returnvariable="LB_Codigo" xmlFile="/rh/generales.xml"/>
            
            <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" 
            default="Descripción"
            returnvariable="LB_Descripcion" xmlFile="/rh/generales.xml"/>
            

            <cf_translatedata name="get" tabla="UnidadGeografica" col="UGdescripcion" returnvariable="LvarUGdescripcion" Conexion="asp">

            <cf_conlis
                campos="UGidpadre,UGcodigoPadre,UGdescripcionPadre"
                desplegables="N,S,S"
                modificables="N,S,N"
                size="0,10,40"
                title="#LB_ListaDeUnidades#"
                valuesArray="#Arguments.valuesArray#"
                tabla="UnidadGeografica"
                columnas="UGcodigo,#LvarUGdescripcion# as UGdescripcion,UGid as UGidpadre,UGcodigo as UGcodigoPadre,UGdescripcion as UGdescripcionPadre"
                filtro="#filtroArea# order by UGcodigo"
                desplegar="UGcodigoPadre,UGdescripcion"
                filtrar_por="UGcodigo|#LvarUGdescripcion#"
                filtrar_por_delimiters="|"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"
             
                asignar="UGidpadre,UGcodigoPadre,UGdescripcionPadre"
                asignarformatos="S,S, S"
                showEmptyListMsg="true"
                tabindex="1"
				readonly="#Arguments.readonly#"
                form="#Arguments.formName#"
                TranslateDataCols="UGdescripcion"
                conexion = "#Arguments.Conexion#">	
    </cffunction>  
<!---====================FUNCIÓN OBTENER LOS Areas GEOGRAFICOS====================---> 	
	<cffunction name="fnGetAreas" access="public" returntype="query">
    	<cfargument name="Conexion"		type="string"   required="no"> 
        <cfargument name="AGid"  		type="numeric"  required="no">
		<cfargument name="AGidPadre"  	type="numeric"  required="no">
		<cfargument name="getRaiz"  	type="boolean"  required="no" default="false">
		<cfargument name="sinConfig"  	type="boolean"  required="no" default="false"> 
        <cfargument name="idioma"  		type="string"   required="yes"> 
    
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "asp">
        </cfif>
		<cf_translatedata name="get" tabla="AreaGeografica" conexion="asp" col="AGdescripcion" idioma="#arguments.idioma#" returnvariable="LvarAGdescripcion"> 
		<cfquery datasource="#Arguments.Conexion#" name="rsAreas">
			select AGid,AGcodigo, #LvarAGdescripcion# as AGdescripcion,AGidPadre,BMUsucodigo,ts_rversion,
				(select count(1) from AreaGeografica sng where sng.AGidPadre = ng.AGid)as cantSubAreas,coalesce(ng.AGesconsultable,0) as AGesconsultable
			from AreaGeografica ng
			where 0=0
			<cfif isdefined('Arguments.AGid')>
				and AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
			</cfif>
			<cfif isdefined('Arguments.AGidPadre')>
				and AGidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGidPadre#">
			</cfif>
			<cfif isdefined('Arguments.getRaiz') and Arguments.getRaiz>
				and AGidPadre is null <!----and (select count(1) from AreaGeografica sng where sng.AGidPadre = ng.AGid) > 0----->
			<!---<cfelseif isdefined('Arguments.sinConfig') and Arguments.sinConfig>
				and AGidPadre is null and (select count(1) from AreaGeografica sng where sng.AGidPadre = ng.AGid) = 0---->
			</cfif>
		</cfquery> 
     	<cfreturn rsAreas>	     
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
				inner join AreaGeografica ng
					on ng.Ppais = p.Ppais
				</cfif>
			where 0=0
			<cfif isdefined('Arguments.Ppais')>
				Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ppais#">
			</cfif>
			<cfif isdefined('Arguments.IsConfig') and Arguments.IsConfig>
				and ng.AGidPadre is null and (select count(1) from AreaGeografica sng where sng.AGidPadre = ng.AGid) > 0
			</cfif>
			order by p.Ppais,Pnombre
		</cfquery>
     	<cfreturn rsPaises>	     
    </cffunction>  		

<cffunction name="getHijos" returntype="string" hint="Devuelve todos los hijos de una Unidad geografica, utiliza el path">
  <cfargument name="lista" type="string" required="true">
          <cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="UGdescripcion" returnvariable="LvarUGdescripcion">
          <cfquery datasource="asp" name="rsPaths">
            select UGpath, #LvarUGdescripcion# as UGdescripcion from UnidadGeografica where UGid in (#arguments.lista#)
          </cfquery>
          <cfquery datasource="asp" name="rsPathsH">
            select distinct UGid
            from UnidadGeografica 
            where 1=2
            <cfloop query="rsPaths">
                or UGpath like '#rsPaths.UGpath#%'
            </cfloop>
          </cfquery>
         <cfreturn valuelist(rsPathsH.UGid)>
</cffunction>

<cffunction name="fnGetListadoUnidadesRemote"  output="no" access="remote" returntype="array" returnformat="json" >
    <cfargument name="UGidpadre" 	 type="numeric"  required="no">
   <cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="x.UGdescripcion" returnvariable="LvarUGdescripcion">
   <cfquery datasource="asp" name="rslistadoDist">
        select x.UGid,x.UGcodigo,#LvarUGdescripcion# as UGdescripcion, case when (select count(1)
                                                 from UnidadGeografica
                                                 where UGidpadre = x.UGid
                                             )> 0 then 1 else 0 end esPadre
        from UnidadGeografica x
        where x.UGidpadre = #Arguments.UGidpadre#
    </cfquery>
 
    <cfset returnArray = ArrayNew(1)>
    <cfloop  query="rslistadoDist">
        <cfset x = StructNew()>
        <cfset x["key"]=UGid>
        <cfset x["label"]=UGdescripcion>
        <cfset x["esPadre"]=esPadre>
        <cfset ArrayAppend(returnArray,x)>
    </cfloop>
    <cfreturn returnArray>
</cffunction>  

</cfcomponent>