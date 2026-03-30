<!---<cfdump var="#Form#">
--->
<cfquery name="rs" datasource="#session.DSN#">
    select max(ESnumero) as ESnumero
    from ESolicitudCompraCM
    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="rsCentroFuncional" datasource="#session.DSN#">
    select Top 1 CFid
    from CFuncional
    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="rsTipoSolicitud" datasource="#session.DSN#">
    select Top 1 a.CMTScodigo
    from CMTSolicitudCF a
    inner join CMTiposSolicitud b on a.Ecodigo=b.Ecodigo and a.CMTScodigo=b.CMTScodigo
    where a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    and a.CFid      = <cfqueryparam value="#rsCentroFuncional.CFid#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="rsTipoEspe" datasource="#session.DSN#">
    select Top 1 a.CMSid
	from CMSolicitantesCF a
	inner join CFuncional b on a.CFid=b.CFid 
	where b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    and a.CFid      = <cfqueryparam value="#rsCentroFuncional.CFid#" cfsqltype="cf_sql_integer">
</cfquery>    
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo =  #Session.Ecodigo#  	
</cfquery>
<cfset form.CMTScompradirecta = 0>
<cfset fecha = now()>
<cfset form.ESfecha = "#LSDateFormat(fecha,'dd/mm/yyyy')#">
<cfset form.ESobservacion = "Solicitud Compra de Produccion">
<cfset form.EStipocambio  = 1>

<cftransaction>
    <cfset consecutivo = 1>
    <cfif rs.RecordCount gt 0 and len(trim(rs.ESnumero))>
        <cfset consecutivo = rs.ESnumero + 1>
    </cfif>
        
    <cfquery name="insertEncabSolC" datasource="#session.DSN#" >
        insert into ESolicitudCompraCM( ESnumero, Ecodigo, CFid, CMTScodigo, CMSid, SNcodigo, ESfecha, EStotalest, ESobservacion, Usucodigo, ESfalta, Mcodigo, EStipocambio, CMElinea, TRcodigo)
            values (<cfqueryparam value="#consecutivo#" 			cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#session.Ecodigo#" 		cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#rsCentroFuncional.CFid#"  cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#rsTipoSolicitud.CMTScodigo#"  	cfsqltype="cf_sql_varchar">, 
                    <cfqueryparam value="#rsTipoEspe.CMSid#"        cfsqltype="cf_sql_numeric">, 
                    <cfif form.CMTScompradirecta eq 1 and isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
                        <cfqueryparam value="#form.SNcodigo#" cfsqltype="cf_sql_integer">,
                    <cfelse>
                        null,
                    </cfif>
                    <cfqueryparam value="#LSParseDateTime(form.ESfecha)#" cfsqltype="cf_sql_date">,
                    0,
                    <cfqueryparam value="#form.ESobservacion#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.Usucodigo#"	 cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
                    
                    <cfqueryparam value="#rsMonedaLocal.Mcodigo#" cfsqltype="cf_sql_numeric">, 
                    <cfqueryparam value="#form.EStipocambio#" cfsqltype="cf_sql_float">,
                    <cfif isdefined("form.CMElinea") and len(trim(form.CMElinea))><cfqueryparam value="#form.CMElinea#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
                    <cfif isdefined("form.TRcodigo") and len(trim(form.TRcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.TRcodigo#"><cfelse>null</cfif>
                )
        <cf_dbidentity1 datasource="#session.DSN#">
    </cfquery>	
    <cf_dbidentity2 datasource="#session.DSN#" name="insertEncabSolC">
	<cfset Form.ESidsolicitud = insertEncabSolC.identity>    
</cftransaction>

<cfquery name="consecutivod" datasource="#session.DSN#">
    select max(DSconsecutivo) as linea
    from DSolicitudCompraCM
    where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
</cfquery>
<cfset linea = 1 >
<cfif consecutivod.RecordCount gt 0 and len(trim(consecutivod.linea))>
    <cfset linea = consecutivod.linea + 1 >
</cfif>


<cfset form.Icodigo ="IEXE">
<cfset form.DSfechareq="">
<cfset form.CFid_Detalle="">

<cfloop from="1" to="#form.NumArt#" index="id">
<cfset idArt = 'idArticulo#id#'>
<cfset idAlm = 'Almacen#id#'>
<cfset DScant = 'CPedir#id#'>
<cfset precioUnt = 'precioU#id#'>
<cfset desArt = 'artDescripcion#id#'>

<cfquery name="rsArticulo" datasource="#Session.DSN#">
	select Ucodigo from Articulos
	where Ecodigo =  #Session.Ecodigo# and 	Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#idArt#']#">
</cfquery>
 
<!---<cfdump var="#form['#desArt#']#">
--->
<!--- Function getTotal --->
<cffunction name="getTotal" returntype="numeric">
	<cfargument name="id" type="numeric" required="yes">

	<cfquery name="rsTotal" datasource="#session.DSN#">
		select coalesce(
                    sum(round(DScant*DSmontoest,2))+
                    sum(round(round(DScant*DSmontoest,2) * Iporcentaje/100,2))
	            ,0) as total
		from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud=b.ESidsolicitud
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
		where a.ESidsolicitud = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfif rsTotal.RecordCount gt 0 and len(trim(rsTotal.total))>
		<cfreturn rsTotal.total>
	<cfelse>
		<cfreturn 0 >	
	</cfif>
	
</cffunction>

<cftransaction>
	<cfquery name="insertd" datasource="#session.DSN#" >
		insert into DSolicitudCompraCM ( Ecodigo, ESidsolicitud, ESnumero, DSconsecutivo, DStipo, Aid, Alm_Aid, Cid, ACcodigo, ACid, DSdescripcion, DSobservacion, DSdescalterna,  Icodigo,DScant, DSmontoest, DStotallinest, Ucodigo, DSfechareq, CFid, DSespecificacuenta, CFidespecifica, DSformatocuenta)
		values (<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
				<cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">,
                <cfqueryparam value="#consecutivo#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#linea#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value='A' cfsqltype="cf_sql_char">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#idArt#']#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#idAlm#']#">,
                null,null,null,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#desArt#']#">, 
                null,null,
                <cfif len(trim(form.Icodigo))><cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
				<cfqueryparam value="#form['#DScant#']#" cfsqltype="cf_sql_float">, 
                <cfqueryparam value="#form['#precioUnt#']#" cfsqltype="cf_sql_money">,
				round(#form['#precioUnt#'] * form['#DScant#']#,2),
                <cfqueryparam value="#trim(rsArticulo.Ucodigo)#" cfsqltype="cf_sql_varchar">,
				<cfif len(trim(form.DSfechareq))><cfqueryparam value="#LSParseDateTime(form.DSfechareq)#" cfsqltype="cf_sql_timestamp"><cfelse>null</cfif>,
				<cfif len(trim(form.CFid_Detalle))><cfqueryparam value="#form.CFid_Detalle#" 	cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				<cfif isdefined("form.DSespecificacuenta")>1<cfelse>0</cfif>,
				<cfif isdefined("form.DSespecificacuenta") and isdefined("form.CFcuenta") and len(trim(form.CFcuenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#validaCFcuenta(form.CFcuenta)#"><cfelse>null</cfif>,
				<cfif isdefined("form.DSespecificacuenta") and isdefined("form.CFormato") and len(trim(form.CFormato))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFormato#"><cfelse>null</cfif> )						 
				</cfquery>
			
				<cfset total = getTotal(form.ESidsolicitud) >
		
				<cfquery name="update" datasource="#session.DSN#">
					update ESolicitudCompraCM
					set EStotalest	  = <cfqueryparam value="#total#" cfsqltype="cf_sql_money">
					where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
				</cfquery>
</cftransaction>


</cfloop>

