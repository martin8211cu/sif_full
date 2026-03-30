<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 25-2-2006.
		Motivo: Se usa el componente de listas, por que la navegación que tenía no funcionaba y la lista estaba pintada 
		a pie.
	Modificado por: Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se agrega el botón de regresar.
	
 --->
<cfif isdefined("url.Periodo")>
	<cfparam name="Form.Periodo" default="#url.Periodo#">
	<cfparam name="Form.PeriodoLista" default="#url.PeriodoLista#">
	<cfparam name="Form.Ccuenta" default="#url.Ccuenta#"> 
    <cfparam name="Form.Ccuenta1" default="#url.Ccuenta1#"> 
    <cfparam name="Form.Ccuenta2" default="#url.Ccuenta2#"> 
	<cfparam name="Form.Oficina" default="#url.Oficina#">
	<cfparam name="Form.Mes" default="#url.Mes#">
	<cfparam name="Form.MesCierre" default="#url.MesCierre#">
    <cfparam name="Form.Tabla" default="#url.Tabla#">
    
    <cfparam name="Form.Cdescripcion1" default="#url.Cdescripcion1#"> 
    <cfparam name="Form.Cdescripcion2" default="#url.Cdescripcion2#"> 
	<cfparam name="Form.Cformato1" default="#url.Cformato1#">
	<cfparam name="Form.Cformato2" default="#url.Cformato2#">
	<cfparam name="Form.Cmayor1" default="#url.Cmayor1#">
    <cfparam name="Form.Cmayor2" default="#url.Cmayor2#"> 
	<cfparam name="Form.Mcodigo" default="#url.Mcodigo#">
    <cfparam name="Form.McodigoOpt" default="#url.McodigoOpt#">         
</cfif>

<cfif #Form.Tabla# EQ 'HDContables' OR #Form.Tabla# EQ 'HDContables1'>
	<cfset Tabla = 'HDContables'>
<cfelse>
	<cfset Tabla = 'DContables'>
</cfif>    

<cfquery name="rsCuenta" datasource="#Session.DSN#">
	select Cformato, Cdescripcion ,Cmovimiento
	from CContables 
	where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Odescripcion 
	from Oficinas 
	where Ecodigo = #Session.Ecodigo#
	  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Oficina#">
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select '-1' as value, '-- Todos --' as description, 0 as ord from dual
	union
	select Mnombre as value, Mnombre as description, 1 as ord
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	order by ord
</cfquery>

<cfset varMonedas = "">

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

<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
	select -1 as value, '-- Todos --' as description, 0 as ord from dual
	union
	select CFid as value, CFdescripcion as description, 1 as ord
	from CFuncional
	where Ecodigo = #Session.Ecodigo#
	order by ord, description
</cfquery>

<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cfset LvarPeriodoConsulta = form.PeriodoLista>
<cfset LvarMesConsulta = Form.Mes>

<cfif form.MesCierre And (#Tabla# EQ 'HDContables' OR #Tabla# EQ  'HDContables1')>
	<cfset LvarPeriodoConsulta = LvarPeriodoConsulta>
	<cfset LvarMesConsulta = LvarMesConsulta - 1>
	<cfif LvarMesConsulta LT 1>
		<cfset LvarPeriodoConsulta = LvarPeriodoConsulta - 1>
		<cfset LvarMesConsulta = 12>
	</cfif>
	
	<cfquery name="rsSalMon" datasource="#Session.DSN#">
		  select 
			b.Mcodigo, 
			b.Mnombre, 

			a.SOinicial + a.DOdebitos - a.COcreditos as SOfinal, 
			a.SLinicial + a.DLdebitos - a.CLcreditos as SLfinal, 
			a.SLinicial + a.DLdebitos - a.CLcreditos as SLinicial, 
			a.SOinicial + a.DOdebitos - a.COcreditos as SOinicial, 

			coalesce((
				select sum(det.Dlocal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'D'
				  ), 0.00) as DLdebitos,

			coalesce((
				select sum(det.Dlocal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'C'
				  ), 0.00) as CLcreditos,

			coalesce((
				select sum(det.Doriginal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'D'
				  ), 0.00) as DOdebitos,

			coalesce((
				select sum(det.Doriginal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'C'
				  ), 0.00) as COcreditos
				  
			from SaldosContables a
				inner join Monedas b
				on b.Mcodigo = a.Mcodigo
			where a.Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			  and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPeriodoConsulta#">
			  and a.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesConsulta#">
			  and a.Ecodigo  = #SESSION.Ecodigo#
			  and a.Ocodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Oficina#">
			<cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                And a.Mcodigo = #varMonedas#
            </cfif>                 
			order by b.Mnombre
	</cfquery>
	<cfloop query="rsSalMon">
		<cfset querysetcell(rsSalMon, "SOfinal", rsSalMon.SOinicial + rsSalMon.DOdebitos - rsSalMon.COcreditos, rsSalMon.currentrow)>
		<cfset querysetcell(rsSalMon, "SLfinal", rsSalMon.SLinicial + rsSalMon.DLdebitos - rsSalMon.CLcreditos, rsSalMon.currentrow)>
	</cfloop>
<cfelseif #Tabla# EQ 'DContables'>
	<cfquery name="rsSalMon" datasource="#Session.DSN#">
        Select
            MO.Mnombre,
            DC.Emes, 
            DC.Ccuenta,
            DC.Eperiodo,
            Sum(Case 
                When DC.Dmovimiento = 'D' 
                    then DC.Dlocal 
                    Else 0
                End
                )
            As DLdebitos, <!--- Debitos Locales --->
            Sum(Case 
                When DC.Dmovimiento = 'C' 
                    then DC.Dlocal 
                    Else 0
                End
                )
            As CLcreditos, <!--- Creditos Locales --->
            Sum(DC.Dlocal * Case When DC.Dmovimiento = 'C' then -1 Else 1 End) As MLocal, <!--- Movimiento del Mes --->
            Sum(Case 
                When DC.Dmovimiento = 'D' 
                    then DC.Doriginal 
                    Else 0
                End
                )
            As DOdebitos, <!--- Debitos Originales --->
            Sum(Case 
                When DC.Dmovimiento = 'C' 
                    then DC.Doriginal 
                    Else 0
                End
                )
            As COcreditos, <!--- Creditos Originales --->
            Sum(DC.Doriginal  * Case When DC.Dmovimiento = 'C' then -1 Else 1 End) As MOriginal <!--- Movimiento del Mes --->
        From 
            DContables DC
            Inner Join Monedas MO On
                MO.Ecodigo = #session.Ecodigo# And
                MO.Mcodigo = DC.Mcodigo
        Where 
            DC.Ecodigo = #session.Ecodigo# And
            DC.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"> And
            DC.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPeriodoConsulta#"> And
            DC.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesConsulta#"> And
            DC.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Oficina#">
			<cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                And DC.Mcodigo = #varMonedas#
            </cfif>             
        Group By
            DC.Ccuenta,DC.Eperiodo,DC.Emes,MO.Mnombre
        Order by 
            MO.Mnombre 
	</cfquery>      
<cfelse>
	<cfquery name="rsSalMon" datasource="#Session.DSN#">
		  select 
			b.Mcodigo, 
			b.Mnombre, 
			a.SLinicial, 
			a.DLdebitos, 
			a.CLcreditos, 
			a.SOinicial, 
			a.SLinicial + a.DLdebitos - a.CLcreditos as SLfinal, 
			a.SOinicial + a.DOdebitos - a.COcreditos as SOfinal, 
			a.DOdebitos, 
			a.COcreditos 
			from SaldosContables a
				inner join Monedas b
				on b.Mcodigo = a.Mcodigo
			where a.Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			  and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPeriodoConsulta#">
			  and a.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesConsulta#">
			  and a.Ecodigo    = #SESSION.Ecodigo#
			  and a.Ocodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Oficina#">
			<cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
                And a.Mcodigo = #varMonedas#
            </cfif>              
			order by b.Mnombre 
	</cfquery>
</cfif>

<cfif #Tabla# NEQ 'DContables'>
    <cfquery name="rsTot" dbtype="query">
        select sum(SLfinal) as SaldoF, sum(DLdebitos) as Debitos, sum(CLcreditos) as Creditos, sum(SLinicial)  as SaldoI
        from rsSalMon
    </cfquery>
<cfelse>
    <cfquery name="rsTot" dbtype="query">
        select sum(DLdebitos) as Debitos, sum(CLcreditos) as Creditos
        from rsSalMon
    </cfquery>	
</cfif>

<cfquery name="Empresas" datasource="#Session.DSN#">
	select Ecodigo, Edescripcion from Empresas where Ecodigo = #SEssion.Ecodigo#
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>

<cfflush interval="32">
<form name="form1" method="post"  action="SaldosMovimientosB1.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<!--- ******************************************************************************* --->
		<tr class="area"> 
			<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
		</tr>
		<!--- ******************************************************************************* --->
		<tr class="area"> 
			<td align="center" colspan="8" nowrap><strong>Saldos y Movimientos</strong></td>
		</tr>
		<tr class="area"> 
			<td align="center" colspan="8" nowrap>
				<cfif  #Tabla# EQ 'HDContables'>
                    <strong>Asientos Aplicados</strong>
                <cfelse>
                    <strong>Asientos en Tr&aacute;nsito</strong>
                </cfif>
            </td>
		</tr>        
		<!--- ******************************************************************************* --->
		<tr> 
			<td nowrap><strong>Cuenta:</strong></td>
			<td colspan="5" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#rsCuenta.Cdescripcion#-#rsCuenta.Cformato#</cfoutput> <cfif rsCuenta.Cmovimiento eq 'N'>(Este nivel no acepta mov.)</cfif>
			</td>
			<td colspan="2" align="right"><strong>Fecha: <font color="#006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
		</tr>
		<!--- ******************************************************************************* --->
		<tr> 
			<td nowrap><strong>Per&iacute;odo:</strong></td>
			<td colspan="5" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#LvarPeriodoConsulta#</cfoutput>
			</td>		
			<td colspan="2" align="right" class="noprint">
				<cfif not isdefined("url.impr")>
					<input name="btnRegresar" type="button" value="Regresar" onclick="FuncRegresar();">
				</cfif>
			</td>

		</tr>
		<!--- ******************************************************************************* --->
		<tr>
			<td nowrap><strong>Mes:</strong></td>
			<cfif form.MesCierre>
			<td colspan="7" nowrap>
					&nbsp;&nbsp;&nbsp;Cierre
			</td>	
			<cfelse>
			<td colspan="7" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#ListGetAt(meses, Form.Mes, ',')#</cfoutput>
			</td>	
			</cfif>
		</tr>
		<!--- ******************************************************************************* --->
		<tr>
			<td nowrap><strong>Oficina:</strong></td>
			<td colspan="7" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#rsOficinas.Odescripcion#</cfoutput>
			</td>	
		</tr>
		<tr><td colspan="8">&nbsp;</td></tr>
        <cfif #Tabla# NEQ 'DContables'>
            <tr> 
                <td colspan="3">&nbsp;</td>
                <td nowrap align="right"><strong>Saldo Inicial</strong></td>
                <td nowrap align="right"><strong>D&eacute;bitos</strong></td>
                <td nowrap align="right"><strong>Cr&eacute;ditos</strong></td>
                <td nowrap align="right"><strong>Saldo Final</strong></td>
                <td nowrap align="right"><strong>&nbsp;</strong></td>
            </tr>
        <cfelse>
            <tr> 
                <td colspan="3">&nbsp;</td>
                <td nowrap align="right"><strong>D&eacute;bitos</strong></td>
                <td nowrap align="right"><strong>Cr&eacute;ditos</strong></td>
                <td nowrap align="right"><strong>&nbsp;</strong></td>
            </tr>        	
        </cfif>
		<cfif #Tabla# NEQ 'DContables'>        	
		<tr> 
			<cfoutput>
			<td colspan="3" ><strong>Local</strong></font></td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.SaldoI,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.Debitos,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.Creditos,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.SaldoF,'none')#</td>
			<td nowrap align="right">&nbsp;</td>
            </cfoutput>
		</tr>
        <cfelse>
		<tr> 
			<cfoutput>
			<td colspan="3" ><strong>Local</strong></font></td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.Debitos,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.Creditos,'none')#</td>
			<td nowrap align="right">&nbsp;</td>
            </cfoutput>
		</tr>       	
        </cfif>
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr> 
			<td colspan="8" align="center" nowrap bgcolor="lightgrey" ><font size="3"><strong>Resumen por Moneda</strong></font></td>
		</tr>
		<!--- ******************************************************************************* --->	
        <cfif #Tabla# NEQ 'DContables'> 	
		<tr> 
			<td colspan="3" ><strong>Moneda</strong></td>
			<td nowrap align="right"><strong>Saldo Inicial</strong></td>
			<td nowrap align="right"><strong>D&eacute;bitos</strong></td>
			<td nowrap align="right"><strong>Cr&eacute;ditos</strong></td>
			<td nowrap align="right"><strong>Saldo Final</strong></td>
			<td nowrap align="right"><strong>Local</strong></td>
		</tr>
        <cfelse>
		<tr> 
			<td colspan="3" ><strong>Moneda</strong></td>
			<td nowrap align="right"><strong>D&eacute;bitos</strong></td>
			<td nowrap align="right"><strong>Cr&eacute;ditos</strong></td>
			<td nowrap align="right"><strong>Local</strong></td>
		</tr>        	
        </cfif>
		<!--- ******************************************************************************* --->		
		<cfloop query="rsSalMon"> 
			<tr <cfif rsSalmon.CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
				<cfoutput>
                <td colspan="3" >#rsSalmon.Mnombre#</td>
                <cfif #Tabla# NEQ 'DContables'> 				
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.SOinicial,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.DOdebitos,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.COcreditos,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.SOfinal,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.SLfinal,'none')#</td>
                <cfelse>
                    <td nowrap align="right">#LSCurrencyFormat(rsSalmon.DOdebitos,'none')#</td>
                    <td nowrap align="right">#LSCurrencyFormat(rsSalmon.COcreditos,'none')#</td> 
                    <td nowrap align="right">#LSCurrencyFormat(rsSalmon.MLocal,'none')#</td>               	
                </cfif>
				</cfoutput>
			</tr>
		</cfloop>
        <cfif #Tabla# NEQ 'DContables'> 		 
            <cfquery name="TotLocal" dbtype="query">
                select sum(SLfinal) as TotalLocal from rsSalMon 
            </cfquery>
        <cfelse>
            <cfquery name="TotLocal" dbtype="query">
                select sum(MLocal) as TotalLocal from rsSalMon 
            </cfquery>        	
        </cfif>
		<!--- ******************************************************************************* --->		
		<tr> 
			<td colspan=<cfif #Tabla# NEQ 'DContables'>"6"<cfelse>"4"</cfif> <cfif rsSalmon.CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>&nbsp;</td>
			<td nowrap align="right"><strong>Total:</strong></td>
			<td nowrap align="right"><strong><cfoutput>#LSCurrencyFormat(TotLocal.TotalLocal,'none')#</cfoutput></strong></td>
		</tr>
		<!--- ******************************************************************************* --->		

	</table>
	
	<cfif isdefined("url.filtro_cconcepto")>
		<cfset form.filtro_cconcepto = url.filtro_cconcepto>
	</cfif>
	<cfif isdefined("url.filtro_ddescripcion")>
		<cfset form.filtro_ddescripcion = url.filtro_ddescripcion>
	</cfif>
	<cfif isdefined("url.filtro_ddocumento")>
		<cfset form.filtro_ddocumento = url.filtro_ddocumento>
	</cfif>
	<cfif isdefined("url.filtro_edocumento")>
		<cfset form.filtro_edocumento = url.filtro_edocumento>
	</cfif>
	<cfif isdefined("url.filtro_mnombre")>
		<cfset form.filtro_mnombre = url.filtro_mnombre>
	</cfif>	
	<cfif isdefined("url.filtro_CentroFuncional")>
		<cfset form.filtro_CentroFuncional = url.filtro_CentroFuncional>
	</cfif>
	
	
	<cfset navegacion = ''>
	<cfif isdefined("form.id")>
		<cfset navegacion = navegacion & "&id=#form.id#">
	</cfif>
	<cfif isdefined("form.Ccuenta")>
		<cfset navegacion = navegacion & "&Ccuenta=#form.Ccuenta#">
	</cfif>
	<cfif isdefined("form.Ccuenta1")>
		<cfset navegacion = navegacion & "&Ccuenta1=#form.Ccuenta1#">
	</cfif>
	<cfif isdefined("form.Ccuenta2")>
		<cfset navegacion = navegacion & "&Ccuenta2=#form.Ccuenta2#">
	</cfif>        
	<cfif isdefined("form.mes")>
		<cfset navegacion =  navegacion &"&mes=#form.mes#">
	</cfif>
	<cfif isdefined("form.oficina")>
		<cfset navegacion = navegacion & "&oficina=#form.oficina#">
	</cfif>
	<cfif isdefined("form.periodo")>
		<cfset navegacion = navegacion & "&periodo=#form.periodo#">
	</cfif>
	<cfif isdefined("form.periodoLista")>
		<cfset navegacion = navegacion & "&periodoLista=#form.periodoLista#">
	</cfif>
	<cfif isdefined("form.MesCierre")>
		<cfset navegacion = navegacion & "&MesCierre=#form.MesCierre#">
	</cfif>
	<cfif isdefined("form.Cdescripcion1")>
		<cfset navegacion = navegacion & "&Cdescripcion1=#form.Cdescripcion1#">
	</cfif>
	<cfif isdefined("form.Cdescripcion2")>
		<cfset navegacion = navegacion & "&Cdescripcion2=#form.Cdescripcion2#">
	</cfif> 
	<cfif isdefined("form.Cformato1")>
		<cfset navegacion = navegacion & "&Cformato1=#form.Cformato1#">
	</cfif>
	<cfif isdefined("form.Cformato2")>
		<cfset navegacion = navegacion & "&Cformato2=#form.Cformato2#">
	</cfif>     
	<cfif isdefined("form.Cmayor1")>
		<cfset navegacion = navegacion & "&Cmayor1=#form.Cmayor1#">
	</cfif>             
	<cfif isdefined("form.Cmayor2")>
		<cfset navegacion = navegacion & "&Cmayor2=#form.Cmayor2#">
	</cfif> 
	<cfif isdefined("form.Mcodigo")>
		<cfset navegacion = navegacion & "&Mcodigo=#form.Mcodigo#">
	</cfif> 
	<cfif isdefined("form.McodigoOpt")>
		<cfset navegacion = navegacion & "&McodigoOpt=#form.McodigoOpt#">
	</cfif>                          
	<cfif isdefined("form.Tabla")>
		<cfset navegacion = navegacion & "&Tabla=#form.Tabla#">
	</cfif>    
	
	<!--- Para sostener los filtroa en la navegación --->
	<cfif isdefined("form.filtro_cconcepto")>
		<cfset navegacion = navegacion & "&filtro_cconcepto=#form.filtro_cconcepto#">
	</cfif>
	<cfif isdefined("form.filtro_ddescripcion")>
		<cfset navegacion = navegacion & "&filtro_ddescripcion=#form.filtro_ddescripcion#">
	</cfif>
	<cfif isdefined("form.filtro_ddocumento")>
		<cfset navegacion = navegacion & "&filtro_ddocumento=#form.filtro_ddocumento#">
	</cfif>
	<cfif isdefined("form.filtro_edocumento")>
		<cfset navegacion = navegacion & "&filtro_edocumento=#form.filtro_edocumento#">
	</cfif>
	<cfif isdefined("form.filtro_mnombre")>
		<cfset navegacion = navegacion & "&filtro_mnombre=#form.filtro_mnombre#">
	</cfif>
	<cfif isdefined("form.filtro_CentroFuncional")>
		<cfset navegacion = navegacion & "&filtro_CentroFuncional=#form.filtro_CentroFuncional#">
	</cfif>	
	
	
	<cfset Filtro =          " a.Ecodigo = #session.Ecodigo#">
	<cfset Filtro = Filtro & " and Ccuenta = #Form.Ccuenta#">
	<cfset Filtro = Filtro & " and a.Ocodigo =  #Form.Oficina#">
	<cfset Filtro = Filtro & " and a.Eperiodo = #LvarPeriodoConsulta#">
	<cfset Filtro = Filtro & " and a.Emes = #LvarMesConsulta#">
	<cfif isdefined('Form.Mcodigo') and len(Form.Mcodigo) and isdefined("Form.McodigoOpt") and Form.McodigoOpt GTE 0>
		<cfset Filtro = Filtro & " and a.Mcodigo = #varMonedas#">
    </cfif>    
	<cfif form.MesCierre>
    	<cfif  #Tabla# NEQ 'DContables'>
      		<cfset Filtro = Filtro & " and e.ECtipo = 1">
      	</cfif>
	<cfelse>
	    <cfif  #Tabla# NEQ 'DContables'>
			<cfset Filtro = Filtro & " and e.ECtipo <> 1">
      	</cfif>
	</cfif>
	

	<cfif isdefined("form.filtro_cconcepto") and form.filtro_cconcepto neq "">
		<cfset Filtro = Filtro & " and upper(rtrim(convert(char,a.Cconcepto))) like '#form.filtro_cconcepto#'">
	</cfif>
	<cfif isdefined("form.filtro_ddescripcion") and form.filtro_ddescripcion neq "">
		<cfset Filtro = Filtro & " and upper(a.Ddescripcion) like '%" & #UCase(form.filtro_ddescripcion)# & "%'">
	</cfif>
	<cfif isdefined("form.filtro_ddocumento") and form.filtro_ddocumento neq "">
		<cfset Filtro = Filtro & " and upper(a.Ddocumento) like '%" & #UCase(form.filtro_ddocumento)# & "%'">
	</cfif>
	<cfif isdefined("form.filtro_edocumento") and form.filtro_edocumento neq "">
		<cfset Filtro = Filtro & " and upper(rtrim(convert(char,a.Edocumento))) like '#form.filtro_edocumento#'">
	</cfif>
	<cfif isdefined("form.filtro_mnombre") and form.filtro_mnombre neq "-1">
		<cfset Filtro = Filtro & " and rtrim(m.Mnombre) = '#form.filtro_mnombre#'">
	</cfif>
	<cfif isdefined("form.filtro_CentroFuncional") and form.filtro_CentroFuncional neq "-1">
		<cfset Filtro = Filtro & " and cf.CFid = #form.filtro_CentroFuncional#">
	</cfif>
	
	
	<cfset Filtro = Filtro & "	group by">
	<cfset Filtro = Filtro & "	a.IDcontable, a.Ccuenta, a.Edocumento, a.Cconcepto, a.Ddocumento, a.Ddescripcion,cf.CFid,cf.CFcodigo, cf.CFdescripcion, m.Mnombre, a.Eperiodo, a.Emes">
	<cfset Filtro = Filtro & "	order by">
	<cfset Filtro = Filtro & "	a.Edocumento, a.Cconcepto">
	
	<cfif not isdefined("url.impr")>
		<cfset Lvarmostrar_filtro = true>
		<cfset Lvarmaxrows = 25>
		<cfset LvarshowLink = true>
		<cfset LvarPoliza = 'Poliza'>
	<cfelse>
		<cfset Lvarmostrar_filtro = false>
		<cfset Lvarmaxrows = 0>
		<cfset LvarshowLink = false>
		<cfset LvarPoliza = ''>
	</cfif>
	<cfflush interval="1024">

	<cfif isdefined("url.filtro_cconcepto")>
		<cfset form.filtro_cconcepto = url.filtro_cconcepto>
	</cfif>
	<cfif isdefined("url.filtro_ddescripcion")>
		<cfset form.filtro_ddescripcion = url.filtro_ddescripcion>
	</cfif>
	<cfif isdefined("url.filtro_ddocumento")>
		<cfset form.filtro_ddocumento = url.filtro_ddocumento>
	</cfif>
	<cfif isdefined("url.filtro_edocumento")>
		<cfset form.filtro_edocumento = url.filtro_edocumento>
	</cfif>
	<cfif isdefined("url.filtro_mnombre")>
		<cfset form.filtro_mnombre = url.filtro_mnombre>
	</cfif>
	<cfif isdefined("url.filtro_CentroFuncional")>
		<cfset form.filtro_CentroFuncional = url.filtro_CentroFuncional>
	</cfif>
    
	<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">
	<cfquery name="rsQrySaldMov" datasource="#Session.DSN#">
		Select 	a.IDcontable as id, 
				a.Ccuenta as Cuenta, 
				a.Edocumento, 
				a.Cconcepto, 
				a.Ddocumento, 
				a.Ddescripcion, 
				m.Mnombre, 
				sum(case when a.Dmovimiento='D' then a.Dlocal else 0.00 end) as Debitos, 
				sum(case when a.Dmovimiento='C' then a.Dlocal else 0.00 end) as Creditos, 
				a.Eperiodo, 
				a.Emes, 
				' ' as truco,
				case when cf.CFid is not null then
					rtrim(cf.CFcodigo) #_CAT# '-' #_CAT# rtrim(cf.CFdescripcion)
				else
					''
				end
				as CentroFuncional
		from #Tabla# a 
				inner join Monedas m 
					on m.Mcodigo = a.Mcodigo
                 <cfif  #Tabla# EQ 'HDContables'>
				inner join HEContables e 
					on e.IDcontable = a.IDcontable
                </cfif>
				left outer join CFuncional  cf
						on cf.CFid = a.CFid
		where #preservesinglequotes(Filtro)#
	</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
		<cfinvokeargument name="query" value="#rsQrySaldMov#"/>
		<cfinvokeargument name="desplegar" value="Edocumento, Cconcepto, Ddocumento, Ddescripcion, Mnombre, CentroFuncional, Debitos, Creditos, truco"/>
		<cfinvokeargument name="etiquetas" value="Póliza, Lote, Documento, Descripción, Moneda, Centro Funcional, Débitos, Créditos, &nbsp;"/>
		<cfinvokeargument name="formatos" value="S, S, S, S, S, S, UM, UM, U"/>
		<cfinvokeargument name="align" value="left, left, left, left, left, left, right, right, left"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="keys" value="id"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="MaxRows" value="#Lvarmaxrows#"/>
		<cfinvokeargument name="maxrowsquery" value="3000"/>
		<cfinvokeargument name="incluyeForm" value="false"/>
		<cfinvokeargument name="formName" value="form1"/>
		<cfinvokeargument name="mostrar_filtro" value="#Lvarmostrar_filtro#"/>
		<cfinvokeargument name="rsMnombre" value="#rsMonedas#"/>
		<cfinvokeargument name="rsCentroFuncional" value="#rsCentroFuncional#"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="funcion" value="#LvarPoliza#"/>
		<cfinvokeargument name="fparams" value="id,Eperiodo,Emes,Cuenta"/>
		<cfinvokeargument name="debug" value="N"/>
	</cfinvoke>	
	<cfoutput>
        <input type="hidden" name="Periodo" value="#Form.Periodo#">
        <input type="hidden" name="PeriodoLista" value="#Form.PeriodoLista#">
        <input type="hidden" name="MesCierre" value="#Form.MesCierre#">
        <input type="hidden" name="Oficina" value="#Form.Oficina#">
        <input type="hidden" name="Mes" value="#Form.Mes#">
        <input type="hidden" name="Ccuenta" value="#Form.Ccuenta#">
        <input type="hidden" name="Ccuenta1" value="#Form.Ccuenta1#">
        <input type="hidden" name="Ccuenta2" value="#Form.Ccuenta2#">
        <input name="Cdescripcion1" value="#Form.Cdescripcion1#" type="hidden">
        <input name="Cdescripcion2" value="#Form.Cdescripcion2#" type="hidden">  
        <input name="Cformato1" value="#Form.Cformato1#" type="hidden">   
        <input name="Cformato2" value="#Form.Cformato2#" type="hidden">     
        <input name="Cmayor1" value="#Form.Cmayor1#" type="hidden">   
        <input name="Cmayor2" value="#Form.Cmayor2#" type="hidden">           
      	<input type="hidden" name="Tabla" value="#Form.Tabla#">
        <input type="hidden" name="Direccion" value="">
        <input type="hidden" name="IDcontable" value="">
        <input name="Mcodigo" value="<cfif isdefined("form.Mcodigo")>#form.Mcodigo#</cfif>" type="hidden">
        <input name="McodigoOpt" value="<cfif isdefined("form.McodigoOpt")>#form.McodigoOpt#</cfif>" type="hidden">
	</cfoutput>
</form>

<script language="javascript" type="text/javascript">
	function Poliza(xidcontable, periodo, mes, cuenta){
		<cfoutput>
			document.form1.IDcontable.value=xidcontable;
			document.form1.Mes.value=mes;
			document.form1.Ccuenta.value=cuenta;
			document.form1.action = "SQLPolizaConta.cfm?Saldoymov='s'&Periodo=#Form.Periodo#&PeriodoLista=#Form.PeriodoLista#&Oficina=#Form.Oficina#&Mes=#Form.Mes#&Cuenta=#Form.Ccuenta#&Tabla=#Form.Tabla#";
			document.form1.submit();
		</cfoutput>
	}
	function buscar(){
		document.form1.Direccion.value = '';
		document.form1.Pagina.value =  '1';
		document.form1.submit();
	}		
	function FuncRegresar(){
		<cfif #Form.Tabla# EQ 'HDContables1'>
			<cfoutput>
				document.form1.Oficina.value = ' ';
				document.form1.Mes.value =' ';
				document.form1.action = 'saldosymov01.cfm?Ccuenta=#form.Ccuenta#&Periodos=#form.periodo#';
				document.form1.submit();
			</cfoutput>
		<cfelse>
			<cfoutput>
				document.form1.Oficina.value = ' ';
				document.form1.Mes.value =' ';
				document.form1.action = 'SaldosMovimientosA.cfm';
				document.form1.submit();
			</cfoutput>			
		</cfif>
	}
	function nextREG(){
		document.form1.Direccion.value = 'next';
		var pagina = new Number(document.form1.Pagina.value) + 1;
		document.form1.Pagina.value =  pagina;
		document.form1.submit();
	}
	function backREG(){
		history.back();
		<!---
		document.form1.Direccion.value = 'back';
		var pagina = new Number(document.form1.Pagina.value) - 1;
		document.form1.Pagina.value =  pagina ;
		document.form1.submit();--->
	}	
</script>	
