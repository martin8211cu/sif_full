<!--- Se asume que se tiene un cfquery con el nombre rsPuesto  											 --->
<!--- que contiene la siguente información                    											 --->
<!---  RHPcodigo,RHPcodigoext,RHPdescpuesto,CFdescripcion,salariopromedio,Puntos,RHPropuesto,RHPactivo	 --->
<cfset R_LINEAL = 0>
<cfset R_EXPONENCIAL = 0>
<cfset R_LOGARITMICA = 0>
<cfset R_POTENCIAL = 0>

<cfset R2_LINEAL = 0>
<cfset R2_EXPONENCIAL = 0>
<cfset R2_LOGARITMICA = 0>
<cfset R2_POTENCIAL = 0>



<cf_dbtemp name="puestosProcesar" returnvariable="puestosProcesar" datasource="#session.DSN#">
    <cf_dbtempcol name="RHPcodigo"  type="char(10)"	mandatory="yes">
    <cf_dbtempcol name="X"			type="float"  	mandatory="yes">
    <cf_dbtempcol name="Y"			type="float"  	mandatory="yes">
    <cf_dbtempcol name="X2"			type="float"  	mandatory="yes">
    <cf_dbtempcol name="Y2"			type="float"  	mandatory="yes">
    <cf_dbtempcol name="YX"			type="float"  	mandatory="yes">
    <cf_dbtempcol name="LNY"		type="float"  	mandatory="no">
    <cf_dbtempcol name="LNY2"		type="float"  	mandatory="no">
	<cf_dbtempcol name="LNYX"		type="float"  	mandatory="yes">
    <cf_dbtempcol name="LOGX"		type="float"  	mandatory="no">
    <cf_dbtempcol name="LOGX2"		type="float"  	mandatory="no">
	<cf_dbtempcol name="LOGXY"		type="float"  	mandatory="no">
    <cf_dbtempcol name="LOGY"		type="float"  	mandatory="no">
    <cf_dbtempcol name="LOGY2"		type="float"  	mandatory="no">
    <cf_dbtempcol name="LOGY2LOGXY"	type="float"  	mandatory="no">
</cf_dbtemp>

<cfset N = 1>
<cfset A = 1>
<cfset B = 1>

<cfif rsPuesto.recordCount GT 0>
    
    <cfif rsPuesto.recordCount gt 5>
        <cfquery name="rsmax"  dbtype="query">
            select max(puntos) as puntos from rsPuesto
        </cfquery>
        <cfquery name="rsmix"  dbtype="query">
            select min(puntos) as puntos from rsPuesto
        </cfquery>
       
        <cfquery name="rsRHPcodigomax"  dbtype="query">
            select RHPcodigo  FROM rsPuesto
            where puntos =  #rsmax.puntos#
        </cfquery>
        <cfquery name="rsRHPcodigomix"  dbtype="query">
            select RHPcodigo  FROM rsPuesto
            where puntos =   #rsmix.puntos#
        </cfquery>
     <cfelse>
     	<cfset rsRHPcodigomax.RHPcodigo = '-1'>
        <cfset rsRHPcodigomix.RHPcodigo = '-1'>
     </cfif> 
     
    <cfquery name="rsDatos1"  dbtype="query">
        
        select RHPcodigo,
               sum(Puntos) as X, 
               sum(salariopromedio) as  Y
        FROM rsPuesto
        where RHPcodigo not in ( '#rsRHPcodigomax.RHPcodigo#','#rsRHPcodigomix.RHPcodigo#')
        group by RHPcodigo
    </cfquery>

	<cfloop query="rsDatos1">
        <cfquery name="rsINSERT" datasource="#session.DSN#">
            insert into #puestosProcesar# (RHPcodigo,X,Y,X2,Y2,YX,LNY,LNY2,LNYX,LOGX,LOGX2,LOGXY,LOGY,LOGY2,LOGY2LOGXY)
            values(
            <cfqueryparam value="#rsDatos1.RHPcodigo#" cfsqltype="cf_sql_char">,						<!--- PUESTO                 --->
           	
			<cfif rsDatos1.X GT 0>
            	<cfqueryparam value="#rsDatos1.X#" cfsqltype="cf_sql_float">,      						<!--- SUMATORIA DE X         --->
            <cfelse>
				1,
			</cfif>    
            
			<cfif rsDatos1.Y GT 0>	
                <cfqueryparam value="#rsDatos1.Y#" cfsqltype="cf_sql_float">, 							<!--- SUMATORIA DE Y         --->	
            <cfelse>
				1,
			</cfif>
			
			<cfif rsDatos1.X GT 0>
            	<cfqueryparam value="#(rsDatos1.X)^2#" cfsqltype="cf_sql_float">, 						<!--- SUMATORIA DE X ^2      --->
            <cfelse>
				1,
			</cfif>
            
			<cfif rsDatos1.Y GT 0>
            	<cfqueryparam value="#(rsDatos1.Y)^2#" cfsqltype="cf_sql_float">, 						<!--- SUMATORIA DE Y ^2      --->	
            <cfelse>
				1,
			</cfif>
            
            <cfif rsDatos1.Y GT 0 and rsDatos1.X GT 0>
            	<cfqueryparam value="#(rsDatos1.X)*(rsDatos1.Y)#" cfsqltype="cf_sql_float">, 			<!--- SUMATORIA DE XY        --->
            <cfelse>
				1,
			</cfif>
            
			<cfif rsDatos1.Y GT 0>
                <cfqueryparam value="#log(rsDatos1.Y)#" cfsqltype="cf_sql_float">,						<!--- SUMATORIA DE LN(Y)     --->
            <cfelse>
				1,
			</cfif>
            
			<cfif rsDatos1.Y GT 0>
            	<cfqueryparam value="#(log(rsDatos1.Y))^2#" cfsqltype="cf_sql_float">,          		<!--- SUMATORIA DE LN(Y)^2   ---> 
            <cfelse>
				1,
			</cfif>
			
			<cfif rsDatos1.Y GT 0 and rsDatos1.X GT 0>
            	<cfqueryparam value="#(rsDatos1.X)*(log(rsDatos1.Y))#" cfsqltype="cf_sql_float">, 		<!--- SUMATORIA DE LN(Y)X    --->
            <cfelse>
				1,
			</cfif>
			
			<cfif rsDatos1.X GT 0>
            	<cfqueryparam value="#log10(rsDatos1.X)#" cfsqltype="cf_sql_float">, 					<!--- SUMATORIA DE LOG(X)    --->
            <cfelse>
				1,
			</cfif>
			
			<cfif rsDatos1.X GT 0>
            	<cfqueryparam value="#(log10(rsDatos1.X))^2#" cfsqltype="cf_sql_float">, 				<!--- SUMATORIA DE LOG(X)^2  --->
			<cfelse>
				1,
			</cfif>
			
			<cfif rsDatos1.X GT 0>
            	<cfqueryparam value="#(log10(rsDatos1.X))*(rsDatos1.Y)#" cfsqltype="cf_sql_float">, 	<!--- SUMATORIA DE LOG(X)Y   --->
            <cfelse>
				1,
			</cfif>
            
			<cfif rsDatos1.Y GT 0>
	            <cfqueryparam value="#log10(rsDatos1.Y)#" cfsqltype="cf_sql_float">, 					<!--- SUMATORIA DE LOG(Y)    --->
            <cfelse>
				1,
			</cfif>
			
			<cfif rsDatos1.Y GT 0>
            	<cfqueryparam value="#(log10(rsDatos1.Y))^2#" cfsqltype="cf_sql_float">, 				<!--- SUMATORIA DE LOG(Y)^2  --->
            <cfelse>
				1,
			</cfif>
            
			<cfif rsDatos1.Y GT 0 and rsDatos1.X GT 0>
                <cfqueryparam value="#(log10(rsDatos1.X))*(log10(rsDatos1.Y))#" cfsqltype="cf_sql_float"> <!--- SUMATORIA DE LOG(Y)LOG(X)  --->
            <cfelse>
				1
			</cfif>
            
            )
        </cfquery> 
    </cfloop>    
    
    <cfquery name="rsDatos1" datasource="#session.DSN#">
    	SELECT * FROM  #puestosProcesar#
    </cfquery> 
    
    <cfset N = rsDatos1.recordCount >
    
    <cfquery name="rsDatos2"  dbtype="query">
        select 	
                sum(X) 		as SUMX,
                sum(Y) 		as SUMY,
                sum(X2) 	as SUMX2,
                sum(Y2) 	as SUMY2,
                sum(YX) 	as SUMYX,
                sum(LNY) 	as SUMLNY,
                sum(LNY2) 	as SUMLNY2,
                sum(LNYX) 	as SUMLNYX,
                sum(LOGX) 	as SUMLOGX,
                sum(LOGX2) 	as SUMLOGX2,
                sum(LOGXY) 	as SUMLOGXY,
                sum(LOGY) 	as SUMLOGY,
                sum(LOGY2) 	as SUMLOGY2,
                sum(LOGY2LOGXY) as SUMLOGY2LOGXY
        FROM rsDatos1
    </cfquery>
    
<!---     <cfquery name="rsDatos3"  dbtype="query">
        select 	
                sum(X) 		as SUMX,
                sum(X2) 	as SUMX2,
                sum(LNY) 	as SUMLNY,
                sum(LNY2) 	as SUMLNY2,
                sum(LNYX) 	as SUMLNYX

        FROM rsDatos1
    </cfquery>
    <cfdump var="#rsDatos3#"> --->
    
	<!--- *********************************************************************** --->
    <!--- LO PRIMERO QUE SE DEBE LOCALIZAR ES EL R Ó R2 MAS CERCANO A 1           --->
    <!--- PARA LAS REGRESIONES :                                                  --->
    <!--- LINEAL                                                                  --->
    <!--- EXPONENCIAL                                                             --->
    <!--- LOGARITMICA                                                             --->
    <!--- POTENCIAL                                                               --->
	<!---                                                                         --->
	<!---   R =(n*∑xy) - (∑x*∑y) / ([(n*∑x^2) - (∑x)^2)]*[(n*∑y^2)-(∑y)^2])^0.5   ---> 		
	<!---   R^2 = [(n*∑xy) - (∑x*∑y)]^2 / [(n*∑x^2) - (∑x)^2)]*[(n*∑y^2)-(∑y)^2)] ---> 		
	<!---                                                                         --->
	<!--- *********************************************************************** --->

	   <cfif rsDatos2.recordCount GT 0>
		<!--- REGRESION LINEA CALCULO DE R Y R^2     --->
		<cfset R_LINEAL = 0>
		<cfset R2_LINEAL = 0>
        <cfset Ra_LINEAL = 0>
        <cfset Rb_LINEAL = 0>
        <cfset Ra_LINEAL = (n * rsDatos2.SUMYX) - (rsDatos2.SUMX * rsDatos2.SUMY)>
		<cfset Rb1_LINEAL = (n * rsDatos2.SUMX2) - (rsDatos2.SUMX * rsDatos2.SUMX)>
		<cfset Rb2_LINEAL = (n * rsDatos2.SUMY2) - (rsDatos2.SUMY * rsDatos2.SUMY)>
		<cfset Rb_LINEAL = sqr(Rb1_LINEAL*Rb2_LINEAL)>
        <cfset R_LINEAL = abs(Ra_LINEAL / Rb_LINEAL)>
        <cfset R2_LINEAL = R_LINEAL ^2 >
        
		<!--- REGRESION EXPONENCIAL CALCULO DE R Y R^2    Y= LN(Y) --->
		<cfset R_EXPONENCIAL = 0>
		<cfset R2_EXPONENCIAL = 0>
        <cfset Ra_EXPONENCIAL = 0>
        <cfset Rb_EXPONENCIAL = 0>
        <cfset Ra_EXPONENCIAL = (n * rsDatos2.SUMLNYX) - (rsDatos2.SUMX * rsDatos2.SUMLNY)>
		<cfset Rb1_EXPONENCIAL = (n * rsDatos2.SUMX2) - (rsDatos2.SUMX * rsDatos2.SUMX)>
		<cfset Rb2_EXPONENCIAL = (n * rsDatos2.SUMLNY2) - (rsDatos2.SUMLNY * rsDatos2.SUMLNY)>
		<cfset Rb_EXPONENCIAL = sqr(Rb1_EXPONENCIAL*Rb2_EXPONENCIAL)>
        <cfset R_EXPONENCIAL = abs(Ra_EXPONENCIAL / Rb_EXPONENCIAL)>
        <cfset R2_EXPONENCIAL = R_EXPONENCIAL ^2 >
		<!--- REGRESION LOGARITMICA CALCULO DE R Y R^2    X= LOG(X) --->
		<cfset R_LOGARITMICA = 0>
		<cfset R2_LOGARITMICA = 0>
        <cfset Ra_LOGARITMICA = 0>
        <cfset Rb_LOGARITMICA = 0>
        <cfset Ra_LOGARITMICA =  (n * rsDatos2.SUMLOGXY) - (rsDatos2.SUMLOGX * rsDatos2.SUMY)>
		<cfset Rb1_LOGARITMICA = (n * rsDatos2.SUMLOGX2) - (rsDatos2.SUMLOGX * rsDatos2.SUMLOGX)>
		<cfset Rb2_LOGARITMICA = (n * rsDatos2.SUMY2) - (rsDatos2.SUMY * rsDatos2.SUMY)>
		<cfset Rb_LOGARITMICA = sqr(Rb1_LOGARITMICA*Rb2_LOGARITMICA)>
        <cfset R_LOGARITMICA = abs(Ra_LOGARITMICA / Rb_LOGARITMICA)>
        <cfset R2_LOGARITMICA = R_LOGARITMICA ^2 >

		<!--- REGRESION POTENCIAL CALCULO DE R Y R^2    X= LOG(X) Y= LOG(Y) --->
		<cfset R_POTENCIAL = 0>
		<cfset R2_POTENCIAL = 0>
        <cfset Ra_POTENCIAL = 0>
        <cfset Rb_POTENCIAL = 0>
        <cfset Ra_POTENCIAL =  (n * rsDatos2.SUMLOGY2LOGXY) - (rsDatos2.SUMLOGX * rsDatos2.SUMLOGY)>
		<cfset Rb1_POTENCIAL = (n * rsDatos2.SUMLOGX2) - (rsDatos2.SUMLOGX * rsDatos2.SUMLOGX)>
		<cfset Rb2_POTENCIAL = (n * rsDatos2.SUMLOGY2) - (rsDatos2.SUMLOGY * rsDatos2.SUMLOGY)>
		<cfset Rb_POTENCIAL = sqr(Rb1_POTENCIAL*Rb2_POTENCIAL)>
        <cfset R_POTENCIAL = abs(Ra_POTENCIAL / Rb_POTENCIAL)>
        <cfset R2_POTENCIAL = R_POTENCIAL ^2 >
	</cfif>         
    
	<cfif not isdefined("form.radTipo") and  ( R_LINEAL LT 1 and R_LINEAL GT 0  and  R_LINEAL GT R_EXPONENCIAL and  R_LINEAL GT R_LOGARITMICA and  R_LINEAL GT R_POTENCIAL)>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!---                                                                   --->
        <!--- B :  N(EY * EX2)-(EX * EXY) / N(EX2) - (EX)^2                     --->
        <!--- A :  EY - BEX / N                                                 --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
        <cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            <cfset N = rsDatos1.recordCount>
            <cfset B = ((N *rsDatos2.SUMYX)- (rsDatos2.SUMX * rsDatos2.SUMY)) / ((N * rsDatos2.SUMX2)- (rsDatos2.SUMX * rsDatos2.SUMX))>
            <cfset A = (rsDatos2.SUMY -(B*rsDatos2.SUMX ))/ N > 
        </cfif>
	<cfelseif  not isdefined("form.radTipo") and   (R_EXPONENCIAL LT 1 and R_EXPONENCIAL GT 0  and  R_EXPONENCIAL  GT R_LINEAL  and  R_EXPONENCIAL GT R_LOGARITMICA and  R_EXPONENCIAL GT R_POTENCIAL)>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!---*** pero en este caso Y es LN(Y)                                   --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!--- B :  N(EY * EX2)-(EX * EXY) / N(EX2) - (EX)^2                     --->
        <!--- A :  EY - BEX / N                                                 --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
		<cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            <cfset N = rsDatos1.recordCount>
            <cfset B = ((N *rsDatos2.SUMLNYX)- (rsDatos2.SUMX * rsDatos2.SUMLNY)) / ((N * rsDatos2.SUMX2)- (rsDatos2.SUMX * rsDatos2.SUMX))>
            <cfset A = (rsDatos2.SUMLNY -(B*rsDatos2.SUMX ))/ N > 
        </cfif>
    <cfelseif  not isdefined("form.radTipo") and   (R_LOGARITMICA LT 1 and R_LOGARITMICA GT 0  and  R_LOGARITMICA  GT R_LINEAL  and  R_LOGARITMICA  GT R_EXPONENCIAL and  R_LOGARITMICA GT R_POTENCIAL)>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!---*** pero en este caso X es Log(X)                                  --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!--- a = ∑y∑x^2 - ∑x∑xy  /    n∑x^2 - (∑x)^2                           --->
        <!--- b = n∑xy - ∑x∑y  /n∑x^2 - (∑x)^2                                  --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
        <cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            <cfset N = rsDatos1.recordCount>
            <cfset A = ((rsDatos2.SUMY * rsDatos2.SUMLOGX2) - (rsDatos2.SUMLOGX * rsDatos2.SUMLOGXY)) /((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX* rsDatos2.SUMLOGX))> 
			<cfset B = ((n*rsDatos2.SUMLOGXY)-(rsDatos2.SUMLOGX* rsDatos2.SUMY))/((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX* rsDatos2.SUMLOGX))>
        </cfif>
    <cfelseif  not isdefined("form.radTipo") and   (R_POTENCIAL LT 1 and R_POTENCIAL GT 0  and  R_POTENCIAL  GT R_LINEAL  and  R_POTENCIAL  GT R_EXPONENCIAL and  R_POTENCIAL  GT R_LOGARITMICA)>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!--- *******   Y = log(Y)   X = log(X) ******                          --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!---                                                                   --->
        <!--- a = ∑y∑x^2 - ∑x∑xy / n∑x^2 - (∑x)^2                               --->
        <!--- b = n∑xy - ∑x∑y / n∑x^2 - (∑x)^2                                  --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
        <cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            <cfset N = rsDatos1.recordCount>
            <cfset A = ((rsDatos2.SUMLOGX * rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGY2LOGXY))/((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGX)) > 
            <cfset B = ((n*rsDatos2.SUMLOGY2LOGXY)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGY))/((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGX)) >
        </cfif>
   	<cfelseif  isdefined("form.radTipo") and form.radTipo eq 1>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!---                                                                   --->
        <!--- B :  N(EY * EX2)-(EX * EXY) / N(EX2) - (EX)^2                     --->
        <!--- A :  EY - BEX / N                                                 --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
        <cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            <cfset N = rsDatos1.recordCount>
            <cfset B = ((N *rsDatos2.SUMYX)- (rsDatos2.SUMX * rsDatos2.SUMY)) / ((N * rsDatos2.SUMX2)- (rsDatos2.SUMX * rsDatos2.SUMX))>
            <cfset A = (rsDatos2.SUMY -(B*rsDatos2.SUMX ))/ N > 
        </cfif>
   	<cfelseif  isdefined("form.radTipo") and form.radTipo eq 2>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!---*** pero en este caso Y es LN(Y)                                   --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!--- B :  N(EY * EX2)-(EX * EXY) / N(EX2) - (EX)^2                     --->
        <!--- A :  EY - BEX / N                                                 --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
		<cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            <cfset N = rsDatos1.recordCount>
            <cfset B = ((N *rsDatos2.SUMLNYX)- (rsDatos2.SUMX * rsDatos2.SUMLNY)) / ((N * rsDatos2.SUMX2)- (rsDatos2.SUMX * rsDatos2.SUMX))>
            <cfset A = (rsDatos2.SUMLNY -(B*rsDatos2.SUMX ))/ N > 
            <cfset A = exp(A) >
        </cfif>
   	<cfelseif  isdefined("form.radTipo") and form.radTipo eq 3>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!---*** pero en este caso X es Log(X)                                  --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!--- a = ∑y∑x^2 - ∑x∑xy  /    n∑x^2 - (∑x)^2                           --->
        <!--- b = n∑xy - ∑x∑y  /n∑x^2 - (∑x)^2                                  --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
        <cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            <cfset N = rsDatos1.recordCount>
            <cfset A = ((rsDatos2.SUMY * rsDatos2.SUMLOGX2) - (rsDatos2.SUMLOGX * rsDatos2.SUMLOGXY)) /((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX* rsDatos2.SUMLOGX))> 
			<cfset B = ((n*rsDatos2.SUMLOGXY)-(rsDatos2.SUMLOGX* rsDatos2.SUMY))/((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX* rsDatos2.SUMLOGX))>
        </cfif>
   	<cfelseif  isdefined("form.radTipo") and form.radTipo eq 4>
		<!--- ***************************************************************** --->
        <!--- Las variables N,B,A  se calcularon de la siguiente manera         --->
        <!--- N : es la cantidad de puestos quitando el de menor y mayor peso   --->
        <!---                                                                   --->
        <!--- Tanto para A como para B se excluye  el de menor y mayor peso     --->
        <!---                                                                   --->
        <!--- Y = salario promedio   X = Puntos del salario promedio            --->
        <!--- *******   Y = log(Y)   X = log(X) ******                          --->
        <!--- E = equivale al signo de sumatoria                                --->
        <!---                                                                   --->
        <!--- a = ∑y∑x^2 - ∑x∑xy / n∑x^2 - (∑x)^2                               --->
        <!--- b = n∑xy - ∑x∑y / n∑x^2 - (∑x)^2                                  --->
        <!---                                                                   --->
        <!--- una vez calculado B= pendiente  y A= inteseccion                  --->
        <!--- ***************************************************************** --->
        <cfif rsDatos2.recordCount GT 0 and rsDatos2.SUMX GT 0> 
            
			<cfset N = rsDatos1.recordCount>
            <cfset A = ((rsDatos2.SUMLOGY * rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGY2LOGXY))/((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGX)) > 
			<cfset B = ((n*rsDatos2.SUMLOGY2LOGXY)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGY))/((n*rsDatos2.SUMLOGX2)-(rsDatos2.SUMLOGX * rsDatos2.SUMLOGX)) >
        </cfif>
    </cfif>

</cfif>
