
<!--- Creado por Gabriel Ernesto Sanchez Huerta  para  AppHost  02/09/2010 --->

<cfif isdefined('Form.periodo') and isdefined('Form.mes')>
    <cfset UltimoPeriodo = #Form.periodo#>
    <cfset UltimoMes = #Form.mes#> 
<cfelse>
    <cfquery name="rsParam1" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 30
    </cfquery>

    <cfquery name="rsParam2" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 40
    </cfquery>
    
    <cfset UltimoPeriodo = rsParam1.Pvalor>
    <cfset UltimoMes = rsParam2.Pvalor>    
</cfif> 

<cfquery name="rsMonedasPeriodoConversion" datasource="#Session.DSN#">
    select HT.*, M.Mnombre, M.Miso4217 
    from HtiposcambioConversion HT 
        inner join Monedas M on
            HT.Ecodigo = M.Ecodigo
        and	HT.Mcodigo = M.Mcodigo
    where HT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and HT.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#UltimoPeriodo#">
    and HT.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#UltimoMes#">
</cfquery>

<cfif #rsMonedasPeriodoConversion.recordcount# gt 0>   
	<cfset ExisteTipoC = 1>
<cfelse>
	<cfset ExisteTipoC = 0>       
</cfif>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
    select distinct Speriodo
    from CGPeriodosProcesados
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    order by Speriodo desc
</cfquery>

	<!--- Averiguar si existe la moneda de conversión en la tabla de Parametros --->
	<cfquery name="rsParamConversion" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 660
	</cfquery>
    
	<!--- Si la moneda de conversión sí existe en la tabla de parámetros, entonces capturar los tipos de cambio para el primer mes cerrado que no exista en HtiposcambioConversion --->
<!---		<cfquery name="rsMonedaConversion" datasource="#Session.DSN#">
			select Mcodigo, {fn concat ( {fn concat ( {fn concat ( Mnombre, ' (' )}, Miso4217)}, ') ')} as Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamConversion.Pvalor#">
		</cfquery> --->
        
        <cfquery name="rsMonedaConversion" datasource="#Session.DSN#">
			select Mcodigo, {fn concat ( {fn concat ( {fn concat ( Mnombre, ' (' )}, Miso4217)}, ') ')} as Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamConversion.Pvalor#">
		</cfquery>
        
<cfoutput>
		<form name="form1" method="post" action="ConsultaTcambio.cfm" style="margin: 0">
			<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td colspan="5">
					<input type="hidden" name="Speriodo" value="#UltimoPeriodo#">
					<input type="hidden" name="Smes" value="#UltimoMes#">
					<input type="hidden" name="Mcodigo" value="#rsMonedaConversion.Mcodigo#"> 
				</td>
			  </tr>
              <br /><br />
			  <tr>
				<td colspan="5" class="tituloAlterno">TIPOS DE CAMBIO DE CONVERSI&Oacute;N DE MONEDA</td>
			  </tr>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="5">
					<table border="0" cellspacing="0" cellpadding="2" align="center">
                    	<tr>
                            <td width="30%"> &nbsp; &nbsp; </td>
                            <td align="right"><strong>Per&iacute;odo:</strong></td>
                            <td>
                              <select name="periodo">
                                <cfloop query = "rsPeriodos">
                              <option value="#rsPeriodos.Speriodo#" <cfif #UltimoPeriodo# EQ "#rsPeriodos.Speriodo#">selected</cfif>>#rsPeriodos.Speriodo#							                          		</option>
                                </cfloop>
                              </select>
                            </td>
                                    
                            <td width="4%" align="right" ><strong>Mes:</strong></td>
                            <td width="20%">
                              <select name="mes" size="1">
                                <option value="1" <cfif #UltimoMes# EQ 1>selected</cfif>>Enero</option>
                                <option value="2" <cfif #UltimoMes# EQ 2>selected</cfif>>Febrero</option>
                                <option value="3" <cfif #UltimoMes# EQ 3>selected</cfif>>Marzo</option>
                                <option value="4" <cfif #UltimoMes# EQ 4>selected</cfif>>Abril</option>
                                <option value="5" <cfif #UltimoMes# EQ 5>selected</cfif>>Mayo</option>
                                <option value="6" <cfif #UltimoMes# EQ 6>selected</cfif>>Junio</option>
                                <option value="7" <cfif #UltimoMes# EQ 7>selected</cfif>>Julio</option>
                                <option value="8" <cfif #UltimoMes# EQ 8>selected</cfif>>Agosto</option>
                                <option value="9" <cfif #UltimoMes# EQ 9>selected</cfif>>Setiembre</option>
                                <option value="10" <cfif #UltimoMes# EQ 10>selected</cfif>>Octubre</option>
                                <option value="11" <cfif #UltimoMes# EQ 11>selected</cfif>>Noviembre</option>
                                <option value="12" <cfif #UltimoMes# EQ 12>selected</cfif>>Diciembre</option>
                              </select>
                            </td>                        
                                
                            <td colspan="1" align="left">
                                 <input type="submit" name="Submit" value="Buscar">
                            </td>
                            <td width="30%"> &nbsp; &nbsp; 
                            </td>
                      </tr>
					</table>
				</td>
			  </tr>
</cfoutput>	
    
<cfif ExisteTipoC eq 1>
	<cfoutput>
        <tr>
          <td colspan="5">&nbsp;</td>
        </tr>
        <tr bgcolor="##CCCCCC">
          <td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;"><strong>Moneda Origen</strong></td>
          <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;"><strong>Moneda Conversi&oacute;n</strong></td>
          <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;"><strong>Tipo de Cambio (Venta)</strong></td>
          <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;"><strong>Tipo de Cambio (compra)</strong></td>
          <td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;"><strong>Tipo de Cambio (promedio)</strong></td>

        </tr>
        <tr><td>&nbsp;  </td></tr>
        <cfloop query="rsMonedasPeriodoConversion">
            <tr>
              <td align="center">
                  #rsMonedasPeriodoConversion.Mnombre# & #rsMonedasPeriodoConversion.Miso4217#
              </td>
              <td align="center">
                  #rsMonedaConversion.Mnombre# 
              </td>
              <td align="center">
                  <cfif #rsMonedasPeriodoConversion.Mcodigo# EQ #rsMonedaConversion.Mcodigo#>1.00000<cfelse>#rsMonedasPeriodoConversion.TCventa#</cfif>
              </td>
              <td align="center">
                  <cfif #rsMonedasPeriodoConversion.Mcodigo# EQ #rsMonedaConversion.Mcodigo#>1.00000<cfelse>#rsMonedasPeriodoConversion.TCcompra#</cfif>
              </td>
              <td align="center">
                  <cfif #rsMonedasPeriodoConversion.Mcodigo# EQ #rsMonedaConversion.Mcodigo#>1.00000<cfelse>#rsMonedasPeriodoConversion.TCpromedio#</cfif>
              </td>
            </tr>
        </cfloop>
 	</cfoutput>
 </cfif>             
  </table>
</form>
