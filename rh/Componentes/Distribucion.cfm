<cfset debug = false>
<!--- **************************************************************************** --->
<!---   EN ESTE ARCHIVO SE HACE EL RROCESO DE DISTRIBUCION POR CENTRO FUNCIONAL    --->
<!---   Y EMPLEADO PARA SALARIOS , INCIDENCIAS Y CARGAS PARA AQUELLOS CASOS        --->
<!---   DONDE APLIQUE LA DISTRIBUCION DE LO CONTRARIO  RCuentasTipo QUEDA IGUAL    --->
<!--- **************************************************************************** --->

<!--- ******************************************* --->
<!--- TODA LA INFORMACION SE ENCUENTRA CONTENIDA  --->
<!--- EN LA  TEMPORAL LLAMADA Distribucion        --->
<!--- ******************************************* --->

<!--- **************************************************************************** --->
<!--- PRIMER PASO , BUSCAR LOS SALARIOS Y LA INCIDENCIAS QUE APLIQUE DISTRIBUCION  --->
<!--- **************************************************************************** --->

<!--- ***************** --->
<!--- INSERTA SALARIOS  --->
<!--- ***************** --->
<cfquery datasource="#arguments.conexion#" name="rscopiar">
   insert into #Distribucion# (RCTidREF,RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, 
    							CFcuenta, tipo, CFid,CFidOrigen, Ocodigo, Dcodigo, montores,montoresORI,porcentajeAPL,SB_INC,
    							BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, 
                                Mes,CSid,procesado,insertado,tipod)
    select 
        a.RCTid, 
        a.RCNid, 
        a.Ecodigo, 
        a.tiporeg, 
        cf.CFcuentac as cuenta, 
        coalesce(( select ec.valor2 
           from CFExcepcionCuenta ec
           where ec.CFid=decs.CFid 
             and ec.valor1=a.valor2 ), a.valor2),
        a.valor2,     
        a.Cformato, 
        a.Ccuenta, 
        a.CFcuenta, 
        a.tipo, 
        decs.CFid,
        a.CFid, 
        a.Ocodigo, 
        a.Dcodigo, 
        a.montores *(DECSporcentaje/100) as montores, 
        a.montores  as montoresORI, 
        (DECSporcentaje/100) as DECSporcentaje, 
        1,
        a.BMfechaalta, 
        a.BMUsucodigo, 
        a.DEid, 
        a.RHPPid, 
        a.referencia, 
        a.vpresupuesto, 
        a.Periodo, 
        a.Mes,
        null,
        1,
        0,
        'SALARIO'
    from RCuentasTipo a
      inner join DistEmpCompSal decs
            on   a.DEid 	= decs.DEid 
            and  a.Ecodigo 	= decs.Ecodigo    
            and  100.00 = ( select sum(DECSporcentaje) from DistEmpCompSal x
                            where x.DEid = a.DEid 
                            and  x.Ecodigo 	= a.Ecodigo) 
      inner join CFuncional cf
            on 	decs.CFid 		= cf.CFid						
            and decs.Ecodigo 	= cf.Ecodigo 
    where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
    and a.tipo = 'D'
    and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
    and   tiporeg in (10,11)
</cfquery>

<!--- **************************************** --->
<!--- INSERTA INCIDENCIAS  POR OBJETO DE GASTO --->
<!--- **************************************** --->
<cfquery datasource="#arguments.conexion#" name="rscopiar">
    insert into #Distribucion# (RCTidREF,RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, 
                            CFcuenta, tipo, CFid,CFidOrigen, Ocodigo, Dcodigo, montores,montoresORI,porcentajeAPL,SB_INC,
                            BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, 
                            Mes,CSid,procesado,insertado,tipod, montoorigen)
    select distinct  
        a.RCTid, 
        a.RCNid, 
        a.Ecodigo, 
        a.tiporeg, 
        cf.CFcuentac as cuenta, 
        coalesce(( select ec.valor2 
           from CFExcepcionCuenta ec
           where ec.CFid=dei.CFid 
             and ec.valor1=a.valor2 ), a.valor2),
        a.valor2,     
        a.Cformato, 
        a.Ccuenta, 
        a.CFcuenta, 
        a.tipo, 
        dei.CFid,
        a.CFid, 
        a.Ocodigo, 
        a.Dcodigo, 
        a.montores *(DEIporcentaje/100) as montores, 
        a.montores  as montoresORI, 
        (DEIporcentaje/100) as DECSporcentaje, 
        1,
        a.BMfechaalta, 
        a.BMUsucodigo, 
        a.DEid, 
        a.RHPPid, 
        a.referencia, 
        a.vpresupuesto, 
        a.Periodo, 
        a.Mes,
        d.CSid,
        1,
        0,
        'INCIDENCIAS',
        (select sum(montores) from RCuentasTipo a1 where a.DEid = a1.DEid and a.RCNid = a1.RCNid and a1.tiporeg in (10,20) )

    from RCuentasTipo a
         inner join IncidenciasCalculo c
            on  a.DEid  = c.DEid
            and a.RCNid = c.RCNid 
            and a.CFid  = c.CFid
            and a.referencia  = c.CIid
            and c.ICmontores <> 0 
       inner join CIncidentes d
            on  c.CIid 		   = d.CIid
            and d.Ecodigo 	   = a.Ecodigo 
            and d.CIredondeo   = 0 
			and d.Ccuenta is  null 
        inner join  LineaTiempo lt
            on c.DEid = lt.DEid
            and c.ICfecha between lt.LTdesde and lt.LThasta
            and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
        inner join  RHPlazas p   
            on lt.Ecodigo = p.Ecodigo
            and lt.RHPid = p.RHPid
            and  a.CFid = coalesce(p.CFidconta,p.CFid)
      inner join DistEmpIncidencias dei
            on   a.DEid 	= dei.DEid 
            and  c.CIid 	= dei.CIid 
            and  a.Ecodigo 	= dei.Ecodigo    
            and  100.00 = ( select sum(DEIporcentaje) from DistEmpIncidencias x
                            where x.DEid = a.DEid 
                            and  x.Ecodigo 	= a.Ecodigo
                            and  x.CIid = c.CIid  ) 
      inner join CFuncional cf
            on 	dei.CFid 		= cf.CFid						
            and dei.Ecodigo 	= cf.Ecodigo 
    where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
    and a.tipo = 'D'
    and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
    and a.tiporeg in (20,21)
</cfquery>
<cfquery datasource="#arguments.conexion#" name="rscopiar">
	select * from RCuentasTipo a
    where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
    and a.tipo = 'D'
    and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
    and a.tiporeg in (20,21)

</cfquery>

<!--- **************************************** --->
<!--- INSERTA INCIDENCIAS  CUENTA FIJA         --->
<!--- **************************************** --->
<cfquery datasource="#arguments.conexion#" name="rscopiar">
    insert into #Distribucion# (RCTidREF,RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, 
                            CFcuenta, tipo, CFid,CFidOrigen, Ocodigo, Dcodigo, montores,montoresORI,porcentajeAPL,SB_INC,
                            BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, 
                            Mes,CSid,procesado,insertado,tipod, montoorigen)
    select distinct
        a.RCTid, 
        a.RCNid, 
        a.Ecodigo, 
        a.tiporeg, 
        a.cuenta, 
        a.valor,
        a.valor2,     
        a.Cformato, 
        a.Ccuenta, 
        a.CFcuenta, 
        a.tipo, 
        dei.CFid,
        a.CFid, 
        a.Ocodigo, 
        a.Dcodigo, 
        a.montores *(DEIporcentaje/100) as montores, 
        a.montores  as montoresORI, 
        (DEIporcentaje/100) as DECSporcentaje, 
        1,
        a.BMfechaalta, 
        a.BMUsucodigo, 
        a.DEid, 
        a.RHPPid, 
        a.referencia, 
        a.vpresupuesto, 
        a.Periodo, 
        a.Mes,
        d.CSid,
        1,
        0,
        'INCIDENCIAS',
        (select sum(montores) from RCuentasTipo a1 where a.DEid = a1.DEid and a.RCNid = a1.RCNid and a1.tiporeg in (10,20) )

    from RCuentasTipo a
         inner join IncidenciasCalculo c
            on  a.DEid  = c.DEid
            and a.RCNid = c.RCNid 
            and a.CFid  = c.CFid
            and a.referencia  = c.CIid
            and c.ICmontores > 0 
       inner join CIncidentes d
            on  c.CIid 		   = d.CIid
            and d.Ecodigo 	   = a.Ecodigo 
            and d.CIredondeo   = 0  
			and d.Ccuenta is not null
        inner join  LineaTiempo lt
            on c.DEid = lt.DEid
            and c.ICfecha between lt.LTdesde and lt.LThasta
            and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
        inner join  RHPlazas p   
            on lt.Ecodigo = p.Ecodigo
            and lt.RHPid = p.RHPid
            and  a.CFid = coalesce(p.CFidconta,p.CFid)
      inner join DistEmpIncidencias dei
            on   a.DEid 	= dei.DEid 
            and  c.CIid 	= dei.CIid 
            and  a.Ecodigo 	= dei.Ecodigo    
            and  100.00 = ( select sum(DEIporcentaje) from DistEmpIncidencias x
                            where x.DEid = a.DEid 
                            and  x.Ecodigo 	= a.Ecodigo
                            and  x.CIid = c.CIid  ) 
      inner join CFuncional cf
            on 	dei.CFid 		= cf.CFid						
            and dei.Ecodigo 	= cf.Ecodigo 
    where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
    and a.tipo = 'D'
    and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
    and a.tiporeg in (20,21)
</cfquery>

<!--- DEBUG --->
<cfif debug>
    <b> SALARIOS QUE APLICAN DISTRIBUCION POR CENTRO FUNCIONAL</b><BR>
    <cfquery datasource="#arguments.conexion#" name="RSDebug">
        select 
                a.RCTid, 
                a.tiporeg, 
                a.CFid,  
                <cf_dbfunction name="to_char" args="montores"> as montores,  
                a.DEid
            from RCuentasTipo a

            where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
            and a.tipo = 'D'
            and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
            and   tiporeg in (10,11)
			and exists (    select 1 from DistEmpCompSal decs
                    		where  a.DEid 	= decs.DEid 
                    		and  a.Ecodigo 	= decs.Ecodigo    
                    		and  100.00 = ( select sum(DECSporcentaje) from DistEmpCompSal x
                            where x.DEid = a.DEid 
                             and  x.Ecodigo	= a.Ecodigo)
            )  
             order by tiporeg,DEid,CFid                
    </cfquery>
    <CFDUMP var="#RSDebug#">
    
    <b> INCIDENCIAS QUE APLICAN DISTRIBUCION POR CENTRO FUNCIONAL</b><BR>
    <cfquery datasource="#arguments.conexion#" name="RSDebug">
        select 
            a.RCTid, 
            a.tiporeg, 
            a.CFid, 
            <cf_dbfunction name="to_char" args="montores"> as montores, 
            a.DEid
        from RCuentasTipo a
             inner join IncidenciasCalculo c
                on  a.DEid  = c.DEid
                and a.RCNid = c.RCNid 
                and a.CFid  = c.CFid
                and a.referencia  = c.CIid
                and c.ICmontores > 0 
           inner join CIncidentes d
                on  c.CIid 		   = d.CIid
                and d.Ecodigo 	   = a.Ecodigo 
                and d.CIredondeo   = 0  
            inner join  LineaTiempo lt
                on c.DEid = lt.DEid
                and c.ICfecha between lt.LTdesde and lt.LThasta
                and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
            inner join  RHPlazas p   
                on lt.Ecodigo = p.Ecodigo
                and lt.RHPid = p.RHPid
                and  a.CFid = coalesce(p.CFidconta,p.CFid)  
        where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
        and a.tipo = 'D'
        and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
        and a.tiporeg in (20,21)
        and exists (    select 1 from DistEmpIncidencias decs
                    where  a.DEid 	    = decs.DEid 
                    and    a.Ecodigo 	= decs.Ecodigo  
                    and    c.CIid 	    = decs.CIid    
                    and  100.00 = ( select sum(DEIporcentaje) from DistEmpIncidencias x
                    where x.DEid = a.DEid 
                     and  x.Ecodigo	= a.Ecodigo)
        )  
    </cfquery>
    <CFDUMP var="#RSDebug#">
    
    <b> ASI QUEDARA LOS NUEVOS REGISTROS EN SALARIOS (10,11) E INCIDENCIAS (20,21)</b><BR>
    <cfquery datasource="#arguments.conexion#" name="RSDebug">
    	select 
        		RCTidREF, 
                tiporeg, 
                CFid, 
                <cf_dbfunction name="to_char" args="montores"> as montores, 
                DEid,
                porcentajeAPL,
                montoresORI,
                CFidOrigen,
                SB_INC,tipod
         from #Distribucion# 
        order by tiporeg,DEid,CFid
    </cfquery>
    <CFDUMP var="#RSDebug#">
</cfif>
<!--- FIN DEBUG --->
<!--- **************************************************************************** --->
<!--- SEGUNDO PASO , PASAR LAS CARGAS DE LOS CASOS ANTERIORES DEL CENTRO FUNCIONAL --->
<!--- ORIGEN A LOS NUEVOS                                                          --->
<!--- **************************************************************************** --->

<!--- *********************************** --->
<!--- APLICA LAS CARGAS DE LOS SALARIOS  e incidencias  --->
<!--- *********************************** --->
<cfquery name="rsInsert" datasource="#arguments.conexion#">
    insert into #Distribucion# (RCTidREF,RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, 
                            CFcuenta, tipo, CFid,CFidOrigen, Ocodigo, Dcodigo, montores,montoresORI,porcentajeAPL,SB_INC,
                            BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, 
                            Mes,CSid,procesado,insertado,tipod, montoorigen) 
    select 
    a.RCTid, 
    a.RCNid, 
    a.Ecodigo, 
    a.tiporeg, 
    cf.CFcuentac as cuenta, 
    coalesce(( select ec.valor2 
       from CFExcepcionCuenta ec
       where ec.CFid=c.CFid 
         and ec.valor1=a.valor2 ), a.valor2),
    a.valor2,     
    a.Cformato, 
    a.Ccuenta, 
    a.CFcuenta, 
    a.tipo, 
    c.CFid,
    a.CFid, 
    a.Ocodigo, 
    a.Dcodigo, 
    c.montores, 
    a.montores  as montoresORI, 
    c.porcentajeAPL, 
    1,
    a.BMfechaalta, 
    a.BMUsucodigo, 
    a.DEid, 
    a.RHPPid, 
    a.referencia, 
    a.vpresupuesto, 
    a.Periodo, 
    a.Mes,
    null,
    0,
    0,
    case c.tiporeg 
    	when 10 then   'CARGAS SALARIO'
    	when 11 then   'CARGAS SALARIO'
    	when 20 then   'CARGAS INCIDENCIAS'
    	when 21 then   'CARGAS INCIDENCIAS'
    end   
    , (select sum(montores) from RCuentasTipo a1 where a.DEid = a1.DEid and a.RCNid = a1.RCNid and a1.tiporeg in (10,20) )  
    from RCuentasTipo  a
    inner join #Distribucion# c
        on  a.DEid = c.DEid
        and c.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        and c.tiporeg in (10,11,20,21)
        and a.CFid = c.CFidOrigen

    inner join CFuncional cf
        on c.CFid = cf.CFid
    where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
    and a.tipo = 'D'
    and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
    and a.tiporeg  in (30,31,40,41)
 </cfquery>

<!--- *************************************** --->
<!--- ACTUALIZA LOS CAMPOS SB_INC Y MONTORES  --->
<!--- PARA CALCULAR LA PARTE DE CARGAS        --->
<!--- CORRESPONDIENTE A INCIDENCIAS           --->
<!--- *************************************** ---> 

<cfquery datasource="#arguments.conexion#" name="rscopiar">
        select 
            a.DEid,
            a.CFid,   
              SUM(a.montores) as incidencias,
              
            ( select sum(montores) from #Distribucion#
              where a.DEid =  #Distribucion#.DEid
              <!--- and   a.CFid =  #Distribucion#.CFidOrigen --->
              and   #Distribucion#.tiporeg in (10,11)
             ) as salario 	
            
        from RCuentasTipo a
             inner join IncidenciasCalculo c
                on  a.DEid  = c.DEid
                and a.RCNid = c.RCNid 
                and a.CFid  = c.CFid
                and a.referencia  = c.CIid
                and c.ICmontores > 0 
           inner join CIncidentes d
                on  c.CIid 		   = d.CIid
                and d.Ecodigo 	   = a.Ecodigo 
                and d.CIredondeo   = 0 
                and d.CInocargas   = 0
                and d.CInocargasley  = 0
            inner join  LineaTiempo lt
                on c.DEid = lt.DEid
                and c.ICfecha between lt.LTdesde and lt.LThasta
                and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
            inner join  RHPlazas p   
                on lt.Ecodigo = p.Ecodigo
                and lt.RHPid = p.RHPid
                and  a.CFid = coalesce(p.CFidconta,p.CFid)  
        where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
        and a.tipo = 'D'
        and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
        and a.tiporeg in (10,11,20,21) /*
        and (exists  (select 1 from DistEmpIncidencias  decs
                    where a.DEid 	  = decs.DEid 
                    and a.referencia  = decs.CIid
                    and  100.00 = ( select sum(DEIporcentaje) from DistEmpIncidencias x <!--- Cambio de tabla de DistEmpCargas a DistEmpIncidencias --->
                                    where x.DEid 		= a.DEid 
                                    and  x.Ecodigo 		= a.Ecodigo
                                    and  a.referencia 	= x.CIid) <!---Cambio de campo DClinea a CIid ---> 
				                    ) <!--- --->
         or  exists ( select 1 from DistEmpCompSal decs
                    where    a.DEid 	= decs.DEid 
                    and  a.Ecodigo 	= decs.Ecodigo    
                    and  100.00 = ( select sum(DECSporcentaje) from DistEmpCompSal x
                                where x.DEid = a.DEid 
                                and  x.Ecodigo 	= a.Ecodigo)    
                    )                          
         ) */
        group by   a.DEid, a.CFid        
</cfquery>


<cfloop query="rscopiar">
	<cfquery name="rsInsert" datasource="#arguments.conexion#">
    	update #Distribucion#
    	set  SB_INC  =  #rscopiar.salario# + #rscopiar.incidencias#
        where CFidOrigen = #rscopiar.CFid#
        and   DEid = #rscopiar.DEid#
        and	  tiporeg  in (30,40)
    </cfquery>
</cfloop>

<!--- ******************************************* --->
<!--- TENIENDO EL VALOR DE CARGAS CORREPONDIENTE  --->
<!--- A INCIDENCIAS , EL SALARIO + INCIDENCIAS    --->
<!--- Y EN MONTO DE CARGA QUE SE VA A REBAJAR     --->
<!--- POR MEDIO DE  REGLA DE 3 SE CALCULA EL      --->
<!--- MONTO DE LA CARGA A REBAJAR                 --->



<cfquery name="rsInsert" datasource="#arguments.conexion#">
    update #Distribucion#
    set   montores  = (	montoresORI / montoorigen)* montores
    where tiporeg  in (30,40)
</cfquery>


<!--- ************************************* --->
<!--- APLICA LAS CARGAS DE LAS INCIDENCIAS  --->
<!--- ************************************* --->
<!------------------------------------------------------------------------------------------------------------- DEBUG --->
<cfif debug>
    <b> ASI QUEDARA LAS NUEVAS CARGAS DE SALARIOS (10,11) E INCIDENCIAS (20,21)</b><BR>
    <cfquery datasource="#arguments.conexion#" name="RSDebug">
    	select 
        		RCTidREF, 
                tiporeg, 
                CFid, 
                <cf_dbfunction name="to_char" args="montores"> as montores, 
                DEid,
                porcentajeAPL,
                montoresORI MontoActualEnCargas,
                CFidOrigen,
                SB_INC,
                referencia as id_carga,
                tipod
         from #Distribucion# 
         where tiporeg in (30,40)
        order by tiporeg,DEid,CFid
    </cfquery>
    <CFDUMP var="#RSDebug#">
    <b> RESUMEN</b><BR>
    <cfquery datasource="#arguments.conexion#" name="RSDebug">
    	select 
                CFidOrigen, 
                DEid,
                referencia as id_carga,
                max(montoresORI) as montoresORI,
                sum(montores)    as montores,
                (max(montoresORI) - sum(montores) )   as diferencia
                
         from #Distribucion# 
         where tiporeg in (30,40)
        group by DEid,CFidOrigen,referencia
        order by DEid,CFidOrigen,referencia
    </cfquery>
    <CFDUMP var="#RSDebug#">
    
        <cfquery datasource="#arguments.conexion#" name="RSDebug">
    	select 
                CFid, 
                DEid,
                referencia as id_carga,
                max(montoresORI) as montoresORI,
                sum(montores)    as montores,
                (max(montoresORI) - sum(montores) )   as diferencia
                
         from #Distribucion# 
         where tiporeg in (30,40)
        group by DEid,CFid,referencia
        order by DEid,CFid,referencia
    </cfquery>
    <CFDUMP var="#RSDebug#">
    
</cfif>
<!------------------------------------------------------------------------------------------------------------- FIN DEBUG --->
<!--- **************************************************************************** --->
<!--- TERCER PASO , INSERTA LOS NUEVOS REGISTROS EN RCUENTASTIPO Y ELIMINA LOS     --->
<!--- DESACTUALIZADOS ESTO SOLO APLICA PARA SALARIOS E INCIDENCIAS                 --->
<!--- QUE TENGAN DISTRIBUCION POR CENTRO FUNCIONAL Y PARA EL CASO DE LAS  CARGAS   --->
<!--- INSERTA LAS NUEVAS Y RESTA EL MONTO EN LAS ANTERIORES                        --->
<!--- **************************************************************************** --->

<!--- borra las incidencias y salarios  que tienen distribucion y se encuentran insertadas en RCuentasTipo  ( borra las viejas )--->
 <cfquery datasource="#arguments.conexion#" name="rsborrar">
    delete from RCuentasTipo 
    where tipo = 'D'
    and   RCNid  	= #arguments.RCNid#
    and   Ecodigo 	= #Arguments.Ecodigo#
    and   tiporeg in (10,11,20,21,30,40)
    and   RCTid in ( 
		select distinct x.RCTidREF 
		from #Distribucion#  x
        where x.tipo = 'D'
          and   x.RCNid  = #arguments.RCNid#
          and   x.Ecodigo = #Arguments.Ecodigo#
          and   x.tiporeg in (10,11,20,21,30,40)
        )
</cfquery> 

<!--- inserta las incidencias y salario  ya distribuidas  en RCuentasTipo--->
<cfquery datasource="#arguments.conexion#" name="rscopiar">
  insert into RCuentasTipo (  RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, 
                                BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
   select 
        RCNid, 
        Ecodigo, 
        tiporeg, 
        cuenta, 
        valor,
        valor2,
        Cformato, 
        Ccuenta, 
        CFcuenta, 
        tipo, 
        CFid, 
        Ocodigo, 
        Dcodigo, 
        montores, 
        BMfechaalta, 
        BMUsucodigo, 
        DEid, 
        RHPPid, 
        referencia, 
        vpresupuesto, 
        Periodo, 
        Mes
    from #Distribucion#
    where RCNid  		= #arguments.RCNid#
    and   tipo 			= 'D'
    and   Ecodigo 	   	= #Arguments.Ecodigo#
    and   tiporeg in (10,11,20,21,30,40)
</cfquery>

<!--- Actualiza los montos de las cargas  en RCuentasTipo--->
 <cfquery name="rsCargas" datasource="#arguments.conexion#">
 	update RCuentasTipo 
		set montores = coalesce(montores,0) - 
    		coalesce((
				select coalesce(sum(montores),0) 
				from #Distribucion# 
        		where  RCuentasTipo.RCTid = #Distribucion#.RCTidREF
				), 0.00)
	where RCNid = #Arguments.RCNid#
 </cfquery>
 
<!---  esto esta en la linea 485 --->
  <cfquery datasource="#arguments.conexion#" name="rsborrar">
    delete from #Distribucion#
    where tipo = 'D'
    and   Ecodigo 	   =  #Arguments.Ecodigo#
    and   RCNid 	   =  #arguments.RCNid#
    and   tiporeg in (10,11,20,21)
</cfquery> 

<!------------------------------------------------------------------------------------------------------------- DEBUG --->
<cfif debug>
    <b> ASI QUEDA RCuentasTipo </b><BR>
    <cfquery datasource="#arguments.conexion#" name="rscopiar">
        select * from RCuentasTipo
        where RCNid  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
        and   tipo 			= 'D'
        and   Ecodigo 	   	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
        order by tiporeg,DEid,CFid
    </cfquery>
    <cfdump var="#rscopiar#">
</cfif>
<!------------------------------------------------------------------------------------------------------------- END DEBUG --->

<cfquery datasource="#arguments.conexion#" name="rsborrar">
    delete from #Distribucion#
</cfquery> 

<!--- **************************************************************************** --->
<!--- CUARTO PASO , BUSCAR LAS CARGAS QUE TENGAN QUE DISTRIBUIRSE Y APLICARLAS     --->
<!--- **************************************************************************** --->
<cfquery datasource="#arguments.conexion#" name="rscopiar">
    insert into #Distribucion# (RCTidREF,RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, 
    							CFcuenta, tipo, CFid,CFidOrigen, Ocodigo, Dcodigo, montores,montoresORI,porcentajeAPL,SB_INC,
    							BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, 
                                Mes,CSid,procesado,insertado,tipod)
    select 
        1, 
        a.RCNid, 
        a.Ecodigo, 
        a.tiporeg,
        cf.CFcuentac as cuenta, 
        coalesce(( select ec.valor2 
           from CFExcepcionCuenta ec
           where ec.CFid=decs.CFid 
             and ec.valor1=a.valor2 ), a.valor2),
        a.valor2,     
        null, 
        null, 
        0, 
        a.tipo, 
        decs.CFid,
        null, 
        a.Ocodigo, 
        a.Dcodigo, 
        sum(a.montores) as montores, 
        sum(a.montores) as montoresORI, 
        (DECporcentaje/100) as DECSporcentaje, 
        0.00,
        <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
        <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">, 
        a.DEid, 
        a.RHPPid, 
        a.referencia, 
        a.vpresupuesto, 
        a.Periodo, 
        a.Mes,
        null,
        1,
        0,
        'Cargas'
    from RCuentasTipo a
      inner join DistEmpCargas decs
            on   a.DEid 		= decs.DEid 
            and  a.Ecodigo 		= decs.Ecodigo 
            and  a.referencia 	= decs.DClinea   
            and  100.00 = ( select sum(DECporcentaje) from DistEmpCargas x
                            where x.DEid 		= a.DEid 
                            and  x.Ecodigo 		= a.Ecodigo
                            and  a.referencia 	= x.DClinea) 
      inner join CFuncional cf
            on 	decs.CFid 		= cf.CFid						
            and decs.Ecodigo 	= cf.Ecodigo 
    where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
    and a.tipo = 'D'
    and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
    and   tiporeg in (30,31,40,41)
    
    group by 
        a.RCNid, 
        a.Ecodigo, 
        a.tiporeg,
        cf.CFcuentac, 
        a.valor2,     
        a.tipo, 
        decs.CFid,
        a.Ocodigo, 
        a.Dcodigo, 
        (DECporcentaje/100), 
        a.DEid, 
        a.RHPPid, 
        a.referencia, 
        a.vpresupuesto, 
        a.Periodo, 
        a.Mes    
</cfquery>
<cfquery datasource="#arguments.conexion#" name="rscopiar">
   update #Distribucion#
   set montores = montores * porcentajeAPL
</cfquery>

<!------------------------------------------------------------------------------------------------------------- DEBUG --->
<cfif debug>
    <b> CARGAS QUE APLICAN DISTRIBUCION POR CENTRO FUNCIONAL</b><BR>
    <cfquery datasource="#arguments.conexion#" name="RSDebug">
        select 
                a.RCTid, 
                a.tiporeg, 
                a.CFid, 
                a.referencia,
                <cf_dbfunction name="to_char" args="montores"> as montores, 
                a.DEid 
            from RCuentasTipo a

            where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
            and a.tipo = 'D'
            and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
            and   tiporeg in (30,31,40,41)
			and exists (    select 1 from DistEmpCargas decs
                    		where  a.DEid 	= decs.DEid 
                    		and  a.Ecodigo 	= decs.Ecodigo
                            and  a.referencia 	= decs.DClinea    
                    		and  100.00 = ( select sum(DECporcentaje) from DistEmpCargas x
                            where x.DEid = a.DEid 
                             and  x.Ecodigo	= a.Ecodigo
                             and  a.referencia 	= x.DClinea)
            )  
             order by tiporeg,DEid,CFid                
    </cfquery>
    <CFDUMP var="#RSDebug#">
    
    <b> ASI QUEDARA LOS NUEVOS REGISTROS EN CARGAS (30,31,40,41)</b><BR>
    <cfquery datasource="#arguments.conexion#" name="RSDebug">
    	select 
        		RCTidREF, 
                tiporeg, 
                CFid, 
                <cf_dbfunction name="to_char" args="montores"> as montores, 
                DEid,
                porcentajeAPL,
                montoresORI,
                CFidOrigen,
                SB_INC,tipod
         from #Distribucion# 
        order by tiporeg,DEid,CFid
    </cfquery>
    <CFDUMP var="#RSDebug#">
</cfif>
<!------------------------------------------------------------------------------------------------------------- FIN DEBUG --->


<!--- **************************************************************************** --->
<!---       BORRA LAS CARGAS ANTERIORES Y AGREGA LAS NUEVAS (LAS DISTRIBUIDAS)     --->
<!--- **************************************************************************** --->

 <cfquery datasource="#arguments.conexion#" name="rsborrar">
    delete from RCuentasTipo 
    where tipo = 'D'
    and   Ecodigo 	   	= #Arguments.Ecodigo#
    and   RCNid  		= #arguments.RCNid#
    and   tiporeg in (30,31,40,41)
    and   referencia in ( 
		select distinct x.referencia from #Distribucion#  x
        where x.tipo = 'D'
          and   x.RCNid  = #arguments.RCNid#
          and   x.Ecodigo = #Arguments.Ecodigo#
          and   x.tiporeg in (30,31,40,41)
        )
    and   DEid in ( 
		select distinct x.DEid from #Distribucion#  x
        where x.tipo = 'D'
          and   x.RCNid  = #arguments.RCNid#
          and   x.Ecodigo = #Arguments.Ecodigo#
          and   x.tiporeg in (30,31,40,41)
        )                
</cfquery> 


<cfquery datasource="#arguments.conexion#" name="rscopiar">
  insert into RCuentasTipo (  RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, 
                                BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
   select 
        RCNid, 
        Ecodigo, 
        tiporeg, 
        cuenta, 
        valor,
        valor2,
        Cformato, 
        Ccuenta, 
        CFcuenta, 
        tipo, 
        CFid, 
        Ocodigo, 
        Dcodigo, 
        montores, 
        BMfechaalta, 
        BMUsucodigo, 
        DEid, 
        RHPPid, 
        referencia, 
        vpresupuesto, 
        Periodo, 
        Mes
    from #Distribucion#
    where RCNid  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
    and   tipo 			= 'D'
    and   Ecodigo 	   	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
    and   tiporeg in (30,31,40,41)
</cfquery>

<!------------------------------------------------------------------------------------------------------------- DEBUG --->
<cfif debug>
    <b> ASI QUEDA RCuentasTipo </b><BR>
    <cfquery datasource="#arguments.conexion#" name="rscopiar">
        select * from RCuentasTipo
        where RCNid  		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
        and   tipo 			= 'D'
        and   Ecodigo 	   	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
        ---and   DEid          = 85051
        and   tiporeg in (30,31,40,41)
        order by tiporeg,DEid,CFid
    </cfquery>
    <cfdump var="#rscopiar#">
</cfif>
<!------------------------------------------------------------------------------------------------------------- FIN DEBUG --->

<!--- **************************************************************************** --->
<!---     FINALIZA EL PROCESO DE DISTRIBUCION                                      --->
<!--- **************************************************************************** --->
<cfif debug>
	<cfabort>
</cfif>
<!--- ************************************************************************************************************************************************************ --->
<!--- ************************************************************************************************************************************************************ --->
<!--- ************************************************************************************************************************************************************ --->
