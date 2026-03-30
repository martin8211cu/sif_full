<cf_navegacion name="form.CMSid" 			  default="-1">
<cf_navegacion name="form.ESlugarentrega" 	  default="">
<cf_navegacion name="form.SNcodigo" 		  default="-1">
<cf_navegacion name="form.ESreabastecimiento" default="1">
<cf_navegacion name="form.CMElinea" 		  default="-1">
<cf_navegacion name="form.TRcodigo" 		  default="">
<cf_navegacion name="form.ActividadId" 		  default="">
<cf_navegacion name="form.Actividad" 		  default="">

<cfif NOT LEN(TRIM(form.CMSid))><cfset form.CMSid = -1></cfif>
<cfif NOT LEN(TRIM(form.SNcodigo))><cfset form.SNcodigo = -1></cfif>
<cfif NOT LEN(TRIM(form.ESreabastecimiento))><cfset form.ESreabastecimiento =1></cfif>
<cfif NOT LEN(TRIM(form.CMElinea))><cfset form.CMElinea = -1></cfif>

<cfif isdefined('form.GENSC')>
        <cfquery name="rsIE" datasource="#session.dsn#">
            select Icodigo
             from Impuestos
             where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.INVRid#">
        </cfquery>
        
    <cftransaction>
    	<cfquery name="rsLineas" datasource="#session.dsn#">
        	select ro.INVRid, ro.Art_Aid, ro.Aid, act.Adescripcion, ro.Cantidad, act.Ucodigo,
			coalesce((select min(Icodigo) from Impuestos where Icodigo = 'IE' and Iporcentaje = 0 and Ecodigo = act.Ecodigo),
            		 (select min(Icodigo) from Impuestos where Iporcentaje = 0 and Ecodigo = act.Ecodigo))  as Icodigo,
                     (select Ecostou from Existencias where Aid = ro.Art_Aid and Alm_Aid = ro.Aid) as Ecostou,
                     ro.Cantidad * (select Ecostou from Existencias where Aid = ro.Art_Aid and Alm_Aid = ro.Aid) as DStotallinest
             from INVDreorden ro
             	inner join Articulos act
                    on act.Aid = ro.Art_Aid
             where ro.INVRid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.INVRid#">
        </cfquery>
        <cfquery name="rsLineasTotal" dbtype="query">
        	select sum(DStotallinest) as TotalSC from rsLineas 
        </cfquery>
        <cfif rsLineas.recordCount>
        	<cfset form.EStotalest = rsLineasTotal.TotalSC>
            <cfinvoke component="sif.Componentes.CM_SolicitudCompra" argumentcollection="#form#" method="AltaEncabezadoSolicitud" returnvariable="DataReturn"/>      
            
            <cfloop query="rsLineas">
            	<cfif rsLineas.Cantidad gt 0>
                    <cfinvoke component="sif.Componentes.CM_SolicitudCompra" method="AltaDetalleSolicitud">
                        <cfinvokeargument name="ESidsolicitud" 		value="#DataReturn.ESidsolicitud#">
                        <cfinvokeargument name="ESnumero" 			value="#DataReturn.ESnumero#">
                        <cfinvokeargument name="DStipo" 	   		value="A">
                        <cfinvokeargument name="Aid" 	  			value="#rsLineas.Art_Aid#">
                        <cfinvokeargument name="Alm_Aid" 	  		value="#rsLineas.Aid#">
                        <cfinvokeargument name="DSdescripcion" 		value="#rsLineas.Adescripcion#">
                        <cfinvokeargument name="Icodigo" 			value="#rsLineas.Icodigo#">
                        <cfinvokeargument name="DScant" 			value="#rsLineas.Cantidad#">
                        <cfinvokeargument name="DSmontoest" 		value="#rsLineas.Ecostou#">
                        <cfinvokeargument name="DStotallinest" 		value="#rsLineas.DStotallinest#">
                        <cfinvokeargument name="Ucodigo" 			value="#rsLineas.Ucodigo#">
                        <cfinvokeargument name="CFid" 				value="#form.CFid#">
                        <cfinvokeargument name="DSespecificacuenta" value="0">
                      <cfif LEN(TRIM(form.ActividadId))>
                        <cfinvokeargument name="FPAEid" 			value="#form.ActividadId#">
                      </cfif>
                      <cfif LEN(TRIM(form.Actividad))>
                        <cfinvokeargument name="CFComplemento" 		value="#form.Actividad#">
                      </cfif>
                    </cfinvoke>  
               </cfif>         
            </cfloop>

            <cfquery name="rsReorden" datasource="#session.dsn#">
               DELETE FROM INVDreorden where INVRid in (select INVRid from INVreorden where INVRid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.INVRid#">)
            </cfquery>
            <cfquery datasource="#session.dsn#">     
                DELETE FROM INVreorden WHERE INVRid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.INVRid#">
            </cfquery>
       </cfif>
    </cftransaction>
    <cfif rsLineas.recordCount>
    	<script>
			alert('La Solicitud de Compra de Inventario N° <cfoutput>#DataReturn.ESnumero#</cfoutput> se generero correctamente');
			window.location = '/cfmx/sif/cm/operacion/solicitudes_IN.cfm?ESidsolicitud=<cfoutput>#DataReturn.ESidsolicitud#</cfoutput>';
        </script>
    <cfelse>
    	<cflocation addtoken="no" url="/cfmx/sif/iv/operacion/RequisicionesInter-lista.cfm">
    </cfif>
</cfif>