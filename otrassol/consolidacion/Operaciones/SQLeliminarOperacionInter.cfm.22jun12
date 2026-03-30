<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">

<cffunction name="numCtaDestino" returntype="numeric">
    <cfargument name="pEcodigoOrig"   type="numeric" required="true">
    <cfargument name="pEcodigoDest"   type="numeric" required="true">
    <cfargument name="pcuenta"        type="numeric" required="true">
    <cfset cta = 9999>
	<cfquery name="rs" datasource="#Session.DSN#">
        select b.Ccuenta
        from CContables a
        inner join CContables b on a.Cformato=b.Cformato
        where 	a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pcuenta#"> and 
        		a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pEcodigoOrig#"> and 
        		b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pEcodigoDest#"> 		  
	</cfquery>
	<cfif rs.RecordCount EQ 0>
        <<cfreturn #cta#>
    </cfif>	    
    <cfreturn #rs.Ccuenta#>
</cffunction>

<cfscript>
function formaCtaAsiento(pMascaraElimina,pMascaraAsiento,pFormaElimina)
{
	var ArrX = "";
	var Salida = "";
	var j = 1;
    for (i = 1; i LE len(pMascaraElimina); i++) {
		if (Mid(pMascaraElimina,i,1)=='X')
		{
			ArrX = ArrX & Mid(pMascaraAsiento,i,1);
		}
	}
    for (i = 1; i LE len(pFormaElimina); i++) {
		if (Mid(pFormaElimina,i,1)=='X')
		{
			Salida = Salida & Mid(ArrX,j,1);
			j++;
		}
		else
		{
        	Salida = Salida & Mid(pFormaElimina,i,1);
		}
	}
	return trim(Salida);
}
</cfscript>

<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<!--- PARAMETROS RELACIONADOS CON ELIMINACIÓN DE CUENTAS --->
<cfset empConsolida = ObtenerDato(1310)>
<cfset polizaElimina = ObtenerDato(1320)>

<cfset periodo_actual = ObtenerDato(30)>
<cfset mes_contable = ObtenerDato(40)>

 <!--- Obtiene la suma de polizas anteriores para la cuenta de eliminación --->
<cffunction name="ObtenerAjuste" returntype="query">
	<cfargument name="pecodigo"  type="numeric" required="true">
	<cfargument name="pperiodo"  type="numeric" required="true">
	<cfargument name="pmes"      type="numeric" required="true">
	<cfargument name="pdocumento" type="string" required="true">
    <cfargument name="pcuenta"   type="numeric" required="true">
    <cfargument name="pmcodigo"   type="numeric" required="true">
    <cfargument name="pmtipo"   type="string" required="true">

	<cfquery name="rs" datasource="#Session.DSN#">
    	select
		(select COALESCE(sum(INTMON),0)
	       from Cons_SaldosXCuenta
		where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pecodigo#">
        	and Eperiodo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pperiodo#">
            and Emes      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pmes#">
            and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pdocumento#">
		  	and Ccuenta   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcuenta#">
            and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pmcodigo#">
            and Dmovimiento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.pmtipo#">) as Mlocal,
		(select COALESCE(sum(INTMOE),0)
	       from Cons_SaldosXCuenta
		where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pecodigo#">
        	and Eperiodo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pperiodo#">
            and Emes      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pmes#">
            and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pdocumento#">
		  	and Ccuenta   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcuenta#">
            and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pmcodigo#">
            and DOmovimiento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.pmtipo#">) as Moriginal
	</cfquery>    
	<cfreturn #rs#>
</cffunction>

 <!--- Obtiene el saldo actual la cuenta de eliminación --->
<cffunction name="ObtenerSaldoContable" returntype="query">
	<cfargument name="pecodigo"  type="numeric" required="true">
	<cfargument name="pperiodo"  type="numeric" required="true">
	<cfargument name="pmes"      type="numeric" required="true">
    <cfargument name="pcuenta"   type="numeric" required="true">
    <cfargument name="pmcodigo"   type="numeric" required="true">

	<cfquery name="rs" datasource="#Session.DSN#">
    select d.Cbalancen,
    a.DLdebitos-a.CLcreditos as SLfinal,
    DOdebitos-a.COcreditos as SOfinal
<!---    a.SLinicial+a.DLdebitos-a.CLcreditos as SLfinal,
    a.SOinicial+DOdebitos-a.COcreditos as SOfinal
--->    
	from SaldosContables a 
    inner join CContables c on c.Ccuenta =a.Ccuenta
    inner join CtasMayor d on c.Cmayor=d.Cmayor and c.Ecodigo=d.Ecodigo   
    where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pecodigo#">
        	and a.Speriodo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pperiodo#">
            and a.Smes      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pmes#">
		  	and a.Ccuenta   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcuenta#">
            and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pmcodigo#">
	</cfquery>    
	<cfreturn #rs#>
</cffunction>

<cf_dbtemp name="Ccta_elim" returnvariable="Ccta_elim" datasource="#session.DSN#">
	<cf_dbtempcol name="Ecodigo"   type="int"          mandatory="yes">
    <cf_dbtempcol name="INTLIN"    type="numeric"      identity="yes">
    <cf_dbtempcol name="INTORI"    type="char(4)"      mandatory="yes">
    <cf_dbtempcol name="INTREL"    type="int"          mandatory="yes">
    <cf_dbtempcol name="INTDOC"    type="varchar(20)"  mandatory="yes">
    <cf_dbtempcol name="INTREF"    type="varchar(25)"  mandatory="yes">
    <cf_dbtempcol name="INTMON"    type="money"        mandatory="yes">
    <cf_dbtempcol name="INTTIP"    type="char(1)"      mandatory="yes">
    <cf_dbtempcol name="INTIPO"    type="char(1)"      mandatory="yes">
    <cf_dbtempcol name="INTDES"    type="varchar(80)"  mandatory="yes">
    <cf_dbtempcol name="INTFEC"    type="varchar(8)"   mandatory="yes">
    <cf_dbtempcol name="INTCAM"    type="float"        mandatory="yes">
    <cf_dbtempcol name="Periodo"   type="int"          mandatory="yes">
    <cf_dbtempcol name="Mes"       type="int"          mandatory="yes">
    <cf_dbtempcol name="Ccuenta"   type="numeric"      mandatory="yes">
    <cf_dbtempcol name="Ccuenta2"   type="numeric"      mandatory="yes">
    <cf_dbtempcol name="Mcodigo"   type="numeric"      mandatory="yes">
    <cf_dbtempcol name="Ocodigo"   type="numeric"      mandatory="yes">
    <cf_dbtempcol name="INTMOE"    type="money"        mandatory="yes">
    <cf_dbtempcol name="Cgasto"    type="varchar(100)" mandatory="no">
    <cf_dbtempcol name="Cformato"  type="varchar(100)" mandatory="no">
    <cf_dbtempcol name="CFcuenta"  type="numeric"      mandatory="no">
    <cf_dbtempcol name="CFcuenta2"  type="numeric"      mandatory="no">
    <cf_dbtempcol name="INTMON2"   type="money"        mandatory="no">
    <cf_dbtempcol name="LIN_IDREF" type="numeric"      mandatory="no">
    <cf_dbtempcol name="LIN_CAN"   type="float"        mandatory="no">
    <cf_dbtempcol name="Dlinea"     type="integer"     mandatory="no">
    <cf_dbtempcol name="DOlinea"    type="numeric"     mandatory="no">
    <cf_dbtempcol name="DDcantidad" type="float"        mandatory="no">
    <cf_dbtempcol name="CFid" type="numeric"        mandatory="no">
    <cf_dbtempcol name="CFCuentaContable"	type="varchar(100)" mandatory="no">
    <cf_dbtempcol name="CFCuentaComplemento"	type="varchar(100)" mandatory="no">
    <cf_dbtempkey cols="INTLIN">
</cf_dbtemp>

<cf_dbfunction name="sReplace"	args="b.CFCuentaContable,'X','%'"  returnvariable="strreplace">
<!--- PARAMETROS RELACIONADOS CON ELIMINACIÓN DE CUENTAS --->
<cfquery name="rsCuentasComunes" datasource="#session.DSN#">
    select DISTINCT a.Ecodigo,a.Ccuenta,c.Cformato,d.Cbalancen,d.Cmayor,a.Speriodo,a.Smes,a.Mcodigo,a.Ocodigo,<!--- a.SLiniciala.DLdebitos,,--->
    a.CLcreditos,
    a.DLdebitos-a.CLcreditos as SLfinal,
<!---    a.SLinicial+a.DLdebitos-a.CLcreditos as SLfinal, --->
    b.CFCuentaContable,b.CFCuentaComplemento,
<!---    a.SOinicial,DOdebitos,a.COcreditos,--->
    a.DOdebitos-a.COcreditos as SOfinal 
<!---    a.SOinicial+a.DOdebitos-a.COcreditos as SOfinal --->
    from SaldosContables a 
    inner join CContables c on c.Ccuenta =a.Ccuenta
    inner join Cons_CtaConEliminaInter1 b on c.Cformato like(#PreserveSingleQuotes(strreplace)#) and b.EcodigoEmp=c.Ecodigo
    inner join CtasMayor d on c.Cmayor=d.Cmayor and c.Ecodigo=d.Ecodigo    
    where a.Speriodo = #form.periodo# and a.Smes=#form.mes# and a.Ecodigo = #form.empresa#
    and ((a.DOdebitos - a.COcreditos) != 0 or (a.DLdebitos - a.CLcreditos) != 0) 
    <!---and (a.DLdebitos - a.CLcreditos) > 0--->
</cfquery>

<cfquery name="rsEmpresaElim" datasource="#session.DSN#">
	select Edescripcion from Empresas where Ecodigo = #form.empresa#
</cfquery>

<cfif rsCuentasComunes.RecordCount EQ 0>
	<cfset	msg = "No existen saldos de cuentas interempresa para eliminar">
    <cflocation url="eliminarOperInterempresa.cfm?errorCta=1&Cuenta=#msg#">
<cfelse>
<!---VALIDACION DE CUENTAS COMODIN--->
	<cfloop query="rsCuentasComunes">
	<!--- Validar que la cuenta de eliminación exista en la empresa destino --->    
		<cfset CtaDestino	= numCtaDestino(#rsCuentasComunes.Ecodigo#,#empConsolida.Pvalor#,#rsCuentasComunes.Ccuenta#)>
        <cfif #CtaDestino# EQ 9999>   <!---NO EXISTE LA CUENTA DE ELIMINACION EN LA EMPRESA DESTINO--->
            <cfset Lprm_Fecha = createdate(Year(Now()),Month(Now()),Day(Now()))>
            <cftransaction>
                <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_Cmayor"   value="#rsCuentasComunes.Cmayor#"/>
                    <cfinvokeargument name="Lprm_Cdetalle" value="#mid(rsCuentasComunes.Cformato,6,100)#"/>
                    <cfinvokeargument name="Lprm_Fecha"    value="#Lprm_Fecha#"/>		
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                    <cfinvokeargument name="Lprm_DSN" value="#session.DSN#"/>
                    <cfinvokeargument name="Lprm_Ecodigo" value="#empConsolida.Pvalor#"/>
                    <cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
                    <cfinvokeargument name="Lprm_NoVerificarObras" value="true"/>
                </cfinvoke>
                <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                  <cfset m="Cuenta "& "#rsCuentasComunes.Cformato#: "&"#LvarERROR#">
                  <cflocation url="eliminarOperInterempresa.cfm?errorCta=1&Cuenta=#m#">
                </cfif> 
            </cftransaction>           
        </cfif>
        
        <!--- Calcular la cuenta de ASIENTO --->
        <cfset CformatoAsiento = formaCtaAsiento(#rsCuentasComunes.CFCuentaContable#,#rsCuentasComunes.Cformato#,#rsCuentasComunes.CFCuentaComplemento#)>
<!---        <cfset CmayorAsiento = "#Left(CformatoAsiento,4)#" & "YY" & "#mid(CformatoAsiento,6,100)#">
--->        
		<!--- Validar que la cuenta de ASIENTO exista en la empresa destino --->
        <cfquery name="rs_asientoDestino" datasource="#Session.DSN#">
            select a.Ccuenta
            from CContables a
            where 	a.Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#CformatoAsiento#"> and 
                    a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value= "#empConsolida.Pvalor#"> 		  
        </cfquery>
<!---        <cf_dump var="#CmayorAsiento#"> ---> 
       <cfif rs_asientoDestino.RecordCount EQ 0>   <!---NO EXISTE LA CUENTA DE ASIENTO EN LA EMPRESA DESTINO--->
            <cfset Lprm_Fecha = createdate(Year(Now()),Month(Now()),Day(Now()))>
            <cftransaction>
                <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_Cmayor"   value="#Left(CformatoAsiento,4)#"/>
                    <cfinvokeargument name="Lprm_Cdetalle" value="#mid(CformatoAsiento,6,100)#"/>
                    <cfinvokeargument name="Lprm_Fecha"    value="#Lprm_Fecha#"/>		
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                    <cfinvokeargument name="Lprm_DSN" value="#session.DSN#"/>
                    <cfinvokeargument name="Lprm_Ecodigo" value="#empConsolida.Pvalor#"/>
                    <cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
                    <cfinvokeargument name="Lprm_NoVerificarObras" value="true"/>
                </cfinvoke>
                <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                  <cfset m="Cuenta "& "#CformatoAsiento#: "&"#LvarERROR#">
                  <cflocation url="eliminarOperInterempresa.cfm?errorCta=1&Cuenta=#m#">
                </cfif> 
            </cftransaction>  
         </cfif>         
    </cfloop>
<!---INICIO DE ELIMINACION--->
   	<cfset LvarDescripcion = "#TRIM(rsEmpresaElim.Edescripcion)#"&' '&"#Form.periodo#"&'/'&"#form.mes#"&' Elim-IntEmpr'>
    <cfset LvarReferencia = 'Elim-IntEmpr'&"#Form.periodo#"&'/'&"#form.mes#">
      
    <cfquery datasource="#Session.DSN#">    
        insert into #Ccta_elim# ( Ecodigo,INTORI, INTREL, INTDOC, INTREF, 
        INTMON, 
        INTTIP,
        INTIPO,
        INTDES, 
        INTFEC, 
        INTCAM, Periodo, Mes, 
        Ccuenta, Ccuenta2, Mcodigo, Ocodigo, INTMOE,CFCuentaContable,Cformato,CFCuentaComplemento)
       
        select DISTINCT	a.Ecodigo,'EINT',1,'#polizaElimina.Pvalor#','#LvarReferencia#',
                abs(a.DLdebitos-a.CLcreditos),                
                case  
                    when d.Cbalancen='D' and (a.DLdebitos-a.CLcreditos)>0 then 'C'
                    when d.Cbalancen='C' and (a.DLdebitos-a.CLcreditos)<0 then 'D'                                        
                    else d.Cbalancen 
                end,
                case  
                    when d.Cbalancen='D' and (a.DOdebitos-a.COcreditos)>0 then 'C'
                    when d.Cbalancen='C' and (a.DOdebitos-a.COcreditos)<0 then 'D'                                        
                    else d.Cbalancen 
                end,
                '#LvarDescripcion#',a.BMFecha,
                1,a.Speriodo,a.Smes,                
                a.Ccuenta, 
				(select e.Ccuenta from CContables e
            		where e.Cformato = '#CformatoAsiento#' and 
                    	  e.Ecodigo  = #empConsolida.Pvalor#
                ),      
                a.Mcodigo,a.Ocodigo,
                abs(a.DOdebitos-a.COcreditos),
				b.CFCuentaContable,c.Cformato,b.CFCuentaComplemento
				              
        from SaldosContables a 
        inner join CContables c on c.Ccuenta =a.Ccuenta
        inner join Cons_CtaConEliminaInter1 b on c.Cformato like(#PreserveSingleQuotes(strreplace)#) and b.EcodigoEmp=c.Ecodigo
        inner join CtasMayor d on c.Cmayor=d.Cmayor and c.Ecodigo=d.Ecodigo   
        where a.Speriodo = #form.periodo# and a.Smes=#form.mes# and a.Ecodigo = #form.empresa#
    </cfquery>
    
    <cfquery name="rsa" datasource="#Session.DSN#">
        select Ecodigo,INTORI, INTREL, INTDOC, INTREF, 
        INTMON, 
        INTTIP,
        INTIPO, 
        INTDES, 
        INTFEC, 
        INTCAM, Periodo, Mes, 
        Ccuenta, Ccuenta2, Mcodigo, Ocodigo, INTMOE,CFCuentaContable,Cformato,CFCuentaComplemento
        from #Ccta_elim#
    </cfquery>
    <cfloop query="rsa">	
        <cfset CformatoAsiento = formaCtaAsiento(#rsa.CFCuentaContable#,#rsa.Cformato#,#rsa.CFCuentaComplemento#)>
        <cfquery name="rs_AsientoDest" datasource="#Session.DSN#">
            select a.Ccuenta
            from CContables a
            where 	a.Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#CformatoAsiento#"> and 
                    a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value= "#empConsolida.Pvalor#"> 		  
        </cfquery>
		<cfset CtaAsiento = #rs_AsientoDest.Ccuenta#>
		
		<cfquery name="rsCodigoMoneda" datasource="#Session.DSN#">
			select b.Mcodigo 
			from Monedas a
			join Monedas b on a.Miso4217=b.Miso4217
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsa.Ecodigo#"> and
				  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empConsolida.Pvalor#"> and
				  a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsa.Mcodigo#">
        </cfquery>
		<cfset CodMonedaDest = #rsCodigoMoneda.Mcodigo#>
		
        <cfset CtaDestino	= numCtaDestino(rsa.Ecodigo,empConsolida.Pvalor,rsa.Ccuenta)>
		<cfset saldoContableActual = ObtenerSaldoContable(rsa.Ecodigo,rsa.Periodo,rsa.Mes,rsa.Ccuenta,rsa.Mcodigo)>
		
		<cfset saldoActualD = ObtenerAjuste(rsa.Ecodigo,rsa.Periodo,rsa.Mes,rsa.INTDOC,CtaDestino,rsCodigoMoneda.Mcodigo,'D')>
        <cfset saldoActualC = ObtenerAjuste(rsa.Ecodigo,rsa.Periodo,rsa.Mes,rsa.INTDOC,CtaDestino,rsCodigoMoneda.Mcodigo,'C')>
				
        <cfif #saldoActualD.Mlocal# GT 0 or #saldoActualC.Mlocal# GT 0 or #saldoActualC.Moriginal# GT 0 or #saldoActualD.Moriginal# GT 0>
        	<cfset saldoFinINTMON = 0>
            <cfset saldoFinINTMOE = 0>
            
        	<cfif #saldoActualD.Mlocal# GT 0>
            	<cfif #saldoActualC.Mlocal# GT 0>
					<cfset saldoFinINTMON = saldoActualD.Mlocal-saldoActualC.Mlocal>
				<cfelse>
					<cfset saldoFinINTMON = saldoActualD.Mlocal>
				</cfif>
			<cfelse>
            	<cfif #saldoActualC.Mlocal# GT 0>
            		<cfset saldoFinINTMON = 0-saldoActualC.Mlocal>
                </cfif>
            </cfif>
            
            <cfif #saldoActualD.Moriginal# GT 0>  
            	<cfif #saldoActualC.Moriginal# GT 0>
					<cfset saldoFinINTMOE = saldoActualD.Moriginal-saldoActualC.Moriginal>
				<cfelse>
					<cfset saldoFinINTMOE = saldoActualD.Moriginal>
				</cfif>
            <cfelse>
            	<cfif #saldoActualC.Moriginal# GT 0>
					<cfset saldoFinINTMOE = 0-saldoActualC.Moriginal>
				</cfif>
			</cfif>
				
            <cfquery datasource="#Session.DSN#">
                update #Ccta_elim# set
                	Ccuenta = #CtaDestino#, 
					Ccuenta2 = #CtaAsiento#,	  
					INTMON   = abs(#saldoContableActual.SLfinal#+#saldoFinINTMON#),
					INTMOE   = abs(#saldoContableActual.SOfinal#+#saldoFinINTMOE#),
					Mcodigo  = #CodMonedaDest#,
                    INTTIP   = 
					case  
						when '#saldoContableActual.Cbalancen#' ='D' and (#saldoContableActual.SLfinal#+#saldoFinINTMON#)>0 then 'C' 
						when '#saldoContableActual.Cbalancen#' ='C' and (#saldoContableActual.SLfinal#+#saldoFinINTMON#)<0 then 'D'
						else '#saldoContableActual.Cbalancen#' 
					end,
                    INTIPO  = 
					case  
						when '#saldoContableActual.Cbalancen#' ='D' and (#saldoContableActual.SOfinal#+#saldoFinINTMOE#)>0 then 'C' 
						when '#saldoContableActual.Cbalancen#' ='C' and (#saldoContableActual.SOfinal#+#saldoFinINTMOE#)<0 then 'D'
						else '#saldoContableActual.Cbalancen#' 
					end
                where 
                    Periodo     = <cfqueryparam cfsqltype="cf_sql_integer" value= "#rsa.Periodo#">
                    and Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsa.Mes#">
                    and INTDOC  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsa.INTDOC#">
                    and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsa.Ccuenta#">  
                    and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsa.Mcodigo#">
            </cfquery>
      	<cfelse>
            <cfquery datasource="#Session.DSN#">
                update #Ccta_elim# set
                	Ccuenta = #CtaDestino#,
					Ccuenta2 = #CtaAsiento#,
					Mcodigo = #CodMonedaDest#						  
                where 
                    Periodo     = <cfqueryparam cfsqltype="cf_sql_integer" value= "#rsa.Periodo#">
                    and Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsa.Mes#">
                    and INTDOC  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsa.INTDOC#">
                    and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsa.Ccuenta#">  
                    and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsa.Mcodigo#">
            </cfquery>
        </cfif>
    </cfloop>

    <cftransaction action="begin">
<!---Cuando los montos en Moneda Local y Origen tienen el mismo movimiento ambos C o D --->    
        <cfquery datasource="#Session.DSN#">     
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
            INTMON, 
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, Mcodigo, Ocodigo, INTMOE)
           
            select  INTORI, INTREL, INTDOC, INTREF, 
            INTMON, 
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, 
            Mcodigo, Ocodigo, 
            INTMOE
            from #Ccta_elim#
            where INTTIP=INTIPO
		</cfquery> 
<!---Cuando los montos en Moneda Local y Origen tienen el diferente movimiento uno C y el otro D o viceversa---> 
<!---Ingreso un movimiento para la moneda origen y cero para la moneda local---> 
        <cfquery datasource="#Session.DSN#">     
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
            INTMON, 
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, Mcodigo, Ocodigo, INTMOE)
           
            select  INTORI, INTREL, INTDOC, INTREF, 
            INTMON, 
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, 
            Mcodigo, Ocodigo, 
            0
            from #Ccta_elim#
            where INTTIP!=INTIPO
		</cfquery>
<!---Ingreso un movimiento para la moneda local y cero para la moneda origen, con el movimiento de la moneda origen---> 
        <cfquery datasource="#Session.DSN#">     
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
            INTMON, 
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, Mcodigo, Ocodigo, INTMOE)
           
            select  INTORI, INTREL, INTDOC, INTREF, 
            0, 
            INTIPO, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, 
            Mcodigo, Ocodigo, 
            INTMOE
            from #Ccta_elim#
            where INTTIP!=INTIPO
		</cfquery> 
         
        
<!---Se guardan los saldos por cuenta de Origen con el movimiento Origen y el movimiento local--->        
        <cfquery datasource="#Session.DSN#">
			insert into Cons_SaldosXCuenta(CEcodigo,Ecodigo,Eperiodo,Emes,Ddocumento,Ccuenta,Mcodigo,INTMOE,INTMON,Dmovimiento,DOmovimiento)
			select #Session.cecodigo#,#form.empresa#,Periodo, Mes,INTDOC,Ccuenta,Mcodigo,INTMOE,INTMON,INTTIP,INTIPO from #Ccta_elim#
            where INTMON<>0 or INTMOE<>0
       	</cfquery>
        
<!---Cuando los montos en Moneda Local y Origen tienen el mismo movimiento ambos C o D --->    
        <cfquery datasource="#Session.DSN#">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
            INTMON,
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, Mcodigo, Ocodigo, INTMOE)
            
            select  INTORI, INTREL, INTDOC, INTREF, 
            INTMON, 
            case when INTTIP = 'D' then 'C' else 'D' end, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta2, 
            Mcodigo, Ocodigo, 
            INTMOE
            from #Ccta_elim#
            where INTTIP=INTIPO
		</cfquery>
<!---Ingreso un movimiento para la moneda origen y cero para la moneda local---> 
        <cfquery datasource="#Session.DSN#">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
            INTMON,
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, Mcodigo, Ocodigo, INTMOE)
            
            select  INTORI, INTREL, INTDOC, INTREF, 
            INTMON, 
            case when INTTIP = 'D' then 'C' else 'D' end, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta2, 
            Mcodigo, Ocodigo, 
            0
            from #Ccta_elim#
            where INTTIP!=INTIPO
		</cfquery>
<!---Ingreso un movimiento para la moneda local y cero para la moneda origen, con el movimiento de la moneda origen---> 
        <cfquery datasource="#Session.DSN#">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
            INTMON,
            INTTIP, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta, Mcodigo, Ocodigo, INTMOE)
            
            select  INTORI, INTREL, INTDOC, INTREF, 
            0, 
            case when INTIPO = 'D' then 'C' else 'D' end, 
            INTDES, 
            INTFEC, 
            INTCAM, Periodo, Mes, 
            Ccuenta2, 
            Mcodigo, Ocodigo, 
            INTMOE
            from #Ccta_elim#
            where INTTIP!=INTIPO
		</cfquery>

<!---  Ejecutar el Genera Asiento    --->
		<cfset vRetroactivo = false>
		<cfif #form.periodo# lt #periodo_actual.Pvalor#>
        	<cfset vRetroactivo = true>
        <cfelse>
        	<cfif #form.periodo# eq #periodo_actual.Pvalor# and #form.mes# lt #mes_contable.Pvalor#>
            	<cfset vRetroactivo = true>
            </cfif>
		</cfif> 
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="retIDcontable" method="GeneraAsiento"
            Oorigen 		= "EINT"
            Cconcepto       = "#polizaElimina.Pvalor#"
            Eperiodo		= "#form.periodo#"
            Emes			= "#form.mes#"
            Efecha			= "#Createdate(year(now()),month(now()), day(Now()))#"
            Edescripcion	= "#LvarDescripcion#"
            Edocbase		= ""
            Ereferencia		= "#LvarReferencia#"            
            Retroactivo		= "#vRetroactivo#"
            />    
	
	</cftransaction>
</cfif>
<cflocation url="eliminarOperInterempresa.cfm">
