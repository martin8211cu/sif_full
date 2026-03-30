<cfcomponent> 
	<cffunction name="FDocumentosCC" access="public" output="false" returntype="query">
    	<cfargument name='Conexion' 		type='string' required='false' default="#session.DSN#">
        <cfargument name='Dreferencia' 		type='numeric' required='true'>
        <cfargument name='Idioma' 			type='numeric' required='true' default="0">
        <cfargument name='firmaAutorizada' 	type='string' required='true' default="">
        <cfargument name='CCtipo'			type='string'  required='true'>

    <cfquery name="rsDatos1" datasource="#session.DSN#">
        select 
			EDAtotalglobal as monto, 
	        Mcodigo,
            EDAfechaglobal as fecha, 
            SNcodigo as Socio
        from EDocumentosAgrupados
        where Ecodigo     = #session.Ecodigo#
          and Dreferencia = #arguments.Dreferencia#
	</cfquery>
    
    <cfset LvarLetras = ''>
    
    <cf_dbfunction name="OP_concat" returnvariable="_concat">
    <cfquery name="rsDatos2" datasource="#session.DSN#">
        select min(c.direccion1 #_concat# ' / ' #_concat# c.direccion2) as direccion
        from SNegocios a
        	inner join SNDirecciones b
              on a.SNid = b.SNid
        	inner join DireccionesSIF c
              on c.id_direccion = b.id_direccion
        where a.Ecodigo = #session.Ecodigo#
        and a.SNcodigo = #rsDatos1.Socio#
	</cfquery>
    
    <cfset LvarFecha = createdate(year(rsDatos1.fecha),month(rsDatos1.fecha),'01')>
    <cfset LvarFecha = dateadd('d', -1, dateadd('m',1,LvarFecha) )>
    
    <cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
	<cfset LvarMontoEnLetras = LvarObj.fnMontoEnLetras(rsDatos1.monto,#arguments.Idioma#)>
    
     <cfquery name="rsReporte" datasource="#session.DSN#">
		select
			a.Ecodigo, 
			'#session.enombre#' as Edescripcion,
			a.SNcodigo,
			f.SNnumero,
			f.SNnombre,
			a.Ddocumento, 
			a.EDAfechaglobal, 
			a.EDAfechavenc, 
			b.DDcantidad, 
			b.DDpreciou, 
			b.DDtotal, 
			b.DDcodartcon, 
			case DDtipo 
				when 'A' 
					then ((select c.Acodigo from Articulos c where c.Aid = b.DDcodartcon and c.Ecodigo = b.Ecodigo)) 
				when 'S' 
					then ((select d.Ccodigo from Conceptos d where d.Cid = b.DDcodartcon and d.Ecodigo = b.Ecodigo))
			end as Acodigo, 
			case DDtipo 
				when 'A' 

					then ((select c.Adescripcion from Articulos c where c.Aid = b.DDcodartcon and c.Ecodigo = b.Ecodigo)) 
				when 'S' 
					then ((select d.Cdescripcion from Conceptos d where d.Cid = b.DDcodartcon and d.Ecodigo = b.Ecodigo))
			end as Adescripcion,
 
				coalesce
					(( 
						select c.Ucodigo 
						from Articulos c 
						where c.Aid = b.DDcodartcon 
						  and c.Ecodigo = b.Ecodigo
					), ' ') 
			as Ucodigo ,
			a.EDAtotalglobal,
			a.EDAtotaldoc,
			'#LvarMontoEnLetras#' as MontoLetras,
			#arguments.Dreferencia# as Dreferencia,
			#LvarFecha# as Ultimodia,
			'#rsDatos2.direccion#' as direccion,
			'#arguments.firmaAutorizada#' as firmaAutorizada
        from EDocumentosAgrupados a
            inner join DDocumentosAgrupados b
                on b.EDAid   = a.EDAid
               and b.Ecodigo = a.Ecodigo
    
            inner join SNegocios f
                 on f.SNcodigo  = a.SNcodigo
                and f.Ecodigo   = a.Ecodigo
            inner join CCTransacciones t
                 on t.Ecodigo   = a.Ecodigo
                and t.CCTcodigo = a.CCTcodigo
        where a.Ecodigo     = #session.Ecodigo#
           and a.Dreferencia = #arguments.Dreferencia# 
          and t.CCTtipo     = '#arguments.CCtipo#'
      </cfquery>
      <cfreturn rsReporte>
    </cffunction>
</cfcomponent>