<cfdump var="#form#">
<cfdump var="#url#">

<cfif isdefined("form.btnEliminar")>
	<cfset fnProcesaEliminacion()>
</cfif>

<cfif isdefined("form.btnReprocesar")>
	<cfset fnReprocesar()>
</cfif>

<cfif isdefined("form.btnFiltrar")>
	<cfif isdefined('form.FILTROFECHAD') and len(trim(form.FILTROFECHAD)) eq 0>
    	<cfset form.FILTROFECHAD = '19000101'>
    </cfif>
    <cfif isdefined('form.FILTROFECHAH') and len(trim(form.FILTROFECHAH)) eq 0>
    	<cfset form.FILTROFECHAH = '61000101'>
    </cfif>
    <cfif isdefined ('form.FILTROFECHAD') and len(trim(form.FILTROFECHAD))>
        <cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.FILTROFECHAH,'dd/mm/yyyy')#)>
        <cfset form.FILTROFECHAH = DateAdd("s", -1, #LvarFechaFin#)>
    </cfif>
	<cfset LvarReporte= fnExportar(form.FILTROFECHAD, form.FILTROFECHAH)>
    <cfabort>
</cfif>


<cflocation url="QPassInconsistencias.cfm" addtoken="no">	

<cffunction name="fnObtieneRegistrosInconsistente" access="private" output="false">
	<cfargument name="QPMestado" required="yes" type="numeric">
	<cfset LvarCheck = -1>
	<cfif isdefined("form.chk")>
		<cfset LvarCheck = form.chk>
	</cfif>
	<cfquery name="PorActualizar" datasource="#session.dsn#">
		select b.QPMid, b.QPTPAN, b.QPMCFInclusion,QPMCdescripcion,QPMCMonto
		from QPMovInconsistente b
		where b.QPMid in (#LvarCheck#)
		  and b.QPMestado = #Arguments.QPMestado#
	</cfquery>
</cffunction>

<cffunction name="fnReprocesar" access="private" output="false">
	<cfset fnObtieneRegistrosInconsistente(0)>
	<cfloop query="PorActualizar">
		<cfinvoke component="sif.QPass.Componentes.QPassInconsistencia" method="fnReprocesar" returnvariable="LvarResultado">
			<cfinvokeargument name="Conexion" value="#session.DSN#">
			<cfinvokeargument name="QPMid" value="#PorActualizar.QPMid#">
			<cfinvokeargument name="QPTPAN" value="#PorActualizar.QPTPAN#">
			<cfinvokeargument name="QPMCFInclusion" value="#PorActualizar.QPMCFInclusion#">
			<cfinvokeargument name="QPMCdescripcion" value="#PorActualizar.QPMCdescripcion#">
			<cfinvokeargument name="QPMCMonto" value="#PorActualizar.QPMCMonto#">
		</cfinvoke>
	</cfloop>
</cffunction>

<cffunction name="fnProcesaEliminacion" access="private" output="false">
	<!---Si Elimina--->	
	<cfset fnObtieneRegistrosInconsistente(0)>
	<cfloop query="PorActualizar">
		<cfinvoke component="sif.QPass.Componentes.QPassInconsistencia" method="fnCambiaEstado" returnvariable="LvarResultado">
			<cfinvokeargument name="Conexion" value="#session.DSN#">
			<cfinvokeargument name="QPMid" value="#PorActualizar.QPMid#">
			<cfinvokeargument name="QPTPAN" value="#PorActualizar.QPTPAN#">
	        <cfinvokeargument name="QPMestado" value="1">
		</cfinvoke>
	</cfloop>
</cffunction>

<cffunction name="fnExportar" access="private" output="true" returntype="any">
	<cfargument name="FILTROFECHAD" type="date" required="no">
    <cfargument name="FILTROFECHAH" type="date" required="no">
    
    <cfquery name="rsReporte" datasource="#session.DSN#" maxrows="500">
    	select
			a.QPMid,
			a.QPMestado,
			a.Ecodigo,
			a.QPTPAN,
			a.QPMCFInclusion,
			a.QPMCMonto,
			a.QPMCdescripcion,
			coalesce(a.QPMCintento,0) as QPMCintento ,
			a.QPMCerrordesc,
           case when (select count(1)
            	from QPassTag aa
                where aa.QPTPAN = a.QPTPAN) = 0 then 'No Existe el Tag en el sistema'
            else 
            	'Si existe Tag en el sistema'
            end as TagExiste,
            Case when (select count(1) 
                    from QPassTag b
                    where b.Ecodigo = #Session.Ecodigo#
                      and b.QPTPAN   = a.QPTPAN
                      and b.QPTEstadoActivacion in (4,5,6) ) =0 then ' Tag no ha sido vendido'
             else 
             	'Tag en estado vendido (Correcto)'
             end as TagEncuentravendido,
                      
             case when (select count(1) 
                        from QPventaTags c
                        inner join QPassTag d
                        on d.QPTidTag = c.QPTidTag
                        where d.QPTPAN   = a.QPTPAN
                        and c.QPvtaEstado =1) =0 then 'Tag Sin cuenta de saldos o cliente'
             else
             	'Tag Con cuenta Saldo o Cliente (Correcto)'
             end as TagCuentaSaldos,
			a.BMFecha
		from QPMovInconsistente a
		where a.Ecodigo = #session.Ecodigo#

		<cfif isdefined("arguments.FiltroFechaD") and len(trim(arguments.FiltroFechaD)) and isdefined("arguments.FiltroFechaH") and len(trim(arguments.FiltroFechaH))>
			and a.BMFecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(arguments.FiltroFechaD)#"> and #arguments.FiltroFechaH#
		<cfelseif isdefined("arguments.FiltroFechaH") and len(trim(arguments.FiltroFechaH)) and arguments.FiltroFechaD eq ''>
			and a.BMFecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(arguments.FiltroFechaH)#">
		<cfelseif isdefined("arguments.FiltroFechaD") and len(trim(arguments.FiltroFechaD)) and arguments.FiltroFechaH eq ''>
			and a.BMFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(arguments.FiltroFechaD)#">
		</cfif> 
		and a.QPMestado = 0
        and a.QPMCintento > 0
	   order by a.BMFecha asc,a.QPTPAN
    </cfquery>
    <cf_exportQueryToFile query="#rsReporte#" separador="#chr(9)#" filename="ReporteInconsistencias_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="false">
	<cfabort>
    <cfreturn true>
    
</cffunction>
