<cfif isdefined("Form.BOTONSEL") and isdefined("Form.CHK")>
	<cfset ListCHK = ListToArray(#Form.CHK#,',')>
	<cfset num = 0>
	<cfset ArrayTable=ArrayNew(1)>
	<cfset ListTable = ''>
	<cfset cache = ''>
	<cfloop array="#ListCHK#" index="i">
		<cfset ArrayCHK = ListToArray(#i#,'|')>
		<cfset form.dsn = Trim(ArrayCHK[2])>
		<cfset dbtype = Application.dsinfo[form.dsn].type>
		<cfif dbtype is 'sqlserver'>
			<cfset pk = ''>
			<cfset ak = ''>
    		<cfquery datasource="#form.dsn#" name="indices">
				exec sp_helpindex <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayCHK[1]#">
			</cfquery>
    		<cfquery name="rsPKsAKs" datasource="#form.dsn#">
      			SELECT o.name, case when xtype = 'PK' then 'P' else 'A' end as type
         		FROM sysconstraints c, sysobjects o
        		WHERE c.id =  OBJECT_ID('#ArrayCHK[1]#')
          		AND c.constid = o.id
          		AND o.xtype in ('PK','UQ')
			</cfquery>
			<cfloop query="rsPKsAKs">
    			<cfquery name="rsColumns" dbtype="query">
        			select index_keys
            		from indices
            		where index_name = '#rsPKsAKs.name#'
        		</cfquery>
    			<cfif rsPKsAKs.type EQ 'P'>
        			<cfset pk = ListAppend(pk,Replace(rsColumns.index_keys,' ','','all'))>
        			<cfelse>
        			<cfset ak = ListAppend(ak,Replace(rsColumns.index_keys,' ','','all'))>
        		</cfif>
			</cfloop>
			<cfset addPBitacora('#ArrayCHK[1]#','#ArrayCHK[1]#','#pk#','',0,'#ArrayCHK[2]#')>
		</cfif>
        <cfset num = num+1>
		<cfset ArrayTable[num] = '#ArrayCHK[1]#'>
        <cfset cache = '#ArrayCHK[2]#'>
	</cfloop>
	<cfset ListTable = ArrayToList(ArrayTable,',')>
	<cfquery datasource="asp" name="lista">
		select PBtabla
		from PBitacora
		where PBtabla in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListTable#" list="yes">)
		order by PBtabla
	</cfquery>
	<cfloop query="lista">
	<cfinvoke component="asp.admin.bitacora.operacion.trigger.trigger_text" method="create_triggers" returnvariable="the_text"
			table_name="#lista.PBtabla#" datasource="#cache#" />
	</cfloop>

</cfif>

<cfif not IsDefined('the_text')>
	<cfset the_text = "Selecciona algunas tablas">
</cfif>


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
            insert into PBitacora (PBtabla,PBdescripcion,PBllaves,PBlista,PCache,PBinactivo,BMfechamod, BMUsucodigo)
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

<cflocation url="tablas.cfm?the_text=#the_text#">