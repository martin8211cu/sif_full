
<cfset params = 'sel=3&RHTTid=#Form.RHTTid#&modo=#modo#&RHVTid=#form.RHVTid#'>
<!--- FUNCION MODIFIAR MONTOS --->
<cffunction name="modificaMontos" access="private" returntype="void">
	<cfargument name="RHMCid" type="numeric" required="true">
	<cfargument name="RHVTid" type="numeric" required="true">
    <cfargument name="sufijo"  type="string" required="true">
    
	<cfquery name="insertM" datasource="#session.DSN#">
		update RHMontosCategoria#arguments.sufijo#
		set 
			<cfif len(trim(arguments.sufijo)) gt 0><!---- fcastro 21/5/12 se realiza este if dado que dependiendo del sufijo los nombres en la base de datos cambia--->
			RHCmontoFijo = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('RHMCmontoFijo#arguments.RHMCid#'),',','','all')#">,
			RHCmontoAnt = <cfqueryparam cfsqltype="cf_sql_money" value="#round(Replace(Evaluate('RHMCmontoAnt#arguments.RHMCid#'),',','','all'))#">,
			<cfelse>
			RHMCmontoFijo = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Evaluate('RHMCmontoFijo#arguments.RHMCid#'),',','','all')#">,
			RHMCmontoAnt = <cfqueryparam cfsqltype="cf_sql_money" value="#round(Replace(Evaluate('RHMCmontoAnt#arguments.RHMCid#'),',','','all'))#">,
			</cfif>	
			BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo #">
		where RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMCid#">
		  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTid#">
	</cfquery>
	<cfreturn>
</cffunction>
<cfif isdefined('form.Modificar')>
	<cftransaction>
		<cfquery name="rsCategorias" datasource="#session.DSN#">
			select RHMCid
            from RHMontosCategoria a
            inner join RHCategoria b
                on b.RHCid = a.RHCid
            where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<!--- MODIFICACIÓN DE LOS MONTOS --->
		<cfoutput query="rsCategorias">
			<cfset result = modificaMontos(rsCategorias.RHMCid,form.RHVTid,'')>
		</cfoutput>
	</cftransaction>
<cfelseif  isdefined('form.ModificarA')>
	<cftransaction>
        <cfquery name="verifT" datasource="#session.DsN#">
            select 1 
            from RHMontosCategoriaT
            where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
        </cfquery>
        <!--- SI NO EXISTE EL REGISTRO SE INSERTA --->
        <cfif not verifT.RecordCount>
            <!--- GUARDA EN LA TABLA DE TRABAJO  --->
            <cfquery name="rs" datasource="#session.DSN#">
               insert RHMontosCategoriaT (RHMCid,RHVTid, RHCid, RHCmonto,RHCmontoAnt, RHCmontoFijo,RHCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo)<!--- fcastro 12-05-12 se cambian los nombres de las columnas, dado que estaban erroneos--->
                select RHMCid,RHVTid, RHCid, RHMCmonto,RHMCmonto, 0,0,CSid,
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
            <!--- MODIFICACIÓN DE LOS MONTOS --->
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