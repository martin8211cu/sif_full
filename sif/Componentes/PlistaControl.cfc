<cfcomponent>
	<!------>
    <cffunction name="SetControlDefault" access="public">
    	<cfargument name="SScodigo" type="string" required="yes">
        <cfargument name="SMcodigo" type="string" required="yes"> 
        <cfif Arguments.SScodigo EQ 'SIF' and Arguments.SMcodigo EQ 'AF'>
        	<cfset SetControl('SIF','AF','CTRCTRASL',20,'Traspaso de Centro de Custodia')>
            <cfset SetControl('SIF','AF','CRAFOPTR',20,'Traspaso de Responsable')> 
            <cfset SetControl('SIF','AF','CTRAPRB',20,'Aprobación de Traslados')>  
        <cfelse>
        	<cfthrow message="El control de Lista no está implementado para el Sistema #Arguments.SScodigo#, modulo #Arguments.SMcodigo#">	
        </cfif>
    </cffunction>
 <!---►►►►►Inserta o Actualizar un Control de Lista◄◄◄◄◄◄--->
    <cffunction name="SetControl" access="public">
    	<cfargument name="SScodigo" 	 type="string"   required="no">
        <cfargument name="SMcodigo" 	 type="string"   required="no">
        <cfargument name="SPcodigo" 	 type="string"   required="no">
        <cfargument name="MaxRow"   	 type="numeric"  required="no"  default="20">
        <cfargument name="SPdescripcion" type="string"   required="no"  default="">
        <cfargument name="PLCid" 		 type="numeric"  required="no">
        
        <cfif NOT isdefined('Arguments.PLCid')>
            <cfquery datasource="#session.DSN#" name="rs">
                select count(1) cantidad
                    from PlistaControl
                     where Ecodigo  = #session.Ecodigo#
                       and SScodigo = '#Arguments.SScodigo#'
                       and SMcodigo = '#Arguments.SMcodigo#'
                       and SPcodigo = '#Arguments.SPcodigo#'
            </cfquery>
     	 <cfif rs.cantidad EQ 0> 
            <cfquery datasource="#session.DSN#">
                insert PlistaControl (Ecodigo, SScodigo, SMcodigo, SPcodigo,SPdescripcion, MaxRow, fechaalta, BMUsucodigo)
                values (#session.Ecodigo#, '#Arguments.SScodigo#', '#Arguments.SMcodigo#', '#Arguments.SPcodigo#','#Arguments.SPdescripcion#', #Arguments.MaxRow#, 
                <cf_dbfunction name="now">, #session.Usucodigo#)
            </cfquery>
         </cfif>
       <cfelse>
       		  <cfquery datasource="#session.DSN#">
            	update PlistaControl set 
                    MaxRow         = #Arguments.MaxRow#
                    ,BMUsucodigo   = #session.Usucodigo#
                    ,fechaalta     = <cf_dbfunction name="now">
                    <cfif LEN(TRIM(Arguments.SPdescripcion))>
                    ,SPdescripcion = '#Arguments.SPdescripcion#'
                    </cfif>
            	where PLCid    = #Arguments.PLCid#
            </cfquery>
       </cfif>
    </cffunction>
    <!------>
       <cffunction name="GetControl" access="public" returntype="query">
    	<cfargument name="SScodigo" 	 type="string"   required="no">
        <cfargument name="SMcodigo" 	 type="string"   required="no">
        <cfargument name="SPcodigo" 	 type="string"   required="no">
        <cfargument name="Readonly" 	 type="boolean"  required="no" default="true">
        <cfargument name="default" 	 	 type="numeric"  required="no">
        
        <cfif NOT Arguments.Readonly>
            <cf_dbfunction name="to_char" args="PLCid"  returnvariable="PLCid">
            <cf_dbfunction name="to_char" args="MaxRow" returnvariable="MaxRow">
            <cf_dbfunction name="OP_concat" returnvariable="_Cat">
            <cfsavecontent variable="INP">
                <cf_inputNumber name="Plista_AAAA" value="111" onblur="fnUpdateMaxRow(AAAA, this.value);" enteros = "4" decimales = "0">
            </cfsavecontent>
			<cfset INP	= replace(INP,"'","''","ALL")>
            <cfset INP	= replace(INP,"AAAA","' #_Cat# #PLCid#  #_Cat# '","ALL")>
            <cfset INP	= replace(INP,"111","' #_Cat# #MaxRow#  #_Cat# '","ALL")>
         </cfif>
        
        <cfquery datasource="#session.DSN#" name="rs">
        	select PLCid, Ecodigo, SScodigo, SMcodigo, SPcodigo,SPdescripcion, fechaalta, BMUsucodigo
            <cfif Arguments.Readonly>
            	,MaxRow
            <cfelse>
            	,'#PreserveSingleQuotes(INP)#' as MaxRow
            </cfif>
            	from PlistaControl
             where Ecodigo  = #session.Ecodigo#
             	<cfif isdefined('Arguments.SScodigo')>and SScodigo = '#Arguments.SScodigo#' </cfif>
                <cfif isdefined('Arguments.SMcodigo')>and SMcodigo = '#Arguments.SMcodigo#' </cfif>
                <cfif isdefined('Arguments.SPcodigo')>and SPcodigo = '#Arguments.SPcodigo#' </cfif>
        </cfquery>
        	<cfif isdefined('Arguments.default') and rs.RecordCount EQ 0>
            	<cfset rs   = QueryNew("MaxRow")>
                <cfset QueryAddRow(rs, 1)>
                <cfset QuerySetCell(rs, "MaxRow", Arguments.default, 1)>
            </cfif>
        <cfreturn rs>
    </cffunction>
</cfcomponent>