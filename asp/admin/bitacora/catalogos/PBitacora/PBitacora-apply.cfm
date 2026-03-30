<cfparam name="form.PBinactivo" default="0">
<!---►►►Modificacion de la Tabla para bitacora◄◄◄--->
<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="asp" table="PBitacora" redirect="metadata.code.cfm" timestamp="#form.ts_rversion#"
				field1="PBtabla"
				type1="char"
				value1="#form.PBtabla#">

	<cfset addPBitacora(form.PBtabla,form.PBdescripcion,form.PBllaves,form.PBlista,form.PBinactivo,form.PCache)>
	<cflocation url="PBitacora.cfm?PBtabla=#URLEncodedFormat(form.PBtabla)#" addtoken="no">
<!---►►►Eliminación de la Tabla para bitacora◄◄◄--->
<cfelseif IsDefined("form.Baja")>
    <cfloop index = "i" from = "1" to = "3">
		<cfif i eq 1>
			<cfset nombre = 'bitins_'&#form.PBtabla#>
		</cfif>
		<cfif i eq 2>
			<cfset nombre = 'bitupd_'&#form.PBtabla#>
		</cfif>
		<cfif i eq 3>
			<cfset nombre = 'bitdel_'&#form.PBtabla#>
		</cfif>

		<cfquery name="rsval" datasource="#form.PCache#">
			SELECT * FROM sys.triggers WHERE name = <cfqueryparam cfsqltype="cf_sql_char" value="#nombre#">
		</cfquery>
		<cfif rsval.RecordCount gt 0>
			<cftry>
				<cfquery datasource="#form.PCache#">
					drop trigger #nombre#
				</cfquery>
				<cfcatch>
				</cfcatch>
			</cftry>
		</cfif>

	</cfloop>

	<cfquery datasource="asp">
		delete from PBitacora
		where PBtabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PBtabla#" null="#Len(form.PBtabla) Is 0#">
		and PCache = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PCache#">
	</cfquery>
<!---►►►Nueva de la Tabla para bitacora◄◄◄--->
<cfelseif IsDefined("form.Alta")>
  <cfset addPBitacora(form.PBtabla,form.PBdescripcion,form.PBllaves,form.PBlista,form.PBinactivo,form.PCache)>
  <cflocation url="PBitacora.cfm?PBtabla=#URLEncodedFormat(form.PBtabla)#" addtoken="no">
</cfif>

<cflocation url="PBitacora.cfm" addtoken="no">
<cffunction name="addPBitacora" access="public">
	<cfargument name="PBtabla" 		 type="string" required="yes">
    <cfargument name="PBdescripcion" type="string" required="yes">
    <cfargument name="PBllaves" 	 type="string" required="yes">
    <cfargument name="PBlista" 		 type="string" required="yes">
    <cfargument name="PBinactivo" 	 type="string" required="yes" default="0">
	<cfargument name="PCache" 		 type="string" required="yes">

    <cfquery datasource="asp" name="rsPBitacora">
    	select count(1) cantidad
        	from PBitacora
         where PBtabla = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBtabla#">
		    and PCache = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PCache#">
    </cfquery>
    <cfif rsPBitacora.cantidad GT 0>
         <cfquery datasource="asp">
                update PBitacora
                set PBdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBdescripcion#">
                 ,PBllaves 		  = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBllaves#" null="#Len(Arguments.PBllaves) Is 0#">
                 ,PBlista 		  = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBlista#"  null="#Len(Arguments.PBlista) Is 0#">
                 ,PBinactivo 	  = <cfqueryparam cfsqltype="cf_sql_bit"  value="#Arguments.PBinactivo#">
				 ,PCache          = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PCache#">
                 ,BMfechamod 	  = <cf_dbfunction name="now">
                 ,BMUsucodigo 	  = #session.Usucodigo#
                where PBtabla 	  = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBtabla#">
         </cfquery>
    <cfelse>
    	 <cfquery datasource="asp">
            insert into PBitacora (PBtabla,PBdescripcion,PBllaves,PBlista,PBinactivo,BMfechamod, BMUsucodigo)
            values (
                    <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBtabla#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBdescripcion#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBllaves#" null="#Len(Arguments.PBllaves) Is 0#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PBlista#"  null="#Len(Arguments.PBlista)  Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PCache#"  null="#Len(Arguments.PCache)  Is 0#">,
                    <cfqueryparam cfsqltype="cf_sql_bit"  value="#Arguments.PBinactivo#">,
                    <cf_dbfunction name="now">,
                    #session.Usucodigo#
                   )
		</cfquery>
    </cfif>
</cffunction>