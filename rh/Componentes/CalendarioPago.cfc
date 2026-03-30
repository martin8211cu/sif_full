<cfcomponent>
    <!---===============================================================================--->
	
    <cffunction name="getCalendarioPagoAplicado" access="public" returntype="query">
		<cfargument name="CPid"  	 type="numeric" required="no" hint="Id del Calendario">
        <cfargument name="CPtipo"  	 type="numeric" required="no" hint="Tipo de Calendario">
        <cfargument name="Filtro" 	 type="string"  required="no" hint="Filtro Extra">
        <cfargument name="CPperiodo" type="numeric" required="no" hint="Periodo del Calendario">
        <cfargument name="CPmes"   	 type="numeric" required="no" hint="Mes del Calendario">
        <cfargument name="Tcodigo"   type="string"  required="no" hint="Tipo de Nomina">
        <cfargument name="Ecodigo"   type="numeric" required="no" hint="Codigo de la empresa">
        <cfargument name="conexion"  type="string"  required="no" hint="Nombre del Datasource">
       
        <CFIF NOT ISDEFINED('ARGUMENTS.Ecodigo') AND ISDEFINED('SESSION.Ecodigo')>
        	<CFSET ARGUMENTS.Ecodigo = SESSION.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.conexion') AND ISDEFINED('SESSION.dsn')>
        	<CFSET ARGUMENTS.conexion = SESSION.dsn>
        </CFIF>
        <cf_dbfunction name="fn_len" datasource="#ARGUMENTS.conexion#" returnvariable="LvarDescripcion">
        <cfif isdefined("Form.historicos") and Form.historicos>
			<cfset RCalculoNomina = "HRCalculoNomina">
            <cfset filtro = filtro & " and a.CPfcalculo is not null ">
        <cfelse>
            <cfset RCalculoNomina = "HRCalculoNomina">
        </cfif>
		<cfquery name="rsCP" datasource="#ARGUMENTS.conexion#">
          select CPid, a.CPcodigo, case when #LvarDescripcion# (rtrim(coalesce(CPdescripcion,RCDescripcion))) = 0 then RCDescripcion else coalesce(CPdescripcion,RCDescripcion) end as CPdescripcion, a.Tcodigo, c.Tdescripcion, b.Tcodigo as CodNom
             from CalendarioPagos a, #RCalculoNomina# b, TiposNomina c
            where a.Ecodigo = #Arguments.Ecodigo# and b.RCNid = a.CPid and b.Ecodigo = c.Ecodigo and b.Tcodigo = c.Tcodigo
            <cfif isdefined('Arguments.CPid') and LEN(TRIM(Arguments.CPid))>
              and a.CPid = #Arguments.CPid#
            </cfif>    
            <cfif isdefined('Arguments.CPtipo') and LEN(TRIM(Arguments.CPtipo))>
              and a.CPtipo = #Arguments.CPtipo#  
              </cfif>    
            <cfif isdefined('Arguments.Tcodigo') and LEN(TRIM(Arguments.Tcodigo))>
              and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
            </cfif>     
            <cfif isdefined('Arguments.Filtro') and LEN(TRIM(Arguments.Filtro))>
              #Arguments.Filtro#
            </cfif>  
       </cfquery>
		<cfreturn rsCP>
	</cffunction>
    <!---===============================================================================--->
    <!---===============================================================================--->
	<cffunction name="getCalendarioPago" access="public" returntype="query">
		<cfargument name="CPid"  	 type="numeric" required="no" hint="Id del Calendario">
        <cfargument name="CPtipo"  	 type="numeric" required="no" hint="Tipo de Calendario">
        <cfargument name="Filtro" 	 type="string"  required="no" hint="Filtro Extra">
        <cfargument name="CPperiodo" type="numeric" required="no" hint="Periodo del Calendario">
        <cfargument name="CPmes"   	 type="numeric" required="no" hint="Mes del Calendario">
        <cfargument name="Tcodigo"   type="string"  required="no" hint="Tipo de Nomina">
        <cfargument name="Ecodigo"   type="numeric" required="no" hint="Codigo de la empresa">
        <cfargument name="conexion"  type="string"  required="no" hint="Nombre del Datasource">
       
        <CFIF NOT ISDEFINED('ARGUMENTS.Ecodigo') AND ISDEFINED('SESSION.Ecodigo')>
        	<CFSET ARGUMENTS.Ecodigo = SESSION.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.conexion') AND ISDEFINED('SESSION.dsn')>
        	<CFSET ARGUMENTS.conexion = SESSION.dsn>
        </CFIF>
        
		<cfquery name="rsCP" datasource="#ARGUMENTS.conexion#">
          select a.CPid,a.Ecodigo,a.CPcodigo,a.Tcodigo,a.CPdesde,a.CPhasta,a.CPfpago,a.CPperiodo,a.CPmes
                ,a.CPfcalculo,a.CPfenvio,a.CPusucalc,a.CPusuloccalc,a.CPusuenvio,a.CPusulocenvio
                ,a.Usucodigo,a.Ulocalizacion,a.CPtipo,a.CPdescripcion,a.CPnorenta,a.CPnocargasley
                ,a.CPnocargas,a.ts_rversion,a.BMUsucodigo,a.CPnodeducciones,a.CPTipoCalRenta, b.Ttipopago
             from CalendarioPagos a
             	inner join TiposNomina b
                	 on b.Ecodigo = a.Ecodigo
                    and b.Tcodigo = b.Tcodigo
            where a.Ecodigo = #Arguments.Ecodigo#
            <cfif isdefined('Arguments.CPid') and LEN(TRIM(Arguments.CPid))>
              and a.CPid = #Arguments.CPid#
            </cfif>    
            <cfif isdefined('Arguments.CPtipo') and LEN(TRIM(Arguments.CPtipo))>
              and a.CPtipo = #Arguments.CPtipo#
            </cfif>    
            <cfif isdefined('Arguments.CPperiodo') and LEN(TRIM(Arguments.CPperiodo))>
              and a.CPperiodo = #Arguments.CPperiodo#
            </cfif>
            <cfif isdefined('Arguments.CPmes') and LEN(TRIM(Arguments.CPmes))>
              and a.CPmes = #Arguments.CPmes#
            </cfif>  
            <cfif isdefined('Arguments.Tcodigo') and LEN(TRIM(Arguments.Tcodigo))>
              and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
            </cfif>     
            <cfif isdefined('Arguments.Filtro') and LEN(TRIM(Arguments.Filtro))>
              #Arguments.Filtro#
            </cfif>  
       </cfquery>
		<cfreturn rsCP>
	</cffunction>
    <!---===============================================================================--->
    <cffunction name="AltaCalendarioPago" access="public" returntype="numeric">
     	<cfargument name="Tcodigo" 			type="string"  	required="yes" hint="Codigo del Tipo de Nomina">
        <cfargument name="CPdesde" 			type="any"  	required="yes" hint="Fecha Inicio de Calendario">
        
    	<cfargument name="Ecodigo"  		type="numeric" 	required="no" hint="Codigo de la empresa,default session ">
        <cfargument name="conexion" 		type="string"  	required="no" hint="Nombre del datasource, default session">
        <cfargument name="Usucodigo" 		type="numeric"  required="no" hint="Usuario del portal">
        <cfargument name="Ulocalizacion" 	type="string"  	required="no" hint="Localizacion">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no" hint="Usuario del Portal">
        
        <cfargument name="CPnorenta" 		type="numeric"  required="no" default="0" hint="No calcula Renta">
        <cfargument name="CPnocargasley" 	type="numeric"  required="no" default="0" hint="No calcula Cargas de Ley">
        <cfargument name="CPnocargas" 		type="numeric"  required="no" default="0" hint="No calcula Cargas">
        <cfargument name="CPnodeducciones" 	type="numeric"  required="no" default="0" hint="No aplica Deducciones">
        
        <cfargument name="CPtipo" 			type="numeric"  required="no" default="0" hint="0-Normal,1-Especial,2-Anticipo,3-?,4-PTU">
        <cfargument name="CPTipoCalRenta" 	type="numeric"  required="no" default="1" hint="1-X Mes,2-Nomina Aguinaldo,3-Ajuste Anual de Renta">
         
        <cfargument name="CPcodigo" 		type="string"  	required="no" default="" hint="Codigo: default (YYYY-MM-XXX)">
        <cfargument name="CPhasta" 			type="any"  	required="no" default="" hint="Fecha Fin de Calendario">
        <cfargument name="CPfpago" 			type="any"  	required="no" default="" hint="Fecha de aplicacion de la Nomina">
        <cfargument name="CPfcalculo" 		type="any"  	required="no" default="" hint="Fecha de Calculo">
        <cfargument name="CPfenvio" 		type="any"  	required="no" default="" hint="Fecha de Envio">
        <cfargument name="CPusuloccalc" 	type="string"  	required="no" default="">
        <cfargument name="CPusulocenvio" 	type="string"  	required="no" default="">
        <cfargument name="CPdescripcion" 	type="string"  	required="no" default="">
        
        <cfargument name="CPperiodo" 		type="numeric"  required="no" default="-1" hint="Periodo,default periodo de fecha Inicio">
        <cfargument name="CPmes" 			type="numeric"  required="no" default="-1" hint="Mes, default Mes de la Fecha Inicio">
        <cfargument name="CPusuenvio" 		type="numeric"  required="no" default="-1">
        <cfargument name="CPusucalc" 		type="numeric"  required="no" default="-1">
        <cfargument name="EsAguinaldo" 		type="boolean"  required="no" default="false">
        <cfargument name="EsPTU" 			type="boolean"  required="no" default="false">

        
        <CFIF NOT ISDEFINED('ARGUMENTS.Ecodigo') AND ISDEFINED('SESSION.Ecodigo')>
        	<CFSET ARGUMENTS.Ecodigo = SESSION.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.conexion') AND ISDEFINED('SESSION.dsn')>
        	<CFSET ARGUMENTS.conexion = SESSION.dsn>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.Usucodigo') AND ISDEFINED('SESSION.Usucodigo')>
        	<CFSET ARGUMENTS.Usucodigo = SESSION.Usucodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.Ulocalizacion') AND ISDEFINED('SESSION.Ulocalizacion')>
        	<CFSET ARGUMENTS.Ulocalizacion = SESSION.Ulocalizacion>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.BMUsucodigo') AND ISDEFINED('SESSION.UsuCodigo')>
        	<CFSET ARGUMENTS.BMUsucodigo = SESSION.UsuCodigo>
        </CFIF>
        
        <!---Periodo: Si no se envia se toma el de la fecha Inicio del Calendario--->
        <cfif ARGUMENTS.CPperiodo EQ -1>
        	<cfset ARGUMENTS.CPperiodo = datepart('YYYY',ARGUMENTS.CPdesde)>
        </cfif>
        <!---Mes: Si no se envia se toma el de la fecha inicio del Calendario--->
        <cfif ARGUMENTS.CPmes EQ -1>
        	<cfset ARGUMENTS.CPmes = datepart('m',ARGUMENTS.CPdesde)>
        </cfif>
        <!---Codigo: Si no se envia se Arma de la siguiente manera (YYYY-MM-XXX) donde XXX es un consecutivo por Años, mes, tipo Nomina--->
        <cfif NOT LEN(TRIM(ARGUMENTS.CPcodigo))>
        	<cfinvoke method="getCalendarioPago" returnvariable="rsCP">
            	<cfinvokeargument name="CPperiodo" value="#ARGUMENTS.CPperiodo#">
                <cfinvokeargument name="CPmes"     value="#ARGUMENTS.CPmes#">
                <cfinvokeargument name="Tcodigo"   value="#ARGUMENTS.Tcodigo#">
            </cfinvoke>
            <cfif EsAguinaldo>
            	<cfset ARGUMENTS.CPcodigo = 'AGUI'&'-'&ARGUMENTS.CPperiodo&'-'&RepeatString('0',2-LEN(rsCP.Recordcount+1))&rsCP.Recordcount+1>
            <cfelseif EsPTU>
            	<cfset ARGUMENTS.CPcodigo = 'CPTU'&'-'&ARGUMENTS.CPperiodo&'-'&RepeatString('0',2-LEN(rsCP.Recordcount+1))&rsCP.Recordcount+1>
            <cfelse>
	      		<cfset ARGUMENTS.CPcodigo = ARGUMENTS.CPperiodo&'-'&RepeatString('0',2-LEN(ARGUMENTS.CPmes))&ARGUMENTS.CPmes&'-'&RepeatString('0',3-LEN(rsCP.Recordcount+1))&rsCP.Recordcount+1>
            </cfif>
        </cfif>
      <!---Fecha Fin: Si no se envia se Calcula dependiente del tipo de Nomina--->
      <cfif NOT LEN(TRIM(ARGUMENTS.CPhasta))>
         <cfinvoke component="rh.Componentes.TipoNomina" method="GetTipoNomina" Tcodigo="#ARGUMENTS.Tcodigo#" returnvariable="rsTN"/>
         <cfswitch expression="#rsTN.Ttipopago#">
           <cfcase value="0"><cfset ARGUMENTS.CPhasta = DateAdd('d',6,ARGUMENTS.CPdesde)></cfcase><!---Semanal--->
           <cfcase value="1"><cfset ARGUMENTS.CPhasta = DateAdd('d',13,ARGUMENTS.CPdesde)></cfcase><!---Bisemanal--->
           <cfcase value="2"><!---Quincenal--->
           		<cfif Day(ARGUMENTS.CPdesde) EQ "16">
					<cfset ARGUMENTS.CPhasta = CreateDate(Year(ARGUMENTS.CPdesde), Month(ARGUMENTS.CPdesde), DaysInMonth(ARGUMENTS.CPdesde))>
		   		<cfelse>
					<cfset ARGUMENTS.CPhasta = DateAdd('d',14,ARGUMENTS.CPdesde)>
                </cfif>
          </cfcase>
           <cfcase value="3"><cfset ARGUMENTS.CPhasta = DateAdd('d',DaysInMonth(ARGUMENTS.CPdesde)-1,ARGUMENTS.CPdesde)></cfcase><!---Mensual--->
         </cfswitch>
      </cfif>
      <cfif NOT LEN(TRIM(ARGUMENTS.CPfpago))>
         <cfset ARGUMENTS.CPfpago = ARGUMENTS.CPhasta>
      </cfif>
      <!---Descripcion: Si no se envia se Arma--->
      <cfif NOT LEN(TRIM(ARGUMENTS.CPdescripcion))>
      	 <cfswitch expression="#rsTN.Ttipopago#">
           <cfcase value="0"><cfset LvarFrec ='Semanal'></cfcase>
           <cfcase value="1"><cfset LvarFrec ='Bisemanal'></cfcase>
           <cfcase value="2"><cfset LvarFrec ='Quincenal'></cfcase>
           <cfcase value="3"><cfset LvarFrec ='Mensual'></cfcase>
         </cfswitch>
      	<cfset ARGUMENTS.CPdescripcion = 'Nomina ' & LvarFrec&' del '&LsDateFormat(ARGUMENTS.CPdesde,'DD/MM/YYYY')&' al '& LsDateFormat(ARGUMENTS.CPhasta,'DD/MM/YYYY')>
      </cfif>
		<cfquery name="ABC_datosCalenPago_insert" datasource="#ARGUMENTS.conexion#">
		   insert into CalendarioPagos 
			(Ecodigo,CPcodigo,Tcodigo,CPdesde,CPhasta,CPfpago,CPperiodo,CPmes,CPfcalculo,CPfenvio,CPusucalc,CPusuloccalc,
             CPusuenvio,CPusulocenvio,Usucodigo,Ulocalizacion,CPtipo,CPdescripcion,CPnorenta,CPnocargasley,CPnocargas,
             BMUsucodigo,CPnodeducciones,CPTipoCalRenta)
			values (									
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.Ecodigo 	      EQ -1#" value="#ARGUMENTS.Ecodigo#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.CPcodigo 	      EQ -1#" value="#TRIM(ARGUMENTS.CPcodigo)#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.Tcodigo 	      EQ -1#" value="#TRIM(ARGUMENTS.Tcodigo)#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_date" 	voidnull null="#ARGUMENTS.CPdesde 	      EQ -1#" value="#ARGUMENTS.CPdesde#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_date" 	voidnull null="#ARGUMENTS.CPhasta 	      EQ -1#" value="#ARGUMENTS.CPhasta#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_date" 	voidnull null="#ARGUMENTS.CPfpago         EQ -1#" value="#ARGUMENTS.CPfpago#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPperiodo 	  EQ -1#" value="#ARGUMENTS.CPperiodo#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPmes 		  EQ -1#" value="#ARGUMENTS.CPmes#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_date" 	voidnull null="#ARGUMENTS.CPfcalculo      EQ -1#" value="#ARGUMENTS.CPfcalculo#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_date" 	voidnull null="#ARGUMENTS.CPfenvio        EQ -1#" value="#ARGUMENTS.CPfenvio#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPusucalc	      EQ -1#" value="#ARGUMENTS.CPusucalc#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.CPusuloccalc    EQ -1#" value="#TRIM(ARGUMENTS.CPusuloccalc)#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPusuenvio 	  EQ -1#" value="#ARGUMENTS.CPusuenvio#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.CPusulocenvio   EQ -1#" value="#ARGUMENTS.CPusulocenvio#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.Usucodigo 	  EQ -1#" value="#ARGUMENTS.Usucodigo#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.Ulocalizacion   EQ -1#" value="#ARGUMENTS.Ulocalizacion#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPtipo 	 	  EQ -1#" value="#ARGUMENTS.CPtipo#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.CPdescripcion   EQ -1#" value="#ARGUMENTS.CPdescripcion#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPnorenta 	  EQ -1#" value="#ARGUMENTS.CPnorenta#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPnocargasley   EQ -1#" value="#ARGUMENTS.CPnocargasley#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPnocargas 	  EQ -1#" value="#ARGUMENTS.CPnocargas#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.BMUsucodigo     EQ -1#" value="#ARGUMENTS.BMUsucodigo#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPnodeducciones EQ -1#" value="#ARGUMENTS.CPnodeducciones#">,
        <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CPTipoCalRenta  EQ -1#" value="#ARGUMENTS.CPTipoCalRenta#">
				)
            <cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_datosCalenPago_insert">
        <cfreturn ABC_datosCalenPago_insert.Identity>
	</cffunction>
    <!---===============================================================================--->
    <cffunction name="GetCalendarioPagoAuto" access="public" returntype="query">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="no" hint="Codigo de la empresa">
        <cfargument name="conexion" 	type="string"  	required="no" hint="Nombre del Datasource">
        <cfargument name="Tcodigo"  	type="string"   required="no" hint="Tipo de Calendario">
       
        <CFIF NOT ISDEFINED('ARGUMENTS.Ecodigo') AND ISDEFINED('SESSION.Ecodigo')>
        	<CFSET ARGUMENTS.Ecodigo = SESSION.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.conexion') AND ISDEFINED('SESSION.dsn')>
        	<CFSET ARGUMENTS.conexion = SESSION.dsn>
        </CFIF>
        
        <cfset FiltroExtra = "  and CPfcalculo is null 
							    and a.CPid in (select min(b.CPid) 
											    from CalendarioPagos b 
											  where b.Ecodigo = a.Ecodigo 
											    and (select count(1)from RCalculoNomina c  where c.RCNid = b.CPid) = 0
											    and (select count(1)from HRCalculoNomina d where d.RCNid = b.CPid) = 0
											   )">
         <cfinvoke method="getCalendarioPago" returnvariable="rsCPGenNoPag">
         	<cfinvokeargument name="Tcodigo" value="#ARGUMENTS.Tcodigo#">
         </cfinvoke>
         <cfif rsCPGenNoPag.recordCount>
         	<cfreturn rsCPGenNoPag>
         <cfelse>
         	<cfthrow message="NO IMPLEMENTADO">
         </cfif>
        
                
        <cfinvoke component="rh.Componentes.TipoNomina" method="GetTipoNomina" Tcodigo="#ARGUMENTS.Tcodigo#" returnvariable="rsTN"/>
	
	</cffunction>
    
    <cffunction name="fnBajaCalendarioPago" access="public" hint="Funcion para eliminar un Calendario de pago">
		<cfargument name="CPid"  	 type="numeric" required="no" hint="Id del Calendario">
        <cfargument name="Ecodigo"   type="numeric" required="no" hint="Codigo de la empresa">
        <cfargument name="Conexion"  type="string"  required="no" hint="Nombre del Datasource">
       
        <CFIF NOT ISDEFINED('Arguments.Ecodigo')>
        	<CFSET Arguments.Ecodigo = session.Ecodigo>
        </CFIF>
        
        <CFIF NOT ISDEFINED('Arguments.Conexion')>
        	<CFSET Arguments.Conexion = session.dsn>
        </CFIF>
        
        
        <!---►►►Se Eliminan los conceptos del Calendario◄◄◄--->
        <cfquery datasource="#Arguments.Conexion#">
          delete from CCalendario
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">
        </cfquery>
        
        <!---►►►Se Eliminan las Deducciones a Excluir◄◄◄--->
        <cfquery datasource="#Arguments.Conexion#">
          delete from RHExcluirDeduccion
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">
        </cfquery>
        
        <!---►►►Se Eliminan el calendario de Pago◄◄◄--->
		<cfquery datasource="#Arguments.Conexion#">
          delete from CalendarioPagos
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">
       </cfquery>
	</cffunction>
<!---→ Busca el siguiente posible calendario y lo crea para que la accion se aplique sobre el posible calendario ←--->
	<cffunction name="InsertNextCalendar" access="public">
    	<cfargument name="Tcodigo" 	 type="string"  required="yes" hint="Codigo del Tipo de Nomina">
        <cfargument name="Ecodigo"   type="numeric" required="no"  hint="Codigo de la empresa">
        <cfargument name="Conexion"  type="string"  required="no"  hint="Nombre del Datasource">
        
        <CFIF NOT ISDEFINED('Arguments.Ecodigo')>
        	<CFSET Arguments.Ecodigo = session.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Conexion')>
        	<CFSET Arguments.Conexion = session.dsn>
        </CFIF>
        
        <cfquery name="rsCalendar" datasource="#Arguments.Conexion#">
            select cal.CPid, cal.CPdesde, cal.CPhasta
                from CalendarioPagos cal
            where cal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
             and cal.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
             and cal.CPfcalculo is null
             and (select Count(1) from RCalculoNomina nom where nom.RCNid = cal.CPid) = 0
        </cfquery>
        <cfquery name="rsNextCalendar" datasource="#Arguments.Conexion#">
          select dateadd(dd,1,cal.CPhasta) as CPdesde, tn.Ttipopago
            from CalendarioPagos cal
                inner join TiposNomina tn
                    on cal.Ecodigo = tn.Ecodigo
                    and cal.Tcodigo = tn.Tcodigo
             where cal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
               and cal.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
               and cal.CPfpago = (select max(CPfpago) 
                                    from CalendarioPagos maxcal
                                  where maxcal.Ecodigo = cal.Ecodigo
                                    and maxcal.Tcodigo = cal.Tcodigo) 
               order by CPdesde
        </cfquery>
      <cfloop query="rsNextCalendar">
      <!---  Se hace este cambio pues para el calculo de la renta es importante tomar la fecha hasta como CPmes y no la fechadesde ademas para los reportes--->
  		<cfswitch expression="#rsNextCalendar.Ttipopago#">
        	<cfcase value="0"><cfset fechaHasta = DateAdd('d',6,rsNextCalendar.CPdesde)></cfcase><!---Semanal--->
           	<cfcase value="1"><cfset fechaHasta = DateAdd('d',13,rsNextCalendar.CPdesde)></cfcase><!---Bisemanal--->
           	<cfcase value="2"><!---Quincenal--->
           		<cfif Day(rsNextCalendar.CPdesde) EQ "16">
					<cfset fechaHasta = CreateDate(Year(rsNextCalendar.CPdesde), Month(rsNextCalendar.CPdesde), DaysInMonth(rsNextCalendar.CPdesde))>	
                <cfelse>																									
		   			<cfset fechaHasta = DateAdd('d',14,rsNextCalendar.CPdesde)>
                </cfif>
          	</cfcase>
           <cfcase value="3"><!---Mensual--->
		   		<cfset fechaHasta = DateAdd('d',DaysInMonth(rsNextCalendar.CPdesde)-1,rsNextCalendar.CPdesde)>
           </cfcase>
         </cfswitch>
         <cfset CPmes = datepart('m',fechaHasta)>
      		<cfinvoke component="rh.Componentes.CalendarioPago" method="AltaCalendarioPago" returnvariable="LvarCPid">
                <cfinvokeargument name="CPdesde" value="#rsNextCalendar.CPdesde#">
                <cfinvokeargument name="Tcodigo" value="#Arguments.Tcodigo#">
                <cfinvokeargument name="CPmes" 	 value="#CPmes#">
            </cfinvoke>
      </cfloop>
    </cffunction>



<!------>
	<cffunction name="PrintNextCalendar" access="public" output="yes">
    	<cfargument name="Tcodigo" 	 type="string"  required="yes" hint="Codigo del Tipo de Nomina">
        <cfargument name="Ecodigo"   type="numeric" required="no"  hint="Codigo de la empresa">
        <cfargument name="Conexion"  type="string"  required="no"  hint="Nombre del Datasource">
        
        <CFIF NOT ISDEFINED('Arguments.Ecodigo')>
        	<CFSET Arguments.Ecodigo = session.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Conexion')>
        	<CFSET Arguments.Conexion = session.dsn>
        </CFIF>
        <cfquery name="rsCalendar" datasource="#Arguments.Conexion#">
            select cal.CPid, cal.CPdesde, cal.CPhasta
                from CalendarioPagos cal
            where cal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
             and cal.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
             and cal.CPfcalculo is null
             and (select Count(1) from RCalculoNomina nom where nom.RCNid = cal.CPid) = 0
             order by CPdesde
        </cfquery>
        <cfquery name="rsNextCalendar" datasource="#Arguments.Conexion#">
          select dateadd(dd,1,cal.CPhasta) as CPdesde, tn.Ttipopago
            from CalendarioPagos cal
                inner join TiposNomina tn
                    on cal.Ecodigo = tn.Ecodigo
                    and cal.Tcodigo = tn.Tcodigo
             where cal.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
               and cal.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
               and cal.CPhasta = (select max(CPhasta) 
                                    from CalendarioPagos maxcal
                                  where maxcal.Ecodigo = cal.Ecodigo
                                    and maxcal.Tcodigo = cal.Tcodigo) 
               order by CPdesde
        </cfquery>
        <cfswitch expression="#rsNextCalendar.Ttipopago#">
        	<cfcase value="0"><cfset fechaHasta = DateAdd('d',6,rsNextCalendar.CPdesde)></cfcase><!---Semanal--->
           	<cfcase value="1"><cfset fechaHasta = DateAdd('d',13,rsNextCalendar.CPdesde)></cfcase><!---Bisemanal--->
           	<cfcase value="2"><!---Quincenal--->
           		<cfif Day(rsNextCalendar.CPdesde) EQ "16">
					<cfset fechaHasta = CreateDate(Year(rsNextCalendar.CPdesde), Month(rsNextCalendar.CPdesde), DaysInMonth(rsNextCalendar.CPdesde))>	
                <cfelse>																									
		   			<cfset fechaHasta = DateAdd('d',14,rsNextCalendar.CPdesde)>
                </cfif>
          	</cfcase>
           <cfcase value="3"><!---Mensual--->
		   		<cfset fechaHasta = DateAdd('d',DaysInMonth(rsNextCalendar.CPdesde)-1,rsNextCalendar.CPdesde)>
           </cfcase>
         </cfswitch>
        <select name="CPAdesdeIni">
        	<cfloop query="rsCalendar">
            	<option value="CPid|<cfoutput>#rsCalendar.CPid#</cfoutput>"><cfoutput>Nomina del #DateFormat(rsCalendar.CPdesde,'DD/MM/YYYY')# al #DateFormat(rsCalendar.CPhasta,'DD/MM/YYYY')#</cfoutput></option>
            </cfloop>
            	<option value="CPdesde|<cfoutput>#DateFormat(rsNextCalendar.CPdesde,'DD/MM/YYYY')#</cfoutput>"><cfoutput>Nomina del #DateFormat(rsNextCalendar.CPdesde,'DD/MM/YYYY')# al #DateFormat(fechaHasta,'DD/MM/YYYY')#</cfoutput></option>
        </select>        
    </cffunction>
    <!---►►►►►Funcion para agregar las Excluiciones de Deducciones◄◄◄◄◄◄--->
    <cffunction name="AltaRHExcluirDeduccion" access="public" output="no">
    	<cfargument name="CPid" 	 	type="numeric"  required="yes" hint="Codigo del Calendario de Pago">
        <cfargument name="TDidIncluir"  type="string"  required="no"  hint="Deducciones a incluir, es decir no incluir en la exclusion">
        <cfargument name="TDidExluir"   type="string"  required="no"  hint="Deducciones a Excluir, es decir incluira todas excepto las que aca se indiquen">
        <cfargument name="Ecodigo"  	type="numeric" required="no"  hint="Codigo de la empresa">
        <cfargument name="Conexion"  	type="string"  required="no"  hint="Nombre del Datasource">

        <CFIF NOT ISDEFINED('Arguments.Conexion')>
        	<CFSET Arguments.Conexion = session.dsn>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Ecodigo')>
        	<CFSET Arguments.Ecodigo = session.Ecodigo>
        </CFIF>
        
        <cfquery name="insertaDeduccionesMasivas" datasource="#Arguments.Conexion#">
            insert into RHExcluirDeduccion (CPid,TDid,BMUsucodigo)
           		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">, TDid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            from TDeduccion
             where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
             <cfif isdefined('Arguments.TDidIncluir')>
               and TDid not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TDidIncluir#" list="yes">)
             </cfif>
             <cfif isdefined('Arguments.TDidExluir')>
               and TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TDidExluir#" list="yes">)
             </cfif>
			</cfquery>
    </cffunction>
    <!---►►►►►Funcion para agregar los Conceptos◄◄◄◄◄◄--->
    <cffunction name="AltaCCalendario" access="public" output="no">
    	<cfargument name="CPid" 	 	type="numeric"  required="yes" hint="Codigo del Calendario de Pago">
        <cfargument name="CIid" 	 	type="numeric"  required="yes" hint="Id del Concepto de Pago">
        <cfargument name="Conexion"  	type="string"  required="no"  hint="Nombre del Datasource">
         
    	 <CFIF NOT ISDEFINED('Arguments.Conexion')>
        	<CFSET Arguments.Conexion = session.dsn>
        </CFIF>
        
        <cfquery name="ABC_datosCalenPago" datasource="#Arguments.Conexion#">
            insert into CCalendario (CPid,CIid,BMUsucodigo)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            )
        </cfquery>
    </cffunction>
</cfcomponent>