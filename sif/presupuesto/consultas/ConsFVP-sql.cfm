		<cfset logfile = ExpandPath("\WEB-INF\cfusion\logs\FormulacionAplica.log")>
        <cfif  not fileExists(logfile)>
    		<cfoutput>Archivo Log "#logfile#" No existe o  no  se tiene acceso.</cfoutput>
    		<cfabort>
		</cfif>
        
        <cfif isdefined("Form.LogError") and Len(Trim(Form.LogError))>
            <cfset Form.LogError = Form.LogError>
        </cfif>
        <cfif isdefined("Form.LogFecha") and Len(Trim(Form.LogFecha))>
            <cfset Form.LogFecha = Form.LogFecha>
        </cfif>
        <cfif isdefined("Form.LogHora") and Len(Trim(Form.LogHora)) >
            <cfset Form.LogHora = '#Form.LogHora#'>
		<cfelse>
             <cfset Form.LogHora = '00:00'>       
        </cfif>
        <cfif isdefined("Form.LogHoraFin") and Len(Trim(Form.LogHoraFin))>
            <cfset Form.LogHoraFin = '#Form.LogHoraFin#' >
		<cfelse>
             <cfset Form.LogHoraFin = '00:00'>       
        </cfif>
        
        <cfif isdefined("Form.chk_error")>
            <cfset Form.chk_error = #Form.chk_error#>
        </cfif>

        <cfif isdefined("Form.LogMen") and Len(Trim(Form.LogMen))>
            <cfset Form.LogMen = Form.LogMen>
        </cfif>
        <cfif isdefined("Form.UltReg") and Len(Trim(Form.UltReg))>
            <cfset Form.UltReg = Form.UltReg>
        </cfif>
        
        <!--- Convierte el archivo en un array de lineas --->
        <!--- Array de Linea --->
		<cfset lineas = []>
		<!--- Para no tomar en cuenta la linea de titulos del LOG --->
        <cfset Plinea = false>
       	<cfloop file="#logfile#" index="Lfile">
            <cfif Plinea>
				<cfset arrayAppend(lineas, Lfile)>
            <cfelse>
            	<cfset Plinea = true>
            </cfif>
        </cfloop>
        
		<!--- Convierte el array en un RS --->        
        <!--- query to send to cffeed --->
		<cfset qfile = queryNew("Tipo_Error,Fecha, Hora,Aplicacion, Mensaje")>
        <cfset Limlineas = arraylen(lineas)>
        <cfloop from="1" to="#Limlineas#" step="1" index="Lin">
   			<cfset Linea = replace(lineas[Lin],'"','',"ALL")>
            <cfset Linea = replace(Linea,'___','',"ALL")>
			<cfset Registro = listtoarray(Linea,",","true")>
			<cfset queryaddRow(qfile)>
            <cfif arraylen(Registro) GTE 1>
	            <cfset querysetCell(qfile,"Tipo_Error",trim(Registro[1]))>
            <cfelse>
            	<cfset querysetCell(qfile,"Tipo_Error","")>
            </cfif>
            
			<cfif arraylen(Registro) GTE 3>
            	<cfif isdate(Registro[3])>
					<cfset querysetCell(qfile,"Fecha", dateformat(trim(Registro[3]),'dd/mm/yyyy'))>
                <cfelse>
                	<cfset querysetCell(qfile,"Fecha", dateformat(now(),'dd/mm/yyyy'))>
                </cfif>	
            <cfelse>
            	<cfset querysetCell(qfile,"Fecha","")>
           	</cfif>
            
            <cfif arraylen(Registro) GTE 4>
	            <cfset querysetCell(qfile,"Hora",trim(Registro[4]))>
            <cfelse>
            	<cfset querysetCell(qfile,"Hora","")>
            </cfif>
            
            <cfif arraylen(Registro) GTE 5>
            	<cfset querysetCell(qfile,"Aplicacion",trim(Registro[5]))>
            <cfelse>
            	<cfset querysetCell(qfile,"Aplicacion","")>
            </cfif>
            
            <cfif arraylen(Registro) GTE 6>
            	<cfif arraylen(Registro) EQ 6>
            		<cfset querysetCell(qfile,"Mensaje",trim(Registro[6]))>
                <cfelse>
                	<cfset varEXCol = "">
                    <cfloop from="6" to="#arraylen(Registro)#" step="1" index="EXCol">
                    	<cfset varEXCol = varEXCol & " " & trim(Registro[EXCol])>
                    </cfloop>
                   	<cfset querysetCell(qfile,"Mensaje",trim(varEXCol))>
                </cfif>
            <cfelse>
            	<cfset querysetCell(qfile,"Mensaje","")>
            </cfif>
        </cfloop>
        
        <cfoutput>
			<cfset LvarHHMM = int(#LogHora# / 60)>
            <cfset LvarMinutos = #LogHora#>
            <cfset LvarHHMM = "#numberFormat(LvarHHMM,"00")#:#numberFormat(LvarMinutos - LvarHHMM*60,"00")#">
            
            <cfset LvarHHMMFin = int(#LogHoraFin# / 60)>
            <cfset LvarMinutos = #LogHoraFin#>
            <cfset LvarHHMMFin = "#numberFormat(LvarHHMMFin,"00")#:#numberFormat(LvarMinutos - LvarHHMMFin*60,"00")#">
            <cfset varmaxrows= 20>
        	<cfif isdefined("Form.UltReg")> 
            	<cfif Form.UltReg eq "">
                	<cfset varmaxrows= -1>
				<cfelse>
                   	<cfset varmaxrows=#Form.UltReg#> 
				</cfif> 
            <cfelse>
                <cfset Form.UltReg= 20>               
            </cfif>
            
            <cfquery dbtype="query" name="rsResult" maxrows="#varmaxrows#">
                select                  
                * 
                from qfile
                where 1=1
				<cfif isdefined("Form.LogError") and Len(Trim(Form.LogError))>
                    and Tipo_Error like <cfqueryparam value= "%#Form.LogError#%" cfsqltype="cf_sql_varchar">
                </cfif>
                <cfif isdefined("Form.LogFecha") and Len(Trim(Form.LogFecha))>
                    and Fecha = <cfqueryparam value="#Form.LogFecha#" cfsqltype="cf_sql_date">
                </cfif>
                <cfif isdefined("Form.LogHora")>
            		and Hora >= <cfqueryparam value="#LvarHHMM#" cfsqltype="cf_sql_varchar">
                </cfif>
                <cfif isdefined("Form.LogHoraFin") and #Form.LogHoraFin# gt 0>
            		and Hora <= <cfqueryparam value="#LvarHHMMFin#" cfsqltype="cf_sql_varchar">
                </cfif>
                <cfif isdefined('form.LogMen') and #form.LogMen# NEQ ''>
                	and upper(Mensaje) like '%#Ucase(form.LogMen)#%'
                </cfif> 
                <cfif isdefined('Form.chk_error')>
                	and upper(Mensaje) like <cfqueryparam value= "%ERROR%" cfsqltype="cf_sql_varchar">
                </cfif> 
				order by Fecha desc ,Hora desc
            </cfquery>
		</cfoutput>
