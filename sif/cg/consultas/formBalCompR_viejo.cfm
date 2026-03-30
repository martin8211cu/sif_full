<cfinclude template="Funciones.cfm">
<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("url.Ocodigo")>
	<cfparam name="Form.Ocodigo" default="#url.Ocodigo#">
</cfif>
<cfif isdefined("url.periodo")>
	<cfparam name="Form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes")>
	<cfparam name="Form.mes" default="#url.mes#">
</cfif>
<cfif isdefined("url.nivel")>
	<cfparam name="Form.nivel" default="#url.nivel#">
</cfif>
<cfif isdefined("url.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#url.Mcodigo#">
</cfif>
<cfif isdefined("url.Ccuenta1")>
	<cfparam name="Form.Ccuenta1" default="#url.Ccuenta1#">
</cfif>
<cfif isdefined("url.Ccuenta2")>
	<cfparam name="Form.Ccuenta2" default="#url.Ccuenta2#">
</cfif>
<cfif isdefined("url.Cformato1")>
	<cfparam name="form.Cformato1" default="#url.Cformato1#">
</cfif>
<cfif isdefined("url.Cformato2")>
	<cfparam name="Form.Cformato2" default="#url.Cformato2#">
</cfif>

<cfquery name="rsProc" datasource="#Session.DSN#">
	set nocount on
	exec sp_SIF_CG0004 
 		@Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
		@periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.periodo#">,
		@mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mes#">,
		@nivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.nivel#">,
		<cfif isdefined("Form.Ocodigo") and Form.Ocodigo NEQ "-1">
			@Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
		</cfif>
		<cfif isdefined("Form.Cformato1") and Form.Cformato1 NEQ "">
			 @cuentaini = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cformato1#">,
		</cfif>
		<cfif isdefined("Form.Cformato2") and Form.Cformato2 NEQ "">
			 @cuentafin = <cfqueryparam cfsqltype="cf_sqlvar_char" value="#Form.Cformato2#">,
		</cfif>
		<cfif Form.Mcodigo NEQ "-1">
			@Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">,
		</cfif>
		<cfif isdefined('Form.chkCeros')>
			@ceros = 'S',
		</cfif>
		@usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
	set nocount off
</cfquery>

<cfquery name="rsTipo" dbtype="query">
	select distinct ntipo 
	from rsProc
	order by corte
</cfquery>
<cfquery name="rsOficina" datasource="#Session.DSN#">
	select Odescripcion
	from Oficinas 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	and Ocodigo = <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer"> 
</cfquery>

<cfquery name="rsSumasGlobales" datasource="#Session.DSN#">
	set nocount on
	
	declare @Mcodigo int, @Speriodo int, @Smes int, @Ecodigo int, @cuentaini varchar(100), @cuentafin varchar(100), @Ocodigo int
	declare @c1 char(4), @c2 char(4)	 
	
	select 	@Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">, 
			@Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.periodo#">, 
			@Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mes#">, 
			@Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			@Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
	
	<cfif isDefined("Form.Cformato1") and Len(Trim(Form.Cformato1)) gt 0 >
		select @cuentaini =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cformato1#">
		select @c1 = min(Cmayor)
		from CContables	
		where Ecodigo = @Ecodigo 
		  and Cformato >= @cuentaini		
	<cfelse>
		select @cuentaini =	null
		select @c1 = min(Cmayor) from CContables where Ecodigo = @Ecodigo		
	</cfif>
		
	<cfif isDefined("Form.Cformato2") and Len(Trim(Form.Cformato2)) gt 0 >
		select @cuentafin =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cformato2#">
		select @c2 = max(Cmayor)
		from CContables	
		where Ecodigo = @Ecodigo 
		  and Cformato <= @cuentafin
	<cfelse>
		select @cuentafin =	null
		select @c2 = max(Cmayor) from CContables where Ecodigo = @Ecodigo		
	</cfif>
	<cfif isDefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) gt 0 and Form.Mcodigo NEQ -1>
		select 'Total', sum(b.SOinicial) as saldoini, sum(b.DOdebitos) as debitos, sum(b.COcreditos) as creditos, 
		sum(b.DOdebitos) - sum(b.COcreditos) as movmes, sum(b.SOinicial) + sum(b.DOdebitos) - sum(b.COcreditos) as saldofin	 		
		from SaldosContables b, CContables a
		where b.Ecodigo = @Ecodigo
	    and b.Ocodigo = case when @Ocodigo = -1 then b.Ocodigo else @Ocodigo end
		and b.Speriodo = @Speriodo
		and b.Smes = @Smes
		and b.Mcodigo = @Mcodigo
		and a.Ccuenta = b.Ccuenta
		and a.Cmayor = a.Cformato
		and a.Cmayor between @c1 and @c2		
	<cfelse>
		select 'Total', sum(b.SLinicial) as saldoini, sum(b.DLdebitos) as debitos, sum(b.CLcreditos) as creditos, 
		sum(b.DLdebitos) - sum(b.CLcreditos) as movmes, sum(b.SLinicial) + sum(b.DLdebitos) - sum(b.CLcreditos) as saldofin		
		from SaldosContables b, CContables a
		where b.Ecodigo = @Ecodigo
	    and b.Ocodigo = case when @Ocodigo = -1 then b.Ocodigo else @Ocodigo end
		and b.Speriodo = @Speriodo
		and b.Smes = @Smes
		and a.Ccuenta = b.Ccuenta
		and a.Cmayor = a.Cformato
		and a.Cmayor between @c1 and @c2			
	</cfif>

	set nocount off		 
</cfquery>
<cfquery name="rsSumas" dbtype="query">
	select sum(saldoini) as totsaldoini, sum(debitos) as totdebitos, sum(creditos) as totcreditos, sum(movmes) as totmovmes, sum(saldofin)  as totsaldofin
	from rsSumasGlobales
</cfquery>

<!--- select sum(saldoini) as totsaldoini, sum(debitos) as totdebitos, sum(creditos) as totcreditos, sum(movmes) as totmovmes, sum(saldofin)  as totsaldofin
from rsSumasGlobalesPre
 --->

<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
<CF_sifHTML2Word Titulo="Balance de Comprobación">
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
}
</style>
<script language="JavaScript">
function ConsultaDet(cta,per,fmt,descrip) {

	document.form1.Periodos.value = per;
	document.form1.Ccuenta.value = cta;
	document.form1.Cformato.value = fmt;
	document.form1.Cdescripcion.value = descrip;
	document.form1.submit();
}
</script>
<form name="form1" method="post" action="saldosymov01.cfm">

  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    <tr> 
      <td colspan="12" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="12">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="12" align="center"><b>Balance de Comprobaci&oacute;n Resumido 
        en <cfoutput>#get_moneda(Form.Mcodigo).Mnombre#</cfoutput></b></td>
    </tr>
    <tr> 
      <td colspan="12" align="center"> <b>Oficina</b> <cfoutput>#rsOficina.Odescripcion#</cfoutput> </td>
    </tr>
    <tr> 
      <td colspan="12" align="center"> <b>Rango</b> <cfoutput>#rsProc.Rango#</cfoutput> </td>
    </tr>
    <tr> 
      <td colspan="4" width="50%" align="right" style="padding-right: 20px"> <b>Mes</b> 
        &nbsp;<cfoutput>#ListGetAt(meses, Form.mes, ',')#</cfoutput></td>
      <td colspan="8" width="50%" align="left" style="padding-left: 20px"> <b>Período</b> 
        &nbsp;<cfoutput>#Form.periodo#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="12" class="bottomline">&nbsp;</td>
    </tr>
    <cfoutput> 
      <tr> 
        <td colspan="12" nowrap class="bottomline"><div align="right"> 
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <caption>
              Totales Globales
</caption>
              <tr> 
                <td nowrap class="bottomline"> <div align="right">Saldo Inicial:</div></td>
                <td nowrap class="bottomline"> <div align="right"><strong><cfif isdefined("rsSumas") and rsSumas.RecordCount GT 0>#LSCurrencyFormat(rsSumas.totsaldoini,'none')#<cfelse>0.00</cfif></strong></div></td>
                <td nowrap class="bottomline"> <div align="right">D&eacute;bitos:</div></td>
                <td nowrap class="bottomline"> <div align="right"><strong><cfif isdefined("rsSumas") and rsSumas.RecordCount GT 0>#LSCurrencyFormat(rsSumas.totdebitos,'none')#<cfelse>0.00</cfif></strong></div></td>
                <td nowrap class="bottomline"> <div align="right">Cr&eacute;ditos:</div></td>
                <td nowrap class="bottomline"> <div align="right"><strong><cfif isdefined("rsSumas") and rsSumas.RecordCount GT 0>#LSCurrencyFormat(rsSumas.totcreditos,'none')#<cfelse>0.00</cfif></strong></div></td>
                <td nowrap class="bottomline"> <div align="right">Mov. Mes:</div></td>
                <td nowrap class="bottomline"> <div align="right"><strong><cfif isdefined("rsSumas") and rsSumas.RecordCount GT 0>#LSCurrencyFormat(rsSumas.totmovmes,'none')#<cfelse>0.00</cfif></strong></div></td>
                <td nowrap class="bottomline"> <div align="right">Saldo Final:</div></td>
                <td nowrap class="bottomline"> <div align="right"><strong><cfif isdefined("rsSumas") and rsSumas.RecordCount GT 0>#LSCurrencyFormat(rsSumas.totsaldofin,'none')#<cfelse>0.00</cfif></strong></div></td>
              </tr>
            </table>
          </div></td>
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="12" class="bottomline">&nbsp;</td>
    </tr>
    <cfloop query="rsTipo">
      <tr> 
        <td colspan="12" class="superSubTitulo"><cfoutput>#rsTipo.ntipo#</cfoutput></td>
      </tr>
      <cfquery name="rsCuentas" dbtype="query">
      select * from rsProc where ntipo = 
      <cfqueryparam value="#rsTipo.ntipo#" cfsqltype="cf_sql_varchar">
      order by formato 
      </cfquery>
      <tr> 
        <td class="encabReporte" align="center">Mayor</td>
        <td class="encabReporte">Descripci&oacute;n</td>
        <td class="encabReporte">Cuenta 
          Detalle</td>
        <td align="right" nowrap class="encabReporte">Saldo 
          Inicial </td>
        <td align="right" nowrap class="encabReporte">D&eacute;bitos</td>
        <td align="right" nowrap class="encabReporte">Cr&eacute;ditos</td>
        <td align="right" nowrap class="encabReporte">Movimientos</td>
        <td colspan="5" align="right" nowrap class="encabReporte">Saldo 
          Final</td>
      </tr>
      <cfset ctaMayor="">
      <cfloop query="rsCuentas">
        <cfif ctaMayor NEQ rsCuentas.mayor>
          <cfset ctaMayor=rsCuentas.mayor>
          <tr> 
            <td align="center"><cfoutput>#rsCuentas.mayor#</cfoutput></td>
            <td colspan="11">&nbsp;</td>
          </tr>
        </cfif>
        <tr> 
          <td align="center">&nbsp;</td>
          <td><cfoutput><a href="javascript:ConsultaDet(#rsCuentas.Ccuenta#,#Form.periodo#,'#rsCuentas.formato#','#rsCuentas.descrip#');">#rsCuentas.descrip#</a></cfoutput></td>
          <td nowrap><cfoutput><a href="javascript:ConsultaDet(#rsCuentas.Ccuenta#,#Form.periodo#,'#rsCuentas.formato#','#rsCuentas.descrip#');">#rsCuentas.formato#</a></cfoutput></td>
          <td align="right" nowrap><cfoutput><a href="javascript:ConsultaDet(#rsCuentas.Ccuenta#,#Form.periodo#,'#rsCuentas.formato#','#rsCuentas.descrip#');">#LSCurrencyFormat(rsCuentas.saldoini,'none')#</a></cfoutput></td>
          <td align="right" nowrap><cfoutput><a href="javascript:ConsultaDet(#rsCuentas.Ccuenta#,#Form.periodo#,'#rsCuentas.formato#','#rsCuentas.descrip#');">#LSCurrencyFormat(rsCuentas.debitos,'none')#</a></cfoutput></td>
          <td align="right" nowrap><cfoutput><a href="javascript:ConsultaDet(#rsCuentas.Ccuenta#,#Form.periodo#,'#rsCuentas.formato#','#rsCuentas.descrip#');">#LSCurrencyFormat(rsCuentas.creditos,'none')#</a></cfoutput></td>
          <td align="right" nowrap><cfoutput><a href="javascript:ConsultaDet(#rsCuentas.Ccuenta#,#Form.periodo#,'#rsCuentas.formato#','#rsCuentas.descrip#');">#LSCurrencyFormat(rsCuentas.movmes,'none')#</a></cfoutput></td>
          <td colspan="5" align="right" nowrap><cfoutput><a href="javascript:ConsultaDet(#rsCuentas.Ccuenta#,#Form.periodo#,'#rsCuentas.formato#','#rsCuentas.descrip#');">#LSCurrencyFormat(rsCuentas.saldofin,'none')#</a></cfoutput></td>
        </tr>
      </cfloop>
      <cfquery name="rsSumas" dbtype="query">
      select sum(debitos) as totdebitos, sum(creditos) as totcreditos, sum(movmes) 
      as totmovmes, sum(saldoini) as totsaldoini, sum(saldofin) as totsaldofin	
      from rsCuentas where mayor = formato 
      </cfquery>
      <tr> 
        <td colspan="12">&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="12" class="topline">&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="3"><b>Total <cfoutput>#rsTipo.ntipo#</cfoutput></b></td>
        <td align="right" nowrap><b><cfoutput>#LSCurrencyFormat(rsSumas.totsaldoini,'none')#</cfoutput></b></td>
        <td align="right" nowrap><b><cfoutput>#LSCurrencyFormat(rsSumas.totdebitos,'none')#</cfoutput></b></td>
        <td align="right" nowrap><b><cfoutput>#LSCurrencyFormat(rsSumas.totcreditos,'none')#</cfoutput></b></td>
        <td align="right" nowrap><b><cfoutput>#LSCurrencyFormat(rsSumas.totmovmes,'none')#</cfoutput></b></td>
        <td colspan="5" align="right" nowrap><b><cfoutput>#LSCurrencyFormat(rsSumas.totsaldofin,'none')#</cfoutput></b></td>
      </tr>
      <tr> 
        <td colspan="12" class="bottomline">&nbsp;</td>
      </tr>
    </cfloop>
    <tr> 
      <td colspan="12">
	  <input type="hidden" name="Periodos">
	  <input type="hidden" name="Ccuenta">
	  <input type="hidden" name="Cformato">
	  <input type="hidden" name="Cdescripcion">
	  </td>
    </tr>
    <tr> 
      <td colspan="12"><div align="center">------------------ Fin del Reporte ------------------</div></td>
    </tr>
  </table>
</form>
</CF_sifHTML2Word>
