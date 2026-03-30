<cfsetting requesttimeout="8600">

<cfset params = 'sel=3&RHTTid=#Form.RHTTid#&modo=#modo#&RHVTid=#form.RHVTid#'>
<!--- FUNCION MODIFIAR MONTOS --->

<cffunction name="modificaMontos" access="private" returntype="void">
	<cfargument name="RHMCid" type="numeric" required="true">
	<cfargument name="RHVTid" type="numeric" required="true">
    <cfargument name="sufijo"  type="string" required="true">
    
	<cfset pre='M'>
	<cfif len(trim(arguments.sufijo)) gt 0>
		<cfset pre='M'>
	</cfif>
    
    <cfif len(trim(Evaluate('RHMCmontoFijo#arguments.RHMCid#'))) eq 0>
    	<cfset Evaluate('RHMCmontoFijo#arguments.RHMCid# = 0')>
	</cfif>
    <cfif len(trim(Evaluate('RHMCmontoPorc#arguments.RHMCid#'))) eq 0>
    	<cfset Evaluate('RHMCmontoPorc#arguments.RHMCid# = 0')>
	</cfif>
    <cfif len(trim(Evaluate('RHMCmonto#arguments.RHMCid#'))) eq 0>
    	<cfset Evaluate('RHMCmonto#arguments.RHMCid# = 0')>
	</cfif>

	<cfquery name="insertM" datasource="#session.DSN#">
		update RHMontosCategoria#arguments.sufijo#
		set 
			RH#pre#CmontoAnt = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('RHMCmontoAnt#arguments.RHMCid#'),',','','all')#">,
			RH#pre#CmontoFijo = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('RHMCmontoFijo#arguments.RHMCid#'),',','','all')#">,
			RH#pre#CmontoPorc = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('RHMCmontoPorc#arguments.RHMCid#'),',','','all')#">,
			RH#pre#Cmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('RHMCmonto#arguments.RHMCid#'),',','','all')#">,
			BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMCid#">
		  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTid#">
	</cfquery>
	<cfreturn>
</cffunction>
<cfif isdefined('form.Modificar')>
	<cftransaction>

        <cfquery datasource="#session.dsn#">
            update RHVigenciasTabla set RHVTtipoformula = #form.formularCalculo#
                where RHVTid = #form.RHVTid#
        </cfquery>
		<cfquery name="rsCategorias" datasource="#session.DSN#">
			select RHMCid
            from RHMontosCategoria a
            inner join RHCategoria b
                on b.RHCid = a.RHCid
            where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<!--- MODIFICACIN DE LOS MONTOS --->
		<cfoutput query="rsCategorias">
			<cfset result = modificaMontos(rsCategorias.RHMCid,form.RHVTid,'')>
		</cfoutput>
	</cftransaction>
<cfelseif  isdefined('form.ModificarA')>
	<cftransaction>
        <cfquery datasource="#session.dsn#">
            update RHVigenciasTabla set RHVTtipoformula = #form.formularCalculo#
                where RHVTid = #form.RHVTid#
        </cfquery>
        <cfquery name="verifT" datasource="#session.DsN#">
            select 1 
            from RHMontosCategoriaT
            where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
        </cfquery>
       
        
        <!--- SI NO EXISTE EL REGISTRO SE INSERTA --->
        <cfif not verifT.RecordCount>
         
            <!--- GUARDA EN LA TABLA DE TRABAJO  --->
            <cfquery name="rs" datasource="#session.DSN#">
               insert RHMontosCategoriaT (RHMCid,RHVTid, RHCid, RHMCmonto,RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo)<!--- fcastro 12-05-12 se cambian los nombres de las columnas, dado que estaban erroneos--->
                select RHMCid,RHVTid, RHCid, RHMCmonto,RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo #">
                from RHMontosCategoria
                where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
            </cfquery>
         <cfelse>
            <cfquery name="rsCategorias" datasource="#session.DSN#">
                select RHMCid
                from RHMontosCategoriaT a
                inner join RHCategoria b
                    on b.RHCid = a.RHCid
                where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
                  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>
            <!--- MODIFICACIN DE LOS MONTOS --->
            <cfoutput query="rsCategorias">
                <cfset result = modificaMontos(rsCategorias.RHMCid,form.RHVTid,'T')>
            </cfoutput>
        </cfif>

<!--- 
se crea una tabla de trabajo
se 
se modifica la misma tabla
SE GUARDA EL HISTORICO
SE MODIFICA EL ACTUAL
SE DEBE DE IDENTIFICAR QUE LA TABLA ESTA EN MODIFICACION, CREANDO UN NUEVO REGISTRO CON UN ESTADO, Y SE TIENE PONER EN LAS CONSULTAS QUE LO REQUIERAN
EL ESTADO QUE SE PUEDA UTILIZAR ES EL ACTIVO 'A', MODIFICANDO 'M', HISTORICO 'H'
 --->
<!--- <cf_dumptable var="RHMontosCategoriaT"> --->
	</cftransaction> 
<cfelseif isdefined('Eliminar')>
	<cfquery datasource="#session.DsN#">
    	delete RHMontosCategoriaT
        where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
    </cfquery>
</cfif>
<cflocation url="tipoTablasSal.cfm?#params#">
