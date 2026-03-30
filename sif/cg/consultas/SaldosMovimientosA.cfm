
<cfset Param = "">

<!--- Cuenta Contable--->

<cfif isdefined("Form.Exportar") And Form.Exportar EQ "Si">
	<cfset form.toExcel = "on">
</cfif>

<cfif isdefined("Url.Ccuenta1") and not isdefined("Form.Ccuenta1")>
	<cfset Form.Ccuenta1 = Url.Ccuenta1>
    <cfset Param = Param & "?Ccuenta1="&#Form.Ccuenta1#>  
</cfif>

<cfif isdefined("Url.Ccuenta2") and not isdefined("Form.Ccuenta2")>
	<cfset Form.Ccuenta2 = Url.Ccuenta2>
    <cfset Param = Param & "&Ccuenta2="&#Form.Ccuenta2#> 
</cfif>

<!--- Descripción de la Cuenta--->
<cfif isdefined("Url.cdescripcion1") and not isdefined("Form.cdescripcion1")>
	<cfset Form.cdescripcion1 = Url.cdescripcion1>
    <cfset Param = Param & "&cdescripcion1="&#Form.cdescripcion1#> 
</cfif>

<cfif isdefined("Url.cdescripcion2") and not isdefined("Form.cdescripcion2")>
	<cfset Form.cdescripcion2 = Url.cdescripcion2>
    <cfset Param = Param & "&cdescripcion2="&#Form.cdescripcion2#>  
</cfif>

<cfif isdefined("Url.cfcuenta1") and not isdefined("Form.cfcuenta1")>
	<cfset Form.cfcuenta1 = Url.cfcuenta1>
    <cfset Param = Param & "&cfcuenta1="&#Form.cfcuenta1#> 
</cfif>

<cfif isdefined("Url.cfcuenta2") and not isdefined("Form.cfcuenta2")>
	<cfset Form.cfcuenta2 = Url.cfcuenta2>
    <cfset Param = Param & "&cfcuenta2="&#Form.cfcuenta2#> 
</cfif>

<!--- Formato de la cuenta--->
<cfif isdefined("Url.cformato1") and not isdefined("Form.cformato1")>
	<cfset Form.cformato1 = Url.cformato1>
    <cfset Param = Param & "&cformato1="&#Form.cformato1#> 
</cfif>

<cfif isdefined("Url.cformato2") and not isdefined("Form.cformato2")>
	<cfset Form.cformato2 = Url.cformato2>
    <cfset Param = Param & "&cformato2="&#Form.cformato2#> 
</cfif>

<!--- Cuenta del mayor--->
<cfif isdefined("Url.Cmayor1") and not isdefined("Form.Cmayor1")>
	<cfset Form.Cmayor1 = Url.Cmayor1>
    <cfset Param = Param & "&Cmayor1="&#Form.Cmayor1#>  
</cfif>

<cfif isdefined("Url.Cmayor2") and not isdefined("Form.Cmayor2")>
	<cfset Form.Cmayor2 = Url.Cmayor2>
    <cfset Param = Param & "&Cmayor2="&#Form.Cmayor2#> 
</cfif>

<cfif isdefined("Url.Cmayor_id") and not isdefined("Form.Cmayor_id")>
	<cfset Form.Cmayor_id = Url.Cmayor_id>
    <cfset Param = Param & "&Cmayor_id="&#Form.Cmayor_id#> 
</cfif>

<cfif isdefined("Url.Cmayor_mask") and not isdefined("Form.Cmayor_mask")>
	<cfset Form.Cmayor_mask = Url.Cmayor_mask>
    <cfset Param = Param & "&Cmayor_mask="&#Form.Cmayor_mask#> 
</cfif>

<!--- Opción para exportar a excell--->
<cfif isdefined("Url.Exportar") and not isdefined("Form.Exportar")>
	<cfset Form.Exportar = Url.Exportar>
    <cfset Param = Param & "&Exportar="&#Form.Exportar#> 
</cfif>

<!--- Codigo de la Moneda--->
<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfset Form.Mcodigo = url.Mcodigo>
    <cfset Param = Param & "&Mcodigo="&#Form.Mcodigo#> 
</cfif>

<!--- 0 Selecciono otra moneda que no es la local, -2 no selecciono ningún tipo de moneda--->
<cfif isdefined("Url.Mcodigoopt") and not isdefined("Form.Mcodigoopt")>
	<cfset Form.Mcodigoopt = url.Mcodigoopt>
    <cfset Param = Param & "&Mcodigoopt="&#Form.Mcodigoopt#>
</cfif>

<!--- Periodo Seleccionado--->
<cfif isdefined("Url.Periodo") and not isdefined("Form.Periodo")>
	<cfset Form.Periodo = url.Periodo>
    <cfset Param = Param & "&Periodo="&#Form.Periodo#>
</cfif>

<cfif  isdefined("Url.imprimir")>
    <div style="width:1000px">
    &nbsp;
    </div>
<cfelse>
    <cf_templatecss>
    <cfif not isdefined("form.toExcel")>
        <cf_templatecss>   
        <table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
          <tr align="left"> 
            <td><a href="/cfmx/sif/">SIF</a></td>
            <td>|</td>
            <td nowrap><a href="../MenuCG.cfm">Contabilidad General</a></td>
            <td>|</td>
            <td nowrap><a href="javascript:regresar()">Regresar</a></td>
            <td>|</td>
            <td width="100%"><a href="javascript:exportar()">Exportar</a></td>
          </tr>
        </table>
    </cfif>
</cfif>

<script type="text/javascript">
	function exportar(){
		document.form2.action = 'SaldosMovimientosA.cfm';
		document.form2.Exportar.value = 'Si';
		document.form2.submit();
	}
	
	function regresar(){
		document.form2.action = 'SaldosMovimientosAT.cfm';
		document.form2.submit();
	}	
	
</script>

<!--- Obtiene el código de la empresa y la descripción o nombre de la misma--->
<cfquery name="Empresas" datasource="#Session.DSN#">
	select Ecodigo, Edescripcion 
	from Empresas 
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Se define el tipo de moneda para los montos contables--->
<cfif isdefined("Form.Mcodigoopt") and Form.Mcodigoopt EQ "0">
	<cfset varMonedas = Form.Mcodigo>
    <cfquery name="rsMoneda" datasource="#Session.DSN#">
        Select Mcodigo, Mnombre
        From Monedas
        Where
            Ecodigo = #session.Ecodigo# And
            Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varMonedas#">
    </cfquery>
<cfelse>
	<cfquery name="rs_Monloc" datasource="#Session.DSN#">
        Select E.Mcodigo, M.Mnombre 
        From Empresas E
            Inner Join Monedas M On
                M.Mcodigo = E.Mcodigo And
                M.Ecodigo = #session.Ecodigo#
        Where E.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
		<cfset varMonedas = rs_Monloc.Mcodigo>
	</cfif>	
</cfif>

<!---<cfif not isdefined("form.toExcel")>
	<cf_rhimprime datos="/sif/cg/consultas/SaldosMovimientosA.cfm" paramsuri="#Param#">     
</cfif>--->

<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=SaldosMovimientosA_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>

<!--- Descripción de la Cuenta Contable--->
<cffunction name="rsInformacionCuenta" returntype="query">
<cfargument name="Ccuenta" required="yes" type="numeric">
    <cfquery name="rsCuenta" datasource="#session.DSN#">
        Select Ccuenta, Cmayor, Cformato, Cdescripcion,Cmovimiento
        From CContables
        Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Ccuenta =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">
    </cfquery>
    <cfreturn rsCuenta>
</cffunction>

<!--- Obtiene último mes del cierre fiscal de la empresa--->
<cfquery name="rsUltimoMes" datasource="#Session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = #session.Ecodigo#  
	and Pcodigo = 45
	and Mcodigo = 'CG'
</cfquery>

<cfset LvarPrimerMes = 1>
<cfif isdefined('rsUltimoMes') and rsUltimoMes.recordcount GT 0>
	<cfset LvarPrimerMes = rsUltimoMes.Pvalor + 1>
	<cfif LvarPrimerMes EQ 13>
		<cfset LvarPrimerMes = 1>
	</cfif>
</cfif>

<!--- Obtiene los meses contables correspondientes a la empresa--->
<cfquery name="rsMeses" datasource="#Session.DSN#">
    Select 
        1 As Orden, 
        <cf_dbfunction name='to_number' args="VSvalor"> As Mes, 
        VSdesc As Mesd, 
        <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodo#"> As Periodo
    From VSidioma
    Where VSgrupo = 1
      And Iid = 1
      And <cf_dbfunction name='to_number' args="VSvalor"> >= #LvarPrimerMes#

    <cfif LvarPrimerMes NEQ 1>
        Union
        Select 
            2 As Orden, 
            <cf_dbfunction name='to_number' args="VSvalor"> As Mes, 
            VSdesc As Mesd, 
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodo + 1 #"> As Periodo
        From VSidioma
        Where VSgrupo = 1
          And Iid = 1
          And <cf_dbfunction name='to_number' args="VSvalor"> < #LvarPrimerMes#

        Union
        Select 
            3 as Orden, 
            #LvarPrimerMes# As Mes, 
            'Cierre' As Mesd, 
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodo + 1#"> As Periodo
        From dual
        Order by 1, 2

    <cfelse>
        Union
        Select 
            3 As Orden, 
            #LvarPrimerMes# As Mes, 
            'Cierre' As Mesd, 
            <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.Periodo + 1#"> As Periodo
         From dual
    Order By 1, 2
    </cfif>
</cfquery>

<cfquery name="rsCuentasContables" datasource="#Session.DSN#">
	Select * 
    From 
    	CContables
   	Where
    	Ecodigo = #session.Ecodigo# And
        Cmovimiento = 'S' And
        Cformato Between 
        	(Select Cformato From CContables Where Ccuenta = #Form.Ccuenta1# And Ecodigo = #session.Ecodigo#) And 
            (Select Cformato From CContables Where Ccuenta = #Form.Ccuenta2# And Ecodigo = #session.Ecodigo#)
    Order By
    	Cformato    
</cfquery>

<cfset ultimoMes = "">
<cfset nextAno = "">

<cfif #rsMeses.Mes# EQ "1">
	<cfset ultimoMes = "12">
    <cfset nextAno = #rsMeses.Periodo#>
<cfelse>
	<cfset ultimoMes = #rsMeses.Mes# - 1>
    <cfset nextAno = #rsMeses.Periodo# + 1>
</cfif>

<!---<cfdump var="#rsMeses#">
<cfdump var="#rsMeses.Mes#">
<cfdump var="#ultimoMes#">
<cfdump var="#nextAno#">--->

<!--- Se seleccionan todas las oficinas que tienen asociada una cuenta contable--->
<cffunction name="rsOficinasCuenta" returntype="query">
<cfargument name="Ccuenta" required="yes" type="numeric">
    <cfquery name="rsOficinas" datasource="#Session.DSN#">    
        Select 
            Distinct OFN.Ocodigo, OFN.Oficodigo, OFN.Ecodigo, OFN.Odescripcion
        From 
            HDContables HD 
                Inner Join SaldosContables SCA On
                    SCA.Ccuenta = HD.Ccuenta<!--- And
                    SCA.Smes = #rsMeses.Mes#--->
                Inner Join Oficinas OFN On 
                    (HD.Ocodigo = OFN.Ocodigo)
        Where 
            HD.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#"> And 
            HD.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMeses.Periodo#">  And 
            HD.Ecodigo = #session.Ecodigo#  And
            OFN.Ecodigo = #session.Ecodigo# And
            HD.Emes Between 
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMeses.Mes#"> And 12
            <cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                And HD.Mcodigo = #varMonedas#
            </cfif>        
            
        Union
        
        Select 
            Distinct OFN.Ocodigo, OFN.Oficodigo, OFN.Ecodigo, OFN.Odescripcion
        From 
            DContables DC 
                Inner Join SaldosContables SCA On
                    SCA.Ccuenta = DC.Ccuenta<!--- And
                    SCA.Smes = #rsMeses.Mes#  --->                  
                Inner Join Oficinas OFN On 
                    (DC.Ocodigo = OFN.Ocodigo)
        Where 
            DC.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#"> And 
            DC.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMeses.Periodo#">  And 
            DC.Ecodigo = #session.Ecodigo#  And
            OFN.Ecodigo = #session.Ecodigo# And
            DC.Emes Between 
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMeses.Mes#"> And 12            
            <cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                And DC.Mcodigo = #varMonedas#
            </cfif>        
              
        <cfif LvarPrimerMes NEQ 1>
            Union
            Select 
                Distinct OFN.Ocodigo, OFN.Oficodigo, OFN.Ecodigo, OFN.Odescripcion
            From 
                HDContables HD 
                    Inner Join SaldosContables SCA On
                        SCA.Ccuenta = HD.Ccuenta<!--- And
                        SCA.Smes = #rsMeses.Mes#--->
                    Inner Join Oficinas OFN On 
                        (HD.Ocodigo = OFN.Ocodigo)
            Where 
                HD.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#"> And 
                HD.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#nextAno#">  And 
                HD.Ecodigo = #session.Ecodigo#  And
                OFN.Ecodigo = #session.Ecodigo# And
            	HD.Emes Between 
            		1 And <cfqueryparam cfsqltype="cf_sql_integer" value="#ultimoMes#"> 
                <cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                    And HD.Mcodigo = #varMonedas#
                </cfif>             
            Union
            
            Select 
                Distinct OFN.Ocodigo, OFN.Oficodigo, OFN.Ecodigo, OFN.Odescripcion
            From 
                DContables DC 
                    Inner Join SaldosContables SCA On
                        SCA.Ccuenta = DC.Ccuenta<!--- And
                        SCA.Smes = #rsMeses.Mes# --->   
                    Inner Join Oficinas OFN On 
                        (DC.Ocodigo = OFN.Ocodigo)
            Where 
                DC.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#"> And 
                DC.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#nextAno#">  And 
                DC.Ecodigo = #session.Ecodigo#  And
                OFN.Ecodigo = #session.Ecodigo# And
            	DC.Emes Between 
            		1 And <cfqueryparam cfsqltype="cf_sql_integer" value="#ultimoMes#">  
                <cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                    And DC.Mcodigo = #varMonedas#
                </cfif>  
        </cfif>
         Order By 
            Oficodigo
    </cfquery>
    <cfreturn rsOficinas>
</cffunction>

<!---<cfif rsOficinas.recordcount LT 1>
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		Select 
        	o.Ocodigo, o.Oficodigo, o.Ecodigo, o.Odescripcion
		From 
        	Oficinas o
		Where 
        	o.Ecodigo = #Session.Ecodigo#
		Order By 
        	o.Oficodigo
	</cfquery>
</cfif>--->

<script language="JavaScript">
	function Asignar(mes, oficina, periodo, MesCierre, Tabla, Cuenta) {
		document.form2.Oficina.value = oficina;
		document.form2.Mes.value = mes;
		document.form2.PeriodoLista.value = periodo;
		document.form2.Ccuenta.value = Cuenta; 
		document.form2.MesCierre.value = MesCierre; 
		document.form2.Tabla.value = Tabla; <!--- Tabla--->
		document.form2.action = 'SaldosMovimientosB1.cfm';
		document.form2.submit();
	}
</script>

<Form name="form2" action="SaldosMovimientosB1.cfm" method="post">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
            <cfoutput>
                <td align="right" width="100%" colspan="3"> 
                <cfparam name="Form.CFcuenta" default=" ">
                <cfparam name="Form.Cmayor_id" default=" ">
                <cfparam name="Form.Cmayor_mask" default=" ">                
                <!---<cfset params = "ccuenta=#Form.ccuenta#&cdescripcion=#rsCuentaContable.cdescripcion#&cfcuenta=#Form.cfcuenta#&cformato=#Form.cformato#&cmayor=#Form.cmayor#&cmayor_id=#Form.cmayor_id#&cmayor_mask=#Form.cmayor_mask#&mcodigo=#Form.mcodigo#&mcodigoopt=#Form.mcodigoopt#&periodos=#Form.periodos#"> --->
                </td>	
            </cfoutput>
        </tr>
    </table>
    <cfoutput>
    <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
            <td colspan="4"><div align="center"><strong>#Empresas.Edescripcion#</strong></div></td>
        </tr>
        <tr> 
            <td colspan="4" align="center"><font size="2"><strong>Saldos y Movimientos</strong></font></td>
        </tr> 
        <tr>
            <td width="16%" align="center"><strong>Periodo&nbsp;#Form.Periodo#<cfif LvarPrimerMes NEQ 1>-#Form.Periodo + 1#</strong></cfif></td>
        </tr>
        <tr>
            <td width="16%" align="center">
                <strong>
					<cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                        Moneda:&nbsp;#rsMoneda.Mnombre#
                   <cfelse>
                   		Moneda:&nbsp;#rs_Monloc.Mnombre#
                    </cfif>                  
                </strong>
            </td>
        </tr>        
        <tr> 
            <td align="center" colspan="4">&nbsp;</td>
        </tr>                          
	<table width="98%" border="0" cellpadding="0" cellspacing="0"  align="center"> 
    <cfset contadorCuentas = 0>          
		<cfif (rsCuentasContables.recordcount gt 0) And (rsCuentasContables.recordcount lt 100)>
       <!--- <cfif rsCuentasContables.recordcount gt 100>--->
        <cfif isdefined("form.toExcel")>
        	<cfset oldlocale = SetLocale("French (Canadian)")>
       	</cfif>
        	<cfloop query="rsCuentasContables">
				<cfset rsOficinas = rsOficinasCuenta(#rsCuentasContables.Ccuenta#)>
                <cfset rsCuenta = rsInformacionCuenta(#rsCuentasContables.Ccuenta#)>                
                <cfif rsOficinas.recordcount gt 0>
                <tr>
                    <td colspan="14" align="center"><font size="2"><strong>Cuenta&nbsp;#rsCuenta.Cformato#</strong></font></td>
                </tr> 
                <tr>
                    <td colspan="14" align="center"><font size="2"><strong>#rsCuenta.Cdescripcion#</strong></font></td>
                </tr>               
                <tr> 
                    <td align="center" colspan="4">&nbsp;</td>
                </tr>                
				<cfset contador = 1>
                <tr>
                    <td  width="5%" align="center"><strong>&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>				
                    <cfloop query="rsMeses">
                        <cfset contador = contador + 1>
                        <cfif contador EQ rsMeses.recordcount + 1>
                            <td  width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black; border-right:1px solid black;" align="center"><strong>#rsMeses.Mesd#</strong></td>                    	
                        <cfelse>
                            <td  width="8%" style=" border-bottom:1px solid black;  border-top:1px solid black;  border-left:1px solid black;" align="center"><strong>#rsMeses.Mesd#</strong></td>
                        </cfif>
                    </cfloop>                                
                </tr>
                <cfset ArregloTotalGeneral = arraynew(1)>   
                <cfset contadorCuentas = contadorCuentas + 1> 
                <!---<cfif rsOficinas.recordcount gt 0>--->
                <cfloop query="rsOficinas">
                    <tr>
                        <td colspan="14" align="left"  bgcolor="BCBCBC">
                            <strong>Oficina&nbsp;#rsOficinas.OfiCodigo#&nbsp;--&nbsp;#rsOficinas.Odescripcion#</strong>
                        </td>
                    </tr>
                    <tr>
                        <td  width="8%" style="border-bottom:1px solid black;">
                            <strong>Saldos</strong>                       
                        </td>
                        <cfset contador = 1>
                        <cfset ArregloMontosMes = arraynew(1)>                
                        <cfloop query="rsMeses">
                           	<cfquery name="rsSaldos" datasource="#Session.DSN#">    
                                    Select 
                                    <cfif isdefined('Form.McodigoOpt') and Form.McodigoOpt GTE 0>
                                        Sum(SOinicial <cfif rsMeses.Orden NEQ 3> + DOdebitos-COcreditos</cfif>) as Total
                                    <cfelse>
                                        Sum(SLinicial <cfif rsMeses.Orden NEQ 3> + DLdebitos-CLcreditos</cfif>) as Total
                                    </cfif>
                                    From SaldosContables SC
                                    Where SC.Ccuenta =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasContables.Ccuenta#">
                                      And SC.Speriodo = #rsMeses.Periodo#
                                      And SC.Smes     = #rsMeses.Mes#
                                      And SC.Ecodigo  = #session.Ecodigo#
                                      And SC.Ocodigo  = #rsOficinas.OCodigo#
                                      <cfif isdefined('Form.McodigoOpt') and Form.McodigoOpt GTE 0>
                                          and SC.Mcodigo = #varMonedas#
                                      </cfif>
                                </cfquery> 
                                
                                <cfquery name="rsMovimientos" datasource="#Session.DSN#">
                                    Select
                                        <cfif isdefined('Form.McodigoOpt') and Form.McodigoOpt GTE 0>
                                            Sum(DC.Doriginal * Case When DC.Dmovimiento = 'C' then -1 Else 1 End) As Total
                                        <cfelse>
                                            Sum(DC.Dlocal * Case When DC.Dmovimiento = 'C' then -1 Else 1 End) As Total
                                        </cfif>
                                    From
                                        HDContables DC
                                        	Inner Join HEContables HEC On
                                           		HEC.IDcontable = DC.IDcontable
                                    Where
                                        DC.Eperiodo = #rsMeses.Periodo# And
                                        DC.Ocodigo = #rsOficinas.OCodigo# And
                                        <cfif rsMeses.Orden NEQ 3>
                                       		HEC.ECtipo <> 1 And
                                        	DC.Emes = #rsMeses.Mes# And                                            
                                       	<cfelse>
                                        	HEC.ECtipo = 1 And
                                        	DC.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMeses.Mes - 1#"> And                                            
                                      	</cfif>
                                        DC.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasContables.Ccuenta#"> 
                                      <cfif isdefined('Form.McodigoOpt') and Form.McodigoOpt GTE 0>
                                        And DC.Mcodigo = #varMonedas#
                                      </cfif>                                                                 
                                </cfquery>
                                                                
                                <cfif isdefined('rsSaldos') and len(rsSaldos.Total) GT 0>
                                <td  width="8%" style="border-bottom:1px solid black;">
                                <cfif not isdefined("form.toExcel")>
									<cfif (isdefined('rsMovimientos') and len(rsMovimientos.Total) GT 0)>
                                        <a href="javascript:Asignar(#rsMeses.Mes#,#rsOficinas.OCodigo#,#rsMeses.Periodo#, '#rsMeses.Orden EQ 3#', 'HDContables', #rsCuentasContables.Ccuenta#);">                            
                                            <font 
                                                <cfif rsSaldos.Total LT 0>color="red"<cfelseif rsSaldos.Total EQ 0>color="blue" 
                                                </cfif>>#LSNumberFormat(rsSaldos.Total, ",.00()")#
                                            </font>
                                        </a>
                                    <cfelse>
                                        <font 
                                            <cfif rsSaldos.Total LT 0>color="red"</cfif>>#LSNumberFormat(rsSaldos.Total, ",.00()")#
                                        </font>                                    	
                                    </cfif>
                                <cfelse>
                                    <font 
                                        <cfif rsSaldos.Total LT 0>color="red"<cfelseif rsSaldos.Total EQ 0>color="blue" 
                                        </cfif>>#LSNumberFormat(rsSaldos.Total, "(_________.___)")#
                                    </font>                            	
                                </cfif>
                                    <cfset ArregloMontosMes[contador] = rsSaldos.Total>
                                    <cfif arrayLen(#ArregloTotalGeneral#) LT contador>	
                                        <cfset ArregloTotalGeneral[contador] = rsSaldos.Total>
                                    <cfelse>
                                        <cfset ArregloTotalGeneral[contador] = ArregloTotalGeneral[contador] + rsSaldos.Total>
                                    </cfif>
                                </td>
                                <cfelse>
                                <td  width="8%" style="border-bottom:1px solid black;">
                                    <cfif not isdefined("form.toExcel")>
                                        #LSNumberFormat(0, ",.00")#
                                    <cfelse>
                                        #LSNumberFormat(0, "(_________.___)")#
                                    </cfif>
                                    <cfset ArregloMontosMes[contador] = 0>
                                    <cfif arrayLen(#ArregloTotalGeneral#) LT contador>
                                        <cfset ArregloTotalGeneral[contador] = 0>
                                    <cfelse>
                                        <cfset ArregloTotalGeneral[contador] = ArregloTotalGeneral[contador] + 0>
                                    </cfif>
                                </td>
                                </cfif>                           
                            <!---</cfif>--->
                            <cfset contador = contador + 1>                        
                        </cfloop>                     
                    </tr>
                    <tr>
                        <!--- Montos en transito--->
                        <td  width="8%" style="border-bottom:1px solid black;">
                            <strong>Transito</strong>
                        </td>
                        <cfset contador = 1>
                        <cfloop query="rsMeses">
                            <cfif rsMeses.Mesd EQ 'Cierre'>
                                <td  width="8%" style="border-bottom:1px solid black;"></td>
                            <cfelse>                      
                                <cfquery name="rsSaldos" datasource="#Session.DSN#">
                                    Select
                                        <cfif isdefined('Form.McodigoOpt') and Form.McodigoOpt GTE 0>
                                            Sum(DC.Doriginal * Case When DC.Dmovimiento = 'C' then -1 Else 1 End) As Total
                                        <cfelse>
                                            Sum(DC.Dlocal * Case When DC.Dmovimiento = 'C' then -1 Else 1 End) As Total
                                        </cfif>
                                    From
                                        DContables DC
                                    Where
                                        DC.Eperiodo = #rsMeses.Periodo# And
                                        DC.Emes = #rsMeses.Mes# And
                                        DC.Ocodigo = #rsOficinas.OCodigo# And
                                        DC.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasContables.Ccuenta#"> 
                                      <cfif isdefined('Form.McodigoOpt') and Form.McodigoOpt GTE 0>
                                        And DC.Mcodigo = #varMonedas#
                                      </cfif>                                                                 
                                </cfquery>
                                <!---<cfif rsSaldos.Total NEQ ''>   --->
                                <cfif isdefined('rsSaldos') and len(rsSaldos.Total) GT 0>
                                <td  width="8%" style="border-bottom:1px solid black;">
                                    <cfif not isdefined("form.toExcel")>
                                        <a href="javascript:Asignar(#rsMeses.Mes#,#rsOficinas.OCodigo#,#rsMeses.Periodo#, '#rsMeses.Orden EQ 3#', 'DContables', #rsCuentasContables.Ccuenta#);">
                                            <font 
                                                <cfif rsSaldos.Total LT 0>color="red"<cfelseif rsSaldos.Total EQ 0>color="blue" 
                                                </cfif>>#LSNumberFormat(rsSaldos.Total, ",.00()")#
                                            </font>                                	
                                        </a>
                                    <cfelse>
                                        <font 
                                            <cfif rsSaldos.Total LT 0>color="red"<cfelseif rsSaldos.Total EQ 0>color="blue" 
                                            </cfif>>#LSNumberFormat(rsSaldos.Total, "(_________.___)")#
                                        </font> 
                                    </cfif>
                                    <cfset ArregloMontosMes[contador] = ArregloMontosMes[contador] + rsSaldos.Total>
                                    <cfset ArregloTotalGeneral[contador] = ArregloTotalGeneral[contador] + rsSaldos.Total>
                                </td>
                                <cfelse>
                               <td  width="8%" style="border-bottom:1px solid black;">
                                    <cfif not isdefined("form.toExcel")>
                                        #LSNumberFormat(0, ",.00")#
                                    <cfelse>
                                        #LSNumberFormat(0, "(_________.___)")#
                                    </cfif>
                                </td>
                                </cfif>
                            </cfif>    
                            <cfset contador = contador + 1>                    
                        </cfloop>                                       
                    </tr>
                    <tr>
                        <td  width="8%" style="border-bottom:1px solid black;">
                            <strong>Total</strong>
                        </td>
                        <cfset contador = 1>
                        <cfloop index="i" from="1" to="#arrayLen(ArregloMontosMes)#">
                            <td  width="8%" style="border-bottom:1px solid black;">
                                <strong>
                                    <font <cfif ArregloMontosMes[i] LT 0>color="red" </cfif>>
                                         <cfif not isdefined("form.toExcel")>
                                            #LSNumberFormat(ArregloMontosMes[i], ",.00()")#
                                        <cfelse>
                                            #LSNumberFormat(ArregloMontosMes[i], "(_________.___)")#
                                        </cfif>
                                    </font>
                                </strong>                        
                            </td>
                        </cfloop>               
                    </tr>                
                    <tr><td colspan="14">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>                
                </cfloop>
                <tr>
                    <td  width="8%" bgcolor="lightgrey" style="border-bottom:1px solid black;">
                        <strong>Total General</strong>
                    </td>
                    <cfset contador = 1>
                    <cfloop index="i" from="1" to="#arrayLen(ArregloTotalGeneral)#">
                        <td  width="8%" bgcolor="lightgrey" style="border-bottom:1px solid black;">
                            <strong>
                                <font  <cfif ArregloTotalGeneral[i] LT 0>color="red" </cfif>>
                                    <cfif not isdefined("form.toExcel")>
                                        #LSNumberFormat(ArregloTotalGeneral[i], ",.00()")#
                                    <cfelse>
                                        #LSNumberFormat(ArregloTotalGeneral[i], "(_________.___)")#
                                    </cfif>
                                </font>
                            </strong>
                        </td>
                    </cfloop>                               
                </tr>
                <tr> 
                    <td align="center" colspan="4">&nbsp;</td>
                </tr>                
                <cfelse>
<!---                <tr>
                    <td colspan="14" align="center"><font size="2"><strong>La Cuenta Contable&nbsp;#rsCuenta.Cformato#: &nbsp;#rsCuenta.Cdescripcion# no tuvo movimientos en las oficinas</strong></font></td>
                </tr>--->               
                </cfif>
            </cfloop> 
            <cfelse>
                <tr>
                    <td colspan="14" align="center"><font size="2"><strong>El rango entre cuentas no debe ser superior a los 100 registros</strong></font></td>
                </tr>             	                                                           
        </cfif>
        <tr>
            <td colspan="14" align="center"><font size="2"><strong>N&uacute;mero de Registros:&nbsp;#contadorCuentas#</strong></font></td>
        </tr>          
    	</table>
    </table>
    <input name="Ccuenta" value="" type="hidden">
    <input name="Ccuenta1" value="#Form.Ccuenta1#" type="hidden">
    <input name="Ccuenta2" value="#Form.Ccuenta2#" type="hidden">
    <input name="Cdescripcion1" value="#Form.Cdescripcion1#" type="hidden">
    <input name="Cdescripcion2" value="#Form.Cdescripcion2#" type="hidden">  
    <input name="Cformato1" value="#Form.Cformato1#" type="hidden">   
	<input name="Cformato2" value="#Form.Cformato2#" type="hidden">     
    <input name="Cmayor1" value="#Form.Cmayor1#" type="hidden">   
	<input name="Cmayor2" value="#Form.Cmayor2#" type="hidden">                 
    <input name="Periodo" value="#Form.Periodo#" type="hidden">
    <input name="PeriodoLista" value="" type="hidden">
    <input name="Mes" value="" type="hidden">
    <input name="Oficina" value="" type="hidden">
    <input name="Mcodigo" value="<cfif isdefined("form.Mcodigo")>#form.Mcodigo#</cfif>" type="hidden">
    <input name="McodigoOpt" value="<cfif isdefined("form.McodigoOpt")>#form.McodigoOpt#</cfif>" type="hidden">
    <input name="MesCierre" value="" type="hidden"> 
    <input name="Exportar" value="No" type="hidden">  
    <input name="Tabla" value="" type="hidden">
    
</cfoutput>
</Form>

<!---<cfdump var="#rsCuenta#">
<cfdump var="#rsMeses#">
<cfdump var="#rsOficinas#">
<cfdump var="#form#">--->
