<cf_templatecss>
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name="op_concat" returnvariable="_CAT">
<cf_navegacion name="id">

<cfquery name="rsValidaDocImportacion" datasource="#session.dsn#">
	select count(1) as Cant
    from EDocumentosCPR ed
      inner join EDocumentosI ei
            inner join DDocumentosI di
               on di.EDIid = ei.EDIid
            on ei.Ecodigo = ed.Ecodigo
            and ei.Ddocumento = ed.EDdocumento
            and ei.SNcodigo = ed.SNcodigo
    where ed.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and ed.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
        <!--- and not di.DOlinea is null  --->
</cfquery>

<cfset LvarImportacion = 0>
<cfif rsValidaDocImportacion.Cant gt 0>
	<cfset LvarImportacion = 1>
</cfif>

<cfquery name="rsSolicitudes" datasource="#session.dsn#">
	select 
        s.CMSid, 
        s.CMSnombre, 
        ed.EDdocumento, 
        ed.EDfecha, 
        ds.DSlinea, 
        ds.ESnumero, 
        do.EOnumero, 
        coalesce(des.DEemail, dps.Pemail1, dps.Pemail2) as EmailS,
        case ds.DStipo  when 'A' then a.Adescripcion 
                        when 'S' then c.Cdescripcion 
                        when 'F' then ds.DSdescripcion end 
                        as Descripcion,
        <cfif LvarImportacion eq 1>do.DOcantidad as DDcantidad<cfelse>dd.DDcantidad</cfif>,                 
        coalesce(ds.DSdescalterna,'') as descalterna, 
        cf.CFcodigo +' - '+ cf.CFdescripcion centroFuncional
        
    from EDocumentosCPR ed
    <cfif LvarImportacion eq 1>
         inner join EDocumentosI ei
            inner join DDocumentosI di
               on di.EDIid = ei.EDIid
    <cfelse>
    	inner join DDocumentosCPR dd
    </cfif>
            inner join DOrdenCM do
                inner join DSolicitudCompraCM ds
                --left outer join DSolicitudCompraCM ds
                    left outer join Articulos a
                        on a.Aid = ds.Aid
                    left outer join Conceptos c
                        on c.Cid = ds.Cid
                    left outer join ACategoria ac
                        on ac.Ecodigo = ds.Ecodigo and ac.ACcodigo = ds.ACcodigo
                    left outer join AClasificacion acl
                        on acl.Ecodigo = ds.Ecodigo and acl.ACcodigo = ds.ACcodigo and acl.ACid = ds.ACid        
                    inner join ESolicitudCompraCM es
                        --left outer join EsolicitudCompraCM es
                            inner join CFuncional cf
                               on es.CFid = cf.CFid 
                               and es.Ecodigo= cf.Ecodigo 
                            inner join CMSolicitantes s
                                left outer join DatosEmpleado des
                                    on des.DEid = s.DEid
                                inner join Usuario us
                                    left outer join DatosPersonales dps
                                        on dps.datos_personales = us.datos_personales
                                    on us.Usucodigo = s.Usucodigo
                                on s.CMSid = es.CMSid
                            on es.ESidsolicitud = ds.ESidsolicitud        
                    on ds.DSlinea = do.DSlinea    
          <cfif LvarImportacion eq 1>      
            on do.DOlinea = di.DOlinea
            on ei.Ecodigo = ed.Ecodigo
            and ei.Ddocumento = ed.EDdocumento
            and ei.SNcodigo = ed.SNcodigo
          <cfelse>
            on do.DRemisionlinea = dd.Linea
        	on ed.IDdocumento = dd.IDdocumento
         </cfif>   
    
    where  ed.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
       <cfif LvarImportacion eq 0> and not do.DRemisionlinea is null </cfif> 
	order by CMSnombre, EDdocumento, EOnumero, ESnumero, Descripcion
</cfquery>

<cfif rsSolicitudes.recordcount eq 0>
	<script language="javascript1.2">
		alert("No existen datos para mostrar");
		close();
	</script>
    <cfabort>
</cfif>
<cf_rhimprime datos="/sif/cp/operacion/ImprimeFactura.cfm" paramsuri="?#navegacion#">    
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<cfset MaxLineas = 5>  
<cfset contador = 0>  
<cfoutput query="rsSolicitudes" group="CMSid">
	<tr><td colspan="2">&nbsp;</td></tr>
    <tr>
    	<td width="50%"><strong>Solicitante:</strong>&nbsp;#rsSolicitudes.CMSnombre#</td>
        <td><strong>Email:</strong>&nbsp;#rsSolicitudes.EmailS#</td>
   	</tr>
    <tr>
    	<td><strong>Factura:</strong>&nbsp;#rsSolicitudes.EDdocumento#</td>
        <td><strong>Fecha:</strong>&nbsp;#Dateformat(rsSolicitudes.EDfecha,'dd/mm/YYYY')#</td>
   	</tr>
      <tr>
    	<td colspan="2" ><strong>Centro Funcional:</strong>&nbsp;#rsSolicitudes.centroFuncional#</td>
   	</tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr><td colspan="2" align="center">
    	<table border="0" cellpadding="0" cellspacing="0" width="90%">
        	<tr>
            	<td><strong>Num. Orden Compra</strong></td>
                <td><strong>Num. Solicitud</strong></td>
                <td><strong>Descripci&oacute;n</strong></td>
                <td><strong>Descripci&oacute;n alterna</strong></td>
                <td align="right"><strong>Cantidad</strong></td>
            </tr>
			<cfoutput>
            <tr>
            	<td align="center">#rsSolicitudes.EOnumero#</td>
                <td align="center">#rsSolicitudes.ESnumero#</td>
                <td>#rsSolicitudes.Descripcion#</td>
                <td>#rsSolicitudes.descalterna#</td>                
                <td align="right">#rsSolicitudes.DDcantidad#</td>
            </tr>
            </cfoutput>
   		</table>
    </td></tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr><td colspan="2" align="center"><strong>Recibido:&nbsp;</strong>_______________________________________________________________________</td></tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr><td colspan="2"><BR style="page-break-after:always;"></td></tr>
</cfoutput>
</table>
